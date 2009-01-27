{
Source Name: BarPreview.pas
Description: SharpE Bar Preview Rendering
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
  BarForm, SharpEBar, Windows, SysUtils, Dialogs, Graphics, uISharpETheme,
  uSharpEMenu, uSharpEMenuSettings;

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
  sSchemeDir := sSkinDir + SKINS_SCHEME_DIRECTORY + '\';

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
  Dir: string;
  skinfile: string;
  schemefile: string;
  themeskinfile: string;
  xml: TJclSimpleXML;
  throbberpos: TPoint;
  buttonpos: TPoint;
  x, y: integer;
begin
  xml := TJclSimpleXML.Create;
  try

    with BarWnd do begin

      // Get the files
      skinfile := GetSharpeDirectory + 'Skins\' + skin + '\skin.xml';
      themeskinfile := GetSharpeUserSettingsPath + 'Themes\' + Theme + '\' + 'skin.xml';
      schemefile := Dir + 'Skins\' + skin + '\scheme.xml';

      // Precheck
      if not (fileExists(skinfile)) then exit;

      {$REGION 'Create bar and apply skin'}
      // Create the bar and load the skin
      BarWnd := TBarWnd.Create(nil);
      BarWnd.Visible := false;
      BarWnd.Width := barWidth;
      BarWnd.SkinComp.LoadFromXmlFile(skinfile);

      // Get the scheme
      BarWnd.ssMain.Colors := colors;
      BarWnd.SkinComp.UpdateDynamicProperties(BarWnd.ssMain);

      // Apply the scheme and skin to the bar
      Bar.UpdateSkin;

      // Set bar size and initialise
      srcBitmap.SetSize(max(barWidth, 1), BarWnd.SkinManager.Skin.BarSkin.SkinDim.HeightAsInt);
      srcBitmap.Clear(color32(0, 0, 0, 0));
{$ENDREGION}

      {$REGION 'Draw Glass Effect'}
      if drawGlass then begin

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

        if BarWnd.SkinManager.Skin.BarSkin.GlassEffect then
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
{$ENDREGION}

      {$REGION 'Draw elements to source bitmap'}
      // Draw background
      Bar.abackground.Skin.Drawto(srcBitmap, 0, 0);

      // Draw bar
      Bar.Skin.DrawTo(srcBitmap, 0, 0);

      // Draw throbber
      ThrobberPos := Point(BarWnd.SkinManager.Skin.BarSkin.ThDim.XAsInt,
        BarWnd.SkinManager.Skin.BarSkin.ThDim.YAsInt);
      Bar.Throbber.UpdateSkin;
      Bar.Throbber.Skin.DrawTo(srcBitmap, ThrobberPos.X, ThrobberPos.Y);

      // Draw button
      ButtonPos := Point(BarWnd.SkinManager.Skin.BarSkin.PAXoffset.XAsInt + 8,
        BarWnd.SkinManager.Skin.BarSkin.PAYoffset.XAsInt + BarWnd.SkinManager.Skin.ButtonSkin.SkinDim.YAsInt);
      Button.UpdateSkin;
      Button.Skin.DrawTo(srcBitmap, ButtonPos.X, ButtonPos.Y);
{$ENDREGION}

    end;
  finally
    xml.Free;
    FreeAndNil(barWnd);
  end;
end;

end.

