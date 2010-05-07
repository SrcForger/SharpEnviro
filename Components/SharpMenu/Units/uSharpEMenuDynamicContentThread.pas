{
Source Name: uSharpMenuDynamicContentThread.pas
Description: Thread to update the dynamic content of a list of menus 
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

unit uSharpEMenuDynamicContentThread;

interface

uses
  Classes,
  SharpApi,
  Contnrs;

type
  TSharpEMenuDynamicContentThread = class(TThread)
  private
    FList : TObjectList;
  protected
    procedure Execute; override;
    procedure DoRefresh;
  public
    constructor Create(pList : TObjectList);
    destructor Destroy; override;
  end;

implementation

uses
  uSharpEMenu;

constructor TSharpEMenuDynamicContentThread.Create(pList : TObjectList);
begin
  inherited Create(True);
  FreeOnTerminate := False;

  FList := TObjectList.Create;
  FList.OwnsObjects := False;
  FList.Assign(pList);
end;

destructor TSharpEMenuDynamicContentThread.Destroy;
begin
  FList.Free;

  inherited Destroy;
end;

procedure TSharpEMenuDynamicContentThread.DoRefresh;
var
  n : integer;
  menu : TSharpEMenu;
begin
  for n := 0 to FList.Count - 1 do
  begin
    if Terminated then
      break;
    menu := TSharpEMenu(FList.Items[n]);
    menu.RefreshDynamicContent;
    menu.ParentMenuItem.isDynamicSubMenuInitialized := True;
  end;
end;

procedure TSharpEMenuDynamicContentThread.Execute;
begin
  DoRefresh;
end;

end.
