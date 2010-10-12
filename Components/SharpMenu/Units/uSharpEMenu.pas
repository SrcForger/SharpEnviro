{
Source Name: uSharpEMenu.pas
Description: SharpE Menu Class
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

unit uSharpEMenu;

interface

uses SysUtils, Windows, Forms, Contnrs, Menus, Controls, GR32,Classes,Dialogs,
     SharpApi,
     GR32_Backends,
     SharpGraphicsUtils,
     ISharpESkinComponents,
     uSharpEMenuPopups,
     uSharpEMenuIcon,
     uSharpEMenuIcons,
     uSharpEMenuItem,
     uSharpEMenuActions,
     uSharpEMenuConsts,
     uSharpEMenuSettings,
     uSharpEMenuDynamicContentThread,
     uSharpEMenuRenderThread;

type
  TIntArray = array of integer;
  
  TSharpEMenu = class
  private
    FParentMenuItem : TSharpEMenuItem;
    FSkinManager  : ISharpESkinManager;
    FMenuActions  : TSharpEMenuActions;
    FMenuConsts   : TSharpEMenuConsts;
    FSettings     : TSharpEMenuSettings;
    FItems : TObjectList;
    FBackground : TBitmap32;
    FNormalMenu : TBitmap32;
    FSpecialBackground : TBitmap32;
    FSpecialBackgroundSource : TBitmap32;
    FItemIndex : integer;
    FItemWidth : integer;
    FItemsHeight : TIntArray;
    FMouseDown : boolean;
    FWrapMenu  : boolean;
    FCustomSettings : boolean;
    FDesignMode : boolean;
    FDynamicContentThread : TSharpEMenuDynamicContentThread;
    FOffset : integer;
    FOldWH : TPoint;
    FWrapCount : integer;
    FPosition : TPoint;
    FRedrawBG : boolean;

    procedure UpdateItemWidth;
    procedure UpdateItemsHeight;
    procedure ImageCheck(var pbmp : TBitmap32; pSize : TPoint);
    procedure RenderMenuItem(Dst : TBitmap32; px,py : integer;
                             pitem : TObject; state : TSharpEMenuItemState);
    function GetCurrentItem : TSharpEMenuItem;

  public
    // Create/Destroy
    constructor Create(pParentMenuItem : TSharpEMenuItem; pManager  : ISharpESkinManager; pSettings : TSharpEMenuSettings; pDynamicContentThread : TSharpEMenuDynamicContentThread = nil); reintroduce; overload;
    constructor Create(pManager  : ISharpESkinManager; pSettings : TSharpEMenuSettings; pDynamicContentThread : TSharpEMenuDynamicContentThread = nil); reintroduce; overload;

    destructor Destroy; override;

    // Add Menu Items
    function AddSeparatorItem(pDynamic : boolean; pInsertPos: Integer=-1): TObject;
    function AddLabelItem(pCaption : String; pDynamic : boolean; pInsertPos: Integer=-1): TObject;
    function AddLinkItem(pCaption,pTarget,pIcon : String; pDynamic : boolean; pInsertPos: Integer=-1) : TObject; overload;
    function AddLinkItem(pCaption,pTarget,pIconName : String; pIcon : TBitmap32; pDynamic : boolean; pInsertPos: Integer=-1) : TObject; overload;
    function AddDynamicDirectoryItem(pTarget : String; pMax,pSort : integer; pFilter : String; pRecursive : Boolean; pDynamic : boolean; pInsertPos: Integer=-1) : TObject;
    function AddDriveListItem(pDriveNames:  boolean; pDynamic : boolean; pInsertPos: Integer=-1) : TObject;
    function AddControlPanelItem(pDynamic : boolean; pInsertPos: Integer=-1): TObject;
    function AddSubMenuItem(pCaption,pIcon,pTarget : String; pDynamic : boolean; pInsertPos: Integer=-1) : TObject; overload;
    function AddCustomItem(pCaption,pIconName : String; pIcon : TBitmap32; pType :TSharpEMenuItemType = mtCustom; pInsertPos: Integer=-1) : TObject;
    function AddObjectListItem(pDynamic : boolean; pInsertPos: Integer=-1) : TObject;
    function AddObjectItem(pFile : String; pDynamic : boolean; pInsertPos: Integer=-1): TObject;
    function AddUListItem(pType,pCount : integer; pDynamic : boolean; pInsertPos: Integer=-1) : TObject;

    // Rendering
    procedure RenderBackground(pLeft, pTop : integer; isRunThreaded : boolean = False; BGBmp : TBitmap32 = nil);
    procedure RenderNormalMenu;
    procedure RenderTo(Dst : TBitmap32); overload;
    procedure RenderTo(Dst : TBitmap32; pLeft,pTop : integer); overload;
    procedure RenderTo(Dst : TBitmap32; pLeft,pTop : integer; BGBmp : TBitmap32); overload;    
    procedure RecycleBitmaps;

    // Item Control
    function GetItemsHeight(pstart, pmax: integer; sizeRestrict: boolean = true) : integer;
    function NextVisibleIndex : integer;
    function PreviousVisibleIndex : integer;
    function NextNotVisibleIndex : integer;
    function PreviousNotVisibleIndex : integer;
    procedure SelectItemByMenu(pSubMenu : TSharpEMenu);
    function GetItemUndercursor(px, py: integer): TSharpEMenuItem;

    // Perform Actions
    function PerformMouseMove(px,py : integer; var submenu : boolean) : boolean;
    function PerformMouseDown(Wnd : TObject; Button: TMouseButton; X,Y : integer) : boolean;
    function PerformMouseUp(Wnd : TObject; Button: TMouseButton; Shift: TShiftState; X,Y : integer) : boolean;
    function PerformClick(Wnd : TObject) : boolean;

    // Refresh Content
    procedure RefreshDynamicContent;
    procedure InitializeDynamicSubMenus;

    // Wrap
    procedure WrapMenu(pMaxItems : integer);
    procedure UnWrapMenu(target : TSharpEMenu);

    function GetStartIndex: integer;
    function GetStartIndexHeight: integer;
    function GetMaxHeight: integer;

    procedure UpdateOffset(val: integer);

    procedure SetPosition(pos: TPoint);

    property ItemIndex  : integer read FItemIndex write FItemIndex;
    property CurrentItem : TSharpEMenuItem read GetCurrentItem;
    property Background : TBitmap32 read FBackground;
    property NormalMenu : TBitmap32 read FNormalMenu;
    property SpecialBackgroundSource : TBitmap32 read FSpecialBackgroundSource;
    property SkinManager : ISharpESkinManager read FSkinManager;
    property Items : TObjectList read FItems;
    property ItemsHeight : TIntArray read FItemsHeight;
    property isWrapMenu : boolean read FWrapMenu write FWrapMenu;
    property Settings : TSharpeMenuSettings read FSettings;
    property ParentMenuItem : TSharpEMenuItem read FParentMenuItem;
    property CustomSettings : boolean read FCustomSettings write FCustomSettings;
    property DesignMode : boolean read FDesignMode write FDesignMode;
    property DynamicContentThread : TSharpEMenuDynamicContentThread read FDynamicContentThread write FDynamicContentThread;
    property Offset : integer read FOffset write UpdateOffset;
    property StartIndex : integer read GetStartIndex;
    property WrapCount : integer read FWrapCount;
    property Position : TPoint read FPosition write SetPosition;

  end;

var
  SharpEMenuIcons : TSharpEMenuIcons;
  SharpEMenuPopups : TSharpEMenuPopups;

implementation

uses Math,
     JclFileUtils,
     uSharpEMenuWnd,
     SharpThemeApiEx,
     uISharpETheme;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;     

constructor TSharpEMenu.Create(pParentMenuItem : TSharpEMenuItem; pManager  : ISharpESkinManager; pSettings : TSharpEMenuSettings; pDynamicContentThread : TSharpEMenuDynamicContentThread);
begin
  inherited Create;

  FDynamicContentThread := pDynamicContentThread;
  FCustomSettings := False;
  FDesignMode := False;
  FParentMenuItem  := pParentMenuItem;
  FMenuActions := TSharpEMenuActions.Create(self);
  FMenuConsts  := TSharpEMenuConsts.Create;
  FSettings    := TSharpEMenuSettings.Create;
  FSettings.Assign(pSettings);

  FSkinManager := pManager;
  FMouseDown := False;
  FItemIndex := -1;
  FOffset := 0;
  FOldWH := Point(-1, -1);
  FPosition := Point(-1, -1);
  FRedrawBG := True;

  FItems := TObjectList.Create(True);

  FWrapMenu := False;

  if SharpEMenuIcons = nil then
  begin
    SharpEMenuIcons := TSharpEMenuIcons.Create;
    SharpEMenuIcons.LoadGenericIcons;
  end;

  if SharpEMenuPopups = nil then
     SharpEMenuPopups := TSharpEMenuPopups.Create;

  FWrapCount := Settings.WrapCount;
  if Settings.WrapMenu then
    FWrapCount := FWrapCount + 2;
end;

destructor TSharpEMenu.Destroy;
begin
  FreeAndNil(FItems);

  FreeAndNil(FMenuActions);
  FreeAndNil(FMenuConsts);
  FreeAndNil(FSettings);
  FreeAndNil(FBackground);
  FreeAndNil(FNormalMenu);
  FreeAndNil(FSpecialBackground);
  FreeAndNil(FSpecialBackgroundSource);

  if FParentMenuItem = nil then
  begin
    FreeAndNil(SharpEMenuIcons);
    FreeAndNil(SharpEMenuPopups);
  end;

  FSkinManager := nil;

  inherited Destroy;
end;

procedure TSharpEMenu.UpdateOffset(val: Integer);
var
  w, h : integer;
begin
  if val < 0 then
    exit;

  FOffset := val;

  w := FItemWidth;
  h := Max(1,GetItemsHeight(StartIndex, FWrapCount));

  if (FOldWH.X <> w) or (FOldWH.Y <> h) then
  begin
    FOldWH := Point(w, h);

    RenderBackground(FPosition.X, FPosition.Y);
  end;
  RenderNormalMenu;
end;

function TSharpEMenu.GetStartIndex: integer;
var
  n : integer;
  size, idx : integer;
begin
  size := 0;
  idx := 0;

  for n := 0 to High(FItemsHeight) do
  begin
    size := size + FItemsHeight[n];
    if size >= FOffset then
      break;

    idx := idx + 1;
  end;
  result := idx;
end;

function TSharpEMenu.GetStartIndexHeight: integer;
var
  n : integer;
  size : integer;
begin
  size := 0;

  for n := 0 to High(FItemsHeight) do
  begin
    if size + FItemsHeight[n] >= FOffset then
      break;

    size := size + FItemsHeight[n];
  end;
  result := size;
end;

function TSharpEMenu.GetMaxHeight: integer;
var
  n : integer;
  size : integer;
begin
  size := 0;

  for n := 0 to High(FItemsHeight) - FWrapCount do
    size := size + FItemsHeight[n];

  result := size;
end;

procedure TSharpEMenu.SetPosition(pos: TPoint);
begin
  if (FPosition.X <> pos.X) and (FPosition.Y <> pos.Y) then
    FRedrawBG := True;

  FPosition := pos;
end;

procedure TSharpEMenu.RecycleBitmaps;
begin
  FreeAndNil(FBackground);
  FreeAndNil(FNormalMenu);
  if FSpecialBackground <> nil then
    FreeAndNil(FSpecialBackground);
  if FSpecialBackgroundSource <> nil then
    FreeAndNil(FSpecialBackgroundSource);
end;

function DynSort(Item1 : Pointer; Item2 : Pointer) : integer;
var
 I1,I2 : TSharpEMenuItem;
 d1,d2 : string;
begin
  I1 := TSharpEMenuItem(Item1);
  I2 := TSharpEMenuItem(Item2);
  if (I1.isDynamic) and (not I2.isDynamic) then
     result := 1
     else if (not I1.isDynamic) and (I2.isDynamic) then
     result := -1
     else if ((I1.PropList.GetBool('NoSort')) or (I2.PropList.GetBool('NoSort'))) then
     result := I1.ListIndex - I2.ListIndex
     else if (I1.isDynamic) and (I2.isDynamic) and (I1.ItemType = mtSubMenu) and (I2.ItemType <> I1.ItemType) then
     result := -1 - 2*Min(0,I1.PropList.GetInt('Sort'))
     else if (I1.isDynamic) and (I2.isDynamic) and (I2.ItemType = mtSubMenu) and (I2.ItemType <> I1.ItemType) then
     result := 1 + 2*Min(0,I1.PropList.GetInt('Sort'))
     else if (I1.isDynamic) and (I2.isDynamic) and (I1.ItemType = I2.ItemType) then
     begin
       if (I1.PropList.GetInt('Sort') > 1) and (I2.PropList.GetInt('Sort') > 1) then
       begin
         d1 := I1.PropList.GetString('SortData');
         d2 := I2.PropList.GetString('SortData');
         result := CompareText(d2,d1);
       end else result := CompareText(I1.Caption,I2.Caption);
     end
     else result := I1.ListIndex - I2.ListIndex;
end;

procedure TSharpEMenu.InitializeDynamicSubMenus;
var
  FSubList : TObjectList;
  item : TSharpEMenuItem;
  n : integer;
begin
  FSubList := TObjectList.Create;
  FSubList.OwnsObjects := False;

  // Build a list of all items with sub menus
  for n := 0 to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    if (item.SubMenu <> nil) and (not item.isDynamicSubMenuInitialized) then
      FSubList.Add(item.SubMenu);
  end;

  if Assigned(FDynamicContentThread) then
  begin
    FDynamicContentThread.AddItem(FSubList);
    FDynamicContentThread.Resume;
  end;

end;

procedure TSharpEMenu.RefreshDynamicContent;

  procedure AddDynamicItems(var list : TObjectList; pMenu : TSharpEMenu);
  var
    i : integer;
    item : TSharpEMenuItem;
  begin
    for i := 0 to pMenu.Items.Count - 1 do
    begin
      item := TSharpEMenuItem(pMenu.Items[i]);

      // include wrapped sub menus
//      if (item.isDynamic) and (item.isWrapMenu) and (item.SubMenu <> nil) then
  //      AddDynamicItems(list,TSharpEMenu(item.SubMenu))
    //  else if (item.isDynamic) and (not item.isWrapMenu) then
      //  list.Add(item);
      if (item.isDynamic) then
        list.add(pMenu.Items[i]);
    end;
  end;

var
  FDynList : TObjectList;
  item : TSharpEMenuItem;
  n : integer;
begin
  if FWrapMenu then exit;

  FDynList := TObjectList.Create;
  FDynList.OwnsObjects := False;

  // Build a list of all dynamic items
  AddDynamicItems(FDynList,self);

  // Find all items which are creating dynamic items
  for n := 0 to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    case item.ItemType of
      mtDynamicDir : FMenuActions.UpdateDynamicDirectory(FDynList,
                                                         item.PropList.GetString('Action'),
                                                         item.PropList.GetString('Filter'),
                                                         item.PropList.GetInt('Sort'),
                                                         item.PropList.GetInt('MaxItems'),
                                                         item.PropList.GetBool('Recursive'));
      mtDriveList : FMenuActions.UpdateDynamicDriveList(FDynList,item.PropList.GetBool('ShowDriveNames'));
      mtCPLList : FMenuActions.UpdateControlPanelList(FDynList);
      mtDesktopObjectList : FMenuActions.UpdateObjectList(FDynList);
      mtulist : FMenuActions.UpdateUList(FDynList,item.PropList.GetInt('Type'),item.PropList.GetInt('Count'));
    end;
  end;

  // Check which items are left in FDynList and remove them
  for n := FDynList.Count - 1 downto 0 do
  begin
    item := TSharpEMenuItem(FDynList.Items[n]);
    FItems.Remove(item);
  end;

  for n := 0 to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    item.ListIndex := n;
  end;

  FItems.Sort(DynSort);

  FDynList.Free;

  if FSettings.WrapMenu then
    WrapMenu(Max(5, FSettings.WrapCount));
end;

function TSharpEMenu.AddLabelItem(pCaption : String; pDynamic : boolean; pInsertPos: Integer=-1): TObject;
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(self,mtLabel);
  item.isDynamic := False;
  item.Icon := nil;
  item.Caption := pCaption;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddSeparatorItem(pDynamic : boolean; pInsertPos: Integer=-1): TObject;
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(self,mtSeparator);
  item.isDynamic := pDynamic;
  item.icon := nil;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddCustomItem(pCaption,pIconName : String; pIcon : TBitmap32; pType :TSharpEMenuItemType = mtCustom; pInsertPos: Integer=-1) : TObject;
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(self,pType);
  if FSettings.UseIcons then
    item.Icon := SharpEMenuIcons.AddIcon(pIconName,pIcon,itCustomIcon)
  else item.Icon := nil;
  item.Caption := pCaption;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddLinkItem(pCaption,pTarget,pIconName : String; pIcon : TBitmap32; pDynamic : boolean; pInsertPos: Integer=-1) : TObject;
var
  item : TSharpEMenuItem;
begin
  if not FDesignMode then  
    pTarget := FMenuConsts.ParseString(pTarget);
  item := TSharpEMenuItem.Create(self,mtLink);
  if FSettings.UseIcons then
    item.Icon := SharpEMenuIcons.AddIcon(pIconName,pIcon,itDefaultIcon)
  else item.Icon := nil;
  item.Caption := pCaption;
  item.PropList.Add('Action',pTarget);
  item.OnClick := FMenuActions.OnLinkClick;
  if pDynamic and FileExists(pTarget) then
     item.Popup := SharpEMenuPopups.DynamicLinkPopup;
  item.isDynamic := pDynamic;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddObjectItem(pFile: String; pDynamic: boolean; pInsertPos: Integer=-1): TObject;
var
  item : TSharpEMenuItem;
  s : String;
begin
  item := TSharpEMenuItem.Create(self,mtDesktopObject);
  item.PropList.Add('ObjectFile',pFile);
  s := ExtractFileName(pFile);
  setlength(s,length(s) - length(ExtractFileExt(s)));
  item.Caption := s;
  item.OnClick := FMenuActions.OnDesktopObjectClick;
  if FSettings.UseIcons then
    item.Icon := SharpEMenuIcons.AddIcon('icon.file.picture','icon.file.picture',itCustomIcon)
  else item.Icon := nil;
  item.isVisible := True;
  item.isDynamic := pDynamic;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddObjectListItem(pDynamic: boolean; pInsertPos: Integer=-1): TObject;
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(self,mtDesktopObjectList);
  item.Icon := nil;
  item.isVisible := False;
  item.isDynamic := pDynamic;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddLinkItem(pCaption,pTarget,pIcon : String; pDynamic : boolean; pInsertPos: Integer=-1) : TObject;
var
  item : TSharpEMenuItem;
  etarget : String;
begin
  item := TSharpEMenuItem.Create(self,mtLink);
  item.PropList.Add('IconSource',pIcon);
  etarget := FMenuConsts.ParseString(pTarget);
  pIcon   := FMenuConsts.ParseString(pIcon);
  if not FDesignMode then
    pTarget := etarget;
  if FSettings.UseIcons then
  begin
    if (FSettings.UseGenericIcons) and (CompareText(pIcon,'shell:icon') = 0) then
      item.Icon := SharpEMenuIcons.AddIcon(FMenuConsts.GetGenericIcon(eTarget),eTarget,itGeneric)
    else
      item.Icon := SharpEMenuIcons.AddIcon(pIcon,eTarget,itDefaultIcon);
  end else
    item.Icon := nil;

  item.Caption := pCaption;

  item.PropList.Add('Action',pTarget);
  item.OnClick := FMenuActions.OnLinkClick;
  if pDynamic and (length(pTarget) > 3) then
     if FileExists(pTarget) then
        item.Popup := SharpEMenuPopups.DynamicLinkPopup;
  item.isDynamic := pDynamic;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddSubMenuItem(pCaption,pIcon,pTarget : String; pDynamic : boolean; pInsertPos: Integer=-1) : TObject;
var
  item : TSharpEMenuItem;
  etarget : String;
begin
  item := TSharpEMenuItem.Create(self,mtSubMenu);
  item.PropList.Add('IconSource',pIcon);
  pIcon   := FMenuConsts.ParseString(pIcon);
  etarget := FMenuConsts.ParseString(pTarget);
  if not FDesignMode then
    pTarget := etarget;
  if FSettings.UseIcons then
  begin
    if (FSettings.UseGenericIcons) and (CompareText(pIcon,'shell:icon') = 0) then
      item.Icon := SharpEMenuIcons.AddIcon(FMenuConsts.GetGenericIcon(eTarget),eTarget,itGeneric)
    else
      item.Icon := SharpEMenuIcons.AddIcon(pIcon,eTarget,itDefaultIcon);
  end else
    item.Icon := nil;

  item.Caption := pCaption;
  item.isDynamic := pDynamic;
  if length(trim(pTarget))>0 then
  begin
    item.PropList.Add('Target',pTarget);
    item.OnClick := FMenuActions.OnFolderClick;
    if pDynamic then
       item.popup := SharpEMenuPopups.DynamicDirPopup;
  end;
  result := Item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddUListItem(pType,pCount: integer; pDynamic: boolean;
  pInsertPos: Integer): TObject;
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(self,mtulist);
  item.Icon := nil;
  item.isVisible := False;
  item.isDynamic := pDynamic;
  item.PropList.Add('type',pType);
  item.PropList.Add('count',pCount);
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

constructor TSharpEMenu.Create(pManager: ISharpESkinManager; pSettings: TSharpEMenuSettings; pDynamicContentThread: TSharpEMenuDynamicContentThread);
begin
  Create(nil, pManager, pSettings, pDynamicContentThread);
end;

function TSharpEMenu.AddDynamicDirectoryItem(pTarget : String; pMax,pSort : integer; pFilter : String; pRecursive : Boolean; pDynamic : boolean; pInsertPos: Integer=-1): TObject;
var
  item : TSharpEMenuItem;
begin
  if not FDesignMode then
    pTarget := FMenuConsts.ParseString(pTarget);

  item := TSharpEMenuItem.Create(self,mtDynamicDir);
  item.Icon := nil;
  item.PropList.Add('Action',pTarget);
  item.PropList.Add('MaxItems',pMax);
  item.PropList.Add('Sort',pSort);
  item.PropList.Add('Filter',pFilter);
  item.PropList.Add('Recursive',pRecursive);
  item.isVisible := False;
  item.isDynamic := pDynamic;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddDriveListItem(pDriveNames: Boolean; pDynamic : boolean; pInsertPos: Integer=-1): TObject;
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(self,mtDriveList);
  item.Icon := nil;
  item.isVisible := False;
  item.PropList.Add('ShowDriveNames',pDriveNames);
  item.isDynamic := pDynamic;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

function TSharpEMenu.AddControlPanelItem(pDynamic : boolean; pInsertPos: Integer=-1): TObject;
var
  item : TSharpEMenuItem;
begin
  item := TSharpEMenuItem.Create(self,mtCPLList);
  item.Icon := nil;
  item.isVisible := False;
  item.isDynamic := pDynamic;
  result := item;

  if pInsertPos = -1 then
  FItems.Add(item) else
  FItems.Insert(pInsertPos,item);
end;

// Calculate overall items size until pindex (-1 = all)
function TSharpEMenu.GetItemsHeight(pstart, pmax: integer; sizeRestrict: boolean) : integer;
var
  n : integer;
  size : integer;
begin
  size := 0;

  if (pmax < 0) then
    pmax := pstart + FWrapCount;
  if (pmax > High(FItemsHeight)) then
     pmax := High(FItemsHeight);

  for n := pstart to pmax + pstart do
  begin
    if n >= Length(FItemsHeight) then
      break;

    size := size + FItemsHeight[n];
  end;

  result := size;
end;

function TSharpEMenu.GetItemUndercursor(px, py: integer): TSharpEMenuItem;
var
  menuskin : ISharpEMenuSkin;
  item : TSharpEMenuItem;
  tl : TPoint;
  n : integer;
begin
  menuskin := FSkinManager.Skin.Menu;
  tl.x := menuskin.LROffset.X;
  tl.y := menuskin.TBOffset.X;

  for n := StartIndex to StartIndex + FWrapCount do
  begin
    if n >= FItems.Count then
      break;

    item := TSharpEMenuItem(FItems.Items[n]);
    if (PointInRect(Point(px,py),Rect(0,tl.y,tl.y + tl.x+FItemWidth,tl.y + FItemsHeight[n]))
        and (item.isVisible)) then
    begin
      result := item;
      exit;
    end;
    tl.y := tl.y + FItemsHeight[n];
  end;
  result := nil;
end;

// Calculate the height of the menu and store the result as array in FItemsHeight
procedure TSharpEMenu.UpdateItemsHeight;
var
  n,i : integer;
  menuitemskin : ISharpEMenuItemSkin;
  item : TSharpEMenuItem;
begin
  if (FSkinManager = nil) or (FItems.Count = 0) then
  begin
    setlength(FItemsHeight,0);
    exit;
  end;

  menuitemskin := FSkinManager.Skin.MenuItem;
  setlength(FItemsHeight,0);
  for n:= 0 to FItems.Count -1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    setlength(FItemsHeight,length(FItemsHeight) + 1);
    if item.isVisible then
    begin
      case item.ItemType of
        mtLabel    : i := menuitemskin.LabelItem.Dimension.Y;
        mtSeparator: i := menuitemskin.Separator.Dimension.Y;
        mtSubMenu  : i := menuitemskin.NormalSubItem.Dimension.Y;
        else         i := menuitemskin.NormalItem.Dimension.Y;
      end;
    end else
      i := 0;
    FItemsHeight[High(FItemsHeight)] := i;
  end;
end;

// Calculate the max item width for all menu items and store result in FItemWidth
procedure TSharpEMenu.UpdateItemWidth;
var
  n,i : integer;
  item : TSharpEMenuItem;
  size : integer;
  maxitemtext : integer;
  maxsize : integer;
  temp : TBitmap32;
  menuskin : ISharpEMenuSkin;
  menuitemskin : ISharpEMenuItemSkin;
  SkinText : ISharpESkinText;
begin
  size := 255;

  if FSkinManager = nil then
  begin
    FItemWidth := size;
    exit;
  end;
  
  menuitemskin := FSkinManager.Skin.MenuItem;
  menuskin := FSkinManager.Skin.Menu;
  SkinText := menuitemskin.NormalItem.CreateThemedSkinText;
  temp := TBitmap32.Create;
  try
    SkinText.AssignFontTo(temp.font,FSkinManager.Scheme);
    size := menuskin.WidthLimit.X;
    maxsize := menuskin.WidthLimit.Y;
    maxitemtext := SkinText.GetDim(Rect(0,0,maxsize,64)).X;
    for n:= 0 to FItems.Count -1 do
    begin
      item := TSharpEMenuItem(FItems.Items[n]);
      if item.isVisible then
      begin
        i := Min(maxitemtext,temp.TextWidth(item.Caption)) + menuitemskin.NormalItem.WidthMod;
        if (i>size) then
           size := i;
        if (size > maxsize) then
        begin
          size := maxsize;
          break;
        end;
      end;
    end;
  finally
    temp.free;
  end;
  SkinText := nil;
  FItemWidth := size;
end;

// Check if a Bmp is nil... if nil then create a new Bitmap and initialize it with pSize
procedure TSharpEMenu.ImageCheck(var pbmp : TBitmap32; pSize : TPoint);
begin
  if (pbmp <> nil) then exit;
  pbmp := TBitmap32.Create;
  pbmp.DrawMode := dmBlend;
  pbmp.CombineMode := cmMerge;
  pbmp.SetSize(Max(pSize.x,1),Max(pSize.y,1));
  pbmp.Clear(color32(0,0,0,0));
end;

function TSharpEMenu.GetCurrentItem : TSharpEMenuItem;
begin
  if (FItemIndex > -1) and (FItemIndex < FItems.Count) then
  begin
    result := TSharpEMenuItem(FItems.Items[FItemIndex]);
  end else result := nil;
end;

// Unwrap the window and move all wrapped items back
procedure TSharpEMenu.UnWrapMenu(target : TSharpEMenu);
var
  item : TSharpeMenuItem;
  n : integer;
begin
  if FWrapMenu then
  begin
    // Transfer the menu items to target menu
    for n := 0 to FItems.Count - 1 do
    begin
      item := TSharpEMenuItem(FItems[n]);
      if not item.isWrapMenu then
         target.Items.Add(FItems[n])
    end;
    // remove the transfered items
    for n := FItems.Count - 1 downto 0 do
    begin
      item := TSharpEMenuItem(FItems[n]);
      if not item.isWrapMenu then
         FItems.Extract(FItems[n]);
    end;
  end;

  // find all WrapMenu items and copy their sub menus
  for n := 0 to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems[n]);
    if item.isWrapMenu then
       TSharpEMenu(item.SubMenu).UnWrapMenu(target);
  end;

  // remove everything what remained
  if FWrapMenu then
  begin
    FWrapMenu := False;
    FItems.Clear;
  end;
