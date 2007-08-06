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
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  uThemeSkinListWnd in 'uThemeSkinListWnd.pas' {frmSkinListWnd},
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; owner: hwnd): hwnd;
begin
  if frmSkinListWnd = nil then frmSkinListWnd := TfrmSkinListWnd.Create(nil);

  frmSkinListWnd.Theme := APluginID;
  frmSkinListWnd.DefaultSkin := frmSkinListWnd.GetDefaultSkin(frmSkinListWnd.Theme);

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

procedure Save;
begin
  frmSkinListWnd.Save;
end;

procedure GetDisplayName(const APluginID: Pchar; var ADisplayName: PChar);
begin
  ADisplayName := PChar('Skin');
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  Result := suSkin;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  if frmSkinListWnd.lbSkinList.Count = 0 then
  ATabs.Add('Skins',nil,'','NA') else
  ATabs.Add('Skins',nil,'',IntToStr(frmSkinListWnd.lbSkinList.Count));
end;

procedure SetDisplayText(const APluginID:Pchar; var ADisplayText:PChar);
begin
  ADisplayText := PChar('Skin');
end;

procedure SetStatusText(var AStatusText: PChar);
var
  sr: TSearchRec;
  dir: string;
  n: Integer;
begin
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

  AStatusText := PChar(IntToStr(n));
end;

procedure GetCenterScheme(var ABackground: TColor; var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  frmSkinListWnd.lbSkinList.Colors.ItemColorSelected := AItemSelectedColor;
  frmSkinListWnd.lbSkinList.Colors.ItemColor := AItemColor;
end;

exports
  Open,
  Close,
  Save,
  SetDisplayText,
  SetStatusText,
  SetSettingType,

  AddTabs,
  GetCenterScheme;

end.

