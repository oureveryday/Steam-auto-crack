del /f /s /q ..\bin\Steamautocrack
rd /s /q ..\bin\Steamautocrack
xcopy "%~dp0..\src\" "%~dp0..\bin\Steamautocrack\" /H /E /Y /C /Q /R /I
mkdir ..\bin\Steamautocrack\
ahk2exe.exe /in "%~dp0..\src\Steamautocrack.ahk" /out "%~dp0..\bin\Steamautocrack\Steamautocrack.exe" /base "%~dp0Unicode 32-bit.bin" /compress 0 /icon "%~dp0..\icon\Steamautocrack.ico"
ahk2exe.exe /in "%~dp0..\src\bin\Apply_Crack\Apply_Crack.ahk" /out "%~dp0..\bin\Steamautocrack\bin\Apply_Crack\Apply_Crack.exe" /base "%~dp0Unicode 32-bit.bin" /compress 0 /icon "%~dp0..\icon\Steamautocrack.ico"
del /f /s /q ..\bin\Steamautocrack\Steamautocrack.ahk
del /f /s /q ..\bin\Steamautocrack\bin\Apply_Crack\Apply_Crack.ahk
pause