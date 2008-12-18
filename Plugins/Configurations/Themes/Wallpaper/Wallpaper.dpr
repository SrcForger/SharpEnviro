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
  Controls,
  StdCtrls,
  Classes,
  Buttons,
  Windows,
  Forms,
  Types,
  Dialogs,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  GR32,
  SharpThemeApi,
  SharpApi,
  JvPageList,
  JclSimpleXml,
  GR32_PNG,
  GR32_RESAMPLERS,
  Graphics,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginPreview,
      ISharpCenterPluginTabs)
  private
    function Load: Boolean;
    procedure PopulateAvailableMonitors;
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

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: string;
begin
  Result := Format('Wallpaper Configuration for "%s"', [PluginHost.PluginId]);
end;

function TSharpCenterPlugin.Load: Boolean;
var
  iScreenMonitor, iMonitor, iWallpaper, val: integer;
  wpItem: TWPItem;
  monitor: TMonitor;
  monitorId: integer;

  elemMonitors, elemWallpapers: TJclSimpleXMLElem;
begin
  result := true;

  PluginHost.Xml.XmlFilename := XmlGetWallpaperFile(PluginHost.PluginId);
  if PluginHost.Xml.Load then begin
    with PluginHost.Xml.XmlRoot do begin

      for iScreenMonitor := 0 to Pred(Screen.MonitorCount) do
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
        WPList.Add(wpItem);

        // Get the monitors xml element
        elemMonitors := Items.ItemNamed['Monitors'];

        if elemMonitors <> nil then

          // Enumerate available monitors
          for iMonitor := 0 to elemMonitors.Items.Count - 1 do
            if elemMonitors.Items.Item[iMonitor].Items.IntValue('ID', 0) = monitorId then
            begin

              // A Wallpaper for that monitor exists, now we need to find it
              // Get the wallpaper xml element
              elemWallpapers := Items.ItemNamed['Wallpapers'];

              if elemWallpapers <> nil then
                for iWallpaper := 0 to elemWallpapers.Items.Count - 1 do

                  if CompareText(elemWallpapers.Items.Item[iWallpaper].Items.Value('Name', '-2'),
                    elemMonitors.Items.Item[iMonitor].Items.Value('Name', '-1')) = 0 then
                    with elemWallpapers.Items.Item[iWallpaper].Items do
                    begin

                      // Found the matching wallpaper, load the settings
                      {$REGION 'Load Wallpaper settings'}
                      wpItem.Name := Value('Name');
                      wpItem.FileName := Value('Image');
                      wpItem.Color := IntValue('Color', 0);
                      wpItem.Alpha := IntValue('Alpha', 255);
                      val := IntValue('Size', 0);
                      case val of
                        0: wpItem.Size := twsCenter;
                        2: wpItem.Size := twsStretch;
                        3: wpItem.Size := twsTile;
                      else wpItem.Size := twsScale;
                      end;
                      wpItem.ColorChange := BoolValue('ColorChange', False);
                      wpItem.Hue := IntValue('Hue', 0);
                      wpItem.Saturation := IntValue('Saturation', 0);
                      wpItem.Lightness := IntValue('Lightness', 0);
                      wpItem.Gradient := BoolValue('Gradient', False);
                      val := IntValue('GradientType', 0);
                      case val of
                        1: wpItem.GradientType := twgtVert;
                        2: wpItem.GradientType := twgtTSHoriz;
                        3: wpItem.GradientType := twgtTSVert
                      else wpItem.GradientType := twgtHoriz;
                      end;
                      wpItem.GDStartColor := IntValue('GDStartColor', 0);
                      wpItem.GDStartAlpha := IntValue('GDStartAlpha', 0);
                      wpItem.GDEndColor := IntValue('GDEndColor', 0);
                      wpItem.GDEndAlpha := IntValue('GDEndAlpha', 255);
                      wpItem.MirrorHoriz := BoolValue('MirrorHoriz', False);
                      wpItem.MirrorVert := BoolValue('MirrorVert', False);
{$ENDREGION}

                      break;
                    end;
              break;
            end;
        wpItem.LoadFromFile;
      end
    end
  end
  else begin

    // if not successfull create a default configuration
    for iMonitor := 0 to Screen.MonitorCount - 1 do
    begin
      monitor := Screen.Monitors[iMonitor];
      if monitor.Primary then monitorId := -100
      else monitorId := monitor.MonitorNum;

      WPItem := TWPItem.Create;
      WPItem.MonID := monitorId;
      WPItem.Mon := monitor;
      WPList.Add(WPItem);
    end;

  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin

  if frmSettingsWnd = nil then frmSettingsWnd := TfrmSettingsWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmSettingsWnd);
  frmSettingsWnd.PluginHost := PluginHost;

  // Load the settings from the xml file
  Load;
  result := PluginHost.Open(frmSettingsWnd);

  // Refresh gui and render preview
  PopulateAvailableMonitors;
  frmSettingsWnd.UpdateGUIFromWPItem(frmSettingsWnd.CurrentWP);

  // Refresh the preview
  PluginHost.Refresh(rtPreview);

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

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForm(PluginHost.Theme, frmSettingsWnd);
end;

