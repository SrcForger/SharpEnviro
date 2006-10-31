{
Source Name: Components
Description: Components SettingsDll
Copyright (C)
              Pixol (lee@sharpe-shell.org)

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

library ComponentsService;

uses
  Forms,
  windows,
  dialogs,
  sysutils,
  SharpApi,
  Controls,
  PngSpeedButton,
  tabs,
  uCompServiceItemsWnd in 'uCompServiceItemsWnd.pas' {frmCompItems},
  uCompServiceList in 'uCompServiceList.pas',
  uSharpCenterSectionList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterSectionList.pas',
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas';

{$E dll}

{$R *.res}
function Open(const APluginID:Pchar; owner: hwnd):hwnd;
begin

  if frmCompItems = nil then
    frmCompItems := TfrmCompItems.Create(nil);

  ItemStorage := TComponentsList.Create;
  ItemStorage.FileName := GetListFileName;
  if FileExists(ItemStorage.FileName) then
    ItemStorage.Load
  else
    ItemStorage.New;

  frmCompItems.ParentWindow := owner;
  frmCompItems.Left := 2;
  frmCompItems.Top := 2;
  frmCompItems.BorderStyle := bsNone;
  frmCompItems.UpdateDisplay(ItemStorage);
  frmCompItems.Show;
  result := frmCompItems.Handle;

  frmCompItems.UpdateButtonStates;
end;

procedure Help;
begin
  SharpApi.HelpMsg('go {docs}\SharpCore\Services\Components.sdoc');
end;

function Close(owner: hwnd; SaveSettings: Boolean): boolean;
begin

  try

    if SaveSettings then
    begin
      ItemStorage.Save;
    end;

    frmCompItems.Close;
    frmCompItems.Free;
    frmCompItems := nil;

    result := True;
  except
    result := False;
  end;
end;

function ConfigDllType: Integer;
begin
  Result := SCU_SERVICE;
end;

procedure BtnAdd(var AButton:TPngSpeedButton);
var
  p:TPoint;
begin
  p := AButton.ClientOrigin;
  frmCompItems.mnuAdd.Popup(p.X,p.Y+AButton.Height);
end;

procedure BtnEdit(var AButton:TPngSpeedButton);
begin
  frmCompItems.btnEditClick(nil);
end;

procedure BtnDelete(var AButton:TPngSpeedButton);
begin
  frmCompItems.btnDeleteClick(nil);
end;

procedure BtnMoveUp(var AButton:TPngSpeedButton);
begin
  frmCompItems.btnUpClick(nil);
end;

procedure BtnMoveDown(var AButton:TPngSpeedButton);
begin
  frmCompItems.btnDownClick(nil);
end;

procedure BtnImport(var AButton:TPngSpeedButton);
begin
  frmCompItems.btnImportClick(nil);
end;

procedure BtnExport(var AButton:TPngSpeedButton);
begin
  frmCompItems.btnExportClick(nil);
end;

procedure BtnClear(var AButton:TPngSpeedButton);
begin
  frmCompItems.BtnClearClick(nil);
end;

procedure ChangeSection(const ASection:TSectionObject);
begin
end;

procedure AddSections(var AList: TSectionObjectList; var AItemHeight: Integer);
begin

end;

procedure GetDisplayName(const APluginID:Pchar; var ADisplayName:PChar);
begin
  ADisplayName := PChar('Components');
end;

exports
  Open,
  Close,
  Help,
  ConfigDllType,

  BtnAdd,
  BtnEdit,
  BtnDelete,
  BtnMoveUp,
  BtnMoveDown,
  BtnImport,
  BtnExport,
  BtnClear,

  GetDisplayName,

  AddSections,
  ChangeSection;

end.

