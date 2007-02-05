{
Source Name: uSkinManagerThreads.pas
Description: TSharpESkinManager related Threads 
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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
  FManager.SkinSource := ssSystem;
  FManager.SchemeSource := ssSystem;
end;

procedure TSystemSkinLoadThread.Execute;
begin
  DoUpdate;
end;

end.
