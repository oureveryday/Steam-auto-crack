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
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.R
SetBatchLines -1
;--- Script Settings End ---

;--- Script Init Start ---
Init:
global Ver
global Running
global FilePath
global FileName
global FileDir
global LatestJobID
global CurrentJobID
global FileSelectorPath
global OutputPath
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


MainMenu:
Gui MainMenu:New,,Steam Auto Crack %Ver%
;--- Info Start ---
Gui Font,s9,Segoe UI

if(A_IsCompiled)
{
Gui Add,Picture,x300 y10 w90 h90,%A_ScriptFullPath%
}
else
{
Gui Add,Picture,x300 y10 w90 h90,icon\SteamAutoCrack.png
}
Gui Font
Gui Font,s20
Gui Add,Text,x450 y10 w380 h100 +0x200,Steam Auto Crack %Ver%
Gui Add,Text,x530 y80 w380 h30 +0x200,Main Menu
Gui Font
;--- Info End ---
;--- Log Start ---
Gui Add,Text,x605 y120 w200 h12 +0x200,Log
Gui Add,Edit,x605 y135 w590 r25 vLogBox HwndhLogBox readonly VScroll
Gui Add,Button,x1095 y110 w100 h25 gClearLog,Clear Log
;--- Log End ---
;--- Main Options Start ---
Gui Add,Button,x10 y150 w100 h50 gAutoCrack,Auto Crack
Gui Add,Button,x110 y150 w110 h50 gDelTMP,Delete TEMP File
Gui Add,Button,x220 y150 w100 h50 gRestore,Restore Crack
Gui Add,Button,x320 y150 w100 h50 gGenCrack,Generate Crack Only Files
Gui Add,Button,x420 y150 w70 h50 gAbout,About
Gui Add,Button,x490 y150 w70 h50 gExit,Exit

Gui Add,GroupBox,x5 y130 w590 h80,Main Options
;--- Main Options End ---
;--- EXE Crack Options Start ---
Gui Add,Button,x10 y250 w200 h50 gAutoUnpack,Auto Unpack SteamStub
Gui Add,Button,x210 y250 w300 h50 gAutoUnpackFind,Auto Find EXE and Unpack SteamStub
Gui Add,GroupBox,x5 y230 w590 h80,EXE Crack Options
;--- EXE Crack Options End ---
;--- Steam Emulator Options Start ---
Gui Add,Button,x10 y350 w250 h50 gAutoApplyEMU,Auto Apply Goldberg Steam Emulator
Gui Add,Button,x260 y350 w300 h50 gAutoFindApplyEMU,Auto Find and apply Goldberg Steam Emulator
Gui Add,Button,x10 y410 w250 h50 gEMUConfig,Goldberg Steam Emulator Configuration
Gui Add,Button,x260 y410 w300 h50 gUpdateEMU,Update/Download Goldberg Steam Emulator
Gui Add,GroupBox,x5 y330 w590 h162,Steam Emulator Options
;--- Steam Emulator Options End ---
Gui Show,w1200 h500,Steam Auto Crack %Ver%
WinGet Gui_ID,ID,A 
GuiControl Focus,LogBox
ControlGetFocus LogBoxclass,ahk_id %Gui_ID% 
Log("Steam Auto Crack "+ Ver)
return

MainMenuGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
    Exitapp
MainMenuGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
    ExitApp
Main:
Gosub,Init
Gosub,MainMenu

;--- Exit Start ---
Exit:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
    ExitApp
;--- Exit End ---

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

;--- Delete Temp File Start ---
DelTMP:
    MsgBox,36,Delete TEMP File,Delete All TEMP File?
    IfMsgBox Yes
    {   FileRemoveDir,TEMP,1
        Log("TEMP File Deleted.")
    }
    return
;--- Delete Temp File End ---

;--- Check File Start ---
CheckDependFile()
{
MissingDependFiles:=
DependFileMissing:=0
DependFilenames:= ["bin\7z\7za.dll"
,"bin\7z\7za.exe"
,"bin\7z\7zxa.dll"
,"bin\Apply_Crack\Apply_Crack.exe"
,"bin\generate_game_infos\generate_game_infos.exe"
,"bin\generate_game_infos\libcurl.dll"
,"bin\generate_game_infos\libgcc_s_dw2-1.dll"
,"bin\generate_game_infos\libstdc++-6.dll"
,"bin\Goldberg\generate_interfaces_file.exe"
,"bin\Goldberg\job_id"
,"bin\Goldberg\steam_api.dll"
,"bin\Goldberg\steam_api64.dll"
,"bin\Steamless\Plugins\ExamplePlugin.dll"
,"bin\Steamless\Plugins\SharpDisasm.dll"
,"bin\Steamless\Plugins\Steamless.API.dll"
,"bin\Steamless\Plugins\Steamless.Unpacker.Variant10.x86.dll"
,"bin\Steamless\Plugins\Steamless.Unpacker.Variant20.x86.dll"
,"bin\Steamless\Plugins\Steamless.Unpacker.Variant21.x86.dll"
,"bin\Steamless\Plugins\Steamless.Unpacker.Variant30.x64.dll"
,"bin\Steamless\Plugins\Steamless.Unpacker.Variant30.x86.dll"
,"bin\Steamless\Plugins\Steamless.Unpacker.Variant31.x64.dll"
,"bin\Steamless\Plugins\Steamless.Unpacker.Variant31.x86.dll"
,"bin\Steamless\Steamless.CLI.exe"
,"bin\Steamless\Steamless.CLI.exe.config"
,"bin\Steamless\Steamless.exe"
,"bin\Steamless\Steamless.exe.config"]
for key,DependFilename in DependFilenames
{
    if (!FileExist(DependFilename))
    {
        DependFileMissing:=1
        MissingDependFiles:=MissingDependFiles . "`n" . """" . DependFilename . """"
    }
}
if(!A_IsCompiled)
{
   if (!FileExist("icon\SteamAutoCrack.png"))
    {
        DependFileMissing:=1
        MissingDependFiles:=MissingDependFiles . "`n" . """icon\SteamAutoCrack.png"""
    } 
}
if (DependFileMissing)
{
    MsgBox,16,Error,% "Some Dependency Files are Missing.`nSteam Auto Crack May Not Operate Normally.`nMissing File List:" . MissingDependFiles
}
}
;--- Check File End ---

;--- Auto Unpack Start ---
AutoUnpack:
    If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,AutoUnpack:New,,Auto Unpack SteamStub (Unpack + Backup)
Gui Font
Gui Font,s20
Gui Add,Text,x50 y0 w600 h50 +0x200,Auto Unpack SteamStub (Unpack + Backup)
Gui Font
Gui Add,Text,x10 y120 w100 h25 +0x200,.exe File Path:
Gui Add,Edit,x105 y120 w450 h25 vAutoUnpackFilePath
Gui Add,Button,x560 y120 w35 h25 gAutoUnpackSelectFile,...
Gui Add,Button,x20 y250 w170 h60 gAutoUnpackUnpackFile,Unpack
Gui Add,Button,x360 y250 w170 h60 gAutoUnpackGuiClose,Close
Gui Show,x500 y500 w600 h400,Auto Unpack SteamStub (Unpack + Backup)
return

AutoUnpackSelectFile:
FileSelectorPath =
FileSelectFile,FileSelectorPath,1,,Select File,.exe file(*.exe)
GuiControl,AutoUnpack:,AutoUnpackFilePath,%FileSelectorPath%
return

AutoUnpackGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Unpack Complete before Closing.
    return
}
Running = 0
FilePath =
FileSelectorPath =
Gui,Destroy
return

AutoUnpackGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Unpack Complete before Closing.
    return
}
Running = 0
FilePath =
FileSelectorPath =
Gui,Destroy
return

AutoUnpackGuiDropFiles:
if(A_EventInfo=1)
{
    if (A_GuiControl="AutoUnpackFilePath")
    {   
        GuiControl,AutoUnpack:,AutoUnpackFilePath,% A_GuiEvent
    }
}
return
;--- Auto Unpack End ---

