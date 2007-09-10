{
Source Name: uMiniScmdWnd.pas
Description: MiniScmd Module Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uMiniScmdWnd;

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
  TfrmMiniScmd = class(TForm)
    plMain: TJvPageList;
    pagMiniScmd: TJvStandardPage;
    Label5: TLabel;
    cb_quickselect: TCheckBox;
    Label3: TLabel;
    Panel1: TPanel;
    sgb_width: TSharpeGaugeBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_quickselectClick(Sender: TObject);
    procedure sgb_widthChangeValue(Sender: TObject; Value: Integer);
  private
    procedure UpdateSettings;
  public
    sModuleID: string;
    sBarID : string;
  end;

var
  frmMiniScmd: TfrmMiniScmd;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmMiniScmd.cb_quickselectClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmMiniScmd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmMiniScmd.FormShow(Sender: TObject);
begin
  Label5.Font.Color := clGrayText;
end;

procedure TfrmMiniScmd.sgb_widthChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings
end;

procedure TfrmMiniScmd.UpdateSettings;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

