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
    FOCDText    : TSkinText;
    FTextPosTL : TSkinPoint;
    FTextPosBL : TSkinPoint;
    FSkinVersion: Double;
    FBitmapList: TSkinBitmapList;
    FLoadSkins : TSharpESkinItems;

    FOnNotify: TSkinEvent;
    FButtonSkin: TSharpEButtonSkin;
    FProgressBarSkin: TSharpEProgressBarSkin;
    FBarSkin: TSharpEBarSkin;
    FMiniThrobberSkin: TSharpEMiniThrobberSkin;
    FEditSkin: TSharpEEditSkin;
    FTaskItemSkin: TSharpETaskItemSkin;
    FMenuSkin : TSharpEMenuSkin;
    FMenuItemSkin: TSharpEMenuItemSkin;
    FTaskSwitchSkin : TSharpETaskSwitchSkin;
    FNotifySkin : TSharpENotifySkin;

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
    property ProgressBarSkin: TSharpEProgressBarSkin read FProgressBarSkin;
    property BarSkin: TSharpEBarSkin read FBarSkin;
    property MiniThrobberSkin: TSharpEMiniThrobberSkin read FMiniThrobberSkin;
    property EditSkin: TSharpEEditSkin read FEditSkin;
    property MenuSkin : TSharpEMenuSkin read FMenuSkin;
    property MenuItemSkin : TSharpEMenuItemSkin read FMenuItemSkin;
    property TaskItemSkin: TSharpETaskItemSkin  read FTaskItemSkin;
    property TaskSwitchSkin : TSharpETaskSwitchSkin read FTaskSwitchSkin;
    property NotifySkin : TSharpENotifySkin read FNotifySkin;
    property SkinText: TSkinText read FSkinText;
    property SmallText  : TSkinText read FSmallText;
    property MediumText : TSkinText read FMediumText;
    property BigText    : TSkinText read FBigText;
    property OCDText    : TSkinText read FOCDText;
    property TextPosTL : TSkinPoint read FTextPosTL;
    property TextPosBL : TSkinPoint read FTextPosBL;
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

  TSharpETaskItemState = class
                           Normal         : TSkinPartEx;
                           NormalHover    : TSkinPartEx;
                           Down           : TSkinPartEx;
                           DownHover      : TSkinPartEx;
                           Highlight      : TSkinPartEx;
                           HighlightHover : TSkinPartEx;
                           Spacing        : integer;
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

  TSharpENotifySkin = class
  private
    FSkinDim    : TSkinDim;
    FCATBOffset : TSkinPoint;
    FCALROffset : TSkinPoint;
    FBackground : TSkinPartEx;
  public
    constructor Create(BmpList : TSkinBitmapList);
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem; path: string);
    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    property SkinDim : TSkinDim read FSkinDim;
    property CATBOffset : TSkinPoint read FCATBOffset;
    property CALROffset : TSkinPoint read FCALROffset;
    property Background : TSkinPartEx read FBackground;
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
    FNormal: TSkinPartEx;
    FDown: TSkinPartEx;
    FHover: TSkinPartEx;
    FDisabled: TSkinPartEx;
    FWidthMod: integer;
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

    property WidthMod: integer read FWidthMod write FWidthMod;
    property Normal: TSkinPartEx read FNormal write FNormal;
    property Down: TSkinPartEx read FDown write FDown;
    property Hover: TSkinPartEx read FHover write FHover;
    property Disabled: TSkinPartEx read FDisabled write FDisabled;
    property SkinDim: TSkinDim read FSkinDim;
    property OnNormalMouseEnterScript : String read FOnNormalMouseEnterScript;
    property OnNormalMouseLeaveScript : String read FOnNormalMouseLeaveScript;
 end;

  TSharpEProgressBarSkin = class
  private
    FSkinDim: TSkinDim;
    FSkinDimTL: TSkinDim;
    FSkinDimBL: TSkinDim;
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
    function GetAutoDim(r: TRect; vpos : TSharpEBarAutoPos): TRect;
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
  if scProgressBar in FLoadSkins then FProgressBarSkin := TSharpEProgressBarSkin.create(FBitmapList);
  if scBar in FLoadSkins then FBarSkin := TSharpEBarSkin.create(FBitmapList);
  if scTaskItem in FLoadSkins then FTaskItemSkin := TSharpeTaskItemSkin.Create(FBitmapList);
  FSkinText := TSkinText.Create;
  FSmallText  := TSkinText.Create;
  FMediumText := TSkinText.Create;
  FBigText    := TSkinText.Create;
  FOCDText    := TSkinText.Create;
  FTextPosTL  := TSkinPoint.Create;
  FTextPosBL  := TSkinPoint.Create;
  FSkinHeader := TSharpeSkinHeader.Create;
  if scMiniThrobber in FLoadSkins then FMiniThrobberskin := TSharpEMiniThrobberSkin.Create(FBitmapList);
  if scEdit in FLoadSkins then FEditSkin := TSharpEEditSkin.Create(FBitmapList);
  if scMenu in FLoadSkins then FMenuSkin := TSharpEMenuSkin.Create(FBitmapList);
  if scMenuItem in FLoadSkins then FMenuItemSkin := TSharpEMenuItemSkin.Create(FBitmapList);
  if scTaskSwitch in FLoadSkins then FTaskSwitchSkin := TSharpETaskSwitchSkin.Create(FBitmapList);
  if scNotify in FLoadSkins then FNotifySkin := TSharpENotifySkin.Create(FBitmapList);

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
  if FProgressBarskin <> nil then FProgressBarSkin.Free;
  if FBarSkin <> nil then FBarSkin.Free;
  if FTaskItemSkin <> nil then FTaskItemSkin.Free;
  FSkinText.Free;
  FSmallText.Free;
  FMediumText.Free;
  FBigText.Free;
  FOCDText.Free;
  FTextPosTL.Free;
  FTextPosBL.Free;
  FSkinHeader.Free;
  if FMiniThrobberSkin <> nil then FMiniThrobberSkin.Free;
  if FEditSkin <> nil then FEditSkin.Free;
  if FMenuSkin <> nil then FMenuSkin.Free;
  if FMenuItemSkin <> nil then FMenuItemSkin.Free;
  if FTaskSwitchSkin <> nil then FTaskSwitchSkin.Free;
  if FNotifySkin <> nil then FNotifySkin.Free;


  FBitmapList.Free;
  inherited;
