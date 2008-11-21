{
Source Name: DeskArea
Description: DeskArea Configuration
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

library DeskArea;
uses
  Controls,
  Classes,
  Windows,
  SysUtils,
  Forms,
  Dialogs,
  JclSimpleXml,
  PngSpeedButton,
  SharpETabList,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SharpCenterApi,
  SharpApi,
  GR32,
  SharpThemeApi,
  uVistaFuncs,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings};

{$E .dll}
{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin,
      ISharpCenterPluginPreview, ISharpCenterPluginTabs)
  private
    procedure Load;
  public
    constructor Create(APluginHost: TInterfacedSharpCenterHostBase);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    procedure Save; override; stdcall;
    function GetPluginDescriptionText: string; override; stdcall;
    procedure Refresh; override; stdcall;
    procedure UpdatePreview(ABitmap: TBitmap32); stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
var
  n: integer;
begin
  if frmSettings <> nil then
  begin
    for n := 0 to DAList.Count - 1 do
      if TDAItem(DAList.Items[n]).MonID = -100 then
      begin
        ATabItems.AddObject('Primary Monitor', TDAItem(DAList.Items[n]));
        break;
      end;

    for n := 0 to DAList.Count - 1 do
      if TDAItem(DAList.Items[n]).MonID <> -100 then
        ATabItems.AddObject('Monitor (' + inttostr(n) + ')', TDAItem(DAList.Items[n]));
  end;
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
begin
  if ATab.FObject <> nil then
    frmSettings.UpdateGUIFromDAItem(TDAItem(ATab.FObject));
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: string;
begin
  Result := 'Define desktop area constraints.';
end;

procedure TSharpCenterPlugin.Load;
var
  xml: TJclSimpleXML;
  n, i: integer;
  fileName: string;
  daItem: TDAItem;
  mon: TMonitor;
  monId: integer;
  failed: boolean;
begin
  fileName := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\DeskArea\DeskArea.xml';

  failed := True;
  xml := Self.PluginHost.Xml;
  try
    if FileExists(fileName) then
    begin
      xml.LoadFromFile(fileName);
      for n := 0 to Screen.MonitorCount - 1 do
      begin
        mon := Screen.Monitors[n];
        if mon.Primary then
          monId := -100
        else
          monId := mon.MonitorNum;
        daItem := TDAItem.Create;
        daItem.monId := monId;
        daItem.mon := mon;
        DAList.Add(daItem);

        if xml.Root.Items.ItemNamed['Monitors'] <> nil then
          for i := 0 to xml.Root.Items.ItemNamed['Monitors'].Items.Count - 1 do
            if xml.Root.Items.ItemNamed['Monitors'].Items.Item[i].Items.IntValue('ID', 0) = monId then
              with xml.Root.Items.ItemNamed['Monitors'].Items.Item[i].Items do
              begin
                daItem.AutoMode := BoolValue('AutoMode', True);
                daItem.OffSets.Left := IntValue('Left', 0);
                daItem.OffSets.Top := IntValue('Top', 0);
                daItem.OffSets.Right := IntValue('Right', 0);
                daItem.OffSets.Bottom := IntValue('Bottom', 0);
                break;
              end;
        if monId = -100 then
          frmSettings.UpdateGUIFromDAItem(daItem);
      end;
      failed := False;
    end;
  except
  end;

  if Failed then
  begin
    DAList.Clear;

    for n := 0 to Screen.MonitorCount - 1 do
    begin
      mon := Screen.Monitors[n];
      if mon.Primary then
        monId := -100
      else
        monId := mon.MonitorNum;
      daItem := TDAItem.Create;
      daItem.monId := monId;
      daItem.mon := mon;
      DAList.Add(daItem);
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettings = nil then
    frmSettings := TfrmSettings.Create(nil);
  uVistaFuncs.SetVistaFonts(frmSettings);

  result := PluginHost.Open(frmSettings);
  frmSettings.PluginHost := PluginHost;
  Load;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForm(PluginHost.Theme, frmSettings);
end;

procedure TSharpCenterPlugin.Save;
var
  fileName,dir : String;
  n : integer;
  daItem : TDAItem;
  xml : TJclSimpleXML;
begin
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\DeskArea\';
  fileName := dir + 'DeskArea.xml';
  xml := PluginHost.Xml;
  xml.Root.Clear;

    xml.Root.Name := 'SharpEDeskArea';
    xml.Root.Items.Add('Monitors');
    with xml.Root.Items.ItemNamed['Monitors'].Items do
    begin
      for n := 0 to DAList.Count - 1 do
      begin
        daItem := TDAItem(DAList.Items[n]);
        with Add('item').Items do
        begin
          Add('ID',daItem.MonID);
          Add('AutoMode',daItem.AutoMode);
          Add('Left',daItem.OffSets.Left);
          Add('Top',daItem.OffSets.Top);
          Add('Right',daItem.OffSets.Right);
          Add('Bottom',daItem.OffSets.Bottom);
        end;
      end;
    end;

    if not DirectoryExists(dir) then
      ForceDirectories(dir);
    xml.SaveToFile(fileName + '~');
    if FileExists(fileName) then
       DeleteFile(fileName);
    RenameFile(fileName + '~',fileName);
end;

procedure TSharpCenterPlugin.UpdatePreview(ABitmap: TBitmap32);
begin
  frmSettings.UpdatePreview(ABitmap);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Desk Area';
    Description := 'Desk Area Service Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suDeskArea)]);
  end;
end;

function InitPluginInterface(APluginHost: TInterfacedSharpCenterHostBase): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

