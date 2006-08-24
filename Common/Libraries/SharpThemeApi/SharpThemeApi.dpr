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
  SharpAPI in '..\SharpAPI\SharpAPI.pas';

type
  TSharpEColorSet = record
                      BaseColor  : integer;
                      LightColor : integer;
                      DarkColor  : integer;
                      FontColor  : integer;
                    end;

  TSharpESkinColor = record
                       Name  : String;
                       Tag   : String;
                       Color : integer;
                     end;

  TSharpEIcon = record
                  FileName : String;
                  Tag      : String;
                end;

                

  TThemeIconSet = record
                    Name      : String;
                    Author    : String;
                    Website   : String;
                    Directory : String;
                    Icons     : Array of TSharpEIcon;
                  end;

  TThemeSkin = record
                 Name : String;
                 SkinColors : array of TSharpESkinColor;
               end;

  TThemeData = record
                 Directory  : String;
                 LastUpdate : Int64;
               end;

  TThemeInfo = record
                 Name    : String;
                 Author  : String;
                 Comment : String;
                 Website : String;
               end;

  TThemeScheme = record
                   Name      : String;
                   FirstSet  : TSharpEColorSet;
                   SecondSet : TSharpEColorSet;
                   ThirdSet  : TSharpEColorSet;
                 end;

  TSharpETheme = record
                   Data    : TThemeData;
                   Info    : TThemeInfo;
                   Scheme  : TThemeScheme;
                   Skin    : TThemeSkin;
                   IconSet : TThemeIconSet;
                 end;

var
  Theme : TSharpETheme;
  rtemp : string;

const
  ICONS_DIR = 'Icons';
  THEME_DIR = 'Themes';

  DEFAULT_THEME = 'Default';
  DEFAULT_ICONSET = 'Cubeix Black';

  SHARPE_USER_SETTINGS = 'SharpE.xml';

  THEME_INFO_FILE = 'Theme.xml';
  SCHEME_FILE     = 'Scheme.xml';
  SKIN_FILE       = 'Skin.xml';
  ICONSET_FILE    = 'IconSet';

  scsFirstBaseColor   = -1;
  scsFirstLightColor  = -2;
  scsFirstDarkColor   = -3;
  scsFirstFontColor   = -4;
  scsSecondBaseColor  = -5;
  scsSecondLightColor = -6;
  scsSecondDarkColor  = -7;
  scsSecondFontColor  = -8;
  scsThirdBaseColor   = -9;
  scsThirdLightColor  = -10;
  scsThirdDarkColor   = -11;
  scsThirdFontColor   = -12;


// ##########################################
//   COLOR CONVERTING
// ##########################################

function SchemeCodeToColor(pCode : integer) : integer;
begin
  case pCode of
    scsFirstBaseColor   : result := Theme.Scheme.FirstSet.BaseColor;
    scsFirstLightColor  : result := Theme.Scheme.FirstSet.LightColor;
    scsFirstDarkColor   : result := Theme.Scheme.FirstSet.DarkColor;
    scsFirstFontColor   : result := Theme.Scheme.FirstSet.FontColor;
    scsSecondBaseColor  : result := Theme.Scheme.SecondSet.BaseColor;
    scsSecondLightColor : result := Theme.Scheme.SecondSet.LightColor;
    scsSecondDarkColor  : result := Theme.Scheme.SecondSet.DarkColor;
    scsSecondFontColor  : result := Theme.Scheme.SecondSet.FontColor;
    scsThirdBaseColor   : result := Theme.Scheme.ThirdSet.BaseColor;
    scsThirdLightColor  : result := Theme.Scheme.ThirdSet.LightColor;
    scsThirdDarkColor   : result := Theme.Scheme.ThirdSet.DarkColor;
    scsThirdFontColor   : result := Theme.Scheme.ThirdSet.FontColor;
    else result := pCode;
  end;
end;

function ColorToSchemeCode(pColor : integer) : integer;
begin
       if (pColor = Theme.Scheme.FirstSet.BaseColor) then   result := scsFirstBaseColor
  else if (pColor = Theme.Scheme.FirstSet.LightColor) then  result := scsFirstLightColor
  else if (pColor = Theme.Scheme.FirstSet.DarkColor) then   result := scsFirstDarkColor
  else if (pColor = Theme.Scheme.FirstSet.FontColor) then   result := scsFirstFontColor
  else if (pColor = Theme.Scheme.SecondSet.BaseColor) then  result := scsSecondBaseColor
  else if (pColor = Theme.Scheme.SecondSet.LightColor) then result := scsSecondLightColor
  else if (pColor = Theme.Scheme.SecondSet.DarkColor) then  result := scsSecondDarkColor
  else if (pColor = Theme.Scheme.SecondSet.FontColor) then  result := scsSecondFontColor
  else if (pColor = Theme.Scheme.ThirdSet.BaseColor) then   result := scsThirdBaseColor
  else if (pColor = Theme.Scheme.ThirdSet.LightColor) then  result := scsThirdLightColor
  else if (pColor = Theme.Scheme.ThirdSet.DarkColor) then   result := scsThirdDarkColor
  else if (pColor = Theme.Scheme.ThirdSet.FontColor) then   result := scsThirdFontColor
  else result := pColor;
