{
Source Name: SharpETaskItem
Description: TaskItem component for SharpE
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
unit SharpETaskItem;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  Forms,
  StdCtrls,
  uThemeConsts,
  gr32,
  gr32_resamplers,
  SharpGraphicsUtils,
  SharpEBase,
  SharpEBaseControls,
  SharpESkinPart,
  SharpEScheme,
  SharpEDefault,
  ISharpESkinComponents,
  SharpTypes,
  SharpApi,
  math,
  Types,
  Buttons;

type
  TGlyph32FileName = string;

  TSharpETaskItem = class(TCustomSharpEGraphicControl)
  private
    //FCancel: Boolean;
    FSpecial : boolean;       
    FUseSpecial : boolean;
    FFlashing : boolean;
    FState : TSharpETaskItemStates;
    FGlyph32FileName: TGlyph32FileName;
    FGlyph32: TBitmap32;
    FLayout: TButtonLayout;
    FMargin: Integer;
    FDisabledAlpha: Integer;
    FCaption: WideString;
    FModalResult: TModalResult;
    FDefault: Boolean;
    FAutoPosition: Boolean;
    FDown: Boolean;
    FPrecacheText : ISharpESkinText;
    FPrecacheBmp  : TBitmap32;
    FPrecacheCaption : WideString;
    FHandle : Cardinal;
    FDestroying : boolean;
    FOverlay : TBitmap32;
    FOverlayPos : TPoint;
    FGlyphColor : integer;
    FHighlightTimer : TTimer;
    FHighlightSettings : TSharpESkinHighlightSettings;
    procedure OnHighlightTimer(Sender : TObject);
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
    procedure SetCaption(Value: WideString);
    procedure SetDefault(Value: Boolean);
    procedure SetDown(Value: Boolean);
    procedure SetState(Value: TSharpETaskItemStates);
    procedure SetFlashing(Value : Boolean);
    procedure SetSpecial(Value : Boolean);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Resize; override;
    destructor Destroy; override;
    function GetCurrentStateItem : ISharpETaskItemStateSkin;
    procedure CalculateGlyphColor;
  published
    //property Align;
    property Anchors;
    //property Cancel: Boolean read FCancel write FCancel default False;
    property Constraints;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
    //property TabOrder;
    //property TabStop default True;
    property PopUpMenu;
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
    property Caption: WideString read FCaption write SetCaption;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Default: Boolean read FDefault write SetDefault default False;
    property AutoPosition: boolean read FAutoPosition write SetAutoPosition;
    property Down: Boolean read FDown write SetDown;
    property State: TSharpETaskItemStates read FState write SetState;
    property Flashing: Boolean read FFlashing write SetFlashing;
    property Handle: Cardinal read FHandle write FHandle;
    property Overlay: TBitmap32 read FOverlay;
    property OverlayPos: TPoint read FOverlayPos write FOverlayPos;
    property UseSpecial: boolean read FUseSpecial write FUseSpecial;
    property Special: boolean read FSpecial write SetSpecial;
   { Published declarations }
  end;

implementation

uses
   gr32_png;

constructor TSharpETaskItem.Create;
begin
  inherited Create(AOwner);
  Width := 75;
  Height := 25;

  FHighlightTimer := TTimer.Create(nil);
  FHighlightTimer.Enabled := False;
  FHighlightTimer.Interval := 100;
  FHighlightTimer.OnTimer := OnHighlightTimer;

  FHighlightSettings := TSharpESkinHighlightSettings.Create;

  FGlyph32 := TBitmap32.Create;
  FOverlay := TBitmap32.Create;
  FOverlay.DrawMode := dmBlend;
  FOverlay.CombineMode := cmMerge;

  FSpecial := False;
  FUseSpecial := False;
  FOverlayPos := Point(0,0);
  FDestroying := False;
  FHandle := 0;
  FMargin := -1;
  FDisabledAlpha := 100;
  Flayout := blGlyphleft;
  FButtonDown := False;
  FFlashing := False;
  Tag := 0;

  CalculateGlyphColor;
end;

procedure TSharpETaskItem.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

function TSharpETaskItem.GetCurrentStateItem : ISharpETaskItemStateSkin;
begin
  if not assigned(FManager) then
  begin
    result := nil;
    exit;
  end;

  case FState of
    tisCompact : result := FManager.Skin.TaskItem.Compact;
    tisMini    : result := FManager.Skin.TaskItem.Mini;
    else result := FManager.Skin.TaskItem.Full;
  end;
end;

procedure TSharpETaskItem.SetFlashing(Value : Boolean);
var
  CurrentState : ISharpETaskItemStateSkin; 
begin
  if Value <> FFlashing then
  begin
    FFlashing := Value;
    if not assigned(FManager) then exit;

    case FState of
      tisCompact : CurrentState := FManager.Skin.TaskItem.Compact;
      tisMini    : CurrentState := FManager.Skin.TaskItem.Mini;
      else CurrentState := FManager.Skin.TaskItem.Full;
    end;
    // Assign defaults
    if FFlashing then
      FHighlightSettings.Assign(CurrentState.HighlightSettings);

    FHighlightTimer.Enabled := FFlashing;
    UpdateSkin;
  end;
end;

procedure TSharpETaskItem.SetSpecial(Value: Boolean);
begin
  if FUseSpecial then
  begin
    if Value <> FSpecial then
    begin
      FSpecial := Value;
      UpdateSkin;
    end;
  end else
  begin
    if Value <> FDown then
    begin
      FDown := Value;
      UpdateSkin;
    end;
  end;
end;

procedure TSharpETaskItem.SetState(Value: TSharpETaskItemStates);
begin
  if Value <> FState then
  begin
    FState := Value;
    UpdateSkin;
  end;
end;

procedure TSharpETaskItem.SetDown(Value: Boolean);
begin
  if (Value <> FDown) and ((not FUseSpecial) or FSpecial) then
  begin
    FDown := Value;
    UpdateSkin;
  end;
end;

procedure TSharpETaskItem.SetDefault(Value: Boolean);
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

  if not Assigned(FManager) then exit;
  UpdateSkin;
end;

procedure TSharpETaskItem.CMDialogKey(var Message: TCMDialogKey);
begin
  inherited;
end;

procedure TSharpETaskItem.CalculateGlyphColor;
begin
  if FGlyph32 <> nil then
    FGlyphColor := GetColorAverage(FGlyph32)
  else FGlyphColor := clWhite;
end;

procedure TSharpETaskItem.CMDialogChar(var Message: TCMDialogChar);
begin
  inherited;
end;

procedure TSharpETaskItem.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
end;

procedure TSharpETaskItem.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

  UpdateSkin;
end;

procedure TSharpETaskItem.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if (not FDestroying) then  
    UpdateSkin;
end;

procedure TSharpETaskItem.OnHighlightTimer(Sender: TObject);
var
  ItemChanged : boolean;

  procedure ApplyHighlight(item : ISharpESkinHighlightItem);
  begin
    with item do
    begin
      if Apply then
      begin
        ItemChanged := True;
        Value := Value + Change;
        if Value >= Max then
        begin
          Value := Max;
          Change := -1 * Change;
        end else if Value <= Min then
        begin
          Value := Min;
          Change := -1 * Change;
        end;
      end;
    end;
  end;

begin
  ItemChanged := False;
  with FHighlightSettings do
  begin
    ApplyHighlight(Lighten);
    ApplyHighlight(LightenIcon);
    ApplyHighlight(Blend);
    ApplyHighlight(BlendIcon);
    ApplyHighlight(Alpha);
    ApplyHighlight(AlphaIcon);
    if ItemChanged then
    begin
      UpdateSkin();
    end;
  end;
end;

procedure TSharpETaskItem.SMouseEnter;
var
  CurrentState : ISharpETaskItemStateSkin;
begin
  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  CurrentState := GetCurrentStateItem;
  if CurrentState <> nil then
  begin
    if FFlashing then
    begin
      UpdateSkin;
    end 
    else UpdateSkin;
  end else UpdateSkin;
end;

procedure TSharpETaskItem.SMouseLeave;
var
  CurrentState : ISharpETaskItemStateSkin;
begin
  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  CurrentState := GetCurrentStateItem;
  if CurrentState <> nil then
  begin
    UpdateSkin;
  end else UpdateSkin;
end;

function FixCaption(bmp : TBitmap32; Caption : WideString; MaxWidth : integer) : WideString;
var
  n : integer;
  count : integer;
  s : WideString;
begin
  if bmp.TextWidthW(Caption) <= MaxWidth then result := Caption
  else
  begin
    count := length(Caption);
    s := '';
    n := 0;
    repeat
      n := n + 1;
      s := s + Caption[n];
    until (bmp.TextWidthW(s) > MaxWidth) or (n >= count);
    if length(s)>=4 then
    begin
      setlength(s,length(s)-4);
      s := s + '...';
    end else s := '';
    result := s;
  end;
end;

procedure TSharpETaskItem.DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r: TRect;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
  temp : TBitmap32;
  drawcaption : WideString;
begin
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
    if (FButtonDown or FDown) then
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('WorkAreaLight')), 200));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('WorkAreaDark')), 200));
    end
    else if (FButtonOver) then
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('ThrobberDark')), 200));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('ThrobberLight')), 200));
    end
    else
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('WorkAreaDark')), 200));
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
      Temp := TBitmap32.Create;
      Temp.DrawMode := dmBlend;
      Temp.CombineMode := cmMerge;
      Temp.SetSize(16,16);
      Temp.Clear(color32(0,0,0,0));
      TLinearResampler.Create(FGlyph32);
      FGlyph32.DrawTo(Temp,Rect(0,0,16,16));
      drawcaption := FixCaption(Bmp,Caption,96);
      TextSize.X := bmp.TextWidthW(drawcaption);
      TextSize.Y := bmp.TextHeightW(drawcaption);
      TextPos.X := Width div 2 - TextSize.X div 2;
      TextPos.Y := Height div  2 - TextSize.Y div 2;
      GlyphPos.X := TextPos.X - (Temp.Width + 2) div 2;
      GlyphPos.Y := TextPos.Y - Temp.Height div 2 + TextSize.Y div 2;
      TextPos.X := TextPos.X + (Temp.Width + 2) div 2;
      Temp.DrawTo(bmp,GlyphPos.X,GlyphPos.Y);
      bmp.RenderTextW(TextPos.X,TextPos.Y,drawcaption,0, Color32(bmp.Font.color));
      Temp.Free;
    end;
  end;
