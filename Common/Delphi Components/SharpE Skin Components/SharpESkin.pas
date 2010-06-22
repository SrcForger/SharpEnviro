{
Source Name: SharpESkin                               
Description: Core Skin loading classes
Copyright (C) Lee Green <Pixol@SharpE-Shell.org>
              Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

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
  TSharpEButtonSkin = class;
  TSharpEBarSkin = class;
  TSharpEProgressBarSkin = class;
  TSharpESkinHeader = class;
  TSharpEMiniThrobberSkin = class;
  TSharpEEditSkin = class;
  TSharpETaskItemSkin = class;
  TSharpEMenuSkin = class;
  TSharpEMenuItemSkin = class;
  TSharpETaskSwitchSkin = class;
  TSharpENotifySkin = class;
  TSharpETaskPreviewSkin = class;
  TSkinEvent = procedure of object;

  TSkinName = string;
  TXmlFileName = string;    
  TSkinFileName = string;

  TSharpESkin = class(TInterfacedObject, ISharpESkin)
  private
    FSkinName: TSkinName;
    FSkinText: TSkinText;
    FTextPosTL : TSkinPoint;
    FTextPosBL : TSkinPoint;
    FSkinVersion: Double;
    FBitmapList: TSkinBitmapList;
    FLoadSkins : TSharpESkinItems;

    FOnNotify: TSkinEvent;

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
    FTaskSwitchSkin   : TSharpETaskSwitchSkin;
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
    FTaskSwitchInterface   : ISharpETaskSwitchSkin;
    FMiniThrobberInterface : ISharpEMiniThrobberSkin;
    FTaskPreviewInterface  : ISharpETaskPreviewSkin;

    FSkinHeader: TSharpeSkinHeader;
    FXml: TJclSimpleXml;
    FXmlFileName: TXmlFileName;

    procedure SetXmlFileName(const Value: TXmlFileName);
    function GetSkinAuthor: string;
    function GetSkinName: string;
    function GetSkinUrl: string;
    function GetSkinVersion: string;
    procedure SetSkinName(const Value: TSkinName);

    function GetButtonSkin       : ISharpEButtonSkin; stdcall;
    function GetEditSkin         : ISharpEEditSkin; stdcall;
    function GetProgressBarSkin  : ISharpEProgressBarSkin; stdcall;
    function GetMenuSkin         : ISharpEMenuSkin; stdcall;
    function GetMenuItemSkin     : ISharpEMenuItemSkin; stdcall;
    function GetBarSkin          : ISharpEbarskin; stdcall;
    function GetNotifySkin       : ISharpENotifySkin; stdcall;
    function GetTaskItemSkin     : ISharpETaskItemSkin; stdcall;
    function GetTaskSwitchSkin   : ISharpETaskSwitchSkin; stdcall;
    function GetMiniThrobberSkin : ISharpEMiniThrobberSkin; stdcall;
    function GetTaskPreviewSkin  : ISharpETaskPreviewSkin; stdcall;

    function GetSmallText  : ISharpESkinText; stdcall;
    function GetMediumText : ISharpESkinText; stdcall;
    function GetLargeText  : ISharpESkinText; stdcall;
    function GetOSDText    : ISharpESkinText; stdcall;

    function GetTextPosTL : TPoint; stdcall;
    function GetTextPosBL : TPoint; stdcall;    
  protected
  public
    constructor Create; overload;
    constructor Create(Skins: TSharpESkinItems); reintroduce; overload;
    constructor CreateBmp(BmpList : TSkinBitmapList; Skins: TSharpESkinItems = ALL_SHARPE_SKINS); overload;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromXmlFile(filename: string); virtual;
    procedure LoadFromSkin(filename: string); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;

    procedure SaveToSkin(filename: string); virtual;
    procedure SaveToStream(Stream: TStream); overload; virtual;
    procedure SaveToStream(Stream: TStream; SaveBitmap:boolean); overload; virtual;

    property Button       : ISharpEButtonSkin read GetButtonSkin;
    property Edit         : ISharpEEditSkin read GetEditSkin;
    property ProgressBar  : ISharpEProgressBarSkin read GetProgressBarSkin;
    property Menu         : ISharpEMenuSkin read GetMenuSkin;
    property MenuItem     : ISharpEMenuItemSkin read GetMenuItemSkin;
    property Bar          : ISharpEBarSkin read GetBarSkin;
    property Notify       : ISharpENotifySkin read GetNotifySkin;
    property TaskItem     : ISharpETaskItemSkin read GetTaskItemSkin;
    property TaskSwitch   : ISharpETaskSwitchSkin read GetTaskSwitchSkin;
    property MiniThrobber : ISharpEMiniThrobberSkin read GetMiniThrobberSkin;
    property TaskPreview  : ISharpETaskPreviewSkin read GetTaskPreviewSkin;

    property SmallText  : ISharpESkinText read GetSmallText;
    property MediumText : ISharpESkinText read GetMediumText;
    property LargeText  : ISharpESkinText read GetLargeText;
    property OSDText    : ISharpESkinText read GetOSDText;

    property TextPosTL : TPoint read GetTextPosTL;
    property TextPosBL : TPoint read GetTextPosBL;    

    property OnNotify: TSkinEvent read FOnNotify write FOnNotify;
    property BarSkin: TSharpEBarSkin read FBarSkin;

    property SkinText: TSkinText read FSkinText;
    property BitmapList: TSkinBitmapList read FBitmapList write FBitmapList;

    procedure RemoveNotUsedBitmaps;
    procedure UpdateDynamicProperties(Scheme : ISharpEScheme); stdcall;

    procedure FreeInstance; override;

    property _SkinName: string read GetSkinName;
    property _SkinVersion: string read GetSkinVersion;
    property _SkinAuthor: string read GetSkinAuthor;
    property _SkinUrl: string read GetSkinUrl;

    property XmlFilename: TXmlFileName read FXmlFileName write SetXmlFileName;
    property Skin: TSkinName read FSkinName write SetSkinName;
  end;

  TSharpESkinHeader = class
  private
    FVersion: string;
    FAuthor: string;
    FName: string;
    FUrl: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXml(xml: TJclSimpleXmlElem; path: string);

    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Url: string read FUrl write FUrl;
    property Version: string read FVersion write FVersion;
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
    FOnNormalMouseEnterScript    : String;
    FOnNormalMouseLeaveScript    : String;
    FOnDownMouseEnterScript      : String;
    FOnDownMouseLeaveScript      : String;
    FOnHighlightMouseEnterScript : String;
    FOnHighlightMouseLeaveScript : String;
    FOnHighlightStepStartScript  : String;
    FOnHighlightStepEndScript    : String;

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

    function GetOnNormalMouseEnterScript  : String; stdcall;
    function GetOnNormalMouseLeaveScript  : String; stdcall;
    function GetOnDownMouseEnterScript    : String; stdcall;
    function GetOnDownMouseLeaveScript    : String; stdcall;
    function GetOnHighlightMouseEnterScript : String; stdcall;
    function GetOnHighlightMouseLeaveScript : String; stdcall;
    function GetOnHighlightStepStartScript  : String; stdcall;
    function GetOnHighlightStepEndScrtipt   : String; stdcall;                           
  public
    constructor Create(BmpList : TSkinBitmapList); reintroduce;
    destructor Destroy; override;
    procedure Clear;
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

    property HasSpecial : boolean read GetHasSpecial;
    property HasOverlay : boolean read GetHasOverlay;
    property Location : TPoint read GetLocation;
    property Spacing : integer read GetSpacing;
    property Dimension : TPoint read GetDimension;

    property OnNormalMouseEnterScript    : String read GetOnNormalMouseEnterScript;
    property OnNormalMouseLeaveScript    : String read GetOnNormalMouseLeaveScript;
    property OnDownMouseEnterScript      : String read GetOnDownMouseEnterScript;
    property OnDownMouseLeaveScript      : String read GetOnDownMouseLeaveScript;
    property OnHighlightMouseEnterScript : String read GetOnHighlightMouseEnterScript;
    property OnHighlightMouseLeaveScript : String read GetOnHighlightMouseLeaveScript;
    property OnHighlightStepStartScript  : String read GetOnHighlightStepStartScript;
    property OnHighlightStepEndScript    : String read GetOnHighlightStepEndScrtipt;
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

  TSharpETaskSwitchSkin = class(TInterfacedObject, ISharpETaskSwitchSkin)
  private
    FSkinDim : TSkinDim;

    FBackground : TSkinPart;
    FItem       : TSkinPart;
    FItemHover  : TSkinPart;

    FBackgroundInterface : ISharpESkinPart;
    FItemInterface       : ISharpEskinPart;
    FItemHoverInterface  : ISharpESkinPart;

    FItemPreview      : TSkinDim;
    FItemHoverPreview : TSkinDim;
    FTBOffset         : TSkinPoint;
    FLROffset         : TSkinPoint;
    FWrapCount        : integer;
    FSpacing          : integer;

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
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

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

    property SkinDim : TSkinDim read FSkinDim;
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
    
    FNormal  : TSkinPartEx;
    FDown    : TSkinPartEx;
    FHover   : TSkinPartEx;

    FNormalInterface : ISharpESkinPartEx;
    FDownInterface   : ISharpESkinPartEx;
    FHoverInterface  : ISharpESkinPartEx;

    FWidthMod : integer;

    FOnNormalMouseEnterScript : String;
    FOnNormalMouseLeaveScript : String;

    function GetNormal : ISharpESkinPartEx; stdcall;
    function GetDown   : ISharpESkinPartEx; stdcall;
    function GetHover  : ISharpESkinPartEx; stdcall;

    function GetWidthMod : integer; stdcall;

    function GetOnNormalMouseEnterScript : String; stdcall;
    function GetOnNormalMouseLeaveScript : String; stdcall;      
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
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
    property OnNormalMouseEnterScript : String read GetOnNormalMouseEnterScript;
    property OnNormalMouseLeaveScript : String read GetOnNormalMouseLeaveScript;

    function GetLocation : TPoint; stdcall;    
    function GetValid : Boolean; stdcall;
    property Location : TPoint read GetLocation;    
    property Valid : Boolean read GetValid;
 end;

  TSharpEProgressBarSkin = class(TInterfacedObject, ISharpEProgressBarSkin)
  private
    FSkinDim: TSkinDim;
    FSkinDimTL: TSkinDim;
    FSkinDimBL: TSkinDim;

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
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    function GetAutoDim(r: TRect; vpos : TSharpEBarAutoPos): TRect; stdcall;
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
    function GetEditXOffsets : TPoint; stdcall;
    function GetEditYOffsets : TPoint; stdcall;
    function GetValid : Boolean; stdcall;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJclSimpleXmlElem; path: string);
    function GetAutoDim(r: TRect): TRect; stdcall;
    procedure UpdateDynamicProperties(cs: ISharpEScheme);

    property Normal : ISharpESkinPart read GetNormal;
    property Hover  : ISharpESkinPart read GetHover;
    property Focus  : ISharpESkinPart read GetFocus;

    property Dimension : TPoint read GetDimension;    
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


