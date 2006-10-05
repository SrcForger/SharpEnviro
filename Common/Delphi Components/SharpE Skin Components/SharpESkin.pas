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
  Windows,
  Classes,
  Forms,
  SysUtils,
  Dialogs,
  Contnrs,
  gr32,
  graphics,
  jvsimplexml,
  types,
  SharpESkinPart,
  SharpEBitmapList,
  SharpEBase,
  Math;

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
    constructor Create(AOwner: TComponent); overload;override;
    constructor CreateBmp(AOwner: TComponent; BmpList : TSkinBitmapList); overload;
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
    property TaskItemSkin: TSharpETaskItemSkin  read FTaskItemSkin;
    property SkinText: TSkinText read FSkinText;
    property SmallText  : TSkinText read FSmallText;
    property MediumText : TSkinText read FMediumText;
    property BigText    : TSkinText read FBigText;
    property BitmapList: TSkinBitmapList read FBitmapList write FBitmapList;

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
    property Full: TSharpETaskItemState read FFull write FFull;
    property Compact: TSharpETaskItemState read FCompact write FCompact;
    property Mini: TSharpETaskItemState read FMini write FMini;
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
    FBarBottom: TSkinPart;
    FFSMod: TSkinPoint;
    FSBMod: TSkinPoint;
    FPAXoffset: TSkinPoint;
    FPAYoffset: TSkinPoint;
    FSeed: integer;
    FEnableVFlip: boolean;
    FSpecialHideForm: boolean;
    FDefaultSkin: boolean;
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
    property ThNormal: TSkinPart read FThNormal write FThNormal;
    property ThDown: TSkinPart read FThDown write FThDown;
    property ThHover: TSkinPart read FThHover write FThHover;
    property ThDim: TSkinDim read FThDim;
    property ThBDim: TSkinDim read FThBDim;
    property Bar: TSkinPart read FBar write FBar;
    property BarBottom : TSkinPart read FBarBottom write FBarBottom;
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
    property Normal: TSkinPart read FNormal write FNormal;
    property Down: TSkinPart read FDown write FDown;
    property Hover: TSkinPart read FHover write FHover;
    property SkinDim : TSkinDim read FSkinDim;
  end;

implementation
uses SharpESkinManager,gr32_png;


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

constructor TSharpESkin.Create(AOwner: TComponent);
begin
  inherited;
  if FBitmaplist = nil then
    FBitmapList := TSkinBitmapList.Create;
  FButtonSkin := TSharpEButtonSkin.create(FBitmapList);
  FCheckBoxSkin := TSharpECheckBoxSkin.create(FBitmapList);
  FRadioBoxSkin := TSharpERadioBoxSkin.create(FBitmapList);
  FProgressBarSkin := TSharpEProgressBarSkin.create(FBitmapList);
  FFormSkin := TSharpEFormSkin.Create(FBitmapList);
  FBarSkin := TSharpEBarSkin.create(FBitmapList);
  FTaskItemSkin := TSharpeTaskItemSkin.Create(FBitmapList);
  FSkinText := TSkinText.Create;
  FSmallText  := TSkinText.Create;
  FMediumText := TSkinText.Create;
  FBigText    := TSkinText.Create;
  FPanelSkin := TSharpEPanelSkin.Create(FBitmapList);
  FSkinHeader := TSharpeSkinHeader.Create;
  FMiniThrobberskin := TSharpEMiniThrobberSkin.Create(FBitmapList);
  FEditSkin := TSharpEEditSkin.Create(FBitmapList);

  FXml := TJvSimpleXml.Create(nil);
end;

constructor TSharpESkin.CreateBmp(AOwner: TComponent; BmpList : TSkinBitmapList);
begin
  FBitmapList := bmpList;
  Create(Aowner);
end;

