{
Source Name: SharpAPI
Description: Header unir for SharpAPI.dll
Copyright (C) Lee Green (Pixol) <pixol@sharpe-shell.org>
              Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpCenterAPI;

interface

uses
  Messages,
  SharpApi,
  Classes,
  SysUtils,
  Graphics,
  JvSimpleXml,
  JclSimpleXml,
  SharpThemeApiEx,
  uThemeConsts,
  uISharpETheme,
  ExtCtrls,
  StdCtrls,
  ComCtrls,
  Forms,
  Windows,

  SharpEListBoxEx;

Type
 TCenterThemeInfo = record

  // Scheme details
  FileName,
  Name,
  Author: String;

	// Global background colour
	Background,
  BackgroundText,
  Border,

	// Navbar colours
  NavBarItem,
  NavBarSelectedItem,
  NavBarItemText,
  NavBarSelectedItemText,

  // Plugin colours
  PluginBackground,
  PluginBackgroundText,
  PluginTab,
  PluginSelectedTab,
  PluginTabText,
  PluginTabSelectedText,
  PluginItem,
  PluginSelectedItem,
  PluginItemText,
  PluginSelectedItemText,
  PluginItemDescriptionText,
  PluginSelectedItemDescriptionText,
  PluginItemButtonText,
  PluginSelectedItemButtonText,
  PluginItemButtonDisabledText,
  PluginSelectedItemButtonDisabledText,
  PluginSectionTitle,
  PluginSectionDescription,
  PluginControlBackground,
  PluginControlText,

	// Edit panel colours
  EditBackground,
  EditBackgroundText,
  EditBackgroundError,
  EditControlBackground,
  EditControlText,

  ContainerColor,
  ContainerTextColor: TColor;

  end;
  TCenterThemeInfoSet = array of TCenterThemeInfo;

function BroadcastCenterMessage(wpar: wparam; lpar: lparam): boolean;
  external 'SharpCenterAPI.dll' name 'BroadcastCenterMessage';

function CenterCommand(ACommand: TSCC_COMMAND_ENUM; AParam, APluginID :PChar): hresult;
  external 'SharpCenterAPI.dll' name 'CenterCommand';

function CenterCommandAsText(ACommand: TSCC_COMMAND_ENUM): string;
  external 'SharpCenterAPI.dll' name 'CenterCommandAsText';

function CenterCommandAsEnum(ACommand: string): TSCC_COMMAND_ENUM;
  external 'SharpCenterAPI.dll' name 'CenterCommandAsEnum';

procedure CenterReadDefaults(var AFields: TSC_DEFAULT_FIELDS);
  external 'SharpCenterAPI.dll' name 'CenterReadDefaults';

procedure CenterWriteDefaults(var AFields: TSC_DEFAULT_FIELDS);
  external 'SharpCenterAPI.dll' name 'CenterWriteDefaults';

procedure XmlGetCenterThemeList(var AThemeList: TCenterThemeInfoSet);
procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string);
function GetCenterThemeListAsCommaText: string;

function XmlGetCenterTheme: string; overload;
procedure XmlGetCenterTheme(AThemeName: string; var ATheme: TCenterThemeInfo); overload;

procedure AssignSystemDefaultTheme( var ATheme: TCenterThemeInfo );
procedure AssignSystemDefaultTheme2( var ATheme: TCenterThemeInfo );

procedure GetThemeValuesFromElems( var ATheme: TCenterThemeInfo ; AElems: TJclSimpleXMLElems ; AFileName: String  );
procedure XmlSetCenterTheme(AThemeName: String);

procedure AssignThemeToListBoxItemText( ATheme: TCenterThemeInfo; AItem: TSharpEListItem;
  var colItemTxt:tcolor; var colDescTxt:tcolor; var colBtnTxt: TColor); overload;
procedure AssignThemeToListBoxItemText( ATheme: TCenterThemeInfo; AItem: TSharpEListItem;
  var colItemTxt:tcolor; var colDescTxt:tcolor; var colBtnTxt: TColor; var colBtnDisabledTxt: TColor); overload;

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