;--- AutoUnpackUnpack File Start ---
AutoUnpackUnpackFile:
    Processing = 1
    FilePath = 
    GuiControlGet,FilePath,AutoUnpack: ,AutoUnpackFilePath
    if (!FileExist(FilePath))
    {
        Log(Format("File '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,File Not Exist.
        Processing = 0
        return
    }
    if(unpack(FilePath) = 0)
    {
        MsgBox,64,Success,File Unpacked and Backuped.
        Log(Format("File '{1}' Unpack Success.",FilePath))
    }
    else
    {
        Log(Format("File '{1}' Unpack Failed.",FilePath))
        MsgBox,16,Error,File Unpack Failed.
    }
    Processing = 0
    return
;--- AutoUnpackUnpack File End ---

;--- Auto Unpack Find Start ---
AutoUnpackFind:
    If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,AutoUnpackFind:New,,Auto find and Unpack SteamStub (Unpack + Backup)
Gui Font
Gui Font,s16
Gui Add,Text,x50 y0 w600 h50 +0x200,Auto find and Unpack SteamStub (Unpack + Backup)
Gui Font
Gui Add,Text,x10 y120 w100 h25 +0x200,Game Path:
Gui Add,Edit,x105 y120 w450 h25 vAutoUnpackFindFilePath
Gui Add,Button,x560 y120 w35 h25 gAutoUnpackFindSelectFile,...
Gui Add,Button,x20 y250 w170 h60 gAutoUnpackFindUnpackFile,Unpack
Gui Add,Button,x360 y250 w170 h60 gAutoUnpackFindGuiClose,Close
Gui Show,x500 y500 w600 h400,Auto find and Unpack SteamStub (Unpack + Backup)
return

AutoUnpackFindSelectFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,,0,Select Path
GuiControl,AutoUnpackFind:,AutoUnpackFindFilePath,%FileSelectorPath%
return

AutoUnpackFindGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
Running = 0
FilePath =
FileSelectorPath =
Gui,Destroy
return

AutoUnpackFindGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
Running = 0
FilePath =
FileSelectorPath =
Gui,Destroy
return

AutoUnpackFindGuiDropFiles:
if(A_EventInfo=1)
{
    if (A_GuiControl="AutoUnpackFindFilePath")
    {   
        GuiControl,AutoUnpackFind:,AutoUnpackFindFilePath,% A_GuiEvent
    }
}
return

;--- Auto Unpack Find End ---

;--- AutoUnpackFindUnpack File Start ---
AutoUnpackFindUnpackFile:
    Processing = 1
    FilePath = 
    GuiControlGet,FilePath,AutoUnpackFind: ,AutoUnpackFindFilePath
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
RunWait,bin\Steamless\Steamless.CLI.exe --keepbind "%Path%",,Hide
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

;--- EMU Config Start ---
EMUConfig:
    If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,EMUConfig:New,,Goldberg Steam Emulator Configuration
Gui Font
Gui Font,s20
Gui Add,Text,x370 y0 w600 h50 +0x200,Goldberg Steam Emulator Configuration
Gui Font
Gui Add,Text,x10 y50 w100 h25 +0x200,Steam App ID:
Gui Add,Edit,x105 y50 w70 h25 vEMUConfigAPPID
Gui Add,Link,x380 y60 w200 h25,Get App ID on <a href="https://steamdb.info/">SteamDB</a>
;------
Gui Add,GroupBox,x10 y120 w580 h150,Generate Game Info
Gui Add,CheckBox,x40 y140 w130 h25 vEMUConfigGenOnline gEMUConfigGenUpdate,Generate Online
Gui Add,CheckBox,x40 y170 w130 h25 vEMUConfigUseAPIKey gEMUConfigGenUpdate,Use Steam API Key:
Gui Add,Edit,x190 y170 w200 h25 vEMUConfigAPIKey gEMUConfigGenUpdate
Gui Add,CheckBox,x40 y200 w200 h25 vEMUConfigGenIMG gEMUConfigGenUpdate,Generate Achievement Images
Gui Add,Button,x220 y230 w120 h25 gEMUConfigGenInfo,Generate Game Info
Gui Add,Button,x100 y230 w120 h25 gEMUConfigGenInfoDefault,Default Setting
;------
Gui Add,GroupBox,x610 y60 w580 h210,Settings
Gui Add,Text,x615 y75 w100 h25 +0x200,Language:
Gui Add,DropDownList,x700 y80 w100 vEMUSettingLanguage,arabic|bulgarian|schinese|tchinese|czech|danish|dutch|english|finnish|french|german|greek|hungarian|italian|japanese|koreana|norwegian|polish|portuguese|brazilian|romanian|russian|spanish|swedish|thai|turkish|ukrainian
Gui Add,CheckBox,x900 y75 w100 h25 vEMUSettingLanguageForce,Force
Gui Add,Text,x615 y100 w100 h25 +0x200,Listen Port:
Gui Add,Edit,x700 y105 w150 h20 vEMUSettingListen
Gui Add,CheckBox,x900 y100 w100 h25 vEMUSettingListenForce,Force
Gui Add,Text,x615 y125 w100 h25 +0x200,Account Name:
Gui Add,Edit,x700 y130 w150 h20 vEMUSettingAccount
Gui Add,CheckBox,x900 y125 w100 h25 vEMUSettingAccountForce,Force
Gui Add,Text,x615 y150 w100 h25 +0x200,Steam ID:
Gui Add,Edit,x700 y155 w150 h20 vEMUSettingSteamID
Gui Add,CheckBox,x900 y150 w100 h25 vEMUSettingSteamIDForce,Force
Gui Add,CheckBox,x615 y180 w100 h25 vEMUSettingOffline,Offline mode
Gui Add,CheckBox,x900 y180 w150 h25 vEMUDisableNet,Disable Networking
Gui Add,CheckBox,x615 y205 w140 h25 vEMUSettingUseCustomIP gEMUSettingUpdateCustomIP,Custom Broadcast IP:
Gui Add,Edit,x755 y210 w130 h20 vEMUSettingCustomIP
Gui Add,CheckBox,x900 y205 w150 h25 vEMUDisableOverlay,Disable Overlay
Gui Add,Button,x615 y240 w120 h25 gEMUSettingDefault,Default Setting
Gui Add,Button,x740 y240 w120 h25 gEMUSettingOpenExample,Open Example
Gui Add,Button,x865 y240 w150 h25 gEMUSettingSettingsFolder,Open Settings Folder
;------
Gui Add,GroupBox,x10 y275 w1180 h120,Generate Steam Interfaces
Gui Add,Text,x15 y295 w530 h25,You Only Need to Do This For steam_api(64).dll Older Than May 2016.
Gui Add,Text,x15 y315 w530 h25,Apply Goldberg Steam Emulator first, then Select steam_api(64).dll.bak File.
Gui Add,Text,x15 y335 w530 h25,steam_api(64).dll.bak Path:
Gui Add,Edit,x185 y330 w360 h20 vEMUConfigGenInterfaceFile
Gui Add,Button,x550 y330 w35 h25 gEMUConfigGenInterfaceSelectFile,...
Gui Add,Button,x15 y360 w150 h25 gEMUConfigGenInterfaceGen,Generate

;------
Gui Add,Text,x10 y80 w100 h25 +0x200,Game Info:
Gui Add,Text,x100 y80 w100 h25 +0x200 vGameInfoStatus
Gui Add,Button,x200 y80 w150 h25 gEMUConfigStatus,Check Game Info Status
Gui Add,Button,x200 y420 w170 h60 gEMUSettingSave,Save
Gui Add,Button,x700 y420 w170 h60 gEMUConfigGuiClose,Close
Gui Show,x500 y70 w1200 h500,Goldberg Steam Emulator Config
GuiControl,,EMUConfigGenOnline,1
GuiControl,,EMUConfigUseAPIKey,0
GuiControl,,EMUConfigAPIKey,0
GuiControl,,EMUConfigGenIMG,0
GuiControl,Disable,EMUConfigUseAPIKey
GuiControl,Disable,EMUConfigAPIKey
GuiControl,Disable,EMUConfigGenIMG
GuiControl,Disable,EMUSettingCustomIP
EMUConfigGenInfoDefault()
EMUConfigStatus()
EMUSettingDefault()
return

EMUConfigGenInterfaceSelectFile:
FileSelectorPath =
FileSelectFile,FileSelectorPath,1,,Select File,steam_api[64].dll.bak file(steam_api.dll.bak;steam_api64.dll.bak)
GuiControl,,EMUConfigGenInterfaceFile,%FileSelectorPath%
return

EMUConfigGenInterfaceGen:
    Processing = 1
    GuiControlGet,EMUConfigGenInterfaceFile,,EMUConfigGenInterfaceFile
    if (!FileExist(EMUConfigGenInterfaceFile))
    {
        Log(Format("File '{1}' Not Exist.",EMUConfigGenInterfaceFile))
        MsgBox,16,Error,File Not Exist.
        Processing = 0
        return
    }
    SplitPath,EMUConfigGenInterfaceFile,EMUConfigGenInterfaceFileName
    if (EMUConfigGenInterfaceFileName != "steam_api.dll.bak" && EMUConfigGenInterfaceFileName != "steam_api64.dll.bak")
    {
        MsgBox,16,Error,File is Not steam_api(64).dll.bak.
        Processing = 0
        return
    }
    SplitPath,EMUConfigGenInterfaceFile,,EMUConfigGenInterfaceFileNameDir
    log(EMUConfigGenInterfaceFileNameDir)
    Log(format("Generating Steam Interfaces for '{1}'...",EMUConfigGenInterfaceFile))
    RunWait,% format("""{2}\bin\Goldberg\generate_interfaces_file.exe"" ""{1}""",EMUConfigGenInterfaceFile,A_ScriptDir),% EMUConfigGenInterfaceFileNameDir,Hide
    Log("Generated.")
    MsgBox,64,Info,Generated.
    Processing = 0
    return
EMUSettingOpenExample:
    Run % format("explorer.exe ""{1}\bin\Goldberg\Example""",A_ScriptDir)
    return
EMUSettingSettingsFolder:
if (!FileExist("Temp\steam_settings"))
{
    MsgBox,64,Info,Settings Not Generated.
}
else
{
    Run % format("explorer.exe ""{1}\Temp\steam_settings""",A_ScriptDir)
}
    return
EMUSettingUpdateCustomIP:
GuiControlGet,EMUSettingUseCustomIP,,EMUSettingUseCustomIP
if ( EMUSettingUseCustomIP = 1 )
{
GuiControl,Enable,EMUSettingCustomIP
}
else
{
GuiControl,Disable,EMUSettingCustomIP
}
return

EMUSettingSave:
{
    Processing = 1
    GuiControlGet,EMUSettingListen,,EMUSettingListen
    GuiControlGet,EMUSettingAccount,,EMUSettingAccount
    GuiControlGet,EMUSettingSteamID,,EMUSettingSteamID
    GuiControlGet,EMUSettingOffline,,EMUSettingOffline
    GuiControlGet,EMUDisableNet,,EMUDisableNet
    GuiControlGet,EMUDisableOverlay,,EMUDisableOverlay
    GuiControlGet,EMUSettingLanguage,,EMUSettingLanguage
    GuiControlGet,EMUSettingLanguageForce,,EMUSettingLanguageForce
    GuiControlGet,EMUSettingListenForce,,EMUSettingListenForce
    GuiControlGet,EMUSettingAccountForce,,EMUSettingAccountForce
    GuiControlGet,EMUSettingSteamIDForce,,EMUSettingSteamIDForce
    GuiControlGet,EMUSettingCustomIP,,EMUSettingCustomIP
    GuiControlGet,EMUSettingUseCustomIP,,EMUSettingUseCustomIP
    FileCreateDir,Temp\steam_settings\settings
    Log("Saving Settings...")
    FileRemoveDir,TEMP\steam_settings\settings,1
    FileDelete,Temp\steam_settings\force_language.txt
    FileDelete,Temp\steam_settings\force_listen_port.txt
    FileDelete,Temp\steam_settings\force_account_name.txt
    FileDelete,Temp\steam_settings\force_steamid.txt
    FileDelete,Temp\steam_settings\offline.txt
    FileDelete,Temp\steam_settings\disable_networking.txt
    if (EMUConfigStatus()=0)
    {
        Log("Game Info Not Generated.")
        MsgBox,16,Error,Game Info Not Generated.
        return
    }
    FileCreateDir,TEMP\steam_settings\settings
    if EMUSettingListen is not digit
    {
        Log("Wrong Listen Port.")
        MsgBox,16,Error,Wrong Listen Port.
        return
    }
    if (EMUSettingListen = "" )
    {
        Log("Empty Listen Port.")
        MsgBox,16,Error,Empty Listen Port.
        return
    }
    if EMUSettingSteamID is not digit
    {
        Log("Wrong Steam ID.")
        MsgBox,16,Error,Wrong Steam ID.
        return
    }
    if (EMUSettingSteamID = "" )
    {
        Log("Empty Steam ID.")
        MsgBox,16,Error,Empty Steam ID.
        return
    }
    if (EMUSettingListen = "" )
    {
        Log("Empty Listen Port.")
        MsgBox,16,Error,Empty Listen Port.
        return
    }
    if (EMUSettingAccount = "" )
    {
        Log("Empty Account Name.")
        MsgBox,16,Error,Empty Account Name.
        return
    }
    if (EMUSettingUseCustomIP = 1)
    {
        if (EMUSettingCustomIP = "" )
        {
            Log("Empty Custom IP.")
            MsgBox,16,Error,Empty Custom IP.
            return
        }
    }
    If (EMUSettingLanguageForce = 1)
    {
        FileAppend ,% EMUSettingLanguage,Temp\steam_settings\force_language.txt
    }
    Else
    {
        FileAppend ,% EMUSettingLanguage,Temp\steam_settings\settings\language.txt
    }
    If (EMUSettingListenForce = 1)
    {
        FileAppend ,% EMUSettingListen,Temp\steam_settings\force_listen_port.txt
    }
    Else
    {
        FileAppend ,% EMUSettingListen,Temp\steam_settings\settings\listen_port.txt
    }
    If (EMUSettingAccountForce = 1)
    {
        FileAppend ,% EMUSettingAccount,Temp\steam_settings\force_account_name.txt
    }
    Else
    {
        FileAppend ,% EMUSettingAccount,Temp\steam_settings\settings\account_name.txt
    }
    If (EMUSettingSteamIDForce = 1)
    {
        FileAppend ,% EMUSettingSteamID,Temp\steam_settings\force_steamid.txt
    }
    Else
    {
        FileAppend ,% EMUSettingSteamID,Temp\steam_settings\settings\user_steam_id.txt
    }
    If (EMUSettingOffline = 1)
    {
        FileAppend ,,Temp\steam_settings\offline.txt
    }
    If (EMUDisableNet = 1)
    {
        FileAppend ,,Temp\steam_settings\disable_networking.txt
    }
    If (EMUDisableOverlay = 1)
    {
        FileAppend ,,Temp\steam_settings\disable_overlay.txt
    }
    If (EMUSettingUseCustomIP = 1)
    {
        FileAppend ,% EMUSettingCustomIP,Temp\steam_settings\settings\custom_broadcast_ip.txt
    }

    Log("Settings Saved.")
    MsgBox,64,Info,Settings Saved.
    Processing = 0
}

EMUSettingDefault()
{
languages=english
language := SubStr(A_Language,3,2)
switch language
{
case "01":
    languages=arabic
case "02":
    languages=bulgarian
case "05":
    languages=czech
case "06":
    languages=danish
case "13":
    languages=dutch
case "09":
    languages=english
case "0b":
    languages=finnish
case "0c":
    languages=french
case "07":
    languages=german
case "08":
    languages=greek
case "0e":
    languages=hungarian
case "10":
    languages=italian
case "11":
    languages=japanese
case "12":
    languages=koreana
case "14":
    languages=norwegian
case "15":
    languages=polish
case "18":
    languages=romanian
case "19":
    languages=russian
case "0a":
    languages=spanish
case "1d":
    languages=swedish
case "1e":
    languages=thai
case "1f":
    languages=turkish
case "22":
    languages=ukrainian
}
switch A_Language
{
case "0804":
languages=schinese
case "0c04":
languages=tchinese
case "1004":
languages=schinese
case "1404":
languages=tchinese
case "0404":
languages=schinese
case "0816":
languages=portuguese
case "0416":
languages=brazilian
}
Log(Format("Language Generated By System Locale: {1}",languages))
GuiControl,Choose,EMUSettingLanguage,% languages
GuiControl,,EMUSettingAccount,Goldberg
GuiControl,,EMUSettingSteamID,76561197960287930
GuiControl,,EMUSettingListen,47584
GuiControl,,EMUSettingLanguageForce,0
GuiControl,,EMUSettingAccountForce,0
GuiControl,,EMUSettingSteamIDForce,0
GuiControl,,EMUSettingListenForce,0
GuiControl,,EMUSettingUseCustomIP,0
GuiControl,,EMUSettingCustomIP,
GuiControl,,EMUSettingOffline,0
GuiControl,,EMUDisableNet,0
GuiControl,,EMUDisableOverlay,0
GuiControl,Disable,EMUSettingCustomIP
return
}


EMUConfigGenInfoDefault()
{
GuiControl,,EMUConfigGenOnline,1
GuiControl,,EMUConfigUseAPIKey,0
GuiControl,,EMUConfigAPIKey,0
GuiControl,,EMUConfigGenIMG,0
return
}

EMUConfigGenUpdate:
GuiControlGet,EMUConfigGenOnline,,EMUConfigGenOnline
GuiControlGet,EMUConfigUseAPIKey,,EMUConfigUseAPIKey
GuiControlGet,EMUConfigGenOnline,,EMUConfigGenOnline
GuiControlGet,EMUConfigGenIMG,,EMUConfigGenIMG
if ( EMUConfigGenOnline = 1 )
{
GuiControl,Enable,EMUConfigUseAPIKey
GuiControl,Enable,EMUConfigGenOnline
GuiControl,Enable,EMUConfigGenIMG
}
else
{
GuiControl,,EMUConfigAPIKey,
GuiControl,Disable,EMUConfigUseAPIKey
GuiControl,Disable,EMUConfigAPIKey
GuiControl,Disable,EMUConfigGenIMG
}
if ( EMUConfigUseAPIKey = 1 )
{
    GuiControl,Enable,EMUConfigAPIKey
}
else
{
    GuiControl,,EMUConfigAPIKey,
    GuiControl,Disable,EMUConfigAPIKey
}



return

EMUConfigGenInfo:
Processing = 1
GuiControlGet,EMUConfigAPPID,,EMUConfigAPPID
GuiControlGet,EMUConfigGenOnline,,EMUConfigGenOnline
GuiControlGet,EMUConfigAPIKey,,EMUConfigAPIKey
GuiControlGet,EMUConfigUseAPIKey,,EMUConfigUseAPIKey
GuiControlGet,EMUConfigGenIMG,,EMUConfigGenIMG
if (FileExist(format("{1}\Temp\steam_settings",A_ScriptDir)))
{
    MsgBox,36,Delete Previous steam_settings Folder?,Delete Previous steam_settings Folder and Start Generate Info?
    IfMsgBox Yes
    {   
        FileRemoveDir,TEMP\steam_settings,1
        Log("Previous steam_settings Folder Deleted.")
    }
    Else
    {
        Processing = 0
        return
    }
}

if EMUConfigAPPID is not digit
{
    Log("Wrong App ID.")
    MsgBox,16,Error,Wrong App ID.
    Processing = 0
    return
}
if (EMUConfigAPPID = "" )
{
    Log("Empty App ID.")
    MsgBox,16,Error,Empty App ID.
    Processing = 0
    return
}
if (EMUConfigGenOnline = 0)
{
    FileCreateDir,Temp\steam_settings
    FileAppend ,% EMUConfigAPPID,Temp\steam_settings\steam_appid.txt
    Log("Writed App ID to steam_appid.txt.")
    Log("Game Info Generated.")
    MsgBox,64,Success,Game Info Generated.
    EMUConfigStatus()
    Processing = 0
    return
}
If (EMUConfigUseAPIKey = 1)
{
    if (EMUConfigAPIKey = "" )
    {
        Log("Empty API Key.")
        MsgBox,16,Error,Empty API Key.
        Processing = 0
        return
    }
    APIKeyCMD = % Format("-s ""{1}""",EMUConfigAPIKey)
}
else
{
    APIKeyCMD = 
}
GenCMD = % Format("""{1}\bin\generate_game_infos\generate_game_infos.exe""",A_ScriptDir)
Log("Generating...")
FileCreateDir,Temp\steam_settings
if (EMUConfigGenIMG = 1)
{
    RunWithLog(Format("{5} {2} -o ""{1}\Temp\steam_settings"" {3} {4}",A_ScriptDir,EMUConfigAPPID ,OutputCMD,APIKeyCMD,GenCMD),Format("{1}\bin\generate_game_infos",A_ScriptDir))
}
else
{
    RunWithLog(Format("{5} {2} -o ""{1}\Temp\steam_settings"" {3} {4} -i",A_ScriptDir,EMUConfigAPPID ,OutputCMD,APIKeyCMD,GenCMD),Format("{1}\bin\generate_game_infos",A_ScriptDir))
}
Log("Game Info Generated.")
MsgBox,64,Success,Game Info Generated.
EMUConfigStatus()
Processing = 0
return

EMUConfigGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
Running = 0
FilePath =
FileSelectorPath =
Gui,Destroy
return

EMUConfigGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
Running = 0
FilePath =
FileSelectorPath =
Gui,Destroy
return

EMUConfigGuiDropFiles:
if(A_EventInfo=1)
{
    if (A_GuiControl="EMUConfigGenInterfaceFile")
    {   
        GuiControl,EMUConfig:,EMUConfigGenInterfaceFile,% A_GuiEvent
    }
}
return
;--- EMU Config End ---
;--- Get EMU Config Status Start ---
EMUConfigStatus()
{
    if (FileExist(format("{1}\Temp\steam_settings\steam_appid.txt",A_ScriptDir)))
    {
        Log("Emulator Config Exist.")
        GuiControl,+c00ff00,GameInfoStatus
        GuiControl,Text,GameInfoStatus,Generated
        return 1
    }
    else
    {
        Log("Emulator Config Not Exist.")
        GuiControl,+cff0000,GameInfoStatus
        GuiControl,Text,GameInfoStatus,Not Generated
        return 0
    }
}
;--- Get EMU Config Status End ---
;--- Run With Log Start ---
/*
RunWithLog(CMD,WorkingDir)
{
DllCall("AllocConsole")
hConsole := DllCall("GetConsoleWindow")
WinWait % "ahk_id " hConsole
WinHide
Shell:=ComObjCreate("WScript.Shell")
Shell.CurrentDirectory :=WorkingDir
exec:=Shell.Exec(CMD)
while,!Exec.StdOut.AtEndOfStream
{
Log(Exec.StdOut.readline())
}
SetWorkingDir %A_ScriptDir%
return
}
*/
RunWithLog(CMD,WorkingDir)
{
RunCMD(CMD,WorkingDir,,"RunWithLogOutput")
return
}
RunWithLogOutput(Line, LineNum)
{
If ( SubStr(Line,-1)!="`n" )
{
    len = % StrLen(Line)
    Line = % SubStr(Line,1,StrLen(Line)-1)
}
Log(Line)
}
;--- Run With Log End ---

;--- AutoApplyEMU Start ---
AutoApplyEMU:
    If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,AutoApplyEMU:New,,Auto apply Goldberg Steam Emulator (Apply + Backup)
Gui Font
Gui Font,s16
Gui Add,Text,x50 y0 w600 h50 +0x200,Auto apply Goldberg Steam Emulator (Apply + Backup)
Gui Font
Gui Add,Text,x10 y120 w140 h25 +0x200,steam_api(64).dll Path:
Gui Add,Edit,x155 y120 w400 h25 vAutoApplyEMUFilePath
Gui Add,Button,x560 y120 w35 h25 gAutoApplyEMUSelectFile,...
Gui Add,CheckBox,x10 y150 w170 h25 +0x200 gAutoApplyEMUUseSavePath vAutoApplyEMUUseSavePath,Change Default Save Path:
Gui Add,Edit,x190 y150 w365 h25 vAutoApplyEMUSavePath
Gui Add,Button,x560 y150 w35 h25 gAutoApplyEMUSavePathSelectFile vAutoApplyEMUSavePathSelectFile,...
Gui Add,Button,x20 y250 w170 h60 gAutoApplyEMUApplyFile,Apply
Gui Add,Button,x360 y250 w170 h60 gAutoApplyEMUGuiClose,Close
Gui Show,x500 y500 w600 h400,Auto apply Goldberg Steam Emulator (Apply + Backup)
AutoApplyEMUUseSavePath()
return

AutoApplyEMUUseSavePath()
{
GuiControlGet,AutoApplyEMUUseSavePath,,AutoApplyEMUUseSavePath
if ( AutoApplyEMUUseSavePath = 1 )
{
GuiControl,Enable,AutoApplyEMUSavePath
GuiControl,Enable,AutoApplyEMUSavePathSelectFile
}
else
{
GuiControl,AutoApplyEMU:,AutoApplyEMUSavePath
GuiControl,Disable,AutoApplyEMUSavePath
GuiControl,Disable,AutoApplyEMUSavePathSelectFile
}
return
}

AutoApplyEMUSavePathSelectFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,1,,Select Save Folder
GuiControl,AutoApplyEMU:,AutoApplyEMUSavePath,%FileSelectorPath%
return

AutoApplyEMUSelectFile:
FileSelectorPath =
FileSelectFile,FileSelectorPath,1,,Select File,steam_api[64].dll file(steam_api.dll;steam_api64.dll)
GuiControl,AutoApplyEMU:,AutoApplyEMUFilePath,%FileSelectorPath%
return

AutoApplyEMUGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Apply EMU Complete before Closing.
    return
}
Running = 0
FilePath =
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

AutoApplyEMUGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Apply EMU Complete before Closing.
    return
}
Running = 0
FilePath =
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

