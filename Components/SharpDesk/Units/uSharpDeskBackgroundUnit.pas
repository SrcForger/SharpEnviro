{
Source Name: uSharpDeskBackgroundUnit.pas
Description: Unit for handling background image drawing
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

Unit uSharpDeskBackgroundUnit;

Interface

uses Windows,Graphics,SysUtils,Forms,SharpApi,Classes,Dialogs,Types,
     GR32,Math,GR32_blend,GR32_Image, GR32_resamplers,PngImage, Registry,Messages,
     SharpThemeApi, Jpeg,
     SharpGraphicsUtils;

type
    TBackground = Object
                  public
                   procedure Create;
                   procedure Destroy;
                   procedure Reload;
                   procedure ApplyEffects(var Bmp : TBitmap32; Mon : TThemeWallpaper);
                  end;

Implementation


uses uSharpDeskMainForm;



// ######################################


procedure TBackground.ApplyEffects(var Bmp : TBitmap32; Mon : TThemeWallpaper);
begin
  if (Mon.Gradient) and ((Mon.GDStartAlpha<>255) or (Mon.GDEndAlpha<>255)) then
     ApplyGradient(Bmp, Mon.GradientType, Mon.GDStartColor,Mon.GDEndColor,
                   Mon.GDStartAlpha,Mon.GDEndAlpha);
end;


// ######################################


procedure TBackground.Create;
begin
//  LaodSettings;
  Reload;
end;


// ######################################


procedure TBackground.Destroy;
begin
     Disabled:=True;
     SharpDeskMainForm.BackgroundImage.Layers.Clear;
end;


// ######################################


procedure TBackground.Reload;
var
   n,i : integer;
   PMon : TMonitor;
   MonID : integer;
   MonRect : TRect;
   TempBmp,DrawBmp : TBitmap32;
   tBmp : TBitmap;
   x,y,ny,nx : integer;
   Re : TRect;
   w,h : integer;
   //JPeg : TJpegImage;
   winWallPath: string;
   Reg : TRegistry;

   loaded : boolean;
   WP : TThemeWallpaper;
   img : TBitmap32;
   SList : TStringList;
begin
  img := SharpDesk.Image.Bitmap;
  img.SetSize(Screen.DesktopWidth,Screen.DesktopHeight);
  for n := 0 to Screen.MonitorCount - 1 do
  begin
    PMon := Screen.Monitors[n];
    if PMon.Primary then
       MonID := -100
       else MonID := PMon.MonitorNum;
    WP := SharpThemeApi.GetMonitorWallpaper(MonID);

    MonRect.TopLeft := SharpDesk.Image.ScreenToClient(Point(PMon.Left,PMon.Top));
    MonRect.BottomRight := SharpDesk.Image.ScreenToClient(Point(PMon.Left+PMon.Width,
                                                                PMon.Top+PMon.Height));

    // Background
    img.FillRect(MonRect.Left,MonRect.Top,MonRect.Right,MonRect.Bottom,color32(WP.Color));

    // Image Loading
    TempBmp := TBitmap32.Create;
    DrawBmp := TBitmap32.Create;
    DrawBmp.DrawMode := dmBlend;
    DrawBmp.CombineMode := cmMerge;
    DrawBmp.MasterAlpha := WP.Alpha;

    TLinearResampler.Create(TempBmp);
    TLinearResampler.Create(DrawBmp);

    loaded := False;
    SList := TStringList.Create;
    SList.Add(SharpThemeApi.GetThemeDirectory + WP.Image);
    SList.Add(WP.Image);
    SList.Add(SharpApi.GetSharpeDirectory + WP.Image);
    for i := 0 to SList.Count - 1 do
        if FileExists(SList[i]) then
        try
          TempBmp.LoadFromFile(WP.Image);
          loaded := True;
          break;
        except
        end;
    SList.Free;
    if not loaded then
    begin
      TempBmp.SetSize(MonRect.Right-MonRect.Left,MonRect.Bottom-MonRect.Top);
      TempBmp.Clear(Color32(WP.Color));
    end;

    w := MonRect.Right - MonRect.Left;
    h := MonRect.Bottom - MonRect.Top;

    // HSL Effects
    if WP.ColorChange then
       HSLChangeImage(TempBmp,WP.Hue,WP.Saturation,WP.Lightness);

    // Mirror Image?
    if WP.MirrorHoriz then
       TempBmp.Canvas.CopyRect(Rect(TempBmp.Width,0,0,TempBmp.Height),TempBmp.Canvas,Rect(0,0,TempBmp.Width,TempBmp.Height));
    if WP.MirrorVert then
       TempBmp.Canvas.CopyRect(Rect(0,TempBmp.Height,TempBmp.Width,0),TempBmp.Canvas,Rect(0,0,TempBmp.Width,TempBmp.Height));

    // Draw Image and Apply Effects
    case WP.Size of
      twsStretch :
      begin
        img.BeginUpdate;
        DrawBmp.SetSize(MonRect.Right - MonRect.Left,MonRect.Bottom - MonRect.Top);
        DrawBmp.Draw(DrawBmp.Canvas.ClipRect,TempBmp.Canvas.ClipRect,TempBmp);
        ApplyEffects(DrawBmp,WP);
        img.Draw(MonRect.Left,MonRect.Top,DrawBmp);
        img.EndUpdate;
      end;

      twsTile :
      begin
        DrawBmp.SetSize(MonRect.Right - MonRect.Left,MonRect.Bottom - MonRect.Top);
        if TempBmp.Height=MonRect.Bottom - MonRect.Top then y:=1
           else y:=round(Int((MonRect.Bottom - MonRect.Top)/TempBmp.Height))+1;
        if TempBmp.Width=MonRect.Right - MonRect.Left then x:=1
           else x:=round(Int((MonRect.Right - MonRect.Left)/TempBmp.Width))+1;
        img.BeginUpdate;
        for ny:=0 to y-1 do
            for nx:=0 to x-1 do
                DrawBmp.Draw(nx*TempBmp.Width,ny*TempBmp.Height,TempBmp);
        ApplyEffects(DrawBmp,WP);
        img.Draw(MonRect.Left,MonRect.Top,DrawBmp);
        img.EndUpdate;
      end;

      twsCenter :
      begin
        DrawBmp.SetSize(MonRect.Right - MonRect.Left,MonRect.Bottom - MonRect.Top);
        DrawBmp.Clear(color32(WP.Color));
        img.BeginUpdate;
        DrawBmp.Draw((MonRect.Right - MonRect.Left) div 2 - TempBmp.Width div 2, (MonRect.Bottom - MonRect.Top) div 2 - TempBmp.Height div 2, TempBmp);
        ApplyEffects(DrawBmp,WP);
        img.Draw(MonRect.Left,MonRect.Top,DrawBmp);
        img.EndUpdate;
      end;

      twsScale:
      begin
        DrawBmp.SetSize(w,h);
        DrawBmp.Clear(color32(WP.Color));
        Re := Rect(0,0,0,0);
        if (TempBmp.Width/TempBmp.Height)=(w/h) then
        begin
          Re := Rect(0,0,w,h);
        end
        else if (TempBmp.Width/TempBmp.Height)>(w/h) then
        begin
          Re.Left := 0;
          Re.Top := round((h div 2 - ((w/TempBmp.Width)*TempBmp.Height) / 2));
          Re.Right := w;
          Re.bottom := round((h div 2 + ((w/TempBmp.Width)*TempBmp.Height) / 2));
        end else
        begin
          Re.Left := round((w div 2 - ((h/TempBmp.Height)*TempBmp.Width) / 2));
          Re.Top := 0;
          Re.Right := round((w div 2 + ((h/TempBmp.Height)*TempBmp.Width) / 2));
          Re.bottom := h;
        end;
        img.BeginUpdate;
        DrawBmp.Draw(Re,TempBmp.Canvas.ClipRect,TempBmp);
        ApplyEffects(DrawBmp,WP);
        img.Draw(MonRect.Left,MonRect.Top,DrawBmp);
        img.EndUpdate;
      end;
    end;

    TempBmp.Free;
    DrawBmp.Free;
  end;

  SharpApi.SendDebugMessageEx('SharpDesk',PChar(('Background - Export : ') + WP.Name),clblue,DMT_trace);
  winWallPath := SharpApi.GetSharpeDirectory + 'SharpDeskbg';
  tBmp := TBitmap.Create;
  tBmp.Assign(SharpDesk.Image.Bitmap);
  tBmp.SaveToFile(winWallPath+'.bmp');
{  Jpeg := TJpegImage.Create;
  Jpeg.Assign(tBmp);
  JPeg.SaveToFile(winWallPath+'.jpg');
  JPeg.Free;}
  tBmp.Free;

  SharpApi.SendDebugMessageEx('SharpDesk',PChar(('Background - Set Win Wallpaper : ') + WP.Name),clblue,DMT_trace);
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('\Control Panel\Desktop\',False);
  Reg.WriteString('Wallpaper', winWallPath+'.bmp');
  Reg.WriteString('WallpaperStyle', '0');
  Reg.WriteString('TileWallpaper', '0');
  Reg.OpenKey('\Software\Microsoft\Internet Explorer\Desktop\General',False);
  Reg.WriteString('BackupWallpaper', winWallPath+'.bmp');
  Reg.WriteString('Wallpaper', winWallPath+'.bmp');
  Reg.WriteString('WallpaperStyle', '0');
  Reg.WriteString('TileWallpaper', '0');
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Themes\LastTheme',False);
  Reg.WriteString('Wallpaper', winWallPath+'.bmp');
  Reg.Free;
  SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, PChar(winWallPath+'.bmp'), SPIF_SENDCHANGE);

  SendMessage(FindWindow('Progman','Program Manager'),WM_COMMAND,106597, 0);
end;



end.
