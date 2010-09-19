{
Source Name: Wallpaper
Description: Theme Wallpaper Configuration
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

library Wallpaper;
uses
//  VCLFixPack,
  Controls,
  StdCtrls,
  Classes,
  Buttons,
  Windows,
  Forms,
  Types,
  Dialogs,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  GR32,
  SharpThemeApiEx,
  uThemeConsts,
  uISharpETheme,
  uSharpETheme,
  SharpApi,
  JvPageList,
  JclSimpleXml,
  GR32_PNG,
  GR32_RESAMPLERS,
  Graphics,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginPreview,
      ISharpCenterPluginTabs)
  private
    FTheme : ISharpETheme;
    function Load: Boolean;
    procedure PopulateAvailableMonitors;
  public
    constructor Create(APluginHost: ISharpCenterHost);
    destructor Destroy; override;

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure UpdatePreview(ABitmap: TBitmap32); stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('Wallpaper', frmSettingsWnd.pagWallpaper);
  ATabItems.AddObject('Color', frmSettingsWnd.pagColor);
  ATabItems.AddObject('Gradient', frmSettingsWnd.pagGradient);
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
begin
  with frmSettingsWnd, frmSettingsWnd.plConfig do begin

    ActivePage := TJvStandardPage(ATab.FObject);
    if TJvStandardPage(ATab.FObject) = pagWallpaper then
      UpdateWallpaperPage else
      if TJvStandardPage(ATab.FObject) = pagColor then
        UpdateColorPage else
        if TJvStandardPage(ATab.FObject) = pagGradient then
          UpdateGradientPage;
  end;
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettingsWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  
  FTheme := TSharpETheme.Create(PluginHost.PluginID);
  FTheme.LoadTheme([tpWallpaper,tpSkinScheme]);
end;

destructor TSharpCenterPlugin.Destroy;
begin
  FTheme := nil;

  inherited Destroy;
end;

function TSharpCenterPlugin.Load: Boolean;
var
  wpItem: TWPItem;
  monitor: TMonitor;
  monitorId: integer;
  iScreenMonitor: integer;
begin
  result := true;

  FTheme.LoadTheme([tpWallpaper,tpSkinScheme]);

  for iScreenMonitor := 0 to Screen.MonitorCount - 1 do
  begin
    monitor := Screen.Monitors[iScreenMonitor];

    // Get primary monitor
    if monitor.Primary then
      monitorId := -100
    else
      monitorId := monitor.MonitorNum;

    // Create a new wallpaper item, and add to the list
    wpItem := TWPItem.Create;
    wpItem.MonID := monitorId;
    wpItem.Mon := monitor;
    wpList.Add(wpItem);

    with FTheme.Wallpaper.GetMonitorWallpaper(monitorID) do
    begin
      wpItem.Name := Name;
      wpItem.FileName := Image;
      wpItem.ColorStr := ColorStr;
      wpItem.Alpha := Alpha;
      wpItem.Size := Size;
      wpItem.ColorChange := ColorChange;
      wpItem.Hue := Hue;
      wpItem.Saturation := Saturation;
      wpItem.Lightness := Lightness;
      wpItem.Gradient := Gradient;
      wpItem.GradientType := GradientType;
      wpItem.GDStartColorStr := GDStartColorStr;
      wpItem.GDStartAlpha := GDStartAlpha;
      wpItem.GDEndColorStr := GDEndColorStr;
      wpItem.GDEndAlpha := GDEndAlpha;
      wpItem.MirrorHoriz := MirrorHoriz;
      wpItem.MirrorVert := MirrorVert;
      wpItem.SwitchPath := SwitchPath;
      wpItem.SwitchRecursive := SwitchRecursive;
      wpItem.SwitchRandomize := SwitchRandomize;
      wpItem.SwitchTimeout := SwitchTimer;
      wpItem.Switch := Switch;
    end;
    wpItem.LoadFromFile;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettingsWnd = nil then frmSettingsWnd := TfrmSettingsWnd.Create(nil);
  frmSettingsWnd.Theme := FTheme;
  uVistaFuncs.SetVistaFonts(frmSettingsWnd);
  frmSettingsWnd.PluginHost := PluginHost;

  // Load the settings from the xml file
  Load;
  result := PluginHost.Open(frmSettingsWnd);

  // Refresh gui and render preview
  PopulateAvailableMonitors;
  frmSettingsWnd.UpdateGUIFromWPItem(frmSettingsWnd.CurrentWP);
