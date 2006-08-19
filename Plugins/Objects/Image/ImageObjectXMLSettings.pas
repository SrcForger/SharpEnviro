{
Source Name: ImageObjectXMlSettings.pas
Description: Image Object Settings class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
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

unit ImageObjectXMLSettings;

interface

uses JvSimpleXML,
     SysUtils,
     SharpApi,
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
      UseThemeSettings : boolean;
      IconFile         : String;
      ColorBlend       : boolean;
      BlendColor       : integer;
      BlendValue       : integer;
      Size             : integer;
      AlphaValue       : integer;
      AlphaBlend       : boolean;
      ftURL            : boolean;
      URLRefresh       : integer;
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
  FXML.Root.Name := 'ImageObjectSettings';
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
  Dir := UserDir + 'SharpDesk\Objects\Image\';
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
    SharpApi.SendDebugMessageEx('Image.object','Settings File does not exist',0,DMT_INFO);
  end;

  try
    if FObjectID <> -1 then
       FXML.LoadFromFile(SettingsFile);
  except
    SharpApi.SendDebugMessageEx('Image.object',PChar('Failed to load Settings File: '+Settingsfile),0,DMT_ERROR);
  end;

  csX := SharpApi.LoadColorSchemeEx;

  with FXMLRoot.Items do
  begin
    AlphaBlend       := BoolValue('AlphaBlend',False);
    ColorBlend       := BoolValue('ColorBlend',False);
    UseThemeSettings := BoolValue('UseThemeSettings',True);
    ftURL            := BoolValue('ftURL',False);
    IconFile         := Value('IconFile','');
    BlendColor       := CodeToColorEx(IntValue('BlendColor',-1),csX);
    BlendValue       := IntValue('BlendValue',0);
    Size             := IntValue('Size',100);
    AlphaValue       := IntValue('AlphaValue',255);
    URLRefresh       := IntValue('URLRefresh',30);
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

  SaveSetting(FXMLRoot,'ColorBlend',ColorBlend,True);
  SaveSetting(FXMLRoot,'AlphaBlend',AlphaBlend,True);
  SaveSetting(FXMLRoot,'UseThemeSettings',UseThemeSettings,True);
  SaveSetting(FXMLRoot,'IconFile',IconFile,False);
  SaveSetting(FXMLRoot,'BlendValue',BlendValue,True);
  SaveSetting(FXMLRoot,'Size',Size,True);
  SaveSetting(FXMLRoot,'AlphaValue',AlphaValue,True);
  SaveSetting(FXMLRoot,'ftURL',ftURL,False);
  SaveSetting(FXMLRoot,'URLRefresh',URLRefresh,False);
  SaveSetting(FXMLRoot,'BlendColor',ColorToCodeEx(BlendColor,csX),True);

  if SaveToFile then
  begin
    SettingsFile := GetSettingsFile;
    SettingsDir  := ExtractFileDir(SettingsFile);
    ForceDirectories(SettingsDir);
    try
      FXML.SaveToFile(SettingsDir+'~temp.xml');
    except
      SharpApi.SendDebugMessageEx('Image.object',PChar('Failed to save Settings to: '+SettingsDir+'~temp.xml'),0,DMT_ERROR);
      DeleteFile(SettingsDir+'~temp.xml');
      exit;
    end;
    if FileExists(SettingsFile) then
       DeleteFile(SettingsFile);
    if not RenameFile(SettingsDir+'~temp.xml',SettingsFile) then
       SharpApi.SendDebugMessageEx('Image.object','Failed to Rename Settings File',0,DMT_ERROR);
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
