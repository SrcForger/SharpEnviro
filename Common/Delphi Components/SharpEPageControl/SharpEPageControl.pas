unit SharpEPageControl;

interface

uses
  Windows,
  Classes,
  Graphics,
  Controls,
  Forms,
  SharpERoundPanel,
  SharpETabList,
  ExtCtrls,
  pngimagelist;

type
  TSharpEPageControl = class(TCustomPanel)
  private
    FTabList: TSharpETabList;
    FPnlContent: TSharpERoundPanel;
    FMinimized: Boolean;
    FExpandedHeight: Integer;
    FTabControlVisible: boolean;
    function GetTabItems: TTabItems;
    procedure SetTabItems(const Value: TTabItems);
    procedure CreateControls;
    function GetOnTabChange: TSharpETabChange;
    procedure SetOnTabChange(const Value: TSharpETabChange);
    function GetOnTabClick: TSharpETabClick;
    procedure SetOnTabClick(const Value: TSharpETabClick);
    function GetTabIndex: Integer;
    procedure SetTabIndex(const Value: Integer);
    function GetTabCount: Integer;
    function GetTabWidth: Integer;
    procedure SetTabWidth(const Value: Integer);

    function GetTabCaptionSelColor: TColor;
    function GetTabCaptionColor: TColor;
    function GetTabColor: TColor;
    function GetTabSelColor: TColor;
    function GetTabStatusSelColor: TColor;
    function GetTabStatusColor: TColor;

    procedure SetTabCaptionSelColor(const Value: TColor);
    procedure SetTabCaptionColor(const Value: TColor);
    procedure SetTabColor(const Value: TColor);
    procedure SetTabSelColor(const Value: TColor);
    procedure SetTabStatusSelColor(const Value: TColor);
    procedure SetTabStatusColor(const Value: TColor);
    function GetRoundValue: Integer;
    procedure SetRoundValue(const Value: Integer);
    function GetTabAlign: TLeftRight;
    procedure SetTabAlign(const Value: TLeftRight);
    function GetAutoSizeTabs: Boolean;
    procedure SetAutoSizeTabs(const Value: Boolean);
    function GetBackgroundColor: TColor;
    procedure SetBackgroundColor(const Value: TColor);
    function GetBorder: Boolean;
    function GetBorderColor: TColor;
    procedure SetBorder(const Value: Boolean);
    procedure SetBorderColor(const Value: TColor);
    function GetTabImageList: TPngImageList;
    procedure SetTabImageList(const Value: TPngImageList);
    function GetMinimized: Boolean;
    procedure SetMinimized(const Value: Boolean);
    function GetTabBackgroundColor: TColor;
    procedure SetTabBackgroundColor(const Value: TColor);
    procedure SetTabControlVisible(const Value: boolean);
    function GetButtons: TButtonItems;
    procedure SetButtons(const Value: TButtonItems);
    function GetOnBtnClick: TSharpEBtnClick;
    procedure SetOnBtnClick(const Value: TSharpEBtnClick);
    function GetBtnWidth: Integer;
    procedure SetBtnWidth(const Value: Integer);
    function GetIconSpacingX: Integer;
    function GetIconSpacingY: Integer;
    procedure SetIconSpacingX(const Value: Integer);
    procedure SetIconSpacingY(const Value: Integer);
    function GetTextSpacingX: Integer;
    function GetTextSpacingY: Integer;
    procedure SetTextSpacingX(const Value: Integer);
    procedure SetTextSpacingY(const Value: Integer);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    property TabList: TSharpETabList read FTabList write FTabList;
    property Minimized: Boolean read GetMinimized write SetMinimized;
    property TabControlVisible: boolean read FTabControlVisible write SetTabControlVisible;
  published
    property Align;
    property Anchors;
    property Visible;
    property Font;
    property ParentFont;
    property Color;
    property DoubleBuffered;

    property ExpandedHeight: Integer read FExpandedHeight write FExpandedHeight;
    property TabItems: TTabItems read GetTabItems write SetTabItems;
    property Buttons: TButtonItems read GetButtons write SetButtons;
    property RoundValue: Integer read GetRoundValue write SetRoundValue;
    property Border: Boolean read GetBorder write SetBorder;

    Property TextSpacingX: Integer read GetTextSpacingX write SetTextSpacingX;
    Property TextSpacingY: Integer read GetTextSpacingY write SetTextSpacingY;
    Property IconSpacingX: Integer read GetIconSpacingX write SetIconSpacingX;
    Property IconSpacingY: Integer read GetIconSpacingY write SetIconSpacingY;

    property TabCount: Integer read GetTabCount;
    property BtnWidth: Integer read GetBtnWidth write SetBtnWidth;
    property TabWidth: Integer read GetTabWidth write SetTabWidth;
    property TabIndex: Integer read GetTabIndex write SetTabIndex;
    property TabAlignment: TLeftRight read GetTabAlign write SetTabAlign;
    property AutoSizeTabs: Boolean read GetAutoSizeTabs write SetAutoSizeTabs;
    property TabImageList: TPngImageList read GetTabImageList write SetTabImageList;

    property TabBackgroundColor: TColor read GetTabBackgroundColor write SetTabBackgroundColor;
    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor;
    property BorderColor: TColor read GetBorderColor write SetBorderColor;
    property TabColor: TColor read GetTabColor write SetTabColor;
    property TabSelColor: TColor read GetTabSelColor write SetTabSelColor;
    property TabCaptionSelColor: TColor read GetTabCaptionSelColor write SetTabCaptionSelColor;
    property TabStatusSelColor: TColor read GetTabStatusSelColor write SetTabStatusSelColor;
    property TabCaptionColor: TColor read GetTabCaptionColor write SetTabCaptionColor;
    property TabStatusColor: TColor read GetTabStatusColor write SetTabStatusColor;

    property OnTabChange: TSharpETabChange read GetOnTabChange write SetOnTabChange;
    property OnTabClick: TSharpETabClick read GetOnTabClick write SetOnTabClick;
    property OnBtnClick: TSharpEBtnClick read GetOnBtnClick write SetOnBtnClick;

    procedure ResizeEvent(Sender: TObject);

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpEPageControl]);
end;

