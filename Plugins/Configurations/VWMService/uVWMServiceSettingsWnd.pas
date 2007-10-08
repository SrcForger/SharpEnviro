{
Source Name: uVWMServiceSettingsWnd.pas
Description: VWM Service Settings Window
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

unit uVWMServiceSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi, SharpCenterApi,
  SharpEGaugeBoxEdit, ImgList, PngImageList, JvPageList, JvExControls, ExtCtrls;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmVWMSettings = class(TForm)
    JvPageList1: TJvPageList;
    JvSettingsPage: TJvStandardPage;
    Panel1: TPanel;
    Label4: TLabel;
    sgb_vwmcount: TSharpeGaugeBox;
    Label1: TLabel;
    cb_focustopmost: TCheckBox;
    Label2: TLabel;
    procedure sgb_vwmcountChangeValue(Sender: TObject; Value: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cb_focustopmostClick(Sender: TObject);
  private
    procedure SendUpdate;
  public
  end;

var
  frmVWMSettings: TfrmVWMSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmVWMSettings.cb_focustopmostClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmVWMSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
end;

procedure TfrmVWMSettings.FormShow(Sender: TObject);
begin
  Label4.Font.Color := clGray;
  Label2.Font.Color := clGray;
end;

procedure TfrmVWMSettings.SendUpdate;
begin
  if Visible then
     CenterDefineSettingsChanged;
end;

procedure TfrmVWMSettings.sgb_vwmcountChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

end.

