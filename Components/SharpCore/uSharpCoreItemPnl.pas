{
Source Name: uServiceMgrItem
Description: A service item for the service manager
Copyright (C) Lee Green

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
unit uSharpCoreItemPnl;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,

  jclFileUtils;

type
  TStatusType = (stDisabled, stStarted, stStopped);
  TGradientDirection = (gdVertical, gdHorizontal);
  TServiceMgrItem = class(TCustomPanel)
  private
    IsMouseOver: Boolean;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;

    FStatus: TStatusType;
    FDetail: string;
    FTitle: string;
    FSelected: Boolean;

    FBorderColor: TColor;
    FFocusedBorderColor: TColor;
    FSelectedBorderColor: TColor;
    FSelectedColor: Tcolor;
    FSelectedGradientFrom: TColor;
    FSelectedGradientTo: TColor;
    FFSelectedGradientFrom: TColor;
    FFSelectedColor: Tcolor;
    FHasConfig: Boolean;
    FOnInfoBtn: TNotifyEvent;
    FOnConfigBtn: TNotifyEvent;
    FOnStopBtn: TNotifyEvent;
    FOnStartBtn: TNotifyEvent;
    FHasInfo: Boolean;

    { Private declarations }
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    procedure SetBorderColor(const Value: TColor);
    procedure SetFocusedBorderColor(const Value: TColor);
    procedure SetSelectedBorderColor(const Value: TColor);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetSelectedGradientFrom(const Value: TColor);
    procedure SetSelectedGradientTo(const Value: TColor);

    procedure SetDetail(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetStatus(const Value: TStatusType);

    procedure SetSelected(const Value: Boolean);
    function IsCursorOverInfoBtn(X, Y: Integer): Boolean;
    function IsCursorOverStopBtn(X, Y: Integer): Boolean;
    function IsCursorOverStartBtn(X, Y: Integer): Boolean;
    function IsCursorOverConfigBtn(X, Y: Integer): Boolean;
    procedure SetHasConfig(const Value: Boolean);
    procedure SetHasInfo(const Value: Boolean);
  protected
  public
    { Public declarations }
    procedure Paint; override;
  published
    { Published declarations }

    property Detail: string read FDetail write SetDetail;
    property Title: string read FTitle write SetTitle;
    property Selected: Boolean read FSelected write SetSelected;
    property Status: TStatusType read FStatus write SetStatus;
    property HasConfig: Boolean read FHasConfig write SetHasConfig;
    property HasInfo: Boolean read FHasInfo write SetHasInfo;

    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property FocusedBorderColor: TColor read FFocusedBorderColor write
      SetFocusedBorderColor;
    property SelectedBorderColor: TColor read FSelectedBorderColor write
      SetSelectedBorderColor;
    property SelectedColor: Tcolor read FFSelectedColor write SetSelectedColor;
    property SelectedGradientFrom: TColor read FFSelectedGradientFrom write
      SetSelectedGradientFrom;
    property SelectedGradientTo: TColor read FSelectedGradientTo write
      SetSelectedGradientTo;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
      Integer);
      override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    {inherited}
    property Font;
    property Color;
    property ParentColor;
    property Visible;
    property Align;
    property Alignment;
    property Cursor;
    property Hint;
    property ParentShowHint;
    property ShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;

    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
    property OnMouseDown;
    property OnStartBtn: TNotifyEvent read FOnStartBtn write FOnStartBtn;
    property OnStopBtn: TNotifyEvent read FOnStopBtn write FOnStopBtn;
    property OnConfigBtn: TNotifyEvent read FOnConfigBtn write FOnConfigBtn;
    property OnInfoBtn: TNotifyEvent read FOnInfoBtn write FOnInfoBtn;

    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;

  end;

implementation

uses
  uSharpCoreMainWnd;

{$R Resources.res}

{ TServiceMgrItem }

procedure TServiceMgrItem.CMMouseEnter(var Message: TMessage);
begin
  try
    inherited;
    IsMouseOver := true;
    Paint;

    {trigger onmouseenter event}
    if Assigned(FOnMouseEnter) then
      FOnMouseEnter(Self);
  except
  end;
end;

procedure TServiceMgrItem.CMMouseLeave(var Message: TMessage);
begin
  try
    inherited;
    isMouseOver := false;
    Paint;

    {trigger onmouseleave event}
    if Assigned(FOnMouseLeave) then
      FOnMouseLeave(Self);
  except
  end;
end;

procedure TServiceMgrItem.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  try
    inherited;
    // Check for information button
    if IsCursorOverInfoBtn(X, Y) then begin
      if Assigned(FOnInfoBtn) then
        FOnInfoBtn(Self);
    end;

    if IsCursorOverStopBtn(X, Y) then begin
      if FStatus = stStarted then begin
        if Assigned(FOnStopBtn) then
          FOnStopBtn(Self);
      end;
    end
    else if IsCursorOverStartBtn(X, Y) then begin
      if FStatus = stStopped then begin
        if Assigned(FOnStartBtn) then
          FOnStartBtn(Self);
      end;
    end
    else if IsCursorOverConfigBtn(X, Y) then begin
      if FHasConfig then begin
        if Assigned(FOnConfigBtn) then
          FOnConfigBtn(Self);
      end;
    end;
  except
  end;

  //Self.Paint;

end;

procedure TServiceMgrItem.Paint;
var
  memoryBitmap: TBitmap;
  TmpBitmap: TBitmap;
  n: integer;
  tmpStr: String;
begin
  //inherited;
  memoryBitmap := TBitmap.Create;
  try
    try
      // Initialise memory bitmap
      memoryBitmap.Height := ClientRect.Bottom;
      memoryBitmap.Width := ClientRect.Right;
      memoryBitmap.Height := ClientRect.Bottom;
      memoryBitmap.Width := ClientRect.Right;

      // Fill white
      memoryBitmap.Canvas.brush.Color := clwhite;
      memoryBitmap.Canvas.FillRect(ClientRect);
      memoryBitmap.Canvas.Pen.Color := $00EBEBEB;
      memoryBitmap.Canvas.MoveTo(4, memoryBitmap.Height - 1);
      memoryBitmap.Canvas.LineTo(MemoryBitmap.Width - 4, memoryBitmap.Height -
        1);
      memoryBitmap.Canvas.Pen.Color := clGray;

      // Draw Border
      if FSelected then begin
        memoryBitmap.Canvas.pen.Color := FSelectedBorderColor;
        memoryBitmap.Canvas.Brush.Color := FSelectedGradientTo;

        if SharpCoreMainWnd.sbList.VertScrollBar.Visible then
          memoryBitmap.Canvas.RoundRect(ClientRect.Left, ClientRect.Top,
            ClientRect.Right - 17, ClientRect.Bottom, 10, 10)
        else

          memoryBitmap.Canvas.RoundRect(ClientRect.Left, ClientRect.Top,
            ClientRect.Right, ClientRect.Bottom, 10, 10);
      end
      else if IsMouseOver then begin
        memoryBitmap.Canvas.pen.Color := FFocusedBorderColor;

        if SharpCoreMainWnd.sbList.VertScrollBar.Visible then
          memoryBitmap.Canvas.RoundRect(ClientRect.Left, ClientRect.Top,
            ClientRect.Right - 17, ClientRect.Bottom, 10, 10)
        else

          memoryBitmap.Canvas.RoundRect(ClientRect.Left, ClientRect.Top,
            ClientRect.Right, ClientRect.Bottom, 10, 10);
      end;

      // Draw Status
      TmpBitmap := TBitmap.Create;
      TmpBitmap.Transparent := True;
      case FStatus of
        stDisabled: TmpBitmap.Handle := LoadBitmap(HInstance,
            'SCL_IMG_STATDISABLED');
        stStarted: TmpBitmap.Handle := LoadBitmap(HInstance,
            'SCL_IMG_STATLOADED');
        stStopped: TmpBitmap.Handle := LoadBitmap(HInstance,
            'SCL_IMG_STATSTOPPED');
      end;

      memoryBitmap.Canvas.Draw(6, 5, TmpBitmap);
      TmpBitmap.Free;

      // Draw On/Off button
      TmpBitmap := TBitmap.Create;
      TmpBitmap.Transparent := True;
      case FStatus of
        stStarted: TmpBitmap.Handle := LoadBitmap(HInstance, 'SCL_IMG_STOP');
        stStopped: TmpBitmap.Handle := LoadBitmap(HInstance, 'SCL_IMG_START');
        stDisabled: TmpBitmap.Handle := LoadBitmap(HInstance,
            'SCL_IMG_DISABLED');
      end;
      memoryBitmap.Canvas.Draw(memoryBitmap.Width - 112, 7, TmpBitmap);
      TmpBitmap.Free;

      // Draw Config button
      TmpBitmap := TBitmap.Create;
      TmpBitmap.Transparent := True;
      if FHasConfig then begin
        TmpBitmap.Handle := LoadBitmap(HInstance, 'SCL_IMG_CONFIG');
        memoryBitmap.Canvas.Draw(memoryBitmap.Width - 70, 7, TmpBitmap);
        TmpBitmap.Free;
      end;

      // Draw Info
      if FHasInfo then begin
        TmpBitmap := TBitmap.Create;
        TmpBitmap.Transparent := True;
        TmpBitmap.Handle := LoadBitmap(HInstance, 'SCL_IMG_INFO');
        memoryBitmap.Canvas.Draw(memoryBitmap.Width - 45, 7, TmpBitmap);
        TmpBitmap.Free;

      end;

      // Draw Service Name
      memoryBitmap.Canvas.Font.Name := 'Arial';
      memoryBitmap.Canvas.Font.size := 9;
      memoryBitmap.Canvas.Font.Style := [];
      memoryBitmap.Canvas.TextOut(28, 5, FTitle);
      n := memoryBitmap.Canvas.TextWidth(FTitle);

      // Draw Service Detail
      memoryBitmap.Canvas.Font.Color := clGray;
      memoryBitmap.Canvas.Font.Name := 'Small Fonts';
      memoryBitmap.Canvas.Font.size := 7;
      memoryBitmap.Canvas.Font.Style := [];

      tmpStr := PathCompactPath(Canvas.Handle,FDetail,memoryBitmap.Width-112-(28 + n + 4),cpEnd);
      memoryBitmap.Canvas.TextOut(28 + n + 4, 8, tmpStr);

      // Copy memoryBitmap to screen
      canvas.CopyRect(ClientRect, memoryBitmap.canvas, ClientRect);

    finally
      if assigned(memorybitmap) then
        memoryBitmap.Free;
    end;
  except
  end;

end;

procedure TServiceMgrItem.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetDetail(const Value: string);
begin
  FDetail := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetFocusedBorderColor(const Value: TColor);
begin
  FFocusedBorderColor := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetTitle(const Value: string);
begin
  FTitle := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetSelected(const Value: Boolean);
begin
  FSelected := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetSelectedBorderColor(const Value: TColor);
begin
  FSelectedBorderColor := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetSelectedColor(const Value: TColor);
begin
  FSelectedColor := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetSelectedGradientFrom(const Value: TColor);
begin
  FSelectedGradientFrom := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetSelectedGradientTo(const Value: TColor);
begin
  FSelectedGradientTo := Value;
  Invalidate;
end;

procedure TServiceMgrItem.SetStatus(const Value: TStatusType);
begin
  FStatus := Value;
  Invalidate;
end;

procedure TServiceMgrItem.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  try
    inherited;
    Cursor := crArrow;
    // Check for information button
    if IsCursorOverInfoBtn(X, Y) then
      Cursor := crHandPoint
    else if IsCursorOverStopBtn(X, Y) then begin
      if FStatus = stStarted then
        Cursor := crHandPoint;
    end
    else if IsCursorOverStartBtn(X, Y) then begin
      if FStatus = stStopped then
        Cursor := crHandPoint
      else
    end
    else if IsCursorOverConfigBtn(X, Y) then begin
      if HasConfig then
        Cursor := crHandPoint
      else
    end;
  except
  end;
end;

function TServiceMgrItem.IsCursorOverInfoBtn(X, Y: Integer): Boolean;
begin
  Result := False;

  if not (FHasInfo) then begin
    Result := false;
    Exit;
  end;

  // Check extents
  if ((Y >= 7) and (Y <= 7 + 12)) and ((X >= Width - 45) and (X <= Width - 45 +
    21)) then
    Result := True;
end;

function TServiceMgrItem.IsCursorOverStopBtn(X, Y: Integer): Boolean;
begin
  Result := False;

  // Check extents
  if ((Y >= 7) and (Y <= 7 + 12)) and ((X >= Width - 112) and (X <= Width - 112 +
    18)) then
    Result := True;
end;

function TServiceMgrItem.IsCursorOverStartBtn(X, Y: Integer): Boolean;
begin
  Result := False;

  // Check extents
  if ((Y >= 7) and (Y <= 7 + 12)) and ((X >= Width - 112 + 18) and (X <= Width -
    112 + 36)) then
    Result := True;
end;

procedure TServiceMgrItem.SetHasConfig(const Value: Boolean);
begin
  FHasConfig := Value;
  Invalidate;
end;

function TServiceMgrItem.IsCursorOverConfigBtn(X, Y: Integer): Boolean;
begin
  Result := False;

  // Check extents
  if ((Y >= 7) and (Y <= 7 + 21)) and ((X >= Width - 70) and (X <= Width - 70 +
    21)) then
    Result := True;
end;

procedure TServiceMgrItem.SetHasInfo(const Value: Boolean);
begin
  FHasInfo := Value;
  Invalidate;
end;

end.

