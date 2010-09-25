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
  ExtCtrls,
  ComCtrls,
  StdCtrls,

  // 3rd Party
  pngimagelist,
  pngspeedbutton,
  JvComCtrls,
  JvXPCore,
  JvXPCheckCtrls,
  gr32,


  // SharpE Units
  SharpFX,
  SharpThemeApiEx,
  uThemeConsts,
  uISharpETheme,
  SharpESwatchCollection,
  SharpESwatchManager,
  SharpERoundPanel,
  SharpETabList,
  SharpEColorPicker,
  SharpEPageControl;

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
  TSharpEColorEditor = class(TCustomPanel)
  private
    FTabs: TSharpETabList;
    FColorPicker: TSharpEColorPicker;
    FAddColorButton: TPngSpeedButton;
    FPngImageList: TPngImageList;
    //FPages: TPageControl;
    FNameLabel: TPanel;
    FHueSlider, FSatSlider, FLumSlider: TJvTrackBar;
    FRedSlider, FGreenSlider, FBlueSlider: TJvTrackBar;
    FValueSlider: TJvTrackBar;
    FSharpESwatchCollection: TSharpESwatchCollection;
    FSliderUpdateMode: TColorSliderUpdateMode;

    FColDefinePage, FValDefinePage, FBoolDefinePage, FSwatchesPage: TPanel;
    FBoolCheckbox: TJvXpCheckBox;

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
    FDisplayPercent: boolean;
    FBorderColor: TColor;
    FBackgroundTextColor: TColor;
    FBackgroundColor: TColor;
    FPageControl: TSharpEPageControl;
    FControlsCreated: Boolean;
    FPanel: TPanel;

    FContainerTextColor: TColor;
    FContainerColor: TColor;

    procedure CreateControls;
    procedure SetExpanded(const Value: Boolean);
    procedure SetGroupIndex(const Value: Integer);

    function GetExpanded: Boolean;
    procedure TabClickEvent(ASender: TObject; const ATabIndex: Integer);
    procedure ColorClickEvent(ASender: TObject);
    procedure CheckClickEvent(ASender: TObject);
    procedure SetValueAsTColor(const Value: TColor);


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
    procedure SetDisplayPercent(const Value: boolean);
    procedure SetValueMax(const Value: Integer);
    procedure SetValueMin(const Value: Integer);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetBackgroundTextColor(const Value: TColor);
    procedure UpdatePageVisibility(const ATabIndex: Integer);
    procedure SetBorderColor(const Value: TColor);

    procedure SetContainerColor(const Value: TColor);
    procedure SetContainerTextColor(const Value: TColor);
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

    property DisplayPercent: boolean read FDisplayPercent write
      SetDisplayPercent;

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
    property ValueMin: Integer read FValueMin write SetValueMin;
    property ValueMax: Integer read FValueMax write SetValueMax;

    property Visible: boolean read FVisible write SetVisible;

    property OnUiChange: TNotifyEvent read FOnUiChange write
      FOnUiChange;

    property OnValueChange: TValueChangeEvent read FOnValueChange write
      FOnValueChange;

    property SwatchManager: TSharpESwatchManager read FSwatchManager write
      SetSwatchManager;

    property Font;

    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BackgroundColor : TColor read FBackgroundColor write SetBackgroundColor;
    property BackgroundTextColor : TColor read FBackgroundTextColor write SetBackgroundTextColor;
    property ContainerColor: TColor read FContainerColor write SetContainerColor;
    property ContainerTextColor: TColor read FContainerTextColor write SetContainerTextColor;

    procedure RefreshTheme;
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
  Parent := TWinControl(AOwner);

  FBackgroundTextColor := clBlack;
  FBackgroundColor := clWhite;
  FBorderColor := $00FEF7F1;
  FContainerTextColor := clBlack;
  FContainerColor := clWhite;

  Self.Height := 135;
  Self.Width := 200;
  FCollapseHeight := 24;
  FExpandedHeight := 135;
  FValueEditorType := vetColor;
  FValueMin := 0;
  FValueMax := 255;
  FValueText := '';
  FVisible := True;
  CreateControls;
end;

