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

uses Variants,SharpApi;

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

procedure Adapter_IsComponentRunning(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := IsComponentRunning(PChar(VarToStr(Args.Values[0])));
end;

procedure Adapter_FindComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := FindComponent(PChar(VarToStr(Args.Values[0])));
end;

procedure Adapter_CloseComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := CloseComponent(PChar(VarToStr(Args.Values[0])));
end;

procedure Adapter_TerminateComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TerminateComponent(PChar(VarToStr(Args.Values[0])));
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
    AddFunction('SharpApi','IsComponentRunning',Adapter_IsComponentRunning,1,[varString],varBoolean);
    AddFunction('SharpApi','FindComponent',Adapter_FindComponent,1,[varString],varLongWord);
    AddFunction('SharpApi','CloseComponent',Adapter_CloseComponent,1,[varString],varBoolean);
    AddFunction('SharpApi','TerminateComponent',Adapter_TerminateComponent,1,[varString],varEmpty);
  end;
end;

end.
