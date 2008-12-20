{
Source Name: SharpThemeApi.pas
Description: Header unit for SharpThemeApi.dll
Copyright (C)  Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpThemeApi;

interface

uses
  Windows,
  Classes,
  SysUtils,
  SharpApi,
  JvSimpleXml;

type
  TThemePart = (tpSkin, tpScheme, tpInfo, tpIconSet, tpDesktopIcon,
    tpDesktopAnimation, tpWallpaper, tpSkinFont);
  TThemeParts = set of TThemePart;

  TThemeWallpaperGradientType = (twgtHoriz, twgtVert, twgtTSHoriz, twgtTSVert);
  TThemeWallpaperSize = (twsCenter, twsScale, twsStretch, twsTile);

  TThemeWallpaper = record
    Name: string;
    Image: string;
    Color: integer;
    Alpha: integer;
    Size: TThemeWallpaperSize;
    ColorChange: boolean;
    Hue: integer;
    Saturation: integer;
    Lightness: integer;
    Gradient: boolean;
    GradientType: TThemeWallpaperGradientType;
    GDStartColor: integer;
    GDStartAlpha: integer;
    GDEndColor: integer;
    GDEndAlpha: integer;
    MirrorHoriz: boolean;
    MirrorVert: boolean;
  end;

  TSharpESchemeType = (stColor, stBoolean, stInteger);

  TSharpESkinColor = record
    Name: string;
    Tag: string;
    Info: string;
    Color: integer;
    schemetype: TSharpESchemeType;
  end;
  TSharpEColorSet = array of TSharpESkinColor;

  TSharpEIcon = record
    FileName: string;
    Tag: string;
  end;

  TThemeInfo = record
    LastUpdate: Int64;
    Name: string;
    Author: string;
    Comment: string;
    Website: string;

    Filename: string;
    Preview: string;
    Readonly: boolean;
  end;
  TThemeInfoSet = array of TThemeInfo;

const
  ICONS_DIR = 'Icons';
  THEME_DIR = 'Themes';

  DEFAULT_THEME = 'Default';
  DEFAULT_ICONSET = 'Cubeix Black';

  SKINS_DIRECTORY = 'Skins';
  SKINS_SCHEME_DIRECTORY = 'Schemes';

  SHARPE_USER_SETTINGS = 'SharpE.xml';

  THEME_INFO_FILE = 'Theme.xml';
  SCHEME_FILE = 'Scheme.xml';
  SKIN_FILE = 'Skin.xml';
  ICONSET_FILE = 'IconSet.xml';
  DESKTOPICON_FILE = 'DesktopIcon.xml';
  DESKTOPANIM_FILE = 'DesktopAnimation.xml';
  WALLPAPER_FILE = 'Wallpaper.xml';
  SKINFONT_FILE = 'Font.xml';

  ALL_THEME_PARTS = [tpSkin, tpScheme, tpInfo, tpIconSet, tpDesktopIcon,
    tpDesktopAnimation, tpWallpaper, tpSkinFont];

  // ThemeAPIControls
procedure InitializeTheme; external 'SharpThemeApi.dll' name 'InitializeTheme';
function Initialized: boolean; external 'SharpThemeApi.dll' name 'Initialized';
function LoadTheme(pName: PChar; ForceReload: Boolean = False; ThemeParts: TThemeParts = ALL_THEME_PARTS): boolean; overload external 'SharpThemeApi.dll' name 'LoadTheme';
function LoadTheme(ForceReload: Boolean = False; ThemeParts: TThemeParts = ALL_THEME_PARTS): boolean; overload; external 'SharpThemeApi.dll' name 'LoadCurrentTheme';

// Global data
function GetCurrentSharpEThemeName: PChar; external 'SharpThemeApi.dll' name 'GetCurrentSharpEThemeName';

// Theme Info
function GetThemeName: PChar; external 'SharpThemeApi.dll' name 'GetThemeName';
function GetThemeAuthor: PChar; external 'SharpThemeApi.dll' name 'GetThemeAuthor';
function GetThemeComment: PChar; external 'SharpThemeApi.dll' name 'GetThemeComment';
function GetThemeWebsite: PChar; external 'SharpThemeApi.dll' name 'GetThemeWebsite';

// Theme Data
function GetThemeDirectory: PChar; overload; external 'SharpThemeApi.dll' name 'GetCurrentThemeDirectory';
function GetThemeDirectory(pName: PChar): PChar; overload external 'SharpThemeApi.dll' name 'GetThemeDirectory';

// Theme Scheme
function GetSchemeColorSet(pSet: integer): TSharpEColorSet; external 'SharpThemeApi.dll' name 'GetSchemeColorSet';
function GetSchemeName: PChar; external 'SharpThemeApi.dll' name 'GetSchemeName';
function SchemeCodeToColor(pCode: integer): integer; external 'SharpThemeApi.dll' name 'SchemeCodeToColor';
function ColorToSchemeCode(pColor: integer): integer; external 'SharpThemeApi.dll' name 'ColorToSchemeCode';
function GetSchemeColorCount: Integer; external 'SharpThemeApi.dll' name 'GetSchemeColorCount';
function GetSchemeColorByIndex(pIndex: integer): TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSchemeColorByIndex';
function GetSchemeColorIndexByTag(pTag: string): Integer; external 'SharpThemeApi.dll' name 'GetSchemeColorIndexByTag';
function GetSchemeColorByTag(pTag: string): TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSchemeColorByTag';
function ParseColor(AColorStr: PChar): Integer; external 'SharpThemeApi.dll' name 'ParseColor';
function GetSchemeDirectory: PChar; external 'SharpThemeApi.dll' name 'GetSchemeDirectory';

// Theme Skin
function GetSkinName: PChar; external 'SharpThemeApi.dll' name 'GetSkinName';
function GetSkinColorCount: integer; external 'SharpThemeApi.dll' name 'GetSkinColorCount';
function GetSkinColor(pIndex: integer): TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSkinColor';
function GetSkinDirectory: PChar; external 'SharpThemeApi.dll' name 'GetSkinDirectory';
function GetSkinGEBlurRadius: integer; external 'SharpThemeApi.dll' name 'GetSkinGEBlurRadius';
function GetSkinGEBlurIterations: integer; external 'SharpThemeApi.dll' name 'GetSkinGEBlurIterations';
function GetSkinGEBlend: boolean; external 'SharpThemeApi.dll' name 'GetSkinGEBlend';
function GetSkinGEBlendColor: integer; external 'SharpThemeApi.dll' name 'GetSkinGEBlendColor';
function GetSkinGEBlendAlpha: integer; external 'SharpThemeApi.dll' name 'GetSkinGEBlendAlpha';
function GetSkinGELighten: boolean; external 'SharpThemeApi.dll' name 'GetSkinGELighten';
function GetSkinGELightenAmount: integer; external 'SharpThemeApi.dll' name 'GetSkinGELightenAmount';

// Theme IconSet
function GetIconSetName: PChar; external 'SharpThemeApi.dll' name 'GetIconSetName';
function GetIconSetAuthor: PChar; external 'SharpThemeApi.dll' name 'GetIconSetAuthor';
function GetIconSetWebsite: PChar; external 'SharpThemeApi.dll' name 'GetIconSetWebsite';
function GetIconSetDirectory: PChar; external 'SharpThemeApi.dll' name 'GetIconSetDirectory';
function GetIconSetIconsCount: integer; external 'SharpThemeApi.dll' name 'GetIconSetIconsCount';
function GetIconSetIcon(pIndex: integer): TSharpEIcon; overload; external 'SharpThemeApi.dll' name 'GetIconSetIconByIndex';
function GetIconSetIcon(pTag: PChar): TSharpEIcon; overload; external 'SharpThemeApi.dll' name 'GetIconSetIconByTag';
function IsIconInIconSet(pTag: PChar): boolean; external 'SharpThemeApi.dll' name 'IsIconInIconSet';

// Theme DesktopIcon
function GetDesktopIconSize: integer; external 'SharpThemeApi.dll' name 'GetDesktopIconSize';
function GetDesktopIconAlphaBlend: boolean; external 'SharpThemeApi.dll' name 'GetDesktopIconAlphaBlend';
function GetDesktopIconAlpha: integer; external 'SharpThemeApi.dll' name 'GetDesktopIconAlpha';
function GetDesktopIconBlending: boolean; external 'SharpThemeApi.dll' name 'GetDesktopIconBlending';
function GetDesktopIconBlendColor: integer; external 'SharpThemeApi.dll' name 'GetDesktopIconBlendColor';
function GetDesktopIconBlendAlpha: integer; external 'SharpThemeApi.dll' name 'GetDesktopIconBlendAlpha';
function GetDesktopIconShadow: boolean; external 'SharpThemeApi.dll' name 'GetDesktopIconShadow';
function GetDesktopIconShadowColor: integer; external 'SharpThemeApi.dll' name 'GetDesktopIconShadowColor';
function GetDesktopIconShadowAlpha: integer; external 'SharpThemeApi.dll' name 'GetDesktopIconShadowAlpha';
function GetDesktopFontName: PChar; external 'SharpThemeApi.dll' name 'GetDesktopFontName';
function GetDesktopDisplayText: boolean; external 'SharpThemeApi.dll' name 'GetDesktopDisplayText';
function GetDesktopTextSize: integer; external 'SharpThemeApi.dll' name 'GetDesktopTextSize';
function GetDesktopTextBold: boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextBold';
function GetDesktopTextItalic: boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextItalic';
function GetDesktopTextUnderline: boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextUnderline';
function GetDesktopTextColor: integer; external 'SharpThemeApi.dll' name 'GetDesktopTextColor';
function GetDesktopTextAlpha: boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextAlpha';
function GetDesktopTextAlphaValue: integer; external 'SharpThemeApi.dll' name 'GetDesktopTextAlphaValue';
function GetDesktopTextShadow: boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextShadow';
function GetDesktopTextShadowAlpha: integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowAlpha';
function GetDesktopTextShadowColor: integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowColor';
function GetDesktopTextShadowType: integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowType';
function GetDesktopTextShadowSize: integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowSize';

// Theme Desktop Animation
function GetDesktopAnimUseAnimations: boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimUseAnimations';
function GetDesktopAnimScale: boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimScale';
function GetDesktopAnimScaleValue: integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimScaleValue';
function GetDesktopAnimAlpha: boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimAlpha';
function GetDesktopAnimAlphaValue: integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimAlphaValue';
function GetDesktopAnimBlend: boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimBlend';
function GetDesktopAnimBlendValue: integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimBlendValue';
function GetDesktopAnimBlendColor: integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimBlendColor';
function GetDesktopAnimBrightness: boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimBrightness';
function GetDesktopAnimBrightnessValue: integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimBrightnessValue';

// Theme Wallpaper
function GetMonitorWallpaper(Index: integer): TThemeWallpaper; external 'SharpThemeApi.dll' name 'GetMonitorWallpaper';

// Theme Skin Fon
function GetSkinFontModSize: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModSize';
function GetSkinFontModName: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModName';
function GetSkinFontModAlpha: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModAlpha';
function GetSkinFontModUseShadow: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModUseShadow';
function GetSkinFontModShadowType: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModShadowType';
function GetSkinFontModShadowAlpha: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModShadowAlpha';
function GetSkinFontModBold: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModBold';
function GetSkinFontModItalic: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModItalic';
function GetSkinFontModUnderline: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModUnderline';
function GetSkinFontModClearType: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModClearType';
function GetSkinFontValueSize: integer; external 'SharpThemeApi.dll' name 'GetSkinFontValueSize';
function GetSkinFontValueName: string; external 'SharpThemeApi.dll' name 'GetSkinFontValueName';
function GetSkinFontValueAlpha: integer; external 'SharpThemeApi.dll' name 'GetSkinFontValueAlpha';
function GetSkinFontValueUseShadow: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueUseShadow';
function GetSkinFontValueShadowType: integer; external 'SharpThemeApi.dll' name 'GetSkinFontValueShadowType';
function GetSkinFontValueShadowAlpha: integer; external 'SharpThemeApi.dll' name 'GetSkinFontValueShadowAlpha';
function GetSkinFontValueBold: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueBold';
function GetSkinFontValueItalic: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueItalic';
function GetSkinFontValueUnderline: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueUnderline';
function GetSkinFontValueClearType: boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueClearType';

function GetThemeListAsCommaText: string;
procedure XmlGetThemeList(var AThemeList: TThemeInfoSet);

function XmlGetSchemeListAsCommaText(ATheme: string): string;
function XmlGetBarListAsCommaText: string;

procedure XmlGetThemeScheme(var AThemeScheme: TSharpEColorSet); overload;
procedure XmlGetThemeScheme(ATheme: string; AScheme: string; ASkin: string; var AThemeScheme: TSharpEColorSet); overload;
procedure XmlGetThemeScheme(ATheme: string; AScheme: string; var AThemeScheme: TSharpEColorSet); overload;
procedure XmlGetThemeScheme(ASkin: string; var AThemeScheme: TSharpEColorSet); overload;

procedure XmlSetThemeScheme(ATheme: string; AScheme: string; ASkin: string; var AThemeScheme: TSharpEColorSet; AAuthor:String=''); overload;
procedure XmlSetThemeScheme(ATheme: string; AScheme: string; var AThemeScheme: TSharpEColorSet;AAuthor:String=''); overload;

function XmlGetSchemeAuthor(ATheme: string; AScheme: string): string;

function XmlColorToSchemeCode(AColor: integer): integer; overload;
function XmlColorToSchemeCode(AColor: integer; AThemeScheme: TSharpEColorSet): integer; overload;

function XmlSchemeCodeToColor(AColorCode: integer): integer; overload;
function XmlSchemeCodeToColor(AColorCode: integer; AThemeScheme: TSharpEColorSet): integer; overload;

function XmlGetSkinColorByTag(ATag: string): TSharpESkinColor; overload;
function XmlGetSkinColorByTag(ATag: string; AThemeScheme: TSharpEColorSet): TSharpESkinColor; overload;

function XmlGetSkin(ATheme: string): string;
function XmlGetSkinFile(ATheme: String): String;
function XmlGetSchemeFile(ATheme: string): string;
function XmlGetFontFile(ATheme: string): string;
function XmlGetWallpaperFile(ATheme: string): string;
function XmlGetTheme: string;
function XmlGetThemeFile(ATheme: string): string;
procedure XmlSetScheme(ATheme: String; AName: string);
procedure XmlSetSkin(ATheme: String; AName: string);
function XmlGetScheme(ATheme: string): string;
procedure XmlSetTheme(ATheme: String);
function XmlGetSkinDir(ATheme: String): String; overload;
function XmlGetSkinDir: String; overload;

procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string);

