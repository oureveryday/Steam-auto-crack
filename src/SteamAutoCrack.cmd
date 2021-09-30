::---------------------------------------------------------------
::                Steam Auto Crack V1.1.7
::          Automatic Steam Game Cracker
:: Github: https://github.com/oureveryday/Steam-auto-crack
:: Gitlab:   https://gitlab.com/oureveryday/Steam-auto-crack
::---------------------------------------------------------------

::------------------Init---------------------
@echo off
color F1
set "_null=1>nul 2>nul"
set "Ver=V1.1.7"
chcp 65001 %_null%
title  Steam Auto Crack %Ver%
setlocal EnableDelayedExpansion
setlocal Enableextensions
cd /d %~dp0
cls
goto Menu

::-------------Main Menu---------------------
:Menu
set "Info=Main Menu"
call :MenuInfo
echo     1. Auto Crack
echo     2. EXE Crack Options
echo     3. Steam Emulator Options
echo     4. Genetate Crack Only Files
echo     5. Delete TEMP File
echo     6. Restore Crack
echo     7. About
echo     8. Exit
echo.
choice /N /C 87654321 /M "Select Options [1~7]:"
if errorlevel 8 goto :AutoCrack
if errorlevel 7 goto :CrackMenu
if errorlevel 6 goto :EMUMenu
if errorlevel 5 goto :GenCrack
if errorlevel 4 goto :DelTMP
if errorlevel 3 goto :Restore
if errorlevel 2 goto :About
if errorlevel 1 Exit


::----------------------Restore Crack--------------------
:Restore
set "Info=Restore Crack"
call :MenuInfo
echo.
echo This will Restore all Crack Files.
echo Please select Game Folder:
call :FileSelect Folder
FOR /R %FilePath% %%i IN (*.bak) DO (
set _BAKFilePath=%%i
set _BAKFileOrig=!_BAKFilePath:.bak=!
del /f /s /q "!_BAKFileOrig!" %_null%
move /Y "!_BAKFilePath!" "!_BAKFileOrig!" %_null%
)
pushd %FilePath%
FOR /D /r %%i in (steam_settings) DO (
set _FolderFilePath=%%i
del /f /s /q "!_FolderFilePath!" %_null%
rd /s /q "!_FolderFilePath!" %_null%
)
popd
echo All File Restored.
echo.
pause
goto :Menu 

::---------------------Generate Crack Only Files-----------------
:GenCrack
set "Info=Generate Crack Only Files"
call :MenuInfo
echo.
if EXIST "%~dp0Temp\Crack" (
choice /N /M "Delete Previous Crack Only Folder[Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (del /F /S /Q "%~dp0Temp\Crack"  %_null% & rd /S /Q "%~dp0Temp\Crack" %_null% & echo Deleted. )
)
if EXIST "%~dp0Temp\Crack.zip" (
choice /N /M "Delete Previous Crack.zip [Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (del /F /S /Q "%~dp0Temp\Crack.zip" %_null% & echo Deleted. )
)
echo This will generate Crack Only Files for "Steam Auto Crack" Cracked Game.
echo Please select Game Folder:
call :FileSelect Folder
set FilePathC=%FilePath:"=%
mkdir "%~dp0TEMP\Crack" %_null%

FOR /R %FilePath% %%i IN (*.bak) DO (
set _BAKFilePath=%%i
call :checkfile "!_BAKFilePath!" steam_api.dll.bak
if !result!==1 (
echo ---------------
set _BAKFileOrig=!_BAKFilePath:.bak=!
set _BAKFileOrigRelPath=!_BAKFileOrig:%FilePathC%=!
set _BAKFileOrigRelPath=!_BAKFileOrigRelPath:steam_api.dll=!
echo Found "!_BAKFileOrig!" . Copying......
xcopy "!_BAKFileOrig!" "%~dp0TEMP\Crack!_BAKFileOrigRelPath!steam_api.dll*" /H /Y /Q /I %_null%
)
call :checkfile "!_BAKFilePath!" steam_api64.dll.bak
if !result!==1 (
echo ---------------
set _BAKFileOrig=!_BAKFilePath:.bak=!
set _BAKFileOrigRelPath=!_BAKFileOrig:%FilePathC%=!
set _BAKFileOrigRelPath=!_BAKFileOrigRelPath:steam_api64.dll=!
echo Found "!_BAKFileOrig!" . Copying......
xcopy "!_BAKFileOrig!" "%~dp0TEMP\Crack!_BAKFileOrigRelPath!steam_api64.dll*" /H /Y /Q /I %_null%
)
)

FOR /R %FilePath% %%i IN (*.exe.bak) DO (
set _BAKFilePath=%%i
call :checkfile "!_BAKFilePath!" *.exe.bak
echo ---------------
set _BAKFileOrig=!_BAKFilePath:.bak=!
set _BAKFileOrigRelPath=!_BAKFileOrig:%FilePathC%=!
echo Found "!_BAKFileOrig!" . Copying......
xcopy "!_BAKFileOrig!" "%~dp0TEMP\Crack!_BAKFileOrigRelPath!*" /H /Y /Q /I %_null%
)

pushd %FilePath%
FOR /D /r %%i in (steam_settings) DO (
set _FolderFilePath=%%i
set _FolderFilePath1="%%i"
if EXIST !_FolderFilePath1! (
echo Found !_FolderFilePath1! . Copying......
set _FolderFilePathRel=!_FolderFilePath:steam_settings=!
set _FolderFilePathRel=!_FolderFilePathRel:%FilePathC%=!
xcopy !_FolderFilePath1! "%~dp0TEMP\Crack!_FolderFilePathRel!steam_settings" /H /E /Y /C /Q /R /I %_null%
)
)
popd

