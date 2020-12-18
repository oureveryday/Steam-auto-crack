@echo off
chcp 65001 >nul 2>nul
cd /d %~dp0
del /f /s /q "%~dp0..\Temp\steam_settings" >nul 2>nul
mkdir %~dp0..\Temp\steam_settings >nul 2>nul
if /i [%1]==[] goto usage
if /i [%2]==[] goto noapi

goto api
goto end

:noapi
start /MIN /WAIT "" "%~dp0bin\generate_game_info_noapi.exe" "%1" "%~dp0..\Temp\steam_settings" 
goto end 

:api
start /MIN /WAIT "" "%~dp0bin\generate_game_info.exe" "%1" "%2" "%~dp0..\Temp\steam_settings" 
goto end



:usage
echo Usage: AutoEMUConfigModule.bat appid [Steam API key]


:end
