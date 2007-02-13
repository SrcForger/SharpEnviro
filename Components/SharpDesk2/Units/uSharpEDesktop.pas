{
Source Name: uSharpEDesktop.pas
Description: TSharpEDesktop class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit uSharpEDesktop;

interface

uses Windows,Classes,SysUtils,Math,Contnrs,DateUtils,Types,
     uSharpEDesktopItem;

type
  TSharpEDesktopAddPoint = (apTopLeft,apTopRight,apBottomRight,apBottomLeft);

  TCustomData = class
  public
    X,Y : integer;
    FileName : String;
  end;

  // Usage:
  // - TSharpEDesktop.Create
  // - TSharpEDesktop.AddDirectory('DirA'); (Main Directory!)
  // - TSharpEDesktop.AddDirectory('DirB');
  // - TSharpEDesktop.LoadCustomData;
  // - TSharpEDesktop.RefreshDirectories;


  TSharpEDesktop = class
  private
    FName          : String; 
    FDirectories   : TStringList;                 // List of included Directories
    FItems         : TObjectList;                 // List of all desktop objects
    FCustomData    : TObjectList;                 // Items with special position
    FAddPoint      : TSharpEDesktopAddPoint;      // Add topleft,bottomleft,...
    FAddVert       : boolean;                     // Add Direction = Top <-> Bottom
    FGridSize      : integer;
    FGridArray     : array of array of TSharpEDesktopItem;
    FDimension     : TPoint;
    function FindCustomDataByFile(pFileName : String) : TCustomData;
    function FindItemByFile(pFileName : String) : TSharpEDesktopItem;
    procedure InitGridArray;
    procedure ClearGridArray;
    procedure InsertToGrid(pItem : TSharpEDesktopItem);
    function GetGridItem(x,y : integer) : TSharpEDesktopItem;
    procedure UpdateCustomDataFromGrid;
  public
    procedure AddDirectory(pDirectory : String);
    procedure LoadCustomData;
    procedure SaveCustomData;
    procedure RefreshDirectories;

    constructor Create(pWidth,pHeight : integer); reintroduce;
    destructor Destroy; override;
  published
    property Name : String read FName write FName;
  end;

implementation

uses JclFileUtils,JvSimpleXML;

constructor TSharpEDesktop.Create(pWidth,pHeight : integer);
begin
  inherited Create;

  FAddPoint := apTopLeft;
  FAddVert := True;

  FGridSize := 64;
  FDimension.x := pWidth;
  FDimension.y := pHeight;

  FDirectories := TStringList.Create;
  FDirectories.Clear;

  FItems := TObjectList.Create(True);
  FItems.Clear;

  FCustomData := TObjectList.Create(True);
  FCustomData.Clear;

  InitGridArray;
  ClearGridArray;
end;

destructor TSharpEDesktop.Destroy;
begin
  FItems.Clear;
  FCustomData.Clear;
  FDirectories.Clear;

  FreeAndNil(FCustomData);
  FreeAndNil(FDirectories);
  FreeAndNil(FItems);

  inherited Destroy;
end;

procedure TSharpEDesktop.UpdateCustomDataFromGrid;
var
  x,y : integer;
  item : TSharpEDesktopItem;
  ditem : TCustomData;
begin
  FCustomData.Clear;

  for y := 0 to High(FGridArray) do
      for x := 0 to High(FGridArray[y]) do
          if FGridArray[y][x] <> nil then
          begin
            item := TSharpEDesktopItem(FGridArray[y][x]);
            ditem := TCustomData.Create;
            ditem.FileName := item.FileName;
            ditem.X := x;
            ditem.Y := y;
            FCustomData.Add(ditem);
          end;
end;

procedure TSharpEDesktop.SaveCustomData;
var
  XML : TJvSimpleXML;
  ditem : TCustomData;
  n,i : integer;
  Dir : String;
  fn1,fn2 : String;
begin
  UpdateCustomDataFromGrid;
  XML := TJvSimpleXMl.Create(nil);

  for n := 0 to FDirectories.Count - 1 do
  begin
    XML.Root.Items.Clear;
    XML.Root.Name := 'SharpEDesktop';
    for i := 0 to FCustomData.Count -1 do
    begin
      ditem := TCustomData(FCustomData.Items[i]);
      Dir := IncludeTrailingBackSlash(ExtractFileDir(ditem.FileName));
      if CompareText(FDirectories[n],Dir) = 0 then
         with XML.Root.Items.Add('item').Items do
         begin
           Add('FileName',ditem.FileName);
           Add('X',ditem.X);
           Add('Y',ditem.Y);
         end;
    end;

    // try/except because of read only drives/directories
    try
      fn1 := FDirectories[n] + 'SharpE.Desktop~';
      fn2 := FDirectories[n] + 'SharpE.Desktop';
      if FileExists(fn1) then
         DeleteFile(fn1);
      XML.SaveToFile(fn1);
      if FileExists(fn2) then
         DeleteFile(fn2);
      RenameFile(fn1,fn2);
    except
    end;
    
  end;
  XML.Free;
end;

procedure TSharpEDesktop.LoadCustomData;
var
  XML : TJvSimpleXML;
  ditem : TCustomData;
  fn : String;
  n,i : integer;
begin
  FCustomData.Clear;
  XML := TJvSimpleXMl.Create(nil);
  
  for n := 0 to FDirectories.Count - 1 do
  begin
    fn := FDirectories[n] + 'SharpE.Desktop';
    if FileExists(fn) then
    begin
      try
        XML.LoadFromFile(fn);
        for i := 0 to XML.Root.Items.Count - 1 do
            with XML.Root.Items.Item[n].Items do
            begin
              ditem := TCustomData.Create;
              ditem.X := IntValue('x',0);
              ditem.Y := IntValue('y',0);
              ditem.FileName := Value('FileName','');
              FCustomData.Add(ditem);
            end;
      except
      end;
    end;
  end;
  XML.Free;
end;

procedure TSharpEDesktop.ClearGridArray;
var
  x,y : integer;
begin
  for y := 0 to High(FGridArray) do
      for x := 0 to High(FGridArray[y]) do
          FGridArray[x,y] := nil;
end;

procedure TSharpEDesktop.InitGridArray;
var
  mx,my : integer;
  n : integer;
begin
  mx := Floor(FDimension.X / FGridSize);
  my := Floor(FDimension.Y / FGridSize);
  setlength(FGridArray,my);
  for n := 0 to High(FGridArray) do
      setlength(FGridArray[n],mx);
end;

procedure TSharpEDesktop.InsertToGrid(pItem : TSharpEDesktopItem);

  function GridAssign(x,y : integer) : boolean;
  begin
    if FGridArray[x,y] = nil then
    begin
      FGridArray[x,y] := pItem;
      pItem.IsInGrid := True;
      result := true
    end else result := false;
  end;

var
  x,y   : integer;
  mx,my : integer;
begin
  mx := High(FGridArray[0]);
  my := High(FGridArray);

  case FAddPoint of
    apTopLeft:
      if FAddVert then
      begin
        for x := 0 to mx do
            for y := 0 to my do
                if GridAssign(x,y) then exit;
      end else
      begin
        for y := 0 to my do
            for x := 0 to mx do
                if GridAssign(x,y) then exit;
      end;
      
    apTopRight:
      if FAddVert then
      begin
        for x := mx downto 0 do
            for y := 0 to my do
                if GridAssign(x,y) then exit;
      end else
      begin
        for y := 0 to my do
            for x := mx downto 0 do
                if GridAssign(x,y) then exit;
      end;

    apBottomRight:
      if FAddVert then
      begin
        for x := mx downto 0 do
            for y := my downto 0 do
                if GridAssign(x,y) then exit;
      end else
      begin
        for y := my downto 0 do
            for x := mx downto 0 do
                if GridAssign(x,y) then exit;
      end;

    apBottomLeft:
      if FAddVert then
      begin
        for x := 0 to mx do
            for y := my downto 0 do
                if GridAssign(x,y) then exit;
      end else
      begin
        for y := my downto 0 do
            for x := 0 to mx do
                if GridAssign(x,y) then exit;
      end;
  end;
  
  pItem.IsInGrid := False;
end;

function TSharpEDesktop.GetGridItem(x,y : integer) : TSharpEDesktopItem;
begin
  x := abs(x);
  y := abs(y);

  if (y > High(FGridArray)) or (x > High(FGridArray[0])) then
  begin
    result := nil;
    exit;
  end;

  result := FGridArray[y][x]
end;

procedure TSharpEDesktop.AddDirectory(pDirectory : String);
begin
  FDirectories.Add(IncludeTrailingBackSlash(pDirectory));
end;

function TSharpEDesktop.FindCustomDataByFile(pFileName : String) : TCustomData;
var
  n : integer;
  temp : TCustomData;
begin
  for n := 0 to FCustomData.Count - 1 do
  begin
    temp := TCustomData(FCustomData.Items[n]);
    if temp.FileName = pFileName then
    begin
      result := temp;
      exit;
    end;
  end;

  result := nil;
end;

function TSharpEDesktop.FindItemByFile(pFileName : String) : TSharpEDesktopItem;
var
  n : integer;
  temp : TSharpEDesktopItem;
begin
  for n := 0 to FItems.Count - 1 do
  begin
    temp := TSharpEDesktopItem(FItems.Items[n]);
    if temp.FileName = pFileName then
    begin
      result := temp;
      exit;
    end;
  end;
  
  result := nil;
end;

procedure TSharpEDesktop.RefreshDirectories;
var
  sr : TSearchRec;
  n,i : integer;
  item : TSharpEDesktopItem;
  ditem : TCustomData;
  dt : TDateTime;
  newlist : TStringList;
  newitem : boolean;
begin
  newlist := TStringList.Create;
  newlist.Clear;

  newitem := False;
  
  for n := 0 to FDirectories.Count - 1 do
  begin
    if DirectoryExists(FDirectories[n]) then
    begin
      if FindFirst(FDirectories[n] + '*.*',FAAnyFile,sr) = 0 then
      repeat
        if ((sr.Name <> '.') and (sr.Name <> '..')) then
        begin
          item := FindItemByFile(sr.Name);
          if item <> nil then
          begin
            newlist.add(FDirectories[n] + sr.Name);
          end else
          begin
            GetFileLastWrite(item.FileName,dt);
            if CompareDateTime(dt,item.LastChange) > 0 then
               item.UpdateFromFile;
          end;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end else ForceDirectories(FDirectories[n])
  end;

  for n := 0 to FCustomData.Count - 1 do
  begin
    ditem := TCustomData(FCustomData.Items[n]);
    i := newlist.IndexOf(ditem.FileName);
    if i > -1 then
      if GetGridItem(ditem.X,ditem.Y) = nil then
      begin
        newitem := True;
        item := TSharpEDesktopItem.Create(FDirectories[n] + sr.Name);
        item.IsInGrid := True;
        FItems.Add(item);
        newlist.Delete(i);
      end;
  end;

  for n := 0 to newlist.Count - 1 do
  begin
    newitem := True;
    item := TSharpEDesktopItem.Create(FDirectories[n] + sr.Name);
    FItems.Add(item);
    InsertToGrid(item);
  end;

  FreeAndNil(newlist);

  if newitem then SaveCustomData;
end;

end.
