{
Source Name: Prism.service
Description: Service for memory and cpu optimisation
Copyright (C) Lee Green <Pixol@sharpe-shell.org>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 6
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
library Prism;

uses
  windows,
  Classes,
  Messages,
  Dialogs,
  sysutils,
  ExtCtrls,
  graphics,
  forms,
  JvComponent,
  JvSimpleXml,
  SharpApi,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd},
  uPrismSettings in 'uPrismSettings.pas',
  uSharpCenterSectionList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterSectionList.pas';

{$R *.RES}

function Open(const APluginID: Integer; owner: hwnd): hwnd;
var
  s: string;
begin
  // Specidfy the Service configuration filename
  s := GetSharpeUserSettingsPath +
    'SharpCore\Services\Prism\Prism.xml';

  PrismSettings := TPrismSettings.Create(s);

  frmSettingsWnd := TfrmSettingsWnd.Create(nil);
  frmSettingsWnd.InitialiseSettings;

  frmSettingsWnd.ParentWindow := owner;
  frmSettingsWnd.Left := 0;
  frmSettingsWnd.Top := 0;
  frmSettingsWnd.BorderStyle := bsNone;
  frmSettingsWnd.Show;

  result := frmSettingsWnd.Handle;
end;

procedure Help;
begin
  SharpApi.HelpMsg('go {docs}\SharpCore\Services\Prism.sdoc');
end;

function ConfigDllType: Integer;
begin
  Result := SCU_SERVICE;
end;

function Close(owner: hwnd; SaveSettings: Boolean): boolean;
begin

  if SaveSettings then
    PrismSettings.Save;

  FreeAndNil(frmSettingsWnd);
  FreeAndNil(PrismSettings);
  result := True;
end;

procedure GetDisplayName(const APluginID:Integer; var ADisplayName:PChar);
begin
  ADisplayName := PChar('Prism');
end;

exports
  Open,
  Close,
  Help,
  ConfigDllType,

  {BtnAdd,
  BtnEdit,
  BtnDelete,
  BtnMoveUp,
  BtnMoveDown,
  BtnImport,
  BtnExport,
  BtnClear, }

  GetDisplayName;

end.