AutoApplyEMUGuiDropFiles:
if(A_EventInfo=1)
{
    if (A_GuiControl="AutoApplyEMUFilePath")
    {   
        GuiControl,AutoApplyEMU:,AutoApplyEMUFilePath,% A_GuiEvent
    }
    if (A_GuiControl="AutoApplyEMUSavePath")
    {   
        GuiControlGet,AutoApplyEMUUseSavePath,,AutoApplyEMUUseSavePath
        if ( AutoApplyEMUUseSavePath = 1 )
        {
            GuiControl,AutoApplyEMU:,AutoApplyEMUSavePath,% A_GuiEvent
        }
        
    }
}
return
;--- AutoApplyEMU End ---

;--- AutoApplyEMUApply File Start ---
AutoApplyEMUApplyFile:
    Processing = 1
    FilePath = 
    FileName =
    FileDir =
    GuiControlGet,AutoApplyEMUUseSavePath,,AutoApplyEMUUseSavePath
    GuiControlGet,AutoApplyEMUSavePath,,AutoApplyEMUSavePath
    GuiControlGet,FilePath,AutoApplyEMU: ,AutoApplyEMUFilePath
    SplitPath,FilePath,FileName
    if (!FileExist("Temp\steam_settings"))
    {  
        MsgBox,16,Info,Steam Emulator Settings Not Generated.
        Processing = 0
        return
    }
    if (!FileExist(FilePath))
    {
        Log(Format("File '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,File Not Exist.
        Processing = 0
        return
    }
    if (FileName != "steam_api.dll" && FileName != "steam_api64.dll")
    {
        MsgBox,16,Error,File is Not steam_api(64).dll.
        Processing = 0
        return
    }
    ApplyEMU(FilePath,AutoApplyEMUUseSavePath,AutoApplyEMUSavePath)
    MsgBox,64,Success,Emulator Applied.
    Processing = 0
    return
;--- AutoApplyEMUApply File End ---

;--- ApplyEmu Start ---
ApplyEMU(Path,UseLocalSave,SavePath)
{
FileName = 
FileDir =
if (FileExist(Format("{1}.bak",Path)))
{
Log(Format("Backup File '{1}.bak' Already Exists,Skipping ...",Path))
return
}
Log(Format("Applying Emulator to '{1}'...",Path))
FileMove,% Path,% Format("{1}.bak",Path),0
SplitPath,Path,FileName
FileCopy,% Format("{1}\bin\Goldberg\{2}",A_ScriptDir,FileName),% Path,1
SplitPath,Path,,FileDir
FileCopyDir,Temp\steam_settings,% format("{1}\steam_settings\",FileDir),1
if (UseLocalSave = 1)
{
    Log(Format("Using Local Save Path '{1}'...",SavePath))
    FileDelete,% format("{1}\local_save.txt",FileDir)
    FileAppend,% SavePath,% format("{1}\local_save.txt",FileDir)
}
Log("Emulator Applied.")
return
}
;--- ApplyEmu End ---

;--- AutoFindApplyEMU Start ---
AutoFindApplyEMU:
    If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,AutoFindApplyEMU:New,,Auto Find and apply Goldberg Steam Emulator (Apply + Backup)
Gui Font
Gui Font,s14
Gui Add,Text,x20 y0 w600 h50 +0x200,Auto Find and apply Goldberg Steam Emulator (Apply + Backup)
Gui Font
Gui Add,Text,x10 y120 w100 h25 +0x200,Game Path:
Gui Add,Edit,x105 y120 w450 h25 vAutoFindApplyEMUFilePath
Gui Add,Button,x560 y120 w35 h25 gAutoFindApplyEMUSelectFile,...
Gui Add,CheckBox,x10 y150 w170 h25 +0x200 gAutoFindApplyEMUUseSavePath vAutoFindApplyEMUUseSavePath,Change Default Save Path:
Gui Add,Edit,x190 y150 w365 h25 vAutoFindApplyEMUSavePath
Gui Add,Button,x560 y150 w35 h25 gAutoFindApplyEMUSavePathSelectFile vAutoFindApplyEMUSavePathSelectFile,...
Gui Add,Button,x20 y250 w170 h60 gAutoFindApplyEMUApplyFile,Apply
Gui Add,Button,x360 y250 w170 h60 gAutoFindApplyEMUGuiClose,Close
Gui Show,x500 y500 w600 h400,Auto Find and apply Goldberg Steam Emulator (Apply + Backup)
AutoFindApplyEMUUseSavePath()
return

AutoFindApplyEMUUseSavePath()
{
GuiControlGet,AutoFindApplyEMUUseSavePath,,AutoFindApplyEMUUseSavePath
if ( AutoFindApplyEMUUseSavePath = 1 )
{
GuiControl,Enable,AutoFindApplyEMUSavePath
GuiControl,Enable,AutoFindApplyEMUSavePathSelectFile
}
else
{
GuiControl,,AutoFindApplyEMUSavePath
GuiControl,Disable,AutoFindApplyEMUSavePath
GuiControl,Disable,AutoFindApplyEMUSavePathSelectFile
}
return
}

AutoFindApplyEMUSavePathSelectFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,1,,Select Save Folder
GuiControl,AutoFindApplyEMU:,AutoFindApplyEMUSavePath,%FileSelectorPath%
return

AutoFindApplyEMUSelectFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,,0,Select Path
GuiControl,AutoFindApplyEMU:,AutoFindApplyEMUFilePath,%FileSelectorPath%
return

AutoFindApplyEMUGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Apply EMU Complete before Closing.
    return
}
Running = 0
FilePath = 
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

AutoFindApplyEMUGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Apply EMU Complete before Closing.
    return
}
Running = 0
FilePath = 
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

AutoFindApplyEMUGuiDropFiles:
if(A_EventInfo=1)
{
    if (A_GuiControl="AutoFindApplyEMUFilePath")
    {   
        GuiControl,AutoFindApplyEMU:,AutoFindApplyEMUFilePath,% A_GuiEvent
    }
    if (A_GuiControl="AutoFindApplyEMUSavePath")
    {   
        GuiControlGet,AutoFindApplyEMUUseSavePath,,AutoFindApplyEMUUseSavePath
        if ( AutoFindApplyEMUUseSavePath = 1 )
        {
            GuiControl,AutoFindApplyEMU:,AutoFindApplyEMUSavePath,% A_GuiEvent
        }
        
    }
}
return
;--- AutoFindApplyEMU End ---

;--- AutoFindApplyEMUUnpack File Start ---
AutoFindApplyEMUApplyFile:
    Processing = 1
    FilePath = 
    FileName =
    FileDir =
    GuiControlGet,AutoFindApplyEMUUseSavePath,,AutoFindApplyEMUUseSavePath
    GuiControlGet,AutoFindApplyEMUSavePath,,AutoFindApplyEMUSavePath
    GuiControlGet,FilePath,AutoFindApplyEMU: ,AutoFindApplyEMUFilePath
    if (!FileExist("Temp\steam_settings"))
    {  
        MsgBox,16,Info,Steam Emulator Settings Not Generated.
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
    Loop,Files,% Format("{1}\steam_api.dll",FilePath),R
    {
        Log(Format("Found '{1}'. Applying...",A_LoopFileFullPath))
        ApplyEMU(A_LoopFileFullPath,AutoFindApplyEMUUseSavePath,AutoFindApplyEMUSavePath)
    }
    Loop,Files,% Format("{1}\steam_api64.dll",FilePath),R
    {
        Log(Format("Found '{1}'. Applying...",A_LoopFileFullPath))
        ApplyEMU(A_LoopFileFullPath,AutoFindApplyEMUUseSavePath,AutoFindApplyEMUSavePath)
    }
    Log(Format("All steam_api(64).dll in '{1}' Emulator Applied.",FilePath))
    MsgBox,64,Success,All File Unpacked and Backuped.
    Processing = 0
    return
;--- AutoFindApplyEMUUnpack File End ---

;--- Restore Start ---
Restore:
    If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,Restore:New,,Restore Crack
Gui Font
Gui Font,s16
Gui Add,Text,x230 y0 w600 h50 +0x200,Restore Crack
Gui Font
Gui Add,Text,x10 y120 w100 h25 +0x200,Game Path:
Gui Add,Edit,x105 y120 w450 h25 vRestoreFilePath
Gui Add,Button,x560 y120 w35 h25 gRestoreSelectFile,...
Gui Add,Button,x20 y250 w170 h60 gRestoreFile,Restore
Gui Add,Button,x360 y250 w170 h60 gRestoreGuiClose,Close
Gui Show,x500 y500 w600 h400,Restore Crack
return

RestoreSelectFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,,0,Select Path
GuiControl,Restore:,RestoreFilePath,%FileSelectorPath%
return

RestoreGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Restore Complete before Closing.
    return
}
Running =0
FilePath =
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

RestoreGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Restore Complete before Closing.
    return
}
Running =0
FilePath =
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

