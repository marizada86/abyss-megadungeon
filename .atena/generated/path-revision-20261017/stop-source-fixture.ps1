$ErrorActionPreference='Stop'
$targets=Get-CimInstance Win32_Process -Filter "Name='godot.exe'" | Where-Object {$_.CommandLine -like '*origin-candidate*' -and $_.CommandLine -like '*tools/run_one_test.gd*' -and $_.CommandLine -like '*test_root_art*'}
foreach($target in $targets){Stop-Process -Id $target.ProcessId;Write-Output ('Stopped owned missing-fixture test PID '+$target.ProcessId)}
