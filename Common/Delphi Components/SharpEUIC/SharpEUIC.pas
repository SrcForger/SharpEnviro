{
Source Name: SharpEUIC.pas
Description: Underlying Indicator Control Component (UIC)
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit SharpEUIC;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics, StdCtrls,
  SharpEGaugeBoxEdit, SharpEColorEditorEx, JvXPCheckCtrls, PngSpeedButton;

type
  TSharpEUIC = class(TPanel)
  private
    FOnResetEvent : TNotifyEvent;

    FResetBtn : TPngSpeedButton;
    FRoundValue: Integer;
    FBorderColor: TColor;
    FBorder: Boolean;
    FBackgroundColor: TColor;
    FNormalColor : TColor;
    FHasChanged : boolean;
    FAutoReset : boolean;
    FDefaultValue : String;
    FMonitorControl : TComponent;

    procedure SetMonitorControl(const Value: TComponent);
    
    procedure ResetBtnOnClick(Sender : TObject);
    procedure SetHasChanged(const Value: boolean);

  protected
    procedure Resize; override;
    procedure Paint; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateStatus(Init : boolean = False);
    procedure UpdateStatusFromValue(Value : String; Init : boolean = False); overload;
    procedure UpdateStatusFromValue(Value: Integer; Init: boolean = False); overload;
    procedure UpdateBtnStatus;

    procedure SetDefaultValue(const Value: String); overload;
    procedure SetDefaultValue(const Value: Boolean); overload;
    procedure SetDefaultValue(const Value: Integer); overload;
    procedure Reset;
  published
    property HasChanged : boolean read FHasChanged write SetHasChanged;
    property AutoReset : boolean read FAutoReset write FAutoReset;
    property DefaultValue : String read FDefaultValue write SetDefaultValue;
    property MonitorControl : TComponent read FMonitorControl write SetMonitorControl;
    property Color;

    property OnReset : TNotifyEvent read FOnResetEvent write FOnResetEvent;
  end;

procedure Register;

implementation

{$R SharpEUICIcons.res}

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpEUIC]);
end;

function StringToInteger(s : String) : integer;
var
  i : integer;
begin
  if TryStrToInt(s,i) then
    result := i
    else result := -1;
end;

function StringToBoolean(s : String) : boolean;
begin
  result := (CompareText(s,'true') = 0);
end;


constructor TSharpEUIC.Create(AOwner: TComponent);
begin
  Inherited;

  ParentBackground := False;
  FRoundValue := 10;
  FBackgroundColor := clBtnFace;
  FBorderColor := clBtnShadow;
  FNormalColor := clWhite;
  Color := clWhite;

  FBorder := True;
  FDefaultValue := '';
  FMonitorControl := nil;
  FHasChanged := False;
  FAutoReset := True;

  BevelInner := bvNone;
  BevelOuter := bvNone;

  DoubleBuffered := true;
  ParentBackground := false;

  FResetBtn := TPngSpeedButton.Create(self);
  FResetBtn.Parent := self;
  FResetBtn.Flat := True;
  FResetBtn.Visible := False;
  if not (csDesigning in ComponentState) then 
    FResetBtn.PngImage.LoadFromResourceName(hinstance,'UIC_RESET');
  FResetBtn.OnClick := ResetBtnOnClick;
  FResetBtn.ShowHint := True;
  FResetBtn.Hint := 'Reset Setting';

  UpdateBtnStatus;

  AutoSize := True;
end;

destructor TSharpEUIC.Destroy;
begin
  FResetBtn.Free;

  inherited;
end;

procedure TSharpEUIC.Paint;
begin
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
end;

procedure TSharpEUIC.Reset;
begin
  ResetBtnOnClick( nil);
end;

procedure TSharpEUIC.ResetBtnOnClick(Sender: TObject);
begin
  FHasChanged := False;

  if (FMonitorControl <> nil) then
  begin
    if FMonitorControl is TCheckBox then
      TCheckBox(FMonitorControl).Checked := StringToBoolean(FDefaultValue)
    else if FMonitorControl is TJvXpCheckBox then
      TJvXpCheckBox(FMonitorControl).Checked := StringToBoolean(FDefaultValue)
    else if FMonitorControl is TEdit then
      TEdit(FMonitorControl).Text := FDefaultValue
    else if FMonitorControl is TSharpEGaugeBox then
      TSharpeGaugeBox(FMonitorControl).Value := StringToInteger(FDefaultValue)
    else if FMonitorControl is TComboBox then
    begin
      if TComboBox(FMonitorControl).Style = csDropDown then
        TComboBox(FMonitorControl).Text := FDefaultValue
        else TComboBox(FMonitorControl).ItemIndex := StringToInteger(FDefaultValue);
    end
    else if FMonitorControl is TSharpEColorEditorEx then
    begin
      if TSharpEColorEditorEx(FMonitorControl).Items.Count > 0 then
        TSharpEColorEditorEx(FMonitorControl).Items.Item[0].ColorCode := StringToInteger(FDefaultValue);
    end;
  end;

  UpdateBtnStatus;
  Invalidate;

  if Assigned(FOnResetEvent) then
    FOnResetEvent(self);
