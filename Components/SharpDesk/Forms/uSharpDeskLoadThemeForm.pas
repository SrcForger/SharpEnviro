{
Source Name: uSharpDeskLoadThemeForm.pas
Description: progress Form for loading a theme
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit uSharpDeskLoadThemeForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Gauges, SharpApi, SharpFX,
  ComCtrls, PngImage, SharpThemeApi;

type
  TLoadThemeForm = class(TForm)
    Preview: TImage;
    pbar: TProgressBar;
    Label1: TLabel;
    lb_status: TLabel;
    lb_theme: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure SetStatus(Status : String; Progress : integer);
    procedure ReDrawForm;
  end;

var
  LoadThemeForm: TLoadThemeForm;

implementation

uses uSharpDeskMainForm;

{$R *.dfm}

procedure TLoadThemeForm.ReDrawForm;
begin
     pbar.Repaint;
end;

procedure TLoadThemeForm.SetStatus(Status : String; Progress : integer);
begin
     pbar.Position:=Progress;
     lb_status.Caption:=Status;
     lb_status.Repaint;
     self.Repaint;
end;

procedure TLoadThemeForm.FormShow(Sender: TObject);
var
   temppng : TPngObject;
   tempbmp : TBitmap;
   bmp : TBitmap;
   c : TColor;
begin
     lb_theme.Caption:='Theme : ' + SharpThemeApi.GetThemeName;;
     temppng := TPngObject.Create;
     if FileExists(SharpThemeApi.GetThemeDirectory + 'Preview.png') then
     try
        temppng.LoadFromFile(SharpThemeApi.GetThemeDirectory + 'Preview.png');
     finally
        bmp := TBitmap.Create;
        bmp.Width := temppng.Width;
        bmp.Height := temppng.Height;
        temppng.AssignTo(bmp);
     end else
     begin
        bmp := TBitmap.Create;
        bmp.Width := 62;
        bmp.Height := 48;
        bmp.Canvas.FillRect(bmp.canvas.ClipRect);
     end;
     tempbmp := TBitmap.Create;
     tempbmp.Width := preview.Width+4;
     tempbmp.Height := preview.Height+4;
     c := self.Color;
     if Preview.Picture.Bitmap = nil then Preview.Picture.Bitmap := TBitmap.Create;
     Preview.Picture.Bitmap.Width := 72;
     Preview.Picture.Bitmap.Height := 58;
     Preview.Picture.Bitmap.Canvas.Brush.Color := c;
     Preview.Picture.Bitmap.PixelFormat := pf32bit;
     Preview.Picture.Bitmap.Canvas.FillRect(Preview.Picture.Bitmap.Canvas.ClipRect);
     with tempbmp.Canvas do
     begin
          Brush.Color := c;
          FillRect(ClipRect);
          Brush.Color := clFuchsia;
          Pen.Color := clBlack;
          FillRect(Rect(1,1,64+3,48+4));
          Rectangle(Rect(3,3,64+3,48+5));
          SharpFX.CreateDropShadow(@tempbmp,c,0,0);
     end;
     tempbmp.Canvas.Draw(4,4,bmp);
     Preview.Picture.Bitmap.Canvas.Draw(-3,-3,tempbmp);
     bmp.Free;
     tempbmp.Free;
     temppng.Free;
     ReDrawForm;
end;


end.
