{
Source Name: uSharpDeskBackgroundUnit.pas
Description: Unit for handling background image drawing
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

Unit uSharpDeskBackgroundUnit;

Interface

uses Windows,Graphics,SysUtils,Forms,SharpApi,Classes,Dialogs,Types,ExtCtrls, StdCtrls,
     GR32,Math,GR32_blend,GR32_Image, GR32_resamplers,GR32_Backends,
     PngImage, Registry,Messages, SharpThemeApiEx, uThemeConsts,
     GR32_PNG, Jpeg, uISharpETheme,
     MonitorList,
     SharpSharedFileAccess,
     SharpGraphicsUtils,
     SharpImageUtils;

type
  TWallpaper = record
    Enabled: Boolean;
    OldTime: uint;
    Interval: uint;
    MonitorID: integer;
    ShouldSkip: Boolean; // Used for !NextWallpaper
  end;
  TWallpapers = array of TWallpaper;

  TBackground = class
  private
    FWallpaperTimer : TTimer;
    FWallpapers: TWallpapers;
    
  public
    constructor Create;
    destructor Destroy; override;

    function ReloadMonitor(PMon : TMonitor; monID : integer; isSchemeChange : boolean) : boolean;
    procedure ReloadWindows;
    procedure Reload(isSchemeChange : boolean);

    procedure ApplyEffects(var Bmp : TBitmap32; Mon : TThemeWallpaperItem);

    procedure LoadWallpaperChanger;

    property Wallpapers: TWallpapers read FWallpapers write FWallpapers;
    property WallpaperTimer: TTimer read FWallpaperTimer write FWallpaperTimer;
    
  protected
    procedure WallpaperTimerOnTimer(Sender: TObject);

  end;

Implementation


uses uSharpDeskMainForm;

// ######################################


procedure TBackground.ApplyEffects(var Bmp : TBitmap32; Mon : TThemeWallpaperItem);
begin
  if (Mon.Gradient) and ((Mon.GDStartAlpha<>255) or (Mon.GDEndAlpha<>255)) then
     ApplyGradient(Bmp, Mon.GradientType, Mon.GDStartColor,Mon.GDEndColor,
                   Mon.GDStartAlpha,Mon.GDEndAlpha);
end;


// ######################################


constructor TBackground.Create;
begin
  SetLength(FWallpapers, 0);

  FWallpaperTimer := TTimer.Create(nil);
  FWallpaperTimer.Enabled := False;
  FWallpaperTimer.OnTimer := WallpaperTimerOnTimer;
  FWallpaperTimer.Interval := 1000;
end;


// ######################################


destructor TBackground.Destroy;
begin
  SetLength(FWallpapers, 0);

  if Assigned(FWallpaperTimer) then
    FreeAndNil(FWallpaperTimer);

  Disabled := True;
  SharpDeskMainForm.BackgroundImage.Layers.Clear;

  inherited;
end;

procedure TBackground.WallpaperTimerOnTimer(Sender: TObject);
var
  i: integer;
  hasChanged: boolean;
begin
  if Length(FWallpapers) <> Screen.MonitorCount then
  begin
    // Reload wallpapers
    GetCurrentTheme.LoadTheme([tpWallpaper]);
    LoadWallpaperChanger;
    exit;
  end;

  hasChanged := False;
  for i := Low(FWallpapers) to High(FWallpapers) do
  begin
    if (FWallpapers[i].Enabled) and
          ((GetCurrentTime - FWallpapers[i].OldTime >= FWallpapers[i].Interval) or
            (FWallpapers[i].ShouldSkip)) then
    begin
      if GetCurrentTheme.Wallpaper.UpdateAutomaticWallpaper(FWallpapers[i].MonitorID) then
        hasChanged := True;

      FWallpapers[i].OldTime := GetCurrentTime;
      FWallpapers[i].ShouldSkip := False;
    end;
  end;

  if hasChanged then
  begin
    Reload(false);

    if not SharpDeskMainForm.Visible then
      SharpDeskMainForm.BackgroundImage.Bitmap.SetSize(0, 0);

    SharpDeskMainForm.BackgroundImage.ForceFullInvalidate;
    if SharpDesk.BackgroundLayer <> nil then
    begin
      SharpDesk.BackgroundLayer.Update;
      SharpDesk.BackgroundLayer.Changed;
    end;
    SharpApi.BroadcastGlobalUpdateMessage(suDesktopBackgroundChanged,-1,True);
  end;
end;

procedure TBackground.LoadWallpaperChanger;
var
  MonID : Integer;
  WP : TThemeWallpaperItem;
  hasTimer: Boolean;
  i: integer;
begin
  // Clear out old wallpapers
  SetLength(FWallpapers, 0);
  SetLength(FWallpapers, Screen.MonitorCount);

  hasTimer := False;
  for i := 0 to High(FWallpapers) do
  begin
    if Screen.Monitors[i].Primary then
      MonID := -100
    else
      MonID := Screen.Monitors[i].MonitorNum;

    WP := GetCurrentTheme.Wallpaper.GetMonitorWallpaper(MonID);
    if (WP.Switch) and (WP.SwitchTimer > 0) then
    begin
      FWallpapers[i].Enabled := True;
      FWallpapers[i].OldTime := GetCurrentTime;
      FWallpapers[i].Interval := WP.SwitchTimer;
      FWallpapers[i].MonitorID := MonID;
      FWallpapers[i].ShouldSkip := False;
      hasTimer := True;
    end else
      FWallpapers[i].Enabled := False;
  end;

  FWallpaperTimer.Enabled := hasTimer;
end;

// ######################################


function TBackground.ReloadMonitor(PMon : TMonitor; MonID : integer; isSchemeChange : boolean) : boolean;
var
  Theme : ISharpETheme;
  WP : TThemeWallpaperItem;
  
  img : TBitmap32;

  MonRect : TRect;
  TempBmp,DrawBmp : TBitmap32;

  loaded : boolean;
  SList : TStringList;

  i : integer;
  x,y,ny,nx : integer;
  w,h : integer;
  Re : TRect;
  
  RMode : boolean;
begin
  Result := False;

  Theme := GetCurrentTheme;
  WP := Theme.Wallpaper.GetMonitorWallpaper(MonID);

  img := SharpDesk.Image.Bitmap;
  img.SetSize(Screen.DesktopWidth,Screen.DesktopHeight);

  // only update if scheme color changes and scheme colors are used
  if (isSchemeChange) and (StrToIntDef(WP.ColorStr,-1) >= 0)
    and (((StrToIntDef(WP.GDStartColorStr,-1) >= 0)
    or (StrToIntDef(WP.GDEndColorStr,-1) >= 0)) or (not WP.Gradient)) then
      exit;

  // at least one wallpaper has changed;
  Result := True;

  // Find the top-left position of the wallpaper
  MonRect.TopLeft := SharpDesk.Image.ScreenToClient(Point(PMon.Left,PMon.Top));
  MonRect.BottomRight := SharpDesk.Image.ScreenToClient(Point(PMon.Left+PMon.Width,
                                                                PMon.Top+PMon.Height));
  RMode := (PMon.Width < PMon.Height) and (SharpDesk.DeskSettings.ScreenRotAdjust);

  // Background
  img.FillRect(MonRect.Left,MonRect.Top,MonRect.Right,MonRect.Bottom,color32(WP.Color));

  // Image Loading
  TempBmp := TBitmap32.Create;
  DrawBmp := TBitmap32.Create;
  try
  DrawBmp.DrawMode := dmBlend;
  DrawBmp.CombineMode := cmMerge;
  DrawBmp.MasterAlpha := WP.Alpha;

  TLinearResampler.Create(TempBmp);
  TLinearResampler.Create(DrawBmp);

  loaded := False;
  SList := TStringList.Create;
  try
    SList.Add(Theme.Info.Directory + '\' + WP.Image);
    SList.Add(WP.Image);
    SList.Add(SharpApi.GetSharpeDirectory + WP.Image);
    for i := 0 to SList.Count - 1 do
    begin
      if FileExists(SList[i]) then
      begin
        try
          TempBmp.LoadFromFile(SList[i]);
          loaded := True;
          break;
        except
        end;
      end;
    end;
  finally
    SList.Free;
  end;

  if not loaded then
  begin
    TempBmp.SetSize(MonRect.Right-MonRect.Left,MonRect.Bottom-MonRect.Top);
    TempBmp.Clear(Color32(WP.Color));
  end;

  if RMode then
  begin
    h := MonRect.Right - MonRect.Left;
    w := MonRect.Bottom - MonRect.Top;
  end else
  begin
    w := MonRect.Right - MonRect.Left;
    h := MonRect.Bottom - MonRect.Top;
  end;

  // HSL Effects
  if WP.ColorChange then
    HSLChangeImage(TempBmp,WP.Hue,WP.Saturation,WP.Lightness);

  // Mirror Image?
  if WP.MirrorHoriz then
    TempBmp.Canvas.CopyRect(Rect(TempBmp.Width,0,0,TempBmp.Height),TempBmp.Canvas,Rect(0,0,TempBmp.Width,TempBmp.Height));
  if WP.MirrorVert then
    TempBmp.Canvas.CopyRect(Rect(0,TempBmp.Height,TempBmp.Width,0),TempBmp.Canvas,Rect(0,0,TempBmp.Width,TempBmp.Height));

  DrawBmp.SetSize(w,h);

  // Draw Image and Apply Effects
  case WP.Size of
    twsStretch :
    begin
      img.BeginUpdate;
      DrawBmp.Draw(DrawBmp.Canvas.ClipRect,TempBmp.Canvas.ClipRect,TempBmp);
      ApplyEffects(DrawBmp,WP);
      if RMode then
        DrawBmp.Rotate90;
      img.Draw(MonRect.Left,MonRect.Top,DrawBmp);
      img.EndUpdate;
    end;

    twsTile :
    begin
      if TempBmp.Height = h then
        y := 1
      else
        y := round(Int((h) / TempBmp.Height)) + 1;

      if TempBmp.Width = w then
        x := 1
      else
        x := round(Int((w) / TempBmp.Width)) + 1;

      img.BeginUpdate;
      for ny := 0 to y - 1 do
        for nx := 0 to x - 1 do
          DrawBmp.Draw(nx * TempBmp.Width, ny * TempBmp.Height, TempBmp);

      ApplyEffects(DrawBmp,WP);
      if RMode then
        DrawBmp.Rotate90;
      img.Draw(MonRect.Left,MonRect.Top,DrawBmp);
      img.EndUpdate;
    end;

    twsCenter :
    begin
      DrawBmp.Clear(color32(WP.Color));
      img.BeginUpdate;

      DrawBmp.Draw(w div 2 - TempBmp.Width div 2, h div 2 - TempBmp.Height div 2, TempBmp);
      ApplyEffects(DrawBmp,WP);
      if RMode then
        DrawBmp.Rotate90;

      img.Draw(MonRect.Left,MonRect.Top,DrawBmp);
      img.EndUpdate;
    end;

    twsScale:
    begin
      DrawBmp.Clear(color32(WP.Color));
      Re := Rect(0,0,0,0);
      if (TempBmp.Width / TempBmp.Height) = (w / h) then
          Re := Rect(0, 0, w, h)
      else if (TempBmp.Width / TempBmp.Height) > (w / h) then
      begin
        Re.Left := 0;
        Re.Top := round((h div 2 - ((w / TempBmp.Width) * TempBmp.Height) / 2));
        Re.Right := w;
        Re.bottom := round((h div 2 + ((w / TempBmp.Width) * TempBmp.Height) / 2));
      end else
      begin
        Re.Left := round((w div 2 - ((h / TempBmp.Height) * TempBmp.Width) / 2));
        Re.Top := 0;
        Re.Right := round((w div 2 + ((h / TempBmp.Height) * TempBmp.Width) / 2));
        Re.bottom := h;
      end;
      img.BeginUpdate;

      DrawBmp.Draw(Re,TempBmp.Canvas.ClipRect,TempBmp);
      ApplyEffects(DrawBmp,WP);
      if RMode then
        DrawBmp.Rotate90;

      img.Draw(MonRect.Left,MonRect.Top,DrawBmp);
      img.EndUpdate;
    end;
  end;
  finally
    TempBmp.Free;
    DrawBmp.Free;
  end;
end;

procedure TBackground.ReloadWindows;
var
  Theme : ISharpETheme;
  SharpWallpaper, ExplorerWallpaper: string;
  Reg : TRegistry;

  ExplorerBmp : TBitmap;
  OutBmp, TempBGBmp, MonBmp : TBitmap32;
  
  Stream : TSharedFileStream;

  Left: integer;
  tl, br: TPoint;
  i: integer;

  TempBmp : TBitmap32;
begin
  Theme := GetCurrentTheme;

  SharpWallpaper := SharpApi.GetSharpeUserSettingsPath + 'SharpDeskbg.bmp';
  ExplorerWallpaper := SharpApi.GetSharpeUserSettingsPath + 'ExplorerWallpaper.bmp';

  // The explorer desktop wants the primary monitor first and then the other monitors, so revert it here
  OutBmp := TBitmap32.Create;
  OutBmp.SetSize(SharpDesk.Image.Width, SharpDesk.Image.Height);
  TempBGBmp := TBitmap32.Create;
  TempBGBmp.Assign(SharpDesk.Image.Bitmap);
  MonBmp := TBitmap32.Create;

  Left := 0;
  for i := 0 to MonList.MonitorCount - 1 do
  begin
    MonBmp.SetSize(MonList.Monitors[i].Width, MonList.Monitors[i].Height);
    MonBmp.Clear(color32(0,0,0,0));

    tl := SharpDesk.Image.ScreenToClient(Point(MonList.Monitors[i].Left, MonList.Monitors[i].Top));
    br := SharpDesk.Image.ScreenToClient(Point(MonList.Monitors[i].Left + MonList.Monitors[i].Width, MonList.Monitors[i].Top + MonList.Monitors[i].Height));
    TempBGBmp.DrawTo(MonBmp,
        Rect(0, 0, MonBmp.Width, MonBmp.Height),
        Rect(tl.X, tl.Y, br.X, br.Y));

    MonBmp.DrawTo(OutBmp, Left, MonList.Monitors[i].Top);
    Left := Left + MonBmp.Width;
  end;

  MonBmp.Free;

  ExplorerBmp := TBitmap.Create;

  // Write SharpDesk wallpaper
  ExplorerBmp.Assign(TempBGBmp);
  if OpenFileStreamShared(Stream, sfaCreate, SharpWallpaper, True) = sfeSuccess then
  begin
    Stream.Size := 0;
    ExplorerBmp.SaveToStream(Stream);
    Stream.Free;
  end;

  // Write explorer wallpaper
  ExplorerBmp.Assign(OutBmp);
  if OpenFileStreamShared(Stream, sfaCreate, ExplorerWallpaper, True) = sfeSuccess then
  begin
    Stream.Size := 0;
    ExplorerBmp.SaveToStream(Stream);
    Stream.Free;
  end;
  ExplorerBmp.Free;
  TempBGBmp.Free;
  OutBmp.Free;

  // save the preview bitmap
  TempBmp := TBitmap32.Create;
  RescaleImage(SharpDesk.Image.Bitmap,TempBmp,62,48,True);
  if not DirectoryExists(Theme.Info.Directory) then
    ForceDirectories(Theme.Info.Directory);
  if OpenFileStreamShared(Stream, sfaCreate, Theme.Info.Directory + '\preview.png', True) = sfeSuccess then
  begin
    Stream.Size := 0;
    SaveBitmap32ToPNG(TempBmp,Stream,False,True,clWhite);
    Stream.Free;
  end;
  TempBmp.Free;

  //SharpApi.SendDebugMessageEx('SharpDesk',PChar(('Background - Set Win Wallpaper : ') + WP.Name),clblue,DMT_trace);
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\Control Panel\Desktop\',False);
    Reg.WriteString('Wallpaper', ExplorerWallpaper);
    Reg.WriteString('WallpaperStyle', '0');
    Reg.WriteString('TileWallpaper', '1');
    Reg.OpenKey('\Software\Microsoft\Internet Explorer\Desktop\General',False);
    Reg.WriteString('BackupWallpaper', ExplorerWallpaper);
    Reg.WriteString('Wallpaper', ExplorerWallpaper);
    Reg.WriteString('WallpaperStyle', '0');
    Reg.WriteString('TileWallpaper', '1');
    Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Themes\LastTheme',False);
    Reg.WriteString('Wallpaper', ExplorerWallpaper);
    SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDCHANGE);
  except
      //SharpApi.SendDebugMessageEx('SharpDesk',PChar(('Failed to Send SPI_SETDESKWALLPAPER') + WP.Name),clblue,DMT_ERROR);
  end;
  Reg.Free;
  
  SendMessage(FindWindow('Progman','Program Manager'),WM_COMMAND,106597, 0);
end;

procedure TBackground.Reload(isSchemeChange : boolean);
var
  n : integer;
  PMon : TMonitor;
  MonID : integer;

  WPChanged : boolean;
begin
  SharpDeskMainForm.Monitor; // make it update the TScreen Monitor Data

  WPChanged := False;
  for n := 0 to Screen.MonitorCount - 1 do
  begin
    PMon := Screen.Monitors[n];
    if PMon.Primary then
       MonID := -100
    else
      MonID := PMon.MonitorNum;

    if (ReloadMonitor(PMon, MonID, isSchemeChange)) and (not WPChanged) then
      WPChanged := true;

  end;

  if WPChanged then
    ReloadWindows;
end;



end.
