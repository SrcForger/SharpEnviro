{
Source Name: SharpESkin                               
Description: Core Skin loading classes
Copyright (C) Lee Green <Pixol@SharpE-Shell.org>
              Malx (Malx@techie.com)
              Martin Kr�mer <MartinKraemer@gmx.net>

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

unit SharpESkin;

interface

uses
  Classes,
  Graphics,
  Forms,
  SysUtils,
  Dialogs,
  Contnrs,
  gr32,
  JclSimpleXML,
  SystemFontList,
  types,
  ISharpESkinComponents,
  SharpESkinPart,
  SharpEBitmapList,
  SharpEBase,
  SharpEScheme,
  Math,
  SharpTypes;

type
  TSharpESkinDesign = class;
  TSharpEButtonSkin = class;
  TSharpEBarSkin = class;
  TSharpEProgressBarSkin = class;
  TSharpEMiniThrobberSkin = class;
  TSharpEEditSkin = class;
  TSharpETaskItemSkin = class;
  TSharpEMenuSkin = class;
  TSharpEMenuItemSkin = class;
  TSharpENotifySkin = class;
  TSharpETaskPreviewSkin = class;
  TSkinEvent = procedure of object;

  TSkinName = string;
  TXmlFileName = string;    
  TSkinFileName = string;

  TSharpESkinDesign = class(TInterfacedObject, ISharpESkinDesign)
  private
    FDefaultDesign: boolean;
    FName: String;
    FSelfInterface : ISharpESkinDesign;

    FBitmapList: TSkinBitmapList;

    FTextPosTL : TSkinPoint;
    FTextPosBL : TSkinPoint;
    FTextPosBottomTL : TSkinPoint;
    FTextPosBottomBL : TSkinPoint;

    FSkinText: TSkinText;

    FLoadSkins : TSharpESkinItems;

    FSmallText  : TSkinText;
    FMediumText : TSkinText;
    FLargeText  : TSkinText;
    FOSDText    : TSkinText;

    FSmallTextInterface  : ISharpESkinText;
    FMediumTextInterface : ISharpESkinText;
    FLargeTextInterface  : ISharpESkinText;
    FOSDTextInterface    : ISharpESkinText;
    
    FButtonSkin       : TSharpEButtonSkin;
    FEditSkin         : TSharpEEditSkin;
    FProgressBarSkin  : TSharpEProgressBarSkin;
    FMenuSkin         : TSharpEMenuSkin;
    FMenuItemSkin     : TSharpEMenuItemSkin;
    FBarSkin          : TSharpEBarSkin;
    FNotifySkin       : TSharpENotifySkin;
    FTaskItemSkin     : TSharpETaskItemSkin;
    FMiniThrobberSkin : TSharpEMiniThrobberSkin;
    FTaskPreviewSkin  : TSharpETaskPreviewSkin;

    FButtonInterface       : ISharpEButtonSkin;
    FEditInterface         : ISharpEEditSkin;
    FProgressBarInterface  : ISharpEProgressBarSkin;
    FMenuInterface         : ISharpEMenuSkin;
    FMenuItemInterface     : ISharpEMenuItemSkin;
    FBarInterface          : ISharpEBarSkin;
    FNotifyInterface       : ISharpENotifySkin;
    FTaskItemInterface     : ISharpETaskItemSkin;
    FMiniThrobberInterface : ISharpEMiniThrobberSkin;
    FTaskPreviewInterface  : ISharpETaskPreviewSkin;

    function GetIsDefaultDesign  : boolean; stdcall;

    function GetButtonSkin       : ISharpEButtonSkin; stdcall;
    function GetEditSkin         : ISharpEEditSkin; stdcall;
    function GetProgressBarSkin  : ISharpEProgressBarSkin; stdcall;
    function GetMenuSkin         : ISharpEMenuSkin; stdcall;
    function GetMenuItemSkin     : ISharpEMenuItemSkin; stdcall;
    function GetBarSkin          : ISharpEbarskin; stdcall;
    function GetNotifySkin       : ISharpENotifySkin; stdcall;
    function GetTaskItemSkin     : ISharpETaskItemSkin; stdcall;
    function GetMiniThrobberSkin : ISharpEMiniThrobberSkin; stdcall;
    function GetTaskPreviewSkin  : ISharpETaskPreviewSkin; stdcall;

    function GetSmallText  : ISharpESkinText; stdcall;
    function GetMediumText : ISharpESkinText; stdcall;
    function GetLargeText  : ISharpESkinText; stdcall;
    function GetOSDText    : ISharpESkinText; stdcall;

    function GetTextPosTL       : TPoint; stdcall;
    function GetTextPosBL       : TPoint; stdcall;
    function GetTextPosBottomTL : TPoint; stdcall;
    function GetTextPosBottomBL : TPoint; stdcall;

    function GetName : String; stdcall; 
  protected
  public
    constructor Create; overload;
    constructor Create(Skins: TSharpESkinItems); reintroduce; overload;
    destructor Destroy; override;

    procedure Clear;
    procedure Assign(src : TSharpESkinDesign);

    procedure LoadFromXml(xml: TJclSimpleXMLElem; path : String); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;

    procedure SaveToStream(Stream: TStream); overload; virtual;
    procedure SaveToStream(Stream: TStream; SaveBitmap:boolean); overload; virtual;        

    procedure RemoveNotUsedBitmaps;
    procedure UpdateDynamicProperties(Scheme : ISharpEScheme); stdcall;

    property IsDefaultDesign: boolean read GetIsDefaultDesign;
    property SelfInterface : ISharpESkinDesign read FSelfInterface write FSelfInterface;    

    property BitmapList: TSkinBitmapList read FBitmapList write FBitmapList;

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
    property OSDText    : ISharpESkinText read GetOSDText;

    property TextPosTL       : TPoint read GetTextPosTL;
    property TextPosBL       : TPoint read GetTextPosBL;
    property TextPosBottomTL : TPoint read GetTextPosBottomTL;
    property TextPosBottomBL : TPoint read GetTextPosBottomBL;

    property Name : String read GetName;

    property BarSkin: TSharpEBarSkin read FBarSkin;
  end;

  TSharpESkin = class(TInterfacedObject, ISharpESkin)
  private
    FSkinName: TSkinName;
    FSkinDesigns: TObjectList;

    FSkinVersion: Double;
    FLoadSkins : TSharpESkinItems;

    FXml: TJclSimpleXml;
    FXmlFileName: TXmlFileName;

    FOnNotify: TSkinEvent;    

    function GetSkinDesigns : TObjectList;

    procedure SetXmlFileName(const Value: TXmlFileName);
    procedure SetSkinName(const Value: TSkinName);

  protected
  public
    constructor Create; overload;
    constructor Create(Skins: TSharpESkinItems); reintroduce; overload;
    destructor Destroy; override;

    procedure Clear;

    procedure ClearSkinDesigns;
    function GetDefaultSkinDesign : TSharpESkinDesign;
    
    procedure LoadFromXmlFile(filename: string); virtual;
    procedure LoadFromSkin(filename: string); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;

    procedure SaveToSkin(filename: string); virtual;
    procedure SaveToStream(Stream: TStream); overload; virtual;
    procedure SaveToStream(Stream: TStream; SaveBitmap:boolean); overload; virtual;

    procedure RemoveNotUsedBitmaps;
    procedure UpdateDynamicProperties(Scheme : ISharpEScheme); stdcall;

    procedure FreeInstance; override;

    property SkinDesigns : TObjectList read GetSkinDesigns;

    property XmlFilename: TXmlFileName read FXmlFileName write SetXmlFileName;
    property Skin: TSkinName read FSkinName write SetSkinName;

    property OnNotify: TSkinEvent read FOnNotify write FOnNotify;    
  end;

  TSharpETaskItemState = class(TInterfacedObject, ISharpETaskItemStateSkin)
  private
    FNormal         : TSkinPartEx;
    FNormalHover    : TSkinPartEx;
    FDown           : TSkinPartEx;
    FDownHover      : TSkinPartEx;
    FHighlight      : TSkinPartEx;
    FHighlightHover : TSkinPartEx;
    FSpecial        : TSkinPartEx;
    FSpecialHover   : TSkinPartEx;

    FOverlayText : TSkinText;
    FOverlayTextInterface : ISharpESkinText;

    FNormalInterface         : ISharpESkinPartEx;
    FNormalHoverInterface    : ISharpESkinPartEx;
    FDownInterface           : ISharpESkinPartEx;
    FDownHoverInterface      : ISharpESkinPartEx;
    FHighlightInterface      : ISharpESkinPartEx;
    FHighlightHoverInterface : ISharpESkinPartEx;
    FSpecialInterface        : ISharpESkinPartEx;
    FSpecialHoverInterface   : ISharpESkinPartEx;

    FHasOverlay     : boolean;
    FHasSpecial     : boolean;
    FSpacing        : integer;
    FSkinDim        : TSkinDim;

    FHighlightSettings : TSharpESkinHighlightSettings;
    FHighlightSettingsInterface: ISharpESkinHighlightSettings;

    function GetHighlightSettings : ISharpESkinHighlightSettings; stdcall;

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
  public
    constructor Create(BmpList : TSkinBitmapList); reintroduce;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(src : TSharpETaskItemState);
    procedure UpdateDynamicProperties(cs: ISharpEScheme);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);    

    property SkinDim : TSkinDim read FSkinDim;

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

  TSharpETaskItemSkin = class(TInterfacedObject, ISharpETaskItemSkin)
  private
    FFull    : TSharpETaskItemState;
    FCompact : TSharpETaskItemState;
    FMini    : TSharpETaskItemState;

    FFullInterface : ISharpETaskItemStateSkin;
    FCompactInterface : ISharpETaskItemStateSkin;
    FMiniInterface : ISharpETaskItemStateSkin;

    function GetFull : ISharpETaskItemStateSkin; stdcall;
    function GetCompact : ISharpETaskItemStateSkin; stdcall;
    function GetMini : ISharpETaskItemStateSkin; stdcall;    
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(src : TSharpETaskItemSkin);
    function IsValid(tis : TSharpETaskItemStates) : boolean; stdcall;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    function GetAutoDim(tis : TSharpETaskItemStates; r: TRect): TRect; stdcall;
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property Full : ISharpETaskItemStateSkin read GetFull;
    property Compact : ISharpETaskItemStateSkin read GetCompact;
    property Mini : ISharpETaskItemStateSkin read GetMini;
  end;

  TSharpETaskPreviewSkin = class(TInterfacedObject, ISharpETaskPreviewSkin)
  private
    FSkinDim    : TSkinDim;
    FCATBOffset : TSkinPoint;
    FCALROffset : TSkinPoint;

    FBackground : TSkinPartEx;
    FHover      : TSkinPartEx;

    FBackgroundInterface : ISharpESkinPartEx;
    FHoverInterface      : ISharpESkinPartEx;
    
    function GetBackground : ISharpESkinPartEx; stdcall;
    function GetHover      : ISharpESkinPartEx; stdcall;

    function GetCATBOffset : TPoint; stdcall;
    function GetCALROffset : TPoint; stdcall;
    function GetLocation   : TPoint; stdcall;
    function GetDimension  : TPoint; stdcall;    
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(src : TSharpETaskPreviewSkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property SkinDim : TSkinDim read FSkinDim;

    property Background : ISharpESkinPartEx read GetBackground;
    property Hover      : ISharpESkinPartEx read GetHover;
    property CATBOffset : TPoint read GetCATBOffset;
    property CALROffset : TPoint read GetCALROffset;
    property Location   : TPoint read GetLocation;
    property Dimension  : TPoint read GetDimension;
  end;

  TSharpENotifySkin = class(TInterfacedObject, ISharpENotifySkin)
  private
    FSkinDim    : TSkinDim;
    FCATBOffset : TSkinPoint;
    FCALROffset : TSkinPoint;
    FBackground : TSkinPartEx;
    FBackgroundInterface : ISharpESkinPartEx;
    
    function GetBackground : ISharpESkinPartEx; stdcall;
    function GetCATBOffset : TPoint; stdcall;
    function GetCALROffset : TPoint; stdcall;
    function GetLocation   : TPoint; stdcall;
    function GetDimension  : TPoint; stdcall;    
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(src: TSharpENotifySkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property SkinDim : TSkinDim read FSkinDim;

    property Background : ISharpESkinPartEx read GetBackground;
    property CATBOffset : TPoint read GetCATBOffset;
    property CALROffset : TPoint read GetCALROffset;
    property Location   : TPoint read GetLocation;
    property Dimension  : TPoint read GetDimension;
  end;

  TSharpEMenuSkin = class(TInterfacedObject, ISharpEMenuSkin)
  private
    FSkinDim    : TSkinDim;

    FBackground : TSkinPart;
    FBackgroundInterface : ISharpESkinPart;
    
    FTBOffset   : TSkinPoint;
    FLROffset   : TSkinPoint;
    FWidthLimit : TSkinPoint;
    
    function GetBackground : ISharpESkinPart; stdcall;
    function GetValid : Boolean; stdcall;
    function GetTBOffset : TPoint; stdcall;
    function GetLROffset : TPoint; stdcall;
    function GetWidthLimit : TPoint; stdcall;
    function GetLocationOffset : TPoint; stdcall;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(src : TSharpEMenuSkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property Background : ISharpESkinPart read GetBackground;
    property Valid : Boolean read GetValid;
    property TBOffset : TPoint read GetTBOffset;
    property LROffset : TPoint read GetLROffset;
    property WidthLimit : TPoint read GetWidthLimit;
    property LocationOffset : TPoint read GetLocationOffset;
  end;

  TSharpEMenuItemSkin = class(TInterfacedObject, ISharpEMenuItemSkin)
  private
    FSkinDim       : TSkinDim;
    FSeparator     : TSkinPart;
    FLabelItem     : TSkinPartEx;
    FNormalItem    : TSkinPartEx;
    FHoverItem     : TSkinPartEx;
    FDownItem      : TSkinPartEx;
    FNormalSubItem : TSkinPartEx;
    FHoverSubItem  : TSkinPartEx;

    FSeparatorInterface     : ISharpESkinPart;
    FLabelItemInterface     : ISharpESkinPartEx;
    FNormalItemInterface    : ISharpESkinPartEx;
    FHoverItemInterface     : ISharpESkinPartEx;
    FDownItemInterface      : ISharpESkinPartEx;
    FNormalSubItemInterface : ISharpESkinPartEx;
    FHoverSubItemInterface  : ISharpESkinPartEx;

    function GetSeparator     : ISharpESkinPart; stdcall;
    function GetLabelItem     : ISharpESkinPartEx; stdcall;
    function GetNormalItem    : ISharpESkinPartEx; stdcall;
    function GetHoverItem     : ISharpESkinPartEx; stdcall;
    function GetDownItem      : ISharpESkinPartEx; stdcall;
    function GetNormalSubItem : ISharpESkinPartEx; stdcall;
    function GetHoverSubItem  : ISharpESkinPartEx; stdcall;    
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(src : TSharpEMenuItemSkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property Separator     : ISharpESkinPart read GetSeparator;
    property LabelItem     : ISharpESkinPartEx read GetLabelItem;
    property NormalItem    : ISharpESkinPartEx read GetNormalItem;
    property HoverItem     : ISharpESkinPartEx read GetHoverItem;
    property DownItem      : ISharpESkinPartEx read GetDownItem;
    property NormalSubItem : ISharpESkinPartEx read GetNormalSubItem;
    property HoverSubItem  : ISharpESkinPartEx read GetHoverSubItem;
  end;

  TSharpEButtonSkin = class(TInterfacedObject, ISharpEButtonSkin)
  private
    FSkinDim : TSkinDim;
    FSkinDimBottom : TSkinDim;
    
    FNormal  : TSkinPartEx;
    FDown    : TSkinPartEx;
    FHover   : TSkinPartEx;

    FNormalInterface : ISharpESkinPartEx;
    FDownInterface   : ISharpESkinPartEx;
    FHoverInterface  : ISharpESkinPartEx;

    FWidthMod : integer;

    function GetNormal : ISharpESkinPartEx; stdcall;
    function GetDown   : ISharpESkinPartEx; stdcall;
    function GetHover  : ISharpESkinPartEx; stdcall;

    function GetWidthMod : integer; stdcall;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Src : TSharpEButtonSkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    function GetAutoDim(r: TRect): TRect;  stdcall;
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property WidthMod: integer read GetWidthMod;

    property Normal : ISharpESkinPartEx read GetNormal;
    property Down   : ISharpESkinPartEx read GetDown;
    property Hover  : ISharpESkinPartEx read GetHover;

    property SkinDim: TSkinDim read FSkinDim;
    property SkinDimBottom : TSkinDim read FSkinDimBottom;

    function GetLocation : TPoint; stdcall;
    function GetLocationBottom : TPoint; stdcall;
    function GetValid : Boolean; stdcall;
    property Location : TPoint read GetLocation;
    property LocationBottom : TPoint read GetLocationBottom;
    property Valid : Boolean read GetValid;
 end;

  TSharpEProgressBarSkin = class(TInterfacedObject, ISharpEProgressBarSkin)
  private
    FSkinDim: TSkinDim;
    FSkinDimTL: TSkinDim;
    FSkinDimBL: TSkinDim;
    FSkinDimBottom: TSkinDim;
    FSkinDimBottomTL: TSkinDim;
    FSkinDimBottomBL: TSkinDim;

    FBackground      : TSkinPart;
    FBackgroundSmall : TSkinPart;
    FProgress        : TSkinPart;
    FProgressSmall   : TSkinPart;

    FBackgroundInterface      : ISharpESkinPart;
    FBackgroundSmallInterface : ISharpESkinPart;
    FProgressInterface        : ISharpESkinPart;
    FProgressSmallInterface   : ISharpESkinPart;

    FSmallModeOffset: TSkinPoint;
    function GetBackground      : ISharpESkinPart; stdcall;
    function GetProgress        : ISharpESkinPart; stdcall;
    function GetBackgroundSmall : ISharpESkinPart; stdcall;
    function GetProgressSmall   : ISharpESkinPart; stdcall;

    function GetSmallModeOffset : TPoint; stdcall;
    function GetValid : Boolean; stdcall;    
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Src : TSharpEProgressBarSkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    function GetAutoDim(r: TRect; vpos : TSharpEBarAutoPos; isBarBottom : boolean = false): TRect; stdcall;
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property Background      : ISharpESkinPart read GetBackground;
    property BackgroundSmall : ISharpESkinPart read GetBackgroundSmall;
    property Progress        : ISharpESkinPart read GetProgress;
    property ProgressSmall   : ISharpESkinPart read GetProgressSmall;

    property SmallModeOffset : TPoint read GetSmallModeOffset;
    property Valid : Boolean read GetValid;
  end;

  TSharpEBarSkin = class(TInterfacedObject,ISharpEBarSkin)
  private
    FSkinDim: TSkinDim;
    FThDim: TSkinDim;
    FThBDim: TSkinDim;

    FThNormal        : TSkinPart;
    FThDown          : TSkinPart;
    FThHover         : TSkinPart;
    FBar             : TSkinPart;
    FBarBorder       : TSkinPart;
    FBarBottom       : TSkinPart;
    FBarBottomBorder : TSkinPart;

    FThNormalInterface        : ISharpESkinPart;
    FThDownInterface          : ISharpESkinPart;
    FThHoverInterface         : ISharpESkinPart;
    FBarInterface             : ISharpESkinPart;
    FBarBorderInterface       : ISharpESkinPart;
    FBarBottomInterface       : ISharpESkinPart;
    FBarBottomBorderInterface : ISharpESkinPart;

    FFSMod: TSkinPoint;
    FSBMod: TSkinPoint;
    FSeed: integer;
    FEnableVFlip: boolean;
    FSpecialHideForm: boolean;
    FDefaultSkin: boolean;
    FGlassEffect: boolean;
    FPAXoffset : TSkinPoint;
    FPAYoffset : TSkinPoint;
    FPTXoffset : TSkinPoint;
    FPTYoffset : TSkinPoint;
    FPBXoffset : TSkinPoint;
    FPBYoffset : TSkinPoint;
    FNCYOffset  : TSkinPoint;
    FNCTYOffset : TSkinPoint;
    FNCBYOffset : TSkinPoint;
    function GetBar             : ISharpESkinPart; stdcall;
    function GetBarBorder       : ISharpESkinPart; stdcall;
    function GetBarBottom       : ISharpESkinPart; stdcall;
    function GetBarBottomBorder : ISharpESkinPart; stdcall;
    function GetThNormal        : ISharpESkinPart; stdcall;
    function GetThDown          : ISharpESkinPart; stdcall;
    function GetThHover         : ISharpESkinPart; stdcall;

    function GetPTXOffset  : TPoint; stdcall;
    function GetPTYOffset  : TPoint; stdcall;
    function GetPBXOffset  : TPoint; stdcall;
    function GetPBYOffset  : TPoint; stdcall;
    function GetPAXOffset  : TPoint; stdcall;
    function GetPAYOffset  : TPoint; stdcall;
    function GetFSMod      : TPoint; stdcall;
    function GetSBMod      : TPoint; stdcall;
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
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Src : TSharpEBarSkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure NewSeed;
    procedure CheckValid; stdcall;
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    function GetAutoDim(r: TRect): TRect; stdcall;
    function GetThrobberDim(r: TRect): TRect; stdcall;
    function GetThrobberBottomDim(r: TRect): TRect; stdcall;
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    procedure SetBarBottom; stdcall;
    procedure SetBarTop; stdcall;    

    property Bar             : ISharpESkinPart read GetBar;
    property BarBorder       : ISharpESkinPart read GetBarBorder;
    property BarBottom       : ISharpESkinPart read GetBarBottom;
    property BarBottomBorder : ISharpESkinPart read GetBarBottomBorder;
    property ThNormal        : ISharpESkinPart read GetThNormal;
    property ThDown          : ISharpESkinPart read GetThDown;
    property ThHover         : ISharpESkinPart read GetThHover;

    property PTXOffset  : TPoint read GetPTXOffset;
    property PTYOffset  : TPoint read GetPTYOffset;
    property PBXOffset  : TPoint read GetPBXOffset;
    property PBYOffset  : TPoint read GetPBYOffset;
    property PAXOffset  : TPoint read GetPAXOffset;
    property PAYOffset  : TPoint read GetPAYOffset;
    property FSMod : TPoint read GetFSMod;
    property SBMod : TPoint read GetSBMod;
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

  TSharpEEditSkin = class(TInterfacedObject, ISharpEEditSkin)
  private
    FSkinDim: TSkinDim;
    FSkinDimBottom: TSkinDim;

    FNormal: TSkinPart;
    FFocus: TSkinPart;
    FHover : TSkinPart;

    FNormalInterface : ISharpESkinPart;
    FHoverInterface  : ISharpESkinPart;
    FFocusInterface  : ISharpESkinPart;

    FEditXOffsets : TSkinPoint;
    FEditYOffsets : TSkinPoint;
    
    function GetNormal : ISharpESkinPart; stdcall;
    function GetHover  : ISharpESkinPart; stdcall;
    function GetFocus  : ISharpESkinPart; stdcall;
    function GetDimension : TPoint; stdcall;
    function GetDimensionBottom : TPoint; stdcall;    
    function GetEditXOffsets : TPoint; stdcall;
    function GetEditYOffsets : TPoint; stdcall;
    function GetValid : Boolean; stdcall;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(src : TSharpEEditSkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    function GetAutoDim(r: TRect; isBarBottom : boolean = false): TRect; stdcall;
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property Normal : ISharpESkinPart read GetNormal;
    property Hover  : ISharpESkinPart read GetHover;
    property Focus  : ISharpESkinPart read GetFocus;

    property Dimension : TPoint read GetDimension;
    property DimensionBottom : TPoint read GetDimensionBottom;    
    property EditXOffsets : TPoint read GetEditXOffsets;
    property EditYOffsets : TPoint read GetEditYOffsets;
    property Valid : Boolean read GetValid;

    property SkinDim : TSkinDim read FSkinDim;
  end;

  TSharpEMiniThrobberSkin = class(TInterfacedObject, ISharpEMiniThrobberSkin)
  private
    FSkinDim: TSkinDim;
    FBottomSkinDim : TSkinDim;

    FNormal: TSkinPart;
    FDown: TSkinPart;
    FHover: TSkinPart;

    FNormalInterface : ISharpESkinPart;
    FDownInterface   : ISharpESkinPart;
    FHoverInterface  : ISharpESkinPart;
    
    function GetNormal : ISharpESkinPart; stdcall;
    function GetDown   : ISharpESkinPart; stdcall;
    function GetHover  : ISharpESkinPart; stdcall;

    function GetLocation : TPoint; stdcall;
    function GetBottomLocation : TPoint; stdcall;

    function GetValid : Boolean; stdcall;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(src : TSharpEMiniThrobberSkin);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    function GetAutoDim(r: TRect): TRect; stdcall;
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property Normal : ISharpESkinPart read GetNormal;
    property Down   : ISharpESkinPart read GetDown;
    property Hover  : ISharpESkinPart read GetHover;

    property Location : TPoint read GetLocation;
    property BottomLocation : TPoint read GetBottomLocation;

    property Valid : Boolean read GetValid;
    
    property SkinDim : TSkinDim read FSkinDim;
    property BottomSkinDim : TSkinDim read FBottomSkinDim;
  end;

var
  FontList : TFontList;


implementation

uses SharpESkinManager,
     SharpApi,
     gr32_png;

//***************************************
//* TSharpESkin
//***************************************

constructor TSharpESkin.Create;
begin
  Create(ALL_SHARPE_SKINS);
end;

constructor TSharpESkin.Create(Skins: TSharpESkinItems);
begin
  inherited Create;

  if FontList = nil then
    FontList := TFontList.Create;

  FontList.RefreshFontInfo;

  FSkinDesigns := TObjectList.Create(True);

  FLoadSkins := Skins;

  FXml := TJclSimpleXml.Create;
end;

destructor TSharpESkin.Destroy;
begin
  FXml.Free;

  ClearSkinDesigns;
  FSkinDesigns.Free;

  if FontList <> nil then
  begin
    FontList.Free;
    FontList := nil;
  end;

  inherited;
end;

procedure TSharpESkin.ClearSkinDesigns;
var
  Skin : TSharpESkinDesign;
  n : integer;
begin
  for n := FSkinDesigns.Count - 1 downto 0 do
  begin
    Skin := TSharpESkinDesign(FSkinDesigns.Items[n]);
    FSkinDesigns.Extract(Skin);
    Skin.SelfInterface := nil;
    // make sure to really free all instances
    while Skin.RefCount > 0 do
      Skin._Release;
  end;
end;

procedure TSharpESkin.RemoveNotUsedBitmaps;
var
  n : integer;
begin
  for n := 0 to FSkinDesigns.Count - 1 do
    TSharpESkinDesign(FSkinDesigns.Items[n]).RemoveNotUsedBitmaps;
end;

procedure TSharpESkin.UpdateDynamicProperties(Scheme : ISharpEScheme);
var
  n : integer;
begin
  for n := 0 to FSkinDesigns.Count - 1 do
    TSharpESkinDesign(FSkinDesigns.Items[n]).UpdateDynamicProperties(Scheme);
end;

procedure TSharpESkin.SaveToStream(Stream: TStream);
begin
  SaveToStream(Stream, true);
end;

procedure TSharpESkin.LoadFromSkin(filename: string);
var FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TSharpESkin.SaveToSkin(filename: string);
var FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;
   
procedure TSharpESkin.LoadFromStream(Stream: TStream);
var
  temp : String;
  designCount : integer;
  n : integer;
  Skin : TSharpESkinDesign;
begin
  Stream.ReadBuffer(FSkinVersion, sizeof(FSkinVersion));
  if (floor(FSkinVersion) <> 2) then
    exit;
  temp := StringLoadFromStream(Stream);
  if temp <> '' then
    FSkinName := temp;
  Stream.ReadBuffer(designCount,SizeOf(designCount));

  for n := 0 to designCount - 1 do
  begin
    Skin := TSharpESkinDesign.Create(FLoadSkins);
    Skin.LoadFromStream(Stream);
    FSkinDesigns.Add(Skin);
  end;
end;

procedure TSharpESkin.Clear();
begin
  FSkinName := '';
  ClearSkinDesigns;
end;

procedure TSharpESkin.LoadFromXMLFile(filename : string);
var
  Path: string;
  n : integer;
  DefaultSkin, Skin : TSharpESkinDesign;
begin
  if FontList <> nil then
    FontList.RefreshFontInfo;

  SkinDesigns.Clear;

  try
    Path := ExtractFilePath(filename);
    Fxml.LoadFromFile(filename);
    if FXml.Root.Items.Count = 0 then
      exit;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpESkin','Error loading skin from file: ' + filename,clred,DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpESkin',E.Message,clred,DMT_ERROR);
      Clear;
      Skin := TSharpESkinDesign.Create(FLoadSkins);
      if Skin.BarSkin <> nil then
         Skin.BarSkin.CheckValid;
      SkinDesigns.Add(Skin);
      exit;
    end;
  end;

  Clear;

  // interate over all skin designs and find the default skin
  DefaultSkin := nil;
  for n := 0 to Fxml.Root.Items.Count - 1 do
  begin
    if Fxml.Root.Items.Item[n].Properties.BoolValue('default',False) then
    begin
      DefaultSkin := TSharpESkinDesign.Create(FLoadSkins);
      DefaultSkin.LoadFromXML(Fxml.Root.Items.Item[n],Path);
      SkinDesigns.Add(DefaultSkin);
      break;
    end;
  end;

  // load all other skin designs
  for n := 0 to Fxml.Root.Items.Count - 1 do
  begin
    if not (Fxml.Root.Items.Item[n].Properties.BoolValue('default',False)) then
    begin
      Skin := TSharpESkinDesign.Create(FLoadSkins);
      if (DefaultSkin <> nil) then
        Skin.Assign(DefaultSkin);
      Skin.LoadFromXml(Fxml.Root.Items.Item[n],Path);
      SkinDesigns.Add(Skin);
    end;
  end;
end;

//***************************************
//* TSharpESkinDesign
//***************************************

constructor TSharpESkinDesign.Create;
begin
  Create(ALL_SHARPE_SKINS);
end;

constructor TSharpESkinDesign.Create(Skins: TSharpESkinItems);
begin
  inherited Create;

  FName := 'Default';
  FDefaultDesign := True;

  if FBitmaplist = nil then
    FBitmapList := TSkinBitmapList.Create;  

  FLoadSkins := Skins;

  if scButton in FLoadSkins then
  begin
    FButtonSkin := TSharpEButtonSkin.create(FBitmapList);
    FButtonInterface := FButtonSkin;
  end;
  if scProgressBar in FLoadSkins then
  begin
    FProgressBarSkin := TSharpEProgressBarSkin.create(FBitmapList);
    FProgressBarInterface := FProgressBarSkin;
  end;
  if scBar in FLoadSkins then
  begin
    FBarSkin := TSharpEBarSkin.create(FBitmapList);
    FBarInterface := FBarSkin;
  end;
  if scTaskItem in FLoadSkins then
  begin
    FTaskItemSkin := TSharpeTaskItemSkin.Create(FBitmapList);
    FTaskItemInterface := FTaskItemSkin;
  end;
  FSkinText := TSkinText.Create(True);

  FSmallText  := TSkinText.Create(False);
  FMediumText := TSkinText.Create(False);
  FLargeText  := TSkinText.Create(False);
  FOSDText    := TSkinText.Create(False);

  FSmallTextInterface := FSmallText;
  FMediumTextInterface := FMediumText;
  FLargeTextInterface  := FLargeText;
  FOSDTextInterface    := FOSDText;

  FTextPosTL  := TSkinPoint.Create;
  FTextPosBL  := TSkinPoint.Create;
  FTextPosBottomTL  := TSkinPoint.Create;
  FTextPosBottomBL  := TSkinPoint.Create;  
  if scMiniThrobber in FLoadSkins then
  begin
    FMiniThrobberSkin := TSharpEMiniThrobberSkin.Create(FBitmapList);
    FMiniThrobberInterface := FMiniThrobberSkin;
  end;
  if scEdit in FLoadSkins then
  begin
    FEditSkin := TSharpEEditSkin.Create(FBitmapList);
    FEditInterface := FEditSkin;
  end;
  if scMenu in FLoadSkins then
  begin
    FMenuSkin := TSharpEMenuSkin.Create(FBitmapList);
    FMenuInterface := FMenuSkin;
  end;
  if scMenuItem in FLoadSkins then
  begin
    FMenuItemSkin := TSharpEMenuItemSkin.Create(FBitmapList);
    FMenuItemInterface := FMenuItemSkin;
  end;
  if scNotify in FLoadSkins then
  begin
    FNotifySkin := TSharpENotifySkin.Create(FBitmapList);
    FNotifyInterface := FNotifySkin;
  end;
  if scTaskPreview in FLoadSkins then
  begin
    FTaskPreviewSkin := TSharpETaskPreviewSkin.Create(FBitmapList);
    FTaskPreviewInterface := FTaskPreviewSkin;
  end;

  FSelfInterface := self;
end;

destructor TSharpESkinDesign.Destroy;
begin
  if FButtonSkin <> nil then
  begin
    FButtonInterface := nil;
    FButtonSkin := nil;
  end;
  if FProgressBarSkin <> nil then
  begin
    FProgressBarInterface := nil;
    FProgressBarSkin := nil;
  end;
  if FBarSkin <> nil then
  begin
    FBarInterface := nil;
    FBarSkin := nil;
  end;
  if FTaskItemSkin <> nil then
  begin
    FTaskItemInterface := nil;
    FTaskItemSkin := nil;
  end;
  FSkinText.SelfInterface := nil;

  FSmallTextInterface := nil;
  FMediumTextInterface := nil;
  FLargeTextInterface := nil;
  FOSDTextInterface := nil;

  FTextPosTL.Free;
  FTextPosBL.Free;
  FTextPosBottomTL.Free;
  FTextPosBottomBL.Free;  
  if FMiniThrobberSkin <> nil then
  begin
    FMiniThrobberInterface := nil;
    FMiniThrobberSkin := nil;
  end;
  if FEditSkin <> nil then
  begin
    FEditInterface := nil;
    FEditSkin := nil;
  end;
  if FMenuSkin <> nil then
  begin
    FMenuInterface := nil;
    FMenuSkin := nil;
  end;
  if FMenuItemSkin <> nil then
  begin
    FMenuItemInterface := nil;
    FMenuItemSkin := nil;
  end;
  if FNotifySkin <> nil then
  begin
    FNotifyInterface := nil;
    FNotifySkin := nil;
  end;
  if FTaskPreviewSkin <> nil then
  begin
    FTaskPreviewInterface := nil;
    FTaskPreviewSkin := nil;
  end;

  FBitmapList.Free;

  inherited;
end;

procedure TSharpESkinDesign.UpdateDynamicProperties(Scheme : ISharpEScheme);
begin
  if FButtonSkin <> nil then FButtonSkin.UpdateDynamicProperties(Scheme);
  if FProgressBarskin <> nil then FProgressBarSkin.UpdateDynamicProperties(Scheme);
  if FBarSkin <> nil then FBarSkin.UpdateDynamicProperties(Scheme);
  if FTaskItemSkin <> nil then FTaskItemSkin.UpdateDynamicProperties(Scheme);
  if FMiniThrobberSkin <> nil then FMiniThrobberSkin.UpdateDynamicProperties(Scheme);
  if FEditSkin <> nil then FEditSkin.UpdateDynamicProperties(Scheme);
  if FMenuSkin <> nil then FMenuSkin.UpdateDynamicProperties(Scheme);
  if FMenuItemSkin <> nil then FMenuItemSkin.UpdateDynamicProperties(Scheme);
  if FNotifySkin <> nil then FNotifySkin.UpdateDynamicProperties(Scheme);
  if FTaskPreviewSkin <> nil then FTaskPreviewSkin.UpdateDynamicProperties(Scheme);


  FSkinText.UpdateDynamicProperties(Scheme);
  FSmallText.UpdateDynamicProperties(Scheme);
  FMediumText.UpdateDynamicProperties(Scheme);
  FLargeText.UpdateDynamicProperties(Scheme);
  FOSDText.UpdateDynamicProperties(Scheme);
end;

procedure TSharpESkinDesign.RemoveNotUsedBitmaps;

  procedure RemoveSkinPartBitmaps(sp : TSkinPart; List : TObjectList);
  var
    i,k : integer;
    item : TSkinBitmap;
  begin
    if sp.Items <> nil then
    begin
      for i := 0 to sp.Items.Count - 1 do
      begin
        if sp.Items.Item[i].Items <> nil then
           RemoveSkinPartBitmaps(sp.Items.Item[i],List);
      end;
    end;

    if (sp.BitmapID >= 0) and (sp.BitmapID <= FBitmapList.Count - 1)then
    begin
      for k := List.Count - 1 downto 0 do
      begin
        item := TSkinBitmap(List.Items[k]);
        if FBitmapList[sp.BitmapID] = item then
          List.Delete(k);
      end;
    end;
  end;

var
  n : integer;
  list : TObjectList;
begin
  list := TObjectList.Create(False);
  for n := 0 to FBitmapList.Count - 1 do
      list.Add(FBitmapList.Items[n]);

  if FButtonSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FButtonSkin.FNormal,List);
    RemoveSkinPartBitmaps(FButtonSkin.FDown,List);
    RemoveSkinPartBitmaps(FButtonSkin.FHover,List);
  end;
  if FBarSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FBarSkin.FBar,List);
    RemoveSkinPartBitmaps(FBarSkin.FBarBottom,List);
    RemoveSkinPartBitmaps(FBarSkin.FBarBorder,List);
    RemoveSkinPartBitmaps(FBarSkin.FBarBottomBorder,List);
    RemoveSkinPartBitmaps(FBarSkin.FThNormal,List);
    RemoveSkinPartBitmaps(FBarSkin.FThDown,List);
    RemoveSkinPartBitmaps(FBarSkin.FThHover,List);
  end;
  if FEditSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FEditSkin.FNormal,List);
    RemoveSkinPartBitmaps(FEditSkin.FFocus,List);
    RemoveSkinPartBitmaps(FEditSkin.FHover,List);
  end;
  if FProgressBarSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FProgressBarSkin.FBackground,List);
    RemoveSkinPartBitmaps(FProgressBarSkin.FBackgroundSmall,List);
    RemoveSkinPartBitmaps(FProgressBarSkin.FProgress,List);
    RemoveSkinPartBitmaps(FProgressBarSkin.FProgressSmall,List);
  end;
  if FTaskItemSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FTaskItemSkin.FFull.FNormal,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FFull.FNormalHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FFull.FDown,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FFull.FDownHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FFull.FHighlight,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FFull.FHighlightHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FFull.FSpecial,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FFull.FSpecialHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FCompact.FNormal,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FCompact.FNormalHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FCompact.FDown,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FCompact.FDownHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FCompact.FHighlight,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FCompact.FHighlightHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FCompact.FSpecial,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FCompact.FSpecialHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FMini.FNormal,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FMini.FNormalHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FMini.FDown,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FMini.FDownHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FMini.FHighlight,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FMini.FHighlightHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FMini.FSpecial,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.FMini.FSpecialHover,List);
  end;
  if FMiniThrobberSkin <> nil then
  begin
    RemoveskinPartBitmaps(FMiniThrobberSkin.FNormal,List);
    RemoveskinPartBitmaps(FMiniThrobberSkin.FDown,List);
    RemoveskinPartBitmaps(FMiniThrobberSkin.FHover,List);
  end;
  if FMenuSkin <> nil then
  begin
    RemoveskinPartBitmaps(FMenuSkin.FBackground,List);
  end;
  if FMenuItemSkin <> nil then
  begin
    RemoveskinPartBitmaps(FMenuItemSkin.FNormalItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.FHoverItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.FDownItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.FNormalSubItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.FHoverSubItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.FLabelItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.FSeparator,List);
  end;
  if FNotifySkin <> nil then
  begin
    RemoveskinpartBitmaps(FNotifySkin.FBackground,List);
  end;
  if FTaskPreviewSkin <> nil then
  begin
    RemoveSkinpartBitmaps(FTaskPreviewSkin.FBackground,List);
    RemoveSkinpartBitmaps(FTaskPreviewSkin.FHover,List);
  end;

  for n := 0 to List.Count - 1 do
    FreeAndNil(TSkinBitmap(List.Items[n]).FBitmap);

  list.free;
