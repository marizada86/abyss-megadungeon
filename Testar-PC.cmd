@echo off
setlocal
if not exist "%~dp0.atena\generated\review-profile" mkdir "%~dp0.atena\generated\review-profile"
"%~dp0build\NottgardSurvivors-Playtest.exe" -- --controller-profile "%~dp0.atena\generated\review-profile\profile.json"
