$ErrorActionPreference='Stop'
$projectPath=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
$session=Get-ChildItem -LiteralPath (Join-Path $projectPath '.atena/generated/map-playtest-sessions') -Directory | Sort-Object Name -Descending | Select-Object -First 1
$process=Get-Process | Where-Object {$_.MainWindowTitle -like '*Nottgard*' -and $_.StartTime -ge $session.CreationTime} | Sort-Object StartTime -Descending | Select-Object -First 1
if(-not $process){throw 'Playtest process not found yet'}
if($process.MainWindowHandle -eq 0){throw 'Visible window not found yet'}
$probe=Get-Content -LiteralPath (Join-Path $session.FullName 'isolation.log') -Raw
$userDir=[regex]::Match($probe,'ISOLATED_USER_DIR=([^\r\n]+)').Groups[1].Value.Trim()
if(-not $userDir -or -not ([IO.Path]::GetFullPath($userDir).StartsWith($session.FullName+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase))){throw 'Isolation failed'}
foreach($name in @('engine.log','playtest-errors.log')){
 $body=Get-Content -LiteralPath (Join-Path $session.FullName $name) -Raw
 if($body -match 'SCRIPT ERROR:|ERROR:|Parse Error:'){throw ('Launch error '+$name)}
}
$report=@{session=$session.FullName;process_id=$process.Id;title=$process.MainWindowTitle;visible_window=$true;art_revision='r1';geometry_revision='r3';user_data_dir=$userDir;errors_at_check=@();human_feedback='PENDING'}
$report|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $PSScriptRoot 's005-window.json') -Encoding utf8
$report|ConvertTo-Json -Compress
