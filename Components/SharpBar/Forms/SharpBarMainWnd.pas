{
Source Name: SharpBarMainWnd.pas
Description: SharpBar Main Form 
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit SharpBarMainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms,
  Dialogs, SharpESkinManager, Menus, StdCtrls, JvSimpleXML, SharpApi,
  GR32, uSharpEModuleManager, DateUtils, PngImageList, SharpEBar, Jpeg, SharpThemeApi,
  SharpEBaseControls, ImgList, Controls, ExtCtrls, uSkinManagerThreads,
  uSystemFuncs, Types, AppEvnts, uSharpEColorBox, SharpESkin;

type
  TSharpBarMainForm = class(TForm)
    PopupMenu1: TPopupMenu;
    Position1: TMenuItem;
    AutoPos1: TMenuItem;
    Bottom1: TMenuItem;
    N1: TMenuItem;
    Left1: TMenuItem;
    Right2: TMenuItem;
    Middle1: TMenuItem;
    N2: TMenuItem;
    Monitor1: TMenuItem;
    N3: TMenuItem;
    ExitMn: TMenuItem;
    FullScreen1: TMenuItem;
    N4: TMenuItem;
    PluginManager1: TMenuItem;
    PngImageList1: TPngImageList;
    Settings1: TMenuItem;
    AutoStart1: TMenuItem;
    ThrobberPopUp: TPopupMenu;
    Information1: TMenuItem;
    N5: TMenuItem;
    Delete1: TMenuItem;
    Move1: TMenuItem;
    Left2: TMenuItem;
    Right1: TMenuItem;
    CreateNewBar1: TMenuItem;
    OutofallRightModules1: TMenuItem;
    AllModulestotheLeft1: TMenuItem;
    Settings: TMenuItem;
    DisableBarHiding1: TMenuItem;
    BarManagment1: TMenuItem;
    CreateemptySharpBar1: TMenuItem;
    DelayTimer1: TTimer;
    DelayTimer2: TTimer;
    DelayTimer3: TTimer;
    Clone1: TMenuItem;
    QuickAddModule1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    N6: TMenuItem;
    Skin1: TMenuItem;
    ColorScheme1: TMenuItem;
    ConfigureDesktopArea1: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ConfigureDesktopArea1Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure Clone1Click(Sender: TObject);
    procedure DelayTimer3Timer(Sender: TObject);
    procedure DelayTimer2Timer(Sender: TObject);
    procedure DelayTimer1Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CreateemptySharpBar1Click(Sender: TObject);
    procedure SkinManager1SkinChanged(Sender: TObject);
    procedure DisableBarHiding1Click(Sender: TObject);
    procedure Right1Click(Sender: TObject);
    procedure Left2Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure SettingsClick(Sender: TObject);
    procedure Information1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SharpEBar1ThrobberMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SharpEBar1ThrobberMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SharpEBar1ThrobberMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure AutoStart1Click(Sender: TObject);
    procedure PluginManager1Click(Sender: TObject);
    procedure SharpEBar1ResetSize(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure ExitMnClick(Sender: TObject);
    procedure Right2Click(Sender: TObject);
    procedure Middle1Click(Sender: TObject);
    procedure Left1Click(Sender: TObject);
    procedure Bottom1Click(Sender: TObject);
    procedure AutoPos1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnMonitorPopupItemClick(Sender : TObject);
    procedure OnQuickAddModuleItemClick(Sender : TObject);
    procedure OnSkinSelectItemClick(Sender : TObject);
    procedure OnSchemeSelectItemClick(Sender : TObject);
    procedure OnSchemeCreateClick(Sender : TObject);
  private
    { Private-Deklarationen }
    FUser32DllHandle : THandle;
    PrintWindow : function (SourceWindow: hwnd; Destination: hdc; nFlags: cardinal): bool; stdcall;
    FSuspended : boolean;
    FBarID : integer;
    FShellHookList : TStringList;
    FStartup : Boolean;
    FBarLock : Boolean;
    FTopZone : TBitmap32;
    FBottomZone : TBitmap32;
    FBGImage : TBitmap32;
    FShellBCInProgress : boolean;
    FSkinManager : TSharpESkinManager;
    FSharpEBar : TSharpEBar;
    SkinManagerLoadThread : TSystemSkinLoadThread;

    FDeskAreaStart : function (owner : hwnd) : hwnd;
    FDeskAreaEnd : function (owner : hwnd; SaveSettings : Boolean) : boolean;

    procedure CreateNewBar;
    procedure LoadBarModules(XMLElem : TJvSimpleXMlElem);

    procedure WMThemeLoadingEnd(var msg : TMessage); message WM_APP + 536;

    // Plugin message (to be broadcastet to modules)
    procedure WMWeatherUpdate(var msg : TMessage); message WM_WEATHERUPDATE;

    // Power Management
    procedure WMPowerBroadcast(var msg : TMessage); message WM_POWERBROADCAST;

    // Shutdown
    procedure WMEndSession(var msg : TMessage); message WM_ENDSESSION;
    procedure WMQueryEndSession(var msg : TMessage); message WM_QUERYENDSESSION;

    // shell hooks
    procedure WMRegisterShellHook(var msg : TMessage); message WM_REGISTERSHELLHOOK;
    procedure WMUnregisterShellHook(var msg : TMessage); message WM_UNREGISTERSHELLHOOK;
//    procedure WMShellHook(var msg : TMessage); message WM_SHELLHOOK;

    // SharpE Actions
    procedure WMUpdateBangs(var Msg : TMessage); message WM_SHARPEUPDATEACTIONS;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;

    //Modules (uSharpBarAPI.pas)
    procedure WMLockBarWindow(var msg : TMessage); message WM_LOCKBARWINDOW;
    procedure WMUnlockBarWindow(var msg : TMessage); message WM_UNLOCKBARWINDOW;

    procedure WMGetFreeBarSpace(var msg : TMessage); message WM_GETFREEBARSPACE;
    procedure WMSaveXMLFile(var msg : TMessage); message WM_SAVEXMLFILE;
    procedure WMGetXMLHandle(var msg : TMessage); message WM_GETXMLHANDLE;
    procedure WMGetBGHandle(var msg : TMessage); message WM_GETBACKGROUNDHANDLE;
    procedure WMGetBarHeight(var msg : TMessage); message WM_GETBARHEIGHT;

    procedure WMSharpTerminate(var msg : TMessage); message WM_SHARPTERMINATE;
    procedure WMDisplayChange(var msg : TMessage); message WM_DISPLAYCHANGE;
    procedure WMUpdateBarWidth(var msg : TMessage); message WM_UPDATEBARWIDTH;
    procedure WMGetCopyData(var msg: TMessage); message WM_COPYDATA;
    procedure WMUpdateSettings(var msg : TMessage); message WM_SHARPEUPDATESETTINGS;

    procedure OnBarPositionUpdate(Sender : TObject);
  public
    procedure LoadBarFromID(ID : integer);
    procedure LoadModuleSettings;
    procedure SaveBarSettings;
    procedure UpdateBGZone;
    procedure UpdateBGImage;
    property BGImage : TBitmap32 read FBGImage;
    property SkinManager : TSharpESkinManager read FSkinManager;
    property SharpEBar : TSharpEBar read FSharpEBar;
    property ShellBCInProgress : boolean read FShellBCInProgress;
  end;

const
  Debug = True;
  DebugLevel = 3;

var
  SharpBarMainForm: TSharpBarMainForm;
  mfParamID : integer;
  ModuleManager : TModuleManager;
  ModuleSettings : TJvSimpleXML;
  BarMove : boolean;
  BarMovePoint : TPoint;
  WM_SHELLHOOK : integer;
  Closing : boolean;

procedure LockWindow(const Handle: HWND);
procedure UnLockWindow(const Handle: HWND);
function RegisterShellHook(wnd : hwnd; param : dword) : boolean; stdcall; external 'shell32.dll' index 181;

implementation

uses CoreConfigDummyWnd,
     PluginManagerWnd,
     SharpEMiniThrobber,
     BarHideWnd,
     AddPluginWnd,
     EditSchemeWnd;

{$R *.dfm}


function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

procedure DebugOutput(Msg : String; Level,msgtype : integer);
begin
  if (Debug) and (Level<=DebugLevel) then SharpAPI.SendDebugMessageEx('SharpBar',PChar(Msg),clBlack,msgtype);
end;

procedure dllcallback(handle : hwnd);
begin
end;

function GetCurrentTime : Int64;
var
  h,m,s,ms : word;
begin
  DecodeTime(now,h,m,s,ms);
  result := h*60*60*1000 + m*60*1000 + s*1000 + ms;
end;


procedure LockWindow(const Handle: HWND);
begin
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
end;

procedure UnlockWindow(const Handle: HWND);
begin
  if SharpBarMainForm.ShellBCInProgress then exit;

  SendMessage(Handle, WM_SETREDRAW, 1, 0);
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

// ************************
// Window Message handlers
// ************************

procedure TSharpBarMainForm.WMEndSession(var msg : TMessage);
begin
  msg.result := 0;
  Close;
end;

procedure TSharpBarMainForm.WMQueryEndSession(var msg : TMessage);
begin
  msg.Result := 1;
  Close;
end;

// Temporary! remove when SharpCenter is done!
procedure TSharpBarMainForm.WMThemeLoadingEnd(var msg : TMessage);
begin
 if FSuspended then exit;

  if not FStartup then LockWindow(Handle);
  FBarLock := True;

  UpdateBGZone;

  SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);
  SkinManager.UpdateScheme;
  SkinManager.UpdateSkin;
  SharpEBar.Throbber.UpdateSkin;
  SharpEbar.Throbber.Repaint;

  ModuleManager.BroadcastPluginUpdate(SU_SKINFILECHANGED);
  ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);

  ModuleManager.FixModulePositions;

  FBarLock := False;
  if not FStartup then UnLockWindow(Handle);
