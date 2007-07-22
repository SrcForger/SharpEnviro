{
Source Name: SharpBarMainWnd.pas
Description: SharpBar Main Form 
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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
  GR32, uSharpEModuleManager, DateUtils, PngImageList, SharpEBar, SharpThemeApi,
  SharpEBaseControls, ImgList, Controls, ExtCtrls, uSkinManagerThreads,
  uSystemFuncs, Types, AppEvnts, SharpESkin,
  SharpGraphicsUtils, Math;

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
    N5: TMenuItem;
    Delete1: TMenuItem;
    Move1: TMenuItem;
    Left2: TMenuItem;
    Right1: TMenuItem;
    Settings: TMenuItem;
    DisableBarHiding1: TMenuItem;
    BarManagment1: TMenuItem;
    CreateemptySharpBar1: TMenuItem;
    DelayTimer1: TTimer;
    DelayTimer3: TTimer;
    Clone1: TMenuItem;
    QuickAddModule1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    N6: TMenuItem;
    Skin1: TMenuItem;
    ColorScheme1: TMenuItem;
    ThemeHideTimer: TTimer;
    ShowMiniThrobbers1: TMenuItem;
    procedure ShowMiniThrobbers1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ThemeHideTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure Clone1Click(Sender: TObject);
    procedure DelayTimer3Timer(Sender: TObject);
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
    procedure OnBackgroundPaint(Sender : TObject; Target : TBitmap32; x : integer);
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

    procedure CreateNewBar;
    procedure LoadBarModules(XMLElem : TJvSimpleXMlElem);

    procedure WMDeskClosing(var msg : TMessage); message WM_DESKCLOSING;
    procedure WMDeskBackgroundChange(var msg : TMessage); message WM_DESKBACKGROUNDCHANGED;

    // Bad Show/Hide Messages
    procedure WMShowBar(var msg : TMessage); message WM_SHOWBAR;
    procedure WMHideBar(var msg : TMessage); message WM_HIDEBAR;

    // Bar Message
    procedure WMBarReposition(var msg : TMessage); message WM_BARREPOSITION;
    procedure WMBarInsertModule(var msg : TMessage); message WM_BARINSERTMODULE;

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

    procedure OnBarPositionUpdate(Sender : TObject; var X,Y : Integer);
  public
    procedure LoadBarFromID(ID : integer);
    procedure LoadModuleSettings;
    procedure SaveBarSettings;
    procedure UpdateBGZone;
    procedure UpdateBGImage(NewWidth : integer = -1);
    procedure InitBar;
    property BGImage : TBitmap32 read FBGImage;
    property SkinManager : TSharpESkinManager read FSkinManager;
    property SharpEBar : TSharpEBar read FSharpEBar;
    property ShellBCInProgress : boolean read FShellBCInProgress;
    property BarID : integer read FBarID;
    property Startup : boolean read FStartup write FStartup;
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

uses PluginManagerWnd,
     SharpEMiniThrobber,
     BarHideWnd,
     AddPluginWnd;

{$R *.dfm}
// {$R SharpBarCR.RES}


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
  exit;
  if SharpBarMainForm.SharpEBar.HorizPos = hpFull then
     LockWindowUpdate(Handle)
     else SendMessage(Handle, WM_SETREDRAW, 0, 0);
end;

procedure UnlockWindow(const Handle: HWND);
begin
  exit;
  if SharpBarMainForm.ShellBCInProgress then exit;

  if SharpBarMainForm.SharpEBar.HorizPos = hpFull then
     LockWindowUpdate(0)
     else
     begin
       SendMessage(Handle, WM_SETREDRAW, 1, 0);
       RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
     end;
end;

// ************************
// Window Message handlers
// ************************

procedure TSharpBarMainForm.WMShowBar(var msg : TMessage);
begin
  if not SharpbarMainForm.Visible then
  begin
    SharpBarMainForm.Show;
    BarHideForm.UpdateStatus;
  end;
end;

procedure TSharpBarMainForm.WMHideBar(var msg : TMessage);
begin
  if SharpBarMainForm.Visible then
  begin
    SharpBarMainForm.Hide;
    ShowWindow(SharpEBar.abackground.Handle, SW_HIDE);
    BarHideForm.UpdateStatus;
  end;
end;

// Settings in the XML file have changed, the bar should reload the settings
// and update its position
procedure TSharpBarMainForm.WMBarReposition(var msg : TMessage);
var
  XML : TJvSimpleXML;
  Dir : String;
  FName : String;
  n : integer;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  FName := Dir + 'bars.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(FName) then
    begin
      XML.LoadFromFile(FName);
      if XML.Root.Items.ItemNamed['bars'] <> nil then
         with XML.Root.Items.ItemNamed['bars'].Items do
              for n := 0 to Count - 1 do
                  if Item[n].Items.IntValue('ID',-1) = FBarID then
                     if Item[n].Items.ItemNamed['Settings'] <> nil then
                        with Item[n].Items.ItemNamed['Settings'].Items do
                        begin
                          SharpEBar.AutoPosition   := BoolValue('AutoPosition',True);
                          SharpEBar.PrimaryMonitor := BoolValue('PrimaryMonitor',True);
                          SharpEBar.MonitorIndex   := IntValue('MonitorIndex',0);
                          SharpEBar.HorizPos       := IntToHorizPos(IntValue('HorizPos',0));
                          SharpEBar.VertPos        := IntToVertPos(IntValue('VertPos',0));
                          SharpEBar.AutoStart      := BoolValue('AutoStart',True);
                          SharpEBar.ShowThrobber   := BoolValue('ShowThrobber',True);
                          SharpEBar.DisableHideBar := BoolValue('DisableHideBar',False);
                          SharpEBar.UpdatePosition;
                        end;
    end;
  finally
    XML.Free;
  end;
end;

// A Module is being inserted into the bar via Drag & Drop
procedure TSharpBarMainForm.WMBarInsertModule(var msg : TMessage);
var
  MP : TPoint;
  ModulePos : TPoint;
  tempModule : TModule;
  n : integer;
  LastPos : integer;
  LastIndex : integer;
begin
  MP := Mouse.CursorPos;
  LastPos := -1;
  LastIndex := -1;
  for n := 0 to ModuleManager.Modules.Count - 1 do
  begin
    tempModule := TModule(ModuleManager.Modules.Items[n]);
    ModulePos := tempModule.Control.ClientToScreen(Point(tempModule.Control.Width,
                                                         tempModule.Control.Top));
    if ModulePos.X - tempModule.Control.Width < MP.X then
    begin
      LastPos := tempModule.Position;
      LastIndex := n;
    end else break;
  end;
  ModuleManager.LoadModule(msg.WParam,msg.LParam,LastPos,LastIndex);
  ModuleManager.ReCalculateModuleSize;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.WMEndSession(var msg : TMessage);
begin
  msg.result := 0;
  Close;
end;

procedure TSharpBarMainForm.WMQueryEndSession(var msg : TMessage);
begin
  msg.Result := 1;
  Self.Close;
end;

// Desk is shutting down
procedure TSharpBarMainForm.WMDeskClosing(var msg : TMessage);
begin
  if Closing then exit;

  DelayTimer1.Enabled := True;
end;

// The Desktop Background has changed
procedure TSharpBarMainForm.WMDeskBackgroundChange(var msg : TMessage);
begin
  if ModuleManager = nil then exit;
  if FSuspended then exit;
  if Closing then exit;

  if not FStartup then LockWindow(Handle);
  FBarLock := True;

  UpdateBGZone;

  SharpEBar.Throbber.UpdateSkin;
  if SharpEBar.Throbber.Visible then
     SharpEbar.Throbber.Repaint;

  ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);

  FBarLock := False;

  if ThemeHideTimer.Enabled then
     ThemeHideTimer.OnTimer(ThemeHideTimer);

  if not FStartup then UnLockWindow(Handle);