implementation

procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> '\' then
    StartDir := StartDir + '\';

  { Build a list of the files in directory StartDir
     (not the directories!)                         }

  IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
  while IsFound do begin
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  SysUtils.FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  try
    IsFound := FindFirst(StartDir + '*.*', faAnyFile, SR) = 0;
    while IsFound do begin
      if ((SR.Attr and faDirectory) <> 0) and
        (SR.Name[1] <> '.') then
        DirList.Add(StartDir + SR.Name);
      IsFound := FindNext(SR) = 0;
    end;
    SysUtils.FindClose(SR);

    // Scan the list of subdirectories
    for i := 0 to DirList.Count - 1 do
      FindFiles(FilesList, DirList[i], FileMask);

  finally
    DirList.Free;
  end;

end;

function GetThemeListAsCommaText: string;
var
  sThemeDir: string;
  tmpStringList: TStringList;
begin
  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';

  tmpStringList := TStringList.Create;
  try

    FindFiles(tmpStringList, sThemeDir, '*theme.xml');
    tmpStringList.Sort;
    result := tmpStringList.CommaText;

  finally
    tmpStringList.Free;
  end;
end;

function XmlGetSchemeListAsCommaText(ATheme: string): string;
var
  sSchemeDir, sSkin: string;
  tmpStringList: TStringList;
