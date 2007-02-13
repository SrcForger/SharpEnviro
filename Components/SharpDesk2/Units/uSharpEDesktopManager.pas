{
Source Name: uSharpEDesktopManager.pas
Description: TSharpEDesktopManager class
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

unit uSharpEDesktopManager;

interface

uses Forms,Classes,SysUtils,Windows,Contnrs,uSharpEDesktopItem,uSharpEDesktop;

type
  TSharpEDesktopManager = class
  private
    FDesktops : TObjectList;
    FCurrentDesktop : TSharpEDesktop; // only a pointer to a desktop from the list!
    procedure InitDesktops;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure LoadDesktops;
  published
    property CurrentDesktop : TSharpEDesktop read FCurrentDesktop;
  end;

implementation

uses SharpApi, JvSimpleXML;

constructor TSharpEDesktopManager.Create;
begin
  inherited Create;

  FCurrentDesktop := nil;

  FDesktops := TObjectList.Create(True);
  FDesktops.Clear;
end;

destructor TSharpEDesktopManager.Destroy;
begin
  FDesktops.Clear;
  
  FreeAndNil(FDesktops);
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
            DirList.Free;
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

end.