end;

// SharpE Actions
procedure TSharpBarMainForm.WMUpdateBangs(var Msg : TMessage);
begin
   ModuleManager.BroadcastPluginMessage('MM_SHARPEUPDATEACTIONS');

   SharpApi.RegisterActionEx(PChar('!FocusBar ('+inttostr(FBarID)+')'),'SharpBar',Handle,1);
end;

procedure TSharpBarMainForm.WMSharpEBang(var Msg : TMessage);
begin
  case msg.LParam of
    1: ForceForeGroundWindow(Handle);
  end;
end;

// SharpE Terminate Message support
procedure TSharpBarMainForm.WMSharpTerminate(var msg : TMessage);
begin
  Close;
end;

// Weather Service updated the xml files -> broadcast as message to all modules
procedure TSharpBarMainForm.WMWeatherUpdate(var msg : TMessage);
begin
  ModuleManager.BroadcastPluginMessage('MM_WEATHERUPDATE');
end;

// Computer is entering or leaving suspended state (Laptop,...)
procedure TSharpBarMainForm.WMPowerBroadcast(var msg : TMessage);
begin
  case msg.WParam of
    PBT_APMSUSPEND: FSuspended := True;
    PBT_APMRESUMESUSPEND: FSuspended := False;
  end;
  msg.Result := 1;
end;

// Module is requesting to lock the whole bar window
procedure TSharpBarMainForm.WMLockBarWindow(var msg : TMessage);
begin
  if FStartup then exit;
  if FBarLock then exit;

  LockWindow(Handle);
end;

// Module is requesting the bar window to be unlocked
procedure TSharpBarMainForm.WMUnlockBarWindow(var msg : TMessage);
begin
  if FStartup then exit;
  if FBarLock then exit;
  if FShellBCInProgress then exit;

  UnLockWindow(Handle);
  SendMessage(SharpEBar.abackground.handle, WM_SETREDRAW, 1, 0);
  RedrawWindow(SharpEBar.abackground.handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

// Shell hook received (task list,...) -> forward to all registered shell modules
{procedure TSharpBarMainForm.WMShellHook(var msg : TMessage);
var
  n : integer;
begin
  // bar received a shell hook, forward it to all registered modules

  try
    for n := 0 to FShellHookList.Count - 1 do
    begin
      if (n = 0) and (n <> FShellHookList.Count - 1) then FShellBCInProgress := True
         else if n = FShellHookList.Count -1 then FShellBCInProgress := False;
      PostMessage(strtoint(FShellHookList[n]),WM_ShellHook,msg.WParam,msg.LParam);
    end;
  except
  end;
end;        }

// A module is requesting to be notified on shell messages (task list,...)
procedure TSharpBarMainForm.WMRegisterShellHook(var msg : TMessage);
var
  n : integer;
  Module : TModule;
  mm: MINIMIZEDMETRICS;
begin
  for n := 0 to ModuleManager.Modules.Count - 1 do
  begin
    Module := TModule(ModuleManager.Modules.Items[n]);
    if Module.ID = msg.WParam then
       FShellHookList.Add(inttostr(Module.Handle));
  end;

  if FShellHookList.Count = 1 then
  begin
    FillChar(mm, SizeOf(MINIMIZEDMETRICS), 0);

    mm.cbSize := SizeOf(MINIMIZEDMETRICS);
    SystemParametersInfo(SPI_GETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

    mm.iArrange := mm.iArrange or ARW_HIDE;
    SystemParametersInfo(SPI_SETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

    // first module requestion a shell hook -> register the global hook
    RegisterShellHook(0,1);
    RegisterShellHook(Handle,3);
//    SHSetMainHandle(self.handle);
//    SHSetCallBack(@dllcallback);
//    SHSetHook;
  end;
end;

// A Module which was registered to receive shell messages unregisters itself
procedure TSharpBarMainForm.WMUnregisterShellHook(var msg : TMessage);
begin
  FShellHookList.Delete(FShellHookList.IndexOf(inttostr(msg.WParam)));

  if FShellHookList.Count = 0 then
  begin
    RegisterShellHook(Handle,0);
//    SHUnsetHook;
  end;
end;


// A Module is requesting how much free bar space is left
procedure TSharpBarMainForm.WMGetFreeBarSpace(var msg : TMessage);
begin
  msg.Result := ModuleManager.GetFreeBarSpace;
end;

// Display resolution changed
procedure TSharpBarMainForm.WMDisplayChange(var msg : TMessage);
begin
  if FSuspended then exit;
  DelayTimer3.Enabled := True;
end;

procedure TSharpBarMainForm.WMUpdateSettings(var msg : TMessage);
begin
  if FSuspended then exit;

  if msg.WParam < 0 then exit;

  if not FStartup then LockWindow(Handle);
  FBarLock := True;

  // Step1: Update settings and prepate modules for updating
  case msg.WParam of
    SU_SKIN : SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);
    SU_THEME : SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme,tpIconSet]);
    SU_SCHEME :
      begin
        SharpThemeApi.LoadTheme(True,[tpScheme]);
        SkinManager.UpdateScheme;
      end;
    SU_ICONSET : SharpThemeApi.LoadTheme(True,[tpIconSet]);
  end;

  if (msg.WParam = SU_THEME) or (msg.WParam = SU_SCHEME)
     or (msg.WParam = SU_SKINFILECHANGED)  then
     begin
       SkinManager.UpdateScheme;
       SkinManager.UpdateSkin;
       SharpEBar.UpdateSkin;
       SharpEBar.Throbber.UpdateSkin;
       SharpEbar.Throbber.Repaint;
       UpdateBGZone;
