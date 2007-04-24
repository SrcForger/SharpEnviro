unit SharpECenterScheme;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TSharpECenterScheme = Class(TComponent)
  private
    FMainListItemSelCol: TColor;
    FMainListCol: TColor;
    FMainTabBordCol: TColor;
    FMainListItemBordCol: TColor;
    FEditTabSelCol: TColor;
    FSidePanelTextCol: TColor;
    FEditErrCol: TColor;
    FEditTabBordCol: TColor;
    FMainTabTextStatCol: TColor;
    FEditCol: TColor;
    FSidePanelItemTextCol: TColor;
    FSidePanelItemSelBordCol: TColor;
    FMainTextCol: TColor;
    FSidePanelTextDisCol: TColor;
    FSidePanelTabCol: TColor;
    FSidePanelBordCol: TColor;
    FEditTextCol: TColor;
    FSidePanelItemCol: TColor;
    FMainTextDisCol: TColor;
    FMainTabCol: TColor;
    FMainListItemCol: TColor;
    FEditTabErrCol: TColor;
    FSidePanelTabSelCol: TColor;
    FEditTextDisCol: TColor;
    FEditTabCol: TColor;
    FEditBordCol: TColor;
    FMainListItemDisCol: TColor;
    FSidePanelTabBordCol: TColor;
    FSidePanelItemSelCol: TColor;
    FMainTabSelCol: TColor;
    FSidePanelCol: TColor;
    FOnChangeColor: TNotifyEvent;
    FOnLoad: TNotifyEvent;
    FTimer: TTimer;
    procedure TimerEvent(Sender:TObject);
    procedure SetEditBordCol(const Value: TColor);
    procedure SetEditCol(const Value: TColor);
    procedure SetEditErrCol(const Value: TColor);
    procedure SetEditTabBordCol(const Value: TColor);
    procedure SetEditTabCol(const Value: TColor);
    procedure SetEditTabErrCol(const Value: TColor);
    procedure SetEditTabSelCol(const Value: TColor);
    procedure SetEditTextCol(const Value: TColor);
    procedure SetEditTextDisCol(const Value: TColor);
    procedure SetMainListCol(const Value: TColor);
    procedure SetMainListItemBordCol(const Value: TColor);
    procedure SetMainListItemCol(const Value: TColor);
    procedure SetMainListItemDisCol(const Value: TColor);
    procedure SetMainListItemSelCol(const Value: TColor);
    procedure SetMainTabBordCol(const Value: TColor);
    procedure SetMainTabCol(const Value: TColor);
    procedure SetMainTabSelCol(const Value: TColor);
    procedure SetMainTabTextStatCol(const Value: TColor);
    procedure SetMainTextCol(const Value: TColor);
    procedure SetMainTextDisCol(const Value: TColor);
    procedure SetSidePanelBordCol(const Value: TColor);
    procedure SetSidePanelCol(const Value: TColor);
    procedure SetSidePanelItemCol(const Value: TColor);
    procedure SetSidePanelItemSelBordCol(const Value: TColor);
    procedure SetSidePanelItemSelCol(const Value: TColor);
    procedure SetSidePanelItemTextCol(const Value: TColor);
    procedure SetSidePanelTabBordCol(const Value: TColor);
    procedure SetSidePanelTabCol(const Value: TColor);
    procedure SetSidePanelTabSelCol(const Value: TColor);
    procedure SetSidePanelTextCol(const Value: TColor);
    procedure SetSidePanelTextDisCol(const Value: TColor);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure SetDefaults;
  protected
  published
    Property SidePanelCol: TColor read FSidePanelCol
      write SetSidePanelCol;

    Property SidePanelBordCol: TColor read FSidePanelBordCol
      write SetSidePanelBordCol;

    Property SidePanelItemCol: TColor read FSidePanelItemCol
      write SetSidePanelItemCol;

    Property SidePanelItemSelCol: TColor read FSidePanelItemSelCol
      write SetSidePanelItemSelCol;

    Property SidePanelItemSelBordCol: TColor read FSidePanelItemSelBordCol
      write SetSidePanelItemSelBordCol;

    Property SidePanelItemTextCol: TColor read FSidePanelItemTextCol
      write SetSidePanelItemTextCol;

    Property SidePanelTabCol: TColor read FSidePanelTabCol
      write SetSidePanelTabCol;

    Property SidePanelTabBordCol: TColor read FSidePanelTabBordCol
      write SetSidePanelTabBordCol;

    Property SidePanelTabSelCol: TColor read FSidePanelTabSelCol
      write SetSidePanelTabSelCol;

    Property SidePanelTabTextCol: TColor read FSidePanelTextCol
      write SetSidePanelTextCol;

    Property SidePanelTabTextDisCol: TColor read FSidePanelTextDisCol
      write SetSidePanelTextDisCol;

    Property EditCol: TColor read FEditCol
      write SetEditCol;

    Property EditBordCol: TColor read FEditBordCol
      write SetEditBordCol;

    Property EditErrCol: TColor read FEditErrCol
      write SetEditErrCol;

    Property EditTabCol: TColor read FEditTabCol
      write SetEditTabCol;

    Property EditTabBordCol: TColor read FEditTabBordCol
      write SetEditTabBordCol;

    Property EditTabSelCol: TColor read FEditTabSelCol
      write SetEditTabSelCol;

    Property EditTabErrCol: TColor read FEditTabErrCol
      write SetEditTabErrCol;

    Property EditTabTextCol: TColor read FEditTextCol
      write SetEditTextCol;

    Property EditTabTextDisCol: TColor read FEditTextDisCol
      write SetEditTextDisCol;

    Property MainTabCol: TColor read FMainTabCol
      write SetMainTabCol;

    Property MainTabSelCol: TColor read FMainTabSelCol
      write SetMainTabSelCol;

    Property MainTabTextCol: TColor read FMainTextCol
      write SetMainTextCol;

    Property MainTabTextDisCol: TColor read FMainTextDisCol
      write SetMainTextDisCol;

    Property MainTabTextStatCol: TColor read FMainTabTextStatCol
      write SetMainTabTextStatCol;

    Property MainTabBordCol: TColor read FMainTabBordCol
      write SetMainTabBordCol;

    Property MainListCol: TColor read FMainListCol
      write SetMainListCol;

    Property MainListItemCol: TColor read FMainListItemCol
      write SetMainListItemCol;

    Property MainListItemBordCol: TColor read FMainListItemBordCol
      write SetMainListItemBordCol;

    Property MainListItemSelCol: TColor read FMainListItemSelCol
      write SetMainListItemSelCol;

    Property MainListItemDisCol: TColor read FMainListItemDisCol
      write SetMainListItemDisCol;

    property OnLoad: TNotifyEvent read FOnLoad write FOnLoad;
    property OnChangeColor: TNotifyEvent read FOnChangeColor write FOnChangeColor;
