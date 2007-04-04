unit SharpEColorPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpERoundPanel, uSharpETabList, uSharpEColorBox,
    pngimagelist, pngimage, ComCtrls, JvExComCtrls, JvComCtrls, StdCtrls,
      jvPageList, SharpGraphicsUtils, SharpCenterScheme, gr32, JvSpin,
        JvHtControls;

Type
  TSharpEColorPanel = Class(TCustomControl)
  private
     FTabs: TSharpETabList;
     FTabContainer: TSharpERoundPanel;
     FColorPicker: TSharpEColorBox;
     FPngImageList: TPngImageList;
     FPages: TJvPageList;
     FCaptionLabel: TPanel;
     FHueSlider, FSatSlider, FBriSlider: TJvTrackBar;
     FRedSlider, FGreSlider, FBluSlider: TJvTrackBar;
     FSCS: TSharpECenterScheme;
     FTimer: TTimer;


    FBackgroundColor: TColor;
    FExpanded: Boolean;
    FGroupIndex: Integer;
    FExpandedHeight: Integer;
    FCollapseHeight: Integer;
    FColorCode: Integer;
    FColorAsTColor: TColor;
    FCaption: String;
    procedure SetBackgroundColor(const Value: TColor);
    procedure CreateControls(Sender: TObject);
    procedure SetExpanded(const Value: Boolean);
    procedure SetGroupIndex(const Value: Integer);
    procedure SetCollapseHeight(const Value: Integer);
    procedure SetExpandedHeight(const Value: Integer);
    function GetExpanded: Boolean;
    procedure TabClickEvent(ASender: TObject; const ATabIndex:Integer);
    procedure ColorClickEvent(ASender: TObject);
    procedure SetColorCode(const Value: Integer);
    function GetColorCode: Integer;
    procedure SetColorAsTColor(const Value: TColor);

    procedure MakeSliderPretty(ASlider: TJvTrackBar);
    procedure PositionSlider(ASlider: TJvTrackBar; ACaption:String;
  ATextRect, ASliderRect:TRect; ARow:Integer; AParent:TWinControl;
        ALabelAnchors, ASliderAnchors: TAnchors);
    procedure LoadResources;
    procedure ResizeEvent(Sender:TObject);
    procedure ResizeDefineCol;
    procedure InitialiseSliders;
    procedure SetCaption(const Value: String);
    procedure SliderChangeEvent(Sender:TObject);
    procedure SliderMouseDownEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
    procedure LabelClickEvent(Sender:TObject);
    procedure FreeAllSpinEdits(Sender:TObject=nil);
    procedure SpinEditKeyPressEvent(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  public
    constructor Create(AOwner:TComponent); override;

    destructor Destroy; override;
    procedure DeselectTabs;
    procedure Collapse;
    
  protected
  published
    property Color;
    property Align;

    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    property Expanded: Boolean read GetExpanded write SetExpanded;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property CollapseHeight: Integer read FCollapseHeight write SetCollapseHeight;
    property ExpandedHeight: Integer read FExpandedHeight write SetExpandedHeight;
    property Caption: String read FCaption write SetCaption;

    property ColorCode: Integer read FColorCode write SetColorCode;
    property ColorAsTColor: TColor read FColorAsTColor write SetColorAsTColor;
end;

  procedure Register;

implementation

uses Types;

{$R SharpEColorPanelRes.res}


procedure Register;
begin
  RegisterComponents('SharpE', [TSharpEColorPanel]);
end;

{ TSharpEColorPanel }

constructor TSharpEColorPanel.Create(AOwner: TComponent);
begin
  
  FCollapseHeight := 24;
  FExpandedHeight := 135;

  FTimer := TTimer.Create(nil);
  with FTimer do begin
    Interval := 1;
    OnTimer := CreateControls;
    Enabled := True;
  end;
  
  inherited;
end;

procedure TSharpEColorPanel.CreateControls(Sender: TObject);
var
  tmpTab: TJvstandardPage;
begin
  // Disable Timer, as no longer needed
  FTimer.Enabled := false;
  FSCS := TSharpECenterScheme.Create(nil);

  // Load Png Resource Files
  LoadResources;

  FTabs := TSharpETabList.Create(Self);
  FTabs.PngImageList := FPngImageList;
  FTabs.Align := altop;
  Ftabs.parent := self;
  FTabs.TabAlign := taRightJustify;
  FTabs.Add('',0);
  FTabs.Add('',1);
  FTabs.BkgColor := Color;
  FTabs.BorderColor := Color;
  FTabs.OnTabClick := TabClickEvent;

  FTabs.TabSelectedColor := FSCS.EditTabSelCol;
  FTabs.TabColor := clWindow;
  FTabs.BorderColor := FSCS.EditTabBordCol;
  FTabs.BorderSelectedColor := FSCS.EditTabBordCol;
  FTabs.Border := True;
  FTabs.IconBounds := Rect(12,3,0,0);
  FTabs.TabWidth := 40;
  FTabs.SendToBack;
  FTabs.DoubleBuffered := True;

  FCaptionLabel := tPanel.Create(nil);
  FCaptionLabel.Parent := self;
  FCaptionLabel.Left := 0;
  FCaptionLabel.Top := 0;
  FCaptionLabel.Width := 100;
  FCaptionLabel.Height := ftabs.Height-2;
  FCaptionLabel.BevelInner := bvNone;
  FCaptionLabel.BevelOuter := bvNone;
  FCaptionLabel.Caption := FCaption;
  FCaptionLabel.Alignment := taLeftJustify;
  FCaptionLabel.VerticalAlignment := taVerticalCenter;
  FCaptionLabel.BringToFront;
  FCaptionLabel.DoubleBuffered := True;
  FCaptionLabel.Color := clWindow;

  FColorPicker := TSharpEColorBox.Create(nil);
  FColorPicker.Parent := Self;
  FColorPicker.Left := Self.Width-120;
  FColorPicker.Top := 7;
  FColorPicker.BackgroundColor := clWindow;
  FColorPicker.OnColorClick := ColorClickEvent;
  FColorPicker.ColorCode := FColorCode;
  FColorPicker.Anchors := [akRight,akTop];
  FColorPicker.DoubleBuffered := True;
  FColorAsTColor := TColor(FColorCode);


  FTabContainer := TSharpERoundPanel.Create(self);
  FTabContainer.Parent := Self;
  FTabContainer.Top := FTabs.Height-1;
  FTabContainer.Left := 0;
  FTabContainer.Height := Height-FTabs.Height+1;
  FTabContainer.Width := Width;
  FTabContainer.DrawMode := srpNoTopRight;
  FTabContainer.BorderColor := FSCS.EditBordCol;
  FTabContainer.Color := FSCS.EditCol;
  FTabContainer.BackgroundColor := FSCS.EditCol;
  FTabContainer.BorderWidth := 4;
  FTabContainer.Border := True;
  FTabContainer.Anchors := [akLeft,akTop,akRight,akBottom];
  FTabContainer.ParentBackground := False;
  FTabContainer.DoubleBuffered := True;
  FTabContainer.SendToBack;

  FPages := TJvpageList.Create(FTabContainer);
  FPages.DoubleBuffered := True;
  FPages.Parent := FTabContainer;
  FPages.Align := alClient;

  // Create the customisation page
  tmpTab := TJvStandardPage.Create(Self);
  tmpTab.DoubleBuffered := True;
  tmpTab.PageList := FPages;
  tmpTab.Visible := True;
  tmptab.Caption := 'test';

  FHueSlider := TJvTrackBar.Create(tmpTab);
  FSatSlider := TJvTrackBar.Create(tmpTab);
  FBriSlider := TJvTrackBar.Create(tmpTab);
  FRedSlider := TJvTrackBar.Create(tmpTab);
  FGreSlider := TJvTrackBar.Create(tmpTab);
  FBluSlider := TJvTrackBar.Create(tmpTab);
  ResizeDefineCol;

  // Create the swatches page
  
  Self.OnResize := ResizeEvent;
  InitialiseSliders;

  FHueSlider.Invalidate;
  FSatSlider.Invalidate;
  FBriSlider.Invalidate;
  FRedSlider.Invalidate;
  FGreSlider.Invalidate;
  FBluSlider.Invalidate;
end;

procedure TSharpEColorPanel.DeselectTabs;
begin
  FTabs.TabIndex := -1;
end;

destructor TSharpEColorPanel.Destroy;
begin
  FTabs.Free;
  inherited;
end;

procedure TSharpEColorPanel.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  Invalidate;
end;

procedure TSharpEColorPanel.SetExpanded(const Value: Boolean);
var
  i:Integer;
  tmp: TSharpEColorPanel;
begin
  FExpanded := Value;

  if Self.GroupIndex <> 0 then begin

    For i := 0 to Pred(Owner.ComponentCount) do begin
      if Owner.Components[i].ClassType = TSharpEColorPanel then begin
        tmp := TSharpEColorPanel(Owner.Components[i]);
        tmp.FreeAllSpinEdits;

        if ((tmp <> nil) and (tmp <> self) and (tmp.GroupIndex = Self.GroupIndex)) then
          tmp.Height := FCollapseHeight;

      end;
    end;

    Self.Height := FExpandedHeight;

  end else begin
    if Value then
      Self.Height := FExpandedHeight else
      Self.Height := FCollapseHeight;
  end;

end;

procedure TSharpEColorPanel.SetExpandedHeight(const Value: Integer);
begin
  FExpandedHeight := Value;
  if FExpanded then
    Height := FExpandedHeight;
end;

procedure TSharpEColorPanel.SetCollapseHeight(const Value: Integer);
begin
  FCollapseHeight := Value;
  if Not(FExpanded) then
    Height := FCollapseHeight;
end;

procedure TSharpEColorPanel.SetGroupIndex(const Value: Integer);
begin
  FGroupIndex := Value;
end;

procedure TSharpEColorPanel.Collapse;
begin
  Expanded := True;
end;

function TSharpEColorPanel.GetExpanded: Boolean;
begin
  Result := False;

  if FExpandedHeight = Height then
    Result := True
  else if FCollapseHeight = Height then
    Result := False;

end;

procedure TSharpEColorPanel.TabClickEvent(ASender: TObject; const ATabIndex:Integer);
begin
  lockwindowupdate(self.Handle);
  try
    if Not(Expanded) then
      Expanded := True;

  finally
    lockwindowupdate(0);
  end;
end;

function TSharpEColorPanel.GetColorCode: Integer;
begin
  if FColorPicker <> nil then
    Result := FColorPicker.ColorCode;
end;

procedure TSharpEColorPanel.SetColorCode(const Value: Integer);
begin
  FColorCode := Value;
  FColorAsTColor := TColor(Value);

  if FColorPicker <> nil then
    FColorPicker.ColorCode := Value;

  InitialiseSliders;
end;

procedure TSharpEColorPanel.ColorClickEvent(ASender: TObject);
begin
  FColorCode := FColorPicker.ColorCode;

  InitialiseSliders;
end;

procedure TSharpEColorPanel.SetColorAsTColor(const Value: TColor);
begin
  FColorCode := Value;
  FColorAsTColor := Value;

  if FColorPicker <> nil then
    FColorPicker.ColorCode := Value;

  InitialiseSliders;
end;

procedure TSharpEColorPanel.MakeSliderPretty(ASlider: TJvTrackBar);
begin
  with ASlider do begin
    TickStyle := tsNone;
    ShowRange := False;
    Height := 33;
    PageSize := 1;
  end;
end;

procedure TSharpEColorPanel.PositionSlider(ASlider: TJvTrackBar; ACaption:String;
  ATextRect, ASliderRect:TRect; ARow:Integer; AParent:TWinControl;
        ALabelAnchors, ASliderAnchors: TAnchors);
var
  lbl: TLabel;
begin

  ASlider.Parent := AParent;
  ASlider.Left := ASliderRect.Left;
  ASlider.Height := 30;
  ASlider.Top := ASliderRect.Top + (ASlider.Height*ARow);
  ASlider.Width := ASliderRect.Right-ASliderRect.Left;
  ASlider.Min := 0;
  ASlider.Max := 255;
  ASlider.Anchors := ASliderAnchors;
  ASlider.OnChange := SliderChangeEvent;
  ASlider.OnMouseDown := SliderMouseDownEvent;
  ASlider.ToolTips := True;
  ASlider.Frequency := 1;
  ASlider.HintColor := clWindow;
  ASlider.PageSize := 0;

  lbl := TLabel.Create(AParent);
  lbl.Parent := AParent;
  lbl.Caption := ACaption;
  lbl.Left := ATextRect.Left;
  lbl.Height := 30;
  lbl.Top := ASlider.Top-5;
  lbl.Left := ATextRect.Left;
  lbl.Width := ATextRect.Right-ATextRect.Left;
  lbl.AutoSize := false;
  lbl.Anchors := ALabelAnchors;
  lbl.Alignment := taLeftJustify;
  lbl.Layout := tlCenter;
  lbl.Tag := Integer(ASlider);
  lbl.OnClick := LabelClickEvent;

  ASlider.Tag := Integer(lbl);

  MakeSliderPretty(ASlider);
end;

procedure TSharpEColorPanel.LoadResources;
var
  png:TPngImageCollectionItem;
begin
  FPngImageList := TPngImageList.Create(Self);
  png := FPngImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance,'COLOR_PANEL_GEAR_PNG');
  png := FPngImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance,'COLOR_PANEL_HEART_PNG');
  png := FPngImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance,'COLOR_PANEL_HEART_PNG');