end;

// ##########################################
//   FILE AND DIRECTORY STRUCTURE FUNCTIONS
// ##########################################

procedure CreateDefaultSharpeUserSettings;
var
  XML : TJvSimpleXML;
begin
  XML := TJvSimpleXML.Create(nil);
  try
    XML.Root.Name := 'SharpEUserSettings';
    XML.Root.Items.Clear;
    XML.Root.Items.Add('Theme','Default');
    ForceDirectories(SharpApi.GetSharpeUserSettingsPath);
    XML.SaveToFile(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS);
  finally
    XML.Free;
  end;
end;

function CheckSharpEUserSettings : boolean;
begin
  if FileExists(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS) then result := True
     else result := False;
end;



// ##########################################
//      HELPER FUNCTIONS
// ##########################################

function GetCurrentThemeName : String;
var
  XML : TJvSimpleXML;
begin
  if not CheckSharpEUserSettings then CreateDefaultSharpEUserSettings;

  result := 'Default';
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS);
    result := XML.Root.Items.Value('Theme','Default');
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
  setlength(Theme.IconSet.Icons,0);
end;

procedure SetThemeInfoDefault;
begin
  Theme.Info.Name    := 'Default';
  Theme.Info.Author  := '';
  Theme.Info.Comment := 'Default SharpE Theme';
  Theme.Info.Website := '';
end;

procedure SetThemeSchemeDefault;
begin
  Theme.Scheme.Name := 'Default';

  Theme.Scheme.FirstSet.BaseColor  := 0;
  Theme.Scheme.FirstSet.LightColor := 0;
  Theme.Scheme.FirstSet.DarkColor  := 0;
  Theme.Scheme.FirstSet.FontColor  := 0;

  Theme.Scheme.SecondSet.BaseColor  := 0;
  Theme.Scheme.SecondSet.LightColor := 0;
  Theme.Scheme.SecondSet.DarkColor  := 0;
  Theme.Scheme.SecondSet.FontColor  := 0;

  Theme.Scheme.ThirdSet.BaseColor  := 0;
  Theme.Scheme.ThirdSet.LightColor := 0;
  Theme.Scheme.ThirdSet.DarkColor  := 0;
  Theme.Scheme.ThirdSet.FontColor  := 0;
end;

procedure SetThemeSkinDefault;
begin
  Theme.Skin.Name := 'Default';
  setlength(Theme.Skin.SkinColors,0);
  setlength(Theme.Skin.SkinColors,1);
  Theme.Skin.SkinColors[0].Name := 'Background';
  Theme.Skin.SkinColors[0].Tag  := '$FirstBaseColor';
  Theme.Skin.skinColors[0].Color := scsFirstBaseColor;
end;



// ##########################################
//      LOAD THEME PARTS
// ##########################################

procedure LoadIconSet;
var
  XML : TJvSimpleXML;
  n   : integer;
begin
  SetThemeIconSetDefault;
  if not FileExists(Theme.Data.Directory + ICONSET_FILE) then exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(Theme.Data.Directory + ICONSET_FILE);
    Theme.IconSet.Directory := SharpApi.GetSharpeDirectory + ICONS_DIR + '\'
                               + XML.Root.Items.Value('Name',DEFAULT_ICONSET);
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
    XML.LoadFromFile(Theme.IconSet.Directory + '\IconSet.xml');
    Theme.IconSet.Name := XML.Root.Items.Value('Name','Default');
    Theme.IconSet.Author := XML.Root.Items.Value('Author','');
    Theme.IconSet.Website := XML.Root.Items.Value('Website','');
    if XML.Root.Items.ItemNamed['Icons'] <> nil then
       with XML.Root.Items.ItemNamed['Icons'].Items do
       begin
         for n := 0 to Count - 1 do
         begin
           setlength(Theme.IconSet.Icons,length(Theme.IconSet.Icons)+1);
           Theme.IconSet.Icons[High(Theme.IconSet.Icons)].Tag := Item[n].Items.Value('Name','');
           Theme.IconSet.Icons[High(Theme.IconSet.Icons)].FileName := Item[n].Items.Value('File','');
         end;
       end;
  finally
    XML.Free;
  end;
