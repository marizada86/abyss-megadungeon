$ErrorActionPreference='Stop'
$root=$PSScriptRoot
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
public static class PreparedAudit {
 public static long[] Scan(string path,int cellWidth) {
  using(var b=new Bitmap(path)){
   var data=b.LockBits(new Rectangle(0,0,b.Width,b.Height),ImageLockMode.ReadOnly,PixelFormat.Format32bppArgb);
   int stride=Math.Abs(data.Stride);var bytes=new byte[stride*b.Height];Marshal.Copy(data.Scan0,bytes,0,bytes.Length);b.UnlockBits(data);
   long solid=0,clear=0,magenta=0,frameEdge=0;int minX=b.Width,minY=b.Height,maxX=-1,maxY=-1;
   for(int y=0;y<b.Height;y++)for(int x=0;x<b.Width;x++){int i=y*stride+x*4;int a=bytes[i+3];
    if(a==0)clear++;
    if(a>=32){solid++;minX=Math.Min(minX,x);maxX=Math.Max(maxX,x);minY=Math.Min(minY,y);maxY=Math.Max(maxY,y);
     if(bytes[i+2]>180&&bytes[i]>180&&bytes[i+1]<80)magenta++;
     if(cellWidth>0&&(x%cellWidth==0||x%cellWidth==cellWidth-1||y==0||y==b.Height-1))frameEdge++;
    }
   }
   return new long[]{b.Width,b.Height,solid,clear,magenta,frameEdge,minX,minY,maxX,maxY};
  }
 }
}
'@
$jobs=@()
foreach($f in @('ui-jobs.json','n-jobs.json')){$loaded=Get-Content (Join-Path $root $f) -Raw -Encoding UTF8|ConvertFrom-Json; foreach($entry in $loaded){$jobs+=$entry}}
$expected=@()
foreach($j in $jobs){
 if($j.mode -eq 'sprite'){
  foreach($s in $j.states.PSObject.Properties){$expected+=@{file=($j.out_anim+'/'+$s.Name+'.png');size=@(([int]$j.cell[0]*[int]$s.Value),([int]$j.cell[1]));cell=[int]$j.cell[0];id=$j.id;source=@($j.poses.PSObject.Properties.Value);key='gray';kind='procedural_transition_sheet'}}
  $expected+=@{file=$j.out_static;size=$j.static_size;cell=0;id=$j.id;source=@($j.poses.idle);key='gray';kind='static_sprite'}
 }elseif($j.split -eq 'grid'){
  foreach($n in $j.names){$expected+=@{file=($j.out_dir+'/'+$n+'.png');size=$j.fit;cell=0;id=$j.id;source=@($j.src);key=$j.key;kind='split_icon'}}
 }else{
  $sz=if($j.size){$j.size}else{$j.fit}
  $expected+=@{file=$j.out;size=$sz;cell=0;id=$j.id;source=@($j.src);key=$j.key;kind='pose_or_ui'}
 }
}
if($expected.Count-ne158){throw "Expected 158 outputs, got $($expected.Count)"}
$results=@()
foreach($e in $expected){
 $p=Join-Path $root $e.file
 if(!(Test-Path -LiteralPath $p)){throw "Missing $p"}
 $v=[PreparedAudit]::Scan($p,$e.cell)
 $errors=@()
 if($v[0]-ne$e.size[0]-or$v[1]-ne$e.size[1]){$errors+='DIMENSIONS'}
 if($v[2]-eq0){$errors+='EMPTY'}
 if($e.key-ne'none'-and$e.id-ne'U13_fill'-and$v[3]-eq0){$errors+='NO_TRANSPARENCY'}
 if($e.key-eq'magenta'-and$v[4]-gt0){$errors+='MAGENTA_RESIDUE'}
 if($e.cell-gt0-and$v[5]-gt0){$errors+='SHEET_FRAME_EDGE_CONTACT'}
 $results+=[ordered]@{id=$e.id;file=$e.file;width=$v[0];height=$v[1];solid_pixels=$v[2];transparent_pixels=$v[3];magenta_pixels=$v[4];frame_edge_pixels=$v[5];bbox=@($v[6],$v[7],$v[8],$v[9]);sha256=(Get-FileHash $p -Algorithm SHA256).Hash;source=$e.source;kind=$e.kind;state='DRAFT';checks=if($errors.Count){'HOLD'}else{'PASS'};errors=$errors}
}
$changed=@()
$sourceRoot=Join-Path (Split-Path $root) 'asset-production-20261021-r1'
foreach($s in (Get-Content (Join-Path $sourceRoot 'png-audit.json') -Raw|ConvertFrom-Json)){
 if((Get-FileHash (Join-Path $sourceRoot $s.file) -Algorithm SHA256).Hash-ne$s.sha256){$changed+=$s.file}
}
$report=[ordered]@{revision='DRAFT/r1';expected=158;outputs=$results.Count;holds=@($results|Where-Object checks -EQ HOLD).Count;source_changes=$changed;runtime_modified=$false;canonical_promotion=$false;human_derivative_acceptance='NOT_PRESUMED_FROM_SOURCE_ACCEPTANCE';artifacts=$results}
[IO.File]::WriteAllText((Join-Path $root 'audit.json'),($report|ConvertTo-Json -Depth 8),(New-Object Text.UTF8Encoding($false)))
$results|Where-Object checks -EQ HOLD|ConvertTo-Json -Depth 5
[pscustomobject]@{outputs=$results.Count;holds=$report.holds;source_changes=$changed.Count}
if($report.holds-gt0-or$changed.Count-gt0){exit 1}