end;

// Check if the menu is too big and maybe wrap it
procedure TSharpEMenu.WrapMenu(pMaxItems : integer);
var
  n,i : integer;
  c,size : integer;
  item,submenuitem : TSharpEMenuItem;
begin
  UpdateItemsHeight;

  if pMaxItems < 0 then
     pMaxItems := FItems.Count;

  c := 0;
  size := 0;
  for n := 0 to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems[n]);
    size := size + FItemsHeight[n];
    if item.isVisible then
       c := c + 1;

    if ((c >= pMaxItems) or (size > GetItemsHeight(0, FWrapCount, false)))
       and (n < FItems.Count - 1) then
    begin
      item := TSharpEMenuItem.Create(self,mtSeparator);
      item.Icon := nil;
      item.isDynamic := True;

      submenuitem := TSharpEMenuItem.Create(self,mtSubMenu);
      if FSettings.UseIcons then
      begin
        if FSettings.UseGenericIcons then
          submenuitem.Icon := SharpEMenuIcons.FindIcon('generic.folder','generic.folder')
        else submenuitem.Icon := SharpEMenuIcons.AddIcon('icon.folder','icon.folder',itCustomIcon);
      end else submenuitem.Icon := nil;
      submenuitem.Caption := 'Next Page...';
      submenuitem.isDynamic := True;
      submenuitem.isWrapMenu := True;
      submenuitem.SubMenu := TSharpEMenu.Create(submenuitem,FSkinManager,FSettings,FDynamicContentThread);
      TSharpeMenu(submenuitem.SubMenu).isWrapMenu := True;

      if FSettings.WrapPosition = 0 then
      begin
        FItems.Insert(n,item);
        FItems.Insert(n+1,submenuitem);
      end else
      begin
        FItems.Insert(0,submenuitem);
        FItems.Insert(1,item);
      end;

      for i := Min(FItems.Count - 1,n + 2) to FItems.Count - 1 do
      begin
        item := TSharpEMenuItem(FItems[i]);
        if item.isVisible then
           TSharpeMenu(submenuitem.SubMenu).Items.Add(FItems[i]);
      end;
      for i := FItems.Count - 1 downto Min(FItems.Count - 1,n + 2) do
      begin
        item := TSharpEMenuItem(FItems[i]);
        if item.isVisible then
           FItems.Extract(FItems[i]);
      end;
      TSharpeMenu(submenuitem.SubMenu).WrapMenu(pMaxItems);
      exit;
    end;
  end;

