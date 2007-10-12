{
Source Name: uSysTrayWnd.pas
Description: SystemTray Module Settings Window
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

unit uSysTrayWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask, SharpEColorEditorEx,
  SharpESwatchManager;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmSysTray = class(TForm)
    plMain: TJvPageList;
    pagSysTray: TJvStandardPage;
    lbBackground: TLabel;
    Panel1: TPanel;
    sgbIconAlpha: TSharpeGaugeBox;
    Panel2: TPanel;
    sgbBackground: TSharpeGaugeBox;
    Label3: TLabel;
    Colors: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
    Label4: TLabel;
    Label5: TLabel;
    cbBackground: TCheckBox;
    Panel3: TPanel;
    sgbBorder: TSharpeGaugeBox;
    lbBorder: TLabel;
    cbBorder: TCheckBox;
    cbBlend: TCheckBox;
    lbBlend: TLabel;
    Panel4: TPanel;
    sgbBlend: TSharpeGaugeBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_numbersClick(Sender: TObject);
    procedure sgbIconAlphaChangeValue(Sender: TObject; Value: Integer);
    procedure ColorsChangeColor(ASender: TObject; AValue: Integer);
    procedure cbBackgroundClick(Sender: TObject);
    procedure cbBorderClick(Sender: TObject);
    procedure cbBlendClick(Sender: TObject);
  private
    procedure UpdateSettings;
  public
    sModuleID: string;
    sBarID : string;
  end;

var
  frmSysTray: TfrmSysTray;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmSysTray.cbBackgroundClick(Sender: TObject);
begin
  sgbBackground.Enabled := cbBackground.Checked;
  lbBackground.Enabled := cbBackground.Checked;
  Colors.Items.Item[0].Visible := cbBackground.Checked;
  UpdateSettings;
end;

procedure TfrmSysTray.cbBlendClick(Sender: TObject);
begin
  sgbBlend.Enabled := cbBlend.Checked;
  lbBlend.Enabled := cbBlend.Checked;
  Colors.Items.Item[2].Visible := cbBlend.Checked;
  UpdateSettings;
end;

procedure TfrmSysTray.cbBorderClick(Sender: TObject);
begin
  sgbBorder.Enabled := cbBorder.Checked;
  lbBorder.Enabled := cbBorder.Checked;
  Colors.Items.Item[1].Visible := cbBorder.Checked;  
  UpdateSettings;
end;

procedure TfrmSysTray.cb_numbersClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmSysTray.ColorsChangeColor(ASender: TObject; AValue: Integer);
begin
  UpdateSettings;
end;

procedure TfrmSysTray.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmSysTray.FormShow(Sender: TObject);
begin
  Label5.Font.Color := clGrayText;
  lbBackground.Font.Color := clGrayText;
  lbBorder.Font.Color := clGrayText;
  lbBlend.Font.Color := clGrayText;
  cbBackground.OnClick(cbBackground);
  cbBorder.OnClick(cbBorder);
  cbBlend.OnClick(cbBlend);
end;

procedure TfrmSysTray.sgbIconAlphaChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmSysTray.UpdateSettings;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