end;


procedure LoadThemeSkin;
var
  XML : TJvSimpleXML;
  n   : integer;
begin
  SetThemeSkinDefault;
  if not FileExists(Theme.Data.Directory + SKIN_FILE) then exit;

  setlength(Theme.Skin.SkinColors,0);
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(Theme.Data.Directory + SKIN_FILE);
    with XML.Root.Items do
    begin
      Theme.Skin.Name := Value('Name');
      if ItemNamed['SkinColors'] <> nil then
         for n := 0 to ItemNamed['SkinColors'].Items.Count - 1 do
             with ItemNamed['SkinColors'].Items.Item[n].Items do
             begin
               setlength(Theme.Skin.SkinColors,length(Theme.Skin.SkinColors)+1);
               Theme.Skin.SkinColors[High(Theme.Skin.SkinColors)].Name := Value('Name','Background');
               Theme.Skin.SkinColors[High(Theme.Skin.SkinColors)].Tag  := Value('Tag','$FirstBaseColor');
               Theme.Skin.SkinColors[High(Theme.Skin.SkinColors)].Color := IntValue('Color',scsFirstBaseColor);
             end;
    end;
  finally
    XML.Free;
  end;
end;

procedure LoadThemeScheme;
var
  XML : TJvSimpleXML;
begin
  if not FileExists(Theme.Data.Directory + SCHEME_FILE) then SetThemeSchemeDefault;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(Theme.Data.Directory + SCHEME_FILE);
    with XML.Root.Items do
    begin
      Theme.Scheme.Name := Value('Name','Default');
      if ItemNamed['BaseColors'] <> nil then
         with ItemNamed['BaseColors'].Items do
         begin
           Theme.Scheme.FirstSet.BaseColor  := IntValue('1',0);
           Theme.Scheme.SecondSet.BaseColor := IntValue('2',0);
           Theme.Scheme.ThirdSet.BaseColor  := IntValue('3',0);
         end;
      if ItemNamed['LightColors'] <> nil then
         with ItemNamed['LightColors'].Items do
         begin
           Theme.Scheme.FirstSet.LightColor  := IntValue('1',0);
           Theme.Scheme.SecondSet.LightColor := IntValue('2',0);
           Theme.Scheme.ThirdSet.LightColor  := IntValue('3',0);
         end;
      if ItemNamed['DarkColors'] <> nil then
         with ItemNamed['DarkColors'].Items do
         begin
           Theme.Scheme.FirstSet.DarkColor  := IntValue('1',0);
           Theme.Scheme.SecondSet.DarkColor := IntValue('2',0);
           Theme.Scheme.ThirdSet.DarkColor  := IntValue('3',0);
         end;
      if ItemNamed['FontColors'] <> nil then
         with ItemNamed['FontColors'].Items do
         begin
           Theme.Scheme.FirstSet.FontColor  := IntValue('1',0);
           Theme.Scheme.SecondSet.FontColor := IntValue('2',0);
           Theme.Scheme.ThirdSet.FontColor  := IntValue('3',0);
         end;
    end;
  finally
    XML.Free;
  end;
end;

procedure LoadThemeInfo;
var
  XML : TJvSimpleXML;
begin
  SetThemeInfoDefault;
  if not FileExists(Theme.Data.Directory + THEME_INFO_FILE) then exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(Theme.Data.Directory + THEME_INFO_FILE);
    with XML.Root.Items do
    begin
      Theme.Info.Name    := Value('Name','Default');
      Theme.Info.Author  := Value('Author','');
      Theme.Info.Comment := Value('Comment','Default SharpE Theme');
      Theme.Info.Website := Value('Website','');
    end;
  finally
    XML.Free;
  end;
end;



// ##########################################
//      EXPORT: THEME INFO
// ##########################################
function GetThemeName : PChar;
begin
  result := PChar(Theme.Info.Name);
end;

function GetThemeAuthor : PChar;
begin
  result := PChar(Theme.Info.Author);
end;

function GetThemeComment : PChar;
begin
  result := PChar(Theme.Info.Comment);
end;

function GetThemeWebsite : PChar;
begin
  result := PChar(Theme.Info.Website);
end;



// ##########################################
//      EXPORT: THEME DATA
// ##########################################

// Get Directory of the Current Theme
function GetCurrentThemeDirectory : PChar;
begin
  result := PChar(Theme.Data.Directory);
end;

// Get Directory for Theme with Name = pName
function GetThemeDirectory(pName : PChar) : PChar;
var
  ThemeDir : String;