end;

procedure TSharpESkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  if FButtonSkin <> nil then FButtonSkin.UpdateDynamicProperties(cs);
  if FProgressBarskin <> nil then FProgressBarSkin.UpdateDynamicProperties(cs);
  if FBarSkin <> nil then FBarSkin.UpdateDynamicProperties(cs);
  if FTaskItemSkin <> nil then FTaskItemSkin.UpdateDynamicProperties(cs);
  if FMiniThrobberSkin <> nil then FMiniThrobberSkin.UpdateDynamicProperties(cs);
  if FEditSkin <> nil then FEditSkin.UpdateDynamicProperties(cs);
  if FMenuSkin <> nil then FMenuSkin.UpdateDynamicProperties(cs);
  if FMenuItemSkin <> nil then FMenuItemSkin.UpdateDynamicProperties(cs);
  if FTaskSwitchSkin <> nil then FTaskSwitchSkin.UpdateDynamicProperties(cs);
  if FNotifySkin <> nil then FNotifySkin.UpdateDynamicProperties(cs);

  FSkinText.UpdateDynamicProperties(cs);
  FSmallText.UpdateDynamicProperties(cs);
  FMediumText.UpdateDynamicProperties(cs);
  FBigText.UpdateDynamicProperties(cs);
  FOCDText.UpdateDynamicProperties(cs);
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
  if FMiniThrobberSkin <> nil then
  begin
    RemoveskinPartBitmaps(FMiniThrobberSkin.Normal,List);
    RemoveskinPartBitmaps(FMiniThrobberSkin.Down,List);
    RemoveskinPartBitmaps(FMiniThrobberSkin.Hover,List);
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
  if FTaskSwitchSkin <> nil then
  begin
    RemoveskinpartBitmaps(FTaskSwitchSkin.Background,List);
    RemoveskinpartBitmaps(FTaskSwitchSkin.Item,List);
    RemoveskinpartBitmaps(FTaskSwitchSkin.ItemHover,List);
  end;
  if FNotifySkin <> nil then
  begin
    RemoveskinpartBitmaps(FNotifySkin.Background,List);
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
  FOCDText.SaveToStream(Stream);
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
    FOCDText.LoadFromStream(Stream);
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
  if FProgressBarSkin <> nil then FProgressBarSkin.Clear;
  if FBarSkin <> nil then FBarSkin.Clear;
  FSkinHeader.Clear;
  if FMiniThrobberSkin <> nil then FMiniThrobberSkin.Clear;
  if FEditSkin <> nil then FEditSkin.Clear;
  if FMenuSkin <> nil then FMenuSkin.Clear;
  if FMenuItemSkin <> nil then FMenuItemSkin.Clear;
  if FTaskItemSkin <> nil then FTaskItemSkin.Clear;
  if FTaskSwitchSkin <> nil then FTaskSwitchSkin.Clear;
  if FNotifySkin <> nil then FNotifySkin.Clear;  

  FSmallText.Clear;
  FMediumText.Clear;
  FBigText.Clear;
  FOCDText.Clear;
  FBitmapList.Clear;
  FTextPosTL.Clear;
  FTextPosBL.Clear;

  FOCDText.ColorString := 'clwhite';
  FOCDText.Color := 16777215;
  FOCDText.ShadowColorString := '0';
  FOCDText.ShadowColor := 0;
  FOCDText.Shadow := True;
  FOCDText.ShadowType := stOutline;
  FOCDText.Size := 56;
  FOCDText.Alpha := 224;
  FOCDText.AlphaString := '224';

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
       if ItemNamed['locationTL'] <> nil then
          FTextPosTL.SetPoint(ItemNamed['locationTL'].Value);
       if ItemNamed['locationBL'] <> nil then
          FTextPosBL.SetPoint(ItemNamed['locationBL'].Value);
       if ItemNamed['small'] <> nil then
          FSmallText.LoadFromXML(ItemNamed['small']);
       if ItemNamed['medium'] <> nil then
          FMediumText.LoadFromXML(ItemNamed['medium']);
       if ItemNamed['big'] <> nil then
          FBigText.LoadFromXML(ItemNamed['big']);
       if ItemNamed['osd'] <> nil then
          FOCDText.LoadFromXML(ItemNamed['osd']);
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
    SkinIcon.Free;
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
  FDown := TSkinPartEx.Create(BmpList);
  FHover := TSkinPartEx.Create(BmpList);
  FDisabled := TSkinPartEx.Create(BmpList);
  FOnNormalMouseEnterScript   := '';
  FOnNormalMouseLeaveScript   := '';
  FWidthMod := 0;
