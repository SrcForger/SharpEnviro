{
Source Name: uExplorer.pas
Description: Main Explorer Window
Copyright (C) Mathias Tillman <mathias@sharpenviro.com>

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

unit uSharpExplorerForm;

interface

uses
  Windows,
  Messages,
  Types,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  SharpApi, ExtCtrls,
  uSharpWinDesk;

type
  TWinList_Init = function : integer; stdcall;
  TWinList_Terminate = function : integer; stdcall;

  TSharpExplorerForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    WinListDll : THandle;
    WinList_Init : TWinList_Init;
    WinList_Terminate : TWinList_Terminate;

    procedure WMSharpTerminate(var Msg : TMessage);       message WM_SHARPTERMINATE;
  end;

var
  SharpExplorerForm : TSharpExplorerForm;
  SharpWinDesk : TSharpWinDesk;

implementation

{$R *.dfm}

procedure TSharpExplorerForm.WMSharpTerminate(var Msg : TMessage);
begin
  Close;
end;

procedure TSharpExplorerForm.FormCreate(Sender: TObject);
begin
  // Initialize IShellWindows
  // Try 7 Dll
  WinListDll := LoadLibrary('ExplorerFrame.dll');
  if (WinListDll = 0) or (not Assigned(GetProcAddress(WinListDll, PAnsiChar(MAKELPARAM(110, 0))))) then
  begin
    if WinListDll <> 0 then
      FreeLibrary(WinListDll);

    // Use Vista/XP dll
    WinListDll := LoadLibrary('shdocvw.dll');
  end;

  if WinListDll <> 0 then
  begin
    @WinList_Init := GetProcAddress(WinListDll, PAnsiChar(MAKELPARAM(110, 0)));
    if Assigned(WinList_Init) then
      WinList_Init;
  end;

  SharpWinDesk := TSharpWinDesk.Create;
  SharpWinDesk.Start;
end;

procedure TSharpExplorerForm.FormDestroy(Sender: TObject);
begin
  if WinListDll <> 0 then
  begin
    @WinList_Terminate := GetProcAddress(WinListDll, PAnsiChar(MAKELPARAM(111, 0)));
    if Assigned(WinList_Terminate) then
      WinList_Terminate;

    FreeLibrary(WinListDll);
  end;

  SharpWinDesk.Stop;
  SharpWinDesk.Free;
end;

end.


