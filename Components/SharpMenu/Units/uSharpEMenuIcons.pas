{
Source Name: uSharpEMenuIcons.pas
Description: SharpE Menu Icons List Class
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

unit uSharpEMenuIcons;

interface

uses SysUtils,Contnrs,GR32,uSharpEMenuIcon;

type
  TSharpEMenuIcons = class
  private
    FItems : TObjectList;
    function FindIcon(pIconSource,pIconData : String) : TSharpEMenuIcon;
  public
    property Items : TObjectList read FItems;
    constructor Create; reintroduce;
    destructor Destroy; override;
    function AddIcon(pIconSource,pIconData : String) : TSharpEMenuIcon; overload;
    function AddIcon(pIconSource : String; pBmp : TBitmap32) : TSharpEMenuIcon; overload;
    procedure RemoveIcon(pIconSource : String); overload;
    procedure RemoveIcon(pIcon : TSharpEMenuIcon); overload;
  end;

implementation

constructor TSharpEMenuIcons.Create;
begin
  inherited Create;

  FItems := TObjectList.Create;
  FItems.Clear;
end;

destructor TSharpEMenuIcons.Destroy;
begin
  FreeAndNil(FItems);

  inherited Destroy;
end;

function TSharpEMenuIcons.FindIcon(pIconSource,pIconData : String) : TSharpEMenuIcon;
var
  n : integer;
  Item : TSharpEMenuIcon;
begin
  for n := 0 to FItems.Count -1 do
  begin
    Item := TSharpEMenuIcon(FItems.Items[n]);
    if (Item.IconSource = pIconSource) then
    begin
      result := Item;
      exit;
    end;
  end;
  result := nil;
end;

function TSharpEMenuIcons.AddIcon(pIconSource : String; pBmp : TBitmap32) : TSharpEMenuIcon;
var
  Item : TSharpEMenuIcon;
begin
  Item := FindIcon(pIconSource,pIconSource);
  if Item = nil then
  begin
    Item := TSharpEMenuIcon.Create(pIconSource,pBmp);
    FItems.Add(Item);
  end else Item.Count := Item.Count + 1;
  result := Item;
end;

function TSharpEMenuIcons.AddIcon(pIconSource,pIconData : String) : TSharpEMenuIcon;
var
  Item : TSharpEMenuIcon;
begin
  Item := FindIcon(pIconSource,pIconData);
  if Item = nil then
  begin
    Item := TSharpEMenuIcon.Create(pIconSource,pIconData);
    FItems.Add(Item);
  end else Item.Count := Item.Count + 1;
  result := Item;
end;

procedure TSharpEMenuIcons.RemoveIcon(pIcon : TSharpEMenuIcon);
var
  n : integer;
  Item : TSharpEMenuIcon;
begin
  for n := 0 to FItems.Count -1 do
  begin
    Item := TSharpEMenuIcon(FItems.Items[n]);
    if Item = pIcon then
    begin
      Item.Count := Item.Count - 1;
      if Item.Count <= 0 then FItems.Delete(n);
      exit;      
    end;
  end;
end;

procedure TSharpEMenuIcons.RemoveIcon(pIconSource : String);
var
  n : integer;
  Item : TSharpEMenuIcon;
begin
  for n := 0 to FItems.Count -1 do
  begin
    Item := TSharpEMenuIcon(FItems.Items[n]);
    if Item.IconSource = pIconSource then
    begin
      Item.Count := Item.Count - 1;
      if Item.Count <= 0 then FItems.Delete(n);
      exit;
    end;
  end;
end;

end.