//       ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);
     end;

  // Step2: Update modules
  ModuleManager.BroadcastPluginUpdate(msg.WParam);

  // Step3: Modules updated, now update the bar
  if (msg.WParam = SU_SKINFILECHANGED) then
     ModuleManager.FixModulePositions;

  FBarLock := False;
  if not FStartup then UnLockWindow(Handle);
end;

// Module is requesting that the settings are saved to file
procedure TSharpBarMainForm.WMSaveXMLFile(var msg : TMessage);
begin
  if FSuspended then exit;
  ModuleSettings.SaveToFile(ModuleSettings.FileName + '~');
  if FileExists(ModuleSettings.FileName) then
     DeleteFile(ModuleSettings.FileName);
  RenameFile(ModuleSettings.FileName + '~',ModuleSettings.FileName);
end;

// Module is requesting the handle to the xml settings class
procedure TSharpBarMainForm.WMGetXMLHandle(var msg : TMessage);
begin
  msg.Result := integer(@ModuleSettings);
end;

// Module is requesting the handle to the Background image
procedure TSharpBarMainForm.WMGetBGHandle(var msg : TMessage);
begin
  msg.result := integer(@FBGImage);
end;

// Module is requesting the height of the Bar
procedure TSharpBarMainForm.WMGetBarHeight(var msg : TMessage);
begin
  try
    msg.Result := strtoint(SkinManager.Skin.BarSkin.SkinDim.Height) -
                  strtoint(SkinManager.Skin.BarSkin.PAYoffset.X) -
                  strtoint(SkinManager.Skin.BarSkin.PAYoffset.Y);
  except
    msg.Result := 30;
  end;
end;


// Plugin message received... foward to requested module
procedure TSharpBarMainForm.WMGetCopyData(var msg: TMessage);
var
  pParams: string;
  pID    : integer;
  msgdata: TMsgData;
begin
  DebugOutput('WM_CopyData',2,1);
  // Extract the Message Data
  msgdata := pMsgData(PCopyDataStruct(msg.lParam)^.lpData)^;
  try
    pID := strtoint(lowercase(msgdata.Command));
  except
    exit;
  end;
  pParams := msgdata.Parameters;

  ModuleManager.SendPluginMessage(pID,pParams);
end;

// Module is requesting update of bar width
procedure TSharpBarMainForm.WMUpdateBarWidth(var msg : TMessage);
begin
  if FSuspended then exit;

  DebugOutput('WM_UpdateBarWidth',2,1);
  if not FStartup then LockWindow(Handle);
  try
    ModuleManager.ReCalculateModuleSize;
  finally
    if not FStartup then UnLockwindow(Handle);
  end;
end;

// ***********************

procedure TSharpBarMainForm.UpdateBGImage;
begin
  if FSuspended then exit;
  if FBGImage = nil then exit;
  if (Width = 0) or (Height = 0) then exit;

  FBGImage.SetSize(Width,Height);
  FBGImage.Clear(color32(0,0,0,0));
  if SharpEBar.VertPos = vpTop then FBGImage.Draw(0,0,Rect(Left-Monitor.Left,0,Left-Monitor.Left+FTopZone.Width,FTopZone.Height),FTopZone)
     else FBGImage.Draw(0,0,Rect(Left-Monitor.Left,0,Left-Monitor.Left+FBottomZone.Width,FBottomZone.Height),FBottomZone);
  SharpEbar.Skin.DrawTo(FBGImage);
end;

procedure TSharpBarMainForm.UpdateBGZone;
var
  BGBmp : TBitmap32;
  wnd : hwnd;
begin
  if FSuspended then exit;
  if (FTopZone = nil) or (FBottomZone = nil) then exit;

  BGBmp := TBitmap32.Create;
  BGBmp.SetSize(Screen.Width,Screen.Height);
  BGBmp.Clear(color32(0,0,0,255));
  try
    wnd := FindWindow('TSharpDeskMainForm',nil);
    if wnd <> 0 then
    begin
      // try 3 times... :)
      if @PrintWindow <> nil then
      begin
        if not PrintWindow(wnd,BGBmp.Handle,0) then
           if not PrintWindow(wnd,BGBmp.Handle,0) then
              if not PrintWindow(wnd,BGBmp.Handle,0) then
              begin
                if FileExists(SharpApi.GetSharpeDirectory + 'SharpDeskbg.jpg') then
                   BGBmp.LoadFromFile(SharpApi.GetSharpeDirectory + 'SharpDeskbg.jpg');
              end;
      end else
      begin
        if FileExists(SharpApi.GetSharpeDirectory + 'SharpDeskbg.jpg') then
        BGBmp.LoadFromFile(SharpApi.GetSharpeDirectory + 'SharpDeskbg.jpg');
      end;
    end else PaintDesktop(BGBmp.Handle);
    FTopZone.SetSize(Monitor.Width,Height);
    FBottomZone.SetSize(Monitor.Width,Height);
    FTopZone.Draw(0,0,Rect(Monitor.Left,Monitor.Top,Monitor.Left + Monitor.Width,Monitor.Top + Height), BGBmp);
    FBottomZone.Draw(0,0,Rect(Monitor.Left,Monitor.Top + Monitor.Height - Height,Monitor.Left + Monitor.Width,Monitor.Top + Monitor.Height), BGBmp);
  except
  end;
  BGBmp.Free;
  UpdateBGImage;
end;


procedure TSharpBarMainForm.LoadModuleSettings;
// Load the module settings file for this bar
// User\{}\SharpBar\Module Settings\BarID.xml
var
  Dir : String;
  i : integer;
begin
  DebugOutput('Loading Module Settings',1,1);
  if FBarID <= 0 then
  begin
    DebugOutput('No Valid Bar ID given. Aborting module settings loading!',1,3);
    // Not initalized... No valid Bar ID!
    exit;
  end;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Module Settings\';
  // Check if Bar Module settings file already exists - if not create a new file
  if (not FileExists(Dir + inttostr(FBarID)+'.xml')) then
  begin
    ModuleSettings.Root.Clear;
    ModuleSettings.Root.Name := 'SharpBarModules';
    ForceDirectories(Dir);
    ModuleSettings.SaveToFile(Dir + inttostr(FBarID)+'.xml');
    // Set FileName property and load file!
    ModuleSettings.FileName := Dir + inttostr(FBarID)+'.xml';
  end;

  begin
    try
      DebugOutput('Loading file '+Dir + inttostr(FBarID)+'.xml',2,1);
      // Set FileName property and load file!
      ModuleSettings.FileName := Dir + inttostr(FBarID)+'.xml';
    except
      DebugOutput('Error while loading or parsing the xml file',1,3);
      // error while loading or parsing the xml file
      // create backup and reset file
      i := DateTimeToUnix(now());
      if CopyFile(PChar(Dir + inttostr(FBarID)+'.xml'),PChar(Dir + inttostr(FBarID)+'.xml#Backup#'+inttostr(i)),True) = null then
      begin
        ShowMessage('Error Loading the Module Settings for Bar ID [' + inttostr(FBarID) + ']!' + #10#13 +
                    'Creating a Backup failed...');
      end else
      begin
        ShowMessage('Error Loading the Module Settings for Bar ID [' + inttostr(FBarID) + ']!' + #10#13 +
                    'Backup Created to: '+ #10#13 +
                    Dir + inttostr(FBarID)+'.xml#Backup#'+inttostr(i));
      end;
      ModuleSettings.Root.Clear;
      ModuleSettings.Root.Name := 'SharpBarModules';
      ForceDirectories(Dir);
      ModuleSettings.SaveToFile(Dir + inttostr(FBarID)+'.xml');
    end;
  end;
  ModuleManager.ReCalculateModuleSize;
