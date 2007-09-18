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
  SharpEAnimationTimers,
  SharpESkinPart,
  math,
  Types,
  Buttons;

type
  TGlyph32FileName = string;
  TSharpETaskItem = class(TCustomSharpEGraphicControl)
  private
    //FCancel: Boolean;
    FFlashing : boolean;
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
    procedure OnAnimFinished(Sender : TObject; SkinPart : TSkinPart);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Resize; override;
    destructor Destroy; override;
    function HasDownHoverScript : boolean;
    function HasNormalHoverScript : boolean;
    function HasHighlightAnimationScript : boolean;
//    function HasHighlightHoverScript : boolean;
    function GetCurrentStateItem : TSharpETaskItemState;
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
    if not SharpEAnimManager.HasScriptRunning(self) then UpdateSkin;
  end;
end;

function TSharpETaskItem.GetCurrentStateItem : TSharpETaskItemState;
begin
  if not assigned(FManager) then
  begin
    result := nil;
    exit;
  end;

  case FState of
    tisCompact : result := FManager.Skin.TaskItemSkin.Compact;
    tisMini    : result := FManager.Skin.TaskItemSkin.Mini;
    else result := FManager.Skin.TaskItemSkin.Full;
  end;
end;


procedure TSharpETaskItem.OnAnimFinished(Sender : TObject; SkinPart : TSkinPart);
var
  CurrentState : TSharpETaskItemState;
begin
  CurrentState := GetCurrentStateItem;
  //if not (CurrentState.Highlight = SkinPart) then exit;

  FFlashState := not FFlashState;
  if (FFlashState) then
  begin
    if FFlashing then
       SharpEAnimManager.ExecuteScript(self,
                                       CurrentState.OnHighlightStepStartScript,
                                       CurrentState.Normal,
                                       FManager.Scheme).OnTimerFinished := OnAnimFinished
  end else SharpEAnimManager.ExecuteScript(self,
                                           CurrentState.OnHighlightStepEndScript,
                                           CurrentState.Normal,
                                           FManager.Scheme).OnTimerFinished := OnAnimFinished;
end;

{function TSharpETaskItem.HasHighlightHoverScript : boolean;
var
  CurrentState : TSharpETaskItemState;
begin
  result := False;
  if not assigned(FManager) then exit;

  CurrentState := GetCurrentStateItem;

  if (length(Trim(CurrentState.OnHighlightMouseEnterScript)) > 0)
     and (length(Trim(CurrentState.OnHighlightMouseLeaveScript)) > 0) then result := True
     else result := False;
end;   }

function TSharpETaskItem.HasHighlightAnimationScript : boolean;
var
  CurrentState : TSharpETaskItemState;
begin
  result := False;
  if not assigned(FManager) then exit;

  CurrentState := GetCurrentStateItem;

  if (length(Trim(CurrentState.OnHighlightStepStartScript)) > 0)
     and (length(Trim(CurrentState.OnHighlightStepEndScript)) > 0) then result := True
     else result := False;
end;

function TSharpETaskItem.HasDownHoverScript : boolean;
var
  CurrentState : TSharpETaskItemState;
begin
  result := False;
  if not assigned(FManager) then exit;

  CurrentState := GetCurrentStateItem;

  if (length(Trim(CurrentState.OnDownMouseEnterScript)) > 0)
     and (length(Trim(CurrentState.OnDownMouseLeaveScript)) > 0) then result := True
     else result := False;
end;

function TSharpETaskItem.HasNormalHoverScript : boolean;
var
  CurrentState : TSharpETaskItemState;
begin
  result := False;
  if not assigned(FManager) then exit;

  CurrentState := GetCurrentStateItem;

  if (length(Trim(CurrentState.OnNormalMouseEnterScript)) > 0)
     and (length(Trim(CurrentState.OnNormalMouseLeaveScript)) > 0) then result := True
     else result := False;
end;

procedure TSharpETaskItem.SetFlashing(Value : Boolean);
var
  CurrentState : TSharpETaskItemState;
begin
  if Value <> FFlashing then
  begin
    FFlashing := Value;
    if (HasHighlightAnimationScript) then
    begin
      CurrentState := GetCurrentStateItem;
      FFlashState := FFlashing;
      if (FFlashing) then
         SharpEAnimManager.ExecuteScript(self,
                                         CurrentState.OnHighlightStepStartScript,
                                         CurrentState.Normal,
                                         FManager.Scheme).OnTimerFinished := OnAnimFinished;
    end else UpdateSkin;
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

  if not SharpEAnimManager.HasScriptRunning(self) then UpdateSkin;
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
var
  CurrentState : TSharpETaskItemState;
