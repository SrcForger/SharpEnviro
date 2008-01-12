{
Source Name: SharpBarList
Description: SharpBar Manager Config Dll
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

library SharpBarList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  Contnrs,
  graphics,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  SharpCenterApi,
  uSharpBarListWnd in 'uSharpBarListWnd.pas' {frmBarList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  uSharpBarListEditWnd in 'uSharpBarListEditWnd.pas' {frmEditItem};

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmBarList = nil then frmBarList := TfrmBarList.Create(nil);
  CenterDefineConfigurationMode(scmLive);

  uVistaFuncs.SetVistaFonts(frmBarList);
  frmBarList.ParentWindow := aowner;
  frmBarList.Left := 0;
  frmBarList.Top := 0;
  frmBarList.BorderStyle := bsNone;
  frmBarList.Show;
  result := frmBarList.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmBarList.Close;
    frmBarList.Free;
    frmBarList := nil;

    if frmEditItem <> nil then begin
      frmEditItem.Close;
      frmEditItem.Free;
      frmEditItem := nil;
    end;

  except
    result := False;
  end;
end;

function OpenEdit(AOwner: hwnd; AEditMode:TSCE_EDITMODE_ENUM): hwnd;
begin
  result := HR_NORECIEVERWINDOW;
  if frmEditItem = nil then frmEditItem := TfrmEditItem.Create(nil);
  uVistaFuncs.SetVistaFonts(frmEditItem);

  frmEditItem.ParentWindow := AOwner;
  frmEditItem.Left := 0;
  frmEditItem.Top := 0;
  frmEditItem.BorderStyle := bsNone;
  frmEditItem.Show;
  frmBarList.EditMode := AEditMode;

  //force
  frmEditItem.SetFocus;

  if frmBarList.UpdateUI then
  begin
    result := frmEditItem.Handle;
  end else
    FreeAndNil(FrmEditItem);

end;

function CloseEdit(AEditMode:TSCE_EDITMODE_ENUM; AApply: Boolean): boolean;
begin
  Result := True;

  // First validate
  if AApply then
    if Not(frmEditItem.ValidateWindow(AEditMode)) then
    begin
      Result := False;
      Exit;
    end else
       frmEditItem.ClearValidation;

  // If Validation ok then continue
  if (AApply) and (frmEditItem.plEdit.ActivePage <> frmEditItem.pagBarSpace) then
    frmBarList.SaveUi;

  if frmEditItem <> nil then
  begin
      frmEditItem.Close;
      frmEditItem.Free;
      frmEditItem := nil;
  end;

  if frmBarList <> nil then
  begin
    frmBarList.lbBarList.Enabled := True;
    frmBarList.BuildBarList;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  tmpList: TObjectList;
begin
  AName := 'Toolbars';
  ATitle := 'Toolbar Management';
  ADescription := 'Create and manage SharpBar configurations. ';

  tmpList := TObjectList.Create;
  Try
    AddItemsToList(tmpList);
    AStatus := IntToStr(tmpList.Count);
  Finally
    tmpList.Free;
  End;
end;

function SetBtnState(AButtonID: TSCB_BUTTON_ENUM): Boolean;
begin
  Result := False;

  Case AButtonID of
    scbImport: Result := False;
    scbExport: Result := False;
    scbDelete: Begin
      if frmBarList.lbBarList.ItemIndex <> -1 then
        Result := True else
        Result := False;
    end;
    scbConfigure: Result := True;
  end;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  if frmEditItem <> nil then begin
    FrmEditItem.Color := ABackground;
  end;

  if frmBarList <> nil then begin
    frmBarList.lbBarList.Colors.ItemColor := AItemColor;
    frmBarList.lbBarList.Colors.ItemColorSelected := AItemSelectedColor;
    frmBarList.lbBarList.Colors.BorderColor := AItemSelectedColor;
    frmBarList.lbBarList.Colors.BorderColorSelected := AItemSelectedColor;
  end;
end;

function SetSettingType : TSU_UPDATE_ENUM;
begin
  result := suSharpBar;
end;

exports
  Open,
  Close,
  OpenEdit,
  CloseEdit,
  SetText,
  SetBtnState,
  SetSettingType,
  GetCenterScheme;

end.

