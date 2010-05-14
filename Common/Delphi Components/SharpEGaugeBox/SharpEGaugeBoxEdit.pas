{
Source Name: uSharpeGaugeBoxEdit
Description: A SharpE Value Edit Box
Copyright (C) Pixol (pixol@sharpe-shell.org)

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

unit SharpEGaugeBoxEdit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Buttons,
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls,
  SharpApi,
  Types,
  GR32,
  JvComCtrls,

  SharpGraphicsUtils;

  {$R SharpEGaugeBoxBitmaps.res}

type
  TChangeValueEvent = procedure(Sender: TObject; Value: Integer) of object;
  TArrowColor = (acBlue, acCyan, acGray, acGreen, acOrange, acPurple, acRed, acYellow, acDefault);
  TPopPosition = (ppTop, ppBottom, ppLeft, ppRight);
type
  TSharpeGaugeBox = class(TCustomPanel)
  private
    FFrmSharpeGaugeBox: TObject;
    FBtnGauge: TSpeedButton;
    FValueEdit: TEdit;
    FBackPanel: TPanel;
    FEnabled: Boolean;
    FPercentDisplay: Boolean;
    FOnChangeValue: TChangeValueEvent;
    FMax: Integer;
    FMin: Integer;
    FValue: Integer;
    FPrefix: string;
    FSuffix: string;
    FArrowColor: TArrowColor;
    FFlatStyle: Boolean;
    FPopPosition: TPopPosition;
    FDescription: string;
    FFormatting: string;

    function CreateInitialControls: Boolean;

    procedure BtnGaugeClick(Sender: TObject);
    procedure BtnGaugeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetMax(const Value: Integer);
    procedure SetMin(const Value: Integer);
    procedure SetPrefix(const Value: string);
    procedure SetSuffix(const Value: string);
    procedure SetValue(const Value: Integer);

    procedure ValueEditKeyPress(Sender: TObject; var Key: Char);
    procedure ValueEditExit(Sender: TObject);
    procedure ValueEditClick(Sender: Tobject);
    procedure ValueEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure PopAnimateWindow(Popper: TControl; PopWindow: TWinControl);

    procedure SetPopPosition(const Value: TPopPosition);
    procedure SetDescription(const Value: string);
    procedure SetPercentDisplay(const Value : boolean);
    function GetBackgroundColor: TColor;
    procedure SetBackgroundColor(const Value: TColor);
    procedure SelectValueText;
    function GetNewValue: integer;
  protected
    procedure SetEnabled(Value: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateValue(newValue: integer);
    procedure UpdateEditBox;
    procedure BeforeDestruction; override;

  published
    property Owner;
    property Align;
    property Color;
    property Anchors;
    property Font;
    property Constraints;
    property ParentBackground;
    property Visible;
    property TabOrder;
    property TabStop;

    property Min: Integer read FMin write SetMin;
    property Max: Integer read FMax write SetMax;
    property Value: Integer read FValue write SetValue;

    property Prefix: string read FPrefix write SetPrefix;
    property Suffix: string read FSuffix write SetSuffix;
    property Description: string read FDescription write SetDescription;
    //property Enabled;
    property PopPosition: TPopPosition read FPopPosition write SetPopPosition;
    property PercentDisplay: boolean read FPercentDisplay write SetPercentDisplay;

    property Formatting: string read FFormatting write FFormatting;

    property OnChangeValue: TChangeValueEvent read FOnChangeValue write FOnChangeValue;

    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor;
  end;

procedure Register;

implementation

uses
  SharpeGaugeBoxWnd;
  
procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpeGaugeBox]);
end;

{ TSharpeGaugeBox }

constructor TSharpeGaugeBox.Create(AOwner: TComponent);
begin
  inherited;

  Width := 145;
  Height := 21;

  BorderStyle := bsNone;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BevelKind := bkNone;
  ParentBackground := False;

  FPercentDisplay := False;
  FEnabled := True;
  FValue := 100;
  FMin := -100;
  FMax := 100;
  FFlatStyle := True;
  FPopPosition := ppBottom;
  FDescription := 'Adjust to set the transparency';
  FFormatting := '%d';

  FArrowColor := acGray;

  Ctl3D := False;

  CreateInitialControls;
end;

function TSharpeGaugeBox.CreateInitialControls: Boolean;
var
  R: TRect;
  ButtonWidth: Integer;
