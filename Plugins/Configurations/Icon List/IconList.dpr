{
Source Name: IconList
Description: Icon List Config Dll
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

library IconList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JvSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uIconListWnd in 'uIconListWnd.pas' {frmIconList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}      

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
begin
  if frmIconList = nil then frmIconList := TfrmIconList.Create(nil);

  uVistaFuncs.SetVistaFonts(frmIconList);
  frmIconList.sTheme := APluginID;
  frmIconList.ParentWindow := aowner;
  frmIconList.Left := 2;
  frmIconList.Top := 2;
  frmIconList.BorderStyle := bsNone;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(SharpApi.GetSharpeUserSettingsPath + '\Themes\'+APluginID+'\IconSet.xml');
    frmIconList.sCurrentIconSet := XML.Root.Items.Value('Name','');
  except
  end;
  XML.Free;

  CenterDefineConfigurationMode(scmLive);

  frmIconList.BuildIconList;
  frmIconList.Show;
  result := frmIconList.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmIconList.Close;
    frmIconList.Free;
    frmIconList := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Icons');
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
begin
  if frmIconList <> nil then
  begin
    frmIconList.lb_iconlist.Colors.ItemColor := AItemColor;
    frmIconList.lb_iconlist.Colors.ItemColorSelected := AItemSelectedColor;
    frmIconList.lb_iconlist.Colors.BorderColor := AItemSelectedColor;
    frmIconList.lb_iconlist.Colors.BorderColorSelected := AItemSelectedColor;
  end;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Icons',nil,'',IntToStr(frmIconList.lb_iconlist.Count));
end;

procedure UpdatePreview(var ABmp: TBitmap32);
begin
  if (frmIconList.lb_iconlist.ItemIndex < 0) or
     (frmIconList.lb_iconlist.Count = 0) then
     exit;

  ABmp.Clear(color32(0,0,0,0));
  frmIconList.BuildIconPreview(ABmp);
end;


exports
  Open,
  Close,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  GetCenterScheme,
  AddTabs,
  ClickBtn,
  UpdatePreview;

end.

