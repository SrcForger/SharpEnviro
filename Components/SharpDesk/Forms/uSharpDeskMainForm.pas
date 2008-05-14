{
Source Name: uSharpDeskMainForm.pas
Description: Main window for displaying and controling all desktop objects
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
  uSharpDeskObjectSet,
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
    ApplicationEvents1: TApplicationEvents;
    ObjectPopup2: TPopupMenu;
    Delete1: TMenuItem;
    Clone1: TMenuItem;
    N8: TMenuItem;
    BringtoFront2: TMenuItem;
    SendtoBack1: TMenuItem;
    ENDOFCUSTOMMENU: TMenuItem;
    N4: TMenuItem;
    Align2: TMenuItem;
    NewAligns1: TMenuItem;
    N5: TMenuItem;
    Edit1: TMenuItem;
    Delete2: TMenuItem;
    ObjectAlig1: TMenuItem;
    LockObjects1: TMenuItem;
    UnlockObjects1: TMenuItem;
    Aligntogrid1: TMenuItem;
    Objectselections1: TMenuItem;
    All1: TMenuItem;
    N9: TMenuItem;
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
    N13: TMenuItem;
    Lock1: TMenuItem;
    N6: TMenuItem;
    N1: TMenuItem;
    N10: TMenuItem;
    N14: TMenuItem;
    PngImageList2: TPngImageList;
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
    procedure NewAligns1Click(Sender: TObject);
    procedure ObjectPopup2Popup(Sender: TObject);
    procedure LockObjects1Click(Sender: TObject);
    procedure UnlockObjects1Click(Sender: TObject);
    procedure All1Click(Sender: TObject);
    procedure MakeWindow1Click(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
  private
    procedure WMSettingsChange(var Msg : TMessage);       message WM_SETTINGCHANGE;
    procedure WMDisplayChange(var Msg : TMessage);        message WM_DISPLAYCHANGE;
    procedure WMDeskExportBackground(var Msg : TMessage); message WM_DESKEXPORTBACKGROUND;
    procedure WMUpdateBangs(var Msg : TMessage);          message WM_SHARPEUPDATEACTIONS;
    procedure WMSharpEBang(var Msg : TMessage);           message WM_SHARPEACTIONMESSAGE;
    procedure WMPosChanging(var Msg: TWMWindowPosMsg);    message WM_WINDOWPOSCHANGING;
    procedure WMSharpEUppdateSettings(var msg: TMessage); message WM_SHARPEUPDATESETTINGS;
    procedure WMCloseDesk(var msg : TMEssage);            message WM_CLOSEDESK;
    procedure WMWeatherUpdate(var msg : TMessage);        message WM_WEATHERUPDATE;
    procedure msg_EraseBkgnd(var msg : TMessage);         message WM_ERASEBKGND;
    procedure WMMouseLeave(var Msg: TMessage);            message CM_MOUSELEAVE;
    procedure WMMouseMove(var Msg: TMessage);             message WM_MOUSEMOVE;
    procedure WMSharpTerminate(var Msg : TMessage);       message WM_SHARPTERMINATE;
    procedure WMCopyData(var Msg : TMessage);             message WM_COPYDATA;
    procedure OnCreateNewPresetClick(Sender : TObject);        // PresetMenu event
    procedure OnSaveAsPresetClick(Sender : TObject);           // PresetMenu event
    procedure OnLoadPresetClick(Sender : TObject);             // PresetMenu event
    procedure OnLoadPresetClickSelected(Sender : TObject);     // PresetMenu event
    procedure OnDeletePresetClick(Sender : TObject);           // PresetMenu event
    procedure OnLoadPresetAllClick(Sender : TObject);          // PresetMenu event
    procedure OnObjectAlignClick(Sender : TObject);            // AlignsMenu event
    procedure OnObjectAlignDeleteClick(Sender : TObject);      // AlignsMenu event
    procedure OnObjectAlignEditClick(Sender : TObject);        // AlignsMenu event
  public
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES; // Drag & Drop
    procedure SendMessageToConsole(msg : string; color : integer; DebugLevel : integer);
    procedure LoadTheme(WPChange : boolean);
    procedure UpdateSharpEActions;
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
    THandleArray = array of HWND;


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


uses uSharpDeskAlignSettingsForm,
     uSharpDeskObjectFile,
     uSharpDeskObjectSetItem,
     SharpCenterApi;

{$R *.dfm}

function FindAllWindows(const WindowClass: string): THandleArray;
type
  PParam = ^TParam;
  TParam = record
    ClassName: string;
    Res: THandleArray;
  end;
var
  Rec: TParam;

  function GetWndClass(pHandle: hwnd): string;
  var
    buf: array[0..254] of Char;
  begin
    GetClassName(pHandle, buf, SizeOf(buf));
    result := buf;
  end;

  function _EnumProc(_hWnd: HWND; _LParam: LPARAM): LongBool; stdcall;
  begin
    with PParam(_LParam)^ do
    begin
      if (CompareText(GetWndClass(_hWnd), ClassName) = 0) then
      begin
        SetLength(Res, Length(Res) + 1);
        Res[Length(Res) - 1] := _hWnd;
      end;
      Result := True;
    end;
  end;

begin
  try
    Rec.ClassName := WindowClass;
    SetLength(Rec.Res, 0);
    EnumWindows(@_EnumProc, Integer(@Rec));
  except
    SetLength(Rec.Res, 0);
  end;
  Result := Rec.Res;
end;


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
      if CompareText(SharpApi.GetSharpeUserSettingsPath + 'SharpDeskbg.bmp',WP) <> 0 then
      begin
        Dir := SharpThemeApi.GetThemeDirectory;
        FName := Dir + 'Wallpaper.xml';
        if FileExists(FName) then
        begin
          // Get the name of the primary monitor (ID:-100 = Primary Mon)
          WPName := SharpThemeApi.GetMonitorWallpaper(-100).Name;
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
var
  wnd : hwnd;
  n : integer;
  R : TRect;
  b : boolean;
begin
  wnd := GetForeGroundWindow;
  if wnd <> 0 then
  begin
    b := False;
    // check if a window is running in FullScreen
    if ((GetWindowLong(wnd,GWL_STYLE) and WS_BORDER) = 0) and
       ((GetWindowLong(wnd,GWL_STYLE) and WS_CAPTION) = 0) then
      for n := 0 to Screen.MonitorCount - 1 do
      begin
        GetWindowRect(wnd,R);
        if (R.Left = Screen.Monitors[n].BoundsRect.Left) and
           (R.Right = Screen.Monitors[n].BoundsRect.Right) and
           (R.Top = Screen.Monitors[n].BoundsRect.Top) and
           (R.Bottom = Screen.Monitors[n].BoundsRect.Bottom) then
        begin
          b := True;
          break;
        end;     
      end;

    if (not b) or (wnd = handle) then
    begin
      SharpDeskMainForm.Left := Screen.DesktopLeft;
      SharpDeskMainForm.Top  := Screen.DesktopTop;
      SharpDeskMainForm.Width := Screen.DesktopWidth;
      SharpDeskMainForm.Height := Screen.DesktopHeight;
      Background.Reload(True);
      BackgroundImage.ForceFullInvalidate;
      SharpDesk.BackgroundLayer.Update;
      SharpDesk.BackgroundLayer.Changed;
      SharpCenterApi.BroadcastGlobalUpdateMessage(suDesktopBackgroundChanged,-1,True);
    end;
  end;
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

procedure TSharpDeskMainForm.WMCopyData(var Msg: TMessage);
var
  tmpMsg: TsharpE_DataStruct;
  ofile : TObjectFile;
  SetItem : TObjectSetItem;
  newID : integer;
  s : String;
begin
  tmpMsg := PSharpE_DataStruct(PCopyDataStruct(msg.lParam)^.lpData)^;

  if CompareText(tmpMsg.Command,'AddObject') = 0 then
  begin
    oFile := SharpDesk.ObjectFileList.GetByObjectFile(tmpMsg.Parameter);
    if oFile <> nil then
    begin
      // Add new object
      NewID :=  SharpDesk.ObjectSet.GenerateObjectID;
      SetItem := SharpDesk.ObjectSet.AddDesktopObject(newID,
                                                  OFile.FileName,
                                                  Point(LastX,LastY),
                                                  False,
                                                  False);
      OFile.AddDesktopObject(SetItem);
      SharpDesk.ObjectSet.Save;

      // Open the settings dialog in SharpCenter
      s := OFile.filename;
      setlength(s,length(s) - length(ExtractFileExt(s)));
      SharpCenterApi.CenterCommand(sccLoadSetting,
                                   PChar(SharpApi.GetCenterDirectory + '_Objects\' + s + '.con'),
                                   PChar(inttostr(SetItem.ObjectID)));
    end;
  end;
end;

procedure TSharpDeskMainForm.WMUpdateBangs(var Msg : TMessage);
begin
  UpdateSharpEActions;
end;

function IsTopMost(wnd: HWND): Boolean;
begin
  Result := (GetWindowLong(wnd, GWL_EXSTYLE) and WS_EX_TOPMOST) <> 0;
end;

procedure TSharpDeskMainForm.WMSharpEBang(var Msg : TMessage);
begin
  case msg.LParam of
   1 : WMCloseDesk(msg);
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
      Background.Reload(False);
    end;
    SharpDesk.UpdateAnimationLayer;

    if SharpDesk.DeskSettings.AdvancedMM then SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));
  finally
    BackgroundImage.ForceFullInvalidate;
    SharpDesk.BackgroundLayer.Update;
    SharpDesk.BackgroundLayer.Changed;
    SharpCenterApi.BroadcastGlobalUpdateMessage(suDesktopBackgroundChanged,-1,True);
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


// #################################################
// a setting has changed

procedure TSharpDeskMainForm.WMSharpEUppdateSettings(var msg: TMessage);
begin
  if msg.WParam < 0 then exit;

  if (msg.WParam = Integer(suTheme)) then
  begin
    LoadTheme(True);
    SharpDesk.SendMessageToAllObjects(SDM_SETTINGS_UPDATE,0,0,0);
    exit;
  end;

  if (msg.WParam = Integer(suWallpaper)) or (msg.WParam = Integer(suScheme))
    or (msg.WParam = Integer(suSkin)) then
  begin
    SharpThemeApi.LoadTheme(True,ALL_THEME_PARTS);
    Background.Reload(msg.Wparam = Integer(suScheme));
    BackgroundImage.ForceFullInvalidate;
    SharpDesk.BackgroundLayer.Update;
    SharpDesk.BackgroundLayer.Changed;
    SharpDesk.SendMessageToAllObjects(SDM_SETTINGS_UPDATE,0,0,0);
    if msg.WParam = Integer(suWallpaper) then
      SharpCenterApi.BroadcastGlobalUpdateMessage(suDesktopBackgroundChanged,-1,True);
  end;

  if (msg.WParam = Integer(suSharpDesk)) then
  begin
    SharpDesk.DeskSettings.ReloadSettings;
    if SharpDesk.Desksettings.DragAndDrop then SharpDesk.DragAndDrop.RegisterDragAndDrop(SharpDesk.Image.Parent.Handle)
       else SharpDesk.DragAndDrop.UnregisterDragAndDrop(SharpDesk.Image.Parent.Handle);
  end;

  if (msg.WParam = Integer(suDesktopIcon)) or (msg.WParam = Integer(suIconSet)) then
  begin
    SharpThemeApi.LoadTheme(True,ALL_THEME_PARTS);
    SharpDesk.SendMessageToAllObjects(SDM_SETTINGS_UPDATE,0,0,0);
  end;

  if (msg.WParam = Integer(suDesktopObject)) then
  begin
    SharpDesk.SendMessageToObject(SDM_SETTINGS_UPDATE,msg.LParam,0,0,0);
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
  UpdateSharpEActions;
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
     SharpDesk.LoadObjectSet;
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
  SharpApi.UnRegisterAction('!CloseSharpDesk');
  SharpDesk.ObjectSet.Save;
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
   B : integer;
   DesktopObject : TDesktopObject;
   ActionStr : String;
   CPos : TPoint;
begin
  if not SharpDesk.Enabled then exit;
  SharpDesk.MouseDown:=False;

  if not GetCursorPosSecure(CPos) then
    exit;

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
    SharpDesk.ObjectSet.Save;
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
                                             SDM_MOUSE_UP,CPos.X,CPos.Y,B);
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
      try
        DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                DesktopObject.Layer,
                                                SDM_MENU_POPUP,CPos.X,CPos.Y,0);
      except
        on E: Exception do
        begin
         SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MENU_POPUP to ' + inttostr(DesktopObject.Settings.ObjectID) + '('+DesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
         SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clblue, DMT_TRACE);
        end;
      end;
      //i := ObjectPopUp.Images.Count;
      //ObjectPopUp.Images.AddImages(ObjectMenu.Images);
      //CopyMenuItems(ObjectMenu.Items,ObjectPopUp.Items[0],ObjectPopUpImageCount-(ObjectPopUpImageCount-i),True);

      if ObjectPopUp.Items[0].Name = 'ENDOFCUSTOMMENU' then ObjectPopUp.Items[0].Visible := False
         else ObjectPopUp.Items[0].Visible := True;

      if (SharpDesk.SelectionCount <= 1) then
      begin
        if DesktopObject.Settings.isWindow then MakeWindow1.Checked := True
           else MakeWindow1.Checked := False;
        if DesktopObject.Settings.Locked then LockObjec1.Checked := True
           else LockObjec1.Checked := False;
        ObjectPopUp.Popup(CPos.X,CPos.y);
      end else ObjectPopUp2.Popup(CPos.x,CPos.y);
    end;
  end else
  begin
    LastX:=X;
    LastY:=Y;
    if (Button = mbRight) then
    begin
      ActionStr := inttostr(CPos.X) + ' ' + inttostr(CPos.Y) + ' ' + '1';
      ActionStr := ActionStr + ' "' + SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\';
      if (Shift = [ssShift]) then
        ActionStr := ActionStr + SharpDesk.DeskSettings.MenuFileShift + '.xml"'
      else ActionStr := ActionStr + SharpDesk.DeskSettings.MenuFile + '.xml"';
      ShellApi.ShellExecute(Handle,'open',PChar(GetSharpEDirectory + 'SharpMenu.exe'),PChar(ActionStr),GetSharpEDirectory,SW_SHOWNORMAL);
      //sleep(1000);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar('Menu popup at : ' + inttostr(CPos.X) + '|' + inttostr(CPos.Y)),clblue,DMT_Trace);
    end;
  end;