end;

procedure TSharpEMenu.RenderBackground(pLeft,pTop : integer; isRunThreaded : boolean = False; BGBmp : TBitmap32 = nil);
const
  CAPTUREBLT = $40000000;
var
  w,h : integer;
  menuskin : ISharpEMenuSkin;
  dc : hdc;
  Theme : ISharpETheme;
begin
  ImageCheck(FBackground,Point(255,32));
  if FSkinManager = nil then exit;

  if not isRunThreaded then // Do not run this when executed threaded
  begin
    UpdateItemWidth;
    UpdateItemsHeight;
  end;

  menuskin := FSkinManager.Skin.Menu;

  if (FOldWH.X = -1) or (FOldWH.Y = -1) then
    FOldWH := Point(FItemWidth, Max(1,GetItemsHeight(StartIndex, FWrapCount)));

  w := FOldWH.X;
  h := FOldWH.Y;

  // add Left/Right and Top/Bottom offsets to menu size;
  w := w + menuskin.LROffset.X + menuskin.LROffset.Y;
  h := h + menuskin.TBOffset.X + menuskin.TBOffset.Y;

  // fail safe check
  if (w<=0) or (h<=0) then
    exit;

  FBackground.SetSize(w,h);
  FBackground.Clear(color32(0,0,0,0));

  if FSkinManager.Skin.Bar.GlassEffect then
  begin
    ImageCheck(FSpecialBackground,Point(w,h));

    FSpecialBackground.SetSize(w,h);
    FSpecialBackground.Clear(color32(0,0,0,0));

    dc := GetWindowDC(GetDesktopWindow);
    try
      Theme := GetCurrentTheme;    
      if BGBmp <> nil then
        BGBmp.DrawTo(FSpecialBackground,0,0)
      else
      begin
        if (FSpecialBackgroundSource = nil) or (FRedrawBG) then
        begin
          ImageCheck(FSpecialBackgroundSource,Point(w,h));
          FSpecialBackgroundSource.SetSize(w,h);
          FSpecialBackgroundSource.Clear(color32(0,0,0,0));

          BitBlt(FSpecialBackgroundSource.Canvas.Handle,
                  0,
                  0,
                  FSpecialBackgroundSource.Width,
                  FSpecialBackgroundSource.Height,
                  dc,
                  pLeft,
                  pTop,
                  SRCCOPY or CAPTUREBLT);
               
            FSpecialBackgroundSource.ResetAlpha;

            FRedrawBG := False;
        end;
        
        FSpecialBackground.Assign(FSpecialBackgroundSource);
      end;
    finally
      ReleaseDC(GetDesktopWindow, dc);
    end;
      
      if Theme.Skin.GlassEffect.Blend then
        BlendImageC(FSpecialBackground,Theme.Skin.GlassEffect.BlendColor,Theme.Skin.GlassEffect.BlendAlpha);
      fastblur(FSpecialBackground,Theme.Skin.GlassEffect.BlurRadius,Theme.Skin.GlassEffect.BlurIterations);
      if Theme.Skin.GlassEffect.Lighten then
         lightenBitmap(FSpecialBackground,Theme.Skin.GlassEffect.LightenAmount);
      FSpecialBackground.ResetAlpha(255);

      FBackground.SetSize(w,h);
      FBackground.Clear(color32(0,0,0,0));
      menuskin.Background.DrawTo(FBackground,FSkinManager.Scheme);
      ReplaceTransparentAreas(FSpecialBackground,FBackground,Color32(0,0,0,0));
  end else
  begin
    menuskin.Background.drawto(FBackground,FSkinManager.Scheme);
    if FSpecialBackground <> nil then
      FreeAndNil(FSpecialBackground);
  end;
