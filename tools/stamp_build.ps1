# Carimba a build: grava data/build_info.json (ignorado pelo Git) com o hash curto do commit, lido por Version.build_id().
# Rodar antes de exportar; remover depois com -Clear para que execuções locais voltem a mostrar "dev".
# Uso: powershell -File tools/stamp_build.ps1 [-Clear]
param([switch]$Clear)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$target = Join-Path $root "data/build_info.json"
if ($Clear) {
    if (Test-Path $target) { Remove-Item $target }
    Write-Output "build_info.json removido"
    exit 0
}
$commit = (git -C $root rev-parse --short=8 HEAD).Trim()
if (-not $commit) { throw "git rev-parse falhou" }
# Alterações em arquivos rastreados tornam o build não reproduzível a partir do commit: marca o ID.
$dirty = (git -C $root status --porcelain --untracked-files=no | Measure-Object).Count -gt 0
if ($dirty) { $commit = "$commit-dirty" }
$info = [ordered]@{
    commit  = $commit
    version = ((Select-String -Path (Join-Path $root "core/version.gd") -Pattern '^const VERSION := "(.+)"').Matches[0].Groups[1].Value)
    stamped = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
}
[System.IO.File]::WriteAllText($target, ($info | ConvertTo-Json) + "`n", (New-Object System.Text.UTF8Encoding($false)))
Write-Output "build_info.json: $commit"
