{
Source Name: SimpleForms.pas
Description: Simplified Forms.pas
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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


{
  Some Delphi Units such as Forms.pas are very huge which results in a
  bigger memory usage and binary size for any project using those Units even
  when only a small percentage of the units code is actually used.

  SimpleForms.pas offers replacement functions for some functionality, of the
  original Forms.pas, which doesn't require the usage of Forms.
  Any Project which is not using any Delphi Form should try to use SimpleForms.pas
  instead of Forms.pas in necessary.
}

unit SimpleForms;

interface

function Application_GetExeName: string;

implementation

function Application_GetExeName: string;
begin
  Result := ParamStr(0);
end;

end.
