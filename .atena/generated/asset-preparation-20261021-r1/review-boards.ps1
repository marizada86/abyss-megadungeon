$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$root=$PSScriptRoot
$report=Get-Content (Join-Path $root 'audit.json') -Raw -Encoding UTF8|ConvertFrom-Json
$ui=@($report.artifacts|Where-Object {$_.file -match '^prepared/(ui|icons)/'})
$chars=@($report.artifacts|Where-Object {$_.file -match '^prepared/characters/'})
function Board($items,$out,$cols,$cw,$ch) {
 $rows=[int][Math]::Ceiling($items.Count/$cols)
 $b=New-Object Drawing.Bitmap(($cols*$cw),($rows*$ch))
 $g=[Drawing.Graphics]::FromImage($b)
 $g.Clear([Drawing.Color]::FromArgb(30,32,40))
 $font=New-Object Drawing.Font('Arial',10)
 try {
  for($i=0;$i-lt$items.Count;$i++){
   $x=($i%$cols)*$cw;$y=[int][Math]::Floor($i/$cols)*$ch
   $g.DrawString(($items[$i].file -replace '^prepared/',''),$font,[Drawing.Brushes]::White,($x+4),($y+4))
   $im=[Drawing.Image]::FromFile((Join-Path $root $items[$i].file))
   try {
    $s=[Math]::Min(($cw-12)/$im.Width,($ch-34)/$im.Height)
    $w=[int]($im.Width*$s);$h=[int]($im.Height*$s)
    $g.DrawImage($im,($x+[int](($cw-$w)/2)),($y+28),$w,$h)
   }finally{$im.Dispose()}
  }
  $b.Save((Join-Path $root $out),[Drawing.Imaging.ImageFormat]::Png)
 }finally{$font.Dispose();$g.Dispose();$b.Dispose()}
}
Board $ui 'ui-review-board.png' 4 280 120
Board $chars 'n-review-board.png' 6 190 315

