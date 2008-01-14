unit SharpEColorEditor;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  pngspeedbutton,
  ExtCtrls,
  pngimagelist,
  ComCtrls,
  JvComCtrls,
  StdCtrls,
  jvPageList,
  SharpECenterScheme,
  gr32,
  JvSpin,
  SharpFX,
  SharpThemeApi,
  SharpESwatchCollection,
  SharpESwatchManager,
  SharpERoundPanel,
  SharpETabList,
  SharpEColorPicker;

type
  TColorSliderUpdateMode = (sumAll, sumRGB, sumHSL);
  TValueEditorType = (vetColor, vetValue, vetBoolean);
type
  TValueChangeEvent = procedure(ASender: TObject; AValue: Integer) of
    object;

const
  cTabDefine = 0;
  cTabColSwatch = 1;

type
  TSharpEColorEditor = class(TCustomControl)
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
    FSliderUpdateMode: TColorSliderUpdateMode;
    FSCS: TSharpECenterScheme;

    FColDefinePage, FValDefinePage, FBoolDefinePage, FSwatchesPage: TJvStandardPage;
    FBoolCheckbox: TCheckBox;

    FExpanded: Boolean;
    FGroupIndex: Integer;
    FExpandedHeight: Integer;
    FCollapseHeight: Integer;
    FValueAsTColor: TColor;
    FCaption: string;
    FOnValueChange: TValueChangeEvent;
    FOnTabClick: TNotifyEvent;
    FSwatchManager: TSharpESwatchManager;
    FValueEditorType: TValueEditorType;
    FValueMin: Integer;
    FDescription: string;
    FValueMax: Integer;
    FValueText: string;
    FValue: Integer;
    FOnUiChange: TNotifyEvent;
    FVisible: boolean;

    procedure CreateControls(Sender: TObject);
    procedure SetExpanded(const Value: Boolean);
    procedure SetGroupIndex(const Value: Integer);

    function GetExpanded: Boolean;
    procedure TabClickEvent(ASender: TObject; const ATabIndex: Integer);
    procedure ColorClickEvent(ASender: TObject);
    procedure CheckClickEvent(ASender: TObject);
    procedure SetValueAsTColor(const Value: TColor);
    procedure LabelClickEvent(Sender: TObject);

    procedure PositionSlider(ASlider: TJvTrackBar; ACaption: string;
      ATextRect, ASliderRect, ASliderValRect: TRect; ARow: Integer; AParent:
      TWinControl;
      ALabelAnchors, ASliderAnchors: TAnchors);
    procedure LoadResources;
    procedure ResizeEvent(Sender: TObject);

    procedure ResizeDefineColsPage;
    procedure ResizeDefineValPage;
    procedure ResizeDefineBoolPage;

    procedure InitialiseColSliders;
    procedure SetCaption(const Value: string);
    procedure SliderChangeEvent(Sender: TObject);
    procedure SliderMouseDownEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CaptionLabelClickEvent(Sender: TObject);
    procedure FreeAllSpinEdits(Sender: TObject = nil);
    procedure SpinEditKeyPressEvent(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure SliderEvents(AEnabled: Boolean);

    procedure ClickSwatchEvent(ASender: TObject; AColor: TColor);
    procedure AddSwatchEvent(ASender: TObject);
    procedure SetSwatchManager(const Value: TSharpESwatchManager);

    procedure GetWidth(ASender: TObject; var
      AWidth: Integer);
    procedure UpdateSwatchBitmap(ASender: TObject; const ABitmap32: TBitmap32);
    function GetCollapseHeight: Integer;
    function GetExpandedHeight: Integer;
    procedure SetValueEditorType(const Value: TValueEditorType);
    procedure SetDescription(const Value: string);

    procedure ColorSliderChangeEvent(Sender: TObject);
    procedure ValSliderChangeEvent(Sender: TObject);

    procedure SetValue(const Value: Integer);
    procedure SetVisible(const Value: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnTabClick: TNotifyEvent read FOnTabClick write FOnTabClick;
    procedure SelectDefaultTab;
    procedure Collapse;
    function GetTabIndex: Integer;

    procedure OverrideSliderUpdateMode(ASliderUpdateMode:
      TColorSliderUpdateMode);
    property SwatchCollection: TSharpESwatchCollection read
      FSharpESwatchCollection write
      FSharpESwatchCollection;
  protected
    procedure DeSelectTabs;

  published
    property Align;
    property ParentColor;

    property CollapseHeight: Integer read GetCollapseHeight;
    property ExpandedHeight: Integer read GetExpandedHeight;
    property Expanded: Boolean read GetExpanded write SetExpanded;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property Caption: string read FCaption write SetCaption;

    property ValueAsTColor: TColor read FValueAsTColor write SetValueAsTColor;
    property ValueEditorType: TValueEditorType read FValueEditorType write
      SeTValueEditorType;

    property Description: string read FDescription write SetDescription;
    property ValueText: string read FValueText write FValueText;
    property Value: Integer read FValue write SetValue;

    property Visible: boolean read FVisible write SetVisible;

    property OnUiChange: TNotifyEvent read FOnUiChange write
      FOnUiChange;

    property OnValueChange: TValueChangeEvent read FOnValueChange write
      FOnValueChange;

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
  FValueEditorType := vetColor;
  FValueMin := 0;
  FValueMax := 255;
  FValueText := '';
  FVisible := True;

  CreateControls(nil);
end;

procedure TSharpEColorEditor.CreateControls(Sender: TObject);
var
  tmpPanel: TPanel;

  procedure AssignDefaultSliderProps(ASlider: TJvTrackBar);
  begin

    with ASlider do begin

      Parent := FTabContainer;
      DoubleBuffered := True;
      Frequency := 1;
      ShowRange := False;
      Ctl3D := False;
      DotNetHighlighting := False;
      TickStyle := tsNone;
      PageSize := 1;
      Visible := False;

      Min := 0;
      Max := 255;
      Height := 25;

      Color := FSCS.EditCol;

      OnChange := SliderChangeEvent;
      OnMouseDown := SliderMouseDownEvent;
      OnMouseUp := SliderMouseDownEvent;

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
  Self.ParentColor := False;
  Self.ParentBackground := false;

  // Create the tabs
  FTabs := TSharpETabList.Create(Self);
  with FTabs do begin
    Parent := Self;
    Anchors := [akRight, akTop, akLeft];

    TabAlign := taRightJustify;
    IconBounds := Rect(12, 3, 0, 0);
    TabWidth := 40;
    AutoSizeTabs := False;

    Top := 0;
    FTabs.Width := Self.Width;
    FTabs.Left := 0;
    Border := True;
    PngImageList := FPngImageList;

    BkgColor := clwindow;
    Color := clwindow;
    BorderColor := Color;
    TabSelectedColor := FSCS.EditTabSelCol;
    TabColor := clWindow;
    BorderColor := FSCS.EditTabBordCol;
    BorderSelectedColor := FSCS.EditTabBordCol;

    OnTabClick := TabClickEvent;
    FTabs.SendToBack;

    Add('', 0);
    Add('', 1);
  end;

  // Create the colour picker control
  FColorPicker := TSharpEColorPicker.Create(FTabs);
  with FColorPicker do begin
    Parent := FTabs;
    Anchors := [akRight, akTop];

    FColorPicker.Left := FTabs.Width - (FTabs.TabWidth * 2) -
      FTabs.IconBounds.Left + 2 - FColorPicker.Width;
    Top := 7;
    Height := 17;
    DoubleBuffered := False;

    BackgroundColor := clWindow;

    OnColorClick := ColorClickEvent;
    ParentBackground := False;
    ParentColor := False;
  end;

  tmpPanel := TPanel.Create(FTabs);
  with tmpPanel do begin
    tmpPanel.Parent := FTabs;
    tmpPanel.Anchors := [akRight, akTop];
    tmpPanel.Width := 20;
    tmpPanel.Height := FColorPicker.Height + 2;
    tmpPanel.Caption := '';
    tmpPanel.Left := FColorPicker.Left - tmpPanel.Width - 4;
    tmpPanel.OnClick := AddSwatchEvent;
    tmpPanel.BringToFront;
    tmpPanel.BevelInner := bvNone;
    tmpPanel.BevelOuter := bvNone;
    tmpPanel.ParentBackground := False;
    tmpPanel.ParentColor := False;
    tmpPanel.Color := clWindow;
    tmpPanel.Top := 5;
  end;

  FAddColorButton := TPngSpeedButton.Create(tmpPanel);
  with FAddColorButton do begin
    FAddColorButton.Parent := tmpPanel;
    FAddColorButton.Align := alClient;
    FAddColorButton.Flat := True;
    FAddColorButton.Width := 20;
    FAddColorButton.Height := FColorPicker.Height + 3;
    FAddColorButton.Caption := '';
    FAddColorButton.Left := FColorPicker.Left - FAddColorButton.Width - 4;
    FAddColorButton.OnClick := AddSwatchEvent;
    FAddColorButton.BringToFront;
    FAddColorButton.PngImage.LoadFromResourceName(HInstance,
      'COLOR_PANEL_ADD_PNG');
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
    Left := 0;
    Top := 0;
    Width := FAddColorButton.Left - 4;
    Height := FTabs.Height;

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

    Anchors := [akLeft, akTop, akRight, akBottom];

    DrawMode := srpNoTopRight;
    BorderWidth := 8;
    Border := True;

    FTabContainer.Top := FTabs.Height - 1;
    FTabContainer.Left := 0;
    FTabContainer.Height := Height - FTabs.Height;
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
  FColDefinePage := TJvStandardPage.Create(Self);
  with FColDefinePage do begin
    Parent := FPages;
    PageList := FPages;
    Caption := 'Colour Edit';
  end;

  // Create the sliders
  FHueSlider := TJvTrackBar.Create(FColDefinePage);
  AssignDefaultSliderProps(FHueSlider);

  FSatSlider := TJvTrackBar.Create(FColDefinePage);
  AssignDefaultSliderProps(FSatSlider);

  FLumSlider := TJvTrackBar.Create(FColDefinePage);
  AssignDefaultSliderProps(FLumSlider);

  FRedSlider := TJvTrackBar.Create(FColDefinePage);
  AssignDefaultSliderProps(FRedSlider);

  FGreenSlider := TJvTrackBar.Create(FColDefinePage);
  AssignDefaultSliderProps(FGreenSlider);

  FBlueSlider := TJvTrackBar.Create(FColDefinePage);
  AssignDefaultSliderProps(FBlueSlider);

  // Create the val define page
  FValDefinePage := TJvStandardPage.Create(Self);
  with FValDefinePage do begin
    Parent := FPages;
    PageList := FPages;
    Caption := 'Val Edit';
  end;

  FValueSlider := TJvTrackBar.Create(FValDefinePage);
  AssignDefaultSliderProps(FValueSlider);

  // Create the bool define page
  FBoolDefinePage := TJvStandardPage.Create(Self);
  with FBoolDefinePage do begin
    Parent := FPages;
    PageList := FPages;
    Caption := 'Bool Edit';
  end;

  FBoolCheckbox := TCheckBox.Create(FBoolDefinePage);
  with FBoolCheckbox do begin
    Parent := FBoolDefinePage;
    DoubleBuffered := True;
    FBoolCheckbox.Width := 100;
    FBoolCheckbox.OnClick := CheckClickEvent;
  end;

  // Create the swatches page
  FSwatchesPage := TJvStandardPage.Create(Self);
  with FSwatchesPage do begin
    PageList := FPages;
    BorderWidth := 4;
    Caption := 'Swatches';
    Color := FSCS.EditCol;
  end;

  FSharpESwatchCollection := TSharpESwatchCollection.Create(FSwatchesPage);
  with FSharpESwatchCollection do begin
    Align := alClient;
    Parent := FSwatchesPage;
    BorderStyle := bsNone;
    ParentBackground := False;
    DoubleBuffered := True;

    OnDblClickSwatch := ClickSwatchEvent;
  end;

  // Set the default page
  FColDefinePage.Show;
  FTabs.TabIndex := -1;
  FVisible := True;
  Visible := FVisible;

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
  i: Integer;
  tmp: TSharpEColorEditor;
begin
  if FExpanded = Value then
    exit;

  FExpanded := Value;
  try

    if Self.GroupIndex <> 0 then begin

      for i := 0 to Pred(Owner.ComponentCount) do begin
        if Owner.Components[i].ClassType = TSharpEColorEditor then begin
          tmp := TSharpEColorEditor(Owner.Components[i]);

          if not (tmp.Visible) then
            tmp.Height := 0
          else
            tmp.Collapse;

          if ((tmp <> nil) and (tmp <> self) and (tmp.GroupIndex =
            Self.GroupIndex)) then
            if not (tmp.Visible) then
              tmp.Height := 0
            else
              tmp.Height := FCollapseHeight;

        end;
      end;

      if not (FVisible) then
        Self.Height := 0
      else
        Self.Height := FExpandedHeight;

      FTabs.TabIndex := cTabDefine;

    end
    else begin
      if Value then begin
        if not (FVisible) then
          Self.Height := 0
        else
          Self.Height := FExpandedHeight;
        FTabs.TabIndex := cTabDefine;
      end
      else begin
        if not (FVisible) then
          Self.Height := 0
        else
          Self.Height := FCollapseHeight;

        FTabs.TabIndex := -1;
      end;
    end;

  except
  end;
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

procedure TSharpEColorEditor.TabClickEvent(ASender: TObject; const ATabIndex:
  Integer);
begin

  if ATabIndex = 0 then begin
    FSliderUpdateMode := sumAll;
    InitialiseColSliders;

    case FValueEditorType of
      vetColor: FColDefinePage.Show;
      vetValue: FValDefinePage.Show;
      vetBoolean: FBoolDefinePage.Show;
    end;

  end
  else if ATabIndex = 1 then begin
    FSwatchesPage.Show;
  end;

  FTabs.TabIndex := ATabIndex;
  if Assigned(FOnTabClick) then
    FOnTabClick(Self)
  else
    Expanded := True;

end;

procedure TSharpEColorEditor.ColorClickEvent(ASender: TObject);
begin
  Value := FColorPicker.ColorCode;

  if Assigned(FOnUiChange) then
    FOnUiChange(Self);
end;

procedure TSharpEColorEditor.SetValueAsTColor(const Value: TColor);
begin
  if FValue = Value then
    exit;

  Self.Value := Value;
end;

procedure TSharpEColorEditor.PositionSlider(ASlider: TJvTrackBar; ACaption:
  string;
  ATextRect, ASliderRect, ASliderValRect: TRect; ARow: Integer; AParent:
  TWinControl;
  ALabelAnchors, ASliderAnchors: TAnchors);
var
  lbl: TLabel;
begin

  // Position the slider
  with ASlider do begin
    Parent := AParent;
    Left := ASliderRect.Left;
    Top := ASliderRect.Top + (ASlider.Height * ARow);
    Width := ASliderRect.Right - ASliderRect.Left;
    Anchors := ASliderAnchors;
    Visible := True;
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
    Top := ASlider.Top - 5;
    Left := ATextRect.Left;
    Width := ATextRect.Right - ATextRect.Left;

    Color := FSCS.EditCol;
  end;

  // Create the slider value text
  lbl := TLabel.Create(AParent);
  with lbl do begin
    Parent := AParent;
    Tag := Integer(ASlider);

    Anchors := ALabelAnchors;

    if ASlider <> FValueSlider then
      Caption := ACaption
    else
      Caption := IntToStr(FValue);

    AutoSize := False;
    Transparent := False;
    Alignment := taLeftJustify;
    Layout := tlCenter;

    Height := 30;
    Top := ASlider.Top - 5;
    Left := ASliderValRect.Left;
    Width := ASliderValRect.Right - ASliderValRect.Left;

    Color := FSCS.EditCol;
    Font.Color := Darker(FScS.EditCol, 35);

    OnClick := LabelClickEvent;
  end;

  ASlider.Tag := Integer(lbl);

end;

procedure TSharpEColorEditor.LoadResources;
var
  png: TPngImageCollectionItem;
begin
  FPngImageList := TPngImageList.Create(Self);
  png := FPngImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'COLOR_PANEL_GEAR_PNG');
  png := FPngImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'COLOR_PANEL_HEART_PNG');
  png := FPngImageList.PngImages.Add();
  png.PngImage.LoadFromResourceName(HInstance, 'COLOR_PANEL_HEART_PNG');
