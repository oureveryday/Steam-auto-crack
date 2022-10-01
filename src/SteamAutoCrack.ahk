;Steam Auto Crack v2.3.1
;Automatic Steam Game Cracker
;Github: https://github.com/oureveryday/Steam-auto-crack
;Gitlab: https://gitlab.com/oureveryday/Steam-auto-crack

;--- Script Settings Start ---
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance ignore
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
Ver = v2.3.1
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
Gui Add,Button,x200 y50 w150 h25 gEMUConfigAppIDFinder,App ID Finder
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

EMUConfigAppIDFinder:
AppIDFinder("","EMUConfigAppIDFinderCallback")
return

EMUConfigAppIDFinderCallback(AppID)
{
    GuiControl,EMUConfig:,EMUConfigAPPID,% AppID
    return
}

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
if (AppIDFinderRunning = 1)
{
    MsgBox,16,Info,Please Close AppID Finder before Closing.
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
if (AppIDFinderRunning = 1)
{
    MsgBox,16,Info,Please Close AppID Finder before Closing.
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
Gui Add,Button,x200 y120 w150 h25 gCrackAppIDFinder,App ID Finder
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

CrackAppIDFinder:
GuiControlGet,CrackGenCrackFilePath,,CrackGenCrackFilePath
SplitPath,CrackGenCrackFilePath,,,,CrackGenCrackFilePath
Log("AppID Finder Default App Name: '" . CrackGenCrackFilePath . "'")
AppIDFinder(CrackGenCrackFilePath,"CrackAppIDFinderCallback")
return

CrackAppIDFinderCallback(AppID)
{
    GuiControl,Crack:,CrackAPPID,% AppID
    return
}

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
if (AppIDFinderRunning = 1)
{
    MsgBox,16,Info,Please Close AppID Finder before Closing.
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
if (AppIDFinderRunning = 1)
{
    MsgBox,16,Info,Please Close AppID Finder before Closing.
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
;-------------JSON Start ---------
;
; cJson.ahk 0.4.1
; Copyright (c) 2021 Philip Taylor (known also as GeekDude, G33kDude)
; https://github.com/G33kDude/cJson.ahk
;
; MIT License
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;

class JSON
{
	static version := "0.4.1-git-built"

	BoolsAsInts[]
	{
		get
		{
			this._init()
			return NumGet(this.lib.bBoolsAsInts, "Int")
		}

		set
		{
			this._init()
			NumPut(value, this.lib.bBoolsAsInts, "Int")
			return value
		}
	}

	EscapeUnicode[]
	{
		get
		{
			this._init()
			return NumGet(this.lib.bEscapeUnicode, "Int")
		}

		set
		{
			this._init()
			NumPut(value, this.lib.bEscapeUnicode, "Int")
			return value
		}
	}

	_init()
	{
		if (this.lib)
			return
		this.lib := this._LoadLib()

		; Populate globals
		NumPut(&this.True, this.lib.objTrue, "UPtr")
		NumPut(&this.False, this.lib.objFalse, "UPtr")
		NumPut(&this.Null, this.lib.objNull, "UPtr")

		this.fnGetObj := Func("Object")
		NumPut(&this.fnGetObj, this.lib.fnGetObj, "UPtr")

		this.fnCastString := Func("Format").Bind("{}")
		NumPut(&this.fnCastString, this.lib.fnCastString, "UPtr")
	}

	_LoadLib32Bit() {
		static CodeBase64 := ""
		. "FLYQAQAAAAEwVYnlEFOB7LQAkItFFACIhXT///+LRUAIixCh4BYASAAgOcIPhKQAcMdFAvQAFADrOIN9DAAAdCGLRfQF6AEAQA+2GItFDIsAAI1I"
		. "AotVDIkACmYPvtNmiRAg6w2LRRAAKlABwQAOiRCDRfQAEAViIACEwHW5AMaZiSBFoIlVpAEhRCQmCABGAAYEjQATBCSg6CYcAAACaRQLXlDHACIA"
		. "DFy4AZfpgK0HAADGRfMAxAgIi1AAkwiLQBAQOcJ1RwATAcdFCuwCuykCHAyLRewAweAEAdCJRbACiwABQAiLVeyDAMIBOdAPlMCIAEXzg0XsAYB9"
		. "EPMAdAuEIkXsfIrGgkUkAgsHu1sBJpgFu3uCmYlOiRiMTQSAvYGnAHRQx0Wi6Auf6AX5KJ/oAAQjhRgCn8dF5AJ7qQULgUGDauSEaqyDfeSwAA+O"
		. "qYAPE6EsDaGhhSlSx0XgiyngqilO4AACRQyCKesnUyAgIVUgZcdF3EIgVMdERdiLItgF/Kgi2EcAAkUMgiKDRdyABBiAO0XcfaQPtoB5gPABhMAP"
		. "hJ/AwIHCeRg5ReR9fOScGItFrMCNALCYiVVKnA2wmAGwZRlEXxfNDxPpgTjKE+nKQgSAIaIcgCEPjZ9C3NQLQOjUBf4oQNQAAkUMRNyhxCyQiVWU"
		. "zSyQYRaUsRiYbivqC+scwwlgi1UQiVTgCOAEVKQkBIEIYBqVCDqtKAN/Q4ctDIP4AXUek0EBLg76FwBhnAIBKKEDBQYPhV7COqzAmIbkICAAgVXH"
		. "RdDLKbjQBQcAB98pwynQAAETJQbCKekqJA4QodzFRgzMSwzMBQxfDEYM7swAASUGQwzHphiBsUMMYshLDMgFEl8MRgzIFwABJQZDDGRCDBiNSBAB"
		. "D7aVg7+siwAoiUwkoSwMjy3N+TD//+kv5BKBLQV1liBCBk8FVsBJ6QRIBYgCdWlAAY1VgCUEVNQUwVzEIho3IhogAItViItFxAHAiI0cAioaD7cT"
		. "ERoExAEFBgHQD7cAgGaFwHW36ZCiZ2LACyXABRcfJeYKwM8AASUGpmcuHIAVv9RGCgbkAAHjyeQPjEj6RP//ZJ4PhLXiFbzt6xW8P6+IC7wAASUG"
		. "BMRv4uLhqGH7CAu0/6iIBbQXgAAVA3RUuCABuDtFqBh8pFpxXVNxfV9xA11xkgmLXfzJw5DOkLEaAgBwiFdWkIizUYoMMBQUcQDHQAjRAdjHQAxS"
		. "DIAECIEEwCEOCJFBwABhH4P4IHQi5dgACnTX2AANdCLJ2AAJdLvYAHsPjIVygjxoBcdFoDIHVkWBj2AAqGMArGEAoYaM8AjQLkAYixWhAJDHRCQg"
		. "4gFEJCCLIAAAjU2QwDMYjdRNoGAAFFABEEGWcAAf8gtwAOMMQFdxAIkUJED/0IPsJItAY0U+sN8N3w3fDd8N1wB9D6yEVARuEgGFEG9DCQFAg/gi"
		. "dAq4YCj/xOm/EAqNRYDxYOEHAeAtaf7//4XAdPoX8wGf8AH/Cf8J/wn/CXXVADrFB0LPBZJplAjfVv2SCMQCFcICiIM4CP1jArCyZ4ABTxRPCk8K"
		. "TwqR1wAsdRIqBelUcBFmkFkWhQl8C18MgCwJQQIxVbCJUAjDqlTDdQLzA1sPhfBFGTYovIVwwUGxIjK5kwB4lgDOfJQA/yj8KI1gkAIiKZ6NEQVf"
		. "KV8pVimFaBED/EW00KbxAq8VrxWvFa8VYdcAXQ+EtpSP9imlkwNA2B/h+9kfFwr1AdXgi+RjArRhArpQFS8Kby8KLwovCtkfFioFgVzplgGACBkg"
		. "XcUJegkfIDUXILQWIFJ1AkQ4D4VMYwPvNYB4ReCSA+DDkAOjBAgA6e8FSxRvDbQH/pEgNwVcD4WqF51NKQdxe+CAAYlV4LsCazsuizkGwATbAlzc"
		. "Aqpd2wIv2wIv3AIv2wKqYtsCCNwCAdsCZtsCqgzcAtPbTW7bAgrcAqql2wJy2wIN3AJ32wIudNsCMR7ZAknbAnUPfIURTT7gA4ADsWVCz+nPwdcw"
		. "AQADoNyJwuEBOhuIL34w2AA5fyLDAoORAlMBAdCD6DCFAwTpgKk1g/hAfi0B2ADAtwBGfx+LReAPtwAAicKLRQiLAEEAkAHQg+g3AXDgIGaJEOtF"
		. "BVhmg1D4YH4tCDRmE+hXEQZ0Crj/AADpbQZEAAACQI1QAgAOiQAQg0XcAYN93BADD44WAD6DReAoAusmAypCBCoQjQpKAioIAEmNSAKJGk0AZhIA"
		. "Ugh9Ig+FAP/8//+LRQyLEkgBJinIAXcMi0AQCIPoBAEp4GbHCgAMeLgAEADp3QUjBBYDSC10JIgGLw8IjrEDig85D4+foYAIx0XYAYInDIArIhSB"
		. "A8dACIEnx0DmDAEDiSh1FIAWAWiKPjGIEDB1IxMghRXpjhELKTB+dQlJf2frCkcBdlCBd2vaCmtAyAAB2bsKgBn3AOMB0YnKi00IAIsJjXECi10I"
		. "AIkzD7cxD7/OAInLwfsfAcgRANqDwNCD0v+LAE0MiUEIiVEMSck+fhoJGX6dRXCrEAQAAJCIBi4PhYalTSyGI2YPbsDAAADKZg9iwWYP1mSFUEAQ"
		. "361BAYAI3VZYwGpBUAUAVNQBVOsAQotV1InQweAAAgHQAcCJRdQBQxVIAotVCIkKAcAbmIPoMImFTIXAD9tDAUXU3vmBErBACN7BhRTIMA7KMCKi"
		. "SANldBJIA0UPHIVVACANMQMHFHUxVQk00MAA2gA00wA0lVEVNMZF00uBE0AEAY3KF+tAzAYIK3URhgxX0IhNMsRiH8KizEGM61Ani1XMh07DUU4B"
		. "ENiJRcxYFb3HRSLIwTDHRcRCChOLhFXIqDHIg0XEQBgAxDtFzHzlgH0Q0wB0E0Mv20XIoaMwWAjrEUcCyUYiFeUoKyR0WCBN2JmJAN8Pr/iJ1g+v"
		. "APEB/vfhjQwWk2FVJFHrHcYGBXVmCibYcApELgMAA3oMAqFqZXQPhasiGsAiGgA3i0XABQcXAAAAD7YAZg++0FEmBTnCdGQqy+1AgwxFwKAexgaE"
		. "wHW6lA+2wIYAQAF0G6UPJ0N4oidDeOssQwMJABCLFeQWgoWJUAhCoUIBAItABKMCiYAUJP/Qg+wEgxcuT2UPhKqFF7yFF7wF6gyaFw6PF7yAF8YG"
		. "mhf76I+JF9yHF0IBgxdBAYsXgpKrlG51f8dFIgOA6zSLRbgFEhMX0gcCF+tYrBa4oBZmBvWgFr3nEeDnEUIB4xFBAQnqEesFIguNZfRbMF5fXcNB"
		. "AgUAIlUAbmtub3duX08AYmplY3RfAA0KCiALIqUBdHJ1ZQAAZmFsc2UAbgh1bGzHBVZhbHUAZV8AMDEyMzQANTY3ODlBQkMAREVGAFWJ5VNAg+xU"
		. "x0X0ZreLAEAUjVX0iVQkIBTHRCQQIitEJKIMwUONVQzAAgjAAQ8AqaAF4HPDFhjHReSpAgVF6MMA7MMA8IMKcBCJReRgAuPOIgwYqItV9MAIIKQL"
		. "HOQAghjhAI1N5IlMgw/fwQyBD8QDwjwgEAQnD2De0hCDNgl1MCEQcE7xBUAIi1UQi1JFAgTE62hmAgN1XGECElESu0AWf7lBBTnDGSjRfBWGAT0g"
		. "AYCJQNCD2P99LvAajTRV4HEPiXAPMR4EJATooQAChcB0EYsETeBGA4kBiVEEAJCLXfzJw5CQAXAVg+xYZsdF7ikTH0XwIBYUARBNDAC6zczMzInI"
		. "9xDiweoDNkopwYkCyhAHwDCDbfQBgSGA9GaJVEXGsAMJ4gL34pAC6AOJRQAMg30MAHW5jUJVoAH0AcABkAIQDYAJCGIRwwko/v//hpBACLMdYMdF"
		. "+EIuBhrkRcAKRfjB4AQgAdCJRdgBAUAYwDlF+A+NRPAZAAsKzlEC2PEMRfTGRQDzAIN99AB5B2GQAAH3XfRQHEMM9KC6Z2ZmZkAM6nAJhPgCUnkp"
		. "2InC/wyog23s8gzs8QymngNAwfkficopoAj0AYEGdaWAffMAdAYOQQMhA8dERaYtHXAnpsAAwA5gAtDGRYbrkCXiJotF5I0hjCDQAdAPtzBn5I3S"
		. "DMEWAcgDOnWQOQgCQABmhcB1GSUBDGUmAQYQBQHrEKG8AnQDUIS8AnQHg0XkAQDrh5CAfesAD2aEoWbhH1XYMJnRLemSyiQuQBwhFYyj4gChwxTU"
		. "xkXjgAvcgwvq3IIF1IQL3I8LCAKFC/sjAYoL44ILvAKBC7wCgQtC3IML4wB0D0oL65AYg0X48n1AEFIL8Nf9//9ySLosvz1iABNyQ2Aj6AWBD90A"
		. "3RpdkC7YswGyDsdF4ONjACIbjUXoUCcwAZEH7KGIED3jQBWhAB1BIXXATCQYjU3YBUFCav8MQeVIFUEhCz8LPwvAATES0QAxBIsAADqJIEmfC3+f"
		. "C58LnwufC58Lnws2O2Q9wAnmkgrSNjQKV0l8GIM1AStMfW6NRahoSib2kEBUD+s3gUN0IACLVbCLRfABwFSNHPBqDHSWDHGWE12xzg2hIcBs8CAQ"
		. "wWzw1gEFA2YntzNzPvR60xMA7IN97AB5bYtMTeyPQY9BuDAQBCk60KpOvr4DpkHCBXWjB+ECwQJAQb4tAOtbX88GzwZfVa8GrwalhCPrQj5CEyeN"
		. "Vb7WVuhnvxO/E7IT6AF8AyYUqWvpNbMqGJIGF3oFUIMimADpyXLcmAXpt5PdKQTkdVaiAxStA1wAVx0JHwYTBmMeBlEZBlxPHwYfBh8GaALpAR4G"
		. "73vTaBMGCB8GHwYfBmYCYgAAgrEA6Z8CAACLRRAgiwCNUAEAcIkQBOmNAogID7cAZgCD+Ax1VoN9DEAAdBSLRQwAjEgAAotVDIkKZsdgAFwA6w0K"
		. "3AJMF6ENTGYA6T0OwisJwoIKPGFuAOnbAQ1hFskCEQRhDTxhcgDpKnmOMGeJMAm8MHQAFOkXjjAFgAgPtgUABAAAAITAdCkRBjYfdgyGBX52B0K4"
		. "ABMA6wW4gAIAoIPgAeszCBQYCBTCE4QFPaAAdw0awBc2bykwjgl1jQkDGw+3AMCLVRCJVCQIAQEKVCQEiQQk6DptgR4rwhHAJ8gRi1UhwAwSZokQ"
		. "jRxFCAICBC+FwA+FOvwU//9TISJNIZDJwwCQkJBVieVTgwTsJIAQZolF2McARfAnFwAAx0UC+AE/6y0Pt0XYAIPgD4nCi0XwAAHQD7YAZg++ANCL"
		. "RfhmiVRFQugBB2bB6AQBDoMARfgBg334A36gzcdF9APBDjOCIQAci0X0D7dcRZLoiiOJ2hAybfRAEBD0AHnHAl6LXfwBwic="
		static Code := false
		if ((A_PtrSize * 8) != 32) {
			Throw Exception("_LoadLib32Bit does not support " (A_PtrSize * 8) " bit AHK, please run using 32 bit AHK")
		}
		; MCL standalone loader https://github.com/G33kDude/MCLib.ahk
		; Copyright (c) 2021 G33kDude, CloakerSmoker (CC-BY-4.0)
		; https://creativecommons.org/licenses/by/4.0/
		if (!Code) {
			CompressedSize := VarSetCapacity(DecompressionBuffer, 3935, 0)
			if !DllCall("Crypt32\CryptStringToBinary", "Str", CodeBase64, "UInt", 0, "UInt", 1, "Ptr", &DecompressionBuffer, "UInt*", CompressedSize, "Ptr", 0, "Ptr", 0, "UInt")
				throw Exception("Failed to convert MCLib b64 to binary")
			if !(pCode := DllCall("GlobalAlloc", "UInt", 0, "Ptr", 9092, "Ptr"))
				throw Exception("Failed to reserve MCLib memory")
			DecompressedSize := 0
			if (DllCall("ntdll\RtlDecompressBuffer", "UShort", 0x102, "Ptr", pCode, "UInt", 9092, "Ptr", &DecompressionBuffer, "UInt", CompressedSize, "UInt*", DecompressedSize, "UInt"))
				throw Exception("Error calling RtlDecompressBuffer",, Format("0x{:08x}", r))
			for k, Offset in [33, 66, 116, 385, 435, 552, 602, 691, 741, 948, 998, 1256, 1283, 1333, 1355, 1382, 1432, 1454, 1481, 1531, 1778, 1828, 1954, 2004, 2043, 2093, 2360, 2371, 3016, 3027, 5351, 5406, 5420, 5465, 5476, 5487, 5540, 5595, 5609, 5654, 5665, 5676, 5725, 5777, 5798, 5809, 5820, 7094, 7105, 7280, 7291, 8610, 8949] {
				Old := NumGet(pCode + 0, Offset, "Ptr")
				NumPut(Old + pCode, pCode + 0, Offset, "Ptr")
			}
			OldProtect := 0
			if !DllCall("VirtualProtect", "Ptr", pCode, "Ptr", 9092, "UInt", 0x40, "UInt*", OldProtect, "UInt")
				Throw Exception("Failed to mark MCLib memory as executable")
			Exports := {}
			for ExportName, ExportOffset in {"bBoolsAsInts": 0, "bEscapeUnicode": 4, "dumps": 8, "fnCastString": 2184, "fnGetObj": 2188, "loads": 2192, "objFalse": 5852, "objNull": 5856, "objTrue": 5860} {
				Exports[ExportName] := pCode + ExportOffset
			}
			Code := Exports
		}
		return Code
	}
	_LoadLib64Bit() {
		static CodeBase64 := ""
		. "xrUMAQALAA3wVUiJ5RBIgezAAChIiU0AEEiJVRhMiUUAIESJyIhFKEggi0UQSIsABAWVAh0APosASDnCD0SEvABWx0X8AXrrAEdIg30YAHQtAItF"
		. "/EiYSI0VQo0ATkQPtgQAZkUCGAFgjUgCSItVABhIiQpmQQ++QNBmiRDrDwAbICCLAI1QAQEIiRDQg0X8AQU/TQA/AT4QhMB1pQJ9iUWgEEiLTSAC"
		. "Q41FoABJichIicHoRhYjAI4CeRkQaMcAIgoADmW4gVfpFgkAMADGRfuAZYFsUDBJgwNAIABsdVsADAEox0X0Amw1hBAYiwRF9IBMweAFSAGa0IBG"
		. "sIALgAFQEIALGIPAAQANAImUwIgARfuDRfQBgH2Q+wB0EwEZY9AILRR8sgNWLIIPCEG4wlsBMQZBuHsBuw9gBESJj1+AfSgAdFBkx0XwjLvwgpsm"
		. "mhyxu/DAXcMP5hvHXcjHRezCSqUGAidEQQLsSUGog33sAA8sjsqBL5hhLJQxZsfUReiMMeiCIV+AIa8xluiAMcMPH4gx6y+ZJkIglCZ5x0XkgiZo"
		. "KMdF4Mwo4MIYvhpt8SjgwCjDD37AD8UogwRF5MAFMDtF5H0IkA+2wJDwAYTAuA+E6EDpQVwGkTBBmdyNiZxbUL1AAajgB+FoSpjoaJjkaP4fJQoc"
		. "mTQK6f5DVIkK6epgAo3qEzjiE0Fsx0XcrCay3KIeihm/Jq8m3KAjXeMHSuAHCIOFGpCIGpAthBophhrWJCwsDesbp2YK5AlkCb0gewk6UC4Dv04t"
		. "NItAGIP4AU51YTCAEAoQXB4gcReGA2Iw4wQGD4Wf4EMzYwVhswkYoAHgl2nH1EXYbC/YYicXAAR/L01tL9hgL+MH1xdnL+m0iwJpD21AA2QP1GwP"
		. "utRiB6AABH8PbQ/UYA9V4wdgaQ8Pag8BZw/QtWwP0GIHKn8PcA/QYA8p4wfqFmgPk2JyMI00SAFACk1B48AQAExDgAZBColMJCDBNa1g+P//6WjE"
		. "M8I1Bax1H2QFLDtiITs9SQUQAg+Fg6NtqEiNoJVw////4QSKYJoox0XMIhxIIxwuSIiLlXjAA4tFzAAVYAHATI0EABttHEHoD7cQUxzMkAAKBFBd"
		. "AA+3AGaFwHWeVOmqUjzIHBXIEhHdbhUfFR8V7QbIEBXzA5338ANbPCoRb6AO7zMPTtoFDuzQBahI8XYPjET5RP//8VwPhN3iDMTl7AzE4gjwFO8M"
		. "7wwNB/bEAAfzA7DwA1dzMZRyY+sBkskGvMIChs8GzwbOBha8wAbzA0bIBoNFwIFwAcA7RTB8kKyFOl2khX2vha+FqJFIgeLEAQxdw5AKAOyiDgAK"
		. "VcCjMEEsjawkgBVCpI2zpJURJEiLhQthAKAbFLUASMdACNvyEZAJhaICAQpQAArTAAcRUXUBMSmD+CB01REtAQp0wi0BDXSvES0BCXScLQF7D4WO"
		. "KcJUrweiB8dFUMIQKMdFWHQAYHIAiwWOA+E4AT9BowX1/tAAEMdEJEBTAkQkOAGCAI1VMEiJVCSqMIAAUIEAKJABICG3VEG58QFBkha6ogKJUMFB"
		. "/9LwFzhQbGh/zxDPEM8QzxDPEM8QJwF9WA+EwvJHaQGF8IesgV4Bg/gidAq4IBDw/+lmEYEOoblgB8IeAOj3/f//hcB0+iIDAkUBAu8M7wzvDO8M"
		. "l+8M7wwkAToVCsQQDwi3CAhSKMcLOsMLtAOIsgNJsDKLjQMsRWjESQL/YA1/Go8Njw2PDY8Njw0nAZgsdR1vB2MH6cLQC+dAkIwd1Qy6D58QnBCw"
		. "OQIJtjmLVWhIiVAaCLPSfcoDkwVbD4W+ZUJ4PwX0M/LJcAD4dADTUkIQM8P7+TO10QD/M+yNVdDF8zPw/zP/M+AZwtjwM3DHhay07R8aPx8aHxof"
		. "Gh8aHxonAV0PNoRh45803kdQKCfH+pkpJxUOMQLiJouVcQz1UA1wRCftMBgvDS8NLw0BJAH+tQAKdMJIi4XAAAAAAEiLAA+3AEBmg/gNdK8NkAlE"
		. "dJwNSCx1JAdISAiNUAIFGokQg4UCrAAQAemq/v//gpANbl10Crj/AAC46T4NASoTggAJyAAJMGbHAAkBIwELSIuAVXBIiVAIuAALGADpAQo8A1ki"
		. "D4WMEwUaUwUXiYWgAgkdBFiVggaALQc7CADpRFkEDTGFwHWEXYKCDA8/XA+F9gMhP7mEVnU0AAmCPIETiQJC5YA8IpYg6ccKL4Q6FCOqXBcjgBAj"
		. "L5QRL5cRKjmQEWKUEQiXEfICVY8RZpQRDJcRq5ARblWUEQqXEWSQEXKUEQ11lxEdkBF0lBFCuJMR1sIBjxF1D4WFigWOmcHEFQAAx4WcAcvByw47"
		. "gwyBBoARweAEiUeB/UIKT1MvfkJNAjkcfy/HB2IHxwMB0INk6DDpCemuo2sqCEBEfj9NAkZ/LJoKN6mJCutczQdgLwpmPAqmVyoKhHm1CNcpg0Io"
		. "CAGDvcEAAw+OuIlAmkiDIggC6zrjB8J16QcQSI1K5wchitUjPkggPo0DExJQLmCXLJD7QAtFkkgmBynIBkiCFuMCQAhIg+hOBMs8dRcjpdcHbzEt"
		. "xHQubj4PjgyKp+Q+iA+P9eCgx4WYwSDLh6YADxQGqMdAICCwDDx1IuMGoSTfooMGMHUPITjTCk1+cA4wD46JwdACOX9260yGKAC9AInQSMHgAkgB"
		. "gNBIAcBJicBpDCkgNYuVYwwKoAdID6C/wEwBwGAP0AUISyPFTGYfbg5+jiVMUwgGAAAO4S4PheYD2BtIPmYP78DySIwPKsEUYQLyDxHgQBUGMQXA"
		. "M5TEM+tsixKVYQGJ0MAbAdAB7MCJQgP4G5jAOwIG8AUNcADScAASBGYPKMgQ8g9eyjYHEEAIsPIPWME8CFwQFw8kTI5q6h9jAWV0ngJFuA+F+I9N"
		. "/RCzAhRXImP/Ef8RxoWTDyoBKiFNkwEBTwdDB+syPQMr3HUf3gQfLUsRE68hhCEKOrI1jFRa6zqLlduxAMYbQZ8pnBtEER4xA4NfB18HfqDHhYiE"
		. "IojHhYRVBxyLlVEBSygj4QCDAgIBi2IAOyEyBnzWgL2iD3Qq61kh4BfJUCONUQMQIxoilOsolwJIgxoPKvIFePIPWb0k+R3BpdU6i0FSREiYSA+v"
		. "OTjr8jg6AwV1vwawBqEDvwalugYMtyIDAFNToQ98oPh0D4XfkhOAlROMUouyAJAJjRXSEAOAD7YEEGYPvkEK6ZgDOcIlr0taBZ1moQQL8BYWBYAU"
		. "BYTAdZcAD7YFUuT//4T4wHQdyQqoUtI/FRFkhcwVDgMHV0sF/CI2Q1AIiwXu0QCJwf/SBVMPq/+G+GYPhdMJUQ9FfCIPTItFfN3SCeewAv8O+w5b"
		. "/zz3DmhFfAG1BJu0BJAOoLmQDmjjnw5MYZ4OBKMGbZgO8lQHkw7kggGWDsFBLzP4bg+FpZIOeKESBkmLRXjSCQOfDmWXDgeSDut0bw5lDnhbYA6D"
		. "BLoxJ2MOo+wLVSv4yOMLQ+oLNeoL6wUhUgdIgcQwsAldwz6QBwCkKQ8ADwACACJVAG5rbm93bl9PAGJqZWN0XwANCgoQCSLVAHRydWUAAGZhbHNl"
		. "AG4IdWxs5wJWYWx1AGVfADAxMjM0ADU2Nzg5QUJDAERFRgBVSInlAEiDxIBIiU0QAEiJVRhMiUUgaMdF/ANTRcBREVsoAEiNTRhIjVX8AEiJVCQo"
		. "x0QkEiDxAUG5MSxJicgDcRJgAk0Q/9BIx0RF4NIAx0XodADwwbQEIEiJReDgAFOJAaIFTItQMItF/IpIEAVA0wJEJDiFAOIwggCNVeBGB8BXQAcH"
		. "ogdiFXGWTRBB/9Lz0QWE73UeogaBl8IYYAYT5ADRGOtgpwIDdVODtQEBDIBIOdB9QG4V1AK68Bp/Qhs50H9l4FNF8Q/YSXCIUwfooUE2hcB0D6AB"
		. "2LDuBVADUjAGEJBIg+xmgBge8xXsYPEV5BVmo7IREAWJRfigFhSABACLTRiJyrjNzATMzDBTwkjB6CAgicLB6gMmXinBAInKidCDwDCDzLQAbfwB"
		. "icKLRfwASJhmiVRFwIsARRiJwrjNzMwAzEgPr8JIwegAIMHoA4lFGIMAfRgAdalIjVUDAIQArEgBwEgB0ABIi1UgSYnQSACJwkiLTRDoAQD+//+Q"
		. "SIPEYAhdw5AGAFVIieUASIPscEiJTRAASIlVGEyJRSAQx0X8AAAA6a4CAAAASItFEEiLRFAYA1bB4AUBV4k0RdABD2MAYQEdQDAASDnCD42aAQBg"
		. "AGbHRbgCNAAaQAEAUEXwxkXvAEhAg33wAHkIAAoBAEj3XfDHRegUgwBfAJTwSLpnZgMAgEiJyEj36kgArgDB+AJJichJwWD4P0wpwAG8gQngBgIB"
		. "PABrKcFIicoAidCDwDCDbegVgo3og42QmCdIwflSPwAbSCmBXfACR3WAgIB97wB0EIEigYMhx0RFkC0AgKEGkIIHhKGJRcDGRSDnAMdF4IGJi0Uy"
		. "4IAMjRQBcQEPD7cKEAQJDAEJGEgByAAPtwBmOcJ1b4EPFQBmhcB1HokLi4AXhQsGgDIB6zqTGgR0IlMNdAqDReAQAelm/0B2gH3nkAAPhPYCVkUg"
		. "wH6JwC4QuMBkAOkBQAFlCmw4AWyMysMKhWrIqMZF38A52MM52IYb/sjFOYIE0DmNCsU5xwXLOb7fwjlRDcE5UQ3BOdjGORDfAHQSzTjrIIMsRfwA"
		. "cgg5IAI5O/0M//+ApEA6g8RwXWLDwruB7JABBIS8SGvEdsAB6MQB8MEBwLLgAgUCwPIPEADyD6IRQIXHRcCECMjEAXrQwgGNgGdAioADASNIAIsF"
		. "hOb//0iLoABMi1AwQAN2QQMQx0QkQAMNRCQ4hQICiwAfiVQkMMHtlQECKEAGIAEQQbnBBwpBwi26QgWJwUH/sNJIgcQBF/B3QOl3fwAXABmgeKNs"
		. "gSEACOReD0yJm39veW+4MOAHKRzQgyyTv2+pbw+Feg9gOWEIIwhgb8AtAOkegF8T34IfE9qCx0XsCSEu61DgARgAdDYLi6oAC+xCAUyNBAIzYlRg"
		. "K41IQAFhOQpBQQBlZokQ6w/hU4sQAI1QAQEBiRCDWEXsARQJR2OO5VRAWyc85Dsg6TsDExyvD2aAxwAiAOleBEOAKcgP6UpjAhAhDYP4KCJ1ZmMI"
		. "GXIIXADT7hdcDuYDTw7SYwJEDk5cXw5fDsgF6XNQDl8dSg4IXw5fDsYFYgDp2gBQDuxk5EMODF8OXw5hxgVmAOmNwwsqB3l9KgcKLwcvBy8HLwfi"
		. "Am5IAOkaLwfpBioHDR8vBy8HLwcvB+ICcgDptqcwTy0HkzMBJAcJLwcPLwcvBy8H4gJ0AOk0BS8H6aFXD7YFmdZA//+EwHQr1wcfRHYNxwB+dgcT"
		. "ZwVB4jqD4AHrNqkCGoWpAhTFAD2gAHd9A31ABnxfDV8NXg3vAuECdbPvAtQHD7dRUPFyGCBUUInB6IZxCDTDBB43zwRgAGADEo9MAQhFEANxT0IN"
		. "hcAPhab736BtXwnYQT4EQaggJE71TQtgWdVriQBrjQVC8wdwBVBZxKjrMg+3RXAQg+AP0qzAWlBTtrAAZg++kqiSXugRAjBmwegEEQTRgIN9gPwD"
		. "fsjHRfhwOwgA6z9TCiWLRfjASJhED7dE4HwOC5hEicJfD+BbbfjQBDD4AHm7JVr1Cw=="
		static Code := false
		if ((A_PtrSize * 8) != 64) {
			Throw Exception("_LoadLib64Bit does not support " (A_PtrSize * 8) " bit AHK, please run using 64 bit AHK")
		}
		; MCL standalone loader https://github.com/G33kDude/MCLib.ahk
		; Copyright (c) 2021 G33kDude, CloakerSmoker (CC-BY-4.0)
		; https://creativecommons.org/licenses/by/4.0/
		if (!Code) {
			CompressedSize := VarSetCapacity(DecompressionBuffer, 4249, 0)
			if !DllCall("Crypt32\CryptStringToBinary", "Str", CodeBase64, "UInt", 0, "UInt", 1, "Ptr", &DecompressionBuffer, "UInt*", CompressedSize, "Ptr", 0, "Ptr", 0, "UInt")
				throw Exception("Failed to convert MCLib b64 to binary")
			if !(pCode := DllCall("GlobalAlloc", "UInt", 0, "Ptr", 11168, "Ptr"))
				throw Exception("Failed to reserve MCLib memory")
			DecompressedSize := 0
			if (DllCall("ntdll\RtlDecompressBuffer", "UShort", 0x102, "Ptr", pCode, "UInt", 11168, "Ptr", &DecompressionBuffer, "UInt", CompressedSize, "UInt*", DecompressedSize, "UInt"))
				throw Exception("Error calling RtlDecompressBuffer",, Format("0x{:08x}", r))
			OldProtect := 0
			if !DllCall("VirtualProtect", "Ptr", pCode, "Ptr", 11168, "UInt", 0x40, "UInt*", OldProtect, "UInt")
				Throw Exception("Failed to mark MCLib memory as executable")
			Exports := {}
			for ExportName, ExportOffset in {"bBoolsAsInts": 0, "bEscapeUnicode": 16, "dumps": 32, "fnCastString": 2624, "fnGetObj": 2640, "loads": 2656, "objFalse": 7632, "objNull": 7648, "objTrue": 7664} {
				Exports[ExportName] := pCode + ExportOffset
			}
			Code := Exports
		}
		return Code
	}
	_LoadLib() {
		return A_PtrSize = 4 ? this._LoadLib32Bit() : this._LoadLib64Bit()
	}

	Dump(obj, pretty := 0)
	{
		this._init()
		if (!IsObject(obj))
			throw Exception("Input must be object")
		size := 0
		DllCall(this.lib.dumps, "Ptr", &obj, "Ptr", 0, "Int*", size
		, "Int", !!pretty, "Int", 0, "CDecl Ptr")
		VarSetCapacity(buf, size*2+2, 0)
		DllCall(this.lib.dumps, "Ptr", &obj, "Ptr*", &buf, "Int*", size
		, "Int", !!pretty, "Int", 0, "CDecl Ptr")
		return StrGet(&buf, size, "UTF-16")
	}

	Load(ByRef json)
	{
		this._init()

		_json := " " json ; Prefix with a space to provide room for BSTR prefixes
		VarSetCapacity(pJson, A_PtrSize)
		NumPut(&_json, &pJson, 0, "Ptr")

		VarSetCapacity(pResult, 24)

		if (r := DllCall(this.lib.loads, "Ptr", &pJson, "Ptr", &pResult , "CDecl Int")) || ErrorLevel
		{
			throw Exception("Failed to parse JSON (" r "," ErrorLevel ")", -1
			, Format("Unexpected character at position {}: '{}'"
			, (NumGet(pJson)-&_json)//2, Chr(NumGet(NumGet(pJson), "short"))))
		}

		result := ComObject(0x400C, &pResult)[]
		if (IsObject(result))
			ObjRelease(&result)
		return result
	}

	True[]
	{
		get
		{
			static _ := {"value": true, "name": "true"}
			return _
		}
	}

	False[]
	{
		get
		{
			static _ := {"value": false, "name": "false"}
			return _
		}
	}

	Null[]
	{
		get
		{
			static _ := {"value": "", "name": "null"}
			return _
		}
	}
}
;-------------- JSON End ---------------
;--------- AppID Finder Start ----------
global AppIDFinderProcessing = 0
global AppIDFinderSearched = 0
AppIDFinder(Name:="",CallBack:="")
{
    global
    AppIDFinderRunning = 1
    Gui,AppIDFinder:New,,App ID Finder
    Gui Add,Text,x10 y10 w150 h25 +0x200,Search Steam App Name:
    Gui Add,Text,x10 y50 w500 h25 +0x200,Select Steam App (Select Then Press OK/Double Click To Select):
    Gui Add,CheckBox,x430 y50 w190 h25 vAppIDFinderFuzzy gAppIDFinderFuzzy,Fuzzy Search      Delta(0-1):
    Gui Add,Edit,x622 y53 w35 h20 vAppIDFinderFuzzyDelta,0.5
    Gui Add,ListView,Grid x10 y80 w650 h380 vAppIDFinderList gAppIDFinderListClick +AltSubmit -Multi, App Name/Info|AppID
    Gui Add,Edit,x150 y10 w400 h25 vAppIDFinderAppName
    Gui Add,Button,x560 y10 w100 h25 Default vAppIDFinderSearch gAppIDFinderSearch,Search
    Gui Add,Button,x100 y465 w170 h30 vAppIDFinderOK gAppIDFinderOK,OK
    Gui Add,Button,x400 y465 w170 h30 gAppIDFinderGuiClose,Close
    Gui Show,x500 y70 w700 h500,App ID Finder
    GuiControl,,AppIDFinderAppName,% Name
    AppIDFinderFuzzy()
    AppIDFinderLoad()
    AppIDFinderCallBack := IsFunc(CallBack) ? Func(CallBack) : 0
    Return
}

AppIDFinderFuzzy()
{
GuiControlGet,AppIDFinderFuzzy,,AppIDFinderFuzzy
if ( AppIDFinderFuzzy = 1 )
{
GuiControl,Enable,AppIDFinderFuzzyDelta
}
else
{
GuiControl,Disable,AppIDFinderFuzzyDelta
}
return
}



AppIDFinderListClick()
{
    global AppIDFinderCallBack
    if(AppIDFinderSearched = 1)
    {
        if (LV_GetNext(0,"F") = 0)
        {
            return
        }
        Row := A_EventInfo
        LV_GetText(AppIDFinderOutputAppID,Row,2)
        if A_GuiEvent = Doubleclick
        {
            Log("AppID Finder Select Appid: " . AppIDFinderOutputAppID)
            AppIDFinderCallBack.Call(AppIDFinderOutputAppID)
            Gosub,AppIDFinderGuiClose
        }
    }
return
}

AppIDFinderOK()
{
    global AppIDFinderCallBack
    if (LV_GetNext(0,"F") = 0)
    {
        MsgBox,16,Info,Please Select Game.
        return
    }
    Row := LV_GetNext(0,"F")
    LV_GetText(AppIDFinderOutputAppID,Row,2)
    Log("AppID Finder Select Appid: " . AppIDFinderOutputAppID)
    AppIDFinderCallBack.Call(AppIDFinderOutputAppID)
    Gosub,AppIDFinderGuiClose
}

AppIDFinderLoad()
{
    AppIDFinderSearched = 0
    GuiControl,Disable,AppIDFinderSearch
    GuiControl,Disable,AppIDFinderOK
    global AppIDFinderAppList
    Log("Loading AppID Finder...")
    LV_ModifyCol(1,400)
    if (IsObject(AppIDFinderAppList))
    {
        Log("AppID Finder App List Already Loaded.")
        GuiControl,Enable,AppIDFinderSearch
        LV_Add("","Ready To Search.")
        Log("AppID Finder Loaded.")
        return
    }
    LV_Add("","Loading App List From Steam...(This Might Take a While)")	
    SetTimer, AppIDFinderLoad2,50
    GetAppList()
}

AppIDFinderLoad2:
Gui, AppIDFinder:Default
if (IsObject(AppIDFinderAppList))
{
    LV_Delete()
    GuiControl,Enable,AppIDFinderSearch
    LV_Add("","Ready To Search.")
    Log("AppID Finder Loaded.")
    SetTimer,AppIDFinderLoad2,Off
    return
}
return

AppIDFinderSearch()
{
    AppIDFinderProcessing = 1
    AppIDFinderSearched = 0
    GuiControl,Disable,AppIDFinderOK
    global AppIDFinderAppList
    GuiControlGet,AppIDFinderAppName,,AppIDFinderAppName
    GuiControlGet,AppIDFinderFuzzy,,AppIDFinderFuzzy
    GuiControlGet,AppIDFinderFuzzyDelta,,AppIDFinderFuzzyDelta
    if (AppIDFinderAppName = "" )
    {
        MsgBox,16,Error,Empty App Name.
        AppIDFinderProcessing = 0
        return
    }
    LV_Delete()
    if (AppIDFinderFuzzy = 1)
    {
        if AppIDFinderFuzzyDelta is not float
        {
            MsgBox,16,Error,Wrong Fuzzy Search Delta.
            AppIDFinderProcessing = 0
            return
        }
        if AppIDFinderFuzzyDelta not between 0 and 1
        {
            MsgBox,16,Error,Wrong Fuzzy Search Delta.
            AppIDFinderProcessing = 0
            return
        }
        LV_Add("","Searching...(This Might Take a While)")
        ResultIndexs := % Sift_Ngram(AppIDFinderAppList,AppIDFinderAppName,AppIDFinderFuzzyDelta)
        LV_Delete()
        for key, Index in ResultIndexs
        {
	        LV_Add("",AppIDFinderAppList[Index].name,AppIDFinderAppList[Index].appid)
	    }
    }
    else
    {
        for key, AppIDFinderAppListArrow in AppIDFinderAppList
        {
	    If (InStr(AppIDFinderAppListArrow.name,AppIDFinderAppName,false))
        {
            LV_Add("",AppIDFinderAppListArrow.name,AppIDFinderAppListArrow.appid)	
        }
	    }
    }
    GuiControl,Enable,AppIDFinderOK
    AppIDFinderSearched = 1
    AppIDFinderProcessing = 0
    return
}

GetAppList()
{
    global
    AppIDFinderAppList := JSON.Load(DownloadToString("https://api.steampowered.com/ISteamApps/GetAppList/v2/")).applist.apps
    return
}



DownloadToString(url, encoding = "utf-8")
{
    static a := "AutoHotkey/" A_AhkVersion
    if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
        return 0
    c := s := 0, o := ""
    if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "ptr", 0, "uint", 0, "uint", 0x80003000, "ptr", 0, "ptr"))
    {
        while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s > 0)
        {
            VarSetCapacity(b, s, 0)
            DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b, "uint", s, "uint*", r)
            o .= StrGet(&b, r >> (encoding = "utf-16" || encoding = "cp1200"), encoding)
        }
        DllCall("wininet\InternetCloseHandle", "ptr", f)
    }
    DllCall("wininet\InternetCloseHandle", "ptr", h)
    return o
}

AppIDFinderGuiClose:
if (AppIDFinderProcessing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
SetTimer, AppIDFinderLoad2,Off
AppIDFinderRunning = 0
Gui,Destroy
return

AppIDFinderGuiEscape:
if (AppIDFinderProcessing = 1)
{
    MsgBox,16,Info,Please Wait Until Process Complete before Closing.
    return
}
SetTimer, AppIDFinderLoad2,Off
AppIDFinderRunning = 0
Gui,Destroy
return
;--------- AppID Finder End ------------
;----------Sift Fuzzy Search Start -----
;{ Sift
; Fanatic Guru
; 2015 04 30
; Version 1.00
;
; LIBRARY to sift through a string or array and return items that match sift criteria.
;
; ===================================================================================================================================================
;
; Functions:
; 
; Sift_Ngram(Haystack, Needle, Delta, Haystack_Matrix, Ngram Size, Format)
;
;	Parameters:
;	1) {Haystack}		String or array of information to search, ByRef for efficiency but Haystack is not changed by function
;
;   2) {Needle}			String providing search text or criteria, ByRef for efficiency but Needle is not changed by function
;
;	3) {Delta}			(Default = .7) Fuzzy match coefficient, 1 is a prefect match, 0 is no match at all, only results above the Delta are returned
;
;	4) {Haystack_Matrix} (Default = false)	
;			An object containing the preprocessing of the Haystack for Ngrams content
;			If a non-object is passed the Haystack is processed for Ngram content and the results are returned by ByRef
;			If an object is passed then that is used as the processed Ngram content of Haystack
;			If multiply calls to the function are made with no change to the Haystack then a previous processing of Haystack for Ngram content 
;				can be passed back to the function to avoid reprocessing the same Haystack again in order to increase efficiency.
;
;	5) {Ngram Size}		(Default = 3) The length of Ngram used.  Generally Ngrams made of 3 letters called a Trigram is good
;
;	6) {Format}			(Default = S`n)
;			S				Return Object with results Sorted
;			U				Return Object with results Unsorted
;			S%%%			Return Sorted string delimited by characters after S
;			U%%%			Return Unsorted string delimited by characters after U
;								Sorted results are by best match first
;
;	Returns:
;		A string or array depending on Format parameter.
;		If string then it is delimited based on Format parameter.
;		If array then an array of object is returned where each element is of the structure: {Object}.Delta and {Object}.Data
;			Example Code to access object returned:
;				for key, element in Sift_Ngram(Data, QueryText, NgramLimit, Data_Ngram_Matrix, NgramSize)
;						Display .= element.delta "`t" element.data "`n"
;
;	Dependencies: Sift_Ngram_Get, Sift_Ngram_Compare, Sift_Ngram_Matrix, Sift_SortResults
;		These are helper functions that are generally not called directly.  Although Sift_Ngram_Matrix could be useful to call directly to preprocess a large static Haystack
;
; 	Note:
;		The string "dog house" would produce these Trigrams: dog|og |g h| ho|hou|ous|use
;		Sift_Ngram breaks the needle and each item of the Haystack up into Ngrams.
;		Then all the Needle Ngrams are looked for in the Haystack items Ngrams resulting in a percentage of Needle Ngrams found
;
; ===================================================================================================================================================


Sift_Ngram(ByRef Haystack, ByRef Needle, Delta := .7, ByRef Haystack_Matrix := false, n := 3, Format := "S`n" )
{
	Haystack_Matrix := Sift_Ngram_Matrix(Haystack, n)
	Needle_Ngram := Sift_Ngram_Get(Needle, n)
	Search_Results := {}
	for key, Hay_Ngram in Haystack_Matrix
	{
		Result := Sift_Ngram_Compare(Hay_Ngram, Needle_Ngram)
		if !(Result < Delta)
            Search_Results.Push(key)
	}
	return Search_Results
}

Sift_Ngram_Get(ByRef String, n := 3)
{
	Pos := 1, Grams := {}
	Loop, % (1 + StrLen(String) - n)
		gram := SubStr(String, A_Index, n), Grams[gram] ? Grams[gram] ++ : Grams[gram] := 1
	return Grams
} 

Sift_Ngram_Compare(ByRef Hay, ByRef Needle)
{
	for gram, Needle_Count in Needle
	{
		Needle_Total += Needle_Count
		Match += (Hay[gram] > Needle_Count ? Needle_Count : Hay[gram])
	}
	return Match / Needle_Total
}

Sift_Ngram_Matrix(ByRef Data, n := 3)
{
	Matrix := {}
	for key, string in Data
		Matrix.Insert(Sift_Ngram_Get(string.name, n))
	return Matrix
}

Sift_SortResults(ByRef Data)
{
	Data_Temp := {}
	for key, element in Data
		Data_Temp[element.Delta SubStr("0000000000" key, -9)] := element
	Data := {}
	for key, element in Data_Temp
		Data.InsertAt(1,element)
	return
}
;----------Sift Fuzzy Search End -----