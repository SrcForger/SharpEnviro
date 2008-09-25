{
Source Name: Clock
Description: Clock Module Config Dll
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

library Clock;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvSimpleXml,
  GR32,
  GR32_Image,
  JvPageList,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uClockWnd in 'uClockWnd.pas' {frmClock},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpDialogs in '..\..\..\Common\Libraries\SharpDialogs\SharpDialogs.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas';

{$E .dll}

{$R *.res}

procedure Save;
begin
  if frmClock <> nil then
    frmClock.Save;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  barId,moduleId : String;
begin
  GetBarModuleIds( APluginId, barId, moduleId );

  if frmClock = nil then frmClock := TfrmClock.Create(nil);
  SetVistaFonts(frmClock);

  frmClock.BarID := barId;
  frmClock.ModuleID := moduleId;

  with frmClock do begin
    frmClock.ParentWindow := aowner;
    frmClock.Left := 0;
    frmClock.Top := 0;
    frmClock.BorderStyle := bsNone;
  end;
  result := frmClock.Handle;

  frmClock.Load;
  frmClock.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmClock.Close;
    frmClock.Free;
    frmClock := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ADescription: String);
begin
  AName := 'Clock';
  ADescription := 'Configure formatting options for the clock module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Clock';
    Description := 'Clock Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.5.2';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure GetCenterTheme(const ATheme: TCenterThemeInfo; const AEdit: Boolean);
begin
  AssignThemeToForm(ATheme,frmClock);
end;


exports
  Open,
  Close,
  Save,
  SetText,
  GetCenterTheme,
  GetMetaData;

begin
end.

