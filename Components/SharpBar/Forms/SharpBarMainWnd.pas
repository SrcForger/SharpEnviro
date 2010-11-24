{
Source Name: SharpBarMainWnd.pas
Description: SharpBar Main Form
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit SharpBarMainWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms,
  Dialogs, SharpESkinManager, Menus, JclSimpleXML, SharpApi,
  GR32, uSharpEModuleManager, PngImageList, SharpEBar,
  SharpEBaseControls, Controls, ExtCtrls, uSkinManagerThreads,
  uSystemFuncs, Types, SharpESkin, Registry, SharpTypes, SharpNotify,
  SharpGraphicsUtils, Math, SharpCenterApi, ImgList, GR32_Backends,
  uSharpESkinInterface, uSharpBarInterface, MonitorList,
  SharpSharedFileAccess, GR32Utils;

type
  TSharpBarMainForm = class(TForm)
    PopupMenu1: TPopupMenu;
    Position1: TMenuItem;
    Top1: TMenuItem;
    Bottom1: TMenuItem;
    N1: TMenuItem;
    Left1: TMenuItem;
    Right1: TMenuItem;
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
    miLeftModule: TMenuItem;
    miRightModule: TMenuItem;
    Settings: TMenuItem;
    DisableBarHiding1: TMenuItem;
    BarManagment1: TMenuItem;
    DelayTimer1: TTimer;
    DelayTimer3: TTimer;
    Clone1: TMenuItem;
    QuickAddModule1: TMenuItem;
    N6: TMenuItem;
    Skin1: TMenuItem;
    ColorScheme1: TMenuItem;
    ThemeHideTimer: TTimer;
    ShowMiniThrobbers1: TMenuItem;
    AlwaysOnTop1: TMenuItem;
    LaunchSharpCenter1: TMenuItem;
    N7: TMenuItem;
    FullscreenCheckTimer: TTimer;
    FixedWidth1: TMenuItem;
    EnabledFixedSize1: TMenuItem;
    N8: TMenuItem;
    N501: TMenuItem;
    N502: TMenuItem;
    N401: TMenuItem;
    N301: TMenuItem;
    N201: TMenuItem;
    Custom1: TMenuItem;
    ForceAlwaysOnTop1: TMenuItem;
    tmrAutoHide: TTimer;
    tmrCursorPos: TTimer;
    procedure ShowMiniThrobbers1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ThemeHideTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Clone1Click(Sender: TObject);
    procedure DelayTimer3Timer(Sender: TObject);
    procedure DelayTimer1Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DisableBarHiding1Click(Sender: TObject);
    procedure miRightModuleClick(Sender: TObject);
    procedure miLeftModuleClick(Sender: TObject);
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
    procedure Right1Click(Sender: TObject);
    procedure Middle1Click(Sender: TObject);
    procedure Left1Click(Sender: TObject);
    procedure Bottom1Click(Sender: TObject);
    procedure Top1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnMonitorPopupItemClick(Sender: TObject);
    procedure OnQuickAddModuleItemClick(Sender: TObject);
    procedure OnSkinSelectItemClick(Sender: TObject);
    procedure OnSchemeSelectItemClick(Sender: TObject);
    procedure OnBackgroundPaint(Sender: TObject; Target: TBitmap32; x: integer);
    procedure AlwaysOnTop1Click(Sender: TObject);
    procedure BarManagment1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LaunchSharpCenter1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FullscreenCheckTimerTimer(Sender: TObject);
    procedure EnabledFixedSize1Click(Sender: TObject);
    procedure N501Click(Sender: TObject);
    procedure Custom1Click(Sender: TObject);
    procedure ForceAlwaysOnTop1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure tmrAutoHideTimer(Sender: TObject);
    procedure tmrCursorPosTimer(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    { Private-Deklarationen }
    FUser32DllHandle: THandle;
    PrintWindow: function(SourceWindow: hwnd; Destination: hdc; nFlags: cardinal): bool; stdcall;
    FSuspended: boolean;
    FBarID: integer;
    FStartup: Boolean;
    FTopZone: TBitmap32;
    FBottomZone: TBitmap32;
    FBGImage: TBitmap32;
    FShellBCInProgress: boolean;
    FSkinInterface : TSharpESkinInterface;
    FBarInterface : TSharpBarInterface;
    FSharpEBar: TSharpEBar;
    FBarName: string;
    FRegisteredSessionNotification : Boolean;

    FDragging : boolean;

    // Info Tooltips
    FFirstHide : Boolean;
    FFirstThrobberHide : Boolean;

    procedure CreateNewBar;
    procedure LoadBarModules(XMLElem: TJclSimpleXMlElem);

    procedure StartAutoHide(wnd : HWND = 0);

    procedure WMDeskClosing(var msg: TMessage); message WM_DESKCLOSING;

    // Bad Show/Hide Messages
    procedure WMShowBar(var msg: TMessage); message WM_SHOWBAR;
    procedure WMHideBar(var msg: TMessage); message WM_HIDEBAR;

    // Bar Message
    procedure WMBarReposition(var msg: TMessage); message WM_BARREPOSITION;
    procedure WMBarInsertModule(var msg: TMessage); message WM_BARINSERTMODULE;
    procedure WMBarCommand(var msg: TMessage); message WM_BARCOMMAND;

    // Plugin message (to be broadcastet to modules)
    procedure WMVWMDesktopChanged(var msg: TMessage); message WM_VWMDESKTOPCHANGED;
    procedure WMVWMUpdateSettings(var msg: TMessagE); message WM_VWMUPDATESETTINGS;
    procedure WMWeatherUpdate(var msg: TMessage); message WM_WEATHERUPDATE;
    procedure WMInputChange(var msg: TMessage); message WM_INPUTLANGCHANGEREQUEST;
    procedure WMShellHookWindowCreate(var msg: TMessage); message WM_SHELLHOOKWINDOWCREATED;

    // Power Management
    procedure WMPowerBroadcast(var msg: TMessage); message WM_POWERBROADCAST;

    procedure WMWTSSessionChange(var msg: TMessage); message WM_WTSSESSION_CHANGE;
    function RegisterSessionNotification(Wnd: HWND; dwFlags: DWORD): Boolean;
    function UnRegisterSesssionNotification(Wnd: HWND): Boolean;

    // Shutdown
    procedure WMEndSession(var msg: TMessage); message WM_ENDSESSION;

    // SharpE Actions
    procedure WMUpdateBangs(var Msg: TMessage); message WM_SHARPEUPDATEACTIONS;
    procedure WMSharpEBang(var Msg: TMessage); message WM_SHARPEACTIONMESSAGE;

    procedure WMGetFreeBarSpace(var msg: TMessage); message WM_GETFREEBARSPACE;

    procedure WMSharpTerminate(var msg: TMessage); message WM_SHARPTERMINATE;
    procedure WMDisplayChange(var msg: TMessage); message WM_DISPLAYCHANGE;
    procedure WMUpdateBarWidth(var msg: TMessage); message WM_UPDATEBARWIDTH;
    procedure WMGetCopyData(var msg: TMessage); message WM_COPYDATA;
    procedure WMUpdateSettings(var msg: TMessage); message WM_SHARPEUPDATESETTINGS;

    procedure OnBarPositionUpdate(Sender: TObject; var X, Y: Integer);

  public
    procedure LoadBarFromID(ID: integer);
    procedure LoadBarTooltipSettings;
    procedure SaveBarSettings;
    procedure SaveBarTooltipSettings;
    procedure UpdateBGZone;
    procedure UpdateBGImage(NewWidth: integer = -1);
    procedure InitBar;
    procedure HideBar;
    procedure ShowNotify(pCaption : String; pScreenBorder : boolean = False);
    procedure UpdateMonitor;

    property BGImage: TBitmap32 read FBGImage;
    property SharpEBar: TSharpEBar read FSharpEBar;
    property ShellBCInProgress: boolean read FShellBCInProgress;
    property BarID: integer read FBarID;
    property Startup: boolean read FStartup write FStartup;
    property SkinInterface: TSharpESkinInterface read FSkinInterface;

    // Tooltips
    property FirstHide: boolean read FFirstHide write FFirstHide;
    property FirstThrobberHide: boolean read FFirstThrobberHide write FFirstThrobberHide;
  end;

const
  Debug = True;
  DebugLevel = 3;

var
  SharpBarMainForm: TSharpBarMainForm;
  mfParamID: integer;
  ModuleManager: TModuleManager;
  BarMove: boolean;
  BarMovePoint: TPoint;
  Closing: boolean;
  foregroundWindowIsFullscreen : Boolean;

implementation

uses
  SharpEMiniThrobber,
  BarHideWnd,
  uISharpETheme,
  uSharpXMLUtils,
  SharpThemeApiEx,
  uThemeConsts;

{$R *.dfm}

function GetControlByHandle(AHandle: THandle): TWinControl;
begin
  Result := Pointer(GetProp(AHandle,
    PChar(Format('Delphi%8.8x',
    [GetCurrentProcessID]))));
end;

procedure dllcallback(handle: hwnd);
begin
end;

function GetCurrentTime: Int64;
var
  h, m, s, ms: word;
begin
  DecodeTime(now, h, m, s, ms);
  result := h * 60 * 60 * 1000 + m * 60 * 1000 + s * 1000 + ms;
end;

// ************************
// Window Message handlers
// ************************

procedure TSharpBarMainForm.WMShowBar(var msg: TMessage);
begin
  if not SharpbarMainForm.Visible then begin
    SharpBarMainForm.Show;
    BarHideForm.UpdateStatus;
  end;
end;

procedure TSharpBarMainForm.WMHideBar(var msg: TMessage);
begin
  if SharpBarMainForm.Visible then begin
    SharpBarMainForm.Hide;
    ShowWindow(SharpEBar.abackground.Handle, SW_HIDE);
    BarHideForm.UpdateStatus;
  end;
end;

// Settings in the XML file have changed, the bar should reload the settings
// and update its position

procedure TSharpBarMainForm.WMBarReposition(var msg: TMessage);
var
  xml: TJclSimpleXML;
  Dir: string;
  FixedWidthEnabledTemp : boolean;
  FixedWidthTemp : integer;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FBarID) + '\';

  // Find and load settings file!
  xml := TJclSimpleXML.Create;

  FixedWidthEnabledTemp := SharpEBar.FixedWidthEnabled;
  FixedWidthTemp := SharpEBar.FixedWidth;

  if LoadXMLFromSharedFile(xml,Dir + 'Bar.xml',True) then
  begin
    // xml file loaded properlty... use it
    if xml.Root.Items.ItemNamed['Settings'] <> nil then
      with xml.Root.Items.ItemNamed['Settings'] do begin
        FBarName := Items.Value('Name', 'Toolbar');
        SharpEBar.AutoPosition := Items.BoolValue('AutoPosition', True);
        SharpEBar.PrimaryMonitor := Items.BoolValue('PrimaryMonitor', True);
        SharpEBar.MonitorIndex := Items.IntValue('MonitorIndex', 0);
        SharpEBar.HorizPos := IntToHorizPos(Items.IntValue('HorizPos', 0));
        SharpEBar.VertPos := IntToVertPos(Items.IntValue('VertPos', 0));
        SharpEBar.AutoStart := Items.BoolValue('AutoStart', True);
        SharpEBar.ShowThrobber := Items.BoolValue('ShowThrobber', True);
        SharpEBar.DisableHideBar := Items.BoolValue('DisableHideBar', True);
        SharpEBar.StartHidden := Items.BoolValue('StartHidden', False);
        ModuleManager.ShowMiniThrobbers := Items.BoolValue('ShowMiniThrobbers', True);
        SharpEBar.AutoHide := Items.BoolValue('AutoHide', False);
        SharpEBar.AutoHideTime := Items.IntValue('AutoHideTime', 1000);
        SharpEBar.AlwaysOnTop := Items.BoolValue('AlwaysOnTop', False);
        SharpEBar.ForceAlwaysOnTop := Items.BoolValue('ForceAlwaysOnTop', False);
        SharpEBar.FixedWidthEnabled := Items.BoolValue('FixedWidthEnabled', False);
        SharpEBar.FixedWidth := Max(10,Min(90,Items.IntValue('FixedWidth', 50)));
      end;
      
    if SharpEBar.AutoHide then
      SharpEBar.AlwaysOnTop := True;

    if (FixedWidthEnabledTemp <> SharpEBar.FixedWidthEnabled)
      or (FixedWidthTemp <> SharpEBar.FixedWidth) then
      ModuleManager.ReCalculateModuleSize(True,True);

    ModuleManager.BarName := FBarName;
    SharpEBar.UpdatePosition;
    UpdateBGZone;

    if (not Visible) and (tmrCursorPos.Enabled) and (not SharpEBar.AutoHide) then
      BarHideForm.ShowBar;

    tmrCursorPos.Enabled := SharpEBar.AutoHide;
    tmrAutoHide.Enabled := False;
    tmrAutoHide.Interval := SharpEBar.AutoHideTime;

  end else
    SharpApi.SendDebugMessageEx('SharpBar',PChar('(WMBarReposition): Error loading '+ Dir + 'Bar.xml'), clred, DMT_ERROR);

  xml.Free;
end;

// A Module is being inserted into the bar via Drag & Drop

procedure TSharpBarMainForm.WMBarCommand(var msg: TMessage);
var
  ModuleIndex: integer;
begin
  ModuleIndex := ModuleManager.GetModuleIndex(msg.LParam);
  if ModuleIndex = -1 then
    exit;

  case msg.WParam of
    BC_MOVEUP: begin
        ModuleManager.MoveModule(ModuleIndex, -1);
        ModuleManager.SortModulesByPosition;
        ModuleManager.FixModulePositions;
        SaveBarSettings;
        SharpApi.BroadcastGlobalUpdateMessage(suCenter);
        msg.Result := BCR_SUCCESS;
      end;
    BC_MOVEDOWN: begin
        ModuleManager.MoveModule(ModuleIndex, 1);
        ModuleManager.SortModulesByPosition;
        ModuleManager.FixModulePositions;
        SaveBarSettings;
        SharpApi.BroadcastGlobalUpdateMessage(suCenter);
        msg.Result := BCR_SUCCESS;
      end;
    BC_DELETE: begin
        ModuleManager.Delete(msg.LParam);
        ModuleManager.ReCalculateModuleSize;
        SaveBarSettings;
        SharpApi.BroadcastGlobalUpdateMessage(suCenter);
        msg.Result := BCR_SUCCESS;
      end;
  end;
end;

procedure TSharpBarMainForm.WMBarInsertModule(var msg: TMessage);
var
  MP: TPoint;
  ModulePos: TPoint;
  tempModule: TModule;
  n: integer;
  LastPos: integer;
  LastIndex: integer;
begin
  if not GetCursorPosSecure(MP) then
    exit;
    
  LastPos := -1;
  LastIndex := -1;
  for n := 0 to ModuleManager.Modules.Count - 1 do begin
    tempModule := TModule(ModuleManager.Modules.Items[n]);
    ModulePos := tempModule.mInterface.Form.ClientToScreen(Point(tempModule.mInterface.Form.Width,
      tempModule.mInterface.Form.Top));
    if ModulePos.X - tempModule.mInterface.Form.Width < MP.X then begin
      LastPos := tempModule.Position;
      LastIndex := n;
    end
    else
      break;
  end;
  ModuleManager.LoadModule(msg.WParam, msg.LParam, LastPos, LastIndex);
  ModuleManager.ReCalculateModuleSize;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.WMEndSession(var msg: TMessage);
begin
  msg.result := 0;
  
  if msg.WParam <> 0 then
    Close;
end;

// Desk is shutting down

procedure TSharpBarMainForm.WMDeskClosing(var msg: TMessage);
begin
  if Closing then
    exit;

  DelayTimer1.Enabled := True;
end;

// SharpE Actions

procedure TSharpBarMainForm.WMUpdateBangs(var Msg: TMessage);
begin
  if ModuleManager = nil then
    exit;
  ModuleManager.BroadcastPluginMessage('MM_SHARPEUPDATEACTIONS');

  SharpApi.RegisterActionEx(PChar('!FocusBar (' + inttostr(FBarID) + ')'), 'SharpBar', Handle, 1);
end;

procedure TSharpBarMainForm.WMSharpEBang(var Msg: TMessage);
begin
  case msg.LParam of
    1: ForceForeGroundWindow(Handle);
  end;
end;

// SharpE Terminate Message support

procedure TSharpBarMainForm.WMSharpTerminate(var msg: TMessage);
begin
  Close;
end;

// The shell hook window has been created, all modules or windows which
// need to receive shell hooks should now register with the service

procedure TSharpBarMainForm.WMShellHookWindowCreate(var msg: TMessage);
begin
  if ModuleManager = nil then
    exit;
  ModuleManager.BroadcastPluginMessage('MM_SHELLHOOKWINDOWCREATED');
end;

// System Input Language Changed -> broadcast a message to all modules

procedure TSharpBarMainForm.WMInputChange(var msg: TMessage);
begin
  if ModuleManager = nil then
    exit;

  DefWindowProc(HAndle,Msg.Msg,Msg.WParam,Msg.LParam);
  ModuleManager.BroadcastPluginMessage('MM_INPUTLANGCHANGE');
end;

// Weather Service updated the xml files -> broadcast as message to all modules

procedure TSharpBarMainForm.WMWeatherUpdate(var msg: TMessage);
begin
  if ModuleManager = nil then
    exit;
  ModuleManager.BroadcastPluginMessage('MM_WEATHERUPDATE');
end;

// Computer is entering or leaving suspended state (Laptop,...)

procedure TSharpBarMainForm.WMPowerBroadcast(var msg: TMessage);
begin
  case msg.WParam of
    PBT_APMSUSPEND: begin
      ModuleManager.BroadcastPluginMessage('MM_APM_SUSPEND');
      FSuspended := True;
    end;
    PBT_APMRESUMESUSPEND: begin
        FSuspended := False;
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
        ModuleManager.BroadcastPluginMessage('MM_APM_RESUMESUSPEND');
      end;
  end;
  msg.Result := 1;
end;

procedure TSharpBarMainForm.WMWTSSessionChange(var msg: TMessage);
begin
  MonList.GetMonitors;
  
  case msg.WParam of
    WTS_REMOTE_CONNECT:
    begin
      if SharpEBar.MonitorIndex > MonList.MonitorCount - 1 then
        FSuspended := True;
    end;
    WTS_REMOTE_DISCONNECT:
      if SharpEBar.MonitorIndex < MonList.MonitorCount then
        FSuspended := False;
    WTS_SESSION_UNLOCK:
    begin
      ModuleManager.BroadcastPluginMessage('MM_SESSION_UNLOCK');
      UpdateBGZone;
      SharpEBar.UpdateSkin;
      SharpEBar.UpdateAlwaysOnTop;
      ModuleManager.BroadCastModuleRefresh;
      ModuleManager.BroadcastPluginUpdate(suBackground);
    end;
  end;
end;

function TSharpBarMainForm.RegisterSessionNotification(Wnd: HWND; dwFlags: Cardinal) : Boolean;
type
  TWTSRegisterSessionNotification = function(Wnd: HWND; dwFlags: DWORD): BOOL; stdcall;
var
  hWTSapi32dll : THandle;
  WTSRegisterSessionNotification : TWTSRegisterSessionNotification;
begin
  Result := False;
  hWTSapi32dll := LoadLibrary('Wtsapi32.dll');
  if hWTSapi32dll > 0 then
  begin
    try
      @WTSRegisterSessionNotification := GetProcAddress(hWTSapi32dll, 'WTSRegisterSessionNotification');
      if Assigned(WTSRegisterSessionNotification) then
        Result:= WTSRegisterSessionNotification(Wnd, dwFlags);
    finally
      if hWTSapi32dll > 0 then
        FreeLibrary(hWTSAPI32DLL);
    end;
  end;
end;

function TSharpBarMainForm.UnRegisterSesssionNotification(Wnd: HWND) : Boolean;
type
  TWTSUnRegisterSessionNotification = function(Wnd: HWND) : BOOL; stdcall;
var
  hWTSapi32dll : THandle;
  WTSUnRegisterSessionNotification : TWTSUnRegisterSessionNotification;
begin
  Result := False;
  hWTSapi32dll := LoadLibrary('Wtsapi32.dll');
  if hWTSapi32dll > 0 then
  begin
    try
      @WTSUnRegisterSessionNotification := GetProcAddress(hWTSapi32dll, 'WTSUnRegisterSessionNotification');
      if Assigned(WTSUnregisterSessionNotification) then
        Result:= WTSUnRegisterSessionNotification(Wnd);
    finally
      if hWTSapi32dll > 0 then
        FreeLibrary(hWTSapi32dll);
    end;
  end;
end;

// A Module is requesting how much free bar space is left

procedure TSharpBarMainForm.WMGetFreeBarSpace(var msg: TMessage);
begin
  msg.Result := ModuleManager.GetFreeBarSpace;
end;

// Display resolution changed

procedure TSharpBarMainForm.WMDisplayChange(var msg: TMessage);
begin
  if FSuspended then
    exit;

  MonList.GetMonitors;
  // Suspend the bar if the monitor is not present.
  FSuspended := SharpEBar.MonitorIndex > MonList.MonitorCount - 1;

  if FSuspended then
    Exit;

  if SharpEBar.HorizPos = hpFull then
  begin
    // This avoids the bars from becoming overlapped if you have multiple monitors
    // with 2 full screen bars.  One of the bars crashes once they become overlapped.
    // These settings are also changed later by DelayTimer3 but that seems to be to late.
    if not MonList.IsValidMonitorIndex(SharpEBar.MonitorIndex) then
      UpdateMonitor;
    Left := MonList.Monitors[SharpEBar.MonitorIndex].Left;
    Width := MonList.Monitors[SharpEBar.MonitorIndex].Width;
  end;
  ModuleManager.BroadcastPluginMessage('MM_DISPLAYCHANGE');
  DelayTimer3.Enabled := True;
end;

// SharpE Settings Update... check what setting has changed...

procedure TSharpBarMainForm.WMUpdateSettings(var msg: TMessage);
var
  h: integer;
  Theme : ISharpETheme;
begin
  if FSuspended then
    exit;
  if Closing then
    exit;

  if msg.WParam < 0 then
    exit;

  if [TSU_UPDATE_ENUM(msg.WParam)] <= [suSkinFont,suSkinFileChanged,suTheme,suIconSet,
                                       suScheme,suHelpTooltips] then
    Theme := GetCurrentTheme;

  // Step1: Update settings and prepare modules for updating
  case msg.WParam of
    Integer(suDesktopBackgroundChanged): begin
      UpdateBGZone;
      SharpEBar.Throbber.UpdateSkin;
      if SharpEBar.Throbber.Visible then
         SharpEbar.Throbber.Repaint;
      ModuleManager.BroadcastPluginUpdate(suBackground);
      RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
      if ThemeHideTimer.Enabled then
        ThemeHideTimer.OnTimer(ThemeHideTimer);
    end;
    Integer(suSkinFont): begin
        Theme.LoadTheme([tpSkinFont]);
        SkinInterface.SkinManager.RefreshControls;
        ModuleManager.BroadcastPluginUpdate(suSkinFileChanged);
        ModuleManager.ReCalculateModuleSize;        
      end;
    Integer(suSkinFileChanged): Theme.LoadTheme([tpSkinScheme]);
    Integer(suTheme): begin
        Theme.LoadTheme([tpTheme,tpSkinScheme, tpSkinFont, tpIconSet]);
        // Check if SharpDesk is running
        if SharpApi.IsComponentRunning('SharpDesk') then begin
          // SharpDesk is running -> the background is going to change
          SetLayeredWindowAttributes(Handle, 0, 0, LWA_ALPHA);
          SharpEBar.abackground.Alpha := 0;
          ThemeHideTimer.Enabled := True;
        end;
      end;
    Integer(suScheme): begin
        Theme.LoadTheme([tpSkinScheme]);
        SkinInterface.SkinManager.UpdateScheme;
      end;
    Integer(suIconSet): Theme.LoadTheme([tpIconSet]);
    Integer(suHelpTooltips) : LoadBarTooltipSettings;
  end;

  h := Height;
  if (msg.WParam = Integer(suScheme))
    or (msg.WParam = Integer(suSkinFileChanged)) then begin
    // Only update the skin if scheme or skin file changed...
    SkinInterface.SkinManager.UpdateScheme;
    SkinInterface.SkinManager.UpdateSkin;
    SharpEBar.UpdateSkin;
    SharpEBar.UpdatePosition;
    if h < Height then
      UpdateBGZone
    else
      UpdateBGZone;
    if SharpEBar.Throbber.Visible then begin
      SharpEBar.Throbber.UpdateSkin;
      SharpEbar.Throbber.Repaint;
    end;
    if h <> Height then
      ModuleManager.UpdateModuleHeights;    
    if (msg.WParam = Integer(suSkinFileChanged)) then
      ModuleManager.ReCalculateModuleSize;
    ModuleManager.BroadcastPluginUpdate(suBackground);
  end;

  // Step2: Update modules
  ModuleManager.BroadcastPluginUpdate(TSU_UPDATE_ENUM(msg.WParam), msg.LParam);

  if (msg.WParam = Integer(suSkinFileChanged)) or
    (msg.Wparam = Integer(suScheme)) or
    (msg.Wparam = Integer(suSkinFont)) then
  begin
    RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
    SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));     
  end;

