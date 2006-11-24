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
  uSchemeListWnd in 'uSchemeListWnd.pas' {frmSchemeList},
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  uSharpCenterSectionList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterSectionList.pas',
  uEditSchemeWnd in 'uEditSchemeWnd.pas' {frmEditScheme},
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  uSchemeList in 'uSchemeList.pas';

{$R *.RES}

function Open(const APluginID: PChar; owner: hwnd): hwnd;
begin
  // Specidfy the Service configuration filename
  frmSchemeList := TfrmSchemeList.Create(nil);
  frmSchemeList.InitialiseSettings(APluginID);

  frmSchemeList.ParentWindow := owner;
  frmSchemeList.Left := 0;
  frmSchemeList.Top := 0;
  frmSchemeList.BorderStyle := bsNone;
  frmSchemeList.Show;

  result := frmSchemeList.Handle;
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
var
  b:Boolean;
begin

  if SaveSettings then begin
    b := frmSchemeList.SaveSchemes;

    if b then begin
      FreeAndNil(frmSchemeList);
      Result := True;
    end else
      Result := False;
    end else begin
      FreeAndNil(frmSchemeList);
      Result := True;
    end;
end;

procedure BtnAdd(var AButton:TPngSpeedButton);
begin
  frmSchemeList.AddScheme;
end;

procedure BtnEdit(var AButton:TPngSpeedButton);
begin
  frmSchemeList.EditScheme;
end;

procedure BtnDelete(var AButton:TPngSpeedButton);
begin
  frmSchemeList.DeleteScheme;
end;

procedure GetDisplayName(const APluginID:PChar; var ADisplayName:PChar);
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

