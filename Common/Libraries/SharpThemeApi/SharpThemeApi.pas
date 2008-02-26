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
  TThemePart = (tpSkin,tpScheme,tpInfo,tpIconSet,tpDesktopIcon,
                tpDesktopAnimation,tpWallpaper,tpSkinFont);
  TThemeParts = set of TThemePart;

  TThemeWallpaperGradientType = (twgtHoriz,twgtVert,twgtTSHoriz,twgtTSVert);
  TThemeWallpaperSize = (twsCenter,twsScale,twsStretch,twsTile);

  TThemeWallpaper  = record
    Name            : String;
    Image           : String;
    Color           : integer;
    Alpha           : integer;
    Size            : TThemeWallpaperSize;
    ColorChange     : boolean;
    Hue             : integer;
    Saturation      : integer;
    Lightness       : integer;
    Gradient        : boolean;
    GradientType    : TThemeWallpaperGradientType;
    GDStartColor    : integer;
    GDStartAlpha    : integer;
    GDEndColor      : integer;
    GDEndAlpha      : integer;
    MirrorHoriz     : boolean;
    MirrorVert      : boolean;
  end;

  TSharpESchemeType = (stColor,stBoolean,stInteger);

  TSharpESkinColor = record
    Name: string;
    Tag: string;
    Info: string;
    Color: integer;
    schemetype : TSharpESchemeType;
  end;
  TSharpEColorSet = array of TSharpESkinColor;

  TSharpEIcon = record
    FileName: string;
    Tag: string;
  end;

  TThemeInfo = record
    LastUpdate : Int64;
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

  ALL_THEME_PARTS = [tpSkin,tpScheme,tpInfo,tpIconSet,tpDesktopIcon,
                     tpDesktopAnimation,tpWallpaper,tpSkinFont];


// ThemeAPIControls
procedure InitializeTheme; external 'SharpThemeApi.dll' name 'InitializeTheme';
function Initialized: boolean; external 'SharpThemeApi.dll' name 'Initialized';
function LoadTheme(pName: PChar; ForceReload: Boolean = False; ThemeParts : TThemeParts = ALL_THEME_PARTS) : boolean; overload external 'SharpThemeApi.dll' name 'LoadTheme';
function LoadTheme(ForceReload: Boolean = False; ThemeParts : TThemeParts = ALL_THEME_PARTS) : boolean; overload; external 'SharpThemeApi.dll' name 'LoadCurrentTheme';

// Global data
function GetCurrentSharpEThemeName : PChar; external 'SharpThemeApi.dll' name 'GetCurrentSharpEThemeName';

// Theme Info
function GetThemeName: PChar; external 'SharpThemeApi.dll' name 'GetThemeName';
function GetThemeAuthor: PChar; external 'SharpThemeApi.dll' name 'GetThemeAuthor';
function GetThemeComment: PChar; external 'SharpThemeApi.dll' name 'GetThemeComment';
function GetThemeWebsite: PChar; external 'SharpThemeApi.dll' name 'GetThemeWebsite';

// Theme Data
function GetThemeDirectory: PChar; overload; external 'SharpThemeApi.dll' name 'GetCurrentThemeDirectory';
function GetThemeDirectory(pName : PChar): PChar; overload external 'SharpThemeApi.dll' name 'GetThemeDirectory';

// Theme Scheme
function GetSchemeColorSet(pSet : integer) : TSharpEColorSet; external 'SharpThemeApi.dll' name 'GetSchemeColorSet';
function GetSchemeName : PChar; external 'SharpThemeApi.dll' name 'GetSchemeName';
function SchemeCodeToColor(pCode : integer) : integer; external 'SharpThemeApi.dll' name 'SchemeCodeToColor';
function ColorToSchemeCode(pColor : integer) : integer; external 'SharpThemeApi.dll' name 'ColorToSchemeCode';
function GetSchemeColorCount: Integer; external 'SharpThemeApi.dll' name 'GetSchemeColorCount';
function GetSchemeColorByIndex(pIndex: integer): TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSchemeColorByIndex';
function GetSchemeColorIndexByTag(pTag: string): Integer; external 'SharpThemeApi.dll' name 'GetSchemeColorIndexByTag';
function GetSchemeColorByTag(pTag: string): TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSchemeColorByTag';
function ParseColor(AColorStr:PChar):Integer; external 'SharpThemeApi.dll' name 'ParseColor';
function GetSchemeDirectory : PChar; external 'SharpThemeApi.dll' name 'GetSchemeDirectory';

