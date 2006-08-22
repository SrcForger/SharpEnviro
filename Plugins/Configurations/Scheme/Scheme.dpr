{
Source Name: Scheme.dll
Description: Configuration dll for Scheme settings
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
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
library Scheme;

uses
  windows,
  Classes,
  Messages,
  Dialogs,
  sysutils,
  ExtCtrls,
  graphics,
  forms,
  PngSpeedButton,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd},
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  uSharpCenterSectionList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterSectionList.pas',
  uEditSchemeWnd in 'uEditSchemeWnd.pas' {EditSchemeForm},
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';

{$R *.RES}

function Open(const APluginID: Integer; owner: hwnd): hwnd;
begin
  // Specidfy the Service configuration filename
  frmSettingsWnd := TfrmSettingsWnd.Create(nil);
  frmSettingsWnd.InitialiseSettings(APluginID);

  frmSettingsWnd.ParentWindow := owner;
  frmSettingsWnd.Left := 0;
  frmSettingsWnd.Top := 0;
  frmSettingsWnd.BorderStyle := bsNone;
  frmSettingsWnd.Show;

  result := frmSettingsWnd.Handle;
end;

procedure Help;
begin
  SharpApi.HelpMsg('go {docs}\Theme\Scheme.sdoc');
end;

function ConfigDllType: Integer;
begin
  Result := SCU_SERVICE;
end;

function Close(owner: hwnd; SaveSettings: Boolean): boolean;
begin

//  if SaveSettings then

  FreeAndNil(frmSettingsWnd);
  result := True;
end;

procedure BtnAdd(var AButton:TPngSpeedButton);
var
  p:TPoint;
begin
  frmSettingsWnd.AddScheme(nil);
//  p := AButton.ClientOrigin;
//  frmCompItems.mnuAdd.Popup(p.X,p.Y+AButton.Height);
end;

procedure BtnEdit(var AButton:TPngSpeedButton);
begin
  frmSettingsWnd.EditScheme;
end;

procedure BtnDelete(var AButton:TPngSpeedButton);
begin
  frmSettingsWnd.DeleteScheme;
//  frmCompItems.btnDeleteClick(nil);
end;

procedure GetDisplayName(const APluginID:Integer; var ADisplayName:PChar);
begin
  ADisplayName := PChar('Scheme');
end;

exports
  Open,
  Close,
  Help,
  ConfigDllType,

  BtnAdd,
  BtnEdit,
  BtnDelete,
  {BtnMoveUp,
  BtnMoveDown,
  BtnImport,
  BtnExport,
  BtnClear, }

  GetDisplayName;

end.