procedure TSharpEColorEditor.CreateControls;

  procedure AssignDefaultSliderProps(ASlider: TJvTrackBar);
  begin

    with ASlider do begin

      Top := 1000;
      Parent := FPageControl;
      Frequency := 1;
      ShowRange := False;
      Ctl3D := False;
      DotNetHighlighting := False;
      TickStyle := tsNone;
      PageSize := 1;
      Visible := False;
      DoubleBuffered := True;

      Min := 0;
      Max := 255;
      Height := 25;

      Color := FBackgroundColor;
      Font.Color := FBackgroundTextColor;

      OnChange := SliderChangeEvent;
      OnMouseDown := SliderMouseDownEvent;
      OnMouseUp := SliderMouseDownEvent;

    end;
  end;
begin

  // Load the image resource files
  FControlsCreated := False;
  try
  LoadResources;

  Self.BorderWidth := 0;
  Self.ParentBackground := False;
  Self.DoubleBuffered := False;
  Self.BevelInner := bvNone;
  Self.BevelOuter := bvNone;

  // Create Page Control
  FPageControl := TSharpEPageControl.Create(Self);
  with FPageControl do begin
    Parent := Self;

    TabList.Add('', 0);
    TabList.Add('', 1);
    Align := alClient;

    TabList.TabAlign := taRightJustify;
    TabList.IconSpacingX := 4;
    TabList.IconSpacingY := 4;
    TabList.AutoSizeTabs := False;

    TabList.Border := True;
    TabList.PngImageList := FPngImageList;

    TabList.BkgColor := self.Color;
    FPageControl.Color := FBackgroundColor;
    BackgroundColor := Self.Color;
    BackgroundTextColor := FBackgroundTextColor;
    Border := True;
    BorderColor := FBackgroundColor;

    TabList.TabSelectedColor := FContainerColor;
    TabList.TabColor := FContainerColor;
    TabList.BorderColor := self.Color;
    TabList.BorderSelectedColor := FContainerColor;
    TabList.Border := True;

    OnTabClick := TabClickEvent;
    FTabs := TabList;
  end;

  // Create the colour picker control
  FColorPicker := TSharpEColorPicker.Create(FTabs);
  with FColorPicker do begin
    Parent := FTabs;
    Anchors := [akRight, akTop];
    name := 'FColorPicker';

    FColorPicker.Left := FTabs.Width - 100;
    Top := 7;
    Height := 17;

    BackgroundColor := self.Color;

    OnColorClick := ColorClickEvent;
    ParentBackground := False;
    DoubleBuffered := True;
    ParentColor := True;
  end;

  FPanel := TPanel.Create(FTabs);
    FPanel.Anchors := [akRight, akTop];
    FPanel.Width := 20;
    FPanel.Height := FColorPicker.Height + 2;
    FPanel.Caption := '';
    FPanel.Left := FColorPicker.Left - FPanel.Width - 4;
    FPanel.Parent := FTabs;
    FPanel.OnClick := AddSwatchEvent;
    FPanel.BevelInner := bvNone;
    FPanel.BevelOuter := bvNone;
    FPanel.ParentBackground := false;
    FPanel.DoubleBuffered := true;
    FPanel.ParentColor := False;
    FPanel.Color := self.Color;
    FPanel.Top := 5;

  FAddColorButton := TPngSpeedButton.Create(FPanel);
  with FAddColorButton do begin
    FAddColorButton.Parent := FPanel;
    FAddColorButton.Align := alClient;
    FAddColorButton.Flat := True;
    FAddColorButton.Width := 20;
    FAddColorButton.Height := FColorPicker.Height + 3;
    FAddColorButton.Caption := '';
    FAddColorButton.Left := FColorPicker.Left - FAddColorButton.Width - 4;
    FAddColorButton.OnClick := AddSwatchEvent;
    FAddColorButton.PngImage.LoadFromResourceName(HInstance,
      'COLOR_PANEL_ADD_PNG');
    FAddColorButton.Top := 5;
  end;

  // Create the name panel control
  FNameLabel := TPanel.Create(FTabs);
  with FNameLabel do begin
    Parent := FTabs;
    name := 'fnamelabel';
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
    Height := FTabs.Height-2;

    ParentColor := False;
    ParentBackground := False;
    DoubleBuffered := True;

    FNameLabel.ParentFont := True;
    Color := self.Color;
    Font.Color := Self.Font.Color;

    OnClick := CaptionLabelClickEvent;
  end;

  FColDefinePage := TPanel.Create(FPageControl);
  with FColDefinePage do begin
    Parent := FPageControl;
    FColDefinePage.Color := BackgroundColor;
    FColDefinePage.DoubleBuffered := true;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    ParentBackground := false;
    FColDefinePage.color := FBackgroundColor;
    Caption := '';

    Top := 0;
    Left := 0;
    Height := Height - FTabs.Height;
    Width := Self.Width;

    Anchors := [akLeft, akTop, akRight, akBottom];
    Visible := False;
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

  FValDefinePage := TPanel.Create(FPageControl);
  with FValDefinePage do begin
    Parent := FPageControl;
    ParentBackground := false;
    DoubleBuffered := true;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    color := FBackgroundColor;
    Caption := '';

    Top := 0;
    Left := 0;
    Height := Height - FTabs.Height;
    Width := Self.Width;

    Anchors := [akLeft, akTop, akRight, akBottom];
    Visible := False;
  end;

  FValueSlider := TJvTrackBar.Create(FValDefinePage);
  AssignDefaultSliderProps(FValueSlider);

  FBoolDefinePage := TPanel.Create(FPageControl);
  with FBoolDefinePage do begin
    Parent := FPageControl;
    ParentBackground := false;
    DoubleBuffered := true;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    color := FBackgroundColor;
    Caption := '';

    Top := 0;
    Left := 0;
    Height := Height - FTabs.Height;
    Width := Self.Width;

    Anchors := [akLeft, akTop, akRight, akBottom];
    Visible := False;
  end;

  FBoolCheckbox := TJvXPCheckbox.Create(FBoolDefinePage);
  with FBoolCheckbox do begin
    Parent := FBoolDefinePage;
    Font.Color := FBackgroundTextColor;
    Color := FBackgroundColor;
    FBoolCheckbox.Width := 100;
    OnClick := CheckClickEvent;
    FBoolCheckbox.DoubleBuffered := True;
  end;

  FSwatchesPage := TPanel.Create(FPageControl);
  with FSwatchesPage do begin
    Parent := FPageControl;
    ParentBackground := false;
    DoubleBuffered := true;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    color := FBackgroundColor;
    Caption := '';

    Top := 0;
    Left := 0;
    Height := Height - FTabs.Height;
    Width := Self.Width;

    Anchors := [akLeft, akTop, akRight, akBottom];
    Visible := False;
  end;

  FSharpESwatchCollection := TSharpESwatchCollection.Create(FSwatchesPage);
  with FSharpESwatchCollection do begin
    Align := alClient;
    Parent := FSwatchesPage;
    BorderStyle := bsNone;
    FSharpESwatchCollection.Color := FBackgroundColor;
    OnDblClickSwatch := ClickSwatchEvent;
    DoubleBuffered := True;
    ParentBackground := False;
  end;

  FTabs.TabIndex := -1;
  Self.OnResize := ResizeEvent;
  finally
    FControlsCreated := True;
    RefreshTheme;
  end;
