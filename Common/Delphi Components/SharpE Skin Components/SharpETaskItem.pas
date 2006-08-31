{
Source Name: SharpETaskItem
Description: TaskItem component for SharpE
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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
unit SharpETaskItem;

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
  SharpESkin,
  SharpESkinManager,
  math,
  Types,
  Buttons;

type
  TGlyph32FileName = string;
  TSharpETaskItem = class(TCustomSharpEGraphicControl)
  private
    //FCancel: Boolean;
    FFlashing : boolean;
    FFlashTime : int64;
    FFlashState : boolean;
    FState : TSharpETaskItemStates;
    FGlyph32FileName: TGlyph32FileName;
    FGlyph32: TBitmap32;
    FLayout: TButtonLayout;
    FMargin: Integer;
    FDisabledAlpha: Integer;
    FCaption: string;
    FModalResult: TModalResult;
    FDefault: Boolean;
    FAutoPosition: Boolean;
    FDown: Boolean;
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
    procedure SetDown(Value: Boolean);
    procedure SetState(Value: TSharpETaskItemStates);
    procedure SetFlashing(Value : Boolean);
    procedure SetFlashState(Value : Boolean);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Resize; override;
    destructor Destroy; override;
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
    property Down: Boolean read FDown write SetDown;
    property State: TSharpETaskItemStates read FState write SetState;
    property Flashing: Boolean read FFlashing write SetFlashing;
    property FlashState: Boolean read FFlashState write SetFlashState;
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

  FGlyph32 := TBitmap32.Create;

  FMargin := -1;
  FDisabledAlpha := 100;
  Flayout := blGlyphleft;
  FButtonDown := False;
  FFlashing := False;
end;

procedure TSharpETaskItem.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

procedure TSharpETaskItem. SetFlashState(Value : Boolean);
begin
  if Value <> FFlashState then
  begin
    FFlashState := Value;
    UpdateSkin;
  end;
end;

procedure TSharpETaskItem.SetFlashing(Value : Boolean);
begin
  if Value <> FFlashing then
  begin
    FFlashing := Value;
    UpdateSkin;
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
  if Value <> FDown then
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

  UpdateSkin;
end;

procedure TSharpETaskItem.CMDialogKey(var Message: TCMDialogKey);
begin
  inherited;
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
  UpdateSkin;
end;

procedure TSharpETaskItem.SMouseEnter;
begin
  UpdateSkin;
end;

procedure TSharpETaskItem.SMouseLeave;
begin
  UpdateSkin;
end;

function FixCaption(bmp : TBitmap32; Caption : String; MaxWidth : integer) : String;
var
  n : integer;
  count : integer;
  s : String;
begin
  if bmp.TextWidth(Caption) <= MaxWidth then result := Caption
  else
  begin
    count := length(Caption);
    s := '';
    n := 0;
    repeat
      n := n + 1;
      s := s + Caption[n];
    until (bmp.TextWidth(s) > MaxWidth) or (n >= count);
    if length(s)>=4 then
    begin
      setlength(s,length(s)-4);
      s := s + '...';
    end else s := '';
    result := s;
  end;
end;

procedure TSharpETaskItem.DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
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

procedure TSharpETaskItem.DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  r, TextRect, CompRect: TRect;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
  mw : integer;
  DrawCaption : String;
  DrawGlyph : TBitmap32;
  CurrentState : TSharpeTaskItemState;
begin
  CompRect := Rect(0, 0, width, height);

  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, Scheme);
    exit;
  end;

  case FState of
    tisCompact : CurrentState := FManager.Skin.TaskItemSkin.Compact;
    tisMini    : CurrentState := FManager.Skin.TaskItemSkin.Mini;
    else CurrentState := FManager.Skin.TaskItemSkin.Full;
  end;

  if (FAutoPosition) then
     Top := CurrentState.SkinDim.YAsInt;

  if FManager.Skin.TaskItemSkin.Valid(FState) then
  begin
    if FAutoSize then
    begin
      r := FManager.Skin.TaskItemSkin.GetAutoDim(FState,CompRect);
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
    if ((FButtonDown) or (FDown)) and not (CurrentState.Down.Empty) then
    begin
      if ((FButtonOver) and not (FButtonDown) and not(CurrentState.DownHover.Empty)) then
      begin
        CurrentState.DownHover.Draw(bmp, Scheme);
        CurrentState.DownHover.SkinText.AssignFontTo(bmp.Font,Scheme);
        mw := CurrentState.DownHover.SkinText.GetMaxWidth(CompRect);
        DrawCaption := FixCaption(Bmp,Caption,mw);
        TextRect := Rect(0, 0, bmp.TextWidth(DrawCaption), bmp.TextHeight(DrawCaption));
        TextPos := CurrentState.DownHover.SkinText.GetXY(TextRect, CompRect);
      end else
      begin
        CurrentState.Down.Draw(bmp, Scheme);
        CurrentState.Down.SkinText.AssignFontTo(bmp.Font,Scheme);
        mw := CurrentState.Down.SkinText.GetMaxWidth(CompRect);
        DrawCaption := FixCaption(Bmp,Caption,mw);
        TextRect := Rect(0, 0, bmp.TextWidth(DrawCaption), bmp.TextHeight(DrawCaption));
        TextPos := CurrentState.Down.SkinText.GetXY(TextRect, CompRect);
      end;
    end
    else
    if (FFlashing) and not (CurrentState.Highlight.Empty) then
    begin
      if ((FButtonOver) and not (CurrentState.Highlight.Empty)) then
      begin
        CurrentState.HighlightHover.Draw(bmp, Scheme);
        CurrentState.HighlightHover.SkinText.AssignFontTo(bmp.Font,Scheme);
        mw := CurrentState.HighlightHover.SkinText.GetMaxWidth(CompRect);
        DrawCaption := FixCaption(Bmp,Caption,mw);
        TextRect := Rect(0, 0, bmp.TextWidth(DrawCaption), bmp.TextHeight(DrawCaption));
        TextPos := CurrentState.HighlightHover.SkinText.GetXY(TextRect, CompRect);
      end else
      begin
        CurrentState.Highlight.Draw(bmp, Scheme);
        CurrentState.Highlight.SkinText.AssignFontTo(bmp.Font,Scheme);
        mw := CurrentState.Highlight.SkinText.GetMaxWidth(CompRect);
        DrawCaption := FixCaption(Bmp,Caption,mw);
        TextRect := Rect(0, 0, bmp.TextWidth(DrawCaption), bmp.TextHeight(DrawCaption));
        TextPos := CurrentState.Highlight.SkinText.GetXY(TextRect, CompRect);
      end;
    end
    else
    begin
      if ((FButtonOver) and not (CurrentState.NormalHover.Empty)) then
      begin
        CurrentState.NormalHover.Draw(bmp, Scheme);
        CurrentState.NormalHover.SkinText.AssignFontTo(bmp.Font,Scheme);
        mw := CurrentState.NormalHover.SkinText.GetMaxWidth(CompRect);
        DrawCaption := FixCaption(Bmp,Caption,mw);
        TextRect := Rect(0, 0, bmp.TextWidth(DrawCaption), bmp.TextHeight(DrawCaption));
        TextPos := CurrentState.NormalHover.SkinText.GetXY(TextRect, CompRect);
      end else
      begin
        CurrentState.Normal.Draw(bmp, Scheme);
        CurrentState.Normal.SkinText.AssignFontTo(bmp.Font,Scheme);
        mw := CurrentState.Normal.SkinText.GetMaxWidth(CompRect);
        DrawCaption := FixCaption(Bmp,Caption,mw);
        TextRect := Rect(0, 0, bmp.TextWidth(DrawCaption), bmp.TextHeight(DrawCaption));
        TextPos := CurrentState.Normal.SkinText.GetXY(TextRect, CompRect);
      end;
    end;

    if (FGlyph32 <> nil) and (CurrentState.DrawIcon) then
    begin
      if CurrentState.IconSize < 0 then CurrentState.IconSize := 16;
      TLinearResampler.Create(FGlyph32);
      FGlyph32.DrawMode := dmBlend;
      FGlyph32.CombineMode := cmMerge;
      TextSize.X := bmp.TextWidth(DrawCaption);
      TextSize.Y := bmp.TextHeight(DrawCaption);
      if not Enabled then DrawGlyph.MasterAlpha := FDisabledAlpha;
      GlyphPos := CurrentState.IconLocation.GetXY(TextRect,CompRect);
      FGlyph32.DrawTo(bmp,Rect(GlyphPos.X,GlyphPos.Y,GlyphPos.X + CurrentState.IconSize, GlyphPos.Y + CurrentState.IconSize));
    end;
    if CurrentState.DrawText then
    begin
      bmp.RenderText(TextPos.X,TextPos.Y,DrawCaption,0, Color32(bmp.Font.color));
    end;
  end
  else
    DrawDefaultSkin(bmp, Scheme);
end;

procedure TSharpETaskItem.SetCaption(Value: string);
begin
  FCaption := Value;

  UpdateSkin;
end;

procedure TSharpETaskItem.Resize;
begin
  inherited;
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
  FGlyph32.Free;
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

  UpdateSkin;
end;

procedure TSharpETaskItem.SetGlyph32(const Value: TBitmap32);
begin
  if (Value <> nil) and (FGlyph32FileName = '') then
    FGlyph32FileName := 'bitmap32data';
  if (Value = nil) then
    FGlyph32FileName := '';
  FGlyph32.Assign(Value);

  UpdateSkin;
end;


end.