end;

procedure TSharpEColorPanel.ResizeEvent(Sender: TObject);
begin
  ResizeDefineCol;
end;

procedure TSharpEColorPanel.ResizeDefineCol;
var
  png:TPngImageCollectionItem;
  tmpTab: TJvcustomPage;
  btn: TButton;
  iWidthLT, {iWidthRT, }iSliderWidth, iSpacer, iX,iY, iTextWidth, n: Integer;
  rLeftSlider, rRightSlider, rLeftText, rRightText: TRect;
begin
  lockwindowupdate(self.Handle);
  for n := Pred(FPages.Pages[0].ControlCount) downto 0 do
    if FPages.Pages[0].Controls[n] is TLabel then
      FPages.Pages[0].Controls[n].Free;

  tmptab := FPages.Pages[0];
  iSpacer := 12;
  iWidthLT := Self.Canvas.TextWidth('Green: XXX');
  iSliderWidth := (tmpTab.Width-(iWidthLT*2)-(iSpacer*4)) div 2;

  iX := iSpacer;
  iY := iSpacer;
  rLeftText := Rect(iSpacer,iSpacer, iWidthLT+iSpacer,iY+10);
  rLeftSlider := Rect(rLeftText.Right+iSpacer,iY,rLeftText.Right+iSliderWidth+iSpacer,iY+10);
  rRightText := Rect(rLeftSlider.Right+(iSpacer*1),iY,rLeftSlider.Right+iWidthLT+iSpacer,iY+10);
  rRightSlider := Rect(rRightText.Right+iSpacer,iY,Self.Width-iSpacer,iY+10);

  PositionSlider(FHueSlider,'Hue: XXX',rLeftText,rLeftSlider,0, tmpTab,[akLeft,akTop],
    [akTop,akLeft,akRight]);

  PositionSlider(FSatSlider,'Sat: XXX:',rLeftText,rLeftSlider,1, tmpTab,[akLeft,akTop],
    [akTop,akLeft,akRight]);

  PositionSlider(FBriSlider,'Lum: XXX',rLeftText,rLeftSlider,2, tmpTab,[akLeft,akTop],
    [akTop,akLeft,akRight]);

  PositionSlider(FRedSlider,'Red: XXX',rRightText,rRightSlider,0, tmpTab,[akRight,akTop],
    [akTop,akRight]);

  PositionSlider(FGreSlider,'Green: XXX',rRightText,rRightSlider,1, tmpTab,[akRight,akTop,akRight],
    [akTop,akRight]);

  PositionSlider(FBluSlider,'Blue: XXX',rRightText,rRightSlider,2, tmpTab,[akRight,akTop,akRight],
    [akTop,akRight]);

  lockwindowupdate(0);
