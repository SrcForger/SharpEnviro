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
  Dialogs,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  GR32,
  SharpThemeApi,
  JvPageList,
  GR32_PNG,
  GR32_RESAMPLERS,
  Graphics,

  uWPSettingsWnd in 'uWPSettingsWnd.pas' {frmWPSettings},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpDeskTDeskSettings in '..\..\..\Components\SharpDesk\Units\uSharpDeskTDeskSettings.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}

function LoadSettings: Boolean;
var
  XML: TJvSimpleXML;
  n, i, h, k: integer;
  s: string;
  WPItem: TWPItem;
  Mon: TMonitor;
  MonID: integer;
  failed: boolean;
  tmpRdo: TRadioButton;
begin
  Result := True;
    XML := TJvSimpleXML.Create(nil);
    try
      s := SharpApi.GetSharpeUserSettingsPath + 'Themes\' + frmWPSettings.FTheme + '\Wallpaper.xml';
      if FileExists(s) then
      begin
        XML.LoadFromFile(s);
        for n := 0 to Screen.MonitorCount - 1 do
        begin
          Mon := Screen.Monitors[n];
          if Mon.Primary then MonID := -100
          else MonID := Mon.MonitorNum;
          WPItem := TWPItem.Create;
          WPItem.MonID := MonID;
          WPItem.Mon := Mon;
          WPList.Add(WPItem);

          if XML.Root.Items.ItemNamed['Monitors'] <> nil then
            for i := 0 to XML.Root.Items.ItemNamed['Monitors'].Items.Count - 1 do
              if XML.Root.Items.ItemNamed['Monitors'].Items.Item[i].Items.IntValue('ID', 0) = MonID then
              begin
                // A Wallpaper for that monitor exists, now we need to find it
                if XML.Root.Items.ItemNamed['Wallpapers'] <> nil then
                  for h := 0 to XML.Root.Items.ItemNamed['Wallpapers'].Items.Count - 1 do
                    if CompareText(XML.Root.Items.ItemNamed['Wallpapers'].Items.Item[h].Items.Value('Name', '-2'),
                      XML.Root.Items.ItemNamed['Monitors'].Items.Item[i].Items.Value('Name', '-1')) = 0 then
                      with XML.Root.Items.ItemNamed['Wallpapers'].Items.Item[h].Items do
                      begin
                        // Found the matching wallpaper, load the settings
                        WPItem.Name := Value('Name');
                        WPItem.Image := Value('Image');
                        WPItem.Color := IntValue('Color', 0);
                        WPItem.Alpha := IntValue('Alpha', 255);
                        k := IntValue('Size', 0);
                        case k of
                          0: WPItem.Size := twsCenter;
                          2: WPItem.Size := twsStretch;
                          3: WPItem.Size := twsTile;
                        else WPItem.Size := twsScale;
                        end;
                        WPItem.ColorChange := BoolValue('ColorChange', False);
                        WPItem.Hue := IntValue('Hue', 0);
                        WPItem.Saturation := IntValue('Saturation', 0);
                        WPItem.Lightness := IntValue('Lightness', 0);
                        WPItem.Gradient := BoolValue('Gradient', False);
                        k := IntValue('GradientType', 0);
                        case k of
                          1: WPItem.GradientType := twgtVert;
                          2: WPItem.GradientType := twgtTSHoriz;
                          3: WPItem.GradientType := twgtTSVert
                        else WPItem.GradientType := twgtHoriz;
                        end;
                        WPItem.GDStartColor := IntValue('GDStartColor', 0);
                        WPItem.GDStartAlpha := IntValue('GDStartAlpha', 0);
                        WPItem.GDEndColor := IntValue('GDEndColor', 0);
                        WPItem.GDEndAlpha := IntValue('GDEndAlpha', 255);
                        WPItem.MirrorHoriz := BoolValue('MirrorHoriz', False);
                        WPItem.MirrorVert := BoolValue('MirrorVert', False);
                        break;
                      end;
                break;
              end;
          WPItem.LoadFromFile;
        end;
      end else
        Result := False;
        
    finally
      XML.Free;
    end;
end;


function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML: TJvSimpleXML;
  n, i, h, k: integer;
  WPItem: TWPItem;
  Mon: TMonitor;
  MonID: integer;
  failed: boolean;
  tmpRdo: TRadioButton;