end;

// SharpE Actions
procedure TSharpBarMainForm.WMUpdateBangs(var Msg : TMessage);
begin
   if ModuleManager = nil then exit;
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
  if ModuleManager = nil then exit;
  ModuleManager.BroadcastPluginMessage('MM_WEATHERUPDATE');
end;

// Computer is entering or leaving suspended state (Laptop,...)
procedure TSharpBarMainForm.WMPowerBroadcast(var msg : TMessage);
begin
  case msg.WParam of
    PBT_APMSUSPEND: FSuspended := True;
    PBT_APMRESUMESUSPEND: begin
                            FSuspended := False;
                            RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
                          end;
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
  end;
end;

// A Module which was registered to receive shell messages unregisters itself
procedure TSharpBarMainForm.WMUnregisterShellHook(var msg : TMessage);
var
  harray : THandleArray;
begin
  if (Closing) or (FShellHookList = nil) then exit;

  FShellHookList.Delete(FShellHookList.IndexOf(inttostr(msg.WParam)));

  harray := FindAllWindows('TSharpBarMainForm');
  if (FShellHookList.Count = 0) and (length(harray) <= 1) then
     RegisterShellHook(Handle,0);
  setlength(harray,0);

//  if FShellHookList.Count = 0 then
//     RegisterShellHook(Handle,0);
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

