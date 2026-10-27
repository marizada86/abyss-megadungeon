param([string]$Tag = 'depois', [string]$Size = '1280x720')
# Cartões de oferta no pior caso de texto, com APPDATA isolado (nunca o save real).
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$base = Join-Path $root '.atena/generated/offer-card-compact-20261027-r1'
New-Item -ItemType Directory -Force (Join-Path $base 'synthetic/appdata') | Out-Null
New-Item -ItemType Directory -Force (Join-Path $base 'synthetic/localappdata') | Out-Null
$env:APPDATA = Join-Path $base 'synthetic/appdata'
$env:LOCALAPPDATA = Join-Path $base 'synthetic/localappdata'
$exe = Join-Path $root 'Godot_v4.7.2-stable_win64.exe'
$launchArgs = @('--path', $root, '--resolution', $Size, '--rendering-method', 'gl_compatibility', '--script', 'tools/offer_cards_sweep.gd', '--', $Tag, $Size)
$quoted = ($launchArgs | ForEach-Object { '"' + $_ + '"' }) -join ' '
$log = Join-Path $base ('sweep-' + $Tag + '-' + $Size + '.log')
$err = Join-Path $base ('sweep-' + $Tag + '-' + $Size + '-errors.log')
$process = Start-Process -FilePath $exe -ArgumentList $quoted -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput $log -RedirectStandardError $err
Get-Content -LiteralPath $log -Tail 20
Get-Content -LiteralPath $err -Tail 25
exit $process.ExitCode
