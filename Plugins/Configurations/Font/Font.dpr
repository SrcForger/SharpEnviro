{
Source Name: Font
Description: Font Config Dll
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

library Font;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  SharpEUIC,
  uVistaFuncs,
  SharpThemeApi,
  SysUtils,
  Graphics,
  SharpEFontSelectorFontList,
  uFontWnd in 'uFontWnd.pas' {frmFont},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}

procedure Save;
begin
  if frmFont = nil then
    exit;

  frmFont.SaveSettings;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML: TJvSimpleXML;
  sFontName: string;
  n: integer;
  s: string;
begin
  if frmFont = nil then
    frmFont := TfrmFont.Create(nil);

  uVistaFuncs.SetVistaFonts(frmFont);
  frmFont.sTheme := APluginID;
  frmFont.ParentWindow := aowner;
  frmFont.Left := 2;
  frmFont.Top := 2;
  frmFont.BorderStyle := bsNone;

  sFontName := XmlGetFontFile(APluginID);
  if FileExists(sFontName) then begin
    XML := TJvSimpleXML.Create(nil);
    frmFont.cb_Underline.OnClick := nil;
    frmFont.cb_Italic.OnClick := nil;
    frmFont.cb_bold.OnClick := nil;
    frmFont.cb_shadow.OnClick := nil;

    try
      try
        XML.LoadFromFile(sFontName);
        with frmFont do
          with XML.Root.Items do begin
            if BoolValue('ModSize', False) then begin
              sgb_size.Value := IntValue('ValueSize', sgb_size.Value);
              UIC_size.UpdateStatus;
            end;

            if BoolValue('ModName', False) then begin
              UIC_FontType.HasChanged := True;
              s := Value('ValueName', '');
              for n := 0 to FontList.List.Count - 1 do
                if CompareText(TFontInfo(FontList.List.Objects[n]).FullName, s) = 0 then begin
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
          end;
      except
      end;

    finally
      XML.Free;

      frmFont.cb_Underline.OnClick := frmFont.cb_UnderlineClick;
      frmFont.cb_Italic.OnClick := frmFont.cb_ItalicClick;
      frmFont.cb_bold.OnClick := frmFont.cb_boldClick;
      frmFont.cb_shadow.OnClick := frmFont.cb_shadowClick;
    end;

  end;

  frmFont.Show;
  result := frmFont.Handle;
end;

function Close: boolean;
begin
  result := True;
  try
    frmFont.Close;
    frmFont.Free;
    frmFont := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Skin Font';
end;


procedure GetCenterScheme(var ABackground: TColor;
  var AItemColor: TColor; var AItemSelectedColor: TColor);
var
  n: integer;
begin
  if frmFont <> nil then begin
    for n := 0 to frmFont.ComponentCount - 1 do
      if frmFont.Components[n] is TSharpEUIC then begin
        TSharpEUIC(frmFont.Components[n]).NormalColor := clWindow;
        TSharpEUIC(frmFont.Components[n]).BorderColor := AItemSelectedColor;
        TSharpEUIC(frmFont.Components[n]).BackgroundColor := $00F7F7F7;
      end;
  end;
end;

procedure AddTabs(var ATabs: TPluginTabItemList);
begin
  ATabs.Add('Font Face', frmFont.pagFont, '', '');
  ATabs.Add('Font Shadow', frmFont.pagFontShadow, '', '');
end;

procedure ClickTab(ATab: TPluginTabItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.Data <> nil then begin
    tmpPag := TJvStandardPage(ATab.Data);
    tmpPag.Show;
  end;

end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  result := suSkinFont;
end;

exports
  Open,
  Close,
  Save,
  ClickTab,
  SetText,
  GetCenterScheme,
  AddTabs;

end.