begin
  Result := True;

  // Get Initial Values
  R := Rect(Self.Left, Self.Top, Self.Width, Self.Height);
  ButtonWidth := 15;

  FBackPanel := TPanel.Create(Self);
  with FBackPanel do
  begin
    Parent := Self;
    Align := alClient;

    BorderStyle := bsNone;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BevelKind := bkNone;
    ParentBackground := false;
    DoubleBuffered := True;
    ParentFont := True;
    Color := Self.Color;
  end;

  FValueEdit := TEdit.Create(FBackPanel);
  with FValueEdit do
  begin
    Parent := FBackPanel;
    Align := alClient;
    DoubleBuffered := True;
    Text := Format('%s%d%s', [FPrefix, FValue, FSuffix]);
    OnKeyPress := ValueEditKeyPress;
    OnKeyDown := ValueEditKeyDown;
    OnExit := ValueEditExit;
    OnClick := ValueEditClick;
    ParentFont := True;
    MaxLength := 50;
  end;

  FBtnGauge := TSpeedButton.Create(FValueEdit);
  FBtnGauge.Glyph.LoadFromResourceName(HInstance,'DROPLEFT_GRAY');
  SetBackgroundColor(self.BackgroundColor);

  with FBtnGauge do
  begin
    Parent := FValueEdit;
    DoubleBuffered := True;
    Align := alRight;
    Width := ButtonWidth;
    Font.Style := [fsBold];
    Caption := '';
    Flat := true;
    Color := Self.Color;
    OnMouseUp := BtnGaugeMouseUp;
    Cursor := crArrow;
    width := 15;
  end;
end;

procedure TSharpeGaugeBox.BeforeDestruction;
begin
  inherited;

  if assigned(FBtnGauge) then
     FreeAndNil(FBtnGauge);
  if assigned(FValueEdit) then
     FreeAndNil(FValueEdit);
  if assigned(FBackPanel) then
     FreeAndNil(FBackPanel);
  if assigned(FFrmSharpeGaugeBox) then
     FreeAndNil(FFrmSharpeGaugeBox);
end;

procedure TSharpeGaugeBox.SetEnabled(Value: boolean);
begin
  FBackPanel.Enabled := Value;
  FBtnGauge.Enabled := Value;
  FValueEdit.Enabled := Value;

  if Not(Value) then
    FValueEdit.Font.Color := clGrayText else
    FValueEdit.Font.Color := clBtnText;
end;

function TSharpeGaugeBox.GetBackgroundColor: TColor;
begin
  result := FValueEdit.Color;
end;

function TSharpeGaugeBox.GetNewValue: integer;
var
  s : string;
begin
  Result := 0;

  // Search for Prefix
  s := FValueEdit.Text;

  if (FPrefix <> '') and (Pos(fPrefix, s) = 1) then
    delete(s, 1, Length(fPrefix));
  if (fSuffix <> '') and (Pos(Fsuffix, s) > 0) then
    delete(s, Length(s) - Length(fSuffix) + 1, Length(fSuffix));

  if (length(s) <> 0) then
    TryStrToInt(S, Result);
end;

procedure TSharpeGaugeBox.BtnGaugeClick(Sender: TObject);
var
  tmpGaugeBar: TJvTrackBar;
begin
  UpdateValue(GetNewValue);
  UpdateEditBox;

  if not (assigned(FFrmSharpeGaugeBox)) then
    FFrmSharpeGaugeBox := TFrmSharpeGaugeBox.Create(Self);

  with FFrmSharpeGaugeBox as TFrmSharpeGaugeBox do
  begin
    GaugeBoxEdit := Self;
    NoUpdate := True;
    tmpGaugeBar := GetGaugeBar;
    tmpGaugeBar.Max := FMax;
    tmpGaugeBar.Position := FValue;
    tmpGaugeBar.Min := FMin;

    NoUpdate := False;
  end;

  PopAnimateWindow(Self, TFrmSharpeGaugeBox(FFrmSharpeGaugeBox));
   TFrmSharpeGaugeBox(FFrmSharpeGaugeBox).BorderPanel.SetFocus;
end;

procedure TSharpeGaugeBox.SetMax(const Value: Integer);
begin
  FMax := Value;
end;

procedure TSharpeGaugeBox.SetMin(const Value: Integer);
begin
  FMin := Value;
end;

procedure TSharpeGaugeBox.SetValue(const Value: Integer);
begin
  FValue := Value;
  UpdateEditBox;
end;

procedure TSharpeGaugeBox.SetPrefix(const Value: string);
begin
  FPrefix := Value;
  UpdateEditBox;
end;

procedure TSharpeGaugeBox.SetSuffix(const Value: string);
begin
  FSuffix := Value;
  UpdateEditBox;
end;

