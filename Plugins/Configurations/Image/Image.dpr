{
Source Name: Image
Description: Image Object Config Dll
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

library Image;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  SharpEUIC,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpEFontSelectorFontList,
  uImageWnd in 'uImageWnd.pas' {frmImage},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpEPageControl in '..\..\..\Common\Delphi Components\SharpEPageControl\SharpEPageControl.pas',
  SharpETabList in '..\..\..\Common\Delphi Components\SharpETabList\SharpETabList.pas',
  SharpERoundPanel in '..\..\..\Common\Delphi Components\SharpERoundPanel\SharpERoundPanel.pas';

{$E .dll}

{$R *.res}

procedure Save;
begin
  if frmImage = nil then
    exit;

  frmImage.SaveSettings;
end;      

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmImage = nil then frmImage := TfrmImage.Create(nil);

  uVistaFuncs.SetVistaFonts(frmImage);
  frmImage.sObjectID := APluginID;
  frmImage.ParentWindow := aowner;
  frmImage.Left := 2;
  frmImage.Top := 2;
  frmImage.BorderStyle := bsNone;

  frmImage.Show;
  result := frmImage.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmImage.Close;
    frmImage.Free;
    frmImage := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Image');
end;

procedure SetStatusText(var AStatusText: PChar);
begin
  AStatusText := '';
end;

procedure ClickBtn(AButtonID: Integer; AButton:TPngSpeedButton; AText:String);
begin
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
var
  n : integer;
begin
  if frmImage <> nil then
  begin
    for n := 0 to frmImage.ComponentCount - 1 do
      if frmImage.Components[n] is TSharpEUIC then
      begin
        TSharpEUIC(frmImage.Components[n]).NormalColor := clWindow;
        TSharpEUIC(frmImage.Components[n]).BorderColor := AItemSelectedColor;
        TSharpEUIC(frmImage.Components[n]).BackgroundColor := $00F7F7F7;
      end;

    frmImage.spc.TabColor := $00F7F7F7;
    frmImage.spc.BorderColor := $00FBEFE3;
  end;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Image',frmImage.pagImage,'','');
  ATabs.Add('Display',frmImage.pagDisplay,'','');
end;

procedure ClickTab(ATab: TPluginTabItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.Data <> nil then begin
    tmpPag := TJvStandardPage(ATab.Data);
    tmpPag.Show;
  end;

end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  result := suDesktopObject;
end;


exports
  Open,
  Close,
  Save,
  ClickTab,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  GetCenterScheme,
  AddTabs,
  ClickBtn;

end.