begin
  sSkin := XmlGetSkin(ATheme);
  sSchemeDir := GetSharpeDirectory + 'Skins\' + sSkin + '\Schemes\';

  tmpStringList := TStringList.Create;
  try

    FindFiles(tmpStringList, sSchemeDir, '*.xml');
    tmpStringList.Sort;
    result := tmpStringList.CommaText;

  finally
    tmpStringList.Free;
  end;
end;

function XmlGetBarListAsCommaText: string;
var
  sBarDir: string;
  tmpStringList: TStringList;
begin
  sBarDir := GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  tmpStringList := TStringList.Create;
  try

    FindFiles(tmpStringList, sBarDir, '*bar.xml');
    tmpStringList.Sort;
    result := tmpStringList.CommaText;

  finally
    tmpStringList.Free;
  end;
end;

procedure XmlGetThemeList(var AThemeList: TThemeInfoSet);
var
  sThemeDir, sPreview: string;
  xml: TJvSimpleXml;
  i: Integer;
  itm: TThemeInfo;
  tmpStringList: TStringList;
begin
  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';

  tmpStringList := TStringList.Create;
  try

    tmpStringList.CommaText := GetThemeListAsCommaText;

    Setlength(AThemeList, 0);
    for i := 0 to Pred(tmpStringList.Count) do begin
      xml := TJvSimpleXML.Create(nil);
      try
        xml.LoadFromFile(tmpStringList[i]);

        itm.Filename := tmpStringList[i];

        itm.Name := XML.Root.Items.Value('Name', 'Invalid_Name');
        itm.Author := XML.Root.Items.Value('Author', 'Invalid_Author');
        itm.Comment := XML.Root.Items.Value('Comment', 'Invalid_Comment');
        itm.Website := XML.Root.Items.Value('Website', 'Invalid_Website');
        itm.ReadOnly := XML.Root.Items.BoolValue('ReadOnly', false);

        sPreview := ExtractFilePath(tmpStringList[i]) + 'Preview.png';
        if FileExists(sPreview) then
          itm.Preview := sPreview
        else
          itm.Preview := '';

        SetLength(AThemeList, length(AThemeList) + 1);
        AThemeList[High(AThemeList)] := itm;

      finally
        xml.Free;
      end;
    end;
  finally
    tmpStringList.Free;
  end;