end;

destructor TSharpEColorEditor.Destroy;
begin
  FColorPicker.Free;
  FAddColorButton.Free;
  FNameLabel.Free;
  FHueSlider.Free;
  FSatSlider.Free;
  FLumSlider.Free;
  FRedSlider.Free;
  FGreenSlider.Free;
  FBlueSlider.Free;
  FValueSlider.Free;
  FBoolCheckbox.Free;
  FSharpESwatchCollection.Free;
  FSwatchesPage.Free;  
  FBoolDefinePage.Free;
  FValDefinePage.Free;
  FColDefinePage.Free;
  FPanel.Free;
  FPageControl.Free;

  inherited Destroy;
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
end;

function TSharpEColorEditor.GetExpanded: Boolean;
begin
  Result := FExpanded;

end;

procedure TSharpEColorEditor.TabClickEvent(ASender: TObject; const ATabIndex:
  Integer);
begin
  UpdatePageVisibility(ATabIndex);
  if Assigned(FOnTabClick) then
    FOnTabClick(Self)
  else
    Expanded := True;

  FTabs.TabIndex := ATabIndex;

end;

procedure TSharpEColorEditor.ColorClickEvent(ASender: TObject);
begin
  Value := FColorPicker.Color;

  FSliderUpdateMode := sumAll;

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
    Transparent := True;
    Alignment := taLeftJustify;
    Layout := tlCenter;

    Height := 30;
    Top := ASlider.Top - 5;
    Left := ATextRect.Left;
    Width := ATextRect.Right - ATextRect.Left;

    lbl.Color := FContainerColor;
    Font.Color := FContainerTextColor;
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
    Transparent := True;
    Alignment := taLeftJustify;
    Layout := tlCenter;

    Height := 30;
    Top := ASlider.Top - 5;
    Left := ASliderValRect.Left;
    Width := ASliderValRect.Right - ASliderValRect.Left;

    lbl.Color := FContainerColor;
    Font.Color := FContainerTextColor;
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
end;

