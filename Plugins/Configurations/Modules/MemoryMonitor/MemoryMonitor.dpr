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
//  VCLFixPack,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JvPageList,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uMMWnd in 'uMMWnd.pas' {frmMM};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin)
  private
    barID: string;
    moduleID: string;
    procedure Load;
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
  end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlRoot.Name := 'MemoryMonitorModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmMM do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    if cboTextFormat.ItemIndex = 0 then
      Add('ITC', 0)
    else Add('ITC', 1);

    Add('ShowRAMBar', cbrambar.Checked);
    Add('ShowRAMInfo', cbraminfo.checked);
    Add('ShowRAMPC', cbrampc.Checked);
    Add('ShowSWPBar', cbswpbar.Checked);
    Add('ShowSWPInfo', cbswpinfo.Checked);
    Add('ShowSWPPC', cbswppc.Checked);

    case cboAlignment.ItemIndex of
      0: Add('ItemAlign', 1);
      1: Add('ItemAlign', 2);
      2: Add('ItemAlign', 3);
    end;

    Add('Width', sgbBarSize.Value);
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmMM do
    begin
      case IntValue('ITC', 0) of
        0: cboTextFormat.ItemIndex := 0
      else cboTextFormat.ItemIndex := 1;
      end;
      cbrambar.Checked := BoolValue('ShowRAMBar', cbrambar.Checked);
      cbraminfo.checked := BoolValue('ShowRAMInfo', cbraminfo.checked);
      cbrampc.Checked := BoolValue('ShowRAMPC', cbrampc.Checked);
      cbswpbar.Checked := BoolValue('ShowSWPBar', cbswpbar.Checked);
      cbswpinfo.Checked := BoolValue('ShowSWPInfo', cbswpinfo.Checked);
      cbswppc.Checked := BoolValue('ShowSWPPC', cbswppc.Checked);
      case IntValue('ItemAlign', 3) of
        1: cboAlignment.ItemIndex := 0;
        2: cboAlignment.ItemIndex := 1;
      else cboAlignment.ItemIndex := 2;
      end;
      sgbBarSize.Value := IntValue('Width', sgbBarSize.Value);
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmMM = nil then frmMM := TfrmMM.Create(nil);
  frmMM.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmMM);

  Load;
  result := PluginHost.Open(frmMM);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmMM);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Memory Monitor';
    Description := 'Memory Monitor Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
	Name := 'Memory Monitor';
    Description := 'Configure the Memory Monitor module';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmMM,AEditing,Theme);
end;

function InitPluginInterface(APluginHost: ISharpCenterHost): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.