end;

procedure TSharpBarMainForm.LoadBarModules(XMLElem : TJvSimpleXMlElem);
var
  n : integer;
begin
  if XMlElem = nil then exit;
  DebugOutput('Loading Bar Modules',1,1);

  LoadModuleSettings;
  ModuleManager.UnloadModules;
  if XMLElem.Items.ItemNamed['Modules'] <> nil then
     with XMlElem.Items.ItemNamed['Modules'] do
     begin
       for n := 0 to Items.Count-1 do
       begin
         DebugOutput('Loading: '+Items.Item[n].Items.Value('Module','')
                     +' ID:'+Items.Item[n].Items.Value('ID','-1')
                     +' Position:' +Items.Item[n].Items.Value('Position','-1'),2,1);
         ModuleManager.LoadModule(Items.Item[n].Items.IntValue('ID',-1),
                                  Items.Item[n].Items.Value('Module',''),
                                  Items.Item[n].Items.IntValue('Position',-1),
                                  -1);
       end;
     end;
  ModuleManager.ReCalculateModuleSize;
end;

procedure TSharpBarMainForm.SaveBarSettings;
var
  xml : TJvSimpleXML;
  Dir : String;
  n,i   : integer;
  tempModule : TModule;
begin
  DebugOutput('Saving Bar Settings',1,1);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  xml := TJvSimpleXMl.Create(nil);
  try
    xml.LoadFromFile(Dir + 'bars.xml');
    with xml.root.items.ItemNamed['bars'] do
    begin
      for n := 0 to Items.Count - 1 do
          if Items.Item[n].Items.IntValue('ID',0) = FBarID then
          begin
            // Save the Bar Settings
            Items.Item[n].Items.ItemNamed['Settings'].Items.Clear;
            with Items.Item[n].Items.ItemNamed['Settings'] do
            begin
              Items.Add('AutoPosition',SharpEBar.AutoPosition);
              Items.Add('PrimaryMonitor',SharpEBar.PrimaryMonitor);
              Items.Add('MonitorIndex',SharpEBar.MonitorIndex);
              Items.Add('HorizPos',HorizPosToInt(SharpEBar.HorizPos));
              Items.Add('VertPos',VertPosToInt(SharpEbar.VertPos));
              Items.Add('AutoStart',SharpEbar.AutoStart);
              Items.Add('ShowThrobber',SharpEBar.ShowThrobber);
              Items.Add('DisableHideBar',SharpEBar.DisableHideBar);
            end;
            // Save the Module List
            Items.Item[n].Items.ItemNamed['Modules'].Items.Clear;
            with Items.Item[n].Items.ItemNamed['Modules'] do
            begin
              for i := 0 to ModuleManager.Modules.Count -1 do
              begin
                tempModule := TModule(ModuleManager.Modules.Items[i]);
                with Items.Add('Item') do
                begin
                  Items.Add('ID',tempModule.ID);
                  Items.Add('Position',tempModule.Position);
                  Items.Add('Module',ExtractFileName(tempModule.ModuleFile.FileName));
                end;
              end;
            end;
          end;
    end;
  except
    DebugOutput('Error while saving bar settings',1,3);
    xml.free;
    showmessage('Error while saving bar settings');
    exit;
  end;
  ForceDirectories(Dir);
  xml.SaveToFile(Dir + 'bars.xml~');
  if FileExists(Dir + 'bars.xml') then
     DeleteFile(Dir + 'bars.xml');
  RenameFile(Dir + 'bars.xml~',Dir + 'bars.xml');
  xml.Free;
end;

procedure TSharpBarMainForm.CreateNewBar;
var
  xml : TJvSimpleXML;
  Dir : String;
  n   : integer;
  NewID : String;
  b   : boolean;
begin
  DebugOutput('Creating New Bar',1,1);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  xml := TJvSimpleXMl.Create(nil);

  // Check if SharpBar settings file already exists - if not create a new file
  if (not FileExists(Dir + 'bars.xml')) then
  begin
    ForceDirectories(Dir);
    xml.Root.Name := 'SharpEBarSettings';
    xml.Root.Items.Add('bars');
    ForceDirectories(Dir);
    xml.SaveToFile(Dir + 'bars.xml');
  end;
  try
    xml.LoadFromFile(Dir + 'bars.xml');

    // Generate a new unique bar ID and make sure that there is no other
    // bar with the same ID 
    repeat
      NewID := '';
      for n := 1 to 8 do NewID := NewID + inttostr(random(9)+1);

      b := False;
      with xml.root.items.ItemNamed['bars'] do
      begin
        for n := 0 to Items.Count - 1 do
            if Items.Item[n].Items.Value('ID','0') = NewID then
            begin
              b := True;
              break;
            end;
      end;
    until not b;
    FBarID := strtoint(NewID);

    with xml.Root.Items.ItemNamed['bars'].Items.Add('Item') do
    begin
      Items.Add('ID',NewID);
      Items.Add('Settings');
      Items.Add('Modules');
    end;
  except
    // PANIC : something went wrong!!!!!
    // we now might have a bar without any place to store the settings
    // not good!
    // can't think of anything good what to do now... 
    // let's just give an error and terminate the app =)
    DebugOutput('FATAL ERROR: Unable to register new bar settings!',1,3);
    xml.Free;
    ShowMessage('Unable to register the new bar settings.' + #10#13 +
                'This Bar is going to be closed!');
    Application.Terminate;
    exit;
  end;
  ForceDirectories(Dir);
  xml.SaveToFile(Dir + 'bars.xml');
  xml.Free;
  // New bar is now loaded!
  // Set window caption to SharpBar_ID
  self.Caption := 'SharpBar_' + inttostr(FBarID);

  UpdateBGZone;
  LoadModuleSettings;
end;

procedure TSharpBarMainForm.LoadBarFromID(ID : integer);
var
  xml : TJvSimpleXML;
  Dir : String;
  i,n   : integer;
  handle : THandle;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';

  FBarID := -1;

  // Check if the settings file exists!
  if (not FileExists(Dir + 'bars.xml')) or (ID = -1) then
  begin
    // No settings file == fist launch, no other bars!
    // Create new bar!
    FBarID := -1;
    CreateNewBar;
    exit;
  end;

  // There is a settings file and we have a Bar ID,
  // So let's check if the bar with this ID is already running
  // Bar Window Title : SharpBar_ID
  handle := FindWindow(nil,PChar('SharpBar_'+inttostr(ID)));
  if handle <> 0 then
  begin
    // A bar with this ID is already running!
    // Terminate App - we don't want to have two instances of one bar.
    // (would have ID == -1 if it was supposed to be a new and empty bar)
    Application.Terminate;
    exit;
  end;

  // Find and load settings!
  i := -1;
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(Dir + 'bars.xml');
    with xml.root.items.ItemNamed['bars'] do
    begin
      for n := 0 to Items.Count - 1 do
          if Items.Item[n].Items.IntValue('ID',0) = ID then
          with Items.Item[n].Items.ItemNamed['Settings'] do
          begin
            // This is the bar with the ID we want to load
            SharpEBar.AutoPosition   := Items.BoolValue('AutoPosition',True);
            SharpEBar.PrimaryMonitor := Items.BoolValue('PrimaryMonitor',True);
            SharpEBar.MonitorIndex   := Items.IntValue('MonitorIndex',0);
            SharpEBar.HorizPos       := IntToHorizPos(Items.IntValue('HorizPos',0));
            SharpEBar.VertPos        := IntToVertPos(Items.IntValue('VertPos',0));
            SharpEBar.AutoStart      := Items.BoolValue('AutoStart',True);
            SharpEBar.ShowThrobber   := Items.BoolValue('ShowThrobber',True);
            SharpEBar.DisableHideBar := Items.BoolValue('DisableHideBar',False);
            // Set Main Window Title to SharpBar_ID!
            // The bar with the given ID is now loaded =)
            FBarID := ID;
            self.Caption := 'SharpBar_' + inttostr(ID);
            i := n;
            break;
          end;
    end;
  except
    xml.free;
    FBarID := -1;
    CreateNewBar;
    exit;
  end;

  // ID given, but bar doesn't exist
  // create new bar
  if FBarID = -1 then
  begin
    CreateNewBar;
    exit;
  end;

  UpdateBGZone;
  try
    if i <> -1 then LoadBarModules(xml.root.items.ItemNamed['bars'].Items.Item[i]);
  except
  end;
  xml.free;