end;

procedure TSharpEColorEditor.ResizeEvent(Sender: TObject);
begin
  case FValueEditorType of
    vetColor: ResizeDefineColsPage;
    vetValue: ResizeDefineValPage;
    vetBoolean: ResizeDefineBoolPage;
  end;

  FreeAllSpinEdits;
end;

procedure TSharpEColorEditor.ResizeDefineColsPage;
var
  tmpTab: TJvcustomPage;
  iWidthLT, iWidthVal, iSliderWidth, iSpacer, iY, n: Integer;
  rLeftSlider, rLeftSliderVal, rRightSlider, rRightSliderVal, rLeftText,
    rRightText: TRect;
begin

  // Set Tab Container Height
  n := Self.Height - FTabs.Height + 1;
  if n <> FTabContainer.Height then
    FTabContainer.Height := n;

  // Set Tab Container Width
  if FTabContainer.Width <> Self.Width then
    FTabContainer.Width := Self.Width;

  // Set TabList width
  if FTabs.Width <> Self.Width then
    FTabs.Width := Self.Width;

  // Show color picker
  if not (FColorPicker.Visible) then
    FColorPicker.Show;

  // Show add color button?
  FAddColorButton.Visible := FExpanded;

  // Show swatch tab
  if not (FTabs.TabList.Item[cTabColSwatch].Visible) then
    FTabs.TabList.Item[cTabColSwatch].Visible := True;

  // Free all existing labels
  for n := Pred(FColDefinePage.ControlCount) downto 0 do
    if FColDefinePage.Controls[n] is TLabel then
      FColDefinePage.Controls[n].Free;

  // Set default tab to color definition page
  tmptab := FColDefinePage;
  iSpacer := 12;
  iWidthLT := Self.Canvas.TextWidth('Green:X');
  iWidthVal := Self.Canvas.TextWidth('XXXXXXX');
  iSliderWidth := (tmpTab.Width - (iWidthLT * 2) - (iWidthVal * 2) +
    (iSpacer)) div 2;

  iY := iSpacer;

  rLeftText := Rect(iSpacer, iSpacer, iWidthLT, iY + 10);
  rLeftSlider := Rect(rLeftText.Right, iY, rLeftText.Right + iSliderWidth, iY +
    10);
  rLeftSliderVal := Rect(rLeftSlider.Right, iY, rLeftSlider.Right + iWidthVal, iy
    + 10);

  rRightText := Rect(rLeftSliderVal.Right + 4, iY, rLeftSliderVal.Right +
    iWidthLT, iY + 10);
  rRightSlider := Rect(rRightText.Right, iY, rRightText.Right - iSpacer +
    iSliderWidth, iY + 10);
  rRightSliderVal := Rect(rRightSlider.Right, iY, Self.Width - iSpacer - 4, iY +
    10);

  PositionSlider(FHueSlider, 'Hue:', rLeftText, rLeftSlider, rLeftSliderVal, 0,
    tmpTab, [akLeft, akTop], [akTop, akLeft, akRight]);

  PositionSlider(FSatSlider, 'Sat:', rLeftText, rLeftSlider, rLeftSliderVal, 1,
    tmpTab, [akLeft, akTop], [akTop, akLeft, akRight]);

  PositionSlider(FLumSlider, 'Lum:', rLeftText, rLeftSlider, rLeftSliderVal, 2,
    tmpTab, [akLeft, akTop], [akTop, akLeft, akRight]);

  PositionSlider(FRedSlider, 'Red:', rRightText, rRightSlider, rRightSliderVal,
    0, tmpTab, [akRight, akTop], [akTop, akRight]);

  PositionSlider(FGreenSlider, 'Green:', rRightText, rRightSlider,
    rRightSliderVal, 1, tmpTab, [akRight, akTop, akRight], [akTop, akRight]);

  PositionSlider(FBlueSlider, 'Blue:', rRightText, rRightSlider,
    rRightSliderVal, 2, tmpTab, [akRight, akTop, akRight], [akTop, akRight]);

  FSliderUpdateMode := sumAll;
  InitialiseColSliders;
