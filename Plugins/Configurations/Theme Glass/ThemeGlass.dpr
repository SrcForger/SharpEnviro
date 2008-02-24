{
Source Name: ThemeGlass.dpr
Description: Glass skin options
Copyright (C) Lee Green (lee@sharpenviro.com)

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

library ThemeGlass;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uOptionsWnd in 'uOptionsWnd.pas' {frmOptions},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  uSchemeList in '..\Scheme\uSchemeList.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmOptions = nil then
    frmOptions := TfrmOptions.Create(nil);

  uVistaFuncs.SetVistaFonts(frmOptions);
  frmOptions.PluginID := APluginID;
  frmOptions.ParentWindow := aowner;
  frmOptions.Left := 0;
  frmOptions.Top := 0;
  frmOptions.BorderStyle := bsNone;
  frmOptions.Show;

  result := frmOptions.Handle;
end;

function Close: boolean;
begin
  result := True;
  try
    frmOptions.Close;
    frmOptions.Free;
    frmOptions := nil;
  except
    result := False;
  end;
end;

procedure Save;
begin
  frmOptions.Save;
end;

procedure SetText(const APluginID: string; var AName: string; var AStatus: string;
  var ATitle: string; var ADescription: string);
begin
  AName := 'Glass';
  ATitle := Format('Glass Skin Configuration for "%s"',[APluginID]);
  ADescription := 'Define glass options for the currently loaded glass skin.';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Glass';
    Description := 'Glass Skin Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suScheme)]);
  end;
end;

exports
  Open,
  Close,
  Save,
  SetText,
  GetMetaData;

begin
end.

