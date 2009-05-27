{
Source Name: uSkinManagerThreads.pas
Description: TSharpESkinManager related Threads 
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

unit uSkinManagerThreads;

interface

uses
  Classes,
  SharpESkinManager;

type
  // Using this Thread will set the Scheme and Skin properties of a
  // TSharpESkinManager class to ssSystem making the whole system scheme
  // and system skin loading to be done in a Thread.
  // - Make sure to wait for the Thread to be finished before using the skin manager!
  // - The Skin Manager must be created before using the Thread!
  TSystemSkinLoadThread = class(TThread)
  private
    FManager : TSharpESkinManager;
  protected
    procedure Execute; override;
    procedure DoUpdate;
  public
    constructor Create(pManager : TSharpESkinManager);
  end;

implementation

constructor TSystemSkinLoadThread.Create(pManager : TSharpESkinManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FManager := pManager;
end;

procedure TSystemSkinLoadThread.DoUpdate;
begin
  FManager.Skin.UpdateDynamicProperties(FManager.Scheme);
end;

procedure TSystemSkinLoadThread.Execute;
begin
  DoUpdate;
end;

end.
