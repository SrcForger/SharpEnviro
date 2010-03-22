{
Source Name: uThemeConsts.pas
Description: Theme related constants and type delcarations
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

unit uThemeConsts;

interface


type
  TThemePart = (tpSkinScheme, tpIconSet, tpDesktop, tpWallpaper, tpSkinFont,
               tpTheme);
  TThemeParts = set of TThemePart;

const
  ALL_THEME_PARTS = [tpSkinScheme, tpIconSet, tpDesktop, tpWallpaper, tpSkinFont,
                     tpTheme];
    

type
  // TThemeInfo
  TThemeInfoAdditional = record
    Author  : String;
    Website : String;
    Comment : String;
  end;

  // TThemeSkin
  TThemeSkinGlassEffect = record
    BlurRadius     : integer;
    BlurIterations : integer;
    Blend          : Boolean;
    BlendColor     : integer;
    BlendColorStr  : String;
    BlendAlpha     : integer;
    Lighten        : Boolean;
    LightenAmount  : integer;
  end;

  TThemeSkinFont = record
    LastUpdate: Int64;
    ModSize: boolean;
    ModName: boolean;
    ModAlpha: boolean;
    ModUseShadow: boolean;
    ModShadowType: boolean;
    ModShadowAlpha: boolean;
    ModBold: boolean;
    ModItalic: boolean;
    ModUnderline: boolean;
    ModClearType: boolean;
    ValueSize: integer;
    ValueName: string;
    ValueAlpha: integer;
    ValueUseShadow: boolean;
    ValueShadowType: integer;
    ValueShadowAlpha: integer;
    ValueBold: boolean;
    ValueItalic: boolean;
    ValueUnderline: boolean;
    ValueClearType: Boolean;
  end;

  //TThemeDesktop
  TThemeDesktopIcon = record
    LastUpdate: Int64;
    IconSize: integer;
    IconAlphaBlend: boolean;
    IconAlpha: integer;
    IconBlending: boolean;
    IconBlendColor: integer;
    IconBlendColorStr : String;
    IconBlendAlpha: integer;
    IconShadow: boolean;
    IconShadowColor: integer;
    IconShadowColorStr : String;
    IconShadowAlpha: integer;
    FontName: string;
    TextSize: integer;
    TextBold: boolean;
    TextItalic: boolean;
    TextUnderline: boolean;
    TextColor: integer;
    TextColorStr : String;
    TextAlpha: boolean;
    TextAlphaValue: integer;
    TextShadow: boolean;
    TextShadowAlpha: integer;
    TextShadowColor: integer;
    TextShadowColorStr : String;
    TextShadowType: integer;
    TextShadowSize: integer;
    DisplayText: boolean;
  end;

  TThemeDesktopAnim = record
    LastUpdate: Int64;
    UseAnimations: boolean;
    Scale: boolean;
    ScaleValue: integer;
    Alpha: boolean;
    AlphaValue: integer;
    Blend: boolean;
    BlendValue: integer;
    BlendColor: integer;
    BlendColorStr : String;
    Brightness: boolean;
    BrightnessValue: integer;
  end;

  // TThemeScheme
  TSharpESchemeType = (stColor, stBoolean, stInteger, stDynamic);

  TSharpESkinColor = record
    Name: string;
    Tag: string;
    Info: string;
    Color: integer;
    SchemeType: TSharpESchemeType;
  end;

  TSharpEColorSet = array of TSharpESkinColor;

  // TThemeIcon
  TSharpEIcon = record
    FileName: string;
    Tag: string;
  end;

  TSharpEIconSet = array of TSharpEIcon;

  TThemeIconSetInfo = record
    Author  : String;
    Website : String;
  end;

  // TThemeWallpaper
  TThemeWallpaperGradientType = (twgtHoriz, twgtVert, twgtTSHoriz, twgtTSVert);
  TThemeWallpaperSize = (twsCenter, twsScale, twsStretch, twsTile);
  TThemeWallpaperItem = record
    Name: String;
    Image: String;
    Color: integer;
    ColorStr : String;
    Alpha: integer;
    Size: TThemeWallpaperSize;
    ColorChange: boolean;
    Hue: integer;
    Saturation: integer;
    Lightness: integer;
    Gradient: boolean;
    GradientType: TThemeWallpaperGradientType;
    GDStartColor: integer;
    GDStartColorStr : String;
    GDStartAlpha: integer;
    GDEndColor: integer;
    GDEndColorStr : String;
    GDEndAlpha: integer;
    MirrorHoriz: boolean;
    MirrorVert: boolean;
    SwitchPath: String;
    SwitchRecursive: boolean;
    SwitchRandomize: boolean;
    SwitchTimer: integer;
  end;
  TWallpaperMonitor = record
    Name: string;
    ID: integer;
  end;

  TThemeWallpaperItems = array of TThemeWallpaperItem;
  TMonitorWallpapers = array of TWallpaperMonitor;

  // TThemeList
  TThemeListItem = record
    Name: string;
    Author: string;
    Comment: string;
    Website: string;
    Filename: string;
    Preview: string;
    Readonly: boolean;
  end;
  TThemeListItemSet = array of TThemeListItem;

const
  // File and Directories
  THEME_DIR = 'Themes';
  ICONS_DIR = 'Icons';
  SHARPE_USER_SETTINGS = 'SharpE.xml';

  THEME_INFO_FILE = 'Theme.xml';
  THEME_SKIN_FILE = 'Skin.xml';
  THEME_SKIN_FONT_FILE = 'Font.xml';
  THEME_SCHEME_FILE = 'Scheme.xml';
  THEME_DESKTOP_ICON_FILE = 'DesktopIcon.xml';
  THEME_DESKTOP_ANIM_FILE = 'DesktopAnimation.xml';
  THEME_ICONSET_FILE = 'IconSet.xml';
  THEME_WALLPAPER_FILE = 'Wallpaper.xml';

  SKINS_DIRECTORY = 'Skins';
  SKINS_SCHEME_DIRECTORY = 'Schemes';
  SKINS_SCHEME_FILE = 'Scheme.xml';

  // Defaults
  DEFAULT_THEME = 'Default';
  DEFAULT_ICONSET = 'Cubeix Black';


implementation

end.