// Theme Skin
function GetSkinName : PChar; external 'SharpThemeApi.dll' name 'GetSkinName';
function GetSkinColorCount : integer; external 'SharpThemeApi.dll' name 'GetSkinColorCount';
function GetSkinColor(pIndex : integer) : TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSkinColor';
function GetSkinDirectory : PChar; external 'SharpThemeApi.dll' name 'GetSkinDirectory';
function GetSkinGEBlurRadius : integer; external 'SharpThemeApi.dll' name 'GetSkinGEBlurRadius';
function GetSkinGEBlurIterations : integer; external 'SharpThemeApi.dll' name 'GetSkinGEBlurIterations';
function GetSkinGEBlend : boolean; external 'SharpThemeApi.dll' name 'GetSkinGEBlend';
function GetSkinGEBlendColor : integer; external 'SharpThemeApi.dll' name 'GetSkinGEBlendColor';
function GetSkinGEBlendAlpha : integer; external 'SharpThemeApi.dll' name 'GetSkinGEBlendAlpha';
function GetSkinGELighten : boolean; external 'SharpThemeApi.dll' name 'GetSkinGELighten';
function GetSkinGELightenAmount : integer; external 'SharpThemeApi.dll' name 'GetSkinGELightenAmount';

// Theme IconSet
function GetIconSetName : PChar; external 'SharpThemeApi.dll' name 'GetIconSetName';
function GetIconSetAuthor : PChar; external 'SharpThemeApi.dll' name 'GetIconSetAuthor';
function GetIconSetWebsite : PChar; external 'SharpThemeApi.dll' name 'GetIconSetWebsite';
function GetIconSetDirectory : PChar; external 'SharpThemeApi.dll' name 'GetIconSetDirectory';
function GetIconSetIconsCount : integer; external 'SharpThemeApi.dll' name 'GetIconSetIconsCount';
function GetIconSetIcon(pIndex : integer) : TSharpEIcon; overload; external 'SharpThemeApi.dll' name 'GetIconSetIconByIndex';
function GetIconSetIcon(pTag : PChar) : TSharpEIcon; overload; external 'SharpThemeApi.dll' name'GetIconSetIconByTag';
function IsIconInIconSet(pTag : PChar) : boolean; external 'SharpThemeApi.dll' name 'IsIconInIconSet';

// Theme DesktopIcon
function GetDesktopIconSize        : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconSize';
function GetDesktopIconAlphaBlend  : boolean; external 'SharpThemeApi.dll' name 'GetDesktopIconAlphaBlend';
function GetDesktopIconAlpha       : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconAlpha';
function GetDesktopIconBlending    : boolean; external 'SharpThemeApi.dll' name 'GetDesktopIconBlending';
function GetDesktopIconBlendColor  : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconBlendColor';
function GetDesktopIconBlendAlpha  : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconBlendAlpha';
function GetDesktopIconShadow      : boolean; external 'SharpThemeApi.dll' name 'GetDesktopIconShadow';
function GetDesktopIconShadowColor : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconShadowColor';
function GetDesktopIconShadowAlpha : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconShadowAlpha';
function GetDesktopFontName        : PChar;   external 'SharpThemeApi.dll' name 'GetDesktopFontName';
function GetDesktopDisplayText     : boolean; external 'SharpThemeApi.dll' name 'GetDesktopDisplayText';
function GetDesktopTextSize        : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextSize';
function GetDesktopTextBold        : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextBold';
function GetDesktopTextItalic      : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextItalic';
function GetDesktopTextUnderline   : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextUnderline';
function GetDesktopTextColor       : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextColor';
function GetDesktopTextAlpha       : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextAlpha';
function GetDesktopTextAlphaValue  : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextAlphaValue';
function GetDesktopTextShadow      : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextShadow';
function GetDesktopTextShadowAlpha : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowAlpha';
function GetDesktopTextShadowColor : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowColor';
function GetDesktopTextShadowType  : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowType';
function GetDesktopTextShadowSize  : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowSize';