end;

procedure TSharpESkinDesign.SaveToStream(Stream: TStream);
begin
  SaveToStream(Stream,true);
end;

procedure TSharpESkinDesign.SaveToStream(Stream: TStream; SaveBitmap:boolean);
var tempStream: TMemoryStream;
  size: int64;
begin
  Stream.Write(FDefaultDesign,sizeof(FDefaultDesign));
  StringSaveToStream(FName, Stream);

  FSkinText.SaveToStream(Stream);
  FSmallText.SaveToStream(Stream);
  FMediumText.SaveToStream(Stream);
  FLargeText.SaveToStream(Stream);
  FOSDText.SaveToStream(Stream);
  FTextPosTL.SaveToStream(Stream);
  FTextPosBL.SaveToStream(Stream);
  FTextPosBottomTL.SaveToStream(Stream);
  FTextPosBottomBL.SaveToStream(Stream);  
  Stream.WriteBuffer(SaveBitmap, sizeof(SaveBitmap));
  if SaveBitmap then
    FBitmapList.SaveToStream(Stream);

  tempStream := TMemoryStream.Create;
  try

    //Write Button
    if FButtonSkin <> nil then
    begin
      StringSaveToStream('Button', Stream);
      FButtonSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write ProgressBar
    if FProgressBarSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('ProgressBar', Stream);
      FProgressBarSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write Bar
    if FBarSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('Bar', Stream);
      FBarSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write MiniThrobber
    if FMiniThrobberSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('MiniThrobber', Stream);
      FMiniThrobberSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write Edit
    if FEditSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('Edit', Stream);
      FEditSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write TaskItem
    if FTaskItemSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('TaskItem', Stream);
      FTaskItemSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write MenuSkin
    if FMenuSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('Menu', Stream);
      FMenuSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write MenuItemSkin
    if FMenuItemSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('MenuItem', Stream);
      FMenuItemSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write Notify Skin
    if FNotifySkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('Notify', Stream);
      FNotifySkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write TaskPreview Skin
    if FTaskPreviewSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('TaskPreview', Stream);
      FTaskPreviewSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    StringSaveToStream('End', Stream);
  finally
    TempStream.Free;
  end;
