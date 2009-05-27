{
Source Name: SharpEDefault.pas
Description: Default classes
Copyright (C) Malx (Malx@techie.com)
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

unit SharpEDefault;

interface

uses
  Graphics,
  SharpEScheme;

var
  DefaultSharpEScheme: TSharpEScheme;

procedure AssignDefaultFontTo(pFont : TFont);

implementation

procedure AssignDefaultFontTo(pFont : TFont);
begin
  pFont.Name  := 'Small Fonts';
  pFont.Size  := 7;
  pFont.Color := 0;
end;

initialization
//SharpESkin
  DefaultSharpEScheme := TSharpEScheme.Create(True);

finalization
  DefaultSharpEScheme.SelfInterface := nil;

end.
