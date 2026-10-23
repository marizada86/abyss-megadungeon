# Prévia animada (GIF) do montador de recortes. Lê o kit; escreve só em -OutGif (e numa pasta temporária que apaga).
# Uso: powershell -File make_rig_preview.ps1 -Kit <kit.json> -OutGif <saida.gif> [-Amplitude 1.0] [-Cycles 4] [-Delay 9]
param(
  [Parameter(Mandatory = $true)][string]$Kit,
  [Parameter(Mandatory = $true)][string]$OutGif,
  [double]$Amplitude = 1.0,
  [int]$Cycles = 4,
  [int]$Delay = 9
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$assembler = Join-Path $here '../hero-art-reset-20261021/assemble_gif.cjs'
$godot = 'F:/dev/abyss-megadungeon/Godot_v4.7.2-stable_win64.exe'
$work = Join-Path ([IO.Path]::GetTempPath()) ('rig-preview-' + [Guid]::NewGuid().ToString('N'))
$png = Join-Path $work 'png'
$gif = Join-Path $work 'gif'
New-Item -ItemType Directory -Path $png, $gif -Force | Out-Null
$amp = $Amplitude.ToString([Globalization.CultureInfo]::InvariantCulture)
& $godot --headless --script (Join-Path $here 'rig_walk_preview.gd') -- $Kit $png $amp $Cycles | Out-Null
foreach ($f in (Get-ChildItem $png -Filter 'frame-*.png' | Sort-Object Name)) {
  $bmp = [Drawing.Image]::FromFile($f.FullName)
  try { $bmp.Save((Join-Path $gif ($f.BaseName + '.gif')), [Drawing.Imaging.ImageFormat]::Gif) } finally { $bmp.Dispose() }
}
node $assembler $gif $OutGif $Delay
Remove-Item -Recurse -Force $work