// SharpE Settings Update... check what setting has changed...
procedure TSharpBarMainForm.WMUpdateSettings(var msg : TMessage);
var
  h : integer;
begin
  if FSuspended then exit;
  if Closing then exit;

  if msg.WParam < 0 then exit;

  // Step1: Update settings and prepare modules for updating
  case msg.WParam of
    SU_SKINFILECHANGED : SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);
    SU_THEME :
      begin
        SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme,tpIconSet]);
        // Check if SharpDesk is running
        if SharpApi.IsComponentRunning('SharpDesk') then
        begin
          // SharpDesk is running -> the background is going to change
          SetLayeredWindowAttributes(Handle,0, 0, LWA_ALPHA);
          SharpEBar.abackground.Alpha := 0;
          ThemeHideTimer.Enabled := True;
        end;
      end;
    SU_SCHEME :
      begin
        SharpThemeApi.LoadTheme(True,[tpScheme]);
        SkinManager.UpdateScheme;
      end;
    SU_ICONSET : SharpThemeApi.LoadTheme(True,[tpIconSet]);
  end;

  if //(msg.WParam = SU_THEME) or
     (msg.WParam = SU_SCHEME)
     or (msg.WParam = SU_SKINFILECHANGED)  then
     begin
       // Only update the skin if scheme or skin file changed...
       if not FStartup then LockWindow(Handle);
       FBarLock := True;
       h := Height;
       SkinManager.UpdateScheme;
       SkinManager.UpdateSkin;
       if h < Height then UpdateBGZone
          else UpdateBGZone;
       SharpEBar.UpdateSkin;
       if SharpEBar.Throbber.Visible then
       begin
         SharpEBar.Throbber.UpdateSkin;
         SharpEbar.Throbber.Repaint;
       end;
       ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);
     end;

  // Step2: Update modules
  ModuleManager.BroadcastPluginUpdate(msg.WParam);

  // Step3: Modules updated, now update the bar
  if (msg.WParam = SU_SKINFILECHANGED) then
     ModuleManager.ReCalculateModuleSize;

  if (msg.WParam = SU_SKINFILECHANGED) or
     (msg.Wparam = SU_SCHEME) then
      RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);

  if FBarLock then
  begin
    FBarLock := False;
    if not FStartup then UnLockWindow(Handle);
  end;
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
//  msg.result := integer(@FBGImage);
  msg.result := integer(@SharpEBar.Skin);
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
  if Closing then exit;
  if FSuspended then exit;
  if FStartup then exit;

  DebugOutput('WM_UpdateBarWidth',2,1);
  if not FStartup then LockWindow(Handle);
  try
    ModuleManager.ReCalculateModuleSize((msg.wparam = 0));
  finally
    if not FStartup then UnLockwindow(Handle);
  end;