end;

procedure TSharpBarMainForm.WMVWMDesktopChanged(var msg: TMessage);
begin
  if ModuleManager = nil then
    exit;
  ModuleManager.BroadcastPluginMessage('MM_VWMDESKTOPCHANGED');
end;

procedure TSharpBarMainForm.WMVWMUpdateSettings(var msg: TMessagE);
begin
  if ModuleManager = nil then
    exit;
  ModuleManager.BroadcastPluginMessage('MM_VWMUPDATESETTINGS');
end;

// Plugin message received... foward to requested module

procedure TSharpBarMainForm.WMGetCopyData(var msg: TMessage);
var
  pParams: string;
  pID: integer;
  msgdata: TMsgData;
  mIndex: integer;
  sedata: TSharpE_DataStruct;
  wnd : HWND;
begin
  ModuleManager.DebugOutput('WM_CopyData', 2, 1);

  if msg.WParam = WM_BARCOMMAND then begin
    sedata := pSharpE_DataStruct(PCopyDataStruct(msg.lParam)^.lpData)^;
    if sedata.LParam = BC_ADD then begin
      mIndex := ModuleManager.GetModuleFileIndexByFileName(sedata.Module);
      if mIndex <> -1 then begin
        wnd := sedata.Handle;
        if wnd = 0 then
          wnd := Application.Handle;

        ModuleManager.CreateModule(mIndex, sedata.RParam, wnd);
        SaveBarSettings;
        msg.Result := BCR_SUCCESS;

        // Send refresh message to the calling window
        if wnd <> Application.Handle then
          SendMessage(wnd, WM_SHARPSHELLMESSAGE, 0, 0);
      end;
    end;
  end
  else begin
    msgdata := pMsgData(PCopyDataStruct(msg.lParam)^.lpData)^;
    pID := StrToIntDef(lowercase(msgdata.Command),-1);
    if pID = -1 then
      exit;
    pParams := msgdata.Parameters;
    ModuleManager.SendPluginMessage(pID, pParams);
  end;
