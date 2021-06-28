::------------------Init---------------------
@echo off
color F9
set "_null=1>nul 2>nul"
set "Ver=V1.0"
chcp 65001 %_null%
title  Steam Auto Crack %Ver%
setlocal EnableDelayedExpansion
cd /d %~dp0
cls
goto Menu

::-------------Main Menu---------------------
:Menu
set "Info=Main Menu"
call :MenuInfo
call :Error
echo     1. Auto Crack
echo     2. Crack Options
echo     3. Steam Emulator Options
echo     4. Delete TEMP File
echo     5. About
echo     6. Exit
echo.
choice /N /C 654321 /M "Select Options [1~6]:"
if errorlevel  6 goto :AutoCrack
if errorlevel  5 goto :CrackMenu
if errorlevel  4 goto :EMUMenu
if errorlevel  3 goto :DelTMP
if errorlevel  2 call :About & goto :Menu
if errorlevel  1 Exit

::-------------Crack Options Menu---------------------
:CrackMenu
set "Info=Crack Options Menu"
call :MenuInfo
echo     1. Auto Unpack SteamStub (Unpack+Backup)
echo     2. Auto find .exe file and Unpack SteamStub(Unpack+Backup)
echo     3. Back to Main Menu
echo.
choice /N /C 321 /M "Select Options [1~3]:"
if errorlevel  3 call :AutoUnpack
if errorlevel  2 goto :AutoUnpackFind
if errorlevel  1 goto :Menu

::------------Auto Unpack----------------
:AutoUnpack
set "Info=Auto Unpack SteamStub (Unpack+Backup)"
call :MenuInfo
echo Please select Packed .exe file.
call :FileSelect File .exe
%~dp0bin\Steamless\Steamless.CLI.exe %FilePath% %_null%
if errorlevel 1 echo Unpack error. (File not Packed/Other Packer) & pause & goto :Menu
echo Unpack successful, backuping......
move /Y %FilePath% %FilePath%.bak %_null%
move /Y %FilePath%.unpacked.exe %FilePath% %_null%
echo File backuped.
pause
goto :Menu


::----------Auto Unpack Find(Unpack+Backup)----------
:AutoUnpackFind
set "Info=Auto find and Unpack SteamStub(Unpack+Backup)"
call :MenuInfo
echo Please select Packed .exe file.
call :FileSelect Folder
FOR /R %FilePath% %%i IN (*.exe) DO (
set unppath=%%i
echo Found "!unppath!" , Unpacking......
%~dp0bin\Steamless\Steamless.CLI.exe "!unppath!" %_null%
if !errorlevel! EQU 1 echo Unpack error. File not Packed or Packed by Other Packer/Protector.
if !errorlevel! EQU 0 (
echo Unpack successful, backuping...... 
move /Y "!unppath!" "!unppath!.bak" %_null%
move /Y "!unppath!.unpacked.exe" "!unppath!" %_null%
echo File backuped.
)
)

echo All file Unpacked.
pause
goto :Menu


::------------------------------Files---------------------------------------------------------------------
::------------File Selector-------------------------
:FileSelect
set "FilePath="
set "FileType=%1"
set "FileExt=%2"
if /i %FileType%==File (
choice /N /C CIS /M "Please [S]elect File or [I]nput File Full path or [C]ancel: [S,I,C]:"
if errorlevel  3 goto :selectpath 
if errorlevel  2 goto :inputpath  
if errorlevel  1 echo Cenceled. & pause & goto :Menu
)

if /i %FileType%==Folder (
choice /N /C CIS /M "Please [S]elect Folder or [I]nput Folder Full path or [C]ancel: [S,I,C]:"
if errorlevel  3 goto :selectpath 
if errorlevel  2 goto :inputpath
if errorlevel  1 echo Cenceled. & pause & goto :Menu
)

:FileSelect1
if NOT exist %FilePath% echo %FileType% Not Found. & goto :FileSelect
goto :eof

::---------------Select File Path---------------
:selectpath
for %%i in (powershell.exe) do if "%%~$path:i"=="" (
echo Powershell is not installed in the system.
echo Please use Input %FileType% Path.
goto :FileSelect
)

if /i %FileType%==File goto :selectfile 
if /i %FileType%==Folder goto :selectfolder

:selectfile
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.InitialDirectory=pwd;$f.showHelp=$false;$f.Filter='%FileExt% files (*%FileExt%)^|*%FileExt%^|All files (*.*)^|*.*';$f.ShowDialog()^|Out-Null;$f.FileName""
for /f "delims=" %%I in ('%dialog%') do set "FilePath="%%I""
if /i [%FilePath%]==[] echo No %FileType% selected. & goto :FileSelect
goto :FileSelect1

:selectfolder
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.ShowNewFolderButton=$true;$f.ShowDialog();$f.SelectedPath""
for /F "delims=" %%I in ('%dialog%') do set "FilePath="%%I""
if /i [%FilePath%]==[] echo No %FileType% selected. & goto :FileSelect
goto :FileSelect1
::---------------Input File Path---------------
:inputpath
if /i %FileType%==File echo Drag and Drop File or Input File Full Path, then press Enter:
if /i %FileType%==Folder echo Drag and Drop Folder or Input Folder Full Path, then press Enter:
set /p FilePath=
if /i [%FilePath%]==[] echo No %FileType% selected. & goto :FileSelect
set FilePath=%FilePath:"=%
set FilePath="%FilePath%"
goto :FileSelect1

::--------------------------------------------------------------------------------------------------------------

::-------------About---------------------
:About
set "Info=About"
call :MenuInfo
echo.
echo              Steam Auto Crack %Ver%
echo           Automatic Steam Game Cracker
echo  Github: https://github.com/oureveryday/Steam-auto-crack
echo.
pause
goto :eof

::--------------------Info------------------------
:MenuInfo
cls
echo ---------------------------------------------
echo ---------- Steam Auto Crack %Ver% ------------
echo ---------------------------------------------
echo.
echo ---------------%Info%---------------------
goto :eof

::----------------------Error Display-----------------
:Error
if NOT [%ErrorString%]==[] echo Error: %ErrorString%
set "ErrorString="
goto :eof

::----------------------Delete TEMP file-----------------
:DelTMP
set Info=Delete TEMP file
call :MenuInfo
choice /N /M "Delete TEMP file[Y/N]?"
IF /i ERRORLEVEL 2 echo Cenceled. & pause & goto :Menu
del /f /s /q %~dp0Temp %_null%
rd /s /q %~dp0Temp %_null%
echo Temp file deleted.
pause
goto :Menu



