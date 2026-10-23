# Monta a prévia animada (GIF) de uma caminhada a partir de um PNG de figuras. Somente lê a imagem; escreve só em -OutDir.
# Uso: powershell -File make_walk_preview.ps1 -Image <png> -Layout grid|row3 -Sequence 0,1,2,3 -OutGif <saida.gif> [-Delay 9] [-Cycles 4]
# Delay em centésimos de segundo (9 = 90 ms, cerca de 11 fps). Painéis: caixa | tronco | tamanho de jogo (ver walk_preview_frames.gd).
param(
  [Parameter(Mandatory = $true)][string]$Image,
  [Parameter(Mandatory = $true)][string]$Layout,
  [Parameter(Mandatory = $true)][string]$Sequence,
  [Parameter(Mandatory = $true)][string]$OutGif,
  [int]$Delay = 9,
  [int]$Cycles = 4
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$godot = 'F:/dev/abyss-megadungeon/Godot_v4.7.2-stable_win64.exe'
$work = Join-Path ([IO.Path]::GetTempPath()) ('walk-preview-' + [Guid]::NewGuid().ToString('N'))
$png = Join-Path $work 'png'
$gif = Join-Path $work 'gif'
New-Item -ItemType Directory -Path $png, $gif -Force | Out-Null
& $godot --headless --script (Join-Path $here 'walk_preview_frames.gd') -- $Image $Layout $Sequence $png $Cycles | Out-Null
foreach ($f in (Get-ChildItem $png -Filter 'frame-*.png' | Sort-Object Name)) {
  $bmp = [Drawing.Image]::FromFile($f.FullName)
  try { $bmp.Save((Join-Path $gif ($f.BaseName + '.gif')), [Drawing.Imaging.ImageFormat]::Gif) } finally { $bmp.Dispose() }
}
node (Join-Path $here 'assemble_gif.cjs') $gif $OutGif $Delay
Remove-Item -Recurse -Force $work
