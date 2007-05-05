unit SharpEColorEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpERoundPanel, SharpETabList, SharpEColorPicker,
    pngimagelist, pngimage, ComCtrls, JvExComCtrls, JvComCtrls, StdCtrls,
      jvPageList, SharpECenterScheme, gr32, JvSpin,
        JvHtControls, SharpFX, SharpThemeApi,
          SharpESwatchCollection, SharpESwatchManager, SharpApi,
            pngspeedbutton, SharpGraphicsUtils;

Type
  TSliderUpdateMode = (sumAll, sumRGB, sumHSL);
  TColorEditorType = (cetColor, cetValue);
Type
  TColorChangeEvent= procedure (ASender: TObject; AColorCode:Integer) of object;

const
  cPagDefineCol=0;
  cPagColSwatch=1;

Type
  TSharpEColorEditor = Class(TCustomControl)
  private
     FTabs: TSharpETabList;
     FTabContainer: TSharpERoundPanel;
     FColorPicker: TSharpEColorPicker;
     FAddColorButton: TPngSpeedButton;
     FPngImageList: TPngImageList;
     FPages: TJvPageList;
     FNameLabel: TPanel;
     FHueSlider, FSatSlider, FLumSlider: TJvTrackBar;
     FRedSlider, FGreenSlider, FBlueSlider: TJvTrackBar;
     FValueSlider: TJvTrackBar;
     FSharpESwatchCollection: TSharpESwatchCollection;
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
    FSwatchManager: TSharpESwatchManager;
    FColorEditorType: TColorEditorType;
    FValueMin: Integer;
    FDescription: String;
    FValueMax: Integer;
    FValueText: String;
    FValue: Integer;

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
    procedure ResizeDefineValPage;

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

    procedure ClickSwatchEvent(ASender:TObject; AColor:TColor);
    procedure AddSwatchEvent(ASender:TObject);
    procedure SetSwatchManager(const Value: TSharpESwatchManager);

    procedure GetWidth(ASender:TObject; var
      AWidth: Integer);
    procedure UpdateSwatchBitmap(ASender:TObject; const ABitmap32:TBitmap32);
    function GetCollapseHeight: Integer;
    function GetExpandedHeight: Integer;
    procedure SetColorEditorType(const Value: TColorEditorType);
    procedure SetDescription(const Value: String);
    procedure SetValueMax(const Value: Integer);
    procedure SetValueMin(const Value: Integer);

    procedure ColorSliderChangeEvent(Sender:TObject);
    procedure ValSliderChangeEvent(Sender:TObject);
    procedure SetValue(const Value: Integer);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure SelectDefaultTab;
    procedure Collapse;

    procedure OverrideSliderUpdateMode(ASliderUpdateMode:TSliderUpdateMode);
    property SwatchCollection:TSharpESwatchCollection read FSharpESwatchCollection write
      FSharpESwatchCollection;
  protected
    procedure DeSelectTabs;

  published
    property Align;

    property CollapseHeight: Integer read GetCollapseHeight;
    property ExpandedHeight: Integer read GetExpandedHeight;
    property Expanded: Boolean read GetExpanded write SetExpanded;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property Caption: String read FCaption write SetCaption;
    property ColorCode: Integer read FColorCode write SetColorCode;
    property ColorAsTColor: TColor read FColorAsTColor write SetColorAsTColor;
    property ColorEditorType: TColorEditorType  read FColorEditorType write
      SetColorEditorType;

    property Description: String read FDescription write SetDescription;
    property ValueText: String read FValueText write FValueText;
    property ValueMax: Integer read FValueMax write SetValueMax;
    property ValueMin: Integer read FValueMin write SetValueMin;
    property Value: Integer read FValue write SetValue;

    property OnColorChange: TColorChangeEvent read FOnColorChange write FOnColorChange;
    property OnTabClick: TNotifyEvent read FOnTabClick write FOnTabClick;

    property SwatchManager: TSharpESwatchManager read FSwatchManager write
      SetSwatchManager;

end;

  procedure Register;

implementation

uses Types;

{$R SharpEColorEditorRes.res}

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpEColorEditor]);
end;

{ TSharpEColorEditor }

constructor TSharpEColorEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Height := 135;
  Self.Width := 200;
  FCollapseHeight := 24;
  FExpandedHeight := 135;
  FColorEditorType := cetColor;
  FValueMin := 0;
  FValueMax := 255;
  FValueText := 'Alpha';

  CreateControls(nil);
end;

