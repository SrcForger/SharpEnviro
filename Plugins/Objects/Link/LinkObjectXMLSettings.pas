{
Source Name: LinkObjectXMLSettings.pas
Description: Link Object Settings class
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

unit LinkObjectXMLSettings;

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
      IconType         : integer;
      UseIconShadow    : boolean;
      Size             : string;
      IconFile         : string;
      Caption          : string;
      Target           : string;
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
      IconSpacingValue : integer;
      IconSpacing      : boolean;
      IconOffsetValue  : integer;
      IconOffset       : boolean;
      CaptionAlign     : integer;
      MLineCaption     : boolean;
      CustomFont       : boolean;
      FontName         : String;
      FontSize         : integer;
      FontColor        : integer;
      FontBold         : boolean;
      FontItalic       : boolean;
      FontUnderline    : boolean;
      FontShadow       : boolean;
      FontShadowValue  : integer;
      FontShadowColor  : integer;
      FontAlpha        : boolean;
      FontAlphaValue   : integer;
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
  FXML.Root.Name := 'LinkObjectSettings';
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
  Dir := UserDir + 'SharpDesk\Objects\Link\';
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
    UseIconShadow    := BoolValue('UseIconShadow',True);
    Size             := Value('Size','48');
    IconFile         := Value('IconFile','-2');
    Caption          := Value('Caption','');
    Target           := Value('Target','SharpDesk.exe');    
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
    IconSpacingValue := IntValue('IconSpacingValue',0);
    IconSpacing      := BoolValue('IconSpacing',False);
    IconOffsetValue  := IntValue('IconOffsetValue',0);
    IconOffset       := BoolValue('IconOffset',False);
    BGTHBlend        := BoolValue('BGTHBlend',False);
    BGTHBlendColor   := IntValue('BGTHBlendColor',0);
    CaptionAlign     := IntValue('CaptionAlign',2);
    MLineCaption     := BoolValue('MLineCaption',False);
    CustomFont       := BoolValue('CustomFont',False);
    FontName         := Value('FontName','Verdana');
    FontSize         := IntValue('FontSize',10);
    FontColor        := IntValue('FontColor',0);
    FontBold         := BoolValue('FontBold',False);
    FontItalic       := BoolValue('FontItalic',False);
    FontUnderline    := BoolValue('FontUnderline',False);
    FontShadow       := BoolValue('FontShadow',False);
    FontShadowValue  := IntValue('FontShadowValue',0);
    FontShadowColor  := IntValue('FontShadowColor',0);
    FontAlpha        := BoolValue('FontAlpha',False);
    FontAlphaValue   := IntValue('FontAlphaValue',255);
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

  SaveSetting(FXMLRoot,'AlphaValue',AlphaValue,True);
  SaveSetting(FXMLRoot,'AlphaBlend',AlphaBlend,True);
  SaveSetting(FXMLRoot,'BlendValue',BlendValue,True);
  SaveSetting(FXMLRoot,'ColorBlend',ColorBlend,True);
  SaveSetting(FXMLRoot,'UseIconShadow',UseIconShadow,False);
  SaveSetting(FXMLRoot,'Size',Size,True);
  SaveSetting(FXMLRoot,'Target',Target,False);
  SaveSetting(FXMLRoot,'IconFile',IconFile,False);

  FXMLRoot.Items.Add('Caption',Caption);
  with FXMLRoot.Items.ItemNamed['Caption'].Properties do
  begin
    Add('CopyValue',False);
    Add('SortValue',True);
  end;

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
  SaveSetting(FXMLRoot,'IconSpacingValue',IconSpacingValue,True);
  SaveSetting(FXMLRoot,'IconSpacing',IconSpacing,True);
  SaveSetting(FXMLRoot,'IconOffsetValue',IconOffsetValue,True);
  SaveSetting(FXMLRoot,'IconOffset',IconOffset,True);
  SaveSetting(FXMLRoot,'BGTHBlend',BGTHBlend,True);
  SaveSetting(FXMLRoot,'BGTHBlendColor',BGTHBlendColor,True);
  SaveSetting(FXMLRoot,'CaptionAlign',CaptionAlign,False);
  SaveSetting(FXMLRoot,'MLineCaption',MLineCaption,False);
  SaveSetting(FXMLRoot,'CustomFont',CustomFont,True);
  SaveSetting(FXMLRoot,'FontName',FontName,True);
  SaveSetting(FXMLRoot,'FontSize',FontSize,True);
  SaveSetting(FXMLRoot,'FontColor',FontColor,True);
  SaveSetting(FXMLRoot,'FontBold',FontBold,True);
  SaveSetting(FXMLRoot,'FontItalic',FontItalic,True);
  SaveSetting(FXMLRoot,'FontUnderline',FontUnderline,True);
  SaveSetting(FXMLRoot,'FontShadow',FontShadow,True);
  SaveSetting(FXMLRoot,'FontShadowValue',FontShadowValue,True);
  SaveSetting(FXMLRoot,'FontShadowColor',FontShadowColor,True);
  SaveSetting(FXMLRoot,'FontAlpha',FontAlpha,True);
  SaveSetting(FXMLRoot,'FontAlphaValue',FontAlphaValue,True);

  if SaveToFile then
  begin
    SettingsFile := GetSettingsFile;
    SettingsDir  := ExtractFileDir(SettingsFile);
    ForceDirectories(SettingsDir);
    try
      FXML.SaveToFile(SettingsDir+'~temp.xml');
    except
      SharpApi.SendDebugMessageEx('Link.object',PChar('Failed to save Settings to: '+SettingsDir+'~temp.xml'),0,DMT_ERROR);
      DeleteFile(SettingsDir+'~temp.xml');
      exit;
    end;
    if FileExists(SettingsFile) then
       DeleteFile(SettingsFile);
    if not RenameFile(SettingsDir+'~temp.xml',SettingsFile) then
       SharpApi.SendDebugMessageEx('Link.object','Failed to Rename Settings File',0,DMT_ERROR);
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