choice /N /M "Pack Crack Files with .zip archive[Y/N]:"
if /i %errorlevel% EQU 1 (
echo Compressing......
"%~dp0bin\7z\7za.exe" a -tzip "%~dp0TEMP\Crack.zip" "%~dp0TEMP\Crack" %_null%
echo Compress complete.
echo.
echo Generate Crack Only Files completed.
start "" "explorer.exe" /select,"%~dp0TEMP\Crack.zip"
echo.
pause
goto :Menu  
)
echo Generate Crack Only Files completed.
start "" "explorer.exe" /select,"%~dp0TEMP\Crack"
echo.
pause
goto :Menu 



::----------------------Auto Crack---------------
:AutoCrack
set "Info=Auto Crack"
call :MenuInfo
if defined AutoCrackStep (
echo Detected Last Crack Not Completed.
choice /N /C RG /M "[G]o to Last Executed Step Or [R]estart?"
IF !ERRORLEVEL! EQU 2 ( goto %AutoCrackStep% )
)

set "AutoCrackStep="
::-------------------------SelectFolder---------------------------
echo.
echo -----------------------------1.Select Game Folder-----------------------
:AutoCrack1
set "AutoCrackStep=:AutoCrack1"
set "GamePath="
echo Please select Game Folder:
call :FileSelect Folder
set "GamePath=%FilePath%"


::---------------------Generate Goldberg Steam Emulator Game Info-------------------
:AutoCrack2
echo.
SETLOCAL
echo -----------------------------2.Generate Generate Goldberg Steam Emulator Game Info-----------------------
set "AutoCrackStep=:AutoCrack2"
::Init
if EXIST "%~dp0Temp\steam_settings" (
choice /N /M "Delete Previous steam_settings Folder[Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (del /F /S /Q "%~dp0Temp\steam_settings"  %_null% & rd /S /Q "%~dp0Temp\steam_settings" %_null% & echo Deleted. )
)
set "GameAPPID="
set "SteamAPIKEY="
set "Image="
set "Num="
::Input
echo.
echo (If you don't know the Game APPID, Find it Here: https://steamdb.info/)
set /p GameAPPID=Input Game APPID, then press Enter:
if NOT defined GameAPPID ( echo Please Input vaild Game APPID. & pause & goto :Menu )
for /f "delims=0123456789" %%i in ("%GameAPPID%") do set Num=%%i
if defined Num ( echo Please Input vaild Game APPID. & pause & goto :Menu ) 
if /I %GameAPPID% GTR 99999999 ( echo Please Input vaild Game APPID. & pause & goto :Menu ) 
choice /N /M "Generate Game Infos online (Default: Yes)[Y/N]:"
IF ERRORLEVEL 2 (
mkdir Temp\steam_settings %_null%
echo | set /p="%GameAPPID%"> "%~dp0Temp\steam_settings\steam_appid.txt"
echo Default Goldberg Steam Emulator Game Info Generated.
goto :AutoCrack2END
)
)

IF ERRORLEVEL 1 (
choice /N /M "Generate Achievement Images (Generate can take longer time. Default: No)[Y/N]:"
IF ERRORLEVEL 2 ( set "Image=-i" )
echo --------------------
echo Use Steam Web API:  Input Steam Web API Key, then press Enter.
echo Use xan105 API:     Leave Blank, then press Enter. (Default)
echo If use xan105 API, No Steam Web API Key needed, But Can't Generate Items.
echo --------------------
set /p SteamAPIKEY=Steam API Key:
echo --------------------
mkdir "%~dp0TEMP\steam_settings" %_null%
if NOT defined SteamAPIKEY ( echo Using xan105 API. & "%~dp0bin\generate_game_infos\generate_game_infos.exe" "!GameAPPID!" -o "%~dp0Temp\steam_settings" !Image! )
if defined SteamAPIKEY ( echo Using Steam Web API. & "%~dp0bin\generate_game_infos\generate_game_infos.exe" "!GameAPPID!" -s "!SteamAPIKEY!" -o "%~dp0Temp\steam_settings" !Image! )
echo --------------------
echo Goldberg Steam Emulator Game Info Generated.
goto :AutoCrack2END
)
:AutoCrack2END
ENDLOCAL
echo -------------------------------------------------------------------------------------

::-----------------------------Goldberg Steam Emulator Settings----------------
:AutoCrack3
set "AutoCrackStep=:AutoCrack3"
SETLOCAL
echo -----------------------------3.Goldberg Steam Emulator Settings-----------------------
if NOT exist %~dp0Temp\steam_settings ( echo Please Generate Goldberg Steam Emulator Game Info first. & pause & goto :Menu )
if EXIST "%~dp0Temp\steam_settings\settings" (
choice /N /M "Delete Previous steam_settings\settings Folder[Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (del /F /S /Q "%~dp0Temp\steam_settings\settings"  %_null% & rd /S /Q "%~dp0Temp\steam_settings\settings" %_null% & echo Deleted. )
)
set "AccountName="
set "Language="
set "ListenPort="
set "UserSteamID="
echo Loading Default values......
set "DefaultAccountName=Goldberg"
set "DefaultListenPort=47584"
set "DefaultUserSteamID=76561197960287930"
call :setlanguage
set "AccountName=%DefaultAccountName%"
set "Language=%DefaultLanguage%"
set "ListenPort=%DefaultListenPort%"
set "UserSteamID=%DefaultUserSteamID%"
echo Default values loaded.
echo Default Steam Account Name: %DefaultAccountName%
echo Default Language (Generated from your System Locale %_locale%): %DefaultLanguage%
echo Default Listen Port: %DefaultListenPort%
echo Default User Steam ID %DefaultUserSteamID%

