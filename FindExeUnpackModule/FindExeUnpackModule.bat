@echo off
setlocal enabledelayedexpansion
cd /d %~dp0
if /i [%1]==[] goto usage

call %~dp0..\FileFinderModule\FileFinderModule.bat %1 *.exe
for /f "tokens=1* delims=" %%i in (%~dp0..\Temp\Foundfile.txt) do (
    setlocal enabledelayedexpansion
    set d="%%i%%j"
    echo Found !d!,Unpacking......
    call %~dp0..\AutoUnpackModule\AutoUnpackModule.bat !d!
)

del /f /s /q %~dp0..\Temp\Foundfile.txt >nul 2>nul

goto end

:usage
echo Usage: FindExeUnpack.bat Folder

:end