end;

destructor TSharpEButtonSkin.Destroy;
begin
  FNormal.Free;
  FDown.Free;
  FHover.Free;
  FDisabled.Free;
  FSkinDim.Free;
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
  FNormal.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
  FDisabled.SaveToStream(Stream);
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
  FDisabled.LoadFromStream(Stream);
  FOnNormalMouseEnterScript := StringLoadFromStream(Stream);
  FOnNormalMouseLeaveScript := StringLoadFromStream(Stream);
  Stream.ReadBuffer(FWidthMod,SizeOf(FWidthMod));
end;

procedure TSharpEButtonSkin.Clear;
begin
  FNormal.Clear;
  FDown.Clear;
  FHover.Clear;
  FDisabled.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
  FOnNormalMouseEnterScript   := '';
  FOnNormalMouseLeaveScript   := '';
  FWidthMod := 0;
end;

procedure TSharpEButtonSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var
  SkinText: TSkinText;
  SkinIcon: TSkinIcon;
begin
  SkinIcon := TSkinIcon.Create;
  SkinIcon.DrawIcon := True;
  SkinText := TSkinText.create;
  SkinText.SetLocation('cw', 'ch');
  try
    with xml.Items do
    begin
      if ItemNamed['text'] <> nil then
        SkinText.LoadFromXML(ItemNamed['text']);
      if ItemNamed['icon'] <> nil then
        SkinIcon.LoadFromXML(ItemNamed['icon']);

      if ItemNamed['normal'] <> nil then
        FNormal.LoadFromXML(ItemNamed['normal'], path, SkinText, SkinIcon);
      if ItemNamed['down'] <> nil then
        FDown.LoadFromXML(ItemNamed['down'], path, SkinText, SkinIcon);
      if ItemNamed['hover'] <> nil then
        FHover.LoadFromXML(ItemNamed['hover'], path, SkinText, SkinIcon);
      if ItemNamed['disabled'] <> nil then
        FDisabled.LoadFromXML(ItemNamed['disabled'], path, SkinText, SkinIcon);
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
    SkinText.free;
    SkinIcon.free;
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
  FFull.Normal         := TSkinPartEx.Create(BmpList);
  FFull.NormalHover    := TSkinPartEx.Create(BmpList);
  FFull.Down           := TSkinPartEx.Create(BmpList);
  FFull.DownHover      := TSkinPartEx.Create(BmpList);
  FFull.Highlight      := TSkinPartEx.Create(BmpList);
  FFull.HighlightHover := TSkinPartEx.Create(BmpList);

  FCompact.SkinDim := TSkinDim.Create;
  FCompact.Normal         := TSkinPartEx.Create(BmpList);
  FCompact.NormalHover    := TSkinPartEx.Create(BmpList);
  FCompact.Down           := TSkinPartEx.Create(BmpList);
  FCompact.DownHover      := TSkinPartEx.Create(BmpList);
  FCompact.Highlight      := TSkinPartEx.Create(BmpList);
  FCompact.HighlightHover := TSkinPartEx.Create(BmpList);

  FMini.SkinDim := TSkinDim.Create;
  FMini.Normal         := TSkinPartEx.Create(BmpList);
  FMini.NormalHover    := TSkinPartEx.Create(BmpList);
  FMini.Down           := TSkinPartEx.Create(BmpList);
  FMini.DownHover      := TSkinPartEx.Create(BmpList);
  FMini.Highlight      := TSkinPartEx.Create(BmpList);
  FMini.HighlightHover := TSkinPartEx.Create(BmpList);

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

  FCompact.SkinDim.Free;
  FCompact.Normal.Free;
  FCompact.NormalHover.Free;
  FCompact.Down.Free;
  FCompact.DownHover.Free;
  FCompact.Highlight.Free;
  FCompact.HighlightHover.Free;

  FMini.SkinDim.Free;
  FMini.Normal.Free;
  FMini.NormalHover.Free;
  FMini.Down.Free;
  FMini.DownHover.Free;
  FMini.Highlight.Free;
  FMini.HighlightHover.Free;

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
  StringSaveToStream(inttostr(FFull.Spacing),Stream);
  SaveTIScriptsToStream(FFull,Stream);

  FCompact.SkinDim.SaveToStream(Stream);
  FCompact.Normal.SaveToStream(Stream);
  FCompact.NormalHover.SaveToStream(Stream);
  FCompact.Down.SaveToStream(Stream);
  FCompact.DownHover.SaveToStream(Stream);
  FCompact.Highlight.SaveToStream(Stream);
  FCompact.HighlightHover.SaveToStream(Stream);
  StringSaveToStream(inttostr(FCompact.Spacing),Stream);
  SaveTIScriptsToStream(FCompact,Stream);

  FMini.SkinDim.SaveToStream(Stream);
  FMini.Normal.SaveToStream(Stream);
  FMini.NormalHover.SaveToStream(Stream);
  FMini.Down.SaveToStream(Stream);
  FMini.DownHover.SaveToStream(Stream);
  FMini.Highlight.SaveToStream(Stream);
  FMini.HighlightHover.SaveToStream(Stream);
  StringSaveToStream(inttostr(FMini.Spacing),Stream);
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
  FFull.Spacing := StrToInt(StringLoadFromStream(Stream));
  LoadTIScriptsFromStream(FFull,Stream);

  FCompact.SkinDim.LoadFromStream(Stream);
  FCompact.Normal.LoadFromStream(Stream);
  FCompact.NormalHover.LoadFromStream(Stream);
  FCompact.Down.LoadFromStream(Stream);
  FCompact.DownHover.LoadFromStream(Stream);
  FCompact.Highlight.LoadFromStream(Stream);
  FCompact.HighlightHover.LoadFromStream(Stream);
  FCompact.Spacing := StrToInt(StringLoadFromStream(Stream));
  LoadTIScriptsFromStream(FCompact,Stream);

  FMini.SkinDim.LoadFromStream(Stream);
  FMini.Normal.LoadFromStream(Stream);
  FMini.NormalHover.LoadFromStream(Stream);
  FMini.Down.LoadFromStream(Stream);
  FMini.DownHover.LoadFromStream(Stream);
  FMini.Highlight.LoadFromStream(Stream);
  FMini.HighlightHover.LoadFromStream(Stream);
  FMini.Spacing := StrToInt(StringLoadFromStream(Stream));
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
  FMini.Spacing := 2;