end;

procedure TSharpETaskItem.DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r, TextRect, CompRect, IconRect: TRect;
  TextSize : TPoint;
  i : integer;
  GlyphPos, TextPos: TPoint;
  mw : integer;
  DrawCaption : WideString;
  CurrentState : ISharpETaskItemStateSkin;
  SkinText : ISharpESkinText;
  SkinIcon : ISharpESkinIcon;
  DrawPart : ISharpESkinPartEx;
  TempBmp : TBitmap32;
  CompColor : integer;
  CustomScheme : TSharpEScheme;
begin
  CompRect := Rect(0, 0, width, height);
  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
    exit;
  end;

  case FState of
    tisCompact : CurrentState := FManager.Skin.TaskItem.Compact;
    tisMini    : CurrentState := FManager.Skin.TaskItem.Mini;
    else CurrentState := FManager.Skin.TaskItem.Full;
  end;

  if (FAutoPosition) then
     if Top <> CurrentState.Location.Y then
        Top := CurrentState.Location.Y;

  if FManager.Skin.TaskItem.IsValid(FState) then
  begin
    if FAutoSize then
    begin
      r := FManager.Skin.TaskItem.GetAutoDim(FState,CompRect);
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

    // prepare custom scheme
    CustomScheme := TSharpEScheme.Create(True);
    CustomScheme.Assign(Scheme);

    i := CustomScheme.GetColorIndexByTag('$IconHighlight');
    if (i > -1) and (i <= High(CustomScheme.Colors)) then
      if CustomScheme.Colors[i].SchemeType = stDynamic then
          CustomScheme.Colors[i].Color := FGlyphColor;

    i := Scheme.GetColorIndexByTag('$IconHighlightComp');
    if (i > -1) and (i <= High(CustomScheme.Colors)) then
      if CustomScheme.Colors[i].SchemeType = stDynamic then
      begin
        CompColor := ComplementaryColor(FGlyphColor);
        CompColor := DominantColor(CompColor);
        CustomScheme.Colors[i].Color := CompColor;
      end;

    FSkin.Clear(Color32(0, 0, 0, 0));
    if (FFlashing) and (not CurrentState.Highlight.Empty) then
    begin
      if (FButtonOver and (not CurrentState.HighlightHover.Empty)) then
        DrawPart := CurrentState.HighlightHover
      else DrawPart := CurrentState.Highlight;
    end else
    if (FButtonDown or FDown) and (not CurrentState.Down.Empty) then
    begin
      if (FButtonOver) and (not FButtonDown) and (not CurrentState.DownHover.Empty) then
        DrawPart := CurrentState.DownHover
      else DrawPart := CurrentState.Down;
    end else
    begin
      if FButtonOver then
      begin
        if (FFlashing) then
        begin
          DrawPart := CurrentState.HighlightHover
        end else
        if FUseSpecial and CurrentState.HasSpecial then
        begin
          if FSpecial then
            DrawPart := CurrentState.NormalHover
          else DrawPart := CurrentState.SpecialHover;
        end else DrawPart := CurrentState.NormalHover
      end else
      begin
        if FUseSpecial and CurrentState.HasSpecial then
        begin
          if FSpecial then
            DrawPart := CurrentState.Normal
          else DrawPart := CurrentState.Special;
        end else DrawPart := CurrentState.Normal;
      end;
    end;

    SkinIcon := DrawPart.Icon;
    SkinText := DrawPart.CreateThemedSkinText;

    if (FGlyph32 <> nil) and (SkinIcon.DrawIcon) and (FGlyph32.Width>0) and (FGlyph32.Height>0) then
      IconRect := Rect(0,0,SkinIcon.Dimension.X,SkinIcon.Dimension.Y)
    else IconRect := Rect(0,0,0,0);

    SkinText.AssignFontTo(bmp.Font,CustomScheme);
    DrawPart.DrawTo(bmp, CustomScheme);

    if FFlashing then
    with FHighlightSettings do
    begin
      if Lighten.Apply then
        SharpGraphicsUtils.LightenBitmap(bmp, Lighten.Value);
      if Blend.Apply then
        SharpGraphicsUtils.BlendImageC(bmp, Blend.Color, Blend.Value);
      if Alpha.Apply then
      begin
        TempBmp := TBitmap32.Create;
        try
          TempBmp.Assign(bmp);
          bmp.clear(color32(0,0,0,0));
          TempBmp.MasterAlpha := Alpha.Value;
          TempBmp.DrawMode := dmBlend;
          TempBmp.CombineMode := cmMerge;
          TempBmp.DrawTo(bmp);
        finally
          TempBmp.Free;
        end;
      end;                 
    end;

    if (SkinText.DrawText) and (length(Caption) > 0) then
    begin
      mw := SkinText.GetDim(CompRect).x;
      DrawCaption := FixCaption(Bmp,Caption,mw);
    end else DrawCaption := '';
    TextRect := Rect(0, 0, bmp.TextWidthW(DrawCaption), bmp.TextHeightW(DrawCaption));
    TextPos := SkinText.GetXY(TextRect, CompRect, IconRect);

    if (FGlyph32 <> nil) and (SkinIcon.DrawIcon) and (FGlyph32.Width>0) and (FGlyph32.Height>0) then
    begin
      TextSize.X := bmp.TextWidthW(caption);
      TextSize.Y := bmp.TextHeightW(caption);

      GlyphPos := SkinIcon.GetXY(TextRect,CompRect);
      if FFlashing then
      begin
        with FHighlightSettings do
        begin
          TempBmp := TBitmap32.Create;
          try
            TempBmp.SetSize(bmp.width,bmp.height);
            TempBmp.DrawMode := dmBlend;
            TempBmp.CombineMode := cmMerge;
            TempBmp.Clear(color32(0,0,0,0));
            SkinIcon.DrawTo(TempBmp,FGlyph32,GlyphPos.X,GlyphPos.Y);
            if LightenIcon.Apply then
              SharpGraphicsUtils.LightenBitmap(TempBmp, LightenIcon.Value);
            if BlendIcon.Apply then
              SharpGraphicsUtils.BlendImageC(TempBmp, BlendIcon.Color, BlendIcon.Value);
            if AlphaIcon.Apply then
              TempBmp.MasterAlpha := AlphaIcon.Value; 
            TempBmp.DrawTo(bmp);
          finally
            TempBmp.Free;
          end;
        end;
      end else SkinIcon.DrawTo(bmp,FGlyph32,GlyphPos.X,GlyphPos.Y);
    end;

    if ((SkinText <> nil) and (SkinText.DrawText)) then
    begin
      if length(trim(Caption))>0 then
         SkinText.RenderToW(bmp,TextPos.X,TextPos.Y,DrawCaption,CustomScheme,
                           FPrecacheText,FPrecacheBmp,FPrecacheCaption);
    end;

    SkinText := nil;
    SkinIcon := nil;

    if (FOverlay <> nil) and (FOverlay.Width > 0) and (FOverlay.Height > 0) then
      FOverlay.DrawTo(bmp,FOverlayPos.X,FOverlayPos.Y);

    CustomScheme.SelfInterface := nil;
  end
  else
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
end;