begin

  // Create settings form
  if frmWPSettings = nil then frmWPSettings := TfrmWPSettings.Create(nil);
  uVistaFuncs.SetVistaFonts(frmWPSettings);
  frmWPSettings.ParentWindow := aowner;
  frmWPSettings.Left := 2;
  frmWPSettings.Top := 2;
  frmWPSettings.BorderStyle := bsNone;

  // Assign Plugin ID
  frmWPSettings.FTheme := APluginID;

  // Load settings, if not successfull create a default configuration
  if not (LoadSettings) then begin
    for n := 0 to Screen.MonitorCount - 1 do
    begin
      Mon := Screen.Monitors[n];
      if Mon.Primary then MonID := -100
      else MonID := Mon.MonitorNum;
      WPItem := TWPItem.Create;
      WPItem.MonID := MonID;
      WPItem.Mon := Mon;
      WPList.Add(WPItem);
    end;
  end;

  // Add available monitors to a dropdown combo
  for n := 0 to WPList.Count - 1 do begin
    if TWPItem(WPList.Items[n]).MonID = -100 then begin
      frmWPSettings.cboMonitor.Items.AddObject('Primary Monitor', WPList.Items[n]);
      frmWPSettings.FCurrentWP := TWPItem(WPList.Items[n]);
    end else begin
      frmWPSettings.cboMonitor.Items.AddObject(
        'Monitor ' + inttostr(n) + ' (' +
        inttostr(TWPItem(WPList.Items[n]).Mon.Width) + 'x' +
        inttostr(TWPItem(WPList.Items[n]).Mon.Height) + ')',
        WPList.Items[n]);
    end;
  end;

  // If one item then hide the monitor selection, select first item
  frmWPSettings.pnlMonitor.Visible := (frmWPSettings.cboMonitor.Items.Count > 1);
  frmWPSettings.cboMonitor.ItemIndex := 0;

  frmWPSettings.Show;
  frmWPSettings.UpdateGUIFromWPItem(frmWPSettings.FCurrentWP);
  frmWPSettings.RenderPreview;
  result := frmWPSettings.Handle;
end;

procedure Save;
var
  FName: string;
  sPngFile: String;
  n: integer;
  i: integer;
  WPItem: TWPItem;
  k: integer;
  XML: TJvsimpleXML;
  bmp: TBitmap32;
  r: Trect;
