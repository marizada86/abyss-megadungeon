param([string[]]$Tests = @('test_domwieck_art','test_root_art','test_root_navigation','test_map_objectives','test_level_design','test_terrain','test_chapter_flow','test_scripts_compile'), [switch]$Smoke, [switch]$ReviewCatalogContracts, [switch]$Metrics, [switch]$RenderAudit)
$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
$sessionPath = Join-Path $PSScriptRoot ('validation-' + [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-fff'))
$null = New-Item -ItemType Directory -Path $sessionPath
$appPath = Join-Path $sessionPath 'appdata'
$localPath = Join-Path $sessionPath 'localappdata'
$probePath = Join-Path $sessionPath 'probe'
foreach ($folder in @($appPath,$localPath,$probePath)) { $null = New-Item -ItemType Directory -Path $folder }
$env:APPDATA = $appPath
$env:LOCALAPPDATA = $localPath
$env:NOTT_SEM_NEVOA = ''
$profilePath = Join-Path $sessionPath 'synthetic-profile.json'
'{}' | Set-Content -Encoding ascii -LiteralPath $profilePath
$config = Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'project.godot')
$custom = [regex]::Match($config,'(?m)^config/custom_user_dir_name="([^"]+)"').Groups[1].Value
if (-not $custom) { throw 'Missing custom user dir setting' }
$probeProject = "config_version=5`n[application]`nconfig/name=`"IsolationProbe`"`nconfig/use_custom_user_dir=true`nconfig/custom_user_dir_name=`"$custom`"`n"
$probeProject | Set-Content -Encoding ascii -LiteralPath (Join-Path $probePath 'project.godot')
@'
extends SceneTree
func _init() -> void:
 print("ISOLATED_USER_DIR=" + OS.get_user_data_dir())
 quit()
'@ | Set-Content -Encoding ascii -LiteralPath (Join-Path $probePath 'probe.gd')
$godotPath = 'D:\Godot\godot.exe'
function Invoke-IsolatedGodot([string[]]$GodotArgs, [string]$LogName) {
 $log = Join-Path $sessionPath $LogName
 $previous = $ErrorActionPreference
 $ErrorActionPreference = 'Continue'
 & rtk proxy $godotPath @GodotArgs *> $log
 $code = $LASTEXITCODE
 $ErrorActionPreference = $previous
 return @{code=$code;log=$log;body=(Get-Content -Raw -LiteralPath $log)}
}
$probe = Invoke-IsolatedGodot @('--headless','--path',$probePath,'-s','probe.gd') 'isolation.log'
if ($probe.code -ne 0) { throw ('Probe failed, exit ' + $probe.code + ': ' + $probe.body) }
$userDir = [regex]::Match($probe.body,'ISOLATED_USER_DIR=([^\r\n]+)').Groups[1].Value.Trim()
if (-not $userDir -or -not ([IO.Path]::GetFullPath($userDir).StartsWith([IO.Path]::GetFullPath($sessionPath) + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase))) { throw ('Isolation rejected: ' + $userDir) }
$preparation = Invoke-IsolatedGodot @('--headless','--editor','--import','--path',$taskRoot,'--','--controller-profile',$profilePath) 'import.log'
if ($preparation.code -ne 0 -or $preparation.body -match 'SCRIPT ERROR:|Parse Error:') { Write-Output $preparation.body; throw 'Import failed' }
$results = @()
if ($Metrics) {
 $result = Invoke-IsolatedGodot @('--headless','--quit-after','1200','--path',$taskRoot,'--log-file',(Join-Path $sessionPath 'metrics-engine.log'),'-s','.atena/generated/root-navigation-20261017/metrics.gd','--','--controller-profile',$profilePath,'--capture-dir',$sessionPath) 'metrics.log'
 Write-Output $result.body
 Write-Output ('SESSION=' + $sessionPath)
 if ($result.code -ne 0 -or $result.body -match 'ERROR:') {exit 1}
 exit 0
}
if ($ReviewCatalogContracts) { $Tests = @('test_stage_story','test_stage_structures','test_game_design','test_audio','test_chronicles','test_ground_decals','test_fog_edge','test_data','test_map_objectives') }
if ($RenderAudit) {$Smoke = $true}
if ($Smoke) {
 $smokeArguments = @('--path',$taskRoot,'--resolution','1280x720','--position','-10000,-10000','--quit-after','1200','--log-file',(Join-Path $sessionPath 'smoke-engine.log'),'-s','.atena/generated/domwieck-art-20261017/capture-threats.gd','--','--controller-profile',$profilePath,'--capture-dir',$sessionPath)
 if ($RenderAudit) { $smokeArguments = @('--path',$taskRoot,'--resolution','1280x720','--position','-10000,-10000','--quit-after','3600','--log-file',(Join-Path $sessionPath 'smoke-engine.log'),'-s','.atena/generated/domwieck-art-20261017/render-audit.gd','--','--controller-profile',$profilePath,'--capture-dir',$sessionPath) }
 $process = Start-Process -FilePath $godotPath -ArgumentList $smokeArguments -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput (Join-Path $sessionPath 'smoke.log') -RedirectStandardError (Join-Path $sessionPath 'smoke-error.log')
 Write-Output ('SMOKE_EXIT=' + $process.ExitCode)
 Write-Output ('SESSION=' + $sessionPath)
 Get-Content -LiteralPath (Join-Path $sessionPath 'smoke.log') -Tail 20
 Get-Content -LiteralPath (Join-Path $sessionPath 'smoke-error.log') -Tail 25
 if ($process.ExitCode -ne 0 -or -not (Test-Path -LiteralPath (Join-Path $sessionPath 'smoke-result.json'))) {exit 1}
 $report = Get-Content -Raw -LiteralPath (Join-Path $sessionPath 'smoke-result.json') | ConvertFrom-Json
 $errors = Get-Content -Raw -LiteralPath (Join-Path $sessionPath 'smoke-error.log')
 if ($report.failures.Count -gt 0 -or $errors -match 'ERROR:|SCRIPT ERROR:|Parse Error:') {exit 1}
 exit 0
}
foreach ($testName in $Tests) {
 $runner = if ($testName -eq 'test_battle') {'.atena/generated/root-navigation-20261017/run-regression.gd'} else {'tools/run_one_test.gd'}
 $result = Invoke-IsolatedGodot @('--headless','--quit-after','1200','--path',$taskRoot,'--log-file',(Join-Path $sessionPath ($testName + '-engine.log')),'-s',$runner,'--','--controller-profile',$profilePath,$testName) ($testName + '.log')
 $passed = $result.code -eq 0 -and $result.body -match ($testName + ': 0 falha') -and $result.body -notmatch 'ERROR:|SCRIPT ERROR:|Parse Error:|FALHA '
 $results += @{test=$testName;exit_code=$result.code;passed=$passed;log=$result.log}
 Write-Output ($testName + ': ' + $(if ($passed) {'PASS'} else {'FAIL'}))
 if (-not $passed) { Write-Output $result.body; if (-not $ReviewCatalogContracts) { break } }
}
@{session=$sessionPath;user_data_dir=$userDir;profile=$profilePath;results=$results} | ConvertTo-Json -Depth 8 | Set-Content -Encoding utf8 -LiteralPath (Join-Path $sessionPath 'results.json')
Write-Output ('SESSION=' + $sessionPath)
if (@($results | Where-Object {-not $_.passed}).Count) { exit 1 }
