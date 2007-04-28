{
Source Name: DeskArea.dpr
Description: DeskArea Service
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.SharpE-Shell.org

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

library DeskArea;
uses
  windows,
  SysUtils,
  uDeskAreaManager in 'uDeskAreaManager.pas';

var
  DeskAreaManager : TDeskAreaManager;

{$E ser}

{$R *.RES}

procedure Stop;
begin
  DeskAreaManager.Free;
end;

function Start(owner: hwnd): hwnd;
begin
  DeskAreaManager := TDeskAreaManager.Create;
  DeskAreaManager.LoadSettings;
  Result := owner;
end;

function SCMsg(msg: string): integer;
begin
  Result := 0;

  if CompareText(msg,'Update') = 0 then
     DeskAreaManager.SetDeskArea;
end;


exports
  Start,
  Stop,
  SCMsg;

end.


