{
Source Name: uSkinServer
Description: SharpESkin service to provide all app with skin graphics
Copyright (C) Malx (Malx@sharpe-shell.org)
              Martin Krämer (MartinKraemer@gmx.net)

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

unit uSkinServer;

interface

uses Windows, Dialogs, SysUtils, Classes,
     Forms, Controls, Messages, Types, Graphics, Contnrs, ExtCtrls,
     GR32,
     SharpApi,
     SharpThemeApiEx,
     uISharpETheme,
     uThemeConsts,
     SharpESkin,
     SharpTypes;

Type

    TSkinServer = class(TForm)
      procedure FormDestroy(Sender: TObject);
      procedure CreateParams(var Params: TCreateParams); override;
      procedure FormCreate(Sender: TObject);
    private
      FSkin      : TSharpESkin;

      FFileName  : string;
      FStream    : TFileStream;

      procedure UpdateSkin(var Msg: TMessage); message WM_SHARPEUPDATESETTINGS;
    public
      procedure UpdateStreamFile;
    end;

{$R *.dfm}

implementation


procedure TSkinServer.FormCreate(Sender: TObject);
begin
  FSkin := TSharpESkin.Create(self,ALL_SHARPE_SKINS);
  UpdateStreamFile;
  SharpApi.BroadcastGlobalUpdateMessage(suSkinFileChanged,-1,True);
end;

procedure TSkinServer.FormDestroy(Sender: TObject);
begin
  if FStream <> nil then FreeAndNil(FStream);
end;


procedure TSkinServer.UpdateStreamFile;
var
  Theme : ISharpETheme;
begin
  //Load new skin
  Theme := GetCurrentTheme;
  Theme.LoadTheme([tpSkinScheme]);
  FFileName := Theme.Skin.Directory + 'Skin.xml';
  FSkin.LoadFromXmlFile(FFileName);
  if FStream <> nil then
    FreeAndNil(FStream);

  try
    DeleteFile(SharpApi.GetSharpeUserSettingsPath + 'SharpE.skin');
  finally
    FStream := TFileStream.Create(SharpApi.GetSharpeUserSettingsPath + 'SharpE.skin',fmCreate or fmShareDenyWrite);
  end;
  FSkin.SaveToStream(FStream,true);
  FreeAndNil(FStream);
  FSkin.Clear;
end;

procedure TSkinServer.CreateParams(var Params: TCreateParams);
begin
  try
    inherited CreateParams(Params);
    with Params do
    begin
      Params.WinClassName := 'SharpESkinServer';
      ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
      Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
    end;
  except
  end;
end;

procedure TSkinServer.UpdateSkin(var Msg: TMessage);
begin
  if (msg.WParam = Integer(suSkin)) or (msg.WParam = Integer(suTheme)) then
  begin
    UpdateStreamFile;
    SharpApi.BroadcastGlobalUpdateMessage(suSkinFileChanged,-1,True);
  end;
end;

end.
