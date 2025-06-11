@echo off
:: Проверка на запуск от администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Запуск требует прав администратора. Перезапуск...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Включаем расширение переменных в цикле
setlocal EnableDelayedExpansion

:: Устанавливаем рабочую директорию скрипта
set "SCRIPT_DIR=%~dp0"
set "PACKAGES_DIR=%SCRIPT_DIR%Packages"
set "SCRIPT_PATH=%SCRIPT_DIR%install-apps.ps1"

:: Собираем все txt-файлы в строку
set "FILES="

for %%F in ("%PACKAGES_DIR%\*.txt") do (
    set "FILES=!FILES! %%~fF"
)

:: Запуск PowerShell скрипта с bypass и файлами
powershell -ExecutionPolicy Bypass -File "!SCRIPT_PATH!" -PackageFilePaths "!FILES!"

pause