end;

// Module is requesting update of bar width

procedure TSharpBarMainForm.WMUpdateBarWidth(var msg: TMessage);
begin
  if Closing then
    exit;
  if FSuspended then
    exit;
  if FStartup then
    exit;
  if ModuleManager = nil then
    exit;

  ModuleManager.ReCalculateModuleSize((msg.wparam = 0));

 // RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
 // ModuleManager.BroadcastPluginUpdate(suBackground, -2);
end;

// ***********************

// the SharpEBar skin component is requesting the bar background for drawing

procedure TSharpBarMainForm.OnBackgroundPaint(Sender: TObject; Target: TBitmap32; x: integer);
begin
  FBGImage.DrawTo(Target, 0, 0, Rect(x - Monitor.Left, 0, FBGImage.Width, FBGImage.Height));
end;

// Update the background image based on bar position and add glass effects

procedure TSharpBarMainForm.UpdateBGImage(NewWidth: integer = -1);
var
  Theme : ISharpETheme;
begin
  if FSuspended then
    exit;
  if FBGImage = nil then
    exit;
  if (Width = 0) or (Height = 0) then
    exit;

  if NewWidth < 1 then
    NewWidth := Width;

  FBGImage.SetSize(Max(NewWidth, FTopZone.Width), Height);
  FBGImage.Clear(color32(0, 0, 0, 0));
  if SharpEBar.VertPos = vpTop then
    FBGImage.Draw(0, 0, FTopZone)
  else
    FBGImage.Draw(0, 0, FBottomZone);

  // Apply Glass Effects
  if SkinInterface.SkinManager.Skin.Bar.GlassEffect then
  begin
    Theme := GetCurrentTheme;
    if Theme.Skin.GlassEffect.Blend then
      BlendImageC(FBGImage, Theme.Skin.GlassEffect.BlendColor, Theme.Skin.GlassEffect.BlendAlpha);
    fastblur(FBGImage, Theme.Skin.GlassEffect.BlurRadius, Theme.Skin.GlassEffect.BlurIterations);
    if Theme.Skin.GlassEffect.Lighten then
      lightenBitmap(FBGImage, Theme.Skin.GlassEffect.LightenAmount);
  end;

  SharpEBar.UpdateSkin;
  Repaint;
end;

// Update the images which are holding the bar background

procedure TSharpBarMainForm.UpdateBGZone;
var
  BGBmp: TBitmap32;
  TempBmp: TBitmap32;
  Reg: TRegistry;
  wnd: hwnd;
  WinWallPath: string;
  WinWallColor: string;
  WinWallTile: string;
  WinWallStyle: string;
  n: integer;
  x, y: integer;
  R, G, B: integer;
  s: string;
  MLeft, MTop: integer;
