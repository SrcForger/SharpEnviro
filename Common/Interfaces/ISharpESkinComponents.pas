{
Source Name: ISharpESkinComponents.dpr
Description: Skin System Interface Declarations
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit ISharpESkinComponents;

interface

uses
  Types,
  Graphics,
  // Third Party
  GR32,
  // SharpE Units
  SharpTypes,
  uThemeConsts;

type
  ISharpEScheme = interface
    ['{3A9B105D-5D59-4ADC-BE7F-5193E0CBB020}']
    function GetColorByName(Name : String) : integer; stdcall;
    function GetColorByTag(Tag  : String) : integer; stdcall;
    function GetColorIndexByTag(Tag : String) : integer; stdcall;

    function GetColors : TSharpEColorSet; stdcall;
    procedure SetColors(value : TSharpEColorSet); stdcall;
    property Colors : TSharpEColorSet read GetColors write SetColors;
  end;

  ISharpESkinHighlightItem = interface
  ['{034F4C7A-4762-4060-9188-042B0610C642}']
    function GetValue  : integer; stdcall;
    function GetChange : integer; stdcall;
    function GetApply  : boolean; stdcall;
    function GetMax    : integer; stdcall;
    function GetMin    : integer; stdcall;
    function GetColor  : integer; stdcall;
    function GetColorStr : String; stdcall;    

    procedure SetValue(NewValue : integer); stdcall;
    procedure SetChange(NewValue : integer); stdcall;
    procedure SetApply(NewValue : boolean); stdcall;
    procedure SetMax(NewValue : integer); stdcall;
    procedure SetMin(NewValue : integer); stdcall;
    procedure SetColor(NewValue : integer); stdcall;
    procedure SetColorStr(NewValue : String); stdcall;

    procedure UpdateDynamicProperties(cs: ISharpEScheme); stdcall;    
    procedure Assign(Src : ISharpESkinHighlightItem); overload; stdcall;

    property Value  : integer read GetValue write SetValue;
    property Change : integer read GetChange write SetChange;
    property Apply  : boolean read GetApply write SetApply;
    property Max    : integer read GetMax write SetMax;
    property Min    : integer read GetMin write SetMin;
    property Color  : integer read GetColor write SetColor;
    property ColorString : String read GetColorStr write SetColorStr;   
  end;    

  ISharpESkinHighlightSettings = interface
  ['{902D41A7-6DC0-4BE7-8336-B6363EDA6A2E}']
    function GetLighten     : ISharpESkinHighlightItem; stdcall;
    function GetLightenIcon : ISharpESkinHighlightItem; stdcall;
    function GetAlpha       : ISharpESkinHighlightItem; stdcall;
    function GetAlphaIcon   : ISharpESkinHighlightItem; stdcall;
    function GetBlend       : ISharpESkinHighlightItem; stdcall;
    function GetBlendIcon   : ISharpESkinHighlightItem; stdcall;

    procedure UpdateDynamicProperties(cs: ISharpEScheme); stdcall;
    procedure Assign(Src : ISharpESkinHighlightSettings); overload; stdcall;

    property Lighten     : ISharpESkinHighlightItem read GetLighten;
    property LightenIcon : ISharpESkinHighlightItem read GetLightenIcon;
    property Alpha       : ISharpESkinHighlightItem read GetAlpha;
    property AlphaIcon   : ISharpESkinHighlightItem read GetAlphaIcon;
    property Blend       : ISharpESkinHighlightItem read GetBlend;
    property BlendIcon   : ISharpESkinHighlightItem read GetBlendIcon;
  end;

  ISharpESkinText = interface
    ['{8A116794-9019-4E66-8865-88DD34A81E1F}']
    function GetDim(CompRect: TRect) : TPoint; stdcall;
    function GetXY(TextRect,CompRect,IconRect: TRect; isBarBottom : boolean = False): TPoint; stdcall;    
    procedure Assign(Value: ISharpESkinText); overload; stdcall;
    function CreateThemedSkinText : ISharpESkinText; stdcall;    
    procedure UpdateDynamicProperties(cs: ISharpEScheme); stdcall;    
    procedure AssignFontTo(pFont : TFont; cs: ISharpEScheme); stdcall;
    procedure RenderToW(Bmp : TBitmap32; X,Y : integer; Caption : WideString; cs : ISharpEScheme;
                        var pPrecacheText : ISharpESkinText; var pPrecacheBmp : TBitmap32; var pPrecacheCaption : WideString); overload; stdcall;
    procedure RenderToW(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : ISharpEScheme); overload; stdcall;
    procedure RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : ISharpEScheme;
                       var pPrecacheText : ISharpESkinText; var pPrecacheBmp : TBitmap32; var pPrecacheCaption : String); overload; stdcall;
    procedure RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : ISharpEScheme); overload; stdcall;

    function GetX : String; stdcall;
    function GetY : String; stdcall;
    function GetXBottom : String; stdcall;
    function GetYBottom : String; stdcall;      
    function GetWidth : String; stdcall;
    function GetHeight : String; stdcall;
    function GetName : String; stdcall;
    function GetColor : integer; stdcall;
    function GetColorString : String; stdcall;
    function GetAlpha : byte; stdcall;
    function GetAlphaString : String; stdcall;
    function GetShadow : boolean; stdcall;
    function GetSize : integer; stdcall;
    function GetShadowColor : integer; stdcall;
    function GetShadowColorString : String; stdcall;
    function GetShadowAlpha : byte; stdcall;
    function GetShadowType : TSharpESkinShadowType; stdcall;
    function GetDrawText : boolean; stdcall;
    function GetClearType : boolean; stdcall;
    function GetStyleBold : Boolean; stdcall;
    function GetStyleUnderline : Boolean; stdcall;
    function GetStyleItalic : Boolean; stdcall;    

    procedure SetX(Value : String); stdcall;
    procedure SetY(Value : String); stdcall;
    procedure SetXBottom(Value : String); stdcall;
    procedure SetYBottom(Value : String); stdcall;     
    procedure SetWidth(Value : String); stdcall;
    procedure SetHeight(Value : String); stdcall;
    procedure SetName(Value : String); stdcall;
    procedure SetColor(Value : integer); stdcall;
    procedure SetColorString(Value : String); stdcall;
    procedure SetAlpha(Value : byte); stdcall;
    procedure SetAlphaString(Value : String); stdcall;
    procedure SetShadow(Value : boolean); stdcall;
    procedure SetSize(Value : integer); stdcall;
    procedure SetShadowColor(Value : integer); stdcall;
    procedure SetShadowColorString(Value : String); stdcall;
    procedure SetShadowAlpha(Value : byte); stdcall;
    procedure SetShadowType(Value : TSharpESkinShadowType); stdcall;
    procedure SetDrawText(Value : boolean); stdcall;
    procedure SetClearType(Value : boolean); stdcall;
    procedure SetStyleBold(Value : Boolean); stdcall;
    procedure SetStyleUnderline(Value : Boolean); stdcall;
    procedure SetStyleItalic(Value : Boolean); stdcall;   

    property X : String read GetX write SetX;
    property Y : String read GetY write SetY;
    property XBottom : String read GetXBottom write SetXBottom;
    property YBottom : String read GetYBottom write SetYBottom;    
    property Width : String read GetWidth write SetWidth;
    property Height : String read GetHeight write SetHeight;
    property Name : String read GetName write SetName;
    property Color : integer read GetColor write SetColor;
    property ColorString : String read GetColorString write SetColorString;
    property Alpha : byte read GetAlpha write SetAlpha;
    property AlphaString : string read GetAlphaString write SetAlphaString;
    property Shadow : boolean read GetShadow write SetShadow;
    property Size : integer read GetSize write SetSize;
    property ShadowColor : integer read GetShadowColor write SetShadowColor;
    property ShadowColorString : String read GetShadowColorString write SetShadowColorString;
    property ShadowAlpha : byte read GetShadowAlpha write SetShadowAlpha;
    property ShadowType : TSharpESkinShadowType read GetShadowType write SetShadowType;
    property DrawText : boolean read GetDrawText write SetDrawText;
    property ClearType : boolean read GetClearType write SetClearType;
    property StyleBold : boolean read GetStyleBold write SetStyleBold;
    property StyleUnderline : boolean read GetStyleUnderline write SetStyleUnderline;
    property StyleItalic : boolean read GetStyleItalic write SetStyleItalic;
  end;

  ISharpESkinIcon = interface
    ['{72A854A7-6E6F-4AAA-BAAF-F908375BFDF8}']
    procedure DrawTo(Dst,Src : TBitmap32; x,y : integer); stdcall;
    function GetXY(TextRect: TRect; CompRect: TRect): TPoint; stdcall;

    procedure SetDrawIcon(Value : Boolean); stdcall;
    function GetDrawIcon : Boolean; stdcall;
    function GetDimension : TPoint; stdcall;
    property DrawIcon : Boolean read GetDrawIcon write SetDrawIcon;
    property Dimension : TPoint read GetDimension;
  end;

  ISharpESkinPart = interface
    ['{BD72A54F-944C-46E4-8A54-D41B0307E2BE}']
    procedure DrawTo(Bmp: TBitmap32; Scheme: ISharpEScheme); stdcall;
    function GetDimRect(ps: TRect): TRect; stdcall;
    function GetDimension : TPoint; stdcall;
    function GetEmpty : Boolean; stdcall;
    function GetDrawText : Boolean; stdcall;
    function CreateThemedSkinText : ISharpESkinText; stdcall;
    procedure UpdateDynamicProperties(Scheme : ISharpEScheme); stdcall;

    property Empty : Boolean read GetEmpty;
    property Dimension : TPoint read GetDimension; // Only access for skin parts where it's sure
                                                   // that they have fixed/static values (no strings)
    property DrawText : Boolean read GetDrawText;
  end;

  ISharpESkinPartEx = interface(ISharpESkinPart)
    ['{A99FCC31-D190-4ACA-9051-B846C5F0B1E8}']
    function GetIcon : ISharpESkinIcon; stdcall;
    function GetWidthMod : integer; stdcall;
    procedure UpdateDynamicProperties(Scheme : ISharpEScheme); stdcall;    

    property Icon : ISharpESkinIcon read GetIcon;
    property WidthMod : integer read GetWidthMod;
  end;

  ISharpEEditSkin = interface
    ['{00818CB9-477E-46E5-8FEB-74432607EAC4}']
    function GetAutoDim(r: TRect;  isBarBottom : boolean = false): TRect; stdcall;

    function GetNormal : ISharpESkinPart; stdcall;
    function GetHover  : ISharpESkinPart; stdcall;
    function GetFocus  : ISharpESkinPart; stdcall;

    property Normal : ISharpESkinPart read GetNormal;
    property Hover  : ISharpESkinPart read GetHover;
    property Focus  : ISharpESkinPart read GetFocus;

    function GetDimension : TPoint; stdcall;
    function GetDimensionBottom : TPoint; stdcall;  
    function GetEditXOffsets : TPoint; stdcall;
    function GetEditYOffsets : TPoint; stdcall;
    function GetValid : Boolean; stdcall;    

    property Dimension : TPoint read GetDimension;
    property DimensionBottom : TPoint read GetDimensionBottom;  
    property EditXOffsets : TPoint read GetEditXOffsets;
    property EditYOffsets : TPoint read GetEditYOffsets;
    property Valid : Boolean read GetValid;
  end;

  ISharpEProgressBarSkin = interface
    ['{0276F5EC-FDA8-48B5-8531-D71FD7379CC7}']
    function GetAutoDim(r: TRect; vpos : TSharpEBarAutoPos; isBarBottom : boolean = false): TRect; stdcall;

    function GetBackground      : ISharpESkinPart; stdcall;
    function GetProgress        : ISharpESkinPart; stdcall;
    function GetBackgroundSmall : ISharpESkinPart; stdcall;
    function GetProgressSmall   : ISharpESkinPart; stdcall;

    property Background      : ISharpESkinPart read GetBackground;
    property Progress        : ISharpESkinPart read GetProgress;
    property BackgroundSmall : ISharpESkinPart read GetBackgroundSmall;
    property ProgressSmall   : ISharpESkinPart read GetProgressSmall;

    function GetSmallModeOffset : TPoint; stdcall;
    function GetValid : Boolean; stdcall;

    property SmallModeOffset : TPoint read GetSmallModeOffset;
    property Valid : Boolean read GetValid;
  end;

  ISharpEButtonSkin = interface
    ['{7A6CD2CA-750E-4431-9662-74BCCABDC727}']
    function GetAutoDim(r: TRect): TRect; stdcall;

    function GetNormal : ISharpESkinPartEx; stdcall;
    function GetDown   : ISharpESkinPartEx; stdcall;
    function GetHover  : ISharpESkinPartEx; stdcall;

    property Normal : ISharpESkinPartEx read GetNormal;
    property Down   : ISharpESkinPartEx read GetDown;
    property Hover  : ISHarpESkinPartEx read GetHover;

    function GetLocation : TPoint; stdcall;
    function GetLocationBottom : TPoint; stdcall;  
    function GetValid : Boolean; stdcall;
    function GetWidthMod : integer; stdcall;

    property Location : TPoint read GetLocation;
    property LocationBottom : TPoint read GetLocationBottom;    
    property Valid : Boolean read GetValid;
    property WidthMod : integer read GetWidthMod;
  end;

  ISharpETaskPreviewSkin = interface
    ['{29054221-2F65-4F5C-B801-335EFF69B7AD}']
    function GetBackground : ISharpESkinPartEx; stdcall;
    function GetHover      : ISharpESkinPartEx; stdcall;

    function GetCATBOffset : TPoint; stdcall;
    function GetCALROffset : TPoint; stdcall;
    function GetLocation   : TPoint; stdcall;
    function GetDimension  : TPoint; stdcall;

    property Background : ISharpESkinPartEx read GetBackground;
    property Hover      : ISharpESkinPartEx read GetHover;

    property CATBOffset : TPoint read GetCATBOffset;
    property CALROffset : TPoint read GetCALROffset;
    property Location   : TPoint read GetLocation;
    property Dimension  : TPoint read GetDimension;
  end;  

  ISharpENotifySkin = interface
    ['{D558CFED-A6E5-4B45-A34F-489AAD681B08}']
    function GetBackground : ISharpESkinPartEx; stdcall;
    function GetCATBOffset : TPoint; stdcall;
    function GetCALROffset : TPoint; stdcall;
    function GetLocation   : TPoint; stdcall;
    function GetDimension  : TPoint; stdcall;

    property Background : ISharpESkinPartEx read GetBackground;
    property CATBOffset : TPoint read GetCATBOffset;
    property CALROffset : TPoint read GetCALROffset;
    property Location   : TPoint read GetLocation;
    property Dimension  : TPoint read GetDimension;
  end;

  ISharpEMenuSkin = interface
    ['{56C5D7BC-94BA-4704-A4A4-49355A8C363B}']
    function GetBackground : ISharpESkinPart; stdcall;

    property Background : ISharpESkinPart read GetBackground;

    function GetValid : Boolean; stdcall;
    function GetTBOffset : TPoint; stdcall;
    function GetLROffset : TPoint; stdcall;
    function GetWidthLimit : TPoint; stdcall;
    function GetLocationOffset : TPoint; stdcall;

    property Valid : Boolean read GetValid;
    property TBOffset : TPoint read GetTBOffset;
    property LROffset : TPoint read GetLROffset;
    property WidthLimit : TPoint read GetWidthLimit;
    property LocationOffset : TPoint read GetLocationOffset;
  end;

  ISharpEMenuItemSkin = interface
    ['{F74C37BF-63F7-4194-84F8-12B440D13E3A}']
    function GetSeparator     : ISharpESkinPart; stdcall;
    function GetLabelItem     : ISharpESkinPartEx; stdcall;
    function GetNormalItem    : ISharpESkinPartEx; stdcall;
    function GetHoverItem     : ISharpESkinPartEx; stdcall;
    function GetDownItem      : ISharpESkinPartEx; stdcall;
    function GetNormalSubItem : ISharpESkinPartEx; stdcall;
    function GetHoverSubItem  : ISharpESkinPartEx; stdcall;

    property Separator     : ISharpESkinPart read GetSeparator;
    property LabelItem     : ISharpESkinPartEx read GetLabelItem;
    property NormalItem    : ISharpESkinPartEx read GetNormalItem;
    property HoverItem     : ISharpESkinPartEx read GetHoverItem;
    property DownItem      : ISharpESkinPartEx read GetDownItem;
    property NormalSubItem : ISharpESkinPartEx read GetNormalSubItem;
    property HoverSubItem  : ISharpESkinPartEx read GetHoverSubItem;
  end;

  ISharpEBarSkin = interface
    ['{C583F836-5098-4B7C-BF02-C30F8830CC6A}']
    function GetBar             : ISharpESkinPart; stdcall;
    function GetBarBorder       : ISharpESkinPart; stdcall;
    function GetBarBottom       : ISharpESkinPart; stdcall;
    function GetBarBottomBorder : ISharpESkinPart; stdcall;
    function GetThNormal        : ISharpESkinPart; stdcall;
    function GetThDown          : ISharpESkinPart; stdcall;
    function GetThHover         : ISharpESkinPart; stdcall;

    function GetPTXOffset : TPoint; stdcall;
    function GetPTYOffset : TPoint; stdcall;
    function GetPBXOffset : TPoint; stdcall;
    function GetPBYOffset : TPoint; stdcall;
    function GetPAXOffset : TPoint; stdcall;
    function GetPAYOffset : TPoint; stdcall;
    function GetFSMod     : TPoint; stdcall;
    function GetSBMod     : TPoint; stdcall;
    function GetNCYOffset  : TPoint; stdcall;
    function GetNCTYOffset : TPoint; stdcall;
    function GetNCBYOffset : TPoint; stdcall;

    function GetGlassEffect     : Boolean; stdcall;
    function GetEnableVFlip     : Boolean; stdcall;
    function GetSpecialHideForm : Boolean; stdcall;
    function GetDefaultSkin     : Boolean; stdcall;
    function GetSeed            : integer; stdcall;
    function GetValid           : Boolean; stdcall;
    function GetBarHeight       : integer; stdcall;
    function GetThrobberWidth   : integer; stdcall;

    procedure SetBarBottom; stdcall;
    procedure SetBarTop; stdcall;
    procedure CheckValid; stdcall;
    function GetAutoDim(r: TRect): TRect; stdcall;
    function GetThrobberDim(r: TRect): TRect; stdcall;
    function GetThrobberBottomDim(r: TRect): TRect; stdcall;    

    property Bar             : ISharpESkinPart read GetBar;
    property BarBorder       : ISharpESkinPart read GetBarBorder;
    property BarBottom       : ISharpESkinPart read GetBarBottom;
    property BarBottomBorder : ISharpESkinPart read GetBarBottomBorder;
    property ThNormal        : ISharpESkinPart read GetThNormal;
    property ThDown          : ISharpESkinPart read GetThDown;
    property ThHover         : ISharpESkinPart read GetThHover;

    property PTXOffset : TPoint read GetPTXOffset;
    property PTYOffset : TPoint read GetPTYOffset;
    property PBXOffset : TPoint read GetPBXOffset;
    property PBYOffset : TPoint read GetPBYOffset;
    property PAXOffset : TPoint read GetPAXOffset;
    property PAYOffset : TPoint read GetPAYOffset;
    property FSMod     : TPoint read GetFSMod;
    property SBMod     : TPoint read GetSBMod;
    property NCYOffset  : TPoint read GetNCYOffset;
    property NCTYOffset : TPoint read GetNCTYOffset;
    property NCBYOffset : TPoint read GetNCBYOffset;    

    property GlassEffect     : Boolean read GetGlassEffect;
    property EnableVFlip     : Boolean read GetEnableVFlip;
    property SpecialHideForm : Boolean read GetSpecialHideForm;
    property DefaultSkin     : Boolean read GetDefaultSkin;
    property Seed            : integer read GetSeed;
    property Valid           : Boolean read GetValid;
    property BarHeight       : integer read GetBarHeight;
    property ThrobberWidth   : integer read GetThrobberWidth;
  end;

  ISharpETaskItemStateSkin = interface
    ['{44FCBC3D-AFF3-4E7D-8DC7-E97FB21E4AAD}']
    function GetNormal         : ISharpESkinPartEx; stdcall;
    function GetNormalHover    : ISharpESkinPartEx; stdcall;
    function GetDown           : ISharpESkinPartEx; stdcall;
    function GetDownHover      : ISharpESkinPartEx; stdcall;
    function GetHighlight      : ISharpESkinPartEx; stdcall;
    function GetHighlightHover : ISharpESkinPartEx; stdcall;
    function GetSpecial        : ISharpESkinPartEx; stdcall;
    function GetSpecialHover   : ISharpESkinPartEx; stdcall;

    function GetOverlayText : ISharpESkinText; stdcall;       

    function GetHasSpecial : boolean; stdcall;
    function GetHasOverlay : boolean; stdcall;
    function GetLocation : TPoint; stdcall;
    function GetSpacing : integer; stdcall;
    function GetDimension : TPoint; stdcall;

    function GetHighlightSettings : ISharpESkinHighlightSettings; stdcall;

    property Normal         : ISharpESkinPartEx read GetNormal;
    property NormalHover    : ISharpESkinPartEx read GetNormalHover;
    property Down           : ISharpESkinPartEx read GetDown;
    property DownHover      : ISharpESkinPartEx read GetDownHover;
    property Highlight      : ISharpESkinPartEx read GetHighlight;
    property HighlightHover : ISharpESkinPartEx read GetHighlightHover;
    property Special        : ISharpESkinPartEx read GetSpecial;
    property SpecialHover   : ISharpESkinPartEx read GetSpecialHover;

    property OverlayText : ISharpESkinText read GetOverlayText;
    property HighlightSettings : ISharpESkinHighlightSettings read GetHighlightSettings;

    property HasSpecial : boolean read GetHasSpecial;
    property HasOverlay : boolean read GetHasOverlay;
    property Location : TPoint read GetLocation;
    property Spacing : integer read GetSpacing;
    property Dimension : TPoint read GetDimension;
  end;

  ISharpETaskItemSkin = interface
    ['{69E34A87-A682-4F89-8FC0-1FA636D0A3B4}']
    function GetFull : ISharpETaskItemStateSkin; stdcall;
    function GetCompact : ISharpETaskItemStateSkin; stdcall;
    function GetMini : ISharpETaskItemStateSkin; stdcall;

    function IsValid(tis : TSharpETaskItemStates) : Boolean; stdcall;
    function GetAutoDim(tis : TSharpETaskItemStates; r: TRect): TRect; stdcall;

    property Full : ISharpETaskItemStateSkin read GetFull;
    property Compact : ISharpETaskItemStateSkin read GetCompact;
    property Mini : ISharpETaskItemStateSkin read GetMini;
  end;

  ISharpETaskSwitchSkin = interface
    ['{0E1327DD-E880-43C3-B60B-D0C2AD5B794D}']
    function GetBackground : ISharpESkinPart; stdcall;
    function GetItem       : ISharpESkinPart; stdcall;
    function GetItemHover  : ISharpESkinPart; stdcall;

    function GetItemDimension : TPoint; stdcall;
    function GetItemHoverDimension : TPoint; stdcall;
    function GetItemPreviewLocation : TPoint; stdcall;
    function GetItemPreviewDimension : TPoint; stdcall;
    function GetItemHoverPreviewLocation : TPoint; stdcall;
    function GetItemHoverPreviewDimension : TPoint; stdcall;
    function GetTBOffset : TPoint; stdcall;
    function GetLROffset : TPoint; stdcall;

    function GetWrapCount : integer; stdcall;
    function GetSpacing : integer; stdcall;

    property Background : ISharpESkinPart read GetBackground;
    property Item       : ISharpESkinPart read GetItem;
    property ItemHover  : ISharpESkinPart read GetItemHover;

    property ItemDimension : TPoint read GetItemDimension;
    property ItemHoverDimension : TPoint read GetItemHoverDimension;
    property ItemPreviewLocation : TPoint read GetItemPreviewLocation;
    property ItemPreviewDimension : TPoint read GetItemPreviewDimension;
    property ItemHoverPreviewLocation : TPoint read GetItemHoverPreviewLocation;
    property ItemHoverPreviewDimension : TPoint read GetItemHoverPreviewDimension;
    property TBOffset : TPoint read GetTBOffset;
    property LROffset : TPoint read GetLROffset;

    property WrapCount : integer read GetWrapCount;
    property Spacing   : integer read GetSpacing;
  end;

  ISharpEMiniThrobberSkin = interface
    ['{00C2858E-F1BA-4232-8A4B-3CE489ABF4A5}']
    function GetAutoDim(r: TRect): TRect; stdcall;

    function GetNormal : ISharpESkinPart; stdcall;
    function GetDown   : ISharpESkinPart; stdcall;
    function GetHover  : ISharpESkinPart; stdcall;

    function GetLocation : TPoint; stdcall;
    function GetBottomLocation : TPoint; stdcall;

    function GetValid : Boolean; stdcall;    

    property Normal : ISharpESkinPart read GetNormal;
    property Down   : ISharpESkinPart read GetDown;
    property Hover  : ISharpESkinPart read GetHover;

    property Location : TPoint read GetLocation;
    property BottomLocation : TPoint read GetBottomLocation;

    property Valid : Boolean read GetValid;
  end;

  ISharpESkinDesign = interface
    ['{6541F56E-3F35-4B3D-B67F-CE304B38160F}']
    procedure UpdateDynamicProperties(Scheme : ISharpEScheme); stdcall;

    function GetButtonSkin       : ISharpEButtonSkin; stdcall;
    function GetEditSkin         : ISharpEEditSkin; stdcall;
    function GetProgressBarSkin  : ISharpEProgressBarSkin; stdcall;
    function GetMenuSkin         : ISharpEMenuSkin; stdcall;
    function GetMenuItemSkin     : ISharpEMenuItemSkin; stdcall;
    function GetBarSkin          : ISharpEBarSkin; stdcall;
    function GetNotifySkin       : ISharpENotifySkin; stdcall;
    function GetTaskItemSkin     : ISharpETaskItemSkin; stdcall;
    function GetMiniThrobberSkin : ISharpEMiniThrobberSkin; stdcall;
    function GetTaskPreviewSkin  : ISharpETaskPreviewSkin; stdcall;

    function GetSmallText  : ISharpESkinText; stdcall;
    function GetMediumText : ISharpESkinText; stdcall;
    function GetLargeText  : ISharpESkinText; stdcall;
    function GetOSDText    : ISharpESkinText; stdcall;

    function GetTextPosTL : TPoint; stdcall;
    function GetTextPosBL : TPoint; stdcall;
    function GetTextPosBottomTL : TPoint; stdcall;
    function GetTextPosBottomBL : TPoint; stdcall;

    property Button       : ISharpEButtonSkin read GetButtonSkin;
    property Edit         : ISharpEEditSkin read GetEditSkin;
    property ProgressBar  : ISharpEProgressBarSkin read GetProgressBarSkin;
    property Menu         : ISharpEMenuSkin read GetMenuSkin;
    property MenuItem     : ISharpEMenuItemSkin read GetMenuItemSkin;
    property Bar          : ISharpEBarSkin read GetBarSkin;
    property Notify       : ISharpENotifySkin read GetNotifySkin;
    property TaskItem     : ISharpETaskItemSkin read GetTaskItemSkin;
    property MiniThrobber : ISharpEMiniThrobberSkin read GetMiniThrobberSkin;
    property TaskPreview  : ISharpETaskPreviewSkin read GetTaskPreviewSkin;

    property SmallText  : ISharpESkinText read GetSmallText;
    property MediumText : ISharpESkinText read GetMediumText;
    property LargeText  : ISharpESkinText read GetLargeText;
    property OSDText    : ISharpEskinText read GetOSDText;

    property TextPosTL       : TPoint read GetTextPosTL;
    property TextPosBL       : TPoint read GetTextPosBL;
    property TextPosBottomTL : TPoint read GetTextPosBottomTL;
    property TextPosBottomBL : TPoint read GetTextPosBottomBL;    
  end;  

  ISharpESkin = interface
    ['{4D09397D-B2C1-4940-A6EF-7F33362FAE50}']
    procedure UpdateDynamicProperties(Scheme : ISharpEScheme); stdcall;
  end;

  ISharpESkinManager = interface
    ['{FDC09533-F3A9-49B8-8AC0-C64486537A50}']
    function ParseColor(src : String) : integer; stdcall;

    procedure RefreshControls; stdcall;
    procedure UpdateSkin; stdcall;
    procedure UpdateScheme; stdcall;

    function GetScheme : ISharpEScheme; stdcall;
    function GetSkin : ISharpESkinDesign; stdcall;

    function GetSkinItems : TSharpESkinItems; stdcall;

    function GetDPI : integer; stdcall;
    function GetDPIScaleFactor : double; stdcall;

    function GetBarBottom : boolean; stdcall;
    procedure SetBarBottom(Value : boolean); stdcall;

    property Scheme : ISharpEScheme read GetScheme;
    property Skin : ISharpESkinDesign read GetSkin;

    property SkinItems : TSharpESkinItems read GetSkinItems;

    property BarBottom : boolean read GetBarBottom write SetBarBottom;

    property DPI : integer read GetDPI;
    property DPIScaleFactor : double read GetDPIScaleFactor;
  end;

implementation

end.
