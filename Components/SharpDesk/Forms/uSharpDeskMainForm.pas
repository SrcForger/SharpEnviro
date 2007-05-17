{
Source Name: uSharpDeskMainForm.pas
Description: Main window for displaying and controling all desktop objects
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit uSharpDeskMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShellApi, Menus, ImgList, Registry,
  GR32_Image,GR32_Layers,GR32, GR32_resamplers, JPeg,Types,
  ShlObj,JvSimpleXML,JclSysInfo,AppEvnts,
  SharpApi,
  SharpThemeApi,
  SharpDeskApi,
  uSharpDeskBackgroundUnit,
  uSharpDeskFunctions,
  uSharpDeskObjectFileList,
  uSharpDeskObjectSetList,
  uSharpDeskManager,
  uSharpDeskDesktopObject, PngImageList;

const
    WM_PRIVATE_MESSAGE = WM_USER + 321;

type

  TAlignBy = (albLeft,albCenter);

  TIntClass = class(TObject)
    public
     IntValue : integer;
    end;

  TIntArray = array of integer;

  TSharpDeskMainForm = class(TForm)
    BackgroundImage: TImage32;
    ObjectPopUp: TPopupMenu;
    DeleteObject1: TMenuItem;
    OpenObjectSettings1: TMenuItem;
    LockObjec1: TMenuItem;
    ObjectPopUpImages: TImageList;
    CloneObject1: TMenuItem;
    AdvancedCommands: TMenuItem;
    RepaintObject2: TMenuItem;
    PerformDebugAction1: TMenuItem;
    SingleClickAction1: TMenuItem;
    DoubleClickAction1: TMenuItem;
    N2: TMenuItem;
    Align1: TMenuItem;
    STARTOFBOTTOMMENU: TMenuItem;
    AlignObjecttoGrid1: TMenuItem;
    BringtoFront1: TMenuItem;
    MovetoBack1: TMenuItem;
    LockAllObjects1: TMenuItem;
    UnlockAllObjects1: TMenuItem;
    ObjectPreset1: TMenuItem;
    LoadPreset1: TMenuItem;
    N7: TMenuItem;
    Saveas1: TMenuItem;
    DeletePreset1: TMenuItem;
    LoadAll1: TMenuItem;
    ObjectMenu: TPopupMenu;
    ObjectMenuImages: TImageList;
    ApplicationEvents1: TApplicationEvents;
    ObjectPopup2: TPopupMenu;
    Delete1: TMenuItem;
    Clone1: TMenuItem;
    N8: TMenuItem;
    BringtoFront2: TMenuItem;
    SendtoBack1: TMenuItem;
    ENDOFCUSTOMMENU: TMenuItem;
    CheckThemeTimer: TTimer;
    N4: TMenuItem;
    Align2: TMenuItem;
    NewAligns1: TMenuItem;
    N5: TMenuItem;
    Edit1: TMenuItem;
    Delete2: TMenuItem;
    ObjectAlig1: TMenuItem;
    DevMenu: TPopupMenu;
    UnLoadObjects1: TMenuItem;
    LoadObjects1: TMenuItem;
    RefreshObjectDirectory1: TMenuItem;
    LockObjects1: TMenuItem;
    UnlockObjects1: TMenuItem;
    Aligntogrid1: TMenuItem;
    Objectselections1: TMenuItem;
    All1: TMenuItem;
    N9: TMenuItem;
    ImageList1: TImageList;
    sameObjectSet1: TMenuItem;
    ObjectSet1: TMenuItem;
    ObjectPreset2: TMenuItem;
    LoadPreset2: TMenuItem;
    Object1: TMenuItem;
    N11: TMenuItem;
    NewObjectSet: TMenuItem;
    N12: TMenuItem;
    ObjectSet2: TMenuItem;
    N3: TMenuItem;
    Newobjectset1: TMenuItem;
    MakeWindow1: TMenuItem;
    PngImageList1: TPngImageList;
    N13: TMenuItem;
    Lock1: TMenuItem;
    N6: TMenuItem;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BackgroundImageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BackgroundImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure BackgroundImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
      Layer: TCustomLayer);
    procedure BackgroundImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Layer: TCustomLayer);
    procedure OpenObjectSettings1Click(Sender: TObject);
    procedure BackgroundImageDblClick(Sender: TObject);
    procedure BackgroundImageClick(Sender: TObject);
    procedure LockObjec1Click(Sender: TObject);
    procedure CloneObject1Click(Sender: TObject);
    procedure RepaintObject2Click(Sender: TObject);
    procedure SingleClickAction1Click(Sender: TObject);
    procedure DoubleClickAction1Click(Sender: TObject);
    procedure PerformDebugAction1Click(Sender: TObject);
    procedure AlignObjecttoGrid1Click(Sender: TObject);
    procedure BringtoFront1Click(Sender: TObject);
    procedure MovetoBack1Click(Sender: TObject);
    procedure ClickTopMost1Click(Sender: TObject);
    procedure LockAllObjects1Click(Sender: TObject);
    procedure ObjectPopUpPopup(Sender: TObject);
    procedure UnlockAllObjects1Click(Sender: TObject);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Clone1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure CheckThemeTimerTimer(Sender: TObject);
    procedure NewAligns1Click(Sender: TObject);
    procedure ObjectPopup2Popup(Sender: TObject);
    procedure UnLoadObjects1Click(Sender: TObject);
    procedure LoadObjects1Click(Sender: TObject);
    procedure RefreshObjectDirectory1Click(Sender: TObject);
    procedure LockObjects1Click(Sender: TObject);
    procedure UnlockObjects1Click(Sender: TObject);
    procedure All1Click(Sender: TObject);
    procedure sameObjectSet1Click(Sender: TObject);
    procedure NewObjectSetClick(Sender: TObject);
    procedure MakeWindow1Click(Sender: TObject);
  private
    procedure WMSettingsChange(var Msg : TMessage);       message WM_SETTINGCHANGE;
    procedure WMDisplayChange(var Msg : TMessage);        message WM_DISPLAYCHANGE;
    procedure WMDeskExportBackground(var Msg : TMessage); message WM_DESKEXPORTBACKGROUND;
    procedure WMEnableDesk(var Msg : TMessage);           message WM_ENABLESHARPDESK;
    procedure WMDisableDesk(var Msg : TMessage);          message WM_DISABLESHARPDESK;
    procedure WMUpdateBangs(var Msg : TMessage);          message WM_SHARPEUPDATEACTIONS;
    procedure WMSharpEBang(var Msg : TMessage);           message WM_SHARPEACTIONMESSAGE;
    procedure WMPosChanging(var Msg: TWMWindowPosMsg);    message WM_WINDOWPOSCHANGING;
    procedure WMSharpEUppdateSettings(var msg: TMessage); message WM_SHARPEUPDATESETTINGS;
    procedure WMCloseDesk(var msg : TMEssage);            message WM_CLOSEDESK;
    procedure WMAdddesktopObject(var msg : TMessage);     message WM_ADDDESKTOPOBJECT;
    procedure WMShowDesktopSettings(var msg : TMessage);  message WM_SHOWDESKTOPSETTINGS;
    procedure WMForceObjectReload(var msg : TMessage);    message WM_FORCEOBJECTRELOAD;
    procedure WMWeatherUpdate(var msg : TMessage);        message WM_WEATHERUPDATE;
    procedure msg_EraseBkgnd(var msg : TMessage);         message WM_ERASEBKGND;
    procedure WMMouseLeave(var Msg: TMessage);            message CM_MOUSELEAVE;
    procedure WMMouseMove(var Msg: TMessage);             message WM_MOUSEMOVE;
    procedure WMSharpTerminate(var Msg : TMessage);       message WM_SHARPTERMINATE;
    procedure OnCreateNewPresetClick(Sender : TObject);        // PresetMenu event
    procedure OnSaveAsPresetClick(Sender : TObject);           // PresetMenu event
    procedure OnLoadPresetClick(Sender : TObject);             // PresetMenu event
    procedure OnLoadPresetClickSelected(Sender : TObject);     // PresetMenu event
    procedure OnDeletePresetClick(Sender : TObject);           // PresetMenu event
    procedure OnLoadPresetAllClick(Sender : TObject);          // PresetMenu event
    procedure OnObjectAlignClick(Sender : TObject);            // AlignsMenu event
    procedure OnObjectAlignDeleteClick(Sender : TObject);      // AlignsMenu event
    procedure OnObjectAlignEditClick(Sender : TObject);        // AlignsMenu event
    procedure OnObjectAssignSetClick(Sender : TObject);        // AssignObjectSet Menu event
    procedure OnSelectByObjectSetClick(Sender : TObject);      // SelectBy event
  public
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES; // Drag & Drop
    procedure SendMessageToConsole(msg : string; color : integer; DebugLevel : integer);
    procedure LoadTheme(WPChange : boolean);
  end;