begin
  if FSuspended then
    exit;
  if (FTopZone = nil) or (FBottomZone = nil) then
    exit;

  BGBmp := TBitmap32.Create;
  BGBmp.SetSize(MonList.Width, MonList.Height);
  BGBmp.Clear(color32(0, 0, 0, 255));
  try
    // check if SharpDesk is running
    wnd := FindWindow('TSharpDeskMainForm', nil);
    if wnd <> 0 then begin
      // First try to load the SharpDesk background image
      // if this fails then try to use PrintWindow on SharpDesk
      if not LoadBitmap32Shared(BGBmp,SharpApi.GetSharpeUserSettingsPath + 'SharpDeskbg.bmp',True) then 
        if @PrintWindow <> nil then
        begin
          // try 3 times... :)
          if not PrintWindow(wnd, BGBmp.Handle, 0) then begin
            sleep(750);
            if not PrintWindow(wnd, BGBmp.Handle, 0) then begin
              sleep(1500);
              if not PrintWindow(wnd, BGBmp.Handle, 0) then begin
              end;
            end;
          end;
        end
    end
    else begin
      // SharpDesk isn't running, load the windows background

      // Read the Windows Wallpaper settings
      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.Access := KEY_READ;
      if Reg.OpenKey('\Control Panel\Desktop\', False) then begin
        WinWallPath := Reg.ReadString('Wallpaper');
        WinWallStyle := Reg.ReadString('WallpaperStyle');
        WinWallTile := Reg.ReadString('TileWallpaper');
        Reg.CloseKey;
      end;
      if Reg.OpenKey('\Control Panel\Colors\', False) then begin
        WinWallColor := Reg.ReadString('Background');
        Reg.CloseKey;
      end;
      Reg.Free;

      // convert the windows color string to R G B colors
      s := '';
      R := -1;
      G := -1;
      B := -1;
      for n := 1 to length(WinWallColor) do begin
        if WinWallColor[n] <> ' ' then
          s := s + WinWallColor[n]
        else begin
          if R = -1 then
            R := strtoint(s)
          else if G = -1 then
            G := strtoint(s)
          else if B = -1 then
            B := strtoint(s);
          s := '';
        end;
      end;

      // Paint the Wallpaper
      BGBmp.Clear(color32(R, G, B, 255));
      TempBmp := TBitmap32.Create;
      if FileExists(WinWallPath) then
        if LoadBitmap32Shared(TempBmp,WinWallPath,True) then
        begin
          if WinWallTile = '1' then {// Tile Wallpaper}
          begin
            for x := 0 to BGBmp.Width div TempBmp.Width + 1 do
              for y := 0 to BGBmp.Height div TempBmp.Height + 1 do
                TempBmp.DrawTo(BGBmp, x * TempBmp.Width, y * TempBmp.Height);
          end;
        end
      else if WinWallStyle = '0' then // Center the Wallpaper
        TempBmp.DrawTo(BGBmp,
          BGBmp.Width div 2 - TempBmp.Width div 2,
          BGBmp.Height div 2 - TempBmp.Height div 2)
      else if WinWallStyle = '2' then // Scale
        TempBmp.DrawTo(BGBmp, Rect(0, 0, BGBmp.Width, BGBmp.Height));

      TempBmp.Free;
    end;

    // Some monitors have a position < 0 but the bitmap starts at 0...
    // need to calculate an offset
    MLeft := 0;
    MTop := 0;
    for n := 0 to MonList.MonitorCount - 1 do
      with MonList.Monitors[n] do begin
        if (Left < 0) and (Left < MLeft) then
          MLeft := Left;
        if (Top < 0) and (Top < MTop) then
          MTop := Top;
      end;
    MLeft := abs(MLeft);
    MTop := abs(MTop);

    // Update the images holding the top and bottom background image
    // (no need to hold the whole image, only the areas used by bars are of interest)
    FTopZone.SetSize(Monitor.Width, Height);
    FBottomZone.SetSize(Monitor.Width, Height);
    FTopZone.Draw(0, 0, Rect(Monitor.Left + MLeft,
      Monitor.Top + MTop,
      Monitor.Left + MLeft + Monitor.Width,
      Monitor.Top + MTop + Height), BGBmp);
    FBottomZone.Draw(0, 0, Rect(Monitor.Left + MLeft,
      Monitor.Top + MTop + Monitor.Height - Height,
      Monitor.Left + MLeft + Monitor.Width,
      Monitor.Top + MTop + Monitor.Height), BGBmp);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpBar','Failed to Update BG Zone', clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpBar',E.Message,clred, DMT_ERROR);
    end;
  end;
  BGBmp.Free;
  UpdateBGImage;
end;

procedure TSharpBarMainForm.UpdateMonitor;
var
  Mon : TMonitorItem;
begin
  Mon := MonList.MonitorFromWindow(Handle);
  if Mon <> nil then
    SharpEBar.MonitorIndex := MonList.GetMonitorIndex(Mon)
  else SharpEBar.MonitorIndex := 0;
end;

procedure TSharpBarMainForm.LoadBarModules(XMLElem: TJclSimpleXMlElem);
var
  n: integer;
begin
  if XMlElem = nil then
    exit;
  ModuleManager.DebugOutput('Loading Bar Modules', 1, 1);

  ModuleManager.UnloadModules;
  if XMLElem.Items.ItemNamed['Modules'] <> nil then
    with XMlElem.Items.ItemNamed['Modules'] do begin
      for n := 0 to Items.Count - 1 do begin
        ModuleManager.DebugOutput('Loading: ' + Items.Item[n].Items.Value('Module', '')
          + ' ID:' + Items.Item[n].Items.Value('ID', '-1')
          + ' Position:' + Items.Item[n].Items.Value('Position', '-1'), 2, 1);
        ModuleManager.LoadModule(Items.Item[n].Items.IntValue('ID', -1),
          Items.Item[n].Items.Value('Module', ''),
          Items.Item[n].Items.IntValue('Position', -1),
          -1);
      end;
    end;
  ModuleManager.ReCalculateModuleSize;
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

procedure TSharpBarMainForm.SaveBarSettings;
begin
  ModuleManager.SaveBarSettings;
end;

procedure TSharpBarMainForm.SaveBarTooltipSettings;
var
  xml: TJclSimpleXML;
  Dir: string;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';
  xml := TJclSimpleXMl.Create;
  try
    xml.Root.Name := 'SharpBar-Tooltips';

    // Save Bar Settings
    with xml.Root.Items.Add('Tooltips').Items do
    begin
      Add('FirstHide', FFirstHide);
      Add('FirstThrobberHide', FFirstThrobberHide);
    end;

    ForceDirectories(Dir);
    if not SaveXMLToSharedFile(XMl, Dir + 'Tooltips.xml',True) then
      SharpApi.SendDebugMessageEx('SharpBar',PChar('(SaveBarTooltipSettings): Error Saving Settings to ' + Dir + 'Tooltips.xml'), clred, DMT_ERROR);
  finally
    xml.Free;
  end;

  SharpApi.BroadcastGlobalUpdateMessage(suHelpTooltips);
end;

procedure TSharpBarMainForm.CreateNewBar;
var
  xml: TJclSimpleXML;
  Dir: string;
  n: integer;
  NewID: string;
begin
  ModuleManager.DebugOutput('Creating New Bar', 1, 1);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';
  xml := TJclSimpleXMl.Create;
  try
    xml.Root.Clear;
    xml.Root.Name := 'SharpBar';

    // Generate a new unique bar ID and make sure that there is no other
    // bar with the same ID
    repeat
      NewID := '';
      for n := 1 to 8 do
        NewID := NewID + inttostr(random(9) + 1);
    until not DirectoryExists(Dir + NewID);
    FBarID := strtoint(NewID);
    FBarInterface.BarID := FBarID;
    ModuleManager.BarID := FBarID;
    ForceDirectories(Dir + NewID);

    xml.Root.Items.Add('Settings');
    xml.Root.Items.Add('Modules');

    if not SaveXMLToSharedFile(xml,Dir + NewID + '\Bar.xml',True) then
      SharpApi.SendDebugMessageEx('SharpBar',PChar('(CreateNewBar): Error Saving Settings to ' + Dir + NewID + '\Bar.xml'), clred, DMT_ERROR);
  finally
    xml.Free;
  end;

  // New bar is now loaded!
  // Set window caption to SharpBar_ID
  self.Caption := 'SharpBar_' + inttostr(FBarID);

  UpdateBGZone;
end;

procedure TSharpBarMainForm.Custom1Click(Sender: TObject);
begin
  SharpCenterApi.CenterCommand(sccLoadSetting,
    PChar('Home'),
	  PChar('Toolbars'),
	  '');
end;

procedure TSharpBarMainForm.LoadBarTooltipSettings;
var
  xml : TJclSimpleXML;
  Dir : string;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\';

  // Check if the settings file exists
  if not FileExists(Dir + 'Tooltips.xml') then
    exit;

  xml := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(xml,Dir + 'Tooltips.xml',True) then
  begin
    with xml.root.Items do
      if ItemNamed['Tooltips'] <> nil then
        with ItemNamed['Tooltips'].Items do
        begin
          FFirstHide := BoolValue('FirstHide',True);
          FFirstThrobberHide := BoolValue('FirstThrobberHide', True);
        end;
  end else SharpApi.SendDebugMessageEx('SharpBar',PChar('(LoadBarTooltipSettings): Error loading '+ Dir + 'Tooltips.xml'), clred, DMT_ERROR);
  xml.Free;
end;

procedure TSharpBarMainForm.LoadBarFromID(ID: integer);
var
  xml: TJclSimpleXML;
  Dir: string;
  handle: THandle;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(ID) + '\';

  // Check if the settings file exists!
  if (not FileExists(Dir + 'Bar.xml')) or (ID = -1) then begin
    // No settings file == fist launch, no other bars!
    // Create new bar!
    FBarID := -1;
    ModuleManager.BarID := -1;
    FBarInterface.BarID := -1;
    CreateNewBar;
    exit;
  end;
  FBarID := ID;
  ModuleManager.BarID := ID;
  FBarInterface.BarID := ID;

  // There is a settings file and we have a Bar ID,
  // So let's check if the bar with this ID is already running
  // Bar Window Title : SharpBar_ID
  handle := FindWindow(nil, PChar('SharpBar_' + inttostr(ID)));
  if handle <> 0 then begin
    // A bar with this ID is already running!
    // Terminate App - we don't want to have two instances of one bar.
    // (would have ID == -1 if it was supposed to be a new and empty bar)
    Application.Terminate;
    exit;
  end;

  // Find and load settings file!
  xml := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(xml,Dir + 'Bar.xml') then
  begin
    // xml file loaded properlty... use it
    if xml.Root.Items.ItemNamed['Settings'] <> nil then
      with xml.Root.Items.ItemNamed['Settings'] do
      begin
        FBarName := Items.Value('Name', 'Toolbar');
        FFirstHide := Items.BoolValue('FirstHide',FFirstHide);
        SharpEBar.AutoPosition := Items.BoolValue('AutoPosition', True);
        SharpEBar.PrimaryMonitor := Items.BoolValue('PrimaryMonitor', True);
        SharpEBar.MonitorIndex := Items.IntValue('MonitorIndex', 0);
        SharpEBar.HorizPos := IntToHorizPos(Items.IntValue('HorizPos', 0));
        SharpEBar.VertPos := IntToVertPos(Items.IntValue('VertPos', 0));
        SharpEBar.AutoStart := Items.BoolValue('AutoStart', True);
        SharpEBar.ShowThrobber := Items.BoolValue('ShowThrobber', True);
        SharpEBar.DisableHideBar := Items.BoolValue('DisableHideBar', True);
        SharpEBar.StartHidden := Items.BoolValue('StartHidden', False);
        ModuleManager.ShowMiniThrobbers := Items.BoolValue('ShowMiniThrobbers', True);
        SharpEBar.AlwaysOnTop := Items.BoolValue('AlwaysOnTop', False);
        SharpEBar.ForceAlwaysOnTop := Items.BoolValue('ForceAlwaysOnTop', False);
        SharpEBar.FixedWidthEnabled := Items.BoolValue('FixedWidthEnabled', False);
        SharpEBar.FixedWidth := Max(10,Min(90,Items.IntValue('FixedWidth', 50)));
        SharpEBar.AutoHide := Items.BoolValue('AutoHide', False);
        SharpEBar.AutoHideTime := Items.IntValue('AutoHideTime', 1000);

        if SharpEBar.AutoHide then
          SharpEBar.AlwaysOnTop := True;

        ModuleManager.BarName := FBarName;
        // Set Main Window Title to SharpBar_ID!
        // The bar with the given ID is now loaded =)
        Caption := 'SharpBar_' + inttostr(ID);
      end;
    UpdateBGZone;
    LoadBarModules(xml.root);

    tmrCursorPos.Enabled := false;
    tmrAutoHide.Enabled := False;
    tmrAutoHide.Interval := SharpEBar.AutoHideTime;
  end
  else begin
    // file is damaged... try to reconstruct

  end;
  xml.Free;
end;

// Init all skin and module management classes

procedure TSharpBarMainForm.InitBar;
begin
  FBarName := 'Toolbar';

  FSkinInterface := TSharpESkinInterface.Create(self, ALL_SHARPE_SKINS);

  FSharpEBar := TSharpEBar.CreateRuntime(self, SkinInterface.SkinManager);
  FSharpEBar.AutoPosition := True;
  FSharpEBar.AutoStart := True;
  FSharpEBar.AutoHide := False;
  FSharpEBar.AutoHideTime := 1000;
  FSharpEBar.DisableHideBar := True;
  FSharpEBar.StartHidden := False;
  FSharpEBar.HorizPos := hpMiddle;
  FSharpEBar.MonitorIndex := 0;
  FSharpEBar.PrimaryMonitor := True;
  FSharpEBar.ShowThrobber := True;
  FSharpEBar.VertPos := vpTop;
  FSharpEBar.onThrobberMouseDown := SharpEBar1ThrobberMouseDown;
  FSharpEBar.onThrobberMouseUp := SharpEBar1ThrobberMouseUp;
  FSharpEBar.onThrobberMouseMove := SharpEBar1ThrobberMouseMove;
  FSharpEBar.onResetSize := SharpEBar1ResetSize;
  FSharpEBar.onBackgroundPaint := OnBackgroundPaint;

  SharpEBar.SkinManager := SkinInterface.SkinManager;

  FBottomZone := TBitmap32.Create;
  FTopZone := TBitmap32.Create;
  FBGImage := TBitmap32.Create;
  //  SharpEBar.Throbber.SpecialBackground := FBGImage;

  FStartup := True;

  FFirstHide := True;
  FFirstThrobberHide := True;
  LoadBarTooltipSettings;

  randomize;

  // Create and Initialize the module manager
  // (Make sure the Skin Manager and Module Settings are ready before doing this!)
  FBarInterface := TSharpBarInterface.Create;
  FBarInterface.BarWnd := Handle;

  ModuleManager := TModuleManager.Create(Handle, SkinInterface, FBarInterface, SharpEBar);
  FBarInterface.ModuleManager := ModuleManager;
  
  ModuleManager.DebugOutput('Created Module Manager', 2, 1);
  
  ModuleManager.ThrobberMenu := ThrobberPopUp;
  ModuleManager.DebugOutput('Loading Modules from Directory: ' + ExtractFileDir(Application.ExeName) + '\Modules\', 2, 1);
  ModuleManager.LoadFromDirectory(ExtractFileDir(Application.ExeName) + '\Modules\');

  SharpEBar.onPositionUpdate := OnBarPositionUpdate;

  BarHideForm := TBarHideForm.Create(self);

  //DelayTimer2.Enabled := True;

  UpdateBGZone;
  SkinInterface.SkinManager.UpdateSkin;
  SharpEBar.Seed := -1;
  SharpEBar.UpdateSkin;
  if SharpEBar.Throbber.Visible then
    SharpEBar.Throbber.UpdateSkin;

  // Initialize the bar content
  // ID > 0 try load from xml
  // ID = -1 new bar
  if mfParamID <> -255 then begin
    SharpBarMainForm.LoadBarFromID(mfParamID);
    mfParamID := -255;
  end;

  SharpApi.RegisterActionEx(PChar('!FocusBar (' + inttostr(FBarID) + ')'), 'SharpBar', Handle, 1);
  SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));
end;

procedure TSharpBarMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Params.WinClassName := 'TSharpBarMainForm';
    ExStyle := WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW or WS_EX_TOPMOST; 
    Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
  end;
end;

procedure TSharpBarMainForm.FormCreate(Sender: TObject);
begin
  ModuleManager.DebugOutput('Setting Form properties', 2, 1);

  foregroundWindowIsFullscreen := False;
  Closing := False;
  DoubleBuffered := True;
  GetCurrentTheme.LoadTheme([tpSkinScheme, tpIconSet, tpSkinFont]);

  FUser32DllHandle := LoadLibrary('user32.dll');
  if FUser32DllHandle <> 0 then
    @PrintWindow := GetProcAddress(FUser32DllHandle, 'PrintWindow');

  FSuspended := False;
  FShellBCInProgress := False;

  KeyPreview := true;

  FDragging := false;

  // Register for notifications of this session (0), 1 = all sessions.
  FRegisteredSessionNotification := RegisterSessionNotification(Handle, 0);

  ShowWindow(Handle, SW_HIDE);
end;

procedure TSharpBarMainForm.FormDestroy(Sender: TObject);
begin
  if FRegisteredSessionNotification then
    UnRegisterSesssionNotification(Handle);

  FreeLibrary(FUser32DllHandle);
  FUser32DllHandle := 0;
  @PrintWindow := nil;

  SetLayeredWindowAttributes(Handle, 0, 0, LWA_ALPHA);
  SharpEBar.abackground.Alpha := 0;

  SharpApi.UnRegisterAction(PChar('!FocusBar (' + inttostr(FBarID) + ')'));  

  if BarHideForm <> nil then begin
    if BarHideForm.Visible then
      BarHideForm.Close;
    FreeAndNil(BarHideForm);
  end;

  ModuleManager.Free;
  ModuleManager := nil;

  FSharpEBar.Free;
  FSharpEBar := nil;

  FSkinInterface := nil;
  FBarInterface := nil;

  FBottomZone.Free;
  FTopZone.Free;
  FBGImage.Free;
end;

procedure TSharpBarMainForm.Top1Click(Sender: TObject);
begin
  SharpEBar.VertPos := vpTop;
  UpdateBGImage;
  SharpEBar.UpdateSkin;
  SaveBarSettings;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.FixModulePositions;
  ModuleManager.BroadcastPluginUpdate(suBackground);
end;

procedure TSharpBarMainForm.BarManagment1Click(Sender: TObject);
begin
  SharpCenterApi.CenterCommand(sccLoadSetting,
    PChar('Home'),
	  PChar('Toolbars'),
	  '');
end;

procedure TSharpBarMainForm.Bottom1Click(Sender: TObject);
begin
  SharpEBar.VertPos := vpBottom;
  UpdateBGImage;
  SharpEBar.UpdateSkin;
  SaveBarSettings;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.FixModulePositions;
  ModuleManager.BroadcastPluginUpdate(suBackground);
end;

procedure TSharpBarMainForm.LaunchSharpCenter1Click(Sender: TObject);
begin
  SharpExecute('SharpCenter.exe');
end;

procedure TSharpBarMainForm.Left1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpLeft;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.FixModulePositions;
  SaveBarSettings;

  SharpApi.BroadcastGlobalUpdateMessage(suCenter);
end;

procedure TSharpBarMainForm.Middle1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpMiddle;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.FixModulePositions;
  SaveBarSettings;

  SharpApi.BroadcastGlobalUpdateMessage(suCenter);
end;

procedure TSharpBarMainForm.Right1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpRight;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.FixModulePositions;
  SaveBarSettings;

  SharpApi.BroadcastGlobalUpdateMessage(suCenter);
end;

procedure TSharpBarMainForm.OnMonitorPopupItemClick(Sender: TObject);
var
  index: integer;
begin
  index := StrToIntDef(TMenuItem(Sender).Hint,0);
  if index > MonList.MonitorCount - 1 then
    exit;
  if MonList.Monitors[index] = MonList.PrimaryMonitor then
    SharpEBar.PrimaryMonitor := True
  else begin
    SharpEbar.PrimaryMonitor := False;
    SharpEBar.MonitorIndex := index;
  end;
  UpdateBGZone;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.EnabledFixedSize1Click(Sender: TObject);
begin
  EnabledFixedSize1.Checked := not EnabledFixedSize1.Checked;
  SharpEBar.FixedWidthEnabled := EnabledFixedSize1.Checked;
  FixedWidth1.Checked := EnabledFixedSize1.Checked;
  N501.Enabled := EnabledFixedSize1.Checked;
  N502.Enabled := EnabledFixedSize1.Checked;
  N401.Enabled := EnabledFixedSize1.Checked;
  N301.Enabled := EnabledFixedSize1.Checked;
  N201.Enabled := EnabledFixedSize1.Checked;
  if EnabledFixedSize1.Checked and (SharpEBar.HorizPos = hpFull) then
    SharpEBar.HorizPos := hpMiddle;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.ReCalculateModuleSize(True,True);
  SaveBarSettings;
end;

procedure TSharpBarMainForm.ExitMnClick(Sender: TObject);
begin
  SaveBarSettings;
  Application.Terminate;
  //Close;
end;

procedure TSharpBarMainForm.FullScreen1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpFull;
  SharpEBar.FixedWidthEnabled := False;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.FullscreenCheckTimerTimer(Sender: TObject);
var
  wnd : HWND;
  wndRect : TRect;
  mon : TMonitorItem;
  wndClass : array[0..255] of Char;
  style : Integer;
begin
  if FSuspended then
    Exit;
    
  if ((SharpEBar.AlwaysOnTop) or (foregroundWindowIsFullscreen)) then
  begin
    wnd := GetForegroundWindow;
    if (GetParent(wnd) <> 0) then
      wnd := GetParent(wnd);

    if (wnd <> 0) and (wnd <> Handle) then
    begin
      GetClassName(wnd, wndClass, SizeOf(wndClass));

      // The desktops are fullscreen so check for them and exit if it is the foreground window.
      if (CompareText(wndClass, 'Progman') = 0) or
        (CompareText(wndClass, 'TSharpDeskMainForm') = 0) then
        Exit;

      GetWindowRect(wnd, wndRect);
      if not MonList.IsValidMonitorIndex(SharpEBar.MonitorIndex) then
        UpdateMonitor;

      mon := MonList.Monitors[SharpEBar.MonitorIndex];
      // If the window is on the same monitor as the bar then check if it is fullscreen.
      if MonList.MonitorFromRect(wndRect).MonitorNum = mon.MonitorNum then
      begin
        style := GetWindowLong(wnd, GWL_STYLE);
        if (wndRect.Bottom - wndRect.Top >= mon.Height) and
          (wndRect.Right - wndRect.Left >= mon.Width) and
          ((style and WS_BORDER) <> WS_BORDER) and
          (not SharpEBar.ForceAlwaysOnTop) then
        begin
          if SharpEBar.AutoHide then
            HideBar;

          // The window is fullscreen so disable always on top.
          SharpEBar.AlwaysOnTop := False;
          foregroundWindowIsFullscreen := True;

          // Now bring the fullscreen window to the top in front of the bar.
          BringWindowToTop(wnd);
        end
        else if (not SharpEBar.AlwaysOnTop) then
        begin
          // The window is no longer fullscreen so make sure we change our settings back.
          // If the window was never fullscreen we'll also hit here which is ok.
          SharpEBar.AlwaysOnTop := True;
          foregroundWindowIsFullscreen := False;
        end;
      end;
    end;
  end;
end;

procedure TSharpBarMainForm.OnQuickAddModuleItemClick(Sender: TObject);
var
  i: integer;
  tempModule: TModule;
  s : string;
begin
  if not (Sender is TMenuItem) then
    exit;
  i := TMenuItem(Sender).Tag;
  tempModule := ModuleManager.CreateModule(i, -1);
  ModuleManager.FixModulePositions;
  SaveBarSettings;

  SharpApi.BroadcastGlobalUpdateMessage(suCenter);

  if tempModule = nil then
    exit;

  s := ExtractFileName(tempModule.ModuleFile.FileName);
  setlength(s, length(s) - length(ExtractFileExt(s)));

 SharpCenterApi.CenterCommand(sccLoadSetting,
    PChar('Modules'),
	  PChar(s),
    PChar(inttostr(FBarID) + ':' + inttostr(tempModule.mInterface.ID)));

end;

procedure TSharpBarMainForm.PopupMenu1Popup(Sender: TObject);
var
  n: integer;
  item: TMenuItem;
  mfile: TModuleFile;
  s: string;
  sr: TSearchRec;
  Dir: string;
  Theme : ISharpETheme;
begin
  Theme := GetCurrentTheme;

  // Build Monitor List
  Monitor1.Clear;
  for n := 0 to MonList.MonitorCount - 1 do begin
    item := TMenuItem.Create(Monitor1);
    item.GroupIndex := 1;
    item.RadioItem := true;
    item.Caption := inttostr(n);

    if MonList.Monitors[n] = MonList.PrimaryMonitor then
      item.Caption := inttostr(n) + ' (Primary)';

    if n = SharpEBar.MonitorIndex then
      item.Checked := True;

    item.Hint := inttostr(n);
    item.OnClick := OnMonitorPopupItemClick;
    Monitor1.Add(item);
  end;

  // Build Module List
  QuickAddModule1.Clear;
  ModuleManager.RefreshFromDirectory(ModuleManager.ModuleDirectory);
  for n := 0 to ModuleManager.ModuleFiles.Count - 1 do begin
    mfile := TModuleFile(ModuleManager.ModuleFiles.Items[n]);
    item := TMenuItem.Create(Monitor1);

    s := ExtractFileName(mfile.FileName);
    setlength(s, length(s) - length(ExtractFileExt(s)));
    item.Caption := s;
    item.Tag := n;
    item.ImageIndex := 1;
    item.OnClick := OnQuickAddModuleItemClick;
    QuickAdDModule1.Add(item);
  end;

  AutoStart1.Checked := SharpEBar.AutoStart;
  DisableBarHiding1.Checked := SharpEBar.DisableHideBar;
  ShowMiniThrobbers1.Checked := ModuleManager.ShowMiniThrobbers;
  AlwaysOnTop1.Checked := SharpEBar.AlwaysOnTop;
  ForceAlwaysOnTop1.Enabled := AlwaysOnTop1.Checked;
  if AlwaysOnTop1.Checked then
    ForceAlwaysOnTop1.Checked := SharpEBar.ForceAlwaysOnTop;

  // Build Skin List
  Skin1.Clear;
  Dir := SharpApi.GetSharpeDirectory + 'Skins\';
  if FindFirst(Dir + '*.*', FADirectory, sr) = 0 then
    repeat
      if (CompareText(sr.Name, '.') <> 0) and (CompareText(sr.Name, '..') <> 0) then begin
        if FileExists(Dir + sr.Name + '\Skin.xml') then begin
          item := TMenuItem.Create(Skin1);
          item.GroupIndex := 1;
          item.Checked := False;
          item.Caption := sr.Name;
          item.RadioItem := true;

          if CompareText(sr.Name,Theme.Skin.Name) = 0 then
            item.Checked := True;

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

  n := 0;

  Dir := SharpApi.GetSharpeUserSettingsPath + uThemeConsts.SKINS_SCHEME_DIRECTORY + '\' + Theme.Skin.Name + '\';
  if FindFirst(Dir + '*.xml', FAAnyFile, sr) = 0 then
  begin
    repeat
      s := sr.Name;
      setlength(s, length(s) - length('.xml'));

      item := TMenuItem.Create(ColorScheme1);
      item.GroupIndex := 1;
      item.Caption := s;
      item.Checked := false;
      item.RadioItem := true;

      if s = Theme.Scheme.Name then
        item.Checked := True;

      item.Hint := sr.Name;
      item.OnClick := OnSchemeSelectItemClick;
      ColorScheme1.Add(item);

      n := n + 1;
    until FindNext(sr) <> 0;
  end;
  
  FindClose(sr);

  if n <= 0 then
    ColorScheme1.Enabled := False;

  case SharpEBar.VertPos of
    vpTop: Top1.Checked := True;
    vpBottom: Bottom1.Checked := True;
  end;

  case SharpEBar.HorizPos of
    hpLeft: Left1.Checked := True;
    hpMiddle: Middle1.Checked := True;
    hpRight: Right1.Checked := True;
    hpFull: FullScreen1.Checked := True;
  end;

  FixedWidth1.Checked := False;
  EnabledFixedSize1.Checked := False;  
  if SharpEBar.FixedWidthEnabled then
  begin
    FixedWidth1.Checked := True;
    EnabledFixedSize1.Checked := True;
    FullScreen1.Checked := False;
    N501.Enabled := True;
    N502.Enabled := True;
    N401.Enabled := True;
    N301.Enabled := True;
    N201.Enabled := True;
  end else
  begin
    N501.Enabled := False;
    N502.Enabled := False;
    N401.Enabled := False;
    N301.Enabled := False;
    N201.Enabled := False;
  end;

  N501.Checked := False;
  N502.Checked := False;
  N401.Checked := False;
  N301.Checked := False;
  N201.Checked := False;
  if SharpEBar.FixedWidth = 75 then
    N501.Checked := True
  else if SharpEBar.FixedWidth = 50 then
    N502.Checked := True
  else if SharpEBar.FixedWidth = 40 then
    N401.Checked := True
  else if SharpEBar.FixedWidth = 30 then
    N301.Checked := True
  else if SharpEBar.FixedWidth = 20 then
    N201.Checked := True
  else Custom1.Checked := True;       
end;

procedure TSharpBarMainForm.OnSchemeSelectItemClick(Sender: TObject);
var
  s: string;
  Theme : ISharpETheme;
begin
  Theme := GetCurrentTheme;
  s := TMenuItem(Sender).Hint;
  setlength(s, length(s) - length('.xml'));
  Theme.Scheme.Name := s;
  Theme.Scheme.SaveToFile;
  SharpApi.BroadcastGlobalUpdateMessage(suSkin);
end;

procedure TSharpBarMainForm.OnSkinSelectItemClick(Sender: TObject);
var
  NewSkin, SkinDir: string;
  sr: TSearchRec;
  Theme : ISharpETheme;
  s: string;
begin
  NewSkin := TMenuItem(Sender).Hint;
  SkinDir := SharpApi.GetSharpeDirectory + 'Skins\' + NewSkin + '\';

  Theme := GetCurrentTheme;  
  Theme.Skin.Name := NewSkin;
  Theme.Skin.SaveToFileSkinAndGlass;

  if FindFirst(SkinDir + 'Schemes\*.xml', FAAnyFile, sr) = 0 then
  begin
    s := sr.Name;
    setlength(s, length(s) - length('.xml'));
    Theme.Scheme.Name := s;
    Theme.Scheme.SaveToFile;
  end;
  FindClose(sr);
  SharpApi.BroadcastGlobalUpdateMessage(suSkin);
end;

procedure TSharpBarMainForm.SharpEBar1ResetSize(Sender: TObject);
begin
  if FSuspended then
    exit;
  ModuleManager.FixModulePositions;
end;

procedure TSharpBarMainForm.PluginManager1Click(Sender: TObject);
begin
  SharpCenterApi.CenterCommand(sccLoadSetting,
    PChar('Components'),
	  PChar('BarEdit'),
    PChar(inttostr(FBarID)));
end;

procedure TSharpBarMainForm.AutoStart1Click(Sender: TObject);
begin
  AutoStart1.Checked := not AutoStart1.Checked;
  SharpEBar.AutoStart := AutoStart1.Checked;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  if FSuspended then
    exit;

  if BarHideForm <> nil then
    BarHideForm.UpdateStatus;

  ModuleManager.RefreshMiniThrobbers;

  if (SharpEBar.AutoHide) and (not tmrAutoHide.Enabled) then
    tmrAutoHide.Enabled := True;
    
  tmrCursorPos.Enabled := SharpEBar.AutoHide;
end;

function PointInRect(P: TPoint; Rect: TRect): boolean;
begin
  if (P.X >= Rect.Left) and (P.X <= Rect.Right)
    and (P.Y >= Rect.Top) and (P.Y <= Rect.Bottom) then
    PointInRect := True
  else
    PointInRect := False;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  n: integer;
  P: TPoint;
  Mon: integer;
  R: TRect;
  oVP: TSharpEBarVertPos;
  oHP: TSharpEBarHorizPos;
  oMon: integer;
  oPMon: boolean;
begin
  if FSuspended then
    exit;

  if not GetCursorPosSecure(P) then
    exit;

  if Shift = [ssLeft] then begin
    if not BarMove then begin
      // Make sure the mouse was moved more than a few pixels before starting the move bar code
      if (abs(BarMovePoint.X - X) > 64)
        or (abs(BarMovePoint.Y - Y) > 64) then
        BarMove := True
      else
        exit;
    end;
    if BarMove then begin
      oVP := SharpEBar.VertPos;
      oHP := SharpEBar.HorizPos;
      oMon := SharpEBar.MonitorIndex;
      oPMon := SharpEbar.PrimaryMonitor;
      for n := 0 to MonList.MonitorCount - 1 do begin
        if MonList.Monitors[n] = MonList.PrimaryMonitor then
          Mon := -1
        else
          Mon := n;

        // Special Movement Code if Full Align
        if SharpEBar.HorizPos = hpFull then begin
          // Top
          R.Left := MonList.Monitors[n].Left;
          R.Right := R.Left + MonList.Monitors[n].Width;
          R.Top := MonList.Monitors[n].Top;
          R.Bottom := R.Top + 64;
          if PointInRect(P, R) then begin
            if Mon = -1 then
              SharpEBar.PrimaryMonitor := True
            else begin
              SharpEBar.PrimaryMonitor := False;
              SharpEBar.MonitorIndex := Mon;
            end;
            SharpEBar.HorizPos := hpFull;
            SharpEBar.VertPos := vpTop;
          end;

          // Bottom
          R.Top := MonList.Monitors[n].Top + MonList.Monitors[n].Height - 64;
          R.Bottom := R.Top + 64;
          if PointInRect(P, R) then begin
            if Mon = -1 then
              SharpEBar.PrimaryMonitor := True
            else begin
              SharpEBar.PrimaryMonitor := False;
              SharpEBar.MonitorIndex := Mon;
            end;
            SharpEBar.HorizPos := hpFull;
            SharpEBar.VertPos := vpBottom;
          end;
          Continue;
        end;

        // Compact Movement Code
        // Top Left
        R.Left := MonList.Monitors[n].Left;
        R.Top := MonList.Monitors[n].Top;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P, R) then begin
          if Mon = -1 then
            SharpEBar.PrimaryMonitor := True
          else begin
            SharpEBar.PrimaryMonitor := False;
            SharpEBar.MonitorIndex := Mon;
          end;
          SharpEBar.HorizPos := hpLeft;
          SharpEBar.VertPos := vpTop;
        end;

        // Top Middle
        R.Left := MonList.Monitors[n].Left + MonList.Monitors[n].Width div 2 - 128;
        R.Top := MonList.Monitors[n].Top;
        R.Right := R.Left + 128;
        R.Bottom := R.Top + 64;
        if PointInRect(P, R) then begin
          if Mon = -1 then
            SharpEBar.PrimaryMonitor := True
          else begin
            SharpEBar.PrimaryMonitor := False;
            SharpEBar.MonitorIndex := Mon;
          end;
          SharpEBar.HorizPos := hpMiddle;
          SharpEBar.VertPos := vpTop;
        end;

        // Top Right
        R.Left := MonList.Monitors[n].Left + MonList.Monitors[n].Width - 256;
        R.Top := MonList.Monitors[n].Top;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P, R) then begin
          if Mon = -1 then
            SharpEBar.PrimaryMonitor := True
          else begin
            SharpEBar.PrimaryMonitor := False;
            SharpEBar.MonitorIndex := Mon;
          end;
          SharpEBar.HorizPos := hpRight;
          SharpEBar.VertPos := vpTop;
        end;

        // Bottom Left
        R.Left := MonList.Monitors[n].Left;
        R.Top := MonList.Monitors[n].Top + MonList.Monitors[n].Height - 64;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P, R) then begin
          if Mon = -1 then
            SharpEBar.PrimaryMonitor := True
          else begin
            SharpEBar.PrimaryMonitor := False;
            SharpEBar.MonitorIndex := Mon;
          end;
          SharpEBar.HorizPos := hpLeft;
          SharpEBar.VertPos := vpBottom;
        end;

        // Bottom Middle
        R.Left := MonList.Monitors[n].Left + MonList.Monitors[n].Width div 2 - 128;
        R.Top := MonList.Monitors[n].Top + MonList.Monitors[n].Height - 64;
        R.Right := R.Left + 128;
        R.Bottom := R.Top + 64;
        if PointInRect(P, R) then begin
          if Mon = -1 then
            SharpEBar.PrimaryMonitor := True
          else begin
            SharpEBar.PrimaryMonitor := False;
            SharpEBar.MonitorIndex := Mon;
          end;
          SharpEBar.HorizPos := hpMiddle;
          SharpEBar.VertPos := vpBottom;
        end;

        // Bottom Right
        R.Left := MonList.Monitors[n].Left + MonList.Monitors[n].Width - 256;
        R.Top := MonList.Monitors[n].Top + MonList.Monitors[n].Height - 64;
        R.Right := R.Left + 256;
        R.Bottom := R.Top + 64;
        if PointInRect(P, R) then begin
          if Mon = -1 then
            SharpEBar.PrimaryMonitor := True
          else begin
            SharpEBar.PrimaryMonitor := False;
            SharpEBar.MonitorIndex := Mon;
          end;
          SharpEBar.HorizPos := hpRight;
          SharpEBar.VertPos := vpBottom;
        end;
      end;
      if (oMon <> SharpEBar.MonitorIndex) or (oPMon <> SharpEBar.PrimaryMonitor) then begin
        UpdateBGZone;
        SharpEBar.UpdateSkin;
        ModuleManager.ReCalculateModuleSize;
        ModuleManager.FixModulePositions;
        ModuleManager.RefreshMiniThrobbers;
        ModuleManager.BroadcastPluginUpdate(suBackground, -2);
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
      end;
      if oVP <> SharpEBar.VertPos then begin
        UpdateBGImage;
        SharpEBar.UpdateSkin;
        ModuleManager.FixModulePositions;
        ModuleManager.BroadcastPluginUpdate(suBackground, -2);
        ModuleManager.RefreshMiniThrobbers;
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
        SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
      end;
      if oHP <> SharpEBar.HorizPos then begin
        SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
        {        UpdateBGImage;
                ModuleManager.FixModulePositions;
                ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND,-2);
                ModuleManager.RefreshMiniThrobbers;
                RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);}
      end;
    end;
    if BarHideForm <> nil then
      BarHideForm.UpdateStatus;

  end;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
