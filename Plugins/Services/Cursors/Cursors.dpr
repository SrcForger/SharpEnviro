{
Source Name: Cursors.Dpr
Description: A Cursor Service for SharpE
Copyright (C) (2007) Martin Krämer (MartinKraemer@gmx.net)
              (2004) Pixol (Pixol@SharpE-Shell.org)
              (2004) Zack Cerza - zcerza@coe.neu.edu

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

library Cursors;

{$WARN SYMBOL_DEPRECATED OFF}

uses
//  VCLFixPack,
  Forms,
  Classes,
  StrUtils,
  SysUtils,
  windows,
  SharpApi,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uCursorsServiceManager in 'uCursorsServiceManager.pas',
  uCursorsServiceSettings in 'uCursorsServiceSettings.pas';

{$R 'VersionInfo.res'}
{$R *.RES}

procedure Stop;
begin
  if IsStarted then
  begin
    FreeAndNil(CursorsManager);
    DeallocateHWnd(h);
  End;

  IsStarted := false;
  SystemParametersInfo(SPI_SETCURSORS, 0, nil, SPIF_SENDWININICHANGE);
end;

function Start(owner: hwnd): hwnd;
begin
  IsStarted := True;
  CursorsManager := TCursorsManager.Create;

  h := allocatehwnd(CursorsManager.MessageHandler);
  ServiceDone('Cursors');
  Result := Application.Handle;
end;

function SCMsg(msg: string): integer;
begin
  result := 0;

  if IsStarted then
  begin
    if msg = '_reload' then
    begin
      CursorsManager.UpdateCursorInfo;
      CursorsManager.ApplySkin;
    end else
      SharpApi.SendDebugMessage('Cursors','Received unhandled message : ' + msg,0);
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Cursors';
    Description := 'Changes the standard windows cursors to a fancier skinned set';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteService;
    ExtraData := 'priority: 110| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  SCMsg,
  Start,
  Stop,
  GetMetaData;

begin
end.

