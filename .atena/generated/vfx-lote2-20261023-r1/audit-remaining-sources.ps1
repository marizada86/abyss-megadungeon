$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
public static class SourceVfxAudit {
  public static object Scan(string path, int columns, int rows) {
    using (var original = new Bitmap(path))
    using (var b = original.Clone(new Rectangle(0,0,original.Width,original.Height),PixelFormat.Format32bppArgb)) {
      var d = b.LockBits(new Rectangle(0,0,b.Width,b.Height),ImageLockMode.ReadOnly,PixelFormat.Format32bppArgb);
      byte[] bytes = new byte[d.Stride*b.Height];
      Marshal.Copy(d.Scan0,bytes,0,bytes.Length); b.UnlockBits(d);
      int count=columns*rows, cw=b.Width/columns;
      int ch=rows==1?b.Height:384;
      int oy=rows==1?0:128;
      int[] lit=new int[count], minx=new int[count], maxx=new int[count], miny=new int[count], maxy=new int[count];
      for(int i=0;i<count;i++){ minx[i]=b.Width; miny[i]=b.Height; maxx[i]=-1; maxy[i]=-1; }
      int boundaryLit=0;
      for(int y=0;y<b.Height;y++) for(int x=0;x<b.Width;x++) {
        int p=y*d.Stride+x*4;
        if(Math.Max(bytes[p],Math.Max(bytes[p+1],bytes[p+2]))<=24)continue;
        int row=rows==1?0:(y-oy)/ch;
        if(y<oy||row<0||row>=rows)continue;
        int cell=row*columns+Math.Min(columns-1,x/cw);
        lit[cell]++;minx[cell]=Math.Min(minx[cell],x);maxx[cell]=Math.Max(maxx[cell],x);
        miny[cell]=Math.Min(miny[cell],y);maxy[cell]=Math.Max(maxy[cell],y);
        if(x%cw<3||x%cw>=cw-3)boundaryLit++;
      }
      int[] widths=new int[count], heights=new int[count];
      for(int i=0;i<count;i++){widths[i]=Math.Max(0,maxx[i]-minx[i]+1);heights[i]=Math.Max(0,maxy[i]-miny[i]+1);}
      return new {width=b.Width,height=b.Height,nominal_cells=count,lit_pixels_per_cell=lit,bbox_widths=widths,bbox_heights=heights,lit_pixels_in_cell_edge_bands=boundaryLit};
    }
  }
}
'@
$root = $PSScriptRoot
$queuePath = Join-Path $root 'queue.json'
$queue = Get-Content -LiteralPath $queuePath -Raw | ConvertFrom-Json
$items = @($queue.items | Where-Object { -not $_.pilot } | Sort-Object @{Expression={switch ($_.id.Substring(0,1)) {'P'{0};'M'{1};'G'{2}}}},id)
if ($items.Count -ne 19) { throw 'Expected 19 released IDs' }
$records = foreach ($item in $items) {
    $recommended = if ($item.id -in @('M04','G06','G09')) { $item.expected_file.Replace('_v01.png','_v02.png') } else { $item.expected_file }
    $candidates = @(Get-ChildItem -LiteralPath $root -Filter ($item.id + '_*_v0?.png') | Sort-Object Name)
    foreach ($candidate in $candidates) {
        $columns = if ($item.id -in @('G04','G08')) {4} else {6}
        $rows = if ($columns -eq 4) {2} else {1}
        [ordered]@{id=$item.id;file=$candidate.Name;recommended=($candidate.Name -eq $recommended);sha256=(Get-FileHash -LiteralPath $candidate.FullName -Algorithm SHA256).Hash.ToLower();scan=[SourceVfxAudit]::Scan($candidate.FullName,$columns,$rows);human_visual_acceptance='PENDING';runtime_admission=$false}
    }
    $item.state = 'GENERATED_AWAITING_OWNER_REVIEW'
    $item.tool = 'image_gen (built-in)'
    $item | Add-Member -NotePropertyName recommended_file -NotePropertyValue $recommended -Force
    $item | Add-Member -NotePropertyName attempts_used -NotePropertyValue $candidates.Count -Force
    $item | Add-Member -NotePropertyName technical_review -NotePropertyValue 'SOURCE_REVIEW_ONLY_NORMALIZATION_AND_ATLAS_GATE_PENDING' -Force
}
$audit = [ordered]@{date='2026-10-24';state='DRAFT';ids=19;candidates=@($records).Count;tool='image_gen built-in';prompt_set='COLAR-NO-CHATGPT-19-FOLHAS.md';reference='ref-existing-vfx.png';threshold=24;note='Nominal grid occupancy is not proof of frame separability or atlas acceptance. All sources need normalization; edge counts flag possible bleed.';items=@($records)}
$audit | ConvertTo-Json -Depth 15 | Set-Content -LiteralPath (Join-Path $root 'remaining-source-audit-20261024.json') -Encoding utf8
$queue.generation = 'image_gen integrado; piloto preservado; 19 folhas autorizadas pelo pedido atual do dono em 2026-10-24'
$queue | ConvertTo-Json -Depth 15 | Set-Content -LiteralPath $queuePath -Encoding utf8
$html = '<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>VFX Lote 2 — 19 folhas</title><style>body{font:16px system-ui;background:#17151e;color:#eee;max-width:1350px;margin:30px auto;padding:20px}a{color:#8ddcff}img{width:100%;background:#000}article{border-top:1px solid #555;margin-top:30px}code{word-break:break-all}nav{display:flex;gap:14px;flex-wrap:wrap}.note{color:#ffd69b}summary{cursor:pointer}</style><h1>VFX Lote 2 · 19 folhas</h1><p>24/10/2026 · DRAFT · 19 IDs, 22 candidatas. Aceite visual pendente por ID, revisão e hash.</p><p class="note">Fontes de geração. Normalização, loops, animação e leitura no jogo ainda precisam ser validados. M04/G06/G09: v02 recomendada; v01 preservada abaixo.</p><p><a href="remaining-generation-20261024.md">Relatório e ressalvas</a> · <a href="remaining-source-audit-20261024.json">Hashes e medidas</a> · <a href="pilot-gallery-v01.html">Piloto aceito</a></p><nav>'
foreach ($item in $items) { $html += '<a href="#'+$item.id+'">'+$item.id+'</a>' }
$html += '</nav>'
foreach ($item in $items) {
    $r = $records | Where-Object { $_.id -eq $item.id -and $_.recommended }
    $html += '<article id="'+$item.id+'"><h2>'+$item.id+' · '+$item.name+'</h2><p><a href="'+$r.file+'">'+$r.file+'</a> · '+$r.scan.width+'×'+$r.scan.height+' · '+$r.scan.nominal_cells+' células nominais</p><p><code>SHA256 '+$r.sha256+'</code></p><img loading="lazy" src="'+$r.file+'" alt="'+$item.name+'">'
    foreach ($old in @($records | Where-Object { $_.id -eq $item.id -and -not $_.recommended })) { $html += '<details><summary>Comparar versão anterior '+$old.file+'</summary><a href="'+$old.file+'">Abrir original</a><img loading="lazy" src="'+$old.file+'" alt="Versão anterior"></details>' }
    $html += '</article>'
}
$html += '</html>'
$html | Set-Content -LiteralPath (Join-Path $root 'remaining-gallery-20261024.html') -Encoding utf8
$records | Where-Object recommended | ForEach-Object { '{0}: {1}x{2}, cells={3}, edge-lit={4}' -f $_.id,$_.scan.width,$_.scan.height,$_.scan.nominal_cells,$_.scan.lit_pixels_in_cell_edge_bands }