RestoreGuiDropFiles:
if(A_EventInfo=1)
{
    if (A_GuiControl="RestoreFilePath")
    {   
        GuiControl,Restore:,RestoreFilePath,% A_GuiEvent
    }
}
return
;--- Restore End ---

;--- RestoreUnpack File Start ---
RestoreFile:
    Processing = 1
    FilePath =
    FileName =
    FileDir =
    GuiControlGet,FilePath,Restore: ,RestoreFilePath
    if (!FileExist(FilePath))
    {
        Log(Format("Path '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,Path Not Exist.
        Processing = 0
        return
    }
    Loop,Files,% Format("{1}\steam_interfaces.txt",FilePath),R
    {
        Log(Format("Found '{1}'. Restoring...",A_LoopFileFullPath))
        FileDelete,% A_LoopFileFullPath
    }
    Loop,Files,% Format("{1}\local_save.txt",FilePath),R
    {
        Log(Format("Found '{1}'. Restoring...",A_LoopFileFullPath))
        FileDelete,% A_LoopFileFullPath
    }
    Loop,Files,% Format("{1}\*.bak",FilePath),R
    {
        OrigPath :=
        LoopFileFullPathNoExt = 
        Log(Format("Found '{1}'. Restoring...",A_LoopFileFullPath))
        OrigPath :=SubStr(A_LoopFileFullPath,1,InStr(A_LoopFileFullPath,".bak",0,0)-1)
        FileDelete,% OrigPath
        FileMove,% A_LoopFileFullPath,% OrigPath
    }
    Loop,Files,% Format("{1}\steam_settings",FilePath),DR
    {
        Log(Format("Found '{1}'. Restoring...",A_LoopFileFullPath))
        FileRemoveDir,% A_LoopFileFullPath,1
    }
    Log(Format("All File in '{1}' Restored.",FilePath))
    MsgBox,64,Success,All File Restored.
    Processing = 0
    return
;--- RestoreUnpack File End ---


;--- UpdateEMU Start ---
UpdateEMU:
    If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,UpdateEMU:New,,Auto Update/Download Goldberg Steam Emulator
Gui Font
Gui Font,s16
Gui Add,Text,x70 y0 w600 h50 +0x200,Auto Update/Download Goldberg Steam Emulator
Gui Font
Gui Add,Text,x10 y120 w100 h25 +0x200,Current JobID:
Gui Add,Text,x105 y120 w100 h25 +0x200 vUpdateEMUCurrentJobID
Gui Add,Text,x10 y140 w100 h25 +0x200,Latest JobID:
Gui Add,Text,x105 y140 w100 h25 +0x200 vUpdateEMULatestJobID
Gui Add,Button,x300 y140 w200 h25 gUpdateEMUCheck vUpdateEMUCheck,Check Latest Version
Gui Add,Link,x10 y170 w200 h25,<a href="https://mr_goldberg.gitlab.io/goldberg_emulator/">Goldberg Steam Emulator URL</a>
Gui Add,Button,x20 y250 w170 h60 gUpdateEMUFile vUpdateEMUFile,Update/Download
Gui Add,CheckBox,x10 y200 w150 h25 vUpdateExperimental,Use Experimental Build
Gui Add,Button,x360 y250 w170 h60 gUpdateEMUGuiClose,Close
Gui Add,Text,x10 y320 w110 h25 +0x200, Download Progress:
Gui Add,Text,x120 y320 w300 h25 +0x200 vDownloadSpeed,Download Stopped
Gui Add,Progress,x10 y350 w550 h20 vDownloadProgress -Smooth, 0
Gui Add,Text,x570 y345 w130 h25 +0x200 vDownloadInfo, 0`%
Gui Show,x500 y500 w600 h400,Auto Update/Download Goldberg Steam Emulator
UpdateEMUCheck()
return

UpdateEMUFile:
Processing = 1
GuiControl,Disable,UpdateEMUFile
GuiControl,Disable,UpdateEMUCheck
GuiControl,Disable,UpdateExperimental
GuiControlGet,UpdateExperimental,,UpdateExperimental
Log("Downloading Goldberg Steam Emulator Latest Version...")
FileCreateDir,Temp
FileDelete,TEMP\Goldberg.zip
FileRemoveDir,TEMP\Goldberg,1
FileDelete,bin\Goldberg\job_id
Link := format("https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/jobs/{1}/artifacts/download/",LatestJobID)
DownloadAs := format("{1}\TEMP\Goldberg.zip",A_ScriptDir)
DownloadFile(Link,DownloadAs ,True,True)
if (!FileExist("TEMP\Goldberg.zip"))
{
    Log("Download Failed.")
    MsgBox,16,Error,Download Failed.
    GuiControl,Enable,UpdateEMUFile
    GuiControl,Enable,UpdateEMUCheck
    GuiControl,Enable,UpdateExperimental
    return
}
Log("Download Complete. Unpacking...")
RunWait,% format("""{1}\bin\7z\7za.exe"" -o""{1}\TEMP\Goldberg"" -y x ""{1}\TEMP\Goldberg.zip""",A_ScriptDir),,Hide
if (UpdateExperimental=1)
{
    Log("Using Experimental Build.")
    FileCopy,TEMP\Goldberg\experimental\steam_api.dll,bin\Goldberg\steam_api.dll,1
    FileCopy,TEMP\Goldberg\experimental\steam_api64.dll,bin\Goldberg\steam_api64.dll,1
    
}
Else
{
    Log("Using Stable Build.")
    FileCopy,TEMP\Goldberg\steam_api.dll,bin\Goldberg\steam_api.dll,1
    FileCopy,TEMP\Goldberg\steam_api64.dll,bin\Goldberg\steam_api64.dll,1
}
FileRemoveDir,TEMP\Goldberg,1
FileDelete,TEMP\Goldberg.zip
FileAppend,% LatestJobID,bin\Goldberg\job_id
Log("Update Completed.")
MsgBox,64,Success,Update Completed.
GuiControl,,UpdateEMUCurrentJobID,% LatestJobID
GuiControl, +c00ff00, UpdateEMULatestJobID
GuiControl,,UpdateEMULatestJobID,% LatestJobID
GuiControl,Enable,UpdateEMUFile
GuiControl,Enable,UpdateEMUCheck
GuiControl,Enable,UpdateExperimental
Processing = 0
return

UpdateEMUCheck()
{
CurrentJobID =
LatestJobID =
FileReadLine,CurrentJobID,bin\Goldberg\job_id,1
if (ErrorLevel=1)
{
    Log("Cannot Get Current JobID.")
    MsgBox,16,Error,Could Not Get Current JobID.
}
Log(format("Current JobID: {1}",CurrentJobID))
GuiControl,,UpdateEMUCurrentJobID,% CurrentJobID
GuiControl,Disable,UpdateEMUFile
GuiControl,Disable,UpdateEMUCheck
GuiControl,,UpdateEMUCheck,Checking Update...
Log("Checking Update...")
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.SetProxy(0)
whr.Open("GET","https://mr_goldberg.gitlab.io/goldberg_emulator/", true)
whr.Send()
whr.WaitForResponse()
RegExMatch(whr.ResponseText, "https:\/\/gitlab.com\/Mr_Goldberg\/goldberg_emulator\/-\/jobs\/.*\/artifacts\/download",Link)
RegExMatch(Link,"[0-9]+",LatestJobID)
if (LatestJobID="")
{
Log(format("Cannot Get Latest JobID."))
MsgBox,16,Error,Could Not Get Latest JobID.
GuiControl,Enable,UpdateEMUFile
GuiControl,Enable,UpdateEMUCheck
GuiControl,,UpdateEMUCheck,Check Latest Version
return
}
Log(format("Latest JobID: {1}",LatestJobID))
if (LatestJobID=CurrentJobID)
{
    Log("No Update.")
    GuiControl,+c00ff00, UpdateEMULatestJobID
    GuiControl,,UpdateEMULatestJobID,% LatestJobID
    MsgBox,64,Info,No Update.
}
Else
{
    Log("Update Available.")
    GuiControl,+cff0000, UpdateEMULatestJobID
    GuiControl,,UpdateEMULatestJobID,% LatestJobID
    MsgBox,64,Info,Update Available.
}
GuiControl,Enable,UpdateEMUFile
GuiControl,Enable,UpdateEMUCheck
GuiControl,,UpdateEMUCheck,Check Latest Version
return
}

UpdateEMUGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Update Complete before Closing.
    return
}
Running =0
FilePath =
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

UpdateEMUGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Update Complete before Closing.
    return
}
Running =0
FilePath =
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return
;--- UpdateEMU End ---

;--- DownloadFile Start ---
DownloadFile(UrlToFile, SaveFileAs, Overwrite := True, UseProgressBar := True) {
    ;Check if the file already exists and if we must not overwrite it
      If (!Overwrite && FileExist(SaveFileAs))
          Return
    ;Check if the user wants a progressbar
      If (UseProgressBar) {
          ;Initialize the WinHttpRequest Object
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
          ;Download the headers
            WebRequest.Open("HEAD", UrlToFile)
            WebRequest.Send()
          ;Store the header which holds the file size in a variable:
            FinalSize := WebRequest.GetResponseHeader("Content-Length")
          ;Create the progressbar and the timer
            SetTimer, __UpdateProgressBar, 100
      }
    ;Download the file
      UrlDownloadToFile, %UrlToFile%, %SaveFileAs%
    ;Remove the timer and the progressbar because the download has finished
      If (UseProgressBar) {
          SetTimer, __UpdateProgressBar, Off
          GuiControl,UpdateEMU:,DownloadProgress,0
          GuiControl,UpdateEMU:,DownloadInfo,0`%
          GuiControl,UpdateEMU:,DownloadSpeed,Download Stopped
      }
    Return
    
    ;The label that updates the progressbar
      __UpdateProgressBar:
          ;Get the current filesize and tick
            CurrentSize := FileOpen(SaveFileAs, "r").Length ;FileGetSize wouldn't return reliable results
            CurrentSizeTick := A_TickCount
          ;Calculate the downloadspeed
            Speed := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
          ;Save the current filesize and tick for the next time
            LastSizeTick := CurrentSizeTick
            LastSize := FileOpen(SaveFileAs, "r").Length
          ;Calculate percent done
            PercentDone := Round(CurrentSize/FinalSize*100)
          ;Update the ProgressBar
            GuiControl,UpdateEMU:,DownloadProgress,%PercentDone%
            GuiControl,UpdateEMU:,DownloadInfo,%PercentDone%`%
            GuiControl,UpdateEMU:,DownloadSpeed,%CurrentSize%/%FinalSize% Byte (%Speed%)
            
      Return
}
;--- DownloadFile End ---

;--- GenCrack Start ---
GenCrack:
    If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,GenCrack:New,,Generate Crack Only Files
Gui Font
Gui Font,s16
Gui Add,Text,x150 y0 w600 h50 +0x200,Generate Crack Only Files
Gui Font
Gui Add,Text,x10 y120 w100 h25 +0x200,Game Path:
Gui Add,Edit,x105 y120 w450 h25 vGenCrackFilePath
Gui Add,Text,x10 y150 w100 h25 +0x200,Output Path:
Gui Add,Edit,x105 y150 w450 h25 vGenCrackFileOutputPath
Gui Add,Button,x560 y120 w35 h25 gGenCrackSelectFile,...
Gui Add,Button,x560 y150 w35 h25 gGenCrackSelectOutputFile,...
Gui Add,CheckBox,x10 y200 w150 h25 vGenCrackCreateReadme,Create Readme.txt
Gui Add,CheckBox,x210 y200 w250 h25 vGenCrackPack,Pack Crack Files with .zip archive
Gui Add,Button,x20 y250 w170 h60 gGenCrackFile,Generate
Gui Add,Button,x360 y250 w170 h60 gGenCrackGuiClose,Close
Gui Show,x500 y500 w600 h400,Generate Crack Only Files
return

GenCrackSelectOutputFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,,0,Select Path
GuiControl,GenCrack:,GenCrackFileOutputPath,%FileSelectorPath%
return

GenCrackSelectFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,,0,Select Path
GuiControl,GenCrack:,GenCrackFilePath,%FileSelectorPath%
return

GenCrackGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Generate Complete before Closing.
    return
}
Running =0
OutputPath =
FilePath =
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

GenCrackGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Generate Complete before Closing.
    return
}
Running =0
OutputPath =
FilePath =
FileName =
FileDir =
FileSelectorPath =
Gui,Destroy
return

GenCrackGuiDropFiles:
if(A_EventInfo=1)
{
    if (A_GuiControl="GenCrackFileOutputPath")
    {   
        GuiControl,GenCrack:,GenCrackFileOutputPath,% A_GuiEvent
    }
    if (A_GuiControl="GenCrackFilePath")
    {   
        GuiControl,GenCrack:,GenCrackFilePath,% A_GuiEvent
    }
}
return
;--- GenCrack End ---

;--- GenCrackUnpack File Start ---
GenCrackFile:
    Processing = 1
    OutputPath =
    FilePath =
    FileName =
    FileDir =
    ApplyCrack=0
    GuiControlGet,FilePath,GenCrack: ,GenCrackFilePath
    GuiControlGet,OutputPath,GenCrack: ,GenCrackFileOutputPath
    GuiControlGet,GenCrackCreateReadme,,GenCrackCreateReadme
    GuiControlGet,GenCrackPack,,GenCrackPack
    
    if (!FileExist(FilePath))
    {
        Log(Format("Game Path '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,Game Path Not Exist.
        Processing = 0
        return
    }
    if (!FileExist(OutputPath))
    {
        Log(Format("Output Path '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,Output Path Not Exist.
        Processing = 0
        return
    }
    FileDelete,% format("{1}\Crack_Readme.txt",OutputPath)
    FileDelete,% format("{1}\Crack.zip",OutputPath)
    FileRemoveDir,% format("{1}\Crack",OutputPath),1
    FileCreateDir,% format("{1}\Crack",OutputPath)
    Loop,Files,% Format("{1}\*.bak",FilePath),R
    {
        OrigPath :=
        NewPathDir:=
        NewPathExt:=
        Log(Format("Found '{1}'. Copying...",A_LoopFileFullPath))
        OrigPath :=SubStr(A_LoopFileFullPath,1,InStr(A_LoopFileFullPath,".bak",0,0)-1)
        NewPath :=format("{1}\Crack\{2}",OutputPath,SubStr(OrigPath,InStr(OrigPath,FilePath,0,0)+StrLen(FilePath)+1))
        SplitPath,NewPath,,,NewPathExt
        if (NewPathExt = "exe")
        {
            if(ApplyCrack=0)
            {
                MsgBox,36,Generate Auto Unpacker?,Detected SteamStub Packed .exe. `nYes: Generate Auto Unpacker (Apply_Crack.exe) File`nNo: Copy Unpacked .exe
                IfMsgBox Yes
                {
                    Log("Generate Auto Unpacker.")
                    FileCopy,% format("{1}\bin\Apply_Crack\Apply_Crack.exe",A_ScriptDir),% format("{1}\Crack\Apply_Crack.exe",OutputPath),1
                    FileCopyDir,bin\Steamless,% format("{1}\Crack\Steamless",OutputPath),1
                    ApplyCrack=1
                }
                else
                {
                    Log("Normal Generate Crack.")
                    ApplyCrack=2
                }
            }
            if(ApplyCrack=2)
            {
                SplitPath,NewPath,,NewPathDir
                FileCreateDir,% NewPathDir
                FileCopy,% OrigPath,% NewPath,1
            }           
        }
        if (NewPathExt = "dll")
        {
            SplitPath,NewPath,,NewPathDir
            FileCreateDir,% NewPathDir
            FileCopy,% OrigPath,% NewPath,1
        }
        
    }
    Loop,Files,% Format("{1}\steam_settings",FilePath),DR
    {
        OrigPath :=
        Log(Format("Found '{1}'. Copying...",A_LoopFileFullPath))
        OrigPath :=SubStr(A_LoopFileFullPath,1,InStr(A_LoopFileFullPath,"steam_settings",0,0)-1)
        NewPath :=format("{1}\Crack\{2}",OutputPath,SubStr(OrigPath,InStr(OrigPath,FilePath,0,0)+StrLen(FilePath)+1))
        FileCopyDir,% format("{1}\steam_settings",OrigPath),% format("{1}\steam_settings",NewPath),1
    }
    Log(Format("Crack Generated in '{1}\Crack'.",FilePath))
    if (GenCrackCreateReadme=1)
    {
        Log("Creating Readme.txt...")
        FileDelete,% format("{1}\Crack_Readme.txt",OutputPath)
        FileAppend,% format("Crack Generated By SteamAutoCrack {1}`n",Ver),% format("{1}\Crack_Readme.txt",OutputPath)
        FileAppend,% "1.Copy All File in Crack Folder to Game Folder, then Overwrite.`n",% format("{1}\Crack_Readme.txt",OutputPath)
        if (ApplyCrack=1)
        {
            FileAppend,% "2.Run Apply_Crack.exe in Game Folder to Apply Crack.`n",% format("{1}\Crack_Readme.txt",OutputPath)
        }
        Log("Readme.txt Generated.")
    }
    if (GenCrackPack=1)
    {
        Log("Packing Crack...")
        RunWait,% format("""{2}\bin\7z\7za.exe"" a -tzip ""{1}\Crack.zip"" ""{1}\Crack""",OutputPath,A_ScriptDir),,Hide
        if (GenCrackCreateReadme=1)
        {
            Log("Packing Readme.txt...")
            RunWait,% format("""{2}\bin\7z\7za.exe"" a -tzip ""{1}\Crack.zip"" ""{1}\Crack_Readme.txt""",OutputPath,A_ScriptDir),,Hide
        }   
        Log(Format("Crack Packed in '{1}\Crack.zip'.",OutputPath))
        Run % format("explorer.exe ""{1}\Crack.zip""",OutputPath)
        MsgBox,64,Success,Crack Generated.
        Processing = 0
        return
    }
    Run % format("explorer.exe ""{1}\Crack\""",OutputPath)
    MsgBox,64,Success,Crack Generated.
    Processing = 0
    return
;--- GenCrackUnpack File End ---

;------------ Auto Crack Start ------------
AutoCrack:
If (Running)
    {
        MsgBox,16,Error,Another Window is Running.`nPlease Close it First.
        return
    }
Running = 1
Gui,Crack:New,,Auto Crack
Gui Font
Gui Font,s20
Gui Add,Text,x540 y0 w600 h50 +0x200,Auto Crack
Gui Font
Gui Add,Text,x10 y120 w100 h25 +0x200,Steam App ID:
Gui Add,Edit,x105 y120 w70 h25 vCrackAPPID
Gui Add,Link,x380 y130 w200 h25,Get App ID on <a href="https://steamdb.info/">SteamDB</a>
;------
Gui Add,Text,x10 y50 w100 h25 +0x200,Game Path:
Gui Add,Edit,x105 y50 w450 h25 vCrackGenCrackFilePath
Gui Add,Button,x560 y50 w35 h25 gCrackGenCrackSelectFile,...
Gui Add,CheckBox,x10 y90 w170 h25 +0x200 gCrackAutoFindApplyEMUUseSavePath vCrackAutoFindApplyEMUUseSavePath,Change Default Save Path:
Gui Add,Edit,x190 y90 w365 h25 vCrackAutoFindApplyEMUSavePath
Gui Add,Button,x560 y90 w35 h25 gCrackAutoFindApplyEMUSavePathSelectFile vCrackAutoFindApplyEMUSavePathSelectFile,...
;------
;------
Gui Add,GroupBox,x10 y190 w580 h190,Generate Game Info
Gui Add,CheckBox,x40 y210 w130 h25 vCrackGenOnline gCrackGenUpdate,Generate Online
Gui Add,CheckBox,x40 y240 w130 h25 vCrackUseAPIKey gCrackGenUpdate,Use Steam API Key:
Gui Add,Edit,x190 y240 w200 h25 vCrackAPIKey gCrackGenUpdate
Gui Add,CheckBox,x40 y270 w200 h25 vCrackGenIMG gCrackGenUpdate,Generate Achievement Images
Gui Add,Button,x100 y300 w120 h25 gCrackGenInfoDefault,Default Setting
;------
Gui Add,GroupBox,x610 y45 w580 h210,Settings
Gui Add,Text,x615 y60 w100 h25 +0x200,Language:
Gui Add,DropDownList,x700 y65 w100 vCrackEMUSettingLanguage,arabic|bulgarian|schinese|tchinese|czech|danish|dutch|english|finnish|french|german|greek|hungarian|italian|japanese|koreana|norwegian|polish|portuguese|brazilian|romanian|russian|spanish|swedish|thai|turkish|ukrainian
Gui Add,CheckBox,x900 y60 w100 h25 vCrackEMUSettingLanguageForce,Force
Gui Add,Text,x615 y85 w100 h25 +0x200,Listen Port:
Gui Add,Edit,x700 y90 w150 h20 vCrackEMUSettingListen
Gui Add,CheckBox,x900 y85 w100 h25 vCrackEMUSettingListenForce,Force
Gui Add,Text,x615 y110 w100 h25 +0x200,Account Name:
Gui Add,Edit,x700 y115 w150 h20 vCrackEMUSettingAccount
Gui Add,CheckBox,x900 y110 w100 h25 vCrackEMUSettingAccountForce,Force
Gui Add,Text,x615 y135 w100 h25 +0x200,Steam ID:
Gui Add,Edit,x700 y140 w150 h20 vCrackEMUSettingSteamID
Gui Add,CheckBox,x900 y135 w100 h25 vCrackEMUSettingSteamIDForce,Force
Gui Add,CheckBox,x615 y165 w100 h25 vCrackEMUSettingOffline,Offline mode
Gui Add,CheckBox,x900 y165 w150 h25 vCrackEMUDisableNet,Disable Networking
Gui Add,CheckBox,x615 y190 w140 h25 vCrackEMUSettingUseCustomIP gCrackEMUSettingUpdateCustomIP,Custom Broadcast IP:
Gui Add,Edit,x755 y195 w130 h20 vCrackEMUSettingCustomIP
Gui Add,CheckBox,x900 y190 w150 h25 vCrackEMUDisableOverlay,Disable Overlay
Gui Add,Button,x615 y225 w120 h25 gCrackEMUSettingDefault,Default Setting
Gui Add,Button,x740 y225 w120 h25 gCrackEMUSettingOpenExample,Open Example
Gui Add,Button,x865 y225 w150 h25 gCrackEMUSettingSettingsFolder,Open Settings Folder
;------
Gui Add,GroupBox,x610 y260 w580 h120,Generate Steam Interfaces
Gui Add,Text,x615 y280 w530 h25,You Only Need to Do This For steam_api(64).dll Older Than May 2016.
Gui Add,Text,x615 y300 w530 h25,Apply Goldberg Steam Emulator first, then Select steam_api(64).dll.bak File.
Gui Add,Text,x615 y320 w530 h25,steam_api(64).dll.bak Path:
Gui Add,Edit,x785 y315 w360 h20 vCrackGenInterfaceFile
Gui Add,Button,x1150 y315 w35 h25 gCrackGenInterfaceSelectFile,...
Gui Add,Button,x615 y345 w150 h25 gCrackGenInterfaceGen,Generate

;------
Gui Add,Button,x200 y400 w170 h60 gCrackCrack,Start Crack
Gui Add,Button,x700 y400 w170 h60 gCrackGuiClose,Close
Gui Show,x500 y70 w1200 h500,Auto Crack
GuiControl,,CrackGenOnline,1
GuiControl,,CrackUseAPIKey,0
GuiControl,,CrackAPIKey,0
GuiControl,,CrackGenIMG,0
GuiControl,Disable,CrackUseAPIKey
GuiControl,Disable,CrackAPIKey
GuiControl,Disable,CrackGenIMG
GuiControl,Disable,CrackEMUSettingCustomIP
CrackGenInfoDefault()
CrackStatus()
CrackEMUSettingDefault()
CrackAutoFindApplyEMUUseSavePath()
return

CrackAutoFindApplyEMUUseSavePath()
{
GuiControlGet,CrackAutoFindApplyEMUUseSavePath,,CrackAutoFindApplyEMUUseSavePath
if ( CrackAutoFindApplyEMUUseSavePath = 1 )
{
GuiControl,Enable,CrackAutoFindApplyEMUSavePath
GuiControl,Enable,CrackAutoFindApplyEMUSavePathSelectFile
}
else
{
GuiControl,Crack:,CrackAutoFindApplyEMUSavePath,
GuiControl,Disable,CrackAutoFindApplyEMUSavePath
GuiControl,Disable,CrackAutoFindApplyEMUSavePathSelectFile
}
return
}

CrackAutoFindApplyEMUSavePathSelectFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,,0,Select Path
GuiControl,,CrackAutoFindApplyEMUSavePath,%FileSelectorPath%
return

CrackGenCrackSelectFile:
FileSelectorPath =
FileSelectFolder,FileSelectorPath,,0,Select Path
GuiControl,,CrackGenCrackFilePath,%FileSelectorPath%
return

CrackGenInterfaceSelectFile:
FileSelectorPath =
FileSelectFile,FileSelectorPath,1,,Select File,steam_api[64].dll.bak file(steam_api.dll.bak;steam_api64.dll.bak)
GuiControl,,CrackGenInterfaceFile,%FileSelectorPath%
return

CrackGenInterfaceGen()
{
    Processing = 1
    GuiControlGet,CrackGenInterfaceFile,,CrackGenInterfaceFile
    if (!FileExist(CrackGenInterfaceFile))
    {
        Log(Format("File '{1}' Not Exist.",CrackGenInterfaceFile))
        MsgBox,16,Error,File Not Exist.
        Processing = 0
        return
    }
    SplitPath,CrackGenInterfaceFile,CrackGenInterfaceFileName
    if (CrackGenInterfaceFileName != "steam_api.dll.bak" && CrackGenInterfaceFileName != "steam_api64.dll.bak")
    {
        MsgBox,16,Error,File is Not steam_api(64).dll.bak.
        Processing = 0
        return
    }
    SplitPath,CrackGenInterfaceFile,,CrackGenInterfaceFileNameDir
    log(CrackGenInterfaceFileNameDir)
    Log(format("Generating Steam Interfaces for '{1}'...",CrackGenInterfaceFile))
    RunWait,% format("""{2}\bin\Goldberg\generate_interfaces_file.exe"" ""{1}""",CrackGenInterfaceFile,A_ScriptDir),% CrackGenInterfaceFileNameDir,Hide
    Log("Generated.")
    MsgBox,64,Info,Generated.
    Processing = 0
    return
CrackEMUSettingOpenExample:
    Run % format("explorer.exe ""{1}\bin\Goldberg\Example""",A_ScriptDir)
    return
CrackEMUSettingSettingsFolder:
if (!FileExist("Temp\steam_settings"))
{
    MsgBox,64,Info,Settings Not Generated.
}
else
{
    Run % format("explorer.exe ""{1}\Temp\steam_settings""",A_ScriptDir)
}
    return
}
CrackEMUSettingUpdateCustomIP:
GuiControlGet,CrackEMUSettingUseCustomIP,,CrackEMUSettingUseCustomIP
if ( CrackEMUSettingUseCustomIP = 1 )
{
GuiControl,Enable,CrackEMUSettingCustomIP
}
else
{
GuiControl,Disable,CrackEMUSettingCustomIP
}
return

CrackEMUSetting() 
{
    GuiControlGet,CrackEMUSettingListen,,CrackEMUSettingListen
    GuiControlGet,CrackEMUSettingAccount,,CrackEMUSettingAccount
    GuiControlGet,CrackEMUSettingSteamID,,CrackEMUSettingSteamID
    GuiControlGet,CrackEMUSettingOffline,,CrackEMUSettingOffline
    GuiControlGet,CrackEMUDisableNet,,CrackEMUDisableNet
    GuiControlGet,CrackEMUDisableOverlay,,CrackEMUDisableOverlay
    GuiControlGet,CrackEMUSettingLanguage,,CrackEMUSettingLanguage
    GuiControlGet,CrackEMUSettingLanguageForce,,CrackEMUSettingLanguageForce
    GuiControlGet,CrackEMUSettingListenForce,,CrackEMUSettingListenForce
    GuiControlGet,CrackEMUSettingAccountForce,,CrackEMUSettingAccountForce
    GuiControlGet,CrackEMUSettingSteamIDForce,,CrackEMUSettingSteamIDForce
    GuiControlGet,CrackEMUSettingCustomIP,,CrackEMUSettingCustomIP
    GuiControlGet,CrackEMUSettingUseCustomIP,,CrackEMUSettingUseCustomIP
    FileCreateDir,Temp\steam_settings\settings
    Log("Saving Settings...")
    FileRemoveDir,TEMP\steam_settings\settings,1
    FileDelete,Temp\steam_settings\force_language.txt
    FileDelete,Temp\steam_settings\force_listen_port.txt
    FileDelete,Temp\steam_settings\force_account_name.txt
    FileDelete,Temp\steam_settings\force_steamid.txt
    FileDelete,Temp\steam_settings\offline.txt
    FileDelete,Temp\steam_settings\disable_networking.txt
    FileCreateDir,TEMP\steam_settings\settings
    if CrackEMUSettingListen is not digit
    {
        Log("Wrong Listen Port.")
        MsgBox,16,Error,Wrong Listen Port.
        return 1
    }
    if (CrackEMUSettingListen = "" )
    {
        Log("Empty Listen Port.")
        MsgBox,16,Error,Empty Listen Port.
        return 1
    }
    if CrackEMUSettingSteamID is not digit
    {
        Log("Wrong Steam ID.")
        MsgBox,16,Error,Wrong Steam ID.
        return 1
    }
    if (CrackEMUSettingSteamID = "" )
    {
        Log("Empty Steam ID.")
        MsgBox,16,Error,Empty Steam ID.
        return 1
    }
    if (CrackEMUSettingListen = "" )
    {
        Log("Empty Listen Port.")
        MsgBox,16,Error,Empty Listen Port.
        return 1
    }
    if (CrackEMUSettingAccount = "" )
    {
        Log("Empty Account Name.")
        MsgBox,16,Error,Empty Account Name.
        return 1
    }
    if (CrackEMUSettingUseCustomIP = 1)
    {
        if (CrackEMUSettingCustomIP = "" )
        {
            Log("Empty Custom IP.")
            MsgBox,16,Error,Empty Custom IP.
            return 1
        }
    }
    If (CrackEMUSettingLanguageForce = 1)
    {
        FileAppend ,% CrackEMUSettingLanguage,Temp\steam_settings\force_language.txt
    }
    Else
    {
        FileAppend ,% CrackEMUSettingLanguage,Temp\steam_settings\settings\language.txt
    }
    If (CrackEMUSettingListenForce = 1)
    {
        FileAppend ,% CrackEMUSettingListen,Temp\steam_settings\force_listen_port.txt
    }
    Else
    {
        FileAppend ,% CrackEMUSettingListen,Temp\steam_settings\settings\listen_port.txt
    }
    If (CrackEMUSettingAccountForce = 1)
    {
        FileAppend ,% CrackEMUSettingAccount,Temp\steam_settings\force_account_name.txt
    }
    Else
    {
        FileAppend ,% CrackEMUSettingAccount,Temp\steam_settings\settings\account_name.txt
    }
    If (CrackEMUSettingSteamIDForce = 1)
    {
        FileAppend ,% CrackEMUSettingSteamID,Temp\steam_settings\force_steamid.txt
    }
    Else
    {
        FileAppend ,% CrackEMUSettingSteamID,Temp\steam_settings\settings\user_steam_id.txt
    }
    If (CrackEMUSettingOffline = 1)
    {
        FileAppend ,,Temp\steam_settings\offline.txt
    }
    If (CrackEMUDisableNet = 1)
    {
        FileAppend ,,Temp\steam_settings\disable_networking.txt
    }
    If (CrackEMUDisableOverlay = 1)
    {
        FileAppend ,,Temp\steam_settings\disable_overlay.txt
    }
    If (CrackEMUSettingUseCustomIP = 1)
    {
        FileAppend ,% CrackEMUSettingCustomIP,Temp\steam_settings\settings\custom_broadcast_ip.txt
    }

    Log("Settings Saved.")
}

CrackEMUSettingDefault()
{
languages=english
language := SubStr(A_Language,3,2)
switch language
{
case "01":
    languages=arabic
case "02":
    languages=bulgarian
case "05":
    languages=czech
case "06":
    languages=danish
case "13":
    languages=dutch
case "09":
    languages=english
case "0b":
    languages=finnish
case "0c":
    languages=french
case "07":
    languages=german
case "08":
    languages=greek
case "0e":
    languages=hungarian
case "10":
    languages=italian
case "11":
    languages=japanese
case "12":
    languages=koreana
case "14":
    languages=norwegian
case "15":
    languages=polish
case "18":
    languages=romanian
case "19":
    languages=russian
case "0a":
    languages=spanish
case "1d":
    languages=swedish
case "1e":
    languages=thai
case "1f":
    languages=turkish
case "22":
    languages=ukrainian
}
switch A_Language
{
case "0804":
languages=schinese
case "0c04":
languages=tchinese
case "1004":
languages=schinese
case "1404":
languages=tchinese
case "0404":
languages=schinese
case "0816":
languages=portuguese
case "0416":
languages=brazilian
}
Log(Format("Language Generated By System Locale: {1}",languages))
GuiControl,Choose,CrackEMUSettingLanguage,% languages
GuiControl,,CrackEMUSettingAccount,Goldberg
GuiControl,,CrackEMUSettingSteamID,76561197960287930
GuiControl,,CrackEMUSettingListen,47584
GuiControl,,CrackEMUSettingLanguageForce,0
GuiControl,,CrackEMUSettingAccountForce,0
GuiControl,,CrackEMUSettingSteamIDForce,0
GuiControl,,CrackEMUSettingListenForce,0
GuiControl,,CrackEMUSettingUseCustomIP,0
GuiControl,,CrackEMUSettingCustomIP,
GuiControl,,CrackEMUSettingOffline,0
GuiControl,,CrackEMUDisableNet,0
GuiControl,,CrackEMUDisableOverlay,0
GuiControl,Disable,CrackEMUSettingCustomIP
return
}


CrackGenInfoDefault()
{
GuiControl,,CrackGenOnline,1
GuiControl,,CrackUseAPIKey,0
GuiControl,,CrackAPIKey,0
GuiControl,,CrackGenIMG,0
return
}

CrackGenUpdate:
GuiControlGet,CrackGenOnline,,CrackGenOnline
GuiControlGet,CrackUseAPIKey,,CrackUseAPIKey
GuiControlGet,CrackGenOnline,,CrackGenOnline
GuiControlGet,CrackGenIMG,,CrackGenIMG
if ( CrackGenOnline = 1 )
{
GuiControl,Enable,CrackUseAPIKey
GuiControl,Enable,CrackGenOnline
GuiControl,Enable,CrackGenIMG
}
else
{
GuiControl,,CrackAPIKey,
GuiControl,Disable,CrackUseAPIKey
GuiControl,Disable,CrackAPIKey
GuiControl,Disable,CrackGenIMG
}
if ( CrackUseAPIKey = 1 )
{
    GuiControl,Enable,CrackAPIKey
}
else
{
    GuiControl,,CrackAPIKey,
    GuiControl,Disable,CrackAPIKey
}
return

CrackGenInfo()
{
GuiControlGet,CrackAPPID,,CrackAPPID
GuiControlGet,CrackGenOnline,,CrackGenOnline
GuiControlGet,CrackAPIKey,,CrackAPIKey
GuiControlGet,CrackUseAPIKey,,CrackUseAPIKey
GuiControlGet,CrackGenIMG,,CrackGenIMG
MsgBox,36,Delete Previous steam_settings Folder?,Yes: Delete Previous steam_settings Folder and Start Generate Info`nNo: Continue Using Exist Game Info and Continue Crack
    IfMsgBox Yes
    {   
        FileRemoveDir,TEMP\steam_settings,1
        Log("Previous steam_settings Folder Deleted.")
    }
    Else
    {
        Log("Use Exist Config.")
        return 0
    }


if (CrackGenOnline = 0)
{
    FileCreateDir,Temp\steam_settings
    FileAppend ,% CrackAPPID,Temp\steam_settings\steam_appid.txt
    Log("Writed App ID to steam_appid.txt.")
    Log("Game Info Generated.")
    return 0
}
If (CrackUseAPIKey = 1)
{
    if (CrackAPIKey = "" )
    {
        Log("Empty API Key.")
        MsgBox,16,Error,Empty API Key.
        return 1
    }
    APIKeyCMD = % Format("-s ""{1}""",CrackAPIKey)
}
else
{
    APIKeyCMD = 
}
GenCMD = % Format("""{1}\bin\generate_game_infos\generate_game_infos.exe""",A_ScriptDir)
Log("Generating...")
FileCreateDir,Temp\steam_settings
if (CrackGenIMG = 1)
{
    RunWithLog(Format("{5} {2} -o ""{1}\Temp\steam_settings"" {3} {4}",A_ScriptDir,CrackAPPID ,OutputCMD,APIKeyCMD,GenCMD),Format("{1}\bin\generate_game_infos",A_ScriptDir))
}
else
{
    RunWithLog(Format("{5} {2} -o ""{1}\Temp\steam_settings"" {3} {4}-i",A_ScriptDir,CrackAPPID ,OutputCMD,APIKeyCMD,GenCMD),Format("{1}\bin\generate_game_infos",A_ScriptDir))
}
Log("Game Info Generated.")
Return 0
}

CrackGuiClose:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Crack Complete before Closing.
    return
}
Running = 0
FilePath =
FileSelectorPath =
Gui,Destroy
return