procedure TSharpEColorEditor.ResizeDefineColsPage;
var
  tmpTab: TPanel;
  iWidthLT, iWidthVal, iSliderWidth, iSpacer, iY, i: Integer;
  rLeftSlider, rLeftSliderVal, rRightSlider, rRightSliderVal, rLeftText,
    rRightText: TRect;
begin

  // Set Tab Container Height
  FColDefinePage.Top := FTabs.Height + 4;
  FColDefinePage.Height := FPageControl.Height-FTabs.Height-8;
  FColDefinePage.Width := FPageControl.Width-8;
  FColDefinePage.Left := 4;

  FSwatchesPage.Top := FTabs.Height + 4;
  FSwatchesPage.Height := FPageControl.Height-FTabs.Height-8;
  FSwatchesPage.Width := FPageControl.Width-8;
  FSwatchesPage.Left := 4;

  // Show color picker
  if not (FColorPicker.Visible) then
    FColorPicker.Show;
	
  FColorPicker.Left := FTabs.Width - 100;
  FColorPicker.Top := 7;
  FColorPicker.Height := 17;

  // Show add color button?
  FAddColorButton.Visible := FExpanded;
  
  FAddColorButton.Width := 20;
  FAddColorButton.Height := FColorPicker.Height + 3;
  FAddColorButton.Left := FColorPicker.Left - FAddColorButton.Width - 4;
  FAddColorButton.Top := 5;

  // Show swatch tab
  if not (FTabs.TabList.Item[cTabColSwatch].Visible) then
    FTabs.TabList.Item[cTabColSwatch].Visible := True;

  FTabs.Refresh;

  // Free all existing labels
  for i := Pred(FColDefinePage.ControlCount) downto 0 do
    if FColDefinePage.Controls[i] is TLabel then
      FColDefinePage.Controls[i].Free;

  // Set default tab to color definition page
  tmptab := FColDefinePage;
  iSpacer := 12;
  iWidthLT := Self.Canvas.TextWidth('Green:X');
  iWidthVal := Self.Canvas.TextWidth('XXXXXXX');
  iSliderWidth := (tmpTab.Width - (iWidthLT * 2) - (iWidthVal * 2) +
    (iSpacer)) div 2;

  iY := iSpacer;

  rLeftText := Rect(iSpacer, iSpacer, iWidthLT, iY + 10);
  rLeftSlider := Rect(rLeftText.Right, iY, rLeftText.Right + iSliderWidth, iY + 10);
  rLeftSliderVal := Rect(rLeftSlider.Right, iY, rLeftSlider.Right + iWidthVal, iy + 10);

  rRightText := Rect(rLeftSliderVal.Right + 4, iY, rLeftSliderVal.Right + iWidthLT, iY + 10);
  rRightSlider := Rect(rRightText.Right, iY, rRightText.Right - iSpacer + iSliderWidth, iY + 10);
  rRightSliderVal := Rect(rRightSlider.Right, iY, Self.Width - iSpacer*2, iY + 10);

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
  tmpTab: TPanel;
  tmpLbl: TLabel;
  iWidthLT, iWidthVal, iSliderWidth, iSpacer, iY, n: Integer;
  rLeftSlider, rLeftSliderVal, rLeftText: TRect;