end;


// ######################################


procedure TSharpDeskMainForm.BackgroundImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var
   CPos,cursorPos : TPoint;
   DesktopObject : TDesktopObject;
   R : TRect;
   n : integer;
   HA : THandleArray;
begin
  if not SharpDesk.Enabled then exit;

  if GetCursorPosSecure(cursorPos) then
    CPos := SharpDesk.Image.ScreenToClient(cursorPos) else
    exit;

  // Check if the click was in an area of visible SharpE Menu
  HA := FindAllWindows('TSharpEMenuWnd');
  if length(HA) > 0 then
  begin
    for n := 0 to High(HA) do
    begin
      GetWindowRect(HA[n],R);
      if PointInRect(CursorPos,R) then
         exit;
    end;
    SendMessage(HA[0],WM_SHARPTERMINATE,0,0);
  end;
  setlength(HA,0);

  if SharpDesk.DoubleClick then
  begin
    SharpDesk.DoubleClick := False;
    exit;
  end;
  if not Assigned(Layer) then exit;

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
       SharpDesk.SelectAll;
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
      SharpDesk.LayerMousePos := SharpDesk.GetNextGridPoint(CursorPos);
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
   CPos,cursorPos : TPoint;
   X1,X2,Y1,Y2 : integer;
   DesktopObject : TDesktopObject;
