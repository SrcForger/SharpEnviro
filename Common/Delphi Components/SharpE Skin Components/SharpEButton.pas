{
Source Name: SharpEButton
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)

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
  StdCtrls,
  gr32,
  ISharpESkinComponents,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
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
    FCaption: string;
    FModalResult: TModalResult;
    FDefault: Boolean;
    FAutoPosition: Boolean;
    FPrecacheText : ISharpESkinText;
    FPrecacheBmp  : TBitmap32;
    FPrecacheCaption : String;
    FGlyphColor : integer;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure SetGlyph32FileName(const Value: TGlyph32FileName);
    procedure Setglyph32(const Value: TBitmap32);
    procedure SetLayout(const Value: TButtonLayout);
    procedure SetAutoPosition(const Value: boolean);
    procedure SetCaption(Value: string);
    procedure SetDefault(Value: Boolean);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
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
    procedure CalculateGlyphColor;    
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
    property PopUpMenu;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;

    property Skin : TBitmap32 read FSkin;
    property Glyph32FileName: TGlyph32FileName read FGlyph32FileName write  SetGlyph32FileName;
    property Glyph32: Tbitmap32 read FGlyph32 write SetGlyph32 stored True;
    property Layout: TButtonLayout read FLayout write SetLayout;
    property Caption: string read FCaption write SetCaption;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Default: Boolean read FDefault write SetDefault default False;
    property AutoPosition: Boolean read FAutoPosition write SetAutoPosition;
    property GlyphColor : integer read FGlyphColor;
   { Published declarations }
  end;

implementation

uses
  gr32_png,
  uThemeConsts,
  SharpGraphicsUtils;

constructor TSharpEButton.Create;
begin
  inherited Create(AOwner);
  Width := 75;
  Height := 25;

  FGlyph32 := TBitmap32.Create;
 // FGlyph32.OnChange := Bitmap32ChangeEvent;

  FMargin := -1;
  Flayout := blGlyphleft;
  FButtonDown := False;

  CalculateGlyphColor;
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

procedure TSharpEButton.CalculateGlyphColor;
begin
  if FGlyph32 <> nil then
    FGlyphColor := GetColorAverage(FGlyph32)
  else FGlyphColor := clWhite;
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

  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  if HasNormalHoverScript then
     FManager.Skin.Button.Normal.ExecuteScript(self,
                                               FManager.Skin.Button.OnNormalMouseEnterScript,
                                               FManager.Scheme,
                                               nil)
     else UpdateSkin;
end;

procedure TSharpEButton.SMouseEnter;
begin
  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  if HasNormalHoverScript then
     FManager.Skin.Button.Normal.ExecuteScript(self,
                                               FManager.Skin.Button.OnNormalMouseEnterScript,
                                               FManager.Scheme,
                                               nil)
     else UpdateSkin;
end;

procedure TSharpEButton.SMouseLeave;
begin
  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  if HasNormalHoverScript then
     FManager.Skin.Button.Normal.ExecuteScript(self,
                                               FManager.Skin.Button.OnNormalMouseLeaveScript,
                                               FManager.Scheme,
                                               nil)
     else UpdateSkin;
end;

function TSharpEButton.HasNormalHoverScript : boolean;
begin
  result := False;
  if not assigned(FManager) then exit;

  if (length(Trim(FManager.Skin.Button.OnNormalMouseEnterScript)) > 0)
     and (length(Trim(FManager.Skin.Button.OnNormalMouseLeaveScript)) > 0) then result := True
     else result := False;
end;

procedure TSharpEButton.DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r: TRect;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
begin
  if (Height <> 25) and (FAutoSize) then
  begin
    Height := 25;
    exit;
  end;
    
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    SharpEDefault.AssignDefaultFontTo(bmp.Font);
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

    if (FGlyph32 <> nil) and (FGlyph32.Width>0) and (FGlyph32.Height>0) then
    begin
      TextSize.X := bmp.TextWidth(caption);
      TextSize.Y := bmp.TextHeight(caption);
      TextPos.X := Width div 2 - TextSize.X div 2;
      TextPos.Y := Height div  2 - TextSize.Y div 2;
      case Layout of
        blGlyphLeft:
        begin
          GlyphPos.X := TextPos.X - (16 + 4) div 2;
          GlyphPos.Y := TextPos.Y - 16 div 2 + TextSize.Y div 2;
          TextPos.X := TextPos.X + (16 + 4) div 2;
        end;

        blGlyphRight:
        begin
          GlyphPos.Y := TextPos.Y - 16 div 2 + TextSize.Y div 2;
          TextPos.X := TextPos.X - (16 + 4) div 2;
          GlyphPos.X := TextPos.X + TextSize.X + 4;
        end;

        blGlyphTop:
        begin
          GlyphPos.X := TextPos.X + TextSize.X div 2 - 16 div 2;
          GlyphPos.Y := TextPos.Y - (16 + 4) div 2;
          TextPos.Y := TextPos.Y + (16 + 4) div 2;
        end;

        blGlyphBottom:
        begin
          GlyphPos.X := TextPos.X + TextSize.X div 2 - 16 div 2;
          TextPos.Y := TextPos.Y - (16 + 4) div 2;
          GlyphPos.Y := TextPos.Y + TextSize.Y + 4;
        end;
      end;
      FGlyph32.DrawMode := dmBlend;
      FGlyph32.CombineMode := cmMerge;
      FGlyph32.DrawTo(bmp,Rect(GlyphPos.X,GlyphPos.Y,GlyphPos.X+16,GlyphPos.Y+16));
      FGlyph32.MasterAlpha := 255;
      bmp.RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp.Font.color));
    end;
  end;
