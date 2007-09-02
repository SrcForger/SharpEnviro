{
Source Name: SharpImageUtils.pas
Description: Image loading related help Functions
Copyright (C) Malx <>
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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
