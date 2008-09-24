{
Source Name: CPUMonitor.dpr
Description: CPU Monitor Module Config Dll
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

library CPUMonitor;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JclSimpleXML,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  uVistaFuncs,
  SharpESkinManager,
  SharpESkinPart,
  SysUtils,
  Graphics,
  uCPUMonitorWnd in 'uCPUMonitorWnd.pas' {frmCPUMon},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpDialogs in '..\..\..\Common\Libraries\SharpDialogs\SharpDialogs.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas',
  SharpECustomSkinSettings in '..\..\..\Common\Delphi Components\SharpE Skin Components\SharpECustomSkinSettings.pas',
  adCpuUsage in '..\..\..\Common\3rd party\adCpuUsage\adCpuUsage.pas';

{$E .dll}

{$R *.res}

procedure Save;
begin
  if frmCPUMon <> nil then
    frmCPUMon.Save;
end;



function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  barId,moduleId : Integer;
  s : string;
begin
  if frmCPUMon = nil then frmCPUMon := TfrmCPUMon.Create(nil);
  SetVistaFonts(frmCPUMon);

  GetBarModuleIds( APluginID, barId, moduleId );
  frmCPUMon.BarID := barId;
  frmCPUMon.ModuleID := moduleId;

  frmCPUMon.ParentWindow := aowner;
  frmCPUMon.Left := 0;
  frmCPUMon.Top := 0;
  frmCPUMon.BorderStyle := bsNone;

  frmCPUMon.Load;
  frmCPUMon.Show;

  result := frmCPUMon.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmCPUMon.Close;
    frmCPUMon.Free;
    frmCPUMon := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ADescription: String);
begin
  AName := 'CPU Monitor';
  ADescription := 'The CPU module displays current process activity';
end;

procedure AddTabs(var ATabs: TStringList);
begin
  ATabs.AddObject('General',frmCPUMon.pagMon);
  ATabs.AddObject('Colors',frmCPUMon.pagColors);
end;

procedure ClickTab(ATab: TStringItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.FObject <> nil then begin
    tmpPag := TJvStandardPage(ATab.FObject);
    tmpPag.Show;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'CPU Monitor';
    Description := 'CPU Monitor Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.5.2';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure GetCenterTheme(const ATheme: TCenterThemeInfo; const AEdit: Boolean);
begin
  if frmCPUMon <> nil then begin
    with frmCPUMon do begin
      AssignThemeToForm(ATheme,frmCPUMon);
    end;
  end;
end;



exports
  Open,
  Close,
  Save,
  ClickTab,
  SetText,
  GetMetaData,
  GetCenterTheme,
  AddTabs;

begin
end.

