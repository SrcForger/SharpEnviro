{
Source Name: SharpEBase.pas
Description:
Copyright (C) Malx (Malx@techie.com)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit SharpEBase;

interface
uses Windows,
  Graphics,
  Messages,
  Classes,
  Controls;

const WM_UPDATESKIN = WM_APP + 1500;
  WM_REMOVEMANAGER = WM_APP + 1501;
  WM_ADDMANAGER = WM_APP + 1502;

type
  { TColorScheme = record
    Throbberback  : Tcolor;
    Throbberdark  : Tcolor;
    Throbberlight : Tcolor;
    Throbbertext  : Tcolor;
    WorkAreaback  : Tcolor;
    WorkAreadark  : Tcolor;
    WorkArealight : Tcolor;
    WorkAreatext : Tcolor;
  end;           }

  TSkinTextRecord = record
    FName: string;
    FColor: string;
    FSize: integer;
  end;

  FontRec = packed record
    Color: TColor;
    LogF: LogFont;
  end;

function StringLoadFromStream(stream: TStream): string;
procedure StringSaveToStream(str: string; stream: TStream);
function FontLoadFromStream(stream: TStream): TFont;
procedure FontSaveToStream(font: TFont; stream: TStream);

implementation

procedure StringSaveToStream(str: string; stream: TStream);
var Size: integer;
begin
  Size := length(str);
  stream.WriteBuffer(Size, sizeof(Size));
  stream.WriteBuffer(Pointer(str)^, Size);
end;

function StringLoadFromStream(stream: TStream): string;
var Size: integer;
  str: string;
begin
  Stream.ReadBuffer(Size, sizeof(Size));
  SetString(str, nil, Size);
  Stream.ReadBuffer(Pointer(str)^, Size);
  result := str;
end;

procedure FontSaveToStream(font: TFont; stream: TStream);
var
  fRec: FontRec;
  sz: integer;
begin
  sz := SizeOf(fRec.LogF);
  if Windows.GetObject(Font.Handle, sz, @fRec.LogF) > 0 then
  begin
    stream.Write(sz, SizeOf(Integer));
    fRec.Color := Font.Color;
    stream.Write(fRec, SizeOf(fRec));
  end
  else
  begin
    sz := 0;
    stream.Write(sz, SizeOf(Integer));
  end;
end;

function FontLoadFromStream(stream: TStream): TFont;
var
  fRec: FontRec;
  sz: integer;
begin
  stream.read(sz, SizeOf(Integer));
  result := TFont.create;
  if sz = SizeOf(fRec.LogF) then
  begin
    stream.read(fRec, SizeOf(fRec));
    result.Free;
    result.Handle := CreateFontIndirect(fRec.LogF);
    result.Color := fRec.Color;
  end
end;

end.
