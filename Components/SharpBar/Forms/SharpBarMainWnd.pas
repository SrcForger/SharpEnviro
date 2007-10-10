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
  GR32, uSharpEModuleManager, PngImageList, SharpEBar, SharpThemeApi,
  SharpEBaseControls, Controls, ExtCtrls, uSkinManagerThreads,
  uSystemFuncs, Types, SharpESkin, Registry,
  SharpGraphicsUtils, Math, SharpCenterApi, ImgList;

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
    N6: TMenuItem;
    Skin1: TMenuItem;
    ColorScheme1: TMenuItem;
    ThemeHideTimer: TTimer;
    ShowMiniThrobbers1: TMenuItem;
    AlwaysOnTop1: TMenuItem;
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
    procedure AlwaysOnTop1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FUser32DllHandle : THandle;
    PrintWindow : function (SourceWindow: hwnd; Destination: hdc; nFlags: cardinal): bool; stdcall;
    FSuspended : boolean;
    FBarID : integer;
    FStartup : Boolean;
    FBarLock : Boolean;
    FTopZone : TBitmap32;
    FBottomZone : TBitmap32;
    FBGImage : TBitmap32;
    FShellBCInProgress : boolean;
    FSkinManager : TSharpESkinManager;
    FSharpEBar : TSharpEBar;
    FBarName : String;
    SkinManagerLoadThread : TSystemSkinLoadThread;

    procedure CreateNewBar;
    procedure LoadBarModules(XMLElem : TJclSimpleXMlElem);

    procedure WMDeskClosing(var msg : TMessage); message WM_DESKCLOSING;
    procedure WMDeskBackgroundChange(var msg : TMessage); message WM_DESKBACKGROUNDCHANGED;

    // Bad Show/Hide Messages
    procedure WMShowBar(var msg : TMessage); message WM_SHOWBAR;
    procedure WMHideBar(var msg : TMessage); message WM_HIDEBAR;

    // Bar Message
    procedure WMBarReposition(var msg : TMessage); message WM_BARREPOSITION;
    procedure WMBarInsertModule(var msg : TMessage); message WM_BARINSERTMODULE;
    procedure WMBarCommand(var msg : TMessage); message WM_BARCOMMAND;

    // Plugin message (to be broadcastet to modules)
    procedure WMVWMDesktopChanged(var msg : TMessage); message WM_VWMDESKTOPCHANGED;
    procedure WMVWMUpdateSettings(var msg : TMessagE); message   WM_VWMUPDATESETTINGS;
    procedure WMWeatherUpdate(var msg : TMessage); message WM_WEATHERUPDATE;
    procedure WMInputChange(var msg : TMessage); message WM_INPUTLANGCHANGEREQUEST;
    procedure WMShellHookWindowCreate(var msg : TMessage); message WM_SHELLHOOKWINDOWCREATED;

    // Power Management
    procedure WMPowerBroadcast(var msg : TMessage); message WM_POWERBROADCAST;

    // Shutdown
    procedure WMEndSession(var msg : TMessage); message WM_ENDSESSION;
    procedure WMQueryEndSession(var msg : TMessage); message WM_QUERYENDSESSION;

    // SharpE Actions
    procedure WMUpdateBangs(var Msg : TMessage); message WM_SHARPEUPDATEACTIONS;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;

    procedure WMGetFreeBarSpace(var msg : TMessage); message WM_GETFREEBARSPACE;
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
  BarMove : boolean;
  BarMovePoint : TPoint;
  Closing : boolean;

implementation