function XmlGetCenterTheme: string;
var
  xml: TJvSimpleXML;
  s: string;
begin
  Result := 'Default';
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + 'SharpCenter\Global.xml';

    if fileExists(s) then begin
      xml.LoadFromFile(s);
      Result := xml.Root.Items.Value('Theme', 'Default');
    end;
  finally
    xml.Free;
  end;
end;

procedure XmlSetCenterTheme(AThemeName: String);
var
  xml: TJvSimpleXML;
  s: string;
begin
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + 'SharpCenter\Global.xml';
    forcedirectories(ExtractFilePath(s));

    xml.Root.Name := 'SharpCenter';

    if xml.Root.Items.ItemNamed['Theme'] <> nil then
      xml.Root.Items.ItemNamed['Theme'].Value := AThemeName else
      xml.Root.Items.Add('Theme', AThemeName);
      
    xml.SaveToFile(s);
  finally
    xml.Free;
  end;
end;

function GetCenterThemeListAsCommaText: string;
var
  themeDir: string;
  tmpStringList: TStringList;
begin
  themeDir := GetSharpeGlobalSettingsPath + 'SharpCenter\Themes\';

  tmpStringList := TStringList.Create;
  try

    FindFiles(tmpStringList, themeDir, '*ctheme.xml');
    tmpStringList.Sort;
    result := tmpStringList.CommaText;

  finally
    tmpStringList.Free;
  end;
end;

procedure GetThemeValuesFromElems( var ATheme: TCenterThemeInfo ; AElems: TJclSimpleXMLElems ; AFileName: String );
var
  Theme : ISharpETheme;