::Setting
::Steam Account Name
:AutoCrackEMUSetting1
echo --------------------------
choice /N /C CDA /M "Steam Account Name: %AccountName%  [A]ccept, Set to [D]efault or [C]hange:"
if errorlevel 3 echo Set Steam Account Name: %AccountName% & goto :AutoCrackEMUSetting2
if errorlevel 2 set "AccountName=%DefaultAccountName%" & echo Steam Account Name Restored to Default Value. & goto :AutoCrackEMUSetting1
if errorlevel 1 (
set /p AccountName=Input Steam Account Name, then press Enter:
goto :AutoCrackEMUSetting1
)
::Language
:AutoCrackEMUSetting2
echo --------------------------
choice /N /C CDA /M "Language: %Language%  [A]ccept, Set to [D]efault or [C]hange:"
if errorlevel 3 echo Set Language: %Language% & goto :AutoCrackEMUSetting3
if errorlevel 2 set "Language=%DefaultLanguage%" & echo Language Restored to Default Value. & goto :AutoCrackEMUSetting2
if errorlevel 1 (
echo List of valid steam languages:
echo    A. arabic   B. bulgarian C. schinese  D. tchinese E. czech      F. danish    G. dutch
echo   [H. english] I. finnish   J. french    K. german   L. greek      M. hungarian N. italian
echo    O. japanese P. koreana   Q. norwegian R. polish   S. portuguese T. brazilian U. romanian
echo    V: russian  W. spanish   X. swedish   Y. thai     Z. turkish    1. ukrainian
choice /N /C:1ZYXWVUTSRQPONMLKJIHGFEDCBA /M "Select Steam language[A~Z,1]: "
IF !ERRORLEVEL! EQU 27 set "Language=arabic"
IF !ERRORLEVEL! EQU 26 set "Language=bulgarian"
IF !ERRORLEVEL! EQU 25 set "Language=schinese"
IF !ERRORLEVEL! EQU 24 set "Language=tchinese"
IF !ERRORLEVEL! EQU 23 set "Language=czech"
IF !ERRORLEVEL! EQU 22 set "Language=danish"
IF !ERRORLEVEL! EQU 21 set "Language=dutch"
IF !ERRORLEVEL! EQU 20 set "Language=english"
IF !ERRORLEVEL! EQU 19 set "Language=finnish"
IF !ERRORLEVEL! EQU 18 set "Language=french"
IF !ERRORLEVEL! EQU 17 set "Language=german"
IF !ERRORLEVEL! EQU 16 set "Language=greek"
IF !ERRORLEVEL! EQU 15 set "Language=hungarian"
IF !ERRORLEVEL! EQU 14 set "Language=italian"
IF !ERRORLEVEL! EQU 13 set "Language=japanese"
IF !ERRORLEVEL! EQU 12 set "Language=koreana"
IF !ERRORLEVEL! EQU 11 set "Language=norwegian"
IF !ERRORLEVEL! EQU 10 set "Language=polish"
IF !ERRORLEVEL! EQU 9 set "Language=portuguese"
IF !ERRORLEVEL! EQU 8 set "Language=brazilian"
IF !ERRORLEVEL! EQU 7 set "Language=romanian"
IF !ERRORLEVEL! EQU 6 set "Language=russian"
IF !ERRORLEVEL! EQU 5 set "Language=spanish"
IF !ERRORLEVEL! EQU 4 set "Language=swedish"
IF !ERRORLEVEL! EQU 3 set "Language=thai"
IF !ERRORLEVEL! EQU 2 set "Language=turkish"
IF !ERRORLEVEL! EQU 1 set "Language=ukrainian"
goto :AutoCrackEMUSetting2
)
::Listen Port
:AutoCrackEMUSetting3
echo --------------------------
choice /N /C CDA /M "Listen Port: %ListenPort%  [A]ccept, Set to [D]efault or [C]hange:"
if errorlevel 3 echo Set Listen Port: %ListenPort% & goto :AutoCrackEMUSetting4
if errorlevel 2 set "ListenPort=%DefaultListenPort%" & echo Listen Port Restored to Default Values. & goto :AutoCrackEMUSetting3
if errorlevel 1 (
set /p ListenPort1=Input Listen Port, then press Enter:
if NOT defined ListenPort1 ( echo Please Input vaild Listen Port. & goto :AutoCrackEMUSetting3 )
set "Num="
for /f "delims=0123456789" %%i in ("!ListenPort1!") do set Num=%%i
if defined Num ( echo Please Input vaild Listen Port. & goto :AutoCrackEMUSetting3 )
if /I !ListenPort1! GTR 65535 ( echo Please Input vaild Listen Port. & goto :AutoCrackEMUSetting3 ) 
set "ListenPort=!ListenPort1!"
goto :AutoCrackEMUSetting3
)
::User Steam ID
:AutoCrackEMUSetting4
echo --------------------------
choice /N /C CDA /M "User Steam ID: %UserSteamID%  [A]ccept, Set to [D]efault or [C]hange:"
if errorlevel 3 echo Set User Steam ID: %UserSteamID% & goto :AutoCrackEMUSetting5
if errorlevel 2 set "UserSteamID=%DefaultUserSteamID%" & echo User Steam ID Restored to Default Value. & goto :AutoCrackEMUSetting4
if errorlevel 1 (
set /p UserSteamID1=Input User Steam ID, then press Enter:
if NOT defined UserSteamID1 ( echo Please Input vaild Steam ID. & goto :AutoCrackEMUSetting4 )
set "Num="
for /f "delims=0123456789" %%i in ("!UserSteamID1!") do set Num=%%i
if defined Num ( echo Please Input vaild User Steam ID. & goto :AutoCrackEMUSetting4 )
if /I !UserSteamID1! LSS 2147483647 ( echo Please Input vaild User Steam ID. & goto :AutoCrackEMUSetting4 ) 
set "UserSteamID=!UserSteamID1!"
goto :AutoCrackEMUSetting4
)

::Apply
:AutoCrackEMUSetting5
echo ---------------------------------------------------
echo Steam Account Name: %AccountName%      Language: %Language% 
echo Listen Port: %ListenPort%              User Steam ID: %UserSteamID%
echo ---------------------------------------------------
choice /N /M "Please confirm values[Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (
echo Writing Goldberg Steam Emulator Settings......
mkdir "%~dp0Temp\steam_settings\settings" %_null%
echo | set /p="%AccountName%"> "%~dp0Temp\steam_settings\settings\account_name.txt"
echo | set /p="%Language%"> "%~dp0Temp\steam_settings\settings\language.txt"
echo | set /p="%ListenPort%"> "%~dp0Temp\steam_settings\settings\listen_port.txt"
echo | set /p="%UserSteamID%"> "%~dp0Temp\steam_settings\settings\user_steam_id.txt"
)
ENDLOCAL
echo Goldberg Steam Emulator Settings completed.
echo -------------------------------------------------------------------------------------


