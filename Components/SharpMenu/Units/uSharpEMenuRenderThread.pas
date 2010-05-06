{
Source Name: uSharpEMenuRenderThread.pas
Description: Thread for Rendering Certain parts of the SharpEMenu
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

unit uSharpEMenuRenderThread;

interface

uses
  Classes,
  SharpApi,
  Contnrs;

type
  TSharpEMenuRenderItems = (riBackground,riNormalItems);

  TSharpEMenuRenderThread = class(TThread)
  private
    FMenu : TObject;
    FRenderItems : TSharpEMenuRenderItems;
  protected
    procedure Execute; override;
    procedure DoRender;
  public
    constructor Create(pMenu : TObject; pRenderItems: TSharpEMenuRenderItems);
    destructor Destroy; override;
  end;

implementation

uses
  uSharpEMenu;

constructor TSharpEMenuRenderThread.Create(pMenu : TObject; pRenderItems: TSharpEMenuRenderItems);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FMenu := pMenu;
  FRenderItems := pRenderItems;
end;

destructor TSharpEMenuRenderThread.Destroy;
begin

  inherited Destroy;
end;

procedure TSharpEMenuRenderThread.DoRender;
var
  menu : TSharpEMenu;
begin
  menu := TSharpEMenu(FMenu);
  case FRenderItems of
    riBackground: menu.RenderBackground(0,0,True);
    riNormalItems: menu.RenderNormalMenu;
  end;
end;

procedure TSharpEMenuRenderThread.Execute;
begin
  DoRender;
end;

end.
