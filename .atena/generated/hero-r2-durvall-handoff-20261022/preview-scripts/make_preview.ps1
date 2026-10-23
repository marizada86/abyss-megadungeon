$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$delivery = 'F:/dev/abyss-megadungeon/assets_incoming/hero-r2/durvall'
$framesDir = 'F:/dev/abyss-megadungeon/tmp/hero-r2-gate1-isolated/gif-frames'
New-Item -ItemType Directory -Path $framesDir -Force | Out-Null
$idleReport = Get-Content -Raw -LiteralPath "$delivery/gate1-idle-v02.json" | ConvertFrom-Json
$walkReport = Get-Content -Raw -LiteralPath "$delivery/gate1-walk-v02.json" | ConvertFrom-Json
$idleImage = [Drawing.Image]::FromFile("$delivery/durvall_idle_se_v02.png")
$walkImage = [Drawing.Image]::FromFile("$delivery/durvall_walk_se_v02.png")
$font = [Drawing.Font]::new('Arial', 15)
$sequence = @(0,1,2,1)
try {
  for ($tick = 0; $tick -lt 40; $tick++) {
    $bitmap = [Drawing.Bitmap]::new(620,500)
    $g = [Drawing.Graphics]::FromImage($bitmap)
    $g.Clear([Drawing.Color]::Magenta)
    $g.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawString('IDLE - 5 fps', $font, [Drawing.Brushes]::Black, 80, 12)
    $g.DrawString('WALK - 12,5 fps', $font, [Drawing.Brushes]::Black, 365, 12)
    $g.DrawString('Durvall SE - previa v02', $font, [Drawing.Brushes]::Black, 193, 470)
    for ($panel = 0; $panel -lt 2; $panel++) {
      $isIdle = $panel -eq 0
      $phase = if ($isIdle) { [int][Math]::Floor($tick / 5) % 4 } else { [int][Math]::Floor($tick / 2) % 4 }
      $figure = if ($isIdle) { $idleReport.figuras[$sequence[$phase]] } else { $walkReport.figuras[$sequence[$phase]] }
      $image = if ($isIdle) { $idleImage } else { $walkImage }
      $scale = if ($isIdle) { 410.0 / 912 } else { 410.0 / 888 }
      $width = [single]($figure.w * $scale)
      $height = [single]($figure.h * $scale)
      $dest = [Drawing.RectangleF]::new([single](155 + $panel * 310 - $width / 2), [single](455 - $height), $width, $height)
      $source = [Drawing.RectangleF]::new($figure.x, $figure.y, $figure.w, $figure.h)
      $g.DrawImage($image, $dest, $source, [Drawing.GraphicsUnit]::Pixel)
    }
    $g.Dispose()
    $bitmap.Save((Join-Path $framesDir ('frame-{0:D2}.gif' -f $tick)), [Drawing.Imaging.ImageFormat]::Gif)
    $bitmap.Dispose()
  }
} finally {
  $font.Dispose()
  $idleImage.Dispose()
  $walkImage.Dispose()
}
