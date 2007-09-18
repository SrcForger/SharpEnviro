{
Source Name: MainForm.pas
Description: SharpDesk Main Window
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

unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_Image, GR32_Layers,GR32,
  uSharpEDesktopManager, uSharpEDesktopRenderer;

type
  TSharpDeskMainWnd = class(TForm)
    Background: TImage32;
    procedure BackgroundMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure BackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure BackgroundMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    FDeskManager : TSharpEDesktopManager;
    FDeskRenderer : TSharpEDesktopRenderer;
  end;

var
  SharpDeskMainWnd: TSharpDeskMainWnd;

implementation

{$R *.dfm}

procedure TSharpDeskMainWnd.FormCreate(Sender: TObject);
begin
  FDeskManager := TSharpEDesktopManager.Create;
  FDeskManager.LoadDesktops;

  FDeskRenderer := TSharpEDesktopRenderer.Create(Background, FDeskManager);
  FDeskRenderer.RenderBackground;
  FDeskRenderer.RefreshLayers;
end;

procedure TSharpDeskMainWnd.FormDestroy(Sender: TObject);
begin
  FDeskRenderer.Free;
  FDeskManager.Free;
end;

procedure TSharpDeskMainWnd.BackgroundMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  FDeskRenderer.PerformMouseMove(X,Y);
end;

procedure TSharpDeskMainWnd.BackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  FDeskRenderer.PerformMouseDown(X,Y,Button);
end;

procedure TSharpDeskMainWnd.BackgroundMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  FDeskRenderer.PerformMouseUp(X,Y,Button);
end;

end.
