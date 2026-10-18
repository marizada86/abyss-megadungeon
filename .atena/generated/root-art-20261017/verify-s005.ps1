$ErrorActionPreference = 'Stop'
$projectRoot = (Get-Location).Path
$started = (Get-Content -Raw -LiteralPath '.atena/generated/root-art-20261017/s005-start.json' | ConvertFrom-Json).started_utc
$session = Get-ChildItem -LiteralPath '.atena/generated/map-playtest-sessions' -Directory | Where-Object { $_.CreationTimeUtc -ge [DateTime]::Parse($started).ToUniversalTime().AddSeconds(-2) } | Sort-Object CreationTimeUtc -Descending | Select-Object -First 1
if (-not $session) { throw 'No new playtest session' }
$processes = @(Get-CimInstance Win32_Process -Filter "Name='godot.exe'" | Where-Object { $_.CommandLine -like '*tools/playtest_maps.gd*' -and $_.CommandLine.Contains($session.FullName) })
$windows = @($processes | ForEach-Object { $p = Get-Process -Id $_.ProcessId; [ordered]@{pid=$p.Id;title=$p.MainWindowTitle;window_handle=$p.MainWindowHandle.ToInt64();responding=$p.Responding} })
$isolation = [string](Get-Content -Raw -LiteralPath (Join-Path $session.FullName 'isolation.log'))
$userDir = [IO.Path]::GetFullPath([regex]::Match($isolation,'ISOLATED_USER_DIR=([^\r\n]+)').Groups[1].Value.Trim())
$errors = @()
foreach ($name in @('engine.log','playtest-errors.log','preparation-engine.log')) {
 $path = Join-Path $session.FullName $name
 if (Test-Path -LiteralPath $path) { $errors += @(Select-String -LiteralPath $path -Pattern 'SCRIPT ERROR:|ERROR:|Parse Error:' | ForEach-Object { $_.Line }) }
}
$report = [ordered]@{stage='S-RART-005';verified_utc=[DateTime]::UtcNow.ToString('o');session=$session.FullName;map='reino_abissal';user_dir=$userDir;isolated=$userDir.StartsWith($session.FullName,[StringComparison]::OrdinalIgnoreCase);windows=$windows;errors=$errors;owner_visual_acceptance='PENDING'}
$report | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 -LiteralPath '.atena/generated/root-art-20261017/s005-launch.json'
$report | ConvertTo-Json -Depth 5
if (-not $report.isolated -or $errors.Count -gt 0 -or -not @($windows | Where-Object { $_.window_handle -ne 0 -and $_.responding }).Count) { throw 'Launch verification failed' }
