{
Source Name: SharpBarList
Description: SharpBar Manager Config Dll
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

library ServiceManager;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  Contnrs,
  graphics,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  SharpCenterApi,
  uServiceManagerWnd in 'uServiceManagerWnd.pas' {frmBarList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  uComponentMan in '..\..\..\Components\SharpCore2\uComponentMan.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmBarList = nil then frmBarList := TfrmBarList.Create(nil);

  uVistaFuncs.SetVistaFonts(frmBarList);
  frmBarList.ParentWindow := aowner;
  frmBarList.Left := 0;
  frmBarList.Top := 0;
  frmBarList.BorderStyle := bsNone;
  frmBarList.Show;
  result := frmBarList.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmBarList.Close;
    frmBarList.Free;
    frmBarList := nil;

  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  tmpList: TComponentList;
begin
  AName := 'Services';
  ATitle := 'Service Management';
  ADescription := 'Manage the SharpE Services including configuration. ';

  tmpList := TComponentList.Create;
  Try
    tmpList.BuildList('.service',false);
    AStatus := IntToStr(tmpList.Count);
  Finally
    tmpList.Free;
  End;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin

  if frmBarList <> nil then begin
    frmBarList.lbItems.Colors.ItemColor := AItemColor;
    frmBarList.lbItems.Colors.ItemColorSelected := AItemSelectedColor;
    frmBarList.lbItems.Colors.BorderColor := AItemSelectedColor;
    frmBarList.lbItems.Colors.BorderColorSelected := AItemSelectedColor;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Service Manager';
    Description := 'Service Manager Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suService)]);
  end;
end;


exports
  Open,
  Close,
  SetText,
  GetMetaData,
  GetCenterScheme;

end.