begin
  if (Button = mbLeft) and (not BarMove) then
  begin
    p := ClientToScreen(Point(Left, Top));

    // Get the cordinates on the screen where the popup should appear.
    p := ClientToScreen(Point(0, Self.Height));
    if p.Y > Monitor.Top + Monitor.Height div 2 then
      p.Y := p.Y - Self.Height;

    PopUpMenu1.Popup(p.X, p.Y);
  end else if BarMove then
    SaveBarSettings;
  BarMove := False;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    BarMovePoint := Point(X, Y)
  else
    BarMove := False;
end;

procedure TSharpBarMainForm.HideBar;
begin
  if (Visible) and (SharpEBar.DisableHideBar) and (not SharpEBar.AutoHide) then
    exit;

  if (SharpEbar.VertPos = vpBottom) then
  begin
    BarHideForm.Left := Left;
    BarHideForm.Width := Width;
    BarHideForm.Height := 1;
    BarHideForm.Top := Top + Height - 1;
    ShowWindow(SharpEBar.abackground.Handle, SW_HIDE);
    SharpBarMainForm.Hide;
    BarHideForm.Show;
    SharpApi.ServiceMsg('Shell', 'DeskAreaUpdate');
  end else if (SharpEBar.VertPos = vpTop) then
  begin
    BarHideForm.Left := Left;
    BarHideForm.Width := Width;
    BarHideForm.Height := 1;
    BarHideForm.Top := Top;
    ShowWindow(SharpEBar.abackground.Handle, SW_HIDE);
    SharpBarMainForm.Hide;
    BarHideForm.Show;
    SharpApi.ServiceMsg('Shell', 'DeskAreaUpdate');
  end;

  // Display a Tooltop if bar was hidden for the first time
  if (FFirstHide) then
  begin
    ShowNotify('The SharpBar is now invisible because you left clicked the screen border. You can show the SharpBar again by left clicking the screen border another time.',True);
    FFirstHide := False;
    SaveBarTooltipSettings;
  end;
