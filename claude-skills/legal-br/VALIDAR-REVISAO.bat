@echo off
REM Valida a parte mecanica de um documento revisado pela skill legal-br.
REM Uso: VALIDAR-REVISAO.bat <arquivo-REVISADO.md> [arquivo-original.md]

setlocal

if "%~1"=="" (
    echo.
    echo Uso: VALIDAR-REVISAO.bat ^<arquivo-REVISADO.md^> [arquivo-original.md]
    echo.
    echo Exemplo:
    echo   VALIDAR-REVISAO.bat termos-REVISADO-2026-08-21.md termos.md
    echo.
    exit /b 2
)

if "%~2"=="" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0VALIDAR-REVISAO.ps1" -Arquivo "%~f1"
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0VALIDAR-REVISAO.ps1" -Arquivo "%~f1" -Original "%~f2"
)

exit /b %ERRORLEVEL%
