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
  sharpapi,
  graphics,
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
  frmSchemeList.InitialiseSettings(APluginID);
  frmSchemeList.Theme := APluginID;

  frmSchemeList.ParentWindow := AOwner;
  frmSchemeList.Left := 0;
  frmSchemeList.Top := 0;
  frmSchemeList.BorderStyle := bsNone;
  frmSchemeList.Show;  

  result := frmSchemeList.Handle;
end;

procedure Help;
begin

end;

function SetSettingType: Integer;
begin
  Result := SU_SCHEME;
end;

procedure Close(ASave:Boolean);
begin

  if ASave then
    frmSchemeList.SaveSchemes;

  FreeAndNil(frmSchemeList);
  FreeAndNil(frmEditScheme);
end;

procedure GetDisplayName(const APluginID:PChar; var ADisplayName:PChar);
begin
  ADisplayName := PChar('Scheme');
end;

procedure UpdatePreview(var AImage32:TImage32);
begin
  if (frmSchemeList.SchemeItems.Count <> 0) or (frmSchemeList <> nil) then
    frmSchemeList.CreatePreviewBitmap(AImage32) else
    AImage32.Bitmap.Clear(clWhite32);
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
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
    frmSchemeList.BuildSchemeList(frmSchemeList.Theme);
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
  Help,
  SetSettingType,
  AddTabs,
  GetCenterScheme,

  UpdatePreview;
end.

