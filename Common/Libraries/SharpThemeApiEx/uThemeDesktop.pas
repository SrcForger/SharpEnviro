{
Source Name: uTThemeDesktop.pas
Description: TThemeDesktop class implementing IThemeDesktop Interface
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

unit uThemeDesktop;

interface

uses
  uThemeInfo, uThemeConsts, uIThemeDesktop, uIThemeScheme;

type
  TThemeDesktop = class(TInterfacedObject, IThemeDesktop)
  private
    FThemeInfo  : TThemeInfo;
    FIcon       : TThemeDesktopIcon;
    FAnimation : TThemeDesktopAnim;
    procedure SetDefaults;
    procedure LoadFromFileIcon;
    procedure LoadFromFileAnimation;
  public
    LastUpdate : Int64;
    procedure ParseColors(pScheme : IThemeScheme);
    constructor Create(pThemeInfo : TThemeInfo); reintroduce;
    
    // IThemeDesktopInterface
    function GetIcon: TThemeDesktopIcon; stdcall;
    procedure SetIcon(Value :TThemeDesktopIcon); stdcall;
    property Icon : TThemeDesktopIcon read GetIcon write SetIcon;

    function GetAnimation: TThemeDesktopAnim; stdcall;
    procedure SetAnimation(Value : TThemeDesktopAnim); stdcall;
    property Animation : TThemeDesktopAnim read GetAnimation write SetAnimation;

    procedure SaveToFile; stdcall;
    procedure SaveToFileAnimation; stdcall;
    procedure SaveToFileIcon; stdcall;
    procedure LoadFromFile; stdcall;    
  end;

implementation

uses
  SysUtils, DateUtils, JclSimpleXML,
  IXmlBaseUnit;

{ TThemeDesktop }

constructor TThemeDesktop.Create(pThemeInfo : TThemeInfo);
begin
  FThemeInfo := pThemeInfo;

  LoadFromFile;
end;

function TThemeDesktop.GetAnimation: TThemeDesktopAnim;
begin
  result := FAnimation;
end;

function TThemeDesktop.GetIcon: TThemeDesktopIcon;
begin
  result := FIcon;
end;

procedure TThemeDesktop.LoadFromFile;
begin
  SetDefaults;

  LoadFromFileAnimation;
  LoadFromFileIcon;

  LastUpdate := DateTimeToUnix(Now());
end;

procedure TThemeDesktop.LoadFromFileAnimation;
var
  XML : TInterfacedXmlBase;
  fileloaded : boolean;
begin
  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_DESKTOP_ANIM_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    with XML.XmlRoot.Items, FAnimation do
    begin
      UseAnimations   := BoolValue('UseAnimations', UseAnimations);
      Scale           := BoolValue('Scale', Scale);
      ScaleValue      := IntValue('ScaleValue', ScaleValue);
      Alpha           := BoolValue('Alpha', Alpha);
      AlphaValue      := IntValue('AlphaValue', AlphaValue);
      Blend           := BoolValue('Blend', Blend);
      BlendValue      := IntValue('BlendValue', BlendValue);
      BlendColorStr   := Value('BlendColor', BlendColorStr);
      Brightness      := BoolValue('Brightness', Brightness);
      BrightnessValue := IntValue('BrightnessValue', BrightnessValue);
    end
  end else fileloaded := False;
  XML.Free;

  if not fileloaded then
    SaveToFileAnimation;
end;

procedure TThemeDesktop.LoadFromFileIcon;
var
  XML : TInterfacedXmlBase;
  fileloaded : boolean;
begin
  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_DESKTOP_ICON_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    with XML.XmlRoot.Items, FIcon do
    begin
      IconSize           := IntValue('IconSize', IconSize);
      IconAlphaBlend     := BoolValue('IconAlphaBlend', IconAlphaBlend);
      IconAlpha          := IntValue('IconAlpha', IconAlpha);
      IconBlending       := BoolValue('IconBlending', IconBlending);
      IconBlendColorStr  := Value('IconBlendColor', IconBlendColorStr);
      IconBlendAlpha     := IntValue('IconBlendAlpha', IconBlendAlpha);
      IconShadow         := BoolValue('IconShadow', IconShadow);
      IconShadowColorStr := Value('IconShadowColor', IconShadowColorStr);
      IconShadowAlpha    := IntValue('IconShadowAlpha', IconShadowAlpha);
      FontName           := Value('FontName', FontName);
      TextSize           := IntValue('TextSize', TextSize);
      TextBold           := BoolValue('TextBold', TextBold);
      TextItalic         := BoolValue('TextItalic', TextItalic);
      TextUnderline      := BoolValue('TextUnderline', TextUnderline);
      TextColorStr       := Value('TextColor', TextColorStr);
      TextAlpha          := BoolValue('TextAlpha', TextAlpha);
      TextAlphaValue     := IntValue('TextAlphaValue', TextAlphaValue);
      TextShadow         := BoolValue('TextShadow', TextShadow);
      TextShadowAlpha    := IntValue('TextShadowAlpha', TextShadowAlpha);
      TextShadowColorStr := Value('TextShadowColor', TextShadowColorStr);
      TextShadowType     := IntValue('TextShadowType', TextShadowType);
      TextShadowSize     := IntValue('TextShadowSize', TextShadowSize);
      DisplayText        := BoolValue('DisplayText', DisplayText);
    end
  end else fileloaded := False;
  XML.Free;

  if not fileloaded then
    SaveToFileIcon;
end;

procedure TThemeDesktop.ParseColors(pScheme: IThemeScheme);
begin
  with FIcon do
  begin
    IconBlendColor  := pScheme.ParseColor(IconBlendColorStr);
    IconShadowColor := pScheme.ParseColor(IconShadowColorStr);
    TextColor       := pScheme.ParseColor(TextColorStr);
    TextShadowColor := pScheme.ParseColor(TextShadowColorStr);
  end;

  with FAnimation do
  begin
    BlendColor := pScheme.ParseColor(BlendColorStr);
  end;
end;

procedure TThemeDesktop.SaveToFile;
begin
  SaveToFileAnimation;
  SaveToFileIcon;
end;

procedure TThemeDesktop.SaveToFileAnimation;
var
  XML : TInterfacedXmlBase;
begin
  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_DESKTOP_ANIM_FILE;

  XML.XmlRoot.Name := 'SharpEThemeDesktopAnimation';
  with XML.XmlRoot.Items, FAnimation do
  begin
    Add('UseAnimations', UseAnimations);
    Add('Scale', Scale);
    Add('ScaleValue', ScaleValue);
    Add('Alpha', Alpha);
    Add('AlphaValue', AlphaValue);
    Add('Blend', Blend);
    Add('BlendValue', BlendValue);
    Add('BlendColor', BlendColorStr);
    Add('Brightness', Brightness);
    Add('BrightnessValue', BrightnessValue);
  end;
  XML.Save;

  XML.Free;
end;

procedure TThemeDesktop.SaveToFileIcon;
var
  XML : TInterfacedXmlBase;
begin
  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_DESKTOP_ICON_FILE;

  XML.XmlRoot.Name := 'SharpEThemeDesktopIcon';
  with XML.XmlRoot.Items, FIcon do
  begin
    Add('IconSize', IconSize);
    Add('IconAlphaBlend', IconAlphaBlend);
    Add('IconAlpha', IconAlpha);
    Add('IconBlending', IconBlending);
    Add('IconBlendColor', IconBlendColorStr);
    Add('IconBlendAlpha', IconBlendAlpha);
    Add('IconShadow', IconShadow);
    Add('IconShadowColor', IconShadowColorStr);
    Add('IconShadowAlpha', IconShadowAlpha);
    Add('FontName', FontName);
    Add('TextSize', TextSize);
    Add('TextBold', TextBold);
    Add('TextItalic', TextItalic);
    Add('TextUnderline', TextUnderline);
    Add('TextColor', TextColorStr);
    Add('TextAlpha', TextAlpha);
    Add('TextAlphaValue', TextAlphaValue);
    Add('TextShadow', TextShadow);
    Add('TextShadowAlpha', TextShadowAlpha);
    Add('TextShadowColor', TextShadowColorStr);
    Add('TextShadowType', TextShadowType);
    Add('TextShadowSize', TextShadowSize);
    Add('DisplayText', DisplayText);
  end;
  XML.Save;

  XML.Free;
end;

procedure TThemeDesktop.SetAnimation(Value: TThemeDesktopAnim);
begin
  FAnimation := Value;
end;

procedure TThemeDesktop.SetDefaults;
begin
  with FIcon do
  begin
    IconSize := 48;
    IconAlphaBlend := False;
    IconAlpha := 255;
    IconBlending := False;
    IconBlendColor := 0;
    IconBlendColorStr := '0';
    IconBlendAlpha := 255;
    IconShadow := True;
    IconShadowColor := 0;
    IconShadowColorStr := '0';
    IconShadowAlpha := 128;
    FontName := 'Verdana';
    TextSize := 8;
    TextBold := False;
    TextItalic := False;
    TextUnderline := False;
    TextColor := 0;
    TextColorStr := '0';
    TextAlpha := False;
    TextAlphaValue := 255;
    TextShadow := False;
    TextShadowAlpha := 255;
    TextShadowColor := 0;
    TextShadowColorStr := '0';
    TextShadowType := 1;
    TextShadowSize := 1;
    DisplayText := True;
  end;

  with FAnimation do
  begin
    UseAnimations := True;
    Scale := False;
    ScaleValue := 0;
    Alpha := True;
    AlphaValue := 128;
    Blend := True;
    BlendValue := 255;
    BlendColor := 11842737;
    BlendColorStr := '11842737';
    Brightness := True;
    BrightnessValue := 25;
  end;  
end;

procedure TThemeDesktop.SetIcon(Value: TThemeDesktopIcon);
begin
  FIcon := Value;
end;

end.
