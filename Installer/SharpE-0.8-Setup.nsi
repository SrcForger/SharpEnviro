# Auto-generated by EclipseNSIS Script Wizard
# 08.04.2010 17:28:31

Name SharpEnviro

SetCompressor /solid lzma
# SetCompressor bzip2

RequestExecutionLevel highest

!define StrLoc "!insertmacro StrLoc"

!macro StrLoc ResultVar String SubString StartPoint
  Push "${String}"
  Push "${SubString}"
  Push "${StartPoint}"
  Call StrLoc
  Pop "${ResultVar}"
!macroend

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 0.8-RC2
!define COMPANY "SharpE Development Team"
!define URL www.sharpenviro.com

# MUI Symbol Definitions
!define MUI_ICON "..\Graphics\Application Icons\orange.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_LICENSEPAGE_CHECKBOX
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER SharpEnviro
!define MUI_UNICON "..\Graphics\Application Icons\white.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_WELCOMEFINISHPAGE_BITMAP "InstallBanner.bmp"

# Included files
!include Sections.nsh
!include MUI2.nsh
!include LogicLib.nsh
!include x64.nsh

;Required .NET framework
!define MIN_FRA_MAJOR "3"
!define MIN_FRA_MINOR "5"
!define MIN_FRA_BUILD "*"
Var InstallDotNET

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ..\License\gpl-3.0.txt
!insertmacro MUI_PAGE_COMPONENTS
Page custom getSettingsSelect getSettingsLeave
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE "DirectoryLeave"
!insertmacro MUI_PAGE_DIRECTORY
Page custom checkNETFramework checkNETFrameworkLeave
Page custom getRunningComponents getRunningComponentsLeave
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
Page custom setShell setShellLeave
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "FinishPageShow"
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE "FinishPageLeave"
!define MUI_FINISHPAGE_RUN "$INSTDIR\setshell.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Run SetShell.exe to manually change the shell"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
UninstPage custom un.getRunningComponents un.getRunningComponentsLeave
UninstPage custom un.unsetShell un.unsetShellLeave
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE "un.FinishPageLeave"
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

Var UseAppDir
Var SetupSetShell
Var DoReboot
Var InstallDevelopmentFiles

Function setShellLeave
  ReadINIStr $SetupSetShell "$PLUGINSDIR\SetShell.ini" "Field 3" "state"
  IntCmp $SetupSetShell 0 DontSetShell
    # Seperate Explorer Fix
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" DesktopProcess 1
    # Set Shell
    WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\winlogon" Shell "$INSTDIR\SharpCore.exe -startup"
    # Ini File Mapping Change
    ${If} ${RunningX64}
      SetRegView 64
    ${EndIf}
    WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\system.ini\boot" Shell "USR:Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
    ${If} ${RunningX64}
      SetRegView 32
    ${EndIf}
    StrCpy $DoReboot "True"
    GoTo DoneShellLeave
  DontSetShell:
    StrCpy $DoReboot "False"
  DoneShellLeave:
  Pop $R0
FunctionEnd

Function setShell
  !insertmacro MUI_HEADER_TEXT "Change Windows Default Shell" "Select if to change the shell now or do it manually later"
  InstallOptions::initDialog /NOUNLOAD $PLUGINSDIR\SetShell.ini
  GetDlgItem $0 $HWNDPARENT 2
  EnableWindow $0 0
  GetDlgItem $0 $HWNDPARENT 0
  EnableWindow $0 0
  InstallOptions::show
  Pop $R0
FunctionEnd

Function checkNETFrameworkLeave
  ExecWait "$PLUGINSDIR\dotNetFx35setup.exe"
FunctionEnd

Function checkNETFramework
  !insertmacro MUI_HEADER_TEXT ".NET Framework 3.5 Setup" "SharpEnviro requires that the .NET Framework 3.5 is installed."

  StrCpy $InstallDotNET "No"
  Call CheckFramework
  StrCmp $0 "1" DontInstallNET
    StrCpy $InstallDotNET "Yes"
    InstallOptions::dialog $PLUGINSDIR\DotNETCheck.ini
  DontInstallNET:
  Pop $0
FunctionEnd

