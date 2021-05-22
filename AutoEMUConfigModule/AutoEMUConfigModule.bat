@echo off
chcp 65001 >nul 2>nul
cd /d %~dp0
del /f /s /q "%~dp0..\Temp\steam_settings" >nul 2>nul
mkdir %~dp0..\Temp\steam_settings >nul 2>nul
if /i [%1]==[] goto usage
if /i [%2]==[(Empty)] goto noapi
goto api
goto end

:api
"%~dp0bin\generate_game_infos.exe" "%1" -s "%2" -o "%~dp0..\Temp\steam_settings" %3 /WAIT /B
goto end

:noapi
"%~dp0bin\generate_game_infos.exe" "%1" -o "%~dp0..\Temp\steam_settings" %3 /WAIT /B
goto end

:usage
echo Usage: AutoEMUConfigModule.bat appid [Steam API key] <-p>


:end
