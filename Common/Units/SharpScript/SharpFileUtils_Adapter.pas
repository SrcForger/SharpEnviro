{
Source Name: SharpFileUtils_Adapter.pas
Description: JvInterpreter Adapater Unit
             Adds Basic File Util function support to any script
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

unit SharpFileUtils_Adapter;

interface

uses Windows,
     Classes,
     SysUtils,
     JclFileUtils,
     JvInterpreter;

const
  VersionInfo: array[1..8] of string = (
    'CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
    'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion');

procedure RegisterFileUtilsLog(pLog : TStrings);
procedure UnregisterFileUtilsLog;
function GetFileInfo(FName, InfoType: string): string;
procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses Variants,
     Types,
     JclStrings,
     SharpApi;

var
  FLog : TStrings;
  FLogEnabled : boolean;

procedure UnregisterFileUtilsLog;
begin
  FLogEnabled := False;
  FLog := nil;
end;

procedure RegisterFileUtilsLog(pLog : TStrings);
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

function GetFileInfo(FName, InfoType: string): string;
var
  Info: Pointer;
  InfoData: Pointer;
  InfoSize: LongInt;
  InfoLen: {$IFDEF WIN32}DWORD;
{$ELSE}LongInt;
{$ENDIF}
  DataLen: {$IFDEF WIN32}UInt;
{$ELSE}word;
{$ENDIF}
  LangPtr: Pointer;
begin
  result := '';
  DataLen := 255;
  if Length(FName) <= 0 then
    exit;
  FName := FName + #0;
  InfoSize := GetFileVersionInfoSize(@Fname[1], InfoLen);
  if (InfoSize > 0) then
  begin
    GetMem(Info, InfoSize);
    try
      if GetFileVersionInfo(@FName[1], InfoLen, InfoSize, Info) then
      begin
        if VerQueryValue(Info, '\VarFileInfo\Translation', LangPtr, DataLen)
          then
          InfoType := Format('\StringFileInfo\%0.4x%0.4x\%s'#0,
            [LoWord(LongInt(LangPtr^)),
            HiWord(LongInt(LangPtr^)), InfoType]);
        if VerQueryValue(Info, @InfoType[1], InfoData, Datalen) then
          Result := strPas(InfoData);
      end;
    finally
      FreeMem(Info, InfoSize);
    end;
  end;
end;

procedure Adapter_CopyFile(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := CopyFile(PChar(VarToStr(Args.Values[0])),
                      PChar(VarToStr(Args.Values[1])),
                      not Args.Values[2]);
    if Value then AddLog('File copied from: ('+VarToStr(Args.Values[0])+') to: ('+VarToStr(Args.Values[1])+')')
       else AddLog('Failed to copy file from: ('+VarToStr(Args.Values[0])+') to: ('+VarToStr(Args.Values[1])+')');
  except
    AddLog('Failed to call CopyFile "'+VarToStr(Args.Values[0])+'" -> "' +VarToStr(Args.Values[1])+'"');
  end;
end;

procedure Adapter_CopyFiles(var Value: Variant; Args: TJvInterpreterArgs);
var
  sDirFrom, sDirTo, sSrcExtension, sDestExtension, sFileFrom, sFileTo: String;
  bReplace, bOk: Boolean;
  strl:TStringList;
  i:Integer;
begin
  strl := TStringList.Create;
  try
    try
      sDirFrom := VarToStr(Args.Values[0]);
      sDirTo := VarToStr(Args.Values[1]);
      sSrcExtension := VarToStr(Args.Values[2]);
      sDestExtension := VarToStr(Args.Values[3]);
      bReplace := Not(Args.Values[4]);

      AdvBuildFileList(sDirFrom+'*.*',faAnyFile,strl,amAny,[flFullNames],'',nil);

      for i := 0 to Pred(strl.Count) do begin

        if ExtractFileExt(strl[i]) = sSrcExtension then begin

          sFileFrom := strl[i];
          sFileTo := PathAddSeparator(sDirTo)+ExtractFileName(strl[i]);

          if sDestExtension <> '' then
            sFileTo := ChangeFileExt(sFileTo,sDestExtension);

          bOk := CopyFile(PChar(sFileFrom), PChar(sFileTo), bReplace);
          if bOk then AddLog(Format('File copied from: (%s) to: %s',[sFileFrom,sFileTo])) else
          AddLog(Format('Failed to copy from: (%s) to: %s',[sFileFrom,sFileTo]));
        end;
      end;

  except
    AddLog('Failed to call CopyFile "'+VarToStr(Args.Values[0])+'" -> "' +VarToStr(Args.Values[1])+'"');
  end;

  finally
    strl.Free;
  end;
end;

procedure Adapter_DeleteFile(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := DeleteFile(VarToStr(Args.Values[0]));
    if Value then AddLog('Delete file: ('+VarToStr(Args.Values[0])+')')
       else AddLog('Failed to delete file: ('+VarToStr(Args.Values[0])+')');
  except
    AddLog('Failed to call DeleteFile("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapter_FileExists(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := FileExists(VarToStr(Args.Values[0]));
    AddLog('FileExists("'+VarToStr(Args.Values[0])+'") -> ' + BoolToStr(Value,True));
  except
    AddLog('Failed to call FileExists("'+VarToStr(Args.Values[0])+'")');
  end;
end;

procedure Adapater_GetFileVersionAsString(var Value: Variant; Args: TJvInterpreterArgs);
var
  fname : string;
begin
  fname := VarToStr(Args.Values[0]);
  if FileExists(fname) then
     Value := GetFileInfo(fname,'FileVersion')
     else Value := '';
end;

// result: 0 = equal
//        -1 = first version is newer than second
//         1 = first version is older than second
procedure Adapter_CompareVersion(var Value: Variant; Args: TJvInterpreterArgs);
var
  SList : TStringList;
  f1,s1,t1,l1 : integer;
  f2,s2,t2,l2 : integer;
  i,n : integer;
begin
  SList := TStringList.Create;
  SList.Clear;

  JclStrings.StrTokenToStrings(VarToStr(Args.Values[0]),'.',SList);
  try
    f1 := StrToInt(SList[0]);
    s1 := StrToInt(SList[1]);
    t1 := StrToInt(SList[2]);
    l1 := StrToInt(Slist[3]);
  except
    f1 := 0;
    s1 := 0;
    t1 := 0;
    l1 := 0;
  end;

  SList.Clear;
  JclStrings.StrTokenToStrings(VarToStr(Args.Values[1]),'.',SList);
  try
    f2 := StrToInt(SList[0]);
    s2 := StrToInt(SList[1]);
    t2 := StrToInt(SList[2]);
    l2 := StrToInt(Slist[3]);
  except
    f2 := 0;
    s2 := 0;
    t2 := 0;
    l2 := 0;
  end;

  i := 1000000 * f1 + 10000*s1 + 100*t1 + l1;
  n := 1000000 * f2 + 10000*s2 + 100*t2 + l2;
  if i = n then Value := 0
     else if i <n then Value := -1
     else Value := 1;

  Slist.Free;
end;

procedure Adapter_CreateDirectory(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ForceDirectories(VarToStr(Args.Values[0]));
end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('SharpFileUtils','CopyFile',Adapter_CopyFile,3,[varString,varString,varBoolean],varBoolean);
    AddFunction('SharpFileUtils','CopyFiles',Adapter_CopyFiles,5,[varString,varString,varString,varString,varBoolean],varBoolean);
    AddFunction('SharpFileUtils','DeleteFile',Adapter_DeleteFile,1,[varString],varBoolean);
    AddFunction('SharpFileUtils','FileExists',Adapter_FileExists,1,[varString],varBoolean);
    AddFunction('SharpFileUtils','CreateDirectory',Adapter_CreateDirectory,0,[varString],varEmpty);
    AddFunction('SharpFileUtils','GetFileVersion',Adapater_GetFileVersionAsString,1,[varString],varString);
    AddFunction('SharpFileUtils','CompareVersions',Adapter_CompareVersion,2,[varString,varString],varInteger);
  end;
end;

end.