Function FinishPageShow
  # Disable back button
  GetDlGItem $0 $HWNDPARENT 3
  EnableWindow $0 0
  
  IntCmp $SetupSetShell 0 DontHideSetShell
    FindWindow $2 "#32770" "" $HWNDPARENT ; Get inner dialog inside main window (the "white part" of the dialog)
    GetDlgItem $2 $2 1203 ; Item 1203 -> "Run Setshell.exe" Checkbock)
    SendMessage $2 ${BM_CLICK} 0 0 ; uncheck it
    ShowWindow $2 ${SW_HIDE} ; Hide it
  DontHideSetShell:
FunctionEnd

Function FinishPageLeave
  StrCmp $DoReboot "False" DontReboot
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "A reboot of the computer is necessary for the changes to take effect$\n\
      Do you want to reboot your computer now?" \
      IDYES RebootNow IDNO DontReboot
    RebootNow:
      Reboot
  DontReboot:
FunctionEnd

Function DirectoryLeave
  IntCmp $UseAppDir 1 ValidDir
  Push $INSTDIR # Input string (install path).
  
  ${StrLoc} $0 $INSTDIR $PROGRAMFILES ">"
  ${StrLoc} $1 $INSTDIR $SYSDIR ">"
  ${StrLoc} $2 $INSTDIR $COMMONFILES ">"
  ${StrLoc} $3 $INSTDIR $WINDIR ">"
  ${StrLoc} $4 $INSTDIR $STARTMENU ">"
  ${StrLoc} $5 $INSTDIR $TEMP ">"
  ${StrLoc} $6 $INSTDIR $APPDATA ">"
  ${StrLoc} $7 $INSTDIR $PROGRAMFILES64 ">"
  ${StrLoc} $8 $INSTDIR $COMMONFILES64 ">"
  StrCmp $0 "0" InvalidDir
  StrCmp $1 "0" InvalidDir
  StrCmp $2 "0" InvalidDir
  StrCmp $3 "0" InvalidDir
  StrCmp $4 "0" InvalidDir
  StrCmp $5 "0" InvalidDir
  StrCmp $6 "0" InvalidDir
  StrCmp $7 "0" InvalidDir
  StrCmp $8 "0" InvalidDir
  
  Goto ValidDir
  InvalidDir:
    # Show message box then take the user back to the Directory page.
    MessageBox MB_OK|MB_ICONEXCLAMATION "Error: You choose to have SharpE store the user settings within the SharpE directory.$\n\
      Installing into a protected directory like '$INSTDIR' is not possible in this case.$\n\
      Please select another directory or choose to store the user settings globaly in the windows application data directory."
    Abort

  ValidDir:
FunctionEnd

Function getSettingsLeave
  ReadINIStr $UseAppDir "$PLUGINSDIR\SettingsSelect.ini" "Field 3" "state"
  IntCmp $UseAppDir 1 DontChange
  StrCmp $INSTDIR "$PROGRAMFILES\SharpEnviro" Change DontChange
  Change:
    StrCpy $INSTDIR "C:\SharpEnviro"
  DontChange:
FunctionEnd

Function getSettingsSelect
  !insertmacro MUI_HEADER_TEXT "Choose Settings Location" "Select where SharpE should store your user settings"
  Push $R0
  InstallOptions::dialog $PLUGINSDIR\SettingsSelect.ini
  Pop $R0
  ReadINIStr $UseAppDir "$PLUGINSDIR\SettingsSelect.ini" "Field 3" "state"
  Pop $R0
FunctionEnd

# Installer attributes
OutFile SharpE-${VERSION}-Setup.exe
InstallDir $PROGRAMFILES\SharpEnviro
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion 0.8.0.0
VIAddVersionKey ProductName SharpEnviro
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File ..\License\gpl-3.0.txt
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
SectionEnd

