param([string]$TargetRoot='', [string]$Test='', [string]$Harness='', [switch]$Render)
$ErrorActionPreference='Stop'
$projectRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
if(-not $TargetRoot){$TargetRoot=$projectRoot}
$sessionPath=Join-Path $PSScriptRoot ('s002-'+[DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-fff'))
$null=New-Item -ItemType Directory -Path $sessionPath
foreach($folder in @('a','l','probe')){$null=New-Item -ItemType Directory -Path (Join-Path $sessionPath $folder)}
$env:APPDATA=Join-Path $sessionPath 'a';$env:LOCALAPPDATA=Join-Path $sessionPath 'l';$env:NOTT_SEM_NEVOA=''
$profile=Join-Path $sessionPath 'synthetic-profile.json';'{}'|Set-Content -LiteralPath $profile -Encoding ascii
$probe=Join-Path $sessionPath 'probe'
@'
config_version=5
[application]
config/name="IsolationProbe"
config/use_custom_user_dir=true
config/custom_user_dir_name="Godot/app_userdata/Nottgard Survivors"
'@|Set-Content -LiteralPath (Join-Path $probe 'project.godot') -Encoding ascii
@'
extends SceneTree
func _init() -> void:
 print("ISOLATED_USER_DIR="+OS.get_user_data_dir())
 quit()
'@|Set-Content -LiteralPath (Join-Path $probe 'probe.gd') -Encoding ascii
$godot='D:\Godot\godot.exe'
function Invoke-Check([string[]]$GodotArgs,[string]$Name){
 $log=Join-Path $sessionPath ($Name+'.log');$prior=$ErrorActionPreference;$ErrorActionPreference='Continue'
 & rtk proxy $godot @GodotArgs *> $log
 $code=$LASTEXITCODE;$ErrorActionPreference=$prior;$body=Get-Content -LiteralPath $log -Raw
 if($code -ne 0 -or $body -match 'SCRIPT ERROR:|Parse Error:|SHADER ERROR:|ERROR:'){Write-Output $body;throw ($Name+' failed '+$code)}
 return $body
}
$body=Invoke-Check @('--headless','--path',$probe,'-s','probe.gd') 'isolation'
$userDir=[regex]::Match($body,'ISOLATED_USER_DIR=([^\r\n]+)').Groups[1].Value.Trim()
if(-not $userDir -or -not ([IO.Path]::GetFullPath($userDir).StartsWith($sessionPath+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase))){throw 'Isolation rejected'}
@{session=$sessionPath;target=$TargetRoot;user_dir=$userDir}|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $PSScriptRoot 's002-latest-session.json') -Encoding utf8
$null=Invoke-Check @('--headless','--editor','--import','--path',$TargetRoot,'--','--controller-profile',$profile) 'import'
$results=@()
if($Harness){
 if($Render){
  $arguments=@('--path',$TargetRoot,'--resolution','1280x720','--position','-10000,-10000','-s',$Harness,'--','--controller-profile',$profile,'--capture-dir',$sessionPath)
  $quoted=($arguments|ForEach-Object {'"'+$_+'"'}) -join ' '
  $process=Start-Process -FilePath $godot -ArgumentList $quoted -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput (Join-Path $sessionPath 'harness.log') -RedirectStandardError (Join-Path $sessionPath 'harness-errors.log')
  $body=Get-Content -LiteralPath (Join-Path $sessionPath 'harness-errors.log') -Raw
  if($process.ExitCode -ne 0 -or $body -match 'ERROR:|SCRIPT ERROR:|SHADER ERROR:'){Write-Output $body;throw 'Render failed'}
 }else{
  $body=Invoke-Check @('--headless','--path',$TargetRoot,'-s',$Harness,'--','--controller-profile',$profile,'--capture-dir',$sessionPath) 'harness'
  Write-Output $body
 }
}else{
 $tests=if($Test){@($Test.Split(','))}else{@('test_scripts_compile','test_yggdrasil_navigation','test_yggdrasil_map','test_yggdrasil_art','test_root_navigation','test_root_art','test_terrain')}
 foreach($testName in $tests){
  $body=Invoke-Check @('--headless','--path',$TargetRoot,'-s','tools/run_one_test.gd','--','--controller-profile',$profile,$testName) $testName
  if($body -notmatch ($testName+': 0 falha')){Write-Output $body;throw ('Test failed '+$testName)}
  $results+=@{test=$testName;passed=$true};Write-Output ($testName+': PASS')
 }
}
@{results=$results;user_dir=$userDir;target=$TargetRoot}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $sessionPath 'results.json') -Encoding utf8
Write-Output ('SESSION='+$sessionPath)
