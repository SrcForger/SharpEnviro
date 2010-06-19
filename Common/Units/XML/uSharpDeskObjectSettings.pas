{
Source Name: uSharpDeskObjectSettings.pas
Description: base class for desktop object settings
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

unit uSharpDeskObjectSettings;

interface

uses Windows,
     JclSimpleXML,
     SharpApi,
     SysUtils,
     SharpThemeApiEx,
     uSharpXMLUtils,
     uISharpETheme,
     uThemeConsts;

const                                                                 
  DS_ICONSIZE = 0;
  DS_ICONALPHABLEND = 1;
  DS_ICONALPHA = 2;
  DS_ICONBLENDING = 3;
  DS_ICONBLENDCOLOR = 4;
  DS_ICONBLENDALPHA = 5;
  DS_ICONSHADOW = 6;
  DS_ICONSHADOWCOLOR = 7;
  DS_ICONSHADOWALPHA = 8;
  DS_FONTNAME = 9;
  DS_DISPLAYTEXT = 10;
  DS_TEXTSIZE = 11;
  DS_TEXTBOLD = 12;
  DS_TEXTITALIC = 13;
  DS_TEXTUNDERLINE = 14;
  DS_TEXTCOLOR = 15;
  DS_TEXTALPHA = 16;
  DS_TEXTALPHAVALUE = 17;
  DS_TEXTSHADOW = 18;
  DS_TEXTSHADOWALPHA = 19;
  DS_TEXTSHADOWCOLOR = 20;
  DS_TEXTSHADOWTYPE = 21;
  DS_TEXTSHADOWSIZE = 22;

  DST_INT = 0;
  DST_STRING = 1;
  DST_BOOL = 2;

type
    TDesktopThemeSetting = record
                             Name : String;
                             ItemType : byte;
                             Value : String;
                             IntValue : integer;
                             BoolValue : boolean;
                             isCustom  : boolean;
                           end;
    TThemeSettingsArray = array of TDesktopThemeSetting;

    TDesktopXMLSettings = class
    private
      procedure AddArrayItem(Index : integer; Name : String; ItemType : byte; isCustom : boolean);
    protected
      FXML : TJclSimpleXML;
      FXMLRoot : TJclSimpleXMLElem;
      FObjectName : String;
      FObjectID : Integer;
      ts : TThemeSettingsArray;
    public
      constructor Create(pObjectID : integer; pXMLRoot: TJclSimpleXMLElem; pObjectName : String); reintroduce;
      destructor Destroy; override;
      procedure InitLoadSettings;
      procedure LoadSettings; virtual;
      procedure InitSaveSettings;
      procedure SaveSettings; virtual;
      procedure FinishSaveSettings(SaveToFile : boolean);
      function GetSettingsFile : String;

      property XML : TJclSimpleXML read FXML;
    end;


implementation

procedure TDesktopXMLSettings.AddArrayItem(Index : integer; Name : String; ItemType : byte; isCustom : boolean);
begin
  ts[Index].Name := Name;
  ts[Index].IsCustom := isCustom;
  ts[Index].ItemType := ItemType;
end;

constructor TDesktopXMLSettings.Create(pObjectID : integer; pXMLRoot: TJclSimpleXMLElem; pObjectName : String);
begin
  Inherited Create;
  FObjectID := pObjectID;
  FXMLRoot := pXMLRoot;
  FXML := TJclSimpleXML.Create;
  FObjectName := pObjectName;
  FXML.Root.Name := pObjectName + 'ObjectSettings';
  if FXMLRoot = nil then
     FXMLRoot := FXML.Root;

  setlength(ts,23);
  AddArrayItem(DS_ICONSIZE,'IconSize',DST_INT,False);
  AddArrayItem(DS_ICONALPHABLEND,'IconAlhpaBlend',DST_BOOL,False);
  AddArrayItem(DS_ICONALPHA,'IconAlpha',DST_INT,False);
  AddArrayItem(DS_ICONBLENDING,'IconBlending',DST_BOOL,False);
  AddArrayItem(DS_ICONBLENDCOLOR,'IconBlendColor',DST_INT,False);
  AddArrayItem(DS_ICONBLENDALPHA,'IconBlendAlpha',DST_INT,False);
  AddArrayItem(DS_ICONSHADOW,'IconShadow',DST_BOOL,False);
  AddArrayItem(DS_ICONSHADOWCOLOR,'IconShadowColor',DST_INT,False);
  AddArrayItem(DS_ICONSHADOWALPHA,'IconShadowAlpha',DST_INT,False);
  AddArrayItem(DS_FONTNAME,'FontName',DST_STRING,False);
  AddArrayItem(DS_DISPLAYTEXT,'DisplayText',DST_BOOL,False);
  AddArrayItem(DS_TEXTSIZE,'TextSize',DST_INT,False);
  AddArrayItem(DS_TEXTITALIC,'TextItalic',DST_BOOL,False);  
  AddArrayItem(DS_TEXTBOLD,'TextBold',DST_BOOL,False);
  AddArrayItem(DS_TEXTUNDERLINE,'TextUnderline',DST_BOOL,False);
  AddArrayItem(DS_TEXTCOLOR,'TextColor',DST_INT,False);
  AddArrayItem(DS_TEXTALPHA,'TextAlpha',DST_BOOL,False);
  AddArrayItem(DS_TEXTALPHAVALUE,'TextAlphaValue',DST_INT,False);
  AddArrayItem(DS_TEXTSHADOW,'TextShadow',DST_BOOL,False);
  AddArrayItem(DS_TEXTSHADOWALPHA,'TextShadowAlpha',DST_INT,False);
  AddArrayItem(DS_TEXTSHADOWCOLOR,'TextShadowColor',DST_INT,False);
  AddArrayItem(DS_TEXTSHADOWTYPE,'TextShadowType',DST_INT,False);
  AddArrayItem(DS_TEXTSHADOWSIZE,'TextShadowSize',DST_INT,False);
end;


destructor TDesktopXMLSettings.Destroy;
begin
  FXML.Free;
  Inherited Destroy;
end;

function TDesktopXMLSettings.GetSettingsFile : string;
var
  UserDir,Dir : String;
begin
  UserDir := SharpApi.GetSharpeUserSettingsPath;
  Dir := UserDir + 'SharpDesk\Objects\'+ FObjectName +'\';
  result := Dir + inttostr(FObjectID) + '.xml';
end;

procedure TDesktopXMLSettings.InitLoadSettings;
var
  SettingsFile : String;
begin
  SettingsFile := GetSettingsFile;

  if (not FileExists(SettingsFile)) and (FObjectID <> -1) then
     SharpApi.SendDebugMessageEx(PChar(FObjectName + ' Object'),'Settings File does not exist',0,DMT_INFO)
  else if FObjectID <> -1 then
  begin
    if not LoadXMLFromSharedFile(FXML,SettingsFile,True) then
      SharpApi.SendDebugMessageEx(PChar(FObjectName + ' Object'),PChar('Failed to load Settings File: ' + Settingsfile),0,DMT_ERROR);
  end;
end;

procedure TDesktopXMLSettings.LoadSettings;
var
  n : integer;
  Theme : ISharpETheme;
begin
  if FXMLRoot = nil then exit;

  // Load Theme Settings
  Theme := GetCurrentTheme;
  with Theme.Desktop.Icon do
  begin
    ts[DS_ICONSIZE].IntValue := IconSize;
    ts[DS_ICONALPHABLEND].BoolValue := IconAlphaBlend;
    ts[DS_ICONALPHA].IntValue := IconAlpha;
    ts[DS_ICONBLENDING].BoolValue := IconBlending;
    ts[DS_ICONBLENDCOLOR].IntValue := IconBlendColor;
    ts[DS_ICONBLENDALPHA].IntValue := IconBlendAlpha;
    ts[DS_ICONSHADOW].BoolValue := IconShadow;
    ts[DS_ICONSHADOWCOLOR].IntValue := IconShadowColor;
    ts[DS_ICONSHADOWALPHA].IntValue := IconShadowAlpha;
    ts[DS_FONTNAME].Value := FontName;
    ts[DS_DISPLAYTEXT].BoolValue := DisplayText;
    ts[DS_TEXTSIZE].IntValue := TextSize;
    ts[DS_TEXTBOLD].BoolValue := TextBold;
    ts[DS_TEXTITALIC].BoolValue := TextItalic;
    ts[DS_TEXTUNDERLINE].BoolValue := TextUnderline;
    ts[DS_TEXTCOLOR].IntValue := TextColor;
    ts[DS_TEXTALPHA].BoolValue :=TextAlpha;
    ts[DS_TEXTALPHAVALUE].IntValue := TextAlphaValue;
    ts[DS_TEXTSHADOW].BoolValue := TextShadow;
    ts[DS_TEXTSHADOWALPHA].IntValue := TextShadowAlpha;
    ts[DS_TEXTSHADOWCOLOR].IntValue := TextShadowColor;
    ts[DS_TEXTSHADOWTYPE].IntValue := TextShadowType;
    ts[DS_TEXTSHADOWSIZE].IntValue := TextShadowSize;
  end;

  // Object Theme Settings
  with FXMLRoot.Items do
    for n := 0 to High(ts) do
    begin
      if ItemNamed[ts[n].Name] <> nil then
      begin
        ts[n].isCustom := True;
        case ts[n].ItemType of
          DST_INT    : ts[n].IntValue := IntValue(ts[n].Name,ts[n].IntValue);
          DST_STRING : ts[n].Value := Value(ts[n].Name,ts[n].Value);
          DST_BOOL   : ts[n].BoolValue := BoolValue(ts[n].Name,ts[n].BoolValue);
        end;
      end else ts[n].isCustom := False;
    end;
end;

procedure TDesktopXMLSettings.InitSaveSettings;
begin
  if FXMLRoot = nil then exit;

  FXML.Options := FXML.Options + [sxoAutoCreate];
  FXMLRoot.Items.Clear;
end;

procedure TDesktopXMLSettings.SaveSettings;
var
  n : integer;
begin
  if FXMLRoot = nil then exit;

  // Object Theme Settings
  with FXMLRoot.Items do
    for n := 0 to High(ts) do
    begin
      if ts[n].isCustom then
      begin
        case ts[n].ItemType of
          DST_INT    : Add(ts[n].Name,ts[n].IntValue);
          DST_STRING : Add(ts[n].Name,ts[n].Value);
          DST_BOOL   : Add(ts[n].Name,ts[n].BoolValue);
        end;
      end
    end;
end;

procedure TDesktopXMLSettings.FinishSaveSettings(SaveToFile : boolean);
var
  SettingsFile,SettingsDir : String;
begin
  if SaveToFile then
  begin
    SettingsFile := GetSettingsFile;
    SettingsDir  := ExtractFileDir(SettingsFile);
    ForceDirectories(SettingsDir);
    try
      FXML.SaveToFile(SettingsDir+'~temp.xml');
    except
      SharpApi.SendDebugMessageEx(PChar(FObjectName + ' Object'),PChar('Failed to save Settings to: '+SettingsDir+'~temp.xml'),0,DMT_ERROR);
      DeleteFile(SettingsDir+'~temp.xml');
      exit;
    end;
    if FileExists(SettingsFile) then
       DeleteFile(SettingsFile);
    if not RenameFile(SettingsDir+'~temp.xml',SettingsFile) then
       SharpApi.SendDebugMessageEx(PChar(FObjectName + ' Object'),'Failed to Rename Settings File',0,DMT_ERROR);
  end;
end;


end.
