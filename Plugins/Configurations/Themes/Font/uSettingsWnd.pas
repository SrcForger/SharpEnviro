{
Source Name: uFontWnd.pas
Description: Font Window
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
  Math,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JvSimpleXml,
  JclFileUtils,
  ImgList,
  PngImageList,
  SharpEListBox,
  SharpEListBoxEx,
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
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  JvExControls, SharpECenterHeader, JvXPCore, JvXPCheckCtrls, pngimage, Buttons,
  PngSpeedButton;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmSettingsWnd = class(TForm)
    Panel1: TPanel;
    plMain: TJvPageList;
    pagFont: TJvStandardPage;
    pagFontShadow: TJvStandardPage;
    UIC_Size: TSharpEUIC;
    sgb_size: TSharpeGaugeBox;
    UIC_FontType: TSharpEUIC;
    cbxFontName: TComboBox;
    UIC_Alpha: TSharpEUIC;
    sgb_alpha: TSharpeGaugeBox;
    UIC_Shadow: TSharpEUIC;
    textpanel: TPanel;
    UIC_ShadowType: TSharpEUIC;
    cb_shadowtype: TComboBox;
    UIC_ShadowAlpha: TSharpEUIC;
    sgb_shadowalpha: TSharpeGaugeBox;
    UIC_Bold: TSharpEUIC;
    UIC_Italic: TSharpEUIC;
    UIC_Underline: TSharpEUIC;
    UIC_ClearType: TSharpEUIC;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader11: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader13: TSharpECenterHeader;
    SharpECenterHeader5: TSharpECenterHeader;
    SharpECenterHeader6: TSharpECenterHeader;
    cb_cleartype: TJvXPCheckbox;
    cb_Italic: TJvXPCheckbox;
    cb_Underline: TJvXPCheckbox;
    cb_bold: TJvXPCheckbox;
    cb_shadow: TJvXPCheckbox;
    imlFontIcons: TPngImageList;
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    btnRevert: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sgb_sizeChangeValue(Sender: TObject; Value: Integer);
    procedure cbxFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
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
    procedure FormDestroy(Sender: TObject);
    procedure cb_cleartypeClick(Sender: TObject);
    procedure btnRevertClick(Sender: TObject);
  private
    FFontList: TFontList;
    FPluginHost: TInterfacedSharpCenterHostBase;
    function GetChangedControlCount: integer;
    procedure UpdateSettingsChanged;
  public
    procedure SaveSettings;
    procedure RefreshFontList;
    procedure LoadSettings;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;

implementation

uses SharpThemeApi;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmSettingsWnd.RefreshFontList;
var
  fi: TFontInfo;
  i: integer;
  DuplicateCheck: Integer;
begin
  cbxFontName.Items.Clear;
  try
    for i := 0 to pred(FFontList.List.Count) do begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cbxFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
        cbxFontName.Items.AddObject(FFontList.List.Strings[i], fi);
    end;
  finally
    cbxFontName.ItemIndex := cbxFontName.Items.IndexOf('Arial');
  end;
end;

procedure TfrmSettingsWnd.SaveSettings;
var
  XML: TJvSimpleXML;
  sDir: string;
begin
  sDir := SharpApi.GetSharpeUserSettingsPath + 'Themes\' + PluginHost.PluginId;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.Root.Name := 'ThemeFontSettings';
    with XML.Root.Items do begin
      Add('ModSize', UIC_Size.HasChanged);
      Add('ModName', UIC_FontType.HasChanged);
      Add('ModAlpha', UIC_Alpha.HasChanged);
      Add('ModUseShadow', UIC_Shadow.HasChanged);
      Add('ModShadowType', UIC_ShadowType.HasChanged);
      Add('ModShadowAlpha', UIC_ShadowAlpha.HasChanged);
      Add('ModBold', UIC_Bold.HasChanged);
      Add('ModItalic', UIC_Italic.HasChanged);
      Add('ModUnderline', UIC_Underline.HasChanged);
      Add('ModClearType', UIC_ClearType.HasChanged);
      Add('ValueSize', sgb_size.Value);
      Add('ValueName', cbxFontName.Text);
      Add('ValueAlpha', sgb_Alpha.value);
      Add('ValueUseShadow', cb_Shadow.checked);
      Add('ValueShadowType', cb_shadowtype.ItemIndex);
      Add('ValueShadowAlpha', sgb_shadowalpha.Value);
      Add('ValueBold', cb_bold.checked);
      Add('ValueItalic', cb_italic.checked);
      Add('ValueUnderline', cb_underline.checked);
      Add('ValueClearType', cb_ClearType.Checked);
    end;
    XML.SaveToFile(sDir + '\Font.xml~');

    if FileExists(sDir + '\Font.xml') then
      DeleteFile(sDir + '\Font.xml');

    RenameFile(sDir + '\Font.xml~', sDir + '\Font.xml');

  finally
    XML.Free;
  end;
end;

procedure TfrmSettingsWnd.sgb_alphaChangeValue(Sender: TObject; Value: Integer);
begin
  UIC_ALPHA.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.sgb_shadowalphaChangeValue(Sender: TObject; Value: Integer);
begin
  UIC_ShadowAlpha.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.sgb_sizeChangeValue(Sender: TObject; Value: Integer);
begin
  UIC_Size.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.UIC_Reset(Sender: TObject);
begin
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.btnRevertClick(Sender: TObject);
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

procedure TfrmSettingsWnd.cbxFontNameChange(Sender: TObject);
begin
  UIC_FontType.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.cbxFontNameDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  fi: TFontInfo;
  imageindex: integer;
  textheight: integer;
begin
  cbxFontName.canvas.fillrect(rect);
  fi := TFontInfo(cbxFontName.Items.Objects[Index]);

  imageindex := -1;
  case fi.FontType of
    ftTrueType: imageindex := 0;
  end;

  imlFontIcons.Draw(cbxFontName.Canvas, rect.left, rect.top+1, imageindex);

  cbxFontName.Canvas.Font.Name := fi.ShortName;
  textheight := cbxFontName.Canvas.TextHeight(fi.FullName);

  if textheight > cbxFontName.ItemHeight then
    cbxFontName.Canvas.Font.Name := 'Arial';

  cbxFontName.canvas.textout(rect.left + imlFontIcons.width + 2, rect.top, fi.FullName);
end;

procedure TfrmSettingsWnd.cb_boldClick(Sender: TObject);
begin
  UIC_Bold.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.cb_cleartypeClick(Sender: TObject);
begin
  UIC_ClearType.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.cb_ItalicClick(Sender: TObject);
begin
  UIC_Italic.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.cb_shadowClick(Sender: TObject);
begin
  UIC_Shadow.UpdateStatus;
  if cb_shadow.Checked then
    textpanel.Show
  else
    textpanel.Hide;

  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.cb_shadowtypeChange(Sender: TObject);
begin
  UIC_ShadowType.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.cb_UnderlineClick(Sender: TObject);
begin
  UIC_Underline.UpdateStatus;
  UpdateSettingsChanged;
end;

procedure TfrmSettingsWnd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  FFontList := TFontList.Create;
  FFontList.RefreshFontInfo;
  RefreshFontList;
end;

procedure TfrmSettingsWnd.FormDestroy(Sender: TObject);
begin
  FFontList.Free;
end;

procedure TfrmSettingsWnd.FormShow(Sender: TObject);
begin
  if cb_shadow.Checked then
    textpanel.Show
  else
    textpanel.Hide;

  LoadSettings;

end;

function TfrmSettingsWnd.GetChangedControlCount: integer;
var
  i, n:Integer;
begin
  result := 0;
  for i := 0 to Pred(Self.ComponentCount) do begin
    if Self.Components[i].ClassNameIs('TSharpEUIC') then begin
      if TSharpEUIC(Self.Components[i]).HasChanged then
        Inc(Result);
    end;
  end;
end;
procedure TfrmSettingsWnd.LoadSettings;
var
  XML: TJvSimpleXML;
  sFontName: string;
  n: integer;
  s: string;
begin
  sFontName := XmlGetFontFile(PluginHost.PluginId);
  if FileExists(sFontName) then begin
    XML := TJvSimpleXML.Create(nil);
    cb_Underline.OnClick := nil;
    cb_Italic.OnClick := nil;
    cb_bold.OnClick := nil;
    cb_shadow.OnClick := nil;
    cb_cleartype.OnClick := nil;

    try
      XML.LoadFromFile(sFontName);

      with XML.Root.Items do begin
        if BoolValue('ModSize', False) then begin
          sgb_size.Value := IntValue('ValueSize', sgb_size.Value);
          UIC_size.UpdateStatus;
        end;

        if BoolValue('ModName', False) then begin
          UIC_FontType.HasChanged := True;
          s := Value('ValueName', '');
          for n := 0 to cbxFontName.Items.Count - 1 do
            if CompareText(TFontInfo(cbxFontName.Items.Objects[n]).FullName, s) = 0 then begin
              cbxFontName.ItemIndex := n;
              break;
            end;
        end;
        if cbxFontName.ItemIndex = -1 then
          cbxFontName.ItemIndex := cbxFontName.Items.IndexOf('arial');

        if BoolValue('ModAlpha', False) then begin
          sgb_Alpha.value := IntValue('ValueAlpha', sgb_Alpha.value);
          UIC_Alpha.UpdateStatus;
        end;

        if BoolValue('ModUseShadow', False) then begin
          UIC_Shadow.HasChanged := True;
          cb_shadow.Checked := BoolValue('ValueUseShadow', cb_shadow.Checked);
        end;


        if BoolValue('ModShadowType', False) then begin
          UIC_ShadowType.HasChanged := True;
          cb_shadowtype.ItemIndex := Max(0, Min(3, IntValue('ValueShadowType', 0)));
        end;


        if BoolValue('ModShadowAlpha', False) then begin
          sgb_shadowAlpha.Value := IntValue('ValueShadowAlpha', sgb_shadowAlpha.Value);
          UIC_ShadowAlpha.UpdateStatus;
        end;

        if BoolValue('ModBold', False) then begin
          UIC_Bold.HasChanged := True;
          cb_bold.checked := BoolValue('ValueBold', cb_bold.checked);
        end;

        if BoolValue('ModItalic', False) then begin
          UIC_Italic.HasChanged := True;
          cb_italic.checked := BoolValue('ValueItalic', cb_bold.checked);
        end;

        if BoolValue('ModUnderline', False) then begin
          UIC_Underline.HasChanged := True;
          cb_underline.checked := BoolValue('ValueUnderline', cb_bold.checked);
        end;

        if BoolValue('ModClearType', False) then begin
          UIC_ClearType.HasChanged := True;
          cb_cleartype.checked := BoolValue('ValueClearType', cb_cleartype.checked);
        end;
      end;

    finally
      XML.Free;

      cb_cleartype.OnClick := cb_ClearTypeClick;
      cb_Underline.OnClick := cb_UnderlineClick;
      cb_Italic.OnClick := cb_ItalicClick;
      cb_bold.OnClick := cb_boldClick;
      cb_shadow.OnClick := cb_shadowClick;
    end;
  end;
end;

procedure TfrmSettingsWnd.UpdateSettingsChanged;
begin
  PluginHost.SetSettingsChanged;
  PluginHost.Refresh;
  btnRevert.Visible := (GetChangedControlCount <> 0);
  textpanel.Visible := cb_shadow.Checked;
end;

end.