end;

procedure TSharpEUIC.Resize;
var
  H, H2, H3: HRgn;
begin
  Inherited;
  H := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, FRoundValue, FRoundValue);
  H2 := H;
  H3 := CombineRgn(H2,H2,H,RGN_AND);
  DeleteObject(H2);
  DeleteObject(H);

  SetWindowRgn(Handle, H3, True);
  UpdateBtnStatus;
  Invalidate;
end;

procedure TSharpEUIC.SetDefaultValue(const Value: String);
begin
  FDefaultValue := Value;
  UpdateStatus(True);
end;

procedure TSharpEUIC.SetDefaultValue(const Value: Integer);
begin
  FDefaultValue := IntToStr(Value);
  UpdateStatus(True);
end;

procedure TSharpEUIC.SetDefaultValue(const Value: Boolean);
var
  s:string;
begin
  s := 'False';
  if Value then
    s := 'True';

  FDefaultValue := s;
  UpdateStatus(True);
end;

procedure TSharpEUIC.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
  UpdateStatus(False);
  UpdateBtnStatus;
end;

procedure TSharpEUIC.SetMonitorControl(const Value: TComponent);
begin
  FMonitorControl := Value;
  UpdateStatus(True);
end;

procedure TSharpEUIC.UpdateBtnStatus;
begin
  if FHasChanged then
  begin
    FResetBtn.Visible := True;
    FResetBtn.Top := 2;
    FResetBtn.Left := Width - 4 - FResetBtn.Width;
    FResetBtn.Height := 24;
    FResetBtn.Width := 24;

    if FMonitorControl <> nil then
    begin
      if FMonitorControl is TSharpEColorEditorEx then
        FResetBtn.Top := 8;

      //FResetBtn.Top := TWinControl(FMonitorControl).Top;
      FResetBtn.Left := TWinControl(FMonitorControl).Left + TWinControl(FMonitorControl).Width;
    end;
  end else
    FResetBtn.Visible := False;
end;

procedure TSharpEUIC.UpdateStatus(Init : boolean = False);
var
  NewChangedState : boolean;
begin
  if (FMonitorControl = nil) or (length(FDefaultValue) = 0) then
    exit;

  NewChangedState := FHasChanged;

  if FMonitorControl is TCheckBox then
    NewChangedState := (TCheckBox(FMonitorControl).Checked <> StringToBoolean(FDefaultValue))
  else if FMonitorControl is TJvXpCheckBox then
    NewChangedState := (TJvXpCheckBox(FMonitorControl).Checked <> StringToBoolean(FDefaultValue))
  else if FMonitorControl is TEdit then
    NewChangedState := (CompareText(TEdit(FMonitorControl).Text,FDefaultValue) <> 0)
  else if FMonitorControl is TSharpEGaugeBox then
    NewChangedState := (TSharpeGaugeBox(FMonitorControl).Value <> StringToInteger(FDefaultValue))
  else if FMonitorControl is TComboBox then
  begin
    if TComboBox(FMonitorControl).Style = csDropDown then
      NewChangedState := (CompareText(TComboBox(FMonitorControl).Text,FDefaultValue) <> 0)
      else NewChangedState := (TComboBox(FMonitorControl).ItemIndex <> StringToInteger(FDefaultValue));
  end
  else if FMonitorControl is TSharpEColorEditorEx then
  begin
    if TSharpEColorEditorEx(FMonitorControl).Items.Count > 0 then
      NewChangedState := (TSharpEColorEditorEx(FMonitorControl).Items.Item[0].ColorCode <> StringToInteger(FDefaultValue));
  end;

  if NewChangedState <> FHasChanged then
  begin
    if (NewChangedState and (not AutoReset) and (not FHasChanged))
       or (AutoReset) or (Init) then
    begin
      FHasChanged := NewChangedState;
      UpdateBtnStatus;
      Invalidate;
    end;
  end;
end;

procedure TSharpEUIC.UpdateStatusFromValue(Value: String; Init: boolean);
var
  NewChangedState : boolean;
begin
  NewChangedState := (CompareText(Value,DefaultValue) <> 0);

  if NewChangedState <> FHasChanged then
  begin
    if (NewChangedState and (not AutoReset) and (not FHasChanged))
       or (AutoReset) or (Init) then
    begin
      FHasChanged := NewChangedState;
      UpdateBtnStatus;
      Invalidate;
    end;
  end;  

end;

procedure TSharpEUIC.UpdateStatusFromValue(Value: Integer; Init: boolean);
var
  NewChangedState : boolean;
  s: string;
begin
  s := IntToStr(Value);
  NewChangedState := (CompareText(s,DefaultValue) <> 0);

  if NewChangedState <> FHasChanged then
  begin
    if (NewChangedState and (not AutoReset) and (not FHasChanged))
       or (AutoReset) or (Init) then
    begin
      FHasChanged := NewChangedState;
      UpdateBtnStatus;
      Invalidate;
    end;
  end;  

end;

end.