end;

procedure TSharpEColorEditor.ResizeDefineValPage;
var
  tmpTab: TJvcustomPage;
  tmpLbl: TLabel;
  iWidthLT, iWidthVal, iSliderWidth, iSpacer, iY, n: Integer;
  rLeftSlider, rLeftSliderVal, rLeftText: TRect;

begin

  FTabContainer.Height := Self.Height - FTabs.Height + 1;
  FTabContainer.Width := Self.Width;
  FTabs.Width := Self.Width;
  FColorPicker.Hide;
  FAddColorButton.Hide;
  FTabs.TabList.Item[1].Visible := False;

  for n := Pred(FValDefinePage.ControlCount) downto 0 do
    if FValDefinePage.Controls[n] is TLabel then
      FValDefinePage.Controls[n].Free;

  tmptab := FValDefinePage;
  iSpacer := 12;
  Self.Canvas.Font.Assign(Self.Font);
  iWidthLT := Self.Canvas.TextWidth(FValueText + ':XX');
  iWidthVal := Self.Canvas.TextWidth('XXXXXXX');
  iSliderWidth := (tmpTab.Width - (iWidthVal * 2));

  // Create value description label
  if FDescription <> '' then begin
    tmpLbl := TLabel.Create(tmpTab);
    with tmpLbl do begin
      Parent := tmpTab;
      Font.Assign(Self.Font);
      Top := iSpacer;
      Left := iSpacer;
      Width := tmpTab.Width - iSpacer;
      Caption := FDescription;
    end;
    iY := (iSpacer * 2) + Self.Canvas.TextHeight(FDescription);
  end
  else
    iY := iSpacer;

  rLeftText := Rect(iSpacer, iSpacer, iWidthLT {+iSpacer}, iY + 10);
  rLeftSlider := Rect(rLeftText.Right {+iSpacer}, iY, rLeftText.Right +
    iSliderWidth {+iSpacer}, iY + 10);
  rLeftSliderVal := Rect(rLeftSlider.Right {+iSpacer}, iY, rLeftSlider.Right +
    {+iSpacer+}iWidthVal, iy + 10);

  PositionSlider(FValueSlider, FValueText + ':', rLeftText, rLeftSlider,
    rLeftSliderVal, 0, tmpTab, [akLeft, akTop],
    [akTop, akLeft, akRight]);

  SetValue(FValue);