begin
  // Scheme meta data
  ATheme.Filename := AFileName;
  ATheme.Name := AElems.Value('Name', 'Invalid_Name');
  ATheme.Author := AElems.Value('Author', 'Invalid_Author');

  Theme := GetCurrentTheme;
  // Global background colour
	ATheme.Background := Theme.Scheme.ParseColor(AElems.Value('Background', IntToStr(clWindow)));
  ATheme.BackgroundText := Theme.Scheme.ParseColor(AElems.Value('BackgroundText', IntToStr(clWindowText)));
  ATheme.Border := Theme.Scheme.ParseColor(AElems.Value('Border', IntToStr(clWindowText)));

	// Navbar colours
  ATheme.NavBarItem := Theme.Scheme.ParseColor(AElems.Value('NavBarItem', IntToStr(clWindow)));
  ATheme.NavBarSelectedItem := Theme.Scheme.ParseColor(AElems.Value('NavBarSelectedItem', IntToStr(clHighlight)));
  ATheme.NavBarItemText := Theme.Scheme.ParseColor(AElems.Value('NavBarItemText', IntToStr(clWindowText)));
  ATheme.NavBarSelectedItemText := Theme.Scheme.ParseColor(AElems.Value('NavBarSelectedItemText', IntToStr(clHighlightText)));

  // Navbar colours
  ATheme.PluginTab := Theme.Scheme.ParseColor(AElems.Value('PluginTab', IntToStr(clWindow)));
  ATheme.PluginSelectedTab := Theme.Scheme.ParseColor(AElems.Value('pluginSelectedTab', IntToStr(clHighlight)));
  ATheme.PluginTabText := Theme.Scheme.ParseColor(AElems.Value('PluginTabText', IntToStr(clWindowText)));
  ATheme.PluginTabSelectedText := Theme.Scheme.ParseColor(AElems.Value('PluginTabSelectedText', IntToStr(clHighlightText)));
  ATheme.PluginBackground := Theme.Scheme.ParseColor(AElems.Value('PluginBackground', IntToStr(clWindow)));
  ATheme.PluginBackgroundText := Theme.Scheme.ParseColor(AElems.Value('PluginBackgroundText', IntToStr(clHighlight)));
	ATheme.PluginItem := Theme.Scheme.ParseColor(AElems.Value('PluginItem', IntToStr(clWindow)));
  ATheme.PluginSelectedItem := Theme.Scheme.ParseColor(AElems.Value('PluginSelectedItem', IntToStr(clHighlight)));
  ATheme.PluginItemText := Theme.Scheme.ParseColor(AElems.Value('PluginItemText', IntToStr(clWindowText)));

  ATheme.PluginItemDescriptionText := Theme.Scheme.ParseColor(AElems.Value('PluginItemDescriptionText', IntToStr(clWindowText)));
  ATheme.PluginItemButtonText := Theme.Scheme.ParseColor(AElems.Value('PluginItemButtonText', IntToStr(clWindowText)));
  ATheme.PluginItemButtonDisabledText := Theme.Scheme.ParseColor(AElems.Value('PluginItemButtonDisabledText', IntToStr(clWindowText)));


  ATheme.PluginSelectedItemText := Theme.Scheme.ParseColor(AElems.Value('PluginSelectedItemText', IntToStr(clHighlightText)));
  ATheme.PluginSelectedItemDescriptionText := Theme.Scheme.ParseColor(AElems.Value('PluginSelectedItemDescriptionText', IntToStr(clHighlightText)));
  ATheme.PluginSelectedItemButtonText := Theme.Scheme.ParseColor(AElems.Value('PluginSelectedItemButtonText', IntToStr(clHighlightText)));
  ATheme.PluginSelectedItemButtonDisabledText := Theme.Scheme.ParseColor(AElems.Value('PluginSelectedItemButtonDisabledText', IntToStr(clHighlightText)));

  ATheme.PluginSectionTitle := Theme.Scheme.ParseColor(AElems.Value('PluginSectionTitle', IntToStr(clHighlightText)));
  ATheme.PluginSectionDescription := Theme.Scheme.ParseColor(AElems.Value('PluginSectionDescription', IntToStr(clHighlightText)));
  ATheme.PluginControlBackground := Theme.Scheme.ParseColor(AElems.Value('PluginControlBackground', IntToStr(clred)));
  ATheme.PluginControlText := Theme.Scheme.ParseColor(AElems.Value('PluginControlText', IntToStr(clBtnText)));

	// Edit panel colours
  ATheme.EditBackground := Theme.Scheme.ParseColor(AElems.Value('EditBackground', IntToStr(clBtnFace)));
  ATheme.EditBackgroundText := Theme.Scheme.ParseColor(AElems.Value('EditBackgroundText', IntToStr(clred)));
  ATheme.EditBackgroundError := Theme.Scheme.ParseColor(AElems.Value('EditBackgroundError', IntToStr(clBtnText)));
  ATheme.EditControlBackground := Theme.Scheme.ParseColor(AElems.Value('EditControlBackground', IntToStr(clred)));
  ATheme.EditControlText := Theme.Scheme.ParseColor(AElems.Value('EditControlText', IntToStr(clBtnText)));

  // Container
  ATheme.ContainerColor := Theme.Scheme.ParseColor(AElems.Value('ContainerColor', IntToStr(clred)));
  ATheme.ContainerTextColor := Theme.Scheme.ParseColor(AElems.Value('ContainerTextColor', IntToStr(clBtnText)));
end;

procedure XmlGetCenterThemeList(var AThemeList: TCenterThemeInfoSet);
var
  themeDir: string;
  xml: TJvSimpleXml;
  i: Integer;
  itm: TCenterThemeInfo;
  tmpStringList: TStringList;
begin
  themeDir := GetSharpeGlobalSettingsPath + 'SharpCenter\Themes\';
  ForceDirectories(themeDir);

  tmpStringList := TStringList.Create;
  try

    tmpStringList.CommaText := GetCenterThemeListAsCommaText;

    Setlength(AThemeList, 0);
    for i := 0 to Pred(tmpStringList.Count) do begin
      xml := TJvSimpleXML.Create(nil);
      try
        xml.LoadFromFile(tmpStringList[i]);
        GetThemeValuesFromElems(itm,xml.Root.Items,tmpStringList[i]);

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