const
     TAG_APP = 'SharpDesk';
     COLOR_ERROR = clred;
     COLOR_OK = clgreen;
     DESK_VERSION = '0.5.0.0 - Beta Build';


     CLONE_MOVE_X = 64;
     CLONE_MOVE_Y = 64;

type
    pTBitmap = ^Tbitmap;


var
  SharpDesk : TSharpDeskManager;
  SharpDeskMainForm: TSharpDeskMainForm;
  Background : TBackground;

  TaskTM : boolean = False;
  BarTM  : boolean = False;
  TrayTM : boolean = False;
  VWMTM  : boolean = False;

  created : boolean = False;
  bgloaded : boolean = False;
  Disabled : boolean = False;
  startup : boolean = False;

  wpara: wparam;
  mess: integer;
  lpara: lparam;

  LastX,LastY : integer;
  SPos : TPoint;
  oSelect : boolean = False;

  ObjectPopupImageCount : integer;


implementation


uses uSharpDeskCreateForm,
     uSharpDeskSettingsForm,
     uSharpDeskAlignSettingsForm,
     uSharpDeskObjectSet;

{$R *.dfm}


// ######################################


procedure TSharpDeskMainForm.WMSharpTerminate(var Msg : TMessage);
begin
  SharpDesk.DeskSettings.SaveSettings;
  Application.Terminate;
end;

procedure TSharpDeskMainForm.WMSettingsChange(var Msg : TMessage);
var
  Reg : TRegistry;
  WP : String;
  WPStyle : String;
  WPTile : String;
  XML : TJvSimpleXML;
  Dir   : String;
  FName : String;
  WPName : String;
  n,i : integer;
begin
  if (msg.WParam = SPI_SETDESKWALLPAPER)
    or (msg.LPAram = SPI_SETDESKWALLPAPER)  then
    begin
      if not SharpDesk.DeskSettings.WallpaperWatch then exit;

      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey('\Control Panel\Desktop\',False);
      WP := Reg.ReadString('Wallpaper');
      WPStyle := Reg.ReadString('WallpaperStyle');
      WPTile := Reg.ReadString('TileWallpaper');
      Reg.Free;
      if CompareText(SharpApi.GetSharpeDirectory + 'SharpDeskbg.bmp',WP) <> 0 then
      begin
        Dir := SharpThemeApi.GetThemeDirectory;
        FName := Dir + 'Wallpaper.xml';
        if FileExists(FName) then
        begin
          WPName := SharpThemeApi.GetMonitorWallpaper(Screen.PrimaryMonitor.MonitorNum).Name;
          XML := TJvSimpleXML.Create(nil);
          try
            XML.LoadFromFile(FName);
            if XML.Root.Items.ItemNamed['Wallpapers'] <> nil then
               with XML.Root.Items.ItemNamed['Wallpapers'].Items do
                    for n := 0 to Count - 1 do
                        if Item[n].Items.Value('Name','.') = WPName then
                        begin
                          if CompareText(WPTile,'1') = 0 then
                             i := 3 // twsTile
                             else
                             begin
                               if CompareText(WPStyle,'0') = 0 then
                                  i := 0 // twsCenter
                                  else i := 1 // twsScale
                             end;
                          if Item[n].Items.ItemNamed['Image'] <> nil then
                             Item[n].Items.ItemNamed['Image'].Value := WP
                             else Item[n].Items.Add('Image',WP);
                          if Item[n].Items.ItemNamed['Size'] <> nil then
                             Item[n].Items.ItemNamed['Size'].IntValue := i
                             else Item[n].Items.Add('Size',i);
                        end;
          except
            XML.Free;
            exit;
          end;
          XML.SaveToFile(FName + '~');
          if FileExists(FName) then
             DeleteFile(FName);
          RenameFile(FName + '~',FName);
          XML.Free;

          LoadTheme(True);
        end;
      end;
    end;
end;

procedure TSharpDeskMainForm.WMDisplayChange(var Msg : TMessage);
begin
//  LoadTheme(SharpDesk.DeskSettings.ThemeID,True);
end;

procedure TSharpDeskMainForm.WMMouseMove(var Msg: TMessage);
var
  tme: TTRACKMOUSEEVENT;
  TrackMouseEvent_: function(var EventTrack: TTrackMouseEvent): BOOL; stdcall;
begin
  tme.cbSize := sizeof(TTRACKMOUSEEVENT);
  tme.dwFlags := TME_HOVER or TME_LEAVE;
  tme.dwHoverTime := 10;
  tme.hwndTrack := SharpDeskMainForm.Handle;
  @TrackMouseEvent_:= @TrackMouseEvent; // nur eine Pointerzuweisung!!!
  TrackMouseEvent_(tme);
end;

procedure TSharpDeskMainForm.WMMouseLeave(var Msg: TMessage);
begin
{  SharpDesk.UnselectAll;
  SharpDesk.LastLayer := -1;
  SharpApi.SendDebugMessage('DESK','MOUSE LEAVE',0);}
end;

procedure TSharpDeskMainForm.WMDeskExportBackground(var Msg : TMessage);
var
   TempBMP : TBitmap32;
   PreviewShot : TBitmap32;
   SaveJPeg : TJpegImage;
   SaveBitmap : TBitmap;
begin
   PreviewShot := TBitmap32.Create;
   TempBMP     := TBitmap32.Create;
   TempBMP.SetSize(SharpDeskMainForm.BackgroundImage.Width,SharpDeskMainForm.BackgroundImage.Height);
   TempBMP.Clear;
   PreviewShot.SetSize(256,192);
   PreviewShot.Clear;
   SharpDeskMainForm.BackgroundImage.PaintTo(TempBMP,TempBMP.BoundsRect);
   TKernelResampler.Create(TempBmp).Kernel := TMitchellKernel.Create;
//   TempBMP.StretchFilter := sfMitchell;
   TempBMP.DrawTo(PreviewShot,PreviewShot.BoundsRect);
   SaveBitmap := TBitmap.Create;
   SaveBitmap.Assign(PreviewShot);
   SaveJPeg := TJpegImage.Create;
   SaveJPeg.Assign(SaveBitmap);
   SaveJPeg.SaveToFile(ExtractFileDir(Application.ExeName)+'\Preview.jpg');
   FreeAndNil(TempBMP);
   FreeAndNil(PreviewShot);
   FreeAndNil(SaveBitmap);
   FreeAndNil(SaveJPeg);
end;

procedure TSharpDeskMainForm.WMCloseDesk(var Msg : TMessage);
begin
  SharpDeskMainForm.Close;
  Application.Terminate;
end;

procedure TSharpDeskMainForm.WMEnableDesk(var Msg : TMessage);
begin
  CheckThemeTimer.Enabled := False;
  SharpDesk.EnableAnimation;  
  SharpDeskMainForm.Enabled := True;
end;

procedure TSharpDeskMainForm.WMDisableDesk(var Msg : TMessage);
begin
  if CreateForm.Visible       then CreateForm.btn_cancel.OnClick(nil);
  if SettingsForm.Visible     then SettingsForm.btn_cancel.OnClick(nil);
  SharpDesk.DisableAnimation;
  SharpDeskMainForm.Enabled := False;
  CheckThemeTimer.Enabled := True;
end;

procedure TSharpDeskMainForm.WMUpdateBangs(var Msg : TMessage);
begin
  SharpApi.RegisterActionEx('!EditCurrentTheme','SharpTheme',SharpDeskMainForm.Handle,1);
  SharpApi.RegisterActionEx('!ThemeManager','SharpTheme',SharpDeskMainForm.Handle,2);
  SharpApi.RegisterActionEx('!AddDesktopObject','SharpDesk',SharpDeskMainForm.Handle,3);
  SharpApi.RegisterActionEx('!SharpDeskSettings','SharpDesk',SharpDeskMainForm.Handle,5);
  SharpApi.RegisterActionEx('!CloseSharpDesk','SharpDesk',SharpDeskMainForm.Handle,6);
end;

procedure TSharpDeskMainForm.WMForceObjectReload(var msg : TMessage);
begin
  SharpDesk.ObjectFileList.UnLoadAll;
  SharpDesk.ObjectSetList.LoadFromFile;
  SharpDesk.ObjectFileList.RefreshDirectory;
  SharpDesk.ObjectFileList.ReLoadAllObjects;
  SharpDesk.LoadObjectSetsFromTheme(SharpThemeApi.GetThemeName);
end;

function IsTopMost(wnd: HWND): Boolean;
begin
  Result := (GetWindowLong(wnd, GWL_EXSTYLE) and WS_EX_TOPMOST) <> 0;
end;

procedure TSharpDeskMainForm.WMSharpEBang(var Msg : TMessage);
var
  handle : hwnd;
begin
  case msg.LParam of
   1: begin
        SharpApi.SharpExecute(ExtractFileDir(Application.ExeName)+'\SharpTheme.exe');
        sleep(500);
        SharpApi.SendMessageTo('SharpTheme - Theme Manager',WM_EDITCURRENTTHEME,0,0);
      end;
   2: begin
        SharpApi.SharpExecute(ExtractFileDir(Application.ExeName)+'\SharpTheme.exe');
      end;
   3: begin
        if not CreateForm.Visible then
           CreateForm.Showmodal;
        if SharpDesk.Desksettings.AdvancedMM then SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));
      end;
   4 : begin
       end;
   5 : WMShowDesktopSettings(msg);
   6 : WMCloseDesk(msg);
  end;
