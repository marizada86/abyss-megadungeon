param([string]$Script = 'tools/run_one_test.gd', [string[]]$TestArgs = @(), [switch]$Import)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$session=Join-Path $root '.atena/generated/vfx-lote1-20261023-r1/synthetic'
$priorApp=$env:APPDATA
$priorLocal=$env:LOCALAPPDATA
try {
 $env:APPDATA=Join-Path $session 'appdata'
 $env:LOCALAPPDATA=Join-Path $session 'localappdata'
 New-Item -ItemType Directory -Path $env:APPDATA,$env:LOCALAPPDATA -Force | Out-Null
 $exe=Join-Path $root 'Godot_v4.7.2-stable_win64.exe'
 if($Import){& $exe --headless --path $root --editor --import 2>&1 | ForEach-Object { "$_" }}
 else{& $exe --headless --path $root --script $Script -- @TestArgs 2>&1 | ForEach-Object { "$_" }}
 exit $LASTEXITCODE
} finally {$env:APPDATA=$priorApp;$env:LOCALAPPDATA=$priorLocal}
