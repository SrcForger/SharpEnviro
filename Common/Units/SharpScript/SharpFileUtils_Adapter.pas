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
     SysUtils,
     JvInterpreter;

implementation

uses Variants,SharpApi;

procedure Adapter_CopyFile(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := CopyFile(PChar(VarToStr(Args.Values[0])),
                    PChar(VarToStr(Args.Values[1])),
                    Args.Values[2]);
end;

procedure Adapter_DeleteFile(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := DeleteFile(VarToStr(Args.Values[0]));
end;

procedure Adapter_FileExists(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := FileExists(VarToStr(Args.Values[0]));
end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('SharpFileUtils','CopyFile',Adapter_CopyFile,3,[varString,varString,varBoolean],varBoolean);
    AddFunction('SharpFileUtils','DeleteFile',Adapter_DeleteFile,1,[varString],varBoolean);
    AddFunction('SharpFileUtils','FileExists',Adapter_FileExists,1,[varString],varBoolean);
  end;
end;

end.
