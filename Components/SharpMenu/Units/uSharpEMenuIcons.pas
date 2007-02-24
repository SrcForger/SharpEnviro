{
Source Name: uSharpEMenuIcons.pas
Description: SharpE Menu Icons List Class
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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

uses SysUtils,Contnrs,Classes,GR32,uSharpEMenuIcon;

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
    procedure SaveIconCache(pFileName : String);
    procedure LoadIconCache(pFileName : String);
  end;

implementation

uses SharpApi,jclsysinfo;

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
    if (CompareText(Item.IconSource,pIconData) = 0) or
       (CompareText(Item.IconSource,pIconSource) = 0) then
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

procedure StringSaveToStream(str: string; stream: TStream);
var Size: integer;
begin
  Size := length(str);
  stream.WriteBuffer(Size, sizeof(Size));
  stream.WriteBuffer(Pointer(str)^, Size);
end;

function StringLoadFromStream(stream: TStream): string;
var Size: integer;
  str: string;
begin
  Stream.ReadBuffer(Size, sizeof(Size));
  SetString(str, nil, Size);
  Stream.ReadBuffer(Pointer(str)^, Size);
  result := str;
end;

procedure TSharpEMenuIcons.LoadIconCache(pFileName : String);
var
  Stream : TFileStream;
  Dir,Fn : String;
  t : integer;
  Item : TSharpEMenuIcon;
  IconSource : String;
  IconType : TIconType;
begin
  Dir := SharpApi.GetSharpeDirectory + 'Cache';
  Fn := Dir + '\' + GetLocalUserName + pFileName;
  if not FileExists(Fn) then exit;

  Stream := TFileStream.Create(Fn,fmOpenRead);
  while (Stream.Position < Stream.Size) do
  begin
    IconSource := StringLoadFromStream(Stream);
    Stream.ReadBuffer(t,sizeof(t));
    case t of
      1: IconType := itCustomIcon;
      else IconType := itShellIcon;
    end;
    Item := TSharpEMenuIcon.Create(IconSource,IconType,Stream);
    Item.Cached := True;
    FItems.Add(item);
  end;
  Stream.Free;
end;

procedure TSharpEMenuIcons.SaveIconCache(pFileName : String);
var
  Stream : TFileStream;
  n : integer;
  Dir,Fn : String;
  t : integer;
  Item : TSharpEMenuIcon;
begin
  Dir := SharpApi.GetSharpeDirectory + 'Cache';
  If not DirectoryExists(Dir) then ForceDirectories(Dir);

  Fn := Dir + '\' + GetLocalUserName + pFileName;
  if not FileExists(Fn) then Stream := TFileStream.Create(Fn,fmCreate)
     else Stream := TFileStream.Create(Fn,fmOpenReadWrite);
  Stream.Seek(0,soFromEnd);
  for n := 0 to FItems.Count - 1 do
  begin
    Item := TSharpEMenuIcon(FItems.Items[n]);
    if (not Item.Cached) and (length(Item.IconSource) > 0) and
       (Item.Icon.Width > 0) and (Item.Icon.Height > 0) then
    begin
      StringSaveToStream(Item.IconSource,Stream);
      case Item.IconType of
        itCustomIcon : t := 1;
        else t := 0;
      end;
      Stream.WriteBuffer(t,sizeof(t));
      Item.Icon.SaveToStream(Stream);
    end;
  end;
  Stream.Free;
end;

end.