end;

procedure TSharpESkinDesign.LoadFromStream(Stream: TStream);
var temp          : string;
  size            : int64;
  BmpListInStream : boolean;
begin
  if FontList <> nil then
    FontList.RefreshFontInfo;

  Clear;
  try
    Stream.ReadBuffer(FDefaultDesign,sizeof(FDefaultDesign));
    FName := StringLoadFromStream(Stream);
    FSkinText.LoadFromStream(Stream);
    FSmallText.LoadFromStream(Stream);
    FMediumText.LoadFromStream(Stream);
    FLargeText.LoadFromStream(Stream);
    FOSDText.LoadFromStream(Stream);
    FTextPosTL.LoadFromStream(Stream);
    FTextPosBL.LoadFromStream(Stream);
    FTextPosBottomTL.LoadFromStream(Stream);
    FTextPosBottomBL.LoadFromStream(Stream);    
    Stream.ReadBuffer(BmpListInStream, sizeof(BmpListInStream));
    if BmpListInStream then
      FBitmapList.LoadFromStream(Stream);
    temp := StringLoadFromStream(Stream);
    while temp <> 'End' do
    begin
      Stream.ReadBuffer(size, sizeof(size));

      if (temp = 'Button') and (FButtonSkin <> nil) then
        FButtonSkin.LoadFromStream(Stream)
      else if (temp = 'ProgressBar') and (FProgressBarSkin <> nil) then
        FProgressBarSkin.LoadFromStream(Stream)
      else if (temp = 'Bar') and (FBarSkin <> nil) then
        FBarSkin.LoadFromStream(Stream)
      else if (temp = 'MiniThrobber') and (FMiniThrobberSkin <> nil) then
        FMiniThrobberSkin.LoadFromStream(Stream)
      else if (temp = 'Edit') and (FEditSkin <> nil) then
        FEditSkin.LoadFromStream(Stream)
      else if (temp = 'TaskItem') and (FTaskItemSkin <> nil) then
        FTaskItemSkin.LoadFromStream(Stream)
      else if (temp = 'Menu') and (FMenuSkin <> nil) then
        FMenuSkin.LoadFromStream(Stream)
      else if (temp = 'MenuItem') and (FMenuItemSkin <> nil) then
        FMenuItemSkin.LoadFromStream(Stream)
      else if (temp = 'Notify') and (FNotifySkin <> nil) then
        FNotifySkin.LoadFromStream(Stream)
      else if (temp = 'TaskPreview') and (FTaskPreviewSkin <> nil) then
        FTaskPreviewSkin.LoadFromStream(Stream)
      else Stream.Position := Stream.Position + size;

      temp := StringLoadFromStream(Stream);
    end;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpESkin','Error loading skin from stream',clred,DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpESkin',E.Message,clred,DMT_ERROR);
    end;
  end;
  
  if FBarskin <> nil then
     FBarSkin.CheckValid;
  inherited;
  
  RemoveNotUsedBitmaps;
end;

procedure TSharpESkinDesign.Assign(src: TSharpESkinDesign);
begin
  if (FButtonSkin <> nil) then
    FButtonSkin.Assign(src.FButtonSkin);
  if (FProgressBarSkin <> nil) then
    FProgressBarSkin.Assign(src.FProgressBarSkin);
  if (FBarSkin <> nil) then
    FBarSkin.Assign(src.FBarSkin);
  if (FMiniThrobberSkin <> nil) then
    FMiniThrobberSkin.Assign(src.FMiniThrobberSkin);
  if (FEditSkin <> nil) then
    FEditSkin.Assign(src.FEditSkin);
  if (FMenuSkin <> nil) then
    FMenuSkin.Assign(src.FMenuSkin);
  if (FMenuItemSkin <> nil) then
    FMenuItemSkin.Assign(src.FMenuItemSkin);
  if (FTaskItemSkin <> nil) then
    FTaskItemSkin.Assign(src.FTaskItemSkin);
  if (FNotifySkin <> nil) then
    FNotifySkin.Assign(src.FNotifySkin);
  if (FTaskPreviewSkin <> nil) then
    FTaskPreviewSkin.Assign(src.FTaskPreviewSkin);

  FSmallText.Assign(src.SmallText);
  FMediumText.Assign(src.MediumText);
  FLargeText.Assign(src.FLargeText);
  FOSDText.Assign(src.OSDText);
  FTextPosTL.Assign(src.FTextPosTL);
  FTextPosBL.Assign(src.FTextPosBL);
  FTextPosBottomTL.Assign(src.FTextPosBottomTL);
  FTextPosBottomBL.Assign(src.FTextPosBottomBL);

  FBitmapList.AssignList(src.FBitmapList);