end;

procedure TSharpETaskItemSkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
var
 SkinText: TSkinText;
 SkinIcon: TSkinIcon;
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
    SkinIcon := TSkinIcon.Create;
    SkinIcon.DrawIcon := True;
    try
      with xml.Items do
      begin
        if ItemNamed[loadstr] <> nil then
        with ItemNamed[loadstr].Items do
        begin
          if ItemNamed['text'] <> nil then
             SkinText.LoadFromXML(ItemNamed['text']);
          if ItemNamed['icon'] <> nil then
             SkinIcon.LoadFromXML(ItemNamed['icon']);
          if ItemNamed['normal'] <> nil then
             st.Normal.LoadFromXML(ItemNamed['normal'],path,SkinText,SkinIcon);
          if ItemNamed['normalhover'] <> nil then
             st.NormalHover.LoadFromXML(ItemNamed['normalhover'],path,SkinText,SkinIcon);
          if ItemNamed['down'] <> nil then
             st.Down.LoadFromXML(ItemNamed['down'],path,SkinText,SkinIcon);
          if ItemNamed['downhover'] <> nil then
             st.DownHover.LoadFromXML(ItemNamed['downhover'],path,SkinText,SkinIcon);
          if ItemNamed['highlight'] <> nil then
             st.Highlight.LoadFromXML(ItemNamed['highlight'],path,SkinText,SkinIcon);
          if ItemNamed['highlighthover'] <> nil then
             st.HighlightHover.LoadFromXML(ItemNamed['highlighthover'],path,SkinText,SkinIcon);
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
//* TSharpEProgressBarSkin
//***************************************

