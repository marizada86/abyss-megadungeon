param([ValidateSet('raiz_yggdrasil','reino_abissal')][string]$Map)
$ErrorActionPreference='Stop'
$projectRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
$session=Join-Path $PSScriptRoot ('s005-'+$Map+'-'+[DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-fff'))
$null=New-Item -ItemType Directory -Path $session
foreach($f in @('appdata','localappdata','probe')){$null=New-Item -ItemType Directory -Path (Join-Path $session $f)}
$env:APPDATA=Join-Path $session 'appdata';$env:LOCALAPPDATA=Join-Path $session 'localappdata';$env:NOTT_SEM_NEVOA=''
$profile=Join-Path $session 'synthetic-profile.json';'{}'|Set-Content -LiteralPath $profile -Encoding ascii
$config=Get-Content -LiteralPath (Join-Path $projectRoot 'project.godot') -Raw
$custom=[regex]::Match($config,'(?m)^config/custom_user_dir_name="([^"]+)"').Groups[1].Value
if(-not $custom -or $config -notmatch 'config/use_custom_user_dir=true'){throw 'Unexpected userdir settings'}
"config_version=5`n[application]`nconfig/name=`"IsolationProbe`"`nconfig/use_custom_user_dir=true`nconfig/custom_user_dir_name=`"$custom`"`n"|Set-Content -LiteralPath (Join-Path $session 'probe/project.godot') -Encoding ascii
@'
extends SceneTree
func _init() -> void:
 print("ISOLATED_USER_DIR="+OS.get_user_data_dir())
 quit()
'@|Set-Content -LiteralPath (Join-Path $session 'probe/probe.gd') -Encoding ascii
$godot='D:\Godot\godot.exe'
$ErrorActionPreference='Continue'
& rtk proxy $godot --headless --path (Join-Path $session 'probe') -s probe.gd *> (Join-Path $session 'isolation.log')
$probeCode=$LASTEXITCODE
$ErrorActionPreference='Stop'
if($probeCode -ne 0){throw 'Probe failed'}
$userDir=[regex]::Match((Get-Content -LiteralPath (Join-Path $session 'isolation.log') -Raw),'ISOLATED_USER_DIR=([^\r\n]+)').Groups[1].Value.Trim()
if(-not $userDir -or -not ([IO.Path]::GetFullPath($userDir).StartsWith($session+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase))){throw 'Isolation rejected'}
$arguments=@('--headless','--editor','--import','--path',$projectRoot,'--','--controller-profile',$profile)
$quoted=($arguments|ForEach-Object {'"'+$_+'"'}) -join ' '
$import=Start-Process -FilePath $godot -ArgumentList $quoted -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput (Join-Path $session 'import.log') -RedirectStandardError (Join-Path $session 'import-errors.log')
if($import.ExitCode -ne 0){throw 'Import failed'}
$arguments=@('--path',$projectRoot,'--windowed','--resolution','1280x720','--position',$(if($Map -eq 'raiz_yggdrasil'){'40,40'}else{'160,100'}),'--log-file',(Join-Path $session 'engine.log'),'-s','.atena/generated/path-revision-20261017/playtest-s005.gd','--','--controller-profile',$profile,'--map-session',$session,'--map',$Map)
$quoted=($arguments|ForEach-Object {'"'+$_+'"'}) -join ' '
$process=Start-Process -FilePath $godot -ArgumentList $quoted -WorkingDirectory $projectRoot -WindowStyle Normal -PassThru -RedirectStandardOutput (Join-Path $session 'playtest.log') -RedirectStandardError (Join-Path $session 'playtest-errors.log')
$ready=Join-Path $session 'ready.json'
for($attempt=0;$attempt -lt 60;$attempt++){$process.Refresh();if($process.HasExited -or (Test-Path -LiteralPath $ready)){break};Start-Sleep -Milliseconds 500}
$process.Refresh()
$logs=@('engine.log','playtest-errors.log')|ForEach-Object {Get-Content -LiteralPath (Join-Path $session $_) -Raw}
if($process.HasExited -or -not (Test-Path -LiteralPath $ready) -or ($logs -join "`n") -match 'SCRIPT ERROR:|SHADER ERROR:|ERROR:'){throw ('Launch failed; session='+$session)}
$r=Get-Content -LiteralPath $ready -Raw|ConvertFrom-Json
if($r.map -ne $Map -or -not $r.sandbox -or -not $r.save_path.StartsWith('user://qa-sandbox/') -or -not $r.paused -or $process.MainWindowHandle -eq 0){throw ('Readiness rejected; session='+$session)}
$receipt=@{status='OPEN_PAUSED_AWAITING_OWNER_FEEDBACK';map=$Map;pid=$process.Id;window_handle=$process.MainWindowHandle.ToInt64();session=$session;user_dir=$userDir;ready=$r;profile=$profile;human_acceptance='PENDING'}
$receipt|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $PSScriptRoot ('s005-'+$Map+'-launch.json')) -Encoding utf8
$receipt|ConvertTo-Json -Compress -Depth 8
