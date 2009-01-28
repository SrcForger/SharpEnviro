{
Source Name: uNotesWnd.pas
Description: Notes Module Settings Window
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

unit uMMWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JclSimpleXml, Menus, ComCtrls, SharpAPI, SharpCenterAPI,
  ExtCtrls, SharpEGaugeBoxEdit, JclStrings, JvPageList, JvExControls,
  JvXPCore, JvXPCheckCtrls, ISharpCenterHostUnit, SharpECenterHeader;

type
  TfrmMM = class(TForm)
    plMain: TJvPageList;
    pagNotes: TJvStandardPage;
    pnlSize: TPanel;
    sgbBarSize: TSharpeGaugeBox;
    pnlFormat: TPanel;
    pnlAlignment: TPanel;
    schAlignment: TSharpECenterHeader;
    schRam: TSharpECenterHeader;
    schSwap: TSharpECenterHeader;
    schSize: TSharpECenterHeader;
    schFormat: TSharpECenterHeader;
    cbRamBar: TJvXPCheckbox;
    cbRamPC: TJvXPCheckbox;
    cbRamInfo: TJvXPCheckbox;
    cbSwpBar: TJvXPCheckbox;
    cbSwpPC: TJvXPCheckbox;
    cbSwpInfo: TJvXPCheckbox;
    pnlRam: TPanel;
    pnlSwap: TPanel;
    cboAlignment: TComboBox;
    cboTextFormat: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckboxClick(Sender: TObject);
    procedure RadioButtonClick(Sender: TObject);
    procedure sgbBarSizeChangeValue(Sender: TObject; Value: Integer);
    procedure cboChange(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateSettings;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmMM: TfrmMM;

implementation

{$R *.dfm}

procedure TfrmMM.cboChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmMM.CheckboxClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmMM.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmMM.RadioButtonClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmMM.sgbBarSizeChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmMM.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

end.

