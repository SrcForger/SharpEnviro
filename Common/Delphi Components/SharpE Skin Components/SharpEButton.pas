{
Source Name: SharpEButton
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

This component are using the GR32 library
http://sourceforge.net/projects/graphics32

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
unit SharpEButton;

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
  gr32,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
  SharpEScheme,
  SharpESkinManager,
  math,
  Types,
  Buttons;

type
  TGlyph32FileName = string;
  TSharpEButton = class(TCustomSharpEGraphicControl)
  private
    //FCancel: Boolean;

    FGlyph32FileName: TGlyph32FileName;
    FGlyph32: TBitmap32;
    FLayout: TButtonLayout;
    FMargin: Integer;
    FDisabledAlpha: Integer;
    FCaption: string;
    FModalResult: TModalResult;
    FDefault: Boolean;
    FAutoPosition: Boolean;

    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure SetGlyph32FileName(const Value: TGlyph32FileName);
    procedure Setglyph32(const Value: TBitmap32);
    procedure SetLayout(const Value: TButtonLayout);
    procedure SetMargin(const Value: Integer);
    procedure SetDisabledAlpha(const Value: Integer);
    procedure SetAutoPosition(const Value: boolean);
    procedure SetCaption(Value: string);
    procedure SetDefault(Value: Boolean);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure Resize; override;
    destructor Destroy; override;
  published
    //property Align;
    property Anchors;
    //property Cancel: Boolean read FCancel write FCancel default False;
    property Constraints;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
    //property TabOrder;
    //property TabStop default True;
    property AutoSize;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;

    property Glyph32FileName: TGlyph32FileName read FGlyph32FileName write  SetGlyph32FileName;
    property Glyph32: Tbitmap32 read FGlyph32 write SetGlyph32 stored True;
    property Layout: TButtonLayout read FLayout write SetLayout;
    property Margin: Integer read FMargin write SetMargin;
    property DisabledAlpha: Integer read FDisabledAlpha write SetDisabledAlpha;
    property Caption: string read FCaption write SetCaption;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Default: Boolean read FDefault write SetDefault default False;
    property AutoPosition: boolean read FAutoPosition write SetAutoPosition;
   { Published declarations }
  end;

implementation

uses
   gr32_png;

constructor TSharpEButton.Create;
begin
  inherited Create(AOwner);
  Width := 75;
  Height := 25;

  FGlyph32 := TBitmap32.Create;
 // FGlyph32.OnChange := Bitmap32ChangeEvent;

  FMargin := -1;
  FDisabledAlpha := 100;
  Flayout := blGlyphleft;
  FButtonDown := False;
end;

procedure TSharpEButton.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

procedure TSharpEButton.SetDefault(Value: Boolean);
var
  Form: TCustomForm;
begin
  FDefault := Value;
  {if HandleAllocated then
  begin   }
    Form := GetParentForm(Self);
    if Form <> nil then
      Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
  {end;}

  UpdateSkin;
end;

procedure TSharpEButton.CMDialogKey(var Message: TCMDialogKey);
begin
 { with Message do
    if  (((CharCode = VK_RETURN) and FActive) or
      ((CharCode = VK_ESCAPE) and FCancel)) and
      (KeyDataToShiftState(Message.KeyData) = []) and CanFocus then
    begin
      Click;
      Result := 1;
    end else   }
  inherited;
end;

procedure TSharpEButton.CMDialogChar(var Message: TCMDialogChar);
begin
 { with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      Click;
      Result := 1;
    end else }

  inherited;
end;

procedure TSharpEButton.CMFocusChanged(var Message: TCMFocusChanged);
begin
  {with Message do
    if Sender.Name = TsharpeButton.ClassName then
      FActive := Sender = Self
    else
      FActive := FDefault;
  //SetButtonStyle(FActive); }
  inherited;
end;

//procedure TSharpEButton.SetDefault(Value: Boolean);
//var
//  Form: TCustomForm;
//begin
//  FDefault := Value;
 { if HandleAllocated then
  begin
    Form := GetParentForm(Self);
    if Form <> nil then
      Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
  end; }
//end;

procedure TSharpEButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEButton.SMouseEnter;
begin
  UpdateSkin;
end;

procedure TSharpEButton.SMouseLeave;
begin
  UpdateSkin;
end;

procedure TSharpEButton.DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  r: TRect;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    DefaultSharpESkinText.AssignFontTo(bmp.Font,Scheme);
    DrawMode := dmBlend;
    r := Rect(0, 0, Width, Height);
    if true then
    begin
      FrameRectS(0, 0, Width, Height, color32(clblack));
      Inc(r.Left); Inc(r.Top); Dec(r.Bottom); Dec(r.Right);
    end;
    if FButtonDown then
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.WorkAreaLight), 200));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.WorkAreaDark), 200));
    end
    else
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.WorkAreadark), 200));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.WorkAreaLight), 200));
    end;
    FillRect(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1,
      setalpha(color32(Scheme.WorkAreaBack), 200));

    if FDefault then
      FrameRectS(r.Left+1, r.Top+1, r.Right-1, r.Bottom-1,
        setalpha(color32(Scheme.WorkAreadark), 200));

    if FGlyph32 <> nil then
    begin
      TextSize.X := bmp.TextWidth(caption);
      TextSize.Y := bmp.TextHeight(caption);
      TextPos.X := Width div 2 - TextSize.X div 2;
      TextPos.Y := Height div  2 - TextSize.Y div 2;
      case Layout of
        blGlyphLeft:
        begin
          GlyphPos.X := TextPos.X - (FGlyph32.Width + Margin) div 2;
          GlyphPos.Y := TextPos.Y - Glyph32.Height div 2 + TextSize.Y div 2;
          TextPos.X := TextPos.X + (FGlyph32.Width + Margin) div 2;
        end;

        blGlyphRight:
        begin
          GlyphPos.Y := TextPos.Y - Glyph32.Height div 2 + TextSize.Y div 2;
          TextPos.X := TextPos.X - (FGlyph32.Width + Margin) div 2;
          GlyphPos.X := TextPos.X + TextSize.X + Margin;
        end;

        blGlyphTop:
        begin
          GlyphPos.X := TextPos.X + TextSize.X div 2 - Glyph32.Width div 2;
          GlyphPos.Y := TextPos.Y - (FGlyph32.Height + Margin) div 2;
          TextPos.Y := TextPos.Y + (FGlyph32.Height + Margin) div 2;
        end;

        blGlyphBottom:
        begin
          GlyphPos.X := TextPos.X + TextSize.X div 2 - Glyph32.Width div 2;
          TextPos.Y := TextPos.Y - (FGlyph32.Height + Margin) div 2;
          GlyphPos.Y := TextPos.Y + TextSize.Y + Margin;
        end;
      end;
      FGlyph32.DrawMode := dmBlend;
      FGlyph32.CombineMode := cmMerge;
      if not Enabled then FGlyph32.MasterAlpha := FDisabledAlpha;
      FGlyph32.DrawTo(bmp,GlyphPos.X,GlyphPos.Y);
      FGlyph32.MasterAlpha := 255;
      bmp. RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp.Font.color));
    end;
  end;