end;

procedure TSharpESkinDesign.Clear;
begin
  if FButtonSkin <> nil then
    FButtonSkin.Clear;
  if FProgressBarSkin <> nil then
    FProgressBarSkin.Clear;
  if FBarSkin <> nil then
    FBarSkin.Clear;

  if FMiniThrobberSkin <> nil then
    FMiniThrobberSkin.Clear;
  if FEditSkin <> nil then
    FEditSkin.Clear;
  if FMenuSkin <> nil then
    FMenuSkin.Clear;
  if FMenuItemSkin <> nil then
    FMenuItemSkin.Clear;
  if FTaskItemSkin <> nil then
    FTaskItemSkin.Clear;
  if FNotifySkin <> nil then
    FNotifySkin.Clear;
  if FTaskPreviewSkin <> nil then
    FTaskPreviewSkin.Clear;

  FSmallText.Clear;
  FMediumText.Clear;
  FLargeText.Clear;
  FOSDText.Clear;
  FBitmapList.Clear;
  FTextPosTL.Clear;
  FTextPosBL.Clear;
  FTextPosBottomTL.Clear;
  FTextPosBottomBL.Clear;  

  FName := 'Default';
  
  FOSDText.Name := 'Verdana';
  FOSDText.ColorString := 'clwhite';
  FOSDText.Color := 16777215;
  FOSDText.ShadowColorString := '0';
  FOSDText.ShadowColor := 0;
  FOSDText.Shadow := True;
  FOSDText.ShadowType := stOutline;
  FOSDText.Size := 56;
  FOSDText.Alpha := 224;
  FOSDText.AlphaString := '224';
end;

procedure TSharpESkinDesign.LoadFromXml(xml: TJclSimpleXMLElem; path : String);
begin
  FDefaultDesign := xml.Properties.BoolValue('default',false);
  if FDefaultDesign then
    Clear;

  FName := xml.Properties.Value('name','Default');

  // Load Details
  if xml.Items.ItemNamed['font'] <> nil then
  begin
     with xml.Items.ItemNamed['font'].Properties do
     begin
       if ItemNamed['locationTL'] <> nil then
       begin
          FTextPosTL.SetPoint(ItemNamed['locationTL'].Value);
          FTextPosBottomTL.SetPoint(ItemNamed['locationTL'].Value); // use as default
       end;
       if ItemNamed['locationBL'] <> nil then
       begin
          FTextPosBL.SetPoint(ItemNamed['locationBL'].Value);
          FTextPosBottomBL.SetPoint(ItemNamed['locationBL'].Value); // use as default
       end;
       if ItemNamed['locationBottomTL'] <> nil then
          FTextPosBottomTL.SetPoint(ItemNamed['locationBottomTL'].Value);
       if ItemNamed['locationBottomBL'] <> nil then
          FTextPosBottomBL.SetPoint(ItemNamed['locationBottomBL'].Value);
     end;
     with xml.Items.ItemNamed['font'].Items do
     begin
       if ItemNamed['small'] <> nil then
          FSmallText.LoadFromXML(ItemNamed['small'],FontList);
       if ItemNamed['medium'] <> nil then
          FMediumText.LoadFromXML(ItemNamed['medium'],FontList);
       if ItemNamed['big'] <> nil then
          FLargeText.LoadFromXML(ItemNamed['big'],FontList);
       if ItemNamed['osd'] <> nil then
          FOSDText.LoadFromXML(ItemNamed['osd'],FontList);
     end;
  end;
  if (xml.Items.ItemNamed['button'] <> nil) and (FButtonSkin <> nil) then
    FButtonSkin.LoadFromXML(xml.Items.ItemNamed['button'], path);
  if (xml.Items.ItemNamed['sharpbar'] <> nil) and (FBarSkin <> nil) then
    FBarSkin.LoadFromXML(xml.Items.ItemNamed['sharpbar'], path);
  if (xml.Items.ItemNamed['progressbar'] <> nil) and (FProgressBarSkin <> nil) then
    FProgressBarSkin.LoadFromXML(xml.Items.ItemNamed['progressbar'], path);
  if (xml.Items.ItemNamed['minithrobber'] <> nil) and (FMiniThrobberSkin <> nil) then
    FMiniThrobberSkin.LoadFromXML(xml.Items.ItemNamed['minithrobber'], path);
  if (xml.Items.ItemNamed['edit'] <> nil) and (FEditSkin <> nil) then
    FEditSkin.LoadFromXML(xml.Items.ItemNamed['edit'], path);
  if (xml.Items.ItemNamed['taskitem'] <> nil) and (FTaskItemSkin <> nil) then
    FTaskItemSkin.LoadFromXML(xml.Items.ItemNamed['taskitem'],path);
  if (xml.Items.ItemNamed['menu'] <> nil) and (FMenuSkin <> nil) then
    FMenuSkin.LoadFromXML(xml.Items.ItemNamed['menu'],path);
  if (xml.Items.ItemNamed['menuitem'] <> nil) and (FMenuItemSkin <> nil) then
    FMenuItemSkin.LoadFromXML(xml.Items.ItemNamed['menuitem'],path);
  if (xml.Items.ItemNamed['notify'] <> nil) and (FNotifySkin <> nil) then
    FNotifySkin.LoadFromXML(xml.Items.ItemNamed['notify'],path);
  if (xml.Items.ItemNamed['taskpreview'] <> nil) and (FTaskPreviewSkin <> nil) then
    FTaskPreviewSkin.LoadFromXML(xml.Items.ItemNamed['taskpreview'],path);

  if FBarSkin <> nil then
     FBarSkin.CheckValid;
end;

//***************************************
//* TMenuSkin
//***************************************

constructor TSharpEMenuSkin.Create(BmpList:  TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('100','100');

  FBackground := TSkinPart.Create(BmpList);
  FBackgroundInterface := FBackground;

  FTBOffset   := TSkinPoint.Create;
  FTBOffset.SetPoint('0','0');
  FLROffset   := TSkinPoint.Create;
  FLROffset.SetPoint('0','0');
  FWidthLimit := TSkinPoint.Create;
  FWidthLimit.SetPoint('50','350');
end;

destructor TSharpEMenuSkin.Destroy;
begin
  FSkinDim.Free;
  FBackgroundInterface := nil;
  FTBOffset.Free;
  FLROffset.Free;
  FWidthLimit.Free;
end;

function TSharpEMenuSkin.GetBackground: ISharpESkinPart;
begin
  result := FBackgroundInterface;
end;

function TSharpEMenuSkin.GetLocationOffset: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
end;

function TSharpEMenuSkin.GetLROffset: TPoint;
begin
  result := Point(FLROffset.XAsInt,FLROffset.YAsInt);
end;

function TSharpEMenuSkin.GetTBOffset: TPoint;
begin
  result := Point(FTBOffset.XAsInt,FLROffset.YAsInt);
end;

function TSharpEMenuSkin.GetValid: Boolean;
begin
  result := not (FBackground.Empty);
end;

function TSharpEMenuSkin.GetWidthLimit: TPoint;
begin
  result := Point(FWidthLimit.XAsInt,FWidthLimit.YAsInt);
end;

procedure TSharpEMenuSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FBackground.UpdateDynamicProperties(cs);
end;

procedure TSharpEMenuSkin.Assign(src: TSharpEMenuSkin);
begin
  FBackground.Assign(src.FBackground);
  FSkinDim.Assign(src.FSkinDim);
  FTBOffset.Assign(src.FTBOffset);
  FLROffset.Assign(src.FLROffset);
  FWidthLimit.Assign(src.FWidthLimit);
end;

procedure TSharpEMenuSkin.Clear;
begin
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('100','100');
  FTBOffset.SetPoint('0','0');
  FLROffset.SetPoint('0','0');
  FWidthLimit.SetPoint('50','350');
  FBackground.Clear;
end;

procedure TSharpEMenuSkin.LoadFromStream(Stream : TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FBackground.LoadFromStream(Stream);

  FTBOffset.LoadFromStream(Stream);
  FLROffset.LoadFromStream(Stream);
  FWidthLimit.LoadFromStream(Stream);
end;

procedure TSharpEMenuSkin.SaveToStream(Stream : TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FBackground.SaveToStream(Stream);
  FTBOffset.SaveToStream(Stream);
  FLROffset.SaveToStream(Stream);
  FWidthLimit.SaveToStream(Stream);
end;

procedure TSharpEMenuSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var
  SkinText: TSkinText;
begin
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['tboffset'] <> nil then
        FTBOffset.SetPoint(Value('tboffset','0,0'));
      if ItemNamed['lroffset'] <> nil then
        FLROffset.SetPoint(Value('lroffset','0,0'));
      if ItemNamed['widthlimit'] <> nil then
        FWidthLimit.SetPoint(Value('widthlimit','0,0'));    
    end;

    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'],FontList);
      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText, FontList)
      else FBackground.AssignText(SkinText);
    end;
  finally
    SkinText.SelfInterface := nil;
  end;
end;

//***************************************
//* TMenuItemSkin
//***************************************

constructor TSharpEMenuItemSkin.Create(BmpList:  TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w','32');

  FSeparator := TSkinPart.Create(BmpList);
  FNormalItem := TSkinPartEx.Create(BmpList);
  FLabelItem  := TSkinPartEx.Create(BmpList);
  FHoverItem  := TSkinPartEx.Create(BmpList);
  FDownItem   := TSkinPartEx.Create(BmpList);
  FNormalSubItem := TSkinPartEx.Create(BmpList);
  FHoverSubItem := TSkinPartEx.Create(BmpList);

  FSeparatorInterface := FSeparator;
  FNormalItemInterface := FNormalItem;
  FLabelItemInterface := FLabelItem;
  FHoverItemInterface := FHoverItem;
  FDownItemInterface := FDownItem;
  FNormalSubItemInterface := FNormalSubItem;
  FHoverSubItemInterface := FHoverSubItem;
end;

destructor TSharpEMenuItemSkin.Destroy;
begin
  FSkinDim.Free;
  FSeparatorInterface := nil;
  FNormalItemInterface := nil;
  FLabelItemInterface := nil;
  FHoverItemInterface := nil;
  FDownItemInterface := nil;
  FNormalSubItemInterface := nil;
  FHoverSubItemInterface := nil;
end;

function TSharpEMenuItemSkin.GetDownItem: ISharpESkinPartEx;
begin
  result := FDownItemInterface;
end;

function TSharpEMenuItemSkin.GetHoverItem: ISharpESkinPartEx;
begin
  result := FHoverItemInterface;
end;

function TSharpEMenuItemSkin.GetHoverSubItem: ISharpESkinPartEx;
begin
  result := FHoverSubItemInterface;
end;

function TSharpEMenuItemSkin.GetLabelItem: ISharpESkinPartEx;
begin
  result := FLabelItemInterface;
end;

function TSharpEMenuItemSkin.GetNormalItem: ISharpESkinPartEx;
begin
  result := FNormalItemInterface;
end;

function TSharpEMenuItemSkin.GetNormalSubItem: ISharpESkinPartEx;
begin
  result := FNormalSubItemInterface;
end;

function TSharpEMenuItemSkin.GetSeparator: ISharpESkinPart;
begin
  result := FSeparatorInterface;
end;

procedure TSharpEMenuItemSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FSeparator.UpdateDynamicProperties(cs);
  FNormalItem.UpdateDynamicProperties(cs);
  FLabelItem.UpdateDynamicProperties(cs);
  FHoverItem.UpdateDynamicProperties(cs);
  FDownItem.UpdateDynamicProperties(cs);
  FNormalSubItem.UpdateDynamicProperties(cs);
  FHoverSubItem.UpdateDynamicProperties(cs);
end;

procedure TSharpEMenuItemSkin.Assign(src: TSharpEMenuItemSkin);
begin
  FSkinDim.Assign(src.FSkinDim);
  FSeparator.Assign(src.FSeparator);
  FNormalItem.Assign(src.FNormalItem);
  FLabelItem.Assign(src.FLabelItem);
  FHoverItem.Assign(src.FHoverItem);
  FDownItem.Assign(src.FDownItem);
  FNormalSubItem.Assign(src.FNormalSubItem);
  FHoverSubItem.Assign(src.FHoverSubItem);
end;

procedure TSharpEMenuItemSkin.Clear;
begin
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w','32');
  FSeparator.Clear;
  FNormalItem.Clear;
  FLabelItem.Clear;
  FHoverItem.Clear;
  FDownItem.Clear;
  FNormalSubItem.Clear;
  FHoverSubItem.Clear;
end;

procedure TSharpEMenuItemSkin.LoadFromStream(Stream : TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FSeparator.LoadFromStream(Stream);
  FNormalItem.LoadFromStream(Stream);
  FHoverItem.LoadFromStream(Stream);
  FDownItem.LoadFromStream(Stream);
  FNormalSubItem.LoadFromStream(Stream);
  FHoverSubItem.LoadFromStream(Stream);
  FLabelItem.LoadFromStream(Stream);
end;

procedure TSharpEMenuItemSkin.SaveToStream(Stream : TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FSeparator.SaveToStream(Stream);
  FNormalItem.SaveToStream(Stream);
  FHoverItem.SaveToStream(Stream);
  FDownItem.SaveToStream(Stream);
  FNormalSubItem.SaveToStream(Stream);
  FHoverSubItem.SaveToStream(Stream);
  FLabelItem.SaveToStream(Stream);
end;

procedure TSharpEMenuItemSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var
  SkinText: TSkinText;
  SkinIcon : TSkinIcon;
begin
  SkinIcon := TSkinIcon.Create(True);
  SkinIcon.DrawIcon := False;
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
    end;

    with xml.Items do
    begin
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);

      if ItemNamed['Separator'] <> nil then
        FSeparator.LoadFromXML(ItemNamed['Separator'], path, SkinText, FontList)
      else FSeparator.AssignText(SkinText);
      if ItemNamed['normal'] <> nil then
        FNormalItem.LoadFromXML(ItemNamed['normal'], path, SkinText, SkinIcon, FontList)
      else FNormalItem.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['down'] <> nil then
        FDownItem.LoadFromXML(ItemNamed['down'], path, SkinText, SkinIcon, FontList)
      else FDownItem.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['normalsub'] <> nil then
        FNormalSubItem.LoadFromXML(ItemNamed['normalsub'], path, SkinText, SkinIcon, FontList)
      else FNormalSubItem.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['hover'] <> nil then
        FHoverItem.LoadFromXML(ItemNamed['hover'], path, SkinText, SkinIcon, FontList)
      else FHoverItem.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['hoversub'] <> nil then
        FHoverSubItem.LoadFromXML(ItemNamed['hoversub'], path, SkinText, SkinIcon, FontList)
      else FHoverSubItem.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['label'] <> nil then
        FLabelItem.LoadFromXml(ItemNamed['label'], path, SkinText, SkinIcon, FontList)
      else FLabelItem.AssignIconAndText(SkinText, SkinIcon);
    end;
  finally
    SkinText.SelfInterface := nil;
    SkinIcon.SelfInterface := nil;
  end;
end;

//***************************************
//* TSharpEButtonSkin
//***************************************

constructor TSharpEButtonSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w','h');

  FSkinDimBottom := TSkinDim.Create;
  FSkinDimBottom.SetLocation('0','0');
  FSkinDimBottom.SetDimension('w','h');

  FNormal := TSkinPartEx.Create(BmpList);
  FDown   := TSkinPartEx.Create(BmpList);
  FHover  := TSkinPartEx.Create(BmpList);

  FNormalInterface := FNormal;
  FDownInterface   := FDown;
  FHoverInterface  := FHover;

  FWidthMod := 0;
end;

destructor TSharpEButtonSkin.Destroy;
begin
  FNormalInterface := nil;
  FDownInterface   := nil;
  FHoverInterface  := nil;

  FNormal := nil;
  FDown   := nil;
  FHover  := nil;

  FSkinDim.Free;
  FSkinDimBottom.Free;
end;

procedure TSharpEButtonSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FDown.UpdateDynamicProperties(cs);
  FHover.UpdateDynamicProperties(cs);
end;

procedure TSharpEButtonSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FSkinDimBottom.SaveToStream(Stream);
  FNormal.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  Stream.WriteBuffer(FWidthMod,SizeOf(FWidthMod));
end;

procedure TSharpEButtonSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FSkinDimBottom.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FDown.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  Stream.ReadBuffer(FWidthMod,SizeOf(FWidthMod));
end;

procedure TSharpEButtonSkin.Assign(Src: TSharpEButtonSkin);
begin
  FNormal.Assign(Src.FNormal);
  FDown.Assign(Src.FDown);
  FHover.Assign(Src.FHover);
  FSkinDim.Assign(Src.FSkinDim);
  FSkinDimBottom.Assign(Src.FSkinDimBottom);
  FWidthMod := Src.FWidthMod;
end;

procedure TSharpEButtonSkin.Clear;
begin
  FNormal.Clear;
  FDown.Clear;
  FHover.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
  FSkinDimBottom.SetLocation('0','0');
  FSkinDimBottom.SetDimension('w','h');
  FWidthMod := 0;
end;

procedure TSharpEButtonSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var
  SkinText: TSkinText;
  SkinIcon: TSkinIcon;
begin
  SkinIcon := TSkinIcon.Create(True);
  SkinIcon.DrawIcon := True;
  SkinText := TSkinText.create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
      begin
        FSkinDim.SetLocation(Value('location','0,0'));
        FSkinDimBottom.SetLocation(Value('location','0,0'));
      end;
      if ItemNamed['locationbottom'] <> nil then
        FSkinDimBottom.SetLocation(Value('locationbottom','0,0'));        

      FWidthMod := IntValue('WidthMod',20);
    end;

    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);

      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText, SkinIcon, FontList)
      else FNormal.AssignIconAndText(SkinText,SkinIcon);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText, SkinIcon, FontList)
      else FDown.AssignIconAndText(SkinText,SkinIcon);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText, SkinIcon, FontList)
      else FHover.AssignIconAndText(SkinText,SkinIcon);
    end;
  finally
    SkinText.SelfInterface := nil;
    SkinIcon.SelfInterface := nil;
  end;