end;

procedure TSharpCenterPlugin.PopulateAvailableMonitors;
var
  i: Integer;
begin
  with frmSettingsWnd do begin
    for i := 0 to WPList.Count - 1 do begin
      if TWPItem(WPList.Items[i]).MonID = -100 then begin
        cboMonitor.Items.AddObject('Primary Monitor', WPList.Items[i]);
        CurrentWP := TWPItem(WPList.Items[i]);
      end else begin
        cboMonitor.Items.AddObject(
          'Monitor ' + inttostr(i) + ' (' +
          inttostr(TWPItem(WPList.Items[i]).Mon.Width) + 'x' +
          inttostr(TWPItem(WPList.Items[i]).Mon.Height) + ')',
          WPList.Items[i]);
      end;
    end;

    // If one item then hide the monitor selection, select first item
    pnlMonitor.Visible := (cboMonitor.Items.Count > 1);
    cboMonitor.ItemIndex := 0;
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettingsWnd,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  iWpItem: integer;
  wpItem: TWPItem;

  Mon : TWallpaperMonitor;
  MonWall : TThemeWallpaperItem;
begin

  // Update Monitors
  for iWpItem := 0 to WPList.Count - 1 do
  begin
    wpItem := TWPItem(WPList.Items[iWpItem]);
    Mon.Name := wpItem.Name;
    Mon.ID := wpITem.MonID;
    FTheme.Wallpaper.UpdateMonitor(Mon);
  end;

  for iWpItem := 0 to WPList.Count - 1 do
  begin
    wpItem := TWPItem(WPList.Items[iWpItem]);
    with MonWall do
    begin
      Name            := wpItem.Name;
      Image           := wpItem.FileName;
      ColorStr        := wpItem.ColorStr;
      Alpha           := wpItem.Alpha;
      Size            := wpItem.Size;
      ColorChange     := wpItem.ColorChange;
      Hue             := wpItem.Hue;
      Saturation      := wpItem.Saturation;
      Lightness       := wpItem.Lightness;
      Gradient        := wpItem.Gradient;
      GradientType    := wpItem.GradientType;
      GDStartColorStr := wpItem.GDStartColorStr;
      GDStartAlpha    := wpItem.GDStartAlpha;
      GDEndColorStr   := wpItem.GDEndColorStr ;
      GDEndAlpha      := wpItem.GDEndAlpha;
      MirrorHoriz     := wpItem.MirrorHoriz;
      MirrorVert      := wpItem.MirrorVert;
      SwitchPath      := wpItem.SwitchPath;
      SwitchRecursive := wpItem.SwitchRecursive;
      SwitchRandomize := wpItem.SwitchRandomize;
      SwitchTimer     := wpItem.SwitchTimeout;
      Switch          := wpItem.Switch;
    end;
    FTheme.Wallpaper.UpdateWallpaper(MonWall);
  end;

  FTheme.Wallpaper.SaveToFile;
end;

procedure TSharpCenterPlugin.UpdatePreview(ABitmap: TBitmap32);
begin
  if ((frmSettingsWnd.CurrentWP = nil) or (frmSettingsWnd.CurrentWP.FileName = '')) then
  begin
    ABitmap.SetSize(0, 0);
    exit;
  end;

  ABitmap.SetSize(frmSettingsWnd.CurrentWP.BmpPreview.Width, frmSettingsWnd.CurrentWP.BmpPreview.Height);
  ABitmap.Clear(color32(0, 0, 0, 0));
  frmSettingsWnd.CurrentWP.BmpPreview.DrawTo(ABitmap);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Wallpaper';
    Description := 'Wallpaper Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suWallpaper)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
	  Name := 'Wallpaper';
    Description := Format('Wallpaper Configuration for "%s"',[pluginID]);
	  Status := '';
  end;
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