//procedure AssignSystemDefaultTheme( var ATheme: TCenterThemeInfo );
//begin
//  // Scheme meta data
//  ATheme.Filename := '';
//  ATheme.Name := 'System Default';
//  ATheme.Author := 'SharpE';
//
//  // Global background colour
//	ATheme.Background := clWindow;
//
//	// List colours
//	ATheme.Item := clWindow;
//  ATheme.SelectedItem := clHighlight;
//  ATheme.ItemText := clWindowText;
//  ATheme.ItemDescriptionText := clWindowText;
//  ATheme.SelectedItemText := clHighlightText;
//  ATheme.SelectedItemDescriptionText := clHighlightText;
//
//	// Navbar colours
//  ATheme.NavBarItem := clWindow;
//  ATheme.NavBarSelectedItem := clHighlight;
//  ATheme.NavBarItemText := clWindowText;
//  ATheme.NavBarSelectedItemText := clHighlightText;
//
//	// Edit panel colours
//  ATheme.EditBackground := clBtnFace;
//  ATheme.EditErrorBackground := clred;
//  ATheme.EditText := clBtnText;
//  ATheme.EditSelectedText := clBtnText;
//  ATheme.EditErrorText := clWhite;
//end;

procedure AssignSystemDefaultTheme( var ATheme: TCenterThemeInfo );
begin
  // Scheme meta data
  ATheme.Filename := '';
  ATheme.Name := 'System Default';
  ATheme.Author := 'SharpE';

  // Global background colour
	ATheme.Background := clNavy;
  ATheme.BackgroundText := clWhite;
  ATheme.Border := clWhite;

  // Navbar colours
  ATheme.NavBarItem := ATheme.Background;
  ATheme.NavBarSelectedItem := clwhite;
  ATheme.NavBarItemText := clWhite;
  ATheme.NavBarSelectedItemText := clBlack;

  // Plugin colours
  ATheme.PluginTab := clNavy;
  ATheme.PluginTabText := clWhite;
  ATheme.PluginSelectedTab := clWhite;
  ATheme.PluginTabSelectedText := clBlack;
  ATheme.PluginBackground := clWhite;
  ATheme.PluginBackgroundText := clBlack;

  ATheme.PluginItem := clWhite;
  ATheme.PluginSelectedItem := clNavy;
  ATheme.PluginItemText := clBlack;
  ATheme.PluginItemDescriptionText := clGray;
  ATheme.PluginItemButtonText := clNavy;
  ATheme.PluginSelectedItemDescriptionText := clYellow;
  ATheme.PluginSelectedItemButtonText := clYellow;
  ATheme.PluginSelectedItemButtonDisabledText := clGray;
  ATheme.PluginSelectedItemText := clWhite;
  ATheme.PluginSectionTitle := clNavy;
  ATheme.PluginSectionDescription := clBlue;
  ATheme.PluginControlBackground := clWhite;
  ATheme.PluginControlText := clBlack;

	// Edit panel colours
  ATheme.EditBackground := clwhite;
  ATheme.EditBackgroundText := clBlack;
  ATheme.EditBackgroundError := clRed;
  ATheme.EditControlBackground := clNavy;
  ATheme.EditControlText := clWhite;

  // Container
  ATheme.ContainerColor := clNavy;
  ATheme.ContainerTextColor := clwhite;
end;

procedure AssignSystemDefaultTheme2( var ATheme: TCenterThemeInfo );
const
  cCol1 = $0080E7FD;
  cCol2 = $00FEF7F1;
  cCol3 = $00EAE9FC;
  cCol4 = $00EFEFEF;

  cCol5 = $00999999;

  cBackgroundtext = clBlack;
  
  cLightGray = $00F8F8F8;

  cItem = $0086F5FF;
  cEdit = $00FFFFFF;
  cBackground = $00FFFFFF;
  cBorder = $DDDDDD;
  cTab = $EEEEEE;
  cEditBackground = $00FDE6CD;
  cEditBackgroundText = $0000000;
  cEditBackgroundError = $00A4A4FF;
  cPluginItemSel = $00F0F0F0;
