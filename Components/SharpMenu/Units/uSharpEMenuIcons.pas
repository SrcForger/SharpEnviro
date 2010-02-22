{
Source Name: uSharpEMenuIcons.pas
Description: SharpE Menu Icons List Class
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

unit uSharpEMenuIcons;

interface

uses SysUtils,Contnrs,Classes,GR32,uSharpEMenuIcon;

type
  TSharpEMenuIcons = class
  private
    FItems : TObjectList;
  public
    property Items : TObjectList read FItems;
    constructor Create; reintroduce;
    destructor Destroy; override;
    function AddIcon(pIconSource,pIconData : String; pIconType : TIconType) : TSharpEMenuIcon; overload;
    function AddIcon(pIconSource : String; pBmp : TBitmap32; pIconType : TIconType) : TSharpEMenuIcon; overload;
    function FindIcon(pIconSource,pIconData : String) : TSharpEMenuIcon;
    function FindGenericIcon(pIconData : String) : boolean;
    procedure RemoveIcon(pIconSource : String); overload;
    procedure RemoveIcon(pIcon : TSharpEMenuIcon); overload;
    procedure SaveIconCache(pFileName : String);
    procedure LoadIconCache(pFileName : String);
    procedure LoadGenericIcons;
  end;

implementation

uses
  JCLSysInfo,
  SharpApi,
  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts;

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
  isSEIcon : boolean;
  found : boolean;
begin
  if pos('.',pIconSource) <> 0 then
    isSEIcon := GetCurrentTheme.Icons.IsIconInIconSet(pIconSource)
  else isSEIcon := False;

  found := False;
  for n := 0 to FItems.Count -1 do
  begin
    Item := TSharpEMenuIcon(FItems.Items[n]);
    if isSEIcon then
    begin
      if Item.IconType <> itCustomIcon then
        if CompareText(Item.IconSource,pIconSource) = 0 then
          found := True;
    end else
    if (CompareText(Item.IconSource,pIconData) = 0) or
       (CompareText(Item.IconSource,pIconSource) = 0) then
      found := True;

    if found then    
    begin
      result := Item;
      exit;
    end;
  end;
  result := nil;
end;

// only checks for generic icons!
function TSharpEMenuIcons.FindGenericIcon(pIconData: String): boolean;
var
  n : integer;
  Item : TSharpEMenuIcon;
begin
  result := False;

  for n := 0 to FItems.Count -1 do
  begin
    Item := TSharpEMenuIcon(FItems.Items[n]);
    if Item.IconType = itGeneric then
      if CompareText(Item.IconSource,pIconData) = 0 then
      begin
        result := True;
        exit;
      end;
  end;
end;

function TSharpEMenuIcons.AddIcon(pIconSource : String; pBmp : TBitmap32; pIconType : TIconType) : TSharpEMenuIcon;
var
  Item : TSharpEMenuIcon;
begin
  Item := FindIcon(pIconSource,pIconSource);
  if Item = nil then
  begin
    Item := TSharpEMenuIcon.Create(pIconSource,pBmp,pIconType);
    FItems.Add(Item);
  end else Item.Count := Item.Count + 1;
  result := Item;
end;

function TSharpEMenuIcons.AddIcon(pIconSource,pIconData : String; pIconType : TIconType) : TSharpEMenuIcon;
var
  Item : TSharpEMenuIcon;
begin
  Item := FindIcon(pIconSource,pIconData);
  if Item = nil then
  begin
    Item := TSharpEMenuIcon.Create(pIconSource,pIconData,pIconType);
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

procedure TSharpEMenuIcons.LoadGenericIcons;
var
  Dir : String;
  sr : TSearchRec;
  filename : String;
  filetag : String;
begin
  Dir := SharpApi.GetSharpeDirectory + 'Icons\Menu\';

  if FindFirst(Dir + '*.png',faAnyFile,sr) = 0 then
  repeat
    filename := Dir + sr.Name;
    if FileExists(filename) then
    begin
      filetag := sr.Name;
      setlength(filetag,length(filetag) - length(ExtractFileExt(filetag)));
      filetag := 'generic.' + filetag;
      AddIcon(filename,filetag,itGeneric);
    end;
  until (FindNext(sr) <> 0);
  FindClose(sr);
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
    //SendDebugMessageEx('SharpMenu', IconSource, 0, DMT_TRACE);
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
  if not FileExists(Fn) then
    Stream := TFileStream.Create(Fn,fmCreate)
  else
    Stream := TFileStream.Create(Fn,fmOpenReadWrite);

  Stream.Seek(0,soFromEnd);
  for n := 0 to FItems.Count - 1 do
  begin
    Item := TSharpEMenuIcon(FItems.Items[n]);
    if (not Item.Cached) and (length(Item.IconSource) > 0) and
       (Item.Icon.Width > 0) and (Item.Icon.Height > 0)
       and (not GetCurrentTheme.Icons.IsIconInIconSet(Item.IconSource)
       and (Item.IconType <> itGeneric))
    then
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
