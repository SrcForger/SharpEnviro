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

library ThemeSkinList;
uses
  SysUtils,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  graphics,
  PngSpeedButton,
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  uThemeSkinListWnd in 'uThemeSkinListWnd.pas' {frmSkinListWnd},
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  uVistaFuncs in '..\..\..\Common\Units\VistaFuncs\uVistaFuncs.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; owner: hwnd): hwnd;
begin
  if frmSkinListWnd = nil then frmSkinListWnd := TfrmSkinListWnd.Create(nil);
  SetVistaFonts(frmSkinListWnd);

  CenterDefineConfigurationMode(scmLive);
  frmSkinListWnd.Theme := APluginID;
  frmSkinListWnd.DefaultSkin := XmlGetSkin(frmSkinListWnd.Theme);

  frmSkinListWnd.ParentWindow := owner;
  frmSkinListWnd.Left := 2;
  frmSkinListWnd.Top := 2;
  frmSkinListWnd.BorderStyle := bsNone;
  frmSkinListWnd.Show;
  result := frmSkinListWnd.Handle;
end;            

procedure Close;
begin
    frmSkinListWnd.Free;
    frmSkinListWnd := nil;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  sr: TSearchRec;
  dir: string;
  n: Integer;
begin
  AName := 'Skin';
  ATitle := Format('Skin Configuration for "%s"',[APluginID]);
  ADescription := 'Select which skin you want to use for this theme.';


  // Status
  dir := SharpApi.GetSharpeDirectory + 'Skins\';
  n := 0;

  if FindFirst(dir + '*.*', faDirectory, sr) = 0 then
  begin
    repeat
        if FileExists(dir + sr.Name + '\Skin.xml') then
          inc(n);
    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;

  AStatus := PChar(IntToStr(n));
end;

procedure GetCenterScheme(var ABackground: TColor; var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  frmSkinListWnd.lbSkinList.Colors.ItemColorSelected := AItemSelectedColor;
  frmSkinListWnd.lbSkinList.Colors.ItemColor := AItemColor;
end;

exports
  Open,
  Close,
  SetText,
  GetCenterScheme;

end.