end;

function TSharpEButton.GetTextWidth : integer;
var
  bmp : TBitmap32;
  SkinText : ISharpESkinText;
begin
  bmp := TBitmap32.Create;
  try
    if not Assigned(FManager) then
    begin
      AssignDefaultFontTo(bmp.Font);
    end else
    begin
      if FManager.Skin.Button.Valid then
      begin
        SkinText := FManager.Skin.Button.Normal.CreateThemedSkinText;
        SkinText.AssignFontTo(bmp.Font,DefaultSharpEScheme);
        SkinText := nil;
      end;
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
    if not assigned(FManager) then
    begin
      result := 16;
      exit;
    end;
    if FButtonDown and not (FManager.Skin.Button.Down.Empty) then
      result := FManager.Skin.Button.Down.Icon.Dimension.X
    else if ((FButtonOver) and not (FManager.Skin.Button.Hover.Empty) and not (HasNormalHoverScript)) then
      result := FManager.Skin.Button.Hover.Icon.Dimension.X
    else
      result := FManager.Skin.Button.Normal.Icon.Dimension.X;
  end;
end;

procedure TSharpEButton.DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r, TextRect, CompRect, IconRect: TRect;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
  SkinText : ISharpESkinText;
  SkinIcon : ISharpESkinIcon;
  i : integer;
begin
  CompRect := Rect(0, 0, width, height);

  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
    exit;
  end;

  UpdateAutoPosition;

  if FManager.Skin.Button.Valid then
  begin
    if FAutoSize then
    begin
      r := FManager.Skin.Button.GetAutoDim(CompRect);
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

    FSkin.SetSize(Width,Height);
    FSkin.Clear(Color32(0, 0, 0, 0));

    i := Scheme.GetColorIndexByTag('$IconHighlight');
    if (i > -1) and (i <= High(Scheme.Colors)) then
    begin
      if Scheme.Colors[i].SchemeType = stDynamic then
        if Scheme.Colors[i].Color <> FGlyphColor then
        begin
          Scheme.Colors[i].Color := FGlyphColor;
          FManager.Skin.Button.Normal.UpdateDynamicProperties(Scheme);
          FManager.Skin.Button.Down.UpdateDynamicProperties(Scheme);
          FManager.Skin.Button.Hover.UpdateDynamicProperties(Scheme);
        end;
    end;

    if FButtonDown and not (FManager.Skin.Button.Down.Empty) then
    begin
      FManager.Skin.Button.Down.DrawTo(bmp, Scheme);
      SkinText := FManager.Skin.Button.Down.CreateThemedSkinText;
      SkinIcon := FManager.Skin.Button.Down.Icon;
    end
    else if ((FButtonOver) and not (FManager.Skin.Button.Hover.Empty) and not (HasNormalHoverScript)) then
    begin
      FManager.Skin.Button.Hover.DrawTo(bmp, Scheme);
      SkinText := FManager.Skin.Button.Hover.CreateThemedSkinText;
      SkinIcon := FManager.Skin.Button.Hover.Icon;
    end
    else
    begin
      FManager.Skin.Button.Normal.DrawTo(bmp, Scheme);
      SkinText := FManager.Skin.Button.Normal.CreateThemedSkinText;
      SkinIcon := FManager.Skin.Button.Normal.Icon;
    end;

    if (FGlyph32 <> nil) and (SkinIcon.DrawIcon)
       and (FGlyph32.Width>0) and (FGlyph32.Height>0) then
      IconRect := Rect(0,0,SkinIcon.Dimension.X,SkinIcon.Dimension.Y)
    else IconRect := Rect(0,0,0,0);
    SkinText.AssignFontTo(bmp.Font,Scheme);
    TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
    TextPos := SkinText.GetXY(TextRect, CompRect, IconRect);

    if (FGlyph32 <> nil) and (SkinIcon.DrawIcon)
       and (FGlyph32.Width>0) and (FGlyph32.Height>0) then
    begin
      TextSize.X := bmp.TextWidth(caption);
      TextSize.Y := bmp.TextHeight(caption);

      GlyphPos := SkinIcon.GetXY(TextRect,CompRect);
      SkinIcon.DrawTo(bmp,FGlyph32,GlyphPos.X,GlyphPos.Y);
    end;

    if length(trim(Caption))>0 then
       SkinText.RenderTo(bmp,TextPos.X,TextPos.Y,Caption,Scheme,
                         FPrecacheText,FPrecacheBmp,FPrecacheCaption);

    SkinText := nil;
    SkinIcon := nil;
    
    Bmp.DrawTo(FSkin);
  end
  else
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
end;

procedure TSharpEButton.SetCaption(Value: string);
begin
  if CompareStr(FCaption,Value) <> 0 then
  begin
    FCaption := Value;
    UpdateSkin;
    Invalidate;
  end;
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
    if (Assigned(FManager)) then
    begin
      if Top <> FManager.Skin.Button.Location.Y then
         Top := FManager.Skin.Button.Location.Y;
    end;
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

destructor TSharpEButton.Destroy;
begin
  if FPrecacheBmp <> nil then
    FreeAndNil(FPrecacheBmp);
  if FPrecacheText <> nil then
    FPrecacheText := nil;

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

  CalculateGlyphColor;

  UpdateSkin;
end;

procedure TSharpEButton.SetGlyph32(const Value: TBitmap32);
begin
  if (Value <> nil) and (FGlyph32FileName = '') then
    FGlyph32FileName := 'bitmap32data';
  if (Value = nil) then
    FGlyph32FileName := '';
  FGlyph32.Assign(Value);

  CalculateGlyphColor;

  UpdateSkin;
end;


end.
