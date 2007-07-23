unit SharpEPageControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpERoundPanel, SharpETabList, ExtCtrls;

type
  TSharpEPageControl = Class(TCustomPanel)
    private
      FTabList: TSharpETabList;
      FPnlContent: TSharpERoundPanel;
    FTabs: TSharpETabListItems;
    function GetTabs: TSharpETabListItems;
    procedure SetTabs(const Value: TSharpETabListItems);
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
    function GetTab_BkgColor: TColor;
    function GetTab_CaptionSelectedColor: TColor;
    function GetTab_CaptionUnSelectedColor: TColor;
    function GetTab_Color: TColor;
    function GetTab_SelectedColor: TColor;
    function GetTab_StatusSelectedColor: TColor;
    function GetTab_StatusUnSelectedColor: TColor;
    procedure SetTab_BkgColor(const Value: TColor);
    procedure SetTab_CaptionSelectedColor(const Value: TColor);
    procedure SetTab_CaptionUnSelectedColor(const Value: TColor);
    procedure SetTab_Color(const Value: TColor);
    procedure SetTab_SelectedColor(const Value: TColor);
    procedure SetTab_StatusSelectedColor(const Value: TColor);
    procedure SetTab_StatusUnSelectedColor(const Value: TColor);
    function GetRoundValue: Integer;
    procedure SetRoundValue(const Value: Integer);
    function GetTabAlign: TLeftRight;
    procedure SetTabAlign(const Value: TLeftRight);
    function GetTab_AutoSize: Boolean;
    procedure SetTab_AutoSize(const Value: Boolean);
    function GetPanel_BkgColor: TColor;
    procedure SetPanel_BkgColor(const Value: TColor);
    function GetBorder: Boolean;
    function GetBorderColor: TColor;
    procedure SetBorder(const Value: Boolean);
    procedure SetBorderColor(const Value: TColor);
  protected
    procedure Loaded; override;
    public
      constructor Create(AOwner:TComponent); override;
      property TabList: TSharpETabList read FTabList write FTabList;
    published
      property Align;
      property Anchors;
      Property Visible;
      Property Font;
      Property ParentFont;

      property Tabs: TSharpETabListItems read GetTabs write SetTabs;

      property Panel_RoundValue: Integer read GetRoundValue write SetRoundValue;
      property Panel_BkgColor: TColor read GetPanel_BkgColor write SetPanel_BkgColor;

      property BorderColor: TColor read GetBorderColor write SetBorderColor;
      property Border: Boolean read GetBorder write SetBorder;


      property Tab_Count: Integer read GetTabCount;
      Property Tab_Width: Integer read GetTabWidth write SetTabWidth;
      property Tab_Index: Integer read GetTabIndex write SetTabIndex;
      property Tab_Align: TLeftRight read GetTabAlign write SetTabAlign;
      Property Tab_AutoSize: Boolean read GetTab_AutoSize write SetTab_AutoSize;


      Property Tab_Color: TColor read GetTab_Color write SetTab_Color;
      Property Tab_SelectedColor: TColor read GetTab_SelectedColor write SetTab_SelectedColor;
      Property Tab_BkgColor: TColor read GetTab_BkgColor write SetTab_BkgColor;
      Property Tab_CaptionSelectedColor: TColor read GetTab_CaptionSelectedColor write SetTab_CaptionSelectedColor;
      Property Tab_StatusSelectedColor: TColor read GetTab_StatusSelectedColor write SetTab_StatusSelectedColor;
      Property Tab_CaptionUnSelectedColor: TColor read GetTab_CaptionUnSelectedColor write SetTab_CaptionUnSelectedColor;
      Property Tab_StatusUnSelectedColor: TColor read GetTab_StatusUnSelectedColor write SetTab_StatusUnSelectedColor;

      property OnTabChange: TSharpETabChange read GetOnTabChange write SetOnTabChange;
      property OnTabClick: TSharpETabClick read GetOnTabClick write SetOnTabClick;

      procedure ResizeEvent(Sender: TObject);
      
  End;

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

  CreateControls;
end;

{$REGION 'Control Creation'}
  procedure TSharpEPageControl.CreateControls;
  begin
    FTabList := TSharpETabList.Create(Self);
    with FTabList do
    begin
      Parent := Self;
      Top := 0;
      Left := 0;
      Width := Self.Width;
      BottomBorder := True;
      BorderColor := clBlack;
      Border := True;
      BkgColor := clBtnFace;
      TabSelectedColor := clWhite;
      TextBounds := Rect(8, 8, 8, 4);
      AutoSizeTabs := True;
    end;
    FPnlContent := TSharpERoundPanel.Create(Self);
    with FPnlContent do
    begin
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
      ParentBackground := False;

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