end;

procedure TSharpBarMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (SharpEBar.DisableHideBar) or (SharpEBar.AutoHide) then
    exit;

  if (Button = mbLeft) and (Self.Cursor = crSizeNS) and (not FDragging) then
    FDragging := true;
end;

procedure TSharpBarMainForm.FormMouseLeave(Sender: TObject);
var
  pt : TPoint;
begin
  FDragging := False;
  Self.Cursor := crDefault;

  // Start auto-hide
  GetCursorPos(pt);
  StartAutoHide(WindowFromPoint(pt));
end;

procedure TSharpBarMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (SharpEBar.DisableHideBar) or (SharpEBar.AutoHide) then
    exit;

  if (FDragging) and (((Y = 0) and (SharpBarMainForm.SharpEBar.VertPos = vpTop)) or
                      ((Y = Height - 1) and (SharpBarMainForm.SharpEBar.VertPos = vpBottom)))
  then
  begin
    HideBar;
    FDragging := False;
  end;

  if (FDragging) or
      (((Y < 5) and (SharpBarMainForm.SharpEBar.VertPos = vpBottom)) or
      ((Y >= Self.Height - 5) and (SharpBarMainForm.SharpEBar.VertPos = vpTop)))
  then
    Self.Cursor := crSizeNS
  else
    Self.Cursor := crDefault;