procedure TSharpETaskItem.SetCaption(Value: WideString);
begin
  FCaption := Value;
  if FManager = nil then
    exit;

  UpdateSkin;
end;

procedure TSharpETaskItem.Resize;
begin
  inherited;
  if FManager = nil then
    exit;
    
  UpdateSkin;
end;

procedure TSharpETaskItem.SetAutoPosition(const Value: boolean);
begin
  if FAutoPosition <> Value then
  begin
    FAutoPosition := Value;
 //   if (FAutoPosition) and (Assigned(FManager)) then
 //      Top := FManager.Skin.TaskItemSkin.SkinDim.YAsInt;
  end;
end;

procedure TSharpETaskItem.SetLayout(const Value: TButtonLayout);
begin
  FLayout := Value;
  if not assigned(FManager) then exit;
  UpdateSkin;
end;

procedure TSharpETaskItem.SetDisabledAlpha(const Value: Integer);
begin
  if (Value >= 0) and (Value <= 255) then
    FDisabledAlpha := Value;

  UpdateSkin;
end;

procedure TSharpETaskItem.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  UpdateSkin;
end;

destructor TSharpETaskItem.Destroy;
begin
  inherited;
  FHighlightTimer.Enabled := False;
  FHighlightTimer.Free;
  FHighlightSettings.Free;
  FDestroying := True;
  if FPrecacheBmp <> nil then FreeAndNil(FPrecacheBmp);
  if FPrecacheText <> nil then FPrecacheText := nil;
  FGlyph32.Free;
  FOverlay.Free;
end;

procedure TSharpETaskItem.SetGlyph32FileName(const Value: TGlyph32FileName);
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

  if not assigned(FManager) then exit;  
  UpdateSkin;
end;

procedure TSharpETaskItem.SetGlyph32(const Value: TBitmap32);
begin
  if (Value <> nil) and (FGlyph32FileName = '') then
    FGlyph32FileName := 'bitmap32data';
  if (Value = nil) then
    FGlyph32FileName := '';
  FGlyph32.Assign(Value);

  CalculateGlyphColor;

  if not Assigned(FManager) then exit;
  UpdateSkin;
end;

end.
