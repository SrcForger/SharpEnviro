{
Source Name: MouseTimer.pas
Description: If a dll file creates a form no component on this 
             dll form will ever receive any of the VCL internal
             CM_MouseEnter/CM_MouseLeave messages. 
             The TMouseTimer class simply emulates these messages
             by monitoring the current control at the cursor position.

Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
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

unit MouseTimer;

interface

uses Windows,
     ExtCtrls,
     Classes,
     Controls,
     Contnrs,
     Dialogs;

type
  TMouseTimer = class
                private
                  FLastControl : TControl;
                  FTimer : TTimer;
                  FControlList : TObjectList;
                  procedure OnTimer(Sender : TObject);
                public
                  constructor Create;
                  destructor Destroy; override;
                  procedure AddWinControl(control : TWinControl);
                  procedure RemoveWinControl(control : TWinControl);
                published
                  property ControlList : TObjectList read FControlList;
                end;

implementation

constructor TMouseTimer.Create;
begin
  inherited Create;
  FControlList := TObjectList.Create;
  FControlList.OwnsObjects := False;
  FControlList.Clear;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 100;
  FTimer.OnTimer := OnTimer;
  FTimer.Enabled := False;
  FLastControl := nil;
end;

destructor TMouseTimer.Destroy;
begin
  FTimer.Enabled := False;
  FControlList.Free;
  FTimer.Free;
  inherited Destroy;
end;

procedure TMouseTimer.OnTimer(Sender : TObject);
var
  n : integer;
  P,P2 : TPoint;
  temp : TControl;
  FoundControl : boolean;
begin
  GetCursorPos(p);
  FoundControl := False;
  try
    for n := FControlList.Count - 1 downto 0  do
        if FControlList.Items[n] <> nil then
          with FControlList.Items[n] as TWinControl do
          begin
            P2 := ScreenToClient(p);
            temp := ControlAtPos(p2,true,true,true);
            if temp <> nil then
            begin
              if temp <> FLastControl then
              begin
                try
                  if FLastControl <> nil then FLastControl.Perform(CM_MOUSELEAVE,0,0);
                  if temp <> nil then temp.Perform(CM_MOUSEENTER,0,0);
                except
                end;
                FLastControl := temp;
              end;
              FoundControl := True;
              break;
            end;
        end;
    if not FoundControl then
       if FLastControl <> nil then
          begin
            try
              FLastControl.Perform(CM_MOUSELEAVE,0,0);
              FLastControl := nil;
            except
              FLastControl := nil;
            end;
            exit;
          end;
  except
    FLastControl := nil;
  end;
end;

procedure TMouseTimer.AddWinControl(control : TWinControl);
begin
  if not (control is TWinControl) then exit;

  if FControlList.IndexOf(control) = -1 then
     FControlList.Add(control);
     
  if FControlList.Count >0 then FTimer.Enabled := True;
end;

procedure TMouseTimer.RemoveWinControl(control : TWinControl);
begin
  FControlList.Remove(control);

  if FControlList.Count = 0 then FTimer.Enabled := False;
end;

end.
