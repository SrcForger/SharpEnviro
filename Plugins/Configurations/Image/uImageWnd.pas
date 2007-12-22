{
Source Name: uImageWnd.pas
Description: Image Object Settings Window
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

unit uImageWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit, SharpEUIC,
  SharpEFontSelectorFontList, JvPageList, JvExControls, SharpEPageControl,
  ComCtrls, Mask, JvExMask, JvToolEdit, SharpEColorEditorEx, SharpESwatchManager;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmImage = class(TForm)
    plMain: TJvPageList;
    pagImage: TJvStandardPage;
    pagDisplay: TJvStandardPage;
    Label4: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label9: TLabel;
    spc: TSharpEPageControl;
    Label13: TLabel;
    pl: TJvPageList;
    pagefile: TJvStandardPage;
    Label1: TLabel;
    imagefile: TJvFilenameEdit;
    pageurl: TJvStandardPage;
    Label14: TLabel;
    imageurl: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    sgb_refresh: TSharpeGaugeBox;
    Panel2: TPanel;
    sgb_size: TSharpeGaugeBox;
    Panel3: TPanel;
    Label3: TLabel;
    sbgimagencblendalpha: TSharpeGaugeBox;
    Panel10: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    UIC_colorblend: TSharpEUIC;
    cbcolorblend: TCheckBox;
    UIC_ColorAlpha: TSharpEUIC;
    Panel5: TPanel;
    Label12: TLabel;
    UIC_alphablend: TSharpEUIC;
    cbalphablend: TCheckBox;
    UIC_blendalpha: TSharpEUIC;
    sgbiconalpha: TSharpeGaugeBox;
    UIC_Colors: TSharpEUIC;
    IconColors: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
    procedure FormCreate(Sender: TObject);
    procedure sgb_sizeChangeValue(Sender: TObject; Value: Integer);
    procedure FormShow(Sender: TObject);
    procedure UIC_Reset(Sender: TObject);
    procedure spcTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure IconColorsResize(Sender: TObject);
    procedure IconColorsChangeColor(ASender: TObject; AValue: Integer);
    procedure sgbiconalphaChangeValue(Sender: TObject; Value: Integer);
    procedure cbalphablendClick(Sender: TObject);
    procedure sbgimagencblendalphaChangeValue(Sender: TObject; Value: Integer);
    procedure cbcolorblendClick(Sender: TObject);
    procedure imagefileChange(Sender: TObject);
    procedure imageurlChange(Sender: TObject);
  private
  public
    sObjectID: string;
  end;

var
  frmImage: TfrmImage;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmImage.sbgimagencblendalphaChangeValue(Sender: TObject;
  Value: Integer);
begin
  UIC_ColorAlpha.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmImage.sgbiconalphaChangeValue(Sender: TObject; Value: Integer);
begin
  UIC_BlendAlpha.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmImage.sgb_sizeChangeValue(Sender: TObject; Value: Integer);
begin
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmImage.spcTabChange(ASender: TObject; const ATabIndex: Integer;
  var AChange: Boolean);
begin
  pl.ActivePageIndex := ATabIndex;
  Achange := True;
end;

procedure TfrmImage.UIC_Reset(Sender: TObject);
begin
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmImage.cbalphablendClick(Sender: TObject);
begin
  UIC_AlphaBlend.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmImage.cbcolorblendClick(Sender: TObject);
begin
  UIC_ColorBlend.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmImage.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmImage.FormShow(Sender: TObject);
begin
  Label3.Font.Color := clGrayText;
  Label12.Font.Color := clGrayText;
  Label13.Font.Color := clGrayText;
  Label4.Font.Color := clGrayText;
  Label5.Font.Color := clGrayText;
  Label10.Font.Color := clGrayText;
  Label1.Font.Color := clGrayText;
  Label14.Font.Color := clGrayText;
  Label7.Font.Color := clGrayText;
end;

procedure TfrmImage.IconColorsChangeColor(ASender: TObject; AValue: Integer);
begin
  UIC_Colors.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmImage.IconColorsResize(Sender: TObject);
begin
  UIC_Colors.Height := IconColors.Height + 8;
end;

procedure TfrmImage.imagefileChange(Sender: TObject);
begin
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmImage.imageurlChange(Sender: TObject);
begin
  SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

