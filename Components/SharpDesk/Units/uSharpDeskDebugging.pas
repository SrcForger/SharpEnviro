{
Source Name: uSharpDeskDebugging.pas
Description: Debugging Unit
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

unit uSharpDeskDebugging;

interface

uses Forms,
     Graphics,
     SysUtils,
     SharpApi;

procedure DebugFree(pObject : TObject);

implementation

procedure DebugFree(pObject : TObject);
var
  className : String;
begin
  if pObject = nil then exit;
  try
    className := pObject.ClassName;
    pObject.Free;
    pObject := nil;
  except
    on E: Exception do 
    begin
      SharpApi.SendDebugMessageEx('ClassManager',PChar('Failed to free [' + className + '] in [' + Application.ExeName+']'),clred,DMT_ERROR);
      SharpApi.SendDebugMessageEx('ClassManager',PChar('Error message : ' + E.message),clred,DMT_ERROR);      
    end;
  end;
end;

end.
