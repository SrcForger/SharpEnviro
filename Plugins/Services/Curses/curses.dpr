{
Source Name: Curse.Dpr
Description: A Curses Service for SharpE
Copyright (C) (2007) Martin Krämer (MartinKraemer@gmx.net)
              (2004) Pixol (Pixol@SharpE-Shell.org)
              (2004) Zack Cerza - zcerza@coe.neu.edu

3rd Party Libraries used: JCL, JVCL
Common: SharpApi, SharpFX

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

library Curses;

{$WARN SYMBOL_DEPRECATED OFF}

uses
  Forms,
  StrUtils,
  SysUtils,
  windows,
  SharpApi,
  uCursesServiceManager in 'uCursesServiceManager.pas',
  uCursesServiceSettings in 'uCursesServiceSettings.pas';

{$E ser}

{$R *.RES}

procedure Stop;
begin
  if IsStarted then
  begin
    FreeAndNil(CursesManager);
    DeallocateHWnd(h);
  End;

  IsStarted := false;
  SystemParametersInfo(SPI_SETCURSORS, 0, nil, SPIF_SENDWININICHANGE);
end;

function Start(owner: hwnd): hwnd;
begin
  IsStarted := True;
  CursesManager := TCursesManager.Create;

  h := allocatehwnd(CursesManager.MessageHandler);

  Result := Application.Handle;
end;

function SCMsg(msg: string): integer;
var
  i : integer;
  s : string;
begin
  result := 0;
  SharpApi.SendDebugMessage('Curses','Received message : '+msg,0);
  i := length('Load Cursor:');
  if (LeftStr(msg,i) = 'Load Cursor:') then
  begin
    if IsStarted then
    begin
      try
        s := RightStr(msg,length(msg)-i);
        SharpApi.SendDebugMessage('Curses','Loading Cursor with ID '+s+ ' by message' ,0);
        CursesManager.FCursesSettings.CurrentSkin := s;
        CursesManager.FCursesSettings.Save;
        CursesManager.UpdateCursorInfo;
        CursesManager.ApplySkin;
      except
      end;
    end;
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  SCMsg,
  Start,
  Stop;

end.

