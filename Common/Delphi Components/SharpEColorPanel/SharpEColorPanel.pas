unit SharpEColorPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpERoundPanel, uSharpETabList, uSharpEColorBox,
    pngimagelist, pngimage, ComCtrls, JvExComCtrls, JvComCtrls, StdCtrls,
      jvPageList, SharpGraphicsUtils, SharpCenterScheme, gr32, JvSpin,
        JvHtControls, SharpFX, SharpThemeApi, JvLabel, JvTypes, JvPanel;

Type
  TSliderUpdateMode = (sumAll, sumRGB, sumHSL);

Type
  TColorChangeEvent= procedure (ASender: TObject; AColorCode:Integer) of object;

const
  cPagDefineCol=0;
  cPagColSwatch=1;

Type
  TSharpEColorPanel = Class(TCustomControl)
  private
     FTabs: TSharpETabList;
     FTabContainer: TSharpERoundPanel;
     FColorPicker: TSharpEColorBox;
     FPngImageList: TPngImageList;
     FPages: TJvPageList;
     FNamePanel: TPanel;
     FHueSlider, FSatSlider, FLumSlider: TJvTrackBar;
     FRedSlider, FGreenSlider, FBlueSlider: TJvTrackBar;
     FSliderUpdateMode: TSliderUpdateMode;
     FSCS: TSharpECenterScheme;

    FExpanded: Boolean;
    FGroupIndex: Integer;
    FExpandedHeight: Integer;
    FCollapseHeight: Integer;
    FColorCode: Integer;
    FColorAsTColor: TColor;
    FCaption: String;
    FOnColorChange: TColorChangeEvent;
    FOnTabClick: TNotifyEvent;

    procedure CreateControls(Sender: TObject);
    procedure SetExpanded(const Value: Boolean);
    procedure SetGroupIndex(const Value: Integer);

    function GetExpanded: Boolean;
    procedure TabClickEvent(ASender: TObject; const ATabIndex:Integer);
    procedure ColorClickEvent(ASender: TObject);
    procedure SetColorCode(const Value: Integer);

    procedure SetColorAsTColor(const Value: TColor);
    procedure LabelClickEvent(Sender: TObject);

    procedure PositionSlider(ASlider: TJvTrackBar; ACaption:String;
  ATextRect, ASliderRect, ASliderValRect:TRect; ARow:Integer; AParent:TWinControl;
        ALabelAnchors, ASliderAnchors: TAnchors);
    procedure LoadResources;
    procedure ResizeEvent(Sender:TObject);
    procedure ResizeDefineColsPage;
    procedure InitialiseSliders;
    procedure SetCaption(const Value: String);
    procedure SliderChangeEvent(Sender:TObject);
    procedure SliderMouseDownEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
    procedure CaptionLabelClickEvent(Sender:TObject);
    procedure FreeAllSpinEdits(Sender:TObject=nil);
    procedure SpinEditKeyPressEvent(Sender: TObject; var Key: Word;
  Shift: TShiftState);

    procedure SliderEvents(AEnabled: Boolean);

  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure SelectDefaultTab;
    procedure Collapse;

    procedure OverrideSliderUpdateMode(ASliderUpdateMode:TSliderUpdateMode);
  protected
    procedure DeSelectTabs;
    procedure Loaded; override;
    
  published
    property Align;
    property Expanded: Boolean read GetExpanded write SetExpanded;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property Caption: String read FCaption write SetCaption;
    property ColorCode: Integer read FColorCode write SetColorCode;
    property ColorAsTColor: TColor read FColorAsTColor write SetColorAsTColor;

    property OnColorChange: TColorChangeEvent read FOnColorChange write FOnColorChange;
    property OnTabClick: TNotifyEvent read FOnTabClick write FOnTabClick;
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
  inherited Create(AOwner);
  Self.Height := 135;
  Self.Width := 200;
  FCollapseHeight := 24;
  FExpandedHeight := 135;

  CreateControls(nil);
end;

