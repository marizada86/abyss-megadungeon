param([Parameter(Mandatory = $true)][string]$Heroes, [string]$Tag = 'lote', [int]$Crop = 1820)
# PLAN-ABYSS-HERO-PORTRAITS-20261027: integra vários heróis de uma vez (recorte, importação, capturas, testes e folha de contato).
# Uso: powershell -ExecutionPolicy Bypass -File tools/portrait_batch.ps1 -Heroes "brook,bromnor,leoric" [-Tag lote1]
# Crop: 1820 = altura inteira com laterais espelhadas (nada de cabeça ou bota cortada); 1536 = 16:9 central de largura inteira.
# Pré-requisito: assets_incoming/hero-portraits-r1/<id>/<id>_hud_v01.png e <id>_ficha_v01.png. Usa APPDATA sintético (nunca o save real).
$ErrorActionPreference = 'Continue'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
$exe = Join-Path $root 'Godot_v4.7.2-stable_win64.exe'
$base = Join-Path $root '.atena/generated/hero-portraits-20261027-r1'
$ids = $Heroes.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ }
$ready = @()
foreach ($id in $ids) {
  $hud = "assets_incoming/hero-portraits-r1/$id/${id}_hud_v01.png"
  $fic = "assets_incoming/hero-portraits-r1/$id/${id}_ficha_v01.png"
  if ((Test-Path $hud) -and (Test-Path $fic)) { $ready += $id } else { Write-Host "PULADO $id : falta $hud ou $fic" }
}
if ($ready.Count -eq 0) { Write-Host 'nenhum herói pronto'; exit 1 }
foreach ($id in $ready) {
  & $exe --headless --path $root --script tools/portrait_prep.gd -- $id -1 -1 $Crop 2>&1 | Select-String 'portrait_prep'
}
& $exe --headless --path $root --import 2>&1 | Select-String 'ERROR' | Select-Object -First 3
$env:APPDATA = Join-Path $base 'synthetic/appdata'
$env:LOCALAPPDATA = Join-Path $base 'synthetic/localappdata'
New-Item -ItemType Directory -Force $env:APPDATA, $env:LOCALAPPDATA | Out-Null
foreach ($id in $ready) {
  powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root 'tools/portrait_render.ps1') -Hero $id -Tag $Tag | Select-String 'portrait_capture'
}
& $exe --headless --path $root --script tools/portrait_contact.gd -- $Tag @ready 2>&1 | Select-String 'portrait_contact|sem '
foreach ($t in 'test_hero_portraits', 'test_hero_panel') {
  & $exe --headless --path $root -s tools/run_one_test.gd -- $t 2>&1 | Select-String 'falha'
}
Write-Host "feito: $($ready -join ', ') -> $base/captures/contato-$Tag.png"