end;

procedure TSharpEColorPanel.InitialiseSliders;
var
  r,g,b: byte;
  hsl: THSLColor;
  rgb: integer;
begin
  rgb := FColorCode;

  r := GetRValue(rgb);
  b := GetBValue(rgb);
  g := GetGValue(rgb);
  hsl := SharpGraphicsUtils.RGBtoHSL(color32(r,g,b,255));

  // RGB
  if FRedSlider <> nil then begin
    FRedSlider.Position := r;
    TLabel(FRedSlider.Tag).Caption := Format('Red: %d',[r]);
  end;

  if FGreSlider <> nil then begin
    FGreSlider.Position := g;
    TLabel(FGreSlider.Tag).Caption := Format('Green: %d',[g]);
  end;

  if FBluSlider <> nil then begin
    FBluSlider.Position := b;
    TLabel(FBluSlider.Tag).Caption := Format('Blue: %d',[b]);
  end;

  // HSL
  if FHueSlider <> nil then begin
    FHueSlider.Position := hsl.Hue;
    TLabel(FHueSlider.Tag).Caption := Format('Hue: %d',[hsl.Hue]);
  end;

  if FSatSlider <> nil then begin
    FSatSlider.Position := hsl.Saturation;
    TLabel(FSatSlider.Tag).Caption := Format('Sat: %d',[hsl.Saturation]);
  end;

  if FBriSlider <> nil then begin
    FBriSlider.Position := hsl.Lightness;
    TLabel(FBriSlider.Tag).Caption := Format('Bri: %d',[hsl.Lightness]);
  end;