begin

  FValDefinePage.Top := FTabs.Height + 4;
  FValDefinePage.Height := FPageControl.Height-FTabs.Height-8;
  FValDefinePage.Width := FPageControl.Width-8;
  FValDefinePage.Left := 4;

  FColorPicker.Hide;
  FAddColorButton.Hide;
  FTabs.TabList.Item[1].Visible := False;
  FTabs.Refresh;

  for n := Pred(FValDefinePage.ControlCount) downto 0 do
    if FValDefinePage.Controls[n] is TLabel then
      FValDefinePage.Controls[n].Free;

  tmptab := FValDefinePage;
  iSpacer := 12;
  Self.Canvas.Font.Assign(Self.Font);
  iWidthLT := Self.Canvas.TextWidth(FValueText + ':XX');
  iWidthVal := Self.Canvas.TextWidth('XXXXXXX');

  // Create value description label
  if FDescription <> '' then begin
    tmpLbl := TLabel.Create(tmpTab);
    with tmpLbl do begin
      Parent := tmpTab;

      if Font.Color <> FContainerTextColor then
        Font.Color := FContainerTextColor;

      Top := iSpacer;
      Left := iSpacer;
      Width := tmpTab.Width - iSpacer;
      Caption := FDescription;
    end;
    iY := (iSpacer * 2) + Self.Canvas.TextHeight(FDescription);
  end
  else
    iY := iSpacer;

  iSliderWidth := (tmpTab.Width -Self.Canvas.TextWidth(FValueText))-(iSpacer * 6);

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

  if csDesigning in componentState then
    exit;

  if FValue < 0 then
    col := GetCurrentTheme.Scheme.SchemeCodeToColor(FValue)
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

  UpdateLabels;

end;

procedure TSharpEColorEditor.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  Self.Color := Value;
  RefreshTheme;
end;

procedure TSharpEColorEditor.SetBackgroundTextColor(const Value: TColor);
begin
  FBackgroundTextColor := Value;
  RefreshTheme;
end;

procedure TSharpEColorEditor.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  RefreshTheme;
end;

procedure TSharpEColorEditor.SetCaption(const Value: string);
var
  Theme : ISharpETheme;
  s: string;
  pct, val: double;
begin
  FCaption := Value;

  if FNameLabel <> nil then begin

    case FValueEditorType of
      vetColor: begin

          if (FValue < 0) then begin

            if not (csDesigning in ComponentState) then begin
              Theme := GetCurrentTheme;

              if Theme.Scheme.GetColorCount > 0 then
                FNameLabel.Caption := Format('%s (%s):', [FCaption,
                  Theme.Scheme.GetColorByIndex(abs(FValue)-1).Tag]);
            end;

          end
          else begin
            s := IntToHex(GetRValue(FValue), 2) +
              IntToHex(GetGValue(FValue), 2) +
              IntToHex(GetBValue(FValue), 2);

            FNameLabel.Caption := Format('%s (%s):', [FCaption, '#' + s]);
          end;
        end;
      vetValue: begin

          if FDisplayPercent then begin
            val := FValueMax - FValue;
            pct := (val / FValueMax ) * 100;
            s := intTostr(round(pct))+'%';
          end else begin
            s := IntToStr(fvalue) + ' / ' + IntToStr(FValueMax);
          end;

          FNameLabel.Caption := Format('%s (%s):', [FCaption, s]);
        end;
      vetBoolean: begin
          FNameLabel.Caption := Format('%s (%s):', [FCaption, BoolToStr(Boolean(FValue), True)]);
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

procedure TSharpEColorEditor.SetContainerColor(const Value: TColor);
begin
  FContainerColor := Value;
  RefreshTheme;
end;

procedure TSharpEColorEditor.SetContainerTextColor(const Value: TColor);
begin
  FContainerTextColor := Value;
  RefreshTheme;
end;

procedure TSharpEColorEditor.SliderChangeEvent(Sender: TObject);
begin

  case FValueEditorType of
    vetColor: ColorSliderChangeEvent(Sender);
    vetValue: ValSliderChangeEvent(Sender);
  end;

end;

procedure TSharpEColorEditor.SliderMouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

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