end;

  procedure Register;


implementation

{ TSharpCenterTheme }

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpECenterScheme]);
end;

constructor TSharpECenterScheme.Create(AOwner: TComponent);
begin
  inherited;
  SetDefaults;

  Ftimer := TTimer.Create(nil);
  FTimer.Interval := 1;
  FTimer.OnTimer := TimerEvent;
  FTimer.Enabled := True;
end;

destructor TSharpECenterScheme.Destroy;
begin
  inherited;
end;

procedure TSharpECenterScheme.SetDefaults;
const
  cCol1 = $00D6F7FE;
  cCol2 = $00FEF7F1;
  cCol3 = $00EAE9FC;
  cCol4 = $00F7F7F7;
  cCol5 = $00BBBBBB;
begin
  SidePanelCol := clWindow;
  SidePanelBordCol := clWindow;
  SidePanelItemSelBordCol := cCol1;
  SidePanelItemSelCol := cCol1;
  SidePanelItemCol := clWindow;
  SidePanelItemTextCol := clWindowText;
  SidePanelTabCol := clWindow;
  SidePanelTabBordCol := cCol1;
  SidePanelTabSelCol := cCol1;
  SidePanelTabTextCol := clWindowText;
  SidePanelTabTextDisCol := clWindowText;

  EditCol := cCol2;
  EditBordCol := cCol2;
  EditErrCol := cCol3;
  EditTabCol := cCol4;
  EditTabSelCol := cCol2;
  EditTabBordCol := cCol2;
  EditTabErrCol := cCol3;
  EditTabTextCol := clWindowText;
  EditTabTextDisCol := clWindowText;

  MainTabCol := cCol4;
  MainTabSelCol := clWindow;
  MainTabTextCol := clWindow;
  MainTabTextDisCol := clWindow;
  MainTabTextStatCol := clGreen;
  MainTabBordCol := cCol2;
  MainListCol := clWindow;
  MainListItemCol := clWindow;
  MainListItemBordCol := cCol4;
  MainListItemSelCol := cCol4;
  MainListItemDisCol := cCol5;
