{
Source Name: SharpDesk Configs
Description: SharpDesk Config Dll
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

library DesktopSettings;

uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  ComCtrls,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpETabList,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpDeskTDeskSettings,
  uSettingsWnd,
  SharpCenterApi,
  SharpApi,
  uSharpCenterPluginScheme in '..\..\..\..\Components\SharpCenter\uSharpCenterPluginScheme.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs )
  private
    FXmlDeskSettings: TDeskSettings;
    procedure LoadSettings;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    procedure Save; override; stdcall;

    procedure ClickPluginTab(ATab: TStringItem); stdCall;
    procedure AddPluginTabs(ATabItems: TStringList); stdCall;
    function GetPluginDescriptionText: String; override; stdCall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    destructor Destroy; override;

    property XmlDeskSettings: TDeskSettings read FXmlDeskSettings write
      FXmlDeskSettings;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('Desktop',frmSettings.tabDesktop);
  ATabItems.AddObject('Objects',frmSettings.tabObjects);
  ATabItems.AddObject('Menu',frmSettings.tabMenu);
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
begin
  TTabSheet(ATab.FObject).Show;
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  FXmlDeskSettings := TDeskSettings.Create(nil);
end;

destructor TSharpCenterPlugin.Destroy;
begin
  inherited;
  FXmlDeskSettings.Free;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'Define advanced desktop and wallpaper functionality.';
end;

procedure TSharpCenterPlugin.LoadSettings;
begin
  with frmSettings, FXmlDeskSettings do begin
    cb_grid.Checked := Grid;
    sgb_gridx.Value := GridX;
    sgb_gridy.Value := GridY;
    cb_singleclick.Checked := SingleClick;
    cb_amm.Checked := AdvancedMM;
    cb_dd.Checked := DragAndDrop;
    cb_wpwatch.Checked := WallpaperWatch;
    cb_autorotate.Checked := ScreenRotAdjust;
    cb_adjustsize.Checked := ScreenSizeAdjust;
    cb_useexplorer.Checked := UseExplorerDesk;
    BuildMenuList(MenuFile,MenuFileShift);
    UpdateExplorerStatus;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettings = nil then frmSettings := TfrmSettings.Create(nil);
  uVistaFuncs.SetVistaFonts(frmSettings);

  frmSettings.PluginHost := PluginHost;
  result := PluginHost.Open(frmSettings);
  
  LoadSettings;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
 // PluginHost.AssignThemeToPluginForm(frmSettings);
 AssignThemeToPluginForm(frmSettings,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
begin
  with frmSettings, FXmlDeskSettings do begin
    Grid  := cb_grid.Checked;
    GridX := sgb_gridx.Value;
    GridY := sgb_gridy.Value;
    SingleClick := cb_singleclick.Checked;
    AdvancedMM := cb_amm.Checked;
    DragAndDrop := cb_dd.Checked;
    WallpaperWatch := cb_wpwatch.Checked;
    ScreenRotAdjust := cb_autorotate.Checked;
    ScreenSizeAdjust := cb_adjustsize.Checked;
    MenuFile := cbMenuList.Text;
    MenuFileshift := cbMenuShift.Text;
    UseExplorerDesk := cb_useexplorer.Checked;
    SaveSettings;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Desktop';
    Description := 'Desktop Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suSharpDesk)]);
  end;
end;

function InitPluginInterface(APluginHost: ISharpCenterHost) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

