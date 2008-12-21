{
Source Name: ThemeList
Description: Theme List Config Dll
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

library SkinList;
uses
  SysUtils,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  graphics,
  PngSpeedButton,
  SharpCenterApi,
  SharpThemeApi,
  SharpApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uVistaFuncs,
  uListWnd in 'uListWnd.pas' {frmListWnd},
  BarPreview in '..\..\..\..\Common\Units\BarPreview\BarPreview.pas',
  BarForm in '..\..\..\..\Common\Units\BarPreview\BarForm.pas' {BarWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    procedure Load;
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdCall;

    function GetPluginDescriptionText: String; override; stdCall;
    function GetPluginStatusText: String; override; stdCall;
    procedure Refresh; override; stdcall;

  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmListWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  result := Format('Skin Configuration for "%s"',[PluginHost.PluginId]);
end;

function TSharpCenterPlugin.GetPluginStatusText: String;
var
  files: TStringList;
begin
  result := '';

  files := TStringList.Create;
  try
    FindFiles( files, GetSharpeDirectory + 'Skins\', '*Skin.xml' );
    if files.Count <> 0 then result := IntToStr(files.Count);
  finally
    files.Free;
  end;
end;

procedure TSharpCenterPlugin.Load;
begin
  frmListWnd.Skin := XmlGetSkin(PluginHost.PluginId);
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmListWnd = nil then frmListWnd := TfrmListWnd.Create(nil);
  frmListWnd.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmListWnd);

  Load;
  result := PluginHost.Open(frmListWnd);

end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmListWnd);
end;

procedure TSharpCenterPlugin.Save;
begin
  XmlSetSkin(PluginHost.PluginId, frmListWnd.Skin);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Skins';
    Description := 'Theme Skin List Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suSkin)]);
  end;
end;


function InitPluginInterface( APluginHost: TInterfacedSharpCenterHostBase ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.