end;

function TSharpEButtonSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEButtonSkin.GetLocation: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
end;

function TSharpEButtonSkin.GetLocationBottom: TPoint;
begin
  result := Point(FSkinDimBottom.XAsInt,FSkinDimBottom.YAsInt);
end;

function TSharpEButtonSkin.GetDown: ISharpESkinPartEx;
begin
  result := FDownInterface;
end;

function TSharpEButtonSkin.GetHover: ISharpESkinPartEx;
begin
  result := FHoverInterface;
end;

function TSharpEButtonSkin.GetNormal: ISharpESkinPartEx;
begin
  result := FNormalInterface;
end;

function TSharpEButtonSkin.GetValid: boolean;
begin
  result := not (FNormal.Empty);
end;

function TSharpEButtonSkin.GetWidthMod: integer;
begin
  result := FWidthMod;
end;

//***************************************
//* TSharpETaskItemSkin
//***************************************

constructor TSharpETaskItemSkin.Create(BmpList : TSkinBitmapList);
begin
  FFull := TSharpETaskItemState.Create(BmpList);
  FCompact := TSharpETaskItemState.Create(BmpList);
  FMini := TSharpETaskItemState.Create(BmpList);

  FFullInterface := FFull;
  FCompactInterface := FCompact;
  FMiniInterface := FMini;

  Clear;
end;

destructor TSharpETaskItemSkin.Destroy;
begin
  FFullInterface := nil;
  FCompactInterface := nil;
  FMiniInterface := nil;
end;

procedure TSharpETaskItemSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FFull.UpdateDynamicProperties(cs);
  FCompact.UpdateDynamicProperties(cs);
  FMini.UpdateDynamicProperties(cs);
end;

procedure TSharpETaskItemSkin.SaveToStream(Stream: TStream);
begin
  FFull.SaveToStream(Stream);
  FCompact.SaveToStream(Stream);
  FMini.SaveToStream(Stream);
end;

procedure TSharpETaskItemSkin.LoadFromStream(Stream: TStream);
begin
  FFull.LoadFromStream(Stream);
  FCompact.LoadFromStream(Stream);
  FMini.LoadFromStream(Stream);
end;

procedure TSharpETaskItemSkin.Assign(src: TSharpETaskItemSkin);
begin
  FFull.Assign(src.FFull);
  FCompact.Assign(src.FCompact);
  FMini.Assign(src.FMini);
end;

procedure TSharpETaskItemSkin.Clear;
begin
  FFull.Clear;
  FCompact.Clear;
  FMini.Clear;
end;

procedure TSharpETaskItemSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var
 n : integer;
 loadstr : string;
 st : TSharpETaskItemState;
begin
  for n := 0 to 2 do
  begin
    case n of
      0: loadstr := 'full';
      1: loadstr := 'compact';
      2: loadstr := 'mini';
    end;
    case n of
      1: st := FCompact;
      2: st := FMini;
      else st := FFUll;
    end;

    with xml.Items do
      if ItemNamed[loadstr] <> nil then
        st.LoadFromXML(ItemNamed[loadstr],path);
  end;
end;

function TSharpETaskItemSkin.GetAutoDim(tis: TSharpETaskItemStates; r: Trect): TRect;
begin
  case tis of
   tisCompact : result := FCompact.SkinDim.GetRect(r);
   tisMini    : result := FMini.SkinDim.GetRect(r);
   else result := FFull.SkinDim.GetRect(r)
  end;
end;

function TSharpETaskItemSkin.GetCompact: ISharpETaskItemStateSkin;
begin
  result := FCompactInterface;
end;

function TSharpETaskItemSkin.GetFull: ISharpETaskItemStateSkin;
begin
  result := FFullInterface;
end;

function TSharpETaskItemSkin.GetMini: ISharpETaskItemStateSkin;
begin
  result := FMiniInterface;
end;

function TSharpETaskItemSkin.IsValid(tis : TSharpETaskItemStates) : boolean;
begin
  case tis of
    tisCompact : result := not FCompact.Normal.Empty;
    tisMini    : result := not FMini.Normal.Empty;
    else result := not FFull.Normal.Empty;
  end;
end;

//***************************************
//* TSharpEMiniThrobberSkin
//***************************************

constructor TSharpEMiniThrobberSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetDimension('w', 'h');
  FSkinDim.SetLocation('0','0');
  FBottomSkinDim := TSkinDim.Create;
  FBottomSkinDim.SetDimension('w', 'h');
  FBottomSkinDim.SetLocation('0','0');

  FNormal := TSkinPart.Create(BmpList);
  FDown := TSkinPart.Create(BmpList);
  FHover := TSkinPart.Create(BmpList);

  FNormalInterface := FNormal;
  FDownInterface   := FDown;
  FHoverInterface := FHover;
end;

destructor TSharpEMiniThrobberSkin.Destroy;
begin
  FNormalInterface := nil;
  FDownInterface := nil;
  FHoverInterface := nil;

  FSkinDim.Free;
  FBottomSkinDim.Free;
end;

procedure TSharpEMiniThrobberSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FDown.UpdateDynamicProperties(cs);
  FHover.UpdateDynamicProperties(cs);
end;

procedure TSharpEMiniThrobberSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FNormal.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  FBottomSkinDim.SaveToStream(Stream);
end;

procedure TSharpEMiniThrobberSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FDown.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  FBottomSkinDim.Assign(FSkinDim);
  FBottomSkinDim.LoadFromStream(Stream);
end;

procedure TSharpEMiniThrobberSkin.Assign(src: TSharpEMiniThrobberSkin);
begin
  FNormal.Assign(src.FNormal);
  FDown.Assign(src.FDown);
  FHover.Assign(src.FHover);
  FSkinDim.Assign(src.FSkinDim);
  FBottomSkinDim.Assign(src.FBottomSkinDim);
end;

procedure TSharpEMiniThrobberSkin.Clear;
begin
  FNormal.Clear;
  FDown.Clear;
  FHover.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
  FBottomSkinDim.SetDimension('w', 'h');
  FBottomSkinDim.SetLocation('0','0');
end;

procedure TSharpEMiniThrobberSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location', '0,0'));
      if ItemNamed['bottomlocation'] <> nil then
        FBottomSkinDim.SetLocation(Value('bottomlocation', '0,0'))
      else FBottomSkinDim.Assign(FSkinDim);    
    end;

    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);

      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText, FontList)
      else FNormal.AssignText(SkinText);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText, FontList)
      else FDown.AssignText(SkinText);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText, FontList)
      else FHover.AssignText(SkinText);
    end;
  finally
    SkinText.SelfInterface := nil;
  end;
end;

function TSharpEMiniThrobberSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEMiniThrobberSkin.GetBottomLocation: TPoint;
begin
  result := Point(FBottomSkinDim.XAsInt,FBottomSkinDim.YAsInt);
end;

function TSharpEMiniThrobberSkin.GetDown: ISharpESkinPart;
begin
  result := FDownInterface;
end;

function TSharpEMiniThrobberSkin.GetHover: ISharpESkinPart;
begin
  result := FHoverInterface;
end;

function TSharpEMiniThrobberSkin.GetLocation: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
end;

function TSharpEMiniThrobberSkin.GetNormal: ISharpESkinPart;
begin
  result := FNormalInterface;
end;

function TSharpEMiniThrobberSkin.GetValid: boolean;
begin
  result := not (FNormal.Empty);
end;

//***************************************
//* TSharpEMiniThrobberSkin
//***************************************

constructor TSharpEEditSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDimBottom := TSkinDim.Create;  

  FNormal := TSkinPart.Create(BmpList);
  FFocus  := TSkinPart.Create(BmpList);
  FHover  := TSkinPart.Create(BmpList);

  FNormalInterface := FNormal;
  FFocusInterface  := FFocus;
  FHoverInterface  := FHover;

  FEditXOffsets := TSkinPoint.Create;
  FEditYOffsets := TSkinPoint.Create;

  Clear;
end;

destructor TSharpEEditSkin.Destroy;
begin
  FNormalInterface := nil;
  FFocusInterface  := nil;
  FHoverInterface  := nil;

  FEditXOffsets.Free;
  FEditYOffsets.Free;
  FSkinDim.Free;
  FSkinDimBottom.Free;  
end;

procedure TSharpEEditSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FFocus.UpdateDynamicProperties(cs);
  FHover.UpdateDynamicProperties(cs);
end;

procedure TSharpEEditSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FSkinDimBottom.SaveToStream(Stream);  
  FNormal.SaveToStream(Stream);
  FFocus.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  FEditXOffsets.SaveToStream(Stream);
  FEditYOffsets.SaveToStream(Stream);
end;

procedure TSharpEEditSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FSkinDimBottom.LoadFromStream(Stream);  
  FNormal.LoadFromStream(Stream);
  FFocus.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  FEditXOffsets.LoadFromStream(Stream);
  FEditYOffsets.LoadFromStream(Stream);
end;

procedure TSharpEEditSkin.Assign(src: TSharpEEditSkin);
begin
  FNormal.Assign(src.FNormal);
  FFocus.Assign(src.FFocus);
  FHover.Assign(src.FHover);
  FEditXOffsets.Assign(src.FEditXOffsets);
  FEditYOffsets.Assign(src.FEditYOffsets);
  FSkinDim.Assign(src.FSkinDim);
  FSkinDimBottom.Assign(src.FSkinDimBottom);
end;

procedure TSharpEEditSkin.Clear;
begin
  FNormal.Clear;
  FFocus.Clear;
  FHover.Clear;
  FEditXOffsets.Clear;
  FEditYOffsets.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
  FSkinDimBottom.SetLocation('0','0');
  FSkinDimBottom.SetDimension('w', 'h');  
end;

procedure TSharpEEditSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
      begin
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
        FSkinDimBottom.SetDimension(Value('dimension', 'w,h')); // use as default
      end;
      if ItemNamed['dimensionbottom'] <> nil then
        FSkinDimBottom.SetDimension(Value('dimensionbottom', 'w,h'));
      if ItemNamed['editxoffsets'] <> nil then
        FEditXOffsets.SetPoint(Value('editxoffsets','2,2'));
      if ItemNamed['edityoffsets'] <> nil then
        FEditYOffsets.SetPoint(Value('edityoffsets', '2,2'));
      if ItemNamed['location'] <> nil then
      begin
        FSkinDim.SetLocation(Value('location', '0,0'));
        FSkinDimBottom.SetLocation(Value('location', '0,0')); // use as default
      end;
      if ItemNamed['locationbottom'] <> nil then
        FSkinDimBottom.SetLocation(Value('locationbottom', '0,0'));        
    end;

    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);

      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText, FontList)
      else FNormal.AssignText(SkinText);
      if ItemNamed['focus'] <> nil then
        FFocus.LoadFromXML(ItemNamed['focus'], path, SkinText, FontList)
      else FFocus.AssignText(SkinText);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXMl(ItemNamed['hover'], path, SkinText, FontList)
      else FHover.AssignText(SkinText);
    end;
  finally
    SkinText.SelfInterface := nil;
  end;
end;

function  TSharpEEditSkin.GetAutoDim(r: Trect; isBarBottom : boolean = false): TRect;
begin
  if (isBarBottom) then
    result := FSkinDimBottom.GetRect(r)
  else result := FSkinDim.GetRect(r);
end;

function TSharpEEditSkin.GetDimension: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
end;

function TSharpEEditSkin.GetDimensionBottom: TPoint;
begin
  result := Point(FSkinDimBottom.XAsInt,FSkinDimBottom.YAsInt);
end;

function TSharpEEditSkin.GetEditXOffsets: TPoint;
begin
  result := Point(FEditXOffsets.XAsInt,FEditXOffsets.YAsInt);
end;

function TSharpEEditSkin.GetEditYOffsets: TPoint;
begin
  result := Point(FEditYOffsets.XAsInt,FEditYOffsets.YAsInt);
end;

function TSharpEEditSkin.GetFocus: ISharpESkinPart;
begin
  result := FFocusInterface;
end;

function TSharpEEditSkin.GetHover: ISharpESkinPart;
begin
  result := FHoverInterface;
end;

function TSharpEEditSkin.GetNormal: ISharpESkinPart;
begin
  result := FNormalInterface;
end;

