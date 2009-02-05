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

unit uSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit, SharpEUIC,
  SharpEFontSelectorFontList, JvPageList, JvExControls, SharpEPageControl,
  ComCtrls, Mask, JvExMask, JvToolEdit, SharpEColorEditorEx, SharpESwatchManager,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit, SharpECenterHeader, Buttons, PngSpeedButton, pngimage;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmSettings = class(TForm)
    plMain: TJvPageList;
    pagImage: TJvStandardPage;
    pagDisplay: TJvStandardPage;
    spc: TSharpEPageControl;
    pl: TJvPageList;
    pagefile: TJvStandardPage;
    imagefile: TJvFilenameEdit;
    pageurl: TJvStandardPage;
    imageurl: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    sgb_size: TSharpeGaugeBox;
    Panel3: TPanel;
    sbgimagencblendalpha: TSharpeGaugeBox;
    Panel10: TPanel;
    UIC_colorblend: TSharpEUIC;
    cbcolorblend: TCheckBox;
    UIC_ColorAlpha: TSharpEUIC;
    Panel5: TPanel;
    UIC_alphablend: TSharpEUIC;
    cbalphablend: TCheckBox;
    UIC_blendalpha: TSharpEUIC;
    sgbiconalpha: TSharpeGaugeBox;
    UIC_Colors: TSharpEUIC;
    IconColors: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader4: TSharpECenterHeader;
    SharpECenterHeader5: TSharpECenterHeader;
    SharpECenterHeader6: TSharpECenterHeader;
    SharpECenterHeader7: TSharpECenterHeader;
    Panel4: TPanel;
    sgb_refresh: TSharpeGaugeBox;
    Panel6: TPanel;
    Panel7: TPanel;
    Image1: TImage;
    Label1: TLabel;
    btnRevert: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sgb_sizeChangeValue(Sender: TObject; Value: Integer);
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
    procedure btnRevertClick(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    function GetChangedControlCount: integer;
    procedure UpdateSettingsChanged;
  public
    sObjectID: string;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost
      write FPluginHost;

  end;

var
  frmSettings: TfrmSettings;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmSettings.sbgimagencblendalphaChangeValue(Sender: TObject;
  Value: Integer);
begin
  UIC_ColorAlpha.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettings.sgbiconalphaChangeValue(Sender: TObject; Value: Integer);
begin
  UIC_BlendAlpha.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettings.sgb_sizeChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettings.spcTabChange(ASender: TObject; const ATabIndex: Integer;
  var AChange: Boolean);
begin
  pl.ActivePageIndex := ATabIndex;
  Achange := True;
end;

procedure TfrmSettings.UIC_Reset(Sender: TObject);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettings.btnRevertClick(Sender: TObject);
var
  i:Integer;
begin

  for i := 0 to Pred(Self.ComponentCount) do begin
    if Self.Components[i].ClassNameIs('TSharpEUIC') then begin
      TSharpEUIC(Self.Components[i]).Reset;
    end;
  end;

  UpdateSettingsChanged;
end;

function TfrmSettings.GetChangedControlCount: integer;
var
  i:Integer;
begin
  result := 0;
  for i := 0 to Pred(Self.ComponentCount) do begin
    if Self.Components[i].ClassNameIs('TSharpEUIC') then begin
      if TSharpEUIC(Self.Components[i]).HasChanged then
        Inc(Result);
    end;
  end;
end;

procedure TfrmSettings.cbalphablendClick(Sender: TObject);
begin
  UIC_AlphaBlend.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettings.cbcolorblendClick(Sender: TObject);
begin
  UIC_ColorBlend.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmSettings.IconColorsChangeColor(ASender: TObject; AValue: Integer);
begin
  UIC_Colors.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettings.IconColorsResize(Sender: TObject);
begin
  UIC_Colors.Height := IconColors.Height + 8;
end;

procedure TfrmSettings.imagefileChange(Sender: TObject);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettings.imageurlChange(Sender: TObject);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettings.UpdateSettingsChanged;
begin
  if (Visible) then begin
    PluginHost.SetSettingsChanged;
    PluginHost.Refresh;
  end;

  btnRevert.Visible := (GetChangedControlCount <> 0);
end;

end.

