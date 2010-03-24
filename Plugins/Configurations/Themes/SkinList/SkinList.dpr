{
Source Name: SkinList
Description: Skin List Config Dll
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
  SharpThemeApiEx,
  uThemeConsts,
  uISharpETheme,
  SharpFileUtils,
  SharpApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uVistaFuncs,
  uListWnd in 'uListWnd.pas' {frmListWnd},
  BarPreview in '..\..\..\..\Common\Units\BarPreview\BarPreview.pas',
  BarForm in '..\..\..\..\Common\Units\BarPreview\BarForm.pas' {BarWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    FTheme: ISharpETheme;
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdCall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmListWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  
  FTheme := GetTheme(APluginHost.PluginId);
  FTheme.LoadTheme([tpSkinScheme]);
end;

procedure TSharpCenterPlugin.Load;
begin
  FTheme.LoadTheme([tpSkinScheme]);
  frmListWnd.Skin := FTheme.Skin.Name;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmListWnd = nil then frmListWnd := TfrmListWnd.Create(nil);
  frmListWnd.Theme := FTheme;
  frmListWnd.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmListWnd);

  Load;
  result := PluginHost.Open(frmListWnd);

end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmListWnd,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
begin
  FTheme.Skin.Name := frmListWnd.Skin;
  FTheme.Skin.SaveToFileSkinAndGlass;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Skins';
    Description := 'Theme Skin List Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suSkin)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
var
  files: TStringList;
begin
  with Result do
  begin
  	Name := 'Skins';
    Description := Format('Skin Configuration for "%s"',[pluginID]);
  	Status := '';

    files := TStringList.Create;
    try
      SharpFileUtils.FindFiles( files, GetSharpeDirectory + 'Skins\', '*Skin.xml' );
      if files.Count <> 0 then
        Status := IntToStr(files.Count);
    finally
      files.Free;
    end;
  end;
end;

function InitPluginInterface( APluginHost: ISharpCenterHost ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.