end;

procedure TSharpBarMainForm.FormCreate(Sender: TObject);
begin
  Closing := False;

  WM_SHELLHOOK := RegisterWindowMessage('SHELLHOOK');

  FUser32DllHandle := LoadLibrary('user32.dll');
  if FUser32DllHandle <> 0 then
     @PrintWindow := GetProcAddress(FUser32DllHandle, 'PrintWindow');

  FSuspended := False;
  FShellBCInProgress := False;

  FSkinManager := TSharpESkinManager.Create(self, [scBar,scMiniThrobber]);
  FSkinManager.HandleUpdates := False;

  FSharpEBar := TSharpEBar.CreateRuntime(self,SkinManager);
  FSharpEBar.AutoPosition := True;
  FSharpEBar.AutoStart := True;
  FSharpEBar.DisableHideBar := False;
  FSharpEBar.HorizPos := hpMiddle;
  FSharpEBar.MonitorIndex := 0;
  FSharpEBar.PrimaryMonitor := True;
  FSharpEBar.ShowThrobber := True;
  FSharpEBar.VertPos := vpTop;
  FSharpEBar.onThrobberMouseDown := SharpEBar1ThrobberMouseDown;
  FSharpEBar.onThrobberMouseUp   := SharpEBar1ThrobberMouseUp;
  FSharpEBar.onThrobberMouseMove := SharpEBar1ThrobberMouseMove;
  FSharpEBar.onResetSize         := SharpEBar1ResetSize;

  SharpEBar.SkinManager := FSkinManager;
  
  // Load System Skin and Scheme in a Thread
  SkinManagerLoadThread := TSystemSkinLoadThread.Create(FSkinManager);

  FBottomZone := TBitmap32.Create;
  FTopZone    := TBitmap32.Create;
  FBGImage    := TBitmap32.Create;
  SharpEBar.Throbber.SpecialBackground := FBGImage;

  FStartup := True;
  FBarLock := False;

  FShellHookList := TStringList.Create;
  FShellHookList.Clear;

  DebugOutput('Creating Main Form',1,1);
  DebugOutput('Creating SkinManager',2,1);

  randomize;
  // Initialize module settings xml handler
  // The Pointer to this class will be given to the Module Manager
  // NEVER free the ModuleSettings var after this point!
  ModuleSettings := TJvSimpleXML.Create(nil);

  // Create and Initialize the module manager
  // (Make sure the Skin Manager and Module Settings are ready before doing this!)
  DebugOutput('Creating Module Manager',2,1);
  ModuleManager := TModuleManager.Create(self.Handle, SkinManager, SharpEBar, ModuleSettings);
  ModuleManager.ThrobberMenu := ThrobberPopUp;
  DebugOutput('Loading Modules from Directory: '+ExtractFileDir(Application.ExeName) + '\Modules\',2,1);
  ModuleManager.LoadFromDirectory(ExtractFileDir(Application.ExeName) + '\Modules\');

  // VWM Compatible | Taskhide | Alt+f4 lock
  DebugOutput('Setting Form properties',2,1);
  SetWindowLong(Handle, GWL_USERDATA, magicDWord);
  Setwindowlong(Application.handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  SetWindowPos(application.handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  ShowWindow(Application.Handle, SW_HIDE);

  KeyPreview := true;

  SharpEBar.onPositionUpdate := OnBarPositionUpdate;

  BarHideForm := TBarHideForm.Create(self);

  // Wait for the Skin Loading Thread to be finished
  SkinManagerLoadThread.WaitFor;
  SkinManagerLoadThread.Free;

  FSkinManager.onSkinChanged := SkinManager1SkinChanged;
  SharpEBar.UpdateSkin;
  SharpEBar.Throbber.UpdateSkin;

  DelayTimer2.Enabled := True;

  // Initialize the bar content
  // ID > 0 try load from xml
  // ID = -1 new bar
  if mfParamID <> -255 then
  begin
    SharpBarMainForm.LoadBarFromID(mfParamID);
    mfParamID := -255;
  end;

  UpdateBGZone;

  SharpApi.RegisterActionEx(PChar('!FocusBar ('+inttostr(FBarID)+')'),'SharpBar',Handle,1);
end;

procedure TSharpBarMainForm.AutoPos1Click(Sender: TObject);
begin
  SharpEBar.VertPos := vpTop;
  SharpEBar.UpdateSkin;
  ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);
  ModuleManager.FixModulePositions;
  ModuleManager.RefreshMiniThrobbers;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Bottom1Click(Sender: TObject);
begin
  SharpEBar.VertPos := vpBottom;
  SharpEBar.UpdateSkin;
  ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Left1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpLeft;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Middle1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpMiddle;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Right2Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpRight;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.OnMonitorPopupItemClick(Sender : TObject);
var
  index : integer;
begin
  try
    index := strtoint(TMenuItem(Sender).Hint);
  except
    index := 0;
  end;
  if index > Screen.MonitorCount -1 then exit;
  if Screen.Monitors[index] = Screen.PrimaryMonitor then
     SharpEBar.PrimaryMonitor := True
     else
     begin
       SharpEbar.PrimaryMonitor := False;
       SharpEBar.MonitorIndex := index;
     end;
end;

procedure TSharpBarMainForm.ExitMnClick(Sender: TObject);
begin
  SaveBarSettings;
  Close;
end;

procedure TSharpBarMainForm.FullScreen1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpFull;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.OnQuickAddModuleItemClick(Sender : TObject);
var
  i : integer;
begin
  if not (Sender is TMenuItem) then exit;
  i := TMenuItem(Sender).Tag;
  ModuleManager.CreateModule(i,-1);
  SaveBarSettings;
end;

procedure TSharpBarMainForm.PopupMenu1Popup(Sender: TObject);
var
  n : integer;
  item : TMenuItem;
  mfile : TModuleFile;
  s : String;
  sr : TSearchRec;
  Dir : String;
begin
  // Build Monitor List
  Monitor1.Clear;
  for n := 0 to Screen.MonitorCount - 1 do
  begin
    item := TMenuItem.Create(Monitor1);
    if Screen.Monitors[n] = Screen.PrimaryMonitor then
       item.Caption := inttostr(n) + ' (primary)'
       else item.Caption := inttostr(n);
    item.Hint := inttostr(n);
    item.ImageIndex := 14;
    item.OnClick := OnMonitorPopupItemClick;
    Monitor1.Add(item);
  end;

  // Build Module List
  QuickAddModule1.Clear;
  ModuleManager.RefreshFromDirectory(ModuleManager.ModuleDirectory);
  for n := 0 to ModuleManager.ModuleFiles.Count - 1 do
  begin
    mfile := TModuleFile(ModuleManager.ModuleFiles.Items[n]);
    item := TMenuItem.Create(Monitor1);
    s := ExtractFileName(mfile.FileName);
    setlength(s,length(s) - length(ExtractFileExt(s)));
    item.Caption := s;
    item.Tag := n;
    item.ImageIndex := 11;
    item.OnClick := OnQuickAddModuleItemClick;
    QuickAdDModule1.Add(item);
  end;

  AutoStart1.Checked := SharpEBar.AutoStart;
  DisableBarHiding1.Checked := SharpEBar.DisableHideBar;

  // Build Skin List
  Skin1.Clear;
  Dir := SharpApi.GetSharpeDirectory + 'Skins\';
  if FindFirst(Dir + '*.*',FADirectory,sr) = 0 then
  repeat
    if (CompareText(sr.Name,'.') <> 0) and (CompareText(sr.Name,'..') <> 0) then
    begin
      if FileExists(Dir + sr.Name + '\Skin.xml') then
      begin
        item := TMenuItem.Create(Skin1);
        item.ImageIndex := 28;
        if sr.Name = SharpThemeApi.GetSkinName then
           item.Caption := '(' + sr.Name + ')'
           else item.Caption := sr.Name;
        item.Hint := sr.Name;
        item.OnClick := OnSkinSelectItemClick;
        Skin1.Add(item);
      end;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);

  // Build Scheme List
  ColorScheme1.Clear;
  item := TMenuItem.Create(ColorScheme1);
  item.ImageIndex := 27;
  item.Caption := 'Create New Scheme';
  item.Hint := 'My Scheme';
  item.OnClick := OnSchemeCreateClick;
  ColorScheme1.Add(item);

  item := TMenuItem.Create(ColorScheme1);
  item.ImageIndex := 27;
  item.Caption := 'Edit Current Scheme';
  item.Hint := SharpThemeApi.GetSchemeName;
  item.OnClick := OnSchemeCreateClick;
  ColorScheme1.Add(item);

  item := TMenuItem.Create(ColorScheme1);
  item.ImageIndex := -1;
  item.Caption := '-';
  ColorScheme1.Add(item);

  Dir := SharpApi.GetSharpeDirectory + 'Skins\' + SharpThemeApi.GetSkinName + '\Schemes\';
  if FindFirst(Dir + '*.xml',FAAnyFile,sr) = 0 then
  repeat
    item := TMenuItem.Create(ColorScheme1);
    item.ImageIndex := 28;
    s := sr.Name;
    setlength(s,length(s) - length('.xml'));
    if s = SharpThemeApi.GetSchemeName then
       item.Caption := '(' + s + ')'
        else item.Caption := s;
    item.Hint := sr.Name;
    item.OnClick := OnSchemeSelectItemClick;
    ColorScheme1.Add(item);
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

procedure TSharpBarMainForm.OnSchemeCreateClick(Sender : TObject);
var
  EditSchemeForm: TEditSchemeForm;
  XML : TJvSimpleXML;
  Dir : String;
  n : integer;
  reload : boolean;
begin
  reload := False;

  EditSchemeForm := TEditSchemeForm.Create(self);
  try
    EditSchemeForm.InitForm('');
    EditSchemeForm.Caption := 'Create/Edit SharpE Color Scheme';
    EditSchemeForm.edit_name.Text := TMenuItem(Sender).Hint;
    if EditSchemeForm.ShowModal = mrOk then
    begin
      Dir := SharpThemeApi.GetSkinDirectory + 'Schemes\';
      XML := TJvSimpleXML.Create(nil);
      try
        XML.Root.Name := 'SharpESkinScheme';
        XML.Root.Clear;
        with XML.Root.Items.Add('Info').Items do
        begin
          Add('Name',EditSchemeForm.edit_name.Text);
          Add('Author','...');
        end;
        
        for n := 0 to SharpThemeApi.GetSchemeColorCount - 1 do
            with XML.Root.Items.Add('Item').Items do
            begin
              Add('Tag',TLabel(EditSchemeForm.ColorPanel.Components[2*n]).Hint);
              Add('Color',TSharpEColorBox(EditSchemeForm.ColorPanel.Components[2*n+1]).Color);
            end;
        XML.SaveToFile(Dir + EditSchemeForm.edit_name.Text + '.xml');
        if EditSchemeForm.edit_name.Text = SharpThemeApi.GetSchemeName then
           reload := True
           else reload := False;
      finally
        XML.Free;
      end;
    end;
  finally
    EditSchemeForm.Free;
  end;

  if reload then SharpApi.SharpEBroadCast(WM_SHARPEUPDATESETTINGS,SU_SKIN,0);
end;

procedure TSharpBarMainForm.OnSchemeSelectItemClick(Sender : TObject);
var
  XML : TJvSimpleXML;
  Dir : String;
  s : String;
begin
  Dir := SharpThemeApi.GetThemeDirectory;

  // Change Scheme
  XML := TJvSimpleXML.Create(nil);
  try
    XML.Root.Name := 'SharpEThemeScheme';
    XML.Root.Clear;
    s := TMenuItem(Sender).Hint;
    setlength(s,length(s) - length('.xml'));
    XML.Root.Items.Add('Scheme',s);
    XML.SaveToFile(Dir + 'Scheme.xml');
  finally
    XML.Free;
  end;
  SharpApi.SharpEBroadCast(WM_SHARPEUPDATESETTINGS,SU_SKIN,0);
end;

procedure TSharpBarMainForm.OnSkinSelectItemClick(Sender : TObject);
var
  XML : TJvSimpleXML;
  Dir,NewSkin,SkinDir : String;
  sr : TSearchRec;
  s : String;
begin
  XML := TJvSimpleXML.Create(nil);
  Dir := SharpThemeApi.GetThemeDirectory;
  NewSkin := TMenuItem(Sender).Hint;
  SkinDir := SharpApi.GetSharpeDirectory + 'Skins\' + NewSkin + '\';

  // Change Skin
  try
    XML.Root.Name := 'SharpEThemeSkin';
    XML.Root.Clear;
    XML.Root.Items.Add('Skin',NewSkin);
    XML.SaveToFile(Dir + 'Skin.xml');
  finally
    XML.Free;
  end;

  if FindFirst(SkinDir + 'Schemes\*.xml',FAAnyFile,sr) = 0 then
  begin
    XML := TJvSimpleXML.Create(nil);
    try
      XML.Root.Name := 'SharpEThemeScheme';
      XML.Root.Clear;
      s := sr.Name;
      setlength(s,length(s) - length('.xml'));
      XML.Root.Items.Add('Scheme',s);
      XML.SaveToFile(Dir + 'Scheme.xml');
    finally
      XML.Free;
    end;
  end;
  FindClose(sr);
  SharpApi.SharpEBroadCast(WM_SHARPEUPDATESETTINGS,SU_SKIN,0);
end;

procedure TSharpBarMainForm.SharpEBar1ResetSize(Sender: TObject);
begin
  if FSuspended then exit;
  ModuleManager.FixModulePositions;
end;

procedure TSharpBarMainForm.PluginManager1Click(Sender: TObject);
begin
  if PluginManagerForm = nil then PluginManagerForm := TPluginManagerForm.Create(self);
  PluginManagerForm.Showmodal;
end;

procedure TSharpBarMainForm.AutoStart1Click(Sender: TObject);
begin
  AutoStart1.Checked := not AutoStart1.Checked;
  SharpEBar.AutoStart := AutoStart1.Checked;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.FormShow(Sender: TObject);
begin
  if FSuspended then exit;
  if ModuleManager.Modules.Count = 0 then
     SharpEBar.ShowThrobber := True;
  SharpEBar.Throbber.Repaint;
  ShowWindow(application.Handle, SW_HIDE);
  if BarHideForm <> nil then BarHideForm.UpdateStatus;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  n : integer;
  P : TPoint;
  Mon : integer;
  R : TRect;
  oVP : TSharpEBarVertPos;
  oHP : TSharpEBarHorizPos;
  oMon : integer;
  oPMon : boolean;
begin
  if FSuspended then exit;

  if Shift = [ssLeft] then
  begin
    if not BarMove then
    begin
      // Make sure the mouse was moved more than a few pixels before starting the move bar code
      if (abs(BarMovePoint.X - X) > 64)
         or (abs(BarMovePoint.Y - Y) > 64) then
         BarMove := True
         else exit;
    end;
    if BarMove then
    begin
      oVP := SharpEBar.VertPos;
      oHP := SharpEBar.HorizPos;
      oMon := SharpEBar.MonitorIndex;
      oPMon := SharpEbar.PrimaryMonitor;
      for n := 0 to Screen.MonitorCount - 1 do
      begin
        if Screen.Monitors[n] = Screen.PrimaryMonitor then
           Mon := -1 else Mon := n;
        P := Mouse.CursorPos;

        // Special Movement Code if Full Align
        if SharpEBar.HorizPos = hpFull then
        begin
          // Top
          R.Left   := Screen.Monitors[n].Left;
          R.Right  := R.Left + Screen.Monitors[n].Width;
          R.Top    := Screen.Monitors[n].Top;
          R.Bottom := R.Top + 64;
          if PointInRect(P,R) then
          begin
            if Mon = -1 then SharpEBar.PrimaryMonitor := True
               else
               begin
                 SharpEBar.PrimaryMonitor := False;
                 SharpEBar.MonitorIndex := Mon;
               end;
          SharpEBar.HorizPos     := hpFull;
          SharpEBar.VertPos      := vpTop;
          end;

          // Bottom
          R.Top    := Screen.Monitors[n].Top + Screen.Monitors[n].Height - 64;
          R.Bottom := R.Top + 64;
          if PointInRect(P,R) then
          begin
            if Mon = -1 then SharpEBar.PrimaryMonitor := True
               else
               begin
                 SharpEBar.PrimaryMonitor := False;
                 SharpEBar.MonitorIndex := Mon;
               end;
          SharpEBar.HorizPos     := hpFull;
          SharpEBar.VertPos      := vpBottom;
          end;
          Continue;
        end;

        // Compact Movement Code
        // Top Left
        R.Left  := Screen.Monitors[n].Left;
        R.Top   := Screen.Monitors[n].Top;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar.PrimaryMonitor := True
             else
             begin
               SharpEBar.PrimaryMonitor := False;
               SharpEBar.MonitorIndex := Mon;
             end;
          SharpEBar.HorizPos     := hpLeft;
          SharpEBar.VertPos      := vpTop;
        end;

        // Top Middle
        R.Left  := Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - 128;
        R.Top   := Screen.Monitors[n].Top;
        R.Right := R.Left + 128;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar.PrimaryMonitor := True
             else
             begin
               SharpEBar.PrimaryMonitor := False;
               SharpEBar.MonitorIndex := Mon;
             end;
          SharpEBar.HorizPos     := hpMiddle;
          SharpEBar.VertPos      := vpTop;
        end;

        // Top Right
        R.Left  := Screen.Monitors[n].Left + Screen.Monitors[n].Width - 256;
        R.Top   := Screen.Monitors[n].Top;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar.PrimaryMonitor := True
             else
             begin
               SharpEBar.PrimaryMonitor := False;
               SharpEBar.MonitorIndex := Mon;
             end;
          SharpEBar.HorizPos     := hpRight;
          SharpEBar.VertPos      := vpTop;
        end;

        // Bottom Left
        R.Left  := Screen.Monitors[n].Left;
        R.Top   := Screen.Monitors[n].Top + Screen.Monitors[n].Height - 64;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar.PrimaryMonitor := True
             else
             begin
               SharpEBar.PrimaryMonitor := False;
               SharpEBar.MonitorIndex := Mon;
             end;
          SharpEBar.HorizPos     := hpLeft;
          SharpEBar.VertPos      := vpBottom;
        end;

        // Bottom Middle
        R.Left  := Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - 128;
        R.Top   := Screen.Monitors[n].Top + Screen.Monitors[n].Height - 64;
        R.Right := R.Left + 128;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar.PrimaryMonitor := True
             else
             begin
               SharpEBar.PrimaryMonitor := False;
               SharpEBar.MonitorIndex := Mon;
             end;
          SharpEBar.HorizPos     := hpMiddle;
          SharpEBar.VertPos      := vpBottom;
        end;

        // Bottom Right
        R.Left  := Screen.Monitors[n].Left + Screen.Monitors[n].Width - 256;
        R.Top   := Screen.Monitors[n].Top + Screen.Monitors[n].Height - 64;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P,R) then
        begin
          if Mon = -1 then SharpEBar.PrimaryMonitor := True
             else
             begin
               SharpEBar.PrimaryMonitor := False;
               SharpEBar.MonitorIndex := Mon;
             end;
          SharpEBar.HorizPos     := hpRight;
          SharpEBar.VertPos      := vpBottom;
        end;
      end;
      if (oMon <> SharpEBar.MonitorIndex) or (oPMon <> SharpEBar.PrimaryMonitor) then
      begin
        UpdateBGZone;
        ModuleManager.RefreshMiniThrobbers;
      end;
      if oVP <> SharpEBar.VertPos then
      begin
        UpdateBGImage;
        LockWindow(Handle);
        SharpEBar.UpdateSkin;
        ModuleManager.FixModulePositions;
        ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);
        ModuleManager.RefreshMiniThrobbers;
        UnLockWindow(Handle);
      end;
      if oHP <> SharpEBar.HorizPos then
      begin
        UpdateBGImage;
        LockWindow(Handle);
        ModuleManager.FixModulePositions;
        ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);
        ModuleManager.RefreshMiniThrobbers;
        UnLockWindow(Handle);
      end;
    end;
    if BarHideForm <> nil then BarHideForm.UpdateStatus;
  end;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (not BarMove) then PopUpMenu1.Popup(Left,Top);
  BarMove := False;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     BarMovePoint := Point(X,Y)
     else BarMove := False;
