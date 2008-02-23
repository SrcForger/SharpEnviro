{
Source Name: DeskArea
Description: DeskArea Configuration
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

library Home;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uHomeWnd in 'uHomeWnd.pas' {frmHome},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas';

{$E .dll}

{$R *.res}

function GetControlByHandle(AHandle: THandle): TWinControl;
  begin
    Try
      Result := Pointer(GetProp(AHandle,
      PChar(Format('Delphi%8.8x', [GetCurrentProcessID]))));
    Except
      Result := nil;
    End;
  end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmHome = nil then frmHome := TfrmHome.Create(nil);
  uVistaFuncs.SetVistaFonts(frmHome);

  frmHome.ParentWindow := aowner;
  frmHome.Left := 0;
  frmHome.Top := 0;

  frmHome.Show;
  result := frmHome.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmHome.Close;
    frmHome.Free;
    frmHome := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);

begin
  ATitle := 'SharpEnviro 0.74 TD4 R2';
  ADescription := 'Welcome to SharpCenter. The ultimate configurator for SharpE.';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Home';
    Description := 'Home Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suCenter)]);
  end;
end;

exports
  Open,
  Close,
  GetMetaData,
  SetText;

end.