CrackGuiEscape:
if (Processing = 1)
{
    MsgBox,16,Info,Please Wait Until Crack Complete before Closing.
    return
}
Running = 0
FilePath =
FileSelectorPath =
Gui,Destroy
return

CrackGuiDropFiles:
if(A_EventInfo=1)
{
    if (A_GuiControl="CrackGenCrackFilePath")
    {   
        GuiControl,Crack:,CrackGenCrackFilePath,% A_GuiEvent
    }
    if (A_GuiControl="CrackGenInterfaceFile")
    {   
        GuiControl,Crack:,CrackGenInterfaceFile,% A_GuiEvent
    }
    if (A_GuiControl="CrackAutoFindApplyEMUSavePath")
    {   
        GuiControlGet,CrackAutoFindApplyEMUUseSavePath,,CrackAutoFindApplyEMUUseSavePath
        if ( CrackAutoFindApplyEMUUseSavePath = 1 )
        {
            GuiControl,Crack:,CrackAutoFindApplyEMUSavePath,% A_GuiEvent
        }
        
    }
}
return
;------------ Auto Crack End ------------

;--- Get CrackEMU Config Status Start ---
CrackStatus()
{
    if (FileExist("Temp\steam_settings\steam_appid.txt"))
    {
        Log("Emulator Config Exist.")
        return 1
    }
    else
    {
        Log("Emulator Config Not Exist.")
        return 0
    }
}
CrackAutoUnpackFindUnpackFile()
{
    FilePath = 
    GuiControlGet,FilePath,,CrackGenCrackFilePath
    if (!FileExist(FilePath))
    {
        Log(Format("Path '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,Path Not Exist.
        return 1
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
    return 0
}


CrackAutoFindApplyEMUApplyFile()
{
    FilePath = 
    FileName =
    FileDir =
    GuiControlGet,AutoFindApplyEMUUseSavePath,,CrackAutoFindApplyEMUUseSavePath
    GuiControlGet,AutoFindApplyEMUSavePath,,CrackAutoFindApplyEMUSavePath
    GuiControlGet,FilePath,,CrackGenCrackFilePath
    if (!FileExist("Temp\steam_settings"))
    {  
        MsgBox,16,Info,Steam Emulator Settings Not Generated.
        return 2
    }
    if (!FileExist(FilePath))
    {
        Log(Format("Path '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,Path Not Exist.
        return 2
    }
    Loop,Files,% Format("{1}\steam_api.dll",FilePath),R
    {
        Log(Format("Found '{1}'. Applying...",A_LoopFileFullPath))
        ApplyEMU(A_LoopFileFullPath,AutoFindApplyEMUUseSavePath,AutoFindApplyEMUSavePath)
    }
    Loop,Files,% Format("{1}\steam_api64.dll",FilePath),R
    {
        Log(Format("Found '{1}'. Applying...",A_LoopFileFullPath))
        ApplyEMU(A_LoopFileFullPath,AutoFindApplyEMUUseSavePath,AutoFindApplyEMUSavePath)
    }
    Log(Format("All steam_api(64).dll in '{1}' Emulator Applied.",FilePath))
    return 0
}

CrackCrack()
{
    Processing = 1
    GuiControlGet,CrackAPPID,,CrackAPPID
if CrackAPPID is not digit
{
    Log("Wrong App ID.")
    MsgBox,16,Error,Wrong App ID,Crack Failed.
    Processing = 0
    return 1
}
if (CrackAPPID = "" )
{
    Log("Empty App ID.")
    MsgBox,16,Error,Empty App ID,Crack Failed.
    Processing = 0
    return 1
}
    GuiControlGet,FilePath,,CrackGenCrackFilePath
    if (!FileExist(FilePath))
    {
        Log(Format("Path '{1}' Not Exist.",FilePath))
        MsgBox,16,Error,Game Path Not Exist, Crack Failed.
        Processing = 0
        return 1
    }
    Result :=
    Log("Genetate Game Info Start.")
    Result :=CrackGenInfo()
    if (Result=1)
    {
        Log("Crack Failed.")
        MsgBox,16,Error,Crack Failed.
        Processing = 0
        return
    }
    Log("Genetate Game Info End.")
    Log("Emulator Setting Start.")
    Result :=CrackEMUSetting()
    if (Result=1)
    {
        Log("Crack Failed.")
        MsgBox,16,Error,Crack Failed.
        Processing = 0
        return
    }
    Log("Emulator Setting End.")
    Log("Unpack exe Start.")
    Result :=CrackAutoUnpackFindUnpackFile()
    if (Result=1)
    {
        Log("Crack Failed.")
        MsgBox,16,Error,Crack Failed.
        Processing = 0
        return
    }
    Log("Unpack exe End.")
    Log("Apply Emulator Start.")
    Result :=CrackAutoFindApplyEMUApplyFile()
    if (Result=1)
    {
        Log("Crack Failed.")
        MsgBox,16,Error,Crack Failed.
        Processing = 0
        return
    }
    Log("Apply Emulator End.")
    Log("Crack Success.")
    MsgBox,64,Info,Crack Success.
    Processing = 0
}


;------------ Auto Crack End ------------
;------------ Edit_Append Start ----------
Edit_Append(hEdit, Txt) { ; Modified version by SKAN
Local        ; Original by TheGood on 09-Apr-2010 @ autohotkey.com/board/topic/52441-/?p=328342
  L := DllCall("SendMessage", "Ptr",hEdit, "UInt",0x0E, "Ptr",0 , "Ptr",0)   ; WM_GETTEXTLENGTH
       DllCall("SendMessage", "Ptr",hEdit, "UInt",0xB1, "Ptr",L , "Ptr",L)   ; EM_SETSEL
       DllCall("SendMessage", "Ptr",hEdit, "UInt",0xC2, "Ptr",0 , "Str",Txt) ; EM_REPLACESEL
}
;------------ Edit_Append End ----------
;------------ RunCMD Start ----------
RunCMD(CmdLine, WorkingDir:="", Codepage:="CP0", Fn:="RunCMD_Output") {  ;         RunCMD v0.94        
Local         ; RunCMD v0.94 by SKAN on D34E/D37C @ autohotkey.com/boards/viewtopic.php?t=74647                                                             
Global A_Args ; Based on StdOutToVar.ahk by Sean @ autohotkey.com/board/topic/15455-stdouttovar

  Fn := IsFunc(Fn) ? Func(Fn) : 0
, DllCall("CreatePipe", "PtrP",hPipeR:=0, "PtrP",hPipeW:=0, "Ptr",0, "Int",0)
, DllCall("SetHandleInformation", "Ptr",hPipeW, "Int",1, "Int",1)
, DllCall("SetNamedPipeHandleState","Ptr",hPipeR, "UIntP",PIPE_NOWAIT:=1, "Ptr",0, "Ptr",0)

, P8 := (A_PtrSize=8)
, VarSetCapacity(SI, P8 ? 104 : 68, 0)                          ; STARTUPINFO structure      
, NumPut(P8 ? 104 : 68, SI)                                     ; size of STARTUPINFO
, NumPut(STARTF_USESTDHANDLES:=0x100, SI, P8 ? 60 : 44,"UInt")  ; dwFlags
, NumPut(hPipeW, SI, P8 ? 88 : 60)                              ; hStdOutput
, NumPut(hPipeW, SI, P8 ? 96 : 64)                              ; hStdError
, VarSetCapacity(PI, P8 ? 24 : 16)                              ; PROCESS_INFORMATION structure

  If not DllCall("CreateProcess", "Ptr",0, "Str",CmdLine, "Ptr",0, "Int",0, "Int",True
                ,"Int",0x08000000 | DllCall("GetPriorityClass", "Ptr",-1, "UInt"), "Int",0
                ,"Ptr",WorkingDir ? &WorkingDir : 0, "Ptr",&SI, "Ptr",&PI)  
     Return Format("{1:}", "", ErrorLevel := -1
                   ,DllCall("CloseHandle", "Ptr",hPipeW), DllCall("CloseHandle", "Ptr",hPipeR))

  DllCall("CloseHandle", "Ptr",hPipeW)
, A_Args.RunCMD := { "PID": NumGet(PI, P8? 16 : 8, "UInt") }      
, File := FileOpen(hPipeR, "h", Codepage)

, LineNum := 1,  sOutput := ""
  While (A_Args.RunCMD.PID + DllCall("Sleep", "Int",0))
    and DllCall("PeekNamedPipe", "Ptr",hPipeR, "Ptr",0, "Int",0, "Ptr",0, "Ptr",0, "Ptr",0)
        While A_Args.RunCMD.PID and (Line := File.ReadLine())
          sOutput .= Fn ? Fn.Call(Line, LineNum++) : Line

  A_Args.RunCMD.PID := 0
, hProcess := NumGet(PI, 0)
, hThread  := NumGet(PI, A_PtrSize)

, DllCall("GetExitCodeProcess", "Ptr",hProcess, "PtrP",ExitCode:=0)
, DllCall("CloseHandle", "Ptr",hProcess)
, DllCall("CloseHandle", "Ptr",hThread)
, DllCall("CloseHandle", "Ptr",hPipeR)

, ErrorLevel := ExitCode

Return sOutput  
}
;------------ RunCMD End ----------