procedure TSharpEColorPanel.CreateControls(Sender: TObject);
var
  tmpTab: TJvstandardPage;

  procedure AssignDefaultSliderProps(ASlider:TJvTrackBar);
  begin

    with ASlider do begin

      Parent := FTabContainer;
      Frequency := 1;
      ShowRange := False;
      Ctl3D := False;
      DotNetHighlighting := False;
      TickStyle := tsNone;
      PageSize := 1;

      Min := 0;
      Max := 255;
      Height := 25;

      Color := FSCS.EditCol;

      OnChange := SliderChangeEvent;
      OnMouseDown := SliderMouseDownEvent;

    end;
  end;
begin

  // Create the sharpe scheme control, loads defaults
  FSCS := TSharpECenterScheme.Create(nil);

  // Load the image resource files
  LoadResources;

  // Create the tabs
  FTabs := TSharpETabList.Create(Self);
  with FTabs do begin
    Parent := Self;
    Anchors := [akRight, akTop];

    TabAlign := taRightJustify;
    IconBounds := Rect(12,3,0,0);
    TabWidth := 40;

    Top := 0;
    Width := (TabWidth*2)+IconBounds.Left+2;
    Left := Self.Width-Width;
    Border := True;
    PngImageList := FPngImageList;
    DoubleBuffered := True;

    BkgColor := Color;
    BorderColor := Color;
    TabSelectedColor := FSCS.EditTabSelCol;
    TabColor := clWindow;
    BorderColor := FSCS.EditTabBordCol;
    BorderSelectedColor := FSCS.EditTabBordCol;

    OnTabClick := TabClickEvent;
    SendToBack;

    Add('',0);
    Add('',1);
  end;

  // Create the colour picker control
  FColorPicker := TSharpEColorBox.Create(nil);
  with FColorPicker do begin
    Parent := Self;
    Anchors := [akRight, akTop];

    Left := Self.Width-FTabs.Width-FColorPicker.Width;
    Top := 7;
    DoubleBuffered := True;

    BackgroundColor := clWindow;
    ColorCode := FColorCode;

    OnColorClick := ColorClickEvent;
  end;

  // Create the name panel control
  FNamePanel := TPanel.Create(FTabs);
  with FNamePanel do begin
    Parent := self;
    Anchors := [akLeft,akRight, akTop];

    BevelInner := bvNone;
    BevelOuter := bvNone;
    Caption := FCaption;
    Alignment := taLeftJustify;
    VerticalAlignment := taVerticalCenter;

    Left := 0;
    Top := 1;
    Width := Self.Width-FTabs.Width-FColorPicker.Width;
    Height := ftabs.Height-2;

    Color := clWindow;

    OnClick := CaptionLabelClickEvent;
    BringToFront;
  end;

  // Create the tab container control
  FTabContainer := TSharpERoundPanel.Create(self);
  with FTabContainer do begin
    Parent := Self;
    Anchors := [akLeft,akTop,akRight,akBottom];

    DrawMode := srpNoTopRight;
    BorderWidth := 4;
    Border := True;

    Top := FTabs.Height-1;
    Left := 0;
    Height := Height-FTabs.Height+1;
    Width := Self.Width;

    BorderColor := FSCS.EditBordCol;
    Color := FSCS.EditCol;
    BackgroundColor := clWindow;
    DoubleBuffered := True;
    ParentBackground := False;

    SendToBack;
  end;

  FPages := TJvpageList.Create(FTabContainer);
  with FPages do begin
    Parent := FTabContainer;

    Align := alClient;
  end;

  // Create the customisation page
  tmpTab := TJvStandardPage.Create(Self);
  with tmpTab do begin
    PageList := FPages;
    Caption := 'Colour Edit';
  end;

  // Create the sliders
  FHueSlider := TJvTrackBar.Create(tmpTab);
  AssignDefaultSliderProps(FHueSlider);

  FSatSlider := TJvTrackBar.Create(tmpTab);
  AssignDefaultSliderProps(FSatSlider);

  FLumSlider := TJvTrackBar.Create(tmpTab);
  AssignDefaultSliderProps(FLumSlider);

  FRedSlider := TJvTrackBar.Create(tmpTab);
  AssignDefaultSliderProps(FRedSlider);

  FGreenSlider := TJvTrackBar.Create(tmpTab);
  AssignDefaultSliderProps(FGreenSlider);

  FBlueSlider := TJvTrackBar.Create(tmpTab);
  AssignDefaultSliderProps(FBlueSlider);

  // Create the swatches page
  tmpTab := TJvStandardPage.Create(Self);
  with tmpTab do begin
    PageList := FPages;
    tmpTab.Caption := 'Colour Swatches';
  end;

  // Set the default page
  FPages.Pages[cPagDefineCol].Show;
  FTabs.TabIndex := -1;

  // Set resize event 
  Self.OnResize := ResizeEvent;
