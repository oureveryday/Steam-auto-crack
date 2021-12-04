::---------------------------------------------------------------
::                Steam Auto Crack V1.2.0
::      Automatic Steam Game Cracker Crack Apply Module
:: Github: https://github.com/oureveryday/Steam-auto-crack
:: Gitlab: https://gitlab.com/oureveryday/Steam-auto-crack
::---------------------------------------------------------------

::------------------Init---------------------
@echo off
color F1
set "_null=1>nul 2>nul"
set "Ver=V1.2.0"
chcp 65001 %_null%
title  Steam Auto Crack: Apply Crack %Ver%
setlocal EnableDelayedExpansion
setlocal Enableextensions
cd /d %~dp0
cls

::----------Auto Unpack Find (Unpack + Backup)----------
:AutoUnpackFind
set "Info=Auto find and Unpack SteamStub (Unpack + Backup)"
call :MenuInfo
echo Press any key to Apply Crack...
pause
FOR /R "%~dp0" %%i IN (*.exe) DO (
echo --------
set unppath=%%i
echo Found "!unppath!" , Unpacking......
"%~dp0Steamless\Steamless.CLI.exe" "!unppath!" %_null%
if !errorlevel! EQU 1 echo Unpack error. File not Packed or Packed by Other Packer/Protector.
if !errorlevel! EQU 0 (
echo Unpack successful, backuping...... 
move /Y "!unppath!" "!unppath!.bak" %_null%
move /Y "!unppath!.unpacked.exe" "!unppath!" %_null%
echo File backuped.
)
)
echo All file Unpacked.
echo Crack Applied Successfully.
)
pause
rd /s /q "Steamless"
del /f /s /q "Apply_Crack.cmd" & exit

::--------------------Info------------------------
:MenuInfo
cls
echo ---------------------------------------------
echo ---------- Steam Auto Crack %Ver% ------------
echo ---------------------------------------------
echo.
echo ---------------%Info%---------------------
goto :eof