function LoadScriptFromFile(FileName : String) : String;
var
  SList : TStringList;
begin
  result := '';
  if not FileExists(FileName) then exit;
  SList := TStringList.Create;
  SList.Clear;
  try
    SList.LoadFromFile(FileName);
    result := SList.CommaText;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpESkin','Error loading script from file: ' + FileName,clred,DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpESkin',E.Message,clred,DMT_ERROR);
    end;
  end;
  SList.Free;
end;

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

  FLoadSkins := Skins;

  if FBitmaplist = nil then
    FBitmapList := TSkinBitmapList.Create;

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
  FSkinHeader := TSharpeSkinHeader.Create;
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
  if scTaskSwitch in FLoadSkins then
  begin
    FTaskSwitchSkin := TSharpETaskSwitchSkin.Create(FBitmapList);
    FTaskSwitchInterface := FTaskSwitchSkin;
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

  FXml := TJclSimpleXml.Create;
end;

constructor TSharpESkin.CreateBmp(BmpList : TSkinBitmapList; Skins: TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FBitmapList := bmpList;
  Create(Skins);
end;

destructor TSharpESkin.Destroy;
begin
  FXml.Free;
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
  FSkinHeader.Free;
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
  if FTaskSwitchSkin <> nil then
  begin
    FTaskSwitchInterface := nil;
    FTaskSwitchSkin := nil;
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

  if FontList <> nil then
  begin
    FontList.Free;
    FontList := nil;
  end;

  inherited;
end;

procedure TSharpESkin.UpdateDynamicProperties(Scheme : ISharpEScheme);
begin
  if FButtonSkin <> nil then FButtonSkin.UpdateDynamicProperties(Scheme);
  if FProgressBarskin <> nil then FProgressBarSkin.UpdateDynamicProperties(Scheme);
  if FBarSkin <> nil then FBarSkin.UpdateDynamicProperties(Scheme);
  if FTaskItemSkin <> nil then FTaskItemSkin.UpdateDynamicProperties(Scheme);
  if FMiniThrobberSkin <> nil then FMiniThrobberSkin.UpdateDynamicProperties(Scheme);
  if FEditSkin <> nil then FEditSkin.UpdateDynamicProperties(Scheme);
  if FMenuSkin <> nil then FMenuSkin.UpdateDynamicProperties(Scheme);
  if FMenuItemSkin <> nil then FMenuItemSkin.UpdateDynamicProperties(Scheme);
  if FTaskSwitchSkin <> nil then FTaskSwitchSkin.UpdateDynamicProperties(Scheme);
  if FNotifySkin <> nil then FNotifySkin.UpdateDynamicProperties(Scheme);
  if FTaskPreviewSkin <> nil then FTaskPreviewSkin.UpdateDynamicProperties(Scheme);


  FSkinText.UpdateDynamicProperties(Scheme);
  FSmallText.UpdateDynamicProperties(Scheme);
  FMediumText.UpdateDynamicProperties(Scheme);
  FLargeText.UpdateDynamicProperties(Scheme);
  FOSDText.UpdateDynamicProperties(Scheme);
end;

procedure TSharpESkin.RemoveNotUsedBitmaps;

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
  if FTaskSwitchSkin <> nil then
  begin
    RemoveskinpartBitmaps(FTaskSwitchSkin.FBackground,List);
    RemoveskinpartBitmaps(FTaskSwitchSkin.FItem,List);
    RemoveskinpartBitmaps(FTaskSwitchSkin.FItemHover,List);
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

procedure TSharpESkin.SaveToStream(Stream: TStream);
begin
  SaveToStream(Stream,true);
end;

procedure TSharpESkin.SaveToStream(Stream: TStream; SaveBitmap:boolean);
var tempStream: TMemoryStream;
  size: int64;
begin
  FSkinversion := 2.0; //add 1 when not compatible
  Stream.WriteBuffer(FSkinversion, sizeof(FSkinversion));
  StringSaveToStream(FSkinName, Stream);
  FSkinText.SaveToStream(Stream);
  FSmallText.SaveToStream(Stream);
  FMediumText.SaveToStream(Stream);
  FLargeText.SaveToStream(Stream);
  FOSDText.SaveToStream(Stream);
  FTextPosTL.SaveToStream(Stream);
  FTextPosBL.SaveToStream(Stream);
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

    //Write Task Switch Skin
    if FTaskSwitchSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('TaskSwitch', Stream);
      FTaskSwitchSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write Notify Skin
    if FTaskSwitchSkin <> nil then
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

    //Write Header
    {StringSaveToStream('Header', Stream);
    FSkinHeader.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);   }

    StringSaveToStream('End', Stream);
  finally
    TempStream.Free;
  end;
