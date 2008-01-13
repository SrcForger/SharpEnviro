{
Source Name: MemoryMonitor.dpr
Description: Memory Module Config Dll
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

library MemoryMonitor;
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
  uVistaFuncs,
  SysUtils,
  Graphics,
  uMMWnd in 'uMMWnd.pas' {frmMM},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpDialogs in '..\..\..\Common\Libraries\SharpDialogs\SharpDialogs.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas';

{$E .dll}

{$R *.res}

procedure Save;
var
  XML : TJvSimpleXML;
begin
  if frmMM = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'MemoryMonitorModuleSettings';
  with XML.Root.Items, frmMM do
  begin
    if rbPTaken.Checked then
      Add('ITC',0)
    else Add('ITC',1);
    Add('ShowRAMBar',cbrambar.Checked);
    Add('ShowRAMInfo',cbraminfo.checked);
    Add('ShowRAMPC',cbrampc.Checked);
    Add('ShowSWPBar',cbswpbar.Checked);
    Add('ShowSWPInfo',cbswpinfo.Checked);
    Add('ShowSWPPC',cbswppc.Checked);

    if rbHoriz.Checked then
      Add('ItemAlign',1)
    else if rbVert.Checked then
      Add('ItemAlign',2)
    else
      Add('ItemAlign',3);
    Add('Width',sgbBarSize.Value);
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmMM.sBarID),strtoint(frmMM.sModuleID)));
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
begin
  if frmMM = nil then frmMM := TfrmMM.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmMM);
  frmMM.sBarID := left;
  frmMM.sModuleID := right;
  frmMM.ParentWindow := aowner;
  frmMM.Left := 2;
  frmMM.Top := 2;
  frmMM.BorderStyle := bsNone;
  result := frmMM.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmMM do
    begin
      case IntValue('ITC',0) of
        1: rbFreeMB.checked := True;
        else rbPTaken.Checked := True;
      end;
      cbrambar.Checked := BoolValue('ShowRAMBar',cbrambar.Checked);
      cbraminfo.checked := BoolValue('ShowRAMInfo',cbraminfo.checked);
      cbrampc.Checked := BoolValue('ShowRAMPC',cbrampc.Checked);
      cbswpbar.Checked := BoolValue('ShowSWPBar',cbswpbar.Checked);
      cbswpinfo.Checked := BoolValue('ShowSWPInfo',cbswpinfo.Checked);
      cbswppc.Checked := BoolValue('ShowSWPPC',cbswppc.Checked);
      case IntValue('ItemAlign',3) of
        1: rbHoriz.Checked := True;
        2: rbVert.Checked := True;
        else rbHoriz2.Checked := True;
      end;
      sgbBarSize.Value := IntValue('Width',sgbBarSize.Value);
    end;
  XML.Free;

  frmMM.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmMM.Close;
    frmMM.Free;
    frmMM := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Memory Monitor';
  ATitle := 'Memory Monitor Module';
  ADescription := 'Configure memory monitor module';

end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Memory Monitor';
    Description := 'Memory Monitor Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

exports
  Open,
  Close,
  Save,
  SetText,
  GetMetaData;

begin
end.