procedure TSharpEColorEditor.CreateControls(Sender: TObject);
var
  tmpTab: TJvstandardPage;
  tmpPanel: TPanel;

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

  self.DoubleBuffered := True;
  Self.BorderWidth := 0;
  self.Color := clWindow;
  Self.ParentBackground := false;

  // Create the tabs
  FTabs := TSharpETabList.Create(Self);
  with FTabs do begin
    Parent := Self;
    Anchors := [akRight, akTop, akLeft];

    TabAlign := taRightJustify;
    IconBounds := Rect(12,3,0,0);
    TabWidth := 40;

    Top := 0;
    FTabs.Width := Self.Width;
    Left := 0;
    Border := True;
    PngImageList := FPngImageList;
    DoubleBuffered := True;
    ParentBackground := False;

    BkgColor :=  clwindow;
    Color :=  clwindow;
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
  FColorPicker := TSharpEColorPicker.Create(FTabs);
  with FColorPicker do begin
    Parent := FTabs;
    Anchors := [akRight, akTop];

    FColorPicker.Left := FTabs.Width- (FTabs.TabWidth*2)-FTabs.IconBounds.Left+2-FColorPicker.Width;
    Top := 7;
    Height := 17;
    DoubleBuffered := False;

    BackgroundColor := clWindow;
    //ColorCode := FColorCode;
    //Color := clWindow;

    OnColorClick := ColorClickEvent;
    ParentBackground := False;
    ParentColor := False;
  end;

  tmpPanel := TPanel.Create(FTabs);
  with tmpPanel do begin
    tmpPanel.Parent := FTabs;
    tmpPanel.Anchors := [akRight, akTop];
    tmpPanel.Width := 20;
    tmpPanel.Height := FColorPicker.Height+2;
    tmpPanel.Caption := '';
    tmpPanel.Left := FColorPicker.Left-tmpPanel.Width-4;
    tmpPanel.OnClick := AddSwatchEvent;
    tmpPanel.BringToFront;
    tmpPanel.BevelInner := bvNone;
    tmpPanel.BevelOuter := bvNone;
    tmpPanel.ParentBackground := False;
    tmpPanel.Color := clWindow;
    tmpPanel.Top := 5;
  end;

  FAddColorButton := TPngSpeedButton.Create(tmpPanel);
  with FAddColorButton do begin
    FAddColorButton.Parent := tmpPanel;
    FAddColorButton.Align := alClient;
    FAddColorButton.Flat := True;
    FAddColorButton.Width := 20;
    FAddColorButton.Height := FColorPicker.Height+3;
    FAddColorButton.Caption := '';
    FAddColorButton.Left := FColorPicker.Left-FAddColorButton.Width-4;
    FAddColorButton.OnClick := AddSwatchEvent;
    FAddColorButton.BringToFront;
    FAddColorButton.PngImage.LoadFromResourceName(HInstance,'COLOR_PANEL_ADD_PNG');
    FAddColorButton.Top := 5;
  end;

  // Create the name panel control
  FNameLabel := TPanel.Create(FTabs);
  with FNameLabel do begin
    Parent := FTabs;
    Anchors := [akLeft, akTop, akRight];
    Align := alNone;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    Caption := FCaption;
    Alignment := taLeftJustify;
    VerticalAlignment := taVerticalCenter;

    //AutoSize := True;
    Left := 1;
    Top := 1;
    Width := FAddColorButton.Left-4;
    Height := FTabs.Height-2;

    Color := clWindow;
    ParentBackground := False;
    DoubleBuffered := True;

    OnClick := CaptionLabelClickEvent;
    BringToFront;
  end;

  // Create the tab container control
  FTabContainer := TSharpERoundPanel.Create(self);
  with FTabContainer do begin
    Parent := Self;

    Anchors := [akLeft,akTop,akRight,akBottom];

    DrawMode := srpNoTopRight;
    BorderWidth := 8;
    Border := True;

    FTabContainer.Top := FTabs.Height-1;
    FTabContainer.Left := 0;
    FTabContainer.Height := Height-FTabs.Height;
    FTabContainer.Width := Self.Width;

    BorderColor := FSCS.EditBordCol;
    Color := FSCS.EditCol;
    BackgroundColor := clWindow;

    SendToBack;
  end;

  FPages := TJvpageList.Create(FTabContainer);
  with FPages do begin
    Parent := FTabContainer;
    Color := FSCS.EditCol;
    Align := alClient;
  end;

  // Create the customisation page
  tmpTab := TJvStandardPage.Create(Self);
  with tmpTab do begin
    Parent := FPages;
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

  FValueSlider := TJvTrackBar.Create(tmpTab);
  AssignDefaultSliderProps(FValueSlider);

  // Create the swatches page
  tmpTab := TJvStandardPage.Create(Self);
  with tmpTab do begin
    PageList := FPages;
    BorderWidth := 4;
    tmpTab.Caption := 'Colour Swatches';
    tmpTab.Color := FSCS.EditCol;
  end;

  FSharpESwatchCollection := TSharpESwatchCollection.Create(tmpTab);
  with FSharpESwatchCollection do begin
    Align := alClient;
    Parent := tmpTab;
    BorderStyle := bsNone;
    ParentBackground := False;
    DoubleBuffered := True;

    OnDblClickSwatch := ClickSwatchEvent;
  end;

  // Set the default page
  FPages.Pages[cPagDefineCol].Show;
  FTabs.TabIndex := -1;

  // Set resize event
  Self.OnResize := ResizeEvent;
