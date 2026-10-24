param([string]$Script = 'tools/vfx_lote1_playtest.gd', [string[]]$UserArgs = @(), [string]$LogName='playtest', [switch]$Interactive)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$base=Join-Path $root '.atena/generated/vfx-lote1-20261023-r1'
$env:APPDATA=Join-Path $base 'synthetic/appdata'
$env:LOCALAPPDATA=Join-Path $base 'synthetic/localappdata'
$exe=Join-Path $root 'Godot_v4.7.2-stable_win64.exe'
$launchArgs=@('--path',$root,'--resolution','1280x720','--rendering-method','gl_compatibility')
if($Script.EndsWith('.tscn')){$launchArgs+=$Script}else{$launchArgs+=@('--script',$Script)}
$launchArgs+=@('--')+$UserArgs
if($Interactive){$launchArgs+=@("--interactive")}
$quoted=($launchArgs | ForEach-Object {'"'+$_+'"'}) -join ' '
if($Interactive){ & $exe @launchArgs; exit $LASTEXITCODE }
$process=Start-Process -FilePath $exe -ArgumentList $quoted -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput (Join-Path $base ($LogName+'.log')) -RedirectStandardError (Join-Path $base ($LogName+'-errors.log'))
Get-Content -LiteralPath (Join-Path $base ($LogName+'.log')) -Tail 20
Get-Content -LiteralPath (Join-Path $base ($LogName+'-errors.log')) -Tail 25
exit $process.ExitCode
