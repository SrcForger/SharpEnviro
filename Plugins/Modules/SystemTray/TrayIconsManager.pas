{
Source Name: TrayIconsManager
Description: Icon messaging and handling class
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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

unit TrayIconsManager;

interface

uses Windows, Dialogs, SysUtils, Classes,
  CommCtrl,
  Forms, Controls, Messages, Types, Graphics, Contnrs, ExtCtrls,
  GR32,
  SharpApi,
  GR32_Filters,
  GR32_Resamplers,
  WinVer,
  uTypes,
  DateUtils,
  JclSysInfo,
  Math,
  SharpThemeApiEx,
  SharpGraphicsUtils,
  SharpIconUtils,
  SharpNotify,
  uSystemFuncs;

type
  TOnSaveSettings = procedure of Object;
  TOnPaintLock = procedure(lock: Boolean) of Object;

  TTrayChangeEvent = (tceIcon, tceTip, tceVersion);
  TTrayChangeEvents = Set of TTrayChangeEvent;

  TMsgWnd = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormCreate(Sender: TObject);
  private
    procedure IncomingTrayMsg(var Msg: TMessage); message WM_COPYDATA;
  public
    FTrayClient: TObject;
    isClosing: boolean;
    procedure RegisterWithTray;
  end;

  TTrayStartItem = class
  private
    FPath: String;
    FGUID: String;
    FUID: Cardinal;
    FWndClass: String;

    FPosition: integer;
    FHiddenByClient: boolean;

  public
    property Path: String read FPath write FPath;
    property GUID: String read FGUID write FGUID;
    property UID: Cardinal read FUID write FUID;
    property WndClass: String read FWndClass write FWndClass;

    property Position: Integer read FPosition write FPosition;
    property HiddenByClient: Boolean read FHiddenByClient write FHiddenByClient;
  end;

  TTrayItem = class
  private
    FPath: String;
    FWndClass: String;

    FUID: Cardinal;
    FWnd: Thandle;
    FCallbackMessage: UINT;
    FBitmap: TBitmap32;
    FIcon: hIcon;
    FIconSize: Integer;
    FFlags: Cardinal;
    FBTimeOut: Cardinal;
    FBInfoFlags: DWORD;
    FOwner: TObject;
    FTipIndex: integer;
    FIsHovering: boolean;
    FVersion: integer;
    FModX: integer;
    FPosition: integer;
    FGUIDItem: TGUID;
    FGUIDString: String;

  public
    FTip: ArrayWideChar128;
    FInfo: ArrayWideChar256;
    FInfoTitle: ArrayWideChar64;

    function AssignFromNIDv6(NIDv6: TNotifyIconDataV7): TTrayChangeEvents;

    constructor Create(dup: TTrayItem); overload;
    constructor Create(NIDv6: TNotifyIconDataV7; IconSize: Integer); overload;
    destructor Destroy; override;

    function Compare(startItem: TTrayStartItem): boolean;

    property Path: String read FPath write FPath;
    property WndClass: String read FWndClass write FWndClass;

    property GUID: String read FGUIDString write FGUIDString;
    property UID: Cardinal read FUID;
    property Wnd: THandle read FWnd;
    property Bitmap: TBitmap32 read FBitmap;
    property Icon: hIcon read FIcon;
    property CallbackMessage: UINT read FCallbackMessage;
    property Flags: Cardinal read FFlags;
    property BTimeout: Cardinal read FBTimeout;
    property BInfoFlags: DWORD read FBInfoFlags;
    property Owner: TObject read FOwner write FOwner;
    property TipIndex: integer read FTipIndex write FTipIndex;
    property IsHovering: boolean read FIsHovering write FIsHovering;
    property Version: integer read FVersion write FVersion;
    property ModX: integer read FModX write FModX;
    property Position: integer read FPosition write FPosition;
  end;

  TTrayClient = class
  private
    FTipWnd: hwnd;
    FTipForm: TForm;
    FMsgWnd: TMsgWnd;
    FV4Popup: TTrayItem;
    FIconAutoSize: Boolean;
    FIconSize: integer;
    FIconSpacing: integer;
    FTopSpacing: integer;
    FTopOffset: integer;
    FBitmap: TBitmap32;
    FWinVersion: Cardinal;
    FTipTimer: TTimer;
    FLastTipItem: TTrayItem;
    FTipPoint: TPoint;
    FTipGPoint: TPoint;
    FIconAlpha: integer;
    FColorBlend: boolean;
    FBlendColor: integer;
    FBlendAlpha: integer;
    FBackGroundColor: TColor32;
    FBorderColor: TColor32;
    FDrawBackground: boolean;
    FDrawBorder: boolean;
    FBackgroundAlpha: integer;
    FBorderAlpha: integer;
    FRepaintHash: integer;
    FScreenPos: TPoint;
    FLastMessage: Int64;
    FArrowWidth: integer;
    FArrowHeight: integer;

    FItems: TObjectList;
    FHiddenItems: TObjectList;
    FStartItems: TObjectList;
    FStartHidden: boolean;

    FOnSaveSettings: TOnSaveSettings;
    FOnAddIcon: TOnSaveSettings;
    FOnPaintLock: TOnPaintLock;

    procedure FOnBallonClick(wnd: hwnd; ID: Cardinal; Data: TObject; Msg: integer);
    procedure FOnBallonShow(wnd: hwnd; ID: Cardinal; Data: TObject);
    procedure FOnBallonTimeOut(wnd: hwnd; ID: Cardinal; Data: TObject);
    procedure FOnTipTimer(Sender: TObject);
    procedure NewRepaintHash;
    procedure RenderIcon(item: TTrayItem; n: integer);

  public
    function GetTrayIconIndex(pWnd: THandle; UID: Cardinal): integer;
    function GetHiddenTrayIconIndex(pWnd: THandle; UID: Cardinal): integer;
    function GetTrayIcon(pWnd: THandle; UID: Cardinal): TTrayItem;
    procedure AddOrModifyTrayIcon(NIDv6: TNotifyIconDataV7);
    procedure AddTrayIcon(NIDv6: TNotifyIconDataV7); overload;
    procedure AddTrayIcon(item: TTrayItem; addItem: boolean = true); overload;
    procedure ModifyTrayIcon(NIDv6: TNotifyIconDataV7);
    procedure DeleteTrayIcon(NIDv6: TNotifyIconDataV7);
    procedure DeleteTrayIconByIndex(index: integer; Hidden: Boolean = False);

    procedure UpdateTrayIcons;
    procedure UpdatePositions;

    function GetLastPosition: integer;
    function GetAvailablePosition(p: integer): integer;

    procedure RenderIcons;
    function PerformIconAction(x, y, gx, gy, imod: integer; msg: uint; parent: TForm): boolean;
    procedure StartTipTimer(x, y, gx, gy: integer);
    procedure StopTipTimer;
    procedure CloseVistaInfoTip;

    function GetIconPos(item: TTrayItem): TPoint;
    function GetIconAtPos(pt: TPoint): TTrayItem;

    function IconExists(item: TTrayItem): Boolean;
    procedure RegisterWithTray;
    procedure ClearTrayIcons;
    procedure SetBorderColor(Value: TColor32);
    procedure SetBackgroundColor(Value: TColor32);
    procedure SetBlendColor(Value: integer);
    procedure SetBorderAlpha(Value: integer);
    procedure SetBackgroundAlpha(Value: integer);
    procedure SetBlendAlpha(Value: integer);
    procedure SetIconAlpha(Value: integer);
    procedure SetIconAutoSize(Value: Boolean);
    procedure PositionTrayWindow(parent, trayParent: HWND);
    procedure InitToolTips(wnd: TObject);
    procedure DeleteToolTips;
    function GetFreeTipIndex: integer;
    function Print : String;

    constructor Create; reintroduce;
    destructor Destroy; override;

    property Bitmap: TBitmap32 read FBitmap;
    property IconAlpha: integer read FIconAlpha write SetIconAlpha;
    property IconAutoSize: Boolean read FIconAutoSize write SetIconAutoSize;
    property IconSize: integer read FIconSize write FIconSize;
    property IconSpacing: integer read FIconSpacing write FIconSpacing;
    property TopOffset: integer read FTopOffset write FTopOffset;
    property TopSpacing: integer read FTopSpacing write FTopSpacing;
    property ColorBlend: boolean read FColorBlend write FColorBlend;
    property BlendColor: integer read FBlendColor write SetBlendColor;
    property BlendAlpha: integer read FBlendAlpha write SetBlendAlpha;
    property DrawBackground: boolean read FDrawBackground write FDrawBackground;
    property DrawBorder: boolean read FDrawBorder write FDrawBorder;
    property BackGroundColor: TColor32 read FBackGroundColor write SetBackgroundColor;
    property BorderColor: TColor32 read FBorderColor write SetBorderColor;
    property BackgroundAlpha: integer read FBackgroundAlpha write SetBackgroundAlpha;
    property BorderAlpha: integer read FBorderAlpha write SetBorderAlpha;
    property RepaintHash: integer read FRepaintHash write FRepaintHash;
    property ScreenPos: TPoint read FScreenPos write FScreenPos;
    property LastMessage: Int64 read FLastMessage;
    property LastTipItem: TTrayItem read FLastTipItem;
    property TipGPoint: TPoint read FTipGPoint;
    property TipWnd: hwnd read FTipWnd;
    property TipForm: TForm read FTipForm;

    property ArrowWidth: integer read FArrowWidth write FArrowWidth;
    property ArrowHeight: integer read FArrowHeight write FArrowHeight;

    property Items: TObjectList read FItems;
    property HiddenItems: TObjectList read FHiddenItems;
    property StartItems: TObjectList read FStartItems;

    property StartHidden: Boolean read FStartHidden write FStartHidden;

    property OnSaveSettings: TOnSaveSettings read FOnSaveSettings write FOnSaveSettings;
    property OnAddIcon: TOnSaveSettings read FOnAddIcon write FOnAddIcon;
    property OnPaintLock: TOnPaintLock read FOnPaintLock write FOnPaintLock;
  end;

function AllowSetForegroundWindow(ProcessID: DWORD): boolean; stdcall; external 'user32.dll' name 'AllowSetForegroundWindow';

{$R *.dfm}

implementation

uses ToolTipApi, MainWnd;


function ColorToColor32Alpha(Color: TColor; Alpha: integer): TColor32;
var
  R, G, B, A: byte;
begin
  R := GetRValue(Color);
  G := GetGValue(Color);
  B := GetBValue(Color);
  A := Alpha;
  if Alpha > 255 then
  begin
    A := 255
  end
  else
  if Alpha < 0 then
  begin
    A := 0
  end;
  result := Color32(R, G, B, A);
end;


function PointInRect(P: TPoint; Rect: TRect): boolean;
begin
  if (P.X >= Rect.Left) and (P.X <= Rect.Right)
    and (P.Y >= Rect.Top) and (P.Y <= Rect.Bottom) then
  begin
    PointInRect := True
  end
  else
  begin
    PointInRect := False
  end;
end;

function GetCurrentMonitor: integer;
var
  n: integer;
  CPos: TPoint;
begin
  CPos := Mouse.Cursorpos;
  for n := 0 to Screen.MonitorCount - 1 do
  begin
    if PointInRect(CPos, Screen.Monitors[n].BoundsRect) then
    begin
      result := n;
      exit;
    end
  end;
  // something went wrong and the cursor isn't in any monitor
  result := 0;
end;

procedure TMsgWnd.RegisterWithTray;
begin
  PostMessage(FindWindow('Shell_TrayWnd', nil), WM_REGISTERWITHTRAY, handle, 0);
end;

procedure TMsgWnd.CreateParams(var Params: TCreateParams);
begin
  try
    inherited CreateParams(Params);
    with Params do
    begin
      Params.WinClassName := 'SharpETrayModuleMsgWnd';
      ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
      Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
    end;
  except
    on E: Exception do
   //   SendTrayErrorMessage('Problem creating MainWindow', E);
  end;
end;

procedure TMsgWnd.IncomingTrayMsg(var Msg: TMessage);
var
  TrayCmd: integer;
  Icondata: TNotifyIconDataV7;
  data: pCopyDataStruct;
begin
  if isClosing then
  begin
    exit
  end;
  try
    Data := pCopyDataStruct(Msg.LParam);
    if (Data.dwData = 1) or (Data.dwData = 2) then
    begin
      TrayCmd := Data.dwData;
      Icondata := pNotifyIconDataV7(Data.lpdata)^;
      case TrayCmd of
        1:
        begin
          TTrayClient(FTrayClient).AddOrModifyTrayIcon(IconData);
        end;

        2:
        begin
          TTrayClient(FTrayClient).DeleteTrayIcon(IconData);
        end;
      end;
      //important to return value <> 0
      msg.Result := 5;
    end
    else
    begin
      msg.Result := DefWindowProc(Handle, Msg.Msg, Msg.WParam, Msg.LParam)
    end;
  except
    msg.Result := DefWindowProc(Handle, Msg.Msg, Msg.WParam, Msg.LParam);
  end;
end;

procedure TMsgWnd.FormCreate(Sender: TObject);
begin
  isClosing := False;
  left := -200;
  top := -200;
  Width := 1;
  Height := 1;
  
  PostMessage(FindWindow('Shell_TrayWnd', nil), WM_REGISTERWITHTRAY, handle, 0);
  PostMessage(FindWindow('Shell_TrayWnd', nil), WM_SHARPREGISTERTRAY, 0, 0);
end;

procedure TMsgWnd.FormDestroy(Sender: TObject);
begin
  isClosing := True;
  PostMessage(FindWindow('Shell_TrayWnd', nil), WM_UNREGISTERWITHTRAY, handle, 0);
end;

constructor TTrayItem.Create(dup: TTrayItem);
begin
  FPath := dup.FPath;
  FWndClass := dup.WndClass;
  FGUIDString :=  dup.GUID;
  FUID := dup.FUID;
  FWnd := dup.FWnd;
  FCallbackMessage := dup.FCallbackMessage;
  FBitmap := TBitmap32.Create;
  FBitmap.Assign(dup.FBitmap);
  FIcon := dup.FIcon;
  FIconSize := dup.FIconSize;
  FFlags := dup.FFlags;
  FBTimeOut := dup.FBTimeOut;
  FBInfoFlags := dup.FBInfoFlags;
  FOwner := dup.FOwner;
  FTipIndex := dup.FTipIndex;
  FIsHovering := dup.FIsHovering;
  FVersion := dup.FVersion;
  FModX := dup.FModX;
  FPosition := dup.FPosition;
  FGUIDItem := dup.FGUIDItem;
  FGUIDString := dup.FGUIDString;
  FTip := dup.FTip;
  FInfo := dup.FInfo;
  FInfoTitle := dup.FInfoTitle;

  Inherited Create;
end;

constructor TTrayItem.Create(NIDv6: TNotifyIconDataV7; IconSize: Integer);
begin
  FIconSize := IconSize;
  FBitmap := TBitmap32.Create;
  FBitmap.SetSize(FIconSize, FIconSize);
  FIsHovering := False;
  FPosition := -1;
  FModX := 0;
  FGUIDString := '';

  // If the size is the default size or less use the TLinearResampler,
  // when scaling up use TKernelResampler for better quality.
  if FIconSize <= 16 then
  begin
    TLinearResampler.Create(FBitmap)
  end
  else
  begin
    TKernelResampler.Create(FBitmap).Kernel := TLanczosKernel.Create
  end;
  AssignFromNIDv6(NIDv6);

  FPath := GetProcessNameFromWnd(FWnd);
  FWndClass := GetWndClass(FWnd);

  Inherited Create;
end;

destructor TTrayItem.Destroy;
begin
  FBitmap.Free;
  Inherited Destroy;
end;

// return value = True if icon changed
function TTrayItem.AssignFromNIDv6(NIDv6: TNotifyIconDataV7): TTrayChangeEvents;
var
  oTip: String;
  oVersion: integer;
begin
  result := [];
  if NIDv6.uCallbackMessage <> 0 then
  begin
    FCallbackMessage := NIDv6.uCallbackMessage
  end;
  FUID := NIDv6.UID;
  FWnd := NIDv6.Wnd;

  oTip := FTip;
  FTip := NIDv6.szTip;
  if CompareText(oTip, FTip) <> 0 then
  begin
    result := result + [tceTip]
  end;

  if (NIDv6.uFlags and NIF_INFO) = NIF_INFO then
  begin
    FInfo := NIDv6.szInfo;
    FInfoTitle := NIDv6.szInfoTitle;
    FBTimeOut := NIDv6.Union.uTimeOut;
    FBInfoFlags := NIDv6.dwInfoFlags;
  end;

  if (NIDv6.uFlags and NIF_GUID) = NIF_GUID then
  begin
    FGUIDItem := NIDv6.guidItem;
    FGUIDString := GUIDToString(FGUIDItem);
  end;

  oVersion := NIDv6.Union.uVersion;
  FVersion := NIDv6.Union.uVersion;
  if oVersion <> Integer(FVersion) then
  begin
    result := result + [tceVersion]
  end;

  FFlags := NIDv6.uFlags;

  if (NIDv6.Icon <> 0) and (NIDv6.Icon <> FIcon) then
  begin
    FIcon := NIDv6.Icon;
    FBitmap.Clear(color32(0, 0, 0, 0));
    IconToImage(FBitmap, NIDv6.icon);
    result := result + [tceIcon];
  end;
end;

function TTrayItem.Compare(startItem: TTrayStartItem): boolean;
begin
  Result := (CompareText(startItem.Path, FPath) = 0);
  if startItem.GUID <> '' then
    Result := (Result) and (CompareText(startItem.GUID, FGUIDString) = 0)
  else
  begin
    Result := (Result) and
      ((CompareText(startItem.WndClass, FWndClass) = 0) or
      (startItem.FUID = FUID));
  end;
end;

constructor TTrayClient.Create;
begin
  inherited Create;

  Randomize;
  NewRepaintHash;
  FColorBlend := False;
  FIconAlpha := 255;
  FBlendAlpha := 255;
  FBlendColor := 0;
  FDrawBackground := True;
  FDrawBorder := True;
  FBackgroundAlpha := 255;
  FBorderAlpha := 255;
  FIconAutoSize := False;
  FIconSize := 16;
  FIconSpacing := 2;
  FTopSpacing := 2;
  FLastMessage := DateTimeToUnix(now);

  FItems := TObjectList.Create(True);
  FHiddenItems := TObjectList.Create(True);
  FStartItems := TObjectList.Create(True);
  FStartHidden := False;

  FBitmap := Tbitmap32.Create;
  FWinVersion := GetWinVer;
  FTipTimer := TTimer.Create(nil);
  FTipTimer.Interval := 500;
  FTipTimer.Enabled := False;
  FTipTimer.OnTimer := FOnTipTimer;
  FLastTipItem := nil;
  FBackGroundColor := Color32(128, 128, 128, 128);
  FBorderColor := Color32(0, 0, 0, 128);

  FArrowWidth := 16;
  FArrowHeight := 25;

  FMsgWnd := TMsgWnd.Create(nil);
  FMsgWnd.FTrayClient := self;

  SharpNotifyEvent.OnClick := FOnBallonClick;
  SharpNotifyEvent.OnShow := FOnBallonShow;
  SharpNotifyEvent.OnTimeout := FOnBallonTimeout;

  FTipWnd := 0;
  FTipForm := nil;
end;

procedure TTrayClient.InitToolTips(wnd: TObject);
begin
  FTipForm := TMainForm(wnd);
  FTipWnd := ToolTipApi.RegisterToolTip(TMainForm(wnd));

  ToolTipApi.AddToolTip(FTipWnd, FTipForm, 0, Rect(0, 0, FArrowWidth, FArrowHeight), 'Hidden Icons' + sLineBreak + 'Drop icons here to hide them');
  SendMessage(FTipWnd, TTM_SETMAXTIPWIDTH, 0, 300);

  UpdateTrayIcons;
end;

procedure TTrayClient.DeleteToolTips;
var
  i: integer;
begin
  if (FTipWnd <> 0) then
  begin
    for i := 0 to FItems.Count - 1 do
    begin
      ToolTipApi.DeleteToolTip(FTipWnd,
          FTipForm,
          TTrayItem(FItems.Items[i]).TipIndex)
    end;

    DestroyWindow(FTipWnd);
  end;
  FTipWnd := 0;
  FTipForm := nil;
end;

procedure TTrayClient.SetIconAutoSize(Value: Boolean);
begin
  if not Value then
  begin
    FIconSize := 16
  end;
  FIconAutoSize := Value;
end;

procedure TTrayClient.SetIconAlpha(Value: integer);
begin
  if Value <> FIconAlpha then
  begin
    FIconAlpha := min(255, max(0, Value));
  end;
end;

procedure TTrayClient.SetBorderColor(Value: TColor32);
begin
  if Value <> FBorderColor then
  begin
    FBorderColor := ColorToColor32Alpha(GetCurrentTheme.Scheme.SchemeCodeToColor(Value), FBorderAlpha);
  end;
end;

procedure TTrayClient.SetBackgroundColor(Value: TColor32);
begin
  if Value <> FBackgroundColor then
  begin
    FBackgroundColor := ColorToColor32Alpha(GetCurrentTheme.Scheme.SchemeCodeToColor(Value), FBackgroundAlpha);
  end;
end;

procedure TTrayClient.SetBorderAlpha(Value: integer);
begin
  if Value <> FBorderAlpha then
  begin
    FBorderAlpha := Value;
    FBorderColor := ColorToColor32Alpha(GetCurrentTheme.Scheme.SchemeCodeToColor(WinColor(FBorderColor)), FBorderAlpha);
  end;
end;

procedure TTrayClient.SetBackgroundAlpha(Value: integer);
begin
  if Value <> FBackgroundAlpha then
  begin
    FBackgroundAlpha := Value;
    FBackgroundColor := ColorToColor32Alpha(GetCurrentTheme.Scheme.SchemeCodeToColor(WinColor(FBackgroundColor)), FBackgroundAlpha);
  end;
end;

procedure TTrayClient.SetBlendColor(Value: integer);
begin
  if Value <> FBlendColor then
  begin
    FBlendColor := GetCurrentTheme.Scheme.SchemeCodeToColor(Value);
  end;
end;

procedure TTrayClient.SetBlendAlpha(Value: integer);
begin
  if Value <> FBlendAlpha then
  begin
    FBlendAlpha := Value;
  end;
end;

procedure TTrayClient.NewRepaintHash;
var
  n: integer;
begin
  repeat
    n := random(10000000);
  until n <> FRepaintHash;
  FRepaintHash := n;
end;

destructor TTrayClient.Destroy;
begin
  SharpNotifyEvent.OnClick := nil;
  SharpNotifyEvent.OnShow := nil;
  SharpNotifyEvent.OnTimeout := nil;
  DeleteToolTips;
  FMsgWnd.Free;

  FItems.Free;
  FHiddenItems.Free;
  FStartItems.Free;

  FBitmap.Free;
  FTipTimer.Enabled := False;
  FTipTimer.Free;
  inherited Destroy;
end;

function TTrayClient.IconExists(item: TTrayItem): Boolean;
var
  n: integer;
begin
  for n := 0 to Fitems.Count - 1 do
  begin
    if TTrayItem(Fitems.Items[n]) = item then
    begin
      result := true;
      exit;
    end
  end;
  for n := 0 to FHiddenItems.Count - 1 do
  begin
    if TTrayItem(FHiddenItems.Items[n]) = item then
    begin
      result := true;
      exit;
    end
  end;
  result := false;
end;

function TTrayClient.GetIconPos(item: TTrayItem): TPoint;
var
  n: integer;
  x, y: integer;
begin
  x := FIconSize div 2;
  y := FIconSize div 2;
  for n := 0 to Fitems.Count - 1 do
  begin
    if TTrayItem(Fitems.Items[n]) = item then
    begin
      result := Point(x, y);
      exit;
    end;
    x := x + FIconSize + FIconSpacing;
  end;
end;

function TTrayClient.GetIconAtPos(pt: TPoint): TTrayItem;
var
  i: integer;
  x: integer;
  rc: TRect;
begin
  x := 0;
  for i := 0 to FItems.Count - 1 do
  begin
    rc := Rect(x, FTopSpacing, x + FIconSize + FIconSpacing, FTopSpacing + FIconSize);
    if PointInRect(pt, rc) then
    begin
      Result := TTrayItem(FItems.Items[i]);
      exit;
    end;

    x := x + FIconSize + FIconSpacing;
  end;

  Result := nil;
end;

procedure TTrayClient.ClearTrayIcons;
begin
  if Assigned(FOnPaintLock) then
    FOnPaintLock(True);
    
  FItems.Clear;
  FHiddenItems.Clear;
  RenderIcons;
  
  if Assigned(FOnPaintLock) then
    FOnPaintLock(False);
end;

procedure TTrayClient.RegisterWithTray;
begin
  if FMsgWnd = nil then
  begin
    exit
  end;
  FMsgWnd.RegisterWithTray;
  FLastMessage := DateTimeToUnix(now);
end;

procedure TTrayClient.FOnBallonClick(wnd: hwnd; ID: Cardinal; Data: TObject; Msg: integer);
var
  item: TTrayItem;
begin
  if Data <> nil then
  begin
    item := TTrayItem(Data);
    case Msg of
      WM_LBUTTONDOWN:
      begin
        postmessage(item.Wnd, item.CallbackMessage, item.UID, NIN_BALLOONUSERCLICK)
      end;
    else
    begin
      postmessage(item.Wnd, item.CallbackMessage, item.UID, NIN_BALLOONTIMEOUT)
    end;
    end;
  end;
end;

procedure TTrayClient.FOnBallonShow(wnd: hwnd; ID: Cardinal; Data: TObject);
var
  item: TTrayItem;
begin
  if Data <> nil then
  begin
    item := TTrayItem(Data);
    postmessage(item.Wnd, item.CallbackMessage, item.UID, NIN_BALLOONSHOW);
  end;
end;

procedure TTrayClient.FOnBallonTimeOut(wnd: hwnd; ID: Cardinal; Data: TObject);
var
  item: TTrayItem;
begin
  if Data <> nil then
  begin
    item := TTrayItem(Data);
    postmessage(item.Wnd, item.CallbackMessage, item.UID, NIN_BALLOONTIMEOUT);
  end;
end;

procedure TTrayClient.FOnTipTimer(Sender: TObject);
var
  wp: wparam;
  lp: lparam;
begin
  // Vista Popup?
  if (FV4Popup <> nil) then
  begin
    FLastTipItem := nil;
    FTipTimer.Enabled := False;

    wp := MakeLParam(FTipGPoint.x, FTipGPoint.y);
    lp := MakeLParam(NIN_POPUPOPEN, FV4Popup.uID);
    SendNotifyMessage(FV4Popup.Wnd, FV4Popup.CallbackMessage, wp, lp);

    exit;
  end;
end;

procedure TTrayClient.StartTipTimer(x, y, gx, gy: integer);
begin
  if (FTipPoint.X <> x) or (FTipPoint.Y <> y) then
  begin
    FTipTimer.Enabled := False;
    FTipTimer.Enabled := True;
    FTipPoint := Point(x, y);
    FTipGPoint := Point(gx, gy);
  end;
end;

procedure TTrayClient.CloseVistaInfoTip;
var
  wp: wparam;
  lp: lparam;
begin
  if (FV4Popup <> nil) then
  begin
    wp := MakeWParam(0, 0);
    lp := MakeLParam(NIN_POPUPCLOSE, FV4Popup.uID);
    SendNotifyMessage(FV4Popup.Wnd, FV4Popup.CallbackMessage, wp, lp);
    FV4Popup := nil;
    if FTipWnd <> 0 then
    begin
      ToolTipApi.EnableToolTip(FTipWnd)
    end;
  end;
end;

procedure TTrayClient.StopTipTimer;
begin
  FTipTimer.Enabled := False;
  FLastTipItem := nil;
end;

procedure TTrayClient.UpdateTrayIcons;
var
  i, a: integer;
begin
  for i := 0 to FItems.Count - 1 do
  begin
    ToolTipApi.DeleteToolTip(FTipWnd,
      FTipForm,
      TTrayItem(FItems.Items[i]).TipIndex);
  end;

  a := 0;
  if FTipWnd <> 0 then
  begin
    for i := 0 to FItems.Count - 1 do
    begin
      ToolTipApi.AddToolTipByCallback(FTipWnd,
          FTipForm,
          TTrayItem(FItems.Items[i]).TipIndex,
          Rect(FArrowWidth + FTopSpacing + (a) * (FIconSize + FIconSpacing),
          FTopOffset,
          FArrowWidth + FTopSpacing + (a) * (FIconSize + FIconSpacing) + FIconSize,
          FIconSize + FTopOffset));

      a := a + 1;
    end;
  end;
end;

function TTrayClient.GetFreeTipIndex: integer;
var
  b: boolean;
  n: integer;
  i: integer;
begin
  i := 0;
  repeat
    i := i + 1;
    b := True;
    for n := 0 to FItems.Count - 1 do
    begin
      if TTrayItem(FItems.Items[n]).TipIndex = i then
      begin
        b := False;
        break;
      end
    end;
  until b;
  result := i;
end;

function Sort(AItem, BItem: TTrayItem): Integer;
begin
  Result := 0;
  if (AItem.Position > BItem.Position) then
    Result := 1
  else if AItem.Position < BItem.Position then
    Result := -1;
end;

procedure TTrayClient.UpdatePositions;
begin
  FItems.Sort(@Sort);
  UpdateTrayIcons;
end;

function TTrayClient.GetLastPosition: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to FItems.Count - 1 do
    if TTrayItem(FItems[i]).Position < Result then
      Result := TTrayItem(FItems[i]).Position;

  Result := Result - 1;
end;

function TTrayClient.GetAvailablePosition(p: integer): integer;
var
  i: integer;
begin
  Result := p;
  for i := 0 to FItems.Count - 1 do
    if TTrayItem(FItems[i]).Position = p then
    begin
      Result := GetLastPosition;
      Exit;
    end;
end;

procedure TTrayClient.AddTrayIcon(NIDv6: TNotifyIconDataV7);
var
  tempItem: TTrayItem;
begin
  tempItem := TTrayItem.Create(NIDv6, FIconSize);
  tempItem.Owner := self;
  tempItem.TipIndex := GetFreeTipIndex;

  AddTrayIcon(tempItem);
end;

procedure TTrayClient.AddTrayIcon(item: TTrayItem; addItem: boolean);
var
  n: integer;
  i: integer;
  pStartItem: TTrayStartItem;
begin
  if Assigned(FOnPaintLock) then
    FOnPaintLock(True);

  pStartItem := nil;
  for i := 0 to FStartItems.Count - 1 do
  begin
    if  (item.Compare(TTrayStartItem(FStartItems[i]))) then
    begin
      pStartItem := TTrayStartItem(FStartItems.Extract(FStartItems[i]));
      break;
    end;
  end;

  if (addItem) and (pStartItem = nil) then
  begin
    if FStartHidden then
    begin
      item.Position := -1;
      FHiddenItems.Add(item);
    end else
    begin
      item.Position := GetLastPosition;
      FItems.Add(item);
    end;
  end else if addItem then
  begin
    if (pStartItem.HiddenByClient) or ((pStartItem.Position < 0) and (FStartHidden)) then
    begin
      item.Position := -1;
      FHiddenItems.Add(item);
    end else
    begin
      item.Position := GetAvailablePosition(pStartItem.Position);
      FItems.Add(item);
    end;
  end;

  //SharpApi.SendDebugMessage('SystemTray', 'Adding icon: ' + item.FName, DMT_TRACE);

  UpdatePositions;

  n := FItems.Count;
  if FTipWnd <> 0 then
  begin
    ToolTipApi.AddToolTipByCallback(FTipWnd,
        FTipForm,
        item.TipIndex,
        Rect(FTopSpacing + (n) * (FIconSize + FIconSpacing),
        FTopOffset,
        FTopSpacing + (n) * (FIconSize + FIconSpacing) + FIconSize,
        FIconSize + FTopOffset))
  end;
  RenderIcons;

  if Assigned(FOnAddIcon) then
    FOnAddIcon;

  // Save callback
  if Assigned(FOnSaveSettings) then
    FOnSaveSettings;

  if Assigned(FOnPaintLock) then
    FOnPaintLock(False);
end;

function TTrayClient.GetTrayIcon(pWnd: THandle; UID: Cardinal): TTrayItem;
var
  n: integer;
begin
  for n := 0 to FItems.Count - 1 do
  begin
    if (TTrayItem(FItems.Items[n]).Wnd = pWnd) and (TTrayItem(FItems.Items[n]).UID = UID) then
    begin
      result := TTrayItem(Fitems.Items[n]);
      exit;
    end
  end;
  result := nil;
end;

function TTrayClient.GetHiddenTrayIconIndex(pWnd: THandle; UID: Cardinal): integer;
var
  n: integer;
begin
  for n := 0 to FHiddenItems.Count - 1 do
  begin
    if (TTrayItem(FHiddenItems.Items[n]).Wnd = pWnd) and (TTrayItem(FHiddenItems.Items[n]).UID = UID) then
    begin
      result := n;
      exit;
    end
  end;

  result := -1;
end;

function TTrayClient.GetTrayIconIndex(pWnd: THandle; UID: Cardinal): integer;
var
  n: integer;
begin
  for n := 0 to FItems.Count - 1 do
  begin
    if (TTrayItem(FItems.Items[n]).Wnd = pWnd) and (TTrayItem(FItems.Items[n]).UID = UID) then
    begin
      result := n;
      exit;
    end
  end;

  result := -1;
end;

procedure TTrayClient.AddOrModifyTrayIcon(NIDv6: TNotifyIconDataV7);
var
  item: TTrayItem;
  i: integer;
  x, y: integer;
  SPos: TPoint;
  icon: TSharpNotifyIcon;
  FixedInfo, FixedTitle: WideString;
  TimeOut: integer;
  wnd: TMainForm;
  edge: TSharpNotifyEdge;
begin
  FlastMessage := DateTimeToUnix(now);
  if (GetTrayIconIndex(NIDv6.wnd, NIDv6.UID) = -1) and (GetHiddenTrayIconIndex(NIDv6.wnd, NIDv6.UID) = -1) then
  begin
    AddTrayIcon(NIDv6)
  end
  else
  begin
    ModifyTrayIcon(NIDv6)
  end;
  if (NIDv6.uFlags and NIF_INFO) = NIF_INFO then
  begin
    item := GetTrayIcon(NIDv6.Wnd, NIDv6.UID);
    if (item <> nil) and (FTipWnd <> 0) then
    begin
      if (length(trim(item.FInfo)) > 0)
        or (length(trim(item.FInfoTitle)) > 0) then
      begin
        wnd := TMainForm(FTipForm);
        SPos := wnd.ClientToScreen(Point(0, wnd.Height));
        x := SPos.x;
        if SPos.y > wnd.Monitor.Top + wnd.Monitor.Height div 2 then
        begin
          edge := neBottomLeft;
          y := SPos.y - wnd.Height
        end
        else
        begin
          edge := neTopLeft;
          y := SPos.y;
        end;
        case item.BInfoFlags of
          1, 10:
          begin
            icon := niInfo
          end;
          3:
          begin
            icon := niError
          end;
          2:
          begin
            icon := niWarning
          end;
          0:
          begin
            icon := niInfo
          end
        else
        begin
          icon := niInfo
        end
        end;
        FixedTitle := '';
        for i := 0 to length(item.FInfoTitle) - 1 do
        begin
          if item.FInfoTitle[i] = #0 then
          begin
            break
          end;
          if (item.FInfoTitle[i] = #13) or (item.FInfoTitle[i] = #10) then
          begin
            FixedTitle := FixedTitle + ' '
          end
          else
          begin
            FixedTitle := FixedTitle + item.FInfoTitle[i]
          end;
        end;
        for i := 0 to length(item.FInfo) - 1 do
        begin
          if item.FInfo[i] = #0 then
          begin
            break
          end;
          FixedInfo := FixedInfo + item.FInfo[i];
        end;
        TimeOut := item.BTimeout;
        if TimeOut < 7000 then
        begin
          TimeOut := 7000
        end
        else
        if TimeOut > 30000 then
        begin
          TimeOut := 30000
        end;
        SharpNotify.CreateNotifyWindow(0, item, x, y, FixedTitle + #13 + FixedInfo,
          Icon, edge, wnd.mInterface.SkinInterface.SkinManager, TimeOut, wnd.Monitor.BoundsRect);
      end
    end;
  end;
end;

procedure TTrayClient.ModifyTrayIcon(NIDv6: TNotifyIconDataV7);
var
  tempItem: TTrayItem;
  rs: TTrayChangeEvents;
begin
  if Assigned(FOnPaintLock) then
    FOnPaintLock(True);

  tempItem := GetTrayIcon(NIDv6.wnd, NIDv6.UID);
  if tempItem <> nil then
  begin
    rs := TempItem.AssignFromNIDv6(NIDv6);
    if tceIcon in rs then
    begin
      RenderIcons
    end;

    if tceTip in rs then
    begin
      if FTipWnd <> 0 then
      begin
        ToolTipApi.UpdateToolTipTextByCallback(FTipWnd,
            FTipForm,
            tempItem.TipIndex)
      end
    end;
  end;

  if Assigned(FOnPaintLock) then
    FOnPaintLock(False);
end;

procedure TTrayClient.DeleteTrayIcon(NIDv6: TNotifyIconDataV7);
var
  n: integer;
begin
  n := GetTrayIconIndex(NIDv6.Wnd, NIDv6.UID);
  if (n = -1) then
  begin
    n := GetHiddenTrayIconIndex(NIDv6.Wnd, NIDv6.UID);
    if n <> -1 then
      DeleteTrayIconByIndex(n, True);
  end else
    DeleteTrayIconByIndex(n);
end;

procedure TTrayClient.DeleteTrayIconByIndex(index: integer; Hidden: Boolean);
var
  i: integer;
  temp: TTrayItem;
  startItem: TTrayStartItem;
begin
  // To stop the tray from removing the Explorer icons when shutting down the Shell service we need
  // to check if the shell service is stopping
  if (SharpAPI.ServiceStopping('Shell') = MR_STOPPING) then
    exit;

  if Assigned(FOnPaintLock) then
    FOnPaintLock(True);

  if not Hidden then
  begin
    temp := TTrayItem(FItems.Items[index]);
    if temp = FLastTipItem then
      StopTipTimer
  end else
    temp := TTrayItem(FHiddenItems.Items[index]);

  if (FTipWnd <> 0) then
  begin
    ToolTipApi.DeleteToolTip(FTipWnd,
      FTipForm,
      temp.TipIndex);

    if (not Hidden) and (index < FItems.Count - 1) then
    begin
      for i := index + 1 to FItems.Count - 1 do
      begin
        ToolTipApi.UpdateToolTipRect(FTipWnd,
          FTipForm,
          TTrayItem(FItems.Items[i]).TipIndex,
          Rect(FTopSpacing + (i - 1) * (FIconSize + FIconSpacing),
          FTopOffset,
          FTopSpacing + (i - 1) * (FIconSize + FIconSpacing) + FIconSize,
          FIconSize + FTopOffset))
      end;
    end;
  end;

  // Add the item to the startup list if it was hidden (to make it start hidden next time)
  if Hidden then
  begin
    startItem := TTrayStartItem.Create;
    startItem.HiddenByClient := True;
    
    startItem.Path := temp.Path;
    startItem.GUID := temp.GUID;
    startItem.UID := temp.UID;
    startItem.WndClass := temp.WndClass;

    startItem.Position := -1;
    FStartItems.Add(startItem);
  end;

  if not Hidden then
    FItems.Extract(temp)
  else
    FHiddenItems.Extract(temp);

  FreeAndNil(Temp);
  RenderIcons;

  if Assigned(FOnSaveSettings) then
      FOnSaveSettings;

  if Assigned(FOnPaintLock) then
    FOnPaintLock(False);
end;

procedure TTrayClient.RenderIcon(item: TTrayItem; n: integer);
var
  dstRc: TRect;
  tempBmp: TBitmap32;
begin
  dstRc.Left := (FTopSpacing + (n) * (FIconSize + FIconSpacing)) + item.ModX;
  dstRc.Top := FTopSpacing;
  dstRc.Right := (FTopSpacing + (n) * (FIconSize + FIconSpacing) + FIconSize) + item.ModX;
  dstRc.Bottom := FIconSize + FTopSpacing;

  if dstRc.Left < 0 then
  begin
    dstRc.Right := FIconSize;
    dstRc.Left := 0;
  end;
  if dstRc.Right > FItems.Count * (FIconSize + FIconSpacing) then
  begin
    dstRc.Right := FItems.Count * (FIconSize + FIconSpacing);
    dstRc.Left := dstRc.Right - FIconSize;
  end;
  

  item.Bitmap.DrawMode := dmBlend;
  item.Bitmap.MasterAlpha := FIconAlpha;
  if FColorBlend then
  begin
    tempBmp := TBitmap32.Create;
    tempBmp.DrawMode := dmBlend;
    tempBmp.CombineMode := cmMerge;
    try
      tempBmp.SetSize(item.Bitmap.Width, item.Bitmap.Height);
      tempBmp.Clear(color32(0, 0, 0, 0));
      item.Bitmap.MasterAlpha := 255;
      item.Bitmap.DrawTo(tempBmp);
      BlendImageA(tempBmp, FBlendColor, FBlendAlpha);
      tempBmp.MasterAlpha := FIconAlpha;
      tempBmp.DrawTo(FBitmap, dstRc);
    finally
      tempBmp.Free;
    end;
  end else
  begin
    item.Bitmap.DrawTo(FBitmap, dstRc);
  end;
end;

procedure TTrayClient.RenderIcons;
var
  n: integer;
  tempItem: TTrayItem;
  w, h: integer;
begin

  // Remove dead icons
  n := 0;
  while n < FItems.Count - 1 do
  begin
    tempItem := TTrayItem(FItems.Items[n]);
    if (not iswindow(tempItem.Wnd)) then
    begin
      DeleteTrayIconByIndex(n);
      continue;
    end;

    n := n + 1;
  end;

  n := 0;
  while n < FHiddenItems.Count - 1 do
  begin
    tempItem := TTrayItem(FHiddenItems[n]);
    if (not iswindow(tempItem.Wnd)) then
    begin
      DeleteTrayIconByIndex(n, True);
      continue;
    end;

    n := n + 1;
  end;

  w := FItems.Count * (FIconSize + FIconSpacing) + 2 * FTopSpacing;
  h := FIconSize + 2 * FTopSpacing;
  FBitmap.SetSize(w, h);
  FBitmap.Clear(color32(0, 0, 0, 0));
  if FDrawBorder then
  begin
    FBitmap.FillRect(0, 0, FBitmap.Width, FBitmap.Height, FBorderColor);
    FBitmap.FillRect(1, 1, FBitmap.Width - 1, FBitmap.Height - 1, Color32(0, 0, 0, 0));
  end;
  if FDrawBackground then
  begin
    FBitmap.FillRect(1, 1, FBitmap.Width - 1, FBitmap.Height - 1, FBackgroundColor)
  end;

  for n := 0 to FItems.Count - 1 do
  begin
    tempItem := TTrayItem(FItems.Items[n]);
    if tempItem.ModX <> 0 then
      continue;

    RenderIcon(tempItem, n);
  end;

  for n := 0 to FItems.Count - 1 do
  begin
    tempItem := TTrayItem(FItems.Items[n]);
    if tempItem.ModX = 0 then
      continue;

    RenderIcon(tempItem, n);
  end;
  NewRepaintHash;
end;

procedure TTrayClient.PositionTrayWindow(parent, trayParent: HWND);
var
  wnd: hwnd;
  wnd2: hwnd;
  rc, rct: TRect;
begin
  GetWindowRect(parent, rc);
  GetWindowRect(trayParent, rct);

  rc.Right := rc.Right - rc.Left;
  rc.Bottom := rc.Bottom - rc.Top;

  rct.Right := rct.Right - rct.Left;
  rct.Bottom := rct.Bottom - rct.Top;

  wnd := FindWindow('Shell_TrayWnd', nil);
  if wnd <> 0 then
  begin
    SetWindowPos(wnd, 0, rc.Left, rc.Top, rc.Right, rc.Bottom, SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    if IsWindowVisible(wnd) then
    begin
      ShowWindow(wnd, SW_HIDE)
    end;

    wnd2 := FindWindowEx(wnd, 0, 'TrayNotifyWnd', nil);
    if wnd2 <> 0 then
    begin
      SetWindowPos(wnd2, 0, rct.Left + FArrowWidth, rct.Top, rct.Right - FArrowWidth, rct.Bottom, SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW);
      if IsWindowVisible(wnd2) then
      begin
        ShowWindow(wnd2, SW_HIDE)
      end;
    end;
  end;
end;

function TTrayClient.Print: String;
var
  n : integer;
  pItem : TTrayItem;
begin
  result := 'Items: ' + inttostr(FItems.Count);
  for n := 0 to FItems.Count - 1 do
  begin
    pItem := TTrayItem(FItems.Items[n]);
    result := result + pItem.FWndClass + '; ';
  end;
end;

// Documentation on the topic under the remarks section of
// http://msdn.microsoft.com/en-us/library/bb762159.aspx
function TTrayClient.PerformIconAction(x, y, gx, gy, imod: integer; msg: uint; parent: TForm): boolean;
var
  n, i: integer;
  tempItem: TTrayItem;
  PID: DWORD;
  ix, iy: DWORD;
  lp: lparam;
  wp: wparam;
  hcount: integer;
begin
  result := false;
  hcount := 0;
  for n := 0 to FItems.Count - 1 do
  begin
    if (n + imod < 0) or (n + imod > FItems.Count - 1) then
    begin
      exit
    end;

    if ((msg = WM_MOUSELEAVE) and (TTrayItem(FItems.Items[n + imod]).IsHovering)) then
    begin
      StopTipTimer;
      CloseVistaInfoTip;
      TTrayItem(FItems.Items[n + imod]).IsHovering := False;

      continue;
    end;

    if PointInRect(Point(x, y),
      Rect(FIconSpacing + (n - hcount) * (FIconSize + FIconSpacing),
      FTopOffset,
      FIconSpacing + (n - hcount) * (FIconSize + FIconSpacing) + FIconSize,
      FIconSize + FTopOffset)) then
    begin
      tempItem := TTrayItem(FItems.Items[n + imod]);
      if tempItem = nil then
      begin
        exit
      end;

      // Check if there was a tray icon which displayed a new Vista tooltip
      if (TempItem <> FV4Popup) and (FV4Popup <> nil) then
      begin
        CloseVistaInfoTip;
        TTrayItem(FItems.Items[n + imod]).IsHovering := False;
      end;

      if (not iswindow(tempItem.Wnd)) then
      begin
        StopTipTimer;
        DeleteTrayIconByIndex(n + imod);
        exit;
      end;
      result := true;

      GetWindowThreadProcessId(tempItem.Wnd, @PID);
      AllowSetForegroundWindow(PID);

     // SharpApi.SendDebugMessage('SystemTray',PChar('Wnd: ' + inttostr(tempItem.Wnd)
     //                           + ' | CallBack: ' + inttostr(tempItem.CallbackMessage)
     //                           + ' | uID: ' + inttostr(tempItem.uID)
     //                           + ' | uVersion: ' + inttostr(tempItem.BInfoFlags)
     //                           + ' | Title: ' + tempItem.FTip
     //                           + ' | Msg: ' + inttostr(msg)),0);

      // reposition the tray window (some stupid shell services are using
      // it for positioning)
      PositionTrayWindow(parent.ParentWindow, parent.Handle);

      // Stop the tip timer on any other message
      if ((msg <> WM_MOUSEMOVE) and (TTrayItem(FItems.Items[n + imod]).IsHovering)) then
      begin
        StopTipTimer;
        CloseVistaInfoTip;
        TTrayItem(FItems.Items[n + imod]).IsHovering := False;
      end;

      FLastTipItem := tempItem;
      if (tempItem.Version >= NOTIFYICON_VERSION_4) then
      begin
        {$REGION 'NotifyIcon Version > 4'}
        // NotifyIcon Version > 4
        ix := gx;
        iy := gy;
        wp := MakeWParam(ix, iy);
        lp := MakeLParam(msg, tempItem.uID);

        case msg of
          WM_MOUSEMOVE:
          begin
            if (not tempItem.IsHovering) then
            begin
              // Make sure no other tray item is displaying a tooltip
              for i := 0 to FItems.Count - 1 do
              begin
                if (TTrayItem(FItems.Items[i + imod]).IsHovering) then
                begin
                  StopTipTimer;
                  CloseVistaInfoTip;
                  TTrayItem(FItems.Items[i + imod]).IsHovering := False;
                end;
              end;

              // Tooltip check
              if not ((tempItem.Flags and NIF_SHOWTIP) = NIF_SHOWTIP) then
              begin
                FV4Popup := tempItem;
                StartTipTimer(x, y, gx, gy);
                if FTipWnd <> 0 then
                begin
                  ToolTipApi.DisableToolTip(FTipWnd)
                end;
              end;

              TTrayItem(FItems.Items[n + imod]).IsHovering := True;
            end;
          end;
          WM_LBUTTONUP:
          begin
            SendNotifyMessage(tempItem.Wnd, tempItem.CallbackMessage, wp, MakeLParam($400, tempItem.uID));
          end;
          WM_RBUTTONUP:
          begin
            lp := MakeLParam(WM_RBUTTONUP, tempItem.uID);
            SendNotifyMessage(tempItem.Wnd, tempItem.CallbackMessage, wp, lp);
            lp := MakeLParam(WM_CONTEXTMENU, tempItem.uID);
          end;
        end;

        SendNotifyMessage(tempItem.Wnd, tempItem.CallbackMessage, wp, lp);
        {$ENDREGION}
      end
      else if msg <> WM_MOUSEMOVE then { Prevents a problem where certain tooltips won't show }
      begin
        {$REGION 'NotifyIcon Version <= 4'}
        if tempItem.Version >= NOTIFYICON_VERSION then
        begin
          case msg of
            WM_RBUTTONUP:
            begin
              SendNotifyMessage(tempItem.Wnd, tempItem.CallbackMessage, tempItem.uID, msg);
              msg := WM_CONTEXTMENU;
            end;
          end
        end;
        
        SendNotifyMessage(tempItem.Wnd, tempItem.CallbackMessage, tempItem.uID, msg);
        {$ENDREGION}
      end;
    end;
  end;
end;

{$ENDREGION}

end.
