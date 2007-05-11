{
Source Name: SharpDesk Configs
Description: SharpDesk Config Dll
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

library SharpDesk;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  JvPageList,
  Graphics,
  uSharpDeskSettingsWnd in 'uSharpDeskSettingsWnd.pas' {frmDeskSettings},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpDeskTDeskSettings in '..\..\..\Components\SharpDesk\Units\uSharpDeskTDeskSettings.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas';

{$E .dll}

{$R *.res}

var
  XMLSettings : TDeskSettings;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmDeskSettings = nil then frmDeskSettings := TfrmDeskSettings.Create(nil);
  if XMLSettings = nil then XMLSettings := TDeskSettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmDeskSettings);
  frmDeskSettings.ParentWindow := aowner;
  frmDeskSettings.Left := 2;
  frmDeskSettings.Top := 2;
  frmDeskSettings.BorderStyle := bsNone;

  frmDeskSettings.cb_grid.Checked := XMLSettings.Grid;
  frmDeskSettings.sgb_gridx.Value := XMLSettings.GridX;
  frmDeskSettings.sgb_gridy.Value := XMLSettings.GridY;
  frmDeskSettings.cb_singleclick.Checked := XMLSettings.SingleClick;
  frmDeskSettings.cb_amm.Checked := XMLSettings.AdvancedMM;
  frmDeskSettings.cb_dd.Checked := XMLSettings.DragAndDrop;

  frmDeskSettings.Show;
  result := frmDeskSettings.Handle;
end;

function Close(ASave: Boolean): boolean;
begin
  result := True;
  try
    if ASave then
    begin
      XMLSettings.Grid  := frmDeskSettings.cb_grid.Checked;
      XMLSettings.GridX := frmDeskSettings.sgb_gridx.Value;
      XMLSettings.GridY := frmDeskSettings.sgb_gridy.Value;
      XMLSettings.SingleClick := frmDeskSettings.cb_singleclick.Checked;
      XMLSettings.AdvancedMM := frmDeskSettings.cb_amm.Checked;
      XMLSettings.DragAndDrop := frmDeskSettings.cb_dd.Checked;
      XMLSettings.SaveSettings;
    end;
    
    XMLSettings.Free;
    XMLSettings := nil;

    frmDeskSettings.Close;
    frmDeskSettings.Free;
    frmDeskSettings := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('SharpDesk');
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

procedure ClickTab(ATab: TPluginTabItem);
begin
  TJvStandardPage(ATab.Data).Show;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  if frmDeskSettings <> nil then
  begin
    ATabs.Add('Settings',frmDeskSettings.JvSettingsPage,'','');
    ATabs.Add('Advanced',frmDeskSettings.JvAdvSettingsPage,'','');
  end;
end;

function SetSettingType : integer;
begin
  result := SU_SHARPDESK;
end;


exports
  Open,
  Close,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  SetSettingType,
  GetCenterScheme,
  AddTabs,
  ClickTab,
  ClickBtn;

end.

