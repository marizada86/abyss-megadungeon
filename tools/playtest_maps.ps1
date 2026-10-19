param(
 [ValidateSet('reino_abissal','domwieck','raiz_yggdrasil')][string]$Map,
 [switch]$VerifyLaunch
)
$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$godotPath = $null
foreach ($candidate in @($env:NOTTGARD_GODOT, (Join-Path $projectRoot 'Godot_v4.7.2-stable_win64.exe'), 'D:\Godot\godot.exe')) {
  if ($candidate -and (Test-Path -LiteralPath $candidate -PathType Leaf)) { $godotPath = $candidate; break }
}
if (-not $godotPath) { throw 'Godot nao encontrado: defina NOTTGARD_GODOT ou coloque Godot_v4.7.2-stable_win64.exe na raiz do projeto.' }
if ($VerifyLaunch -and -not $Map) { throw 'A verificacao precisa indicar um mapa.' }
$sessionRoot = Join-Path $projectRoot '.atena/generated/map-playtest-sessions'
$null = New-Item -ItemType Directory -Force -Path $sessionRoot
$sessionPath = Join-Path $sessionRoot ([DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-fff') + '-' + [Guid]::NewGuid().ToString('N').Substring(0,8))
$null = New-Item -ItemType Directory -Path $sessionPath
$env:APPDATA = Join-Path $sessionPath 'appdata'
$env:LOCALAPPDATA = Join-Path $sessionPath 'localappdata'
$probePath = Join-Path $sessionPath 'probe'
foreach ($folder in @($env:APPDATA,$env:LOCALAPPDATA,$probePath)) { $null = New-Item -ItemType Directory -Path $folder }
$profilePath = Join-Path $sessionPath 'profile-sintetico.json'
'{}' | Set-Content -Encoding ascii -LiteralPath $profilePath
$source = Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'project.godot')
$userDirName = [regex]::Match($source,'(?m)^config/custom_user_dir_name="([^"]+)"').Groups[1].Value
if (-not $userDirName -or $source -notmatch '(?m)^config/use_custom_user_dir=true') { throw 'Configuracao de isolamento inesperada. Jogo nao iniciado.' }
"config_version=5`n[application]`nconfig/name=`"MapPlaytestIsolation`"`nconfig/use_custom_user_dir=true`nconfig/custom_user_dir_name=`"$userDirName`"`n" | Set-Content -Encoding ascii -LiteralPath (Join-Path $probePath 'project.godot')
@'
extends SceneTree
func _init() -> void:
 print("ISOLATED_USER_DIR=" + OS.get_user_data_dir())
 quit()
'@ | Set-Content -Encoding ascii -LiteralPath (Join-Path $probePath 'probe.gd')
function Start-GodotProcess([string[]]$Arguments, [string]$Prefix, [bool]$Hidden) {
 $quoted = ($Arguments | ForEach-Object { '"' + $_ + '"' }) -join ' '
 $options = @{FilePath=$godotPath;ArgumentList=$quoted;Wait=$true;PassThru=$true;RedirectStandardOutput=(Join-Path $sessionPath ($Prefix + '.log'));RedirectStandardError=(Join-Path $sessionPath ($Prefix + '-errors.log'))}
 if ($Hidden) { $options.WindowStyle = 'Hidden' }
 return Start-Process @options
}
$probe = Start-GodotProcess @('--headless','--path',$probePath,'-s','probe.gd') 'isolation' $true
$probeOutput = Get-Content -Raw -LiteralPath (Join-Path $sessionPath 'isolation.log')
$resolvedDir = [regex]::Match($probeOutput,'ISOLATED_USER_DIR=([^\r\n]+)').Groups[1].Value.Trim()
$boundary = [IO.Path]::GetFullPath($sessionPath) + [IO.Path]::DirectorySeparatorChar
if ($probe.ExitCode -ne 0 -or -not $resolvedDir -or -not ([IO.Path]::GetFullPath($resolvedDir).StartsWith($boundary,[StringComparison]::OrdinalIgnoreCase))) { throw 'Isolamento nao confirmado. Jogo nao iniciado.' }
# Source-only launches need Godot's class index refreshed after new scripts arrive.
Write-Output 'Preparando os arquivos locais do jogo...'
$import = Start-GodotProcess @('--headless','--editor','--import','--path',$projectRoot,'--log-file',(Join-Path $sessionPath 'preparation-engine.log'),'--','--controller-profile',$profilePath) 'preparation' $true
if ($import.ExitCode -ne 0) { throw ('Nao foi possivel preparar o jogo. Registro: ' + (Join-Path $sessionPath 'preparation-engine.log')) }
$preparationLog = Get-Content -Raw -LiteralPath (Join-Path $sessionPath 'preparation-engine.log')
if ($preparationLog -match 'SCRIPT ERROR:|Parse Error:') { throw ('O jogo tem um erro de carregamento. Registro: ' + (Join-Path $sessionPath 'preparation-engine.log')) }
$arguments = @('--path',$projectRoot,'--resolution','1280x720','--log-file',(Join-Path $sessionPath 'engine.log'),'-s','tools/playtest_maps.gd','--','--controller-profile',$profilePath,'--map-session',$sessionPath)
if ($Map) { $arguments += @('--map',$Map) }
if ($VerifyLaunch) { $arguments = @('--position','-10000,-10000','--quit-after','1200') + $arguments; $arguments += '--verify-launch' }
Write-Output 'Abrindo teste dos mapas com dados separados...'
$process = Start-GodotProcess $arguments 'playtest' $VerifyLaunch.IsPresent
if ($process.ExitCode -ne 0) { throw ('Falha ao abrir o teste. Registro: ' + (Join-Path $sessionPath 'engine.log')) }
if ($VerifyLaunch) {
 $reportPath = Join-Path $sessionPath 'launch-verification.json'
 $errors = @((Get-Content -Raw -LiteralPath (Join-Path $sessionPath 'playtest-errors.log')),(Get-Content -Raw -LiteralPath (Join-Path $sessionPath 'engine.log'))) -join "`n"
 # Mensagens de encerramento do motor (texturas GL/RIDs vazados ao fechar a janela) sao ruido registrado (DEBT-PORT-009), nunca erro de jogo.
 $teardown = '(leaked|RenderingServer::get_singleton\(\)" is null|still in use at exit|^\s+at:)'
 $relevant = @($errors -split "`r?`n" | Where-Object { $_ -notmatch $teardown }) -join "`n"
 $ignored = @($errors -split "`r?`n" | Where-Object { $_ -match 'ERROR:' -and $_ -match $teardown }).Count
 if ($ignored -gt 0) { Write-Output ('Aviso: ' + $ignored + ' mensagem(ns) de encerramento do motor ignorada(s).') }
 if (-not (Test-Path -LiteralPath $reportPath) -or $relevant -match 'SCRIPT ERROR:|ERROR:') { throw ('Verificacao falhou: ' + $sessionPath) }
 $report = Get-Content -Raw -LiteralPath $reportPath | ConvertFrom-Json
 if ($report.failures.Count -gt 0) { throw ('Verificacao falhou: ' + ($report.failures -join ', ')) }
 Write-Output ('PASS ' + $Map + ' SESSION=' + $sessionPath)
}
