{
Source Name: uSharpEMenuItem.pas
Description: SharpE Menu Item Class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.net

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

unit uSharpEMenuItem;

interface

uses GR32,uSharpEMenuIcon;

type
  TSharpEMenuItem = class;

  TSharpEMenuItemType = (mtLink,mtSubMenu,mtSeperator,mtDynamicDir,mtDriveList,
                         mtLabel);
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
    FAction   : String;
    FIndex    : Integer;
    FItemType : TSharpEMenuItemType;
    FDynamic  : boolean;
    FVisible  : boolean;
  public
    constructor Create(pItemType : TSharpEMenuItemType); reintroduce;
    destructor Destroy; override;
    property Action    : String read FAction write FAction;
    property Caption   : String read FCaption write FCaption;
    property Icon      : TSharpEMenuIcon read FIcon write FIcon;
    property ItemType  : TSharpEMenuItemType read FItemType;
    property SubMenu   : TObject read FSubMenu write FSubMenu;
    property isDynamic : boolean read FDynamic write FDynamic;
    property isVisible : boolean read FVisible write FVisible;
    property ListIndex : integer read FIndex write FIndex; // only used and updated before sorting!
    property OnClick : TSharpEMenuItemClickEvent read FClickEvent write FClickEvent;
    property OnPaint : TSharpEMenuItemPaintEvent read FPaintEvent write FPaintEvent;
  end;

implementation

uses uSharpEMenu;

constructor TSharpEMenuItem.Create(pItemType : TSharpEMenuItemType);
begin
  inherited Create;

  FVisible := True;
  FDynamic := False;

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

  inherited Destroy;
end;

end.
