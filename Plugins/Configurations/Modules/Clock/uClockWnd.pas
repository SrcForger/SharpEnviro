{
Source Name: uClockWnd.pas
Description: Clock Module Settings Window
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

unit uClockWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, SharpApi, SharpCenterAPI,
  ExtCtrls, SharpECenterHeader, ISharpCenterHostUnit;

type
  TfrmClock = class(TForm)
    PopupMenu1: TPopupMenu;
    TimeColon: TMenuItem;
    TimeColonAMPM: TMenuItem;
    TimeColonDashDatePeriod: TMenuItem;
    TimeColonAMPMDashDatePeriod: TMenuItem;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    pnlTop: TPanel;
    btnTop: TButton;
    pnlBottom: TPanel;
    btnBottom: TButton;
    pnlSize: TPanel;
    cboSize: TComboBox;
    DateSlashTimeColon: TMenuItem;
    SharpECenterHeader3: TSharpECenterHeader;
    pnlTooltip: TPanel;
    editTooltip: TEdit;
    btnTooltip: TButton;
    DateSlash: TMenuItem;
    LongDateSpaceComma: TMenuItem;
    LongDatePeriod: TMenuItem;
    DatePeriod: TMenuItem;
    DatePeriodTimeColon: TMenuItem;
    DatePeriodTimeColonAMPM: TMenuItem;
    DateSlashTimeColonAMPM: TMenuItem;
    editTop: TEdit;
    editBottom: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure btnTopClick(Sender: TObject);
    procedure btnBottomClick(Sender: TObject);
    procedure btnTooltipClick(Sender: TObject);
    procedure UpdateSettingsEvent(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    procedure UpdatePopupMenuCaptions;
    procedure UpdateSettings;
    procedure UpdateBottomEdit;
  public
    ModuleID: string;
    BarID : string;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmClock: TfrmClock;

const
  Small = 0;
  Medium = 1;
  Large = 2;
  Automatic = 3;

implementation

{$R *.dfm}

procedure TfrmClock.btnBottomClick(Sender: TObject);
begin
  UpdatePopupMenuCaptions;
  PopUpMenu1.PopupComponent := editBottom;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TfrmClock.btnTopClick(Sender: TObject);
begin
  UpdatePopupMenuCaptions;
  PopUpMenu1.PopupComponent := editTop;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TfrmClock.btnTooltipClick(Sender: TObject);
begin
  UpdatePopupMenuCaptions;
  PopupMenu1.PopupComponent := editTooltip;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TfrmClock.UpdatePopupMenuCaptions();
var
  menuItem : TMenuItem;
begin
  with PopupMenu1 do
  begin
    for menuItem in Items do
    begin
      // We use the Hint property to store the format so use it to
      // generate the captions for each menu item using the current date time.
      menuItem.Caption := FormatDateTime(menuItem.Hint, Now()) + ' (' + menuItem.Hint + ')';
    end;
  end;
end;

procedure TfrmClock.UpdateSettingsEvent(Sender: TObject);
var
  r: string;
begin
  if Sender is TEdit then
  begin
    DateTimeToString(r,TEdit(Sender).Text,now());
    TEdit(Sender).Hint := r;
  end;

  UpdateSettings;
end;

procedure TfrmClock.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;

  UpdateSettingsEvent(editTop);
  UpdateSettingsEvent(editBottom);
  UpdateSettingsEvent(editTooltip);
end;

procedure TfrmClock.FormShow(Sender: TObject);
begin
  UpdateBottomEdit;
end;

procedure TfrmClock.MenuItemClick(Sender: TObject);
begin
  if PopupMenu1.PopupComponent is TEdit then
    TEdit(PopUpMenu1.PopupComponent).Text := TMenuItem(Sender).Hint;

  if PopUpMenu1.PopupComponent is TLabeledEdit then
     TLabeledEdit(PopUpMenu1.PopupComponent).Text := TMenuItem(Sender).Hint;

  UpdateSettings;
end;

procedure TfrmClock.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;

  UpdateBottomEdit;
end;

procedure TfrmClock.UpdateBottomEdit;
begin
  pnlBottom.Visible := cboSize.ItemIndex = Automatic;
end;

end.