destructor TSharpESkin.Destroy;
begin
  FXml.Free;
  FButtonSkin.Free;
  FCheckBoxSkin.Free;
  FRadioBoxSkin.Free;
  FProgressBarSkin.Free;
  FBarSkin.Free;
  FTaskItemSkin.Free;
  FSkinText.Free;
  FSmallText.Free;
  FMediumText.Free;
  FBigText.Free;
  FPanelSkin.Free;
  FSkinHeader.Free;
  FMiniThrobberSkin.Free;
  FEditSkin.Free;
  FFormSkin.Free;
  FBitmapList.Free;
  inherited;
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
    StringSaveToStream('Button', Stream);
    FButtonSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write ProgressBar
    tempStream.clear;
    StringSaveToStream('ProgressBar', Stream);
    FProgressBarSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write CheckBox
    tempStream.clear;
    StringSaveToStream('CheckBox', Stream);
    FCheckBoxSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write RadioBox
    tempStream.clear;
    StringSaveToStream('RadioBox', Stream);
    FRadioBoxSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write Bar
    tempStream.clear;
    StringSaveToStream('Bar', Stream);
    FBarSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write Panel
    tempStream.clear;
    StringSaveToStream('Panel', Stream);
    FPanelSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write MiniThrobber
    tempStream.clear;
    StringSaveToStream('MiniThrobber', Stream);
    FMiniThrobberSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write Edit
    tempStream.clear;
    StringSaveToStream('Edit', Stream);
    FEditSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write Form
    tempStream.clear;
    StringSaveToStream('Form', Stream);
    FFormSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

    //Write TaskItem
    tempStream.clear;
    StringSaveToStream('TaskItem', Stream);
    FTaskItemSkin.SaveToStream(tempStream);
    size := tempStream.Size;
    tempStream.Position := 0;
    Stream.WriteBuffer(size, sizeof(size));
    Stream.CopyFrom(tempStream, Size);

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
        if temp = 'Button' then
          FButtonSkin.LoadFromStream(Stream)
        else
          if temp = 'ProgressBar' then
            FProgressBarSkin.LoadFromStream(Stream)
          else
            if temp = 'CheckBox' then
              FCheckBoxSkin.LoadFromStream(Stream)
            else
              if temp = 'RadioBox' then
                FRadioBoxSkin.LoadFromStream(Stream)
              else
                if temp = 'Bar' then
                  FBarSkin.LoadFromStream(Stream)
                else
                  if temp = 'Panel' then
                    FPanelSkin.LoadFromStream(Stream)
                  else
                    if temp = 'MiniThrobber' then
                      FMiniThrobberSkin.LoadFromStream(Stream)
                    else
                      if temp = 'Edit' then
                        FEditSkin.LoadFromStream(Stream)
                      else
                        if temp = 'Form' then
                          FFormSkin.LoadFromStream(Stream)
                        else
                          if temp = 'TaskItem' then
                            FTaskItemSkin.LoadFromStream(Stream)
                          else Stream.Position := Stream.Position + size;

      temp := StringLoadFromStream(Stream);
    end;
  except
  end;
  FBarSkin.CheckValid;
  inherited;
end;