end;

procedure TSharpECenterScheme.SetMainListItemSelCol(const Value: TColor);
begin
  FMainListItemSelCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainListCol(const Value: TColor);
begin
  FMainListCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainTabBordCol(const Value: TColor);
begin
  FMainTabBordCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainListItemBordCol(const Value: TColor);
begin
  FMainListItemBordCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditTabSelCol(const Value: TColor);
begin
  FEditTabSelCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelTextCol(const Value: TColor);
begin
  FSidePanelTextCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditErrCol(const Value: TColor);
begin
  FEditErrCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditTabBordCol(const Value: TColor);
begin
  FEditTabBordCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainTabTextStatCol(const Value: TColor);
begin
  FMainTabTextStatCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditCol(const Value: TColor);
begin
  FEditCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelItemTextCol(const Value: TColor);
begin
  FSidePanelItemTextCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelItemSelBordCol(const Value: TColor);
begin
  FSidePanelItemSelBordCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainTextCol(const Value: TColor);
begin
  FMainTextCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelTextDisCol(const Value: TColor);
begin
  FSidePanelTextDisCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelTabCol(const Value: TColor);
begin
  FSidePanelTabCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelBordCol(const Value: TColor);
begin
  FSidePanelBordCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditTextCol(const Value: TColor);
begin
  FEditTextCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelItemCol(const Value: TColor);
begin
  FSidePanelItemCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainTextDisCol(const Value: TColor);
begin
  FMainTextDisCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainTabCol(const Value: TColor);
begin
  FMainTabCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainListItemCol(const Value: TColor);
begin
  FMainListItemCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditTabErrCol(const Value: TColor);
begin
  FEditTabErrCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelTabSelCol(const Value: TColor);
begin
  FSidePanelTabSelCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditTextDisCol(const Value: TColor);
begin
  FEditTextDisCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditTabCol(const Value: TColor);
begin
  FEditTabCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetEditBordCol(const Value: TColor);
begin
  FEditBordCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainListItemDisCol(const Value: TColor);
begin
  FMainListItemDisCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelTabBordCol(const Value: TColor);
begin
  FSidePanelTabBordCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelItemSelCol(const Value: TColor);
begin
  FSidePanelItemSelCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetMainTabSelCol(const Value: TColor);
begin
  FMainTabSelCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.SetSidePanelCol(const Value: TColor);
begin
  FSidePanelCol := Value;

  if assigned(FOnChangeColor) then
    FOnChangeColor(Self);
end;

procedure TSharpECenterScheme.TimerEvent(Sender: TObject);
begin
  FTimer.Enabled := False;

  if Assigned(FOnLoad) then
    FOnLoad(self);
end;

end.