end;

// ***********************

// the SharpEBar skin component is requesting the bar background for drawing
procedure TSharpBarMainForm.OnBackgroundPaint(Sender: TObject; Target: TBitmap32; x : integer);
begin
  FBGImage.DrawTo(Target,0,0,Rect(x-Monitor.Left,0,FBGImage.Width,FBGImage.Height));
end;

// Update the background image based on bar position and add glass effects
procedure TSharpBarMainForm.UpdateBGImage(NewWidth : integer = -1);
begin
  if FSuspended then exit;
  if FBGImage = nil then exit;
  if (Width = 0) or (Height = 0) then exit;

  if NewWidth < 1 then
     NewWidth := Width;

  FBGImage.SetSize(Max(NewWidth,FTopZone.Width),Height);
  FBGImage.Clear(color32(0,0,0,0));
  if SharpEBar.VertPos = vpTop then FBGImage.Draw(0,0,FTopZone)
     else FBGImage.Draw(0,0,FBottomZone);

  // Apply Glass Effects
  if SkinManager.Skin.BarSkin.GlassEffect then
  begin
    if SharpThemeApi.GetSkinGEBlend then
       BlendImageC(FBGImage,GetSkinGEBlendColor,GetSkinGEBlendAlpha);
    boxblur(FBGImage,GetSkinGEBlurRadius,GetSkinGEBlurIterations);
    if GetSkinGELighten then
       lightenBitmap(FBGImage,GetSkinGELightenAmount);
  end;

  SharpEBar.UpdateSkin;
  Repaint;
end;

// Update the images which are holding the bar background
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
      // First try to load the SharpDesk background image
      // if this fails then try to use PrintWindow on SharpDesk
      if FileExists(SharpApi.GetSharpeDirectory + 'SharpDeskbg.bmp') then
         BGBmp.LoadFromFile(SharpApi.GetSharpeDirectory + 'SharpDeskbg.bmp')
      else
      if @PrintWindow <> nil then
      begin
        // try 3 times... :)
        if not PrintWindow(wnd,BGBmp.Handle,0) then
        begin
           sleep(750);
           if not PrintWindow(wnd,BGBmp.Handle,0) then
           begin
              sleep(1500);
              if not PrintWindow(wnd,BGBmp.Handle,0) then
              begin
              end;
           end;
        end;
      end
    end else
    begin
      if FileExists(SharpApi.GetSharpeDirectory + 'SharpDeskbg.bmp') then
         BGBmp.LoadFromFile(SharpApi.GetSharpeDirectory + 'SharpDeskbg.bmp');
    end;
    // Update the images holding the top and bottom background image
    // (no need to hold the whole image, only the areas used by bars are of interest)
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
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
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
              Items.Add('ShowMiniThrobbers',ModuleManager.ShowMiniThrobbers);
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
  xml.SaveToFile(Dir + 'bars.xml~');
  if FileExists(Dir + 'bars.xml') then
     DeleteFile(Dir + 'bars.xml~');
  RenameFile(Dir + 'bars.xml~',Dir + 'bars.xml');
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
    if xml.Root.Items.ItemNamed['bars'] <> nil then
       with xml.root.items.ItemNamed['bars'] do
       begin
         for n := 0 to Items.Count - 1 do
             if Items.Item[n].Items.IntValue('ID',0) = ID then
                if Items.Item[n].Items.ItemNamed['Settings'] <> nil then
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
                     ModuleManager.ShowMiniThrobbers := Items.BoolValue('ShowMiniThrobbers',True);
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