end;

destructor TSharpEColorEditor.Destroy;
begin
  inherited;
  FSCS.Free;
end;

procedure TSharpEColorEditor.SetExpanded(const Value: Boolean);
var
  i:Integer;
  tmp: TSharpEColorEditor;
begin
  FExpanded := Value;
  Try

  if Self.GroupIndex <> 0 then begin

    For i := 0 to Pred(Owner.ComponentCount) do begin
      if Owner.Components[i].ClassType = TSharpEColorEditor then begin
        tmp := TSharpEColorEditor(Owner.Components[i]);
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

procedure TSharpEColorEditor.SetGroupIndex(const Value: Integer);
begin
  FGroupIndex := Value;
end;

procedure TSharpEColorEditor.Collapse;
begin
  Expanded := False;

  DeSelectTabs;
  FreeAllSpinEdits;
end;

function TSharpEColorEditor.GetExpanded: Boolean;
begin
  Result := FExpanded;

end;

procedure TSharpEColorEditor.TabClickEvent(ASender: TObject; const ATabIndex:Integer);
begin
  if ATabIndex = FTabs.TabIndex then
    Exit;

    if ATabIndex = 0 then begin
      FSliderUpdateMode := sumAll;
      InitialiseSliders;
      FPages.Pages[0].Show;

      FRedSlider.Invalidate;
      FBlueSlider.Invalidate;
      FGreenSlider.Invalidate;
      FHueSlider.Invalidate;
      FSatSlider.Invalidate;
      FLumSlider.Invalidate;
    end else
    if ATabIndex = 1 then begin
      FPages.Pages[1].Show;
    end;


  if Assigned(FOnTabClick) then
    FOnTabClick(Self) else
    Expanded := True;

end;

procedure TSharpEColorEditor.SetColorCode(const Value: Integer);
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

procedure TSharpEColorEditor.ColorClickEvent(ASender: TObject);
begin
  ColorCode := FColorPicker.ColorCode;
end;

procedure TSharpEColorEditor.SetColorAsTColor(const Value: TColor);
begin
  ColorCode := Value;
end;