uses SharpEMiniThrobber,
     BarHideWnd;

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
  XML : TJclSimpleXML;
  Dir : String;
  b : boolean;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FBarID) + '\';

  // Find and load settings file!
  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromFile(Dir + 'Bar.xml');
    b := true;
  except
    b := False;
  end;

  if b then
  begin
    // xml file loaded properlty... use it
    if xml.Root.Items.ItemNamed['Settings'] <> nil then
      with xml.Root.Items.ItemNamed['Settings'] do
      begin
        FBarName                 := Items.Value('Name','Toolbar');       
        SharpEBar.AutoPosition   := Items.BoolValue('AutoPosition',True);
        SharpEBar.PrimaryMonitor := Items.BoolValue('PrimaryMonitor',True);
        SharpEBar.MonitorIndex   := Items.IntValue('MonitorIndex',0);
        SharpEBar.HorizPos       := IntToHorizPos(Items.IntValue('HorizPos',0));
        SharpEBar.VertPos        := IntToVertPos(Items.IntValue('VertPos',0));
        SharpEBar.AutoStart      := Items.BoolValue('AutoStart',True);
        SharpEBar.ShowThrobber   := Items.BoolValue('ShowThrobber',True);
        SharpEBar.DisableHideBar := Items.BoolValue('DisableHideBar',True);
        ModuleManager.ShowMiniThrobbers := Items.BoolValue('ShowMiniThrobbers',True);
        SharpEBar.AlwaysOnTop    := Items.BoolValue('AlwaysOnTop',False);
      end;
   SharpEBar.UpdatePosition;
   UpdateBGZone;
  end;
end;

// A Module is being inserted into the bar via Drag & Drop
procedure TSharpBarMainForm.WMBarCommand(var msg: TMessage);
var
  ModuleIndex : integer;
begin
  ModuleIndex := ModuleManager.GetModuleIndex(msg.LParam);
  if ModuleIndex = - 1 then
    exit;

  case msg.WParam of
    BC_MOVEUP:
      begin
        ModuleManager.MoveModule(ModuleIndex,-1);
        ModuleManager.SortModulesByPosition;
        ModuleManager.FixModulePositions;
        SaveBarSettings;
        msg.Result := BCR_SUCCESS;
      end;
    BC_MOVEDOWN:
      begin
        ModuleManager.MoveModule(ModuleIndex,1);
        ModuleManager.SortModulesByPosition;
        ModuleManager.FixModulePositions;
        SaveBarSettings;
        msg.Result := BCR_SUCCESS;
      end;
    BC_DELETE:
      begin
        ModuleManager.Delete(msg.LParam);
        ModuleManager.ReCalculateModuleSize;
        SaveBarSettings;
        msg.Result := BCR_SUCCESS;    
      end;
  end;
end;

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

  FBarLock := True;

  UpdateBGZone;

  SharpEBar.Throbber.UpdateSkin;
  if SharpEBar.Throbber.Visible then
     SharpEbar.Throbber.Repaint;

  ModuleManager.BroadcastPluginUpdate(suBackground);
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);

  FBarLock := False;

  if ThemeHideTimer.Enabled then
     ThemeHideTimer.OnTimer(ThemeHideTimer);

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

// The shell hook window has been created, all modules or windows which
// need to receive shell hooks should now register with the service
procedure TSharpBarMainForm.WMShellHookWindowCreate(var msg: TMessage);
begin
  if ModuleManager = nil then exit;
  ModuleManager.BroadcastPluginMessage('MM_SHELLHOOKWINDOWCREATED');
end;

// System Input Language Changed -> broadcast a message to all modules
procedure TSharpBarMainForm.WMInputChange(var msg : TMessage);
begin
  if ModuleManager = nil then exit;
  ModuleManager.BroadcastPluginMessage('MM_INPUTLANGCHANGE');
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
    Integer(suSkinFont) :
      begin
        SharpThemeApi.LoadTheme(True,[tpSkinFont]);
        SkinManager.RefreshControls;
      end;
    Integer(suSkinFileChanged) : SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);
    Integer(suTheme) :
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
    Integer(suScheme) :
      begin
        SharpThemeApi.LoadTheme(True,[tpScheme]);
        SkinManager.UpdateScheme;
      end;
    Integer(suIconSet) : SharpThemeApi.LoadTheme(True,[tpIconSet]);
  end;

  if (msg.WParam = Integer(suScheme))
     or (msg.WParam = Integer(suSkinFileChanged))  then
     begin
       // Only update the skin if scheme or skin file changed...
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
       ModuleManager.BroadcastPluginUpdate(suBackground);
     end;

  // Step2: Update modules
  ModuleManager.BroadcastPluginUpdate(TSU_UPDATE_ENUM(msg.WParam),msg.LParam);

  // Step3: Modules updated, now update the bar
  if (msg.WParam = Integer(suSkinFileChanged)) then
     ModuleManager.ReCalculateModuleSize;

  if (msg.WParam = Integer(suSkinFileChanged)) or
     (msg.Wparam = Integer(suScheme)) then
      RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);

  if FBarLock then
  begin
    FBarLock := False;
  end;
