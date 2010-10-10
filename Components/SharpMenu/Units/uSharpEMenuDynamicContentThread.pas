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
  ActiveX,
  SharpApi,
  Contnrs,
  Windows;

type
  TSharpEMenuDynamicContentThread = class(TThread)
  private
    FList : TObjectList;
    FCOMInitialized : boolean;
  protected
    procedure Execute; override;
    procedure DoRefresh;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddItem(pList : TObjectList);
  end;

implementation

uses
  uSharpEMenu;

var
  CritSect : TRTLCriticalSection;

constructor TSharpEMenuDynamicContentThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FCOMInitialized := False;

  FList := TObjectList.Create;
end;

destructor TSharpEMenuDynamicContentThread.Destroy;
begin
  FList.Free;
  if FCOMInitialized then  
    CoUnInitialize;
  inherited Destroy;
end;

procedure TSharpEMenuDynamicContentThread.AddItem(pList : TObjectList);
begin
  EnterCriticalSection(CritSect);
  FList.Add(pList);
  LeaveCriticalSection(CritSect);
end;

procedure TSharpEMenuDynamicContentThread.DoRefresh;
var
  i : integer;
  menu : TSharpEMenu;
  mnuObjs : TObjectList;
begin
  while not Terminated do
  begin
    while FList.Count > 0 do
    begin
      if Terminated then
        break;

      mnuObjs := TObjectList(FList.Extract(FList.Last));

      for i := 0 to mnuObjs.Count - 1 do
      begin
        if Terminated then
          break;

        EnterCriticalSection(CritSect);
        menu := TSharpEMenu(mnuObjs.Items[i]);
        menu.RefreshDynamicContent;
        menu.ParentMenuItem.isDynamicSubMenuInitialized := True;
        LeaveCriticalSection(CritSect);
      end;

      Sleep(1);
    end;

    if Terminated then
      break;
      
    Suspend;
  end;
end;

procedure TSharpEMenuDynamicContentThread.Execute;
begin
  if not FCOMInitialized then
  begin
    CoInitialize(nil);
    FCOMInitialized := True;
  end;
  
  DoRefresh;
end;

initialization
   InitializeCriticalSection(CritSect);

finalization
  DeleteCriticalSection(CritSect);

end.