end;

procedure TSharpBarMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
     if (Y=Height-1) and (SharpEBar.VertPos = vpBottom)
        or (Y=0) and (SharpEBar.VertPos = vpTop) then
     begin
       if ModuleManager.Modules.Count = 0 then
       begin
         SharpEBar.ShowThrobber := True;
         exit;
       end;
       SharpEBar.ShowThrobber := not SharpEBar.ShowThrobber;
       LockWindow(Handle);
       ModuleManager.FixModulePositions;
       UnLockWindow(Handle);
       if SharpEBar.ShowThrobber then SharpEBar.Throbber.Repaint;
     end;
  if (Button = mbLeft) and (not SharpEBar.DisableHideBar) then
  begin
    //BarHideForm.Color := SkinManager.Scheme.Throbberback;
    if (Y=Height-1)  and (SharpEbar.VertPos = vpBottom) then
    begin
      BarHideForm.Left := Left;
      BarHideForm.Width := Width;
      BarHideForm.Height := 1;
      BarHideForm.Top := Top + Height -1;
      SharpBarMainForm.Hide;
      BarHideForm.Show;
    end
    else if (Y=0) and (SharpEBar.VertPos = vpTop) then
    begin
      BarHideForm.Left := Left;
      BarHideForm.Width := Width;
      BarHideForm.Height := 1;
      BarHideForm.Top := Top;
      SharpBarMainForm.Hide;
      BarHideForm.Show;
    end;
  end;