end;

function FixCaption(bmp : TBitmap32; Caption : WideString; MaxWidth : integer) : WideString;
var
  n : integer;
  count : integer;
  s : WideString;
begin
  if bmp.TextWidthW(Caption) <= MaxWidth then result := Caption
  else
  begin
    count := length(Caption);
    s := '';
    n := 0;
    repeat
      n := n + 1;
      s := s + Caption[n];
    until (bmp.TextWidthW(s) > MaxWidth) or (n >= count);
    if length(s)>=4 then
    begin
      setlength(s,length(s)-4);
      s := s + '...';
    end else s := '';
    result := s;
  end;
end;

procedure TSharpEMenu.RenderMenuItem(Dst : TBitmap32; px,py : integer;
                             pitem : TObject; state : TSharpEMenuItemState);
var
  temp : TBitmap32;
  iconbmp : TBitmap32;
  text : TBitmap32;
  item : TSharpEMenuItem;
  Ipos : TPoint;
  IWidth,IHeight : integer;  
  DIcon : boolean;
  Tpos : TPoint;
  DText : boolean;
  drawpart : ISharpESkinPart;
  drawpartEx : ISharpESkinPartEx;
  menuitemskin : ISharpEMenuItemSkin;
  w,h : integer;
  ST : ISharpESkinText;
  textrect,iconrect : TRect;
  fixedCaption : String;
  DPIMod : integer;
  TextMod : integer;

