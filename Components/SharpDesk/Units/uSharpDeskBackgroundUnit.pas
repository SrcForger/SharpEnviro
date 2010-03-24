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
     SharpGraphicsUtils,
     SharpImageUtils;

type
  TWallpaperTimer = class
  private
    WallTimer : TTimer;
  public
    constructor Create(const Interval: integer; Event: TNotifyEvent; const Tag: integer);
    destructor Destroy; override;

    property Timer: TTimer read WallTimer write WallTimer;
  end;

  TBackground = Object
  public
    procedure Create;
    procedure Destroy;

    function ReloadMonitor(PMon : TMonitor; monID : integer; isSchemeChange : boolean) : boolean;
    procedure ReloadWindows;
    procedure Reload(isSchemeChange : boolean);

    procedure ApplyEffects(var Bmp : TBitmap32; Mon : TThemeWallpaperItem);

    procedure LoadWallpaperChanger(Event: TNotifyEvent);
    procedure UnloadWallpaperChanger;

  private
    WallpaperTimer : Array of TWallpaperTimer;

  end;

Implementation


uses uSharpDeskMainForm;



constructor TWallpaperTimer.Create(const Interval: integer; Event: TNotifyEvent; const Tag: integer);
begin
  WallTimer := TTimer.Create(nil);
  WallTimer.Enabled := False;
  WallTimer.Tag := Tag;
  WallTimer.Interval := Interval;
  WallTimer.OnTimer := Event;
end;

destructor TWallpaperTimer.Destroy;
begin
  WallTimer.Enabled := False;
  WallTimer.Free;
  WallTimer := nil;

  inherited;
end;

// ######################################


procedure TBackground.ApplyEffects(var Bmp : TBitmap32; Mon : TThemeWallpaperItem);
begin
  if (Mon.Gradient) and ((Mon.GDStartAlpha<>255) or (Mon.GDEndAlpha<>255)) then
     ApplyGradient(Bmp, Mon.GradientType, Mon.GDStartColor,Mon.GDEndColor,
                   Mon.GDStartAlpha,Mon.GDEndAlpha);
end;


// ######################################


procedure TBackground.Create;
begin
  SetLength(WallpaperTimer, 0);
//  LaodSettings;
  Reload(False);
end;


// ######################################


procedure TBackground.Destroy;
begin
  Disabled:=True;
  SharpDeskMainForm.BackgroundImage.Layers.Clear;

  UnloadWallpaperChanger;
end;

procedure TBackground.LoadWallpaperChanger(Event : TNotifyEvent);
var
  i, n : Integer;

  Theme : ISharpETheme;
  PMon : TMonitor;
  MonID : Integer;
  WP : TThemeWallpaperItem;
begin
  SharpDeskMainForm.Monitor; // make it update the TScren Monitor Data

  Theme := GetCurrentTheme;
  for i := 0 to Screen.MonitorCount - 1 do
  begin
    PMon := Screen.Monitors[i];
    if PMon.Primary then
       MonID := -100
    else
      MonID := PMon.MonitorNum;
    WP := Theme.Wallpaper.GetMonitorWallpaper(MonID);

    if (WP.SwitchTimer > 0) and (WP.Switch) then
    begin
      n := Length(WallpaperTimer);

      SetLength(WallpaperTimer, n + 1);

      WallpaperTimer[n] := TWallpaperTimer.Create(WP.SwitchTimer, Event, MonID); 
    end;
  end;

  // Enable the timers
  for i := Length(WallpaperTimer) - 1 downto 0 do
    WallpaperTimer[i].Timer.Enabled := True;
end;

procedure TBackground.UnloadWallpaperChanger;
var
  i : integer;
begin
  for i := Length(WallpaperTimer) - 1 downto 0 do
  begin
    WallpaperTimer[i].Free;
    WallpaperTimer[i] := nil;
  end;
  SetLength(WallpaperTimer, 0);
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
  winWallPath: string;
  Reg : TRegistry;

  tBmp : TBitmap;
  TempBmp : TBitmap32;
begin
  Theme := GetCurrentTheme;

  //SharpApi.SendDebugMessageEx('SharpDesk',PChar(('Background - Export : ') + WP.Name),clblue,DMT_trace);
  winWallPath := SharpApi.GetSharpeUserSettingsPath + 'SharpDeskbg';
  tBmp := TBitmap.Create;
  tBmp.Assign(SharpDesk.Image.Bitmap);
  if FileCheck(winWallPath+'.bmp') then
    tBmp.SaveToFile(winWallPath+'.bmp');
  tBmp.Free;

  // save the preview bitmap
  TempBmp := TBitmap32.Create;
  RescaleImage(SharpDesk.Image.Bitmap,TempBmp,62,48,True);
  if not DirectoryExists(Theme.Info.Directory) then
    ForceDirectories(Theme.Info.Directory);
  if FileCheck(Theme.Info.Directory + '\preview.png') then
    SaveBitmap32ToPNG(TempBmp,Theme.Info.Directory + '\preview.png',False,True,clWhite);
  TempBmp.Free;

  //SharpApi.SendDebugMessageEx('SharpDesk',PChar(('Background - Set Win Wallpaper : ') + WP.Name),clblue,DMT_trace);
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('\Control Panel\Desktop\',False);
  Reg.WriteString('Wallpaper', winWallPath+'.bmp');
  Reg.WriteString('WallpaperStyle', '0');
  Reg.WriteString('TileWallpaper', '1');
  Reg.OpenKey('\Software\Microsoft\Internet Explorer\Desktop\General',False);
  Reg.WriteString('BackupWallpaper', winWallPath+'.bmp');
  Reg.WriteString('Wallpaper', winWallPath+'.bmp');
  Reg.WriteString('WallpaperStyle', '0');
  Reg.WriteString('TileWallpaper', '1');
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Themes\LastTheme',False);
  Reg.WriteString('Wallpaper', winWallPath+'.bmp');
  Reg.Free;
  try
    SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDCHANGE);
  except
      //SharpApi.SendDebugMessageEx('SharpDesk',PChar(('Failed to Send SPI_SETDESKWALLPAPER') + WP.Name),clblue,DMT_ERROR);
  end;

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