end;



procedure TSharpDeskMainForm.LoadTheme(WPChange : boolean);
begin
  SharpDeskMainForm.SendMessageToConsole('Loading Theme',COLOR_OK,DMT_STATUS);

  try
    SharpThemeApi.LoadTheme(True,ALL_THEME_PARTS);
    SharpDesk.DeskSettings.ReloadSettings;

    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Main Resize : ' +
                                inttostr(Screen.DesktopLeft)+','+inttostr(Screen.DesktopTop)+','+inttostr(Screen.DesktopWidth)+','+inttostr(Screen.DesktopHeight)),clblue,DMT_INFO);
    SharpDeskMainForm.Left := Screen.DesktopLeft;
    SharpDeskMainForm.Top  := Screen.DesktopTop;
    SharpDeskMainForm.Width := Screen.DesktopWidth;
    SharpDeskMainForm.Height := Screen.DesktopHeight;
    if WPChange then
    begin
      SharpDeskMainForm.SendMessageToConsole('loading wallpaper',COLOR_OK,DMT_STATUS);
      Background.Reload;
    end;
    SharpDesk.UpdateAnimationLayer;

    SharpDesk.ObjectSetList.LoadFromFile;
    SharpDesk.LoadObjectSetsFromTheme(SharpThemeApi.GetThemeName);

    if SharpDesk.DeskSettings.AdvancedMM then SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));
  finally
    BackgroundImage.ForceFullInvalidate;
    SharpDesk.BackgroundLayer.Update;
    SharpDesk.BackgroundLayer.Changed;
    SharpApi.SharpEBroadCast(WM_DESKBACKGROUNDCHANGED,0,0);
  end;
end;

// ######################################


procedure TSharpDeskMainForm.SendMessageToConsole(msg : string; color : integer; DebugLevel : integer);
begin
     SendDebugMessageEx(TAG_APP,PChar('<font color='+ColorToString(color)+'>'+msg),color,DebugLevel);
end;


// ######################################


procedure TSharpDeskMainForm.WMPosChanging(var Msg: TWMWindowPosMsg);
begin
  inherited;
  if Created then
     Msg.WindowPos.Flags := Msg.WindowPos.Flags or SWP_NOZORDER;
end;


// ######################################


procedure TSharpDeskMainForm.WMAdddesktopObject(var msg : TMessage);
begin
  if SharpDesk.IsAnyObjectSetLoaded then CreateForm.Showmodal
     else
     begin
       showmessage('No object set loaded. Please check your theme settings');
     end;
  if SharpDesk.Desksettings.AdvancedMM then SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));
end;


// ######################################


procedure TSharpDeskMainForm.WMShowDesktopSettings(var msg : TMessage);
begin
  SharpApi.CenterMsg(sccLoadSetting,PChar(GetCenterDirectory + 'Components.con'),'SharpMenu');
end;


// #################################################
// a setting has changed

procedure TSharpDeskMainForm.WMSharpEUppdateSettings(var msg: TMessage);
begin
  if msg.WParam < 0 then exit;

  if (msg.WParam = SU_THEME) then
  begin
    LoadTheme(True);
    exit;
  end;

  if (msg.WParam = SU_SHARPDESK) then
  begin
    SharpDesk.DeskSettings.ReloadSettings;
    if SharpDesk.Desksettings.DragAndDrop then SharpDesk.DragAndDrop.RegisterDragAndDrop(SharpDesk.Image.Parent.Handle)
       else SharpDesk.DragAndDrop.UnregisterDragAndDrop(SharpDesk.Image.Parent.Handle);
  end;

  if (msg.WParam = SU_DESKTOPICON) or (msg.WParam = SU_ICONSET) then
  begin
    SharpThemeApi.LoadTheme(True,ALL_THEME_PARTS);
    SharpDesk.SendMessageToAllObjects(SDM_SETTINGS_UPDATE,0,0,0);
  end;
end;


// ######################################


procedure TSharpDeskMainForm.msg_EraseBkgnd(var msg : Tmessage);
begin
  msg.Result := 0;
end;


// ######################################


procedure TSharpDeskMainForm.FormCreate(Sender: TObject);
begin
  if not SharpThemeApi.Initialized then
     SharpThemeApi.InitializeTheme;
  SharpThemeApi.LoadTheme();

     ObjectPopupImageCount := ObjectPopUp.Images.Count;

     startup := True;
     SharpApi.RegisterActionEx('!EditCurrentTheme','SharpTheme',SharpDeskMainForm.Handle,1);
     SharpApi.RegisterActionEx('!ThemeManager','SharpTheme',SharpDeskMainForm.Handle,2);
     SharpApi.RegisterActionEx('!AddDesktopObject','SharpDesk',SharpDeskMainForm.Handle,3);
     SharpApi.RegisterActionEx('!SharpDeskSettings','SharpDesk',SharpDeskMainForm.Handle,5);
     SharpApi.RegisterActionEx('!CloseSharpDesk','SharpDesk',SharpDeskMainForm.Handle,6);
     SendMessageToConsole('creating main window',COLOR_OK,DMT_STATUS);
     SharpDesk := TSharpDeskManager.Create(SharpDeskMainForm.BackgroundImage);

     Randomize;
     SharpDeskMainForm.Caption:='SharpDesk';


//   {WND SETTINGS}
//     MainForm.DisableAlign;
//     MainForm.EnableAlign;


     SetWindowLong(SharpDeskMainForm.Handle, GWL_USERDATA, magicDWord); //used for vwm
     setwindowpos(SharpDeskMainForm.Handle, HWND_TOP, Screen.DesktopLeft,Screen.DesktopTop,
                  Screen.DesktopWidth, Screen.DesktopHeight, SWP_NOZORDER);
     SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW or WS_EX_TOPMOST);
     SetWindowLong(Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW or WS_EX_TOPMOST);
     ShowWindow(application.handle, SW_HIDE);

     try
        SharpDeskMainForm.SetZOrder(False);
        Created := True;
     except
     end;

     SharpDeskMainForm.Show;

     SharpDeskMainForm.Left:=Screen.DesktopLeft;
     SharpDeskMainForm.Top:=Screen.DesktopTop;
     SharpDeskMainForm.Width:=Screen.DesktopWidth;
     SharpDeskMainForm.Height:=Screen.DesktopHeight;
     LoadTheme(True);
     SharpDeskMainForm.BackgroundImage.RepaintMode := rmOptimizer;