procedure AssignDrawPart(part : ISharpESkinPartEx); overload;
begin
  drawpart := nil;
  drawpartEx := part;
end;

procedure AssignDrawPart(part : ISharpESkinPart); overload;
begin
  drawpartEx := nil;
  drawpart := part;
end;

begin
  if FSkinManager = nil then exit;
  if Dst = nil then exit;

  item := TSharpEMenuItem(pItem);

  if assigned(item.OnPaint) then
  begin
    item.OnPaint(Dst,px,py,item,state);
    exit;
  end;

  menuitemskin := FSkinManager.Skin.MenuItem;
  w := FItemWidth;

  temp := TBitmap32.Create;
  iconbmp := TBitmap32.Create;
  text := TBitmap32.Create;
  temp.DrawMode := dmBlend;
  iconbmp.DrawMode := dmBlend;
  text.DrawMode := dmBlend;
  temp.CombineMode := cmMerge;
  iconbmp.CombineMode := cmMerge;
  text.CombineMode := cmMerge;
  try
    h := 8;
    case item.ItemType of
      mtLabel     : AssignDrawPart(menuitemskin.LabelItem);
      mtSeparator : AssignDrawPart(menuitemskin.Separator);
      mtSubMenu   : begin
                      case state of
                        msHover,msDown : AssignDrawPart(menuitemskin.HoverSubItem);
                        else             AssignDrawPart(menuitemskin.NormalSubItem);
                      end;
                    end;
      else          begin
                      case state of
                        msHover : AssignDrawPart(menuitemskin.HoverItem);
                        msDown  : AssignDrawPart(menuitemskin.DownItem);
                        else      AssignDrawPart(menuitemskin.NormalItem);
                      end;
                    end;
    end;
    iconbmp.Clear(color32(0,0,0,0));
    text.Clear(color32(0,0,0,0));
    dicon := False;
    dtext := False;
    TextMod := 0;
    textrect := Rect(0,0,0,0);
    if drawpartEx <> nil then
    with drawpartEx do
    begin
      ST := CreateThemedSkinText;
      h := Dimension.Y;
      if (item.Icon <> nil) and (Icon.DrawIcon) and (FSettings.UseIcons) then
        iconrect := Rect(0,0,Icon.Dimension.X,Icon.Dimension.Y)
      else iconrect := Rect(0,0,0,0);
      if (length(item.Caption)>0) and (DrawText) and
        (w>0) and (h>0) then
      begin
        text.SetSize(w,h);
        text.clear(color32(0,0,0,0));
        ST.AssignFontTo(text.Font,FSkinManager.Scheme);
        FixedCaption := FixCaption(text,item.Caption,w-32);
        DPIMod := round((FSkinManager.DPIScaleFactor - 1) * 6);        
        Tpos := ST.GetXY(Rect(0, 0, text.TextWidth(FixedCaption), text.TextHeight(FixedCaption)),
                         Rect(0, 0, w, h),iconrect);
        TPos.Y := TPos.Y - DPIMod;                         
        ST.RenderTo(text,Tpos.x,Tpos.y,FixedCaption,FSkinManager.Scheme);
        textrect := rect(TPos.X,TPos.Y,TPos.X + text.TextWidth(FixedCaption),TPos.Y + text.TextHeight(FixedCaption));
        dtext := true;
      end;
      IWidth := Icon.Dimension.X;
      IHeight := Icon.Dimension.Y;
      if (item.Icon <> nil) and (Icon.DrawIcon) and (FSettings.UseIcons) then
      begin
        if (IWidth > 0) and (IHeight > 0) then
        begin
          iconbmp.setsize(IWidth,IHeight);
          iconbmp.Clear(color32(0,0,0,0));
          icon.DrawTo(iconbmp,item.Icon.Icon,0,0);
          dicon := true;
          Ipos := Icon.GetXY(textrect,Rect(0,0,w,h));
        end;
      end else TextMod := IWidth;
      ST := nil;
    end
    else if (drawpart <> nil) then
      h := drawpart.Dimension.Y;
    if (w > 0) and (h > 0) then
    begin
      temp.SetSize(w,h);
      temp.Clear(color32(0,0,0,0));
      if drawpartex <> nil then
        drawpartex.DrawTo(temp,FSkinManager.Scheme)
      else if drawpart <> nil then
        drawpart.DrawTo(temp,FSkinManager.Scheme);
      temp.DrawTo(dst,px,py);
      if dicon then
         iconbmp.DrawTo(dst,px+IPos.x,py+IPos.y);
      if dtext then
         text.DrawTo(dst,px - TextMod,py);
    end;
  finally
    FreeAndNil(temp);
    FreeAndNil(iconbmp);
    FreeAndNil(text);
  end;