procedure TSharpESkin.Clear;
begin
  FButtonSkin.Clear;
  FCheckBoxSkin.Clear;
  FProgressBarSkin.Clear;
  FBarSkin.Clear;
  FPanelSkin.Clear;
  FSkinHeader.Clear;
  FRadioBoxSkin.Clear;
  FMiniThrobberSkin.Clear;
  FEditSkin.Clear;
  FFormSkin.Clear;
  FTaskItemSkin.Clear;
  FSmallText.Clear;
  FMediumText.Clear;
  FBigText.Clear;

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
  if FXml.Root.Items.ItemNamed['button'] <> nil then
    FButtonSkin.LoadFromXML(FXml.Root.Items.ItemNamed['button'], path);
  if FXml.Root.Items.ItemNamed['sharpbar'] <> nil then
    FBarSkin.LoadFromXML(FXml.Root.Items.ItemNamed['sharpbar'], path);
  if FXml.Root.Items.ItemNamed['progressbar'] <> nil then
    FProgressBarSkin.LoadFromXML(FXml.Root.Items.ItemNamed['progressbar'], path);
  if FXml.Root.Items.ItemNamed['checkbox'] <> nil then
    FCheckBoxSkin.LoadFromXML(FXml.Root.Items.ItemNamed['checkbox'], path);
  if FXml.Root.Items.ItemNamed['radiobox'] <> nil then
    FRadioBoxSkin.LoadFromXML(FXml.Root.Items.ItemNamed['radiobox'], path);
  if FXml.Root.Items.ItemNamed['panel'] <> nil then
    FPanelSkin.LoadFromXML(FXml.Root.Items.ItemNamed['panel'], path);
  if FXml.Root.Items.ItemNamed['minithrobber'] <> nil then
    FMiniThrobberSkin.LoadFromXML(FXML.Root.Items.ItemNamed['minithrobber'], path);
  if FXml.Root.Items.ItemNamed['edit'] <> nil then
    FEditSkin.LoadFromXML(FXML.Root.Items.ItemNamed['edit'], path);
  if FXml.Root.Items.ItemNamed['form'] <> nil then
    FFormSkin.LoadFromXML(FXml.Root.Items.ItemNamed['form'], path);
  if FXml.Root.Items.ItemNamed['taskitem'] <> nil then
    FTaskItemSkin.LoadFromXML(FXml.Root.Items.ItemNamed['taskitem'],path);


  FBarSkin.CheckValid;
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
end;

procedure TSharpEMiniThrobberSkin.SaveToStream(Stream: TStream);
begin
  FSkinDim.SaveToStream(Stream);
  FNormal.SaveToStream(Stream);
  FDown.SaveToStream(Stream);
  FHover.SaveToStream(Stream);
end;

procedure TSharpEMiniThrobberSkin.LoadFromStream(Stream: TStream);
begin
  FSkinDim.LoadFromStream(Stream);
  FNormal.LoadFromStream(Stream);
  FDown.LoadFromStream(Stream);
  FHover.LoadFromStream(Stream);
end;

procedure TSharpEMiniThrobberSkin.Clear;
begin
  FNormal.Clear;
  FDown.Clear;
  FHover.Clear;
  FSkinDim.SetLocation('0','0');
  FSkinDim.SetDimension('w', 'h');
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
  FBarBottom := TSkinPart.Create(BmpList);
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
  Clear;
end;

destructor TSharpEBarSkin.Destroy;
begin
  FThNormal.Free;
  FThDown.Free;
  FThBDim.Free;
  FThHover.Free;
  FBar.Free;
  FBarBottom.Free;
  FSkinDim.Free;
  FThDim.Free;
  FFSMod.Free;
  FSBMod.Free;
  FPTXoffset.Free;
  FPTYoffset.Free;
  FPBXoffset.Free;
  FPBYoffset.Free;
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
  FBarBottom.SaveToStream(Stream);
  FFSMod.SaveToStream(Stream);
  FSBMod.SaveToStream(Stream);

  FPTXoffset.SaveToStream(Stream);
  FPTYoffset.SaveToStream(Stream);
  FPBXoffset.SaveToStream(Stream);
  FPBYoffset.SaveToStream(Stream);

  if FEnableVFlip then StringSavetoStream('1', Stream)
     else StringSavetoStream('0', Stream);

  if FSpecialHideForm then StringSaveToStream('1', Stream)
     else StringSaveToStream('0', Stream)
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
  FBarBottom.LoadFromStream(Stream);
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
    FPTYoffset.SetPoint('3', '4');
    FPBXoffset.SetPoint('14', '7');
    FPBYoffset.SetPoint('3', '4');
    FBar.SkinDim.SetDimension('w', 'h');
    FBar.BlendColor := '$WorkAreaBack';
    FBar.Blend := True;
    FBarBottom.SkinDim.SetDimension('w','h');
    FBarBottom.BlendColor := '$WorkAreaBack';
    FBarBottom.Blend := True;
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
  FBarBottom.Clear;
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
      if ItemNamed['barbottom'] <> nil then
        FBarBottom.LoadFromXML(ItemNamed['barbottom'], path, nil);
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
