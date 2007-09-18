{
Source Name: TextLayer XML settings
Description: Text desktop object settings class
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

unit TextObjectXMLSettings;

interface

uses JvSimpleXML,
     SharpApi,
     SysUtils,
     uSharpDeskTDeskSettings,
     uSharpDeskTThemeSettings,
     uSharpDeskTObjectSettings,
     uSharpDeskFunctions;

type
    TXMLSettings = class
    private
      FXML : TJvSimpleXML;
      FXMLRoot : TJvSimpleXMLElem;
      FObjectID : integer;
      procedure SaveSetting(pXMLElems : TJvSimpleXMLElem; pName,pValue : String; copy : boolean); overload;
      procedure SaveSetting(pXMLElems : TJvSimpleXMLElem; pName : String; pValue : Integer; copy : boolean); overload;
      procedure SaveSetting(pXMLElems : TJvSimpleXMLElem; pName : String; pValue : Boolean; copy : boolean); overload;
    public
      {Settings Block}
      AlphaValue       : integer;
      AlphaBlend       : boolean;
      BlendColor       : integer;
      BlendValue       : integer;
      Text             : string;
      BGSkin           : string;
      Shadow           : boolean;
      ColorBlend       : boolean;
      ShowCaption      : boolean;
      UseThemeSettings : boolean;
      BGThickness      : boolean;
      BGTrans          : boolean;
      BGTransValue     : integer;
      BGType           : integer;
      BGColor          : integer;
      BGBorderColor    : integer;
      BGThicknessValue : integer;
      BGTHBlend        : boolean;
      BGTHBlendColor   : integer;        
      {End Settings Block}
      constructor Create(pObjectID : integer; pXMLRoot: TJvSimpleXMLElem); reintroduce;
      destructor Destroy;
      procedure LoadSettings;
      procedure SaveSettings(SaveToFile : boolean);
      function GetSettingsFile : String;
    published
      property XML : TJvSimpleXML read FXML;
    end;


implementation

constructor TXMLSettings.Create(pObjectID : integer; pXMLRoot: TJvSimpleXMLElem);
begin
  Inherited Create;
  FObjectID := pObjectID;
  FXMLRoot := pXMLRoot;
  FXML := TJvSimpleXML.Create(nil);
  FXML.Root.Name := 'TextObjectSettings';
  if FXMLRoot = nil then
     FXMLRoot := FXML.Root;
end;


destructor TXMLSettings.Destroy;
begin
  FXML.Free;
  FXML := nil;
  Inherited Destroy;
end;


function TXMLSettings.GetSettingsFile : string;
var
  UserDir,Dir : String;
begin
  UserDir := SharpApi.GetSharpeUserSettingsPath;
  Dir := UserDir + 'SharpDesk\Objects\Text\';
  result := Dir + inttostr(FObjectID) + '.xml';
end;

procedure TXMLSettings.LoadSettings;
var
  n : integer;
  SettingsFile : String;
  csX : TColorSchemeEX;
begin
  if FXML = nil then exit;
  SettingsFile := GetSettingsFile;
  if (not FileExists(SettingsFile)) and (FObjectID <> -1) then
  begin
    SharpApi.SendDebugMessageEx('Link.object','Settings File does not exist',0,DMT_INFO);
  end;

  try
    if FObjectID <> -1 then
       FXML.LoadFromFile(SettingsFile);
  except
    SharpApi.SendDebugMessageEx('Link.object',PChar('Failed to load Settings File: '+Settingsfile),0,DMT_ERROR);
  end;

  csX := SharpApi.LoadColorSchemeEx;

  with FXMLRoot.Items do
  begin
    AlphaValue       := IntValue('AlphaValue',255);
    AlphaBlend       := BoolValue('AlphaBlend',False);
    BlendValue       := IntValue('BlendValue',0);
    ColorBlend       := BoolValue('ColorBlend',False);
    Text             := Value('Text','Text.object');
    Text := StringReplace(Text,'#;01;#','<',[rfReplaceAll, rfIgnoreCase]);
    Text := StringReplace(Text,'#;02;#','>',[rfReplaceAll, rfIgnoreCase]);
    if length(Text) = 0 then Text := 'Text.Object';
    Shadow           := BoolValue('Shadow',False);
    ShowCaption      := BoolValue('ShowCaption',True);
    UseThemeSettings := BoolValue('UseThemeSettings',True);
    BGSkin           := Value('BGSkin','');    
    BGType           := IntValue('BGType',0);    
    BGColor          := CodeToColorEx(IntValue('BGColor',-6),csX);
    BGBorderColor    := CodeToColorEx(IntValue('BGBorderColor',-5),csX);
    BlendColor       := CodeToColorEx(IntValue('BlendColor',-1),csX);
    BGTrans          := BoolValue('BGTrans',False);
    BGTransValue     := IntValue('BGTransValue',0);
    BGThickness      := BoolValue('BGThickness',True);    
    BGThicknessValue := IntValue('BGThicknessValue',1);
    BGTHBlend        := BoolValue('BGTHBlend',False);
    BGTHBlendColor   := IntValue('BGTHBlendColor',0);       
  end;
end;

procedure TXMLSettings.SaveSettings(SaveToFile : boolean);
var
  csX : TColorSchemeEx;
  SettingsFile,SettingsDir : String;
begin
  if FXML = nil then exit;

  FXML.Options := FXML.Options + [sxoAutoCreate];
  FXMLRoot.Clear;

  csX := SharpApi.LoadColorSchemeEx;

  Text := StringReplace(Text,'<','#;01;#',[rfReplaceAll, rfIgnoreCase]);
  Text := StringReplace(Text,'>','#;02;#',[rfReplaceAll, rfIgnoreCase]);  
  SaveSetting(FXMLRoot,'AlphaValue',AlphaValue,True);
  SaveSetting(FXMLRoot,'AlphaBlend',AlphaBlend,True);
  SaveSetting(FXMLRoot,'BlendValue',BlendValue,True);
  SaveSetting(FXMLRoot,'ColorBlend',ColorBlend,True);
  SaveSetting(FXMLRoot,'Text',Text,False);
  SaveSetting(FXMLRoot,'Shadow',Shadow,True);
  SaveSetting(FXMLRoot,'ShowCaption',ShowCaption,True);
  SaveSetting(FXMLRoot,'UseThemeSettings',UseThemeSettings,True);
  SaveSetting(FXMLRoot,'BGColor',ColorToCodeEx(BGColor,csX),True);
  SaveSetting(FXMLRoot,'BGBorderColor',ColorToCodeEx(BGBorderColor,csX),True);
  SaveSetting(FXMLRoot,'BGType',BGType,True);
  SaveSetting(FXMLRoot,'BGSkin',BGSkin,True);
  SaveSetting(FXMLRoot,'BlendColor',ColorToCodeEx(BlendColor,csX),True);
  SaveSetting(FXMLRoot,'BGTrans',BGTrans,True);
  SaveSetting(FXMLRoot,'BGTransValue',BGTransValue,True);
  SaveSetting(FXMLRoot,'BGThickness',BGThickness,True);
  SaveSetting(FXMLRoot,'BGThicknessValue',BGThicknessValue,True);
  SaveSetting(FXMLRoot,'BGTHBlend',BGTHBlend,True);
  SaveSetting(FXMLRoot,'BGTHBlendColor',BGTHBlendColor,True);

  if SaveToFile then
  begin
    SettingsFile := GetSettingsFile;
    SettingsDir  := ExtractFileDir(SettingsFile);
    ForceDirectories(SettingsDir);
    try
      FXML.SaveToFile(SettingsDir+'~temp.xml');
    except
      SharpApi.SendDebugMessageEx('Text.object',PChar('Failed to save Settings to: '+SettingsDir+'~temp.xml'),0,DMT_ERROR);
      DeleteFile(SettingsDir+'~temp.xml');
      exit;
    end;
    if FileExists(SettingsFile) then
       DeleteFile(SettingsFile);
    if not RenameFile(SettingsDir+'~temp.xml',SettingsFile) then
       SharpApi.SendDebugMessageEx('Text.object','Failed to Rename Settings File',0,DMT_ERROR);
  end;
end;

procedure TXMLSettings.SaveSetting(pXMLElems : TJvSimpleXMLElem; pName,pValue : String; copy : boolean);
begin
  pXMLElems.Items.Add(pName,pValue).Properties.Add('CopyValue',copy);
end;

procedure TXMLSettings.SaveSetting(pXMLElems : TJvSimpleXMLElem; pName : String; pValue : Integer; copy : boolean);
begin
  pXMLElems.Items.Add(pName,pValue).Properties.Add('CopyValue',copy);
end;

procedure TXMLSettings.SaveSetting(pXMLElems : TJvSimpleXMLElem; pName : String; pValue : Boolean; copy : boolean);
begin
  pXMLElems.Items.Add(pName,pValue).Properties.Add('CopyValue',copy);
end;


end.