end;

procedure TSharpEMenu.RenderNormalMenu;
var
  item : TSharpEMenuItem;
  n : integer;
  dh : integer;
begin
  ImageCheck(FNormalMenu,Point(255,32));
  if FSkinManager = nil then exit;

  if (FOldWH.X = -1) or (FOldWH.Y = -1) then
    FOldWH := Point(FItemWidth, Max(1,GetItemsHeight(StartIndex, FWrapCount)));

  FNormalMenu.SetSize(FOldWH.X,FOldWH.Y);
  FNormalMenu.Clear(color32(0,0,0,0));

  dh := -(FOffset - GetStartIndexHeight);
  try
    for n := StartIndex to StartIndex + FWrapCount do
    begin
      if n >= FItems.Count then
        break;

      item := TSharpEMenuItem(FItems.Items[n]);
      if item.isVisible then
         RenderMenuItem(FNormalMenu, 0, dh, item, msNormal);
      dh := dh + FItemsHeight[n];
    end;
  finally
  end;
end;

procedure TSharpEMenu.RenderTo(Dst: TBitmap32);
var
  menuskin : ISharpEMenuSkin;
  temp : TBitmap32;
  n : integer;
  y : integer;
  fr : TPoint;
  backgroundThread : TSharpEMenuRenderThread;
  normalItemsThread : TSharpEMenuRenderThread;
