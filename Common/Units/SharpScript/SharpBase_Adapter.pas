{
Source Name: SharpBase_Adapter.pas
Description: JvInterpreter Adapater Unit
             Adds Base function support to any script
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

unit SharpBase_Adapter;

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
     DateUtils;

procedure Adapter_Sleep(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Sleep(Args.Values[0]);
end;

procedure Adapter_IntToStr(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := inttostr(Args.Values[0]);
  except
    Value := '';
  end;
end;

procedure Adapter_StrToInt(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := strtoint(Args.Values[0]);
  except
    Value := 0;
  end;
end;


procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('SharpBase','Sleep',Adapter_Sleep,1,[varInteger],varEmpty);
    AddFunction('SharpBase','IntToStr',Adapter_IntToStr,1,[varInteger],varString);
    AddFunction('SharpBase','StrToInt',Adapter_StrToInt,1,[varString],varInteger);
  end;
end;

end.