function TSharpEPageControl.GetOnTabChange: TSharpETabChange;
begin
  Result := FTabList.OnTabChange;
end;

function TSharpEPageControl.GetOnTabClick: TSharpETabClick;
begin
  Result := FTabList.OnTabClick;
end;

function TSharpEPageControl.GetPanel_BkgColor: TColor;
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

function TSharpEPageControl.GetTabCount: Integer;
begin
  Result := FTabList.Count;
end;

function TSharpEPageControl.GetTabIndex: Integer;
begin
  Result := FTabList.TabIndex;
end;

function TSharpEPageControl.GetTabs: TSharpETabListItems;
begin
  Result := FTabList.TabList;
end;

function TSharpEPageControl.GetTabWidth: Integer;
begin
  Result := FTabList.TabWidth;
end;

function TSharpEPageControl.GetTab_AutoSize: Boolean;
begin
  Result := FTabList.AutoSizeTabs;
end;

function TSharpEPageControl.GetTab_BkgColor: TColor;
begin
  Result := FTabList.BkgColor;
end;

function TSharpEPageControl.GetTab_CaptionSelectedColor: TColor;
begin
  Result := FTabList.CaptionSelectedColor;
end;

function TSharpEPageControl.GetTab_CaptionUnSelectedColor: TColor;
begin
  Result := FTabList.CaptionUnSelectedColor;
end;

function TSharpEPageControl.GetTab_Color: TColor;
begin
  Result := FTabList.TabColor;
end;

function TSharpEPageControl.GetTab_SelectedColor: TColor;
begin
  Result := FTabList.TabSelectedColor;
end;

function TSharpEPageControl.GetTab_StatusSelectedColor: TColor;
begin
  Result := FTabList.StatusSelectedColor;
end;

function TSharpEPageControl.GetTab_StatusUnSelectedColor: TColor;
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
    with FTabList do
    begin
      Top := 0;
      Left := 0;
      Width := Self.Width;
      Anchors := [akLeft, akRight, akTop];
    end;

    with FPnlContent do
    begin
      Top := FTabList.Top + FTabList.Height - 1;
      Left := 0;
      Width := Self.Width;
      Height := Self.Height - FTabList.Height;
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

procedure TSharpEPageControl.SetOnTabChange(const Value: TSharpETabChange);
begin
  FTabList.OnTabChange := Value;
end;

procedure TSharpEPageControl.SetOnTabClick(const Value: TSharpETabClick);
begin
  FTabList.OnTabClick := Value;
end;

procedure TSharpEPageControl.SetPanel_BkgColor(const Value: TColor);
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
    FPnlContent.DrawMode := srpNoTopLeft else
    FPnlContent.DrawMode := srpNoTopRight;
  
end;

procedure TSharpEPageControl.SetTabIndex(const Value: Integer);
begin
  FTabList.TabIndex := Value;
end;

procedure TSharpEPageControl.SetTabs(const Value: TSharpETabListItems);
begin
  FTabList.TabList := Value;
end;

procedure TSharpEPageControl.SetTabWidth(const Value: Integer);
begin
  FTabList.TabWidth := Value;
end;

procedure TSharpEPageControl.SetTab_AutoSize(const Value: Boolean);
begin
  FTabList.AutoSizeTabs := Value;
end;

procedure TSharpEPageControl.SetTab_BkgColor(const Value: TColor);
begin
  FTabList.BkgColor := Value;
end;

procedure TSharpEPageControl.SetTab_CaptionSelectedColor(const Value: TColor);
begin
  FTabList.CaptionSelectedColor := Value;
end;

procedure TSharpEPageControl.SetTab_CaptionUnSelectedColor(const Value: TColor);
begin
  FTabList.CaptionUnSelectedColor := Value;
end;

procedure TSharpEPageControl.SetTab_Color(const Value: TColor);
begin
  FTabList.TabColor := Value;
end;

procedure TSharpEPageControl.SetTab_SelectedColor(const Value: TColor);
begin
  FTabList.TabSelectedColor := Value;
end;

procedure TSharpEPageControl.SetTab_StatusSelectedColor(const Value: TColor);
begin
  FTabList.StatusSelectedColor := Value;
end;

procedure TSharpEPageControl.SetTab_StatusUnSelectedColor(const Value: TColor);
begin
  FTabList.StatusUnSelectedColor := Value;
end;

end.