function TSharpEEditSkin.GetValid: Boolean;
begin
  result := not (FNormal.Empty);
end;

//***************************************
//* TSharpEProgressBarSkin
//***************************************

constructor TSharpEProgressBarSkin.Create(BmpList : TSkinBitmapList);
begin
  inherited Create;

  FSkinDim := TSkinDim.Create;
  FSkinDimTL := TSkinDim.Create;
  FSkinDimBL := TSkinDim.Create;
  FSkinDimBottom := TSkinDim.Create;
  FSkinDimBottomTL := TSkinDim.Create;
  FSkinDimBottomBL := TSkinDim.Create;  

  FBackground      := TSkinPart.Create(BmpList);
  FProgress        := TSkinPart.Create(BmpList);
  FBackGroundSmall := TSkinPart.Create(BmpList);
  FProgressSmall   := TSkinPart.Create(BmpList);

  FSmallModeOffset := TSkinPoint.Create;

  FBackgroundInterface      := FBackground;
  FProgressInterface        := FProgress;
  FBackgroundSmallInterface := FBackgroundSmall;
  FProgressSmallInterface   := FProgressSmall;

  Clear;
end;

destructor TSharpEProgressBarSkin.Destroy;
begin
  FBackgroundInterface      := nil;
  FProgressInterface        := nil;
  FBackgroundSmallInterface := nil;
  FProgressSmallInterface   := nil;
  FSkinDim.Free;
  FSkinDimTL.Free;
  FSkinDimBL.Free;
  FSkinDimBottom.Free;
  FSkinDimBottomTL.Free;
  FSkinDimBottomBL.Free;  
  FSmallModeOffset.Free;

  inherited Destroy;
end;

procedure TSharpEProgressBarSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FBackGround.UpdateDynamicProperties(cs);
  FProgress.UpdateDynamicProperties(cs);
  FBackGroundSmall.UpdateDynamicProperties(cs);
  FProgressSmall.UpdateDynamicProperties(cs);
end;

procedure TSharpEProgressBarSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FSkinDimTL.SaveToStream(Stream);
  FSkinDimBL.SaveToStream(Stream);
  FSkinDimBottom.SaveToStream(Stream);
  FSkinDimBottomTL.SaveToStream(Stream);
  FSkinDimBottomBL.SaveToStream(Stream);  
  FBackGround.SaveToStream(Stream);
  FProgress.SaveToStream(Stream);
  FBackgroundSmall.SaveToStream(Stream);
  FProgressSmall.SaveToStream(Stream);
  FSmallModeOffset.SaveToStream(Stream);
end;

procedure TSharpEProgressBarSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FSkinDimTL.LoadFromStream(Stream);
  FSkinDimBL.LoadFromStream(Stream);
  FSkinDimBottom.LoadFromStream(Stream);
  FSkinDimBottomTL.LoadFromStream(Stream);
  FSkinDimBottomBL.LoadFromStream(Stream);  
  FBackGround.LoadFromStream(Stream);
  FProgress.LoadFromStream(Stream);
  FBackgroundSmall.LoadFromStream(Stream);
  FProgressSmall.LoadFromStream(Stream);
  FSMallModeOffset.LoadFromStream(Stream);
end;

procedure TSharpEProgressBarSkin.Assign(Src: TSharpEProgressBarSkin);
begin
  FBackground.Assign(Src.FBackground);
  FProgress.Assign(Src.FProgress);
  FBackgroundSmall.Assign(Src.FBackgroundSmall);
  FProgressSmall.Assign(Src.FProgressSmall);
  FSkinDim.Assign(Src.FSkinDim);
  FSkinDimTL.Assign(Src.FSkinDimTL);
  FSkinDimBL.Assign(Src.FSkinDimBL);
  FSkinDimBottom.Assign(Src.FSkinDimBottom);
  FSkinDimBottomTL.Assign(Src.FSkinDimBottomTL);
  FSkinDimBottomBL.Assign(Src.FSkinDimBottomBL);
  FSMallModeOffset.Assign(Src.FSMallModeOffset);
end;

procedure TSharpEProgressBarSkin.Clear;
begin
  FBackGround.Clear;
  FProgress.Clear;
  FBackGroundSmall.Clear;
  FProgressSmall.Clear;
  FSmallModeOffset.Clear;
  FSkinDim.SetDimension('w', 'h');
  FSkinDim.SetLocation('0', '0');
  FSkinDimTL.SetDimension('w', 'h');
  FSkinDimTL.SetLocation('0', '0');
  FSkinDimBL.SetDimension('w', 'h');
  FSkinDimBL.SetLocation('0', '0');
  FSkinDimBottom.SetDimension('w', 'h');
  FSkinDimBottom.SetLocation('0', '0');
  FSkinDimBottomTL.SetDimension('w', 'h');
  FSkinDimBottomTL.SetLocation('0', '0');
  FSkinDimBottomBL.SetDimension('w', 'h');
  FSkinDimBottomBL.SetLocation('0', '0');  
  FSmallModeOffset.SetPoint('0', '0');
end;

procedure TSharpEProgressBarSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Properties do
    begin
      if ItemNamed['location'] <> nil then
      begin
        FSkinDim.SetLocation(Value('location', '0,0'));
        FSkinDimBottom.SetLocation(Value('location', '0,0'));
      end;
      if ItemNamed['dimension'] <> nil then
      begin
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
        FSkinDimBottom.SetDimension(Value('dimension', 'w,h'));
      end;
      if ItemNamed['locationbottom'] <> nil then
        FSkinDimBottom.SetLocation(Value('locationbottom', '0,0'));
      if ItemNamed['dimensionbottom'] <> nil then
        FSkinDimBottom.SetDimension(Value('dimensionbottom', 'w,h'));
      if ItemNamed['locationTL'] <> nil then
      begin
        FSkinDimTL.SetLocation(Value('locationTL', '0,0'));
        FSkinDimBottomTL.SetLocation(Value('locationTL', '0,0'));
      end;
      if ItemNamed['dimensionTL'] <> nil then
      begin
        FSkinDimTL.SetDimension(Value('dimensionTL', 'w,h'));
        FSkinDimBottomTL.SetDimension(Value('dimensionTL', 'w,h'));
      end;
      if ItemNamed['locationbottomTL'] <> nil then
        FSkinDimBottomTL.SetLocation(Value('locationbottomTL', '0,0'));
      if ItemNamed['dimensionbottomTL'] <> nil then
        FSkinDimBottomTL.SetDimension(Value('dimensionbottomTL', 'w,h'));
      if ItemNamed['locationBL'] <> nil then
      begin
        FSkinDimBL.SetLocation(Value('locationBL', '0,0'));
        FSkinDimBottomBL.SetLocation(Value('locationBL', '0,0'));
      end;
      if ItemNamed['dimensionBL'] <> nil then
      begin
        FSkinDimBL.SetDimension(Value('dimensionBL', 'w,h'));
        FSkinDimBottomBL.SetDimension(Value('dimensionBL', 'w,h'));
      end;
      if ItemNamed['locationbottomBL'] <> nil then
        FSkinDimBottomBL.SetLocation(Value('locationbottomBL', '0,0'));
      if ItemNamed['dimensionbottomBL'] <> nil then
        FSkinDimBottomTL.SetDimension(Value('dimensionbottomBL', 'w,h'));
      if ItemNamed['smallmode'] <> nil then
        FSmallModeOffset.SetPoint(Value('smallmode', '0,0'));                         
    end;

    with xml.Items do
    begin
      if ItemNamed['background'] <> nil then
        FBackGround.LoadFromXML(ItemNamed['background'], path, SkinText);
      if ItemNamed['progress'] <> nil then
        FProgress.LoadFromXML(ItemNamed['progress'], path, SkinText);
      if ItemNamed['smallbackground'] <> nil then
        FBackGroundSmall.LoadFromXML(ItemNamed['smallbackground'], path,
          SkinText);
      if ItemNamed['smallprogress'] <> nil then
        FProgressSmall.LoadFromXML(ItemNamed['smallprogress'], path, SkinText);
    end;
  finally
    SkinText.SelfInterface := nil;
  end;
end;

function TSharpEProgressBarSkin.GetAutoDim(r: Trect; vpos : TSharpEBarAutoPos; isBarBottom : boolean = false): TRect;
begin
  if (isBarBottom) then
  begin
    case vpos of
      apTop   : result := FSkinDimBottomTL.GetRect(r);
      apBottom: result := FSkinDimBottomBL.GetRect(r)
      else result := FSkinDimBottom.GetRect(r);
    end;
  end else begin
    case vpos of
      apTop   : result := FSkinDimTL.GetRect(r);
      apBottom: result := FSkinDimBL.GetRect(r)
      else result := FSkinDim.GetRect(r);
    end;  
  end;
end;

function TSharpEProgressBarSkin.GetBackground: ISharpESkinPart;
begin
  result := FBackgroundInterface;
end;

function TSharpEProgressBarSkin.GetBackgroundSmall: ISharpESkinPart;
begin
  result := FBackgroundSmallInterface;
end;

function TSharpEProgressBarSkin.GetProgress: ISharpESkinPart;
begin
  result := FProgressInterface;
end;

function TSharpEProgressBarSkin.GetProgressSmall: ISharpESkinPart;
begin
  result := FProgressSmallInterface;
end;

function TSharpEProgressBarSkin.GetSmallModeOffset: TPoint;
begin
  result.X := FSmallModeOffset.XAsInt;
  result.Y := FSmallModeOffset.YAsInt;
end;

function TSharpEProgressBarSkin.GetValid: boolean;
begin
  result := not (FBackground.Empty);
end;

//***************************************
//* TSharpEBarSkin
//***************************************

constructor TSharpEBarSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FThDim := TSkinDim.Create;
  FThBDim := TSkinDim.Create;

  FThNormal := TSkinPart.Create(BmpList);
  FThDown := TSkinPart.Create(BmpList);
  FThHover := TSkinPart.Create(BmpList);
  FBar := TSkinPart.Create(BmpList);
  FBarBorder := TSkinPart.Create(BmpList);
  FBarBottom := TSkinPart.Create(BmpList);
  FBarBottomBorder := TSkinPart.Create(BmpList);

  FThNormalInterface        := FThNormal;
  FThDownInterface          := FThDown;
  FThHoverInterface         := FThHover;
  FBarInterface             := FBar;
  FBarBorderInterface       := FBarBorder;
  FBarBottomInterface       := FBarBottom;
  FBarBottomBorderInterface := FBarBottomBorder;

  FFSMod := TSkinPoint.Create;
  FSBMod := TSKinPoint.Create;
  FPTXoffset := TSkinPoint.Create;
  FPTYoffset := TSkinPoint.Create;
  FPBXoffset := TSkinPoint.Create;
  FPBYoffset := TSkinPoint.Create;
  FPAXoffset := FPTXoffset;
  FPAYoffset := FPTYoffset;

  FNCTYOffset := TSkinPoint.Create;
  FNCBYOffset := TSkinPoint.Create;
  FNCYOffset  := FNCTYOffset;


  FEnableVFlip := False;
  FSpecialHideForm := False;
  FGlassEffect := False;
  Clear;
end;

destructor TSharpEBarSkin.Destroy;
begin
  FThNormalInterface        := nil;
  FThDownInterface          := nil;
  FThHoverInterface         := nil;
  FBarInterface             := nil;
  FBarBorderInterface       := nil;
  FBarBottomInterface       := nil;
  FBarBottomBorderInterface := nil;

  FSkinDim.Free;
  FThDim.Free;
  FThBDim.Free;  
  FFSMod.Free;
  FSBMod.Free;
  FPTXoffset.Free;
  FPTYoffset.Free;
  FPBXoffset.Free;
  FPBYoffset.Free;
  FNCTYOffset.Free;
  FNCBYOffset.Free;
end;

procedure TSharpEBarSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FThNormal.UpdateDynamicProperties(cs);
  FThDown.UpdateDynamicProperties(cs);
  FThHover.UpdateDynamicProperties(cs);
  FBar.UpdateDynamicProperties(cs);
  FBarBorder.UpdateDynamicProperties(cs);
  FBarBottom.UpdateDynamicProperties(cs);
  FBarBottomBorder.UpdateDynamicProperties(cs);
end;

procedure TSharpEBarSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FThDim.SaveToStream(Stream);
  FThBDim.SaveToStream(Stream);
  FThNormal.SaveToStream(Stream);
  FThDown.SaveToStream(Stream);
  FThHover.SaveToStream(Stream);
  FBar.SaveToStream(Stream);
  FBarBorder.SaveToStream(Stream);
  FBarBottom.SaveToStream(Stream);
  FBarBottomBorder.SaveToStream(Stream);
  FFSMod.SaveToStream(Stream);
  FSBMod.SaveToStream(Stream);

  FPTXoffset.SaveToStream(Stream);
  FPTYoffset.SaveToStream(Stream);
  FPBXoffset.SaveToStream(Stream);
  FPBYoffset.SaveToStream(Stream);

  FNCTYOffset.SaveToStream(Stream);
  FNCBYOffset.SaveToStream(Stream);

  if FEnableVFlip then StringSavetoStream('1', Stream)
     else StringSavetoStream('0', Stream);

  if FSpecialHideForm then StringSaveToStream('1', Stream)
     else StringSaveToStream('0', Stream);

  if FGlassEffect then StringSavetoStream('1', Stream)
     else StringSaveToStream('0', Stream);
end;

procedure TSharpEBarSkin.SetBarBottom;
begin
  FPAXoffset := FPBXoffset;
  FPAYoffset := FPBYoffset;
  FNCYOffset := FNCBYOffset;
end;

procedure TSharpEBarSkin.SetBarTop;
begin
  FPAXoffset := FPTXoffset;
  FPAYoffset := FPTYoffset;
  FNCYOffset := FNCTYOffset;
end;

procedure TSharpEBarSkin.LoadFromStream(Stream: TStream);
var
  n: integer;
begin
  repeat
    n := random(100000);
  until n <> FSeed;
  FSeed := n;
  
  FSkinDim.LoadFromStream(Stream);
  FThDim.LoadFromStream(Stream);
  FThBDim.LoadFromStream(Stream);
  FThNormal.LoadFromStream(Stream);
  FThDown.LoadFromStream(Stream);
  FThHover.LoadFromStream(Stream);
  FBar.LoadFromStream(Stream);
  FBarBorder.LoadFromStream(Stream);
  FBarBottom.LoadFromStream(Stream);
  FBarBottomBorder.LoadFromStream(Stream);
  FFSMod.LoadFromStream(Stream);
  FSBMod.LoadFromStream(Stream);

  FPTXoffset.LoadFromStream(Stream);
  FPTYoffset.LoadFromStream(Stream);
  FPBXoffset.LoadFromStream(Stream);
  FPBYoffset.LoadFromStream(Stream);

  FNCTYOffset.LoadFromStream(Stream);
  FNCBYOffset.LoadFromStream(Stream);

  if StringLoadFromStream(Stream) = '1' then FEnableVFlip := True
     else FEnableVFlip := False;
  if StringLoadFromStream(Stream) = '1' then FSpecialHideForm := True
     else FSpecialHideForm := False;
  if StringLoadFromStream(Stream) = '1' then FGlassEffect := True
     else FGlassEffect := False;
end;

