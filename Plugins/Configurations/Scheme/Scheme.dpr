{
Source Name: Scheme.dll
Description: Configuration dll for Scheme settings
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
library Scheme;

uses
  windows,
  Classes,
  Messages,
  Dialogs,
  sysutils,
  ExtCtrls,
  sharpapi,
  sharpcenterapi,
  graphics,
  uVistaFuncs,
  forms,
  GR32,
  GR32_Image,
  uSharpCenterPluginTabList,
  PngSpeedButton,
  uSchemeListWnd in 'uSchemeListWnd.pas' {frmSchemeList},
  uEditSchemeWnd in 'uEditSchemeWnd.pas' {frmEditScheme},
  uSchemeList in 'uSchemeList.pas';

{$R *.RES}

function Open(const APluginID: PChar; AOwner: hwnd): HWnd;
begin
  // Specify the Service configuration filename
  frmSchemeList := TfrmSchemeList.Create(nil);
  SetVistaFonts(frmSchemeList); 

  frmSchemeList.InitialiseSettings(APluginID);

  frmSchemeList.ParentWindow := AOwner;
  frmSchemeList.Left := 0;
  frmSchemeList.Top := 0;
  frmSchemeList.BorderStyle := bsNone;
  frmSchemeList.Show;  

  result := frmSchemeList.Handle;

  // Set configuration mode
  CenterDefineConfigurationMode(scmLive);
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  Result := suScheme;
end;

procedure Close;
begin
  FreeAndNil(frmSchemeList);
  FreeAndNil(frmEditScheme);
end;

procedure GetDisplayName(const APluginID:PChar; var ADisplayName:PChar);
begin
  ADisplayName := PChar('Scheme');
end;

procedure UpdatePreview(var ABmp:TBitmap32);
begin
  ABmp.SetSize(0,0);
  if (frmSchemeList.lbSchemeList.Count = 0) or (frmSchemeList = nil) then begin
    exit;
  end;

  ABmp.Clear(color32(0,0,0,0));
  frmSchemeList.CreatePreviewBitmap(ABmp);
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  if frmSchemeList.lbSchemeList.Count = 0 then
  ATabs.Add('Schemes',nil,'','NA') else
  ATabs.Add('Schemes',nil,'',IntToStr(frmSchemeList.lbSchemeList.Count));
end;

function OpenEdit(AOwner:Hwnd; AEditMode:TSCE_EditMode_Enum):Hwnd;
begin
  // Create Form
  if Not(Assigned(frmEditScheme)) then
    frmEditScheme := TfrmEditScheme.Create(nil);

  // Assign form to owner handle
  frmEditScheme.ParentWindow := AOwner;
  frmEditScheme.Left := 0;
  frmEditScheme.Top := 0;
  frmEditScheme.BorderStyle := bsNone;

  // Initialise UI based on the edit mode
  frmEditScheme.InitUI(AEditMode);

  Result := frmEditScheme.Handle;
  frmEditScheme.Show;
end;

function CloseEdit(AEditMode:TSCE_EditMode_Enum; AApply:Boolean): boolean;
begin
  Result := True;

  if frmEditScheme = nil then exit;

  // Validation
  if Not(frmEditScheme.ValidateEdit(AEditMode)) and AApply  then Begin
    Result := False;
    //frmEditScheme.InitValidateUi(frmEditScheme);
    Exit;
  End;

  // Define whether we add/edit or delete the item
  if frmEditScheme.Save(AEditMode, AApply) then Begin
    FreeAndNil(frmEditScheme);
    frmSchemeList.AddItems;
  end;
end;

procedure GetCenterScheme(var ABackground: TColor; var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  if frmEditScheme <> nil then begin

    frmEditScheme.Color := ABackground;
    frmEditScheme.pnlContainer.Color := ABackground;
    frmEditScheme.SharpERoundPanel1.BackgroundColor := ABackground;
    frmEditScheme.SharpERoundPanel1.Color := clWindow;

  end;

  frmSchemeList.lbSchemeList.Colors.ItemColor := AItemColor;
  frmSchemeList.lbSchemeList.Colors.ItemColorSelected := AItemSelectedColor;
  frmSchemeList.lbSchemeList.Colors.BorderColorSelected := AItemSelectedColor;
end;

exports
  Open,
  Close,
  OpenEdit,
  CloseEdit,
  SetSettingType,
  AddTabs,
  GetCenterScheme,

  UpdatePreview;
end.

