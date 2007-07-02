{
Source Name: DeskArea.dpr
Description: DeskArea Service
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.SharpE-Shell.org

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

library DeskArea;
uses
  Messages,
  windows,
  Classes,
  SysUtils,
  SharpApi,
  uDeskAreaManager in 'uDeskAreaManager.pas';

type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var Message: TMessage);
  end;

var
  DeskAreaManager : TDeskAreaManager;
  AE:TActionEvent;
  h:THandle;

{$E ser}

{$R *.RES}
{$R DeskAreaCR.RES}

procedure Stop;
begin
  DeskAreaManager.Free;

  DeallocateHWnd(h);
  AE.Free;

  UnRegisterAction('!EnableDeskArea');
  UnRegisterAction('!DisableDeskArea');
end;

function Start(owner: hwnd): hwnd;
begin
  DeskAreaManager := TDeskAreaManager.Create;
  DeskAreaManager.LoadSettings;
  Result := owner;

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);

  RegisterActionEx('!EnableDeskArea','Services',h,0);
  RegisterActionEx('!DisableDeskArea','Services',h,1);
end;

function SCMsg(msg: string): integer;
begin
  Result := 0;

  if CompareText(msg,'Update') = 0 then
     DeskAreaManager.SetDeskArea;
end;

procedure TActionEvent.MessageHandler(var Message: TMessage);
begin
  if message.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    case Message.LParam of
      0 : DeskAreaManager.Enable;
      1 : DeskAreaManager.Disable;
    end;
  end;

  if Message.Msg = WM_SHARPEUPDATEACTIONS then
  begin
    RegisterActionEx('!EnableDeskArea','Services',h,0);
    RegisterActionEx('!DisableDeskArea','Services',h,1);
  end;
end;


exports
  Start,
  Stop,
  SCMsg;

end.