Section "!Core Files" SEC01
  SectionIn RO # Section can't be disabled
  
  # Addons
  SetOutPath "$INSTDIR\Addons\"
  File "..\..\SharpE\Addons\Explorer.exe"
  File "..\..\SharpE\Addons\Explorer32.dll"
  File "..\..\SharpE\Addons\Explorer64.dll"
  File "..\..\SharpE\Addons\SharpEnviro.dll"
  File "..\..\SharpE\Addons\SharpSearch.dll"
  File "..\..\SharpE\Addons\SharpSearch.WPF.dll"
  File "..\..\SharpE\Addons\SharpTwitter.dll"
  SetOutPath "$INSTDIR\Addons\SQLite\x64\"
  File "..\..\SharpE\Addons\SQLite\x64\System.Data.SQLite.dll"
  SetOutPath "$INSTDIR\Addons\SQLite\x86\"
  File "..\..\SharpE\Addons\SQLite\x86\System.Data.SQLite.dll"
  
  # Center
  SetOutPath "$INSTDIR\Center\"
  File /r "..\..\SharpE\Center\*.*"
  
  # Cursors - Cony Island
  SetOutPath "$INSTDIR\Cursors\"
  File /r "..\..\SharpE\Cursors\*.*"

  # Icons - Default
  SetOutPath "$INSTDIR\Icons\Default\"
  File /r "..\..\SharpE\Icons\Default\*.*"

  # Icons - GNOME
  SetOutPath "$INSTDIR\Icons\GNOME\"
  File /r "..\..\SharpE\Icons\GNOME\*.*"
  
  # Icons - Menu
  SetOutPath "$INSTDIR\Icons\Menu\"
  File /r "..\..\SharpE\Icons\Menu\*.*"
  
  # Icons - nuoveXT2
  SetOutPath "$INSTDIR\Icons\nuoveXT2\"
  File /r "..\..\SharpE\Icons\nuoveXT2\*.*"
  
  # Icons - Tango
  SetOutPath "$INSTDIR\Icons\SimplyGrey\"
  File /r "..\..\SharpE\Icons\SimplyGrey\*.*"

  # Icons - Tango
  SetOutPath "$INSTDIR\Icons\Token\"
  File /r "..\..\SharpE\Icons\Token\*.*"
  
  # Icons - Weather
  SetOutPath "$INSTDIR\Icons\Weather\"
  File /r "..\..\SharpE\Icons\Weather\*.*"
  
  # Modules
  SetOutPath "$INSTDIR\Modules\"
  File "..\..\SharpE\Modules\*.dll"
  
  # Objects
  SetOutPath "$INSTDIR\Objects\"
  File "..\..\SharpE\Objects\*.dll"
  
  # Services
  SetOutPath "$INSTDIR\Services\"
  File "..\..\SharpE\Services\*.dll"
  
  # Skins - Minimal
  SetOutPath "$INSTDIR\Skins\Minimal\"
  File /r "..\..\SharpE\Skins\Minimal\*.*"

  # Skins - Minimal 2
  SetOutPath "$INSTDIR\Skins\Minimal 2\"
  File /r "..\..\SharpE\Skins\Minimal 2\*.*"
  
  # Skins - Number 7
  SetOutPath "$INSTDIR\Skins\Number 7\"
  File /r "..\..\SharpE\Skins\Number 7\*.*"
  
  # Skins - Number 8
  SetOutPath "$INSTDIR\Skins\Number 8\"
  File /r "..\..\SharpE\Skins\Number 8\*.*"
  
  # Skins - Objects
  SetOutPath "$INSTDIR\Skins\Objects\"
  File /r "..\..\SharpE\Skins\Objects\*.*"
  
  # Skins - Sept
  SetOutPath "$INSTDIR\Skins\Sept\"
  File /r "..\..\SharpE\Skins\Sept\*.*"
  
  # Skins - Simple
  SetOutPath "$INSTDIR\Skins\Simple\"
  File /r "..\..\SharpE\Skins\Simple\*.*"
  
  # Skins - Sunken
  SetOutPath "$INSTDIR\Skins\Sunken\"
  File /r "..\..\SharpE\Skins\Sunken\*.*"
  
  # Settings - Default User
  SetOutPath "$INSTDIR\Settings\#Default#"
  File /r "..\..\SharpE\Settings\#Default#\*.*"

  # Settings - Default Global
  SetOutPath "$INSTDIR\Settings\#DefaultGlobal#\"
  File /r "..\..\SharpE\Settings\#DefaultGlobal#\*.*"

  SetOutPath "$INSTDIR"
  # Libraries
  File "..\..\SharpE\SharpApi.dll"
  File "..\..\SharpE\SharpApiEx.dll"
  File "..\..\SharpE\SharpCenterApi.dll"
  File "..\..\SharpE\SharpDeskApi.dll"
  File "..\..\SharpE\SharpDialogs.dll"
  File "..\..\SharpE\SharpThemeApiEx.dll"
  # Components
  File "..\..\SharpE\SetShell.exe"
  File "..\..\SharpE\SharpAdmin.exe"
  File "..\..\SharpE\SharpBar.exe"
  File "..\..\SharpE\SharpCenter.exe"
  File "..\..\SharpE\SharpConsole.exe"
  File "..\..\SharpE\SharpCore.exe"
  File "..\..\SharpE\SharpDesk.exe"
  File "..\..\SharpE\SharpLinkLauncherNET.exe"
  File "..\..\SharpE\SharpMenu.exe"
  File "..\..\SharpE\SharpSplash.exe"
  
  # Other Files
  File "..\FDS\rtl100.bpl"
  File "..\FDS\vcl100.bpl"
  File "..\FDS\splash.png"
