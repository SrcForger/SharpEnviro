{
Source Name: uSharpEMenuItem.pas
Description: SharpE Menu Item Class
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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

uses GR32,SysUtils,uSharpEMenuIcon,uPropertyList;

type
  TSharpEMenuItem = class;

  TSharpEMenuItemType = (mtLink,mtSubMenu,mtSeparator,mtDynamicDir,mtDriveList,
                         mtLabel,mtCustom,mtCPLList,mtDesktopObjectList,mtDesktopObject);
  TSharpEMenuItemState = (msNormal,msHover,msDown);

  TSharpEMenuItemClickEvent = procedure(pItem : TSharpEMenuItem; var CanClose : boolean) of object;
  TSharpEMenuItemPaintEvent = procedure(Dst : TBitmap32; px,py : integer;
                                        pItem : TObject; state : TSharpEMenuItemState) of object;

  TSharpEMenuItem = class
  private
    // Events
    FClickEvent : TSharpEMenuItemClickEvent;
    FPaintEvent : TSharpEMenuItemPaintEvent;
    // #############
    FIcon     : TSharpEMenuIcon; // only a pointer to the icon list!
    FSubMenu  : TObject;
    FCaption  : String;
    FIndex    : Integer;
    FItemType : TSharpEMenuItemType;
    FDynamic  : boolean;
    FVisible  : boolean;
    FWrapMenu : boolean;
    FPropList : TPropertyList;
    FPopup    : TObject;
  public
    constructor Create(pItemType : TSharpEMenuItemType); reintroduce;
    destructor Destroy; override;
    property PropList  : TPropertyList read FPropList;
    property Caption   : String read FCaption write FCaption;
    property Icon      : TSharpEMenuIcon read FIcon write FIcon;
    property ItemType  : TSharpEMenuItemType read FItemType;
    property SubMenu   : TObject read FSubMenu write FSubMenu;
    property isDynamic : boolean read FDynamic write FDynamic;
    property isVisible : boolean read FVisible write FVisible;
    property isWrapMenu : boolean read FWrapMenu write FWrapMenu;
    property ListIndex : integer read FIndex write FIndex; // only used and updated before sorting!
    property Popup     : TObject read FPopup write FPopup;
    property OnClick   : TSharpEMenuItemClickEvent read FClickEvent write FClickEvent;
    property OnPaint   : TSharpEMenuItemPaintEvent read FPaintEvent write FPaintEvent;
  end;

implementation

uses uSharpEMenu;

constructor TSharpEMenuItem.Create(pItemType : TSharpEMenuItemType);
begin
  inherited Create;

  FPropList := TPropertyList.Create;

  FVisible := True;
  FDynamic := False;
  FWrapMenu := False;

  FClickEvent := nil;
  FPaintEvent := nil;

  FCaption := '';
  FItemType := pItemType;
end;

destructor TSharpEMenuItem.Destroy;
begin
  if FSubMenu <> nil then
     TSharpEMenu(FSubMenu).Free;
  SharpEMenuIcons.RemoveIcon(Icon);

  FreeAndNil(FPropList);

  inherited Destroy;
end;


end.
