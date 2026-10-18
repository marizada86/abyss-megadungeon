@echo off
setlocal
python "%~dp0review.py"
if errorlevel 1 pause
