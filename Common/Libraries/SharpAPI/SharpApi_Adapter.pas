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

procedure Adapter_StartComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  StartComponent(PChar(VarToStr(Args.Values[0])));
end;

procedure Adapter_TerminateComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TerminateComponent(PChar(VarToStr(Args.Values[0])));
end;

procedure Adapter_SharpExecute(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := SharpExecute(PChar(VarToStr(Args.Values[0])));
end;

procedure Adapter_ServiceStart(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := SharpApi.ServiceStart(PChar(VarToStr(Args.Values[0])));
end;

procedure Adapter_ServiceStop(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := SharpApi.ServiceStop(PChar(VarToStr(Args.Values[0])));
end;

procedure Adapter_ServiceMsg(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := SharpApi.ServiceMsg(PChar(VarToStr(Args.Values[0])),PChar(VarToStr(Args.Values[1])));
end;

procedure Adapter_IsServiceStarted(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := SharpApi.IsServiceStarted(PChar(VarToStr(Args.Values[0])));
end;



procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddConst('SharpApi','SHARPE_DIR',String(GetSharpEDirectory));
    AddConst('SharpApi','SETTINGS_USER_DIR',String(GetSharpeUserSettingsPath));
    AddConst('SharpApi','SETTINGS_GLOBAL_DIR',String(GetSharpEGlobalSettingsPath));

    AddConst('SharpApi','MR_STARTED',MR_STARTED);
    AddConst('SharpApi','MR_STOPPED',MR_STOPPED);
    AddConst('SharpApi','MR_ERRORSTARTING',MR_ERRORSTARTING);
    AddConst('SharpApi','MR_OK',MR_OK);
    AddConst('SharpApi','MR_INCOMPATIBLE',MR_INCOMPATIBLE);
    AddConst('SharpApi','MR_ERRORSTOPPING',MR_ERRORSTOPPING);
    AddConst('SharpApi','MR_STARTED',MR_STARTED);
    AddConst('SharpApi','MR_FORCECONFIGDISABLE',MR_FORCECONFIGDISABLE);

    AddFunction('SharpApi','GetSharpEDirectory',Adapter_GetSharpeDirectory,0,[],varString);
    AddFunction('SharpApi','GetSharpeUserSettingsPath',Adapter_GetSharpeUserSettingsPath,0,[],varString);
    AddFunction('SharpApi','GetSharpeGlobalSettingsPath',Adapter_GetSharpeGlobalSettingsPath,0,[],varString);
    
    AddFunction('SharpApi','IsComponentRunning',Adapter_IsComponentRunning,1,[varString],varBoolean);
    AddFunction('SharpApi','FindComponent',Adapter_FindComponent,1,[varString],varLongWord);
    AddFunction('SharpApi','CloseComponent',Adapter_CloseComponent,1,[varString],varBoolean);
    AddFunction('SharpApi','TerminateComponent',Adapter_TerminateComponent,1,[varString],varEmpty);
    AddFunction('SharpApi','StartComponent',Adapter_StartComponent,1,[varString],varEmpty);

    AddFunction('SharpApi','Execute',Adapter_SharpExecute,1,[varString],varInteger);

    AddFunction('SharpApi','ServiceStart',Adapter_ServiceStart,1,[varString],varInteger);
    AddFunction('SharpApi','ServiceStop',Adapter_ServiceStop,1,[varString],varInteger);
    AddFunction('SharpApi','ServiceMsg',Adapter_ServiceMsg,1,[varString,varString],varInteger);
    AddFunction('SharpApi','IsServiceStarted',Adapter_IsServiceStarted,1,[varString],varInteger);
  end;
end;

end.
