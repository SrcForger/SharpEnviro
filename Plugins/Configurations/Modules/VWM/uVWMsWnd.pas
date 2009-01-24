{
Source Name: uVWMsWnd.pas
Description: VWM Module Settings Window
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

unit uVWMsWnd;

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
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmVWM = class(TForm)
    plMain: TJvPageList;
    pagVWM: TJvStandardPage;
    Panel1: TPanel;
    sgb_background: TSharpeGaugeBox;
    Panel2: TPanel;
    sgb_border: TSharpeGaugeBox;
    Panel3: TPanel;
    sgb_foreground: TSharpeGaugeBox;
    Panel4: TPanel;
    sgb_highlight: TSharpeGaugeBox;
    Panel5: TPanel;
    sgb_text: TSharpeGaugeBox;
    Colors: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
    schColorVisibility: TSharpECenterHeader;
    schColorSelection: TSharpECenterHeader;
    schNumbers: TSharpECenterHeader;
    chkShowNumbers: TJvXPCheckbox;
    procedure FormCreate(Sender: TObject);
    procedure cb_numbersClick(Sender: TObject);
    procedure sgb_backgroundChangeValue(Sender: TObject; Value: Integer);
    procedure ColorsChangeColor(ASender: TObject; AValue: Integer);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateSettings;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmVWM: TfrmVWM;

implementation

uses
  SharpCenterApi;

{$R *.dfm}

procedure TfrmVWM.cb_numbersClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmVWM.ColorsChangeColor(ASender: TObject; AValue: Integer);
begin
  UpdateSettings;
end;

procedure TfrmVWM.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmVWM.sgb_backgroundChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmVWM.UpdateSettings;
begin
  if Visible then
    PluginHost.Save;
end;

end.

