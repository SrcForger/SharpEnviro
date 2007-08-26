{
Source Name: uFontWnd.pas
Description: Font Window
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

unit uFontWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit, SharpEUIC,
  SharpEFontSelectorFontList, JvPageList, JvExControls;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmFont = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    imlFontIcons: TImageList;
    plMain: TJvPageList;
    pagFont: TJvStandardPage;
    pagFontShadow: TJvStandardPage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    UIC_Size: TSharpEUIC;
    sgb_size: TSharpeGaugeBox;
    UIC_FontType: TSharpEUIC;
    cbxFontName: TComboBox;
    UIC_Alpha: TSharpEUIC;
    sgb_alpha: TSharpeGaugeBox;
    Label9: TLabel;
    Label10: TLabel;
    UIC_Shadow: TSharpEUIC;
    cb_shadow: TCheckBox;
    textpanel: TPanel;
    lb_shadowtype: TLabel;
    lb_shadowalpha: TLabel;
    UIC_ShadowType: TSharpEUIC;
    cb_shadowtype: TComboBox;
    UIC_ShadowAlpha: TSharpEUIC;
    sgb_shadowalpha: TSharpeGaugeBox;
    Label8: TLabel;
    Label7: TLabel;
    UIC_Bold: TSharpEUIC;
    cb_bold: TCheckBox;
    UIC_Italic: TSharpEUIC;
    cb_Italic: TCheckBox;
    UIC_Underline: TSharpEUIC;
    cb_Underline: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure sgb_sizeChangeValue(Sender: TObject; Value: Integer);
    procedure cbxFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure cbxFontNameChange(Sender: TObject);
    procedure sgb_alphaChangeValue(Sender: TObject; Value: Integer);
    procedure cb_shadowClick(Sender: TObject);
    procedure cb_shadowtypeChange(Sender: TObject);
    procedure cb_boldClick(Sender: TObject);
    procedure cb_ItalicClick(Sender: TObject);
    procedure cb_UnderlineClick(Sender: TObject);
    procedure sgb_shadowalphaChangeValue(Sender: TObject; Value: Integer);
    procedure FormShow(Sender: TObject);
    procedure UIC_Reset(Sender: TObject);
  private
    FFontList : TFontList;
  public
    sTheme: string;
    procedure SaveSettings;
    procedure RefreshFontList;
    property FontList : TFontList read FFontList;
  end;

var
  frmFont: TfrmFont;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmFont.RefreshFontList;
var
  fi: TFontInfo;
  i: integer;
  DuplicateCheck: Integer;
begin
  FFontList.List.Clear;

  cbxFontName.Items.Clear;
  //cbxFontName.Sorted := True;
  try
    FFontList.RefreshFontInfo;
    for i := 0 To pred(FFontList.List.Count) do begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cbxFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
      cbxFontName.Items.Add(FFontList.List.Strings[i]);
    end;
  finally
  end;
end;

procedure TfrmFont.SaveSettings;
var
  XML: TJvSimpleXML;
  sDir: string;
begin
  sDir := SharpApi.GetSharpeUserSettingsPath + '\Themes\' + sTheme;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.Root.Name := 'ThemeFontSettings';
    with XML.Root.Items do
    begin
      Add('ModSize',UIC_Size.HasChanged);
      Add('ModName',UIC_FontType.HasChanged);
      Add('ModAlpha',UIC_Alpha.HasChanged);
      Add('ModUseShadow',UIC_Shadow.HasChanged);
      Add('ModShadowType',UIC_ShadowType.HasChanged);
      Add('ModShadowAlpha',UIC_ShadowAlpha.HasChanged);
      Add('ModBold',UIC_Bold.HasChanged);
      Add('ModItalic',UIC_Italic.HasChanged);
      Add('ModUnderline',UIC_Underline.HasChanged);
      Add('ValueSize',sgb_size.Value);
      Add('ValueName',cbxFontName.Text);
      Add('ValueAlpha',sgb_Alpha.value);
      Add('ValueUseShadow',cb_Shadow.checked);
      Add('ValueShadowType',cb_shadowtype.ItemIndex);
      Add('ValueShadowAlpha',sgb_shadowalpha.Value);
      Add('ValueBold',cb_bold.checked);
      Add('ValueItalic',cb_italic.checked);
      Add('ValueUnderline',cb_underline.checked);
    end;
    XML.SaveToFile(sDir + '\Font.xml~');

    if FileExists(sDir + '\Font.xml') then
      DeleteFile(sDir + '\Font.xml');

    RenameFile(sDir + '\Font.xml~', sDir + '\Font.xml');

  finally
    XML.Free;
  end;
end;

procedure TfrmFont.sgb_alphaChangeValue(Sender: TObject; Value: Integer);
begin
  UIC_ALPHA.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.sgb_shadowalphaChangeValue(Sender: TObject; Value: Integer);
begin
  UIC_ShadowAlpha.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.sgb_sizeChangeValue(Sender: TObject; Value: Integer);
begin
  UIC_Size.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.UIC_Reset(Sender: TObject);
begin
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.cbxFontNameChange(Sender: TObject);
begin
  UIC_FontType.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.cbxFontNameDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  fi:TFontInfo;
  imageindex : integer;
  itemindex  : integer;
  textheight : integer;
begin
  cbxFontName.canvas.fillrect(rect);

  itemindex := FFontList.List.IndexOf(cbxFontName.Items.Strings[index]);
  fi := TFontInfo(FFontList.List.Objects[itemindex]);

  imageindex := -1;
  case fi.FontType of
    ftTrueType : imageindex := 0;
    ftRaster   : imageindex := 1;
    ftDevice   : imageindex := 2;
  end;

  imlFontIcons.Draw(cbxFontName.Canvas,rect.left,rect.top,imageindex);

  cbxFontName.Canvas.Font.Name := fi.ShortName;
  textheight := cbxFontName.Canvas.TextHeight(fi.FullName);

  if textheight > cbxFontName.ItemHeight then
     cbxFontName.Canvas.Font.Name := 'Arial';

  cbxFontName.canvas.textout(rect.left+imlFontIcons.width+2,rect.top,fi.FullName);
end;

procedure TfrmFont.cb_boldClick(Sender: TObject);
begin
  UIC_Bold.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.cb_ItalicClick(Sender: TObject);
begin
  UIC_Italic.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.cb_shadowClick(Sender: TObject);
begin
  UIC_Shadow.UpdateStatus;
  if cb_shadow.Checked then
    textpanel.Show
    else textpanel.Hide;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.cb_shadowtypeChange(Sender: TObject);
begin
  UIC_ShadowType.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.cb_UnderlineClick(Sender: TObject);
begin
  UIC_Underline.UpdateStatus;
  SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmFont.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  FFontList := TFontList.Create;
  RefreshFontList;
end;

procedure TfrmFont.FormDestroy(Sender: TObject);
begin
  FFontList.Free;
end;

procedure TfrmFont.FormShow(Sender: TObject);
begin
  if cb_shadow.Checked then
    textpanel.Show
    else textpanel.Hide;

  Label4.Font.Color := clGray;
  Label5.Font.Color := clGray;
  Label6.Font.Color := clGray;
  Label7.Font.Color := clGray;
  Label8.Font.Color := clGray;
  lb_shadowtype.Font.Color := clGray;
  lb_shadowalpha.Font.Color := clGray;

end;

end.

