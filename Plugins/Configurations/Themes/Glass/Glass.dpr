{
Source Name: ThemeGlass.dpr
Description: Glass skin options
Copyright (C) Lee Green (lee@sharpenviro.com)

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

library Glass;
uses
//  VCLFixPack,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SharpEColorEditorEx,
  SharpEColorEditor,
  SharpThemeApiEx,
  uSharpETheme,
  uISharpETheme,
  uThemeConsts,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}
      
{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin)
  private
    FTheme : ISharpETheme;
    procedure Load;
  public
    constructor Create(APluginHost: ISharpCenterHost);
    destructor Destroy; override;

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettingsWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;

  if (length(trim(PluginHost.pluginID)) = 0) then
    PluginHost.pluginID := SharpThemeApiEx.GetCurrentTheme.Info.Name;  
  
  FTheme := TSharpETheme.Create(APluginHost.PluginId);
  FTheme.LoadTheme([tpSkinScheme]);
end;

destructor TSharpCenterPlugin.Destroy;
begin
  FTheme := nil;

  inherited Destroy;
end;

procedure TSharpCenterPlugin.Load;
var
  tmpItem: TSharpEColorEditorExItem;
begin
  FTheme.LoadTheme([tpSkinScheme]);

  frmSettingsWnd.IsUpdating := true;
  frmSettingsWnd.sceGlassOptions.BeginUpdate;
  try
    with FTheme.Skin.GlassEffect, frmSettingsWnd do
    begin
      tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
      tmpItem.Title := 'Blur Radius';
      tmpItem.Description := 'Adjust this value to define the glass blur effect';
      tmpItem.ValueText := 'Blur Radius: ';
      tmpItem.ValueEditorType := vetValue;
      tmpItem.ValueMax := 10;
      tmpItem.Value := BlurRadius;

      tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
      tmpItem.Title := 'Blur Iterations';
      tmpItem.Description := 'Adjust this value to define the blur iterations';
      tmpItem.ValueText := 'Blur Amount: ';
      tmpItem.ValueEditorType := vetValue;
      tmpItem.ValueMax := 5;
      tmpItem.Value := BlurIterations;

      tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
      tmpItem.Title := 'Blend';
      tmpItem.Description := 'Enable blend options?';
      tmpItem.ValueEditorType := vetBoolean;
      if Blend then tmpItem.Value := 1
        else tmpItem.Value := 0;

      tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
      tmpItem.Title := 'Blend Color';
      tmpItem.ValueEditorType := vetColor;
      tmpItem.Value := BlendColor;

      tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
      tmpItem.Title := 'Blend Transparecy';
      tmpItem.Description := 'Adjust this value to define the blend transparency';
      tmpItem.ValueText := 'Blend Amount: ';
      tmpItem.ValueEditorType := vetValue;
      tmpItem.ValueMax := 255;
      tmpItem.Value := BlendAlpha;

      tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
      tmpItem.Title := 'Lighten';
      tmpItem.Description := 'Enable lighten options?';
      tmpItem.ValueEditorType := vetBoolean;
      if Lighten then tmpItem.Value := 1
        else tmpItem.Value := 0;

      tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
      tmpItem.Title := 'Lighten Transparency';
      tmpItem.Description := 'Adjust this value to define the lighten transparency';
      tmpItem.ValueText := 'Lighten Amount: ';
      tmpItem.ValueEditorType := vetValue;
      tmpItem.ValueMax := 255;
      tmpItem.Value := LightenAmount;
    end;
  finally
    frmSettingsWnd.IsUpdating := False;
    frmSettingsWnd.sceGlassOptions.EndUpdate;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettingsWnd = nil then frmSettingsWnd := TfrmSettingsWnd.Create(nil);
  frmSettingsWnd.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmSettingsWnd);

  Load;
  result := PluginHost.Open(frmSettingsWnd);

end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettingsWnd,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  GlassData : TThemeSkinGlassEffect;
begin
  GlassData := FTheme.Skin.GlassEffect;
  with GlassData, frmSettingsWnd do
  begin
    BlurRadius     := sceGlassOptions.Items.Item[0].Value;
    BlurIterations := sceGlassOptions.Items.Item[1].Value;
    Blend          := (sceGlassOptions.Items.Item[2].Value <> 0);
    BlendColorStr  := inttostr(sceGlassOptions.Items.Item[3].ColorCode);
    BlendAlpha     := sceGlassOptions.Items.Item[4].Value;
    Lighten        := (sceGlassOptions.Items.Item[5].Value <> 0);
    LightenAmount  := sceGlassOptions.Items.Item[6].Value;
  end;
  FTheme.Skin.GlassEffect := GlassData;
  FTheme.Skin.SaveToFileSkinAndGlass;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Glass Effect';
    Description := 'Glass Effect Skin Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.8.0.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmLive),
      Integer(suScheme)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  if (length(trim(pluginID)) = 0) then
    pluginID := SharpThemeApiEx.GetCurrentTheme.Info.Name;

  with Result do
  begin
  	Name := 'Glass Effect';
    Description := Format('Glass Skin Configuration for Theme "%s"', [pluginID]);
	  Status := '';
  end;
end;

function InitPluginInterface(APluginHost: ISharpCenterHost): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.