// Theme Desktop Animation
function GetDesktopAnimUseAnimations   : boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimUseAnimations';
function GetDesktopAnimScale           : boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimScale';
function GetDesktopAnimScaleValue      : integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimScaleValue';
function GetDesktopAnimAlpha           : boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimAlpha';
function GetDesktopAnimAlphaValue      : integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimAlphaValue';
function GetDesktopAnimBlend           : boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimBlend';
function GetDesktopAnimBlendValue      : integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimBlendValue';
function GetDesktopAnimBlendColor      : integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimBlendColor';
function GetDesktopAnimBrightness      : boolean; external 'SharpThemeApi.dll' name 'GetDesktopAnimBrightness';
function GetDesktopAnimBrightnessValue : integer; external 'SharpThemeApi.dll' name 'GetDesktopAnimBrightnessValue';

// Theme Wallpaper
function GetMonitorWallpaper(Index : integer) : TThemeWallpaper; external 'SharpThemeApi.dll' name 'GetMonitorWallpaper';

// Theme Skin Fon
function GetSkinFontModSize          : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModSize';
function GetSkinFontModName          : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModName';
function GetSkinFontModAlpha         : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModAlpha';
function GetSkinFontModUseShadow     : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModUseShadow';
function GetSkinFontModShadowType    : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModShadowType';
function GetSkinFontModShadowAlpha   : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModShadowAlpha';
function GetSkinFontModBold          : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModBold';
function GetSkinFontModItalic        : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModItalic';
function GetSkinFontModUnderline     : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModUnderline';
function GetSkinFontModClearType     : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontModClearType';
function GetSkinFontValueSize        : integer; external 'SharpThemeApi.dll' name 'GetSkinFontValueSize';
function GetSkinFontValueName        : String;  external 'SharpThemeApi.dll' name 'GetSkinFontValueName';
function GetSkinFontValueAlpha       : integer; external 'SharpThemeApi.dll' name 'GetSkinFontValueAlpha';
function GetSkinFontValueUseShadow   : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueUseShadow';
function GetSkinFontValueShadowType  : integer; external 'SharpThemeApi.dll' name 'GetSkinFontValueShadowType';
function GetSkinFontValueShadowAlpha : integer; external 'SharpThemeApi.dll' name 'GetSkinFontValueShadowAlpha';
function GetSkinFontValueBold        : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueBold';
function GetSkinFontValueItalic      : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueItalic';
function GetSkinFontValueUnderline   : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueUnderline';
function GetSkinFontValueClearType   : boolean; external 'SharpThemeApi.dll' name 'GetSkinFontValueClearType';

function XmlGetTheme: string; external 'SharpThemeApi.dll' name 'XmlGetTheme';

function XmlGetScheme(ATheme: string): string; external 'SharpThemeApi.dll' name 'XmlGetScheme';
function XmlSetScheme(AName:String; ATheme: string): string; external 'SharpThemeApi.dll' name 'XmlSetScheme';

function XmlGetSkin(ATheme: String): String; external 'SharpThemeApi.dll' name 'XmlGetSkin';
function XmlGetSchemeFile(ATheme: string): string; external 'SharpThemeApi.dll' name 'XmlGetSchemeFile';
function XmlGetSkinFile(ATheme: String): String; external 'SharpThemeApi.dll' name 'XmlGetSkinFile';
function XmlGetFontFile(ATheme: String): String; external 'SharpThemeApi.dll' name 'XmlGetFontFile';
function XmlGetThemeFile(ATheme: String): String; external 'SharpThemeApi.dll' name 'XmlGetThemeFile';