end;

destructor TSharpEColorPanel.Destroy;
begin
  inherited;
  FSCS.Free;
end;

procedure TSharpEColorPanel.SetExpanded(const Value: Boolean);
var
  i:Integer;
  tmp: TSharpEColorPanel;
begin
  FExpanded := Value;
  Try

  if Self.GroupIndex <> 0 then begin

    For i := 0 to Pred(Owner.ComponentCount) do begin
      if Owner.Components[i].ClassType = TSharpEColorPanel then begin
        tmp := TSharpEColorPanel(Owner.Components[i]);
        tmp.Collapse;

        if ((tmp <> nil) and (tmp <> self) and (tmp.GroupIndex = Self.GroupIndex)) then
          tmp.Height := FCollapseHeight;

      end;
    end;

    Self.Height := FExpandedHeight;
    FTabs.TabIndex := cPagDefineCol;

  end else begin
    if Value then begin
      Self.Height := FExpandedHeight;
      FTabs.TabIndex := cPagDefineCol;
    end else begin
      Self.Height := FCollapseHeight;
      FTabs.TabIndex := -1;
    end;
  end;
  Except
  End;
end;

procedure TSharpEColorPanel.SetGroupIndex(const Value: Integer);
begin
  FGroupIndex := Value;
end;

procedure TSharpEColorPanel.Collapse;
begin
  Expanded := False;

  DeSelectTabs;
  FreeAllSpinEdits;
end;

function TSharpEColorPanel.GetExpanded: Boolean;
begin
  Result := FExpanded;

end;

procedure TSharpEColorPanel.TabClickEvent(ASender: TObject; const ATabIndex:Integer);
begin
  if ATabIndex = FTabs.TabIndex then
    Exit;

  //LockWindowUpdate(FTabContainer.Handle);
  Try

    if ATabIndex = 0 then begin
      FSliderUpdateMode := sumAll;
      InitialiseSliders;
      FPages.Pages[0].Show;

      FPages.Pages[0].Invalidate;

      FRedSlider.Invalidate;
      FBlueSlider.Invalidate;
      FGreenSlider.Invalidate;
      FHueSlider.Invalidate;
      FSatSlider.Invalidate;
      FLumSlider.Invalidate;

    end else
    if ATabIndex = 1 then begin
      FPages.Pages[1].Show;
      FPages.Pages[1].Invalidate;
    end;

  
  if Assigned(FOnTabClick) then
    FOnTabClick(Self) else
    Expanded := True;
    

  Finally
  //  LockWindowUpdate(0);
  End;
end;

procedure TSharpEColorPanel.SetColorCode(const Value: Integer);
begin
  SliderEvents(False);
  Try

    FColorCode := ColorToSchemeCode(Value);
    FColorAsTColor := SchemeCodeToColor(Value);

    if FColorPicker <> nil then
      FColorPicker.ColorCode := FColorCode;

    //FSliderUpdateMode := sumAll;
    InitialiseSliders;

    if Assigned(FOnColorChange) then
      FOnColorChange(Self,FColorCode);

  Finally
    SliderEvents(True);
  End;
end;

procedure TSharpEColorPanel.ColorClickEvent(ASender: TObject);
begin
  ColorCode := FColorPicker.ColorCode;
end;