begin
  if not SharpDesk.Enabled then exit;
  if not Assigned(Layer) then exit;

  if GetCursorPosSecure(cursorPos) then
    CPos := SharpDesk.Image.ScreenToClient(cursorPos) else
    exit;

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
    if SharpDesk.DeskSettings.Grid then CPos := SharpDesk.GetNextGridPoint(CPos);
    X1 := CPos.X-SharpDesk.LayerMousePos.X;
    Y1 := CPos.Y-SharpDesk.LayerMousePos.Y;
    if (X<>0) and (Y<>0) then
    begin
      if Shift = [ssCtrl,ssLeft] then SharpDesk.MoveSelectedLayers(X1,Y1,True)
         else SharpDesk.MoveSelectedLayers(X1,Y1,False);
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
var
  obj : TDesktopObject;
  s : string;
begin
  obj := TDesktopObject(SharpDesk.GetDesktopObjectByID(SharpDesk.LastLayer));
  s := obj.owner.filename;
  setlength(s,length(s) - length(ExtractFileExt(s)));
  SharpCenterApi.CenterCommand(sccLoadSetting,
                               PChar(SharpApi.GetCenterDirectory + '_Objects\' + s + '.con'),
                               PChar(inttostr(obj.Settings.ObjectID)));
  SharpDesk.UnselectAll;
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
    if GetCursorPosSecure(CPos) then
    begin
      CPos := SharpDesk.Image.ScreenToClient(CPos);
      if DesktopObject.Layer.HitTest(CPos.X,CPos.Y) then
         DesktopObject.Owner.DllSharpDeskMessage(DesktopObject.Settings.ObjectID,
                                                 DesktopObject.Layer,
                                                 SDM_DOUBLE_CLICK,
                                                 CPos.X,CPos.Y,0);
    end;
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
    if GetCursorPosSecure(CPos) then
    begin
      CPos := SharpDesk.Image.ScreenToClient(CPos);
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


procedure TSharpDeskMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Params.WinClassName := 'TSharpDeskMainForm';
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE;
    Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
  end;
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
   CPos,CursorPos : TPoint;
begin
  inherited;
  cnt := DragQueryFile(Message.drop, $FFFFFFFF, nil, 0);

  if GetCursorPosSecure(cursorPos) then
    CPos := SharpDesk.Image.ScreenToClient(cursorPos)
  else begin
    DragFinish(Message.Drop);
    exit;    
  end;

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
  SharpDesk.ObjectSet.Save;
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
begin
     if SharpDesk.LastLayer = -1 then exit;

     SharpDesk.CheckPresetsFile;

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
          Background.Reload(False);
     end;
end;

procedure TSharpDeskMainForm.FormPaint(Sender: TObject);
begin
  Startup := False;
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
   ObjectFile    : String;
begin
  i := Align2.Count - 1;
  for n:=4 to i do
      Align2.Delete(4);
  Delete2.Clear;
  Edit1.Clear;

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

procedure TSharpDeskMainForm.LockObjects1Click(Sender: TObject);
begin
  SharpDesk.LockSelectedObjects;
end;

procedure TSharpDeskMainForm.UnlockObjects1Click(Sender: TObject);
begin
  SharpDesk.UnLockSelectedObjects;
end;

procedure TSharpDeskMainForm.UpdateSharpEActions;
begin
  SharpApi.RegisterActionEx('!CloseSharpDesk','SharpDesk',SharpDeskMainForm.Handle,1);
end;

procedure TSharpDeskMainForm.All1Click(Sender: TObject);
begin
  SharpDesk.SelectAll;
end;


procedure TSharpDeskMainForm.WMWeatherUpdate(var msg : TMessage);
begin
  SharpDesk.SendMessageToAllObjects(SDM_WEATHER_UPDATE,0,0,0);
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
  SharpDesk.ObjectSet.Save;
//  if MakeWindow1.ImageIndex = 29 then
  //   DesktopObject.MakeWindow
//     else DesktopObject.MakeLayer;
end;

end.
