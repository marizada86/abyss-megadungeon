$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$session = Join-Path $PSScriptRoot ('synthetic-' + [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss'))
$null = New-Item -ItemType Directory -Path $session
foreach ($folder in @('appdata', 'localappdata', 'probe')) {
    $null = New-Item -ItemType Directory -Path (Join-Path $session $folder)
}
$config = Get-Content -LiteralPath (Join-Path $root 'project.godot') -Raw
$custom = [regex]::Match($config, '(?m)^config/custom_user_dir_name="([^"]+)"').Groups[1].Value
if (!$custom) { throw 'Missing custom user directory contract' }
$probeProject = "config_version=5`n[application]`nconfig/name=`"UIIsolationProbe`"`nconfig/use_custom_user_dir=true`nconfig/custom_user_dir_name=`"$custom`"`n"
[IO.File]::WriteAllText((Join-Path $session 'probe/project.godot'), $probeProject)
[IO.File]::WriteAllText((Join-Path $session 'probe/probe.gd'), "extends SceneTree`nfunc _init() -> void:`n print(`"ISOLATED_USER_DIR=`"+OS.get_user_data_dir())`n quit()`n")
$profile = Join-Path $session 'synthetic-profile.json'
[IO.File]::WriteAllText($profile, '{}')
function Invoke-Godot([string]$Name, [string[]]$Arguments, [int]$Timeout = 180000) {
    $info = [Diagnostics.ProcessStartInfo]::new()
    $info.FileName = Join-Path $root 'Godot_v4.7.2-stable_win64.exe'
    $info.WorkingDirectory = $root
    $info.UseShellExecute = $false
    $info.CreateNoWindow = $true
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $info.Environment['APPDATA'] = Join-Path $session 'appdata'
    $info.Environment['LOCALAPPDATA'] = Join-Path $session 'localappdata'
    foreach ($argument in $Arguments) { $info.ArgumentList.Add($argument) }
    $process = [Diagnostics.Process]::Start($info)
    $stdout = $process.StandardOutput.ReadToEndAsync()
    $stderr = $process.StandardError.ReadToEndAsync()
    if (!$process.WaitForExit($Timeout)) { $process.Kill($true); throw "Timeout: $Name" }
    $output = $stdout.GetAwaiter().GetResult() + $stderr.GetAwaiter().GetResult()
    [IO.File]::WriteAllText((Join-Path $session ($Name + '.log')), $output)
    return @{ exit_code = $process.ExitCode; output = $output }
}
$probe = Invoke-Godot 'probe' @('--headless', '--path', (Join-Path $session 'probe'), '-s', 'probe.gd')
$match = [regex]::Match($probe.output, 'ISOLATED_USER_DIR=([^\r\n]+)')
if ($probe.exit_code -ne 0 -or !$match.Success) { throw 'Isolation probe failed' }
$userDirectory = [IO.Path]::GetFullPath($match.Groups[1].Value.Trim())
if (!$userDirectory.StartsWith($session + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'User directory escaped synthetic session; main project not launched'
}
Write-Output 'PASS: isolated user directory verified before project launch'
$results = @()
foreach ($test in @('test_offer_cards', 'test_offer_keyboard', 'test_ability_hud', 'test_controller_experience')) {
    $run = Invoke-Godot $test @('--headless', '--path', $root, '-s', 'tools/run_one_test.gd', '--', '--controller-profile', $profile, $test)
    $passed = $run.exit_code -eq 0 -and $run.output -match ([regex]::Escape($test) + ': 0 falha') -and $run.output -notmatch 'SCRIPT ERROR:|Parse Error:|FALHA |ERROR:'
    $assertionsPassed = $run.exit_code -eq 0 -and $run.output -match ([regex]::Escape($test) + ': 0 falha') -and $run.output -notmatch 'SCRIPT ERROR:|Parse Error:|FALHA '
    $results += @{ test = $test; passed = $passed; assertions_passed = $assertionsPassed; certificate_store_error = ($run.output -match 'Failed to read the root certificate store'); exit_code = $run.exit_code }
    Write-Output "$test : $passed"
}
$audit = Invoke-Godot 'audit_projeto' @('--headless', '--path', $root, '-s', 'tools/audit_projeto.gd') 600000
$results += @{ test = 'audit_projeto'; passed = ($audit.exit_code -eq 0 -and $audit.output -match 'RESUMO;erros=0;' -and $audit.output -notmatch 'SCRIPT ERROR:|Parse Error:|ERROR:'); assertions_passed = ($audit.exit_code -eq 0 -and $audit.output -match 'RESUMO;erros=0;' -and $audit.output -notmatch 'SCRIPT ERROR:|Parse Error:'); certificate_store_error = ($audit.output -match 'Failed to read the root certificate store'); exit_code = $audit.exit_code }
$report = [ordered]@{ session = $session; user_data_dir = $userDirectory; runtime_modified = $false; results = $results }
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'baseline.json'), ($report | ConvertTo-Json -Depth 5))
$results | Format-Table -AutoSize
Write-Output "SESSION=$session"
if (@($results | Where-Object { !$_.passed }).Count) { exit 1 }