function GetThemeListAsCommaText: string;
procedure XmlGetThemeList(var AThemeList: TThemeInfoSet);

function GetSchemeListAsCommaText(ATheme:string):string;
procedure XmlGetThemeScheme(var AThemeScheme: TSharpEColorSet);

function XmlColorToSchemeCode(AColor: integer): integer;
function XmlSchemeCodeToColor(AColorCode: integer): integer;

function XmlGetSkinColorByTag(ATag: string): TSharpESkinColor;
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

  IsFound := FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  SysUtils.FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  Try
  IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
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

  Finally
    DirList.Free;
  End;

end;

function GetThemeListAsCommaText: string;
var
  sThemeDir: String;
  tmpStringList: TStringList;
begin
  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';

  tmpStringList := TStringList.Create;
  try

  FindFiles(tmpStringList,sThemeDir,'*theme.xml');
  tmpStringList.Sort;
  result := tmpStringList.CommaText;

  finally
    tmpStringList.Free;
  end;
end;

function GetSchemeListAsCommaText(ATheme: String): string;
var
  sSchemeDir, sSkin: String;
  tmpStringList: TStringList;
begin
  sSkin := XmlGetSkin(ATheme);
  sSchemeDir := GetSharpeDirectory + 'Skins\' + sSkin + '\Schemes\';

  tmpStringList := TStringList.Create;
  try

  FindFiles(tmpStringList,sSchemeDir,'*.xml');
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

      SetLength(AThemeList,length(AThemeList)+1);
      AThemeList[High(AThemeList)] := itm;

    finally
      xml.Free;
    end;
  end;
  finally
    tmpStringList.Free;
  end;

end;

procedure XmlGetThemeScheme(var AThemeScheme: TSharpEColorSet);
var
  XML: TJvSimpleXML;
  i,j, Index: Integer;
  tmpRec: TSharpESkinColor;
  sFile, sTag, sCurScheme: string;
  tmpColor: string;
  s: string;

  sTheme, sSkin: string;
  sSkinDir, sSchemeDir: string;
begin
  Index := 0;

  sTheme := XmlGetTheme;
  sCurScheme := XmlGetScheme(sTheme);
  sSkin := XmlGetSkin(sTheme);

  sSkinDir := GetSharpeDirectory + SKINS_DIRECTORY + '\' + sSkin + '\';
  sSchemeDir := sSkinDir + SKINS_SCHEME_DIRECTORY + '\';

  XML := TJvSimpleXML.Create(nil);
  try
  
    // Get Scheme Colors
    Setlength(AThemeScheme, 0);
    XML.Root.Clear;

      XML.LoadFromFile(sSkinDir + SCHEME_FILE);
      for i := 0 to Pred(XML.Root.Items.Count) do begin

        SetLength(AThemeScheme,length(AThemeScheme)+1);
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
              if CompareText(AThemeScheme[j].Tag,sTag) = 0 then begin
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

function XmlColorToSchemeCode(AColor: integer): integer;
var
  n: integer;
  colors: TSharpEColorSet;
begin
  XmlGetThemeScheme(colors);

  for n := 0 to High(colors) do
    if colors[n].Color = AColor then begin
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

  result := -1;
  if AColorCode < 0 then begin
    if abs(AColorCode) <= length(colors) then
      result := colors[abs(AColorCode) - 1].Color;
  end
  else
    result := AColorCode;
end;

function XmlGetSkinColorByTag(ATag: string): TSharpESkinColor;
var
  n: integer;
  colors: TSharpEColorSet;
  tmpColor: TSharpESkinColor;
begin
  XmlGetThemeScheme(colors);
  Try

  for n := 0 to High(colors) do
    if CompareText(colors[n].Tag, ATag) = 0 then begin
      tmpColor := colors[n];
      exit;
    end;
  Finally
    result := tmpColor;
  End;

end;


end.
