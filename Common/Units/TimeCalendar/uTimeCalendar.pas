{
Source Name: uTimeCalendar.pas
Description: Shows the built-in Windows calendar
Copyright (C) Mathias Tillman <mathias@sharpenviro.com>

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

unit uTimeCalendar;

interface

uses Windows, Classes, ActiveX, ComObj;

const
  Class_TimeDateCPL: TGUID =
      '{A323554A-0FE1-4E49-AEE1-6722465D799F}';
  IID_TimeDateCPL : TGUID =
      '{A323554A-0FE1-4E49-AEE1-6722465D799F}';

  TimeCalendarWidth: integer = 263;
  TimeCalendarHeight: integer = 241;

type
  ITimeDateCPL = interface(IUnknown)
      ['{4376DF10-A662-420B-B30D-958881461EF9}']
      function ShowCalendar(unk: integer; unk2: PRect): Integer; stdcall;
      function Unknown2: Integer; stdcall;
      function Unknown3: Integer; stdcall;
      function Unknown4: Integer; stdcall;
  end;

  TTimeCalendar = class
  private
    FTimeDateCPL: ITimeDateCPL;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Show(x, y: integer);
    
  end;

implementation

constructor TTimeCalendar.Create;
begin
  FTimeDateCPL := nil;

  CoInitialize(nil);
  OleCheck(CoCreateInstance(
      Class_TimeDateCPL,
      nil,
      CLSCTX_INPROC_SERVER,
      ITimeDateCPL,
      FTimeDateCPL));
end;

destructor TTimeCalendar.Destroy;
begin
  FTimeDateCPL := nil;

  CoUninitialize;
end;

procedure TTimeCalendar.Show(x, y: integer);
var
  rc: TRect;
begin
  if not Assigned(FTimeDateCPL) then
    exit;

  rc := Rect(x+(TimeCalendarWidth div 2), y, x-(TimeCalendarWidth - (TimeCalendarWidth div 2)), y-TimeCalendarHeight);

  FTimeDateCPL.ShowCalendar(0, @rc);
end;

end.