procedure TSharpEColorPanel.SetColorAsTColor(const Value: TColor);
begin
  ColorCode := Value;
end;

procedure TSharpEColorPanel.PositionSlider(ASlider: TJvTrackBar; ACaption:String;
  ATextRect, ASliderRect, ASliderValRect:TRect; ARow:Integer; AParent:TWinControl;
        ALabelAnchors, ASliderAnchors: TAnchors);
var
  lbl: TLabel;
begin

  // Position the slider
  with ASlider do begin
    Parent := AParent;
    Left := ASliderRect.Left;
    Top := ASliderRect.Top + (ASlider.Height*ARow);
    Width := ASliderRect.Right-ASliderRect.Left;
    Anchors := ASliderAnchors;
  end;

  // Create the slider text
  lbl := TLabel.Create(AParent);
  with lbl do begin
    Parent := AParent;
    Tag := Integer(ASlider);

    Anchors := ALabelAnchors;
    Caption := ACaption;
    AutoSize := False;
    Transparent := False;
    Alignment := taLeftJustify;
    Layout := tlCenter;

    Height := 30;
    Top := ASlider.Top-5;
    Left := ATextRect.Left;
    Width := ATextRect.Right-ATextRect.Left;

    Color := FSCS.EditCol;
  end;

  // Create the slider value text
  lbl := TLabel.Create(AParent);
  with lbl do begin
    Parent := AParent;
    Tag := Integer(ASlider);

    Anchors := ALabelAnchors;
    Caption := ACaption;
    AutoSize := False;
    Transparent := False;
    Alignment := taLeftJustify;
    Layout := tlCenter;

    Height := 30;
    Top := ASlider.Top-5;
    Left := ASliderValRect.Left;
    Width := ASliderValRect.Right-ASliderValRect.Left;

    Color := FSCS.EditCol;
    Font.Color := Darker(FScS.EditCol,35);

    OnClick := LabelClickEvent;
  end;

  ASlider.Tag := Integer(lbl);

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
  ResizeDefineColsPage;
end;

procedure TSharpEColorPanel.ResizeDefineColsPage;
var
  tmpTab: TJvcustomPage;
  iWidthLT, iWidthVal, iSliderWidth, iSpacer,iY, n: Integer;
  rLeftSlider, rLeftSliderVal, rRightSlider, rRightSliderVal, rLeftText, rRightText: TRect;
begin

  for n := Pred(FPages.Pages[0].ControlCount) downto 0 do
    if FPages.Pages[0].Controls[n] is TLabel then
      FPages.Pages[0].Controls[n].Free;

  tmptab := FPages.Pages[0];
  iSpacer := 12;
  iWidthLT := Self.Canvas.TextWidth('Green:X');
  iWidthVal := Self.Canvas.TextWidth('XXXXXXX');
  iSliderWidth := (tmpTab.Width-(iWidthLT*2)-(iWidthVal*2)+ (iSpacer)) div 2;

  iY := iSpacer;

  rLeftText := Rect(iSpacer,iSpacer, iWidthLT{+iSpacer},iY+10);
  rLeftSlider := Rect(rLeftText.Right{+iSpacer},iY,rLeftText.Right+iSliderWidth{+iSpacer},iY+10);
  rLeftSliderVal := Rect(rLeftSlider.Right{+iSpacer}, iY, rLeftSlider.Right+{+iSpacer+}iWidthVal, iy+10);

  rRightText := Rect(rLeftSliderVal.Right{+iSpacer},iY,rLeftSliderVal.Right+iWidthLT{+iSpacer},iY+10);
  rRightSlider := Rect(rRightText.Right{+iSpacer},iY,rRightText.Right-iSpacer+iSliderWidth,iY+10);
  rRightSliderVal := Rect(rRightSlider.Right{+iSpacer},iY,Self.Width-iSpacer+4,iY+10);

  PositionSlider(FHueSlider,'Hue:',rLeftText,rLeftSlider,rLeftSliderVal,0, tmpTab,[akLeft,akTop],
    [akTop,akLeft,akRight]);

  PositionSlider(FSatSlider,'Sat:',rLeftText,rLeftSlider,rLeftSliderVal,1, tmpTab,[akLeft,akTop],
    [akTop,akLeft,akRight]);

  PositionSlider(FLumSlider,'Lum:',rLeftText,rLeftSlider,rLeftSliderVal,2, tmpTab,[akLeft,akTop],
    [akTop,akLeft,akRight]);

  PositionSlider(FRedSlider,'Red:',rRightText,rRightSlider,rRightSliderVal,0, tmpTab,[akRight,akTop],
    [akTop,akRight]);

  PositionSlider(FGreenSlider,'Green:',rRightText,rRightSlider,rRightSliderVal,1, tmpTab,[akRight,akTop,akRight],
    [akTop,akRight]);

  PositionSlider(FBlueSlider,'Blue:',rRightText,rRightSlider,rRightSliderVal,2, tmpTab,[akRight,akTop,akRight],
    [akTop,akRight]);

  FSliderUpdateMode := sumAll;
  InitialiseSliders;