:AutoCrack4
set "AutoCrackStep=:AutoCrack4"
SETLOCAL
set "FilePath=%GamePath%"
echo -----------------------------4.Goldberg Steam Emulator Settings-----------------------

FOR /R %FilePath% %%i IN (*.dll) DO ( set "_EMUPathInput=%%i" & call :AutoCrackAutoFindApplyEMU1 )
echo All Goldberg Steam Emulator has been Applied.
echo -------------------------------------------------------------------------------------
ENDLOCAL
goto :AutoCrack5


:AutoCrackAutoFindApplyEMU1
SETLOCAL
::steam_api.dll
set _EMUPath=!_EMUPathInput!
call :checkfile "%_EMUPath%" steam_api.dll
if %result%==1 (
echo ---------------
echo Found "%_EMUPath%" .
echo Backuping "%_EMUPath%" .......
move /Y "%_EMUPath%" "%_EMUPath%.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api.dll......
copy /Y "%~dp0bin\Goldberg\steam_api.dll" "%_EMUPath%" %_null%
set _EMUPath=%_EMUPath:\steam_api.dll=%
echo Copying Config to "!_EMUPath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings" "!_EMUPath!\steam_settings" /H /E /Y /C /Q /R /I %_null% 
echo Goldberg Steam Emulator Config Applied.
)
::steam_api64.dll
set _EMUPath=!_EMUPathInput!
call :checkfile "%_EMUPath%" steam_api64.dll
if %result%==1 (
echo ---------------
echo Found "%_EMUPath%" .
echo Backuping "%_EMUPath%" .......
move /Y "%_EMUPath%" "%_EMUPath%.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api64.dll......
copy /Y "%~dp0bin\Goldberg\steam_api64.dll" "%_EMUPath%" %_null%
set _EMUPath=%_EMUPath:\steam_api64.dll=%
echo Copying Config to "!_EMUPath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings" "!_EMUPath!\steam_settings" /H /E /Y /C /Q /R /I %_null% 
echo Goldberg Steam Emulator Config Applied.
)
ENDLOCAL
goto :eof


:AutoCrack5
set "AutoCrackStep=:AutoCrack5"
SETLOCAL
set "FilePath=%GamePath%"
echo -----------------------------5.Unpack .exe file-----------------------
FOR /R %FilePath% %%i IN (*.exe) DO (
echo --------
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
echo --------------------------------------------------------------------------------------
ENDLOCAL

::Complete
echo Game Crack Completed. Enjoy :)
set "AutoCrackStep="
del /f /s /q "%~dp0Temp" %_null%
rd /s /q "%~dp0Temp" %_null%
echo.
pause
goto :Menu

::-------------EXE Crack Options Menu---------------------
:CrackMenu
set "Info=EXE Crack Options Menu"
call :MenuInfo
echo     1. Auto Unpack SteamStub (Unpack + Backup)
echo     2. Auto find .exe file and Unpack SteamStub (Unpack + Backup)
echo     3. Back to Main Menu
echo.
choice /N /C 321 /M "Select Options [1~3]:"
if errorlevel 3 goto :AutoUnpack
if errorlevel 2 goto :AutoUnpackFind
if errorlevel 1 goto :Menu

::-------------Steam Emulator Options Menu---------------------
:EMUMenu
set "Info=Steam Emulator Options Menu"
call :MenuInfo
echo     1. Auto Apply Goldberg Steam Emulator (Apply + Backup)
echo     2. Auto Find and apply Goldberg Steam Emulator (Apply + Backup)
echo     3. Generate Goldberg Steam Emulator Game Info (Appid + Achievements + DLC)
echo     4. Goldberg Steam Emulator Settings (Language + SteamUser)
echo     5. Generate Steam Interfaces for Goldberg Steam Emulator (For steam_api(64).dll older than May 2016)
echo     6. Open Goldberg Steam Emulator Setting folder
echo     7. Open Goldberg Steam Emulator Setting Example Folder
echo     8. Auto Update Goldberg Steam Emulator to latest version
echo     9. Back to Main Menu
echo.
choice /N /C 987654321 /M "Select Options [1~9]:"
if errorlevel 9 goto :AutoApplyEMU
if errorlevel 8 goto :AutoFindApplyEMU
if errorlevel 7 goto :GenerateEMUInfo
if errorlevel 6 goto :EMUSetting
if errorlevel 5 goto :GenerateInterface
if errorlevel 4 goto :OpenEMUFolder
if errorlevel 3 goto :OpenExampleFolder
if errorlevel 2 goto :AutoUpdateEMU
if errorlevel 1 goto :Menu