end;


// ######################################


procedure TSharpDeskMainForm.FormShow(Sender: TObject);
begin
  if SharpDesk.Desksettings.DragAndDrop then SharpDesk.DragAndDrop.RegisterDragAndDrop(SharpDesk.Image.Parent.Handle)
     else SharpDesk.DragAndDrop.UnregisterDragAndDrop(SharpDesk.Image.Parent.Handle);
end;


// ######################################


procedure TSharpDeskMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
{var
   n : integer;  }
begin
  SendMessageToConsole('Closing main window',COLOR_OK,DMT_STATUS);
  SharpApi.UnRegisterAction('!AddDesktopObject');
  SharpApi.UnRegisterAction('!EditCurrentTheme');
  SharpApi.UnRegisterAction('!ThemeManager');
  SharpApi.UnRegisterAction('!SharpDeskSettings');
  SharpApi.UnRegisterAction('!Show/CloseSharpDesk');
  SharpDesk.ObjectSetList.SaveSettings;
  SharpDesk.DeskSettings.SaveSettings;
  SharpDesk.UnloadAllObjects;
  SharpDesk.Free;
  Background.Destroy;
  SharpApi.SharpEBroadCast(WM_DESKCLOSING,0,0);
end;


// ######################################


procedure TSharpDeskMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((SSALT in Shift) and (Key = VK_F4)) then
    Key := 0;
end;


// ######################################


procedure TSharpDeskMainForm.BackgroundImageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((SSALT in Shift) and (Key = VK_F4)) then Key := 0;
end;


// ######################################


procedure TSharpDeskMainForm.BackgroundImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var
   B,i : integer;
   //cpos : TPoint;
   DesktopObject : TDesktopObject;
   wnd : hwnd;
   //MenuItem : TMenuItem;
begin
  if not SharpDesk.Enabled then exit;
  SharpDesk.MouseDown:=False;

  if oSelect then
  begin
    oSelect:=False;
    SharpDesk.SelectLayer.Visible := False;
    SharpDesk.SelectLayer.Location := FloatRect(0,0,0,0);
    SharpDesk.Image.Repaint;    
    exit;
  end;

  if SharpDesk.ObjectsMoved then
  begin
    SharpDesk.ObjectsMoved := False;
    SharpDesk.CheckObjectPosition;
    SharpDesk.ObjectSetList.SaveSettings;
  end;

  if not Assigned(Layer) then exit;
  if Layer.Tag>-1 then
  begin
    DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(Layer.Tag));
    if (not ((Button = mbright) and not (ssAlt in Shift))) and (DesktopObject.Selected) then exit;

    case Button of
      mbLeft   : B:=0;
      mbRight  : B:=1;
      mbMiddle : B:=2;
      else B:=0;
    end;

    try
      DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                              DesktopObject.Layer,
                                             SDM_MOUSE_UP,Mouse.CursorPos.X,Mouse.CursorPos.Y,B);
    except
      on E: Exception do
      begin
        SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MOUSE_UP to ' + inttostr(DesktopObject.Settings.ObjectID) + '('+DesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
        SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
      end;
    end;
    if (Button = mbright) and not (ssAlt in Shift) then
    begin
      ENDOFCUSTOMMENU.Visible := True;
      N13.Visible := True;
//      STARTOFBOTTOMMENU.Visible := True;

      while ObjectPopUp.Items[0].Name <> 'ENDOFCUSTOMMENU' do ObjectPopUp.Items.Delete(0);
      while ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Name <> 'STARTOFBOTTOMMENU' do ObjectPopUp.Items.Delete(ObjectPopUp.Items.Count-1);
      while ObjectPopUp.Images.Count > ObjectPopUpImageCount do ObjectPopUp.Images.Delete(ObjectPopUpImageCount);
      ObjectMenu.Items.Clear;
      ObjectMenuImages.Clear;
      try
        DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                DesktopObject.Layer,
                                                SDM_MENU_POPUP,Mouse.CursorPos.X,Mouse.CursorPos.Y,0);
      except
        on E: Exception do
        begin
         SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MENU_POPUP to ' + inttostr(DesktopObject.Settings.ObjectID) + '('+DesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
         SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
        end;
      end;
      i := ObjectPopUp.Images.Count;
      ObjectPopUp.Images.AddImages(ObjectMenu.Images);
      CopyMenuItems(ObjectMenu.Items,ObjectPopUp.Items[0],ObjectPopUpImageCount-(ObjectPopUpImageCount-i),True);

      if ObjectPopUp.Items[0].Name = 'ENDOFCUSTOMMENU' then ObjectPopUp.Items[0].Visible := False
         else ObjectPopUp.Items[0].Visible := True;

      if (SharpDesk.SelectionCount <= 1) then
      begin
        if DesktopObject.Settings.isWindow then MakeWindow1.Checked := True
           else MakeWindow1.Checked := False;
        if DesktopObject.Settings.Locked then LockObjec1.Checked := True
           else LockObjec1.Checked := False;
        ObjectPopUp.Popup(Mouse.CursorPos.X,Mouse.CursorPos.y);
      end else ObjectPopUp2.Popup(Mouse.CursorPos.x,Mouse.CursorPos.y);
    end;
  end else
  begin
    LastX:=X;
    LastY:=Y;
    if (Button = mbRight) and (Shift = [ssCtrl]) then DevMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y)
    else
    if (Button = mbRight) then
    begin
      wnd := FindWindow('TSharpEMenuWnd',nil);
      if wnd <> 0 then
         SendMessage(wnd,WM_CLOSE,0,0);
      SharpApi.SharpExecute(SharpApi.GetSharpeDirectory+'SharpMenu.exe '
                            + inttostr(Mouse.CursorPos.X) + ' ' + inttostr(Mouse.CursorPos.Y));
      //sleep(1000);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar('Menu popup at : ' + inttostr(Mouse.CursorPos.X) + '|' + inttostr(Mouse.CursorPos.Y)),clblue,DMT_Trace);
    end;
  end;
end;


// ######################################


procedure TSharpDeskMainForm.BackgroundImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var
   CPos : TPoint;
   DesktopObject : TDesktopObject;
   wnd : hwnd;