end;

procedure TSharpESkin.LoadFromStream(Stream: TStream);
var temp          : string;
  size            : int64;
  BmpListInStream : boolean;
begin
  if FontList <> nil then
    FontList.RefreshFontInfo;
  
  Clear;
  try
    Stream.ReadBuffer(FSkinVersion, sizeof(FSkinVersion));
    if (floor(FSkinVersion) <> 2) then
      exit;
    temp := StringLoadFromStream(Stream);
    if temp <> '' then
      FSkinName := temp;

    FSkinText.LoadFromStream(Stream);
    FSmallText.LoadFromStream(Stream);
    FMediumText.LoadFromStream(Stream);
    FLargeText.LoadFromStream(Stream);
    FOSDText.LoadFromStream(Stream);
    FTextPosTL.LoadFromStream(Stream);
    FTextPosBL.LoadFromStream(Stream);
    Stream.ReadBuffer(BmpListInStream, sizeof(BmpListInStream));
    if BmpListInStream then
      FBitmapList.LoadFromStream(Stream);
    temp := StringLoadFromStream(Stream);
    while temp <> 'End' do
    begin
      Stream.ReadBuffer(size, sizeof(size));

      if temp = 'Header' then
        FSkinHeader.LoadFromStream(Stream)
      else if (temp = 'Button') and (FButtonSkin <> nil) then
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
      else if (temp = 'TaskSwitch') and (FTaskSwitchSkin <> nil) then
        FTaskSwitchSkin.LoadFromStream(Stream)
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

procedure TSharpESkin.Clear;
begin
  if FButtonSkin <> nil then
    FButtonSkin.Clear;
  if FProgressBarSkin <> nil then
    FProgressBarSkin.Clear;
  if FBarSkin <> nil then
    FBarSkin.Clear;

  FSkinHeader.Clear;
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
  if FTaskSwitchSkin <> nil then
    FTaskSwitchSkin.Clear;
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

  FSkinName := '';
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

procedure TSharpESkin.LoadFromXmlFile(filename: string);
var
  Path: string;
