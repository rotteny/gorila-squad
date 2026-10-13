@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0ATUALIZAR-FONTES.ps1"
echo.
pause