{ TSharpEPageControl }

constructor TSharpEPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.BevelInner := bvNone;
  Self.BevelOuter := bvNone;
  Self.OnResize := ResizeEvent;
  Self.TabControlVisible := True;
  Height := 200;
  ExpandedHeight := 200;

  CreateControls;
end;

{$REGION 'Control Creation'}

procedure TSharpEPageControl.CreateControls;
begin
  FTabList := TSharpETabList.Create(Self);
  with FTabList do begin
    Parent := Self;
    Top := 0;
    Left := 0;
    Width := Self.Width;
    BottomBorder := True;
    BorderColor := clBlack;
    Border := True;
    BkgColor := clBtnFace;
    TabSelectedColor := clWhite;
    TextSpacingX := 8;
    TextSpacingY := 6;
    AutoSizeTabs := True;
  end;
  FPnlContent := TSharpERoundPanel.Create(Self);
  with FPnlContent do begin
    Parent := Self;
    Top := FTabList.Top + FTabList.Height - 1;
    Left := 0;
    Width := Self.Width;
    Height := Self.Height - FTabList.Height;
    FPnlContent.SendToBack;
    BorderColor := clBlack;
    Border := True;
    DrawMode := srpNoTopLeft;
    ParentColor := False;
    Color := clWindow;
    ParentBackground := False;
    DoubleBuffered := True;

    Padding.Left := 8;
    Padding.Top := 8;
    Padding.Right := 8;
    Padding.Bottom := 8;
  end;
end;
{$ENDREGION}

function TSharpEPageControl.GetBorder: Boolean;
begin
  Result := FPnlContent.Border;
end;

function TSharpEPageControl.GetBorderColor: TColor;
begin
  Result := FPnlContent.BorderColor;
end;

function TSharpEPageControl.GetBtnWidth: Integer;
begin
  Result := FTabList.ButtonWidth;
end;

function TSharpEPageControl.GetButtons: TButtonItems;
begin
  Result := FTabList.Buttons;
end;

function TSharpEPageControl.GetIconSpacingX: Integer;
begin
  Result := FTabList.IconSpacingX;
end;