begin
  if (FSkinManager = nil) then exit;

  backgroundThread := nil;
  normalItemsThread := nil;
  if Settings.MultiThreading then
  begin
    if (FBackground = nil) then
    begin
      UpdateItemWidth;
      UpdateItemsHeight;
      backgroundThread := TSharpEMenuRenderThread.Create(self,riBackground);
      backgroundThread.Resume;
    end;
    if (FNormalMenu = nil) then
    begin
      normalItemsThread := TSharpEMenuRenderThread.Create(self,riNormalItems);
      normalItemsThread.Resume;
    end;
  end else
  begin
    if (FBackground = nil) then RenderBackground(FPosition.X,FPosition.Y);
    if (FNormalMenu = nil) then RenderNormalMenu();
  end;

  if backgroundThread <> nil then
  begin
    if not backgroundThread.Suspended then
      backgroundThread.WaitFor();
    backgroundThread.Free;
  end;

  menuskin := FSkinManager.Skin.Menu;

  if (FBackground.Width <= 0) or (FBackground.Height <= 0) then
    exit;

  Dst.SetSize(FBackground.Width,FBackground.Height);
  Dst.Clear(color32(0,0,0,0));
  if FSpecialBackground <> nil then
    FSpecialBackground.DrawTo(Dst);

  FBackground.DrawTo(Dst);

  if normalItemsThread <> nil then
  begin
    if not normalItemsThread.Suspended then
      normalItemsThread.WaitFor();
    normalItemsThread.Free;
  end;
  
  temp := TBitmap32.Create;
  temp.assign(FNormalMenu);
  y := -(FOffset - GetStartIndexHeight);;
  try
    for n := StartIndex to FWrapCount + StartIndex do
    begin
      if n >= FItems.Count then
        break;

      if (n = FItemIndex) and (TSharpEMenuItem(FItems.Items[n]).isVisible) then
      begin
        fr := Point(y, y+FItemsHeight[n]);
        if fr.X < 0 then
          fr.X := 0;
        if fr.Y > FNormalMenu.Height then
          fr.Y := FNormalMenu.Height;
      
        temp.DrawMode := dmOpaque;
        temp.FillRect(0,fr.X,FItemWidth,fr.Y,color32(0,0,0,0));

        if FMouseDown then
          RenderMenuItem(temp,0,y,TSharpEMenuItem(FItems.Items[n]),msDown)
        else
          RenderMenuItem(temp,0,y,TSharpEMenuItem(FItems.Items[n]),msHover);
          
        temp.DrawMode := dmBlend;
        break;
      end;
      y := y + FItemsHeight[n];
    end;
    temp.DrawTo(Dst,menuskin.LROffset.X,menuskin.TBOffset.X);
  finally
    temp.Free;
  end;
