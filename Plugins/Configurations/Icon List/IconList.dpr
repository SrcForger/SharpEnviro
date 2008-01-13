{
Source Name: IconList
Description: Icon List Config Dll
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

library IconList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uIconListWnd in 'uIconListWnd.pas' {frmIconList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
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
  XML: TJclSimpleXML;
begin
  if frmIconList = nil then
    frmIconList := TfrmIconList.Create(nil);

  uVistaFuncs.SetVistaFonts(frmIconList);
  frmIconList.sTheme := APluginID;
  frmIconList.ParentWindow := aowner;
  frmIconList.Left := 2;
  frmIconList.Top := 2;
  frmIconList.BorderStyle := bsNone;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(SharpApi.GetSharpeUserSettingsPath + '\Themes\' + APluginID + '\IconSet.xml');
    frmIconList.sCurrentIconSet := XML.Root.Items.Value('Name', '');
  except
  end;
  XML.Free;

  frmIconList.BuildIconList;
  frmIconList.Show;
  result := frmIconList.Handle;
end;

function Close: boolean;
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

procedure SetText(const APluginID: string; var AName: string; var AStatus: string;
  var ATitle: string; var ADescription: string);
var
  sr: TSearchRec;
  sDir: string;
  xml: TJclSimpleXML;
  n: Integer;
begin
  AName := 'Icons';
  ATitle := Format('Icon Set Configuration for "%s"',[APluginID]);
  ADescription := 'Select which icon set you want to use for this theme.';

  xml := TJclSimpleXML.Create;
  try
    sDir := SharpApi.GetSharpeDirectory + 'Icons\';
    n := 0;
    if FindFirst(sDir + '*', FADirectory, sr) = 0 then
      repeat
        if (CompareText(sr.Name, '.') <> 0) and (CompareText(sr.Name, '..') <> 0) then begin
          if FileExists(sDir + sr.Name + '\IconSet.xml') then begin
            n := n + 1;
          end;
        end;
      until FindNext(sr) <> 0;
    FindClose(sr);
  finally
    xml.Free;
  end;

  AStatus := IntToStr(n);
end;

procedure GetCenterScheme(var ABackground: TColor;
  var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  if frmIconList <> nil then begin
    frmIconList.lb_iconlist.Colors.ItemColor := AItemColor;
    frmIconList.lb_iconlist.Colors.ItemColorSelected := AItemSelectedColor;
    frmIconList.lb_iconlist.Colors.BorderColor := AItemSelectedColor;
    frmIconList.lb_iconlist.Colors.BorderColorSelected := AItemSelectedColor;
  end;
end;

procedure UpdatePreview(var ABmp: TBitmap32);
begin
  if (frmIconList.lb_iconlist.ItemIndex < 0) or
    (frmIconList.lb_iconlist.Count = 0) then
    exit;

  ABmp.Clear(color32(0, 0, 0, 0));
  frmIconList.BuildIconPreview(ABmp);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Icon List';
    Description := 'Icon List Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suIconSet)]);
  end;
end;

exports
  Open,
  Close,
  SetText,
  GetMetaData,
  GetCenterScheme,
  UpdatePreview;

end.

