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
  SharpESwatchManager, ISharpCenterHostUnit, SharpECenterHeader, JvXPCore,
  JvXPCheckCtrls;

type
  TfrmSysTray = class(TForm)
    plMain: TJvPageList;
    pagSysTray: TJvStandardPage;
    pnlIcon: TPanel;
    sgbIconAlpha: TSharpeGaugeBox;
    pnlBackground: TPanel;
    sgbBackground: TSharpeGaugeBox;
    Colors: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
    pnlBorder: TPanel;
    sgbBorder: TSharpeGaugeBox;
    pnlBlend: TPanel;
    sgbBlend: TSharpeGaugeBox;
    schIconVisibility: TSharpECenterHeader;
    schBackgroundVisibility: TSharpECenterHeader;
    schBorderVisibility: TSharpECenterHeader;
    schColorBlendOptions: TSharpECenterHeader;
    schColor: TSharpECenterHeader;
    chkBackground: TJvXPCheckbox;
    chkBorder: TJvXPCheckbox;
    chkBlend: TJvXPCheckbox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_numbersClick(Sender: TObject);
    procedure sgbIconAlphaChangeValue(Sender: TObject; Value: Integer);
    procedure ColorsChangeColor(ASender: TObject; AValue: Integer);
    procedure cbBackgroundClick(Sender: TObject);
    procedure cbBorderClick(Sender: TObject);
    procedure cbBlendClick(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateSettings;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmSysTray: TfrmSysTray;

implementation

uses
  SharpCenterApi;

{$R *.dfm}

procedure TfrmSysTray.cbBackgroundClick(Sender: TObject);
begin
  sgbBackground.Enabled := chkBackground.Checked;
  Colors.Items.Item[0].Visible := chkBackground.Checked;
  UpdateSettings;
end;

procedure TfrmSysTray.cbBlendClick(Sender: TObject);
begin
  sgbBlend.Enabled := chkBlend.Checked;
  Colors.Items.Item[2].Visible := chkBlend.Checked;
  UpdateSettings;
end;

procedure TfrmSysTray.cbBorderClick(Sender: TObject);
begin
  sgbBorder.Enabled := chkBorder.Checked;
  Colors.Items.Item[1].Visible := chkBorder.Checked;
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
  chkBackground.OnClick(chkBackground);
  chkBorder.OnClick(chkBorder);
  chkBlend.OnClick(chkBlend);
end;

procedure TfrmSysTray.sgbIconAlphaChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmSysTray.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

end.