// Init all skin and module management classes
procedure TSharpBarMainForm.InitBar;
begin
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
  FSharpEBar.onBackgroundPaint   := OnBackgroundPaint;

  SharpEBar.SkinManager := FSkinManager;

  // Load System Skin and Scheme in a Thread
  SkinManagerLoadThread := TSystemSkinLoadThread.Create(FSkinManager);

  FBottomZone := TBitmap32.Create;
  FTopZone    := TBitmap32.Create;
  FBGImage    := TBitmap32.Create;
//  SharpEBar.Throbber.SpecialBackground := FBGImage;

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
  ModuleManager := TModuleManager.Create(Handle, SkinManager, SharpEBar, ModuleSettings);
  ModuleManager.ThrobberMenu := ThrobberPopUp;
  DebugOutput('Loading Modules from Directory: '+ExtractFileDir(Application.ExeName) + '\Modules\',2,1);
  ModuleManager.LoadFromDirectory(ExtractFileDir(Application.ExeName) + '\Modules\');


  SharpEBar.onPositionUpdate := OnBarPositionUpdate;

  BarHideForm := TBarHideForm.Create(self);

  // Wait for the Skin Loading Thread to be finished
  SkinManagerLoadThread.WaitFor;
  SkinManagerLoadThread.Free;

  FSkinManager.onSkinChanged := SkinManager1SkinChanged;

  //DelayTimer2.Enabled := True;

  // Initialize the bar content
  // ID > 0 try load from xml
  // ID = -1 new bar
  if mfParamID <> -255 then
  begin
    SharpBarMainForm.LoadBarFromID(mfParamID);
    mfParamID := -255;
  end;

  UpdateBGZone;
  SkinManager.UpdateSkin;
  SharpEBar.Seed := - 1;
  SharpEBar.UpdateSkin;
  if SharpEBar.Throbber.Visible then
     SharpEBar.Throbber.UpdateSkin;

  SharpApi.RegisterActionEx(PChar('!FocusBar ('+inttostr(FBarID)+')'),'SharpBar',Handle,1);
end;

procedure TSharpBarMainForm.FormCreate(Sender: TObject);
begin
  Closing := False;
  DoubleBuffered := True;
  SharpThemeApi.LoadTheme;

  WM_SHELLHOOK := RegisterWindowMessage('SHELLHOOK');

  FUser32DllHandle := LoadLibrary('user32.dll');
  if FUser32DllHandle <> 0 then
     @PrintWindow := GetProcAddress(FUser32DllHandle, 'PrintWindow');

  FSuspended := False;
  FShellBCInProgress := False;

  DebugOutput('Setting Form properties',2,1);
  Setwindowlong(Application.handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  SetWindowPos(application.handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  ShowWindow(Application.Handle, SW_HIDE);

  KeyPreview := true;
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
  ShowMiniThrobbers1.Checked := ModuleManager.ShowMiniThrobbers;

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
    if FileExists(Dir + 'Skin.xml') then
    begin
      XML.LoadFromFile(Dir + 'Skin.xml');
      if XML.Root.Items.ItemNamed['Skin'] <> nil then
         XML.Root.Items.ItemNamed['Skin'].Value := NewSkin
         else XML.Root.Items.Add('Skin',NewSkin);
    end else
    begin
      XML.Root.Name := 'SharpEThemeSkin';
      XML.Root.Clear;
      XML.Root.Items.Add('Skin',NewSkin);
    end;
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
  if SharpEBar.Throbber.Visible then
     SharpEBar.Throbber.Repaint;
  ShowWindow(application.Handle, SW_HIDE);
  if BarHideForm <> nil then BarHideForm.UpdateStatus;
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
  ModuleManager.RefreshMiniThrobbers;
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
        SharpEBar.UpdateSkin;
        ModuleManager.FixModulePositions;
        ModuleManager.RefreshMiniThrobbers;
        ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND,-2);
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
      end;
      if oVP <> SharpEBar.VertPos then
      begin
        UpdateBGImage;
        SharpEBar.UpdateSkin;
        ModuleManager.FixModulePositions;
        ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND,-2);
        ModuleManager.RefreshMiniThrobbers;
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
      end;
      {if oHP <> SharpEBar.HorizPos then
      begin
        UpdateBGImage;
        ModuleManager.FixModulePositions;
        ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND,-2);
        ModuleManager.RefreshMiniThrobbers;
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
      end;     }
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
       if ssShift in Shift then
       begin
         // Toggle Mini Throbbers
         ModuleManager.ShowMiniThrobbers := not ModuleManager.ShowMiniThrobbers;
         ModuleManager.ReCalculateModuleSize;
       end else
       begin
         // Toggle Main Throbber
         if ModuleManager.Modules.Count = 0 then
         begin
           SharpEBar.ShowThrobber := True;
           exit;
         end;
         SharpEBar.ShowThrobber := not SharpEBar.ShowThrobber;
         ModuleManager.ReCalculateModuleSize;
         if SharpEBar.ShowThrobber then SharpEBar.Throbber.Repaint;
       end;
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
      SharpApi.ServiceMsg('DeskArea','Update');
    end
    else if (Y=0) and (SharpEBar.VertPos = vpTop) then
    begin
      BarHideForm.Left := Left;
      BarHideForm.Width := Width;
      BarHideForm.Height := 1;
      BarHideForm.Top := Top;
      SharpBarMainForm.Hide;
      BarHideForm.Show;
      SharpApi.ServiceMsg('DeskArea','Update');
    end;
  end;
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
  if SharpEBar.Throbber.Visible then
  begin
    SharpEBar.Throbber.UpdateSkin;
    SharpEbar.Throbber.Repaint;
  end;
  UpdateBGImage;

  //ModuleManager.UpdateModuleSkins;
  ModuleManager.FixModulePositions;
  ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND);

  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
  ModuleManager.RefreshMiniThrobbers;
