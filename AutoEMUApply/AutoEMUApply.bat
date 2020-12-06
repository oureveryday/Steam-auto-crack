@echo off
cd /d %~dp0
if /i [%1]==[] goto usage
echo Searching folder %1......

if exist %1\steam_api64.dll (goto api64)

:detect
if exist %1\steam_api.dll (goto api)
goto end

:api64
echo steam_api64.dll found.
move /Y %1\steam_api64.dll %1\steam_api64.dll.bak >nul 2>nul
copy %~dp0Goldberg\steam_api64.dll %1\steam_api64.dll >nul 2>nul
xcopy %~dp0..\Temp\steam_settings\ %1\steam_settings\ /E /C /Q /H /R /Y >nul 2>nul
goto detect

:api
echo steam_api.dll found.
move /Y %1\steam_api.dll %1\steam_api.dll.bak >nul 2>nul
copy %~dp0Goldberg\steam_api.dll %1\steam_api.dll >nul 2>nul
xcopy %~dp0..\Temp\steam_settings\ %1\steam_settings\ /E /C /Q /H /R /Y >nul 2>nul

goto end

:usage
echo Usage: AutoEMUApply.bat SteamAPIFolder

:end