end;

procedure XmlGetThemeScheme(ATheme: string; AScheme: string; ASkin: string;
  var AThemeScheme: TSharpEColorSet); overload;
var
  XML: TJvSimpleXML;
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

  XML := TJvSimpleXML.Create(nil);
  try

    // Get Scheme Colors
    Setlength(AThemeScheme, 0);
    XML.Root.Clear;

    XML.LoadFromFile(sSkinDir + SCHEME_FILE);
    for i := 0 to Pred(XML.Root.Items.Count) do begin

      SetLength(AThemeScheme, length(AThemeScheme) + 1);
      tmpRec := AThemeScheme[i];

      with XML.Root.Items.Item[i].Items do begin
        tmpRec.Name := Value('name', '');
        tmpRec.Tag := Value('tag', '');
        tmpRec.Info := Value('info', '');
        tmpRec.Color := ParseColor(PChar(Value('Default', '0')));
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
              AThemeScheme[j].Color := ParseColor(PChar(tmpColor));
              break;
            end;
          end;
        end;
    end;
  finally
    XML.Free;
  end;
end;

procedure XmlGetThemeScheme(ASkin: string; var AThemeScheme: TSharpEColorSet); overload;
var
  XML: TJvSimpleXML;
  i: Integer;
  tmpRec: TSharpESkinColor;
  s: string;

  sSkin, sSkinDir, sSchemeDir: string;
