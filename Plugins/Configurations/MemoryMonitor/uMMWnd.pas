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
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmMM = class(TForm)
    plMain: TJvPageList;
    pagNotes: TJvStandardPage;
    cbRamInfo: TCheckBox;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    cbRamPC: TCheckBox;
    cbRamBar: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    cbSwpBar: TCheckBox;
    cbSwpPC: TCheckBox;
    cbSwpInfo: TCheckBox;
    Label7: TLabel;
    Panel1: TPanel;
    sgbBarSize: TSharpeGaugeBox;
    Label9: TLabel;
    Panel2: TPanel;
    rbPTaken: TRadioButton;
    rbFreeMB: TRadioButton;
    Panel3: TPanel;
    rbHoriz: TRadioButton;
    rbHoriz2: TRadioButton;
    rbVert: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbRamInfoClick(Sender: TObject);
    procedure rbVertClick(Sender: TObject);
    procedure sgbBarSizeChangeValue(Sender: TObject; Value: Integer);
  private
    procedure UpdateSettings;
  public
    sModuleID: string;
    sBarID : string;
  end;

var
  frmMM: TfrmMM;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmMM.cbRamInfoClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmMM.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmMM.FormShow(Sender: TObject);
begin
  Label5.Font.Color := clGrayText;
  Label1.Font.Color := clGrayText;
  Label6.Font.Color := clGrayText;
end;

procedure TfrmMM.rbVertClick(Sender: TObject);
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
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

