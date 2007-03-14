{
Source Name: SharpEPanel
Description: SharpE component for SharpE
Copyright (C) Pixol (pixol@sharpe-shell.org)

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

unit SharpEPanel;

interface

uses ExtCtrls,
  SharpEBaseControls,
  messages,
  Classes,
  forms,
  Buttons,
  Types,
  Windows,
  graphics,
  Controls,
  SharpEDefault,
  SHarpESkinPart,
  SharpEScheme,
  SysUtils,
  Gr32;

type
  TParentControl = class(TWinControl);
  TPanelSkinState = (pssRaised, pssLowered, pssNormal);
  TGlyph32FileName = string;
type
  TSharpEPanel = class(TCustomSharpEControl)
  private
    FState: TPanelSkinState;
    FSelected: Boolean;
    FGlyph32FileName: TGlyph32FileName;
    FGlyph32: TBitmap32;
    FLayout: TButtonLayout;
    FMargin: Integer;
    FHSpacing: Integer;
    FVSpacing: Integer;
    FDisabledAlpha: Integer;
    FCaption: string;
    procedure DrawDefaultSkin;
    procedure DrawManagedSkin(Scheme: TSharpEScheme);
    procedure SetState(const Value: TPanelSkinState);
    procedure SetSelected(const Value: Boolean);
    procedure SetGlyph32FileName(const Value: TGlyph32FileName);
    procedure Setglyph32(const Value: TBitmap32);
    procedure SetLayout(const Value: TButtonLayout);
    procedure SetMargin(const Value: Integer);
    procedure SetHSpacing(const Value: Integer);
    procedure SetVSpacing(const Value: Integer);
    procedure SetDisabledAlpha(const Value: Integer);
    procedure Bitmap32ChangeEvent(Sender: TObject);
    procedure SetCaption(Value: string);
    procedure CopyParentImage(Control: TControl; Dest: TCanvas);
  protected
    procedure Loaded; override;
    procedure Paint; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure Resize; override;

  public
    property DockManager;

    procedure UpdateSkin; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published

    property Align;
    property Enabled;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Constraints;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property PopupMenu;
    property ShowHint;

    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    property SkinManager;

    property State: TPanelSkinState read FState write SetState;
    property Selected: Boolean read FSelected write SetSelected;
    property Glyph32FileName: TGlyph32FileName read FGlyph32FileName write
      SetGlyph32FileName;
    property Glyph32: Tbitmap32 read FGlyph32 write SetGlyph32 stored True;
    property Layout: TButtonLayout read FLayout write SetLayout;
    property Margin: Integer read FMargin write SetMargin;
    property HSpacing: Integer read FHSpacing write SetHSpacing;
    property VSpacing: Integer read FVSpacing write SetVSpacing;
    property DisabledAlpha: Integer read FDisabledAlpha write SetDisabledAlpha;
    property Caption: string read FCaption write SetCaption;
  end;

implementation

uses
  GR32_Png;

procedure TSharpEPanel.CopyParentImage(Control: TControl; Dest: TCanvas);
var
  I, Count, X, Y, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
begin
  if (Control = nil) or (Control.Parent = nil) then Exit;
  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
{$IFDEF WIN32}
  with Control.Parent do ControlState := ControlState + [csPaintCopy];
  try
{$ENDIF}
    with Control do begin
      SelfR := Bounds(Left, Top, Width, Height);
      X := -Left; Y := -Top;
    end;
    { Copy parent control image }
    SaveIndex := SaveDC(DC);
    try
      SetViewportOrgEx(DC, X, Y, nil);
      IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth,
        Control.Parent.ClientHeight);
      with TParentControl(Control.Parent) do begin
        Perform(WM_ERASEBKGND, DC, 0);
        PaintWindow(DC);
      end;
    finally
      RestoreDC(DC, SaveIndex);
    end;
    { Copy images of graphic controls }
    for I := 0 to Count - 1 do begin
      if Control.Parent.Controls[I] = Control then Break
      else if (Control.Parent.Controls[I] <> nil) and
        (Control.Parent.Controls[I] is TGraphicControl) then
      begin
        with TGraphicControl(Control.Parent.Controls[I]) do begin
          CtlR := Bounds(Left, Top, Width, Height);
          if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then begin
{$IFDEF WIN32}
            ControlState := ControlState + [csPaintCopy];
{$ENDIF}
            SaveIndex := SaveDC(DC);
            try
              SaveIndex := SaveDC(DC);
              SetViewportOrgEx(DC, Left + X, Top + Y, nil);
              IntersectClipRect(DC, 0, 0, Width, Height);
              Perform(WM_PAINT, DC, 0);
            finally
              RestoreDC(DC, SaveIndex);
{$IFDEF WIN32}
              ControlState := ControlState - [csPaintCopy];
{$ENDIF}
            end;
          end;
        end;
      end;
    end;
{$IFDEF WIN32}
  finally
    with Control.Parent do ControlState := ControlState - [csPaintCopy];
  end;
{$ENDIF}
end;

