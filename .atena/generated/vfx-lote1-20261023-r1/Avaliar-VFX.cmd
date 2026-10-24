@echo off
cd /d "%~dp0../../.."
powershell -NoProfile -ExecutionPolicy Bypass -File "tools/vfx_lote1_render.ps1" -Interactive
