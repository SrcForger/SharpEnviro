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
  JvSimpleXML,
  Dialogs,
  GR32,
  Graphics,
  Windows,
  JclStrings,
  SharpAPI in '..\SharpAPI\SharpAPI.pas';

type
  TSharpESkinColor = record
    Name: string;
    Tag: string;
    Info: string;
    Color: integer;
  end;

  TSharpEColorSet = array of TSharpESkinColor;

  TSharpEIcon = record
    FileName: string;
    Tag: string;
  end;

  TThemeIconSet = record
    Name: string;
    Author: string;
    Website: string;
    Directory: string;
    Icons: array of TSharpEIcon;
  end;

  TThemeSkin = record
    Name: string;
    Scheme: string;
    Directory: string;
  end;

  TThemeData = record
    Directory: string;
    LastUpdate: Int64;
  end;

  TThemeInfo = record
    Name: string;
    Author: string;
    Comment: string;
    Website: string;
  end;

  TThemeScheme = record
    Name: string;
    Colors: TSharpEColorSet;
  end;

  TSharpETheme = record
    Data: TThemeData;
    Info: TThemeInfo;
    Scheme: TThemeScheme;
    Skin: TThemeSkin;
    IconSet: TThemeIconSet;
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
  ICONSET_FILE = 'IconSet';

  // ##########################################
  //   COLOR CONVERTING
  // ##########################################

function ParseColor(AColorStr: PChar): Integer;
var
  iStart, iEnd: Integer;
  h, s, l: double;
  sColorType, sParam: string;
  strlTokens: TStringList;
  r, g, b: byte;
  c: Integer;
  col32: TColor32;
  n : integer;

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
    if TryStrToInt(AColorStr,n) then result := n
    else
    begin
      try
        result := StringToColor(AColorStr);
      except
        result := -1;
      end;
    end;
    exit;
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
    if abs(pCode) < length(Theme.Scheme.Colors) - 1 then
      result := Theme.Scheme.Colors[abs(pCode)].Color;
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
      result := -n;
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

procedure SetThemeIconSetDefault;
begin
  Theme.IconSet.Name := 'Default';
  Theme.IconSet.Author := '';
  Theme.IconSet.Website := '';
  Theme.IconSet.Directory := SharpApi.GetSharpeDirectory + ICONS_DIR + '\' + DEFAULT_ICONSET;
  setlength(Theme.IconSet.Icons, 0);
end;

procedure SetThemeInfoDefault;
begin
  Theme.Info.Name := 'Default';
  Theme.Info.Author := '';
  Theme.Info.Comment := 'Default SharpE Theme';
  Theme.Info.Website := '';
end;

procedure SetThemeSchemeDefault;
begin
  Theme.Scheme.Name := 'Default';

  {setlength(Theme.Scheme.Colors, 1);
  Theme.Scheme.Colors[0].Name := 'Default';
  Theme.Scheme.Colors[0].Tag := 'Default';
  Theme.Scheme.Colors[0].Info := '';
  Theme.Scheme.Colors[0].Color := 16777215;  }
end;

procedure SetThemeSkinDefault;
begin
  Theme.Skin.Name := 'Default';
end;

// ##########################################
//      LOAD THEME PARTS
// ##########################################

procedure LoadIconSet;
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
  XML.Root.Clear;
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
        Xml.LoadFromFile(Theme.Data.Directory + SKIN_FILE);
        sCurSkin := XML.Root.Items.Value('skin', 'default');
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

  {if not FileExists(Theme.Data.Directory + SKIN_FILE) then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(Theme.Data.Directory + SKIN_FILE);
    with XML.Root.Items do
    begin
      Theme.Skin.Name := Value('Name');
      Theme.Skin.Scheme := Value('Scheme');
    end;
  finally
    XML.Free;
  end;
  Theme.Skin.Directory := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + Theme.Skin.Name + '\';  }
end;

procedure LoadThemeScheme;
var
  XML: TJvSimpleXML;
  i, ItemCount, Index: Integer;
  tmpRec: TSharpESkinColor;
  sFile, sTag, sCurScheme: string;
  tmpColor: string;
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
    exit;
  end;

  result.Name := Theme.Scheme.Colors[pIndex].Name;
  result.Tag := Theme.Scheme.Colors[pIndex].Tag;
  result.Color := Theme.Scheme.Colors[pIndex].Color;
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
  for n := 0 to GetIconSetIconsCount do
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
  for n := 0 to GetIconSetIconsCount do
    if Theme.IconSet.Icons[n].Tag = pTag then
    begin
      result := True;
      exit;
    end;
end;

function ValidateIcon(pFileName: PChar): PChar;
var
  sfile: string;
  sExt: string;
begin
  sfile := pFileName;
  if IsIconInIconSet(pFileName) then
    sfile := GetIconSetIconByTag(pFileName).FileName;

  sExt := ExtractFileExt(sfile);
  if ((not FileExists(sfile))
    and (sExt <> '.png')
    and (sExt <> '.jpg')
    and (sExt <> '.jpeg')
    and (sExt <> '.bmp')
    and (sExt <> '.bmp')
    and (GetIconSetIconsCount > 0)) then
    sfile := Theme.IconSet.Icons[0].FileName;

  rtemp := sfile;
  result := PChar(rtemp);
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
    exit;
  end;

  result.Name := Theme.Scheme.Colors[pIndex].Name;
  result.Tag := Theme.Scheme.Colors[pIndex].Tag;
  result.Info := Theme.Scheme.Colors[pIndex].Info;
  result.Color := Theme.Scheme.Colors[pIndex].Color;
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

  for i := 0 to GetSchemeColorCount - 1 do
  begin
    if CompareText(Theme.Scheme.Colors[i].Tag, pTag) = 0 then
    begin
      result.Name := Theme.Scheme.Colors[i].Name;
      result.Tag := Theme.Scheme.Colors[i].Tag;
      result.Info := Theme.Scheme.Colors[i].Info;
      result.Color := Theme.Scheme.Colors[i].Color;
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
  SetThemeIconSetDefault;

  bInitialized := True;
end;

function LoadTheme(pName: PChar; ForceReload: Boolean = False): boolean;
var
  ThemeDir: string;
begin
  if (DateTimeToUnix(Now()) - Theme.Data.LastUpdate <= 1)
     and (not ForceReload) then
  begin
    result := False;
    exit;
  end;

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

  LoadThemeInfo;
  LoadThemeSkin;
  LoadThemeScheme;
  LoadIconSet;

  result := True;
end;

function LoadCurrentThemeF(ForceUpdate : boolean) : boolean;
var
  themename: string;
begin
  themename := GetCurrentThemeName;
  result := LoadTheme(PChar(themename),ForceUpdate);
end;

function LoadCurrentTheme: boolean;
begin
  result := LoadCurrentThemeF(False);
end;

// ##########################################
//      EXPORT: GLOBAL
// ##########################################

function GetCurrentSharpEThemeName : PChar;
begin
  rtemp := GetCurrentThemeName;
  result := PChar(rtemp);
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

  // Theme IconSet
  GetIconSetName,
  GetIconSetAuthor,
  GetIconSetWebsite,
  GetIconSetDirectory,
  GetIconSetIconsCount,
  GetIconSetIconByIndex,
  GetIconSetIconByTag,
  IsIconInIconSet,
  ValidateIcon;

begin
end.

