@echo off
chcp 65001 >nul 2>nul
setlocal enabledelayedexpansion
cd /d %~dp0
if /i [%1]==[] goto usage
echo Fiding folder %1......

call %~dp0..\FileFinderModule\FileFinderModule.bat %1 steam_api64.dll

for /f "tokens=1* delims=" %%i in (%~dp0..\Temp\Foundfile.txt) do (
    setlocal enabledelayedexpansion
    set a="%%i%%j"
    echo Found !a!,Applying......
    move /Y !a! !a!.bak >nul 2>nul
    copy %~dp0..\Goldberg\steam_api64.dll !a! >nul 2>nul
    echo copy config to %%~dpi......
    cd /d %~dp0
    xcopy %~dp0..\Temp\steam_settings\ "%%~dpi\steam_settings\" /E /C /Q /H /R /Y >nul 2>nul
)
::del /f /s /q %~dp0..\Temp\Foundfile.txt >nul 2>nul

call %~dp0..\FileFinderModule\FileFinderModule.bat %1 steam_api.dll
for /f "tokens=1* delims=" %%i in (%~dp0..\Temp\Foundfile.txt) do (
    setlocal enabledelayedexpansion
    set a="%%i%%j"
    echo Found !a!,Applying......
    move /Y !a! !a!.bak >nul 2>nul
    copy %~dp0..\Goldberg\steam_api.dll !a! >nul 2>nul
    echo copy config to %%~dpi......
    cd /d %~dp0
    xcopy %~dp0..\Temp\steam_settings\ %%~dpi\steam_settings\ /E /C /Q /H /R /Y >nul 2>nul
)
::del /f /s /q %~dp0..\Temp\Foundfile.txt >nul 2>nul

goto end
:usage
echo Usage: FindExeUnpack.bat Folder

:end
