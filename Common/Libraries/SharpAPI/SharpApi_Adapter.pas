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

uses JvInterpreter, Classes, SysUtils;

procedure UnregisterAPILog;
procedure RegisterAPILog(pLog : TStrings);
procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses Variants,SharpApi;

var
  FLog : TStrings;
  FLogEnabled : boolean;

procedure UnregisterAPILog;
begin
  FLogEnabled := False;
  FLog := nil;
end;

procedure RegisterAPILog(pLog : TStrings);
begin
  FLogEnabled := True;
  FLog := pLog;
end;

procedure AddLog(logmsg : String);
begin
  if not FLogEnabled then exit;
  
  try
    if FLog <> nil then FLog.Add(logmsg);
  except
    FLog := nil;
  end;
end;

procedure Adapter_GetSharpeDirectory(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := String(GetSharpeDirectory);
  except
    AddLog('Failed to get SharpE Directory');
  end;
end;

procedure Adapter_GetSharpeUserSettingsPath(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := String(GetSharpeUserSettingsPath);
  except
    AddLog('Failed to get SharpE User Settings Path');
  end;
end;

procedure Adapter_GetSharpeGlobalSettingsPath(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := String(GetSharpeGlobalSettingsPath);
  except
    AddLog('Failed to get SharpE Global Settings Path');
  end;
end;

procedure Adapter_IsComponentRunning(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := IsComponentRunning(PChar(VarToStr(Args.Values[0])));
    AddLog('IsComponentRunning("'+VarToStr(Args.Values[0])+'") -> ' + BoolToStr(Value,True));
  except
    AddLog('Failed to call IsComponentRunning("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_FindComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := FindComponent(PChar(VarToStr(Args.Values[0])));
    AddLog('FindComponent("'+VarToStr(Args.Values[0])+'") -> ' + BoolToStr(Value,True));
  except
    AddLog('Failed to call FindComponent("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_CloseComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := CloseComponent(PChar(VarToStr(Args.Values[0])));
    if Value then AddLog('Component "'+VarToStr(Args.Values[0])+'" closed.')
       else AddLog('Failed to close component "'+VarToStr(Args.Values[0])+'"');
  except
    AddLog('Failed to call CloseComponent("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_StartComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    AddLog('Starting component "'+VarToStr(Args.Values[0])+'"');
    StartComponent(PChar(VarToStr(Args.Values[0])));
  except
    AddLog('Failed to call StartComponent("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_TerminateComponent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    AddLog('Terminating component "'+VarToStr(Args.Values[0])+'"');
    TerminateComponent(PChar(VarToStr(Args.Values[0])));
  except
    AddLog('Failed to call TerminateComponent("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_SharpExecute(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := SharpExecute(PChar(VarToStr(Args.Values[0])));
    AddLog('SharpExecute("'+VarToStr(Args.Values[0])+'") -> ' + IntToStr(Value));
  except
    AddLog('Failed to call SharpExecute("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_ServiceStart(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := SharpApi.ServiceStart(PChar(VarToStr(Args.Values[0])));
    AddLog('ServiceStart("'+VarToStr(Args.Values[0])+'") -> ' + IntToStr(Value));
  except
    AddLog('Failed to call ServiceStart("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_ServiceStop(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := SharpApi.ServiceStop(PChar(VarToStr(Args.Values[0])));
    AddLog('ServiceStop("'+VarToStr(Args.Values[0])+'") -> ' + IntToStr(Value));
  except
    AddLog('Failed to call ServiceStop("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_ServiceMsg(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := SharpApi.ServiceMsg(PChar(VarToStr(Args.Values[0])),PChar(VarToStr(Args.Values[1])));
    AddLog('ServiceMsg("'+VarToStr(Args.Values[0])+'") -> ' + IntToStr(Value));
  except
    AddLog('Failed to call ServiceMsg("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_IsServiceStarted(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := SharpApi.IsServiceStarted(PChar(VarToStr(Args.Values[0])));
    AddLog('IsServiceStarted("'+VarToStr(Args.Values[0])+'") -> ' + IntToStr(Value));
  except
    AddLog('Failed to call IsServiceStarted("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_SharpEBroadCast(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := SharpApi.SharpEBroadCast(Args.Values[0],Args.Values[1],Args.Values[2]);
    AddLog('SharpEBroadCast("'+VarToStr(Args.Values[0])+',' +VarToStr(Args.Values[1])+','+VarToStr(Args.Values[2])+'") -> ' + IntToStr(Value));
  except
    AddLog('IsServiceStarted("'+VarToStr(Args.Values[0])+'") -> ' + IntToStr(Value));
  end;
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

    AddConst('SharpApi','WM_SHARPEUPDATESETTINGS',WM_SHARPEUPDATESETTINGS);
    AddConst('SharpApi','WM_WEATHERUPDATE',WM_WEATHERUPDATE);
    AddConst('SharpApi','WM_DESKBACKGROUNDCHANGED',WM_DESKBACKGROUNDCHANGED);
    AddConst('SharpApi','WM_SHARPTERMINATE',WM_SHARPTERMINATE);

    AddConst('SharpApi','SU_SKIN',SU_SKIN);
    AddConst('SharpApi','SU_SKINFILECHANGED',SU_SKINFILECHANGED);
    AddConst('SharpApi','SU_SCHEME',SU_SCHEME);
    AddConst('SharpApi','SU_THEME',SU_THEME);
    AddConst('SharpApi','SU_ICONSET',SU_ICONSET);
    AddConst('SharpApi','SU_BACKGROUND',SU_BACKGROUND);
    AddConst('SharpApi','SU_SERVICE',SU_SERVICE);
    AddConst('SharpApi','SU_DESKTOPICON',SU_DESKTOPICON);
    AddConst('SharpApi','SU_SHARPDESK',SU_SHARPDESK);
    AddConst('SharpApi','SU_SHARPMENU',SU_SHARPMENU);
    AddConst('SharpApi','SU_SHARPBAR',SU_SHARPBAR);
    AddConst('SharpApi','SU_CURSOR',SU_CURSOR);
    AddConst('SharpApi','SU_WALLPAPER',SU_WALLPAPER);

    AddFunction('SharpApi','GetSharpEDirectory',Adapter_GetSharpeDirectory,0,[],varString);
    AddFunction('SharpApi','GetSharpeUserSettingsPath',Adapter_GetSharpeUserSettingsPath,0,[],varString);
    AddFunction('SharpApi','GetSharpeGlobalSettingsPath',Adapter_GetSharpeGlobalSettingsPath,0,[],varString);
    
    AddFunction('SharpApi','IsComponentRunning',Adapter_IsComponentRunning,1,[varString],varBoolean);
    AddFunction('SharpApi','FindComponent',Adapter_FindComponent,1,[varString],varLongWord);
    AddFunction('SharpApi','CloseComponent',Adapter_CloseComponent,1,[varString],varBoolean);
    AddFunction('SharpApi','TerminateComponent',Adapter_TerminateComponent,1,[varString],varEmpty);
    AddFunction('SharpApi','StartComponent',Adapter_StartComponent,1,[varString],varEmpty);

    AddFunction('SharpApi','Execute',Adapter_SharpExecute,1,[varString],varInteger);
    AddFunction('SharpApi','BroadCastMessage',Adapter_SharpEBroadCast,3,[varInteger,varInteger,varInteger],varInteger);

    AddFunction('SharpApi','ServiceStart',Adapter_ServiceStart,1,[varString],varInteger);
    AddFunction('SharpApi','ServiceStop',Adapter_ServiceStop,1,[varString],varInteger);
    AddFunction('SharpApi','ServiceMsg',Adapter_ServiceMsg,1,[varString,varString],varInteger);
    AddFunction('SharpApi','IsServiceStarted',Adapter_IsServiceStarted,1,[varString],varInteger);
  end;
end;

end.