begin
  // Scheme meta data
  ATheme.Filename := '';
  ATheme.Name := 'System Default';
  ATheme.Author := 'SharpE';

  // Global background colour
	ATheme.Background := cBackground;
  ATheme.BackgroundText := cBackgroundtext;
  ATheme.Border := cBorder;

  // Navbar colours
  ATheme.NavBarItem := cBackground;
  ATheme.NavBarSelectedItem := cItem;
  ATheme.NavBarItemText := cBackgroundtext;
  ATheme.NavBarSelectedItemText := cBackgroundtext;

  // Plugin colours
  ATheme.PluginTab := cTab;
  ATheme.PluginTabText := cCol5;
  ATheme.PluginSelectedTab := cEdit;
  ATheme.PluginTabSelectedText := clWindowText;
  ATheme.PluginBackground := cEdit;
  ATheme.PluginBackgroundText := clBlack;

  ATheme.PluginItem := cEdit;
  ATheme.PluginSelectedItem := cEditBackground;
  ATheme.PluginItemText := cEditBackgroundText;
  ATheme.PluginSelectedItemText := cEditBackgroundText;
  ATheme.PluginItemDescriptionText := cEditBackgroundText;
  ATheme.PluginSelectedItemDescriptionText := cEditBackgroundText;
  ATheme.PluginItemButtonText := clBlue;
  ATheme.PluginSelectedItemButtonText := clBlue;
  ATheme.PluginItemButtonDisabledText := clGray;
  ATheme.PluginSelectedItemButtonDisabledText := clGray;
  ATheme.PluginSectionTitle := clBlack;
  ATheme.PluginSectionDescription := clGray;
  ATheme.PluginControlText := clBlack;
  ATheme.PluginControlBackground := $00F3F3F3;

	// Edit panel colours
  ATheme.EditBackground := cEditBackground;
  ATheme.EditBackgroundText := cEditBackgroundText;
  ATheme.EditBackgroundError := cEditBackgroundError;
  ATheme.EditControlText := clBlack;
  ATheme.EditControlBackground := $00FDF7F0;

  // Container
  ATheme.ContainerColor := cEditBackground;
  ATheme.ContainerTextColor := cEditBackgroundText;
end;

procedure AssignThemeToListBoxItemText( ATheme: TCenterThemeInfo; AItem: TSharpEListItem;
  var colItemTxt:tcolor; var colDescTxt:tcolor; var colBtnTxt: TColor );
var
  colBtnDisabledTxt: TColor;
begin
  AssignThemeToListBoxItemText( ATheme, AItem, colItemTxt, colDescTxt, colBtnTxt, colBtnDisabledTxt );
end;

procedure AssignThemeToListBoxItemText( ATheme: TCenterThemeInfo; AItem: TSharpEListItem;
  var colItemTxt:tcolor; var colDescTxt:tcolor; var colBtnTxt: TColor; var colBtnDisabledTxt: TColor);
begin
  if AItem.Selected then
  begin
    colItemTxt := ATheme.PluginSelectedItemText;
    colDescTxt := ATheme.PluginSelectedItemDescriptionText;
    colBtnTxt := ATheme.PluginSelectedItemButtonText;
    colBtnDisabledTxt := ATheme.PluginSelectedItemButtonDisabledText;
  end
  else
  begin
    colItemTxt := ATheme.PluginItemText;
    colDescTxt := ATheme.PluginItemDescriptionText;
    colBtnTxt := ATheme.PluginItemButtonText;
    colBtnDisabledTxt := ATheme.PluginItemButtonDisabledText;
  end;
end;

procedure XmlGetCenterTheme(AThemeName: string; var ATheme: TCenterThemeInfo); overload;
var
  xml: TJvSimpleXML;

  theme, themeDir, themeFile: string;
begin
  theme := AThemeName;
  themeDir := GetSharpeGlobalSettingsPath + 'SharpCenter\Themes\';
  themeFile := themeDir+ theme + '\' + 'ctheme.xml';

  if ( (theme = '') or ( not(FileExists(themeFile))))  then begin
    //SharpApi.SendDebugMessageEx('SharpCenterApi', 'Some parameters were invalid for XmlGetCenterTheme', 0, DMT_ERROR);
    AssignSystemDefaultTheme2( ATheme );
    Exit;
  end;

  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(themeFile);
    GetThemeValuesFromElems(ATheme,xml.Root.Items,themeFile);

  finally
    xml.Free;
  end;
end;

end.