end;

procedure TSharpEButton.DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  r, TextRect, CompRect: TRect;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
begin
  CompRect := Rect(0, 0, width, height);

  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, Scheme);
    exit;
  end;

  if (FAutoPosition) then
     Top := FManager.Skin.ButtonSkin.SkinDim.YAsInt;

  if FManager.Skin.ButtonSkin.Valid then
  begin
    if FAutoSize then
    begin
      r := FManager.Skin.ButtonSkin.GetAutoDim(CompRect);
      if (r.Right <> width) or (r.Bottom <> height) then
      begin
        width := r.Right;
        height := r.Bottom;
        Exit;
      end;
    end;

    if (csDesigning in componentstate) then
    begin
      FButtonDown := False;
      FButtonOver := False;
    end;

    FSkin.Clear(Color32(0, 0, 0, 0));
    if not (Enabled) and not (FManager.Skin.ButtonSkin.Disabled.Empty) then
    begin
      FManager.Skin.ButtonSkin.Disabled.Draw(bmp, Scheme);
      FManager.Skin.ButtonSkin.Disabled.SkinText.AssignFontTo(bmp.Font,Scheme);
      TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
      TextPos := FManager.Skin.ButtonSkin.Disabled.SkinText.GetXY(TextRect, CompRect);
    end
    else
      if FButtonDown and not (FManager.Skin.ButtonSkin.Down.Empty) then
      begin
        FManager.Skin.ButtonSkin.Down.Draw(bmp, Scheme);
        FManager.Skin.ButtonSkin.Down.SkinText.AssignFontTo(bmp.Font,Scheme);
        TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
        TextPos := FManager.Skin.ButtonSkin.Down.SkinText.GetXY(TextRect, CompRect);
      end
      else
        if FButtonOver and not (FManager.Skin.ButtonSkin.Hover.Empty) then
        begin
          FManager.Skin.ButtonSkin.Hover.Draw(bmp, Scheme);
          FManager.Skin.ButtonSkin.Hover.SkinText.AssignFontTo(bmp.Font,Scheme);
          TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
          TextPos := FManager.Skin.ButtonSkin.Hover.SkinText.GetXY(TextRect, CompRect);
        end
        else
        begin
          FManager.Skin.ButtonSkin.Normal.Draw(bmp, Scheme);
          FManager.Skin.ButtonSkin.Normal.SkinText.AssignFontTo(bmp.Font,Scheme);
          TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
          TextPos := FManager.Skin.ButtonSkin.Normal.SkinText.GetXY(TextRect, CompRect);
        end;

    if FGlyph32 <> nil then
    begin
      TextSize.X := bmp.TextWidth(caption);
      TextSize.Y := bmp.TextHeight(caption);
      case Layout of
        blGlyphLeft:
        begin
          GlyphPos.X := TextPos.X - (FGlyph32.Width + Margin) div 2;
          GlyphPos.Y := TextPos.Y - Glyph32.Height div 2 + TextSize.Y div 2;
          TextPos.X := TextPos.X + (FGlyph32.Width + Margin) div 2;
        end;

        blGlyphRight:
        begin
          GlyphPos.Y := TextPos.Y - Glyph32.Height div 2 + TextSize.Y div 2;
          TextPos.X := TextPos.X - (FGlyph32.Width + Margin) div 2;
          GlyphPos.X := TextPos.X + TextSize.X + Margin;
        end;

        blGlyphTop:
        begin
          GlyphPos.X := TextPos.X + TextSize.X div 2 - Glyph32.Width div 2;
          GlyphPos.Y := TextPos.Y - (FGlyph32.Height + Margin) div 2;
          TextPos.Y := TextPos.Y + (FGlyph32.Height + Margin) div 2;
        end;

        blGlyphBottom:
        begin
          GlyphPos.X := TextPos.X + TextSize.X div 2 - Glyph32.Width div 2;
          TextPos.Y := TextPos.Y - (FGlyph32.Height + Margin) div 2;
          GlyphPos.Y := TextPos.Y + TextSize.Y + Margin;
        end;
      end;
      FGlyph32.DrawMode := dmBlend;
      FGlyph32.CombineMode := cmMerge;
      if not Enabled then FGlyph32.MasterAlpha := FDisabledAlpha;
      FGlyph32.DrawTo(bmp,GlyphPos.X,GlyphPos.Y);
      FGlyph32.MasterAlpha := 255;
      bmp.RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp.Font.color));
    end;
  end
  else
    DrawDefaultSkin(bmp, Scheme);
