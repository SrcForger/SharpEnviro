{
Source Name: SharpArchiveUtils_Adapter.pas
Description: JvInterpreter Adapater Unit
             Adds Basic Archive function support to any script
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

unit SharpArchiveUtils_Adapter;

interface

uses Windows,
     SysUtils,
     JvInterpreter,
     AbUtils,
     AbArcTyp,
     AbBase,
     AbBrowse,
     AbZBrows,
     AbUnzper;


procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses Variants,
     Classes,
     Types,
     Dialogs,
     JclStrings,
     SharpApi;

procedure Adapter_DecompressFile(var Value: Variant; Args: TJvInterpreterArgs);
var
  UnZipper : TAbUnZipper;
  fname : String;
  dir   : String;
  Error : boolean;
  tempdir : String;
begin
  Error := True;
  Value := Error;
  fname := Args.Values[0];
  Dir   := Args.Values[1];
  tempdir := SharpApi.GetSharpeDirectory + 'Temp\';
  if not FileExists(tempdir + fname) then exit;
  Dir := IncludeTrailingBackSlash(Dir);
  UnZipper := TAbUnZipper.Create(nil);
  try
    ForceDirectories(Dir);
    UnZipper.OpenArchive(tempdir + fname);
    UnZipper.ExtractOptions := [eoCreateDirs];
    UnZipper.BaseDirectory := VarToStr(Dir);
    UnZipper.ExtractFiles('*.*');
    UnZipper.CloseArchive;
    Error := False;
  except
  end;
  UnZipper.Free;
  Value := Error;
end;


procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('SharpArchiveUtils','DecompressFile',Adapter_DecompressFile,2,[varString,varString],varBoolean);
  end;
end;

end.