end;

procedure TSharpBarMainForm.WMVWMDesktopChanged(var msg: TMessage);
begin
  if ModuleManager = nil then exit;
  ModuleManager.BroadcastPluginMessage('MM_VWMDESKTOPCHANGED');
end;

procedure TSharpBarMainForm.WMVWMUpdateSettings(var msg: TMessagE);
begin
  if ModuleManager = nil then exit;
  ModuleManager.BroadcastPluginMessage('MM_VWMUPDATESETTINGS');
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
  mIndex : integer;
  sedata : TSharpE_DataStruct;
begin
  DebugOutput('WM_CopyData',2,1);

  if msg.WParam = WM_BARCOMMAND then
  begin
    sedata := pSharpE_DataStruct(PCopyDataStruct(msg.lParam)^.lpData)^;
    if sedata.LParam = BC_ADD then
    begin
      mIndex := ModuleManager.GetModuleFileIndexByFileName(sedata.Module);
      if mIndex <> - 1 then
      begin
        ModuleManager.CreateModule(mIndex,sedata.RParam);
        SaveBarSettings;
        msg.Result := BCR_SUCCESS;
      end;
    end;
  end else
  begin
    msgdata := pMsgData(PCopyDataStruct(msg.lParam)^.lpData)^;
    try
      pID := strtoint(lowercase(msgdata.Command));
    except
      exit;
    end;
    pParams := msgdata.Parameters;
    ModuleManager.SendPluginMessage(pID,pParams);
  end;
end;

// Module is requesting update of bar width
procedure TSharpBarMainForm.WMUpdateBarWidth(var msg : TMessage);
begin
  if Closing then exit;
  if FSuspended then exit;
  if FStartup then exit;

  DebugOutput('WM_UpdateBarWidth',2,1);
  try
    ModuleManager.ReCalculateModuleSize((msg.wparam = 0));
  finally
  end;
  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
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
    fastblur(FBGImage,GetSkinGEBlurRadius,GetSkinGEBlurIterations);
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
  TempBmp : TBitmap32;
  Reg : TRegistry;
  wnd : hwnd;
  WinWallPath : String;
  WinWallColor : String;
  WinWallTile  : String;
  WinWallStyle : String;
  n : integer;
  x,y : integer;
  R,G,B : integer;
  s : String;
  MLeft,MTop : integer;
