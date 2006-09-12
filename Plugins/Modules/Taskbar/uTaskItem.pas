{
Source Name: uTaskItem.pas
Description: TaskItem class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows XP

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

unit uTaskItem;

interface

uses
  Windows,
  Dialogs,
  Messages,
  SysUtils,
  DateUtils,
  JclSysUtils,
  JclSysInfo;

type
  TTaskItem = class
              protected
                FTimeAdded : Int64;
                FHandle : hwnd;
                FIcon : hIcon;
                FCaption : String;
                FWndClass : String;
                FFilePath : String;
                FFileName : String;
                FVisible  : boolean;
                FPlacement: TWindowPlacement;
              private
              public
                constructor Create(phandle : hwnd); reintroduce;
                destructor Destroy; override;
                procedure UpdateFromHwnd;
                procedure UpdateCaption;
                procedure UpdateWndClass;
                procedure UpdateVisibleState;
                procedure UpdatePlacement;
                procedure UpdateIcon;
                procedure UpdateFileInfo;
                procedure Minimize;
                procedure Restore;
              published
                property Icon     : hIcon   read FIcon;
                property Caption  : String  read FCaption;
                property Handle   : hwnd    read FHandle;
                property WndClass : String  read FWndClass;
                property Visible  : boolean read FVisible;
                property Placement : TWindowPlacement read FPlacement;
                property TimeAdded : Int64  read FTimeAdded;
                property FileName  : String read FFileName;
                property FilePath  : String read FFilePath;
              end;

implementation


constructor TTaskItem.Create(phandle : hwnd);
begin
  inherited Create;
  FHandle := phandle;
  UpdateFromHwnd;
  FTimeAdded := DateTimeToUnix(Now);
end;

destructor TTaskItem.Destroy;
begin
  inherited Destroy;
end;

procedure TTaskItem.UpdateFileInfo;
begin
  FFilePath := GetProcessNameFromWnd(FHandle);
  FFileName := LowerCase(ExtractFileName(FFilePath));
end;

procedure TTaskItem.UpdateIcon;
const
  ICON_SMALL2 = 2;
var
  newicon : hicon;
begin
  newicon := 0;
  if FIcon <> 0 then DestroyIcon(FIcon);
  try
    SendMessageTimeout(Handle, WM_GETICON, 0, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));

    if (newicon = 0) then newicon := HICON(GetClassLong(Handle, GCL_HICON));

    if (newicon = 0) then SendMessageTimeout(Handle, WM_GETICON, 1, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));
    if (newicon = 0) then newicon := HICON(GetClassLong(Handle, GCL_HICON));
    if (newicon = 0) then SendMessageTimeout(Handle, WM_QUERYDRAGICON, 0, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));

    if (newicon = 0) then newicon := LoadIcon(0, IDI_WINLOGO);
  except
  end;
  
  if newicon <> 0 then FIcon := newicon;
end;

procedure TTaskItem.UpdateCaption;
var
  buf:Array[0..1024] of char;
begin
  GetWindowText(FHandle,@buf,sizeof(buf));
  FCaption := buf;
end;

procedure TTaskItem.UpdateWndClass;
var
  buf: array [0..127] of Char;
begin
  GetClassName(FHandle, buf, SizeOf(buf));
  FWndClass := buf;
end;

procedure TTaskItem.UpdateVisibleState;
begin
  if IsIconic(FHandle) then FVisible := False
     else FVisible := True;
end;

procedure TTaskItem.UpdateFromHwnd;
begin
  UpdateCaption;
  UpdateWndClass;
  UpdateVisibleState;
  UpdatePlacement;
  UpdateIcon;
  UpdateFileInfo;
end;

procedure TTaskItem.Minimize;
begin
  CloseWindow(FHandle);
  UpdateCaption;
  UpdateVisibleState;
end;

procedure TTaskItem.Restore;
begin
  if IsIconic(FHandle) then ShowWindow(FHandle, SW_Restore)
     else OpenIcon(FHandle);
  UpdateCaption;
  UpdateVisibleState;
end;

procedure TTaskItem.UpdatePlacement;
begin
  if IsWindow(FHandle) then
  begin
    FPlacement.length := SizeOf(TWindowPlacement);
    GetWindowPlacement(FHandle, @FPlacement);
  end;
end;


end.
