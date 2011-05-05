{
Source Name: BarPreview.pas
Description: SharpE Bar Preview Rendering
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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

unit BarPreview;

interface

uses SharpApi, Types, SharpThemeApiEx, uThemeConsts, Math, GR32, JclSimpleXML,
  BarForm, SharpEBar, Windows, SysUtils, Dialogs, Graphics, uISharpETheme;

procedure CreateBarPreview(srcBitmap: TBitmap32; theme, skin, scheme: string; barWidth: integer;
  var colors: TSharpEColorSet; drawGlass: boolean = false); overload;

procedure CreateBarPreview(srcBitmap: TBitmap32; theme, skin, scheme: string; barWidth: integer;
  ITheme : ISharpETheme; drawGlass: Boolean = false); overload;

procedure XmlGetThemeScheme(ATheme: string; AScheme: string; ASkin: string;
  var AThemeScheme: TSharpEColorSet; ITheme : ISharpETheme); overload;  

implementation

procedure XmlGetThemeScheme(ATheme: string; AScheme: string; ASkin: string;
  var AThemeScheme: TSharpEColorSet; ITheme : ISharpETheme); overload;
var
  XML: TJclSimpleXML;
  i, j, Index: Integer;
  tmpRec: TSharpESkinColor;
  sFile, sTag, sCurScheme: string;
  tmpColor: string;
  s: string;

  sTheme, sSkin: string;
  sSkinDir, sSchemeDir: string;
begin
  Index := 0;

  sTheme := ATheme;
  sCurScheme := AScheme;
  sSkin := ASkin;

  if ((sTheme = '') or (sCurScheme = '') or (sSkin = '')) then begin
    SharpApi.SendDebugMessageEx('SharpThemeApi', 'Some parameters were invalid for XmlGetThemeScheme', 0, DMT_ERROR);
    Setlength(AThemeScheme, 0);
    Exit;
  end;

  sSkinDir := GetSharpeDirectory + SKINS_DIRECTORY + '\' + sSkin + '\';
  sSchemeDir := GetSharpeUserSettingsPath + SKINS_SCHEME_DIRECTORY + '\' + sSkin + '\';

  XML := TJclSimpleXML.Create;
  try

    // Get Scheme Colors
    Setlength(AThemeScheme, 0);
    XML.Root.Clear;

    XML.LoadFromFile(sSkinDir + SKINS_SCHEME_FILE);
    for i := 0 to Pred(XML.Root.Items.Count) do begin

      SetLength(AThemeScheme, length(AThemeScheme) + 1);
      tmpRec := AThemeScheme[i];

      with XML.Root.Items.Item[i].Items do begin
        tmpRec.Name := Value('name', '');
        tmpRec.Tag := Value('tag', '');
        tmpRec.Info := Value('info', '');
        tmpRec.Color := ITheme.Scheme.ParseColor(Value('Default', '0'));
        s := Value('type', 'color');
        if CompareText(s, 'boolean') = 0 then
          tmpRec.schemetype := stBoolean
        else if CompareText(s, 'integer') = 0 then
          tmpRec.schemetype := stInteger
        else if CompareText(s, 'dynamic') = 0 then
          tmpRec.schemetype := stDynamic
        else
          tmpRec.schemetype := stColor;
      end;

      AThemeScheme[i] := tmpRec;
    end;

    sFile := sSchemeDir + sCurScheme + '.xml';
    if FileExists(sFile) then begin
      XML.LoadFromFile(sFile);

      for i := 0 to Pred(XML.Root.Items.Count) do
        with XML.Root.Items.Item[i].Items do begin
          sTag := Value('tag', '');
          tmpColor := Value('color', inttostr(AThemeScheme[Index].Color));

          for j := 0 to high(AThemeScheme) do begin
            if CompareText(AThemeScheme[j].Tag, sTag) = 0 then begin
              AThemeScheme[j].Color := ITheme.Scheme.ParseColor(PChar(tmpColor));
              break;
            end;
          end;
        end;
    end;
  finally
    XML.Free;
  end;
end;

procedure CreateBarPreview(srcBitmap: TBitmap32; theme, skin, scheme: string; barWidth: integer;
  ITheme : ISharpETheme; drawGlass: Boolean = false);
var
  colors: TSharpEColorSet;
begin
  XmlGetThemeScheme(theme, scheme, skin, colors, ITheme);
  CreateBarPreview( srcBitmap, theme, skin, scheme, barWidth, colors, drawGlass );
end;

procedure CreateBarPreview(srcBitmap: TBitmap32; theme, skin, scheme: string; barWidth: integer;
  var colors: TSharpEColorSet; drawGlass: Boolean = false);
const
  csize = 12;
var
  BarWnd: TBarWnd;
  skinfile: string;
  schemefile: string;
  themeskinfile: string;
  xml: TJclSimpleXML;
  throbberpos: TPoint;
  buttonpos: TPoint;
  x, y: integer;
  r : TRect;
begin
  xml := TJclSimpleXML.Create;
  try

    // Get the files
    skinfile := GetSharpeDirectory + 'Skins\' + skin + '\' + THEME_SKIN_FILE;
    themeskinfile := GetSharpeUserSettingsPath + 'Themes\' + Theme + '\' + THEME_SKIN_FILE;
    schemefile := GetSharpeDirectory + 'Skins\' + skin + '\' + THEME_SCHEME_FILE;

    // Precheck
    if not (fileExists(skinfile)) then exit;

    // Create the bar and load the skin
    BarWnd := TBarWnd.Create(nil);
    BarWnd.SkinComp.LoadFromXmlFile(skinfile);
    BarWnd.SkinManager.SetSkinDesign('Default');
    BarWnd.Visible := false;
    BarWnd.Width := barWidth;

    // Get the scheme
    BarWnd.Scheme.Colors := colors;
    BarWnd.SkinComp.UpdateDynamicProperties(BarWnd.Scheme);

    // Apply the scheme and skin to the bar
    BarWnd.Bar.UpdateSkin;

    // Set bar size and initialise
    srcBitmap.SetSize(max(barWidth, 1), BarWnd.SkinManager.Skin.Bar.BarHeight);
    srcBitmap.Clear(color32(0, 0, 0, 0));

    if drawGlass then
    begin
      with BarWnd.Background do
      begin
        SetSize(srcBitmap.Width + 3 * csize, srcBitmap.Height + 3 * csize);
        Clear(color32(clsilver));
        for x := 0 to (srcBitmap.Width + 2 * csize) div (2 * csize) do
          for y := 0 to (srcBitmap.Height + 2 * csize) div (csize) do
            if y mod 2 = 0 then
              FillRect(2 * x * csize, y * csize, 2 * x * csize + csize, y * csize + csize, clWhite32)
            else FillRect(2 * x * csize + csize, y * csize, 2 * x * csize + 2 * csize, y * csize + csize, clWhite32);
        DrawTo(srcBitmap, -round(1.5 * csize), -round(1.5 * csize));
      end;

      if BarWnd.SkinManager.Skin.Bar.GlassEffect then
      begin
        xml.LoadFromFile(themeskinfile);
        with xml.Root.Items do
        begin
          BarWnd.ApplyGlassEffect(IntValue('GEBlurRadius', 2),
            IntValue('GEBlurIterations', 2),
            BoolValue('GEBlend', False),
            IntValue('GEBlendColor', clblue),
            IntValue('GEBlendAlpha', 32),
            BoolValue('GELighten', True),
            IntValue('GELightenAmount', 23));
        end;
      end;
    end;

    // Draw background
    BarWnd.Bar.abackground.Skin.Drawto(srcBitmap, 0, 0);

    // Draw bar
    BarWnd.Bar.Skin.DrawTo(srcBitmap, 0, 0);

    // Draw throbber
    r := BarWnd.SkinManager.Skin.Bar.GetThrobberDim(Rect(0,0,BarWnd.Width,BarWnd.Height));
    ThrobberPos := Point(r.left,r.top);
    BarWnd.Bar.Throbber.UpdateSkin;
    BarWnd.Bar.Throbber.Skin.DrawTo(srcBitmap, ThrobberPos.X, ThrobberPos.Y);

    // Draw button
    ButtonPos := Point(BarWnd.SkinManager.Skin.Bar.PAXoffset.X + 8,
      BarWnd.SkinManager.Skin.Bar.PAYoffset.X + BarWnd.SkinManager.Skin.Button.Location.Y);
    BarWnd.Button.UpdateSkin;
    BarWnd.Button.Skin.DrawTo(srcBitmap, ButtonPos.X, ButtonPos.Y);
  finally
    xml.Free;
    FreeAndNil(BarWnd);
  end;
end;

end.

