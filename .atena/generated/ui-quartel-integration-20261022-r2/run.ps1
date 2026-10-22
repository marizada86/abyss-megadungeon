param([string]$Mode = "before")
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
if ($Mode -eq 'before-offers') {
    $run = Invoke-Godot $Mode @('--path', $root, '--position', '-10000,-10000', '--resolution', '1280x720', '-s', (Join-Path $PSScriptRoot 'capture.gd'), '--', '--controller-profile', $profile, '--capture-dir', $session, '--baseline-offers') 180000
    Write-Output $run.output
} elseif ($Mode -in @('before','after')) {
    $run = Invoke-Godot $Mode @('--path', $root, '--position', '-10000,-10000', '--resolution', '1280x720', '-s', (Join-Path $PSScriptRoot 'capture.gd'), '--', '--controller-profile', $profile, '--capture-dir', $session) 180000
    Write-Output $run.output
} elseif ($Mode -eq 'import') {
    $run = Invoke-Godot $Mode @('--headless','--editor','--import','--path',$root,'--','--controller-profile',$profile) 300000
    Write-Output $run.output
} elseif ($Mode -eq 'interaction') {
    $run = Invoke-Godot $Mode @('--headless','--path',$root,'-s',(Join-Path $PSScriptRoot 'interaction.gd'),'--','--controller-profile',$profile) 60000
    Write-Output $run.output
} elseif ($Mode -eq 'full') {
    $run = Invoke-Godot 'suite' @('--headless','--path',$root,'-s','tests/run_all.gd','--','--controller-profile',$profile) 1800000
    Write-Output $run.output
    $audit = Invoke-Godot 'audit' @('--headless','--path',$root,'-s','tools/audit_projeto.gd','--','--controller-profile',$profile) 600000
    Write-Output $audit.output
} elseif ($Mode -eq 'controller') {
    $run = Invoke-Godot 'controller' @('--headless','--path',$root,'tools/controller_check.tscn','--','--controller-profile',$profile) 270000
    Write-Output $run.output
} else {
    $run = Invoke-Godot $Mode @('--headless','--path',$root,'-s','tools/run_one_test.gd','--','--controller-profile',$profile,$Mode) 180000
    Write-Output $run.output
}
Write-Output "SESSION=$session"
if ($run.exit_code -ne 0 -or $run.output -match 'SCRIPT ERROR:|Parse Error:|FALHA ') { exit 1 }
if ($Mode -in @('before','after') -and $run.output -notmatch 'CAPTURES_PASS=14') { exit 1 }
if ($Mode -eq 'before-offers' -and ($run.output -notmatch 'CAPTURES_PASS=4' -or $run.output -match 'Resource file not found:')) { exit 1 }