end;

procedure TSharpBarMainForm.CreateemptySharpBar1Click(Sender: TObject);
var
  BR : array of TBarRect;
  Mon : TMonitor;
  n : integer;
  lp : TPoint;

  function BarAtPos(x,y : integer) : boolean;
  var
    i : integer;
  begin
    for i := 0 to High(BR) do
        if PointInRect(Point(BR[i].R.Left + (BR[i].R.Right - BR[i].R.Left) div 2,
                             BR[i].R.Top + (BR[i].R.Bottom - BR[i].R.Top) div 2),
                             Mon.BoundsRect) then
           if PointInRect(Point(x,y),BR[i].R)
              or PointInRect(Point(x-75,y),BR[i].R)
              or PointInRect(Point(x+75,y),BR[i].R) then
           begin
             result := true;
             exit;
           end;
    lp := Point(x,y);
    result := false;
  end;

begin
  setlength(BR,0);
  for n := 0 to SharpApi.GetSharpBarCount - 1 do
  begin
    setlength(BR,length(BR)+1);
    BR[High(BR)] := SharpApi.GetSharpBarArea(n);
  end;

  lp := point(-1,-1);
  for n := - 1 to Screen.MonitorCount - 1 do
  begin
    // start with the current monitor
    if n = - 1 then Mon := Monitor
       else Mon := Screen.Monitors[n];
    if (n <> -1) and (Mon = Monitor) then Continue; // don't test the current monitor twice
    if BarAtPos(Mon.Left,Mon.Top) then
       if BarAtPos(Mon.Left + Mon.Width div 2, Mon.Top) then
       if BarAtPos(Mon.Left + Mon.Width, Mon.Top) then
       if BarAtPos(Mon.Left,Mon.Top + Mon.Height) then
       if BarAtPos(Mon.Left + Mon.Width div 2, Mon.Top + Mon.Height) then
          BarAtPos(Mon.Left + Mon.Width, Mon.Top + Mon.Height);
    if (lp.x <> - 1) and (lp.y  <> - 1) then
       break;
  end;
  setlength(BR,0);
  if (lp.x = - 1) and (lp.y  = - 1) then
  begin
    ShowMessage('There is not enough free space left for another SharpBar');
    exit;
  end;

  SharpApi.SharpExecute('SharpBar.exe -load:-1 -x:' + inttostr(lp.x) + ' -y:' + inttostr(lp.y));
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

