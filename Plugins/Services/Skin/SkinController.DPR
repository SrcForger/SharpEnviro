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
  windows,
  Classes,
  Messages,
  SharpCenterApi,
  uSkinServer in 'uSkinServer.pas' {SkinServer},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas';

{$E ser}

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
  if not SharpThemeApi.Initialized then
     SharpThemeApi.InitializeTheme;

  result := owner;
  SkinServer := TSkinServer.Create(nil);

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);
  RegisterActionEx('!RefreshSkin','SharpSkin',h,0);
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
            SharpCenterApi.BroadcastGlobalUpdateMessage(suSkinfileChanged);
          end;
    end;
  end;

  if Message.Msg = WM_SHARPEUPDATEACTIONS then
    RegisterActionEx('!RefreshSkin','SharpSkin',h,0);
end;

begin

end.

