{
Source Name: ThemeList
Description: Theme List Config Dll
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

library ThemeList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  graphics,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SharpCenterApi,
  SysUtils,
  uThemeListWnd in 'uThemeListWnd.pas' {frmThemeList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uThemeListEditWnd in 'uThemeListEditWnd.pas' {frmEditItem},
  uThemeListManager in 'uThemeListManager.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmThemeList = nil then frmThemeList := TfrmThemeList.Create(nil);

  // Set configuration mode, and assign vista fonts
  SetVistaFonts(frmThemeList);

  with frmThemeList do begin
    ParentWindow := aowner;
    Left := 0;
    Top := 0;
    BorderStyle := bsNone;
    Show;
  end;

  // return handle to the new window
  result := frmThemeList.Handle;
end;

procedure Close;
begin

    frmThemeList.Close;
    frmThemeList.Free;
    frmThemeList := nil;

    if frmEditItem <> nil then begin
      frmEditItem.Close;
      frmEditItem.Free;
      frmEditItem := nil;
    end;
end;

function OpenEdit(AOwner: hwnd; AEditMode:TSCE_EDITMODE_ENUM): hwnd;
begin
  if frmEditItem = nil then frmEditItem := TfrmEditItem.Create(nil);
  uVistaFuncs.SetVistaFonts(frmEditItem);

  frmEditItem.ParentWindow := AOwner;
  frmEditItem.Left := 0;
  frmEditItem.Top := 0;
  frmEditItem.BorderStyle := bsNone;
  frmEditItem.Show;
  frmEditItem.EditMode := AEditMode;
  result := frmEditItem.Handle;

  frmEditItem.InitUi(AEditMode);

end;

function CloseEdit(AEditMode:TSCE_EDITMODE_ENUM; AApply: Boolean): boolean;
begin
  Result := True;

  // First validate
  if AApply then
    if Not(frmEditItem.ValidateWindow(AEditMode)) then begin
      Result := False;
      Exit;
    end else
       frmEditItem.ClearValidation;

  // If Validation ok then continue
  frmEditItem.SaveUi(AApply, AEditMode);

  FreeAndNil(frmEditItem);
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  sr: TSearchRec;
  dir : String;
  n: Integer;
begin
  AName := 'Themes';
  ATitle := 'Theme Management';
  ADescription := 'Create and manage themes that customise the appearance of SharpE.';

  // Status
  dir := SharpApi.GetSharpeUserSettingsPath + 'Themes\';
  n := 0;
  if FindFirst(dir+'*.*', faDirectory, sr) = 0 then
  begin
    repeat
        if FileExists(dir + sr.Name + '\Theme.xml') then
          inc(n);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  AStatus := IntToStr(n);

end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  if frmEditItem <> nil then begin
    FrmEditItem.Color := ABackground;
  end;

  if frmThemeList <> nil then begin
    frmThemeList.lbThemeList.Colors.ItemColor := AItemColor;
    frmThemeList.lbThemeList.Colors.ItemColorSelected := AItemSelectedColor;
    frmThemeList.lbThemeList.Colors.BorderColor := AItemSelectedColor;
    frmThemeList.lbThemeList.Colors.BorderColorSelected := AItemSelectedColor;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Themes List';
    Description := 'Theme List Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suTheme)]);
  end;
end;



exports
  Open,
  Close,
  OpenEdit,
  CloseEdit,
  SetText,
  GetMetaData,
  GetCenterScheme;

end.

