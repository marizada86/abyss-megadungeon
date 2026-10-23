$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
Set-Location -LiteralPath $root
$alreadyStaged = @(git diff --cached --name-only)
if ($LASTEXITCODE -ne 0 -or $alreadyStaged.Count) { throw 'Index must be empty before the selective commit' }
$manifest = Get-Content (Join-Path $PSScriptRoot 'admission.json') -Raw | ConvertFrom-Json
foreach ($file in $manifest.runtime_files) {
    if ((Get-FileHash -LiteralPath $file.file).Hash -ne $file.after_sha256) { throw "Runtime changed since validation: $($file.file)" }
}
$files = @(Get-Content (Join-Path $PSScriptRoot 'commit-files.json') -Raw | ConvertFrom-Json)
git add --force -- @files
if ($LASTEXITCODE -ne 0) { throw 'Cannot stage integration files' }
$blob = git hash-object -w --path=.atena/state/plan.yaml -- tmp/ui-quartel-commit-state-20261022.yaml
if ($LASTEXITCODE -ne 0) { throw 'Cannot prepare selective plan state' }
git update-index --add --cacheinfo "100644,$blob,.atena/state/plan.yaml"
if ($LASTEXITCODE -ne 0) { throw 'Cannot stage selective plan state' }
$expected = @($files + '.atena/state/plan.yaml' | Sort-Object -Unique)
$actual = @(git diff --cached --name-only | Sort-Object -Unique)
if (@(Compare-Object $expected $actual).Count) { throw 'Staged paths differ from the authorized manifest' }
git diff --cached --check
if ($LASTEXITCODE -ne 0) { throw 'Staged whitespace validation failed' }
$parent = git rev-parse HEAD
git commit -m 'Complete HUD and Quartel art integration'
if ($LASTEXITCODE -ne 0) { throw 'Local commit failed' }
$commit = git rev-parse HEAD
$receipt = [ordered]@{
    authorization = 'atena commite e  tem algo para ser gerado?'
    scope = 'UI/HUD and Quartel r2 only; selective own plan section and referenced evidence'
    commit = $commit; parent = $parent; files = $actual; pushed = $false
    human_screen_acceptance = 'PENDING'; unrelated_work_preserved = $true
}
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'commit-result.json'), ($receipt | ConvertTo-Json -Depth 4))
git show --stat --oneline HEAD
