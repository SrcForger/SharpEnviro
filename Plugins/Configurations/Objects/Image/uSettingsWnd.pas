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
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JclFileUtils,
  ImgList,
  PngImageList,
  GR32,
  GR32_PNG,
  SharpApi,
  ExtCtrls,
  Menus,
  JclStrings,
  GR32_Image,
  SharpEGaugeBoxEdit,
  SharpEUIC,
  SharpEFontSelectorFontList,
  JvPageList,
  JvExControls,
  SharpEPageControl,
  ComCtrls,
  SharpEColorEditorEx,
  SharpESwatchManager,

  ISharpCenterHostUnit,
  SharpDialogs,
  ISharpCenterPluginUnit,
  SharpECenterHeader,
  Buttons,
  PngSpeedButton,
  pngimage;

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
    pageurl: TJvStandardPage;
    imageurl: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    sgb_size: TSharpeGaugeBox;
    Panel3: TPanel;
    sbgimagencblendalpha: TSharpeGaugeBox;
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
    Panel7: TPanel;
    Image1: TImage;
    Label1: TLabel;
    btnRevert: TPngSpeedButton;
    Panel8: TPanel;
    PngSpeedButton1: TPngSpeedButton;
    imagefile: TEdit;
    OpenDialog1: TOpenDialog;
    pnlDisplay: TPanel;
    pnlImage: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure sgb_sizeChangeValue(Sender: TObject; Value: Integer);
    procedure UIC_Reset(Sender: TObject);
    procedure spcTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure IconColorsChangeColor(ASender: TObject; AValue: Integer);
    procedure sgbiconalphaChangeValue(Sender: TObject; Value: Integer);
    procedure cbalphablendClick(Sender: TObject);
    procedure sbgimagencblendalphaChangeValue(Sender: TObject; Value: Integer);
    procedure cbcolorblendClick(Sender: TObject);
    procedure imagefileChange(Sender: TObject);
    procedure imageurlChange(Sender: TObject);
    procedure btnRevertClick(Sender: TObject);
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure IconColorsResize(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    function GetChangedControlCount: integer;
    procedure UpdateSettingsChanged;

    procedure UpdateImagePage;
    procedure UpdateDisplayPage;
  public
    sObjectID: string;

    property PluginHost: ISharpCenterHost read FPluginHost
      write FPluginHost;

    procedure UpdatePageUI;

  end;

var
  frmSettings: TfrmSettings;

implementation

uses 
  SharpCenterApi;

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

  UpdatePageUI;
  UpdateSettingsChanged;
end;

procedure TfrmSettings.UIC_Reset(Sender: TObject);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettings.btnRevertClick(Sender: TObject);
var
  i: Integer;
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
  i: Integer;
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

  UpdatePageUI;
  UpdateSettingsChanged;
end;

procedure TfrmSettings.cbcolorblendClick(Sender: TObject);
begin
  UIC_ColorBlend.UpdateStatus;

  UpdatePageUI;
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
  UIC_Colors.Height := IconColors.Height + 4;
  UpdateDisplayPage;
end;

procedure TfrmSettings.imagefileChange(Sender: TObject);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettings.imageurlChange(Sender: TObject);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettings.PngSpeedButton1Click(Sender: TObject);
var
  s: string;
begin
  if OpenDialog1.Execute then
    s := OpenDialog1.FileName;
  if length(trim(s)) > 0 then
  begin
    imagefile.Text := s;
  end;
end;

procedure TfrmSettings.UpdateSettingsChanged;
begin
  if (Visible) then begin
    PluginHost.SetSettingsChanged;
  end;

  btnRevert.Visible := (GetChangedControlCount <> 0);
end;

procedure TfrmSettings.UpdateDisplayPage;
begin
  LockWindowUpdate(self.Handle);
  try
    if pagDisplay.Visible then begin

      UIC_blendalpha.Visible := cbalphablend.Checked;
      UIC_ColorAlpha.Visible := cbcolorblend.Checked;

      frmSettings.Height := pnlDisplay.Height;
      PluginHost.Refresh(rtSize);
    end;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmSettings.UpdateImagePage;
begin
  LockWindowUpdate(self.Handle);
  try
    if pagImage.Visible then begin

      if pl.ActivePageIndex = 0 then begin
        spc.Height := 205;
        pl.Height := 80;
      end else begin
        spc.Height := 285;
        pl.Height := 160;
      end;

      frmSettings.Height := pnlImage.Height + 50;
      PluginHost.Refresh(rtSize);
    end;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmSettings.UpdatePageUI;
begin
  if pagImage.Visible then
    UpdateImagePage
  else if pagDisplay.Visible then
    UpdateDisplayPage;
end;

end.