begin
  if FSuspended then exit;
  if (FTopZone = nil) or (FBottomZone = nil) then exit;

  BGBmp := TBitmap32.Create;
  BGBmp.SetSize(Screen.Width,Screen.Height);
  BGBmp.Clear(color32(0,0,0,255));
  try
    // check if SharpDesk is running
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
      // SharpDesk isn't running, load the windows background

      // Read the Windows Wallpaper settings
      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.Access := KEY_READ;
      if Reg.OpenKey('\Control Panel\Desktop\',False) then
      begin
        WinWallPath  := Reg.ReadString('Wallpaper');
        WinWallStyle := Reg.ReadString('WallpaperStyle');
        WinWallTile  := Reg.ReadString('TileWallpaper');
        Reg.CloseKey;
      end;
      if Reg.OpenKey('\Control Panel\Colors\',False) then
      begin
        WinWallColor := Reg.ReadString('Background');
        Reg.CloseKey;
      end;
      Reg.Free;

      // convert the windows color string to R G B colors
      s := '';
      R := -1;
      G := -1;
      B := -1;
      for n := 1 to length(WinWallColor) do
      begin
        if WinWallColor[n] <> ' ' then
           s := s + WinWallColor[n]
        else
        begin
          if         R = -1 then R := strtoint(s)
             else if G = -1 then G := strtoint(s)
             else if B = -1 then B := strtoint(s);
          s := '';
        end;
      end;

      // Paint the Wallpaper
      BGBmp.Clear(color32(R,G,B,255));
      TempBmp := TBitmap32.Create;
      if FileExists(WinWallPath) then
         TempBmp.LoadFromFile(WinWallPath);
      if WinWallTile = '1' then // Tile Wallpaper
      begin
        for x := 0 to BGBmp.Width div TempBmp.Width + 1 do
            for y := 0 to BGBmp.Height div TempBmp.Height + 1 do
                TempBmp.DrawTo(BGBmp,x*TempBmp.Width,y*TempBmp.Height);
      end
      else
      if WinWallStyle = '0' then // Center the Wallpaper
         TempBmp.DrawTo(BGBmp,
                        BGBmp.Width div 2 - TempBmp.Width div 2,
                        BGBmp.Height div 2 - TempBmp.Height div 2)
         else if WinWallStyle = '2' then // Scale
                 TempBmp.DrawTo(BGBmp,Rect(0,0,BGBmp.Width,BGBmp.Height));

      TempBmp.Free;
    end;

    // Some monitors have a position < 0 but the bitmap starts at 0...
    // need to calculate an offset
    MLeft := 0;
    MTop  := 0;
    for n := 0 to Screen.MonitorCount - 1 do
      with Screen.Monitors[n] do
      begin
        if (Left < 0) and (Left < MLeft) then
          MLeft := Left;
        if (Top < 0) and (Top < MTop) then
          MTop := Top;
      end;
    MLeft := abs(MLeft);
    MTop  := abs(MTop);

    // Update the images holding the top and bottom background image
    // (no need to hold the whole image, only the areas used by bars are of interest)
    FTopZone.SetSize(Monitor.Width,Height);
    FBottomZone.SetSize(Monitor.Width,Height);
    FTopZone.Draw(0,0,Rect(Monitor.Left + MLeft,
                           Monitor.Top + MTop,
                           Monitor.Left + MLeft + Monitor.Width,
                           Monitor.Top + MTop + Height), BGBmp);
    FBottomZone.Draw(0,0,Rect(Monitor.Left + MLeft,
                              Monitor.Top + MTop + Monitor.Height - Height,
                              Monitor.Left + MLeft + Monitor.Width,
                              Monitor.Top + MTop + Monitor.Height), BGBmp);
  except
  end;
  BGBmp.Free;
  UpdateBGImage;
end;

procedure TSharpBarMainForm.LoadBarModules(XMLElem : TJclSimpleXMlElem);
var
  n : integer;
begin
  if XMlElem = nil then exit;
  DebugOutput('Loading Bar Modules',1,1);

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
  xml : TJclSimpleXML;
  Dir : String;
  i   : integer;
  tempModule : TModule;
begin
  DebugOutput('Saving Bar Settings',1,1);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(FBarID) + '\';
  xml := TJclSimpleXMl.Create;
  xml.Root.Name := 'SharpBar';

  // Save Bar Settings
  with xml.Root.Items.Add('Settings') do
  begin
    Items.AdD('Name',FBarName);
    Items.Add('AutoPosition',SharpEBar.AutoPosition);
    Items.Add('PrimaryMonitor',SharpEBar.PrimaryMonitor);
    Items.Add('MonitorIndex',SharpEBar.MonitorIndex);
    Items.Add('HorizPos',HorizPosToInt(SharpEBar.HorizPos));
    Items.Add('VertPos',VertPosToInt(SharpEbar.VertPos));
    Items.Add('AutoStart',SharpEbar.AutoStart);
    Items.Add('ShowThrobber',SharpEBar.ShowThrobber);
    Items.Add('DisableHideBar',SharpEBar.DisableHideBar);
    Items.Add('AlwaysOnTop',SharpEBar.AlwaysOnTop);
    Items.Add('ShowMiniThrobbers',ModuleManager.ShowMiniThrobbers);
  end;

  // Save the Module List
  with xml.Root.Items.Add('Modules') do
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

  ForceDirectories(Dir);
  xml.SaveToFile(Dir + 'Bar.xml');
  xml.Free;
end;

procedure TSharpBarMainForm.CreateNewBar;
var
  xml : TJclSimpleXML;
  Dir : String;
  n   : integer;
  NewID : String;
begin
  DebugOutput('Creating New Bar',1,1);
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';
  xml := TJclSimpleXMl.Create;
  xml.Root.Clear;
  xml.Root.Name := 'SharpBar';

  // Generate a new unique bar ID and make sure that there is no other
  // bar with the same ID
  repeat
    NewID := '';
    for n := 1 to 8 do NewID := NewID + inttostr(random(9)+1);
  until not DirectoryExists(Dir + NewID);
  FBarID := strtoint(NewID);
  ModuleManager.BarID := FBarID;  
  ForceDirectories(Dir + NewID);

  xml.Root.Items.Add('Settings');
  xml.Root.Items.Add('Modules');

  xml.SaveToFile(Dir + NewID + '\Bar.xml');
  xml.Free;
  
  // New bar is now loaded!
  // Set window caption to SharpBar_ID
  self.Caption := 'SharpBar_' + inttostr(FBarID);

  UpdateBGZone;
end;

procedure TSharpBarMainForm.LoadBarFromID(ID : integer);
var
  xml : TJclSimpleXML;
  Dir : String;
  handle : THandle;
  b : boolean;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(ID) + '\';

  // Check if the settings file exists!
  if (not FileExists(Dir + 'Bar.xml')) or (ID = -1) then
  begin
    // No settings file == fist launch, no other bars!
    // Create new bar!
    FBarID := -1;
    ModuleManager.BarID := -1;    
    CreateNewBar;
    exit;
  end;
  FBarID := ID;
  ModuleManager.BarID := ID;  

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

  // Find and load settings file!
  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromFile(Dir + 'Bar.xml');
    b := true;
  except
    b := False;
  end;

  if b then
  begin
    // xml file loaded properlty... use it
    if xml.Root.Items.ItemNamed['Settings'] <> nil then
      with xml.Root.Items.ItemNamed['Settings'] do
      begin
        FBarName                 := Items.Value('Name','Toolbar');
        SharpEBar.AutoPosition   := Items.BoolValue('AutoPosition',True);
        SharpEBar.PrimaryMonitor := Items.BoolValue('PrimaryMonitor',True);
        SharpEBar.MonitorIndex   := Items.IntValue('MonitorIndex',0);
        SharpEBar.HorizPos       := IntToHorizPos(Items.IntValue('HorizPos',0));
        SharpEBar.VertPos        := IntToVertPos(Items.IntValue('VertPos',0));
        SharpEBar.AutoStart      := Items.BoolValue('AutoStart',True);
        SharpEBar.ShowThrobber   := Items.BoolValue('ShowThrobber',True);
        SharpEBar.DisableHideBar := Items.BoolValue('DisableHideBar',True);
        ModuleManager.ShowMiniThrobbers := Items.BoolValue('ShowMiniThrobbers',True);
        SharpEBar.AlwaysOnTop    := Items.BoolValue('AlwaysOnTop',False);

        // Set Main Window Title to SharpBar_ID!
        // The bar with the given ID is now loaded =)
        Caption := 'SharpBar_' + inttostr(ID);
      end;
   UpdateBGZone;
   LoadBarModules(xml.root);
  end else
  begin
    // file is damaged... try to reconstruct

  end;
  xml.Free;
end;

// Init all skin and module management classes
procedure TSharpBarMainForm.InitBar;
begin
  FBarName := 'Toolbar';

  FSkinManager := TSharpESkinManager.Create(self, [scBar,scMiniThrobber]);
  FSkinManager.HandleUpdates := False;

  FSharpEBar := TSharpEBar.CreateRuntime(self,SkinManager);
  FSharpEBar.AutoPosition := True;
  FSharpEBar.AutoStart := True;
  FSharpEBar.DisableHideBar := True;
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

  DebugOutput('Creating Main Form',1,1);
  DebugOutput('Creating SkinManager',2,1);

  randomize;

  // Create and Initialize the module manager
  // (Make sure the Skin Manager and Module Settings are ready before doing this!)
  DebugOutput('Creating Module Manager',2,1);
  ModuleManager := TModuleManager.Create(Handle, SkinManager, SharpEBar);
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
  UpdateBGImage;
  SharpEBar.UpdateSkin;
  SaveBarSettings;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH,0,0);
  ModuleManager.FixModulePositions;
  ModuleManager.BroadcastPluginUpdate(suBackground);
end;

procedure TSharpBarMainForm.Bottom1Click(Sender: TObject);
begin
  SharpEBar.VertPos := vpBottom;
  UpdateBGImage;
  SharpEBar.UpdateSkin;
  SaveBarSettings;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH,0,0);
  ModuleManager.FixModulePositions;
  ModuleManager.BroadcastPluginUpdate(suBackground);