procedure TSharpeGaugeBox.SetPercentDisplay(const Value : boolean);
begin
  FPercentDisplay := Value;
  UpdateEditBox;
end;

procedure TSharpeGaugeBox.UpdateEditBox;
var
  temp : integer;
begin
  if FPercentDisplay then
     temp := round(FValue / FMax * 100)
     else temp := FValue;
  FValueEdit.Text := Format('%s' + FFormatting + '%s', [FPrefix, temp, FSuffix]);
end;

procedure TSharpeGaugeBox.ValueEditKeyPress(Sender: TObject; var Key: Char);
begin

  if not (key in ['0'..'9', #8, '-']) then
    key := #0; //#8 = BackSpace
end;

procedure TSharpeGaugeBox.ValueEditExit(Sender: TObject);
begin
  UpdateValue(GetNewValue);
  UpdateEditBox;
  SelectValueText;
end;

procedure TSharpeGaugeBox.ValueEditClick(Sender: Tobject);
begin
  SelectValueText;
  FBtnGauge.Refresh;
end;

procedure TSharpeGaugeBox.PopAnimateWindow(Popper: TControl;
  PopWindow: TWinControl);
var
  xPos: TPoint;
  h, w: integer;
begin
  h := PopWindow.Height;

  w := 150;

  xPos := Popper.ClientToScreen(Point(0, Popper.ClientHeight));

  case FPopPosition of
    ppTop:
      begin
        xPos.Y := xPos.Y - self.Height - h - 3;
        xPos.X := xpos.X + 1;
      end;
    ppBottom: begin
      xPos.X := xPos.X + self.Width - w;
    end;
    ppLeft:
      begin
        xPos.X := xPos.X - Self.Width + 1;
        xPos.Y := xPos.Y - self.Height + 1;
      end;
    ppRight:
      begin
        xPos.X := xPos.X + self.Width;
        xPos.Y := xPos.Y - self.Height;
      end;
  end;

  PopWindow.Left := xPos.X;
  PopWindow.Top := xPos.Y;
  PopWindow.Width := w;
  PopWindow.Height := h;

  PopWindow.Show;
end;

procedure TSharpeGaugeBox.BtnGaugeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  BtnGaugeClick(Sender);
end;

procedure TSharpeGaugeBox.UpdateValue(newValue: integer);
var
  changed : Boolean;
begin
  changed := False;

  // Value has not changed, don't update
  if FValue = newValue then
    exit;

  if FPercentDisplay then
    newValue := round(newValue * FMax / 100);

  if (newValue > FMax) and (newValue <> FMax) then
  begin
    newValue := FMax;
    FValue := newValue;
    UpdateEditBox;
    changed := True;
  end;

  if (newValue < FMin) and (newValue <> FMin) then
  begin
    newValue := FMin;
    FValue := newValue;
    UpdateEditBox;
    changed := True;
  end;

  if (newValue <> FValue) then
    changed := True;
        
  FValue := newValue;

  SelectValueText;

  if (changed) and (assigned(FOnChangeValue)) then
    FOnChangeValue(Self, newValue);
end;

procedure TSharpeGaugeBox.ValueEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    UpdateValue(GetNewValue);
    UpdateEditBox;
    Self.SetFocus;
  end
  else if (key = VK_DOWN) then
    BtnGaugeClick(Sender);
end;

procedure TSharpeGaugeBox.SetPopPosition(const Value: TPopPosition);
begin
  FPopPosition := Value;
end;

procedure TSharpeGaugeBox.SetBackgroundColor(const Value: TColor);
var
  tmpGlyph: TBitmap32;
begin
  FValueEdit.Color := Value;
  FBackPanel.Color := Value;

  // Update glyph
  tmpGlyph := TBitmap32.Create;
  try
    tmpGlyph.DrawMode := dmBlend;
    tmpGlyph.LoadFromResourceName(HInstance,'DROPLEFT_GRAY');
    SharpGraphicsUtils.ReplaceColor32( tmpGlyph, Color32(clBlack), color32(Font.Color) );
    tmpGlyph.DrawTo(FBtnGauge.Glyph.Canvas.Handle,0,0);
  finally
    tmpGlyph.Free;
  end;
end;

procedure TSharpeGaugeBox.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TSharpeGaugeBox.SelectValueText;
var
  temp: Integer;
begin
  if FPercentDisplay then
     temp := round(FValue / FMax * 100)
     else temp := FValue;

  FValueEdit.SelStart := Pos(IntToStr(temp), FValueEdit.Text) - 1;
  FValueEdit.SelLength := length(IntToStr(temp));
end;

end.

