{
Source Name: ObjectList
Description: Objects List Config Dll
Copyright (C)
              Pixol (lee@sharpe-shell.org)

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

library ObjectList;
uses
  SysUtils,
  Controls,
  Classes,
  SharpApi,
  Windows,
  Forms,
  Dialogs,
  uConfigListWnd in 'uConfigListWnd.pas' {frmConfigListWnd},
  uSharpCenterSectionList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterSectionList.pas',
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Integer; owner: hwnd): hwnd;
begin

  if frmConfigListWnd = nil then
    frmConfigListWnd := TfrmConfigListWnd.Create(nil);

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
  //SharpApi.HelpMsg('go {docs}\SharpCore\Services\Components.sdoc');
end;

procedure GetDisplayName(const APluginID: Integer; var ADisplayName: PChar);
begin
  ADisplayName := PChar('Objects');
end;

procedure ChangeSection(const ASection:TSectionObject);
begin
end;

procedure AddSections(var AList: TSectionObjectList; var AItemHeight: Integer);
begin
  frmConfigListWnd.PopulateObjectTypes(AList);
end;

exports
  Open,
  Close,
  Help,
  GetDisplayname,

  AddSections,
  ChangeSection;

end.

