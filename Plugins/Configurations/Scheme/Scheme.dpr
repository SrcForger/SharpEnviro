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
  sysutils,
  sharpapi,
  classes,
  sharpcenterapi,
  graphics,
  uVistaFuncs,
  forms,
  GR32,
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
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  Result := suScheme;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  sl: TStringList;
  tmp: TSchemeManager;
begin
  AName := 'Schemes';
  ATitle := Format('Scheme Configuration for "%s"',[APluginID]);
  ADescription := 'Create custom colour schemes for the selected skin.';

  tmp := TSchemeManager.Create;
  sl := TstringList.Create;
  try
    tmp.GetSchemeList(APluginID, sl);
  finally
    AStatus := IntToStr(sl.count);
    tmp.Free;
    sl.Free;
  end;
end;

procedure Close;
begin
  FreeAndNil(frmSchemeList);
  FreeAndNil(frmEditScheme);
end;

procedure UpdatePreview(var ABmp:TBitmap32);
begin
  if (frmSchemeList.lbSchemeList.Count = 0) or (frmSchemeList = nil) then begin
    ABmp.SetSize(0,0);
    exit;
  end;

  ABmp.Clear(color32(0,0,0,0));
  frmSchemeList.CreatePreviewBitmap(ABmp);
end;

function OpenEdit(AOwner:Hwnd; AEditMode:TSCE_EditMode_Enum):Hwnd;
begin
  // Create Form
  if Not(Assigned(frmEditScheme)) then
    frmEditScheme := TfrmEditScheme.Create(nil);

  SetVistaFonts(frmEditScheme);

  // Assign form to owner handle
  frmEditScheme.ParentWindow := AOwner;
  frmEditScheme.Left := 0;
  frmEditScheme.Top := 0;
  frmEditScheme.BorderStyle := bsNone;

  // Initialise UI based on the edit mode
  frmEditScheme.EditMode := AEditMode;
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
  frmEditScheme.Save(AEditMode, AApply);
  FreeAndNil(frmEditScheme);
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

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Scheme';
    Description := 'Scheme Theme Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suScheme)]);
  end;
end;

exports
  Open,
  Close,
  OpenEdit,
  CloseEdit,
  SetSettingType,
  SetText,
  GetCenterScheme,
  UpdatePreview,
  GetMetaData;
end.

