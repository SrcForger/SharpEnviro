{
Source Name: uRSSReaderWnd.pas
Description: RSS Reader Module Settings Window
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

unit uRSSReaderWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, SharpApi, SharpCenterAPI,
  ExtCtrls, SharpECenterHeader, ISharpCenterHostUnit, SharpEGaugeBoxEdit,
  JvExControls, JvXPCore, JvXPCheckCtrls;

type
  TfrmRSSReader = class(TForm)
    PopupMenu1: TPopupMenu;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    Panel2: TPanel;
    Label4: TLabel;
    edtURL: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    Label3: TLabel;
    sgbUpdateInterval: TSharpeGaugeBox;
    cbNotify: TJvXPCheckbox;
    cbButtons: TJvXPCheckbox;
    Panel3: TPanel;
    cbIcon: TJvXPCheckbox;
    Panel4: TPanel;
    cbCustomIcon: TJvXPCheckbox;
    Panel5: TPanel;
    Label1: TLabel;
    sgbSwitchInterval: TSharpeGaugeBox;
    ffff1: TMenuItem;
    German1: TMenuItem;
    CNNWorldsNews1: TMenuItem;
    CNNUSANews1: TMenuItem;
    CNNEurope1: TMenuItem;
    CNNBusiness1: TMenuItem;
    CNNTechnology1: TMenuItem;
    NYTWorldNews1: TMenuItem;
    NYTUSA1: TMenuItem;
    ntv1: TMenuItem;
    SpiegelSchlagzeilen1: TMenuItem;
    SpiegelNachrichten1: TMenuItem;
    agesschau1: TMenuItem;
    BBCTopNews1: TMenuItem;
    BBCTechnology1: TMenuItem;
    BBCUK1: TMenuItem;
    BBCEurope1: TMenuItem;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure UpdateSettingsEvent(Sender: TObject);
    procedure cbIconClick(Sender: TObject);
    procedure sgbUpdateIntervalChangeValue(Sender: TObject; Value: Integer);
    procedure Button1Click(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    procedure UpdateSettings;
  public
    ModuleID: string;
    BarID : string;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmRSSReader: TfrmRSSReader;

implementation

{$R *.dfm}

procedure TfrmRSSReader.Button1Click(Sender: TObject);
begin
  PopUpMenu1.PopupComponent := edtURL;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TfrmRSSReader.cbIconClick(Sender: TObject);
begin
  cbCustomIcon.Enabled := cbIcon.Checked;
  UpdateSettings;
end;

procedure TfrmRSSReader.UpdateSettingsEvent(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmRSSReader.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmRSSReader.FormShow(Sender: TObject);
begin
  cbIconClick(nil);
end;

procedure TfrmRSSReader.MenuItemClick(Sender: TObject);
begin
  if PopupMenu1.PopupComponent is TEdit then
    TEdit(PopUpMenu1.PopupComponent).Text := TMenuItem(Sender).Hint;

  if PopUpMenu1.PopupComponent is TLabeledEdit then
     TLabeledEdit(PopUpMenu1.PopupComponent).Text := TMenuItem(Sender).Hint;

  UpdateSettings;
end;

procedure TfrmRSSReader.sgbUpdateIntervalChangeValue(Sender: TObject;
  Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmRSSReader.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;


end.