function TSharpEPageControl.GetIconSpacingY: Integer;
begin
  Result := FTabList.IconSpacingY;
end;

function TSharpEPageControl.GetMinimized: Boolean;
begin
  Result := FMinimized;
end;

function TSharpEPageControl.GetOnBtnClick: TSharpEBtnClick;
begin
  Result := FTabList.OnBtnClick;
end;

function TSharpEPageControl.GetOnTabChange: TSharpETabChange;
begin
  Result := FTabList.OnTabChange;
end;

function TSharpEPageControl.GetOnTabClick: TSharpETabClick;
begin
  Result := FTabList.OnTabClick;
end;

function TSharpEPageControl.GetBackgroundColor: TColor;
begin
  Result := FPnlContent.BackgroundColor;
end;

function TSharpEPageControl.GetRoundValue: Integer;
begin
  Result := FPnlContent.RoundValue;
end;

function TSharpEPageControl.GetTabAlign: TLeftRight;
begin
  Result := FTabList.TabAlign;
end;

function TSharpEPageControl.GetTabBackgroundColor: TColor;
begin
  Result := FTabList.BkgColor;
end;

function TSharpEPageControl.GetTabCount: Integer;
begin
  Result := FTabList.Count;
end;

function TSharpEPageControl.GetTabIndex: Integer;
begin
  Result := FTabList.TabIndex;
end;

function TSharpEPageControl.GetTabItems: TTabItems;
begin
  Result := FTabList.TabList;
end;

function TSharpEPageControl.GetTabWidth: Integer;
begin
  Result := FTabList.TabWidth;
end;

function TSharpEPageControl.GetTextSpacingX: Integer;
begin
  Result := FTabList.TextSpacingX;
end;

function TSharpEPageControl.GetTextSpacingY: Integer;
begin
  Result := FTabList.TextSpacingY;
end;

function TSharpEPageControl.GetAutoSizeTabs: Boolean;
begin
  Result := FTabList.AutoSizeTabs;
end;

function TSharpEPageControl.GetTabCaptionSelColor: TColor;
begin
  Result := FTabList.CaptionSelectedColor;
end;

function TSharpEPageControl.GetTabCaptionColor: TColor;
begin
  Result := FTabList.CaptionUnSelectedColor;
end;

function TSharpEPageControl.GetTabColor: TColor;
begin
  Result := FTabList.TabColor;
end;

function TSharpEPageControl.GetTabImageList: TPngImageList;
begin
  Result := FTabList.PngImageList;
end;

function TSharpEPageControl.GetTabSelColor: TColor;
begin
  Result := FTabList.TabSelectedColor;
end;

function TSharpEPageControl.GetTabStatusSelColor: TColor;
begin
  Result := FTabList.StatusSelectedColor;
end;

function TSharpEPageControl.GetTabStatusColor: TColor;
begin
  Result := FTabList.StatusUnSelectedColor;
end;

procedure TSharpEPageControl.Loaded;
begin
  inherited;
  ResizeEvent(nil);
end;

procedure TSharpEPageControl.ResizeEvent(Sender: TObject);
begin

  with FTabList do begin
    Top := 0;
    Left := 0;
    Width := Self.Width;
    Anchors := [akLeft, akRight, akTop];
  end;

  with FPnlContent do begin

    if FTabList.Visible then begin
      Top := FTabList.Top + FTabList.Height - 1;
      Height := Self.Height - FTabList.Height;

      if Self.TabAlignment = taLeftJustify then
        FPnlContent.DrawMode := srpNoTopLeft
      else if Self.TabAlignment = taRightJustify then
        FPnlContent.DrawMode := srpNoTopRight;
    end else begin
      Top := 0;
      Height := Self.Height;
      FPnlContent.DrawMode := srpNormal;
    end;

    Left := 0;
    Width := Self.Width;
    Anchors := [akLeft, akRight, akTop, akBottom];
  end;
end;

procedure TSharpEPageControl.SetBorder(const Value: Boolean);
begin
  FPnlContent.Border := Value;
  FTabList.Border := Value;
end;

procedure TSharpEPageControl.SetBorderColor(const Value: TColor);
begin
  FPnlContent.BorderColor := Value;
  FTabList.BorderColor := Value;
  FTabList.BorderSelectedColor := Value;