::--------------------Auto Update Goldberg Steam Emulator to latest version----------------------
:AutoUpdateEMU
set "Info=Auto Update Goldberg Steam Emulator to latest version"
call :MenuInfo
echo Goldberg Steam Emulator URL: https://mr_goldberg.gitlab.io/goldberg_emulator/
choice /N /M "This will Auto Update Goldberg Steam Emulator to latest version. Continue[Y/N]?"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (
mkdir "%~dp0TEMP" %_null%
echo Getting Download URL......
"%~dp0bin\curl\curl.exe" "https://mr_goldberg.gitlab.io/goldberg_emulator/" -s > "%~dp0TEMP\1.tmp" 
findstr /I /R /C:"https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/jobs/.*/artifacts/download" "%~dp0TEMP\1.tmp" > "%~dp0TEMP\2.tmp"
for /f "tokens=7 delims=/" %%a in (%~dp0TEMP\2.tmp) do ( set "JobID=%%a" )
del /f /s /q "%~dp0TEMP\1.tmp" %_null%
del /f /s /q "%~dp0TEMP\2.tmp" %_null%
echo JobID:!JobID! , Downloading......
set /p OldJobID=<"%~dp0bin\Goldberg\jobid"
IF /I !JobID! == !OldJobID! (
echo Goldberg Emulator Already Updated to Latest Version.
pause
goto :Menu
)
set URL=https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/jobs/!JobID!/artifacts/download
echo Download URL: !URL!
echo ----------------------------------
"%~dp0bin\curl\curl.exe" -L "!URL!" --output "%~dp0TEMP\Goldberg.zip"
echo ----------------------------------
echo Download Complete. Extracting files......
"%~dp0bin\7z\7za.exe" -o"%~dp0TEMP\Goldberg" x "%~dp0TEMP\Goldberg.zip" %_null%
del /f /s /q "%~dp0TEMP\Goldberg.zip" %_null%
copy /Y "%~dp0TEMP\Goldberg\steam_api.dll" "%~dp0bin\Goldberg\steam_api.dll" %_null%
copy /Y "%~dp0TEMP\Goldberg\steam_api64.dll" "%~dp0bin\Goldberg\steam_api64.dll" %_null%
echo !JobID!> "%~dp0bin\Goldberg\jobid"
echo Update completed.
del /f /s /q "%~dp0Temp\Goldberg" %_null%
rd /s /q "%~dp0Temp\Goldberg" %_null%
)
echo.
pause
goto :Menu

::-------------Open Goldberg Steam Emulator Setting folder-------------------
:OpenEMUFolder
echo ---------------------------
if NOT exist "%~dp0Temp\steam_settings" ( echo No Goldberg Steam Emulator Config Path. & pause & goto :Menu )
start "" "explorer.exe" "%~dp0Temp\steam_settings"
echo Opened.
echo.
pause
goto :Menu

::-------------Open Goldberg Steam Emulator Setting Example Folder-------------------
:OpenExampleFolder
echo ---------------------------
start "" "explorer.exe" "%~dp0bin\Goldberg\Example"
echo Opened.
echo.
pause
goto :Menu


::-------------Generate Steam Interfaces for Goldberg Steam Emulator-----------------
:GenerateInterface
set "Info=Generate Steam Interfaces for Goldberg Steam Emulator"
call :MenuInfo
echo You only need to do this For steam_api(64).dll older than May 2016.
echo And Please Apply Goldberg Steam Emulator first, and select steam_api(64).dll.bak File to Generate.
echo Please select steam_api(64).dll.bak :
call :FileSelect File .dll.bak

call :checkfile %FilePath% steam_api.dll.bak
if %result%==1 (
echo Generating Steam Interfaces for %FilePath%......
set "_FilePath=%FilePath:"=%"
set _FilePath=!_FilePath:\steam_api.dll.bak=!
pushd !_FilePath!
"%~dp0bin\Goldberg\generate_interfaces_file.exe" %FilePath% 
popd
echo Generated.
pause
goto :Menu
)

call :checkfile %FilePath% steam_api64.dll.bak
if %result%==1 (
echo Generating Steam Interfaces for %FilePath%......
set "_FilePath=%FilePath:"=%"
set _FilePath=!_FilePath:\steam_api64.dll.bak=!
pushd !_FilePath!
"%~dp0bin\Goldberg\generate_interfaces_file.exe" %FilePath%
popd
echo Generated.
pause
goto :Menu
)
echo File is Not steam_api(64).dll.bak .
echo.
pause
goto :Menu


::---------------------Goldberg Steam Emulator Settings (Language + SteamUser)---------------------
:EMUSetting
set "Info=Goldberg Steam Emulator Settings (Language + SteamUser)"
call :MenuInfo
::Init
if NOT exist %~dp0Temp\steam_settings ( echo Please Generate Goldberg Steam Emulator Game Info first. & pause & goto :Menu )
if EXIST "%~dp0Temp\steam_settings\settings" (
choice /N /M "Delete Previous steam_settings\settings Folder[Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (del /F /S /Q "%~dp0Temp\steam_settings\settings"  %_null% & rd /S /Q "%~dp0Temp\steam_settings\settings" %_null% & echo Deleted. )
)
set "AccountName="
set "Language="
set "ListenPort="
set "UserSteamID="
echo Loading Default values......
set "DefaultAccountName=Goldberg"
set "DefaultListenPort=47584"
set "DefaultUserSteamID=76561197960287930"
call :setlanguage
set "AccountName=%DefaultAccountName%"
set "Language=%DefaultLanguage%"
set "ListenPort=%DefaultListenPort%"
set "UserSteamID=%DefaultUserSteamID%"
echo Default values loaded.
echo Default Steam Account Name: %DefaultAccountName%
echo Default Language (Generated from your System Locale %_locale%): %DefaultLanguage%
echo Default Listen Port: %DefaultListenPort%
echo Default User Steam ID %DefaultUserSteamID%