begin
  sSkin := ASkin;

  if (sSkin = '') then begin
    SharpApi.SendDebugMessageEx('SharpThemeApi', 'Some parameters were invalid for XmlGetThemeScheme', 0, DMT_ERROR);
    Setlength(AThemeScheme, 0);
    Exit;
  end;

  sSkinDir := GetSharpeDirectory + SKINS_DIRECTORY + '\' + sSkin + '\';
  sSchemeDir := sSkinDir + SKINS_SCHEME_DIRECTORY + '\';

  XML := TJvSimpleXML.Create(nil);
  try

    // Get Scheme Colors
    Setlength(AThemeScheme, 0);
    XML.Root.Clear;

    XML.LoadFromFile(sSkinDir + SCHEME_FILE);
    for i := 0 to Pred(XML.Root.Items.Count) do begin

      SetLength(AThemeScheme, length(AThemeScheme) + 1);
      tmpRec := AThemeScheme[i];

      with XML.Root.Items.Item[i].Items do begin
        tmpRec.Name := Value('name', '');
        tmpRec.Tag := Value('tag', '');
        tmpRec.Info := Value('info', '');
        tmpRec.Color := ParseColor(PChar(Value('Default', '0')));
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

  finally
    XML.Free;
  end;
end;

procedure XmlSetThemeScheme(ATheme: string; AScheme: string; ASkin: string;
  var AThemeScheme: TSharpEColorSet; AAuthor:string=''); overload;
