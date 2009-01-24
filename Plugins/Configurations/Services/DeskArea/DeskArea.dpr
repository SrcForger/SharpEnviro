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
  SharpThemeApiEx,
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
  n, i: integer;
  daItem: TDAItem;
  mon: TMonitor;
  monId: integer;

const
  primaryId = -100;

begin
  PluginHost.Xml.XmlFilename := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\DeskArea\DeskArea.xml';
  if PluginHost.Xml.Load then begin

    with PluginHost.Xml.XmlRoot do begin

      for n := 0 to Screen.MonitorCount - 1 do
      begin
        mon := Screen.Monitors[n];
        if mon.Primary then
          monId := primaryId
        else
          monId := mon.MonitorNum;

        daItem := TDAItem.Create;
        daItem.monId := monId;
        daItem.mon := mon;
        DAList.Add(daItem);

        if Items.ItemNamed['Monitors'] <> nil then
          for i := 0 to Items.ItemNamed['Monitors'].Items.Count - 1 do
            if Items.ItemNamed['Monitors'].Items.Item[i].Items.IntValue('ID', 0) = monId then
              with Items.ItemNamed['Monitors'].Items.Item[i].Items do
              begin
                daItem.AutoMode := BoolValue('AutoMode', True);
                daItem.OffSets.Left := IntValue('Left', 0);
                daItem.OffSets.Top := IntValue('Top', 0);
                daItem.OffSets.Right := IntValue('Right', 0);
                daItem.OffSets.Bottom := IntValue('Bottom', 0);
                break;
              end;
        if monId = primaryId then
          frmSettings.UpdateGUIFromDAItem(daItem);
      end;
    end;
  end else begin

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
  frmSettings.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmSettings);

  Load;
  result := PluginHost.Open(frmSettings);
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmSettings);
end;

procedure TSharpCenterPlugin.Save;
var
  n : integer;
  daItem : TDAItem;
begin
  PluginHost.Xml.XmlFilename := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\DeskArea\DeskArea.xml';
  with PluginHost.Xml.XmlRoot do begin
    Name := 'SharpEDeskArea';

    Items.Add('Monitors');
    with Items.ItemNamed['Monitors'].Items do
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

    PluginHost.Xml.Save;
  end;
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