end;

procedure TSharpEPageControl.SetBtnWidth(const Value: Integer);
begin
  FTabList.ButtonWidth := Value;
end;

procedure TSharpEPageControl.SetButtons(const Value: TButtonItems);
begin
  FTabList.Buttons := Value;
end;

procedure TSharpEPageControl.SetIconSpacingX(const Value: Integer);
begin
  FTabList.IconSpacingX := Value;
end;

procedure TSharpEPageControl.SetIconSpacingY(const Value: Integer);
begin
  FTabList.IconSpacingY := Value;
end;

procedure TSharpEPageControl.SetMinimized(const Value: Boolean);
begin
  FMinimized := Value;

  if FMinimized then begin
    Self.Height := FTabList.Height - 1;
    FTabList.Minimized := True;
  end
  else begin
    //Self.Height := FExpandedHeight;
    FTabList.Minimized := False;
  end;
end;

procedure TSharpEPageControl.SetOnBtnClick(const Value: TSharpEBtnClick);
begin
  FTabList.OnBtnClick := Value;
end;

procedure TSharpEPageControl.SetOnTabChange(const Value: TSharpETabChange);
begin
  FTabList.OnTabChange := Value;
end;

procedure TSharpEPageControl.SetOnTabClick(const Value: TSharpETabClick);
begin
  FTabList.OnTabClick := Value;
end;

procedure TSharpEPageControl.SetBackgroundColor(const Value: TColor);
begin
  FPnlContent.BackgroundColor := Value;
end;

procedure TSharpEPageControl.SetRoundValue(const Value: Integer);
begin
  FPnlContent.RoundValue := Value;
end;

procedure TSharpEPageControl.SetTabAlign(const Value: TLeftRight);
begin
  FTabList.TabAlign := Value;
  if Value = taLeftJustify then
    FPnlContent.DrawMode := srpNoTopLeft
  else
    FPnlContent.DrawMode := srpNoTopRight;

end;

procedure TSharpEPageControl.SetTabBackgroundColor(const Value: TColor);
begin
  FTabList.BkgColor := Value;
end;

procedure TSharpEPageControl.SetTabIndex(const Value: Integer);
begin
  FTabList.TabIndex := Value;
end;

procedure TSharpEPageControl.SetTabItems(const Value: TTabItems);
begin
  FTabList.TabList := Value;
end;

procedure TSharpEPageControl.SetTabWidth(const Value: Integer);
begin
  FTabList.TabWidth := Value;
end;

procedure TSharpEPageControl.SetTextSpacingX(const Value: Integer);
begin
  FTabList.TextSpacingX := Value;
end;

procedure TSharpEPageControl.SetTextSpacingY(const Value: Integer);
begin
  FTabList.TextSpacingY := Value;
end;

procedure TSharpEPageControl.SetAutoSizeTabs(const Value: Boolean);
begin
  FTabList.AutoSizeTabs := Value;
end;

procedure TSharpEPageControl.SetTabCaptionSelColor(const Value: TColor);
begin
  FTabList.CaptionSelectedColor := Value;
end;

procedure TSharpEPageControl.SetTabCaptionColor(const Value: TColor);
begin
  FTabList.CaptionUnSelectedColor := Value;
end;

procedure TSharpEPageControl.SetTabColor(const Value: TColor);
begin
  FTabList.TabColor := Value;
end;

procedure TSharpEPageControl.SetTabControlVisible(const Value: boolean);
begin
  FTabControlVisible := Value;

  if FTabList <> nil then begin
    FTabList.Visible := Value;
    ResizeEvent(nil);
  end;
end;

procedure TSharpEPageControl.SetTabImageList(const Value: TPngImageList);
begin
  FTabList.PngImageList := Value;
end;

procedure TSharpEPageControl.SetTabSelColor(const Value: TColor);
begin
  FTabList.TabSelectedColor := Value;
end;

procedure TSharpEPageControl.SetTabStatusSelColor(const Value: TColor);
begin
  FTabList.StatusSelectedColor := Value;
end;

procedure TSharpEPageControl.SetTabStatusColor(const Value: TColor);
begin
  FTabList.StatusUnSelectedColor := Value;
end;

end.

