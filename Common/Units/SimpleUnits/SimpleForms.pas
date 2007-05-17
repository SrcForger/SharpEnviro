{
Source Name: SimpleForms.pas
Description: Simplified Forms.pas
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe

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
