{
Source Name: TrayIconsManager
Description: Icon messaging and handling class
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

unit TrayIconsManager;

interface

uses Windows, Dialogs, SysUtils,
     Forms, Controls, Messages, Types, Graphics, Contnrs, ExtCtrls,
     GR32,
     SharpApi,
     SharpThemeApi,
     GR32_Filters,
     GR32_Resamplers,
     WinVer,
     declaration,
     DateUtils,
     Math,
     SharpGraphicsUtils,
     SharpIconUtils,
     SharpNotify;

type
    TTrayChangeEvent = (tceIcon,tceTip,tceVersion);
    TTrayChangeEvents = Set of TTrayChangeEvent;

 {$REGION '### Classes ###'}
  {$REGION 'TMsgWnd class'}

    TMsgWnd = class(TForm)
      procedure FormDestroy(Sender: TObject);
      procedure CreateParams(var Params: TCreateParams); override;
      procedure FormCreate(Sender: TObject);
    private
      procedure IncomingTrayMsg(var Msg: TMessage); message WM_COPYDATA;
    public
      FTrayClient : TObject;
      isClosing : boolean;
      procedure RegisterWithTray;
    end;
  {$ENDREGION}
  {$REGION 'TTrayItem Class'}

  TTrayItem    = class
                 private
                   FUID : Cardinal;
                   FWnd : Thandle;
                   FCallbackMessage : UINT;
                   FBitmap : TBitmap32;
                   FIcon   : hIcon;
                   FFlags  : Cardinal;
                   FBTimeOut : Cardinal;
                   FBInfoFlags : DWORD;
                   FOwner : TObject;
                   FTipIndex : integer;
                 public
                   FTip : ArrayWideChar128;
                   FInfo : ArrayWideChar256;
                   FInfoTitle : ArrayWideChar64;
                   function AssignFromNIDv6(NIDv6 : TNotifyIconDataV7) : TTrayChangeEvents;
                   constructor Create(NIDv6 : TNotifyIconDataV7); reintroduce;
                   destructor Destroy; override;

                   property UID : Cardinal read FUID;
                   property Wnd : THandle read FWnd;
                   property Bitmap : TBitmap32 read FBitmap;
                   property Icon   : hIcon read FIcon;
                   property CallbackMessage : UINT read FCallbackMessage;
                   property Flags : Cardinal read FFlags;
                   property BTimeout : Cardinal read FBTimeout;
                   property BInfoFlags : DWORD read FBInfoFlags;
                   property Owner : TObject read FOwner write FOwner;
                   property TipIndex : integer read FTipIndex write FTipIndex;
                 end;
  {$ENDREGION}
  {$REGION 'TTrayClient Class'}

  TTrayClient = class
                 private
                   FMsgWnd: TMsgWnd;
                   FWndList : TObjectList;
                   FV4Popup : TTrayItem;
                   FIconSize : integer;
                   FIconSpacing : integer;
                   FTopSpacing  : integer;
                   FItems : TObjectList;
                   FBitmap : TBitmap32;
                   FWinVersion : Cardinal;
                   FTipTimer : TTimer;
                   FLastTipItem : TTrayItem;
                   FTipPoint : TPoint;
                   FTipGPoint : TPoint;
                   FIconAlpha       : integer;
                   FColorBlend      : boolean;
                   FBlendColor      : integer;
                   FBlendAlpha      : integer;
                   FBackGroundColor : TColor32;
                   FBorderColor     : TColor32;
                   FDrawBackground  : boolean;
                   FDrawBorder      : boolean;
                   FBackgroundAlpha : integer;
                   FBorderAlpha     : integer;
                   FRepaintHash     : integer;
                   FScreenPos       : TPoint;
                   FLastMessage     : Int64;
                   procedure FOnBallonClick(wnd: hwnd; ID: Cardinal; Data: TObject;  Msg: integer);
                   procedure FOnBallonShow(wnd: hwnd; ID: Cardinal; Data: TObject);
                   procedure FOnBallonTimeOut(wnd: hwnd; ID: Cardinal; Data: TObject);
                   procedure FOnTipTimer(Sender : TObject);
                   procedure NewRepaintHash;
                 public
                   function  GetTrayIconIndex(pWnd : THandle; UID : Cardinal) : integer;
                   function  GetTrayIcon(pWnd : THandle; UID : Cardinal) : TTrayItem;
                   procedure AddOrModifyTrayIcon(NIDv6 : TNotifyIconDataV7);
                   procedure AddTrayIcon(NIDv6 : TNotifyIconDataV7);
                   procedure ModifyTrayIcon(NIDv6 : TNotifyIconDataV7);
                   procedure DeleteTrayIcon(NIDv6 : TNotifyIconDataV7);
                   procedure DeleteTrayIconByIndex(index : integer);
                   procedure RenderIcons;
                   procedure SpecialRender(target : TBitmap32; si, ei : integer);
                   function PerformIconAction(x,y,gx,gy,imod : integer; msg : uint; parent : TForm) : boolean;
                   procedure StartTipTimer(x,y,gx,gy : integer);
                   procedure StopTipTimer;
                   procedure CloseVistaInfoTip;
                   function  GetIconPos(item : TTrayItem) : TPoint;
                   function  IconExists(item : TTrayItem) : Boolean;
                   procedure RegisterWithTray;
                   procedure ClearTrayIcons;
                   procedure SetBorderColor(Value : TColor32);
                   procedure SetBackgroundColor(Value : TColor32);
                   procedure SetBlendColor(Value : integer);
                   procedure SetBorderAlpha(Value : integer);
                   procedure SetBackgroundAlpha(Value : integer);
                   procedure SetBlendAlpha(Value : integer);
                   procedure SetIconAlpha(Value : integer);
                   procedure PositionTrayWindow(x,y : integer; parent : TForm);
                   procedure AddWindow(wnd : TObject);
                   procedure RemoveWindow(wnd : TObject);
                   function GetFreeTipIndex : integer;
                   constructor Create; reintroduce;
                   destructor  Destroy; override;

                   property Items : TObjectList read FItems;
                   property Bitmap : TBitmap32 read FBitmap;
                   property IconAlpha : integer read FIconAlpha write SetIconAlpha;
                   property IconSize : integer read FIconSize write FIconSize;
                   property IconSpacing : integer read FIconSpacing write FIconSpacing;
                   property TopSpacing  : integer read FTopSpacing write FTopSpacing;
                   property ColorBlend     : boolean read FColorBlend write FColorBlend;
                   property BlendColor     : integer read FBlendColor write SetBlendColor;
                   property BlendAlpha     : integer read FBlendAlpha write SetBlendAlpha;
                   property DrawBackground : boolean read FDrawBackground write FDrawBackground;
                   property DrawBorder     : boolean read FDrawBorder write FDrawBorder;
                   property BackGroundColor : TColor32 read FBackGroundColor write SetBackgroundColor;
                   property BorderColor    : TColor32 read FBorderColor     write SetBorderColor;
                   property BackgroundAlpha : integer read FBackgroundAlpha write SetBackgroundAlpha;
                   property BorderAlpha    : integer read FBorderAlpha      write SetBorderAlpha;
                   property RepaintHash    : integer read FRepaintHash      write FRepaintHash;
                   property ScreenPos      : TPoint  read FScreenPos        write FScreenPos;
                   property LastMessage    : Int64   read FLastMessage;
                   property LastTipItem    : TTrayItem read FLastTipItem;
                   property TipGPoint      : TPoint read FTipGPoint;
                   property WndList        : TObjectList read FWndList;
                 end;
  {$ENDREGION}
{$ENDREGION}

function AllowSetForegroundWindow(ProcessID : DWORD) : boolean; stdcall; external 'user32.dll' name 'AllowSetForegroundWindow';

{$R *.dfm}

implementation

uses ToolTipApi,MainWnd;


type

  TTrayWnd = class
             public
               Wnd : TMainForm;
               TipWnd : hwnd;
             end;

function ColorToColor32Alpha(Color : TColor; Alpha : integer) : TColor32;
var
 R,G,B,A : byte;
begin
  R := GetRValue(Color);
  G := GetGValue(Color);
  B := GetBValue(Color);
  A := Alpha;
  if Alpha > 255 then A := 255
     else if Alpha < 0 then A := 0;
  result := Color32(R,G,B,A);
end;


function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

function GetCurrentMonitor : integer;
var
  n : integer;
  CPos : TPoint;
  cursorPos: TPoint;
begin
  if Not(GetCursorPosSecure(cursorPos)) then
    Exit;

  CPos := cursorpos;
  for n := 0 to Screen.MonitorCount - 1 do
      if PointInRect(CPos,Screen.Monitors[n].BoundsRect) then
      begin
        result := n;
        exit;
      end;
  // something went wrong and the cursor isn't in any monitor
  result := 0;
end;

{$ENDREGION}
{$REGION 'TMsgWnd'}

procedure TMsgWnd.RegisterWithTray;
begin
  PostMessage(FindWindow('Shell_TrayWnd',nil),WM_REGISTERWITHTRAY,handle,0);
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
  if isClosing then exit;
  try
    Data := pCopyDataStruct(Msg.LParam);
    if (Data.dwData = 1) or (Data.dwData = 2) then
    begin
      TrayCmd := Data.dwData;
      Icondata := pNotifyIconDataV7(Data.lpdata)^;
      case TrayCmd of
        1 : begin
              TTrayClient(FTrayClient).AddOrModifyTrayIcon(IconData);
            end;

        2 : begin
              TTrayClient(FTrayClient).DeleteTrayIcon(IconData);
            end;
        end;
      //important to return value <> 0
      msg.Result := 5;
    end
    else
      msg.Result := DefWindowProc(Handle, Msg.Msg, Msg.WParam, Msg.LParam);
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
  PostMessage(FindWindow('Shell_TrayWnd',nil),WM_REGISTERWITHTRAY,handle,0);
end;

procedure TMsgWnd.FormDestroy(Sender: TObject);
begin
  isClosing := True;
  PostMessage(FindWindow('Shell_TrayWnd',nil),WM_UNREGISTERWITHTRAY,handle,0);
end;
{$ENDREGION}
{$REGION 'TTrayItem'}

constructor TTrayItem.Create(NIDv6 : TNotifyIconDataV7);
begin
  FBitmap := TBitmap32.Create;
  FBitmap.SetSize(16,16);
  TLinearResampler.Create(FBitmap);
  AssignFromNIDv6(NIDv6);
  Inherited Create;
end;

destructor TTrayItem.Destroy;
begin
  FBitmap.Free;
  Inherited Destroy;
end;

// return value = True if icon changed
function TTrayItem.AssignFromNIDv6(NIDv6 : TNotifyIconDataV7) : TTrayChangeEvents;
var
  oTip : String;
  oVersion : integer;
begin
  result := [];
  if NIDv6.uCallbackMessage <> 0 then
     FCallbackMessage := NIDv6.uCallbackMessage;
  FUID := NIDv6.UID;
  FWnd := NIDv6.Wnd;

  oTip := FTip;
  FTip := NIDv6.szTip;
  if CompareText(oTip,FTip) <> 0 then
     result := result + [tceTip];

  if (NIDv6.uFlags and NIF_INFO) = NIF_INFO then
  begin
    FInfo := NIDv6.szInfo;
    FInfoTitle := NIDv6.szInfoTitle;
    FBTimeOut := NIDv6.Union.uTimeOut;
  end;

  oVersion := NIDv6.Union.uVersion;
  FBInfoFlags := NIDv6.Union.uVersion;
  if oVersion <> Integer(FBInfoFlags) then
     result := result + [tceVersion];

  FFlags := NIDv6.uFlags;

  if NIDv6.Icon <> FIcon then
  begin
    FIcon := NIDv6.Icon;
    FBitmap.Clear(color32(0,0,0,0));
    IconToImage(FBitmap,NIDv6.icon);
    result := result + [tceIcon];
  end;
end;
{$ENDREGION}
{$REGION 'TTrayClient'}

constructor TTrayClient.Create;
begin
  inherited Create;

  Randomize;
  NewRepaintHash;
  FWndList := TObjectList.Create(True);
  FWndList.Clear;
  FColorBlend := False;
  FIconAlpha  := 255;
  FBlendAlpha := 255;
  FBlendColor := 0;
  FDrawBackground := True;
  FDrawBorder := True;
  FBackgroundAlpha := 255;
  FBorderAlpha := 255;
  FIconSize := 16;
  FIconSpacing := 1;
  FTopSpacing  := 2;
  FLastMessage := DateTimeToUnix(now);
  FItems := TObjectList.Create;
  FItems.Clear;
  FBitmap := Tbitmap32.Create;
  FWinVersion := GetWinVer;
  FTipTimer := TTimer.Create(nil);
  FTipTimer.Interval := 500;
  FTipTimer.Enabled := False;
  FTipTimer.OnTimer := FOnTipTimer;
  FLastTipItem := nil;
  FBackGroundColor := Color32(128,128,128,128);
  FBorderColor     := Color32(0,0,0,128);

  FMsgWnd := TMsgWnd.Create(nil);
  FMsgWnd.FTrayClient := self;

  SharpNotifyEvent.OnClick := FOnBallonClick;
  SharpNotifyEvent.OnShow := FOnBallonShow;
  SharpNotifyEvent.OnTimeout := FOnBallonTimeout;
end;

procedure TTrayClient.AddWindow(wnd : TObject);
var
  item : TTrayWnd;
  item2 : TTrayItem;
  n : integer;
begin
  item := TTrayWnd.Create;
  item.Wnd := TMainForm(wnd);
  item.TipWnd := ToolTipApi.RegisterToolTip(TMainForm(wnd));
  FWndList.Add(item);
  for n := 0 to FItems.Count - 1 do
  begin
    item2 := TTrayItem(FItems.Items[n]);
    ToolTipApi.AddToolTipByCallback(item.TipWnd,
                                    item.Wnd,
                                    item2.TipIndex,
                                    Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
  end;
end;

procedure TTrayClient.RemoveWindow(wnd : TObject);
var
  n,i : integer;
begin
  for n := 0 to FWndList.Count - 1 do
      if TTrayWnd(FWndList.Items[n]).wnd = wnd then
      begin
        for i := 0 to FItems.Count - 1 do
            ToolTipApi.DeleteToolTip(TTrayWnd(FWndList.Items[n]).TipWnd,
                                     TTrayWnd(FWndList.Items[n]).Wnd,     
                                     TTrayItem(FItems).TipIndex);
        DestroyWindow(TTrayWnd(FWndList.Items[n]).TipWnd);
        FWndList.Delete(n);
        exit;
      end; 
end;

procedure TTrayClient.SetIconAlpha(Value : integer);
begin
  if Value <> FIconAlpha then
  begin
    FIconAlpha := min(255,max(0,Value));
  end;
end;

procedure TTrayClient.SetBorderColor(Value : TColor32);
begin
  if Value <> FBorderColor then
  begin
    FBorderColor := ColorToColor32Alpha(SchemeCodeToColor(Value),FBorderAlpha);
  end;
end;

procedure TTrayClient.SetBackgroundColor(Value : TColor32);
begin
  if Value <> FBackgroundColor then
  begin
    FBackgroundColor := ColorToColor32Alpha(SchemeCodeToColor(Value),FBackgroundAlpha);
  end;
end;

procedure TTrayClient.SetBorderAlpha(Value : integer);
begin
  if Value <> FBorderAlpha then
  begin
    FBorderAlpha := Value;
    FBorderColor := ColorToColor32Alpha(SchemeCodeToColor(WinColor(FBorderColor)),FBorderAlpha);
  end;
end;

procedure TTrayClient.SetBackgroundAlpha(Value : integer);
begin
  if Value <> FBackgroundAlpha then
  begin
    FBackgroundAlpha := Value;
    FBackgroundColor := ColorToColor32Alpha(SchemeCodeToColor(WinColor(FBackgroundColor)),FBackgroundAlpha);
  end;
end;

procedure TTrayClient.SetBlendColor(Value : integer);
begin
  if Value <> FBlendColor then
  begin
    FBlendColor := SchemeCodeToColor(Value);
  end;
end;

procedure TTrayClient.SetBlendAlpha(Value : integer);
begin
  if Value <> FBlendAlpha then
  begin
    FBlendAlpha := Value;
  end;
end;

procedure TTrayClient.NewRepaintHash;
var
  n : integer;
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
  FWndList.Free;
  FMsgWnd.Free;
  FItems.Free;
  FBitmap.Free;
  FTipTimer.Enabled := False;
  FTipTimer.Free;
  inherited Destroy;
end;

function TTrayClient.IconExists(item : TTrayItem) : Boolean;
var
  n : integer;
begin
  for n := 0 to Fitems.Count -1 do
      if TTrayItem(Fitems.Items[n]) = item then
      begin
        result := true;
        exit;
      end;
  result := false;
end;

function TTrayClient.GetIconPos(item : TTrayItem) : TPoint;
var
  n : integer;
  x,y : integer;
begin
  x := FIconSize div 2;
  y := FIconSize div 2;
  for n := 0 to Fitems.Count -1 do
  begin
    if TTrayItem(Fitems.Items[n]) = item then
    begin
      result := Point(x,y);
      exit;
    end;
    x := x + FIconSize + FIconSpacing;
  end;
end;

procedure TTrayClient.ClearTrayIcons;
begin
  FItems.Clear;
  RenderIcons;
end;

procedure TTrayClient.RegisterWithTray;
begin
  if FMsgWnd = nil then exit;
  FMsgWnd.RegisterWithTray;
  FLastMessage := DateTimeToUnix(now);
end;

procedure TTrayClient.FOnBallonClick(wnd: hwnd; ID: Cardinal; Data: TObject;  Msg: integer);
var
  item : TTrayItem;
begin
  if Data <> nil then
  begin
    item := TTrayItem(Data);
    case Msg of
      WM_LBUTTONUP:  postmessage(item.Wnd,item.CallbackMessage,item.UID,NIN_BALLOONUSERCLICK);
      else postmessage(item.Wnd,item.CallbackMessage,item.UID,NIN_BALLOONHIDE);
    end;
  end;
end;

procedure TTrayClient.FOnBallonShow(wnd: hwnd; ID: Cardinal; Data: TObject);
var
  item : TTrayItem;
begin
  if Data <> nil then
  begin
    item := TTrayItem(Data);
    postmessage(item.Wnd,item.CallbackMessage,item.UID,NIN_BALLOONSHOW);
  end;
end;

procedure TTrayClient.FOnBallonTimeOut(wnd: hwnd; ID: Cardinal; Data: TObject);
var
  item : TTrayItem;
begin
  if Data <> nil then
  begin
    item := TTrayItem(Data);
    postmessage(item.Wnd,item.CallbackMessage,item.UID,NIN_BALLOONTIMEOUT);
  end;
end;

procedure TTrayClient.FOnTipTimer(Sender : TObject);
var
  wp : wparam;
  lp : lparam;
begin

  // Vista Popup?
  if (FV4Popup <> nil) then
  begin
    FLastTipItem := nil;
    FTipTimer.Enabled := False;

    wp := MakeLParam(FTipGPoint.x,FTipGPoint.y);
    lp := MakeLParam(NIN_POPUPOPEN,FV4Popup.uID);
    SendMessage(FV4Popup.Wnd,FV4Popup.CallbackMessage,wp,lp);

    exit;
  end;
end;

procedure TTrayClient.StartTipTimer(x,y,gx,gy : integer);
begin
  if (FTipPoint.X <> x) or (FTipPoint.Y <> y) then
  begin
    FTipTimer.Enabled := False;
    FTipTimer.Enabled := True;
    FTipPoint := Point(x,y);
    FTipGPoint := Point(gx,gy);
  end;
end;

procedure TTrayClient.CloseVistaInfoTip;
var
  wp : wparam;
  lp : lparam;
  n : integer;
begin
  if (FV4Popup <> nil) then
  begin
    wp := MakeWParam(0,0);
    lp := MakeLParam(NIN_POPUPCLOSE,FV4Popup.uID);
    SendMessage(FV4Popup.Wnd,FV4Popup.CallbackMessage,wp,lp);
    FV4Popup := nil;
    for n := 0 to FWndList.Count - 1 do
        ToolTipApi.EnableToolTip(TTrayWnd(FWndList.Items[n]).TipWnd);
  end;
end;

procedure TTrayClient.StopTipTimer;
begin
  FTipTimer.Enabled := False;
  FLastTipItem := nil;
end;

function TTrayClient.GetFreeTipIndex : integer;
var
  b : boolean;
  n : integer;
  i : integer;
begin
  i := -1;
  repeat
    i := i + 1;
    b := True;
    for n := 0 to FItems.Count - 1 do
        if TTrayItem(FItems.Items[n]).TipIndex = i then
        begin
          b := False;
          break;
        end;
  until b;
  result := i;
end;

procedure TTrayClient.AddTrayIcon(NIDv6 : TNotifyIconDataV7);
var
  tempItem : TTrayItem;
  i,n : integer;
begin
  tempItem := TTrayItem.Create(NIDv6);
  tempItem.Owner := self;
  tempItem.TipIndex := GetFreeTipIndex;
  FItems.Add(TempItem);
  n := FItems.Count - 1;
  for i := 0 to FWndList.Count - 1 do
      ToolTipApi.AddToolTipByCallback(TTrayWnd(FWndList.Items[i]).TipWnd,
                                      TTrayWnd(FWndList.Items[i]).Wnd,
                                      tempItem.TipIndex,
                                      Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));

  RenderIcons;
end;

function  TTrayClient.GetTrayIcon(pWnd : THandle; UID : Cardinal) : TTrayItem;
var
  n : integer;
begin
  for n := 0 to FItems.Count -1 do
      if (TTrayItem(FItems.Items[n]).Wnd = pWnd) and (TTrayItem(FItems.Items[n]).UID = UID) then
      begin
        result := TTrayItem(Fitems.Items[n]);
        exit;
      end;
  result := nil;
end;

function  TTrayClient.GetTrayIconIndex(pWnd : THandle; UID : Cardinal) : integer;
var
  n : integer;
begin
  for n := 0 to FItems.Count -1 do
      if (TTrayItem(FItems.Items[n]).Wnd = pWnd) and (TTrayItem(FItems.Items[n]).UID = UID) then
      begin
        result := n;
        exit;
      end;
  result := -1;
end;

procedure TTrayClient.AddOrModifyTrayIcon(NIDv6 : TNotifyIconDataV7);
var
  item : TTrayItem;
  i : integer;
  x,y : integer;
  SPos : TPoint;
  icon: TSharpNotifyIcon;
  FixedInfo,FixedTitle : WideString;
  TimeOut : integer;
  wnd : TMainForm;
  edge : TSharpNotifyEdge;
begin
  FlastMessage := DateTimeToUnix(now);
  if GetTrayIconIndex(NIDv6.wnd,NIDv6.UID) = -1 then AddTrayIcon(NIDv6)
     else ModifyTrayIcon(NIDv6);
  if (NIDv6.uFlags and NIF_INFO) = NIF_INFO then
  begin
    item := GetTrayIcon(NIDv6.Wnd,NIDv6.UID);
    if (item <> nil) and (wndlist.Count > 0) then
       if (length(trim(item.FInfo))>0)
          or (length(trim(item.FInfoTitle))>0) then
          begin
            wnd := TTrayWnd(wndlist.Items[0]).wnd;
            SPos := wnd.ClientToScreen(Point(0,wnd.Height));
            x := SPos.x;
            if SPos.y > wnd.Monitor.Top + wnd.Monitor.Height div 2 then
            begin
              edge := neBottomLeft;
              y := SPos.y - wnd.Height
            end else
            begin
              edge := neTopLeft;
              y := SPos.y;
            end;
            case item.BInfoFlags of
              1, 10: icon := niInfo;
              3: icon := niError;
              2: icon := niWarning;
              0: icon := niInfo
              else icon := niInfo
            end;
            FixedTitle := '';
            for i := 0 to length(item.FInfoTitle)-1 do
            begin
              if item.FInfoTitle[i] = #0 then
                break;
              if (item.FInfoTitle[i] = #13) or (item.FInfoTitle[i] = #10) then
                FixedTitle := FixedTitle + ' '
              else FixedTitle := FixedTitle + item.FInfoTitle[i];
            end;
            for i := 0 to length(item.FInfo)-1 do
            begin
              if item.FInfo[i] = #0 then
                break;
              FixedInfo := FixedInfo + item.FInfo[i];
            end;
            TimeOut := item.BTimeout;
            if TimeOut < 5000 then
              TimeOut := 5000
            else if TimeOut > 30000 then
              TimeOut := 30000;
            SharpNotify.CreateNotifyWindow(0,item,x,y,FixedTitle + #13 + FixedInfo,
                                           Icon,edge,wnd.SkinManager,TimeOut,wnd.Monitor.BoundsRect);
          end;
  end;
end;

procedure TTrayClient.ModifyTrayIcon(NIDv6 : TNotifyIconDataV7);
var
  tempItem : TTrayItem;
  rs : TTrayChangeEvents;
  k : integer;
begin
  tempItem := GetTrayIcon(NIDv6.wnd,NIDv6.UID);
  if tempItem <> nil then
  begin
    rs := TempItem.AssignFromNIDv6(NIDv6);
    if tceIcon in rs then RenderIcons;
    if tceTip in rs then
       for k := 0 to FWndList.Count - 1 do
           ToolTipApi.UpdateToolTipTextByCallback(TTrayWnd(FWndList.Items[k]).TipWnd,
                                                  TTrayWnd(FWndList.Items[k]).Wnd,
                                                  tempItem.TipIndex);
  end;
end;

procedure TTrayClient.DeleteTrayIcon(NIDv6 : TNotifyIconDataV7);
var
  n : integer;
begin
  n := GetTrayIconIndex(NIDv6.Wnd,NIDv6.UID);
  if (n <> -1) and (n < FItems.Count) then
     DeleteTrayIconByIndex(n);
end;

procedure TTrayClient.DeleteTrayIconByIndex(index : integer);
var
  i,k : integer;
  temp : TTrayItem;
begin
  if index > FItems.Count - 1 then exit;

  temp := TTrayItem(FItems.Items[index]);
  if temp = FLastTipItem then
    StopTipTimer;

  if index < FItems.Count - 1 then
     for k := 0 to FWndList.Count - 1 do
     begin
       ToolTipApi.DeleteToolTip(TTrayWnd(FWndList.Items[k]).TipWnd,
                                TTrayWnd(FWndList.Items[k]).Wnd,
                                temp.TipIndex);

       for i := index + 1 to FItems.Count - 1 do
           ToolTipApi.UpdateToolTipRect(TTrayWnd(FWndList.Items[k]).TipWnd,
                                        TTrayWnd(FWndList.Items[k]).Wnd,
                                        TTrayItem(FItems.Items[i]).TipIndex,
                                        Rect(FTopSpacing+(i-1)*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+(i-1)*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
    end;
  FItems.Extract(temp);
  FreeAndNil(Temp);
  RenderIcons;
end;

procedure TTrayClient.RenderIcons;
var
  n : integer;
  tempItem : TTrayItem;
  w, h : integer;
  tempBmp : TBitmap32;
begin
  for n := FItems.Count -1 downto 0 do
  begin
    tempItem := TTrayItem(FItems.Items[n]);
    if not iswindow(tempItem.Wnd) then
    begin
      DeleteTrayIconByIndex(n);
      RenderIcons;
      exit;
    end;
  end;

  tempBmp := TBitmap32.Create;
  tempBmp.DrawMode := dmBlend;
  tempBmp.CombineMode := cmMerge;
  try
    w := FItems.Count * (FIconSize + FIconSpacing)+2*FTopSpacing;
    h := FIconSize + 2*FTopSpacing;
    FBitmap.SetSize(w,h);
    FBitmap.Clear(color32(0,0,0,0));
    if FDrawBorder then
    begin
      FBitmap.FillRect(0,0,FBitmap.Width,FBitmap.Height,FBorderColor);
      FBitmap.FillRect(1,1,FBitmap.Width-1,FBitmap.Height-1,Color32(0,0,0,0));
    end;
    if FDrawBackground then FBitmap.FillRect(1,1,FBitmap.Width-1,FBitmap.Height-1,FBackgroundColor);
    for n := 0 to FItems.Count - 1 do
    begin
      tempItem := TTrayItem(FItems.Items[n]);
      tempItem.Bitmap.DrawMode := dmBlend;
      tempItem.Bitmap.MasterAlpha := FIconAlpha;
      if FColorBlend then
      begin
        tempBmp.SetSize(tempItem.Bitmap.Width,tempItem.Bitmap.Height);
        tempBmp.Clear(color32(0,0,0,0));
        tempItem.Bitmap.MasterAlpha := 255;
        tempItem.Bitmap.DrawTo(tempBmp);
        BlendImageA(tempBmp,FBlendColor,FBlendAlpha);
        tempBmp.MasterAlpha := FIconAlpha;
        tempBmp.DrawTo(FBitmap,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
      end else tempItem.Bitmap.DrawTo(FBitmap,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
    end;
    NewRepaintHash;
  finally
    tempBmp.Free;
  end;
end;

procedure TTrayClient.SpecialRender(target : TBitmap32; si, ei : integer);
var
  n : integer;
  tempItem : TTrayItem;
  w, h : integer;
  tempBmp : TBitmap32;
begin
  tempBmp := TBitmap32.Create;
  tempBmp.DrawMode := dmBlend;
  tempBmp.CombineMode := cmMerge;
  try
    w := abs(ei-si) * (FIconSize + FIconSpacing) + 2*FTopSpacing;
    h := FIconSize + 2*FTopSpacing;
    target.SetSize(w,h);
    target.Clear(color32(0,0,0,0));
    if FDrawBorder then
    begin
      target.FillRect(0,0,target.Width,target.Height,FBorderColor);
      target.FillRect(1,1,target.Width-1,target.Height-1,Color32(0,0,0,0));
    end;
    if FDrawBackground then target.FillRect(1,1,target.Width-1,target.Height-1,FBackgroundColor);
    for n := 0 to abs(ei-si)-1 do
    begin
      if si+n < FItems.Count then
      begin
        tempItem := TTrayItem(FItems.Items[si+n]);
        tempItem.Bitmap.DrawMode := dmBlend;
        tempItem.Bitmap.MasterAlpha := FIconAlpha;
        if FColorBlend then
        begin
          tempBmp.SetSize(tempItem.Bitmap.Width,tempItem.Bitmap.Height);
          tempBmp.Clear(color32(0,0,0,0));
          tempItem.Bitmap.MasterAlpha := 255;
          tempItem.Bitmap.DrawTo(tempBmp);
          BlendImageA(tempBmp,FBlendColor,FBlendAlpha);
          tempBmp.MasterAlpha := FIconAlpha;
          tempBmp.DrawTo(target,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
        end else tempItem.Bitmap.DrawTo(target,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
      end;
    end;
    NewRepaintHash;
  finally
    tempBmp.Free;
  end;
end;

procedure TTrayClient.PositionTrayWindow(x,y : integer; parent : TForm);
var
  wnd : hwnd;
  wnd2 : hwnd;
  p : TPoint;
begin
  p := parent.ClientToScreen(Point(x,y));

  wnd := FindWindow('Shell_TrayWnd',nil);
  if wnd <> 0 then
  begin
    SetWindowPos(wnd,parent.Handle,p.x,p.y,0,0,SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    if IsWindowVisible(wnd) then
       ShowWindow(wnd,SW_HIDE);

    wnd2 := FindWindowEx(wnd,0,'TrayNotifyWnd',nil);
    if wnd2 <> 0 then
    begin
      SetWindowPos(wnd2,wnd,0,0,parent.Width,parent.Height,SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW);
      if IsWindowVisible(wnd2) then
         ShowWindow(wnd2,SW_HIDE);
    end;
  end;
end;

function TTrayClient.PerformIconAction(x,y,gx,gy,imod : integer; msg : uint; parent : TForm) : boolean;
var
  n : integer;
  tempItem : TTrayItem;
  PID: DWORD;
  ix,iy : DWORD;
  lp : lparam;
  wp : wparam;
  i : integer;
begin
  result := false;
  for n := 0 to FItems.Count - 1 do
  begin
    if PointInRect(Point(x,y),Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing)) then
    if (n + imod >= 0 ) and (n + imod <= FItems.Count - 1) then
    begin
      tempItem := TTrayItem(FItems.Items[n+imod]);
      if tempItem = nil then
        exit;

      // Check if there was a tray icon which displayed a new Vista tooltip
      if (TempItem <> FV4Popup) and (FV4Popup <> nil) then
          CloseVistaInfoTip;

      if not iswindow(tempItem.Wnd) then
      begin
        StopTipTimer;
        DeleteTrayIconByIndex(n+imod);
        exit;
      end;
      result := true;

      GetWindowThreadProcessId(tempItem.Wnd, @PID);
      AllowSetForegroundWindow(PID);

{      SharpApi.SendDebugMessage('Module: SystemTray',PChar('Wnd:' + inttostr(tempItem.Wnd)
                                + ' | CallBack:' + inttostr(tempItem.CallbackMessage)
                                + ' | uID:' + inttostr(tempItem.uID)
                                + ' | uVersion:' + inttostr(tempItem.BInfoFlags)
                                + ' | Title:' + tempItem.FTip),0);}

      // reposition the tray window (some stupid shell services are using
      // it for positioning)
      PositionTrayWindow(x,0,parent);

      FLastTipItem := tempItem;
      if (tempItem.BInfoFlags >= 4) then
      begin
        // NotifyIcon Version > 4
        ix := gx;
        iy := gy;
        wp := MakeWParam(ix,iy);

        // Stop the tip timer on any other message
        if (msg <> WM_MOUSEMOVE) then
        begin
          StopTipTimer;
          CloseVistaInfoTip;
        end;

        lp := MakeLParam(msg,tempItem.uID);
        case msg of
          WM_MOUSEMOVE: begin
                          // Tooltip check
                          if not ((tempItem.Flags and NIF_SHOWTIP) = NIF_SHOWTIP) then
                          begin
                            FV4Popup := tempItem;
                            StartTipTimer(x,y,gx,gy);
                            for i := 0 to FWndList.Count - 1 do
                                ToolTipApi.DisableToolTip(TTrayWnd(FWndList.Items[i]).TipWnd);
                          end;
                        end;
          WM_RBUTTONUP: begin
                          lp := MakeLParam(WM_RBUTTONUP,tempItem.uID);
                          SendMessage(tempItem.Wnd,tempItem.CallbackMessage,wp,lp);
                          lp := MakeLParam(WM_CONTEXTMENU,tempItem.uID);
                        end;
        end;
        SendMessage(tempItem.Wnd,tempItem.CallbackMessage,wp,lp);
      end else
      begin
        // NotifyIcon Version < 4
        PostMessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID,msg);
      end;
    end;
  end;
end;
{$ENDREGION}

end.