SectionEnd

Section "Additional Icons" SEC02

SectionEnd

Section "Development Tools" SEC03
  StrCpy $InstallDevelopmentFiles "True"
  SetOutPath "$INSTDIR"
  File "..\..\SharpE_BuildTools\SharpCompile.exe"
  File "..\..\SharpE_BuildTools\7z.dll"
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "Necessary Files for the shell to work."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "Install additional icon sets."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "Install tools to compile the SharpE source code."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    
    ${If} $UseAppDir == "1"
          WriteRegDWORD HKLM "${REGKEY}" UseAppData 1
    ${Else}
          WriteRegDWORD HKLM "${REGKEY}" UseAppData 0
    ${EndIf}
    
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    CreateShortcut "$DESKTOP\SharpE Desktop.lnk" "$INSTDIR\SharpCore.exe" '-action "!ToggleDesktop"'
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Change Shell.lnk" $INSTDIR\setshell.exe
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\SharpCenter.lnk" $INSTDIR\SharpCenter.exe
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk" $INSTDIR\uninstall.exe
    StrCmp $InstallDevelopmentFiles "True" InstallDevelopmentShortcuts ContinueSection
    InstallDevelopmentShortcuts:
      SetOutPath "$SMPROGRAMS\$StartMenuGroup\Development"
      CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Development\SharpCompile.lnk" $INSTDIR\SharpCompile.exe
    ContinueSection:
    SetOutPath "$SMPROGRAMS\$StartMenuGroup\Debug"
    CreateShortCut "$SMPROGRAMS\$StartMenuGroup\Debug\SharpConsole.lnk" "$INSTDIR\SharpConsole.exe"
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

Var ComponentsRunning
Var RunningComponentsHWND
!define WM_SHARPTERMINATE 33318 # (WM_APP + 550)

# define a macro for installer and uninstaller functions
!macro getRunningComponentsMacro un
Function ${un}killRunningComponents
   FindWindow $0 "TSharpBarMainForm" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   FindWindow $0 "TSharpCoreMainWnd" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   FindWindow $0 "TSharpDeskMainForm" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   FindWindow $0 "TSharpExplorerForm" "SharpExplorerForm"
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   FindWindow $0 "TSharpConsoleWnd" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   FindWindow $0 "TSharpEMenuWnd" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   FindWindow $0 "TSharpCenterWnd" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0

   sleep 500
   FindWindow $0 "TSharpBarMainForm" "" # do SharpBar again in case of multiple bars
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   FindWindow $0 "TSharpCompileMainWnd" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0

   FindWindow $0 "TSharpECreateGenericScriptForm" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   FindWindow $0 "TSharpSplashWnd" ""
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0

   sleep 500
   FindWindow $0 "TSharpBarMainForm" "" # and again ...
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   sleep 500
   FindWindow $0 "TSharpBarMainForm" "" # again ...
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
   
   sleep 500
   FindWindow $0 "TSharpBarMainForm" "" # wohooo ...
   SendMessage $0 ${WM_SHARPTERMINATE} 0 0
FunctionEnd