::Setting
::Steam Account Name
:EMUSetting1
echo --------------------------
choice /N /C CDA /M "Steam Account Name: %AccountName%  [A]ccept, Set to [D]efault or [C]hange:"
if errorlevel 3 echo Set Steam Account Name: %AccountName% & goto :EMUSetting2
if errorlevel 2 set "AccountName=%DefaultAccountName%" & echo Steam Account Name Restored to Default Value. & goto :EMUSetting1
if errorlevel 1 (
set /p AccountName=Input Steam Account Name, then press Enter:
goto :EMUSetting1
)
::Language
:EMUSetting2
echo --------------------------
choice /N /C CDA /M "Language: %Language%  [A]ccept, Set to [D]efault or [C]hange:"
if errorlevel 3 echo Set Language: %Language% & goto :EMUSetting3
if errorlevel 2 set "Language=%DefaultLanguage%" & echo Language Restored to Default Value. & goto :EMUSetting2
if errorlevel 1 (
echo List of valid steam languages:
echo    A. arabic   B. bulgarian C. schinese  D. tchinese E. czech      F. danish    G. dutch
echo   [H. english] I. finnish   J. french    K. german   L. greek      M. hungarian N. italian
echo    O. japanese P. koreana   Q. norwegian R. polish   S. portuguese T. brazilian U. romanian
echo    V: russian  W. spanish   X. swedish   Y. thai     Z. turkish    1. ukrainian
choice /N /C:1ZYXWVUTSRQPONMLKJIHGFEDCBA /M "Select Steam language[A~Z,1]: "
IF !ERRORLEVEL! EQU 27 set "Language=arabic"
IF !ERRORLEVEL! EQU 26 set "Language=bulgarian"
IF !ERRORLEVEL! EQU 25 set "Language=schinese"
IF !ERRORLEVEL! EQU 24 set "Language=tchinese"
IF !ERRORLEVEL! EQU 23 set "Language=czech"
IF !ERRORLEVEL! EQU 22 set "Language=danish"
IF !ERRORLEVEL! EQU 21 set "Language=dutch"
IF !ERRORLEVEL! EQU 20 set "Language=english"
IF !ERRORLEVEL! EQU 19 set "Language=finnish"
IF !ERRORLEVEL! EQU 18 set "Language=french"
IF !ERRORLEVEL! EQU 17 set "Language=german"
IF !ERRORLEVEL! EQU 16 set "Language=greek"
IF !ERRORLEVEL! EQU 15 set "Language=hungarian"
IF !ERRORLEVEL! EQU 14 set "Language=italian"
IF !ERRORLEVEL! EQU 13 set "Language=japanese"
IF !ERRORLEVEL! EQU 12 set "Language=koreana"
IF !ERRORLEVEL! EQU 11 set "Language=norwegian"
IF !ERRORLEVEL! EQU 10 set "Language=polish"
IF !ERRORLEVEL! EQU 9 set "Language=portuguese"
IF !ERRORLEVEL! EQU 8 set "Language=brazilian"
IF !ERRORLEVEL! EQU 7 set "Language=romanian"
IF !ERRORLEVEL! EQU 6 set "Language=russian"
IF !ERRORLEVEL! EQU 5 set "Language=spanish"
IF !ERRORLEVEL! EQU 4 set "Language=swedish"
IF !ERRORLEVEL! EQU 3 set "Language=thai"
IF !ERRORLEVEL! EQU 2 set "Language=turkish"
IF !ERRORLEVEL! EQU 1 set "Language=ukrainian"
goto :EMUSetting2
)
::Listen Port
:EMUSetting3
echo --------------------------
choice /N /C CDA /M "Listen Port: %ListenPort%  [A]ccept, Set to [D]efault or [C]hange:"
if errorlevel 3 echo Set Listen Port: %ListenPort% & goto :EMUSetting4
if errorlevel 2 set "ListenPort=%DefaultListenPort%" & echo Listen Port Restored to Default Values. & goto :EMUSetting3
if errorlevel 1 (
set /p ListenPort1=Input Listen Port, then press Enter:
if NOT defined ListenPort1 ( echo Please Input vaild Listen Port. & goto :EMUSetting3 )
set "Num="
for /f "delims=0123456789" %%i in ("!ListenPort1!") do set Num=%%i
if defined Num ( echo Please Input vaild Listen Port. & goto :EMUSetting3 )
if /I !ListenPort1! GTR 65535 ( echo Please Input vaild Listen Port. & goto :EMUSetting3 ) 
set "ListenPort=!ListenPort1!"
goto :EMUSetting3
)
::User Steam ID
:EMUSetting4
echo --------------------------
choice /N /C CDA /M "User Steam ID: %UserSteamID%  [A]ccept, Set to [D]efault or [C]hange:"
if errorlevel 3 echo Set User Steam ID: %UserSteamID% & goto :EMUSetting5
if errorlevel 2 set "UserSteamID=%DefaultUserSteamID%" & echo User Steam ID Restored to Default Value. & goto :EMUSetting4
if errorlevel 1 (
set /p UserSteamID1=Input User Steam ID, then press Enter:
if NOT defined UserSteamID1 ( echo Please Input vaild Steam ID. & goto :EMUSetting4 )
set "Num="
for /f "delims=0123456789" %%i in ("!UserSteamID1!") do set Num=%%i
if defined Num ( echo Please Input vaild User Steam ID. & goto :EMUSetting4 )
if /I !UserSteamID1! LSS 2147483647 ( echo Please Input vaild User Steam ID. & goto :EMUSetting4 ) 
set "UserSteamID=!UserSteamID1!"
goto :EMUSetting4
)

::Apply
:EMUSetting5
echo ---------------------------------------------------
echo Steam Account Name: %AccountName%      Language: %Language% 
echo Listen Port: %ListenPort%              User Steam ID: %UserSteamID%
echo ---------------------------------------------------
choice /N /M "Please confirm values[Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (
echo Writing Goldberg Steam Emulator Settings......
mkdir "%~dp0Temp\steam_settings\settings" %_null%
echo | set /p="%AccountName%"> "%~dp0Temp\steam_settings\settings\account_name.txt"
echo | set /p="%Language%"> "%~dp0Temp\steam_settings\settings\language.txt"
echo | set /p="%ListenPort%"> "%~dp0Temp\steam_settings\settings\listen_port.txt"
echo | set /p="%UserSteamID%"> "%~dp0Temp\steam_settings\settings\user_steam_id.txt"
)
echo Goldberg Steam Emulator Settings completed.
echo.
pause
goto :Menu

