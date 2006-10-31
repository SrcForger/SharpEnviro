{
Source Name: ThemeList
Description: Theme List Config Dll
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

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

library ThemeList;
uses
  SysUtils,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  PngSpeedButton,
  uConfigListWnd in 'uConfigListWnd.pas' {frmConfigListWnd},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterSectionList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterSectionList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; owner: hwnd): hwnd;
begin
  if frmConfigListWnd = nil then frmConfigListWnd := TfrmConfigListWnd.Create(nil);

  frmConfigListWnd.ParentWindow := owner;
  frmConfigListWnd.Left := 2;
  frmConfigListWnd.Top := 2;
  frmConfigListWnd.BorderStyle := bsNone;
  frmConfigListWnd.Show;
  result := frmConfigListWnd.Handle;
end;

function Close(owner: hwnd; SaveSettings: Boolean): boolean;
begin
  result := True;
  try
    frmConfigListWnd.Close;
    frmConfigListWnd.Free;
    frmConfigListWnd := nil;
  except
    result := False;
  end;
end;

procedure Help;
begin
end;

procedure GetDisplayName(const APluginID: Pchar; var ADisplayName: PChar);
begin
  ADisplayName := PChar('Themes');
end;

procedure BtnAdd(var AButton:TPngSpeedButton);
begin
//  frmConfigListWnd.AddScheme(nil);
end;

procedure BtnEdit(var AButton:TPngSpeedButton);
begin
  if frmConfigListWnd <> nil then frmConfigListWnd.EditTheme
end;

procedure BtnDelete(var AButton:TPngSpeedButton);
begin
//  frmConfigListWnd.DeleteScheme;
end;

exports
  Open,
  Close,
  Help,

//  BtnAdd,
  BtnEdit;
//  BtnDelete;

end.