begin
  if not SharpDesk.Enabled then exit;

  wnd := FindWindow('TSharpEMenuWnd',nil);
  if wnd <> 0 then
     SendMessage(wnd,WM_CLOSE,0,0);

  if SharpDesk.DoubleClick then
  begin
    SharpDesk.DoubleClick := False;
    exit;
  end;
  if not Assigned(Layer) then exit;

  CPos := SharpDesk.Image.ScreenToClient(Mouse.CursorPos);

  if (Layer.Tag=-1) and (SharpDesk.SelectionCount<>0) then
  begin
    SharpDesk.SelectionCount:=0;
    SharpDesk.UnselectAll;
  end;


  SharpDesk.ObjectsMoved := False;

  if Layer.Tag>-1 then
  begin
    DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(Layer.Tag));
    if DesktopObject = nil then exit;

    if (ssShift in Shift) and (ssCtrl in Shift) then
    begin
       SharpDesk.SelectBySetID(TObjectSet(DesktopObject.Settings.Owner).SetID);
    end else
    if ssShift in Shift then
    begin
      if DesktopObject.Selected then
      begin
        if SharpDesk.SelectionCount = -1 then SharpDesk.SelectionCount := 1
        else
        begin
          DesktopObject.Selected := False;
          SharpDesk.SelectionCount := SharpDesk.SelectionCount -1;
        end;
      end else
      begin
        DesktopObject.Selected := True;
        SharpDesk.SelectionCount := SharpDesk.SelectionCount + 1;
      end;
      exit;
    end;

    if not DesktopObject.Selected and (SharpDesk.SelectionCount<>0) then
    begin
      SharpDesk.UnselectAll;
      try
        DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                DesktopObject.Layer,
                                                SDM_MOUSE_ENTER,CPos.X,CPos.Y,0);
      except
        on E: Exception do
        begin
         SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MOUSE_ENTER to ' + inttostr(DesktopObject.Settings.ObjectID) + '('+DesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
         SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
        end;
      end;
      exit;
    end else
    if DesktopObject.Selected and (SharpDesk.SelectionCount<>0) then
    begin
      SharpDesk.LayerMousePos := SharpDesk.GetNextGridPoint(Mouse.CursorPos);
      case Button of
        mbLeft   : SharpDesk.MouseDown:=True;
        mbRight  : SharpDesk.MouseDown:=False;
        mbMiddle : SharpDesk.MouseDown:=False;
      end;
      exit;
    end;
    case Button of
      mbLeft   : SharpDesk.MouseDown:=True;
      mbRight  : SharpDesk.MouseDown:=False;
      mbMiddle : SharpDesk.MouseDown:=False;
    end;

    SharpDesk.LayerMousePos := Point(round(DesktopObject.Layer.Location.Left),
                                     round(DesktopObject.Layer.Location.Top));
  end;

  if (Button = mbLeft) then
  begin
    oSelect:=True;
    SPos.X := X;
    SPos.Y := Y;
    SharpDesk.SelectLayer.Location := FloatRect(X,Y,X+1,Y+1);
    SharpDesk.SelectLayer.BringToFront;
    SharpDesk.SelectLayer.Visible := True;
  end;

end;


// ######################################


procedure TSharpDeskMainForm.BackgroundImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
   CPos : TPoint;
   X1,X2,Y1,Y2 : integer;
   DesktopObject : TDesktopObject;
begin
  if not SharpDesk.Enabled then exit;
  if not Assigned(Layer) then exit;

  CPos := SharpDesk.Image.ScreenToClient(Mouse.CursorPos);

  if Layer.Tag > -1 then
  begin
    DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(Layer.Tag));
    if DesktopObject = nil then exit;
    DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                            DesktopObject.Layer,
                                            SDM_MOUSE_MOVE,CPos.X,CPos.Y,0);

  end;

  if oSelect then
  begin
    CPos.X := X;
    CPos.Y := Y;
    if CPos.X>SPos.X then
    begin
      X1:=SPos.X;
      X2:=CPos.X;
    end else
    begin
      X1:=CPos.X;
      X2:=SPos.X;
    end;
    if CPos.Y>SPos.Y then
    begin
      Y1:=SPos.Y;
      Y2:=CPos.Y;
    end else
    begin
      Y1:=CPos.Y;
      Y2:=SPos.Y;
    end;

    SharpDesk.UpdateSelection(Rect(X1,Y1,X2,Y2));
    SharpDesk.SelectLayer.Location := FloatRect(X1,Y1,X2,Y2);

    exit;
  end;

  if (ssShift in Shift) then exit;

  if (SharpDesk.MouseDown) and (SharpDesk.SelectionCount<>0) then
  begin
    CPos := Mouse.CursorPos;
    if SharpDesk.DeskSettings.Grid then CPos := SharpDesk.GetNextGridPoint(CPos);
    X1 := CPos.X-SharpDesk.LayerMousePos.X;
    Y1 := CPos.Y-SharpDesk.LayerMousePos.Y;
    if (X<>0) and (Y<>0) then
    begin
      if Shift = [ssCtrl,ssLeft] then SharpDesk.MoveSelectedLayers(X1,Y1,True)
         else SharpDesk.MoveSelectedLayers(X1,Y1,False);
      SharpDesk.ObjectSetList.SaveSettings;
    end;
    SharpDesk.LayerMousePos := CPos;
    exit;
  end;

  if Layer.Tag = -2 then exit;
  if (SharpDesk.LastLayer <> Layer.Tag) and (SharpDesk.SelectionCount<=0) then
  begin
    if SharpDesk.LastLayer > -1 then
    begin
      DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
      if DesktopObject = nil then exit;
      try
        DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                DesktopObject.Layer,
                                                SDM_MOUSE_LEAVE,X,Y,0);
      except
        on E: Exception do
        begin
         SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MOUSE_LEAVE to ' + inttostr(DesktopObject.Settings.ObjectID) + '('+DesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
         SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
        end;
      end;
      DesktopObject.Selected := False;
      SharpDesk.SelectionCount := 0;
    end;

    if Layer.Tag > -1 then
    begin
      DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(Layer.Tag));
      if DesktopObject = nil then exit;
      try
        DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                DesktopObject.Layer,
                                                SDM_MOUSE_ENTER,X,Y,0);
      except
        on E: Exception do
        begin
         SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MOUSE_ENTER to ' + inttostr(DesktopObject.Settings.ObjectID) + '('+DesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
         SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
        end;
      end;
      DesktopObject.Selected := True;
      SharpDesk.SelectionCount := -1;
    end;
  end;
  SharpDesk.LastLayer := Layer.Tag;
end;


// ######################################


procedure TSharpDeskMainForm.OpenObjectSettings1Click(Sender: TObject);
begin
//  SettingsForm.Show;
  SettingsForm.Load(TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer)));
  SettingsForm.ShowModal;
end;


// ######################################


procedure TSharpDeskMainForm.BackgroundImageDblClick(Sender: TObject);
var
   CPos : TPoint;
   DesktopObject : TDesktopObject;
begin
  if not SharpDesk.Enabled then exit;
  if SharpDesk.DeskSettings.SingleClick then exit;
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  if DesktopObject <> nil then
  begin
    CPos := SharpDesk.Image.ScreenToClient(Mouse.CursorPos);
    if DesktopObject.Layer.HitTest(CPos.X,CPos.Y) then
       DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                DesktopObject.Layer,
                                                SDM_DOUBLE_CLICK,
                                                CPos.X,CPos.Y,0);
  end;
  SharpDesk.MouseDown := False;
  SharpDesk.ObjectsMoved := False;
  oSelect := False;
  SharpDesk.DoubleClick := True;
end;


// ######################################


procedure TSharpDeskMainForm.BackgroundImageClick(Sender: TObject);
var
   CPos : TPoint;
   DesktopObject : TDesktopObject;
begin
  if not SharpDesk.Enabled then exit;
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  if DesktopObject <> nil then
  begin
    CPos := Mouse.CursorPos;
    if DesktopObject.Layer.HitTest(CPos.X,CPos.Y) then
    begin
      DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                               DesktopObject.Layer,
                                               SDM_CLICK,
                                               CPos.X,CPos.Y,0);
      if (SharpDesk.DeskSettings.SingleClick) and (not SharpDesk.ObjectsMoved) then
         DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                 DesktopObject.Layer,
                                                 SDM_DOUBLE_CLICK,
                                                 CPos.X,CPos.Y,0);                                               
    end;
  end;
  SharpDesk.MouseDown := False;
//  SharpDesk.ObjectsMoved := False;  
end;


// ######################################


procedure TSharpDeskMainForm.LockObjec1Click(Sender: TObject);
begin
  if LockObjec1.Checked then SharpDesk.UnLockSelectedObjects
     else SharpDesk.LockSelectedObjects;
  LockObjec1.Checked := not LockObjec1.Checked;
//  if LockObjec1.ImageIndex = 29 then SharpDesk.LockSelectedObjects
//     else SharpDesk.UnLockSelectedObjects;
End;


// ######################################


procedure TSharpDeskMainForm.CloneObject1Click(Sender: TObject);
begin
  SharpDesk.CloneSelectedObjects;
end;


// ######################################


procedure TSharpDeskMainForm.RepaintObject2Click(Sender: TObject);
var
   DesktopObject : TDesktopObject;
begin
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  if DesktopObject <> nil then
     DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                             DesktopObject.Layer,
                                             SDM_REPAINT_LAYER,
                                             0,0,0);
end;


// ######################################


procedure TSharpDeskMainForm.SingleClickAction1Click(Sender: TObject);
var
   DesktopObject : TDesktopObject;
begin
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  if DesktopObject <> nil then
     DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                             DesktopObject.Layer,
                                             SDM_CLICK,
                                             0,0,0);
end;


// ######################################


procedure TSharpDeskMainForm.DoubleClickAction1Click(Sender: TObject);
var
   DesktopObject : TDesktopObject;
begin
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  if DesktopObject <> nil then
     DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                             DesktopObject.Layer,
                                             SDM_DOUBLE_CLICK,
                                             0,0,0);
end;


// ######################################


procedure TSharpDeskMainForm.PerformDebugAction1Click(Sender: TObject);
var
   DesktopObject : TDesktopObject;
