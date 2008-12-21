{
Source Name: Scheme.dll
Description: Configuration dll for Scheme settings
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
library SchemeEdit;

uses
  windows,
  sysutils,
  sharpapi,
  classes,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  sharpthemeapi,
  graphics,
  uVistaFuncs,
  forms,
  GR32,
  uEditWnd in 'uEditWnd.pas' {frmEditWnd};

{$R *.RES}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginPreview )
  private
    procedure Load;
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    function GetPluginDescriptionText: String; override; stdCall;
    procedure Refresh; override; stdcall;


    procedure Save; override; stdCall;
    procedure UpdatePreview(ABitmap: TBitmap32); stdcall;

  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
var
  pluginId, themeId, schemeId: String;
begin
  {$REGION 'Get theme and scheme'}
        pluginId := PluginHost.PluginId;
        themeId := copy(pluginId, 0, pos(':',pluginId)-1);
        schemeId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
    {$ENDREGION}

  result := Format('Editing Scheme "%s"',[schemeId]);
end;

procedure TSharpCenterPlugin.Load;
var
  pluginId, themeId, schemeId: String;
begin
  {$REGION 'Get theme and scheme'}
        pluginId := PluginHost.PluginId;
        themeId := copy(pluginId, 0, pos(':',pluginId)-1);
        schemeId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
    {$ENDREGION}

  // Get Scheme Colors
  frmEditWnd.Theme := themeId;
  frmEditWnd.Scheme := schemeId;
  XmlGetThemeScheme(themeId, schemeId, frmEditWnd.Colors);
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmEditWnd = nil then frmEditWnd := TfrmEditWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmEditWnd);

  frmEditWnd.PluginHost := PluginHost;
  Load;
  result := PluginHost.Open(frmEditWnd);
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmEditWnd);
end;

procedure TSharpCenterPlugin.Save;
begin
  XmlSetThemeScheme(frmEditWnd.Theme,frmEditWnd.Scheme,frmEditWnd.Colors);
end;

procedure TSharpCenterPlugin.UpdatePreview(ABitmap: TBitmap32);
begin
  if ( ( High(frmEditWnd.Colors)= 0) or (frmEditWnd = nil) ) then begin
    ABitmap.SetSize(0,0);
    exit;
  end;

  ABitmap.Clear(color32(0,0,0,0));
  frmEditWnd.CreatePreviewBitmap(ABitmap);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Edit Scheme';
    Description := 'Configuration for editing a scheme';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suScheme)]);
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
