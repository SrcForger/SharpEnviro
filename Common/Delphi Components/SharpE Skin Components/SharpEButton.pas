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
  gr32_resamplers,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
  SharpEScheme,
  SharpESkinManager,
  SharpESkin,
  SharpEAnimationTimers,
  SharpESkinPart,
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
    FGlyphResize : Boolean;
    FLayout: TButtonLayout;
    FMargin: Integer;
    FDisabledAlpha: Integer;
    FCaption: string;
    FModalResult: TModalResult;
    FDefault: Boolean;
    FAutoPosition: Boolean;
    FCustomSkin : TSharpEButtonSkin;
    FPrecacheText : TSkinText;
    FPrecacheBmp  : TBitmap32;
    FPrecacheCaption : String;
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
    procedure SetGlyphResize(Value: Boolean);
    function GetGlyphSize : TPoint;
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
  public
    function GetTextWidth : integer;
    function GetIconWidth : integer;
    constructor Create(AOwner: TComponent); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure Resize; override;
    destructor Destroy; override;
    procedure UpdateAutoPosition;
    function HasNormalHoverScript : boolean;
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

    property CustomSkin : TSharpEButtonSkin read FCustomSkin write FCustomSkin;
    property Glyph32FileName: TGlyph32FileName read FGlyph32FileName write  SetGlyph32FileName;
    property Glyph32: Tbitmap32 read FGlyph32 write SetGlyph32 stored True;
    property Layout: TButtonLayout read FLayout write SetLayout;
    property Margin: Integer read FMargin write SetMargin;
    property DisabledAlpha: Integer read FDisabledAlpha write SetDisabledAlpha;
    property Caption: string read FCaption write SetCaption;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Default: Boolean read FDefault write SetDefault default False;
    property AutoPosition: Boolean read FAutoPosition write SetAutoPosition;
    property GlyphResize: Boolean read FGlyphResize write SetGlyphResize;
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

procedure TSharpEButton.SetGlyphResize(Value: Boolean);
begin
  if Value <> FGlyphResize then
  begin
    FGlyphResize := Value;
    UpdateSkin;
  end;
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
var
  tempSkin : TSharpEButtonSkin;
begin
  inherited;

  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  if CustomSkin <> nil then
     tempSkin := CustomSkin
     else tempSkin := FManager.Skin.ButtonSkin;

  if HasNormalHoverScript then
     SharpEAnimManager.ExecuteScript(self,
                                     tempSkin.OnNormalMouseEnterScript,
                                     tempSkin.Normal,
                                     FManager.Scheme)
     else UpdateSkin;
end;

procedure TSharpEButton.SMouseEnter;
var
  tempSkin : TSharpEButtonSkin;
begin
  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  if CustomSkin <> nil then
     tempSkin := CustomSkin
     else tempSkin := FManager.Skin.ButtonSkin;

  if HasNormalHoverScript then
     SharpEAnimManager.ExecuteScript(self,
                                     tempSkin.OnNormalMouseEnterScript,
                                     tempSkin.Normal,
                                     FManager.Scheme)
     else UpdateSkin;
end;

procedure TSharpEButton.SMouseLeave;
var
  tempSkin : TSharpEButtonSkin;
begin
  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  if CustomSkin <> nil then
     tempSkin := CustomSkin
     else tempSkin := FManager.Skin.ButtonSkin;

  if HasNormalHoverScript then
     SharpEAnimManager.ExecuteScript(self,
                                     tempSkin.OnNormalMouseLeaveScript,
                                     tempSkin.Normal,
                                     FManager.Scheme)
     else UpdateSkin;
end;

function TSharpEButton.HasNormalHoverScript : boolean;
var
  tempSkin : TSharpEButtonSkin;
begin
  result := False;
  if not assigned(FManager) then exit;


  if CustomSkin <> nil then
     tempSkin := CustomSkin
     else tempSkin := FManager.Skin.ButtonSkin;

  if (length(Trim(tempSkin.OnNormalMouseEnterScript)) > 0)
     and (length(Trim(tempSkin.OnNormalMouseLeaveScript)) > 0) then result := True
     else result := False;
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
        setalpha(color32(Scheme.GetColorByName('WorkAreaLight')), 200));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('WorkAreaDark')), 200));
    end
    else
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('WorkAreadark')), 200));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('WorkAreaLight')), 200));
    end;
    FillRect(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1,
      setalpha(color32(Scheme.GetColorByName('WorkAreaBack')), 200));

    if FDefault then
      FrameRectS(r.Left+1, r.Top+1, r.Right-1, r.Bottom-1,
        setalpha(color32(Scheme.GetColorByName('WorkAreadark')), 200));

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
      bmp.RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp.Font.color));
    end;
  end;