Function ${un}getRunningComponentsRefresh
   GetDlgItem $1 $RunningComponentsHWND 1201

   StrCpy $ComponentsRunning "False"
   # Check if any SharpE Components are still running
   FindWindow $0 "TSharpBarMainForm" ""
   StrCmp $0 0 barNotRunning
   StrCpy $2 "SharpBar"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   barNotRunning:

   FindWindow $0 "TSharpCoreMainWnd" ""
   StrCmp $0 0 coreNotRunning
   StrCpy $2 "SharpCore"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   coreNotRunning:

   FindWindow $0 "TSharpDeskMainForm" ""
   StrCmp $0 0 deskNotRunning
   StrCpy $2 "SharpDesk"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   deskNotRunning:

   FindWindow $0 "TSharpExplorerForm" "SharpExplorerForm"
   StrCmp $0 0 explorerdeskNotRunning
   StrCpy $2 "Explorer Desktop"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   explorerdeskNotRunning:

   FindWindow $0 "TSharpConsoleWnd" ""
   StrCmp $0 0 consoleNotRunning
   StrCpy $2 "SharpConsole"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   consoleNotRunning:

   FindWindow $0 "TSharpEMenuWnd" ""
   StrCmp $0 0 menuNotRunning
   StrCpy $2 "SharpMenu"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   menuNotRunning:

   FindWindow $0 "TSharpCenterWnd" ""
   StrCmp $0 0 centerNotRunning
   StrCpy $2 "SharpCenter"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   centerNotRunning:

   FindWindow $0 "TSharpCompileMainWnd" ""
   StrCmp $0 0 compileNotRunning
   StrCpy $2 "SharpCompile"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   compileNotRunning:

   FindWindow $0 "TSharpECreateGenericScriptForm" ""
   StrCmp $0 0 scriptNotRunning
   StrCpy $2 "SharpScript"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   scriptNotRunning:

   FindWindow $0 "TSharpSplashWnd" ""
   StrCmp $0 0 splashNotRunning
   StrCpy $2 "SharpSplash"
   SendMessage $1 ${LB_ADDSTRING} 1 "STR:$2"
   StrCpy $ComponentsRunning "True"
   splashNotRunning:
FunctionEnd

Function ${un}updateRunningComponentsButtons
   StrCmp $ComponentsRunning "False" EnableNext DisableNext
   EnableNext:
     GetDlgItem $0 $HWNDPARENT 1
     EnableWindow $0 1
     GetDlgItem $1 $RunningComponentsHWND 1201
     SendMessage $1 ${LB_ADDSTRING} 1 "STR:No SharpE Components Running"

     GetDlgItem $1 $RunningComponentsHWND 1202 # Close All Button
     EnableWindow $1 0

     GoTo AfterNext
   DisableNext:
     GetDlgItem $0 $HWNDPARENT 1
     EnableWindow $0 0

     GetDlgItem $1 $RunningComponentsHWND 1202 # Close All Button
     EnableWindow $1 1
   AfterNext:
FunctionEnd

Function ${un}clearRunningComponents
   GetDlgItem $1 $RunningComponentsHWND 1201
   GoTo CheckNext
   DeleteNext:
     SendMessage $1 ${LB_DELETESTRING} 0 0
   CheckNext:
     SendMessage $1 ${LB_GETCOUNT} 0 0 $0
     StrCmp $0 "0" ContinueUpdate DeleteNext
   ContinueUpdate:
FunctionEnd

Function ${un}getRunningComponentsLeave
   ReadINIStr $R0 "$PLUGINSDIR\RunningComponents.ini" "Settings" "State"
   Pop $R1
   GetDlgItem $1 $RunningComponentsHWND 1201

   ${If} $R0 == 4 # Refresh
     Call ${un}clearRunningComponents
     Call ${un}getRunningComponentsRefresh
     Call ${un}updateRunningComponentsButtons
     
     Abort
   ${EndIf}
   ${If} $R0 == 3 # Close All
     Call ${un}killRunningComponents
     Call ${un}clearRunningComponents
     sleep 500
     Call ${un}getRunningComponentsRefresh
     Call ${un}updateRunningComponentsButtons

     SendMessage $1 ${LB_GETCOUNT} 0 0 $0
     StrCmp $0 "0" ContinueCloseAll
     MessageBox MB_OK|MB_ICONEXCLAMATION "Setup was unable to close some of the remaining running SharpE Components.$\n\
     Please try to close the components again or reboot the computer after setting the shell back to explorer.$\n"
     ContinueCloseAll:
     
     Abort
   ${EndIf}
