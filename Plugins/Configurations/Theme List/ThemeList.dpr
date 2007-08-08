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
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  uThemeListEditWnd in 'uThemeListEditWnd.pas' {frmEditItem},
  uThemeListManager in 'uThemeListManager.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmThemeList = nil then frmThemeList := TfrmThemeList.Create(nil);

  // Set configuration mode, and assign vista fonts
  SetVistaFonts(frmThemeList);
  CenterDefineConfigurationMode(scmLive);

  with frmThemeList do begin
    ParentWindow := aowner;
    Left := 0;
    Top := 0;
    BorderStyle := bsNone;
    Show;

    // Define which tabs are visible
    UpdateEditTabs;
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
  result := HR_NORECIEVERWINDOW;
  if frmEditItem = nil then frmEditItem := TfrmEditItem.Create(nil);
  uVistaFuncs.SetVistaFonts(frmEditItem);

  frmEditItem.ParentWindow := AOwner;
  frmEditItem.Left := 0;
  frmEditItem.Top := 0;
  frmEditItem.BorderStyle := bsNone;
  frmEditItem.Show;
  frmThemeList.EditMode := AEditMode;

  if frmThemeList.UpdateUI then begin
    result := frmEditItem.Handle;
  end else
    FreeAndNil(FrmEditItem);

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
  if AApply then begin
    frmThemeList.SaveUi;
    CenterDefineSettingsChanged;
  end;

  if frmEditItem <> nil then begin
      frmEditItem.Close;
      frmEditItem.Free;
      frmEditItem := nil;
  end;

  if frmThemeList <> nil then begin
    frmThemeList.lbThemeList.Enabled := True;
    frmThemeList.BuildThemeList;
    frmThemeList.UpdateEditTabs;
  end;
end;

procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Themes');
end;

procedure SetStatusText(var AStatusText: PChar);
var
  sr: TSearchRec;
  dir : String;
  n: Integer;
begin
  AStatusText := Pchar(IntToStr(1));
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
  AStatusText := Pchar(IntToStr(n));
end;

function SetBtnState(AButtonID: TSCB_BUTTON_ENUM): Boolean;
begin
  Result := False;

  Case AButtonID of
    scbDelete: Begin
      if frmThemeList.lbThemeList.ItemIndex <> -1 then
        Result := True else
        Result := False;
    end;
    scbConfigure: Result := False;
  end;
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

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Themes',nil,'',IntToStr(frmThemeList.lbThemeList.Count));
end;


exports
  Open,
  Close,
  OpenEdit,
  CloseEdit,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  GetCenterScheme,
  AddTabs;

end.

