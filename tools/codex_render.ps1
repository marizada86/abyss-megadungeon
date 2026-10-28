param([string]$Size = '1280x720', [string]$LogName = "codex")
# PLAN-ABYSS-CODEX-LORE: roda tools/codex_capture.gd com APPDATA isolado (nunca o save real).
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$base = Join-Path $root '.atena/generated/codex-lore-20261027-r1'
New-Item -ItemType Directory -Force (Join-Path $base 'synthetic/appdata') | Out-Null
New-Item -ItemType Directory -Force (Join-Path $base 'synthetic/localappdata') | Out-Null
$env:APPDATA = Join-Path $base 'synthetic/appdata'
$env:LOCALAPPDATA = Join-Path $base 'synthetic/localappdata'
$exe = Join-Path $root 'Godot_v4.7.2-stable_win64.exe'
$launchArgs = @('--path', $root, '--resolution', $Size, '--rendering-method', 'gl_compatibility', '--script', 'tools/codex_capture.gd', '--', $Size)
$quoted = ($launchArgs | ForEach-Object { '"' + $_ + '"' }) -join ' '
$log = Join-Path $base ($LogName + '-' + $Size + '.log')
$err = Join-Path $base ($LogName + '-' + $Size + '-errors.log')
$process = Start-Process -FilePath $exe -ArgumentList $quoted -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput $log -RedirectStandardError $err
Get-Content -LiteralPath $log -Tail 20
Get-Content -LiteralPath $err -Tail 25
exit $process.ExitCode
