{
Source Name: SharpESkin
Description: SharpESkin service to provide all app with skin graphics
Copyright (C) Malx (Malx@sharpe-shell.org)

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

library SkinController;

uses
//  VCLFixPack,
  windows,
  Classes,
  Messages,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSkinServer in 'uSkinServer.pas' {SkinServer},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';


{$R *.RES}


type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var Message: TMessage);
  end;

Var
  SkinServer : TSkinServer;
  AE:TActionEvent;
  h:THandle;

function Start(owner: hwnd): hwnd;
begin
  result := owner;
  SkinServer := TSkinServer.Create(nil);

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);
  RegisterActionEx('!RefreshSkin','SharpSkin',h,0);
  ServiceDone('Skin Controller');
end;

procedure Stop;
begin
  SkinServer.Free;

  DeallocateHWnd(h);
  AE.Free;
  UnRegisterAction('!RefreshSkin');
end;

exports
  Start,
  Stop;

{ TActionEvent }

procedure TActionEvent.MessageHandler(var Message: TMessage);
begin
  if message.Msg = WM_SHARPEACTIONMESSAGE then begin

    case Message.LParam of
      0 : begin
            SkinServer.UpdateStreamFile;
            SharpApi.BroadcastGlobalUpdateMessage(suSkinfileChanged,-1,True);
          end;
    end;
  end else if Message.Msg = WM_SHARPEUPDATEACTIONS then
    RegisterActionEx('!RefreshSkin','SharpSkin',h,0)
  else Message.Result := DefWindowProc(h,Message.Msg,MEssage.WParam,Message.LParam);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Skin Controller';
    Description := 'Manages skins for all of SharpE';
    Author := 'Malx (Malx@sharpe-shell.org)';
    Version := '0.8.0.0';
    DataType := tteService;
    ExtraData := 'priority: 100| delay: 0';
  end;
end;

exports
  GetMetaData;

begin

end.