begin
  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  CurrentState := GetCurrentStateItem;
  if CurrentState <> nil then
  begin
    if ((FButtonDown) or (FDown)) and (HasDownHoverScript) and (not FFLashing) then
       SharpEAnimManager.ExecuteScript(self,
                                       CurrentState.OnDownMouseEnterScript,
                                       CurrentState.Down,
                                       FManager.Scheme).OnTimerFinished := nil
{    else if (FFlashing and HasHighlightHoverScript) then
            SharpEAnimManager.ExecuteScript(self,
                                            CurrentState.OnHighlightMouseEnterScript,
                                            CurrentState.Normal,
                                            FManager.Scheme).OnTimerFinished := nil   }
    else if (not FFlashing) and (HasNormalHoverScript) and (not (FButtonDown or FDown))  then
            SharpEAnimManager.ExecuteScript(self,
                                            CurrentState.OnNormalMouseEnterScript,
                                            CurrentState.Normal,
                                            FManager.Scheme).OnTimerFinished := nil
    else if FFlashing then
    begin
      SharpEAnimManager.StopScript(self);
      UpdateSkin;
    end 
    else UpdateSkin;
  end else UpdateSkin;
end;

procedure TSharpETaskItem.SMouseLeave;
var
  CurrentState : TSharpETaskItemState;
begin
  if not assigned(FManager) then
  begin
    UpdateSkin;
    exit;
  end;

  CurrentState := GetCurrentStateItem;
  if CurrentState <> nil then
  begin
    if ((FButtonDown) or (FDown)) and (HasDownHoverScript) and (not FFLashing) then
       SharpEAnimManager.ExecuteScript(self,
                                       CurrentState.OnDownMouseLeaveScript,
                                       CurrentState.Down,
                                       FManager.Scheme).OnTimerFinished := nil
   { else if (FFlashing and HasHighlightHoverScript) then
    begin
      FFlashState := False;
      SharpEAnimManager.ExecuteScript(self,
                                      CurrentState.OnHighlightMouseLeaveScript,
                                      CurrentState.Normal,
                                      FManager.Scheme).OnTimerFinished := OnAnimFinished
    end                                                                     }
    else if (FFlashing and HasHighlightAnimationScript) and (not (FButtonDown or FDown))then
    begin
      FFlashState := False;
      SharpEAnimManager.ExecuteScript(self,
                                      CurrentState.OnHighlightStepEndScript,
                                      CurrentState.Normal,
                                      FManager.Scheme).OnTimerFinished := OnAnimFinished
    end
    else if (HasNormalHoverScript) and (not (FButtonDown or FDown)) then
            SharpEAnimManager.ExecuteScript(self,
                                            CurrentState.OnNormalMouseLeaveScript,
                                            CurrentState.Normal,
                                            FManager.Scheme).OnTimerFinished := nil
    else UpdateSkin;
  end else UpdateSkin;
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
  temp : TBitmap32;
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
      TextSize.X := bmp.TextWidth(caption);
      TextSize.Y := bmp.TextHeight(caption);
      TextPos.X := Width div 2 - TextSize.X div 2;
      TextPos.Y := Height div  2 - TextSize.Y div 2;
      GlyphPos.X := TextPos.X - (Temp.Width + Margin) div 2;
      GlyphPos.Y := TextPos.Y - Temp.Height div 2 + TextSize.Y div 2;
      TextPos.X := TextPos.X + (Temp.Width + Margin) div 2;
      Temp.DrawTo(bmp,GlyphPos.X,GlyphPos.Y);
      bmp.RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp.Font.color));
      Temp.Free;
    end;
  end;
end;


procedure DrawSkinPart(state : TSkinPart; bmp : TBitmap32; scheme : TSharpEScheme;
                       var mw : integer; var TextPos : TPoint; var TextRect : TRect;
                       var CompRect : TRect; Caption : String; var DrawCaption : String;
                       var SkinText : TSkinText);
begin
  state.Draw(bmp, Scheme);
  SkinText := CreateThemedSkinText(state.SkinText);
  SkinText.AssignFontTo(bmp.Font,Scheme);
  mw := SkinText.GetMaxWidth(CompRect);
  DrawCaption := FixCaption(Bmp,Caption,mw);
  TextRect := Rect(0, 0, bmp.TextWidth(DrawCaption), bmp.TextHeight(DrawCaption));
  TextPos := SkinText.GetXY(TextRect, CompRect);
end;


