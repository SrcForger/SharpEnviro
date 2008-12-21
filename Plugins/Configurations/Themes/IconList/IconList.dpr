﻿{
Source Name: IconList
Description: Icon List Config Dll
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

library IconList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpCenterApi,
  SharpApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uListWnd in 'uListWnd.pas' {frmListWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginPreview )
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
    procedure UpdatePreview(ABitmap: TBitmap32); stdcall;

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
  result := Format('Icon Set Configuration for "%s"',[PluginHost.PluginId]);
end;

function TSharpCenterPlugin.GetPluginStatusText: String;
var
  files: TStringList;
begin
  result := '';

  files := TStringList.Create;
  try
    FindFiles( files, SharpApi.GetSharpeDirectory + 'Icons\', '*Iconset.xml' );
    if files.Count <> 0 then result := IntToStr(files.Count);
  finally
    files.Free;
  end;
end;

procedure TSharpCenterPlugin.Load;
var
  iconSet: string;
begin
  with PluginHost, PluginHost.Xml do begin
    XmlFilename := GetSharpeUserSettingsPath + 'Themes\' + PluginId + '\IconSet.xml';

    if Xml.Load then begin
      iconSet := XMLRoot.Items.Value('Name', '');
      frmListWnd.IconSet := iconSet;
    end else begin

      // Default
      frmListWnd.IconSet := 'Cubeix White';
    end;
  end;
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
  with frmListWnd, PluginHost.Xml do begin
    if lbIcons.ItemIndex >= 0 then begin

      XmlRoot.Clear;
      XMLRoot.Name := 'SharpEThemeIconSet';
      XMLRoot.Items.Add('Name', TIconItem(lbIcons.SelectedItem.Data).Name);

      XmlFilename := GetSharpeUserSettingsPath + 'Themes\' + PluginHost.PluginId + '\IconSet.xml';

      PluginHost.Xml.Save;
    end;
  end;
end;

procedure TSharpCenterPlugin.UpdatePreview(ABitmap: TBitmap32);
begin
  if (frmListWnd.lbIcons.ItemIndex < 0) or (frmListWnd.lbIcons.Count = 0) then
    exit;

  ABitmap.Clear(color32(0, 0, 0, 0));
  frmListWnd.BuildIconPreview(ABitmap);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Icon List';
    Description := 'Icon List Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suIconSet)]);
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