begin
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  if DesktopObject <> nil then
     DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                             DesktopObject.Layer,
                                             SDM_DEBUG,
                                             0,0,0);
end;


// ######################################


procedure TSharpDeskMainForm.WMDropFiles(var Message: TWMDropFiles);
var
   aFile: array [0..255] of Char;
   n,cnt: Integer;
   CPos : TPoint;
begin
  inherited;
  cnt := DragQueryFile(Message.drop, $FFFFFFFF, nil, 0);

  CPos:=Mouse.CursorPos;
  CPos := SharpDeskMainForm.ScreenToClient(CPos);
  if CPos.X>Screen.DesktopWidth-CLONE_MOVE_X then
  begin
    CPos.X:=64;
    CPos.Y:=CPos.Y+CLONE_MOVE_X;
    if CPos.Y>Screen.DesktopHeight-CLONE_MOVE_Y then CPos.Y:=64;
  end;

  for n := 0 to cnt - 1 do // for all the file in the list
  begin
    DragQueryFile(Message.drop, n, aFile, 256); // get the FileName (max characters 255 + #0)
    if SharpDesk.DragAndDrop.IsExtRegistered(ExtractFileExt(aFile)) then
    begin
      SharpDesk.DragAndDrop.DoDragAndDrop(aFile,CPos.X,CPos.Y);
      CPos.X:=CPos.X + CLONE_MOVE_X;
      if CPos.X>Screen.DesktopWidth-CLONE_MOVE_X then
      begin
        CPos.X:=64;
        CPos.Y:=CPos.Y+CLONE_MOVE_X;
        if CPos.Y>Screen.DesktopHeight-CLONE_MOVE_Y then CPos.Y:=64;
      end;
    end;
  end;
  DragFinish(Message.Drop);       
end;


// ######################################


procedure TSharpDeskMainForm.AlignObjecttoGrid1Click(Sender: TObject);
begin
  SharpDesk.AlignSelectedObjectsToGrid;
  SharpDesk.ObjectSetList.SaveSettings;
end;


// ######################################


procedure TSharpDeskMainForm.BringtoFront1Click(Sender: TObject);
begin
  SharpDesk.BringSelectedObjectsToFront;
end;


// ######################################


procedure TSharpDeskMainForm.MovetoBack1Click(Sender: TObject);
begin
  SharpDesk.SendSelectedObjectsToBack;
end;


// ######################################


procedure TSharpDeskMainForm.ClickTopMost1Click(Sender: TObject);
begin

end;


// ######################################


procedure TSharpDeskMainForm.LockAllObjects1Click(Sender: TObject);
begin
  SharpDesk.LockAllObjects;
end;


// ######################################


procedure TSharpDeskMainForm.OnCreateNewPresetClick(Sender : TObject);
var
   NewPreSet : String;
   DesktopObject : TDesktopObject;
