{
Source Name: SharpImageUtils.pas
Description: Image loading related help Functions
Copyright (C) Malx <>
              Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpImageUtils;

interface

uses
  GR32,JPeg,SharpIconUtils,SysUtils;

function LoadImage(Image : String; Bmp : TBitmap32) : Boolean;

implementation

function LoadImage(Image : String; Bmp : TBitmap32) : Boolean;
var
  Ext : String;
begin
  result := SharpIconUtils.IconStringToIcon(Image,Image,Bmp);
  if (not result) then
  begin
    if FileExists(Image) then
    begin
      Ext := ExtractFileExt(Image);
      if CompareText(Ext,'.bmp') = 0 then
      begin
        Bmp.LoadFromFile(Image);
        result := True;
      end else
      if (CompareText(Ext,'.jpg') = 0) or (CompareText(Ext,'.jpeg') = 0) then
      begin
        Bmp.LoadFromFile(Image);
        result := True;
      end;
    end;
  end;
end;

end.
