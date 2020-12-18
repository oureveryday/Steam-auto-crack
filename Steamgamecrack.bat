@echo off
color F1
chcp 65001
cd /d %~dp0
cls

:select
set select=""
echo Select crack options:
echo 1.Auto crack(Unpack+Emu apply)
echo 2.Auto unpack(Unpack+Backup)
echo 3.Auto apply EMU(Apply+Backup)
echo 4.EMU config(Appid+Achievements+DLC)
echo 5.EMU setting(Language+UserID)
echo 6.Delete TEMP File(Run before crack)
echo 7.Open EMU setting floder
echo 8.Exit
set /p select=Select:
if /i "%select%"=="1" goto crack
if /i "%select%"=="2" cls & goto unpack
if /i "%select%"=="3" goto EMUapply
if /i "%select%"=="4" goto EMUconfig
if /i "%select%"=="5" goto EMUsetting
if /i "%select%"=="6" goto deletetemp
if /i "%select%"=="7" goto open
if /i "%select%"=="8" exit
cls
goto select

:Open
start "" "%~dp0Temp\steam_settings\settings"
cls
goto select

:EMUapply
cls
echo Selected EMU auto Apply.
if /i exist %~dp0Temp\steam_settings>nul 2>nul (nul) else ( cls & echo Please config steam api first. & echo. & goto select)
if /i exist %~dp0Temp\steam_settings\settings >nul 2>nul (nul) else ( cls & echo Please set steam api first. & echo. & goto select)

set /p gamedir=Drag and drop or steam api directory:
if /i [%gamedir%]==[] cls & echo No steam api selected. & echo. & goto select
if /i exist %gamedir% (nul)>nul 2>nul else cls & echo Input steam api directory not found. & echo. & goto select 
echo Selected directory %gamedir%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Applying Steam EMU......
call %~dp0AutoEMUApply\AutoEMUApply.bat %gamedir%
echo Steam EMU applied.
pause
cls
goto select



:crack
cls
echo Selected Auto crack.
if /i exist %~dp0Temp\steam_settings>nul 2>nul (nul) else ( cls & echo Please config steam api first. & echo. & goto select)
if /i exist %~dp0Temp\steam_settings\settings >nul 2>nul (nul) else ( cls & echo Please set steam api first. & echo. & goto select)

set /p gamedir=Drag and drop or input game directory:
if /i [%gamedir%]==[] cls & echo No game directory selected. & echo. & goto select
if /i exist %gamedir% (nul)>nul 2>nul else cls & echo Input game directory not found. & echo. & goto select 
echo Selected directory %gamedir%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Unpacking......
call %~dp0FindExeUnpackModule\FindExeUnpackModule.bat %gamedir%
echo File unpacked and a backup was made.
echo Applying Steam EMU......
call %~dp0FindAPIApplyModule\FindAPIApplyModule.bat %gamedir%
echo Steam EMU applied.
pause
cls
goto select




:unpack
echo Selected Unpack.
set /p exedir=Drag and drop or input exe file:
echo Selected file %exedir%
if /i [%exedir%]==[] cls & echo No input file selected. & echo. & goto select
if /i exist %exedir% (nul)>nul 2>nul else cls & echo Input file not found. & echo. & goto select >nul 2>nul
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Unpacking......
call %~dp0AutoUnpackModule\AutoUnpackModule.bat %exedir%
echo File unpacked and a backup was made.
pause
cls
goto select

:deletetemp
del /f /s /q %~dp0Temp>nul 2>nul
rd /s /q %~dp0Temp
cls
echo Temp file deleted.
echo.
goto select


:EMUconfig
cls
echo Selected EMUconfig.
set /p appid=Input appid:
if /i [%appid%]==[] cls & echo No appid input. & echo. & goto select
echo Enable no steam api key mode?
choice
IF /i ERRORLEVEL 2 ( set /p apikey=Input Steam api key: & if /i [%apikey%]==[] ( cls & echo No Steam api key input. & echo. & goto select))
echo appid:%appid% , Steam api key:%apikey%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Getting game info......
call %~dp0AutoEMUConfigModule\AutoEMUConfigModule.bat %appid% %apikey%
echo Steam EMU config completed.
pause
cls
goto select

:EMUsetting
cls
if /i exist %~dp0Temp\steam_settings>nul 2>nul (nul) else ( cls & echo Please config steam api first. & echo. & goto select)
echo Selected EMUsetting.
echo For default leave blank.
set /p account=Input account_name:
copy /Y %~dp0AutoEMUSetModule\Example\language.txt %~dp0Temp\language.txt >nul 2>nul
start "" "%~dp0Temp\language.txt"
set /p language=Input language:
del /f /s /q %~dp0Temp\language.txt >nul 2>nul
set /p listenport=Input listen_port:
set /p steamid=Input user_steam_id:
if /i [%account%]==[] set account=""
if /i [%language%]==[] set language=""
if /i [%listenport%]==[] set listenport=""
if /i [%steamid%]==[] set steamid=""
echo account_name:%account%
echo Language:%language%
echo listen_port:%listenport%
echo user_steam_id:%steamid%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
cd /d %~dp0
call AutoEMUSetModule\AutoEMUSetModule.bat %account% %language% %listenport% %steamid%
echo Steam EMU set completed.
pause
cls
goto select




