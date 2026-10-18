param([switch]$Render)
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
$sessionPath=Join-Path $PSScriptRoot ('s004-'+[DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss'))
$null=New-Item -ItemType Directory -Path $sessionPath
foreach($folder in @('a','l','probe')){$null=New-Item -ItemType Directory -Path (Join-Path $sessionPath $folder)}
$env:APPDATA=Join-Path $sessionPath 'a'
$env:LOCALAPPDATA=Join-Path $sessionPath 'l'
$env:NOTT_SEM_NEVOA=''
$profile=Join-Path $sessionPath 'synthetic-profile.json'
'{}'|Set-Content -LiteralPath $profile -Encoding ascii
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
 $log=Join-Path $sessionPath ($Name+'.log')
 $prior=$ErrorActionPreference;$ErrorActionPreference='Continue'
 & rtk proxy $godot @GodotArgs *> $log
 $code=$LASTEXITCODE;$ErrorActionPreference=$prior
 $body=Get-Content -LiteralPath $log -Raw
 if($code -ne 0 -or $body -match 'SCRIPT ERROR:|Parse Error:|SHADER ERROR:|ERROR:') {Write-Output $body;throw ($Name+' failed '+$code)}
 return $body
}
$body=Invoke-Check @('--headless','--path',$probe,'-s','probe.gd') 'isolation'
$userDir=[regex]::Match($body,'ISOLATED_USER_DIR=([^\r\n]+)').Groups[1].Value.Trim()
if(-not $userDir -or -not ([IO.Path]::GetFullPath($userDir).StartsWith([IO.Path]::GetFullPath($sessionPath)+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase))){throw 'Isolation rejected'}
$null=Invoke-Check @('--headless','--editor','--import','--path',$taskRoot,'--','--controller-profile',$profile) 'import-first'
foreach($name in @('ground','edge','detail','trunk')){
 $file=Join-Path $taskRoot ('assets/tiles/yggdrasil_r1/'+$name+'.png.import')
 $text=Get-Content -LiteralPath $file -Raw
 $text=$text -replace 'process/size_limit=\d+','process/size_limit=1024'
 $text=$text -replace 'mipmaps/generate=true','mipmaps/generate=false'
 [IO.File]::WriteAllText($file,$text,(New-Object Text.UTF8Encoding($false)))
}
$null=Invoke-Check @('--headless','--editor','--import','--path',$taskRoot,'--','--controller-profile',$profile) 'import-capped'
if($Render){
 $argsList=@('--path',$taskRoot,'--resolution','1280x720','--position','-10000,-10000','--quit-after','12000','-s','.atena/generated/yggdrasil-art-20261017/render-integration.gd','--','--controller-profile',$profile,'--capture-dir',$sessionPath)
 $p=Start-Process -FilePath $godot -ArgumentList $argsList -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput (Join-Path $sessionPath 'render.log') -RedirectStandardError (Join-Path $sessionPath 'render-error.log')
 $err=Get-Content -LiteralPath (Join-Path $sessionPath 'render-error.log') -Raw
 Write-Output $err
 if($p.ExitCode -ne 0 -or $err -match 'ERROR:' -or -not (Test-Path -LiteralPath (Join-Path $sessionPath 'render-result.json'))){throw 'Render failed'}
 Get-Content -LiteralPath (Join-Path $sessionPath 'render-result.json') -Raw
}else{
 $results=@()
 foreach($test in @('test_yggdrasil_art','test_yggdrasil_navigation','test_yggdrasil_map','test_root_navigation','test_root_art','test_domwieck_art','test_map_objectives','test_level_design','test_terrain','test_chapter_flow','test_scripts_compile')){
  $body=Invoke-Check @('--headless','--quit-after','1200','--path',$taskRoot,'-s','tools/run_one_test.gd','--','--controller-profile',$profile,$test) $test
  if($body -notmatch ($test+': 0 falha')){Write-Output $body;throw ('Test assertion failed '+$test)}
  $results+=@{test=$test;passed=$true};Write-Output ($test+': PASS')
 }
 @{results=$results;user_data_dir=$userDir;profile=$profile}|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $sessionPath 'tests-result.json') -Encoding utf8
}
Write-Output ('SESSION='+$sessionPath)