end;

function TSharpEButton.GetGlyphSize : TPoint;
var
  ox,oy : TPoint;
  ButtonSkin : TSharpEButtonSkin;
begin
  if FGlyph32 = nil then
  begin
    result := Point(0,0);
    exit;
  end;

  if FCustomSkin <> nil then ButtonSkin := FCustomSkin
     else ButtonSkin := FManager.Skin.ButtonSkin;

  ox := Point(3,3);
  oy := Point(3,3);
  if Assigned(FManager) then
  begin
    ox := Point(ButtonSkin.IconLROffset.XasInt,
                ButtonSkin.IconLROffset.YasInt);
    oy := Point(ButtonSkin.IconTBOffset.XasInt,
                ButtonSkin.IconTBOffset.YasInt);
  end;

  if Height < FGlyph32.Height + (oy.x + oy.y) then
  begin
    result.y := Height - (oy.x + oy.y);
    result.x := round((FGlyph32.Width/FGlyph32.Height)*result.y);
  end else
  if Width < FGlyph32.Width + (ox.x + ox.y) then
  begin
    result.x := Width - (ox.x + ox.y);
    result.y := round((FGlyph32.Height/FGlyph32.Width)*result.x);
  end else
  begin
    result.x := FGlyph32.Width;
    result.y := FGlyph32.Height;
  end;
end;

function TSharpEButton.GetTextWidth : integer;
var
  bmp : TBitmap32;
  ButtonSkin : TSharpEButtonSkin;
begin
  bmp := TBitmap32.Create;
  try
    if not Assigned(FManager) then
    begin
      DefaultSharpESkinText.AssignFontTo(bmp.Font,DefaultSharpEScheme);
    end else
    begin
      if FCustomSkin <> nil then ButtonSkin := FCustomSkin
         else ButtonSkin := FManager.Skin.ButtonSkin;

      if ButtonSkin.Valid then
         ButtonSkin.Normal.SkinText.AssignFontTo(bmp.Font,DefaultSharpEScheme)
         else DefaultSharpESkinText.AssignFontTo(bmp.Font,DefaultSharpEScheme);
    end;
    result := bmp.TextWidth(FCaption);
    exit;
  finally
    bmp.free;
  end;
  result := 0;
end;

function TSharpEButton.GetIconWidth : integer;
begin
  if FGlyph32 = nil then result := 0
  else
  begin
    if FGlyphResize then
       result := GetGlyphSize.x
       else result := FGlyph32.Width;
  end;
end;

procedure TSharpEButton.DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  r, TextRect, CompRect: TRect;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
  glp : TBitmap32;
  nw,nh : integer;
  p : TPoint;
  ButtonSkin : TSharpEButtonSkin;
  SkinText : TSkinText;
