{
Source Name: SharpELabel
Description: Themed Label for SharpE
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
unit SharpELabel;

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
  StdCtrls,
  SharpEBaseControls,
  SharpESkinManager;

type
  TSharpELabelStyle = (lsSmall,lsMedium,lsBig);
  TSharpELabel = class(TLabel)
  private
    FManager: TSharpESkinManager;
    FLayout: TTextLayout;
    FLabelStyle: TSharpELabelStyle;

    procedure SetManager(const Value: TSharpESkinManager);
    procedure SetLayout(const Value: TTextLayout);
    procedure SetLabelStyle(const Value : TSharpELabelStyle);

    { Private declarations }
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
    procedure Paint; override;
    procedure Loaded; override;
    { Protected declarations }
  public
    { Public declarations }
    procedure UpdateSkin; overload;
    procedure UpdateSkin(sender: TComponent); overload;
  published
    { Published declarations }
    property SkinManager: TSharpESkinManager read FManager write SetManager;
    property Layout: TTextLayout read FLayout write SetLayout default tlTop;
    property LabelStyle: TSharpELabelStyle read FLabelStyle write SetLabelStyle;
  end;

implementation

uses SharpESkinPart;

procedure TSharpELabel.Paint;
var
  Rect: TRect;
begin
  with Canvas do
  begin
    if not Transparent then
    begin
      Brush.Color := Self.Color;

      Brush.Style := bsSolid;
      FillRect(ClientRect);
    end;
    Brush.Style := bsClear;
    Rect := ClientRect;
    DoDrawText(Rect, 0);
  end;
end;

procedure TSharpELabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  Text: string;
  VAlign: TVerticalAlignment;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
  VerticalAlignments: array[TVerticalAlignment] of Longint = (DT_TOP, DT_BOTTOM,
    DT_VCENTER);

begin
  Text := caption;
  VAlign := taAlignTop;

  if Assigned(FManager) then
  begin
    case FLabelStyle of
      lsSmall: FManager.Skin.SmallText.AssignFontTo(Canvas.Font,FManager.Scheme);
      lsMedium: FManager.Skin.MediumText.AssignFontTo(Canvas.Font,FManager.Scheme);
      lsBig: FManager.Skin.BigText.AssignFontTo(Canvas.Font,FManager.Scheme);
    end;
  end else Canvas.Font.Assign(Self.Font);

  if AutoSize then
  begin
    if Canvas.TextWidth(Caption) <> Width then Width := Canvas.TextWidth(Caption);
    if Canvas.TextHeight(Caption) <> Height then Height := Canvas.TextHeight(Caption);
  end;

  if not Enabled then
  begin
    if Assigned(FManager) then
       Canvas.Font.Color := clBtnShadow;
  end;

  case Layout of
    tlTop: VAlign := taAlignTop;
    tlCenter: VAlign := taVerticalCenter;
    tlBottom: VAlign := taAlignBottom;
  end;

  Flags := Flags or DT_NOPREFIX or DT_EXPANDTABS or DT_SINGLELINE or
    VerticalAlignments[VAlign] or Alignments[Alignment];
  Flags := DrawTextBiDiModeFlags(Flags);

  DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

procedure TSharpELabel.SetManager(const Value: TSharpESkinManager);
begin
  FManager := Value;
  UpdateSkin;
end;

procedure TSharpELabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FManager) then
    begin
      FManager := nil;
      UpdateSkin;
    end;
  end
  else
    if (Operation = opInsert) then
    begin
      if (AComponent is TSharpESkinManager) and (csDesigning in ComponentState)
        then
      begin
        if FManager = nil then
        begin
          FManager := AComponent as TSharpESkinManager;
          UpdateSkin;
        end;
      end;
    end;
end;

procedure TSharpELabel.UpdateSkin(sender: TComponent);
begin
  if FManager = sender then
    UpdateSkin;
end;

procedure TSharpELabel.UpdateSkin;
begin
  Paint;
end;

procedure TSharpELabel.Loaded;
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpELabel.SetLabelStyle(const Value : TSharpELabelStyle);
begin
  FLabelStyle := Value;
  UpdateSkin;
  Invalidate;
end;

procedure TSharpELabel.SetLayout(const Value: TTextLayout);
begin
  inherited Layout;
  FLayout := Value;

  // Force Invalidate

  UpdateSkin;
  Invalidate;
end;

end.