end;

procedure TSharpBarMainForm.Information1Click(Sender: TObject);
begin
  Showmessage('Someone should create a nice Informations Dialog!');
end;

procedure TSharpBarMainForm.SettingsClick(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then exit;
  if @tempModule.ModuleFile.DllShowSettingsWnd <> nil then
     tempModule.ModuleFile.DllShowSettingsWnd(tempModule.ID);
end;

procedure TSharpBarMainForm.Delete1Click(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
begin
  if FSuspended then exit;
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  if MessageBox(self.handle,'Do you really want to remove this module? All settings will be lost!','Confirm : "Remove Module"',MB_YESNO) = IDYES then
  begin
    LockWindow(Handle);
    ModuleManager.Delete(mThrobber.Tag);
    SaveBarSettings;
    ModuleManager.ReCalculateModuleSize;
    UnLockWindow(Handle);
  end;
end;

procedure TSharpBarMainForm.Left2Click(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
  ri : integer;
  index : integer;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then exit;
  ri := ModuleManager.GetFirstRModuleIndex;
  index := ModuleManager.Modules.IndexOf(tempModule);
  if (ri = index) and (SharpEbar.HorizPos <> hpFull) then
     ModuleManager.MoveModule(index,-1);
  ModuleManager.MoveModule(index,-1);
  ModuleManager.SortModulesByPosition;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Right1Click(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
  tempModule : TModule;
  ri,index : integer;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then exit;
  ri := ModuleManager.GetFirstRModuleIndex;
  index := ModuleManager.Modules.IndexOf(tempModule);
  if (ri = index+1) and (SharpEbar.HorizPos <> hpFull) then
     ModuleManager.MoveModule(index,1);
  ModuleManager.MoveModule(index,1);
  ModuleManager.SortModulesByPosition;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.DisableBarHiding1Click(Sender: TObject);
begin
  DisableBarHiding1.Checked := not DisableBarHiding1.Checked;
  SharpEBar.DisableHideBar := DisableBarHiding1.Checked;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.SkinManager1SkinChanged(Sender: TObject);
begin
  exit;
//  if FThemeUpdating then exit;
  if FSuspended then exit;
  if ModuleManager = nil then exit;

  SharpEBar.UpdateSkin;
  SharpEBar.Throbber.UpdateSkin;
  SharpEbar.Throbber.Repaint;
  UpdateBGImage;

  //ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
  ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);

 // if FThemeUpdating then exit;

  ModuleManager.RefreshMiniThrobbers;
end;

procedure TSharpBarMainForm.CreateemptySharpBar1Click(Sender: TObject);
begin
  SharpApi.SharpExecute('SharpBar.exe -load:-1');
end;

procedure TSharpBarMainForm.FormResize(Sender: TObject);
begin
  if FSuspended then exit;
  if BarHideForm <> nil then BarHideForm.UpdateStatus;
end;

procedure TSharpBarMainForm.FormHide(Sender: TObject);
begin
  if FSuspended then exit;
  if BarHideForm <> nil then BarHideForm.UpdateStatus;
end;

procedure TSharpBarMainForm.OnBarPositionUpdate(Sender : TObject);
begin
  if FSuspended then exit;
  if BarHideForm <> nil then BarHideForm.UpdateStatus;

  if Left < 0 then Left := 0;
  if Width > Monitor.Width then
     Width := Monitor.Width; 

  UpdateBGImage;
  ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);
end;

procedure TSharpBarMainForm.DelayTimer1Timer(Sender: TObject);
begin
  DelayTimer1.Enabled := False;
end;

procedure TSharpBarMainForm.DelayTimer2Timer(Sender: TObject);
begin
  DelayTimer2.Enabled := False;

  if (FStartup) or (not Visible) then
  begin
    FStartup := False;
    UnlockWindow(Handle);
    Show;
  end;
end;

procedure TSharpBarMainForm.DelayTimer3Timer(Sender: TObject);
begin
  DelayTimer3.Enabled := False;
  if FSuspended then exit;

  if BarHideForm.Visible then
  begin
    if SharpEBar.SpecialHideForm then BarHideForm.UpdateStatus
       else BarHideForm.Close;
  end;
  SharpEBar.UpdatePosition;
  ModuleManager.BroadCastModuleRefresh;
  ModuleManager.FixModulePositions;
end;

procedure TSharpBarMainForm.Clone1Click(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  ModuleManager.Clone(mThrobber.Tag);
  SaveBarSettings;
  ModuleManager.ReCalculateModuleSize;
end;

procedure TSharpBarMainForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  n : integer;
begin
  if msg.message = WM_SHELLHOOK then
  begin
   // bar received a shell hook, forward it to all registered modules
    try
      for n := 0 to FShellHookList.Count - 1 do
      begin
        if (n = 0) and (n <> FShellHookList.Count - 1) then FShellBCInProgress := True
           else if n = FShellHookList.Count -1 then FShellBCInProgress := False;
        PostMessage(strtoint(FShellHookList[n]),WM_SHARPSHELLMESSAGE,msg.WParam,msg.LParam);
      end;
    except
    end;
   Handled := True;
  end else Handled := False;
end;

procedure TSharpBarMainForm.ConfigureDesktopArea1Click(Sender: TObject);
var
  DllHandle : integer;
  FileName : String;
  CoreConfigDummyForm: TCoreConfigDummyForm;
  c : TControl;
begin
  FileName := SharpApi.GetSharpeDirectory + 'Services\DeskArea.service';
  if FileExists(FileName) then
  begin
    DllHandle := LoadLibrary(PChar(FileName));
    if DllHandle <> 0 then
    begin
      @FDeskAreaStart := GetProcAddress(DllHandle, 'StartSettingsWnd');
      @FDeskAreaEnd   := GetProcAddress(DllHandle, 'CloseSettingsWnd');

      CoreConfigDummyForm := TCoreConfigDummyForm.Create(self);
      c := GetControlByHandle(FDeskAreaStart(CoreConfigDummyForm.bgpanel.Handle));
      c.Parent := CoreConfigDummyForm;
      c.Left := 8;
      c.Top := 8;
      if CoreConfigDummyForm.ShowModal = mrOk then FDeskAreaEnd(CoreConfigDummyForm.bgpanel.Handle,True)
         else FDeskAreaEnd(CoreConfigDummyForm.bgpanel.Handle,False);
      CoreConfigDummyForm.Free;
      FreeLibrary(Dllhandle);
      SharpApi.ServiceStop('DeskArea');
      SharpApi.ServiceStart('DeskArea');
    end;
  end;
end;

procedure TSharpBarMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Closing then exit;

  Closing := True;
  FreeLibrary(FUser32DllHandle);
  FUser32DllHandle := 0;

  SharpApi.UnRegisterAction(PChar('!FocusBar ('+inttostr(FBarID)+')'));

  if BarHideForm <> nil then FreeAndNil(BarHideForm);
  if AddPluginForm <> nil then FreeAndNil(AddPluginForm);
  if PluginManagerForm <> nil then FreeAndNil(PluginManagerForm);

  // check if shell hook functions have been used for any module
  if FShellHookList.Count > 0 then
  begin
    RegisterShellHook(Handle,0);
  //  SHUnSetHook;
  end;
  FShellHookList.Clear;
  FShellHookList.Free;

  // We want to produce good code, so let's free stuff before the app is closed ;)
  ForceDirectories(ExtractFileDir(ModuleSettings.FileName));
  SaveBarSettings;
  ModuleSettings.SaveToFile(ModuleSettings.FileName + '~');
  if FileExists(ModuleSettings.FileName) then
     DeleteFile(ModuleSettings.FileName);
  RenameFile(ModuleSettings.FileName + '~',ModuleSettings.FileName);
  ModuleManager.Free;
 // ModuleSettings.Free;
  //ModuleSettings := nil;

  FBottomZone.Free;
  FTopZone.Free;
  FBGImage.Free;

  FSharpEBar.Free;
  FSharpEBar := nil;

  FSkinManager.Free;
  FSkinManager := nil;
end;

procedure TSharpBarMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
end;

end.