::-------------Set Language-------------------------
:setlanguage
set "DefaultLanguage="
For /f "tokens=3" %%G in ('Reg query "HKCU\Control Panel\International" /v LocaleName') Do (Set _locale=%%G)
echo %_locale% | findstr /C:ar %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=arabic"
echo %_locale% | findstr /C:bg %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=bulgarian"
echo %_locale% | findstr /C:zh %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=schinese"
echo %_locale% | findstr /C:zh-Hans %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=schinese"
echo %_locale% | findstr /C:zh-CN %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=schinese"
echo %_locale% | findstr /C:zh-SG %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=schinese"
echo %_locale% | findstr /C:zh-Hant %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=tchinese"
echo %_locale% | findstr /C:zh-HK %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=tchinese"
echo %_locale% | findstr /C:zh-MO %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=tchinese"
echo %_locale% | findstr /C:zh-TW %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=tchinese"
echo %_locale% | findstr /C:cs %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=czech"
echo %_locale% | findstr /C:da %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=danish"
echo %_locale% | findstr /C:nl %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=dutch"
echo %_locale% | findstr /C:en %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=english"
echo %_locale% | findstr /C:fi %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=finnish"
echo %_locale% | findstr /C:fr %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=french"
echo %_locale% | findstr /C:de %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=german"
echo %_locale% | findstr /C:el %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=greek"
echo %_locale% | findstr /C:hu %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=hungarian"
echo %_locale% | findstr /C:it %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=italian"
echo %_locale% | findstr /C:ja %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=japanese"
echo %_locale% | findstr /C:ko %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=koreana"
echo %_locale% | findstr /C:no %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=norwegian"
echo %_locale% | findstr /C:pl %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=polish"
echo %_locale% | findstr /C:pt %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=portuguese"
echo %_locale% | findstr /C:ro %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=romanian"
echo %_locale% | findstr /C:ru %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=russian"
echo %_locale% | findstr /C:es %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=spanish"
echo %_locale% | findstr /C:sv %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=swedish"
echo %_locale% | findstr /C:th %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=thai"
echo %_locale% | findstr /C:tr %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=turkish"
echo %_locale% | findstr /C:uk %_null%
IF %ERRORLEVEL% EQU 0 set "DefaultLanguage=ukrainian"
if NOT defined DefaultLanguage set "DefaultLanguage=english"
goto :eof

