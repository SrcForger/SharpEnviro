{
Source Name: uSharpETheme.pas
Description: TSharpETheme Class
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

unit uSharpETheme;

interface

uses
  Windows, SysUtils, Classes,
  JclSimpleXML,
  IXmlBaseUnit, SharpApi,
  uThemeInfo, uThemeConsts, uThemeSkin, uThemeScheme, uIThemeInfo,
  uISharpETheme, uIThemeSkin, uIThemeScheme, uThemeDesktop,
  uIThemeDesktop, uIThemeIcons, uThemeIcons, uThemeWallpaper,
  uIThemeWallpaper;

type
  TSharpETheme = class(TInterfacedObject, ISharpETheme)
  private
    FIsCustomTheme : boolean;
    FParts : TThemeParts;
    FThemeInfo : TThemeInfo;
    FThemeSkin : TThemeSkin;
    FThemeScheme : TThemeScheme;
    FThemeDesktop : TThemeDesktop;
    FThemeIcons : TThemeIcons;
    FThemeWallpaper : TThemeWallpaper;
    FThemeInfoInterface : IThemeInfo;
    FThemeSkinInterface : IThemeSkin;
    FThemeSchemeInterface : IThemeScheme;
    FThemeDesktopInterface : IThemeDesktop;
    FThemeIconsInterface : IThemeIcons;
    FThemeWallpaperInterface : IThemeWallpaper;
    function GetCurrentTheme : String;
    procedure CreateDefaultSharpeUserSettings;
    function CheckSharpEUserSettings: boolean;
  public
    constructor Create; reintroduce; overload;
    constructor Create(pName : String); overload;
    destructor Destroy; override;

    //ISharpETheme Interface
    function GetThemeInfo : IThemeInfo; stdcall;
    property Info : IThemeInfo read GetThemeInfo;

    function GetThemeSKin : IThemeSkin; stdcall;
    property Skin : IThemeSkin read GetThemeSkin;

    function GetThemeScheme : IThemeScheme; stdcall;
    property Scheme : IThemeScheme read GetThemeScheme;

    function GetThemeDesktop : IThemeDesktop; stdcall;
    property Desktop : IThemeDesktop read GetThemeDesktop;

    function GetThemeIcons : IThemeIcons; stdcall;
    property Icons : IThemeIcons read GetThemeIcons;

    function GetThemeWallpaper : IThemeWallpaper; stdcall;
    property Wallpaper : IThemeWallpaper read GetThemeWallpaper;       

    procedure LoadTheme(pParts: TThemeParts = ALL_THEME_PARTS); stdcall;
    procedure SetCurrentTheme(Name : String); stdcall;
  end;

implementation

function TSharpETheme.CheckSharpEUserSettings: boolean;
begin
  if FileExists(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS) then
    result := True
  else
    result := False;
end;

constructor TSharpETheme.Create;
begin
  inherited Create;
  SharpApi.SendDebugMessage('ThemeAPI','TSharpETheme.Create', 0);

  FParts := [];

  FIsCustomTheme := False;
  FThemeInfo := TThemeInfo.Create(GetCurrentTheme);
  FThemeInfoInterface := FThemeInfo;
end;

constructor TSharpETheme.Create(pName: String);
begin
  inherited Create;

  SharpApi.SendDebugMessage('ThemeAPI','TSharpETheme.Create(' + pName + ')', 0);

  FParts := [];

  FIsCustomTheme := True;
  FThemeInfo := TThemeInfo.Create(pName);
  FThemeInfoInterface := FThemeInfo;  
end;

procedure TSharpETheme.CreateDefaultSharpeUserSettings;
var
  XML: TJclSimpleXML;
begin
  XML := TJclSimpleXML.Create;
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

destructor TSharpETheme.Destroy;
begin
  SharpApi.SendDebugMessage('ThemeAPI','TSharpETheme.Destroy', 0);

  FThemeInfoInterface      := nil;
  FThemeSkinInterface      := nil;
  FThemeSchemeInterface    := nil;
  FThemeDesktopInterface   := nil;
  FThemeIconsInterface     := nil;
  FThemeWallpaperInterface := nil;

  inherited Destroy;
end;

function TSharpETheme.GetCurrentTheme : String;
var
  XML : IXmlBase;
  fileloaded : boolean;
begin
  if not CheckSharpEUserSettings then
    CreateDefaultSharpEUserSettings;

  result := 'Default';
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS;
  if XML.Load then
  begin
    fileloaded := True;
    with XML.XmlRoot.Items do
      result := Value('Theme', 'Default');
  end else fileloaded := False;
  XML := nil;

  if not fileloaded then
    CreateDefaultSharpEUserSettings;
end;

procedure TSharpETheme.SetCurrentTheme(Name : String);
var
  XML: TJclSimpleXML;
begin
  XML := TJclSimpleXML.Create;
  try
    XML.Root.Name := 'SharpEUserSettings';
    XML.Root.Items.Clear;
    XML.Root.Items.Add('Theme', Name);
    ForceDirectories(SharpApi.GetSharpeUserSettingsPath);
    XML.SaveToFile(SharpApi.GetSharpeUserSettingsPath + SHARPE_USER_SETTINGS);
  finally
    XML.Free;
  end;
end;

function TSharpETheme.GetThemeDesktop: IThemeDesktop;
begin
  result := FThemeDesktopInterface;
end;

function TSharpETheme.GetThemeIcons: IThemeIcons;
begin
  result := FThemeIconsInterface;
end;

function TSharpETheme.GetThemeInfo: IThemeInfo;
begin
  result := FThemeInfoInterface;
end;

function TSharpETheme.GetThemeScheme: IThemeScheme;
begin
  result := FThemeSchemeInterface;
end;

function TSharpETheme.GetThemeSkin: IThemeSKin;
begin
  result := FThemeSkinInterface;
end;

function TSharpETheme.GetThemeWallpaper: IThemeWallpaper;
begin
  result := FThemeWallpaperInterface;
end;

procedure TSharpETheme.LoadTheme(pParts: TThemeParts);
var
  s,s2 : String;
begin
  s := '';
  if tpTheme in pParts then
    s := s + 'tpTheme,';
  if tpSkinScheme in pParts then
    s := s + 'tpSkinScheme,';
  if tpWallpaper in pParts then
    s := s + 'tpWallpaper,';
  if tpIconSet in pParts then
    s := s + 'tpIconSet,';
  if tpDesktop in pParts then
    s := s + 'tpDesktop,';
  if tpSkinFont in pParts then
    s := s + 'tpSkinFont,';

  s2 := BoolToStr((FThemeInfo = nil)) + ',' + BoolToStr((FThemeSkin = nil))
        + ',' + BoolToStr((FThemeDesktop = nil)) + ',' + BoolToStr((FThemeIcons = nil))
        + ',' + BoolToStr((FThemeWallpaper = nil));
  SharpApi.SendDebugMessage('ThemeAPI','Load Theme:' + s + s2, 0);

  if (tpTheme in pParts) and (not FIsCustomTheme) then
  begin
    FThemeInfo.Name := GetCurrentTheme;
    FThemeInfo.LoadFromFile;
  end;
  
  if ((tpSkinScheme in pParts) or (tpSkinFont in pParts))
    and (not (tpSkinScheme in FParts)) then
  begin
    FParts := FParts + [tpSkinScheme,tpSkinFont];

    FThemeSkin := TThemeSkin.Create(FThemeInfo);
    FThemeSkinInterface := FThemeSkin;

    FThemeScheme := TThemeScheme.Create(FThemeInfo,FThemeSkin);
    FThemeSchemeInterface := FThemeScheme;
  end else if (tpSkinScheme in pParts) then
  begin
    FThemeSkin.LoadFromFile;
    FThemeScheme.LoadFromFile;
  end else if (tpSkinFont in pParts) then
  begin
    FThemeSkin.LoadFromFileFont;
  end;

  if (tpDesktop in pParts) then
  begin
    if (not (tpDesktop in FParts)) then
    begin
      FParts := FParts + [tpDesktop];

      FThemeDesktop := TThemeDesktop.Create(FThemeInfo);
      FThemeDesktopInterface := FThemeDesktop;
    end else FThemeDesktop.LoadFromFile;
  end;

  if (tpIconSet in pParts) then
  begin
    if (not (tpIconSet in FParts)) then
    begin
      FParts := FParts + [tpIconSet];

      FThemeIcons := TThemeIcons.Create(FThemeInfo);
      FThemeIconsInterface := FThemeIcons;
    end else FThemeIcons.LoadFromFile;
  end;

  if (tpWallpaper in pParts) then
  begin
    if (not (tpWallpaper in FParts)) then
    begin
      FParts := FParts + [tpWallpaper];

      FThemeWallpaper := TThemeWallpaper.Create(FThemeInfo);
      FThemeWallpaperInterface := FThemeWallpaper;
    end else FThemeWallpaper.LoadFromFile;
  end;

  if (FThemeSchemeInterface <> nil) then
  begin
    if (tpSkinScheme in FParts) or (tpSkinFont in FParts) then
      FThemeSkin.ParseColors(FThemeSchemeInterface);
    if (tpDesktop in FParts) then
      FThemeDesktop.ParseColors(FThemeSchemeInterface);
    if (tpWallpaper in FParts) then
      FThemeWallpaper.ParseColors(FThemeSchemeInterface);
  end;
end;

end.
