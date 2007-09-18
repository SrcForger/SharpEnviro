{
Source Name: uSharpEDesktopManager.pas
Description: TSharpEDesktopManager class
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

unit uSharpEDesktopManager;

interface

uses Forms,Classes,Controls,SysUtils,Windows,Contnrs,uSharpEDesktopItem,uSharpEDesktop;

type
  TSharpEDesktopManager = class
  private
    FDesktops : TObjectList;
    FSelectionList : TObjectList;
    FCurrentDesktop : TSharpEDesktop; // only a pointer to a desktop from the list!
    procedure InitDesktops;
  public
    procedure LoadDesktops;
    procedure UpdateSelection(alist,dlist : TObjectList; X1,Y1,X2,Y2 : integer);

    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property CurrentDesktop : TSharpEDesktop read FCurrentDesktop;
    property SelectionList : TObjectList read FSelectionList;
  end;

implementation

uses SharpApi, JvSimpleXML;

constructor TSharpEDesktopManager.Create;
begin
  inherited Create;

  FCurrentDesktop := nil;

  FDesktops := TObjectList.Create(True);
  FDesktops.Clear;

  FSelectionList := TObjectList.Create(False);
  FSelectionList.Clear;
end;

destructor TSharpEDesktopManager.Destroy;
begin
  FDesktops.Clear;
  FSelectionList.Clear;
  
  FreeAndNil(FDesktops);
  FreeAndNil(FSelectionList);
end;

procedure TSharpEDesktopManager.InitDesktops;
var
  n : integer;
  desk : TSharpEDesktop;
begin
  for n := 0 to FDesktops.Count - 1 do
  begin
    desk := TSharpEDesktop(FDesktops.Items[n]);
    desk.LoadCustomData;
    desk.RefreshDirectories;
    if n = 0 then FCurrentDesktop := desk;
  end;
end;

procedure TSharpEDesktopManager.LoadDesktops;
var
  XML  : TJvSimpleXML;
  n,i  : integer;
  Dir  : String;
  fn   : String;
  desk : TSharpEDesktop;
  DirList : TStringList;
  w,h : integer;
begin
  // Desktop Size
  w := Screen.Width;
  h := Screen.WorkAreaHeight;

  FDesktops.Clear;

  XML := TJvSimpleXML.Create(nil);
  DirList := TStringList.Create;
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\';
  fn  := Dir + 'Desktops.xml';

  if FileExists(fn) then
  begin
    try
      XML.LoadFromFile(fn);
      for n := 0 to XML.Root.Items.Count - 1 do
          with XML.Root.Items.Item[n].Items do
          begin
            DirList.Clear;
            if ItemNamed['Directories'] <> nil then
               for i := 0 to ItemNamed['Directories'].Items.Count - 1 do
                   DirList.Add(ItemNamed['Directories'].Items.Item[i].Value);
            if DirList.Count > 0 then
            begin
              desk := TSharpEDesktop.Create(w,h);
              desk.Name := Value('Name','...');
              for i := 0 to DirList.Count - 1 do
                  desk.AddDirectory(DirList[i]);
              FDesktops.add(desk);
            end;
          end;
    except
    end;
  end;

  DirList.Free;
  XML.Free;

  InitDesktops;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TSharpEDesktopManager.UpdateSelection(alist,dlist : TObjectList; X1,Y1,X2,Y2 : integer);
var
  x,y : integer;
  n,i : integer;
  item : TSharpEDesktopItem;
  R : TRect;
  newList : TObjectList;
begin
  if FCurrentDesktop = nil then exit;

  R := Rect(X1,Y1,X2,Y2);

  newList := TObjectList.Create(False);
  newList.Clear;

  if alist <> nil then alist.Clear;
  if dlist <> nil then dlist.Clear;

  with FCurrentDesktop do
  begin
    for y := 0 to High(Grid) do
        for x := 0 to High(Grid[y]) do
        begin
          if Grid[y][x] <> nil then
            if PointInRect(Point(x*gridsize + gridsize div 2, y*gridsize + gridsize div 2),R) then
            begin
              item := TSharpEDesktopItem(Grid[y][x]);
              newList.Add(item);

              // new item, add to add list
              if (alist <> nil) and (FSelectionList.IndexOf(item)<0) then
                 alist.Add(item)  
            end;
        end;
  end;

  // get items which have been removed
  if (dlist <> nil) then
  begin
    for n := 0 to FSelectionList.Count - 1 do
    begin
      i := newList.IndexOf(FSelectionList.Items[n]);
      if (i < 0) then
          dlist.Add(FSelectionList.Items[n]);
    end;
  end;

  // build new list
  FSelectionList.Clear;
  for n := 0 to newList.Count - 1 do
      FSelectionList.Add(newList[n]);

  newList.Free;
end;


end.
