{
Source Name: TaskModule.dpr
Description: TaskModule Config
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

library TaskModule;
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
  uEditWnd in 'uEditWnd.pas' {frmEdit},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  pluginId: string;
  barId: string;
  moduleId: string;
begin
  {$REGION 'Form Creation'}
    if frmEdit = nil then
        frmEdit := TfrmEdit.Create(nil);
      frmEdit.ParentWindow := aowner;
      frmEdit.Left := 0;
      frmEdit.Top := 0;
      frmEdit.BorderStyle := bsNone;
      frmEdit.Show;
      uVistaFuncs.SetVistaFonts(frmEdit);
  {$ENDREGION}

  {$REGION 'Get plugin and module id'}
    pluginId := APluginID;
      barId := copy(pluginId, 0, pos(':',pluginId)-1);
      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
      frmEdit.BarId := barId;
      frmEdit.ModuleId := moduleId;
  {$ENDREGION}

  frmEdit.LoadSettings;
  result := frmEdit.Handle;
end;

function Close: boolean;
begin
  result := True;
  try
    frmEdit.Close;
    frmEdit.Free;
    frmEdit := nil;
  except
    result := False;
  end;
end;

procedure Save;
begin
  frmEdit.SaveSettings;
end;

procedure SetText(const APluginID: string; var AName: string; var AStatus: string;
  var ATitle: string; var ADescription: string);
begin
  AName := 'Task Options';
  AStatus := '';
  ATitle := 'Task Module';
  ADescription := 'Configure Task Module';

end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Task Module';
    Description := 'Task Module Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suTaskFilter)]);
  end;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin

  if frmEdit <> nil then begin
    frmEdit.lbItems.Colors.ItemColor := AItemColor;
    frmEdit.lbItems.Colors.CheckColor := AItemColor;
    frmEdit.lbItems.Colors.ItemColorSelected := AItemSelectedColor;
    frmEdit.lbItems.Colors.CheckColorSelected := AItemSelectedColor;

  end;
end;

exports
  Open,
  Close,
  Save,
  SetText,
  GetMetaData,
  GetCenterScheme;

begin
end.