procedure TSharpEBarSkin.Assign(Src: TSharpEBarSkin);
begin
  FDefaultSkin := Src.FDefaultSkin;
  FGlassEffect := Src.GlassEffect;
  FEnableVFlip := Src.FEnableVFlip;
  FSpecialHideForm := Src.FSpecialHideForm;

  FSkinDim.Assign(Src.FSkinDim);
  FThDim.Assign(Src.FThDim);
  FThBDim.Assign(Src.FThBDim);
  FFSMod.Assign(Src.FFSMod);
  FSBMod.Assign(Src.FSBMod);
  FPTXoffset.Assign(Src.FPTXoffset);
  FPTYoffset.Assign(Src.FPTYoffset);
  FPBXoffset.Assign(Src.FPBXoffset);
  FPBYoffset.Assign(Src.FPBYoffset);
  FBar.Assign(Src.FBar);
  FBarBorder.Assign(Src.FBarBorder);
  FBarBottom.Assign(Src.FBarBottom);
  FBarBottomBorder.Assign(Src.FBarBottomBorder);
  FThNormal.Assign(Src.FThNormal);
  FThDown.Assign(Src.FThDown);
  FThHover.Assign(Src.FThHover);
  FNCTYOffset.Assign(Src.FNCTYOffset);
  FNCBYOffset.Assign(Src.FNCBYOffset);
end;

procedure TSharpEBarSkin.CheckValid;
begin
  if not Valid then
  begin
    // special code if there is no SharpBar skin!
    // modules are getting the bar skin directly from the skin manager
    // so there must be a bitmap in SkinManager.Skin.Bar so that it's valid
    // and can be used for drawing the backgrund of the modules.
    FDefaultSkin := True;
    //FBar.BitmapID := BID;
    FSkinDim.SetDimension('w', '33');
    FThDim.SetLocation('4', '3');
    FThDim.SetDimension('10', '13');
    FThBDim.SetLocation('4','4');
    FThBDim.SetDimension('10', '13');
    FFSMod.SetPoint('0', '0');
    FSBMod.SetPoint('0', '0');
    FPTXoffset.SetPoint('14', '7');
    FPTYoffset.SetPoint('3', '3');
    FPBXoffset.SetPoint('14', '7');
    FPBYoffset.SetPoint('3', '3');
    FBar.SkinDim.SetDimension('w', 'h');
    FBar.BlendColorString := '$WorkAreaBack';
    FBar.Blend := True;
    FBarBorder.SkinDim.SetDimension('w', 'h');
    FBarBorder.BlendColorString := '$WorkAreaBack';
    FBarBorder.Blend := True;
    FBarBottom.SkinDim.SetDimension('w','h');
    FBarBottom.BlendColorString := '$WorkAreaBack';
    FBarBottom.Blend := True;
    FBarBottomBorder.SkinDim.SetDimension('w','h');
    FBarBottomBorder.BlendColorString := '$WorkAreaBack';
    FBarBottomBorder.Blend := True;
    FGlassEffect := False;
  end
  else
    FDefaultSkin := False;
end;

procedure TSharpEBarSkin.Clear;
begin
  FThNormal.Clear;
  FThDown.Clear;
  FThHover.Clear;
  FBar.Clear;
  FBarBorder.Clear;
  FBarBottom.Clear;
  FBarBottomBorder.Clear;
  FFSMod.Clear;
  FSBMod.Clear;
  FPTXoffset.Clear;
  FPTYoffset.Clear;
  FPBXoffset.Clear;
  FPBYoffset.Clear;
  FNCTYOffset.Clear;
  FNCBYOffset.Clear;
  FSkinDim.SetDimension('w', 'h');
  FThDim.SetDimension('0', '0');
  FThDim.SetLocation('0', '0');
  FThBDim.SetDimension('0', '0');
  FThBDim.SetLocation('0', '0');
  FEnableVFlip := False;
  FSpecialHideForm := False;
  FGlassEffect := False;
  NewSeed;
end;

procedure TSharpEbarSkin.NewSeed;
var
  n: integer;
begin
  // create a random number and save it as FSeed property.
  // could be used to check if the skin is reloaded or simply updated.
  repeat
    n := random(100000);
  until n <> FSeed;
  FSeed := n;
end;

procedure TSharpEBarSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
begin
  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['fsmod'] <> nil then
        FFSmod.SetPoint(Value('fsmod', '0,0'));
      if ItemNamed['sbmod'] <> nil then
        FSBMod.SetPoint(Value('sbmod', '0,0'));
      if ItemNamed['payoffsets'] <> nil then
        FPTYoffset.SetPoint(Value('payoffsets', '0,0'));
      if ItemNamed['paxoffsets'] <> nil then
        FPTXoffset.SetPoint(Value('paxoffsets', '0,0'));
      if ItemNamed['payoffsetsbottom'] <> nil then
        FPBYoffset.SetPoint(Value('payoffsetsbottom', '0,0'));
      if ItemNamed['paxoffsetsbottom'] <> nil then
        FPBXoffset.SetPoint(Value('paxoffsetsbottom', '0,0'));
      if ItemNamed['ncyoffsets'] <> nil then
        FNCTYOffset.SetPoint(Value('ncyoffsets','0,0'));
      if ItemNamed['ncyoffsetsbottom'] <> nil then
        FNCBYOffset.SetPoint(Value('ncyoffsetsbottom','0,0'));
      if ItemNamed['enablevflip'] <> nil then
        FEnablevflip := BoolValue('enablevflip', False);
      if ItemNamed['specialhideform'] <> nil then
        FSpecialHideForm := BoolValue('specialhideform', False);
      if ItemNamed['glasseffect'] <> nil then
        FGlassEffect := BoolValue('glasseffect',False);
    end;

    with xml.Items do
    begin
      if ItemNamed['throbber'] <> nil then
      begin
        with ItemNamed['throbber'].Properties do
        begin
          if ItemNamed['dimension'] <> nil then
          begin
            FThDim.SetDimension(Value('dimension', 'w,h'));
            FThBDim.SetDimension(Value('dimension', 'w,h'));
          end;
          if ItemNamed['location'] <> nil then
          begin
            FThDim.SetLocation(Value('location', 'w,h'));
            FThBDim.SetLocation(Value('location', 'w,h'));
          end;
          if ItemNamed['locationbottom'] <> nil then
            FThBDim.SetLocation(Value('locationbottom', 'w,h'));        
        end;

        with ItemNamed['throbber'].Items do
        begin
          if ItemNamed['normal'] <> nil then
            FThNormal.LoadFromXML(ItemNamed['normal'], path, nil);
          if ItemNamed['down'] <> nil then
            FThDown.LoadFromXML(ItemNamed['down'], path, nil);
          if ItemNamed['hover'] <> nil then
            FThHover.LoadFromXML(ItemNamed['hover'], path, nil);
        end;
      end;
      if ItemNamed['bar'] <> nil then
        FBar.LoadFromXML(ItemNamed['bar'], path, nil);
      if ItemNamed['barborder'] <> nil then
        FBarBorder.LoadFromXML(ItemNamed['barborder'], path, nil);
      if ItemNamed['barbottom'] <> nil then
        FBarBottom.LoadFromXML(ItemNamed['barbottom'], path, nil);
      if ItemNamed['barbottomborder'] <> nil then
        FBarBottomBorder.LoadFromXML(ItemNamed['barbottomborder'], path, nil);
    end;
  finally
  end;
end;

function TSharpEBarSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEBarSkin.GetBar: ISharpESkinPart;
begin
  result := FBarInterface;
end;

function TSharpEBarSkin.GetBarBorder: ISharpESkinPart;
begin
  result := FBarBorderInterface;
end;

function TSharpEBarSkin.GetBarBottom: ISharpESkinPart;
begin
  result := FBarBottomInterface;
end;

function TSharpEBarSkin.GetBarBottomBorder: ISharpESkinPart;
begin
  result := FBarBottomBorderInterface;
end;

function TSharpEBarSkin.GetBarHeight: integer;
begin
  result := FSkinDim.HeightAsInt;
end;

function TSharpEBarSkin.GetDefaultSkin: Boolean;
begin
  result := FDefaultSkin;
end;

function TSharpEBarSkin.GetEnableVFlip: Boolean;
begin
  result := FEnableVFlip;
end;

function TSharpEBarSkin.GetFSMod: TPoint;
begin
  result := Point(FFSMod.XAsInt,FFSMod.YAsInt);
end;

function TSharpEBarSkin.GetGlassEffect: Boolean;
begin
  result := FGlassEffect;
end;

function TSharpEBarSkin.GetNCBYOffset: TPoint;
begin
  result := Point(FNCBYOffset.XAsInt,FNCBYOffset.YAsInt);
end;

function TSharpEBarSkin.GetNCTYOffset: TPoint;
begin
  result := Point(FNCTYOffset.XAsInt,FNCTYOffset.YAsInt);
end;

function TSharpEBarSkin.GetNCYOffset: TPoint;
begin
  result := Point(FNCYOffset.XAsInt,FNCYOffset.YAsInt);
end;

function TSharpEBarSkin.GetPAXOffset: TPoint;
begin
  result := Point(FPAXOffset.XAsInt,FPAXOffset.YAsInt);
end;

function TSharpEBarSkin.GetPAYOffset: TPoint;
begin
  result := Point(FPAYOffset.XAsInt,FPAYOffset.YAsInt);
end;

function TSharpEBarSkin.GetPBXOffset: TPoint;
begin
  result := Point(FPBXOffset.XAsInt,FPBXOffset.YAsInt);
end;

function TSharpEBarSkin.GetPBYOffset: TPoint;
begin
  result := Point(FPBYOffset.XAsInt,FPBYOffset.YAsInt);
end;

function TSharpEBarSkin.GetPTXOffset: TPoint;
begin
  result := Point(FPTXOffset.XAsInt,FPTXOffset.YAsInt);
end;

function TSharpEBarSkin.GetPTYOffset: TPoint;
begin
  result := Point(FPTYOffset.XAsInt,FPTYOffset.YAsInt);
end;

function TSharpEBarSkin.GetSBMod: TPoint;
begin
  result := Point(FSBMod.XAsInt,FSBMod.YAsInt);
end;

function TSharpEBarSkin.GetSeed: integer;
begin
  result := FSeed;
end;

function TSharpEBarSkin.GetSpecialHideForm: Boolean;
begin
  result := FSpecialHideForm;
end;

function TSharpEBarSkin.GetThDown: ISharpESkinPart;
begin
  result := FTHDownInterface;
end;

function TSharpEBarSkin.GetThHover: ISharpESkinPart;
begin
  result := FThHoverInterface;
end;

function TSharpEBarSkin.GetThNormal: ISharpESkinPart;
begin
  result := FThNormalInterface;
end;

function TSharpEBarSkin.GetThrobberBottomDim(r: TRect): TRect;
begin
  result := FThBDim.GetRect(r);
end;

function TSharpEBarSkin.GetThrobberDim(r: Trect): TRect;
begin
  result := FThDim.GetRect(r);
end;

function TSharpEBarSkin.GetThrobberWidth: integer;
begin
  result := FThDim.WidthAsInt;
end;

function TSharpEBarSkin.Getvalid: boolean;
begin
  result := not (FBar.Empty);
end;

procedure TSharpESkin.FreeInstance;
begin
  inherited;

end;

function TSharpESkin.GetDefaultSkinDesign: TSharpESkinDesign;
var
  n : integer;
begin
  result := nil;
  for n := 0 to FSkinDesigns.Count - 1 do
    if TSharpESkinDesign(FSkinDesigns.Items[n]).IsDefaultDesign then
    begin
      result := TSharpESkinDesign(FSkinDesigns.Items[n]);
      exit;
    end;
end;

function TSharpESkin.GetSkinDesigns: TObjectList;
begin
  result := FSkinDesigns;
end;

procedure TSharpESkin.SetXmlFileName(const Value: TXmlFileName);
begin
  FXmlFileName := Value;

  if FileExists(Value) then
  begin
    LoadFromXmlFile(Value);
  end
  else
    if Value = '' then
    begin
      FXmlFileName := '';
      Clear;
    end;
end;

function TSharpESkinDesign.GetBarSkin: ISharpEbarskin;
begin
  result := FBarInterface;
end;

function TSharpESkinDesign.GetButtonSkin: ISharpEButtonSkin;
begin
  result := FButtonInterface;
end;

function TSharpESkinDesign.GetEditSkin: ISharpEEditSkin;
begin
  result := FEditInterface;
end;

function TSharpESkinDesign.GetIsDefaultDesign: boolean;
begin
  result := FDefaultDesign;
end;

function TSharpESkinDesign.GetLargeText: ISharpESkinText;
begin
  result := FLargeTextInterface;
end;

function TSharpESkinDesign.GetMediumText: ISharpESkinText;
begin
  result := FMediumTextInterface;
end;

function TSharpESkinDesign.GetMenuItemSkin: ISharpEMenuItemSkin;
begin
  result := FMenuItemInterface;
end;

function TSharpESkinDesign.GetMenuSkin: ISharpEMenuSkin;
begin
  result := FMenuInterface;
end;

function TSharpESkinDesign.GetMiniThrobberSkin: ISharpEMiniThrobberSkin;
begin
  result := FMiniThrobberInterface;
end;

function TSharpESkinDesign.GetName: String;
begin
  result := FName;
end;

function TSharpESkinDesign.GetNotifySkin: ISharpENotifySkin;
begin
  result := FNotifyInterface;
end;

function TSharpESkinDesign.GetOSDText: ISharpESkinText;
begin
  result := FOSDTextInterface;
end;

function TSharpESkinDesign.GetProgressBarSkin: ISharpEProgressBarSkin;
begin
  result := FProgressBarInterface;
end;

function TSharpESkinDesign.GetSmallText: ISharpESkinText;
begin
  result := FSmallTextInterface;
end;

function TSharpESkinDesign.GetTaskItemSkin: ISharpETaskItemSkin;
begin
  result := FTaskItemInterface;
end;

function TSharpESkinDesign.GetTaskPreviewSkin: ISharpETaskPreviewSkin;
begin
  result := FTaskPreviewInterface;
end;

function TSharpESkinDesign.GetTextPosBL: TPoint;
begin
  result := Point(FTextPosBL.XAsInt,FTextPosBL.YAsInt);
end;

function TSharpESkinDesign.GetTextPosBottomBL: TPoint;
begin
  result := Point(FTextPosBottomBL.XAsInt,FTextPosBottomBL.YAsInt);
end;

function TSharpESkinDesign.GetTextPosBottomTL: TPoint;
begin
  result := Point(FTextPosBottomTL.XAsInt,FTextPosBottomTL.YAsInt);
end;

function TSharpESkinDesign.GetTextPosTL: TPoint;
begin
  result := Point(FTextPosTL.XAsInt,FTextPosTL.YAsInt);                                                        
end;

procedure TSharpESkin.SaveToStream(Stream: TStream; SaveBitmap: boolean);
var
  designCount : integer;
  n : integer;
begin
  FSkinversion := 2.0; //add 1 when not compatible
  Stream.WriteBuffer(FSkinversion, sizeof(FSkinversion));
  StringSaveToStream(FSkinName, Stream);
  designCount := FSkinDesigns.Count;
  Stream.WriteBuffer(designCount,sizeof(designCount));

  for n := 0 to FSkinDesigns.Count - 1 do
  begin
    TSharpESkinDesign(FSkinDesigns.Items[n]).SaveToStream(Stream);
  end;
end;

procedure TSharpESkin.SetSkinName(const Value: TSkinName);
begin
  if FileExists(Value) then
  begin
    FSkinName := ExtractFileName(Value);
    LoadFromSkin(Value);
  end
  else
    if Value = '' then
    begin
      FSkinName := Value;
      Clear;
    end;
end;

{ TSharpENotifySkin }

