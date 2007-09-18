{
Source Name: uHotkeyServiceMgrItem
Description: Hotkey Pnl Item
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

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

unit uHotkeyServiceMgrItem;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls;

type
  TGradientDirection = (gdVertical, gdHorizontal);
  THotkeyMgrItem = class(TCustomPanel)
  private
    IsMouseOver: Boolean;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;

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
    FIsAction: Boolean;

    { Private declarations }

    procedure SetBorderColor(const Value: TColor);
    procedure SetFocusedBorderColor(const Value: TColor);
    procedure SetSelectedBorderColor(const Value: TColor);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetSelectedGradientFrom(const Value: TColor);
    procedure SetSelectedGradientTo(const Value: TColor);

    procedure SetDetail(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetSelected(const Value: Boolean);
    procedure SetIsAction(const Value: Boolean);
  protected
  public
    { Public declarations }
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }

    property Detail: string read FDetail write SetDetail;
    property Title: string read FTitle write SetTitle;
    property Selected: Boolean read FSelected write SetSelected;

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
    property IsAction: Boolean read FIsAction write SetIsAction;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function IsCursorOverItem(X, Y: Integer): Boolean;

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

    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

implementation

{$R Resources.res}

{ THotkeyMgrItem }

procedure THotkeyMgrItem.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure THotkeyMgrItem.Paint;
var
  memoryBitmap: TBitmap;
  TmpBitmap: TBitmap;
  n: integer;
begin
  inherited;
  memoryBitmap := TBitmap.Create;
  try
    try
      // Initialise memory bitmap
      memoryBitmap.Height := ClientRect.Bottom;
      memoryBitmap.Width := ClientRect.Right;
      memoryBitmap.Height := ClientRect.Bottom;
      memoryBitmap.Width := ClientRect.Right;

      // Fill white
      memoryBitmap.Canvas.brush.Color := self.Color;
      memoryBitmap.Canvas.FillRect(ClientRect);
      memoryBitmap.Canvas.Pen.Color := $00EBEBEB;
      memoryBitmap.Canvas.MoveTo(4, memoryBitmap.Height - 1);
      memoryBitmap.Canvas.LineTo(MemoryBitmap.Width - 4, memoryBitmap.Height - 1);
      memoryBitmap.Canvas.Pen.Color := clGray;

      // Draw Border
      if FSelected then begin
        memoryBitmap.Canvas.pen.Color := FSelectedBorderColor;
        memoryBitmap.Canvas.Brush.Color := FSelectedGradientTo;
        memoryBitmap.Canvas.Rectangle(ClientRect.Left, ClientRect.Top, ClientRect.Right,
          ClientRect.Bottom);
      end
      else if IsMouseOver then begin
        memoryBitmap.Canvas.pen.Color := FFocusedBorderColor;
        memoryBitmap.Canvas.Rectangle(ClientRect.Left, ClientRect.Top, ClientRect.Right,
          ClientRect.Bottom);
      end;

      // Draw Status
      TmpBitmap := TBitmap.Create;

      if FIsAction then
        TmpBitmap.LoadFromResourceName(Hinstance, 'HKL_IMG_ACTION')
      else
        TmpBitmap.LoadFromResourceName(Hinstance, 'HKL_IMG_FILE');

      TmpBitmap.Transparent := true;
      TmpBitmap.SaveToFile('c:\test.bmp');
      memoryBitmap.Canvas.Draw(5, 5, TmpBitmap);
      TmpBitmap.Free;

      // Draw Hotkey Name
      memoryBitmap.Canvas.Font.Name := 'Arial';
      memoryBitmap.Canvas.Font.size := 9;
      memoryBitmap.Canvas.Font.Style := [fsbold];
      memoryBitmap.Canvas.TextOut(26, 5, FTitle);
      n := memoryBitmap.Canvas.TextWidth(FTitle);

      // Draw Hotkey Detail
      memoryBitmap.Canvas.Font.Color := clGray;
      memoryBitmap.Canvas.Font.Name := 'Small Fonts';
      memoryBitmap.Canvas.Font.size := 7;
      memoryBitmap.Canvas.Font.Style := [];
      memoryBitmap.Canvas.TextOut(26 + n + 4, 8, FDetail);

      // Copy memoryBitmap to screen
      canvas.CopyRect(ClientRect, memoryBitmap.canvas, ClientRect);

    finally
      if assigned(memorybitmap) then
        memoryBitmap.Free;
    end;
  except
  end;

end;

procedure THotkeyMgrItem.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.SetDetail(const Value: string);
begin
  FDetail := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.SetFocusedBorderColor(const Value: TColor);
begin
  FFocusedBorderColor := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.SetTitle(const Value: string);
begin
  FTitle := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.SetSelected(const Value: Boolean);
begin
  FSelected := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.SetSelectedBorderColor(const Value: TColor);
begin
  FSelectedBorderColor := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.SetSelectedColor(const Value: TColor);
begin
  FSelectedColor := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.SetSelectedGradientFrom(const Value: TColor);
begin
  FSelectedGradientFrom := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.SetSelectedGradientTo(const Value: TColor);
begin
  FSelectedGradientTo := Value;
  Invalidate;
end;

procedure THotkeyMgrItem.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

function THotkeyMgrItem.IsCursorOverItem(X, Y: Integer): Boolean;
begin
  Result := False;
  if Y > Self.BoundsRect.TopLeft.Y then
    Result := True;
end;

constructor THotkeyMgrItem.Create;
begin
  inherited;
end;

procedure THotkeyMgrItem.SetIsAction(const Value: Boolean);
begin
  FIsAction := Value;
  Invalidate;
end;

end.