end;

procedure TSharpBarMainForm.Left1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpLeft;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH,0,0);
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Middle1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpMiddle;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH,0,0);
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.Right2Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpRight;
  UpdateBGImage;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH,0,0);
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
  UpdateBGZone;
  SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH,0,0);
  ModuleManager.FixModulePositions;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.ExitMnClick(Sender: TObject);
begin
  SaveBarSettings;
  Close;
end;

procedure TSharpBarMainForm.FullScreen1Click(Sender: TObject);
begin
  SharpEBar.HorizPos := hpFull;
  UpdateBGImage;  
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
  AlwaysOnTop1.Checked := SharpEBar.AlwaysOnTop;

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
        if sr.Name = SharpThemeApi.GetSkinName then
        begin
          item.ImageIndex := 28;
          item.Caption := '(' + sr.Name + ')'
        end else
        begin
          item.ImageIndex := 29;
          item.Caption := sr.Name;
        end;
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
    s := sr.Name;
    setlength(s,length(s) - length('.xml'));
    if s = SharpThemeApi.GetSchemeName then
    begin
      item.ImageIndex := 28;
      item.Caption := '(' + s + ')'
    end else
    begin
      item.ImageIndex := 29;
      item.Caption := s;
    end;
    item.Hint := sr.Name;
    item.OnClick := OnSchemeSelectItemClick;
    ColorScheme1.Add(item);
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