end;

procedure TSharpEColorPanel.InitialiseSliders;
var
  col:TColor;
  r,g,b: byte;
  hsl: THSLColor;
  rgb: integer;

  procedure UpdateHSLLabel;
  begin
    TLabel(FHueSlider.Tag).Caption := Format('%d',[FHueSlider.Position]);
    TLabel(FSatSlider.Tag).Caption := Format('%d',[FSatSlider.Position]);
    TLabel(FLumSlider.Tag).Caption := Format('%d',[FLumSlider.Position]);
  end;

  procedure UpdateRGBLabel;
  begin
    TLabel(FRedSlider.Tag).Caption := Format('%d',[FRedSlider.Position]);
    TLabel(FGreenSlider.Tag).Caption := Format('%d',[FGreenSlider.Position]);
    TLabel(FBlueSlider.Tag).Caption := Format('%d',[FBlueSlider.Position]);
  end;

  procedure UpdateLabels;
  begin
    UpdateRGBLabel;
    UpdateHSLLabel;
  end;
begin

  if FColorCode < 0 then
    col := SchemeCodeToColor(FColorCode) else
    col := FColorCode;

  rgb := col;

  r := GetRValue(rgb);
  b := GetBValue(rgb);
  g := GetGValue(rgb);
  hsl := SharpGraphicsUtils.RGBtoHSL(color32(r,g,b,255));

  // RGB
  if ((FRedSlider <> nil) and ((FSliderUpdateMode = sumRGB) or (FSliderUpdateMode = sumAll))) then begin
    FRedSlider.Position := r;
  end;

  if ((FGreenSlider <> nil) and ((FSliderUpdateMode = sumRGB) or (FSliderUpdateMode = sumAll))) then begin
    FGreenSlider.Position := g;
  end;

  if ((FBlueSlider <> nil) and ((FSliderUpdateMode = sumRGB) or (FSliderUpdateMode = sumAll))) then begin
    FBlueSlider.Position := b;
  end;

  // HSL
  if ((FHueSlider <> nil) and ((FSliderUpdateMode = sumHSL) or (FSliderUpdateMode = sumAll))) then begin
    FHueSlider.Position := hsl.Hue;
  end;

   if ((FSatSlider <> nil) and ((FSliderUpdateMode = sumHSL) or (FSliderUpdateMode = sumAll))) then begin
    FSatSlider.Position := hsl.Saturation;
  end;

  if ((FHueSlider <> nil) and ((FSliderUpdateMode = sumHSL) or (FSliderUpdateMode = sumAll))) then begin
    FLumSlider.Position := hsl.Lightness;
  end;

  if FTabContainer <> nil then
    UpdateLabels;

end;

procedure TSharpEColorPanel.SetCaption(const Value: String);
begin
  FCaption := Value;

  if FNamePanel <> nil then
    FNamePanel.Caption := Value;

  if (FNamePanel <> nil) then begin
    if (Value = '') then
    FNamePanel.Hide else
    FNamePanel.Show;
  end
