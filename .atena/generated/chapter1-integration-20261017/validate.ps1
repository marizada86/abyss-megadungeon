param([string[]]$Tests = @('test_chapter_flow','test_hqs','test_profile','test_save_resilience','test_data','test_map_objectives','test_scripts_compile','test_stage_story','test_stage_structures','test_map_scale','test_terrain','test_reach_grid','test_battle','test_qa_sandbox','test_playtest','test_catalog'), [switch]$Smoke, [switch]$ReviewCatalogContracts, [switch]$Regression)
$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
$sessionPath = Join-Path $PSScriptRoot ('s004-validation-' + [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-fff'))
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
$results = @()
$import = Invoke-IsolatedGodot @('--headless','--editor','--import','--path',$taskRoot,'--log-file',(Join-Path $sessionPath 'import-engine.log')) 'import.log'
if ($import.code -ne 0 -or $import.body -match 'SCRIPT ERROR:|Parse Error:') { Write-Output $import.body; exit 1 }
if ($ReviewCatalogContracts) { $Tests = @('test_stage_story','test_stage_structures','test_game_design','test_audio','test_chronicles','test_ground_decals','test_fog_edge','test_data','test_map_objectives') }
if ($Regression) {
 foreach ($phase in @('writer','reader')) {
  $result = Invoke-IsolatedGodot @('--headless','--verbose','--quit-after','2400','--path',$taskRoot,'--log-file',(Join-Path $sessionPath ($phase + '-engine.log')),'-s','.atena/generated/chapter1-integration-20261017/regression.gd','--','--controller-profile',$profilePath,'--capture-dir',$sessionPath,'--phase',$phase) ($phase + '.log')
  Write-Output ($phase + ': exit ' + $result.code)
  Write-Output (($result.body -split "`r?`n" | Select-Object -Last 8) -join "`n")
  $reportPath = Join-Path $sessionPath ('regression-' + $phase + '.json')
  if ($result.code -ne 0 -or $result.body -match 'SCRIPT ERROR:|Parse Error:|REGRESSION_FAIL|ERROR:' -or -not (Test-Path -LiteralPath $reportPath)) {Write-Output ('SESSION=' + $sessionPath); exit 1}
  $report = Get-Content -Raw -LiteralPath $reportPath | ConvertFrom-Json
  if ($report.failures.Count -gt 0) {Write-Output ('SESSION=' + $sessionPath); exit 1}
 }
 Write-Output ('SESSION=' + $sessionPath)
 exit 0
}
if ($Smoke) {
 $smokeArguments = @('--path',$taskRoot,'--resolution','1280x720','--position','-10000,-10000','--quit-after','1200','--log-file',(Join-Path $sessionPath 'smoke-engine.log'),'-s','.atena/generated/chapter1-integration-20261017/smoke.gd','--','--controller-profile',$profilePath,'--capture-dir',$sessionPath)
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
 $result = Invoke-IsolatedGodot @('--headless','--quit-after','1200','--path',$taskRoot,'--log-file',(Join-Path $sessionPath ($testName + '-engine.log')),'-s','tools/run_one_test.gd','--','--controller-profile',$profilePath,$testName) ($testName + '.log')
 $passed = $result.code -eq 0 -and $result.body -match ($testName + ': 0 falha') -and $result.body -notmatch 'SCRIPT ERROR:|Parse Error:|FALHA '
 $results += @{test=$testName;exit_code=$result.code;passed=$passed;log=$result.log}
 Write-Output ($testName + ': ' + $(if ($passed) {'PASS'} else {'FAIL'}))
 if (-not $passed) { Write-Output $result.body; if (-not $ReviewCatalogContracts) { break } }
}
@{session=$sessionPath;user_data_dir=$userDir;profile=$profilePath;results=$results} | ConvertTo-Json -Depth 8 | Set-Content -Encoding utf8 -LiteralPath (Join-Path $sessionPath 'results.json')
Write-Output ('SESSION=' + $sessionPath)
if (@($results | Where-Object {-not $_.passed}).Count) { exit 1 }