procedure TSharpBarMainForm.OnSchemeSelectItemClick(Sender : TObject);
var
  XML : TJclSimpleXML;
  Dir : String;
  s : String;
begin
  Dir := SharpThemeApi.GetThemeDirectory;

  // Change Scheme
  XML := TJclSimpleXML.Create;
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
  SharpCenterApi.BroadcastGlobalUpdateMessage(suSkin);
end;

procedure TSharpBarMainForm.OnSkinSelectItemClick(Sender : TObject);
var
  XML : TJclSimpleXML;
  Dir,NewSkin,SkinDir : String;
  sr : TSearchRec;
  s : String;
begin
  XML := TJclSimpleXML.Create;
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
    XML := TJclSimpleXML.Create;
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
  SharpCenterApi.BroadcastGlobalUpdateMessage(suSkin);
end;

procedure TSharpBarMainForm.SharpEBar1ResetSize(Sender: TObject);
begin
  if FSuspended then exit;
  ModuleManager.FixModulePositions;
end;

procedure TSharpBarMainForm.PluginManager1Click(Sender: TObject);
var
  cfile : String;
begin
  cfile := SharpApi.GetCenterDirectory + '_Components\Module Manager.con';
  SharpCenterApi.CenterCommand(sccLoadSetting,
                              PChar(cfile),
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
        ModuleManager.ReCalculateModuleSize;
        ModuleManager.FixModulePositions;
        ModuleManager.RefreshMiniThrobbers;
        ModuleManager.BroadcastPluginUpdate(suBackground,-2);
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
      end;
      if oVP <> SharpEBar.VertPos then
      begin
        UpdateBGImage;
        SharpEBar.UpdateSkin;
        ModuleManager.FixModulePositions;
        ModuleManager.BroadcastPluginUpdate(suBackground,-2);
        ModuleManager.RefreshMiniThrobbers;
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
        SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH,0,0);
      end;
      if oHP <> SharpEBar.HorizPos then
      begin
        SharpApi.SharpEBroadCast(WM_UPDATEBARWIDTH,0,0);
{        UpdateBGImage;
        ModuleManager.FixModulePositions;
        ModuleManager.BroadcastPluginUpdate(SU_BACKGROUND,-2);
        ModuleManager.RefreshMiniThrobbers;
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);}
      end;
    end;
    if BarHideForm <> nil then BarHideForm.UpdateStatus;
  end;