end;

procedure TSharpEColorEditor.InitialiseColSliders;
var
  col: TColor;
  r, g, b: integer;
  h, s, l: byte;
  rgb: integer;

  procedure UpdateHSLLabel;
  begin
    TLabel(FHueSlider.Tag).Caption := Format('%d', [FHueSlider.Position]);
    TLabel(FSatSlider.Tag).Caption := Format('%d', [FSatSlider.Position]);
    TLabel(FLumSlider.Tag).Caption := Format('%d', [FLumSlider.Position]);
  end;

  procedure UpdateRGBLabel;
  begin
    TLabel(FRedSlider.Tag).Caption := Format('%d', [FRedSlider.Position]);
    TLabel(FGreenSlider.Tag).Caption := Format('%d', [FGreenSlider.Position]);
    TLabel(FBlueSlider.Tag).Caption := Format('%d', [FBlueSlider.Position]);
  end;

  procedure UpdateLabels;
  begin
    UpdateRGBLabel;
    UpdateHSLLabel;
  end;
begin

  if FValue < 0 then
    col := SchemeCodeToColor(FValue)
  else
    col := FValue;

  if col < 0 then
    col := 0;

  rgb := col;

  r := GetRValue(rgb);
  b := GetBValue(rgb);
  g := GetGValue(rgb);
  RGBtoHSL(rgb, h, s, l);

  // RGB
  if ((FRedSlider <> nil) and ((FSliderUpdateMode = sumRGB) or (FSliderUpdateMode
    = sumAll))) then begin
    FRedSlider.Position := r;
  end;

  if ((FGreenSlider <> nil) and ((FSliderUpdateMode = sumRGB) or
    (FSliderUpdateMode = sumAll))) then begin
    FGreenSlider.Position := g;
  end;

  if ((FBlueSlider <> nil) and ((FSliderUpdateMode = sumRGB) or
    (FSliderUpdateMode = sumAll))) then begin
    FBlueSlider.Position := b;
  end;

  // HSL
  if ((FHueSlider <> nil) and ((FSliderUpdateMode = sumHSL) or (FSliderUpdateMode
    = sumAll))) then begin
    FHueSlider.Position := h;
  end;

  if ((FSatSlider <> nil) and ((FSliderUpdateMode = sumHSL) or (FSliderUpdateMode
    = sumAll))) then begin
    FSatSlider.Position := s;
  end;

  if ((FHueSlider <> nil) and ((FSliderUpdateMode = sumHSL) or (FSliderUpdateMode
    = sumAll))) then begin
    FLumSlider.Position := l;
  end;

  if FTabContainer <> nil then
    UpdateLabels;