FunctionEnd

Function ${un}getRunningComponents
  !insertmacro MUI_HEADER_TEXT "Running SharpE Components" "Setup has to check if any SharpE components are still running."
   Push $R0
   InstallOptions::initDialog /NOUNLOAD $PLUGINSDIR\RunningComponents.ini
   Pop $RunningComponentsHWND

   Call ${un}getRunningComponentsRefresh
   Call ${un}updateRunningComponentsButtons

   InstallOptions::show
   Pop $R0
   ReadINIStr $R0 "$PLUGINSDIR\RunningComponents.ini" "Settings" "State"
   Pop $R0
FunctionEnd
!macroend

# Insert as an installer and unistaller functions
!insertmacro getRunningComponentsMacro ""
!insertmacro getRunningComponentsMacro "un."

Function un.unsetShellLeave
  # Seperate Explorer Fix
  WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" DesktopProcess 0
  # Set Shell
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\winlogon" Shell "explorer.exe"
  # Launch Explorer.exe to start the windows shell
  Exec "explorer.exe"
FunctionEnd

Function un.unsetShell
  !insertmacro MUI_HEADER_TEXT "Change Windows Default Shell" "Changing the shell back to Explorer"
  Push $R0
  InstallOptions::dialog $PLUGINSDIR\UnsetShell.ini
  Pop $R0
FunctionEnd

Function un.FinishPageLeave
  MessageBox MB_YESNO|MB_ICONEXCLAMATION "A reboot of the computer is necessary for the changes to take effect$\n\
    Do you want to reboot your computer now?" \
    IDYES RebootNow IDNO DontReboot
  RebootNow:
    Reboot
  DontReboot:
FunctionEnd