end;

procedure TSharpEColorPanel.SetCaption(const Value: String);
begin
  FCaption := Value;

  if FCaptionLabel <> nil then
    FCaptionLabel.Caption := Value;

  if (FCaptionLabel <> nil) then begin
    if (Value = '') then
    FCaptionLabel.Hide else
    FCaptionLabel.Show;
  end
end;

procedure TSharpEColorPanel.SliderChangeEvent(Sender: TObject);
var
  r,g,b,h,s,l: byte;
  tmpSlider: TJvTrackBar;
  pos: Integer;
begin

  FRedSlider.OnChange := nil;
  FBluSlider.OnChange := nil;
  FGreSlider.OnChange := nil;
  FHueSlider.OnChange := nil;
  FSatSlider.OnChange := nil;
  FBriSlider.OnChange := nil;

  if (Sender is TJvSpinEdit) then begin
    tmpSlider := TJvTrackBar(TJvSpinEdit(Sender).Tag);
    pos := TJvSpinEdit(Sender).AsInteger;

    if tmpSlider = FRedSlider then
      Sender := FRedSlider else
    if tmpSlider = FBluSlider then
      Sender := FBluSlider else
    if tmpSlider = FGreSlider then
      Sender := FGreSlider;
    if tmpSlider = FHueSlider then
      Sender := FHueSlider else
    if tmpSlider = FSatSlider then
      Sender := FSatSlider else
    if tmpSlider = FBriSlider then
      Sender := FBriSlider;

    TJvTrackBar(Sender).Position := pos;
  end;

  r := FRedSlider.Position;
  g := FGreSlider.Position;
  b := FBluSlider.Position;
  h := FHueSlider.Position;
  s := FSatSlider.Position;
  l := FBriSlider.Position;

  if ((Sender = FRedSlider) or (Sender = FBluSlider) or (Sender = FGreSlider)) then
    ColorCode := RGB(r,g,b)
  else begin
    Color32ToRGB(SharpGraphicsUtils.HSLtoRGB(h,s,l),r,g,b);
    ColorCode := RGB(r,g,b);
  end;

  FRedSlider.OnChange := SliderChangeEvent;
  FBluSlider.OnChange := SliderChangeEvent;
  FGreSlider.OnChange := SliderChangeEvent;
  FHueSlider.OnChange := SliderChangeEvent;
  FSatSlider.OnChange := SliderChangeEvent;
  FBriSlider.OnChange := SliderChangeEvent;
  