procedure TSharpBarMainForm.OnBarPositionUpdate(Sender : TObject; var X,Y : Integer);
begin
  if FSuspended then exit;
  if BarHideForm <> nil then BarHideForm.UpdateStatus;

  if x < Monitor.Left then x := Monitor.Left;
  if Width > Monitor.Width then
     Width := Monitor.Width;

//  UpdateBGImage;
  ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND,-2);
end;

procedure TSharpBarMainForm.DelayTimer1Timer(Sender: TObject);
begin
  DelayTimer1.Enabled := False;
  SendMessage(Handle,WM_DESKBACKGROUNDCHANGED,0,0);
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
  if (FShellHookList = nil) or (Closing) then
  begin
    Handled := False;
    exit;
  end;
  
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

procedure TSharpBarMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  harray : THandleArray;
begin
  if Closing then exit;

  SetLayeredWindowAttributes(Handle,0, 0, LWA_ALPHA);
  SharpEBar.abackground.Alpha := 0;

  Closing := True;
  FreeLibrary(FUser32DllHandle);
  FUser32DllHandle := 0;

  SharpApi.UnRegisterAction(PChar('!FocusBar ('+inttostr(FBarID)+')'));

  if BarHideForm <> nil then
  begin
    if BarHideForm.Visible then BarHideForm.Close;
    FreeAndNil(BarHideForm);
  end;
  if AddPluginForm <> nil then FreeAndNil(AddPluginForm);
  if PluginManagerForm <> nil then FreeAndNil(PluginManagerForm);

  harray := FindAllWindows('TSharpBarMainForm');
  if length(harray) <= 1 then
     RegisterShellHook(Handle,0);
  setlength(harray,0);
  // check if shell hook functions have been used for any module
{  if (FShellHookList.Count > 0) and (FindWindow('TSharpBarMainForm',nil)  then
     RegisterShellHook(Handle,0);}

  // We want to produce good code, so let's free stuff before the app is closed ;)
  ForceDirectories(ExtractFileDir(ModuleSettings.FileName));
  SaveBarSettings;
  ModuleSettings.SaveToFile(ModuleSettings.FileName + '~');
  if FileExists(ModuleSettings.FileName) then
     DeleteFile(ModuleSettings.FileName);
  RenameFile(ModuleSettings.FileName + '~',ModuleSettings.FileName);
  ModuleManager.Free;

  Application.ProcessMessages;
  FShellHookList.Clear;
  FreeAndNil(FShellHookList);
  
 // ModuleSettings.Free;
  //ModuleSettings := nil;

  FSharpEBar.Free;
  FSharpEBar := nil;

  FSkinManager.Free;
  FSkinManager := nil;

  FBottomZone.Free;
  FTopZone.Free;
  FBGImage.Free;

  sleep(500);
end;

procedure TSharpBarMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
end;

procedure TSharpBarMainForm.ThemeHideTimerTimer(Sender: TObject);
begin
  ThemeHideTimer.Enabled := False;
  SetLayeredWindowAttributes(Handle,0, 255, LWA_ALPHA);
  SetLayeredWindowAttributes(Handle, RGB(255, 0, 254), 255, LWA_COLORKEY);
  SharpEBar.abackground.Alpha := 255;
end;

procedure TSharpBarMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((SSALT in Shift) and (Key = VK_F4)) then
     Key := 0;
end;

procedure TSharpBarMainForm.ShowMiniThrobbers1Click(Sender: TObject);
begin
  ShowMiniThrobbers1.Checked := not ShowMiniThrobbers1.Checked;
  ModuleManager.ShowMiniThrobbers := ShowMiniThrobbers1.Checked;
  SaveBarSettings;
  ModuleManager.ReCalculateModuleSize;
end;

end.