begin
  NewPreSet := InputBox('Create New Preset','Create a preset for the current selected object.'+#13#10+'You will be able to assign the properties of the current selected object to all other objects of that type. : ','New Preset');
  if length(NewPreSet)=0 then
  begin
    showmessage('Please enter a name for the new preset!');
    exit;
  end;

  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  SharpDesk.CreatePreset(DesktopObject,NewPreSet);
end;


// ######################################


procedure TSharpDeskMainForm.OnSaveAsPresetClick(Sender : TObject);
var
   pID : integer;
   DesktopObject : TDesktopObject;
begin
  if not (Sender is TMenuItem) then exit;
  pID := TMenuItem(Sender).Tag;
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  SharpDesk.SavePresetAs(DesktopObject,pID);
end;


// ######################################


procedure TSharpDeskMainForm.OnLoadPresetClickSelected(Sender : TObject);
var
   pID : integer;
   //DesktopObject : TDesktopObject;
begin
  if not (Sender is TMenuItem) then exit;
  pID := TMenuItem(Sender).Tag;
  SharpDesk.LoadPresetForSelected(pID);
end;


// ######################################


procedure TSharpDeskMainForm.OnLoadPresetClick(Sender : TObject);
var
   pID : integer;
   DesktopObject : TDesktopObject;
begin
  if not (Sender is TMenuItem) then exit;
  pID := TMenuItem(Sender).Tag;
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  SharpDesk.LoadPreset(DesktopObject,pID,True);
end;


// ######################################


procedure TSharpDeskMainForm.OnDeletePresetClick(Sender : TObject);
var
  XML : TJvSimpleXML;
  pID : integer;
begin
  if not (Sender is TMenuItem) then exit;
  pID := TMenuItem(Sender).Tag;
  XML := TJvSimpleXML.Create(nil);
  XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
  XML.Root.Items.ItemNamed['PresetSettings'].Items.Delete(inttostr(pID));
  XML.Root.Items.ItemNamed['PresetList'].Items.Delete(inttostr(pID));
  XML.SaveToFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
  XML.Free;
end;


// ######################################


procedure TSharpDeskMainForm.OnLoadPresetAllClick(Sender : TObject);
var
   pID : integer;
   DesktopObject : TDesktopObject;
begin
  if not (Sender is TMenuItem) then exit;
  pID := TMenuItem(Sender).Tag;
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  SharpDesk.LoadPresetForAll(DesktopObject.Owner,pID);
end;


// ######################################


procedure TSharpDeskMainForm.ObjectPopUpPopup(Sender: TObject);
var
   tempItem : TMenuItem;
   n : integer;
   XML : TJvSimpleXML;
   ObjectFile : String;
   DesktopObject : TDesktopObject;
   SList : TStringList;
   ObjectSet : TObjectSet;
begin
     if SharpDesk.LastLayer = -1 then exit;

     SharpDesk.CheckPresetsFile;

     {SelectAll Menu}
     SList := TStringList.Create;
     SList.Clear;
     for n := 0 to SharpDesk.ObjectSetList.Count - 1 do
         if TObjectSet(SharpDesk.ObjectSetList.Items[n]).ThemeList.IndexOf(SharpThemeApi.GetThemeName) >= 0 then
            SList.Add(inttostr(TObjectSet(SharpDesk.ObjectSetList.Items[n]).SetID));

     while ObjectSelections1.Count > 3 do
           ObjectSelections1.Delete(3);

     for n := 0 to SList.Count - 1 do
     begin
       ObjectSet := TObjectSet(SharpDesk.ObjectSetList.GetSetByID(strtoint(SList[n])));
       if ObjectSet <> nil then
       begin
         tempItem := TMenuItem.Create(Objectselections1);
         tempItem.Caption := ObjectSet.Name + ' (' + inttostr(ObjectSet.Count) +')';
         tempItem.Tag := ObjectSet.SetID;
         tempItem.ImageIndex := 7;
         tempItem.OnClick := OnSelectByObjectSetClick;
         Objectselections1.Add(tempItem);
       end;
     end;
     SList.Free;

     {Assign To Set Menu}
  SList := TStringList.Create;
  SList.Clear;
  for n := 0 to SharpDesk.ObjectSetList.Count - 1 do
      if TObjectSet(SharpDesk.ObjectSetList.Items[n]).ThemeList.IndexOf(SharpThemeApi.GetThemeName) >= 0 then
         SList.Add(inttostr(TObjectSet(SharpDesk.ObjectSetList.Items[n]).SetID));
  while ObjectSet2.Count>2 do ObjectSet2.Delete(2);
  for n := 0 to SharpDesk.ObjectSetList.Count - 1 do
  begin
    if SList.IndexOf(inttostr(TObjectSet(SharpDesk.ObjectSetList.Items[n]).SetID))<>-1 then
    begin
      tempItem := TMenuItem.Create(ObjectSet2);
      tempItem.Caption := TObjectSet(SharpDesk.ObjectSetList.Items[n]).Name;
      tempItem.ImageIndex := 7;
      tempItem.Tag := n;
      tempItem.OnClick := OnObjectAssignSetClick;
      ObjectSet2.Add(tempItem);
    end;
  end;
  SList.Free;

     {Preset Menu}
     Saveas1.Clear;
     LoadPreset1.Clear;
     DeletePreset1.Clear;
     LoadAll1.Clear;
     DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
     ObjectFile := DesktopObject.Owner.FileName;

     tempItem := TMenuItem.Create(SaveAs1);
     tempItem.Caption:='Create New Preset ...';
     tempItem.ImageIndex :=3;
     tempItem.OnClick:=OnCreateNewPresetClick;
     SaveAs1.Add(tempItem);
     tempItem := TMenuItem.Create(SaveAs1);
     tempItem.Caption:='-';
     tempItem.ImageIndex :=-1;
     SaveAs1.Add(tempItem);

     XML := TJvSimpleXML.Create(nil);
     XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
     with XML.Root.Items.ItemNamed['PresetList'].Items do
     begin
          {Save Preset As}
          for n:=0 to Count-1 do
          begin
              if Item[n].Items.Value('ObjectFile','...')=ObjectFile then
              begin
                   tempItem := TMenuItem.Create(SaveAs1);
                   tempItem.Caption := Item[n].Items.Value('Name','### ERROR ###');
                   tempItem.ImageIndex := 5;
                   tempItem.Tag:=strtoint(Item[n].Name);
                   tempItem.OnClick := OnSaveAsPresetClick;
                   SaveAs1.Add(tempItem);
              end;
          end;

          {Load Preset}
          for n:=0 to Count-1 do
              if Item[n].Items.Value('ObjectFile','...')=ObjectFile then
              begin
                   tempItem := TMenuItem.Create(LoadPreset1);
                   tempItem.Caption := Item[n].Items.Value('Name','### ERROR ###');
                   tempItem.ImageIndex := 5;
                   tempItem.Tag:=strtoint(Item[n].Name);
                   tempItem.OnClick := OnLoadPresetClick;
                   LoadPreset1.Add(tempItem);
              end;

          {Delete Preset}
          for n:=0 to Count-1 do
              if Item[n].Items.Value('ObjectFile','...')=ObjectFile then
              begin
                   tempItem := TMenuItem.Create(DeletePreset1);
                   tempItem.Caption := Item[n].Items.Value('Name','### ERROR ###');
                   tempItem.ImageIndex := 5;
                   tempItem.Tag:=strtoint(Item[n].Name);
                   tempItem.OnClick := OnDeletePresetClick;
                   DeletePreset1.Add(tempItem);
              end;

          {Load Preset for all Objects}
          for n:=0 to Count-1 do
              if Item[n].Items.Value('ObjectFile','...')=ObjectFile then
              begin
                   tempItem := TMenuItem.Create(LoadAll1);
                   tempItem.Caption := Item[n].Items.Value('Name','### ERROR ###');
                   tempItem.ImageIndex := 5;
                   tempItem.Tag:=strtoint(Item[n].Name);
                   tempItem.OnClick := OnLoadPresetAllClick;
                   LoadAll1.Add(tempItem);
              end;                            
     end;
     XML.Free;
end;


// ######################################


procedure TSharpDeskMainForm.UnlockAllObjects1Click(Sender: TObject);
begin
  SharpDesk.UnLockAllObjects;
end;


// ######################################


procedure TSharpDeskMainForm.ApplicationEvents1Deactivate(Sender: TObject);
begin
  SharpDesk.UnselectAll;
  SharpDesk.LastLayer := -1;
  SharpApi.SendDebugMessage('DESK','MOUSE LEAVE',0);
end;

procedure TSharpDeskMainForm.FormDestroy(Sender: TObject);
begin
  SendMessageToConsole('Main window destroyed',COLOR_OK,DMT_STATUS);
end;

procedure TSharpDeskMainForm.Delete1Click(Sender: TObject);
begin
  SharpDesk.DeleteSelectedLayers;
  SharpDesk.LastLayer := - 1;
end;


procedure TSharpDeskMainForm.Clone1Click(Sender: TObject);
begin
  SharpDesk.CloneSelectedObjects;
end;

procedure TSharpDeskMainForm.FormResize(Sender: TObject);
begin
     SharpDesk.ResizeBackgroundLayer;
     if not startup then
     begin
          SharpDeskMainForm.SendMessageToConsole('loading wallpaper settings',COLOR_OK,DMT_STATUS);
          SharpDeskMainForm.SendMessageToConsole('loading wallpaper',COLOR_OK,DMT_STATUS);
          Background.Reload;
     end;
end;

procedure TSharpDeskMainForm.FormPaint(Sender: TObject);
begin
  Startup := False;
end;

procedure TSharpDeskMainForm.CheckThemeTimerTimer(Sender: TObject);
var
   MuteXHandle : THandle;
begin
  MutexHandle := OpenMuteX(MUTEX_ALL_ACCESS	, False, 'SharpThemeMutex');
  if MuteXHandle = 0 then
  begin
    CheckThemeTimer.Enabled := False;
    SharpDeskMainForm.Enabled := True;
  end;
  CloseHandle(MuteXHandle);
end;

procedure TSharpDeskMainForm.NewAligns1Click(Sender: TObject);
var
   AlignSettingsForm : TAlignSettingsForm;
   XML : TJvSimpleXML;
   n,max : integer;
begin
     AlignSettingsForm := TAlignSettingsForm.Create(Application);
     if AlignSettingsForm.Showmodal = mrOk then
     begin
          SharpDesk.CheckAlignsFile;
          if not FileExists(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml') then exit;

          XML := TJvSimpleXML.Create(nil);
          XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml');
          max := 0;
          for n:=0 to XML.Root.Items.Count - 1 do
              if strtoint(XML.Root.Items.Item[n].Name)>=max then
                 max := strtoint(XML.Root.Items.Item[n].Name) + 1;
          with XML.Root.Items.Add(inttostr(Max)).Items do
          begin
               Add('X',AlignSettingsForm.tb_x.position);
               Add('Y',AlignSettingsForm.tb_y.position);
               Add('Wrap',AlignSettingsForm.tb_wrap.position);
               Add('Name',AlignSettingsForm.edit_name.Text);
               if AlignSettingsForm.cb_left.Checked then n := 0
                  else if alignSettingsForm.cb_right.Checked then n := 2
                       else n := 1;
               Add('Align',n);
          end;
          XML.SaveToFile(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml');
          XML.Free;
     end;
end;

procedure TSharpDeskMainForm.ObjectPopup2Popup(Sender: TObject);
var
   n,i : integer;
   tempItem : TMenuItem;
   XML : TJvSimpleXML;
   SList : TStringList;
   //DesktopObject : TDesktopObject;
   ObjectFile    : String;
begin
  i := Align2.Count - 1;
  for n:=4 to i do
      Align2.Delete(4);
  Delete2.Clear;
  Edit1.Clear;

  SList := TStringList.Create;
  SList.Clear;
  for n := 0 to SharpDesk.ObjectSetList.Count - 1 do
      if TObjectSet(SharpDesk.ObjectSetList.Items[n]).ThemeList.IndexOf(SharpThemeApi.GetThemeName) >= 0 then
         SList.Add(inttostr(TObjectSet(SharpDesk.ObjectSetList.Items[n]).SetID));
  while ObjectSet1.Count>2 do ObjectSet1.Delete(2);
  for n := 0 to SharpDesk.ObjectSetList.Count - 1 do
  begin
    if SList.IndexOf(inttostr(TObjectSet(SharpDesk.ObjectSetList.Items[n]).SetID))<>-1 then
    begin
      tempItem := TMenuItem.Create(ObjectSet1);
      tempItem.Caption := TObjectSet(SharpDesk.ObjectSetList.Items[n]).Name;
      tempItem.ImageIndex := 7;
      tempItem.Tag := n;
      tempItem.OnClick := OnObjectAssignSetClick;
      ObjectSet1.Add(tempItem);
    end;
  end;
  SList.Free;

  SharpDesk.CheckAlignsFile;
  if not FileExists(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml') then exit;
  
  XML := TJvSimpleXML.Create(nil);
  XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml');
  for n:=0 to XML.Root.Items.Count - 1 do
  begin
    tempItem := TMenuItem.Create(Align2);
    tempItem.Caption := XML.Root.Items.Item[n].Items.Value('Name','---');
    tempItem.ImageIndex := 11;
    tempItem.Tag := strtoint(XML.Root.Items.Item[n].Name);
    tempItem.OnClick := OnObjectAlignClick;
    Align2.Add(tempItem);

    tempItem := TMenuItem.Create(Edit1);
    tempItem.Caption := XML.Root.Items.Item[n].Items.Value('Name','---');
    tempItem.ImageIndex := 11;
    tempItem.Tag := strtoint(XML.Root.Items.Item[n].Name);
    tempItem.OnClick := OnObjectAlignEditClick;
    Edit1.Add(tempItem);

    tempItem := TMenuItem.Create(Delete2);
    tempItem.Caption := XML.Root.Items.Item[n].Items.Value('Name','---');
    tempItem.ImageIndex := 11;
    tempItem.Tag := strtoint(XML.Root.Items.Item[n].Name);
    tempItem.OnClick := OnObjectAlignDeleteClick;
    Delete2.Add(tempItem);
  end;
  XML.Free;

  ObjectFile := SharpDesk.SelectedObjectsOfSameType('');
  if ObjectFile <> '0' then
  begin
    ObjectPreset2.Enabled := True;
    LoadPreset2.Enabled   := True;
    LoadPreset2.Clear;
    XML := TJvSimpleXML.Create(nil);
    XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Presets.xml');
    with XML.Root.Items.ItemNamed['PresetList'].Items do
    begin
      {Load Preset}
      for n:=0 to Count-1 do
      if Item[n].Items.Value('ObjectFile','...')=ObjectFile then
      begin
        tempItem := TMenuItem.Create(LoadPreset2);
        tempItem.Caption := Item[n].Items.Value('Name','### ERROR ###');
        tempItem.ImageIndex := 7;
        tempItem.Tag:=strtoint(Item[n].Name);
        tempItem.OnClick := OnLoadPresetClickSelected;
        LoadPreset2.Add(tempItem);
      end;
    end;
    XML.Free;
  end else
  begin
    ObjectPreset2.Enabled := False;
    LoadPreset2.Enabled   := False;
  end;
end;


procedure TSharpDeskMainForm.OnObjectAssignSetClick(Sender : TObject);
begin
  if not (Sender is TMenuItem) then exit;
  SharpDesk.AssignSelectedObjectsToSet(TMenuItem(Sender).Tag);
end;

procedure TSharpDeskMainForm.OnObjectAlignClick(Sender : TObject);
begin
  if not (Sender is TMenuItem) then exit;
  SharpDesk.AlignSelectedObjects(TMenuItem(Sender).Tag);
end;

procedure TSharpDeskMainForm.OnObjectAlignDeleteClick(Sender : TObject);
var
   XML : TJvSimpleXML;
begin
     if not (Sender is TMenuItem) then exit;
     SharpDesk.CheckAlignsFile;     
     if not FileExists(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml') then exit;
     XML := TJvSimpleXML.Create(nil);
     XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml');
     XML.Root.Items.Delete(inttostr(TMenuItem(SendeR).Tag));
     XMl.SaveToFile(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml');
     XML.Free;
end;

procedure TSharpDeskMainForm.OnObjectAlignEditClick(Sender : TObject);
var
   XML : TJvSimpleXML;
   AlignSettingsForm : TAlignSettingsForm;
   n : integer;
begin
     if not (Sender is TMenuItem) then exit;
     SharpDesk.CheckAlignsFile;
     if not FileExists(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml') then exit;
     XML := TJvSimpleXML.Create(nil);
     XML.LoadFromFile(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml');

     AlignSettingsForm := TAlignSettingsForm.Create(Application);

     with XML.Root.Items.ItemNamed[inttostr(TMenuItem(Sender).Tag)].Items do
     begin
          AlignSettingsForm.edit_name.Text := Value('Name','---');
          AlignSettingsForm.tb_x.Position := IntValue('X',64);
          AlignSettingsForm.tb_y.Position := IntValue('Y',64);
          AlignSettingsForm.tb_wrap.Position := IntValue('Wrap',8);
          AlignSettingsForm.tb_xChange(AlignSettingsForm.tb_x);
          AlignSettingsForm.tb_yChange(AlignSettingsForm.tb_y);
          AlignSettingsForm.tb_wrapChange(AlignSettingsForm.tb_wrap);
          n := IntValue('Align',0);
          case n of
           0: AlignSettingsForm.cb_left.Checked := True;
           1: AlignSettingsForm.cb_center.Checked := True;
           else AlignSettingsForm.cb_center.Checked := True;
          end;
          if AlignSettingsForm.ShowModal = mrOk then
          begin
               Clear;
               Add('X',AlignSettingsForm.tb_x.position);
               Add('Y',AlignSettingsForm.tb_y.position);
               Add('Wrap',AlignSettingsForm.tb_wrap.position);
               Add('Name',AlignSettingsForm.edit_name.Text);
               if AlignSettingsForm.cb_left.Checked then n := 0
                  else if alignSettingsForm.cb_right.Checked then n := 2
                       else n := 1;
               Add('Align',n);               
          end;
     end;

     FreeAndNil(AlignSettingsForm);

     XMl.SaveToFile(GetSharpeUserSettingsPath + 'SharpDesk\Aligns.xml');
     XML.Free;
end;

procedure TSharpDeskMainForm.UnLoadObjects1Click(Sender: TObject);
begin
  SharpDesk.ObjectFileList.UnLoadAll;
end;

procedure TSharpDeskMainForm.LoadObjects1Click(Sender: TObject);
begin
  SharpDesk.ObjectFileList.ReLoadAllObjects;
  SharpDesk.LoadObjectSetsFromTheme(SharpThemeApi.GetThemeName);
end;

procedure TSharpDeskMainForm.RefreshObjectDirectory1Click(Sender: TObject);
begin
  SharpDesk.ObjectFileList.UnLoadAll;
  SharpDesk.ObjectFileList.RefreshDirectory;
  SharpDesk.ObjectFileList.ReLoadAllObjects;
  SharpDesk.LoadObjectSetsFromTheme(SharpThemeApi.GetThemeName);
end;

procedure TSharpDeskMainForm.LockObjects1Click(Sender: TObject);
begin
  SharpDesk.LockSelectedObjects;
end;

procedure TSharpDeskMainForm.UnlockObjects1Click(Sender: TObject);
begin
  SharpDesk.UnLockSelectedObjects;
end;

procedure TSharpDeskMainForm.All1Click(Sender: TObject);
begin
  SharpDesk.SelectAll;
end;

procedure TSharpDeskMainForm.OnSelectByObjectSetClick(Sender : TObject);
begin
  if not (Sender is TMenuItem) then exit;
  SharpDesk.SelectBySetID(TMenuItem(Sender).Tag);
end;

procedure TSharpDeskMainForm.sameObjectSet1Click(Sender: TObject);
var
   DesktopObject : TDesktopObject;
begin
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  if DesktopObject = nil then exit;
  SharpDesk.SelectBySetID(TObjectSet(DesktopObject.Settings.Owner).SetID);
end;

procedure TSharpDeskMainForm.WMWeatherUpdate(var msg : TMessage);
begin
  SharpDesk.SendMessageToAllObjects(SDM_WEATHER_UPDATE,0,0,0);
end;

procedure TSharpDeskMainForm.NewObjectSetClick(Sender: TObject);
var
  s : String;
begin
  s:= InputBox('Create Object Set','Object Set name : ','');
  if (length(Trim(s)) = 0) or (s='') then exit;
  SharpDesk.ObjectSetList.AddObjectSet(s,SharpThemeApi.GetThemeName);
  SharpDesk.ObjectSetList.SaveSettings;
  SharpDesk.AssignSelectedObjectsToSet(SharpDesk.ObjectSetList.Count-1);
end;


procedure TSharpDeskMainForm.MakeWindow1Click(Sender: TObject);
var
   DesktopObject : TDesktopObject;
begin
  DesktopObject := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  if DesktopObject = nil then exit;
  if MakeWindow1.Checked then DesktopObject.MakeLayer
     else DesktopObject.MakeWindow;
  MakeWindow1.Checked := not MakeWindow1.Checked;
  SharpDesk.AlignSelectedObjectsToGrid;
  SharpDesk.ObjectSetList.SaveSettings;
//  if MakeWindow1.ImageIndex = 29 then
  //   DesktopObject.MakeWindow
//     else DesktopObject.MakeLayer;
end;

end.