procedure TSharpENotifySkin.Assign(src: TSharpENotifySkin);
begin
  FSkinDim.Assign(src.FSkinDim);
  FCATBOffset.Assign(src.FCATBOffset);
  FCALROffset.Assign(src.FCALROffset);
  FBackground.Assign(src.FBackground);
end;

procedure TSharpENotifySkin.Clear;
begin
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('256','64');
  FCATBOffset.SetPoint('0','0');
  FCALROffset.SetPoint('0','0');
  FBackground.Clear;
end;

constructor TSharpENotifySkin.Create(BmpList: TSkinBitmapList);
begin
  Inherited Create;

  FSkinDim := TSkinDim.Create;
  FCATBOffset := TSkinPoint.Create;
  FCALROffset := TSkinPoint.Create;

  FBackground := TSkinPartEx.Create(BmpList);
  FBackgroundInterface := FBackground;

  Clear;
end;

destructor TSharpENotifySkin.Destroy;
begin
  FSkinDim.Free;
  FCATBOffset.Free;
  FCALROffset.Free;
  FBackgroundInterface := nil;

  inherited Destroy;
end;

function TSharpENotifySkin.GetBackground: ISharpESkinPartEx;
begin
  result := FBackgroundInterface;
end;

function TSharpENotifySkin.GetCALROffset: TPoint;
begin
  result := Point(FCALROffset.XAsInt,FCALROffset.YAsInt);
end;

function TSharpENotifySkin.GetCATBOffset: TPoint;
begin
  result := Point(FCATBOffset.XAsInt,FCATBOffset.YAsInt);
end;

function TSharpENotifySkin.GetDimension: TPoint;
begin
  result := Point(FSkinDim.WidthAsInt,FSkinDim.HeightAsInt);
end;

function TSharpENotifySkin.GetLocation: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
end;

procedure TSharpENotifySkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FCATBOffset.LoadFromStream(Stream);
  FCALROffset.LoadFromStream(Stream);
  FBackground.LoadFromStream(Stream);
end;

procedure TSharpENotifySkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var
  SkinText: TSkinText;
  SkinIcon : TSkinIcon;
begin
  SkinIcon := TSkinIcon.Create(True);
  SkinIcon.DrawIcon := False;
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['catboffset'] <> nil then
        FCATBOffset.SetPoint(Value('catboffset', '0,0'));
      if ItemNamed['calroffset'] <> nil then
        FCALROffset.SetPoint(Value('calroffset','0,0'));    
    end;

    with xml.Items do
    begin
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);

      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText, SkinIcon, FontList)
      else FBackground.AssignIconAndText(SkinText, SkinIcon);
    end;
  finally
    SkinText.SelfInterface := nil;
    SkinIcon.SelfInterface := nil;
  end;
end;

procedure TSharpENotifySkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FCATBOffset.SaveToStream(Stream);
  FCALROffset.SaveToStream(Stream);
  FBackground.SaveToStream(Stream);
end;

procedure TSharpENotifySkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FBackground.UpdateDynamicProperties(cs);
end;

{ TSharpETaskPreviewSkin }

procedure TSharpETaskPreviewSkin.Assign(src: TSharpETaskPreviewSkin);
begin
  FSkinDim.Assign(src.FSkinDim);
  FCATBOffset.Assign(src.FCATBOffset);
  FCALROffset.Assign(src.FCALROffset);
  FBackground.Assign(src.FBackground);
  FHover.Assign(src.FHover);
end;

procedure TSharpETaskPreviewSkin.Clear;
begin
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('256','64');
  FCATBOffset.SetPoint('0','0');
  FCALROffset.SetPoint('0','0');
  FBackground.Clear;
  FHover.Clear;
end;

constructor TSharpETaskPreviewSkin.Create(BmpList: TSkinBitmapList);
begin
  Inherited Create;

  FSkinDim := TSkinDim.Create;
  FCATBOffset := TSkinPoint.Create;
  FCALROffset := TSkinPoint.Create;

  FBackground := TSkinPartEx.Create(BmpList);
  FHover      := TSkinPartEx.Create(BmpList);

  FBackgroundInterface := FBackground;
  FHoverInterface      := FHover;

  Clear;
end;

destructor TSharpETaskPreviewSkin.Destroy;
begin
  FSkinDim.Free;
  FCATBOffset.Free;
  FCALROffset.Free;
  FBackgroundInterface := nil;
  FHoverInterface := nil;

  inherited Destroy;
end;

function TSharpETaskPreviewSkin.GetBackground: ISharpESkinPartEx;
begin
  result := FBackgroundInterface;
end;

function TSharpETaskPreviewSkin.GetCALROffset: TPoint;
begin
  result := Point(FCALROffset.XAsInt,FCALROffset.YAsInt);
end;

function TSharpETaskPreviewSkin.GetCATBOffset: TPoint;
begin
  result := Point(FCATBOffset.XAsInt,FCATBOffset.YAsInt);
end;

function TSharpETaskPreviewSkin.GetDimension: TPoint;
begin
  result := Point(FSkinDim.WidthAsInt,FSkinDim.HeightAsInt);
end;

function TSharpETaskPreviewSkin.GetHover: ISharpESkinPartEx;
begin
  result := FHoverInterface;
end;

function TSharpETaskPreviewSkin.GetLocation: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
end;

procedure TSharpETaskPreviewSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FCATBOffset.LoadFromStream(Stream);
  FCALROffset.LoadFromStream(Stream);
  FBackground.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
end;

procedure TSharpETaskPreviewSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var
  SkinText: TSkinText;
  SkinIcon : TSkinIcon;
begin
  SkinIcon := TSkinIcon.Create(True);
  SkinIcon.DrawIcon := False;
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['catboffset'] <> nil then
        FCATBOffset.SetPoint(Value('catboffset', '0,0'));
      if ItemNamed['calroffset'] <> nil then
        FCALROffset.SetPoint(Value('calroffset','0,0'));
    end;

    with xml.Items do
    begin
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);

      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText, SkinIcon, FontList)
      else FBackground.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText, SkinIcon, FontList)
      else FHover.AssignIconAndText(SkinText, SkinIcon);
    end;
  finally
    SkinText.SelfInterface := nil;
    SkinIcon.SelfInterface := nil;
  end;
end;

procedure TSharpETaskPreviewSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FCATBOffset.SaveToStream(Stream);
  FCALROffset.SaveToStream(Stream);
  FBackground.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
end;

procedure TSharpETaskPreviewSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FBackground.UpdateDynamicProperties(cs);
  FHover.UpdateDynamicProperties(cs);
end;

{ TSharpETaskItemState }

procedure TSharpETaskItemState.Assign(src: TSharpETaskItemState);
begin
  FHasSpecial := src.HasSpecial;
  FHasOverlay := src.HasOverlay;
  FSpacing := src.FSpacing;

  FSkinDim.Assign(src.FSkinDim);
  FNormal.Assign(src.FNormal);
  FNormalHover.Assign(src.FNormalHover);
  FDown.Assign(src.FDown);
  FDownHover.Assign(src.FDownHover);
  FHighlight.Assign(src.FHighlight);
  FHighlightHover.Assign(src.FHighlightHover);
  FSpecial.Assign(src.FSpecial);
  FSpecialHover.Assign(src.FSpecialHover);
  FOverlayText.Assign(src.FOverlayText);
  FHighlightSettings.Assign(src.FHighlightSettings);
end;

procedure TSharpETaskItemState.Clear;
begin
  FHasSpecial := False;
  FHasOverlay := False;
  FSkinDim.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
  FNormal.Clear;
  FNormalHover.Clear;
  FDown.Clear;
  FDownHover.Clear;
  FHighlight.Clear;
  FHighlightHover.Clear;
  FSpecial.Clear;
  FOverlayText.Clear;
  FHighlightSettings.Clear;
  FSpacing := 2;
end;

constructor TSharpETaskItemState.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;

  FNormal         := TSkinPartEx.Create(BmpList);
  FNormalHover    := TSkinPartEx.Create(BmpList);
  FDown           := TSkinPartEx.Create(BmpList);
  FDownHover      := TSkinPartEx.Create(BmpList);
  FHighlight      := TSkinPartEx.Create(BmpList);
  FHighlightHover := TSkinPartEx.Create(BmpList);
  FSpecial        := TSkinPartEx.Create(BmpList);
  FSpecialHover   := TSkinPartEx.Create(BmpList);

  FHighlightSettings := TSharpESkinHighlightSettings.Create;

  FOverlayText := TSkinText.Create(False);

  FNormalInterface         := FNormal;
  FNormalHoverInterface    := FNormalHover;
  FDownInterface           := FDown;
  FDownHoverInterface      := FDownHover;
  FHighlightInterface      := FHighlight;
  FHighlightHoverInterface := FHighlightHover;
  FSpecialInterface        := FSpecial;
  FSpecialHoverInterface   := FSpecialHover;

  FHighlightSettingsInterface := FHighlightSettings;

  FOverlayTextInterface := FOverlayText;

  Clear;  
end;

destructor TSharpETaskItemState.Destroy;
begin
  FSkinDim.Free;

  FNormalInterface         := nil;
  FNormalHoverInterface    := nil;
  FDownInterface           := nil;
  FDownHoverInterface      := nil;
  FHighlightInterface      := nil;
  FHighlightHoverInterface := nil;
  FSpecialInterface        := nil;
  FSpecialHoverInterface   := nil;
  
  FHighlightSettingsInterface := nil;

  FOverlayTextInterface   := nil;

  inherited;
end;

function TSharpETaskItemState.GetDimension: TPoint;
begin
  result := Point(FSkinDim.WidthAsInt,FSkinDim.HeightAsInt);
end;

function TSharpETaskItemState.GetDown: ISharpESkinPartEx;
begin
  result := FDownInterface;
end;

function TSharpETaskItemState.GetDownHover: ISharpESkinPartEx;
begin
  result := FDownHoverInterface;
end;

function TSharpETaskItemState.GetHasOverlay: boolean;
begin
  result := FHasOverlay;
end;

function TSharpETaskItemState.GetHasSpecial: boolean;
begin
  result := FHasSpecial;
end;

function TSharpETaskItemState.GetHighlight: ISharpESkinPartEx;
begin
  result := FHighlightInterface;
end;

function TSharpETaskItemState.GetHighlightHover: ISharpESkinPartEx;
begin
  result := FHighlightHoverInterface;
end;

function TSharpETaskItemState.GetHighlightSettings: ISharpESkinHighlightSettings;
begin
  result := FHighlightSettingsInterface;
end;

function TSharpETaskItemState.GetLocation: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
end;

function TSharpETaskItemState.GetNormal: ISharpESkinPartEx;
begin
  result := FNormalInterface;
end;

function TSharpETaskItemState.GetNormalHover: ISharpESkinPartEx;
begin
  result := FNormalHoverInterface;
end;

function TSharpETaskItemState.GetOverlayText: ISharpESkinText;
begin
  result := FOverlayTextInterface;
end;

function TSharpETaskItemState.GetSpacing: integer;
begin
  result := FSpacing;
end;

function TSharpETaskItemState.GetSpecial: ISharpESkinPartEx;
begin
  result := FSpecialInterface;
end;

function TSharpETaskItemState.GetSpecialHover: ISharpESkinPartEx;
begin
  result := FSpecialHoverInterface;
end;

procedure TSharpETaskItemState.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FNormalHover.LoadFromStream(Stream);
  FDown.LoadFromStream(Stream);
  FDownHover.LoadFromStream(Stream);
  FHighlight.LoadFromStream(Stream);
  FHighlightHover.LoadFromStream(Stream);
  FSpecial.LoadFromStream(Stream);
  FSpecialHover.LoadFromStream(Stream);

  FHighlightSettings.LoadFromStream(Stream);
  
  FOverlayText.LoadFromStream(Stream);

  FSpacing := StrToInt(StringLoadFromStream(Stream));

  if StringLoadFromStream(Stream) = '1' then FHasSpecial := True
     else FHasSpecial := False;
  if StringLoadFromStream(Stream) = '1' then FHasOverlay := True
     else FHasOverlay := False;       
end;

procedure TSharpETaskItemState.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var
  SkinText: TSkinText;
  SkinIcon: TSkinIcon;
begin
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  SkinIcon := TSkinIcon.Create(True);
  SkinIcon.DrawIcon := True;

  try
    with xml.Properties do
    begin
      if ItemNamed['dimension'] <> nil then
         FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
         FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['spacing'] <> nil then
         FSpacing := IntValue('spacing',2);    
    end;

    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
         SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['icon'] <> nil then
         SkinIcon.LoadFromXML(ItemNamed['icon']);

      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'],path,SkinText,SkinIcon, FontList)
      else FNormal.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['normalhover'] <> nil then
         FNormalHover.LoadFromXML(ItemNamed['normalhover'],path,SkinText,SkinIcon, FontList)
      else FNormalHover.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['down'] <> nil then
         FDown.LoadFromXML(ItemNamed['down'],path,SkinText,SkinIcon, FontList)
      else FDown.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['downhover'] <> nil then
         FDownHover.LoadFromXML(ItemNamed['downhover'],path,SkinText,SkinIcon, FontList)
      else FDownHover.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['highlight'] <> nil then
         FHighlight.LoadFromXML(ItemNamed['highlight'],path,SkinText,SkinIcon, FontList)
      else FHighlight.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['highlighthover'] <> nil then
         FHighlightHover.LoadFromXML(ItemNamed['highlighthover'],path,SkinText,SkinIcon, FontList)
      else FHighlightHover.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['special'] <> nil then
      begin
        FHasSpecial := True;
        FSpecial.LoadFromXML(ItemNamed['special'],path,SkinText,SkinIcon, FontList);
      end else FSpecial.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['overlaytext'] <> nil then
      begin
        FHasOverlay := True;
        FOverlayText.LoadFromXML(ItemNamed['overlaytext'], FontList);
      end;
      if ItemNamed['specialhover'] <> nil then
         FSpecialHover.LoadFromXML(ItemNamed['specialhover'],path,SkinText,SkinIcon, FontList)
      else FSpecialHover.AssignIconAndText(SkinText, SkinIcon);
      if ItemNamed['highlightsettings']  <> nil then
        FHighlightSettings.LoadFromXML(ItemNamed['highlightsettings']);
    end;
  finally
    SkinText.SelfInterface := nil;
    SkinIcon.SelfInterface := nil;
  end;
end;

procedure TSharpETaskItemState.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FNormal.SaveToStream(Stream);
  FNormalHover.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FDownHover.SaveToStream(Stream);
  FHighlight.SaveToStream(Stream);
  FHighlightHover.SaveToStream(Stream);
  FSpecial.SaveToStream(Stream);
  FSpecialHover.SaveToStream(Stream);

  FHighlightSettings.SaveToStream(Stream);
  
  FOverlayText.SaveToStream(Stream);

  StringSaveToStream(inttostr(FSpacing),Stream);

  if FHasSpecial then StringSavetoStream('1', Stream)
     else StringSavetoStream('0', Stream);
  if FHasOverlay then StringSavetoStream('1', Stream)
     else StringSavetoStream('0', Stream);     
end;

procedure TSharpETaskItemState.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FNormalHover.UpdateDynamicProperties(cs);
  FDown.UpdateDynamicProperties(cs);
  FDownHover.UpdateDynamicProperties(cs);
  FHighlight.UpdateDynamicProperties(cs);
  FHighlightHover.UpdateDynamicProperties(cs);
  FSpecial.UpdateDynamicProperties(cs);
  FSpecialHover.UpdateDynamicProperties(cs);
  FOverlayText.UpdateDynamicProperties(cs);
  FHighlightSettings.UpdateDynamicProperties(cs);
end;

initialization

finalization

end.
