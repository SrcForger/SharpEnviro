{
Source Name: uSharpCenterHistory
Description: Helper methods
Copyright (C) Pixol - pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

unit uSharpCenterHelperMethods;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls;

  const
    GlobalItemHeight = 22;

  procedure ResizeToFitWindow(AHandle: THandle; AControl: TWinControl);
  function GetControlByHandle(AHandle: THandle): TWinControl;
  procedure HideAllTaskbarButton;

implementation

  procedure ResizeToFitWindow(AHandle: THandle; AControl:
    TWinControl);
  begin
    GetControlByHandle(AHandle).Height := AControl.Height;
    GetControlByHandle(AHandle).Width := AControl.Width;
    GetControlByHandle(AHandle).Refresh;
  end;

  function GetControlByHandle(AHandle: THandle): TWinControl;
  begin
    Try
      Result := Pointer(GetProp(AHandle,
      PChar(Format('Delphi%8.8x', [GetCurrentProcessID]))));
    Except
      Result := nil;
    End;
  end;

  procedure HideAllTaskbarButton;
  begin
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(Application.Handle, GWL_EXSTYLE,
      GetWindowLong(Application.Handle, GWL_EXSTYLE) and not WS_EX_APPWINDOW
    or WS_EX_TOOLWINDOW);
      ShowWindow(Application.Handle, SW_SHOW);
  end;

end.