var
  xml: TJvSimpleXML;
  i: Integer;
  sFileName, sSkinDir, sSchemeDir, sSkin, sAuthor: string;
begin
  xml := TJvSimpleXML.Create(nil);

  try
    xml.Root.Name := 'SharpESkinScheme';
    xml.Root.Items.Add('Info');
    with xml.Root.Items.ItemNamed['Info'] do begin
      Items.Add('Name', AScheme);

      if AAuthor = '' then
        sAuthor := XmlGetSchemeAuthor(ATheme, AScheme) else
          sAuthor := AAuthor;

        Items.Add('Author', sAuthor);

    end;
    for i := 0 to High(AThemeScheme) do begin
      with xml.Root.Items.Add('Item') do begin
        Items.Add('Tag', AThemeScheme[i].Tag);
        Items.Add('Color', AThemeScheme[i].Color);
      end;
    end;
  finally

    sSkin := ASkin;
    sSkinDir := GetSharpeDirectory + SKINS_DIRECTORY + '\' + sSkin + '\';
    sSchemeDir := sSkinDir + SKINS_SCHEME_DIRECTORY + '\';
    sFileName := sSchemeDir + AScheme + '.xml';
    xml.SaveToFile(sFileName);
    xml.Free;
  end;

end;

procedure XmlSetThemeScheme(ATheme: string; AScheme: string;
  var AThemeScheme: TSharpEColorSet; AAuthor: String =''); overload;
begin
  XmlSetThemeScheme(ATheme,AScheme,XmlGetSkin(ATheme),AThemeScheme,AAuthor);
end;

function XmlGetSchemeAuthor(ATheme: string; AScheme: string): string;
var
  xml: TJvSimpleXML;
  sSkinDir, sSchemeDir, sSkin: string;
begin
  Result := '';
  sSkin := XmlGetSkin(ATheme);
  sSkinDir := GetSharpeDirectory + SKINS_DIRECTORY + '\' + sSkin + '\';
  sSchemeDir := sSkinDir + SKINS_SCHEME_DIRECTORY + '\';

  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(sSchemeDir + AScheme + '.xml');
    if xml.Root.Items.ItemNamed['Info'] <> nil then
      result := xml.Root.Items.ItemNamed['Info'].Items.Value('Author');
  finally
    xml.Free;
  end;
end;

procedure XmlGetThemeScheme(var AThemeScheme: TSharpEColorSet); overload;
var
  sTheme, sSkin, sCurScheme: string;
begin
  sTheme := XmlGetTheme;
  sCurScheme := XmlGetScheme(sTheme);
  sSkin := XmlGetSkin(sTheme);

  XmlGetThemeScheme(sTheme, sCurScheme, sSkin, AThemeScheme);
end;

procedure XmlGetThemeScheme(ATheme: string; AScheme: string; var AThemeScheme: TSharpEColorSet); overload;
var
  sTheme, sSkin, sCurScheme: string;
begin
  sTheme := ATheme;
  sCurScheme := AScheme;
  sSkin := XmlGetSkin(sTheme);

  XmlGetThemeScheme(sTheme, sCurScheme, sSkin, AThemeScheme);
end;

function XmlColorToSchemeCode(AColor: integer): integer;
var
  colors: TSharpEColorSet;
begin
  XmlGetThemeScheme(colors);
  Result := XmlColorToSchemeCode(AColor, colors);
end;

function XmlColorToSchemeCode(AColor: integer; AThemeScheme: TSharpEColorSet): integer;
var
  n: Integer;
begin
  for n := 0 to High(AThemeScheme) do
    if AThemeScheme[n].Color = AColor then begin
      result := -n - 1;
      exit;
    end;
  result := AColor;
end;

function XmlSchemeCodeToColor(AColorCode: integer): integer;
var
  colors: TSharpEColorSet;
begin
  XmlGetThemeScheme(colors);
  Result := XmlSchemeCodeToColor(AColorCode, colors);
end;

function XmlSchemeCodeToColor(AColorCode: integer; AThemeScheme: TSharpEColorSet): integer;
begin
  result := -1;
  if AColorCode < 0 then begin
    if abs(AColorCode) <= length(AThemeScheme) then
      result := AThemeScheme[abs(AColorCode) - 1].Color;
  end
  else
    result := AColorCode;