procedure TSharpEPanel.SetCaption(Value: string);
begin
  FCaption := Value;

  UpdateSkin;
end;

procedure TSharpEPanel.Resize;
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEPanel.SetEnabled(Value: Boolean);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEPanel.SetLayout(const Value: TButtonLayout);
begin
  FLayout := Value;
  UpdateSkin;
end;

procedure TSharpEPanel.SetDisabledAlpha(const Value: Integer);
begin
  if (Value >= 0) and (Value <= 255) then
    FDisabledAlpha := Value;

  UpdateSkin;
end;

procedure TSharpEPanel.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  UpdateSkin;
end;

procedure TSharpEPanel.SetHSpacing(const Value: Integer);
begin
  FHSpacing := Value;
  UpdateSkin;
end;

procedure TSharpEPanel.SetVSpacing(const Value: Integer);
begin
  FVSpacing := Value;
  UpdateSkin;
end;

procedure TSharpEPanel.DrawDefaultSkin;
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  tmpColor: TColor32;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
  bmp32 : TBitmap32;
begin
  bmp32 := TBitmap32.Create;

  try
    bmp32.SetSize(Self.Width, Self.Height);

    if Assigned(FManager) then
    begin
      TopColor := DefaultSharpEScheme.GetColorByName('WorkAreaLight');
      BottomColor := DefaultSharpEScheme.GetColorByName('WorkAreaDark');
      Color := DefaultSharpEScheme.GetColorByName('WorkAreaBack');
      FManager.Skin.SkinText.AssignFontTo(Font,FManager.Scheme);
    end
    else
    begin
      TopColor := DefaultSharpEScheme.GetColorByName('WorkAreaLight');
      BottomColor := DefaultSharpEScheme.GetColorByName('WorkAreaDark');
      Color := DefaultSharpEScheme.GetColorByName('WorkAreaBack');
      DefaultSharpESkinText.AssignFontTo(Font,DefaultSharpEScheme);
    end;

    tmpColor := Color;
    if FSelected then
    begin
      tmpColor := BottomColor;
    end;

    bmp32.Clear(color32(tmpColor));
    bmp32.PenColor := Color32(BottomColor);
    Rect := GetClientRect;
    case State of
      pssLowered: Frame3D(bmp32.Canvas, Rect, BottomColor, TopColor,
        BevelWidth);
      pssRaised: Frame3D(bmp32.Canvas, Rect, TopColor, BottomColor, BevelWidth);
      pssNormal: bmp32.FrameRectS(Rect, Color32(tmpColor));
    end;

    if FGlyph32 <> nil then
    begin
      TextSize.X := bmp32.TextWidth(caption);
      TextSize.Y := bmp32.TextHeight(caption);
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
      FGlyph32.DrawTo(bmp32,GlyphPos.X,GlyphPos.Y);
      FGlyph32.MasterAlpha := 255;
      bmp32.RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp32.Font.color));
    end;
  finally
    bmp32.DrawTo(Canvas.Handle, bmp32.BoundsRect, bmp32.BoundsRect);
    bmp32.Free;

  end;
end;

procedure TSharpEPanel.DrawManagedSkin(Scheme: TSharpEScheme);
var r, CompRect: TRect;
  p: TPoint;
  skindim: TSkinDim;
  temp: TBitmap32;
  bmp32 : TBitmap32;
  TextSize : TPoint;
  GlyphPos, TextPos: TPoint;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
  VerticalAlignments: array[TVerticalAlignment] of Longint = (DT_TOP, DT_BOTTOM,
    DT_VCENTER);

