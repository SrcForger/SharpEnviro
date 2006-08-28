{
Source Name: uSharpCorePluginMethods
Description: The plugin interface routines
Copyright (C) Lee Green

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

unit uSharpCorePluginMethods;

interface
uses
  Windows,
  dialogs,
  shellapi;

type
  TSharpService = record
    filename: string;
    Dllhandle: Thandle;
    SCMsg: function(msg: string): integer;
    Start: function(owner: hwnd): hwnd;
    Reload: procedure;
    DisplayInfoWnd: procedure;
    Stop: procedure;
  end;
  PSharpService = ^TSharpService;

  // functions to use for loading Plugins
function LoadService(name: Pchar): TSharpService;
function UnLoadService(Service: PsharpService): hresult;

implementation

uses
  uSharpCoreHelperMethods;

function UnLoadService(Service: psharpService): hresult;
begin
  result := 0;
  try
    if Service.dllhandle <> 0 then
      FreeLibrary(Service.dllhandle);
    Service.Start := nil;
    Service.Stop := nil;
    Service.Reload := nil;
    Service.DisplayInfoWnd := nil;
    Service.SCMsg := nil;
    Service.DllHandle := 0;

    FreeLibrary(Service.dllhandle);
    //Service := nil;
    result := 1;
  except
    DError('UnLoadService failed');
  end;
end;

function LoadService(name: Pchar): TSharpService;
begin
  try
    result.filename := name;
    DInfo('Loading Service: ' + name);

    result.dllhandle := LoadLibrary(name);
    if result.dllhandle <> 0 then begin
      @result.Start := GetProcAddress(result.dllhandle, 'Start');
      @result.DisplayInfoWnd := GetProcAddress(result.Dllhandle, 'DisplayInfoWnd');
      @result.Stop := GetProcAddress(result.dllhandle, 'Stop');
      @result.SCMsg := GetProcAddress(result.dllhandle, 'SCMsg');
      @result.Reload := GetProcAddress(result.dllhandle, 'Reload');

      if (@result.Start = nil) then begin
        freelibrary(result.dllhandle);
        result.dllhandle := 0;
        DInfo('Unable to load Service');
      end;
    end;
  except
    result.dllhandle := 0;
    DError('LoadService failed');
  end;
end;
end.