begin
  if FontList <> nil then
    FontList.RefreshFontInfo;

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
      if FBarSkin <> nil then
         BarSkin.CheckValid;
      exit;
    end;
  end;
  Clear;

  // Load Details
  if FXml.Root.Items.ItemNamed['font'] <> nil then
     with FXml.Root.Items.ItemNamed['font'].Items do
     begin
       if ItemNamed['locationTL'] <> nil then
          FTextPosTL.SetPoint(ItemNamed['locationTL'].Value);
       if ItemNamed['locationBL'] <> nil then
          FTextPosBL.SetPoint(ItemNamed['locationBL'].Value);
       if ItemNamed['small'] <> nil then
          FSmallText.LoadFromXML(ItemNamed['small'],FontList);
       if ItemNamed['medium'] <> nil then
          FMediumText.LoadFromXML(ItemNamed['medium'],FontList);
       if ItemNamed['big'] <> nil then
          FLargeText.LoadFromXML(ItemNamed['big'],FontList);
       if ItemNamed['osd'] <> nil then
          FOSDText.LoadFromXML(ItemNamed['osd'],FontList);
     end;
  if FXml.Root.Items.ItemNamed['header'] <> nil then
    FSkinHeader.LoadFromXml(FXml.Root.Items.ItemNamed['header'], path);
  if (FXml.Root.Items.ItemNamed['button'] <> nil) and (FButtonSkin <> nil) then
    FButtonSkin.LoadFromXML(FXml.Root.Items.ItemNamed['button'], path);
  if (FXml.Root.Items.ItemNamed['sharpbar'] <> nil) and (FBarSkin <> nil) then
    FBarSkin.LoadFromXML(FXml.Root.Items.ItemNamed['sharpbar'], path);
  if (FXml.Root.Items.ItemNamed['progressbar'] <> nil) and (FProgressBarSkin <> nil) then
    FProgressBarSkin.LoadFromXML(FXml.Root.Items.ItemNamed['progressbar'], path);
  if (FXml.Root.Items.ItemNamed['minithrobber'] <> nil) and (FMiniThrobberSkin <> nil) then
    FMiniThrobberSkin.LoadFromXML(FXML.Root.Items.ItemNamed['minithrobber'], path);
  if (FXml.Root.Items.ItemNamed['edit'] <> nil) and (FEditSkin <> nil) then
    FEditSkin.LoadFromXML(FXML.Root.Items.ItemNamed['edit'], path);
  if (FXml.Root.Items.ItemNamed['taskitem'] <> nil) and (FTaskItemSkin <> nil) then
    FTaskItemSkin.LoadFromXML(FXml.Root.Items.ItemNamed['taskitem'],path);
  if (FXml.Root.Items.ItemNamed['menu'] <> nil) and (FMenuSkin <> nil) then
    FMenuSkin.LoadFromXML(FXml.Root.Items.ItemNamed['menu'],path);
  if (FXml.Root.Items.ItemNamed['menuitem'] <> nil) and (FMenuItemSkin <> nil) then
    FMenuItemSkin.LoadFromXML(FXml.Root.Items.ItemNamed['menuitem'],path);
  if (FXml.Root.Items.ItemNamed['taskswitch'] <> nil) and (FTaskSwitchSkin <> nil) then
    FTaskSwitchSkin.LoadFromXML(FXML.Root.Items.ItemNamed['taskswitch'],path);
  if (FXml.Root.Items.ItemNamed['notify'] <> nil) and (FNotifySkin <> nil) then
    FNotifySkin.LoadFromXML(FXML.Root.Items.ItemNamed['notify'],path);
  if (FXml.Root.Items.ItemNamed['taskpreview'] <> nil) and (FTaskPreviewSkin <> nil) then
    FTaskPreviewSkin.LoadFromXML(FXML.Root.Items.ItemNamed['taskpreview'],path);

  if FBarSkin <> nil then
     FBarSkin.CheckValid;
end;

//***************************************
//* TSharpETaskSwitchSkin
//***************************************

