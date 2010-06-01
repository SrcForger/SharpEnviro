{
Source Name: uTThemeSkin.pas
Description: TThemeSkin class implementing IThemeSkin Interface
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

unit uThemeSkin;

interface

uses
  SharpApi, uThemeInfo, uIThemeSkin, uIThemeScheme, uThemeConsts;

type
  TThemeSkin = class(TInterfacedObject, IThemeSkin)
  private
    FThemeInfo        : TThemeInfo;
    FName             : String;
    FDirectory        : String;
    FSchemesDirectory : String;
    FGlassEffect      : TThemeSkinGlassEffect;
    FSkinFont         : TThemeSkinFont;
    procedure SetDefaults;
    procedure UpdateDirectory;
    procedure LoadFromFileSkinAndGlass;
  public
    LastUpdate : Int64;
    constructor Create(pThemeInfo : TThemeInfo); reintroduce;
    destructor Destroy; override;
    procedure ParseColors(pScheme : IThemeScheme);
    procedure LoadFromFileFont;

    // IThemeSkin Interface
    function GetName : String; stdcall;
    procedure SetName(Value : String); stdcall;
    property Name : String read GetName write SetName;

    function GetDirectory : String; stdcall;
    property Directory : String read GetDirectory;

    function GetSchemesDirectory : String; stdcall;
    property SchemesDirectory : string read GetSchemesDirectory;

    function GetGlassEffect: TThemeSkinGlassEffect; stdcall;
    procedure SetGlassEffect(Value: TThemeSkinGlassEffect); stdcall;
    property GlassEffect : TThemeSkinGlassEffect read GetGlassEffect write SetGlassEffect;

    function GetSkinFont: TThemeSkinFont; stdcall;
    procedure SetSkinFont(Value : TThemeSkinFont); stdcall;
    property SkinFont : TThemeSkinFont read GetSkinFont write SetSkinFont;    

    procedure SaveToFile; stdcall;
    procedure SaveToFileSkinAndGlass; stdcall;
    procedure SaveToFileFont; stdcall;
    procedure LoadFromFile; stdcall;    
  end;

implementation

uses
  SysUtils, DateUtils, JclSimpleXML,
  uThemeScheme, IXmlBaseUnit;

{ TThemeSkin }

constructor TThemeSkin.Create(pThemeInfo : TThemeInfo);
begin
  inherited Create;
  SharpApi.SendDebugMessage('ThemeAPI','TThemeSkin.Create', 0);

  FThemeInfo := pThemeInfo;

  LoadFromFile;
end;

destructor TThemeSkin.Destroy;
begin
  SharpApi.SendDebugMessage('ThemeAPI','TThemeSkin.Destroy', 0);
  
  inherited;
end;

function TThemeSkin.GetDirectory: String;
begin
  result := FDirectory;
end;

function TThemeSkin.GetGlassEffect: TThemeSkinGlassEffect;
begin
  result := FGlassEffect;
end;

function TThemeSkin.GetName: String;
begin
  result := FName;
end;

function TThemeSkin.GetSchemesDirectory: String;
begin
  result := FSchemesDirectory;
end;

function TThemeSkin.GetSkinFont: TThemeSkinFont;
begin
  result := FSkinFont;
end;

procedure TThemeSkin.LoadFromFile;
begin
  SetDefaults;
    
  LoadFromFileSkinAndGlass;
  LoadFromFileFont;

  LastUpdate := DateTimeToUnix(Now());
end;

procedure TThemeSkin.LoadFromFileFont;
var
  XML : IXmlBase;
  fileloaded : boolean;
begin
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_SKIN_FONT_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    with XML.XmlRoot.Items, FSkinFont do
    begin
      ModSize := BoolValue('ModSize', ModSize);
      ModName := BoolValue('ModName', ModName);
      ModAlpha := BoolValue('ModAlpha', ModAlpha);
      ModUseShadow := BoolValue('ModUseShadow', ModUseShadow);
      ModShadowType := BoolValue('ModShadowType', ModShadowType);
      ModShadowAlpha := BoolValue('ModShadowAlpha', ModShadowAlpha);
      ModBold := BoolValue('ModBold', ModBold);
      ModItalic := BoolValue('ModItalic', ModItalic);
      ModUnderline := BoolValue('ModUnderline', ModUnderline);
      ModClearType := BoolValue('ModClearType', ModClearType);
      ValueSize := IntValue('ValueSize', ValueSize);
      ValueName := Value('ValueName', ValueName);
      ValueAlpha := IntValue('ValueAlpha', ValueAlpha);
      ValueUseShadow := BoolValue('ValueUseShadow', ValueUseShadow);
      ValueShadowType := IntValue('ValueShadowType', ValueShadowType);
      ValueShadowAlpha := IntValue('ValueShadowAlpha', ValueShadowAlpha);
      ValueBold := BoolValue('ValueBold', ValueBold);
      ValueItalic := BoolValue('ValueItalic', ValueItalic);
      ValueUnderline := BoolValue('ValueUnderline', ValueUnderline);
      ValueClearType := BoolValue('ValueClearType', ValueClearType);
    end;
  end else fileloaded := False;
  XML := nil;

  if not fileloaded then
    SaveToFileFont;
end;

procedure TThemeSkin.LoadFromFileSkinAndGlass;
var
  XML : IXmlBase;
  fileloaded : boolean;
begin
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_SKIN_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    with XML.XmlRoot.Items, FGlassEffect do
    begin
      FName          := Value('Skin', 'default');
      BlurRadius     := IntValue('GEBlurRadius', BlurRadius);
      BlurIterations := IntValue('GEBlurIterations', BlurIterations);
      Blend          := BoolValue('GEBlend', Blend);
      BlendColorStr  := Value('GEBlendColor', BlendColorStr);
      BlendAlpha     := IntValue('GEBlendAlpha', BlendAlpha);
      Lighten        := BoolValue('GELighten', Lighten);
      LightenAmount  := IntValue('GELightenAmount', LightenAmount);
    end
  end else fileloaded := False;
  XML := nil;

  if not fileloaded then
    SaveToFileSkinAndGlass;

  UpdateDirectory;
end;

procedure TThemeSkin.ParseColors(pScheme : IThemeScheme);
begin
  FGlassEffect.BlendColor := pScheme.ParseColor(FGlassEffect.BlendColorStr);
end;

procedure TThemeSkin.SaveToFile;
begin
  SaveToFileFont;
  SaveToFileSkinAndGlass;
end;

procedure TThemeSkin.SaveToFileFont;
var
  XML : IXmlBase;
begin
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_SKIN_FONT_FILE;
  XML.XmlRoot.Name := 'SharpEThemeFontSettings';
  with XML.XmlRoot.Items, FSkinFont do
  begin
    Add('ModSize', ModSize);
    Add('ModName', ModName);
    Add('ModAlpha', ModAlpha);
    Add('ModUseShadow', ModUseShadow);
    Add('ModShadowType', ModShadowType);
    Add('ModShadowAlpha', ModShadowAlpha);
    Add('ModBold', ModBold);
    Add('ModItalic', ModItalic);
    Add('ModUnderline', ModUnderline);
    Add('ModClearType', ModClearType);
    Add('ValueSize', ValueSize);
    Add('ValueName', ValueName);
    Add('ValueAlpha', ValueAlpha);
    Add('ValueUseShadow', ValueUseShadow);
    Add('ValueShadowType', ValueShadowType);
    Add('ValueShadowAlpha', ValueShadowAlpha);
    Add('ValueBold', ValueBold);
    Add('ValueItalic', ValueItalic);
    Add('ValueUnderline', ValueUnderline);
    Add('ValueClearType', ValueClearType);
  end;
  XML.Save;
  XML := nil;
end;

procedure TThemeSkin.SaveToFileSkinAndGlass;
var
  XML : IXmlBase;
begin
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_SKIN_FILE;
  XML.XmlRoot.Name := 'SharpEThemeSkin';
  with XML.XmlRoot.Items, FGlassEffect do
  begin
    Add('Skin',Name);
    Add('GEBlurRadius',BlurRadius);
    Add('GEBlurIterations',BlurIterations);
    Add('GEBlend',Blend);
    Add('GEBlendColor',BlendColorStr);
    Add('GEBlendAlpha',BlendAlpha);
    Add('GELighten',Lighten);
    Add('GELightenAmount',LightenAmount);
  end;
  XML.Save;
  XML := nil;
end;

procedure TThemeSkin.SetDefaults;
begin
  FName := 'Default';
  LastUpdate := 0;

  with FGlassEffect do
  begin
    BlurRadius := 1;
    BlurIterations := 3;
    Blend := False;
    BlendColor := $FFFFFF;
    BlendColorStr := 'clWhite';
    BlendAlpha := 32;
    Lighten := True;
    LightenAmount := 32;
  end;

  with FSkinFont do
  begin
    LastUpdate := 0;
    ModSize := False;
    ModName := False;
    ModAlpha := False;
    ModUseShadow := False;
    ModShadowType := False;
    ModShadowAlpha := False;
    ModBold := False;
    ModItalic := False;
    ModUnderline := False;
    ModClearType := False;
    ValueSize := 10;
    ValueName := 'Verdana';
    ValueAlpha := 0;
    ValueUseShadow := True;
    ValueShadowType := 0;
    ValueShadowAlpha := 0;
    ValueBold := False;
    ValueItalic := False;
    ValueUnderline := False;
    ValueClearType := True;  
  end;
end;

procedure TThemeSkin.SetGlassEffect(Value: TThemeSkinGlassEffect);
begin
  FGlassEffect := Value;
end;

procedure TThemeSkin.SetName(Value: String);
begin
  FName := Value;
  UpdateDirectory;
end;

procedure TThemeSkin.SetSkinFont(Value: TThemeSkinFont);
begin
  FSkinFont := Value;
end;

procedure TThemeSkin.UpdateDirectory;
begin
  FDirectory := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\' + FName + '\';
  if not DirectoryExists(FDirectory) then
    FDirectory := SharpApi.GetSharpeDirectory + SKINS_DIRECTORY + '\Simple\';

  FSchemesDirectory := SharpApi.GetSharpeUserSettingsPath + SKINS_SCHEME_DIRECTORY + '\' + FName + '\';
  if not DirectoryExists(FDirectory) then
    FSchemesDirectory := SharpApi.GetSharpeUserSettingsPath + SKINS_SCHEME_DIRECTORY + '\Simple\';  
end;

end.