procedure TSharpEColorEditor.UpdatePageVisibility(const ATabIndex: Integer);
begin
  if ATabIndex = 0 then
  begin
    FSliderUpdateMode := sumAll;

    case FValueEditorType of
      vetColor:
        begin
          InitialiseColSliders;

          FSwatchesPage.Hide;
          FColDefinePage.Show;
          FValDefinePage.Hide;
          FBoolDefinePage.Hide;
        end;
      vetValue:
        begin
          FSwatchesPage.Hide;
          FColDefinePage.Hide;
          FValDefinePage.Show;
          FBoolDefinePage.Hide;
        end;
      vetBoolean:
        begin
          FSwatchesPage.Hide;
          FColDefinePage.Hide;
          FValDefinePage.Hide;
          FBoolDefinePage.Show;
        end;
    end;
  end
  else if ATabIndex = 1 then
  begin
    FColDefinePage.Hide;
    FValDefinePage.Hide;
    FBoolDefinePage.Hide;
    FSwatchesPage.Show;
  end;
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
  AWidth := FPageControl.Width - 25;
end;

procedure TSharpEColorEditor.UpdateSwatchBitmap(ASender: TObject;
  const ABitmap32: TBitmap32);
begin
  FSharpESwatchCollection.Image32.Height := ABitmap32.Height;
  FSharpESwatchCollection.Image32.Width := ABitmap32.Width;
  FSharpESwatchCollection.Image32.Bitmap := ABitmap32;
end;

procedure TSharpEColorEditor.ClickSwatchEvent(ASender: TObject; AColor: TColor);
var
  tmp: TSharpESwatchCollectionItem;
begin
  tmp := TSharpESwatchCollectionItem(ASender);
  FSliderUpdateMode := sumAll;

  if tmp.System then
    Value := tmp.ColorCode
  else
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
        FValDefinePage.Hide;
        FBoolDefinePage.Hide;
        FSwatchesPage.Hide;
      end;
    vetValue: begin
        if ((FValue < 0) or (FValue > 255)) then
          FValue := 0;

        FColDefinePage.Hide;
        FValDefinePage.Show;
        FBoolDefinePage.Hide;
        FSwatchesPage.Hide;
      end;
    vetBoolean: begin
        if ((FValue < -1) or (FValue > 0)) then
          FValue := 1;

        FColDefinePage.Hide;
        FValDefinePage.Hide;
        FBoolDefinePage.Show;
        FSwatchesPage.Hide;
      end;
  end;

  if FTabs.TabIndex <> -1 then
    FTabs.TabIndex := 0;

  ResizeEvent(nil);
end;

procedure TSharpEColorEditor.SetValueMax(const Value: Integer);
begin
  FValueMax := Value;
  FValueSlider.Max := Value;
  ResizeEvent(nil);
end;

procedure TSharpEColorEditor.SetValueMin(const Value: Integer);
begin
  FValueMin := Value;
  FValueSlider.Min := Value;
  ResizeEvent(nil);
end;

procedure TSharpEColorEditor.SetDescription(const Value: string);
begin
  FDescription := Value;
  ResizeEvent(nil);
end;

procedure TSharpEColorEditor.SetDisplayPercent(const Value: boolean);
begin
  FDisplayPercent := Value;
  ResizeEvent(nil);
end;

procedure TSharpEColorEditor.ColorSliderChangeEvent(Sender: TObject);
var
  r, g, b, h, s, l: byte;
begin
  SliderEvents(False);

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
    Value := HSLtoRGB(h, s, l);
    FSliderUpdateMode := sumRGB;
  end;

  SliderEvents(True);
end;

procedure TSharpEColorEditor.ValSliderChangeEvent(Sender: TObject);
begin
  Value := FValueSlider.Position;
end;

