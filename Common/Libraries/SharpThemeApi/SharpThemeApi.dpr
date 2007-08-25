{
Source Name: SharpThemeApi.dpr
Description: SharpThemeApi.dll Library unit
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

library SharpThemeApi;

uses
  SysUtils,
  DateUtils,
  Classes,
  Windows,
  JvSimpleXML,
  GR32,
  Graphics,
  JclStrings,
  SharpAPI in '..\SharpAPI\SharpAPI.pas';

type
  TThemePart = (tpSkin,tpScheme,tpInfo,tpIconSet,tpDesktopIcon,
                tpDesktopAnimation,tpWallpaper,tpSkinFont);
  TThemeParts = set of TThemePart;

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
  TWallpaperMonitor = record
                        Name : String;
                        ID   : integer; 
                      end;

  TThemeWallpapers = array of TThemeWallpaper;
  TMonitorWallpapers = array of TWallpaperMonitor;


  TThemeDesktopAnim = record
    LastUpdate      : Int64;
    UseAnimations   : boolean;
    Scale           : boolean;
    ScaleValue      : integer;
    Alpha           : boolean;
    AlphaValue      : integer;
    Blend           : boolean;
    BlendValue      : integer;
    BlendColor      : integer;
    Brightness      : boolean;
    BrightnessValue : integer;
  end;

  TThemeDesktopIcon = record
    LastUpdate      : Int64;
    IconSize        : integer;
    IconAlphaBlend  : boolean;
    IconAlpha       : integer;
    IconBlending    : boolean;
    IconBlendColor  : integer;
    IconBlendAlpha  : integer;
    IconShadow      : boolean;
    IconShadowColor : integer;
    IconShadowAlpha : integer;
    FontName        : String;
    TextSize        : integer;
    TextBold        : boolean;
    TextItalic      : boolean;
    TextUnderline   : boolean;
    TextColor       : integer;
    TextAlpha       : boolean;
    TextAlphaValue  : integer;
    TextShadow      : boolean;
    TextShadowAlpha : integer;
    TextShadowColor : integer;
    TextShadowType  : integer;
    TextShadowSize  : integer;
    DisplayText     : boolean;
  end;

  TThemeIconSet = record
    LastUpdate : Int64;
    Name: string;
    Author: string;
    Website: string;
    Directory: string;
    Icons: array of TSharpEIcon;
  end;

  TThemeSkin = record
    LastUpdate : Int64;
    Name: string;
    Scheme: string;
    Directory: string;
    GEBlurRadius: integer;
    GEBlurIterations: integer;
    GEBlend      : boolean; 
    GEBlendColor : integer;
    GEBlendAlpha : integer;
    GELighten    : boolean;
    GELightenAmount : integer;
  end;

  TThemeSkinFont = record
    LastUpdate : Int64;
    ModSize          : boolean;
    ModName          : boolean;
    ModAlpha         : boolean;
    ModUseShadow     : boolean;
    ModShadowType    : boolean;
    ModShadowAlpha   : boolean;
    ModBold          : boolean;
    ModItalic        : boolean;
    ModUnderline     : boolean;
    ValueSize        : integer;
    ValueName        : String;
    ValueAlpha       : integer;
    ValueUseShadow   : boolean;
    ValueShadowType  : integer;
    ValueShadowAlpha : integer;
    ValueBold        : boolean;
    ValueItalic      : boolean;
    ValueUnderline   : boolean;
  end;

  TThemeData = record
    Directory: string;
    LastUpdate: Int64;
  end;

  TThemeInfo = record
    LastUpdate : Int64;
    Name: string;
    Author: string;
    Comment: string;
    Website: string;
  end;

  TThemeScheme = record
    LastUpdate : Int64;
    Name: string;
    Colors: TSharpEColorSet;
  end;

  TSharpETheme = record
    Data: TThemeData;
    Info: TThemeInfo;
    Scheme: TThemeScheme;
    Skin: TThemeSkin;
    SkinFont: TThemeSkinFont;
    IconSet: TThemeIconSet;
    DesktopIcon : TThemeDesktopIcon;
    DesktopAnim : TThemeDesktopAnim;
    Wallpapers : TThemeWallpapers;
    WallpapresLastUpdate : Int64;
    MonitorWallpapers : TMonitorWallpapers;
  end;

var
  Theme: TSharpETheme;
  rtemp: string;
  bInitialized: Boolean;

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

  // ##########################################
  //   COLOR CONVERTING
  // ##########################################

function ParseColor(AColorStr: PChar): Integer;
var
  iStart, iEnd: Integer;
  h, s, l: double;
  sColorType, sParam: string;
  strlTokens: TStringList;
  bIdent: Boolean;
  r, g, b: byte;
  c: Integer;
  col: Integer;
  col32: TColor32;
  n : integer;
  sIdent: String;

  function CMYKtoColor(C, M, Y, K: integer): TColor;
  var
    R, G, B: integer;
  begin
    R := 255 - Round(2.55 * (C + K));
    if R < 0 then
      R := 0;
    G := 255 - Round(2.55 * (M + K));
    if G < 0 then
      G := 0;
    B := 255 - Round(2.55 * (Y + K));
    if B < 0 then
      B := 0;
    Result := RGB(R, G, B);
  end;

  function HSVtoRGB(H, S, V: Integer): TColor;
  var
    ht, d, t1, t2, t3: Integer;
    R, G, B: Word;
  begin
    s := s * 255 div 100;
    v := v * 255 div 100;

    if S = 0 then begin
      R := V;
      G := V;
      B := V;
    end
    else begin
      ht := H * 6;
      d := ht mod 360;

      t1 := round(V * (255 - S) / 255);
      t2 := round(V * (255 - S * d / 360) / 255);
      t3 := round(V * (255 - S * (360 - d) / 360) / 255);

      case ht div 360 of
        0: begin
            R := V;
            G := t3;
            B := t1;
          end;
        1: begin
            R := t2;
            G := V;
            B := t1;
          end;
        2: begin
            R := t1;
            G := V;
            B := t3;
          end;
        3: begin
            R := t1;
            G := t2;
            B := V;
          end;
        4: begin
            R := t3;
            G := t1;
            B := V;
          end;
      else begin
          R := V;
          G := t1;
          B := t2;
        end;
      end;
    end;
    Result := RGB(R, G, B);
  end;

begin
  result := -1;

  // Which colour type are we using? RGB, CMY, CMYK, HSV, HSL, LAB
  iStart := Pos('(', AColorStr);
  iEnd := Pos(')', AColorStr);

  if (iStart = 0) or (iEnd = 0) then
  begin
    // try to convert
    if TryStrToInt(AColorStr,n) then begin
      result := n;
      exit;
    end
    else
    begin
        sIdent := AColorStr;
        bIdent := IdentToColor(sIdent,col);
        if bIdent then result := StringToColor(AColorStr) else
        result := -1;
        exit;
    end;
  end;

  sColorType := Copy(AColorStr, 1, iStart - 1);
  sParam := Copy(AColorStr, iStart + 1, iEnd - iStart - 1);

  // RGB
  if CompareText(sColorType, 'rgb') = 0 then begin
    strlTokens := TStringList.Create;
    try
      StrTokenToStrings(sParam, ',', strlTokens);
      if strlTokens.Count <> 3 then
        exit;

      Result := RGB(StrToInt(StrlTokens[0]), StrToInt(StrlTokens[1]),
        StrToInt(StrlTokens[2]));

      exit;

    finally
      strlTokens.Free;
    end;
  end
  else if CompareText(sColorType, 'cmyk') = 0 then begin
    strlTokens := TStringList.Create;
    try
      StrTokenToStrings(sParam, ',', strlTokens);
      if strlTokens.Count <> 4 then
        exit;

      Result := CMYKtoColor(StrToInt(StrlTokens[0]), StrToInt(StrlTokens[1]),
        StrToInt(StrlTokens[2]), StrToInt(StrlTokens[3]));

      exit;

    finally
      strlTokens.Free;
    end;
  end;

  // HSV
  if CompareText(sColorType, 'hsv') = 0 then begin
    strlTokens := TStringList.Create;
    try
      StrTokenToStrings(sParam, ',', strlTokens);
      if strlTokens.Count <> 3 then
        exit;

      Result := HSVtoRGB(strtoint(StrlTokens[0]), strtoint(StrlTokens[1]),
        strtoint(StrlTokens[2]));

      exit;

    finally
      strlTokens.Free;
    end;
  end;
  // HSL
  if CompareText(sColorType, 'hsl') = 0 then begin
    strlTokens := TStringList.Create;
    try
      StrTokenToStrings(sParam, ',', strlTokens);
      if strlTokens.Count <> 3 then
        exit;

      h := StrToFloat(StrlTokens[0]) / 255;
      s := StrToFloat(StrlTokens[1]) / 255;
      l := StrToFloat(StrlTokens[2]) / 255;

      col32 := HSLtoRGB(h, s, l);
      Color32ToRGB(col32, r, g, b);
      Result := RGB(r, g, b);
      exit;

    finally
      strlTokens.Free;
    end;
  end;
  // HEX
  if CompareText(sColorType, 'hex') = 0 then begin
    Result := stringtocolor('$' + sParam);
    c := ColorToRGB(Result);
    c := (c and $FF) shl 16 + // Red
    (c and $FF00) + // Green
    (c and $FF0000) shr 16; // Blue

    Result := c;
  end;
  // COLOR
  if CompareText(sColorType, 'color') = 0 then begin
    Result := stringtocolor(sParam);
  end;

end;

function GetSchemeColorIndexByTag(pTag: string): Integer; forward;

function Initialized: Boolean;
begin
  Result := bInitialized;
end;

function SchemeCodeToColor(pCode: integer): integer;
begin
  result := -1;
  if pCode < 0 then
  begin
    if abs(pCode) <= length(Theme.Scheme.Colors) then
      result := Theme.Scheme.Colors[abs(pCode) - 1].Color;
  end
  else
    result := pCode;
end;

function ColorToSchemeCode(pColor: integer): integer;
var
  n: integer;
begin
  for n := 0 to High(Theme.Scheme.Colors) do
    if Theme.Scheme.Colors[n].Color = pColor then
    begin
      result := -n - 1;
      exit;
    end;
  result := pColor;
end;

// ##########################################
//   FILE AND DIRECTORY STRUCTURE FUNCTIONS
// ##########################################

procedure CreateDefaultSharpeUserSettings;
var
  XML: TJvSimpleXML;
begin
  XML := TJvSimpleXML.Create(nil);
  try
    XML.Root.Name := 'SharpEUserSettings';
    XML.Root.Items.Clear;
    XML.Root.Items.Add('Theme', 'Default');
    
    // fix for svn... only save if SharpCore.exe is in the path so that the SharpE
    // path really is correct.
    if FileExists(SharpApi.GetSharpeDirectory + 'SharpCore.exe') then
    begin
      ForceDirectories(SharpApi.GetSharpeUserSettingsPath);
      XML.SaveToFile(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS);
    end;
  finally
    XML.Free;
  end;
end;

function CheckSharpEUserSettings: boolean;
begin
  if FileExists(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS) then
    result := True
  else
    result := False;
end;

// ##########################################
//      HELPER FUNCTIONS
// ##########################################

function GetCurrentThemeName: string;
var
  XML: TJvSimpleXML;
begin
  if not CheckSharpEUserSettings then
    CreateDefaultSharpEUserSettings;

  result := 'Default';
  XML := TJvSimpleXML.Create(nil);
  try
    try
      XML.LoadFromFile(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS);
      result := XML.Root.Items.Value('Theme', 'Default');
    except
      result := 'Default';
    end;
  finally
    XML.Free;
  end;
end;

// ##########################################
//      DEFAULT SETTINGS
// ##########################################

procedure SetThemeSkinFontDefault;
begin
  with Theme.SkinFont do
  begin
    LastUpdate       := 0;
    ModSize          := False;
    ModName          := False;
    ModAlpha         := False;
    ModUseShadow     := False;
    ModShadowType    := False;
    ModShadowAlpha   := False;
    ModBold          := False;
    ModItalic        := False;
    ModUnderline     := False;
    ValueSize        := 10;
    ValueName        := 'Verdana';
    ValueAlpha       := 0;
    ValueUseShadow   := True;
    ValueShadowType  := 0;
    ValueShadowAlpha := 0;
    ValueBold        := False;
    ValueItalic      := False;
    ValueUnderline   := False;
  end;
end;

procedure SetThemeIconSetDefault;
begin
  Theme.IconSet.LastUpdate := 0;
  Theme.IconSet.Name := 'Default';
  Theme.IconSet.Author := '';
  Theme.IconSet.Website := '';
  Theme.IconSet.Directory := SharpApi.GetSharpeDirectory + ICONS_DIR + '\' + DEFAULT_ICONSET;
  setlength(Theme.IconSet.Icons, 0);
end;

procedure SetThemeInfoDefault;
begin
  Theme.Info.LastUpdate := 0;
  Theme.Info.Name := 'Default';
  Theme.Info.Author := '';
  Theme.Info.Comment := 'Default SharpE Theme';
  Theme.Info.Website := '';
end;

procedure SetThemeSchemeDefault;
begin
  Theme.Scheme.LastUpdate := 0;
  Theme.Scheme.Name := 'Default';
end;

procedure SetThemeSkinDefault;
begin
  Theme.Skin.LastUpdate := 0;
  Theme.Skin.Name := 'Default';
  Theme.Skin.GEBlurRadius := 1;
  Theme.Skin.GEBlurIterations := 3;
  Theme.Skin.GEBlend := False;
  Theme.Skin.GEBlendColor := clWhite;
  Theme.Skin.GEBlendAlpha := 32;
  Theme.Skin.GELighten := True;
  Theme.Skin.GELightenAmount := 32;
end;

procedure SetThemeDesktopIconDefault;
begin
  with Theme.DesktopIcon do
  begin
    IconSize        := 48;
    IconAlphaBlend  := False;
    IconAlpha       := 255;
    IconBlending    := False;
    IconBlendColor  := 0;
    IconBlendAlpha  := 255;
    IconShadow      := True;
    IconShadowColor := 0;
    IconShadowAlpha := 128;
    FontName        := 'Verdana';
    TextSize        := 8;
    TextBold        := False;
    TextItalic      := False;
    TextUnderline   := False;
    TextColor       := 0;
    TextAlpha       := False;
    TextAlphaValue  := 255;
    TextShadow      := False;
    TextShadowAlpha := 255;
    TextShadowColor := 0;
    TextShadowType  := 0;
    TextShadowSize  := 1;
    DisplayText     := True;
  end;
end;

procedure SetThemeDesktopAnimDefault;
begin
  with Theme.DesktopAnim do
  begin
    UseAnimations   := True;
    Scale           := False;
    ScaleValue      := 0;
    Alpha           := True;
    AlphaValue      := 128;
    Blend           := True;
    BlendValue      := 255;
    BlendColor      := 11842737;
    Brightness      := True;
    BrightnessValue := 25;
  end;
end;

procedure SetThemeWallpaperDefault;
begin
  setlength(Theme.Wallpapers,1);
  setlength(Theme.MonitorWallpapers,1);
  Theme.MonitorWallpapers[0].Name := 'Default';
  Theme.MonitorWallpapers[0].ID := -100;
  with Theme.Wallpapers[0] do
  begin
    Name            := 'Default';
    Image           := '';
    Color           := 0;
    Alpha           := 255;
    Size            := twsScale;
    ColorChange     := False;
    Hue             := 0;
    Saturation      := 0;
    Lightness       := 0;
    Gradient        := False;
    GradientType    := twgtHoriz;
    GDStartColor    := 0;
    GDStartAlpha    := 0;
    GDEndColor      := 0;
    GDEndAlpha      := 0;
    MirrorHoriz     := False;
    MirrorVert      := False;
  end;
end;

// ##########################################
//      LOAD THEME PARTS
// ##########################################

procedure LoadThemeSkinFont;
var
  XML : TJvSimpleXML;
begin
  SetThemeSkinFontDefault;
  if not FileExists(Theme.Data.Directory + SKINFONT_FILE) then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(Theme.Data.Directory + SKINFONT_FILE);
    with XML.Root.Items do
      with Theme.SkinFont do
      begin
        ModSize          := BoolValue('ModSize',ModSize);
        ModName          := BoolValue('ModName',ModName);
        ModAlpha         := BoolValue('ModAlpha',ModAlpha);
        ModUseShadow     := BoolValue('ModUseShadow',ModUseShadow);
        ModShadowType    := BoolValue('ModShadowType',ModShadowType);
        ModShadowAlpha   := BoolValue('ModShadowAlpha',ModShadowAlpha);
        ModBold          := BoolValue('ModBold',ModBold);
        ModItalic        := BoolValue('ModItalic',ModItalic);
        ModUnderline     := BoolValue('ModUnderline',ModUnderline);
        ValueSize        := IntValue('ValueSize',ValueSize);
        ValueName        := Value('ValueName',ValueName);
        ValueAlpha       := IntValue('ValueAlpha',ValueAlpha);
        ValueUseShadow   := BoolValue('ValueUseShadow',ValueUseShadow);
        ValueShadowType  := IntValue('ValueShadowType',ValueShadowType);
        ValueShadowAlpha := IntValue('ValueShadowAlpha',ValueShadowAlpha);
        ValueBold        := BoolValue('ValueBold',ValueBold);
        ValueItalic      := BoolValue('ValueItalic',ValueItalic);
        ValueUnderline   := BoolValue('ValueUnderline',ValueUnderline);
      end;
  finally
    XML.Free;
  end;

  Theme.SkinFont.LastUpdate := DateTimeToUnix(Now());
end;

procedure LoadThemeIconSet;
var
  XML: TJvSimpleXML;
  n: integer;
begin
  SetThemeIconSetDefault;
  if not FileExists(Theme.Data.Directory + ICONSET_FILE) then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    try
      XML.LoadFromFile(Theme.Data.Directory + ICONSET_FILE);
      Theme.IconSet.Directory := SharpApi.GetSharpeDirectory + ICONS_DIR + '\' + XML.Root.Items.Value('Name', DEFAULT_ICONSET);
    except
      Theme.IconSet.Directory := SharpApi.GetSharpeDirectory + ICONS_DIR + '\' + DEFAULT_ICONSET;
    end;
  finally
    XML.Free;
  end;

  if ((not DirectoryExists(Theme.IconSet.Directory))
    or (not FileExists(Theme.IconSet.Directory + '\IconSet.xml'))) then
  begin
    SetThemeIconSetDefault;
    exit;
  end;

  Theme.IconSet.Directory := Theme.IconSet.Directory + '\';
  XML := TJvSimpleXML.Create(nil);
  try
    try
      XML.LoadFromFile(Theme.IconSet.Directory + '\IconSet.xml');
      Theme.IconSet.Name := XML.Root.Items.Value('Name', 'Default');
      Theme.IconSet.Author := XML.Root.Items.Value('Author', '');
      Theme.IconSet.Website := XML.Root.Items.Value('Website', '');
      if XML.Root.Items.ItemNamed['Icons'] <> nil then
        with XML.Root.Items.ItemNamed['Icons'].Items do
        begin
          for n := 0 to Count - 1 do
          begin
            setlength(Theme.IconSet.Icons, length(Theme.IconSet.Icons) + 1);
            Theme.IconSet.Icons[High(Theme.IconSet.Icons)].Tag := Item[n].Items.Value('Name', '');
            Theme.IconSet.Icons[High(Theme.IconSet.Icons)].FileName := Item[n].Items.Value('File', '');
          end;
        end;
    except
    end;
  finally
    XML.Free;
  end;
  Theme.IconSet.LastUpdate := DateTimeToUnix(Now());
end;

procedure LoadThemeSkin;
var
  XML: TJvSimpleXML;
  sCurSkin: string;
  sSkinDir: string;
begin
  SetThemeSkinDefault;
  sSkinDir := '';

  // Get theme scheme name
  XML := TJvSimpleXML.Create(nil);
  try
    // Get Scheme Name
    if FileExists(Theme.Data.Directory + SKIN_FILE) then
    begin
      try
        XML.LoadFromFile(Theme.Data.Directory + SKIN_FILE);
        with XML.Root.Items do
        begin
          sCurSkin := Value('skin', 'default');
          Theme.Skin.GEBlurRadius     := IntValue('GEBlurRadius',Theme.Skin.GEBlurRadius);
          Theme.Skin.GEBlurIterations := IntValue('GEBlurIterations',Theme.Skin.GEBlurIterations);
          Theme.Skin.GEBlend          := BoolValue('GEBlend',Theme.Skin.GEBlend);
          Theme.Skin.GEBlendColor     := IntValue('GEBlendColor',Theme.Skin.GEBlendColor);
          Theme.Skin.GEBlendAlpha     := IntValue('GEBlendAlpha',Theme.Skin.GEBlendAlpha);
          Theme.Skin.GELighten        := BoolValue('GELighten',Theme.Skin.GELighten);
          Theme.Skin.GELightenAmount  := IntValue('GELightenAmount',Theme.Skin.GELightenAmount);
        end;
      except
        sCurSkin := 'default';
      end;

      if CompareText(sCurSkin, 'default') <> 0 then
        sSkinDir := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + sCurSkin + '\'
      else
        sSkinDir := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + 'SharpE' + '\';
    end
    else
    begin
      if DirectoryExists(SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + 'SharpE' + '\') then
        sSkinDir := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + 'SharpE' + '\'
      else
        sSkinDir := '';
    end;

  finally
    XML.Free;
    Theme.Skin.Directory := sSkinDir;
    Theme.Skin.Name := sCurSkin;
  end;

  Theme.Skin.LastUpdate := DateTimeToUnix(Now());
end;

procedure LoadThemeScheme;
var
  XML: TJvSimpleXML;
  i, ItemCount, Index: Integer;
  tmpRec: TSharpESkinColor;
  sFile, sTag, sCurScheme: string;
  tmpColor: string;
  s : String;
begin
  Index := 0;

  if not DirectoryExists(Theme.Skin.Directory + SKINS_SCHEME_DIRECTORY) then
    SetThemeSchemeDefault;

  // Get theme scheme name
  XML := TJvSimpleXML.Create(nil);
  try
    // Get Scheme Name
    sCurScheme := 'default';
    if FileExists(Theme.Data.Directory + SCHEME_FILE) then
    begin
      try
        Xml.LoadFromFile(Theme.Data.Directory + SCHEME_FILE);
        sCurScheme := XML.Root.Items.Value('scheme', 'default');
      except
        sCurScheme := 'default';
      end;
    end;
    Theme.Scheme.Name := sCurScheme;

    // Get Scheme Colors
    Setlength(Theme.Scheme.Colors, 0);
    XML.Root.Clear;
    try
      XML.LoadFromFile(Theme.Skin.Directory + SCHEME_FILE);
      for i := 0 to Pred(XML.Root.Items.Count) do
      begin
        ItemCount := high(Theme.Scheme.Colors);
        SetLength(Theme.Scheme.Colors, ItemCount + 2);
        tmpRec := Theme.Scheme.Colors[ItemCount + 1];

        with XML.Root.Items.Item[i].Items do
        begin
          tmpRec.Name := Value('name', '');
          tmpRec.Tag := Value('tag', '');
          tmpRec.Info := Value('info', '');
          tmpRec.Color := ParseColor(PChar(Value('Default', '0')));
          s := Value('type','color');
          if CompareText(s,'boolean') = 0 then
             tmpRec.schemetype := stBoolean
             else if CompareText(s,'integer') = 0 then
                  tmpRec.schemetype := stInteger
                  else tmpRec.schemetype := stColor;
        end;
        Theme.Scheme.Colors[ItemCount + 1] := tmpRec;
      end;
    except
    end;

    sFile := Theme.Skin.Directory + SKINS_SCHEME_DIRECTORY + '\' + sCurScheme + '.xml';
    if FileExists(sFile) then
    begin
      try
        XML.LoadFromFile(sFile);

        for i := 0 to Pred(XML.Root.Items.Count) do
          with XML.Root.Items.Item[i].Items do
          begin
            sTag := Value('tag', '');
            tmpColor := Value('color', inttostr(Theme.Scheme.Colors[Index].Color));

            Index := GetSchemeColorIndexByTag(pchar(sTag));
            if Index >= 0 then
              Theme.Scheme.Colors[Index].Color := ParseColor(PChar(tmpColor));
          end;
      except
      end;
    end;
  finally
    XML.Free;
  end;
  Theme.Scheme.LastUpdate := DateTimeToUnix(Now());
end;

procedure LoadThemeInfo;
var
  XML: TJvSimpleXML;
begin
  SetThemeInfoDefault;
  if not FileExists(Theme.Data.Directory + THEME_INFO_FILE) then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    try
      XML.LoadFromFile(Theme.Data.Directory + THEME_INFO_FILE);
      with XML.Root.Items do
      begin
        Theme.Info.Name := Value('Name', 'Default');
        Theme.Info.Author := Value('Author', '');
        Theme.Info.Comment := Value('Comment', 'Default SharpE Theme');
        Theme.Info.Website := Value('Website', '');
      end;
    except
      SetThemeInfoDefault;
    end;
  finally
    XML.Free;
  end;
  Theme.Info.LastUpdate := DateTimeToUnix(Now());
end;

procedure LoadThemeDesktopIcon;
var
  XML : TJvSimpleXML;
begin
  SetThemeDesktopIconDefault;
  if not FileExists(Theme.Data.Directory + DESKTOPICON_FILE) then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    try
      XML.LoadFromFile(Theme.Data.Directory + DESKTOPICON_FILE);
      with XML.Root.Items do
      with Theme.DesktopIcon do
      begin
        IconSize        := IntValue('IconSize',IconSize);
        IconAlphaBlend  := BoolValue('IconAlphaBlend',IconAlphaBlend);
        IconAlpha       := IntValue('IconAlpha',IconAlpha);
        IconBlending    := BoolValue('IconBlending',IconBlending);
        IconBlendColor  := IntValue('IconBlendColor',IconBlendColor);
        IconBlendAlpha  := IntValue('IconBlendAlpha',IconBlendAlpha);
        IconShadow      := BoolValue('IconShadow',IconShadow);
        IconShadowColor := IntValue('IconShadowColor',IconShadowColor);
        IconShadowAlpha := IntValue('IconShadowAlpha',IconShadowAlpha);
        FontName        := Value('FontName',FontName);
        TextSize        := IntValue('TextSize',TextSize);
        TextBold        := BoolValue('TextBold',TextBold);
        TextItalic      := BoolValue('TextItalic',TextItalic);
        TextUnderline   := BoolValue('TextUnderline',TextUnderline);
        TextColor       := IntValue('TextColor',TextColor);
        TextAlpha       := BoolValue('TextAlpha',TextAlpha);
        TextAlphaValue  := IntValue('TextAlphaValue',TextAlphaValue);
        TextShadow      := BoolValue('TextShadow',TextShadow);
        TextShadowAlpha := IntValue('TextShadowAlpha',TextShadowAlpha);
        TextShadowColor := IntValue('TextShadowColor',TextShadowColor);
        TextShadowType  := IntValue('TextShadowType',TextShadowType);
        TextShadowSize  := IntValue('TextShadowSize',TextShadowSize);
        DisplayText     := BoolValue('DisplayText',DisplayText);
      end;
    except
      SetThemeDesktopIconDefault;
    end;
  finally
    XML.Free;
  end;
  Theme.DesktopIcon.LastUpdate := DateTimeToUnix(Now());
end;

procedure LoadThemeDesktopAnim;
var
  XML : TJvSimpleXML;
begin
  SetThemeDesktopAnimDefault;
  if not FileExists(Theme.Data.Directory + DESKTOPANIM_FILE) then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    try
      XML.LoadFromFile(Theme.Data.Directory + DESKTOPANIM_FILE);
      with XML.Root.Items do
      with Theme.DesktopAnim do
      begin
        UseAnimations   := BoolValue('UseAnimations',UseAnimations);
        Scale           := BoolValue('Scale',Scale);
        ScaleValue      := IntValue('ScaleValue',ScaleValue);
        Alpha           := BoolValue('Alpha',Alpha);
        AlphaValue      := IntValue('AlphaValue',AlphaValue);
        Blend           := BoolValue('Blend',Blend);
        BlendValue      := IntValue('BlendValue',BlendValue);
        BlendColor      := IntValue('BlendColor',BlendColor);
        Brightness      := BoolValue('Brightness',Brightness);
        BrightnessValue := IntValue('BrightnessValue',BrightnessValue);
      end;
    except
      SetThemeDesktopAnimDefault;
    end;
  finally
    XML.Free;
  end;
  Theme.DesktopAnim.LastUpdate := DateTimeToUnix(Now());
end;

procedure LoadThemeWallpaper;
var
  XML : TJvSimpleXML;
  n,i : integer;
begin
  SetThemeWallpaperDefault;
  if not (FileExists(Theme.Data.Directory + WALLPAPER_FILE)) then
     exit;

  XML := TJvSimpleXML.Create(nil);
  try
    try
      XML.LoadFromFile(Theme.Data.Directory + WALLPAPER_FILE);
      if XML.Root.Items.ItemNamed['Wallpapers'] <> nil then
         for n := 0 to XML.Root.Items.ItemNamed['Wallpapers'].Items.Count - 1 do
             with XML.Root.Items.ItemNamed['Wallpapers'].Items.Item[n].Items do
             begin
               if n <> 0 then
                  setlength(Theme.Wallpapers,length(Theme.Wallpapers)+1);
               with Theme.Wallpapers[High(Theme.Wallpapers)] do
               begin
                Name            := Value('Name',Name);
                Image           := Value('Image',Image);
                Color           := IntValue('Color',Color);
                Alpha           := IntValue('Alpha',Alpha);
                i               := IntValue('Size',0);
                case i of
                  0: Size := twsCenter;
                  2: Size := twsStretch;
                  3: Size := twsTile;
                  else Size := twsScale;
                 end;
                 ColorChange     := BoolValue('ColorChange',ColorChange);
                 Hue             := IntValue('Hue',Hue);
                 Saturation      := IntValue('Saturation',Saturation);
                 Lightness       := IntValue('Lightness',Lightness);
                 Gradient        := BoolValue('Gradient',Gradient);
                 i               := IntValue('GradientType',0);
                 case i of
                   1: GradientType := twgtVert;
                   2: GradientType := twgtTSHoriz;
                   3: GradientType := twgtTSVert
                   else GradientType := twgtHoriz;
                 end;
                 GDStartColor    := IntValue('GDStartColor',GDStartColor);
                 GDStartAlpha    := IntValue('GDStartAlpha',GDStartAlpha);
                 GDEndColor      := IntValue('GDEndColor',GDEndColor);
                 GDEndAlpha      := IntValue('GDEndAlpha',GDEndAlpha);
                 MirrorHoriz     := BoolValue('MirrorHoriz',MirrorHoriz);
                 MirrorVert      := BoolValue('MirrorVert',MirrorVert);
               end;
             end;
      if XML.Root.Items.ItemNamed['Monitors'] <> nil then
         for n := 0 to XML.Root.Items.ItemNamed['Monitors'].Items.Count - 1 do
             with XML.Root.Items.ItemNamed['Monitors'].Items.Item[n].Items do
             begin
               if n <> 0 then
                  setlength(Theme.MonitorWallpapers,length(Theme.MonitorWallpapers)+1);
               Theme.MonitorWallpapers[High(Theme.MonitorWallpapers)].Name := Value('Name','Default');
               Theme.MonitorWallpapers[High(Theme.MonitorWallpapers)].ID := IntValue('ID',-100);
             end;
    except
      SetThemeWallpaperDefault;
    end;
  finally
    XML.Free;
  end;
  Theme.WallpapresLastUpdate := DateTimeToUnix(Now());
end;

// ##########################################
//      EXPORT: THEME INFO
// ##########################################

function GetThemeName: PChar;
begin
  result := PChar(Theme.Info.Name);
end;

function GetThemeAuthor: PChar;
begin
  result := PChar(Theme.Info.Author);
end;

function GetThemeComment: PChar;
begin
  result := PChar(Theme.Info.Comment);
end;

function GetThemeWebsite: PChar;
begin
  result := PChar(Theme.Info.Website);
end;

// ##########################################
//      EXPORT: THEME DATA
// ##########################################

// Get Directory of the Current Theme

function GetCurrentThemeDirectory: PChar;
begin
  result := PChar(Theme.Data.Directory);
end;

// Get Directory for Theme with Name = pName

function GetThemeDirectory(pName: PChar): PChar;
var
  ThemeDir: string;
begin
  ThemeDir := SharpApi.GetSharpeUserSettingsPath + THEME_DIR + '\';

  if not DirectoryExists(ThemeDir + pName) then
    rtemp := ThemeDir + DEFAULT_THEME + '\'
  else
    rtemp := ThemeDir + pName + '\';

  result := PChar(rtemp);
end;

// ##########################################
//      EXPORT: THEME SKIN
// ##########################################

function GetSkinGEBlurRadius: integer;
begin
  result := Theme.Skin.GEBlurRadius;
end;

function GetSkinGEBlurIterations: integer;
begin
  result := Theme.Skin.GEBlurIterations;
end;

function GetSkinGEBlend: boolean;
begin
  result := Theme.Skin.GEBlend;
end;

function GetSkinGEBlendColor: integer;
begin
  result := Theme.Skin.GEBlendColor;
end;

function GetSkinGEBlendAlpha: integer;
begin
  result := Theme.Skin.GEBlendAlpha;
end;

function GetSkinGELighten: boolean;
begin
  result := Theme.Skin.GELighten;
end;

function GetSkinGELightenAmount: integer;
begin
  result := Theme.Skin.GELightenAmount
end;

function GetSkinDirectory : PChar;
begin
  result := PChar(Theme.Skin.Directory);
end;

function GetSkinName: PChar;
begin
  result := PChar(Theme.Skin.Name);
end;

function GetSkinColorCount: integer;
begin
  result := length(Theme.Scheme.Colors);
end;

function GetSkinColor(pIndex: integer): TSharpESkinColor;
begin
  if pIndex > GetSkinColorCount - 1 then
  begin
    result.Name := '';
    result.Tag := '';
    result.Color := 0;
    result.schemetype := stColor;
    exit;
  end;

  result.Name := Theme.Scheme.Colors[pIndex].Name;
  result.Tag := Theme.Scheme.Colors[pIndex].Tag;
  result.Color := Theme.Scheme.Colors[pIndex].Color;
  result.schemetype := Theme.Scheme.Colors[pIndex].SchemeType;
end;

// ##########################################
//      EXPORT: THEME SCHEME
// ##########################################

function GetSchemeDirectory : PChar;
begin
  rtemp := GetSkinDirectory + SKINS_SCHEME_DIRECTORY + '\';
  result := PChar(rtemp);
end;

function GetSchemeName: PChar;
begin
  result := PChar(Theme.Scheme.Name);
end;

// ##########################################
//      EXPORT: THEME ICON SET
// ##########################################

function GetIconSetName: PChar;
begin
  result := PChar(Theme.IconSet.Name);
end;

function GetIconSetAuthor: PChar;
begin
  result := PChar(Theme.IconSet.Author);
end;

function GetIconSetWebsite: PChar;
begin
  result := PChar(Theme.IconSet.Website);
end;

function GetIconSetDirectory: PChar;
begin
  result := PChar(Theme.IconSet.Directory);
end;

function GetIconSetIconsCount: integer;
begin
  result := length(Theme.IconSet.Icons);
end;

function GetIconSetIconByIndex(pIndex: integer): TSharpEIcon;
begin
  if pIndex > GetIconSetIconsCount - 1 then
  begin
    result.FileName := '';
    result.Tag := '';
    exit;
  end;

  result.FileName := Theme.IconSet.Icons[pIndex].FileName;
  result.Tag := Theme.IconSet.Icons[pIndex].Tag;
end;

function GetIconSetIconByTag(pTag: PChar): TSharpEIcon;
var
  n: integer;
begin
  for n := 0 to GetIconSetIconsCount - 1 do
    if Theme.IconSet.Icons[n].Tag = pTag then
    begin
      result.FileName := Theme.IconSet.Icons[n].FileName;
      result.Tag := Theme.IconSet.Icons[n].Tag;
      exit;
    end;

  result.FileName := '';
  result.Tag := '';
end;

function IsIconInIconSet(pTag: PChar): boolean;
var
  n: integer;
begin
  result := False;
  for n := 0 to GetIconSetIconsCount - 1 do
    if Theme.IconSet.Icons[n].Tag = pTag then
    begin
      result := True;
      exit;
    end;
end;


// ##########################################
//      EXPORT: Desktop Animation
// ##########################################

function GetDesktopAnimUseAnimations : boolean;
begin
  result := Theme.DesktopAnim.UseAnimations;
end;

function GetDesktopAnimScale : boolean;
begin
  result := Theme.DesktopAnim.Scale;
end;

function GetDesktopAnimScaleValue : integer;
begin
  result := Theme.DesktopAnim.ScaleValue;
end;

function GetDesktopAnimAlpha : boolean;
begin
  result := Theme.DesktopAnim.Alpha;
end;

function GetDesktopAnimAlphaValue : integer;
begin
  result := Theme.DesktopAnim.AlphaValue;
end;

function GetDesktopAnimBlend : boolean;
begin
  result := Theme.DesktopAnim.Blend;
end;

function GetDesktopAnimBlendValue : integer;
begin
  result := Theme.DesktopAnim.BlendValue;
end;

function GetDesktopAnimBlendColor : integer;
begin
  result := Theme.DesktopAnim.BlendColor;
end;

function GetDesktopAnimBrightness : boolean;
begin
  result := Theme.DesktopAnim.Brightness;
end;

function GetDesktopAnimBrightnessValue : integer;
begin
  result := Theme.DesktopAnim.BrightnessValue;
end;

// ##########################################
//      EXPORT: Wallpaper
// ##########################################

function GetMonitorWallpaper(Index : integer) : TThemeWallpaper;
var
  n,i : integer;
begin
  for n := 0 to High(Theme.MonitorWallpapers) do
      if Theme.MonitorWallpapers[n].ID = index then
         for i := 0 to High(Theme.Wallpapers) do
             if CompareText(Theme.Wallpapers[i].Name,Theme.MonitorWallpapers[n].Name) = 0 then
             begin
               result := Theme.Wallpapers[i];
               exit;
             end;

  result := Theme.Wallpapers[0];
end;


// ##########################################
//      EXPORT: Desktop Icon
// ##########################################

function GetDesktopIconSize : integer;
begin
  result := Theme.DesktopIcon.IconSize;
end;

function GetDesktopIconAlphaBlend : boolean;
begin
  result := Theme.DesktopIcon.IconAlphaBlend;
end;

function GetDesktopIconAlpha : integer;
begin
  result := Theme.DesktopIcon.IconAlpha;
end;

function GetDesktopIconBlending : boolean;
begin
  result := Theme.DesktopIcon.IconBlending;
end;

function GetDesktopIconBlendColor : integer;
begin
  result := Theme.DesktopIcon.IconBlendColor;
end;

function GetDesktopIconBlendAlpha : integer;
begin
  result := Theme.DesktopIcon.IconBlendAlpha;
end;

function GetDesktopIconShadow : boolean;
begin
  result := Theme.DesktopIcon.IconShadow;
end;

function GetDesktopIconShadowColor : integer;
begin
  result := Theme.DesktopIcon.IconShadowColor;
end;

function GetDesktopIconShadowAlpha : integer;
begin
  result := Theme.DesktopIcon.IconShadowAlpha;
end;

function GetDesktopFontName: PChar;
begin
  result := PChar(Theme.DesktopIcon.FontName);
end;

function GetDesktopTextSize : integer;
begin
  result := Theme.DesktopIcon.TextSize;
end;

function GetDesktopTextBold : Boolean;
begin
  result := Theme.DesktopIcon.TextBold;
end;

function GetDesktopTextItalic : boolean;
begin
  result := Theme.DesktopIcon.TextItalic;
end;

function GetDesktopTextUnderline : Boolean;
begin
  result := Theme.DesktopIcon.TextUnderline;
end;

function GetDesktopTextColor : integer;
begin
  result := Theme.DesktopIcon.TextColor;
end;

function GetDesktopTextAlpha : boolean;
begin
  result := Theme.DesktopIcon.TextAlpha;
end;

function GetDesktopTextAlphaValue : integer;
begin
  result := Theme.DesktopIcon.TextAlphaValue;
end;

function GetDesktopTextShadow : boolean;
begin
  result := Theme.DesktopIcon.TextShadow;
end;

function GetDesktopDisplayText : boolean;
begin
  result := Theme.DesktopIcon.DisplayText;
end;

function GetDesktopTextShadowAlpha : integer;
begin
  result := Theme.DesktopIcon.TextShadowAlpha;
end;

function GetDesktopTextShadowColor : integer;
begin
  result := Theme.DesktopIcon.TextShadowColor;
end;

function GetDesktopTextShadowType : integer;
begin
  result := Theme.DesktopIcon.TextShadowType;
end;

function GetDesktopTextShadowSize : integer;
begin
  result := Theme.DesktopIcon.TextShadowSize;
end;

// ##########################################
//      EXPORT: SKIN FONT
// ##########################################

function GetSkinFontModSize : boolean;
begin
  result := Theme.SkinFont.ModSize;
end;

function GetSkinFontModName : boolean;
begin
  result := Theme.SkinFont.ModName;
end;

function GetSkinFontModAlpha : boolean;
begin
  result := Theme.SkinFont.ModAlpha;
end;

function GetSkinFontModUseShadow : boolean;
begin
  result := Theme.SkinFont.ModUseShadow;
end;

function GetSkinFontModShadowType : boolean;
begin
  result := Theme.SkinFont.ModShadowType;
end;

function GetSkinFontModShadowAlpha : boolean;
begin
  result := Theme.SkinFont.ModShadowAlpha;
end;

function GetSkinFontModBold : boolean;
begin
  result := Theme.SkinFont.ModBold;
end;

function GetSkinFontModItalic : boolean;
begin
  result := Theme.SkinFont.ModItalic;
end;

function GetSkinFontModUnderline : boolean;
begin
  result := Theme.SkinFont.ModUnderline;
end;

function GetSkinFontValueSize : integer;
begin
  result := Theme.SkinFont.ValueSize;
end;

function GetSkinFontValueName : String;
begin
  result := Theme.SkinFont.ValueName;
end;

function GetSkinFontValueAlpha : integer;
begin
  result := Theme.SkinFont.ValueAlpha;
end;

function GetSkinFontValueUseShadow : boolean;
begin
  result := Theme.SkinFont.ValueUseShadow;
end;

function GetSkinFontValueShadowType : integer;
begin
  result := Theme.SkinFont.ValueShadowType;
end;

function GetSkinFontValueShadowAlpha : integer;
begin
  result := Theme.SkinFont.ValueShadowAlpha;
end;

function GetSkinFontValueBold : boolean;
begin
  result := Theme.SkinFont.ValueBold;
end;

function GetSkinFontValueItalic : boolean;
begin
  result := Theme.SkinFont.ValueItalic;
end;

function GetSkinFontValueUnderline : boolean;
begin
  result := Theme.SkinFont.ValueUnderline;
end;

// ##########################################
//      EXPORT: SCHEME COLOR SET
// ##########################################

function GetSchemeColorCount: Integer;
begin
  result := length(Theme.Scheme.Colors);
end;

function GetSchemeColorByIndex(pIndex: integer): TSharpESkinColor;
begin
  if pIndex > GetSchemeColorCount - 1 then
  begin
    result.Name := '';
    result.Tag := '';
    Result.Info := '';
    Result.Color := 0;
    result.schemetype := stColor;
    exit;
  end;

  result.Name := Theme.Scheme.Colors[pIndex].Name;
  result.Tag := Theme.Scheme.Colors[pIndex].Tag;
  result.Info := Theme.Scheme.Colors[pIndex].Info;
  result.Color := Theme.Scheme.Colors[pIndex].Color;
  result.schemetype := Theme.Scheme.Colors[pIndex].SchemeType;
end;

function GetSchemeColorIndexByTag(pTag: string): Integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to GetSchemeColorCount - 1 do
  begin
    if CompareText(Theme.Scheme.Colors[i].Tag, pTag) = 0 then
      Result := i;
  end;
end;

function GetSchemeColorByTag(pTag: string): TSharpESkinColor;
var
  i: integer;
begin
  result.Name := '';
  result.Tag := '';
  Result.Info := '';
  Result.Color := 0;
  result.SchemeType := stColor;

  for i := 0 to GetSchemeColorCount - 1 do
  begin
    if CompareText(Theme.Scheme.Colors[i].Tag, pTag) = 0 then
    begin
      result.Name := Theme.Scheme.Colors[i].Name;
      result.Tag := Theme.Scheme.Colors[i].Tag;
      result.Info := Theme.Scheme.Colors[i].Info;
      result.Color := Theme.Scheme.Colors[i].Color;
      result.SchemeType := Theme.Scheme.Colors[i].SchemeType;
      exit;
    end;
  end;
end;

// ##########################################
//      EXPORT: THEME DLL CONTROLS
// ##########################################

procedure InitializeTheme;
begin
  Theme.Data.LastUpdate := 0;
  Theme.Data.Directory := SharpApi.GetSharpeUserSettingsPath + THEME_DIR + '\' + DEFAULT_THEME + '\';
  Theme.Data.LastUpdate := DateTimeToUnix(Now());

  SetThemeInfoDefault;
  SetThemeSchemeDefault;
  SetThemeSkinDefault;
  SetThemeSkinFontDefault;
  SetThemeIconSetDefault;
  SetThemeDesktopIconDefault;
  SetThemeDesktopAnimDefault;
  SetThemeWallpaperDefault;

  bInitialized := True;
end;


function LoadTheme(pName: PChar; ForceReload: Boolean = False; ThemeParts : TThemeParts = ALL_THEME_PARTS): boolean;
var
  ThemeDir: string;
  ct : Int64;
begin
  ThemeDir := SharpApi.GetSharpeUserSettingsPath + THEME_DIR + '\' + pName;

  if not DirectoryExists(ThemeDir) then
  begin
    // Theme dir doesn't exist!
    // return False and load default values
    result := False;
    InitializeTheme;
    exit;
  end;

  Theme.Data.Directory := ThemeDir + '\';
  Theme.Data.LastUpdate := DateTimeToUnix(Now());

  ct := DateTimeToUnix(Now());
  if (tpInfo in ThemeParts) and
     (ct - Theme.Info.LastUpdate > 1) or (ForceReload) then LoadThemeInfo;
  if (tpSkin in ThemeParts) and
     (ct - Theme.Skin.LastUpdate > 1) or (ForceReload) then LoadThemeSkin;
  if ((tpSkin in ThemeParts) or (tpSkinFont in ThemeParts)) and
     (ct - Theme.SkinFont.LastUpdate > 1) or (ForceReload) then LoadThemeSkinFont;
  if (tpScheme  in ThemeParts) and
     (ct - Theme.Scheme.LastUpdate > 1) or (ForceReload) then LoadThemeScheme;
  if (tpIconSet in ThemeParts) and
     (ct - Theme.IconSet.LastUpdate > 1) or (ForceReload) then LoadThemeIconSet;
  if (tpDesktopIcon in ThemeParts) and
     (ct - Theme.DesktopIcon.LastUpdate >1) or (ForceReload) then LoadThemeDesktopIcon;
  if (tpDesktopAnimation in ThemeParts) and
     (ct - Theme.DesktopAnim.LastUpdate >1) or (ForceReload) then LoadThemeDesktopAnim;
  if (tpWallpaper in ThemeParts) and
     (ct - Theme.WallpapresLastUpdate >1) or (ForceReload) then LoadThemeWallpaper;

  result := True;
end;

function LoadCurrentTheme(ForceUpdate : boolean = False; ThemeParts : TThemeParts = ALL_THEME_PARTS) : boolean;
var
  themename: string;
begin
  themename := GetCurrentThemeName;
  result := LoadTheme(PChar(themename),ForceUpdate,ThemeParts);
end;

// ##########################################
//      EXPORT: GLOBAL
// ##########################################

function GetCurrentSharpEThemeName : PChar;
begin
  rtemp := GetCurrentThemeName;
  result := PChar(rtemp);
end;

// Temporary for compatibility
function LoadCurrentThemeF(ForceUpdate : boolean) : boolean;
begin
  result := True;
end;


{$R *.res}

exports
  // Main Functions
  InitializeTheme,
  Initialized,
  LoadTheme,
  LoadCurrentTheme,
  LoadCurrentThemeF,

  //Global
  GetCurrentSharpEThemeName,

  // Theme Data
  GetCurrentThemeDirectory,
  GetThemeDirectory,

  // Theme Info
  GetThemeName,
  GetThemeAuthor,
  GetThemeComment,
  GetThemeWebsite,

  // Theme Scheme
  GetSchemeName,
  SchemeCodeToColor,
  ColorToSchemeCode,
  GetSchemeColorByTag,
  GetSchemeColorIndexByTag,
  GetSchemeColorByIndex,
  GetSchemeColorCount,
  GetSchemeDirectory,
  ParseColor,

  // Theme Skin
  GetSkinName,
  GetSkinColorCount,
  GetSkinColor,
  GetSkinDirectory,
  GetSkinGEBlurRadius,
  GetSkinGEBlurIterations,
  GetSkinGEBlend,
  GetSkinGEBlendColor,
  GetSkinGEBlendAlpha,
  GetSkinGELighten,
  GetSkinGELightenAmount,

  // Theme IconSet
  GetIconSetName,
  GetIconSetAuthor,
  GetIconSetWebsite,
  GetIconSetDirectory,
  GetIconSetIconsCount,
  GetIconSetIconByIndex,
  GetIconSetIconByTag,
  IsIconInIconSet,

  // Theme Desktop Icon
  GetDesktopIconSize,
  GetDesktopIconAlphaBlend,
  GetDesktopIconAlpha,
  GetDesktopIconBlending,
  GetDesktopIconBlendColor,
  GetDesktopIconBlendAlpha,
  GetDesktopIconShadow,
  GetDesktopIconShadowColor,
  GetDesktopIconShadowAlpha,
  GetDesktopFontName,
  GetDesktopDisplayText,
  GetDesktopTextSize,
  GetDesktopTextBold,
  GetDesktopTextItalic,
  GetDesktopTextUnderline,
  GetDesktopTextColor,
  GetDesktopTextAlpha,
  GetDesktopTextAlphaValue,
  GetDesktopTextShadow,
  GetDesktopTextShadowAlpha,
  GetDesktopTextShadowColor,
  GetDesktopTextShadowType,
  GetDesktopTextShadowSize,

  // Theme Desktop Animation
  GetDesktopAnimUseAnimations,
  GetDesktopAnimScale,
  GetDesktopAnimScaleValue,
  GetDesktopAnimAlpha,
  GetDesktopAnimAlphaValue,
  GetDesktopAnimBlend,
  GetDesktopAnimBlendValue,
  GetDesktopAnimBlendColor,
  GetDesktopAnimBrightness,
  GetDesktopAnimBrightnessValue,

  // Wallpaper
  GetMonitorWallpaper,

  // Skin Font
  GetSkinFontModSize,
  GetSkinFontModName,
  GetSkinFontModAlpha,
  GetSkinFontModUseShadow,
  GetSkinFontModShadowType,
  GetSkinFontModShadowAlpha,
  GetSkinFontModBold,
  GetSkinFontModItalic,
  GetSkinFontModUnderline,
  GetSkinFontValueSize,
  GetSkinFontValueName,
  GetSkinFontValueAlpha,
  GetSkinFontValueUseShadow,
  GetSkinFontValueShadowType,
  GetSkinFontValueShadowAlpha,
  GetSkinFontValueBold,
  GetSkinFontValueItalic,
  GetSkinFontValueUnderline;

begin
end.