procedure TSharpETaskItem.DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  r, TextRect, CompRect: TRect;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
  mw : integer;
  DrawCaption : String;
  CurrentState : TSharpeTaskItemState;
  SkinText : TSkinText;
begin
  CompRect := Rect(0, 0, width, height);

  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
    exit;
  end;

  if (SharpEAnimManager.HasScriptRunning(self)) and (not SharpEAnimManager.TimerActive) then exit;

  case FState of
    tisCompact : CurrentState := FManager.Skin.TaskItemSkin.Compact;
    tisMini    : CurrentState := FManager.Skin.TaskItemSkin.Mini;
    else CurrentState := FManager.Skin.TaskItemSkin.Full;
  end;

  if (FAutoPosition) then
     if Top <> CurrentState.SkinDim.YAsInt then
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

    SkinText := nil;
    FSkin.Clear(Color32(0, 0, 0, 0));
    if (FButtonDown or FDown) and (not CurrentState.Down.Empty) then
    begin
      if (FButtonOver) and (not FButtonDown) and (not CurrentState.DownHover.Empty) and (not SharpEAnimManager.HasScriptRunning(self)) then
         DrawSkinPart(CurrentState.DownHover,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText)
         else DrawSkinPart(CurrentState.Down,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText);
    end else
    if (FFlashing) and (not CurrentState.Highlight.Empty) and (not SharpEAnimManager.HasScriptRunning(self))
       and (not HasHighlightAnimationScript) then
    begin
      if (FButtonOver and (not CurrentState.HighlightHover.Empty)) then
         DrawSkinPart(CurrentState.HighlightHover,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText)
         else DrawSkinPart(CurrentState.Highlight,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText);
    end else
    begin
      if FButtonOver then
      begin
        if (FFlashing) then
        begin
          if (not SharpEAnimManager.HasScriptRunning(self)) then
           DrawSkinPart(CurrentState.HighlightHover,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText)
           else DrawSkinPart(CurrentState.Normal,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText);
        end else
        if (not HasNormalHoverScript) then DrawSkinPart(CurrentState.NormalHover,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText)
           else DrawSkinPart(CurrentState.Normal,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText);
      end else DrawSkinPart(CurrentState.Normal,bmp,Scheme,mw,TextPos,TextRect,CompRect,Caption,DrawCaption,SkinText);
    end;

    if (FGlyph32 <> nil) and (CurrentState.DrawIcon) then
    begin
      if CurrentState.IconSize < 0 then CurrentState.IconSize := 16;
      TLinearResampler.Create(FGlyph32);
      FGlyph32.DrawMode := dmBlend;
      FGlyph32.CombineMode := cmMerge;
      TextSize.X := bmp.TextWidth(DrawCaption);
      TextSize.Y := bmp.TextHeight(DrawCaption);
      //if not Enabled then DrawGlyph.MasterAlpha := FDisabledAlpha;
      GlyphPos := CurrentState.IconLocation.GetXY(TextRect,CompRect);
      FGlyph32.DrawTo(bmp,Rect(GlyphPos.X,GlyphPos.Y,GlyphPos.X + CurrentState.IconSize, GlyphPos.Y + CurrentState.IconSize));
    end;
    if (CurrentState.DrawText) and (SkinText <> nil) then
    begin
      if length(trim(Caption))>0 then
         SkinText.RenderTo(bmp,TextPos.X,TextPos.Y,DrawCaption,Scheme,
                           FPrecacheText,FPrecacheBmp,FPrecacheCaption);
      SkinText.Free;                           
    end;
  end
  else
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
end;

procedure TSharpETaskItem.SetCaption(Value: string);
begin
  FCaption := Value;
  if not SharpEAnimManager.HasScriptRunning(self) then UpdateSkin;
end;

procedure TSharpETaskItem.Resize;
begin
  inherited;
  if not SharpEAnimManager.HasScriptRunning(self) then UpdateSkin;
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
  if not SharpEAnimManager.HasScriptRunning(self) then UpdateSkin;
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
  if FPrecacheBmp <> nil then FreeAndNil(FPrecacheBmp);
  if FPrecacheText <> nil then FreeAndNil(FPrecacheText);
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

  if not SharpEAnimManager.HasScriptRunning(self) then UpdateSkin;
end;

procedure TSharpETaskItem.SetGlyph32(const Value: TBitmap32);
begin
  if (Value <> nil) and (FGlyph32FileName = '') then
    FGlyph32FileName := 'bitmap32data';
  if (Value = nil) then
    FGlyph32FileName := '';
  FGlyph32.Assign(Value);

  if not SharpEAnimManager.HasScriptRunning(self) then UpdateSkin;
end;


end.