procedure TSharpEColorEditor.SetValue(const Value: Integer);
begin

  FValue := Value;
  if csDesigning in componentState then
    exit;

  case FValueEditorType of
    vetColor: begin
        SliderEvents(False);
        try

          if FValue < 0 then begin
            FValueAsTColor := GetCurrentTheme.Scheme.SchemeCodeToColor(Value);
          end else
            FValueAsTColor := Value;

          if FColorPicker <> nil then
            FColorPicker.Color := FValueAsTColor;

          InitialiseColSliders;

          Caption := FCaption;
          
        finally
          SliderEvents(True);
        end;
      end;
    vetValue: begin
        if FValueSlider <> nil then begin
          FValueSlider.Position := FValue;
          TLabel(FValueSlider.Tag).Caption := IntToStr(FValue);
          TLabel(FValueSlider.Tag).Font.Color := FContainerTextColor;

          Caption := FCaption;
        end;
      end;
    vetBoolean: begin
        if FBoolCheckbox <> nil then begin
          FBoolCheckbox.Checked := StrToBool(IntToStr(FValue));
          if FBoolCheckbox.Checked then
            FBoolCheckbox.Caption := 'Enabled'
          else
            FBoolCheckbox.Caption := 'Disabled';

          if FBoolCheckbox.Font.Color <> FContainerTextColor then
            FBoolCheckbox.Font.Color := FContainerTextColor;
          Caption := FCaption;
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

procedure TSharpEColorEditor.RefreshTheme;

  procedure AssignDefaultSliderProps(ASlider: TJvTrackBar);
  begin

    with ASlider do begin
      Color := FContainerColor;
      Font.Color := FContainerTextColor;
    end;
  end;
begin
  if (FControlsCreated = false) then exit;

  // Create Page Control
  FPageControl.TabList.BkgColor := self.Color;
  FPageControl.Color := FContainerColor;
  FPageControl.BackgroundColor := FBackgroundColor;
  FPageControl.BorderColor := FContainerColor;
  FPageControl.ParentBackground := False;

  FPageControl.TabList.TabSelectedColor := FContainerColor;
  FPageControl.TabList.TabColor := FBackgroundColor;
  FPageControl.TabList.BorderColor := self.Color;
  FPageControl.TabList.BorderSelectedColor := FContainerColor;
  FPageControl.TabList.ParentBackground := False;

  FPanel.ParentBackground := False;
  FPanel.ParentColor := False;
  FPanel.Color := FBackgroundColor;

  FColorPicker.BackgroundColor := FBackgroundColor;

  FNameLabel.Color := FBackgroundColor;
  FNameLabel.Font.Color := FBackgroundTextColor;

  FColDefinePage.Color := FContainerColor;
  FColDefinePage.DoubleBuffered := true;

  AssignDefaultSliderProps(FHueSlider);
  AssignDefaultSliderProps(FSatSlider);
  AssignDefaultSliderProps(FLumSlider);
  AssignDefaultSliderProps(FRedSlider);
  AssignDefaultSliderProps(FGreenSlider);
  AssignDefaultSliderProps(FBlueSlider);

  FValDefinePage.color := FContainerColor;

  AssignDefaultSliderProps(FValueSlider);

  FBoolDefinePage.color := FContainerColor;

  FBoolCheckbox.Font.Color := FBackgroundTextColor;
  FBoolCheckbox.Color := FContainerColor;

  FSwatchesPage.color := FBackgroundColor;
  FSharpESwatchCollection.Color := FContainerColor;
end;

procedure TSharpEColorEditor.ResizeDefineBoolPage;
var
  tmpTab: TPanel;
  tmpLbl: TLabel;
  iSpacer, iY, n: Integer;

begin
  FBoolDefinePage.Top := FTabs.Height + 4;
  FBoolDefinePage.Height := FPageControl.Height-FTabs.Height-8;
  FBoolDefinePage.Width := FPageControl.Width-8;
  FBoolDefinePage.Left := 4;

  FColorPicker.Hide;
  FAddColorButton.Hide;
  FTabs.TabList.Item[1].Visible := False;
  FTabs.Refresh;

  for n := Pred(FBoolDefinePage.ControlCount) downto 0 do
    if FBoolDefinePage.Controls[n] is TLabel then
      FBoolDefinePage.Controls[n].Free;

  tmptab := FBoolDefinePage;
  iSpacer := 12;

  // Create value description label
  if FDescription <> '' then begin
    tmpLbl := TLabel.Create(tmpTab);
    with tmpLbl do begin
      Parent := tmpTab;

      if Font.Color <> FContainerTextColor then
        Font.Color := FContainerTextColor;

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
  Caption := FCaption;
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

