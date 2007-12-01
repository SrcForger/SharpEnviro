{
Source Name: ModuleManager
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

library ModuleManager;
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
  SysUtils,
  SharpCenterApi,
  uModuleManagerListWnd in 'uModuleManagerListWnd.pas' {frmMMList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  uModuleManagerListEdit in 'uModuleManagerListEdit.pas' {frmMMEdit},
  SharpERoundPanel in '..\..\..\Common\Delphi Components\SharpERoundPanel\SharpERoundPanel.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmMMList = nil then frmMMList := TfrmMMList.Create(nil);

  uVistaFuncs.SetVistaFonts(frmMMList);
  frmMMList.BarID := strtoint(APluginID);
  frmMMList.ParentWindow := aowner;
  frmMMList.Left := 0;
  frmMMList.Top := 0;
  frmMMList.BorderStyle := bsNone;
  frmMMList.Show;
  result := frmMMList.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmMMList.Close;
    frmMMList.Free;
    frmMMList := nil;

    if frmMMEdit <> nil then
    begin
      frmMMEdit.Close;
      frmMMEdit.Free;
      frmMMEdit := nil;
    end;
  except
    result := False;
  end;
end;

function OpenEdit(AOwner: hwnd; AEditMode:TSCE_EDITMODE_ENUM): hwnd;
begin
  result := HR_NORECIEVERWINDOW;
  if frmMMEdit = nil then frmMMEdit := TfrmMMEdit.Create(nil);
  uVistaFuncs.SetVistaFonts(frmMMEdit);

  frmMMEdit.ParentWindow := AOwner;
  frmMMEdit.Left := 0;
  frmMMEdit.Top := 0;
  frmMMEdit.BorderStyle := bsNone;
  frmMMEdit.Show;
  frmMMList.EditMode := AEditMode;

  //force
  frmMMEdit.SetFocus;

  if frmMMList.UpdateUI then
  begin
    result := frmMMEdit.Handle;
  end else
    FreeAndNil(frmMMEdit);

end;

function CloseEdit(AEditMode:TSCE_EDITMODE_ENUM; AApply: Boolean): boolean;
begin
  Result := True;

  // First validate
  if AApply then
    if Not(frmMMEdit.ValidateWindow(AEditMode)) then
    begin
      Result := False;
      Exit;
    end else
       frmMMEdit.ClearValidation;

  // If Validation ok then continue
  if (AApply) then
    frmMMList.SaveUi;

  if frmMMEdit <> nil then
  begin
    frmMMEdit.Close;
    frmMMEdit.Free;
    frmMMEdit := nil;
  end;

  if frmMMList <> nil then
  begin
    frmMMList.BuildModuleList;
  end;
end;

procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('ModuleManager');
end;

procedure SetStatusText(var AStatusText: PChar);
begin
  AStatusText := Pchar(IntToStr(1));
end;

function SetBtnState(AButtonID: TSCB_BUTTON_ENUM): Boolean;
begin
  Result := False;

  Case AButtonID of
    scbImport: Result := False;
    scbExport: Result := False;
    scbDelete: Begin
      if ((frmMMList.lbModulesLeft.ItemIndex <> -1) or
        (frmMMList.lbModulesRight.ItemIndex <> -1)) then
        Result := True else
        Result := False;
    end;
    scbConfigure: Result := True;
  end;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  if frmMMEdit <> nil then
  begin
    frmMMEdit.Color := ABackground;
  end;

  if frmMMList <> nil then
  begin
    frmMMList.lbModulesLeft.Colors.ItemColor := AItemColor;
    frmMMList.lbModulesLeft.Colors.ItemColorSelected := AItemSelectedColor;
    frmMMList.lbModulesLeft.Colors.BorderColor := AItemSelectedColor;
    frmMMList.lbModulesLeft.Colors.BorderColorSelected := AItemSelectedColor;
    frmMMList.lbModulesRight.Colors.ItemColor := AItemColor;
    frmMMList.lbModulesRight.Colors.ItemColorSelected := AItemSelectedColor;
    frmMMList.lbModulesRight.Colors.BorderColor := AItemSelectedColor;
    frmMMList.lbModulesRight.Colors.BorderColorSelected := AItemSelectedColor;
  end;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Modules',nil,'','');
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
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  SetSettingType,
  GetCenterScheme,
  AddTabs;

end.

