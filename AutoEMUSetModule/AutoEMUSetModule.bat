@echo off
chcp 65001 >nul 2>nul
cd /d %~dp0
del /f /s /q %~dp0..\Temp\steam_settings\settings >nul 2>nul
set a=
set b=
set c=
set d=
if [%1]==[/?] goto usage
if [%1]==[] (set a=goldberg) else (if [%1]==[""] (set a=goldberg) else (set a=%1))
if [%2]==[] (set b=english) else (if [%2]==[""] (set b=english) else (set b=%2))
if [%3]==[] (set c=47584) else (if [%3]==[""] (set c=47584) else (set c=%3))
if [%4]==[] (set d=76561198648917173) else (if [%4]==[""] (set d=76561198648917173) else (set d=%4))

mkdir %~dp0..\Temp\steam_settings\settings >nul 2>nul
set /p =%a%<nul >%~dp0..\Temp\steam_settings\settings\account_name.txt
set /p =%b%<nul >%~dp0..\Temp\steam_settings\settings\language.txt
set /p =%c%<nul >%~dp0..\Temp\steam_settings\settings\listen_port.txt
set /p =%d%<nul >%~dp0..\Temp\steam_settings\settings\user_steam_id.txt
goto end

:usage
echo Usage: AutoEMUSetModule.bat [account_name] [language] [listen_port] [user_steam_id]


:end
