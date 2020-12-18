@echo off
chcp 65001 >nul 2>nul
cd /d %~dp0
if /i [%1]==[] goto usage

call %~dp0Steamless\Steamless_cmd.bat %1
if exist %1.unpacked.exe (goto move) else goto nomove
goto end

:move
move /Y %1 %1.bak >nul 2>nul
move /Y %1.unpacked.exe %1 >nul 2>nul

goto end

:nomove
echo Unpack failed!
goto end

:usage
echo Usage: AutoUnpackModule.bat Inputfile

:end
