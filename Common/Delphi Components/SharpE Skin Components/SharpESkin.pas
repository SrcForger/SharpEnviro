{
Source Name: SharpESkin                               
Description: Core Skin loading classes
Copyright (C) Lee Green <Pixol@SharpE-Shell.org>
              Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

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

unit SharpESkin;

interface

uses
  Classes,
  Forms,
  SysUtils,
  Dialogs,
  Contnrs,
  gr32,
  jvsimplexml,
  types,
  SharpESkinPart,
  SharpEBitmapList,
  SharpEBase,
  SharpEScheme,
  Math;

type
  TSharpESkinItem = (scPanel,scButton,scBar,scProgressBar,scCheckBox,scRadioBox,
                     scMiniThrobber,scEdit,scForm,scTaskItem,scMenu,scMenuItem,
                     scTaskSwitch);
  TSharpESkinItems = set of TSharpESkinItem;

const
 ALL_SHARPE_SKINS = [scPanel,scButton,scBar,scProgressBar,scCheckBox,scRadioBox,
                     scMiniThrobber,scEdit,scForm,scTaskItem,scMenu,scMenuItem];

type
  TSharpEPanelSkin = class;
  TSharpEButtonSkin = class;
  TSharpEBarSkin = class;
  TSharpEProgressBarSkin = class;
  TSharpECheckBoxSkin = class;
  TSharpESkinHeader = class;
  TSharpERadioBoxSkin = class;
  TSharpEMiniThrobberSkin = class;
  TSharpEEditSkin = class;
  TSharpEFormSkin = class;
  TSharpETaskItemSkin = class;
  TSharpEMenuSkin = class;
  TSharpEMenuItemSkin = class;
  TSharpETaskSwitchSkin = Class;
  TSkinEvent = procedure of object;

  TSkinName = string;
  TXmlFileName = string;
  TSkinFileName = string;

  TSharpESkin = class(TComponent)
  private
    FSkinName: TSkinName;
    FSkinText: TSkinText;
    FSmallText  : TSkinText;
    FMediumText : TSkinText;
    FBigText    : TSkinText;
    FSkinVersion: Double;
    FBitmapList: TSkinBitmapList;
    FLoadSkins : TSharpESkinItems;

    FOnNotify: TSkinEvent;
    FPanelSkin: TSharpEPanelSkin;
    FButtonSkin: TSharpEButtonSkin;
    FProgressBarSkin: TSharpEProgressBarSkin;
    FCheckBoxSkin: TSharpECheckBoxSkin;
    FRadioBoxSkin: TSharpERadioBoxSkin;
    FBarSkin: TSharpEBarSkin;
    FMiniThrobberSkin: TSharpEMiniThrobberSkin;
    FEditSkin: TSharpEEditSkin;
    FFormSkin: TSharpEFormSkin;
    FTaskItemSkin: TSharpETaskItemSkin;
    FMenuSkin : TSharpEMenuSkin;
    FMenuItemSkin: TSharpEMenuItemSkin;
    FTaskSwitchSkin : TSharpETaskSwitchSkin;

    FSkinHeader: TSharpeSkinHeader;
    FXml: TJvSimpleXml;
    FXmlFileName: TXmlFileName;

    procedure SetXmlFileName(const Value: TXmlFileName);
    function GetSkinAuthor: string;
    function GetSkinName: string;
    function GetSkinUrl: string;
    function GetSkinVersion: string;
    procedure SetSkinName(const Value: TSkinName);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; Skins: TSharpESkinItems = ALL_SHARPE_SKINS); reintroduce; overload;
    constructor CreateBmp(AOwner: TComponent; BmpList : TSkinBitmapList; Skins: TSharpESkinItems = ALL_SHARPE_SKINS); overload;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromXmlFile(filename: string); virtual;
    procedure LoadFromSkin(filename: string); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;

    procedure SaveToSkin(filename: string); virtual;
    procedure SaveToStream(Stream: TStream); overload; virtual;
    procedure SaveToStream(Stream: TStream; SaveBitmap:boolean); overload; virtual;

    property OnNotify: TSkinEvent read FOnNotify write FOnNotify;
    property ButtonSkin: TSharpEButtonSkin read FButtonSkin;
    property CheckBoxSkin: TSharpECheckBoxSkin read FCheckBoxSkin;
    property RadioBoxSkin: TSharpERadioBoxSkin read FRadioBoxSkin;
    property ProgressBarSkin: TSharpEProgressBarSkin read FProgressBarSkin;
    property BarSkin: TSharpEBarSkin read FBarSkin;
    property PanelSkin: TSharpEPanelSkin read FPanelSkin;
    property MiniThrobberSkin: TSharpEMiniThrobberSkin read FMiniThrobberSkin;
    property EditSkin: TSharpEEditSkin read FEditSkin;
    property FormSkin: TSharpEFormSkin read FFormSkin;
    property MenuSkin : TSharpEMenuSkin read FMenuSkin;
    property MenuItemSkin : TSharpEMenuItemSkin read FMenuItemSkin;
    property TaskItemSkin: TSharpETaskItemSkin  read FTaskItemSkin;
    property TaskSwitchSkin : TSharpETaskSwitchSkin read FTaskSwitchSkin;
    property SkinText: TSkinText read FSkinText;
    property SmallText  : TSkinText read FSmallText;
    property MediumText : TSkinText read FMediumText;
    property BigText    : TSkinText read FBigText;
    property BitmapList: TSkinBitmapList read FBitmapList write FBitmapList;

    procedure RemoveNotUsedBitmaps;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    procedure FreeInstance; override;
  published
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
    procedure LoadFromXml(xml: TJvSimpleXMLElem; path: string);

    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Url: string read FUrl write FUrl;
    property Version: string read FVersion write FVersion;
  end;

  TSharpETaskItemStates = (tisFull,tisCompact,tisMini);
  TSharpETaskItemState = class
                           Normal         : TSkinPart;
                           NormalHover    : TSkinPart;
                           Down           : TSkinPart;
                           DownHover      : TSkinPart;
                           Highlight      : TSkinPart;
                           HighlightHover : TSkinPart;
                           Spacing        : integer;
                           DrawIcon       : Boolean;
                           DrawText       : Boolean;
                           IconSize       : integer;
                           IconLocation   : TSkinPoint;
                           SkinDim        : TSkinDim;
                           OnNormalMouseEnterScript    : String;
                           OnNormalMouseLeaveScript    : String;
                           OnDownMouseEnterScript      : String;
                           OnDownMouseLeaveScript      : String;
                           OnHighlightMouseEnterScript : String;
                           OnHighlightMouseLeaveScript : String;
                           OnHighlightStepStartScript  : String;
                           OnHighlightStepEndScript    : String;
                         end;

  TSharpETaskItemSkin = class
  private
    FFull    : TSharpETaskItemState;
    FCompact : TSharpETaskItemState;
    FMini    : TSharpETaskItemState;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid(tis : TSharpETaskItemStates) : boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    function GetAutoDim(tis : TSharpETaskItemStates; r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Full: TSharpETaskItemState read FFull write FFull;
    property Compact: TSharpETaskItemState read FCompact write FCompact;
    property Mini: TSharpETaskItemState read FMini write FMini;
 end;

  TSharpETaskSwitchSkin = class
  private
    FSkinDim          : TSkinDim;
    FBackground       : TSkinPart;
    FItem             : TSkinPart;
    FItemPreview      : TSkinDim;
    FItemHover        : TSkinPart;
    FItemHoverPreview : TSkinDim;
    FTBOffset         : TSkinPoint;
    FLROffset         : TSkinPoint;
    FWrapCount        : integer;
    FSpacing          : integer;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Background : TSkinPart read FBackground;
    property Item : TSkinPart read FItem;
    property ItemHover : TSkinPart read FItemHover;
    property ItemPreview : TSkinDim read FItemPreview;
    property ItemHoverPreview : TSkinDim read FItemHoverPreview;
    property TBOffset : TSkinPoint read FTBOffset;
    property LROffset : TSkinPoint read FLROffset;
    property SkinDim : TSkinDim read FSkinDim;
    property WrapCount : integer read FWrapCount;
    property Spacing : integer read FSpacing;
  end;

  TSharpEMenuSkin = class
  private
    FSkinDim    : TSkinDim;
    FTitelText  : TSkinText;
    FBackground : TSkinPart;
    FTBOffset   : TSkinPoint;
    FLROffset   : TSkinPoint;
    FWidthLimit : TSkinPoint;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Background : TSkinPart read FBackground;
    property TBOffset : TSkinPoint read FTBOffset;
    property LROffset : TSkinPoint read FLROffset;
    property WidthLimit : TSkinPoint read FWidthLimit;
    property TitelText : TSkinText read FTitelText;
    property SkinDim : TSkinDim read FSkinDim;
  end;

  TSharpEMenuItemSkin = class
  private
    FSkinDim       : TSkinDim;
    FSeparator     : TSkinPart;
    FLabelItem     : TSkinPartEx;
    FNormalItem    : TSkinPartEx;
    FHoverItem     : TSkinPartEx;
    FDownItem      : TSkinPartEx;
    FNormalSubItem : TSkinPartEx;
    FHoverSubItem  : TSkinPartEx;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property NormalItem : TSkinPartEx read FNormalItem;
    property HoverItem  : TSkinPartEx read FHoverItem;
    property DownItem   : TSkinPartEx read FDownItem;
    property NormalSubItem : TSkinPartEx read FNormalSubItem;
    property HoverSubItem  : TSkinPartEx read FHoverSubItem;
    property LabelItem : TSkinPartEx read FLabelItem;
    property Separator : TSkinPart read FSeparator;
  end;

  TSharpEButtonSkin = class
  private
    FSkinDim: TSkinDim;
    FIconLROffset: TSkinPoint;
    FIconTBOffset: TSkinPoint;
    FNormal: TSkinPart;
    FDown: TSkinPart;
    FHover: TSkinPart;
    FDisabled: TSkinPart;
    FOnNormalMouseEnterScript : String;
    FOnNormalMouseLeaveScript : String;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    function GetAutoDim(r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Normal: TSkinPart read FNormal write FNormal;
    property Down: TSkinPart read FDown write FDown;
    property Hover: TSkinPart read FHover write FHover;
    property Disabled: TSkinPart read FDisabled write FDisabled;
    property SkinDim: TSkinDim read FSkinDim;
    property IconLROffset: TSkinPoint read FIconLROffset;
    property IconTBOffset: TSkinPoint read FIconTBOffset;
    property OnNormalMouseEnterScript : String read FOnNormalMouseEnterScript;
    property OnNormalMouseLeaveScript : String read FOnNormalMouseLeaveScript;
 end;

  TSharpEFormSkin = class
  private
    FSkinDim: TSkinDim;
    FFull: TSkinPart;
    FFullLROffset: TSkinPoint;
    FFullTBOffset: TSkinPoint;
    FTitleDim: TSkinDim;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    function GetAutoDim(r: TRect): TRect;
    property SkinDim: TSkinDim read FSkinDim write FSkinDim;
    property Full: TSkinPart read FFull write FFull;
    property FullLROffset: TSkinPoint read FFullLROffset write FFullLROffset;
    property FullTBOffset: TSkinPoint read FFullTBOffset write FFullTBOffset;
    property TitleDim: TSkinDim read FTitleDim write FTitleDim;
 end;

  TSharpEPanelSkin = class
    FSkinDim: TSkinDim;
    FRaised: TSkinPart;
    FLowered: TSkinPart;
    FNormal: TSkinPart;
    FSelected: TSkinPart;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    function GetAutoDim(r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Normal: TSkinPart read FNormal write FNormal;
    property Selected: TSkinPart read FSelected write FSelected;
    property Lowered: TSkinPart read FLowered write FLowered;
    property Raised: TSkinPart read FRaised write FRaised;
  end;

  TSharpECheckBoxSkin = class
  private
    FSkinDim: TSkinDim;
    FNormal: TSkinPart;
    FDown: TSkinPart;
    FHover: TSkinPart;
    FDisabled: TSkinPart;
    FChecked: TSkinPart;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    function GetAutoDim(r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Normal: TSkinPart read FNormal write FNormal;
    property Down: TSkinPart read FDown write FDown;
    property Hover: TSkinPart read FHover write FHover;
    property Disabled: TSkinPart read FDisabled write FDisabled;
    property Checked: TSkinPart read FChecked write FChecked;
  end;

  TSharpERadioBoxSkin = class
  private
    FSkinDim: TSkinDim;
    FNormal: TSkinPart;
    FDown: TSkinPart;
    FHover: TSkinPart;
    FDisabled: TSkinPart;
    FChecked: TSkinPart;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    function GetAutoDim(r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Normal: TSkinPart read FNormal write FNormal;
    property Down: TSkinPart read FDown write FDown;
    property Hover: TSkinPart read FHover write FHover;
    property Disabled: TSkinPart read FDisabled write FDisabled;
    property Checked: TSkinPart read FChecked write FChecked;
  end;

  TSharpEProgressBarSkin = class
  private
    FSkinDim: TSkinDim;
    FBackGround: TSkinPart;
    FProgress: TSkinPart;
    FBackGroundSmall: TSkinPart;
    FProgressSmall: TSkinPart;
    FSmallModeOffset: TSkinPoint;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    function GetAutoDim(r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property BackGround: TSkinPart read FBackGround write FBackGround;
    property Progress: TSkinPart read FProgress write FProgress;
    property SmallBackground: TSkinPart read FBackGroundSmall write
      FBackGroundSmall;
    property SmallProgress: TSkinPart read FProgressSmall write FProgressSmall;
    property SmallModeOffset: TSkinPoint read FSmallModeOffset write
      FSmallModeOffset;
  end;

  TSharpEBarSkin = class
  private
    FSkinDim: TSkinDim;
    FThDim: TSkinDim;
    FThBDim: TSkinDim;
    FThNormal: TSkinPart;
    FThDown: TSkinPart;
    FThHover: TSkinPart;
    FBar: TSkinPart;
    FBarBorder : TSkinPart;
    FBarBottom: TSkinPart;
    FBarBottomBorder : TSkinPart;
    FFSMod: TSkinPoint;
    FSBMod: TSkinPoint;
    FPAXoffset: TSkinPoint;
    FPAYoffset: TSkinPoint;
    FSeed: integer;
    FEnableVFlip: boolean;
    FSpecialHideForm: boolean;
    FDefaultSkin: boolean;
    FGlassEffect: boolean;
    FPTXoffset : TSkinPoint;
    FPTYoffset : TSkinPoint;
    FPBXoffset : TSkinPoint;
    FPBYoffset : TSkinPoint;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure NewSeed;
    procedure CheckValid;
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    function GetAutoDim(r: TRect): TRect;
    function GetThrobberDim(r: TRect): TRect;
    function GetThrobberBottomDim(r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property ThNormal: TSkinPart read FThNormal write FThNormal;
    property ThDown: TSkinPart read FThDown write FThDown;
    property ThHover: TSkinPart read FThHover write FThHover;
    property ThDim: TSkinDim read FThDim;
    property ThBDim: TSkinDim read FThBDim;
    property Bar: TSkinPart read FBar write FBar;
    property BarBorder: TSkinPart read FBarBorder write FBarBorder;
    property BarBottom: TSkinPart read FBarBottom write FBarBottom;
    property BarBottomBorder: TSkinPart read FBarBottomBorder write FBarBottomBorder;
    property FSMod: TSkinPoint read FFSMod write FFSMod;
    property SBMod: TSkinPoint read FSBMod write FSBMod;
    property Seed: integer read FSeed;
    property PAXoffset: TSkinPoint read FPAXoffset write FPAXoffset;
    property PAYoffset: TSkinPoint read FPAYoffset write FPAYoffset;
    property PTXoffset: TSkinPoint read FPTXoffset;
    property PTYoffset: TSkinPoint read FPTYoffset;
    property PBXoffset: TSkinPoint read FPBXoffset;
    property PBYoffset: TSkinPoint read FPBYoffset;
    property SkinDim: TSkinDim read FSkinDim;
    property EnableVFlip: boolean read FEnableVFlip write FEnableVFlip;
    property SpecialHideForm : boolean read FSpecialHideForm write FSpecialHideForm;
    property DefaultSkin: boolean read FDefaultSkin write FDefaultSkin;
    property GlassEffect: boolean read FGlassEffect write FGlassEffect;
  end;

  TSharpEEditSkin = class
  private
    FSkinDim: TSkinDim;
    FNormal: TSkinPart;
    FFocus: TSkinPart;
    FHover : TSkinPart;
    FDisabled: TSkinPart;
    FEditXOffsets : TSkinPoint;
    FEditYOffsets : TSkinPoint;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    function GetAutoDim(r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Normal: TSkinPart read FNormal write FNormal;
    property Focus: TSkinPart read FFocus write FFocus;
    property Disabled: TSkinPart read FDisabled write FDisabled;
    property Hover: TSkinPart read FHover write FHover;
    property EditXOffsets: TSkinPoint read FEditXOffsets write FEditXOffsets;
    property EditYOffsets: TSkinPoint read FEditYOffsets write FEditYOffsets;
    property SkinDim : TSkinDim read FSkinDim;
  end;

  TSharpEMiniThrobberSkin = class
  private
    FSkinDim: TSkinDim;
    FBottomSkinDim : TSkinDim;
    FNormal: TSkinPart;
    FDown: TSkinPart;
    FHover: TSkinPart;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    function Valid: boolean;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    function GetAutoDim(r: TRect): TRect;
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property Normal: TSkinPart read FNormal write FNormal;
    property Down: TSkinPart read FDown write FDown;
    property Hover: TSkinPart read FHover write FHover;
    property SkinDim : TSkinDim read FSkinDim;
    property BottomSkinDim : TSkinDim read FBottomSkinDim;
  end;


implementation

uses SharpESkinManager,
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
    result := '';
  end;
  SList.Free;
end;

//***************************************
//* TSharpESkin
//***************************************

constructor TSharpESkin.Create(AOwner : TComponent);
begin
  Create(AOwner,ALL_SHARPE_SKINS);
end;

constructor TSharpESkin.Create(AOwner: TComponent; Skins: TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  inherited Create(AOwner);

  FLoadSkins := Skins;

  if FBitmaplist = nil then
    FBitmapList := TSkinBitmapList.Create;

  if scButton in FLoadSkins then FButtonSkin := TSharpEButtonSkin.create(FBitmapList);
  if scCheckBox in FLoadSkins then FCheckBoxSkin := TSharpECheckBoxSkin.create(FBitmapList);
  if scRadioBox in FLoadSkins then FRadioBoxSkin := TSharpERadioBoxSkin.create(FBitmapList);
  if scProgressBar in FLoadSkins then FProgressBarSkin := TSharpEProgressBarSkin.create(FBitmapList);
  if scForm in FLoadSkins then FFormSkin := TSharpEFormSkin.Create(FBitmapList);
  if scBar in FLoadSkins then FBarSkin := TSharpEBarSkin.create(FBitmapList);
  if scTaskItem in FLoadSkins then FTaskItemSkin := TSharpeTaskItemSkin.Create(FBitmapList);
  FSkinText := TSkinText.Create;
  FSmallText  := TSkinText.Create;
  FMediumText := TSkinText.Create;
  FBigText    := TSkinText.Create;
  if scPanel in FLoadSkins then FPanelSkin := TSharpEPanelSkin.Create(FBitmapList);
  FSkinHeader := TSharpeSkinHeader.Create;
  if scMiniThrobber in FLoadSkins then FMiniThrobberskin := TSharpEMiniThrobberSkin.Create(FBitmapList);
  if scEdit in FLoadSkins then FEditSkin := TSharpEEditSkin.Create(FBitmapList);
  if scMenu in FLoadSkins then FMenuSkin := TSharpEMenuSkin.Create(FBitmapList);
  if scMenuItem in FLoadSkins then FMenuItemSkin := TSharpEMenuItemSkin.Create(FBitmapList);
  if scTaskSwitch in FLoadSkins then FTaskSwitchSkin := TSharpETaskSwitchSkin.Create(FBitmapList);
  
  FXml := TJvSimpleXml.Create(nil);
end;

constructor TSharpESkin.CreateBmp(AOwner: TComponent; BmpList : TSkinBitmapList; Skins: TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FBitmapList := bmpList;
  Create(Aowner,Skins);
end;

destructor TSharpESkin.Destroy;
begin
  FXml.Free;
  if FButtonSkin <> nil then FButtonSkin.Free;
  if FCheckBoxSkin <> nil then FCheckBoxSkin.Free;
  if FRadioBoxSkin <> nil then FRadioBoxSkin.Free;
  if FProgressBarskin <> nil then FProgressBarSkin.Free;
  if FBarSkin <> nil then FBarSkin.Free;
  if FTaskItemSkin <> nil then FTaskItemSkin.Free;
  FSkinText.Free;
  FSmallText.Free;
  FMediumText.Free;
  FBigText.Free;
  if FPanelSkin <> nil then FPanelSkin.Free;
  FSkinHeader.Free;
  if FMiniThrobberSkin <> nil then FMiniThrobberSkin.Free;
  if FEditSkin <> nil then FEditSkin.Free;
  if FFormSkin <> nil then FFormSkin.Free;
  if FMenuSkin <> nil then FMenuSkin.Free;
  if FMenuItemSkin <> nil then FMenuItemSkin.Free;
  if FTaskSwitchSkin <> nil then FTaskSwitchSkin.Free;

  FBitmapList.Free;
  inherited;
end;

procedure TSharpESkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  if FButtonSkin <> nil then FButtonSkin.UpdateDynamicProperties(cs);
  if FCheckBoxSkin <> nil then FCheckBoxSkin.UpdateDynamicProperties(cs);
  if FRadioBoxSkin <> nil then FRadioBoxSkin.UpdateDynamicProperties(cs);
  if FProgressBarskin <> nil then FProgressBarSkin.UpdateDynamicProperties(cs);
  if FBarSkin <> nil then FBarSkin.UpdateDynamicProperties(cs);
  if FTaskItemSkin <> nil then FTaskItemSkin.UpdateDynamicProperties(cs);
  if FPanelSkin <> nil then FPanelSkin.UpdateDynamicProperties(cs);
  if FMiniThrobberSkin <> nil then FMiniThrobberSkin.UpdateDynamicProperties(cs);
  if FEditSkin <> nil then FEditSkin.UpdateDynamicProperties(cs);
  if FFormSkin <> nil then FFormSkin.UpdateDynamicProperties(cs);
  if FMenuSkin <> nil then FMenuSkin.UpdateDynamicProperties(cs);
  if FMenuItemSkin <> nil then FMenuItemSkin.UpdateDynamicProperties(cs);
  if FTaskSwitchSkin <> nil then FTaskSwitchSkin.UpdateDynamicProperties(cs);

  FSkinText.UpdateDynamicProperties(cs);
  FSmallText.UpdateDynamicProperties(cs);
  FMediumText.UpdateDynamicProperties(cs);
  FBigText.UpdateDynamicProperties(cs);
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

    if sp.BitmapID >= 0 then
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
    RemoveSkinPartBitmaps(FButtonSkin.Normal,List);
    RemoveSkinPartBitmaps(FButtonSkin.Down,List);
    RemoveSkinPartBitmaps(FButtonSkin.Hover,List);
    RemoveSkinPartBitmaps(FButtonSkin.Disabled,List);
  end;
  if FBarSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FBarSkin.Bar,List);
    RemoveSkinPartBitmaps(FBarSkin.BarBottom,List);
    RemoveSkinPartBitmaps(FBarSkin.BarBorder,List);
    RemoveSkinPartBitmaps(FBarSkin.BarBottomBorder,List);
    RemoveSkinPartBitmaps(FBarSkin.ThNormal,List);
    RemoveSkinPartBitmaps(FBarSkin.ThDown,List);
    RemoveSkinPartBitmaps(FBarSkin.ThHover,List);
  end;
  if FEditSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FEditSkin.Normal,List);
    RemoveSkinPartBitmaps(FEditSkin.Focus,List);
    RemoveSkinPartBitmaps(FEditSkin.Disabled,List);
    RemoveSkinPartBitmaps(FEditSkin.Hover,List);
  end;
  if FProgressBarSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FProgressBarSkin.BackGround,List);
    RemoveSkinPartBitmaps(FProgressBarSkin.Progress,List);
    RemoveSkinPartBitmaps(FProgressBarSkin.SmallBackground,List);
    RemoveSkinPartBitmaps(FProgressBarSkin.SmallProgress,List);
  end;
  if FTaskItemSkin <> nil then
  begin
    RemoveSkinPartBitmaps(FTaskItemSkin.Full.Normal,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Full.NormalHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Full.Down,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Full.DownHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Full.Highlight,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Full.HighlightHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Compact.Normal,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Compact.NormalHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Compact.Down,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Compact.DownHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Compact.Highlight,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Compact.HighlightHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Mini.Normal,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Mini.NormalHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Mini.Down,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Mini.DownHover,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Mini.Highlight,List);
    RemoveSkinPartBitmaps(FTaskItemSkin.Mini.HighlightHover,List);
  end;
  if FCheckBoxSkin <> nil then
  begin
    RemoveskinPartBitmaps(FCheckBoxSkin.Normal,List);
    RemoveskinPartBitmaps(FCheckBoxSkin.Down,List);
    RemoveskinPartBitmaps(FCheckBoxSkin.Hover,List);
    RemoveskinPartBitmaps(FCheckBoxSkin.Disabled,List);
    RemoveskinPartBitmaps(FCheckBoxSkin.Checked,List);
  end;
  if FRadioBoxSkin <> nil then
  begin
    RemoveskinPartBitmaps(FRadioBoxSkin.Normal,List);
    RemoveskinPartBitmaps(FRadioBoxSkin.Down,List);
    RemoveskinPartBitmaps(FRadioBoxSkin.Hover,List);
    RemoveskinPartBitmaps(FRadioBoxSkin.Disabled,List);
    RemoveskinPartBitmaps(FRadioBoxSkin.Checked,List);
  end;
  if FMiniThrobberSkin <> nil then
  begin
    RemoveskinPartBitmaps(FMiniThrobberSkin.Normal,List);
    RemoveskinPartBitmaps(FMiniThrobberSkin.Down,List);
    RemoveskinPartBitmaps(FMiniThrobberSkin.Hover,List);
  end;
  if FFormSkin <> nil then
  begin
    RemoveskinPartBitmaps(FFormSkin.Full,List);
  end;
  if FMenuSkin <> nil then
  begin
    RemoveskinPartBitmaps(FMenuSkin.Background,List);
  end;
  if FMenuItemSkin <> nil then
  begin
    RemoveskinPartBitmaps(FMenuItemSkin.NormalItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.HoverItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.DownItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.NormalSubItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.HoverSubItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.LabelItem,List);
    RemoveskinPartBitmaps(FMenuItemSkin.Separator,List);
  end;
  if FPanelSkin <> nil then
  begin
    RemoveskinPartBitmaps(FPanelSkin.Normal,List);
    RemoveskinPartBitmaps(FPanelSkin.Selected,List);
    RemoveskinPartBitmaps(FPanelSkin.Lowered,List);
    RemoveskinPartBitmaps(FPanelSkin.Raised,List);
  end;
  if FTaskSwitchSkin <> nil then
  begin
    RemoveskinpartBitmaps(FTaskSwitchSkin.Background,List);
    RemoveskinpartBitmaps(FTaskSwitchSkin.Item,List);
    RemoveskinpartBitmaps(FTaskSwitchSkin.ItemHover,List);
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
  FBigText.SaveToStream(Stream);
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

    //Write CheckBox
    if FCheckBoxSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('CheckBox', Stream);
      FCheckBoxSkin.SaveToStream(tempStream);
      size := tempStream.Size;
      tempStream.Position := 0;
      Stream.WriteBuffer(size, sizeof(size));
      Stream.CopyFrom(tempStream, Size);
    end;

    //Write RadioBox
    if FRadioBoxSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('RadioBox', Stream);
      FRadioBoxSkin.SaveToStream(tempStream);
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

    //Write Panel
    if FPanelSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('Panel', Stream);
      FPanelSkin.SaveToStream(tempStream);
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

    //Write Form
    if FFormSkin <> nil then
    begin
      tempStream.clear;
      StringSaveToStream('Form', Stream);
      FFormSkin.SaveToStream(tempStream);
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
      StringSaveToStream('TaskSwitchSkin', Stream);
      FTaskSwitchSkin.SaveToStream(tempStream);
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
    FBigText.LoadFromStream(Stream);
    Stream.ReadBuffer(BmpListInStream, sizeof(BmpListInStream));
    if BmpListInStream then
      FBitmapList.LoadFromStream(Stream);
    temp := StringLoadFromStream(Stream);
    while temp <> 'End' do
    begin
      Stream.ReadBuffer(size, sizeof(size));

      if temp = 'Header' then
        FSkinHeader.LoadFromStream(Stream)
      else
        if (temp = 'Button') and (FButtonSkin <> nil) then
          FButtonSkin.LoadFromStream(Stream)
        else
          if (temp = 'ProgressBar') and (FProgressBarSkin <> nil) then
            FProgressBarSkin.LoadFromStream(Stream)
          else
            if (temp = 'CheckBox') and (FCheckBoxSkin <> nil) then
              FCheckBoxSkin.LoadFromStream(Stream)
            else
              if (temp = 'RadioBox') and (FRadioBoxSkin <> nil) then
                FRadioBoxSkin.LoadFromStream(Stream)
              else
                if (temp = 'Bar') and (FBarSkin <> nil) then
                  FBarSkin.LoadFromStream(Stream)
                else
                  if (temp = 'Panel') and (FPanelSkin <> nil) then
                    FPanelSkin.LoadFromStream(Stream)
                  else
                    if (temp = 'MiniThrobber') and (FMiniThrobberSkin <> nil) then
                      FMiniThrobberSkin.LoadFromStream(Stream)
                    else
                      if (temp = 'Edit') and (FEditSkin <> nil) then
                        FEditSkin.LoadFromStream(Stream)
                      else
                        if (temp = 'Form') and (FFormSkin <> nil) then
                          FFormSkin.LoadFromStream(Stream)
                        else
                          if (temp = 'TaskItem') and (FTaskItemSkin <> nil) then
                            FTaskItemSkin.LoadFromStream(Stream)
                          else
                            if (temp = 'Menu') and (FMenuSkin <> nil) then
                              FMenuSkin.LoadFromStream(Stream)
                            else
                              if (temp = 'MenuItem') and (FMenuItemSkin <> nil) then
                                FMenuItemSkin.LoadFromStream(Stream)
                              else if (temp = 'TaskSwitchSkin') and (FTaskSwitchSkin <> nil) then
                                     FTaskSwitchSkin.LoadFromStream(Stream)
                                    else Stream.Position := Stream.Position + size;

      temp := StringLoadFromStream(Stream);
    end;
  except
  end;
  
  if FBarskin <> nil then
     FBarSkin.CheckValid;
  inherited;
  
  RemoveNotUsedBitmaps;
end;

procedure TSharpESkin.Clear;
begin
  if FButtonSkin <> nil then FButtonSkin.Clear;
  if FCheckBoxSkin <> nil then FCheckBoxSkin.Clear;
  if FProgressBarSkin <> nil then FProgressBarSkin.Clear;
  if FBarSkin <> nil then FBarSkin.Clear;
  if FPanelSkin <> nil then FPanelSkin.Clear;
  FSkinHeader.Clear;
  if FRadioBoxSkin <> nil then FRadioBoxSkin.Clear;
  if FMiniThrobberSkin <> nil then FMiniThrobberSkin.Clear;
  if FEditSkin <> nil then FEditSkin.Clear;
  if FFormSkin <> nil then FFormSkin.Clear;
  if FMenuSkin <> nil then FMenuSkin.Clear;
  if FMenuItemSkin <> nil then FMenuItemSkin.Clear;
  if FTaskItemSkin <> nil then FTaskItemSkin.Clear;
  if FTaskSwitchSkin <> nil then FTaskSwitchSkin.Clear;

  FSmallText.Clear;
  FMediumText.Clear;
  FBigText.Clear;
  FBitmapList.Clear;

  FSkinName := '';
end;

procedure TSharpESkin.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('FileData', LoadFromStream, SaveToStream, true);
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

procedure TSharpESkin.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent is TSharpESkinManager) then
    begin
      if (AComponent as TSharpESkinManager).CompSkin = self then
        FOnNotify := nil;
    end;
  end
end;

procedure TSharpESkin.LoadFromXmlFile(filename: string);
var
  Path: string;
begin
  try
    Path := ExtractFilePath(filename);
    Fxml.LoadFromFile(filename);
    if FXml.Root.Items.Count = 0 then
      exit;
  except
    Clear;
    if FBarSkin <> nil then
       BarSkin.CheckValid;
    exit;
  end;
  Clear;

  // Load Details
  if FXml.Root.Items.ItemNamed['font'] <> nil then
     with FXml.Root.Items.ItemNamed['font'].Items do
     begin
       if ItemNamed['small'] <> nil then
          FSmallText.LoadFromXML(ItemNamed['small']);
       if ItemNamed['medium'] <> nil then
          FMediumText.LoadFromXML(ItemNamed['medium']);
       if ItemNamed['big'] <> nil then
          FBigText.LoadFromXML(ItemNamed['big']); 
     end;
  if FXml.Root.Items.ItemNamed['header'] <> nil then
    FSkinHeader.LoadFromXml(FXml.Root.Items.ItemNamed['header'], path);
  if (FXml.Root.Items.ItemNamed['button'] <> nil) and (FButtonSkin <> nil) then
    FButtonSkin.LoadFromXML(FXml.Root.Items.ItemNamed['button'], path);
  if (FXml.Root.Items.ItemNamed['sharpbar'] <> nil) and (FBarSkin <> nil) then
    FBarSkin.LoadFromXML(FXml.Root.Items.ItemNamed['sharpbar'], path);
  if (FXml.Root.Items.ItemNamed['progressbar'] <> nil) and (FProgressBarSkin <> nil) then
    FProgressBarSkin.LoadFromXML(FXml.Root.Items.ItemNamed['progressbar'], path);
  if (FXml.Root.Items.ItemNamed['checkbox'] <> nil) and (FCheckBoxSkin <> nil) then
    FCheckBoxSkin.LoadFromXML(FXml.Root.Items.ItemNamed['checkbox'], path);
  if (FXml.Root.Items.ItemNamed['radiobox'] <> nil) and (FRadioBoxSkin <> nil) then
    FRadioBoxSkin.LoadFromXML(FXml.Root.Items.ItemNamed['radiobox'], path);
  if (FXml.Root.Items.ItemNamed['panel'] <> nil) and (FPanelSkin <> nil) then
    FPanelSkin.LoadFromXML(FXml.Root.Items.ItemNamed['panel'], path);
  if (FXml.Root.Items.ItemNamed['minithrobber'] <> nil) and (FMiniThrobberSkin <> nil) then
    FMiniThrobberSkin.LoadFromXML(FXML.Root.Items.ItemNamed['minithrobber'], path);
  if (FXml.Root.Items.ItemNamed['edit'] <> nil) and (FEditSkin <> nil) then
    FEditSkin.LoadFromXML(FXML.Root.Items.ItemNamed['edit'], path);
  if (FXml.Root.Items.ItemNamed['form'] <> nil) and (FFormSkin <> nil) then
    FFormSkin.LoadFromXML(FXml.Root.Items.ItemNamed['form'], path);
  if (FXml.Root.Items.ItemNamed['taskitem'] <> nil) and (FTaskItemSkin <> nil) then
    FTaskItemSkin.LoadFromXML(FXml.Root.Items.ItemNamed['taskitem'],path);
  if (FXml.Root.Items.ItemNamed['menu'] <> nil) and (FMenuSkin <> nil) then
    FMenuSkin.LoadFromXML(FXml.Root.Items.ItemNamed['menu'],path);
  if (FXml.Root.Items.ItemNamed['menuitem'] <> nil) and (FMenuItemSkin <> nil) then
    FMenuItemSkin.LoadFromXML(FXml.Root.Items.ItemNamed['menuitem'],path);
  if (FXml.Root.Items.ItemNamed['taskswitch'] <> nil) and (FTaskSwitchSkin <> nil) then
    FTaskSwitchSkin.LoadFromXML(FXML.Root.Items.ItemNamed['taskswitch'],path);

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
  FBackground.Free;
  FItem.Free;
  FItemHover.Free;
  FItemPreview.Free;
  FItemHoverPreview.Free;
  FTBOffset.Free;
  FLROffset.Free;
end;

procedure TSharpETaskSwitchSkin.UpdateDynamicProperties(cs: TSharpEScheme);
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

procedure TSharpETaskSwitchSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var
  SkinText: TSkinText;
begin
  SkinText := TSkinText.Create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText);
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
    SkinText.free;
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
  FTitelText := TSkinText.Create;
  FBackground := TSkinPart.Create(BmpList);
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
  FBackground.Free;
  FTBOffset.Free;
  FLROffset.Free;
  FWidthLimit.Free;
  FTitelText.Free;
end;

procedure TSharpEMenuSkin.UpdateDynamicProperties(cs: TSharpEScheme);
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
  FTitelText.LoadFromStream(Stream);
  FTBOffset.LoadFromStream(Stream);
  FLROffset.LoadFromStream(Stream);
  FWidthLimit.LoadFromStream(Stream);
end;

procedure TSharpEMenuSkin.SaveToStream(Stream : TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FBackground.SaveToStream(Stream);
  FTitelText.SaveToStream(Stream);
  FTBOffset.SaveToStream(Stream);
  FLROffset.SaveToStream(Stream);
  FWidthLimit.SaveToStream(Stream);
end;

procedure TSharpEMenuSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var
  SkinText: TSkinText;
begin
  SkinText := TSkinText.Create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['titeltext'] <> nil then
        FTitelText.LoadFromXML(ItemNamed['titeltext']);
      if ItemNamed['tboffset'] <> nil then
        FTBOffset.SetPoint(Value('tboffset','0,0'));
      if ItemNamed['lroffset'] <> nil then
        FLROffset.SetPoint(Value('lroffset','0,0'));
      if ItemNamed['widthlimit'] <> nil then
        FWidthLimit.SetPoint(Value('widthlimit','0,0'));
    end;
  finally
    SkinText.free;
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
end;

destructor TSharpEMenuItemSkin.Destroy;
begin
  FSkinDim.Free;
  FSeparator.Free;
  FNormalItem.Free;
  FLabelItem.Free;
  FHoverItem.Free;
  FDownItem.Free;
  FNormalSubItem.Free;
  FHoverSubItem.Free;
end;

procedure TSharpEMenuItemSkin.UpdateDynamicProperties(cs: TSharpEScheme);
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

procedure TSharpEMenuItemSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var
  SkinText: TSkinText;
  SkinIcon : TSkinIcon;
begin
  SkinIcon := TSkinIcon.Create;
  SkinIcon.DrawIcon := False;
  SkinText := TSkinText.Create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']); 
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['Separator'] <> nil then
        FSeparator.LoadFromXML(ItemNamed['Separator'], path, SkinText);
      if ItemNamed['normal'] <> nil then
        FNormalItem.LoadFromXML(ItemNamed['normal'], path, SkinText, SkinIcon);
      if ItemNamed['down'] <> nil then
        FDownItem.LoadFromXML(ItemNamed['down'], path, SkinText, SkinIcon);
      if ItemNamed['normalsub'] <> nil then
        FNormalSubItem.LoadFromXML(ItemNamed['normalsub'], path, SkinText, SkinIcon);
      if ItemNamed['hover'] <> nil then
        FHoverItem.LoadFromXML(ItemNamed['hover'], path, SkinText, SkinIcon);
      if ItemNamed['hoversub'] <> nil then
        FHoverSubItem.LoadFromXML(ItemNamed['hoversub'], path, SkinText, SkinIcon);
      if ItemNamed['label'] <> nil then
        FLabelItem.LoadFromXml(ItemNamed['label'], path, SkinText, SkinIcon);
    end;
  finally
    SkinText.free;
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
  FIconLROffset := TSkinPoint.Create;
  FIconTBOffset := TSkinPoint.Create;
  FIconLROffset.SetPoint('3','3');
  FIconTBOffset.SetPoint('3','3');
  FNormal := TSkinPart.Create(BmpList);
  FDown := TSkinPart.Create(BmpList);
  FHover := TSkinPart.Create(BmpList);
  FDisabled := TSkinPart.Create(BmpList);
  FOnNormalMouseEnterScript   := '';
  FOnNormalMouseLeaveScript   := '';
end;

destructor TSharpEButtonSkin.Destroy;
begin
  FNormal.Free;
  FDown.Free;
  FHover.Free;
  FDisabled.Free;
  FSkinDim.Free;
  FIconLROffset.Free;
  FIconTBOffset.Free;
end;

procedure TSharpEButtonSkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FDown.UpdateDynamicProperties(cs);
  FHover.UpdateDynamicProperties(cs);
  FDisabled.UpdateDynamicProperties(cs);
end;

procedure TSharpEButtonSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FIconLROffset.SaveToStream(Stream);
  FIconTBOffset.SaveToStream(Stream);
  FNormal.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  FDisabled.SaveToStream(Stream);
  StringSaveToStream(FOnNormalMouseEnterScript,Stream);
  StringSaveToStream(FOnNormalMouseLeaveScript,Stream);
end;

procedure TSharpEButtonSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FIconLROffset.LoadFromStream(Stream);
  FIconTBOffset.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FDown.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  FDisabled.LoadFromStream(Stream);
  FOnNormalMouseEnterScript := StringLoadFromStream(Stream);
  FOnNormalMouseLeaveScript := StringLoadFromStream(Stream);
end;

procedure TSharpEButtonSkin.Clear;
begin
  FNormal.Clear;
  FDown.Clear;
  FHover.Clear;
  FDisabled.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
  FIconLROffset.SetPoint('3','3');
  FIconTBOffset.SetPoint('3','3');
  FOnNormalMouseEnterScript   := '';
  FOnNormalMouseLeaveScript   := '';
end;

procedure TSharpEButtonSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText);
      if ItemNamed['disabled'] <> nil then
        FDisabled.LoadFromXML(ItemNamed['disabled'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location','0,0'));
      if ItemNamed['iconlroffset'] <> nil then
        FIconLROffset.SetPoint(Value('iconlroffset', '3,3'));
      if ItemNamed['icontboffset'] <> nil then
        FIconTBOffset.SetPoint(Value('icontboffset','3,3'));
      if ItemNamed['OnNormalMouseEnter'] <> nil then
      {$WARNINGS OFF}
        FOnNormalMouseEnterScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnNormalMouseEnter',''));
      if ItemNamed['OnNormalMouseLeave'] <> nil then
        FOnNormalMouseLeaveScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnNormalMouseLeave',''));
      {$WARNINGS ON}
    end;
  finally
    SkinText.free;
  end;
end;

function TSharpEButtonSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEButtonSkin.valid: boolean;
begin
  result := not (FNormal.Empty);
end;

//***************************************
//* TSharpETaskItemSkin
//***************************************

procedure LoadTIScriptsFromStream(ti : TSharpETaskItemState; Stream : TStream);
begin
  ti.OnNormalMouseEnterScript    := StringLoadFromStream(Stream);
  ti.OnNormalMouseLeaveScript    := StringLoadFromStream(Stream);
  ti.OnDownMouseEnterScript      := StringLoadFromStream(Stream);
  ti.OnDownMouseLeaveScript      := StringLoadFromStream(Stream);
  ti.OnHighlightMouseEnterScript := StringLoadFromStream(Stream);
  ti.OnHighlightMouseLeaveScript := StringLoadFromStream(Stream);
  ti.OnHighlightStepStartScript  := StringLoadFromStream(Stream);
  ti.OnHighlightStepEndScript    := StringLoadFromStream(Stream);
end;

procedure SaveTIScriptsToStream(ti : TSharpETaskItemState; Stream : TStream);
begin
  StringSaveToStream(ti.OnNormalMouseEnterScript,Stream);
  StringSaveToStream(ti.OnNormalMouseLeaveScript,Stream);
  StringSaveToStream(ti.OnDownMouseEnterScript,Stream);
  StringSaveToStream(ti.OnDownMouseLeaveScript,Stream);
  StringSaveToStream(ti.OnHighlightMouseEnterScript,Stream);
  StringSaveToStream(ti.OnHighlightMouseLeaveScript,Stream);
  StringSaveToStream(ti.OnHighlightStepStartScript,Stream);
  StringSaveToStream(ti.OnHighlightStepEndScript,Stream);
end;

procedure ClearTIScripts(ti : TSharpETaskItemState);
begin
  ti.OnNormalMouseEnterScript    := '';
  ti.OnNormalMouseLeaveScript    := '';
  ti.OnDownMouseEnterScript      := '';
  ti.OnDownMouseLeaveScript      := '';
  ti.OnHighlightMouseEnterScript := '';
  ti.OnHighlightMouseLeaveScript := '';
  ti.OnHighlightStepStartScript  := '';
  ti.OnHighlightStepEndScript    := '';
end;

constructor TSharpETaskItemSkin.Create(BmpList : TSkinBitmapList);
begin
  FFull := TSharpETaskItemState.Create;
  FCompact := TSharpETaskItemState.Create;
  FMini := TSharpETaskItemState.Create;

  FFull.SkinDim := TSkinDim.Create;
  FFull.Normal         := TSkinPart.Create(BmpList);
  FFull.NormalHover    := TSkinPart.Create(BmpList);
  FFull.Down           := TSkinPart.Create(BmpList);
  FFull.DownHover      := TSkinPart.Create(BmpList);
  FFull.Highlight      := TSkinPart.Create(BmpList);
  FFull.HighlightHover := TSkinPart.Create(BmpList);
  FFull.IconLocation := TSkinPoint.Create;

  FCompact.SkinDim := TSkinDim.Create;
  FCompact.Normal         := TSkinPart.Create(BmpList);
  FCompact.NormalHover    := TSkinPart.Create(BmpList);
  FCompact.Down           := TSkinPart.Create(BmpList);
  FCompact.DownHover      := TSkinPart.Create(BmpList);
  FCompact.Highlight      := TSkinPart.Create(BmpList);
  FCompact.HighlightHover := TSkinPart.Create(BmpList);
  FCompact.IconLocation := TSkinPoint.Create;

  FMini.SkinDim := TSkinDim.Create;
  FMini.Normal         := TSkinPart.Create(BmpList);
  FMini.NormalHover    := TSkinPart.Create(BmpList);
  FMini.Down           := TSkinPart.Create(BmpList);
  FMini.DownHover      := TSkinPart.Create(BmpList);
  FMini.Highlight      := TSkinPart.Create(BmpList);
  FMini.HighlightHover := TSkinPart.Create(BmpList);
  FMini.IconLocation := TSkinPoint.Create;

  Clear;
end;

destructor TSharpETaskItemSkin.Destroy;
begin
  FFull.SkinDim.Free;
  FFull.Normal.Free;
  FFull.NormalHover.Free;
  FFull.Down.Free;
  FFull.DownHover.Free;
  FFull.Highlight.Free;
  FFull.HighlightHover.Free;
  FFull.IconLocation.Free;

  FCompact.SkinDim.Free;
  FCompact.Normal.Free;
  FCompact.NormalHover.Free;
  FCompact.Down.Free;
  FCompact.DownHover.Free;
  FCompact.Highlight.Free;
  FCompact.HighlightHover.Free;
  FCompact.IconLocation.Free;

  FMini.SkinDim.Free;
  FMini.Normal.Free;
  FMini.NormalHover.Free;
  FMini.Down.Free;
  FMini.DownHover.Free;
  FMini.Highlight.Free;
  FMini.HighlightHover.Free;
  FMini.IconLocation.Free;

  FFull.Free;
  FCompact.Free;
  FMini.Free;
end;

procedure TSharpETaskItemSkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FFull.Normal.UpdateDynamicProperties(cs);
  FFull.NormalHover.UpdateDynamicProperties(cs);
  FFull.Down.UpdateDynamicProperties(cs);
  FFull.DownHover.UpdateDynamicProperties(cs);
  FFull.Highlight.UpdateDynamicProperties(cs);
  FFull.HighlightHover.UpdateDynamicProperties(cs);

  FCompact.Normal.UpdateDynamicProperties(cs);
  FCompact.NormalHover.UpdateDynamicProperties(cs);
  FCompact.Down.UpdateDynamicProperties(cs);
  FCompact.DownHover.UpdateDynamicProperties(cs);
  FCompact.Highlight.UpdateDynamicProperties(cs);
  FCompact.HighlightHover.UpdateDynamicProperties(cs);

  FMini.Normal.UpdateDynamicProperties(cs);
  FMini.NormalHover.UpdateDynamicProperties(cs);
  FMini.Down.UpdateDynamicProperties(cs);
  FMini.DownHover.UpdateDynamicProperties(cs);
  FMini.Highlight.UpdateDynamicProperties(cs);
  FMini.HighlightHover.UpdateDynamicProperties(cs);
end;

procedure TSharpETaskItemSkin.SaveToStream(Stream: TStream);
begin
  FFull.SkinDim.SaveToStream(Stream);
  FFull.Normal.SaveToStream(Stream);
  FFull.NormalHover.SaveToStream(Stream);
  FFull.Down.SaveToStream(Stream);
  FFull.DownHover.SaveToStream(Stream);
  FFull.Highlight.SaveToStream(Stream);
  FFull.HighlightHover.SaveToStream(Stream);
  FFull.IconLocation.SaveToStream(Stream);
  StringSaveToStream(inttostr(FFull.Spacing),Stream);
  StringSaveToStream(inttostr(FFull.IconSize),Stream);
  StringSaveToStream(BoolToStr(FFull.DrawIcon),Stream);
  StringSaveToStream(BoolToStr(FFull.DrawText),Stream);
  SaveTIScriptsToStream(FFull,Stream);

  FCompact.SkinDim.SaveToStream(Stream);
  FCompact.Normal.SaveToStream(Stream);
  FCompact.NormalHover.SaveToStream(Stream);
  FCompact.Down.SaveToStream(Stream);
  FCompact.DownHover.SaveToStream(Stream);
  FCompact.Highlight.SaveToStream(Stream);
  FCompact.HighlightHover.SaveToStream(Stream);
  FCompact.IconLocation.SaveToStream(Stream);
  StringSaveToStream(inttostr(FCompact.Spacing),Stream);
  StringSaveToStream(inttostr(FCompact.IconSize),Stream);
  StringSaveToStream(BoolToStr(FCompact.DrawIcon),Stream);
  StringSaveToStream(BoolToStr(FCompact.DrawText),Stream);
  SaveTIScriptsToStream(FCompact,Stream);

  FMini.SkinDim.SaveToStream(Stream);
  FMini.Normal.SaveToStream(Stream);
  FMini.NormalHover.SaveToStream(Stream);
  FMini.Down.SaveToStream(Stream);
  FMini.DownHover.SaveToStream(Stream);
  FMini.Highlight.SaveToStream(Stream);
  FMini.HighlightHover.SaveToStream(Stream);
  FMini.IconLocation.SaveToStream(Stream);
  StringSaveToStream(inttostr(FMini.Spacing),Stream);
  StringSaveToStream(inttostr(FMini.IconSize),Stream);
  StringSaveToStream(BoolToStr(FMini.DrawIcon),Stream);
  StringSaveToStream(BoolToStr(FMini.DrawText),Stream);
  SaveTIScriptsToStream(FMini,Stream);
end;

procedure TSharpETaskItemSkin.LoadFromStream(Stream: TStream);
begin
  Full.SkinDim.LoadFromStream(Stream);
  FFull.Normal.LoadFromStream(Stream);
  FFull.NormalHover.LoadFromStream(Stream);
  FFull.Down.LoadFromStream(Stream);
  FFull.DownHover.LoadFromStream(Stream);
  FFull.Highlight.LoadFromStream(Stream);
  FFull.HighlightHover.LoadFromStream(Stream);
  FFull.IconLocation.LoadFromStream(Stream);
  FFull.Spacing := StrToInt(StringLoadFromStream(Stream));
  FFull.IconSize := StrToInt(StringLoadFromStream(Stream));
  FFull.DrawIcon := StrToBool(StringLoadFromStream(Stream));
  FFull.DrawText := StrToBool(StringLoadFromStream(Stream));
  LoadTIScriptsFromStream(FFull,Stream);

  FCompact.SkinDim.LoadFromStream(Stream);
  FCompact.Normal.LoadFromStream(Stream);
  FCompact.NormalHover.LoadFromStream(Stream);
  FCompact.Down.LoadFromStream(Stream);
  FCompact.DownHover.LoadFromStream(Stream);
  FCompact.Highlight.LoadFromStream(Stream);
  FCompact.HighlightHover.LoadFromStream(Stream);
  FCompact.IconLocation.LoadFromStream(Stream);
  FCompact.Spacing := StrToInt(StringLoadFromStream(Stream));
  FCompact.IconSize := StrToInt(StringLoadFromStream(Stream));
  FCompact.DrawIcon := StrToBool(StringLoadFromStream(Stream));
  FCompact.DrawText := StrToBool(StringLoadFromStream(Stream));
  LoadTIScriptsFromStream(FCompact,Stream);

  FMini.SkinDim.LoadFromStream(Stream);
  FMini.Normal.LoadFromStream(Stream);
  FMini.NormalHover.LoadFromStream(Stream);
  FMini.Down.LoadFromStream(Stream);
  FMini.DownHover.LoadFromStream(Stream);
  FMini.Highlight.LoadFromStream(Stream);
  FMini.HighlightHover.LoadFromStream(Stream);
  FMini.IconLocation.LoadFromStream(Stream);
  FMini.Spacing := StrToInt(StringLoadFromStream(Stream));
  FMini.IconSize := StrToInt(StringLoadFromStream(Stream));
  FMini.DrawIcon := StrToBool(StringLoadFromStream(Stream));
  FMini.DrawText := StrToBool(StringLoadFromStream(Stream));
  LoadTIScriptsFromStream(FMini,Stream);
end;

procedure TSharpETaskItemSkin.Clear;
begin
  ClearTIScripts(FFull);
  ClearTIScripts(FCompact);
  ClearTIScripts(FMini);

  FFull.SkinDim.Clear;
  FFull.SkinDim.SetLocation('0','0');
  FFull.SkinDim.SetDimension('w', 'h');
  FFull.Normal.Clear;
  FFull.NormalHover.Clear;
  FFull.Down.Clear;
  FFull.DownHover.Clear;
  FFull.Highlight.Clear;
  FFull.HighlightHover.Clear;
  FFull.IconSize := 16;
  FFull.DrawIcon := True;
  FFull.DrawText := True;
  FFull.IconLocation.SetPoint('cw-twh','0');
  FFull.Spacing := 2;

  FCompact.SkinDim.Clear;
  FCompact.SkinDim.SetLocation('0','0');
  FCompact.SkinDim.SetDimension('w', 'h');
  FCompact.Normal.Clear;
  FCompact.NormalHover.Clear;
  FCompact.Down.Clear;
  FCompact.DownHover.Clear;
  FCompact.Highlight.Clear;
  FCompact.HighlightHover.Clear;
  FCompact.IconSize := 16;
  FCompact.DrawIcon := False;
  FCompact.DrawText := True;
  FCompact.IconLocation.SetPoint('0','0');
  FCompact.Spacing := 2;

  FMini.SkinDim.Clear;
  FMini.SkinDim.SetLocation('0','0');
  FMini.SkinDim.SetDimension('w', 'h');
  FMini.Normal.Clear;
  FMini.NormalHover.Clear;
  FMini.Down.Clear;
  FMini.DownHover.Clear;
  FMini.Highlight.Clear;
  FMini.HighlightHover.Clear;
  FMini.IconSize := 16;
  FMini.DrawIcon := True;
  FMini.DrawText := False;
  FMini.IconLocation.SetPoint('0','0');
  FMini.Spacing := 2;
end;

procedure TSharpETaskItemSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var
 SkinText: TSkinText;
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
    SkinText := TSkinText.create;
    SkinText.SetLocation('cw', 'ch');
    try
      with xml.Items do
      begin
        if ItemNamed[loadstr] <> nil then
        with ItemNamed[loadstr].Items do
        begin
          if ItemNamed['text'] <> nil then
          begin
            SkinText.LoadFromXML(ItemNamed['text']);
            if ItemNamed['text'].Items.ItemNamed['draw'] <> nil then
               st.DrawText := ItemNamed['text'].Items.ItemNamed['draw'].BoolValue;
          end;
          if ItemNamed['normal'] <> nil then
             st.Normal.LoadFromXML(ItemNamed['normal'],path,SkinText);
          if ItemNamed['normalhover'] <> nil then
             st.NormalHover.LoadFromXML(ItemNamed['normalhover'],path,SkinText);
          if ItemNamed['down'] <> nil then
             st.Down.LoadFromXML(ItemNamed['down'],path,SkinText);
          if ItemNamed['downhover'] <> nil then
             st.DownHover.LoadFromXML(ItemNamed['downhover'],path,SkinText);
          if ItemNamed['highlight'] <> nil then
             st.Highlight.LoadFromXML(ItemNamed['highlight'],path,SkinText);
          if ItemNamed['highlighthover'] <> nil then
             st.HighlightHover.LoadFromXML(ItemNamed['highlighthover'],path,SkinText);
          if ItemNamed['dimension'] <> nil then
             st.SkinDim.SetDimension(Value('dimension', 'w,h'));
          if ItemNamed['location'] <> nil then
             st.SkinDim.SetLocation(Value('location','0,0'));
         {$WARNINGS OFF}
          if ItemNamed['OnNormalMouseEnter'] <> nil then
             st.OnNormalMouseEnterScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnNormalMouseEnter',''));
          if ItemNamed['OnNormalMouseLeave'] <> nil then
             st.OnNormalMouseLeaveScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnNormalMouseLeave',''));
          if ItemNamed['OnDownMouseEnter'] <> nil then
             st.OnDownMouseEnterScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnDownMouseEnter',''));
          if ItemNamed['OnDownMouseLeave'] <> nil then
             st.OnDownMouseLeaveScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnDownMouseLeave',''));
          if ItemNamed['OnHighlightMouseEnter'] <> nil then
             st.OnHighlightMouseEnterScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnHighlightMouseEnter',''));
          if ItemNamed['OnHighlightMouseLeave'] <> nil then
             st.OnHighlightMouseLeaveScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnHighlightMouseLeave',''));
          if ItemNamed['OnHighlightStepStart'] <> nil then
             st.OnHighlightStepStartScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnHighlightStepStart',''));
          if ItemNamed['OnHighlightStepEnd'] <> nil then
             st.OnHighlightStepEndScript := LoadScriptFromFile(IncludeTrailingBackSlash(Path) + Value('OnHighlightStepEnd',''));
          {$WARNINGS ON}
          if ItemNamed['icon'] <> nil then
          begin
            if ItemNamed['icon'].Items.ItemNamed['draw'] <> nil then
               st.DrawIcon := ItemNamed['icon'].Items.ItemNamed['draw'].BoolValue;
            if ItemNamed['icon'].Items.ItemNamed['size'] <> nil then
               st.IconSize := ItemNamed['icon'].Items.ItemNamed['size'].IntValue;
            if ItemNamed['icon'].Items.ItemNamed['location'] <> nil then
               st.IconLocation.SetPoint(ItemNamed['icon'].Items.ItemNamed['location'].Value);
          end;
          if ItemNamed['spacing'] <> nil then
             st.Spacing := IntValue('spacing',2);
        end;
      end;
    finally
      SkinText.free;
    end;
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

function TSharpETaskItemSkin.valid(tis : TSharpETaskItemStates) : boolean;
begin
  case tis of
    tisCompact : result := not FCompact.Normal.Empty;
    tisMini    : result := not FMini.Normal.Empty;
    else result := not FFull.Normal.Empty;
  end;
end;

//***************************************
//* TSharpEFormSkin
//***************************************

constructor TSharpEFormSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetDimension('w', 'h');
  FFull := TSkinPart.Create(BmpList);
  FFullLROffset := TSkinPoint.Create;
  FFullTBOffset := TSkinPoint.Create;
  FTitleDim := TSkinDim.Create;
end;

destructor TSharpEFormSkin.Destroy;
begin
  FFull.Free;
  FSkinDim.Free;
  FFullLROffset.Free;
  FFullTBOffset.Free;
  FTitleDim.Free;
end;

procedure TSharpEFormSkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FFull.UpdateDynamicProperties(cs);
end;

procedure TSharpEFormSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FFull.SaveToStream(Stream);
  FFullLROffset.SaveToStream(Stream);
  FFullTBOffset.SaveToStream(Stream);
  FTitleDim.SaveToStream(Stream);
end;

procedure TSharpEFormSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FFull.LoadFromStream(Stream);
  FFullLROffset.LoadFromStream(Stream);
  FFullTBOffset.LoadFromStream(Stream);
  FTitleDim.LoadFromStream(Stream);
end;

procedure TSharpEFormSkin.Clear;
begin
  FFull.Clear;
  FSkinDim.SetDimension('w', 'h');
  FFullLROffset.SetPoint('5','5');
  FFullTBOffset.SetPoint('5','5');
  FTitleDim.SetLocation('5','5');
  FTitleDim.SetDimension('w-10','5');
end;

procedure TSharpEFormSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['full'] <> nil then
      begin
        FFull.LoadFromXML(ItemNamed['full'], path, SkinText);
        if ItemNamed['full'].Items.ItemNamed['lroffset'] <> nil then
           FFullLROffset.SetPoint(ItemNamed['full'].Items.ItemNamed['lroffset'].Value);
        if ItemNamed['full'].Items.ItemNamed['tboffset'] <> nil then
           FFullTBOffset.SetPoint(ItemNamed['full'].Items.ItemNamed['tboffset'].Value);
        if ItemNamed['full'].Items.ItemNamed['tbarlocation'] <> nil then
           FTitleDim.SetLocation(ItemNamed['full'].Items.ItemNamed['tbarlocation'].Value);
        if ItemNamed['full'].Items.ItemNamed['tbardimension'] <> nil then
           FTitleDim.SetDimension(ItemNamed['full'].Items.ItemNamed['tbardimension'].Value);
      end;
    end;
  finally
    SkinText.free;
  end;
end;

function TSharpEFormSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEFormSkin.valid: boolean;
begin
  result := not (FFull.Empty);
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
end;

destructor TSharpEMiniThrobberSkin.Destroy;
begin
  FNormal.Free;
  FDown.Free;
  FHover.Free;
  FSkinDim.Free;
  FBottomSkinDim.Free;
end;

procedure TSharpEMiniThrobberSkin.UpdateDynamicProperties(cs: TSharpEScheme);
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

procedure TSharpEMiniThrobberSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location', '0,0'));
      if ItemNamed['bottomlocation'] <> nil then
        FBottomSkinDim.SetLocation(Value('bottomlocation', '0,0'))
        else FBottomSkinDim.Assign(FSkinDim);
    end;
  finally
    SkinText.free;
  end;
end;

function TSharpEMiniThrobberSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEMiniThrobberSkin.valid: boolean;
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
  FFocus := TSkinPart.Create(BmpList);
  FDisabled := TSkinPart.Create(BmpList);
  FHover := TSkinPart.Create(BmpList);
  FEditXOffsets := TSkinPoint.Create;
  FEditYOffsets := TSkinPoint.Create;
end;

destructor TSharpEEditSkin.Destroy;
begin
  FNormal.Free;
  FFocus.Free;
  FDisabled.Free;
  FHover.Free;
  FEditXOffsets.Free;
  FEditYOffsets.Free;
  FSkinDim.Free;
end;

procedure TSharpEEditSkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FFocus.UpdateDynamicProperties(cs);
  FDisabled.UpdateDynamicProperties(cs);
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
  FDisabled.SaveToStream(Stream);
end;

procedure TSharpEEditSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FFocus.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  FEditXOffsets.LoadFromStream(Stream);
  FEditYOffsets.LoadFromStream(Stream);
  FDisabled.LoadFromStream(Stream);
end;

procedure TSharpEEditSkin.Clear;
begin
  FNormal.Clear;
  FFocus.Clear;
  FDisabled.Clear;
  FHover.Clear;
  FEditXOffsets.Clear;
  FEditYOffsets.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
end;

procedure TSharpEEditSkin.LoadFromXML(xml: TJvSimpleXMLElem; path:
  string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText);
      if ItemNamed['focus'] <> nil then
        FFocus.LoadFromXML(ItemNamed['focus'], path, SkinText);
      if ItemNamed['disabled'] <> nil then
        FDisabled.LoadFromXML(ItemNamed['disabled'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXMl(ItemNamed['hover'], path, SkinText);
      if ItemNamed['editxoffsets'] <> nil then
        FEditXOffsets.SetPoint(Value('editxoffsets','2,2'));
      if ItemNamed['edityoffsets'] <> nil then
        FEditYOffsets.SetPoint(Value('edityoffsets', '2,2'));
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location', '0,0'));
    end;
  finally
    SkinText.free;
  end;
end;

function  TSharpEEditSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEEditSkin.valid: boolean;
begin
  result := not (FNormal.Empty);
end;

//***************************************
//* TSharpECheckBox
//***************************************

constructor TSharpECheckBoxSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetDimension('w', 'h');
  FNormal := TSkinPart.Create(BmpList);
  FDown := TSkinPart.Create(BmpList);
  FHover := TSkinPart.Create(BmpList);
  FDisabled := TSkinPart.Create(BmpList);
  FChecked := TSkinPart.Create(BmpList);
end;

destructor TSharpECheckBoxSkin.Destroy;
begin
  FNormal.Free;
  FDown.Free;
  FHover.Free;
  FDisabled.Free;
  FChecked.Free;
  FSkinDim.Free;
end;

procedure TSharpECheckBoxSkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FDown.UpdateDynamicProperties(cs);
  FHover.UpdateDynamicProperties(cs);
  FDisabled.UpdateDynamicProperties(cs);
  FChecked.UpdateDynamicProperties(cs);
end;

procedure TSharpECheckBoxSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FNormal.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  FDisabled.SaveToStream(Stream);
  FChecked.SaveToStream(Stream);
end;

procedure TSharpECheckBoxSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FDown.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  FDisabled.LoadFromStream(Stream);
  FChecked.LoadFromStream(Stream);
end;

procedure TSharpECheckBoxSkin.Clear;
begin
  FNormal.Clear;
  FDown.Clear;
  FHover.Clear;
  FDisabled.Clear;
  FChecked.Clear;
  FSkinDim.SetDimension('w', 'h');
end;

procedure TSharpECheckBoxSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText);
      if ItemNamed['disabled'] <> nil then
        FDisabled.LoadFromXML(ItemNamed['disabled'], path, SkinText);
      if ItemNamed['checked'] <> nil then
        FChecked.LoadFromXML(ItemNamed['checked'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
    end;
  finally
    SkinText.free;
  end;
end;

function TSharpECheckBoxSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpECheckBoxSkin.valid: boolean;
begin
  result := not (FNormal.Empty);
end;

//***************************************
//* TSharpEProgressBarSkin
//***************************************

constructor TSharpEProgressBarSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetDimension('w', 'h');
  FBackGround := TSkinPart.Create(BmpList);
  FProgress := TSkinPart.Create(BmpList);
  FBackGroundSmall := TSkinPart.Create(BmpList);
  FProgressSmall := TSkinPart.Create(BmpList);
  FSmallModeOffset := TSkinPoint.Create;
end;

destructor TSharpEProgressBarSkin.Destroy;
begin
  FBackGround.Free;
  FProgress.Free;
  FSkinDim.Free;
  FBackGroundSmall.Free;
  FProgressSmall.Free;
  FSmallModeOffset.Free;
end;

procedure TSharpEProgressBarSkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FBackGround.UpdateDynamicProperties(cs);
  FProgress.UpdateDynamicProperties(cs);
  FBackGroundSmall.UpdateDynamicProperties(cs);
  FProgressSmall.UpdateDynamicProperties(cs);
end;

procedure TSharpEProgressBarSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FBackGround.SaveToStream(Stream);
  FProgress.SaveToStream(Stream);
  FBackgroundSmall.SaveToStream(Stream);
  FProgressSmall.SaveToStream(Stream);
  FSmallModeOffset.SaveToStream(Stream);
end;

procedure TSharpEProgressBarSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
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
  FSmallModeOffset.SetPoint('0', '0');
end;

procedure TSharpEProgressBarSkin.LoadFromXML(xml: TJvSimpleXMLElem; path:
  string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['background'] <> nil then
        FBackGround.LoadFromXML(ItemNamed['background'], path, SkinText);
      if ItemNamed['progress'] <> nil then
        FProgress.LoadFromXML(ItemNamed['progress'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
      if ItemNamed['smallbackground'] <> nil then
        FBackGroundSmall.LoadFromXML(ItemNamed['smallbackground'], path,
          SkinText);
      if ItemNamed['smallprogress'] <> nil then
        FProgressSmall.LoadFromXML(ItemNamed['smallprogress'], path, SkinText);
      if ItemNamed['smallmode'] <> nil then
        FSmallModeOffset.SetPoint(Value('smallmode', '0,0'));
    end;
  finally
    SkinText.free;
  end;
end;

function TSharpEProgressBarSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEProgressBarSkin.valid: boolean;
begin
  result := not (FBackGround.Empty);
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
  FFSMod := TSkinPoint.Create;
  FSBMod := TSKinPoint.Create;
  FPTXoffset := TSkinPoint.Create;
  FPTYoffset := TSkinPoint.Create;
  FPBXoffset := TSkinPoint.Create;
  FPBYoffset := TSkinPoint.Create;
  FPAXoffset := FPTXoffset;
  FPAYoffset := FPTYoffset;
  FEnableVFlip := False;
  FSpecialHideForm := False;
  FGlassEffect := False;
  Clear;
end;

destructor TSharpEBarSkin.Destroy;
begin
  FThNormal.Free;
  FThDown.Free;
  FThBDim.Free;
  FThHover.Free;
  FBar.Free;
  FBarBorder.Free;
  FBarBottom.Free;
  FBarBottomBorder.Free;
  FSkinDim.Free;
  FThDim.Free;
  FFSMod.Free;
  FSBMod.Free;
  FPTXoffset.Free;
  FPTYoffset.Free;
  FPBXoffset.Free;
  FPBYoffset.Free;
end;

procedure TSharpEBarSkin.UpdateDynamicProperties(cs: TSharpEScheme);
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

  if FEnableVFlip then StringSavetoStream('1', Stream)
     else StringSavetoStream('0', Stream);

  if FSpecialHideForm then StringSaveToStream('1', Stream)
     else StringSaveToStream('0', Stream);

  if FGlassEffect then StringSavetoStream('1', Stream)
     else StringSaveToStream('0', Stream);
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
    DefaultSkin := True;
    //FBar.BitmapID := BID;
    SkinDim.SetDimension('w', '33');
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
    DefaultSkin := False;
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

procedure TSharpEBarSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
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

function TSharpEBarSkin.GetThrobberBottomDim(r: TRect): TRect;
begin
  result := FThBDim.GetRect(r);
end;

function TSharpEBarSkin.GetThrobberDim(r: Trect): TRect;
begin
  result := FThDim.GetRect(r);
end;

function TSharpEBarSkin.valid: boolean;
begin
  result := not (FBar.Empty);
end;

{ TSharpEPanelSkin }

constructor TSharpEPanelSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetDimension('w', 'h');
  FNormal := TSkinPart.Create(BmpList);
  FRaised := TSkinPart.Create(BmpList);
  FLowered := TSkinPart.Create(BmpList);
  FSelected := TSkinPart.Create(BmpList);
end;

procedure TSharpEPanelSkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FRaised.UpdateDynamicProperties(cs);
  FLowered.UpdateDynamicProperties(cs);
  FSelected.UpdateDynamicProperties(cs);
end;

procedure TSharpEPanelSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText);
      if ItemNamed['raised'] <> nil then
        FRaised.LoadFromXML(ItemNamed['raised'], path, SkinText);
      if ItemNamed['lowered'] <> nil then
        FLowered.LoadFromXML(ItemNamed['lowered'], path, SkinText);
      if ItemNamed['selected'] <> nil then
        FSelected.LoadFromXML(ItemNamed['selected'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
    end;
  finally
    SkinText.free;
  end;
end;

function TSharpEPanelSkin.GetAutoDim(r: TRect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpEPanelSkin.Valid: boolean;
begin
  result := not (FNormal.Empty);
end;

procedure TSharpEPanelSkin.Clear;
begin
  FNormal.Clear;
  FRaised.Clear;
  FLowered.Clear;
  FSelected.Clear;
  FSkinDim.SetDimension('w', 'h');
end;

destructor TSharpEPanelSkin.Destroy;
begin
  FNormal.Free;
  FRaised.Free;
  FLowered.Free;
  FSelected.Free;
  FSkinDim.Free;
end;

procedure TSharpESkin.FreeInstance;
begin
  inherited;

end;

procedure TSharpEPanelSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FRaised.LoadFromStream(Stream);
  FLowered.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FSelected.LoadFromStream(Stream);
end;

procedure TSharpEPanelSkin.SaveToStream(Stream: TStream);
begin
   FSkinDim.SaveToStream(Stream);
  FRaised.SaveToStream(Stream);
  FLowered.SaveToStream(Stream);
  FNormal.SaveToStream(Stream);
  FSelected.SaveToStream(Stream);
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

procedure TSharpESkinHeader.LoadFromXml(xml: TJvSimpleXMLElem; path: string);
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

function TSharpESkin.GetSkinAuthor: string;
begin
  Result := FSkinHeader.Author
end;

function TSharpESkin.GetSkinVersion: string;
begin
  Result := FSkinHeader.Version;
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

{ TSharpERadioBoxSkin }

constructor TSharpERadioBoxSkin.Create(BmpList : TSkinBitmapList);
begin
  FSkinDim := TSkinDim.Create;
  FSkinDim.SetDimension('w', 'h');
  FNormal := TSkinPart.Create(BmpList);
  FDown := TSkinPart.Create(BmpList);
  FHover := TSkinPart.Create(BmpList);
  FDisabled := TSkinPart.Create(BmpList);
  FChecked := TSkinPart.Create(BmpList);
end;

destructor TSharpERadioBoxSkin.Destroy;
begin
  FNormal.Free;
  FDown.Free;
  FHover.Free;
  FDisabled.Free;
  FChecked.Free;
  FSkinDim.Free;
end;

procedure TSharpERadioBoxSkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FNormal.UpdateDynamicProperties(cs);
  FDown.UpdateDynamicProperties(cs);
  FHover.UpdateDynamicProperties(cs);
  FDisabled.UpdateDynamicProperties(cs);
  FChecked.UpdateDynamicProperties(cs);
end;

procedure TSharpERadioBoxSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FNormal.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  FDisabled.SaveToStream(Stream);
  FChecked.SaveToStream(Stream);
end;

procedure TSharpERadioBoxSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FDown.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
  FDisabled.LoadFromStream(Stream);
  FChecked.LoadFromStream(Stream);
end;

procedure TSharpERadioBoxSkin.Clear;
begin
  FNormal.Clear;
  FDown.Clear;
  FHover.Clear;
  FDisabled.Clear;
  FChecked.Clear;
  FSkinDim.SetDimension('w', 'h');
end;

procedure TSharpERadioBoxSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var SkinText: TSkinText;
begin
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText);
      if ItemNamed['disabled'] <> nil then
        FDisabled.LoadFromXML(ItemNamed['disabled'], path, SkinText);
      if ItemNamed['checked'] <> nil then
        FChecked.LoadFromXML(ItemNamed['checked'], path, SkinText);
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', 'w,h'));
    end;
  finally
    SkinText.free;
  end;
end;

function TSharpERadioBoxSkin.GetAutoDim(r: Trect): TRect;
begin
  result := FSkinDim.GetRect(r);
end;

function TSharpERadioBoxSkin.valid: boolean;
begin
  result := not (FNormal.Empty);
end;

end.