end;

procedure TSharpEColorEditor.SetCaption(const Value: string);
begin
  //if FCaption = Value then
  //  exit;

  FCaption := Value;

  if FNameLabel <> nil then begin

    case FValueEditorType of
      vetColor: begin
          FNameLabel.Caption := Format('%s (%s):', [FCaption, 'Color']);
        end;
      vetValue: begin
          FNameLabel.Caption := Format('%s (%s):', [FCaption, 'Val']);
        end;
      vetBoolean: begin
          FNameLabel.Caption := Format('%s (%s):', [FCaption, 'Bool']);
        end;
    end;
  end;

  if (FNameLabel <> nil) then begin
    if (FCaption = '') then
      FNameLabel.Hide
    else
      FNameLabel.Show;
  end
end;

procedure TSharpEColorEditor.SliderChangeEvent(Sender: TObject);
begin

  case FValueEditorType of
    vetColor: ColorSliderChangeEvent(Sender);
    vetValue: ValSliderChangeEvent(Sender);
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
  tmpEdit.Top := TLabel(Sender).Top + 6;
  tmpEdit.Width := TLabel(Sender).Width;
  tmpEdit.Anchors := [akRight, akTop];
  tmpEdit.MaxValue := 255;
  tmpEdit.MaxLength := 3;
  tmpEdit.Height := 20;
  tmpEdit.Text := IntToStr(TJvTrackBar(TLabel(Sender).Tag).Position);
  tmpEdit.SetFocus;
  tmpEdit.Tag := TLabel(Sender).Tag;
  tmpEdit.OnChange := SliderChangeEvent;
  tmpEdit.OnKeyUp := SpinEditKeyPressEvent;