end;

procedure TSharpEColorPanel.SliderChangeEvent(Sender: TObject);
var
  r,g,b,h,s,l: byte;
  tmpSlider: TJvTrackBar;
  pos: Integer;
begin

  SliderEvents(False);

  if (Sender is TJvSpinEdit) then begin
    tmpSlider := TJvTrackBar(TJvSpinEdit(Sender).Tag);
    pos := TJvSpinEdit(Sender).AsInteger;

    if tmpSlider = FRedSlider then
      Sender := FRedSlider else
    if tmpSlider = FBlueSlider then
      Sender := FBlueSlider else
    if tmpSlider = FGreenSlider then
      Sender := FGreenSlider;
    if tmpSlider = FHueSlider then
      Sender := FHueSlider else
    if tmpSlider = FSatSlider then
      Sender := FSatSlider else
    if tmpSlider = FLumSlider then
      Sender := FLumSlider;

    TJvTrackBar(Sender).Position := pos;
  end;

  r := FRedSlider.Position;
  g := FGreenSlider.Position;
  b := FBlueSlider.Position;
  h := FHueSlider.Position;
  s := FSatSlider.Position;
  l := FLumSlider.Position;

  if ((Sender = FRedSlider) or (Sender = FBlueSlider) or (Sender = FGreenSlider)) then begin

    FSliderUpdateMode := sumHSL;
    ColorCode := RGB(r,g,b);
    

  end else begin
    Color32ToRGB(SharpGraphicsUtils.HSLtoRGB(h,s,l),r,g,b);

    FSliderUpdateMode := sumRGB;
    ColorCode := RGB(r,g,b);
    
  end;

  SliderEvents(True);


end;

procedure TSharpEColorPanel.LabelClickEvent(Sender: TObject);
var
  tmpEdit: TjvspinEdit;
begin

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
  tmpEdit.Tag := TLabel(Sender).Tag;
  tmpEdit.OnChange := SliderChangeEvent;
  tmpEdit.OnKeyUp := SpinEditKeyPressEvent;
end;

procedure TSharpEColorPanel.FreeAllSpinEdits(Sender:TObject=nil);
var
  i: Integer;
begin
  if ((FPages = nil) or (FPages.Pages[cPagDefineCol] = nil)) then exit;

  for i := 0 to Pred(FPages.Pages[cPagDefineCol].ControlCount) do
    if FPages.Pages[cPagDefineCol].Controls[i] is TJvSpinEdit then
      FPages.Pages[cPagDefineCol].Controls[i].Free;
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

procedure TSharpEColorPanel.CaptionLabelClickEvent(Sender: TObject);
begin
  TabClickEvent(FTabs,FTabs.TabIndex);
end;

procedure TSharpEColorPanel.deselecttabs;
begin
  if FTabs <> nil then
    FTabs.TabIndex := -1;
end;

procedure TSharpEColorPanel.SliderEvents(AEnabled: Boolean);
begin
  if AEnabled then begin
    FRedSlider.OnChange := SliderChangeEvent;
    FBlueSlider.OnChange := SliderChangeEvent;
    FGreenSlider.OnChange := SliderChangeEvent;
    FHueSlider.OnChange := SliderChangeEvent;
    FSatSlider.OnChange := SliderChangeEvent;
    FLumSlider.OnChange := SliderChangeEvent;
  end else begin
    FRedSlider.OnChange := nil;
    FBlueSlider.OnChange := nil;
    FGreenSlider.OnChange := nil;
    FHueSlider.OnChange := nil;
    FSatSlider.OnChange := nil;
    FLumSlider.OnChange := nil;
  end;
end;

procedure TSharpEColorPanel.SelectDefaultTab;
begin
  FTabs.TabIndex := 0;
end;

procedure TSharpEColorPanel.OverrideSliderUpdateMode(
  ASliderUpdateMode: TSliderUpdateMode);
begin
  FSliderUpdateMode := ASliderUpdateMode;
end;

procedure TSharpEColorPanel.Loaded;
begin
  inherited;
end;

end.