end;

procedure TSharpBarMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    if (Y = Height - 1) and (SharpEBar.VertPos = vpBottom)
      or (Y = 0) and (SharpEBar.VertPos = vpTop) then begin
      if ssShift in Shift then begin
        // Toggle Mini Throbbers
        ModuleManager.ShowMiniThrobbers := not ModuleManager.ShowMiniThrobbers;
        ModuleManager.ReCalculateModuleSize;
        SharpEBar.Throbber.Repaint;
      end
      else begin
        // Toggle Main Throbber
        if ModuleManager.Modules.Count = 0 then begin
          SharpEBar.ShowThrobber := True;
          exit;
        end;
        SharpEBar.ShowThrobber := not SharpEBar.ShowThrobber;
        ModuleManager.ReCalculateModuleSize;
        if SharpEBar.ShowThrobber then
          SharpEBar.Throbber.Repaint;

        // Display a tooltip if throbber was hidden for the first time
        if not SharpEBar.ShowThrobber and FirstThrobberHide then
        begin
          ShowNotify('The Main Button of the SharpBar was disabled because you right clicked the screen border. You can show the Button again by right clicking the screen border another time.',False);
          FirstThrobberHide := False;
          SaveBarTooltipSettings;
        end;
      end;
    end;
end;

procedure TSharpBarMainForm.FormPaint(Sender: TObject);
begin
  if Visible and SharpEBar.StartHidden then
  begin
    HideBar;
    SharpEBar.StartHidden := False;
  end;