# Uninstaller sections
Section /o -un.Main UNSEC0000
    Delete "$INSTDIR\gpl-3.0.txt"
    
     # Libraries
    Delete "$INSTDIR\SharpApi.dll"
    Delete "$INSTDIR\SharpApiEx.dll"
    Delete "$INSTDIR\SharpCenterApi.dll"
    Delete "$INSTDIR\SharpDeskApi.dll"
    Delete "$INSTDIR\SharpDialogs.dll"
    Delete "$INSTDIR\SharpThemeApiEx.dll"

    # Components
    Delete "$INSTDIR\SetShell.exe"
    Delete "$INSTDIR\SharpAdmin.exe"
    Delete "$INSTDIR\SharpBar.exe"
    Delete "$INSTDIR\SharpCenter.exe"
    Delete "$INSTDIR\SharpConsole.exe"
    Delete "$INSTDIR\SharpCore.exe"
    Delete "$INSTDIR\SharpDesk.exe"
    Delete "$INSTDIR\SharpLinkLauncherNET.exe"
    Delete "$INSTDIR\SharpMenu.exe"
    Delete "$INSTDIR\SharpSplash.exe"
    Delete "$INSTDIR\SharpCompile.exe"
    Delete "$INSTDIR\rtl100.bpl"
    Delete "$INSTDIR\vcl100.bpl"
    Delete "$INSTDIR\splash.png"
    Delete "$INSTDIR\7z.dll"
    
    # SharpCompile settings file
    Delete "$INSTDIR\SharpCompile-Settings.xml"
    
    RMDir /r "$INSTDIR\Settings\#Default#"
    RMDir /r "$INSTDIR\Settings\#DefaultGlobal#"
    
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "Do you want to also delete your SharpEnviro user settings?" \
      IDYES DeleteSettings IDNO DontDeleteSettings
    DeleteSettings:
      RMDir /r "$INSTDIR\Settings\Global"
      RMDir /r "$INSTDIR\Settings\User"
      RMDir /r "$INSTDIR\Settings"
      SetShellVarContext all
      IfFileExists "$APPDATA\SharpEnviro\*.*" DeleteGlobalSettings DontDeleteGlobalSettings
      DeleteGlobalSettings:
        RMDIR /r "$APPDATA\SharpEnviro\*.*"
      DontDeleteGlobalSettings:
      SetShellVarContext current
      IfFileExists "$APPDATA\SharpEnviro\*.*" DeleteUserSettings DontDeleteUserSettings
      DeleteUserSettings:
        RMDIR /r "$APPDATA\SharpEnviro\*.*"
      DontDeleteUserSettings:
    DontDeleteSettings:
    
    RMDir "$INSTDIR\Settings\"
    
    RmDir /r "$INSTDIR\Addons\"
    RmDir /r "$INSTDIR\Cache\"
    RmDir /r "$INSTDIR\Center\"
    
    # Delete the cursors that we install, leave any the user may have added
    RmDir /r "$INSTDIR\Cursors\Cony Island\"
    RmDir /r "$INSTDIR\Cursors\GNOME\"
    RmDir /r "$INSTDIR\Cursors\MoonShine\"
    RmDir /r "$INSTDIR\Cursors\Nabla\"
    RmDir /r "$INSTDIR\Cursors\Nabla Extended\"
    RmDir /r "$INSTDIR\Cursors\Snubby\"
    RmDir "$INSTDIR\Cursors\"
    
    # Delete the icons that we install, leave any the user may have added
    RmDir /r "$INSTDIR\Icons\Default\"
    RmDir /r "$INSTDIR\Icons\Gnome\"
    RmDir /r "$INSTDIR\Icons\Menu\"
    RmDir /r "$INSTDIR\Icons\nuoveXT2\"
    RmDir /r "$INSTDIR\Icons\SimplyGrey\"
    RmDir /r "$INSTDIR\Icons\Token\"
    RmDir /r "$INSTDIR\Icons\Weather\"
    RmDir "$INSTDIR\Icons\"
    
    RmDir /r "$INSTDIR\Modules\"
    RmDir /r "$INSTDIR\Objects\"
    RmDir /r "$INSTDIR\Services\"
    
    # Delete the skins that we install, leave any the user may have added
    RmDir /r "$INSTDIR\Skins\Minimal\"
    RmDir /r "$INSTDIR\Skins\Minimal 2\"
    RmDir /r "$INSTDIR\Skins\Number 7\"
    RmDir /r "$INSTDIR\Skins\Number 8\"
    RmDir /r "$INSTDIR\Skins\Objects\"
    RmDir /r "$INSTDIR\Skins\Sept\"
    RmDir /r "$INSTDIR\Skins\Simple\"
    RmDir /r "$INSTDIR\Skins\Sunken\"
    RmDir "$INSTDIR\Skins\"
    
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Change Shell.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\SharpCenter.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Development\SharpCompile.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Debug\SharpConsole.lnk"
    Delete /REBOOTOK "$DESKTOP\SharpE Desktop.lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Debug"
    RmDir /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Development"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
    File /oname=$PLUGINSDIR\RunningComponents.ini "RunningComponents.ini"
    File /oname=$PLUGINSDIR\SettingsSelect.ini "SettingsSelect.ini"
    File /oname=$PLUGINSDIR\DotNETCheck.ini "DotNETCheck.ini"
    File /oname=$PLUGINSDIR\SetShell.ini "SetShell.ini"
    File /oname=$PLUGINSDIR\dotNetFx35setup.exe "dotNetFx35setup.exe"
FunctionEnd

# Uninstaller functions
Function un.onInit
    InitPluginsDir
    File /oname=$PLUGINSDIR\RunningComponents.ini "RunningComponents.ini"
    File /oname=$PLUGINSDIR\UnsetShell.ini "UnsetShell.ini"
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