begin
  ThemeDir := SharpApi.GetSharpeUserSettingsPath + THEME_DIR + '\';

  if not DirectoryExists(ThemeDir + pName) then
     rtemp := ThemeDir + DEFAULT_THEME + '\'
     else rtemp := ThemeDir + pName + '\';

  result := PChar(rtemp);
end;



// ##########################################
//      EXPORT: THEME SKIN
// ##########################################

function GetSkinName : PChar;
begin
  result := PChar(Theme.Skin.Name);
end;

function GetSkinColorCount : integer;
begin
  result := length(Theme.Skin.SkinColors);
end;

function GetSkinColor(pIndex : integer) : TSharpESkinColor;
begin
  if pIndex > GetSkinColorCount - 1 then
  begin
    result.Name  := 'Background';
    result.Tag   := '$FirstBaseColor';
    result.Color := scsFirstBaseColor;
    exit;
  end;

  result.Name  := Theme.Skin.SkinColors[pIndex].Name;
  result.Tag   := Theme.Skin.SkinColors[pIndex].Tag;
  result.Color := Theme.Skin.SkinColors[pIndex].Color;
end;


// ##########################################
//      EXPORT: THEME SCHEME
// ##########################################

function GetSchemeColorSet(pSet : integer) : TSharpEColorSet;
begin
  case pSet of
    1: result := Theme.Scheme.SecondSet;
    2: result := Theme.Scheme.ThirdSet;
    else result := Theme.Scheme.FirstSet;
  end;
end;

function GetSchemeName : PChar;
begin
  result := PChar(Theme.Scheme.Name);
end;



// ##########################################
//      EXPORT: THEME ICON SET
// ##########################################

function GetIconSetName : PChar;
begin
  result := PChar(Theme.IconSet.Name);
end;

function GetIconSetAuthor : PChar;
begin
  result := PChar(Theme.IconSet.Author);
end;

function GetIconSetWebsite : PChar;
begin
  result := PChar(Theme.IconSet.Website);
end;

function GetIconSetDirectory : PChar;
begin
  result := PChar(Theme.IconSet.Directory);
end;

function GetIconSetIconsCount : integer;
begin
  result := length(Theme.IconSet.Icons);
end;

function GetIconSetIconByIndex(pIndex : integer) : TSharpEIcon;
begin
  if pIndex > GetIconSetIconsCount - 1 then
  begin
    result.FileName := '';
    result.Tag      := '';
    exit;
  end;

  result.FileName := Theme.IconSet.Icons[pIndex].FileName;
  result.Tag      := Theme.IconSet.Icons[pIndex].Tag;
end;

function GetIconSetIconByTag(pTag : PChar) : TSharpEIcon;
var
  n : integer;
begin
  for n := 0 to GetIconSetIconsCount do
      if Theme.IconSet.Icons[n].Tag = pTag then
      begin
        result.FileName := Theme.IconSet.Icons[n].FileName;
        result.Tag      := Theme.IconSet.Icons[n].Tag;
        exit;
      end;

  result.FileName := '';
  result.Tag      := '';
end;

function IsIconInIconSet(pTag : PChar) : boolean;
var
  n : integer;
begin
  result := False;
  for n := 0 to GetIconSetIconsCount do
      if Theme.IconSet.Icons[n].Tag = pTag then
      begin
        result := True;
        exit;
      end;
end;

function ValidateIcon(pFileName : PChar) : PChar;
var
  sfile : String;
  sExt  : String;
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
     and (GetIconSetIconsCount > 0)) then sfile := Theme.IconSet.Icons[0].FileName;

  rtemp := sfile;
  result := PChar(rtemp);
end;


// ##########################################
//      EXPORT: THEME DLL CONTROLS
// ##########################################

procedure InitializeTheme;
begin
  Theme.Data.Directory := SharpApi.GetSharpeUserSettingsPath + THEME_DIR + '\' + DEFAULT_THEME + '\';
  Theme.Data.LastUpdate := DateTimeToUnix(Now());

  SetThemeInfoDefault;
  SetThemeSchemeDefault;
  SetThemeSkinDefault;
  SetThemeIconSetDefault;
end;

function LoadTheme(pName : PChar) : boolean;
var
  ThemeDir : String;
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
  LoadThemeScheme;
  LoadThemeSkin;
  LoadIconSet;

  result := True;
end;

function LoadCurrentTheme : boolean;
var
  themename : String;
begin
  themename := GetCurrentThemeName;
  result := LoadTheme(PChar(themename));
end;


{$R *.res}


exports
  // Main Functions
  InitializeTheme,
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
  GetSchemeColorSet,
  GetSchemeName,
  SchemeCodeToColor,
  ColorToSchemeCode,

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