end;

function XmlGetSkinColorByTag(ATag: string): TSharpESkinColor;
var
  colors: TSharpEColorSet;
begin
  XmlGetThemeScheme(colors);
  Result := XmlGetSkinColorByTag(ATag, colors);

end;

function XmlGetSkinColorByTag(ATag: string; AThemeScheme: TSharpEColorSet): TSharpESkinColor;
var
  n: integer;
  tmpColor: TSharpESkinColor;
begin
  try
    for n := 0 to High(AThemeScheme) do
      if CompareText(AThemeScheme[n].Tag, ATag) = 0 then begin
        tmpColor := AThemeScheme[n];
        exit;
      end;
  finally
    result := tmpColor;
  end;

end;

function XmlGetSchemeFile(ATheme: string): string;
begin
  Result := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'scheme.xml';
end;

function XmlGetSkinFile(ATheme: string): string;
begin
  Result := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'skin.xml';
end;

function XmlGetFontFile(ATheme: string): string;
begin
  Result := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'font.xml';
end;

function XmlGetWallpaperFile(ATheme: string): string;
begin
  Result := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'wallpaper.xml';
end;

function XmlGetTheme: string;
var
  xml: TJvSimpleXML;
  s: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS;

    if fileExists(s) then begin
      xml.LoadFromFile(s);
      Result := xml.Root.Items.Value('Theme', 'Default');
    end;
  finally
    xml.Free;
  end;
end;

procedure XmlSetTheme(ATheme: String);
var
  s: string;
  xml:TJvSimpleXML;
begin
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS;
    forcedirectories(ExtractFilePath(s));

    xml.Root.Name := 'SharpETheme';

    if xml.Root.Items.ItemNamed['Theme'] <> nil then
      xml.Root.Items.ItemNamed['Theme'].Value := ATheme else
      xml.Root.Items.Add('Theme', ATheme);
      
    xml.SaveToFile(s);
  finally
    xml.Free;
  end;
end;

function XmlGetThemeFile(ATheme: string): string;
begin
  Result := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'theme.xml';
end;

procedure XmlSetScheme(ATheme: String; AName: string);
var
  xml: TJvSimpleXML;
  s: string;
begin
  xml := TJvSimpleXML.Create(nil);
  try
    s := XmlGetSchemeFile(ATheme);
    forcedirectories(ExtractFilePath(s));

    xml.Root.Clear;
    xml.Root.Name := 'SharpEThemeScheme';
    xml.Root.Items.Add('Scheme', AName);
    xml.SaveToFile(s);
  finally
    xml.Free;
  end;
end;

function XmlGetScheme(ATheme: string): string;
var
  xml: TJvSimpleXML;
  s: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    s := XmlGetSchemeFile(ATheme);

    if fileExists(s) then begin
      xml.LoadFromFile(s);
      Result := xml.Root.Items.Value('Scheme', 'Default');
    end;
  finally
    xml.Free;
  end;
end;

function XmlGetSkin(ATheme: string): string;
var
  xml: TJvSimpleXML;
  s: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    s := XmlGetSkinFile(ATheme);

    if fileExists(s) then begin
      xml.LoadFromFile(s);
      Result := xml.Root.Items.Value('Skin', '');
    end;
  finally
    xml.Free;
  end;
end;

procedure XmlSetSkin(ATheme: String; AName: string);
var
  xml: TJvSimpleXML;
  s: string;
begin
  xml := TJvSimpleXML.Create(nil);
  try
    s := XmlGetSkinFile(ATheme);
    forcedirectories(ExtractFilePath(s));

    xml.Root.Clear;
    xml.Root.Name := 'SharpEThemeSkin';
    xml.Root.Items.Add('Skin', AName);
    xml.SaveToFile(s);
  finally
    xml.Free;
  end;
end;


function XmlGetSkinDir(ATheme: String):string;
var
  skin: string;
begin
  result := '';
  skin := XmlGetSkin(ATheme);

  if skin <> '' then
    Result := GetSharpeDirectory + SKINS_DIRECTORY + '\' + skin + '\';
end;

function XmlGetSkinDir:string;
begin
  Result := XmlGetSkinDir(XmlGetTheme);
end;

end.