end;

procedure TSharpEButton.SetCaption(Value: string);
begin
  FCaption := Value;

  UpdateSkin;
end;

procedure TSharpEButton.Resize;
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEButton.SetEnabled(Value: Boolean);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEButton.SetAutoPosition(const Value: boolean);
begin
  if FAutoPosition <> Value then
  begin
    FAutoPosition := Value;
    if (FAutoPosition) and (Assigned(FManager)) then
       Top := FManager.Skin.ButtonSkin.SkinDim.YAsInt;
  end;
end;

procedure TSharpEButton.SetLayout(const Value: TButtonLayout);
begin
  FLayout := Value;
  UpdateSkin;
end;

procedure TSharpEButton.SetDisabledAlpha(const Value: Integer);
begin
  if (Value >= 0) and (Value <= 255) then
    FDisabledAlpha := Value;

  UpdateSkin;
end;

procedure TSharpEButton.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  UpdateSkin;
end;

destructor TSharpEButton.Destroy;
begin
  inherited;
  FGlyph32.Free;
end;

procedure TSharpEButton.SetGlyph32FileName(const Value: TGlyph32FileName);
var
  bAlpha: Boolean;
begin
  //This is all neccesary, because you can't assign a nil to a TPNGObject
  if not (FileExists(Value)) or (Value = '') then begin
    FGlyph32.Assign(nil);
    FGlyph32FileName := '';
  end
  else
  begin

    if ExtractFileExt(Value) = '.png' then
      GR32_Png.LoadBitmap32FromPNG(FGlyph32, Value, bAlpha)
    else
      FGlyph32.LoadFromFile(Value);

    FGlyph32.DrawMode := dmBlend;
    FGlyph32.CombineMode := cmMerge;
    FGlyph32FileName := ExtractFileName(Value);
  end;

  UpdateSkin;
end;

procedure TSharpEButton.SetGlyph32(const Value: TBitmap32);
begin
  if (Value <> nil) and (FGlyph32FileName = '') then
    FGlyph32FileName := 'bitmap32data';
  if (Value = nil) then
    FGlyph32FileName := '';
  FGlyph32.Assign(Value);

  UpdateSkin;
end;


end.
