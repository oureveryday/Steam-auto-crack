;Steam Auto Crack v2.2.4
;Automatic Steam Game Cracker
;Github: https://github.com/oureveryday/Steam-auto-crack
;Gitlab: https://gitlab.com/oureveryday/Steam-auto-crack

;--- Script Settings Start ---
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
#NoTrayIcon
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
global Processing
Processing = 0
DetectHiddenWindows,On
Running = 0
Ver = v2.2.4
CheckDependFile()

OnError("ErrorHandler")

ErrorHandler(exception) {
    FileAppend % "Error on line " exception.Line ": " exception.Message "`n" , error.log
    MsgBox,16,Error,% "Error on line " exception.Line ": " exception.Message "`n" , error.log
    Processing = 0
    Running = 0
    return true
}
;--- Script Init End ---

;--- Main ---
Main:
Gui,Main:New,,Steam Auto Crack Apply Crack
Gui Font
Gui Font,s16
Gui Add,Text,x100 y20 w600 h30 +0x200,Steam Auto Crack %Ver% Apply Crack
Gui Font
Gui Add,Text,x10 y70 w100 h25 +0x200,Game Path:
Gui Add,Edit,x105 y70 w450 h25 vAutoUnpackFindFilePath
Gui Add,Button,x20 y130 w170 h60 gAutoUnpackFindUnpackFile,Unpack
Gui Add,Button,x220 y130 w170 h60 gMainGuiClose,Exit
Gui Add,Button,x420 y130 w170 h60 gAbout,About
;--- Log Start ---
Gui Add,Text,x5 y215 w200 h15 +0x200,Log
Gui Add,Edit,x5 y240 w590 r16 vLogBox HwndhLogBox readonly VScroll
Gui Add,Button,x495 y210 w100 h25 gClearLog,Clear Log
;--- Log End ---
GuiControl,,AutoUnpackFindFilePath,%A_ScriptDir%
GuiControl,Disable,AutoUnpackFindFilePath
Gui Show,x500 y300 w600 h500,Steam Auto Crack %Ver% Apply Crack
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
    global hLogBox
    Edit_Append(hLogBox,LogString . "`r`n")
}
;------Logger End----------

MainGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Crack Complete before Closing.
    return
}
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
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Crack Complete before Closing.
    return
}
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


;--- Auto Unpack Find End ---

;--- AutoUnpackFindUnpack File Start ---
AutoUnpackFindUnpackFile:
    Processing = 1
    FilePath = 
    GuiControlGet,FilePath,,AutoUnpackFindFilePath
    if (!FileExist("Steamless\Steamless.CLI.exe"))
    {
        Log(Format("Steamless Not Exist.",FilePath))
        MsgBox,16,Error,Steamless Not Exist.
        Processing = 0
        return
    }
    if (!FileExist(FilePath))
    {
        Log(Format("Path '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,Path Not Exist.
        Processing = 0
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
    Processing = 0
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
    Log(Format("Unpack '{1}' Failed. (File not Packed/Other Packer)",Path))
    return 1
}
Else
{
Log(Format("Backuping File '{1}'...",Path))
FileMove,% Path,% Format("{1}.bak",Path),1
FileMove,% Format("{1}.unpacked.exe",Path),% Path,1
Log(Format("Unpack '{1}' Success.",Path))
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
    {
        DependFileMissing:=1
        MissingDependFiles:=MissingDependFiles . "`n" . """" . DependFilename . """"
    }
}
if (DependFileMissing)
{
    MsgBox,16,Error,% "Some Dependency Files are Missing.`nSteam Auto Crack May Not Operate Normally.`nMissing File List:" . MissingDependFiles
}
}
;--- Check File End ---

;--- About Start ---
About:
Log("Steam Auto Crack "+ Ver)
Log("Automatic Steam Game Cracker")
Log("Github: https://github.com/oureveryday/Steam-auto-crack")
Log("Gitlab: https://gitlab.com/oureveryday/Steam-auto-crack")
Log("Autohotkey Version: " . A_AhkVersion)
MsgBox,64,About, Steam Auto Crack %Ver%`nAutomatic Steam Game Cracker`nGithub: https://github.com/oureveryday/Steam-auto-crack`nGitlab: https://gitlab.com/oureveryday/Steam-auto-crack
return
;--- About End ---

;------------ Edit_Append Start ----------
Edit_Append(hEdit, Txt) { ; Modified version by SKAN
Local        ; Original by TheGood on 09-Apr-2010 @ autohotkey.com/board/topic/52441-/?p=328342
  L := DllCall("SendMessage", "Ptr",hEdit, "UInt",0x0E, "Ptr",0 , "Ptr",0)   ; WM_GETTEXTLENGTH
       DllCall("SendMessage", "Ptr",hEdit, "UInt",0xB1, "Ptr",L , "Ptr",L)   ; EM_SETSEL
       DllCall("SendMessage", "Ptr",hEdit, "UInt",0xC2, "Ptr",0 , "Str",Txt) ; EM_REPLACESEL
}
;------------ Edit_Append End ----------