constructor TSharpETaskSwitchSkin.Create(BmpList:  TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('100','100');

  FBackground := TSkinPart.Create(BmpList);
  FItem       := TSkinPart.Create(BmpList);
  FItemHover  := TSkinPart.Create(BmpList);

  FBackgroundInterface := FBackground;
  FItemInterface       := FItem;
  FItemHoverInterface  := FItemHover;

  FItemPreview := TSkinDim.Create;
  FItemPreview.SetLocation('0','0');
  FItemPreview.SetDimension('48','48');
  FItemHoverPreview := TSkinDim.Create;
  FItemHoverPreview.SetLocation('0','0');
  FItemHoverPreview.SetDimension('48','48');
  FTBOffset   := TSkinPoint.Create;
  FTBOffset.SetPoint('0','0');
  FLROffset   := TSkinPoint.Create;
  FLROffset.SetPoint('0','0');
  FWrapCount := 8;
  FSpacing   := 2;
end;

destructor TSharpETaskSwitchSkin.Destroy;
begin
  FSkinDim.Free;

  FBackgroundInterface := nil;
  FItemInterface := nil;
  FItemHoverInterface := nil;

  FItemPreview.Free;
  FItemHoverPreview.Free;
  FTBOffset.Free;
  FLROffset.Free;
end;

function TSharpETaskSwitchSkin.GetBackground: ISharpESkinPart;
begin
  result := FBackgroundInterface;
end;

function TSharpETaskSwitchSkin.GetItem: ISharpESkinPart;
begin
  result := FItemInterface;
end;

function TSharpETaskSwitchSkin.GetItemDimension: TPoint;
begin
  result := Point(FItem.SkinDim.WidthAsInt,FItem.SkinDim.HeightAsInt);
end;

function TSharpETaskSwitchSkin.GetItemHover: ISharpESkinPart;
begin
  result := FItemHoverInterface;
end;

function TSharpETaskSwitchSkin.GetItemHoverDimension: TPoint;
begin
  result := Point(FItemHover.SkinDim.WidthAsInt,FItemHover.SkinDim.HeightAsInt);
end;

function TSharpETaskSwitchSkin.GetItemHoverPreviewDimension: TPoint;
begin
  result := Point(FItemHoverPreview.WidthAsInt,FItemHoverPreview.HeightAsInt);
end;

function TSharpETaskSwitchSkin.GetItemHoverPreviewLocation: TPoint;
begin
  result := Point(FItemHoverPreview.XAsInt,FItemHoverPreview.YAsInt);
end;

function TSharpETaskSwitchSkin.GetItemPreviewDimension: TPoint;
begin
  result := Point(FItemPreview.WidthAsInt,FItemPreview.HeightAsInt);
end;

function TSharpETaskSwitchSkin.GetItemPreviewLocation: TPoint;
begin
  result := Point(FItemPreview.XAsInt,FItemPreview.YAsInt);
end;

function TSharpETaskSwitchSkin.GetLROffset: TPoint;
begin
  result := Point(FLROffset.XAsInt,FLROffset.YAsInt);
end;

function TSharpETaskSwitchSkin.GetSpacing: integer;
begin
  result := FSpacing;
end;

function TSharpETaskSwitchSkin.GetTBOffset: TPoint;
begin
  result := point(FTBOffset.XAsInt,FTBOffset.YAsInt);
end;

function TSharpETaskSwitchSkin.GetWrapCount: integer;
begin
  result := FWrapCount;
end;

procedure TSharpETaskSwitchSkin.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FBackground.UpdateDynamicProperties(cs);
  FItem.UpdateDynamicProperties(cs);
  FItemHover.UpdateDynamicProperties(cs);
end;

procedure TSharpETaskSwitchSkin.Clear;
begin
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('100','100');
  FTBOffset.SetPoint('0','0');
  FLROffset.SetPoint('0','0');
  FItemPreview.SetLocation('0','0');
  FItemPreview.SetDimension('48','48');
  FItemHoverPreview.SetLocation('0','0');
  FItemHoverPreview.SetDimension('48','48');
  FBackground.Clear;
  FItem.Clear;
  FItemHover.Clear;
  FWrapCount := 8;
  FSpacing   := 2;  
end;

procedure TSharpETaskSwitchSkin.LoadFromStream(Stream : TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FBackground.LoadFromStream(Stream);
  FItem.LoadFromStream(Stream);
  FItemHover.LoadFromStream(Stream);
  FItemPreview.LoadFromStream(Stream);
  FItemHoverPreview.LoadFromStream(Stream);
  FTBOffset.LoadFromStream(Stream);
  FLROffset.LoadFromStream(Stream);
  Stream.ReadBuffer(FWrapCount,SizeOf(FWrapCount));
  Stream.ReadBuffer(FSpacing,SizeOf(FSpacing));
end;

procedure TSharpETaskSwitchSkin.SaveToStream(Stream : TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FBackground.SaveToStream(Stream);
  FItem.SaveToStream(Stream);
  FItemHover.SaveToStream(Stream);
  FItemPreview.SaveToStream(Stream);
  FItemHoverPreview.SaveToStream(Stream);
  FTBOffset.SaveToStream(Stream);
  FLROffset.SaveToStream(Stream);
  Stream.WriteBuffer(FWrapCount,SizeOf(FWrapCount));
  Stream.WriteBuffer(FSpacing,SizeOf(FSpacing));
end;

procedure TSharpETaskSwitchSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var
  SkinText: TSkinText;
begin
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText, FontList);
      if ItemNamed['item'] <> nil then
        FItem.LoadFromXML(ItemNamed['item'], path, SkinText);
      if ItemNamed['itemhover'] <> nil then
        FItemHover.LoadFromXML(ItemNamed['itemhover'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['tboffset'] <> nil then
        FTBOffset.SetPoint(Value('tboffset','0,0'));
      if ItemNamed['lroffset'] <> nil then
        FLROffset.SetPoint(Value('lroffset','0,0'));
      if ItemNamed['previewdim'] <> nil then
        FItemPreview.SetDimension(Value('previewdim', '48,48'));
      if ItemNamed['previewloc'] <> nil then
        FItemPreview.SetLocation(Value('previewloc','0,0'));
      if ItemNamed['hoverpreviewdim'] <> nil then
        FItemHoverPreview.SetDimension(Value('hoverpreviewdim', '48,48'));
      if ItemNamed['hoverpreviewloc'] <> nil then
        FItemHoverPreview.SetLocation(Value('hoverpreviewloc','0,0'));
      FWrapCount := IntValue('WrapCount',8);
      FSpacing := IntValue('Spacing',2);
    end;
  finally
    SkinText.SelfInterface := nil;
  end;
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
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'],FontList);
      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText, FontList);
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
    with xml.Items do
    begin
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['Separator'] <> nil then
        FSeparator.LoadFromXML(ItemNamed['Separator'], path, SkinText, FontList);
      if ItemNamed['normal'] <> nil then
        FNormalItem.LoadFromXML(ItemNamed['normal'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['down'] <> nil then
        FDownItem.LoadFromXML(ItemNamed['down'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['normalsub'] <> nil then
        FNormalSubItem.LoadFromXML(ItemNamed['normalsub'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['hover'] <> nil then
        FHoverItem.LoadFromXML(ItemNamed['hover'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['hoversub'] <> nil then
        FHoverSubItem.LoadFromXML(ItemNamed['hoversub'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['label'] <> nil then
        FLabelItem.LoadFromXml(ItemNamed['label'], path, SkinText, SkinIcon, FontList);
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
  FSkinDim.SetDimension('w', 'h');

  FNormal := TSkinPartEx.Create(BmpList);
  FDown   := TSkinPartEx.Create(BmpList);
  FHover  := TSkinPartEx.Create(BmpList);

  FNormalInterface := FNormal;
  FDownInterface   := FDown;
  FHoverInterface  := FHover;

  FOnNormalMouseEnterScript   := '';
  FOnNormalMouseLeaveScript   := '';
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
  FNormal.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  StringSaveToStream(FOnNormalMouseEnterScript,Stream);
  StringSaveToStream(FOnNormalMouseLeaveScript,Stream);
  Stream.WriteBuffer(FWidthMod,SizeOf(FWidthMod));
end;

procedure TSharpEButtonSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FDown.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  FOnNormalMouseEnterScript := StringLoadFromStream(Stream);
  FOnNormalMouseLeaveScript := StringLoadFromStream(Stream);
  Stream.ReadBuffer(FWidthMod,SizeOf(FWidthMod));
end;

procedure TSharpEButtonSkin.Clear;
begin
  FNormal.Clear;
  FDown.Clear;
  FHover.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
  FOnNormalMouseEnterScript   := '';
  FOnNormalMouseLeaveScript   := '';
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
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);

      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));

      {$WARNINGS OFF}
      if ItemNamed['OnNormalMouseEnter'] <> nil then
        FOnNormalMouseEnterScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnNormalMouseEnter',''));
      if ItemNamed['OnNormalMouseLeave'] <> nil then
        FOnNormalMouseLeaveScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnNormalMouseLeave',''));
      {$WARNINGS ON}

      FWidthMod := IntValue('WidthMod',20);      
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

function TSharpEButtonSkin.GetOnNormalMouseEnterScript: String;
begin
  result := FOnNormalMouseEnterScript;
end;

function TSharpEButtonSkin.GetOnNormalMouseLeaveScript: String;
begin
  result := FOnNormalMouseLeaveScript;
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
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText, FontList);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText, FontList);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText, FontList);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location', '0,0'));
      if ItemNamed['bottomlocation'] <> nil then
        FBottomSkinDim.SetLocation(Value('bottomlocation', '0,0'))
        else FBottomSkinDim.Assign(FSkinDim);
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
  FSkinDim.SetDimension('w', 'h');
  FSkinDim.SetLocation('0','0');

  FNormal := TSkinPart.Create(BmpList);
  FFocus  := TSkinPart.Create(BmpList);
  FHover  := TSkinPart.Create(BmpList);

  FNormalInterface := FNormal;
  FFocusInterface  := FFocus;
  FHoverInterface  := FHover;

  FEditXOffsets := TSkinPoint.Create;
  FEditYOffsets := TSkinPoint.Create;
end;

destructor TSharpEEditSkin.Destroy;
begin
  FNormalInterface := nil;
  FFocusInterface  := nil;
  FHoverInterface  := nil;

  FEditXOffsets.Free;
  FEditYOffsets.Free;
  FSkinDim.Free;
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
  FNormal.SaveToStream(Stream);
  FFocus.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  FEditXOffsets.SaveToStream(Stream);
  FEditYOffsets.SaveToStream(Stream);
end;

procedure TSharpEEditSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FFocus.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  FEditXOffsets.LoadFromStream(Stream);
  FEditYOffsets.LoadFromStream(Stream);
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
end;

procedure TSharpEEditSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText, FontList);
      if ItemNamed['focus'] <> nil then
        FFocus.LoadFromXML(ItemNamed['focus'], path, SkinText, FontList);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXMl(ItemNamed['hover'], path, SkinText, FontList);
      if ItemNamed['editxoffsets'] <> nil then
        FEditXOffsets.SetPoint(Value('editxoffsets','2,2'));
      if ItemNamed['edityoffsets'] <> nil then
        FEditYOffsets.SetPoint(Value('edityoffsets', '2,2'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location', '0,0'));
    end;
  finally
    SkinText.SelfInterface := nil;
  end;
end;

function  TSharpEEditSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEEditSkin.GetDimension: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
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
  FBackGround.LoadFromStream(Stream);
  FProgress.LoadFromStream(Stream);
  FBackgroundSmall.LoadFromStream(Stream);
  FProgressSmall.LoadFromStream(Stream);
  FSMallModeOffset.LoadFromStream(Stream);
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
  FSmallModeOffset.SetPoint('0', '0');
end;

procedure TSharpEProgressBarSkin.LoadFromXML(xml: TJclSimpleXmlElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.Create(True);
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['background'] <> nil then
        FBackGround.LoadFromXML(ItemNamed['background'], path, SkinText);
      if ItemNamed['progress'] <> nil then
        FProgress.LoadFromXML(ItemNamed['progress'], path, SkinText);

      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location', '0,0'));
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));

      if ItemNamed['locationTL'] <> nil then
        FSkinDimTL.SetLocation(Value('locationTL', '0,0'));
      if ItemNamed['dimensionTL'] <> nil then
        FSkinDimTL.SetDimension(Value('dimensionTL', 'w,h'));
        
      if ItemNamed['locationBL'] <> nil then
        FSkinDimBL.SetLocation(Value('locationBL', '0,0'));
      if ItemNamed['dimensionBL'] <> nil then
        FSkinDimBL.SetDimension(Value('dimensionBL', 'w,h'));

      if ItemNamed['smallbackground'] <> nil then
        FBackGroundSmall.LoadFromXML(ItemNamed['smallbackground'], path,
          SkinText);
      if ItemNamed['smallprogress'] <> nil then
        FProgressSmall.LoadFromXML(ItemNamed['smallprogress'], path, SkinText);
      if ItemNamed['smallmode'] <> nil then
        FSmallModeOffset.SetPoint(Value('smallmode', '0,0'));
    end;
  finally
    SkinText.SelfInterface := nil;
  end;
end;

function TSharpEProgressBarSkin.GetAutoDim(r: Trect; vpos : TSharpEBarAutoPos): TRect;
begin
  case vpos of
    apTop   : result := FSkinDimTL.GetRect(r);
    apBottom: result := FSkinDimBL.GetRect(r)
    else result := FSkinDim.GetRect(r);
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
    with xml.Items do
    begin
      if ItemNamed['throbber'] <> nil then
        with ItemNamed['throbber'].Items do
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
          if ItemNamed['normal'] <> nil then
            FThNormal.LoadFromXML(ItemNamed['normal'], path, nil);
          if ItemNamed['down'] <> nil then
            FThDown.LoadFromXML(ItemNamed['down'], path, nil);
          if ItemNamed['hover'] <> nil then
            FThHover.LoadFromXML(ItemNamed['hover'], path, nil);
        end;
      if ItemNamed['bar'] <> nil then
        FBar.LoadFromXML(ItemNamed['bar'], path, nil);
      if ItemNamed['barborder'] <> nil then
        FBarBorder.LoadFromXML(ItemNamed['barborder'], path, nil);
      if ItemNamed['barbottom'] <> nil then
        FBarBottom.LoadFromXML(ItemNamed['barbottom'], path, nil);
      if ItemNamed['barbottomborder'] <> nil then
        FBarBottomBorder.LoadFromXML(ItemNamed['barbottomborder'], path, nil);
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

{ TSharpESkinHeader }

constructor TSharpESkinHeader.Create;
begin
  FName := 'Untitled';
  FVersion := '1';
  FAuthor := '';
  FUrl := '';
end;

procedure TSharpESkinHeader.LoadFromXml(xml: TJclSimpleXmlElem; path: string);
begin
  with xml.Items do
  begin
    if ItemNamed['name'] <> nil then
      FName := Value('name', 'untitled');
    if ItemNamed['version'] <> nil then
      FVersion := Value('version', '0');
    if ItemNamed['author'] <> nil then
      FAuthor := Value('author', '');
    if ItemNamed['url'] <> nil then
      FUrl := Value('url', '');
  end;
end;

procedure TSharpESkinHeader.LoadFromStream(Stream: TStream);
begin
  {FName := StringLoadFromStream(Stream);
  FVersion := StringLoadFromStream(Stream);
  FAuthor := StringLoadFromStream(Stream);
  FUrl := StringLoadFromStream(Stream);  }
end;

procedure TSharpESkinHeader.SaveToStream(Stream: TStream);
begin
  {StringSaveToStream(FName,Stream);
  StringSaveToStream(FVersion,Stream);
  StringSaveToStream(FAuthor,Stream);
  StringSaveToStream(FUrl,Stream);  }
end;

destructor TSharpESkinHeader.Destroy;
begin

  inherited;
end;

function TSharpESkin.GetSkinUrl: string;
begin
  Result := FSkinHeader.FUrl;
end;

function TSharpESkin.GetBarSkin: ISharpEbarskin;
begin
  result := FBarInterface;
end;

function TSharpESkin.GetButtonSkin: ISharpEButtonSkin;
begin
  result := FButtonInterface;
end;

function TSharpESkin.GetEditSkin: ISharpEEditSkin;
begin
  result := FEditInterface;
end;

function TSharpESkin.GetLargeText: ISharpESkinText;
begin
  result := FLargeTextInterface;
end;

function TSharpESkin.GetMediumText: ISharpESkinText;
begin
  result := FMediumTextInterface;
end;

function TSharpESkin.GetMenuItemSkin: ISharpEMenuItemSkin;
begin
  result := FMenuItemInterface;
end;

function TSharpESkin.GetMenuSkin: ISharpEMenuSkin;
begin
  result := FMenuInterface;
end;

function TSharpESkin.GetMiniThrobberSkin: ISharpEMiniThrobberSkin;
begin
  result := FMiniThrobberInterface;
end;

function TSharpESkin.GetNotifySkin: ISharpENotifySkin;
begin
  result := FNotifyInterface;
end;

function TSharpESkin.GetOSDText: ISharpESkinText;
begin
  result := FOSDTextInterface;
end;

function TSharpESkin.GetProgressBarSkin: ISharpEProgressBarSkin;
begin
  result := FProgressBarInterface;
end;

function TSharpESkin.GetSkinAuthor: string;
begin
  Result := FSkinHeader.Author
end;

function TSharpESkin.GetSkinVersion: string;
begin
  Result := FSkinHeader.Version;
end;

function TSharpESkin.GetSmallText: ISharpESkinText;
begin
  result := FSmallTextInterface;
end;

function TSharpESkin.GetTaskItemSkin: ISharpETaskItemSkin;
begin
  result := FTaskItemInterface;
end;

function TSharpESkin.GetTaskPreviewSkin: ISharpETaskPreviewSkin;
begin
  result := FTaskPreviewInterface;
end;

function TSharpESkin.GetTaskSwitchSkin: ISharpETaskSwitchSkin;
begin
  result := FTaskSwitchInterface;
end;

function TSharpESkin.GetTextPosBL: TPoint;
begin
  result := Point(FTextPosBL.XAsInt,FTextPosBL.YAsInt);
end;

function TSharpESkin.GetTextPosTL: TPoint;
begin
  result := Point(FTextPosTL.XAsInt,FTextPosTL.YAsInt);                                                        
end;

function TSharpESkin.GetSkinName: string;
begin
  Result := FSkinHeader.Name;
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

procedure TSharpESkinHeader.Clear;
begin
  FVersion := '';
  FAuthor := '';
  FName := '';
  FUrl := '';
end;

{ TSharpENotifySkin }

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
    with xml.Items do
    begin
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['catboffset'] <> nil then
        FCATBOffset.SetPoint(Value('catboffset', '0,0'));
      if ItemNamed['calroffset'] <> nil then
        FCALROffset.SetPoint(Value('calroffset','0,0'));
      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText, SkinIcon, FontList);
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
    with xml.Items do
    begin
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['catboffset'] <> nil then
        FCATBOffset.SetPoint(Value('catboffset', '0,0'));
      if ItemNamed['calroffset'] <> nil then
        FCALROffset.SetPoint(Value('calroffset','0,0'));
      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText, SkinIcon, FontList);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText, SkinIcon, FontList);
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
  FSpacing := 2;
  FOnNormalMouseEnterScript    := '';
  FOnNormalMouseLeaveScript    := '';
  FOnDownMouseEnterScript      := '';
  FOnDownMouseLeaveScript      := '';
  FOnHighlightMouseEnterScript := '';
  FOnHighlightMouseLeaveScript := '';
  FOnHighlightStepStartScript  := '';
  FOnHighlightStepEndScript    := '';
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

  FOverlayText := TSkinText.Create(False);

  FNormalInterface         := FNormal;
  FNormalHoverInterface    := FNormalHover;
  FDownInterface           := FDown;
  FDownHoverInterface      := FDownHover;
  FHighlightInterface      := FHighlight;
  FHighlightHoverInterface := FHighlightHover;
  FSpecialInterface        := FSpecial;
  FSpecialHoverInterface   := FSpecialHover;

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

function TSharpETaskItemState.GetLocation: TPoint;
begin
  result := Point(FSkinDim.XAsInt,FSkinDim.YAsInt);
end;

function TSharpETaskItemState.GetOnHighlightMouseEnterScript: String;
begin
  result := FOnHighlightMouseEnterScript;
end;

function TSharpETaskItemState.GetOnHighlightMouseLeaveScript: String;
begin
  result := FOnHighlightMouseLeaveScript;
end;

function TSharpETaskItemState.GetOnHighlightStepEndScrtipt: String;
begin
  result := FOnHighlightStepEndScript;
end;

function TSharpETaskItemState.GetOnHighlightStepStartScript: String;
begin
  result := FOnHighlightStepStartScript;
end;

function TSharpETaskItemState.GetNormal: ISharpESkinPartEx;
begin
  result := FNormalInterface;
end;

function TSharpETaskItemState.GetNormalHover: ISharpESkinPartEx;
begin
  result := FNormalHoverInterface;
end;

function TSharpETaskItemState.GetOnDownMouseEnterScript: String;
begin
  result := FOnDownMouseEnterScript;
end;

function TSharpETaskItemState.GetOnDownMouseLeaveScript: String;
begin
  result := FOnDownMouseLeaveScript;
end;

function TSharpETaskItemState.GetOnNormalMouseEnterScript: String;
begin
  result := FOnNormalMouseEnterScript;
end;

function TSharpETaskItemState.GetOnNormalMouseLeaveScript: String;
begin
  result := FOnNormalMouseLeaveScript;
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

  FOverlayText.LoadFromStream(Stream);

  FSpacing := StrToInt(StringLoadFromStream(Stream));

  FOnNormalMouseEnterScript    := StringLoadFromStream(Stream);
  FOnNormalMouseLeaveScript    := StringLoadFromStream(Stream);
  FOnDownMouseEnterScript      := StringLoadFromStream(Stream);
  FOnDownMouseLeaveScript      := StringLoadFromStream(Stream);
  FOnHighlightMouseEnterScript := StringLoadFromStream(Stream);
  FOnHighlightMouseLeaveScript := StringLoadFromStream(Stream);
  FOnHighlightStepStartScript  := StringLoadFromStream(Stream);
  FOnHighlightStepEndScript    := StringLoadFromStream(Stream);

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
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
         SkinText.LoadFromXML(ItemNamed['text'], FontList);
      if ItemNamed['icon'] <> nil then
         SkinIcon.LoadFromXML(ItemNamed['icon']);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'],path,SkinText,SkinIcon, FontList);
      if ItemNamed['normalhover'] <> nil then
         FNormalHover.LoadFromXML(ItemNamed['normalhover'],path,SkinText,SkinIcon, FontList);
      if ItemNamed['down'] <> nil then
         FDown.LoadFromXML(ItemNamed['down'],path,SkinText,SkinIcon, FontList);
      if ItemNamed['downhover'] <> nil then
         FDownHover.LoadFromXML(ItemNamed['downhover'],path,SkinText,SkinIcon, FontList);
      if ItemNamed['highlight'] <> nil then
         FHighlight.LoadFromXML(ItemNamed['highlight'],path,SkinText,SkinIcon, FontList);
      if ItemNamed['highlighthover'] <> nil then
         FHighlightHover.LoadFromXML(ItemNamed['highlighthover'],path,SkinText,SkinIcon, FontList);
      if ItemNamed['special'] <> nil then
      begin
        FHasSpecial := True;
        FSpecial.LoadFromXML(ItemNamed['special'],path,SkinText,SkinIcon, FontList);
      end;
      if ItemNamed['overlaytext'] <> nil then
      begin
        FHasOverlay := True;
        FOverlayText.LoadFromXML(ItemNamed['overlaytext'], FontList);
      end;
      if ItemNamed['specialhover'] <> nil then
         FSpecialHover.LoadFromXML(ItemNamed['specialhover'],path,SkinText,SkinIcon, FontList);
      if ItemNamed['dimension'] <> nil then
         FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
         FSkinDim.SetLocation(Value('location','0,0'));
     {$WARNINGS OFF}
      if ItemNamed['OnNormalMouseEnter'] <> nil then
         FOnNormalMouseEnterScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnNormalMouseEnter',''));
      if ItemNamed['OnNormalMouseLeave'] <> nil then
         FOnNormalMouseLeaveScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnNormalMouseLeave',''));
      if ItemNamed['OnDownMouseEnter'] <> nil then
         FOnDownMouseEnterScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnDownMouseEnter',''));
      if ItemNamed['OnDownMouseLeave'] <> nil then
         FOnDownMouseLeaveScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnDownMouseLeave',''));
      if ItemNamed['OnHighlightMouseEnter'] <> nil then
         FOnHighlightMouseEnterScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnHighlightMouseEnter',''));
      if ItemNamed['OnHighlightMouseLeave'] <> nil then
         FOnHighlightMouseLeaveScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnHighlightMouseLeave',''));
      if ItemNamed['OnHighlightStepStart'] <> nil then
         FOnHighlightStepStartScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnHighlightStepStart',''));
      if ItemNamed['OnHighlightStepEnd'] <> nil then
         FOnHighlightStepEndScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnHighlightStepEnd',''));
      {$WARNINGS ON}
      if ItemNamed['spacing'] <> nil then
         FSpacing := IntValue('spacing',2);
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

  FOverlayText.SaveToStream(Stream);

  StringSaveToStream(inttostr(FSpacing),Stream);

  StringSaveToStream(FOnNormalMouseEnterScript,Stream);
  StringSaveToStream(FOnNormalMouseLeaveScript,Stream);
  StringSaveToStream(FOnDownMouseEnterScript,Stream);
  StringSaveToStream(FOnDownMouseLeaveScript,Stream);
  StringSaveToStream(FOnHighlightMouseEnterScript,Stream);
  StringSaveToStream(FOnHighlightMouseLeaveScript,Stream);
  StringSaveToStream(FOnHighlightStepStartScript,Stream);
  StringSaveToStream(FOnHighlightStepEndScript,Stream);

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
end;

initialization

finalization

end.