begin
  bmp32 := TBitmap32.Create;

  // Set Bitmap Size
  bmp32.SetSize(Self.Width, Self.Height);
  bmp32.Clear(Color32(0,0,0,0));
  CopyParentImage(self,bmp32.Canvas);
  bmp32.ResetAlpha(255);

  skindim := TSkinDim.create;
  temp := TBitmap32.create;

  try
    CompRect := Rect(0, 0, width, height);
    if FManager.Skin.PanelSkin.Valid then
    begin
      if AutoSize then
      begin
        r := FManager.Skin.PanelSkin.GetAutoDim(CompRect);
        if (r.Right <> width) or (r.Bottom <> height) then
        begin
          width := r.Right;
          height := r.Bottom;
          Exit;
        end;
      end;

    // Draw Bitmap
      p := Point(0, 0);
      //bmp32.Clear(Color32(0, 0, 0, 0));
      if Selected then
      begin
        if not (FManager.Skin.PanelSkin.Normal.Empty) then
        begin
          FManager.Skin.PanelSkin.Selected.Draw(bmp32, Scheme);
          FManager.Skin.PanelSkin.Selected.SkinText.AssignFontTo(bmp32.Font,Scheme);
        end;
      end
      else
      begin
        case State of
          pssRaised:
            if not (FManager.Skin.PanelSkin.Raised.Empty) then
            begin
              FManager.Skin.PanelSkin.Raised.Draw(bmp32, Scheme);
              FManager.Skin.PanelSkin.Raised.SkinText.AssignFontTo(bmp32.Font,Scheme);
            end;
          pssLowered:
            if not (FManager.Skin.PanelSkin.Lowered.Empty) then
            begin
              FManager.Skin.PanelSkin.Lowered.Draw(bmp32, Scheme);
              FManager.Skin.PanelSkin.Lowered.SkinText.AssignFontTo(bmp32.Font,Scheme);
            end;
          pssNormal:
            if not (FManager.Skin.PanelSkin.Normal.Empty) then
            begin
              FManager.Skin.PanelSkin.Normal.Draw(bmp32, Scheme);
              FManager.Skin.PanelSkin.Normal.SkinText.AssignFontTo(bmp32.Font,Scheme);
            end;
        end;
      end;

      if FGlyph32 <> nil then
      begin
        TextSize.X := bmp32.TextWidth(caption);
        TextSize.Y := bmp32.TextHeight(caption);
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
        FGlyph32.DrawTo(bmp32,GlyphPos.X,GlyphPos.Y);
        FGlyph32.MasterAlpha := 255;
        bmp32.RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp32.Font.color));
      end;

      bmp32.DrawTo(Canvas.Handle, bmp32.BoundsRect, bmp32.BoundsRect);
    end
    else
      DrawDefaultSkin;
  finally
    skindim.free;
    temp.free;
    bmp32.Free;
  end;
end;

procedure TSharpEPanel.Paint;
begin
  try
    if Assigned(FManager) then
      DrawManagedSkin(FManager.Scheme)
    else
      DrawDefaultSkin;
  except
  end;

end;

procedure TSharpEPanel.UpdateSkin;
begin
  paint;

  // Force Invalidate
  Perform(CM_INVALIDATE, 0, 0);
end;

procedure TSharpEPanel.Loaded;
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEPanel.SetState(const Value: TPanelSkinState);
begin
  FState := Value;
  UpdateSkin;
end;

procedure TSharpEPanel.SetSelected(const Value: Boolean);
begin
  FSelected := Value;
  UpdateSkin;
end;

procedure TSharpEPanel.Bitmap32ChangeEvent(Sender: TObject);
begin
  UpdateSkin;
end;

constructor TSharpEPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  if not (csDesigning in ComponentState) then
    ControlStyle := ControlStyle + [csParentBackground];

  Self.DoubleBuffered := True;
  FGlyph32 := TBitmap32.Create;
  FGlyph32.OnChange := Bitmap32ChangeEvent;

  FHSpacing := 4;
  FVSpacing := 0;
  FMargin := -1;
  FDisabledAlpha := 100;
  Flayout := blGlyphleft;
end;

destructor TSharpEPanel.Destroy;
begin
  inherited;
  FGlyph32.Free;
end;

procedure TSharpEPanel.SetGlyph32FileName(const Value: TGlyph32FileName);
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

procedure TSharpEPanel.SetGlyph32(const Value: TBitmap32);
begin
  if (Value <> nil) and (FGlyph32FileName = '') then
    FGlyph32FileName := 'bitmap32data';
  if (Value = nil) then
    FGlyph32FileName := '';
  FGlyph32.Assign(Value);
end;


end.
