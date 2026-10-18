@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\playtest_maps.ps1"
if errorlevel 1 (
  echo Nao foi possivel abrir o teste dos mapas. Confira a mensagem acima.
  pause
)
