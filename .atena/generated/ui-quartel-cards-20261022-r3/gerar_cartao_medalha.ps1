# Gera fase_cartao_medalha.png: o cartão de fase sem o oval ornamental (estreito demais para as medalhas).
# A coluna do oval é substituída por uma coluna vizinha lisa (painel e trilhos), sem pontas soltas da ornamentação.
param([string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path)
Add-Type -AssemblyName System.Drawing
$src = [System.Drawing.Bitmap]::FromFile((Join-Path $Root 'assets/ui/quartel/fase_cartao.png'))
$bmp = New-Object System.Drawing.Bitmap $src.Width, $src.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.DrawImageUnscaled($src, 0, 0)
$g.CompositingMode = 'SourceCopy'
$slot = New-Object System.Drawing.Rectangle 78, 0, 40, 88
$donor = New-Object System.Drawing.Rectangle 122, 0, 40, 88
$g.DrawImage($src, $slot, $donor.X, $donor.Y, $donor.Width, $donor.Height, 'Pixel')
$bmp.Save((Join-Path $Root 'assets/ui/quartel/fase_cartao_medalha.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose(); $src.Dispose()
