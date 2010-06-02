{
Source Name: xml settings
Description: drive object xml settings
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

unit DriveObjectXMLSettings;

interface

uses Graphics,
     JclSimpleXML,
     SharpApi,
     SysUtils,
     uSharpDeskTDeskSettings,
     uSharpDeskFunctions,
     uSharpDeskObjectSettings;

type
  TXMLSettings = class(TDesktopXMLSettings)
  private

  public
    {Settings Block}
      AlphaValue       : integer;
      AlphaBlend       : boolean;
      BlendColor       : TColor;
      BlendValue       : integer;
      IconType         : integer;
      UseIconShadow    : boolean;
      Size             : string;
      IconFile         : string;
      Caption          : string;
      Target           : string;
      BGSkin           : string;
      DiskData         : boolean;
      DisplayMeter     : boolean;
      Shadow           : boolean;
      ColorBlend       : boolean;
      ShowCaption      : boolean;
      UseThemeSettings : boolean;
      BGThickness      : boolean;
      BGTrans          : boolean;
      BGTransValue     : integer;
      BGType           : integer;
      BGColor          : TColor;
      BGBorderColor    : TColor;
      BGThicknessValue : integer;
      BGTHBlend        : boolean;
      BGTHBlendColor   : TColor;      
      MBGStart         : integer;
      MBGEnd           : integer;
      MFGStart         : integer;
      MFGEnd           : integer;
      MBorder          : integer;
      MTopOffset       : integer;
      MLeftOffset      : integer;
      MBottomOffset    : integer;
      MRightOffset     : integer;
      MeterAlign       : integer;
      IconSpacingValue : integer;
      IconSpacing      : boolean;
      IconOffsetValue  : integer;
      IconOffset       : boolean;
      LGStart          : integer;
      LGEnd            : integer;
      LGBorder         : integer;
      DLAlpha          : boolean;
      DLAlphaValue     : integer;
      DLFontName       : String;
      DLFontSize       : integer;
      DLFontColor      : TColor;
      DLFontBold       : boolean;
      DLFontItalic     : boolean;
      DLFontUnderline  : boolean;
      DriveLetter      : boolean;
      CaptionAlign     : integer;
      MLineCaption     : boolean;
      CustomFont       : boolean;
      FontName         : String;
      FontSize         : integer;
      FontColor        : TColor;
      FontBold         : boolean;
      FontItalic       : boolean;
      FontUnderline    : boolean;
      FontShadow       : boolean;
      FontShadowValue  : integer;
      FontShadowColor  : TColor;
      FontAlpha        : boolean;
      FontAlphaValue   : integer;
           
      {End Settings Block}
      procedure LoadSettings; override;
      procedure SaveSettings(SaveToFile : boolean); reintroduce;

      property Theme : TThemeSettingsArray read ts;
    end;


implementation

procedure TXMLSettings.LoadSettings;
begin
  inherited InitLoadSettings;
  inherited LoadSettings;

  with FXMLRoot.Items do
  begin
    AlphaValue       := IntValue('AlphaValue',255);
    AlphaBlend       := BoolValue('AlphaBlend',False);
    BlendValue       := IntValue('BlendValue',0);
    ColorBlend       := BoolValue('ColorBlend',False);
    UseIconShadow    := BoolValue('UseIconShadow',False);
    Size             := Value('Size','48');
    IconFile         := Value('IconFile','icon.drive.hd');
    Caption          := Value('Caption','C');
    Target           := Value('Target','C');    
    Shadow           := BoolValue('Shadow',False);
    ShowCaption      := BoolValue('ShowCaption',True);
    UseThemeSettings := BoolValue('UseThemeSettings',True);
    BGSkin           := Value('BGSkin','');    
    BGType           := IntValue('BGType',0);
    BGColor          := IntValue('BGColor',0);
    BGBorderColor    := IntValue('BGBorderColor',0);
    BlendColor       := IntValue('BlendColor',0);
    BGTrans          := BoolValue('BGTrans',False);
    BGTransValue     := IntValue('BGTransValue',0);
    BGThickness      := BoolValue('BGThickness',True);
    BGThicknessValue := IntValue('BGThicknessValue',1);
    DisplayMeter     := BoolValue('DisplayMeter',True);
    MeterAlign       := IntValue('MeterAlign',0);
    MTopOffset       := IntValue('MTopOffset',0);
    MLeftOffset      := IntValue('MLeftOffset',0);
    MBottomOffset    := IntValue('MBottomOffset',0);
    MRightOffset     := IntValue('MRightOffset',0);
    DiskData         := BoolValue('DiskData',True);
    IconSpacingValue := IntValue('IconSpacingValue',0);
    IconSpacing      := BoolValue('IconSpacing',False);
    IconOffsetValue  := IntValue('IconOffsetValue',0);
    IconOffset       := BoolValue('IconOffset',False);
    MBGStart         := IntValue('MBGStart',$AAAAAA);
    MBGEnd           := IntValue('MBGEnd',$333333);
    MFGStart         := IntValue('MFGStart',clWhite);
    MFGEnd           := IntValue('MFGEnd',clBlack);
    MBorder          := IntValue('MBorder',0);
    LGStart          := IntValue('LGStart',clWhite);
    LGEnd            := IntValue('LGEnd',clBlack);
    DriveLetter      := BoolValue('DriveLetter',True);
    LGBorder         := IntValue('LGBorder',0);
    DLAlpha          := BoolValue('DLAlpha',False);
    DLAlphaValue     := IntValue('DLAlphaValue',255);
    DLFontName       := Value('DLFontName','Arial');
    DLFontSize       := IntValue('DLFontSize',10);
    DLFontColor      := IntValue('DLFontColor',0);
    DLFontBold       := BoolValue('DLFontBold',True);
    DLFontItalic     := BoolValue('DLFontItalic',False);
    DLFontUnderline  := BoolValue('DLFontUnderline',False);
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
begin
  if FXMLRoot = nil then
    exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  with FXMLRoot.Items do
  begin
    Add('AlphaValue', AlphaValue);
    Add('AlphaBlend', AlphaBlend);
    Add('BlendValue', BlendValue);
    Add('ColorBlend', ColorBlend);
    Add('UseIconShadow', UseIconShadow);
    Add('Size', Size);

    Add('Target',Target);
    with FXMLRoot.Items.ItemNamed['Target'].Properties do
    begin
      Add('CopyValue',False);
      Add('SortValue',True);
    end;

    Add('IconFile', IconFile);
    Add('Caption', Caption);
    Add('Shadow', Shadow);
    Add('ShowCaption', ShowCaption);
    Add('UseThemeSettings', UseThemeSettings);
    Add('BGColor', BGColor);
    Add('BGBorderColor', BGBorderColor);
    Add('BGType', BGType);
    Add('BGSkin', BGSkin);
    Add('BlendColor', BlendColor);
    Add('BGTrans', BGTrans);
    Add('BGTransValue', BGTransValue);
    Add('BGThickness', BGThickness);
    Add('BGThicknessValue', BGThicknessValue);
    Add('DisplayMeter', DisplayMeter);
    Add('MeterAlign', MeterAlign);
    Add('MTopOffset', MTopOffset);
    Add('MLeftOffset', MLeftOffset);
    Add('MBottomOffset', MBottomOffset);
    Add('MRightOffset', MRightOffset);
    Add('DiskData', DiskData);
    Add('IconSpacingValue', IconSpacingValue);
    Add('IconSpacing', IconSpacing);
    Add('IconOffsetValue', IconOffsetValue);
    Add('IconOffset', IconOffset);
    Add('MBGStart', MBGStart);
    Add('MBGEnd', MBGEnd);
    Add('MFGStart', MFGStart);
    Add('MFGEnd', MFGEnd);
    Add('MBorder', MBorder);
    Add('LGStart', LGStart);
    Add('LGEnd', LGEnd);
    Add('DriveLetter', DriveLetter);
    Add('LGBorder', LGBorder);
    Add('DLAlpha', DLAlpha);
    Add('DLAlphaValue', DLAlphaValue);  
    Add('DLFontName', DLFontName);
    Add('DLFontSize', DLFontSize);
    Add('DLFontColor', DLFontColor);
    Add('DLFontBold', DLFontBold);
    Add('DLFontItalic', DLFontItalic);
    Add('DLFontUnderline', DLFontUnderline);
    Add('BGTHBlend', BGTHBlend);
    Add('BGTHBlendColor', BGTHBlendColor);
    Add('CaptionAlign', CaptionAlign);
    Add('MLineCaption', MLineCaption);
    Add('CustomFont', CustomFont);
    Add('FontName', FontName);
    Add('FontSize', FontSize);
    Add('FontColor', FontColor);
    Add('FontBold', FontBold);
    Add('FontItalic', FontItalic);
    Add('FontUnderline', FontUnderline);
    Add('FontShadow', FontShadow);
    Add('FontShadowValue', FontShadowValue);
    Add('FontShadowColor', FontShadowColor);
    Add('FontAlpha', FontAlpha);
    Add('FontAlphaValue', FontAlphaValue);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;

end.
