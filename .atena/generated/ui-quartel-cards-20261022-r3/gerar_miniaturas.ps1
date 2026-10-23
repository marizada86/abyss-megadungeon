# Gera as miniaturas do Quartel (cartões de herói e de fase) a partir dos retratos e
# miniaturas de fase já existentes no projeto. Janela do cartão + 2 px de folga por lado,
# em dobro de resolução. Foco = (x, y, zoom) em frações do retrato; zoom = fração da altura.
param([string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path)
Add-Type -AssemblyName System.Drawing
$out = Join-Path $Root 'assets/ui/quartel/thumbs'
$null = New-Item -ItemType Directory -Force -Path $out
$focus = @{
  arlindo = 0.45, 0.38, 0.58;  bromnor = 0.40, 0.42, 0.66; brook = 0.33, 0.42, 0.58
  durvall = 0.48, 0.36, 0.58;  erik    = 0.47, 0.27, 0.56; kayron = 0.53, 0.28, 0.56
  korrak  = 0.60, 0.42, 0.66;  leoric  = 0.52, 0.34, 0.62; maelor = 0.47, 0.24, 0.56
  nyrelia = 0.50, 0.30, 0.62;  sylas   = 0.42, 0.32, 0.64; zynara = 0.50, 0.28, 0.56
}
function Save-Crop($src, [double]$cx, [double]$cy, [double]$ch, [int]$w, [int]$h, $path) {
  $im = [System.Drawing.Image]::FromFile($src)
  $cropH = [math]::Min($im.Height, $ch * $im.Height)
  $cropW = $cropH * $w / $h
  if ($cropW -gt $im.Width) { $cropW = $im.Width; $cropH = $cropW * $h / $w }
  $x = [math]::Max(0, [math]::Min($im.Width - $cropW, $cx * $im.Width - $cropW / 2))
  $y = [math]::Max(0, [math]::Min($im.Height - $cropH, $cy * $im.Height - $cropH / 2))
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = 'HighQualityBicubic'; $g.SmoothingMode = 'HighQuality'; $g.PixelOffsetMode = 'HighQuality'
  $g.DrawImage($im, (New-Object System.Drawing.Rectangle 0, 0, $w, $h), [float]$x, [float]$y, [float]$cropW, [float]$cropH, 'Pixel')
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose(); $im.Dispose()
}
foreach ($id in $focus.Keys) {
  $f = $focus[$id]
  Save-Crop (Join-Path $Root "assets/portraits/$id.png") $f[0] $f[1] $f[2] 102 94 (Join-Path $out "heroi_$id.png")
}
Get-ChildItem (Join-Path $Root 'assets/stages') -Filter '*_thumb.png' | ForEach-Object {
  $id = $_.BaseName -replace '_thumb$', ''
  Save-Crop $_.FullName 0.5 0.5 1.0 136 96 (Join-Path $out "fase_$id.png")
}
Write-Output ("Miniaturas: " + (Get-ChildItem $out -Filter *.png).Count)