begin
  FName := SharpApi.GetSharpeUserSettingsPath + 'Themes\' + frmWPSettings.FTheme + '\Wallpaper.xml';
  XML := TJvSimpleXML.Create(nil);
  XML.Root.Clear;
  try
    if FileExists(FName) then
    begin
      try
        XML.LoadFromFile(FName);
      except
        XML.Root.Clear;
      end;
    end else XML.Root.Name := 'SharpEThemeWallpaper';

    // Update Monitors
    if XML.Root.Items.ItemNamed['Monitors'] = nil then
      XML.Root.Items.Add('Monitors');
    with XML.Root.Items.ItemNamed['Monitors'].Items do
    begin
      // Find and Delete all already existing monitors...
      for n := 0 to WPList.Count - 1 do
      begin
        WPItem := TWPItem(WPList.Items[n]);
        for i := Count - 1 downto 0 do
          if Item[i].Items.IntValue('ID', -1) = WPItem.MonID then
            Delete(i);
      end;
      // Add new Monitors
      for n := 0 to WPList.Count - 1 do
      begin
        WPItem := TWPItem(WPList.Items[n]);
        with Add('item').Items do
        begin
          if length(trim(WPItem.Name)) = 0 then
            WPItem.Name := inttostr(WPItem.MonID + random(900000) + 1);
          Add('Name', WPItem.Name);
          Add('ID', WPItem.MonID);
        end;
      end;
    end;

    // Update Wallpapers
    if XML.Root.Items.ItemNamed['Wallpapers'] = nil then
      XML.Root.Items.Add('Wallpapers');
    with XML.Root.Items.ItemNamed['Wallpapers'].Items do
    begin
      // Find and Delete all already existing Wallpapers
      for n := 0 to WPList.Count - 1 do
      begin
        WPItem := TWPItem(WPList.Items[n]);
        for i := Count - 1 downto 0 do
          if Item[i].Items.Value('Name', '-1') = WPItem.Name then
            Delete(i);
      end;

      // Add Wallpapers
      for n := 0 to WPList.Count - 1 do
      begin
        WPItem := TWPItem(WPList.Items[n]);
        with Add('item').Items do
        begin
          Add('Name', WPItem.Name);
          Add('Image', WPItem.Image);
          Add('Color', WPItem.Color);
          Add('Alpha', WPItem.Alpha);
          case WPItem.Size of
            twsCenter: k := 0;
            twsStretch: k := 2;
            twsTile: k := 3;
          else k := 1;
          end;
          Add('Size', k);
          Add('ColorChange', WPItem.ColorChange);
          Add('Hue', WPItem.Hue);
          Add('Saturation', WPItem.Saturation);
          Add('Lightness', WPItem.Lightness);
          Add('Gradient', WPItem.Gradient);
          case WPItem.GradientType of
            twgtVert: k := 1;
            twgtTSHoriz: k := 2;
            twgtTSVert: k := 3;
          else k := 0;
          end;
          Add('GradientType', k);
          Add('GDStartColor', WPItem.GDStartColor);
          Add('GDStartAlpha', WPItem.GDStartAlpha);
          Add('GDEndColor', WPItem.GDEndColor);
          Add('GDEndAlpha', WPItem.GDEndAlpha);
          Add('MirrorHoriz', WPItem.MirrorHoriz);
          Add('MirrorVert', WPItem.MirrorVert);
        end;
      end;
    end;
    XML.SaveToFile(FName + '~');
    if FileExists(FName) then
      DeleteFile(FName);
    RenameFile(FName + '~', FName);
  finally
    XML.Free;
  end;

  // Save image to theme dir
  sPngFile := ExtractFilePath(FName)+'preview.png';
  bmp := TBitmap32.Create;
  Try
    bmp.Width := 62;
    bmp.Height := 48;
    bmp.Clear(clWhite32);
    r := frmWPSettings.FCurrentWP.BmpPreview.ClipRect;
    InflateRect(r,-1,-1);

    frmWPSettings.FCurrentWP.BmpPreview.DrawTo(bmp, Rect(0,0,62,48), frmWPSettings.FCurrentWP.BmpPreview.ClipRect);

    SaveBitmap32ToPNG(bmp,sPngFile,False,False,clBlack);
  finally
    bmp.Free;
  End;
end;

function Close: boolean;
begin
  result := True;
  try
    frmWPSettings.Close;
    frmWPSettings.Free;
    frmWPSettings := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Wallpaper');
end;

procedure SetStatusText(var AStatusText: PChar);
begin
  AStatusText := '';
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure ClickTab(ATab: TPluginTabItem);
begin
  frmWPSettings.plConfig.ActivePage := TJvStandardPage(ATab.Data);
  if TJvStandardPage(ATab.Data) = frmWPSettings.pagWallpaper then
    frmWPSettings.UpdateWallpaperPage else
  if TJvStandardPage(ATab.Data) = frmWPSettings.pagColor then
    frmWPSettings.UpdateColorPage else
  if TJvStandardPage(ATab.Data) = frmWPSettings.pagGradient then
    frmWPSettings.UpdateGradientPage;
end;

procedure AddTabs(var ATabs: TPluginTabItemList);
var
  n: integer;
begin
  ATabs.Add('Wallpaper', frmWPSettings.pagWallpaper, '', '');
  ATabs.Add('Color', frmWPSettings.pagColor, '', '');
  ATabs.Add('Gradient', frmWPSettings.pagGradient, '', '');
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  result := suWallpaper;
end;

procedure UpdatePreview(var ABmp: TBitmap32);
begin
  if frmWPSettings.FCurrentWP = nil then
  begin
    ABmp.SetSize(0, 0);
    exit;
  end;

  ABmp.SetSize(frmWPSettings.FCurrentWP.BmpPreview.Width, frmWPSettings.FCurrentWP.BmpPreview.Height);
  ABmp.Clear(color32(0, 0, 0, 0));
  frmWPSettings.FCurrentWP.BmpPreview.DrawTo(ABmp);
end;


exports
  Open,
  Close,
  Save,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  SetSettingType,
  UpdatePreview,
  AddTabs,
  ClickTab;

end.

