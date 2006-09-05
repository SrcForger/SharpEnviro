{
Source Name: SharpApi_Adapter.pas
Description: JvInterpreter Adapater Unit
             Adds SharpAPI function support to any script
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

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

unit SharpApi_Adapter;

interface

uses JvInterpreter;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses SharpApi;

procedure Adapter_GetSharpeDirectory(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := String(GetSharpeDirectory);
end;

procedure Adapter_GetSharpeUserSettingsPath(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := String(GetSharpeUserSettingsPath);
end;

procedure Adapter_GetSharpeGlobalSettingsPath(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := String(GetSharpeGlobalSettingsPath);
end;



procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
const
  cForms = 'Forms';
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('SharpApi','GetSharpEDirectory',Adapter_GetSharpeDirectory,0,[],varString);
    AddFunction('SharpApi','GetSharpeUserSettingsPath',Adapter_GetSharpeUserSettingsPath,0,[],varString);
    AddFunction('SharpApi','GetSharpeGlobalSettingsPath',Adapter_GetSharpeGlobalSettingsPath,0,[],varString);
  end;
end;

end.