Function StrLoc
/*After this point:
  ------------------------------------------
   $R0 = StartPoint (input)
   $R1 = SubString (input)
   $R2 = String (input)
   $R3 = SubStringLen (temp)
   $R4 = StrLen (temp)
   $R5 = StartCharPos (temp)
   $R6 = TempStr (temp)*/

  ;Get input from user
  Exch $R0
  Exch
  Exch $R1
  Exch 2
  Exch $R2
  Push $R3
  Push $R4
  Push $R5
  Push $R6

  ;Get "String" and "SubString" length
  StrLen $R3 $R1
  StrLen $R4 $R2
  ;Start "StartCharPos" counter
  StrCpy $R5 0

  ;Loop until "SubString" is found or "String" reaches its end
  ${Do}
    ;Remove everything before and after the searched part ("TempStr")
    StrCpy $R6 $R2 $R3 $R5

    ;Compare "TempStr" with "SubString"
    ${If} $R6 == $R1
      ${If} $R0 == `<`
        IntOp $R6 $R3 + $R5
        IntOp $R0 $R4 - $R6
      ${Else}
        StrCpy $R0 $R5
      ${EndIf}
      ${ExitDo}
    ${EndIf}
    ;If not "SubString", this could be "String"'s end
    ${If} $R5 >= $R4
      StrCpy $R0 ``
      ${ExitDo}
    ${EndIf}
    ;If not, continue the loop
    IntOp $R5 $R5 + 1
  ${Loop}

  ;Return output to user
  Pop $R6
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch
  Pop $R1
  Exch $R0
FunctionEnd

;Check for .NET framework
Function CheckFrameWork

   ;Save the variables in case something else is using them
  Push $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $R1
  Push $R2
  Push $R3
  Push $R4
  Push $R5
  Push $R6
  Push $R7
  Push $R8

  StrCpy $R5 "0"
  StrCpy $R6 "0"
  StrCpy $R7 "0"
  StrCpy $R8 "0.0.0"
  StrCpy $0 0

  loop:

  ;Get each sub key under "SOFTWARE\Microsoft\NET Framework Setup\NDP"
  EnumRegKey $1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP" $0
  StrCmp $1 "" done ;jump to end if no more registry keys
  IntOp $0 $0 + 1
  StrCpy $2 $1 1 ;Cut off the first character
  StrCpy $3 $1 "" 1 ;Remainder of string

  ;Loop if first character is not a 'v'
  StrCmpS $2 "v" start_parse loop

  ;Parse the string
  start_parse:
  StrCpy $R1 ""
  StrCpy $R2 ""
  StrCpy $R3 ""
  StrCpy $R4 $3

  StrCpy $4 1

  parse:
  StrCmp $3 "" parse_done ;If string is empty, we are finished
  StrCpy $2 $3 1 ;Cut off the first character
  StrCpy $3 $3 "" 1 ;Remainder of string
  StrCmp $2 "." is_dot not_dot ;Move to next part if it's a dot

  is_dot:
  IntOp $4 $4 + 1 ; Move to the next section
  goto parse ;Carry on parsing

  not_dot:
  IntCmp $4 1 major_ver
  IntCmp $4 2 minor_ver
  IntCmp $4 3 build_ver
  IntCmp $4 4 parse_done

  major_ver:
  StrCpy $R1 $R1$2
  goto parse ;Carry on parsing

  minor_ver:
  StrCpy $R2 $R2$2
  goto parse ;Carry on parsing

  build_ver:
  StrCpy $R3 $R3$2
  goto parse ;Carry on parsing

  parse_done:

  IntCmp $R1 $R5 this_major_same loop this_major_more
  this_major_more:
  StrCpy $R5 $R1
  StrCpy $R6 $R2
  StrCpy $R7 $R3
  StrCpy $R8 $R4

  goto loop

  this_major_same:
  IntCmp $R2 $R6 this_minor_same loop this_minor_more
  this_minor_more:
  StrCpy $R6 $R2
  StrCpy $R7 R3
  StrCpy $R8 $R4
  goto loop

  this_minor_same:
  IntCmp $R3 $R7 loop loop this_build_more
  this_build_more:
  StrCpy $R7 $R3
  StrCpy $R8 $R4
  goto loop

  done:

  ;Have we got the framework we need?
  IntCmp $R5 ${MIN_FRA_MAJOR} max_major_same fail OK
  max_major_same:
  IntCmp $R6 ${MIN_FRA_MINOR} max_minor_same fail OK
  max_minor_same:
  IntCmp $R7 ${MIN_FRA_BUILD} OK fail OK

  ;Version on machine is greater than what we need
  OK:
  StrCpy $0 "1"
  goto end

  fail:
  StrCmp $R8 "0.0.0" end


  end:

  ;Pop the variables we pushed earlier
  Pop $R8
  Pop $R7
  Pop $R6
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Pop $4
  Pop $3
  Pop $2
  Pop $1
FunctionEnd