constructor TSharpEProgressBarSkin.Create(BmpList : TSkinBitmapList);
begin
  inherited Create;

  FSkinDim := TSkinDim.Create;
  FSkinDimTL := TSkinDim.Create;
  FSkinDimBL := TSkinDim.Create;
  FBackGround := TSkinPart.Create(BmpList);
  FProgress := TSkinPart.Create(BmpList);
  FBackGroundSmall := TSkinPart.Create(BmpList);
  FProgressSmall := TSkinPart.Create(BmpList);
  FSmallModeOffset := TSkinPoint.Create;
  Clear;
end;

destructor TSharpEProgressBarSkin.Destroy;
begin
  FBackGround.Free;
  FProgress.Free;
  FSkinDim.Free;
  FSkinDimTL.Free;
  FSkinDimBL.Free;
  FBackGroundSmall.Free;
  FProgressSmall.Free;
  FSmallModeOffset.Free;

  inherited Destroy;
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
    SkinText.free;
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
  Clear;
end;

destructor TSharpENotifySkin.Destroy;
begin
  FSkinDim.Free;
  FCATBOffset.Free;
  FCALROffset.Free;
  FBackground.Free;

  inherited Destroy;
end;

procedure TSharpENotifySkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FCATBOffset.LoadFromStream(Stream);
  FCALROffset.LoadFromStream(Stream);
  FBackground.LoadFromStream(Stream);
end;

procedure TSharpENotifySkin.LoadFromXML(xml: TJvSimpleXMLElem; path: string);
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
      if ItemNamed['catboffset'] <> nil then
        FCATBOffset.SetPoint(Value('catboffset', '0,0'));
      if ItemNamed['calroffset'] <> nil then
        FCALROffset.SetPoint(Value('calroffset','0,0'));
      if ItemNamed['background'] <> nil then
        FBackground.LoadFromXML(ItemNamed['background'], path, SkinText, SkinIcon);
    end;
  finally
    SkinText.free;
    SkinIcon.Free;
  end;
end;

procedure TSharpENotifySkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FCATBOffset.SaveToStream(Stream);
  FCALROffset.SaveToStream(Stream);
  FBackground.SaveToStream(Stream);
end;

procedure TSharpENotifySkin.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FBackground.UpdateDynamicProperties(cs);
end;

end.