end;

procedure TSharpBarMainForm.SharpEBar1ThrobberMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (not BarMove) then
    PopUpMenu1.Popup(Left,Top)
  else if BarMove then
    SaveBarSettings;
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
  s : String;
  cfile : String;
begin
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  tempModule := ModuleManager.GetModule(mThrobber.Tag);
  if tempModule = nil then exit;

  s := ExtractFileName(tempModule.ModuleFile.FileName);
  setlength(s,length(s) - length(ExtractFileExt(s)));
  cfile := SharpApi.GetCenterDirectory + '_Modules\' + s + '.con';

  if FileExists(cfile) then
    SharpCenterApi.CenterCommand(sccLoadSetting,
                               PChar(cfile),
                               PChar(inttostr(FBarID) + ':' +inttostr(tempModule.ID)))
  else if @tempModule.ModuleFile.DllShowSettingsWnd <> nil then
    tempModule.ModuleFile.DllShowSettingsWnd(tempModule.ID);
end;

procedure TSharpBarMainForm.Delete1Click(Sender: TObject);
var
  mThrobber : TSharpEMiniThrobber;
begin
  if FSuspended then exit;
  mThrobber := TSharpEMiniThrobber(ThrobberPopUp.popupcomponent);
  if mThrobber = nil then exit;
  if MessageBox(Application.handle,'Do you really want to remove this module? All settings will be lost!','Confirm : "Remove Module"',MB_YESNO) = IDYES then
  begin
    ModuleManager.Delete(mThrobber.Tag);
    SaveBarSettings;
    ModuleManager.ReCalculateModuleSize;
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
  ModuleManager.BroadcastPluginUpdate(suBackground);

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
var
  Mon : TMonitor;
begin
  if FSuspended then exit;
  if BarHideForm <> nil then BarHideForm.UpdateStatus;

  if SharpEBar.HorizPos = hpMiddle then
  begin
    if (SharpEBar.MonitorIndex > (Screen.MonitorCount - 1)) or (SharpEBar.PrimaryMonitor) then
      Mon := Screen.PrimaryMonitor
    else
      Mon := Screen.Monitors[SharpEBar.MonitorIndex];
    if Mon <> nil then
    begin
      if x < Mon.Left then x := Mon.Left;
      if Width > Mon.Width then
         Width := Mon.Width;
    end;
  end;

//  UpdateBGImage;
  ModuleManager.BroadcastPluginUpdate(suBackground,-2);
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

procedure TSharpBarMainForm.AlwaysOnTop1Click(Sender: TObject);
begin
  AlwaysOnTop1.Checked := not AlwaysOnTop1.Checked;
  SharpEBar.AlwaysOnTop := AlwaysOnTop1.Checked;
  SaveBarSettings;
end;

procedure TSharpBarMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Closing then exit;
  SaveBarSettings;

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

  ModuleManager.Free;

  Application.ProcessMessages;

  FSharpEBar.Free;
  FSharpEBar := nil;

  FSkinManager.Free;
  FSkinManager := nil;

  FBottomZone.Free;
  FTopZone.Free;
  FBGImage.Free;
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
