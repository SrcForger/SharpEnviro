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
  bInitialized:Boolean;

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

function GetSchemeColorIndexByTag(pTag: string): Integer; forward;

function Initialized:Boolean;
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
    ForceDirectories(SharpApi.GetSharpeUserSettingsPath);
    XML.SaveToFile(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS);
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

  setlength(Theme.Scheme.Colors, 1);
  Theme.Scheme.Colors[0].Name := 'Default';
  Theme.Scheme.Colors[0].Tag := 'Default';
  Theme.Scheme.Colors[0].Info := '';
  Theme.Scheme.Colors[0].Color := 16777215;
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
  sCurSkin: String;
  sSkinDir: String;
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

      if CompareText(sCurSkin,'default') <> 0 then
        sSkinDir := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + sCurSkin + '\'
        else sSkinDir := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + 'SharpE' + '\';
    end else
    begin
      if DirectoryExists(SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + 'SharpE' + '\') then
        sSkinDir := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + 'SharpE' + '\'
        else sSkinDir := '';
    end;

  finally
    XML.Free;
    Theme.Skin.Directory := sSkinDir;
    Theme.Skin.Name := sCurSkin;
  End;

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
  i, j, ItemCount, Index: Integer;
  tmpItem: TJvSimpleXMLElem;
  tmpRec: TSharpESkinColor;
  sFile, sTag, sCurScheme: string;
  tmpColor: TColor;
  bDefault: Boolean;
begin
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

    // Get Scheme Colors
    Setlength(Theme.Scheme.Colors,0);
    XML.Root.Clear;
    try
      XML.LoadFromFile(Theme.Skin.Directory + SCHEME_FILE);
      for i := 0 to Pred(XML.Root.Items.Count) do
      begin
        ItemCount := high(Theme.Scheme.Colors);
        SetLength(Theme.Scheme.Colors, ItemCount+2);
        tmpRec :=  Theme.Scheme.Colors[ItemCount+1];

        with XML.Root.Items.Item[i].Items do
        begin
          tmpRec.Name := Value('name', '');
          tmpRec.Tag := Value('tag', '');
          tmpRec.Info := Value('info', '');
          tmpRec.Color := IntValue('Default', 0);
        end;
        Theme.Scheme.Colors[ItemCount+1] := tmpRec;
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
            tmpColor := IntValue('color', Theme.Scheme.Colors[Index].Color);

            Index := GetSchemeColorIndexByTag(pchar(sTag));
            if Index >= 0 then
              Theme.Scheme.Colors[Index].Color := tmpColor;
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
    if CompareText(Theme.Scheme.Colors[i].Tag, pTag) = 0 then begin
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
  bInitialized := False;
  Theme.Data.Directory := SharpApi.GetSharpeUserSettingsPath + THEME_DIR + '\' + DEFAULT_THEME + '\';
  Theme.Data.LastUpdate := DateTimeToUnix(Now());

  SetThemeInfoDefault;
  SetThemeSchemeDefault;
  SetThemeSkinDefault;
  SetThemeIconSetDefault;
end;

function LoadTheme(pName: PChar; ForceReload:Boolean=False): boolean;
var
  ThemeDir: string;
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

  LoadThemeInfo;
  LoadThemeSkin;
  LoadThemeScheme;
  LoadIconSet;

  bInitialized := True;
  result := True;
end;

function LoadCurrentTheme: boolean;
var
  themename: string;
begin
  themename := GetCurrentThemeName;
  result := LoadTheme(PChar(themename));
end;

{$R *.res}

exports
  // Main Functions
  InitializeTheme,
  Initialized,
  LoadTheme,
  LoadCurrentTheme,

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

  // Theme Skin
  GetSkinName,
  GetSkinColorCount,
  GetSkinColor,

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