end;

procedure TSharpEColorPanel.LabelClickEvent(Sender: TObject);
var
  tmpEdit: TjvspinEdit;
  i: Integer;
begin
  lockwindowupdate(self.Handle);
  try

  FreeAllSpinEdits;

  tmpEdit := TJvspinEdit.Create(nil);

  tmpEdit.Parent := TLabel(Sender).Parent;
  tmpEdit.ButtonKind := bkStandard;
  tmpEdit.Left := TLabel(Sender).Left;
  tmpEdit.Top := TLabel(Sender).Top+6;
  tmpEdit.Width := TLabel(Sender).Width;
  tmpEdit.MaxValue := 255;
  tmpEdit.MaxLength := 3;
  tmpEdit.Height := 20;
  tmpEdit.Text := IntToStr(TJvTrackBar(TLabel(Sender).Tag).Position);
  tmpEdit.SetFocus;
  tmpEdit.DoubleBuffered := True;
  tmpEdit.Tag := TLabel(Sender).Tag;
  tmpEdit.OnChange := SliderChangeEvent;
  tmpEdit.OnKeyUp := SpinEditKeyPressEvent;

  finally
    lockwindowupdate(0);
  end;
end;

procedure TSharpEColorPanel.FreeAllSpinEdits(Sender:TObject=nil);
var
  i: Integer;
begin

  for i := 0 to Pred(FPages.Pages[0].ControlCount) do
    if FPages.Pages[0].Controls[i] is TJvSpinEdit then
      FPages.Pages[0].Controls[i].Free;
end;

procedure TSharpEColorPanel.SliderMouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FreeAllSpinEdits;
end;

procedure TSharpEColorPanel.SpinEditKeyPressEvent(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then begin
    TJvSpinEdit(Sender).Hide;
  end;
end;

end.


