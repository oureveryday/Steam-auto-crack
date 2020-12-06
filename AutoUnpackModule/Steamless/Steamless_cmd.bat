@echo off
cd /d %~dp0
del /f /s /q %~dp0input.txt >nul 2>nul
if /i [%1]==[] goto usage

set /p =%1<nul >input.txt
start /MIN /WAIT "" "%~dp0steamless.exe" 
del /f /s /q %~dp0input.txt >nul 2>nul
goto end

:usage
echo Usage: Steamless_cmd.bat Inputfile

:end