begin
  CompRect := Rect(0, 0, width, height);

  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
    exit;
  end;

  if FCustomSkin <> nil then ButtonSkin := FCustomSkin
     else Buttonskin := FManager.Skin.ButtonSkin;

  if (FAutoPosition) then
     Top := ButtonSkin.SkinDim.YAsInt;

  if ButtonSkin.Valid then
  begin
    if FAutoSize then
    begin
      r := ButtonSkin.GetAutoDim(CompRect);
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
    if not (Enabled) and not (ButtonSkin.Disabled.Empty) then
    begin
      ButtonSkin.Disabled.Draw(bmp, Scheme);
      SkinText := ButtonSkin.Disabled.SkinText;
      ButtonSkin.Disabled.SkinText.AssignFontTo(bmp.Font,Scheme);
      TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
      TextPos := ButtonSkin.Disabled.SkinText.GetXY(TextRect, CompRect);
    end
    else
      if FButtonDown and not (ButtonSkin.Down.Empty) then
      begin
        ButtonSkin.Down.Draw(bmp, Scheme);
        SkinText := ButtonSkin.Down.SkinText;
        ButtonSkin.Down.SkinText.AssignFontTo(bmp.Font,Scheme);
        TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
        TextPos := ButtonSkin.Down.SkinText.GetXY(TextRect, CompRect);
      end
      else
        if ((FButtonOver) and not (ButtonSkin.Hover.Empty) and not (HasNormalHoverScript)) then
        begin
          ButtonSkin.Hover.Draw(bmp, Scheme);
          SkinText := ButtonSkin.Hover.SkinText;
          ButtonSkin.Hover.SkinText.AssignFontTo(bmp.Font,Scheme);
          TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
          TextPos := ButtonSkin.Hover.SkinText.GetXY(TextRect, CompRect);
        end
        else
        begin
          ButtonSkin.Normal.Draw(bmp, Scheme);
          SkinText := ButtonSkin.Normal.SkinText;
          ButtonSkin.Normal.SkinText.AssignFontTo(bmp.Font,Scheme);
          TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
          TextPos := ButtonSkin.Normal.SkinText.GetXY(TextRect, CompRect);
        end;

    if FGlyph32 <> nil then
    begin
      TextSize.X := bmp.TextWidth(caption);
      TextSize.Y := bmp.TextHeight(caption);

      glp := TBitmap32.Create;
      glp.DrawMode := dmBlend;
      glp.CombineMode := cmMerge;
      FGlyph32.DrawMode := dmBlend;
      FGlyph32.CombineMode := cmMerge;
      if FGlyphResize then
      begin
        TLinearResampler.Create(FGlyph32);
        p := GetGlyphSize;
        nw := p.x;
        nh := p.y;
      end else
      begin
        nw := FGlyph32.Width;
        nh := FGlyph32.Height;
      end;
      glp.SetSize(nw,nh);
      glp.Clear(color32(0,0,0,0));
      FGlyph32.DrawTo(glp,Rect(0,0,nw,nh));

      case Layout of
        blGlyphLeft:
        begin
          GlyphPos.X := TextPos.X - (glp.Width + Margin) div 2;
          GlyphPos.Y := TextPos.Y + round( - glp.Height / 2 + TextSize.Y / 2);
          TextPos.X := TextPos.X + (glp.Width + Margin) div 2;
        end;

        blGlyphRight:
        begin
          GlyphPos.Y := TextPos.Y - glp.Height div 2 + TextSize.Y div 2;
          TextPos.X := TextPos.X - (glp.Width + Margin) div 2;
          GlyphPos.X := TextPos.X + TextSize.X + Margin;
        end;

        blGlyphTop:
        begin
          GlyphPos.X := TextPos.X + TextSize.X div 2 - glp.Width div 2;
          GlyphPos.Y := TextPos.Y - (glp.Height + Margin) div 2;
          TextPos.Y := TextPos.Y + (glp.Height + Margin) div 2;
        end;

        blGlyphBottom:
        begin
          GlyphPos.X := TextPos.X + TextSize.X div 2 - glp.Width div 2;
          TextPos.Y := TextPos.Y - (glp.Height + Margin) div 2;
          GlyphPos.Y := TextPos.Y + TextSize.Y + Margin;
        end;
      end;
      if not Enabled then glp.MasterAlpha := FDisabledAlpha;
      glp.DrawTo(bmp,GlyphPos.X,GlyphPos.Y);
      glp.Free;
      if length(trim(Caption))>0 then
         SkinText.RenderTo(bmp,TextPos.X,TextPos.Y,Caption,Scheme,
                           FPrecacheText,FPrecacheBmp,FPrecacheCaption);
    end;
  end
  else
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
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

procedure TSharpEButton.UpdateAutoPosition;
begin
  if (FAutoPosition) then
  begin
    if FCustomSkin <> nil then Top := FCustomSkin.SkinDim.YAsInt
       else if (Assigned(FManager)) then Top := FManager.Skin.ButtonSkin.SkinDim.YAsInt;
  end;
end;

procedure TSharpEButton.SetAutoPosition(const Value: boolean);
begin
  if FAutoPosition <> Value then
  begin
    FAutoPosition := Value;
    UpdateAutoPosition;
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
  if FPrecacheBmp <> nil then FreeAndNil(FPrecacheBmp);
  if FPrecacheText <> nil then FreeAndNil(FPrecacheText);

  FGlyph32.Free;
  inherited;
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