procedure TSharpEColorEditor.PositionSlider(ASlider: TJvTrackBar; ACaption:String;
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

procedure TSharpEColorEditor.LoadResources;
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

procedure TSharpEColorEditor.ResizeEvent(Sender: TObject);
begin
  case FColorEditorType of
    cetColor: ResizeDefineColsPage;
    cetValue: ResizeDefineValPage;
  end;

  FreeAllSpinEdits;

  //if FSwatchManager <> nil then
  //  FSwatchManager.Resize;
end;

procedure TSharpEColorEditor.ResizeDefineColsPage;
var
  tmpTab: TJvcustomPage;
  iWidthLT, iWidthVal, iSliderWidth, iSpacer,iY, n: Integer;
  rLeftSlider, rLeftSliderVal, rRightSlider, rRightSliderVal, rLeftText, rRightText: TRect;
begin

  FTabContainer.Height := Self.Height-FTabs.Height+1;
  FTabContainer.Width := Self.Width;
  FTabs.Width := Self.Width;

  // Hide/Show relevant components
  FColorPicker.Show;
  FAddColorButton.Show;
  FValueSlider.Hide;
  FRedSlider.Show;
  FBlueSlider.Show;
  FGreenSlider.Show;
  FHueSlider.Show;
  FSatSlider.Show;
  FLumSlider.Show;
  FTabs.TabList.Item[1].Visible := True;

  for n := Pred(FPages.Pages[0].ControlCount) downto 0 do
    if FPages.Pages[0].Controls[n] is TLabel then
      FPages.Pages[0].Controls[n].Free;

  tmptab := FPages.Pages[0];
  iSpacer := 12;
  iWidthLT := Self.Canvas.TextWidth('Green:X');
  iWidthVal := Self.Canvas.TextWidth('XXXXXXX');
  iSliderWidth := (tmpTab.Width-(iWidthLT*2)-(iWidthVal*2)+
    (iSpacer)) div 2;

  iY := iSpacer;

  rLeftText := Rect(iSpacer,iSpacer, iWidthLT{+iSpacer},iY+10);
  rLeftSlider := Rect(rLeftText.Right{+iSpacer},iY,rLeftText.Right+iSliderWidth{+iSpacer},iY+10);
  rLeftSliderVal := Rect(rLeftSlider.Right{+iSpacer}, iY, rLeftSlider.Right+{+iSpacer+}iWidthVal, iy+10);

  rRightText := Rect(rLeftSliderVal.Right+4{+iSpacer},iY,rLeftSliderVal.Right+iWidthLT{+iSpacer},iY+10);
  rRightSlider := Rect(rRightText.Right{+iSpacer},iY,rRightText.Right-iSpacer+iSliderWidth,iY+10);
  rRightSliderVal := Rect(rRightSlider.Right{+iSpacer},iY,Self.Width-iSpacer-4,iY+10);

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

procedure TSharpEColorEditor.ResizeDefineValPage;
var
  tmpTab: TJvcustomPage;
  iWidthLT, iWidthVal, iSliderWidth, iSpacer,iY, n: Integer;
  rLeftSlider, rLeftSliderVal, rRightSlider, rRightSliderVal, rLeftText, rRightText: TRect;

begin

  FTabContainer.Height := Self.Height-FTabs.Height+1;
  FTabContainer.Width := Self.Width;
  FTabs.Width := Self.Width;
  FValueSlider.Show;
  FRedSlider.Hide;
  FBlueSlider.Hide;
  FGreenSlider.Hide;
  FHueSlider.Hide;
  FSatSlider.Hide;
  FLumSlider.Hide;
  FColorPicker.Hide;
  FAddColorButton.Hide;
  FTabs.TabList.Item[1].Visible := False;


  for n := Pred(FPages.Pages[0].ControlCount) downto 0 do
    if FPages.Pages[0].Controls[n] is TLabel then
      FPages.Pages[0].Controls[n].Free;

  tmptab := FPages.Pages[0];
  iSpacer := 12;
  Self.Canvas.Font.Assign(Self.Font);
  iWidthLT := Self.Canvas.TextWidth(FValueText+':XX');
  iWidthVal := Self.Canvas.TextWidth('XXXXXXX');
  iSliderWidth := (tmpTab.Width-(iWidthVal*2));

  iY := iSpacer;

  rLeftText := Rect(iSpacer,iSpacer, iWidthLT{+iSpacer},iY+10);
  rLeftSlider := Rect(rLeftText.Right{+iSpacer},iY,rLeftText.Right+iSliderWidth{+iSpacer},iY+10);
  rLeftSliderVal := Rect(rLeftSlider.Right{+iSpacer}, iY, rLeftSlider.Right+{+iSpacer+}iWidthVal, iy+10);

  PositionSlider(FValueSlider,FValueText+':',rLeftText,rLeftSlider,rLeftSliderVal,0, tmpTab,[akLeft,akTop],
    [akTop,akLeft,akRight]);

  iY := iSpacer;
  FValueSlider.Invalidate;
  SetValue(FValue);
end;

procedure TSharpEColorEditor.InitialiseSliders;
var
  col:TColor;
  r,g,b: integer;
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

  if col < 0 then col := 0;

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

procedure TSharpEColorEditor.SetCaption(const Value: String);
begin
  FCaption := Value;

  if FNameLabel <> nil then
    FNameLabel.Caption := Value;

  if (FNameLabel <> nil) then begin
    if (Value = '') then
    FNameLabel.Hide else
    FNameLabel.Show;
  end
end;

procedure TSharpEColorEditor.SliderChangeEvent(Sender: TObject);
begin

  case FColorEditorType of
    cetColor: ColorSliderChangeEvent(Sender);
    cetValue: ValSliderChangeEvent(Sender);
  end;


end;

procedure TSharpEColorEditor.LabelClickEvent(Sender: TObject);
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
  tmpEdit.Anchors := [akRight,akTop];
  tmpEdit.MaxValue := 255;
  tmpEdit.MaxLength := 3;
  tmpEdit.Height := 20;
  tmpEdit.Text := IntToStr(TJvTrackBar(TLabel(Sender).Tag).Position);
  tmpEdit.SetFocus;
  tmpEdit.Tag := TLabel(Sender).Tag;
  tmpEdit.OnChange := SliderChangeEvent;
  tmpEdit.OnKeyUp := SpinEditKeyPressEvent;
end;

procedure TSharpEColorEditor.FreeAllSpinEdits(Sender:TObject=nil);
var
  i: Integer;
begin
  if ((FPages = nil) or (FPages.Pages[cPagDefineCol] = nil)) then exit;

  for i := 0 to Pred(FPages.Pages[cPagDefineCol].ControlCount) do
    if FPages.Pages[cPagDefineCol].Controls[i] is TJvSpinEdit then
      FPages.Pages[cPagDefineCol].Controls[i].Free;
end;

procedure TSharpEColorEditor.SliderMouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FreeAllSpinEdits;
end;

procedure TSharpEColorEditor.SpinEditKeyPressEvent(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then begin
    TJvSpinEdit(Sender).Hide;
  end;
end;

procedure TSharpEColorEditor.CaptionLabelClickEvent(Sender: TObject);
begin
  TabClickEvent(FTabs,FTabs.TabIndex);
end;

procedure TSharpEColorEditor.deselecttabs;
begin
  if FTabs <> nil then
    FTabs.TabIndex := -1;
end;

procedure TSharpEColorEditor.SliderEvents(AEnabled: Boolean);
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

procedure TSharpEColorEditor.SelectDefaultTab;
begin
  FTabs.TabIndex := 0;
end;

procedure TSharpEColorEditor.OverrideSliderUpdateMode(
  ASliderUpdateMode: TSliderUpdateMode);
begin
  FSliderUpdateMode := ASliderUpdateMode;
end;

procedure TSharpEColorEditor.AddSwatchEvent(ASender: TObject);
var
  sColorsFile:String;
begin
  if FSwatchManager <> nil then
    FSwatchManager.AddSwatch(FColorAsTColor,'');
end;

procedure TSharpEColorEditor.SetSwatchManager(
  const Value: TSharpESwatchManager);
begin
  FSwatchManager := Value;

  if Assigned(FSwatchManager) then begin
    FSharpESwatchCollection.SwatchManager := FSwatchManager;

    SwatchManager.OnGetWidth := GetWidth;
    SwatchManager.OnUpdateSwatchBitmap := UpdateSwatchBitmap;
    SwatchManager.Resize;
  end;
end;

procedure TSharpEColorEditor.GetWidth(ASender: TObject; var AWidth: Integer);
begin
  AWidth := FTabContainer.ClientWidth-24;
end;

procedure TSharpEColorEditor.UpdateSwatchBitmap(ASender:TObject;
  const ABitmap32:TBitmap32);
begin
  FSharpESwatchCollection.Image32.Height := ABitmap32.Height;
  FSharpESwatchCollection.Image32.Width := ABitmap32.Width;
  FSharpESwatchCollection.Image32.Bitmap := ABitmap32;
end;


procedure TSharpEColorEditor.ClickSwatchEvent(ASender: TObject; AColor: TColor);
begin
  ColorCode := AColor;
end;

function TSharpEColorEditor.GetExpandedHeight: Integer;
begin
  Result := FExpandedHeight;
end;

function TSharpEColorEditor.GetCollapseHeight: Integer;
begin
  Result := FCollapseHeight;
end;

procedure TSharpEColorEditor.SetColorEditorType(const Value: TColorEditorType);
begin
  FColorEditorType := Value;

  LockWindowUpdate(Self.Handle);
  Try
    ResizeEvent(nil);

  Finally
    LockWindowUpdate(0);
  End;
end;

procedure TSharpEColorEditor.SetValueMin(const Value: Integer);
begin
  FValueMin := Value;
end;

procedure TSharpEColorEditor.SetDescription(const Value: String);
begin
  FDescription := Value;

end;

procedure TSharpEColorEditor.SetValueMax(const Value: Integer);
begin
  FValueMax := Value;
end;

procedure TSharpEColorEditor.ColorSliderChangeEvent(Sender:TObject);
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

procedure TSharpEColorEditor.ValSliderChangeEvent(Sender: TObject);
var
  tmpSlider: TJvTrackBar;
  pos: Integer;
begin
  if (Sender is TJvSpinEdit) then begin
    tmpSlider := TJvTrackBar(TJvSpinEdit(Sender).Tag);
    pos := TJvSpinEdit(Sender).AsInteger;

    Value := pos;
  end;

  Value := FValueSlider.Position;
end;

procedure TSharpEColorEditor.SetValue(const Value: Integer);
begin
  FValue := Value;


  if FValueSlider <> nil then begin
    FValueSlider.Position := Value;
    TLabel(FValueSlider.Tag).Caption := IntToStr(Value);
  end;
end;

end.







