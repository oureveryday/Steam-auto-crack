;Steam Auto Crack v2.0.0
;Automatic Steam Game Cracker
;Github: https://github.com/oureveryday/Steam-auto-crack
;Gitlab: https://gitlab.com/oureveryday/Steam-auto-crack

;--- Script Settings Start ---
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines -1
;--- Script Settings End ---

;--- Script Init Start ---
Init:
global Ver
global FilePath
global FileName
global FileDir
global Cracked
DetectHiddenWindows,On
Running = 0
Ver = V2.0.0
;CheckDependFile()
;--- Script Init End ---

;--- Main ---
Main:
Gui,Main:New,,Steam Auto Crack Apply Crack
Gui Font
Gui Font,s16
Gui Add,Text,x50 y0 w600 h50 +0x200,Steam Auto Crack %Ver% Apply Crack
Gui Font
Gui Add,Text,x10 y120 w100 h25 +0x200,Game Path:
Gui Add,Edit,x105 y120 w450 h25 vAutoUnpackFindFilePath
Gui Add,Button,x20 y250 w170 h60 gAutoUnpackFindUnpackFile,Unpack
Gui Add,Button,x360 y250 w170 h60 gMainGuiClose,Exit
;--- Log Start ---
Gui Add,Text,x5 y415 w200 h15 +0x200,Log
Gui Add,Edit,x5 y430 w590 r11 vLogBox readonly VScroll
Gui Add,Button,x495 y400 w100 h25 gClearLog,Clear Log
;--- Log End ---
GuiControl,,AutoUnpackFindFilePath,%A_ScriptDir%
GuiControl,Disable,AutoUnpackFindFilePath
Gui Show,x500 y300 w600 h600,Steam Auto Crack %Ver% Apply Crack
WinGet Gui_ID,ID,A 
GuiControl Focus,LogBox
ControlGetFocus LogBoxclass,ahk_id %Gui_ID%
Cracked=0
Log(format("Steam Auto Crack {1} Apply Crack",Ver))
return

;--- Clear Log Start ---
ClearLog:
    GuiControl,,LogBox
    return
;--- Clear Log End ---

;--- Logger Start ---
Log(LogString)
{
    global LogBoxClass
    global Gui_ID
    GuiControlGet,LogBox,Main:,LogBox
    GuiControl,Main:,LogBox,%LogBox%`n%LogString%
    ControlSend %LogBoxClass%,^{End},ahk_id %Gui_ID% 
}
;------Logger End----------

MainGuiEscape:
FileDelete,deleter.bat
if (Cracked=1)
{
    MsgBox,36,Delete File,Delete Apply Crack File?
    IfMsgBox Yes
    {   
        FileRemoveDir,%A_ScriptDir%\Steamless,1
        FileAppend,
        (
        timeout /t 1 /nobreak >nul 
        del "%A_ScriptDir%\Apply_Crack.exe"
        del deleter.bat
        ), deleter.bat
        Run, %COMSPEC% /c deleter.bat,,Hide
    }
}
    Exitapp
MainGuiClose:
FileDelete,deleter.bat
if (Cracked=1)
{
    MsgBox,36,Delete File,Delete Apply Crack File?
    IfMsgBox Yes
    {   
        FileRemoveDir,%A_ScriptDir%\Steamless,1
        FileAppend,
        (
        timeout /t 1 /nobreak >nul 
        del "%A_ScriptDir%\Apply_Crack.exe"
        del deleter.bat
        ), deleter.bat
        Run, %COMSPEC% /c deleter.bat,,Hide
    }
}
ExitApp

AutoUnpackFindGuiClose:
Gui,Destroy
return

AutoUnpackFindGuiEscape:
Gui,Destroy
return

;--- Auto Unpack Find End ---

;--- AutoUnpackFindUnpack File Start ---
AutoUnpackFindUnpackFile:
    FilePath = 
    GuiControlGet,FilePath,,AutoUnpackFindFilePath
    if (!FileExist(FilePath))
    {
        Log(Format("Path '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,Path Not Exist.
        return
    }
    Loop,Files,% Format("{1}\*.exe",FilePath),R
    {
    if(SubStr(A_LoopFileFullPath,-12)=".unpacked.exe")
    {
        return
    }
    Log(Format("Found '{1}'. Unpacking...",A_LoopFileFullPath))
    unpack(A_LoopFileFullPath)
    }
    Log(Format("All File in '{1}' Unpacked and Backuped.",FilePath))
    MsgBox,64,Success,All File Unpacked and Backuped.
    Cracked=1
    return
;--- AutoUnpackFindUnpack File End ---

;--- Unpack File Start ---
unpack(Path)
{
if (FileExist(Format("{1}.bak",Path)))
{
Log(Format("Backup File '{1}.bak' Already Exists,Skipping ...",Path))
return 0
}
Log(Format("Unpacking File '{1}'...",Path))
RunWait,Steamless\Steamless.CLI.exe --keepbind "%Path%",,Hide
if (ErrorLevel = 1)
{
    Log(Format("Unpack '{1}' Failed. (File not Packed/Other Packer)",FilePath))
    return 1
}
Else
{
Log(Format("Backuping File '{1}'...",Path))
FileMove,% Path,% Format("{1}.bak",Path),1
FileMove,% Format("{1}.unpacked.exe",Path),% Path,1
return 0
}
}
;--- Unpack File End ---

;--- Check File Start ---
CheckDependFile()
{
DependFilenames:= ["Steamless\Plugins\ExamplePlugin.dll"
,"Steamless\Plugins\SharpDisasm.dll"
,"Steamless\Plugins\Steamless.API.dll"
,"Steamless\Plugins\Steamless.Unpacker.Variant10.x86.dll"
,"Steamless\Plugins\Steamless.Unpacker.Variant20.x86.dll"
,"Steamless\Plugins\Steamless.Unpacker.Variant21.x86.dll"
,"Steamless\Plugins\Steamless.Unpacker.Variant30.x64.dll"
,"Steamless\Plugins\Steamless.Unpacker.Variant30.x86.dll"
,"Steamless\Plugins\Steamless.Unpacker.Variant31.x64.dll"
,"Steamless\Plugins\Steamless.Unpacker.Variant31.x86.dll"
,"Steamless\Steamless.CLI.exe"
,"Steamless\Steamless.CLI.exe.config"
,"Steamless\Steamless.exe"
,"Steamless\Steamless.exe.config"]
for key,DependFilename in DependFilenames
{
    if (!FileExist(DependFilename))
        MsgBox,16,Error,File %DependFilename% is Missing.`nApply Crack May Not Operate Normally.    
    }
}
;--- Check File End ---
