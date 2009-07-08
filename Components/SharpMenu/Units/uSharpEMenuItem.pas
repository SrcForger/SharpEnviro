{
Source Name: uSharpEMenuItem.pas
Description: SharpE Menu Item Class
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

unit uSharpEMenuItem;

interface

uses GR32,SysUtils,Controls,Classes,uSharpEMenuIcon,uPropertyList;

type
  TSharpEMenuItem = class;

  TSharpEMenuItemType = (mtLink,mtSubMenu,mtSeparator,mtDynamicDir,mtDriveList,
                         mtLabel,mtCustom,mtCPLList,mtDesktopObjectList,
                         mtDesktopObject,mtulist);
  TSharpEMenuItemState = (msNormal,msHover,msDown);

  TSharpEMenuItemMouseEvent = procedure(pItem : TSharpEMenuItem; Button: TMouseButton; Shift: TShiftState) of object;  
  TSharpEMenuItemClickEvent = procedure(pItem : TSharpEMenuItem; pMenuWnd : TObject; var CanClose : boolean) of object;
  TSharpEMenuItemPaintEvent = procedure(Dst : TBitmap32; px,py : integer;
                                        pItem : TObject; state : TSharpEMenuItemState) of object;

  TSharpEMenuItem = class
  private
    // Events
    FClickEvent   : TSharpEMenuItemClickEvent;
    FPaintEvent   : TSharpEMenuItemPaintEvent;
    FMouseUpEvent : TSharpEMenuItemMouseEvent;
    // #############
    FIcon      : TSharpEMenuIcon; // only a pointer to the icon list!
    FSubMenu   : TObject;
    FOwnerMenu : TObject;
    FCaption   : String;
    FIndex     : Integer;
    FItemType  : TSharpEMenuItemType;
    FDynamic   : boolean;
    FVisible   : boolean;
    FWrapMenu  : boolean;
    FPropList  : TPropertyList;
    FPopup     : TObject;
    function GetItemIndex: integer;
  public
    constructor Create(pOwnerMenu : TObject; pItemType : TSharpEMenuItemType); reintroduce;
    destructor Destroy; override;
    procedure MoveToMenu(Dst : TObject; pIndex : integer = -1);
    property PropList  : TPropertyList read FPropList;
    property Caption   : String read FCaption write FCaption;
    property Icon      : TSharpEMenuIcon read FIcon write FIcon;
    property ItemType  : TSharpEMenuItemType read FItemType;
    property SubMenu   : TObject read FSubMenu write FSubMenu;
    property OwnerMenu : TObject read FOwnerMenu write FOwnerMenu;
    property isDynamic : boolean read FDynamic write FDynamic;
    property isVisible : boolean read FVisible write FVisible;
    property isWrapMenu : boolean read FWrapMenu write FWrapMenu;
    property ListIndex : integer read FIndex write FIndex; // only used and updated before sorting!
    property Popup     : TObject read FPopup write FPopup;
    property ItemIndex : integer read GetItemIndex;
    property OnClick   : TSharpEMenuItemClickEvent read FClickEvent write FClickEvent;
    property OnPaint   : TSharpEMenuItemPaintEvent read FPaintEvent write FPaintEvent;
    property OnMouseUp : TSharpEMenuItemMouseEvent read FMouseUpEvent write FMouseUpEvent;
  end;

implementation

uses uSharpEMenu;

constructor TSharpEMenuItem.Create(pOwnerMenu : TObject; pItemType : TSharpEMenuItemType);
begin
  inherited Create;

  FOwnerMenu := pOwnerMenu;
  FPropList := TPropertyList.Create;

  FVisible := True;
  FDynamic := False;
  FWrapMenu := False;

  FSubMenu      := nil;
  FClickEvent   := nil;
  FPaintEvent   := nil;
  FMouseUpEvent := nil;

  FCaption := '';
  FItemType := pItemType;
end;

destructor TSharpEMenuItem.Destroy;
begin
  if FSubMenu <> nil then
     TSharpEMenu(FSubMenu).Free;

  if Icon <> nil then
    SharpEMenuIcons.RemoveIcon(Icon);

  FreeAndNil(FPropList);

  inherited Destroy;
end;


function TSharpEMenuItem.GetItemIndex: integer;
begin
  result := -1;
  if FOwnerMenu = nil then
    exit;

  result := TSharpEMenu(FOwnerMenu).Items.IndexOf(self);
end;

procedure TSharpEMenuItem.MoveToMenu(Dst: TObject; pIndex : integer = -1);
var
  SrcMenu,DstMenu : TSharpEMenu;
begin
  if (Dst = nil) or (FOwnerMenu = nil) then
    exit;
  if not (Dst is TSharpEMenu) then
    exit;
  SrcMenu := TSharpEMenu(FOwnerMenu);
  DstMenu := TSharpEMenu(Dst);

  SrcMenu.Items.Extract(self);
  if pIndex = -1 then
    DstMenu.Items.Add(self)
  else DstMenu.Items.Insert(pIndex,self);
       
  FOwnerMenu := Dst;
end;

end.
