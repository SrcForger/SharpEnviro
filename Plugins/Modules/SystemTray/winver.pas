{
Source Name: winver
Description: Not available
Copyright (C) Malx (Malx@techie.com)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main LDI Site
http://www.lowdimension.net

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
unit winver;

interface
uses windows;
type
  //  LongLongWord = 0..18446744073709551615;
  DLLVERSIONINFO = record
    cbSize: DWORD;
    dwMajorVersion: DWORD; // Major version
    dwMinorVersion: DWORD; // Minor version
    dwBuildNumber: DWORD; // Build number
    dwPlatformID: DWORD; // DLLVER_PLATFORM_*
  end;
  DLLVERSIONINFO2 = record
    info1: DLLVERSIONINFO;
    dwFlags: DWORD; // Major version
    ullversion: Int64; // Minor version
  end;

  pDLLVERSIONINFO = ^DLLVERSIONINFO;
  DLLGETVERSIONPROC = function(VersionInfo: pDLLVERSIONINFO): hresult; stdcall;
const
  OS_WIN32 = 0; { WINDOWS 95 OR 98}
  OS_WINNT = 1; { WINDOWS NT}
  OS_WINS = 2; { WIN32 UNDER WIN3.1}
  OS_WINNT4 = 3; { NT 4 }
  OS_WIN2k = 4; { WIN2K }
  OS_WINXP = 5;
  OS_WINME = 6;

function GetWinVer: Integer;
function GetShellVer: Dword;
var
  hinstDll: Thandle;

implementation

function GetDllVersion(lpszDllName: LPCTSTR): DLLVERSIONINFO;
var
  pDllGetVersion: DLLGETVERSIONPROC;
  dvi: DLLVERSIONINFO;
  hr: Hresult;
begin
  ZeroMemory(@result, sizeof(result));
  result.cbSize := sizeof(result);
  hinstDll := LoadLibrary(lpszDllName);
  if (hinstDll <> 0) then
  begin
    @pDllGetVersion := GetProcAddress(hinstDll, 'DllGetVersion');
    if @pDllGetVersion <> nil then
    begin
      ZeroMemory(@dvi, sizeof(dvi));
      dvi.cbSize := sizeof(dvi);
      hr := pDllGetVersion(@dvi);
      if SUCCEEDED(hr) then
      begin
        result := dvi;
      end
    end;
    FreeLibrary(hinstDll);
  end;
end;

function GetShellVer: Dword;
var
  ComCtl32: DLLVERSIONINFO;
  Shell32: DLLVERSIONINFO;
  ShlWapi: DLLVERSIONINFO;

begin
  result := $0200;
  try
    ComCtl32 := GetDllVersion('comctl32.dll');
    Shell32 := GetDllVersion('Shell32.dll');
    ShlWapi := GetDllVersion('ShlWapi.dll');
    if (ComCtl32.dwMajorVersion >= 6) and (Shell32.dwMajorVersion >= 6) and
      (ShlWapi.dwMajorVersion >= 6) then
    begin
      result := $0600;
    end
    else if (ComCtl32.dwMajorVersion >= 5) and (Shell32.dwMajorVersion >= 5) and
      (ShlWapi.dwMajorVersion >= 5) then
    begin
      if (ComCtl32.dwMinorVersion >= 81) then
        result := $0501
      else if (ComCtl32.dwMinorVersion >= 81) then
        result := $0500
      else
        result := $0401;
    end
    else if (ComCtl32.dwMajorVersion >= 4) and (Shell32.dwMajorVersion >= 4)
      then
    begin
      if (ComCtl32.dwMinorVersion >= 72) and (Shell32.dwMinorVersion >= 72) then
        result := $0401
      else if (ComCtl32.dwMinorVersion >= 71) and (Shell32.dwMinorVersion >= 71)
        then
        result := $0400
      else if (ComCtl32.dwMinorVersion >= 70) and (Shell32.dwMinorVersion >= 70)
        then
        result := $0300;
    end;
  except
    result := $0200;
  end;
end;

function GetWinVer: Integer;
var
  OSVerInfo: TOSVersionInfo;
begin
  try
    OSVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
    GetVersionEx(OSVerInfo);
    result := OSVerInfo.dwMajorVersion;
    case OSVerInfo.dwPlatformID of
      VER_PLATFORM_WIN32s: Result := OS_WINS;
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          case OSVerInfo.dwMinorVersion of
            0, 10: result := OS_WIN32;
            90: result := OS_WINME;
          else
            result := OS_WIN32;
          end;
        end;
      VER_PLATFORM_WIN32_NT:
        begin
          case OSVerInfo.dwMajorVersion of
            3: result := OS_WINNT;
            4: result := OS_WINNT4;
            5: case OSverinfo.dwMinorVersion of
                0: result := OS_WIN2K;
                1: result := OS_WINXP;
              else
                result := OS_WIN2K
              end;
          end;
        end
    else
      result := 0;
    end;
  except
    result := -1;
  end;
end;
end.