procedure TSharpCenterPlugin.Save;
var
  filename: string;
  pngFile: string;
  iWpItem: integer;
  i: integer;
  wpItem: TWPItem;
  val: integer;
  bmp: TBitmap32;
  r: Trect;

  elemMonitors, elemWallpapers: TJclSimpleXMLElem;
begin
  PluginHost.Xml.XmlFilename := XmlGetWallpaperFile(PluginHost.PluginId);
  with PluginHost.Xml.XmlRoot, frmSettingsWnd do begin
    Name := 'SharpEThemeWallpaper';

    // Update Monitors
    elemMonitors := Items.ItemNamed['Monitors'];

    if elemMonitors = nil then
      elemMonitors := Items.Add('Monitors');

    with elemMonitors.Items do
    begin
      {$REGION 'Find and Delete all already existing monitors'}
      for iWpItem := 0 to WPList.Count - 1 do
      begin
        wpItem := TWPItem(WPList.Items[iWpItem]);
        for i := Count - 1 downto 0 do
          if Item[i].Items.IntValue('ID', -1) = wpItem.MonID then
            Delete(i);
      end;
{$ENDREGION}

      {$REGION 'Add new monitors'}
      for iWpItem := 0 to WPList.Count - 1 do
      begin
        wpItem := TWPItem(WPList.Items[iWpItem]);
        with Add('item').Items do
        begin
          if length(trim(wpItem.Name)) = 0 then
            wpItem.Name := inttostr(wpItem.MonID + random(900000) + 1);
          Add('Name', wpItem.Name);
          Add('ID', wpItem.MonID);
        end;
      end;
{$ENDREGION}
    end;

    // Update Wallpapers
    elemWallpapers := Items.ItemNamed['Wallpapers'];

    if elemWallpapers = nil then
      elemWallpapers := Items.Add('Wallpapers');

    with elemWallpapers.Items do
    begin

      {$REGION 'Find and delete all existing wallpapers'}
      for iWpItem := 0 to WPList.Count - 1 do
      begin
        wpItem := TWPItem(WPList.Items[iWpItem]);
        for i := Count - 1 downto 0 do
          if Item[i].Items.Value('Name', '-1') = wpItem.Name then
            Delete(i);
      end;
{$ENDREGION}

      {$REGION 'Add wallpapers'}
      for iWpItem := 0 to WPList.Count - 1 do
      begin
        wpItem := TWPItem(WPList.Items[iWpItem]);
        with Add('item').Items do
        begin
          Add('Name', wpItem.Name);
          Add('Image', wpItem.FileName);
          Add('Color', wpItem.Color);
          Add('Alpha', wpItem.Alpha);
          case wpItem.Size of
            twsCenter: val := 0;
            twsStretch: val := 2;
            twsTile: val := 3;
          else val := 1;
          end;
          Add('Size', val);
          Add('ColorChange', wpItem.ColorChange);
          Add('Hue', wpItem.Hue);
          Add('Saturation', wpItem.Saturation);
          Add('Lightness', wpItem.Lightness);
          Add('Gradient', wpItem.Gradient);
          case wpItem.GradientType of
            twgtVert: val := 1;
            twgtTSHoriz: val := 2;
            twgtTSVert: val := 3;
          else val := 0;
          end;
          Add('GradientType', val);
          Add('GDStartColor', wpItem.GDStartColor);
          Add('GDStartAlpha', wpItem.GDStartAlpha);
          Add('GDEndColor', wpItem.GDEndColor);
          Add('GDEndAlpha', wpItem.GDEndAlpha);
          Add('MirrorHoriz', wpItem.MirrorHoriz);
          Add('MirrorVert', wpItem.MirrorVert);
        end;
      end;
{$ENDREGION}
    end;

    PluginHost.Xml.Save;

    {$REGION 'Save wallpaper preview'}
      pngFile := ExtractFilePath(filename) + 'preview.png';
          bmp := TBitmap32.Create;
          try
            bmp.Width := 62;
            bmp.Height := 48;
            bmp.Clear(clWhite32);
            r := CurrentWP.BmpPreview.ClipRect;
            InflateRect(r, -1, -1);
      
            CurrentWP.BmpPreview.DrawTo(bmp, Rect(0, 0, 62, 48), CurrentWP.BmpPreview.ClipRect);
      
            if FileCheck(pngFile) then
              SaveBitmap32ToPNG(bmp, pngFile, False, False, clBlack);
          finally
            bmp.Free;
          end;
    {$ENDREGION}

  end;
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
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suWallpaper)]);
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

