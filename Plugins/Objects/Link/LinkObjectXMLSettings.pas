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
     uSharpDeskFunctions,
     uSharpDeskObjectSettings;

type
    TXMLSettings = class(TDesktopXMLSettings)
    private
    public
      {Settings Block}
      CaptionAlign     : integer;
      Caption          : string;
      Target           : string;
      Icon             : String;
      MLineCaption     : boolean;
      procedure LoadSettings; override;
      procedure SaveSettings(SaveToFile : boolean); reintroduce;
    published
    end;


implementation



procedure TXMLSettings.LoadSettings;
begin
  inherited InitLoadSettings;
  inherited LoadSettings;

  with FXMLRoot.Items do
  begin
    Icon         := Value('Icon','icon.application');
    Caption      := Value('Caption','');
    Target       := Value('Target','explorer');
    CaptionAlign := IntValue('CaptionAlign',2);
    MLineCaption := BoolValue('MLineCaption',False);
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
  SaveSetting(FXMLRoot,'IconSpacingValue',IconSpacingValue,True);
  SaveSetting(FXMLRoot,'IconSpacing',IconSpacing,True);
  SaveSetting(FXMLRoot,'IconOffsetValue',IconOffsetValue,True);
  SaveSetting(FXMLRoot,'IconOffset',IconOffset,True);
  SaveSetting(FXMLRoot,'CaptionAlign',CaptionAlign,False);
  SaveSetting(FXMLRoot,'MLineCaption',MLineCaption,False);
  SaveSetting(FXMLRoot,'CustomFont',CustomFont,True);
  SaveSetting(FXMLRoot,'FontName',FontName,True);
  SaveSetting(FXMLRoot,'FontSize',FontSize,True);

  SaveSetting(FXMLRoot,'FontBold',FontBold,True);
  SaveSetting(FXMLRoot,'FontItalic',FontItalic,True);
  SaveSetting(FXMLRoot,'FontUnderline',FontUnderline,True);
  SaveSetting(FXMLRoot,'FontShadow',FontShadow,True);
  SaveSetting(FXMLRoot,'FontShadowValue',FontShadowValue,True);

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