end;

procedure TSharpEMenu.RenderTo(Dst: TBitmap32; pLeft, pTop: integer; BGBmp: TBitmap32);
begin
  if (FSkinManager = nil) then exit;
  RenderBackground(pLeft,pTop,False,BGBmp);

  RenderTo(Dst);
end;

procedure TSharpEMenu.SelectItemByMenu(pSubMenu: TSharpEMenu);
var
  n : integer;
  item : TSharpEMenuItem;
begin
  for n := 0 to Min(High(FItemsHeight),FItems.Count-1) do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    if item.SubMenu = pSubMenu then
    begin
      FItemIndex := n;
      exit;
    end;
  end;
end;

procedure TSharpEMenu.RenderTo(Dst : TBitmap32; pLeft,pTop : integer);
begin
  if (FSkinManager = nil) then exit;
    RenderBackground(pLeft,pTop);

  RenderTo(Dst);
end;

function TSharpEMenu.PerformClick(Wnd : TObject) : boolean;
var
  item : TSharpEMenuItem;
  CanClose : boolean;
begin
  if (FItemIndex > -1) and (FItemIndex < FItems.Count)
     and (not SharpEMenuPopups.PopupVisible) then
  begin
    item := TSharpEMenuItem(FItems.Items[FItemIndex]);
    if assigned(item.OnClick) then
    begin
      CanClose := False;
      if not ((item.isDynamic) and (item.ItemType = mtSubMenu)) then
        item.OnClick(item,Wnd,CanClose);
      result := CanClose;
      exit;
    end;
  end;
  result := false;
  SharpEMenuPopups.PopupVisible := False;
end;

function TSharpEMenu.PerformMouseDown(Wnd : TObject; Button: TMouseButton; X,Y : integer) : boolean;
begin
  if (FItemIndex > -1) and (FItemIndex < FItems.Count) then
  begin
    FMouseDown := True;
    result := true;
  end else result := false;
end;

function TSharpEMenu.PerformMouseUp(Wnd : TObject; Button: TMouseButton;
  Shift: TShiftState; X,Y : integer) : boolean;
var
  item : TSharpEMenuItem;
  mwnd : TSharpEMenuWnd;
begin
  if (FItemIndex > -1) and (FItemIndex < FItems.Count)
     and (not SharpEMenuPopups.PopupVisible) then
  begin
    item := TSharpEMenuItem(FItems.Items[FItemIndex]);
    FMouseDown := False;
    if Assigned(item.OnMouseUp) then
    begin
      item.OnMouseUp(item, Button, Shift);
      result := false;
    end else result := true;
    if (button = mbRight) and assigned(item.Popup) then
    begin
      mwnd := TSharpEMenuWnd(wnd);
      if mwnd.SharpESubMenu <> nil then
      begin
        mwnd.SharpESubMenu.SharpEMenu.RecycleBitmaps;
        mwnd.SharpESubMenu.Release;
        mwnd.SharpESubMenu := nil;
      end;
      SharpEMenuPopups.LastMenu := mwnd;
      SharpEMenuPopups.PopupVisible := True;
      TPopupMenu(item.Popup).Popup(X,Y);
    end;
  end else
  begin
    result := false;
    SharpEMenuPopups.PopupVisible := False;
  end;
end;

function TSharpEMenu.PerformMouseMove(px,py : integer; var submenu : boolean) : boolean;
var
  menuskin : ISharpEMenuSkin;
  item : TSharpEMenuItem;
  tl : TPoint;
  n : integer;
begin
  menuskin := FSkinManager.Skin.Menu;

  tl.x := menuskin.LROffset.X;
  tl.y := menuskin.TBOffset.X + -(FOffset - GetStartIndexHeight);;

  for n := StartIndex to FWrapCount + StartIndex do
  begin
    if n >= FItems.Count then
      break;
      
    item := TSharpEMenuItem(FItems.Items[n]);
    if (PointInRect(Point(px,py),Rect(0,tl.y,tl.y + tl.x+FItemWidth,tl.y + FItemsHeight[n]))
        and (item.isVisible)) then
    begin
      result := (FItemIndex <> n);
      FItemIndex := n;

      submenu := (item.ItemType = mtSubMenu);
      exit;
    end;
    tl.y := tl.y + FItemsHeight[n];
  end;
  FItemIndex := -1;
  result := true;
end;

function TSharpEMenu.NextVisibleIndex : integer;
var
  n : integer;
  item : TSharpEMenuItem;
begin
  for n := Max(0,FItemIndex+1) to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    if (item.isVisible)
       and ((@item.OnClick <> nil) or (item.ItemType = mtSubMenu))  then
    begin
      result := n;
      exit;
    end;
  end;
  result := FItemIndex;
end;

function TSharpEMenu.PreviousVisibleIndex : integer;
var
  n : integer;
  item : TSharpEMenuItem;
begin
  for n := Min(FItems.Count - 1,FItemIndex - 1) downto 0 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    if (item.isVisible)
       and ((@item.OnClick <> nil) or (item.ItemType = mtSubMenu))  then
    begin
      result := n;
      exit;
    end;
  end;
  result := FItemIndex;
end;

function TSharpEMenu.NextNotVisibleIndex : integer;
var
  n : integer;
  item : TSharpEMenuItem;
begin
  for n := Max(0,FItemIndex+1) to FItems.Count - 1 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    if (not item.isVisible)  then
    begin
      result := n;
      exit;
    end;
  end;
  result := FItems.Count;
end;

function TSharpEMenu.PreviousNotVisibleIndex : integer;
var
  n : integer;
  item : TSharpEMenuItem;
begin
  for n := Min(FItems.Count - 1,FItemIndex - 1) downto 0 do
  begin
    item := TSharpEMenuItem(FItems.Items[n]);
    if (not item.isVisible) then
    begin
      result := n;
      exit;
    end;
  end;
  result := 0;
end;

end.