end;

procedure TSharpEColorEditor.FreeAllSpinEdits(Sender: TObject = nil);
var
  i: Integer;
  tmpCtrl: TWinControl;
begin
  if (FPages = nil) then
    exit;

  if FValueEditorType = vetColor then
    tmpCtrl := FColDefinePage
  else
    tmpCtrl := FValDefinePage;

  for i := 0 to Pred(tmpCtrl.ControlCount) do
    if tmpCtrl.Controls[i] is TJvSpinEdit then
      tmpCtrl.Controls[i].Free;
end;

procedure TSharpEColorEditor.SliderMouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FreeAllSpinEdits;

  if Assigned(FOnUiChange) then
    FOnUiChange(Self);

end;

procedure TSharpEColorEditor.SpinEditKeyPressEvent(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then begin
    TJvSpinEdit(Sender).Hide;
  end;

  if Assigned(FOnUiChange) then
    FOnUiChange(Self);
end;

procedure TSharpEColorEditor.CaptionLabelClickEvent(Sender: TObject);
begin
  TabClickEvent(FTabs, FTabs.TabIndex);
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
  end
  else begin
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
  if FTabs.TabIndex <> 0 then
    FTabs.TabIndex := 0;
end;

procedure TSharpEColorEditor.OverrideSliderUpdateMode(
  ASliderUpdateMode: TColorSliderUpdateMode);
begin
  FSliderUpdateMode := ASliderUpdateMode;
end;

procedure TSharpEColorEditor.AddSwatchEvent(ASender: TObject);
begin
  if FSwatchManager <> nil then
    FSwatchManager.AddSwatch(FValueAsTColor, '');
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
  AWidth := FTabContainer.Width - 24;
end;

procedure TSharpEColorEditor.UpdateSwatchBitmap(ASender: TObject;
  const ABitmap32: TBitmap32);
begin
  FSharpESwatchCollection.Image32.Height := ABitmap32.Height;
  FSharpESwatchCollection.Image32.Width := ABitmap32.Width;
  FSharpESwatchCollection.Image32.Bitmap := ABitmap32;
end;

procedure TSharpEColorEditor.ClickSwatchEvent(ASender: TObject; AColor: TColor);
begin
  Value := AColor;

  if Assigned(FOnUiChange) then
    FOnUiChange(Self);
end;

function TSharpEColorEditor.GetExpandedHeight: Integer;
begin
  Result := FExpandedHeight;
end;

function TSharpEColorEditor.GetCollapseHeight: Integer;
begin
  Result := FCollapseHeight;
end;

procedure TSharpEColorEditor.SetValueEditorType(const Value: TValueEditorType);
begin

  FValueEditorType := Value;
  case FValueEditorType of
    vetColor: begin
        FColDefinePage.Show;
      end;
    vetValue: begin
        if ((FValue < 0) or (FValue > 255)) then
          FValue := 0;
        FValDefinePage.Show;
      end;
    vetBoolean: begin
        if ((FValue < -1) or (FValue > 0)) then
          FValue := 1;
        FBoolDefinePage.Show;
      end;
  end;

  if FTabs.TabIndex <> -1 then
    FTabs.TabIndex := 0;

  ResizeEvent(nil);
end;

procedure TSharpEColorEditor.SetDescription(const Value: string);
begin
  FDescription := Value;
  ResizeEvent(nil);
end;

procedure TSharpEColorEditor.ColorSliderChangeEvent(Sender: TObject);
var
  r, g, b, h, s, l: byte;
  tmpSlider: TJvTrackBar;
  pos: Integer;
begin
  SliderEvents(False);

  if (Sender is TJvSpinEdit) then begin
    tmpSlider := TJvTrackBar(TJvSpinEdit(Sender).Tag);
    pos := TJvSpinEdit(Sender).AsInteger;

    if tmpSlider = FRedSlider then
      Sender := FRedSlider
    else if tmpSlider = FBlueSlider then
      Sender := FBlueSlider
    else if tmpSlider = FGreenSlider then
      Sender := FGreenSlider;
    if tmpSlider = FHueSlider then
      Sender := FHueSlider
    else if tmpSlider = FSatSlider then
      Sender := FSatSlider
    else if tmpSlider = FLumSlider then
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
    Value := RGB(r, g, b);

  end
  else begin
    //Color32ToRGB(HSLtoRGB(h, s, l), r, g, b);

    Value := HSLtoRGB(h,s,l);

    FSliderUpdateMode := sumRGB;
    //Value := RGB(r, g, b);

  end;

  SliderEvents(True);
end;

procedure TSharpEColorEditor.ValSliderChangeEvent(Sender: TObject);
var
  pos: Integer;
begin
  if (Sender is TJvSpinEdit) then begin
    pos := TJvSpinEdit(Sender).AsInteger;

    Value := pos;
  end;

  Value := FValueSlider.Position;
end;

procedure TSharpEColorEditor.SetValue(const Value: Integer);
begin

  FValue := Value;

  case FValueEditorType of
    vetColor: begin
        SliderEvents(False);
        try

          FValue := ColorToSchemeCode(Value);
          FValueAsTColor := SchemeCodeToColor(Value);

          if FColorPicker <> nil then
            FColorPicker.ColorCode := FValue;

          FSliderUpdateMode := sumAll;
          InitialiseColSliders;

        finally
          SliderEvents(True);
        end;
      end;
    vetValue: begin
        if FValueSlider <> nil then begin
          FValueSlider.Position := FValue;
          TLabel(FValueSlider.Tag).Caption := IntToStr(FValue);
        end;
      end;
    vetBoolean: begin
        if FBoolCheckbox <> nil then begin
          FBoolCheckbox.Checked := StrToBool(IntToStr(FValue));
          if FBoolCheckbox.Checked then
            FBoolCheckbox.Caption := 'Enabled'
          else
            FBoolCheckbox.Caption := 'Disabled';
        end;
      end;
  end;

  if Assigned(FOnValueChange) then
    FOnValueChange(Self, FValue);
end;

procedure TSharpEColorEditor.SetVisible(const Value: boolean);
begin
  if FVisible = Value then
    exit;

  FVisible := Value;

  if not (FVisible) then
    Self.Height := 0
  else begin
    if FExpanded then
      self.Height := FExpandedHeight
    else
      Self.Height := FCollapseHeight;

  end;
end;

procedure TSharpEColorEditor.ResizeDefineBoolPage;
var
  tmpTab: TJvcustomPage;
  tmpLbl: TLabel;
  iSpacer, iY, n: Integer;

begin

  FTabContainer.Height := Self.Height - FTabs.Height + 1;
  FTabContainer.Width := Self.Width;
  FTabs.Width := Self.Width;
  FColorPicker.Hide;
  FAddColorButton.Hide;
  FTabs.TabList.Item[1].Visible := False;

  for n := Pred(FBoolDefinePage.ControlCount) downto 0 do
    if FBoolDefinePage.Controls[n] is TLabel then
      FBoolDefinePage.Controls[n].Free;

  tmptab := FBoolDefinePage;
  iSpacer := 12;
  Self.Canvas.Font.Assign(Self.Font);

  // Create value description label
  if FDescription <> '' then begin
    tmpLbl := TLabel.Create(tmpTab);
    with tmpLbl do begin
      Parent := tmpTab;
      Font.Assign(Self.Font);
      Top := iSpacer;
      Left := iSpacer;
      Width := tmpTab.Width - iSpacer;
      Caption := FDescription;
    end;
    iY := (iSpacer * 2) + Self.Canvas.TextHeight(FDescription);
  end
  else
    iY := iSpacer;

  FBoolCheckbox.Left := iSpacer;
  FBoolCheckbox.Top := iy;

  SetValue(FValue);
end;

procedure TSharpEColorEditor.CheckClickEvent(ASender: TObject);
begin
  Value := StrToInt(BoolToStr(FBoolCheckbox.Checked));

  if Assigned(FOnUiChange) then
    FOnUiChange(Self);
end;

function TSharpEColorEditor.GetTabIndex: Integer;
begin
  Result := -1;

  if FTabs <> nil then
    Result := FTabs.TabIndex;
end;

end.