end;

procedure TSharpBarMainForm.SettingsClick(Sender: TObject);
var
  mThrobber: TSharpEMiniThrobber;
  tempModule: TModule;
  s: string;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then
    exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then
    exit;

  s := ExtractFileName(tempModule.ModuleFile.FileName);
  setlength(s, length(s) - length(ExtractFileExt(s)));

  SharpCenterApi.CenterCommand(sccLoadSetting,
    PChar('Modules'),
	  PChar(s),
    PChar(inttostr(FBarID) + ':' + inttostr(tempModule.mInterface.ID)));
end;

procedure TSharpBarMainForm.Delete1Click(Sender: TObject);
var
  mThrobber: TSharpEMiniThrobber;
begin
  if FSuspended then
    exit;
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then
    exit;
  if MessageBox(Application.handle, 'Do you really want to remove this module? All settings will be lost!', 'Confirm : "Remove Module"', MB_YESNO) = IDYES then begin
    ModuleManager.Delete(mThrobber.Tag);
    SaveBarSettings;
    ModuleManager.ReCalculateModuleSize;
    SharpApi.BroadcastGlobalUpdateMessage(suCenter);
  end;
end;

procedure TSharpBarMainForm.miLeftModuleClick(Sender: TObject);
var
  mThrobber: TSharpEMiniThrobber;
  tempModule: TModule;
  ri: integer;
  index: integer;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then
    exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then
    exit;
  ri := ModuleManager.GetFirstRModuleIndex;
  index := ModuleManager.Modules.IndexOf(tempModule);
  if (ri = index) and (SharpEbar.HorizPos <> hpFull) then
    ModuleManager.MoveModule(index, -1);
  ModuleManager.MoveModule(index, -1);
  ModuleManager.SortModulesByPosition;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.miRightModuleClick(Sender: TObject);
var
  mThrobber: TSharpEMiniThrobber;
  tempModule: TModule;
  ri, index: integer;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then
    exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then
    exit;
  ri := ModuleManager.GetFirstRModuleIndex;
  index := ModuleManager.Modules.IndexOf(tempModule);
  if (ri = index + 1) and (SharpEbar.HorizPos <> hpFull) then
    ModuleManager.MoveModule(index, 1);
  ModuleManager.MoveModule(index, 1);
  ModuleManager.SortModulesByPosition;
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.N501Click(Sender: TObject);
begin
  SharpEBar.FixedWidth := TMenuItem(Sender).Tag;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH, 0, 0);
  ModuleManager.ReCalculateModuleSize(True,True);
  SaveBarSettings;
end;

procedure TSharpBarMainForm.DisableBarHiding1Click(Sender: TObject);
begin
  DisableBarHiding1.Checked := not DisableBarHiding1.Checked;
  SharpEBar.DisableHideBar := DisableBarHiding1.Checked;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.FormResize(Sender: TObject);
begin
  if FSuspended then
    exit;
  if BarHideForm <> nil then
    BarHideForm.UpdateStatus;
end;

procedure TSharpBarMainForm.FormHide(Sender: TObject);
begin
  if FSuspended then
    exit;

  if BarHideForm <> nil then
    BarHideForm.UpdateStatus; 
end;

procedure TSharpBarMainForm.OnBarPositionUpdate(Sender: TObject; var X, Y: Integer);
var
  Mon: TMonitorItem;
begin
  if FSuspended then
    exit;
  if BarHideForm <> nil then
    BarHideForm.UpdateStatus;

  if SharpEBar.HorizPos = hpMiddle then begin
    if (SharpEBar.MonitorIndex > (MonList.MonitorCount - 1)) or (SharpEBar.PrimaryMonitor) then
      Mon := MonList.PrimaryMonitor
    else
    begin
      if not MonList.IsValidMonitorIndex(SharpEBar.MonitorIndex) then
        UpdateMonitor;
        
      Mon := MonList.Monitors[SharpEBar.MonitorIndex];
    end;
    if Mon <> nil then begin
      if x < Mon.Left then
        x := Mon.Left;
      if Width > Mon.Width then
        Width := Mon.Width;
    end;
  end;

  //  UpdateBGImage;
  ModuleManager.BroadcastPluginUpdate(suBackground, -2);
end;

procedure TSharpBarMainForm.DelayTimer1Timer(Sender: TObject);
begin
  DelayTimer1.Enabled := False;
  SendMessage(Handle, WM_DESKBACKGROUNDCHANGED, 0, 0);
end;

procedure TSharpBarMainForm.DelayTimer3Timer(Sender: TObject);
begin
  DelayTimer3.Enabled := False;
  if FSuspended then
    exit;

  if BarHideForm.Visible then begin
    if SharpEBar.SpecialHideForm then
      BarHideForm.UpdateStatus
    else
      BarHideForm.Close;
  end;
  SharpEBar.UpdatePosition;
  ModuleManager.BroadCastModuleRefresh;
  ModuleManager.FixModulePositions;
end;

procedure TSharpBarMainForm.Clone1Click(Sender: TObject);
var
  mThrobber: TSharpEMiniThrobber;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then
    exit;
  ModuleManager.Clone(mThrobber.Tag);
  SaveBarSettings;
  ModuleManager.ReCalculateModuleSize;
end;

procedure TSharpBarMainForm.AlwaysOnTop1Click(Sender: TObject);
begin
  AlwaysOnTop1.Checked := not AlwaysOnTop1.Checked;
  SharpEBar.AlwaysOnTop := AlwaysOnTop1.Checked;
  if SharpEBar.AutoHide then
    SharpEBar.AlwaysOnTop := True;
  SaveBarSettings;

  ForceAlwaysOnTop1.Enabled := AlwaysOnTop1.Checked;
end;

procedure TSharpBarMainForm.ForceAlwaysOnTop1Click(Sender: TObject);
begin
  if not AlwaysOnTop1.Checked then
    exit;

  ForceAlwaysOnTop1.Checked := not ForceAlwaysOnTop1.Checked;
  SharpEBar.ForceAlwaysOnTop := ForceAlwaysOnTop1.Checked;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.FormActivate(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TSharpBarMainForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize := True;
end;

procedure TSharpBarMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Closing then
    exit;
    
  Closing := True;

  SaveBarSettings;
end;

procedure TSharpBarMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
end;

procedure TSharpBarMainForm.ThemeHideTimerTimer(Sender: TObject);
begin
  ThemeHideTimer.Enabled := False;
  SetLayeredWindowAttributes(Handle, 0, 255, LWA_ALPHA);
  SetLayeredWindowAttributes(Handle, RGB(255, 0, 254), 255, LWA_COLORKEY);
  SharpEBar.abackground.Alpha := 255;
end;

procedure TSharpBarMainForm.tmrAutoHideTimer(Sender: TObject);
begin
  tmrAutoHide.Enabled := False;
  HideBar;
end;

procedure TSharpBarMainForm.StartAutoHide(wnd : HWND);
var
  className : array [0..256] of Char;
begin
  if wnd = 0 then
    wnd := GetForegroundWindow;
    
  while GetParent(wnd) <> 0 do
    wnd := GetParent(wnd);

  GetClassName(wnd, className, sizeof(className));
  SharpApi.SendDebugMessage('SharpBar', className, 0);
  // Don't hide if a menu is the foreground window
  if (CompareText(className, 'TSharpEMenuWnd') <> 0) and (CompareText(className, 'TSharpBarMainForm') <> 0) then
    tmrAutoHide.Enabled := True;
end;

procedure TSharpBarMainForm.tmrCursorPosTimer(Sender: TObject);
var
  pt : TPoint;
begin
  if foregroundWindowIsFullscreen then
    exit;

  GetCursorPos(pt);

  if (pt.X >= Self.Left) and (pt.X < Self.Left + Self.Width) then
  begin
    // Top Bar
    if SharpBarMainForm.SharpEBar.VertPos = vpTop then
    begin
      // Auto-Hide
      if (not Self.Visible) and (pt.Y >= Self.Top) and (pt.Y < Self.Top + 1) then
        BarHideForm.ShowBar
      else if (pt.Y > Self.Top + Self.Height) then
        StartAutoHide
      else
        tmrAutoHide.Enabled := False;

    // Bottom Bar
    end else if SharpBarMainForm.SharpEBar.VertPos = vpBottom then        
    begin
      // Auto-Hide
      if (not Self.Visible) and (pt.Y >= Self.Top + Self.Height - 1) and (pt.Y < Self.Top + Self.Height) then
        BarHideForm.ShowBar
      else if (pt.Y < Self.Top) then
        StartAutoHide
      else
        tmrAutoHide.Enabled := False;
    end;
  end;
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
  SharpEBar.Throbber.Repaint;
end;

procedure TSharpBarMainForm.ShowNotify(pCaption : String; pScreenBorder : boolean = False);
var
  edge : TSharpNotifyEdge;
  ypos : integer;
begin
  if Top < Monitor.Top + Monitor.Height div 2 then
  begin
    edge := neTopLeft;
    if pScreenBorder then
      ypos := Monitor.Top + 1
    else ypos := Monitor.Top + Height - 1;
  end else
  begin
    edge := neBottomLeft;
    if pScreenBorder then
      ypos := Monitor.Top + Monitor.Height
    else ypos := Monitor.Top + Monitor.Height - Height;
  end;

  SharpNotify.CreateNotifyWindow(
    0,
    nil,
    Left,
    ypos,
    pCaption,
    niInfo,
    edge,
    SkinInterface.SkinManager,
    10000,
    Monitor.BoundsRect);
end;

end.