::-----------------Generate Goldberg Steam Emulator Game Info (Appid + Achievements + DLC)-----------
:GenerateEMUInfo
set "Info=Generate Goldberg Steam Emulator Game Info (Appid + Achievements + DLC)"
call :MenuInfo
::Init
if EXIST "%~dp0Temp\steam_settings" (
choice /N /M "Delete Previous steam_settings Folder[Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (del /F /S /Q "%~dp0Temp\steam_settings"  %_null% & rd /S /Q "%~dp0Temp\steam_settings" %_null% & echo Deleted. )
)
set "GameAPPID="
set "SteamAPIKEY="
set "Image="
set "Num="
::Input
echo.
echo (If you don't know the Game APPID, Find it Here: https://steamdb.info/)
set /p GameAPPID=Input Game APPID, then press Enter:
if NOT defined GameAPPID ( echo Please Input vaild Game APPID. & pause & goto :Menu )
for /f "delims=0123456789" %%i in ("%GameAPPID%") do set Num=%%i
if defined Num (echo Please Input vaild Game APPID. & pause & goto :Menu ) 
if /I %GameAPPID% GTR 99999999 (echo Please Input vaild Game APPID. & pause & goto :Menu ) 
choice /N /M "Generate Game Infos online (Default: Yes)[Y/N]:"
IF ERRORLEVEL 2 (
mkdir Temp\steam_settings %_null%
echo | set /p="%GameAPPID%"> "%~dp0Temp\steam_settings\steam_appid.txt"
echo Default Goldberg Steam Emulator Game Info Generated.
echo.
pause
goto :Menu
)

IF ERRORLEVEL 1 (
choice /N /M "Generate Achievement Images (Generate can take longer time. Default: No)[Y/N]:"
IF ERRORLEVEL 2 ( set "Image=-i" )
echo --------------------
echo Use Steam Web API:  Input Steam Web API Key, then press Enter.
echo Use xan105 API:     Leave Blank, then press Enter. (Default)
echo If use xan105 API, No Steam Web API Key needed, But Can't Generate Items.
echo --------------------
set /p SteamAPIKEY=Steam API Key:
echo --------------------
mkdir "%~dp0TEMP\steam_settings" %_null%
if NOT defined SteamAPIKEY ( echo Using xan105 API. & "%~dp0bin\generate_game_infos\generate_game_infos.exe" "!GameAPPID!" -o "%~dp0Temp\steam_settings" !Image! )
if defined SteamAPIKEY ( echo Using Steam Web API. & "%~dp0bin\generate_game_infos\generate_game_infos.exe" "!GameAPPID!" -s "!SteamAPIKEY!" -o "%~dp0Temp\steam_settings" !Image! )
echo --------------------
echo Goldberg Steam Emulator Game Info Generated.
echo.
pause
goto :Menu
)



::-----------------Auto apply Goldberg Steam Emulator (Apply + Backup)-----------
:AutoApplyEMU
set "Info=Auto apply Goldberg Steam Emulator (Apply + Backup)"
call :MenuInfo
if NOT EXIST %~dp0Temp\steam_settings echo Please Set Goldberg Steam Emulator first. & pause & goto :Menu
echo Please select steam_api(64).dll :
call :FileSelect File .dll

::steam_api.dll
call :checkfile %FilePath% steam_api.dll
if %result%==1 (
set "_FilePath=%FilePath:"=%"
echo Backuping "!_FilePath!" .......
move /Y "!_FilePath!" "!_FilePath!.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api.dll ......
copy /Y "%~dp0bin\Goldberg\steam_api.dll" "!_FilePath!" %_null%
set _FilePath=!_FilePath:\steam_api.dll=!
echo Copying Config to "!_FilePath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings\" "!_FilePath!\steam_settings\" /E /C /Q /H /R /Y %_null%
echo Goldberg Steam Emulator Applied.
pause
goto :Menu
)

::steam_api64.dll
call :checkfile %FilePath% steam_api64.dll
if %result%==1 (
set "_FilePath=%FilePath:"=%"
echo Backuping "!_FilePath!" .......
move /Y "!_FilePath!" "!_FilePath!.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api64.dll......
copy /Y "%~dp0bin\Goldberg\steam_api64.dll" "!_FilePath!" %_null%
set _FilePath=!_FilePath:\steam_api64.dll=!
echo Copying Config to "!_FilePath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings\" "!_FilePath!\steam_settings\" /E /C /Q /H /R /Y %_null%
echo Goldberg Steam Emulator Applied.
pause
goto :Menu
)
echo Not selected steam_api(64).dll .
pause 
goto :Menu

::-----------------Auto Find and apply Goldberg Steam Emulator (Apply + Backup)-----------
:AutoFindApplyEMU
set "Info=Auto Find and apply Goldberg Steam Emulator (Apply + Backup)"
call :MenuInfo
if NOT EXIST %~dp0Temp\steam_settings echo Please Set Goldberg Steam Emulator first. & pause & goto :Menu
echo Please select Game Folder:
call :FileSelect Folder
FOR /R %FilePath% %%i IN (*.dll) DO ( set "_EMUPathInput=%%i" & call :AutoFindApplyEMU1 )
echo All Goldberg Steam Emulator has been Applied.
echo.
pause 
goto :Menu

:AutoFindApplyEMU1
::steam_api.dll
set _EMUPath=!_EMUPathInput!
call :checkfile "%_EMUPath%" steam_api.dll
if %result%==1 (
echo ---------------
echo Found "%_EMUPath%" .
echo Backuping "%_EMUPath%" .......
move /Y "%_EMUPath%" "%_EMUPath%.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api.dll......
copy /Y "%~dp0bin\Goldberg\steam_api.dll" "%_EMUPath%" %_null%
set _EMUPath=%_EMUPath:\steam_api.dll=%
echo Copying Config to "!_EMUPath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings" "!_EMUPath!\steam_settings" /H /E /Y /C /Q /R /I %_null% 
echo Goldberg Steam Emulator Config Applied.
)
::steam_api64.dll
set _EMUPath=!_EMUPathInput!
call :checkfile "%_EMUPath%" steam_api64.dll
if %result%==1 (
echo ---------------
echo Found "%_EMUPath%" .
echo Backuping "%_EMUPath%" .......
move /Y "%_EMUPath%" "%_EMUPath%.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api64.dll......
copy /Y "%~dp0bin\Goldberg\steam_api64.dll" "%_EMUPath%" %_null%
set _EMUPath=%_EMUPath:\steam_api64.dll=%
echo Copying Config to "!_EMUPath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings" "!_EMUPath!\steam_settings" /H /E /Y /C /Q /R /I %_null% 
echo Goldberg Steam Emulator Config Applied.
)
goto :eof

::------------Auto Unpack----------------
:AutoUnpack
set "Info=Auto Unpack SteamStub (Unpack + Backup)"
call :MenuInfo
echo Please select Packed .exe file:
call :FileSelect File .exe
%~dp0bin\Steamless\Steamless.CLI.exe %FilePath% %_null%
if errorlevel 1 echo Unpack error. (File not Packed/Other Packer) & pause & goto :Menu
echo Unpack successful, backuping......
move /Y %FilePath% %FilePath%.bak %_null%
move /Y %FilePath%.unpacked.exe %FilePath% %_null%
echo File backuped.
pause
goto :Menu


::----------Auto Unpack Find (Unpack + Backup)----------
:AutoUnpackFind
set "Info=Auto find and Unpack SteamStub (Unpack + Backup)"
call :MenuInfo
echo Please select Game Folder:
call :FileSelect Folder
FOR /R %FilePath% %%i IN (*.exe) DO (
echo --------
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
::------------Check File--------------------------
:checkfile
if /I ["%~nx1"]==["%2"] set "result=1"
if /I NOT ["%~nx1"]==["%2"] set "result=0"
set "CheckFileName=%~nx1"
goto :eof
::------------File Selector-------------------------
:FileSelect
set "FilePath="
set "FileType=%1"
set "FileExt=%2"
if /i %FileType%==File (
choice /N /C CIS /M "Please [S]elect File or [I]nput File Full path or [C]ancel: [S,I,C]:"
if errorlevel 3 goto :selectpath 
if errorlevel 2 goto :inputpath  
if errorlevel 1 echo Cenceled. & pause & goto :Menu
)

if /i %FileType%==Folder (
choice /N /C CIS /M "Please [S]elect Folder or [I]nput Folder Full path or [C]ancel: [S,I,C]:"
if errorlevel 3 goto :selectpath 
if errorlevel 2 goto :inputpath
if errorlevel 1 echo Cenceled. & pause & goto :Menu
)

:FileSelect1
if NOT exist %FilePath% echo %FileType% Not Found. & echo -------- & goto :FileSelect
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
if NOT defined FilePath echo No %FileType% selected. & goto :FileSelect
goto :FileSelect1

:selectfolder
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.ShowNewFolderButton=$true;$f.ShowDialog();$f.SelectedPath""
for /F "delims=" %%I in ('%dialog%') do set "FilePath="%%I""
if NOT defined FilePath echo No %FileType% selected. & goto :FileSelect
goto :FileSelect1
::---------------Input File Path---------------
:inputpath
if /i %FileType%==File echo Drag and Drop File or Input File Full Path, then press Enter:
if /i %FileType%==Folder echo Drag and Drop Folder or Input Folder Full Path, then press Enter:
set /p FilePath=
if NOT defined FilePath echo No %FileType% selected. & goto :FileSelect
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
echo  Gitlab: https://gitlab.com/oureveryday/Steam-auto-crack
echo.
pause
goto :Menu

::--------------------Info------------------------
:MenuInfo
cls
echo ---------------------------------------------
echo ---------- Steam Auto Crack %Ver% ------------
echo ---------------------------------------------
echo.
echo ---------------%Info%---------------------
goto :eof

::----------------------Delete TEMP File-----------------
:DelTMP
set Info=Delete TEMP File
call :MenuInfo
if NOT EXIST "%~dp0Temp" echo No TEMP File Generated. & pause & goto :Menu
choice /N /M "Delete TEMP file[Y/N]?"
IF ERRORLEVEL 2 echo Cenceled. & pause & goto :Menu
del /f /s /q "%~dp0Temp" %_null%
rd /s /q "%~dp0Temp" %_null%
echo Temp file deleted.
pause
goto :Menu





