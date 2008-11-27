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
  SharpThemeApi,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin)
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure Load;
  public
    constructor Create(APluginHost: TInterfacedSharpCenterHostBase);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;

    function GetPluginDescriptionText: string; override; stdcall;
    function GetPluginStatusText: string; override; stdcall;
    procedure Refresh; override; stdcall;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost
      write FPluginHost;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettingsWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: string;
begin
  result := Format('Glass Skin Configuration for "%s"', [PluginHost.PluginId]);
end;

function TSharpCenterPlugin.GetPluginStatusText: string;
var
  files: TStringList;
begin
  result := '';

  files := TStringList.Create;
  try
    FindFiles(files, SharpApi.GetSharpeDirectory + 'Icons\', '*Iconset.xml');
    if files.Count <> 0 then result := IntToStr(files.Count);
  finally
    files.Free;
  end;
end;

procedure TSharpCenterPlugin.Load;
var
  tmpItem: TSharpEColorEditorExItem;
begin
  frmSettingsWnd.IsUpdating := true;
  frmSettingsWnd.sceGlassOptions.BeginUpdate;
  try

    with PluginHost.Xml, PluginHost, frmSettingsWnd do begin

      XmlFilename := XmlGetSkinFile(PluginHost.PluginId);
      if Xml.Load then begin

        with XMLRoot.Items do begin

          tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
          tmpItem.Title := 'Blur Radius';
          tmpItem.Description := 'Adjust this value to define the glass blur effect';
          tmpItem.ValueText := 'Blur Radius: ';
          tmpItem.ValueEditorType := vetValue;
          tmpItem.ValueMax := 10;
          tmpItem.Value := IntValue('GEBlurRadius', 1);

          tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
          tmpItem.Title := 'Blur Iterations';
          tmpItem.Description := 'Adjust this value to define the blur iterations';
          tmpItem.ValueText := 'Blur Amount: ';
          tmpItem.ValueEditorType := vetValue;
          tmpItem.ValueMax := 5;
          tmpItem.Value := IntValue('GEBlurIterations', 3);

          tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
          tmpItem.Title := 'Blend';
          tmpItem.Description := 'Enable blend options?';
          tmpItem.ValueEditorType := vetBoolean;
          tmpItem.Value := IntValue('GEBlend', 0);

          tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
          tmpItem.Title := 'Blend Color';
          tmpItem.ValueEditorType := vetColor;
          tmpItem.Value := IntValue('GEBlendColor', clWhite);

          tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
          tmpItem.Title := 'Blend Transparecy';
          tmpItem.Description := 'Adjust this value to define the blend transparency';
          tmpItem.ValueText := 'Blend Amount: ';
          tmpItem.ValueEditorType := vetValue;
          tmpItem.ValueMax := 255;
          tmpItem.Value := IntValue('GEBlendAlpha', 32);

          tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
          tmpItem.Title := 'Lighten';
          tmpItem.Description := 'Enable lighten options?';
          tmpItem.ValueEditorType := vetBoolean;
          tmpItem.Value := IntValue('GELighten', 1);

          tmpItem := TSharpEColorEditorExItem.Create(sceGlassOptions.Items);
          tmpItem.Title := 'Lighten Transparency';
          tmpItem.Description := 'Adjust this value to define the lighten transparency';
          tmpItem.ValueText := 'Lighten Amount: ';
          tmpItem.ValueEditorType := vetValue;
          tmpItem.ValueMax := 255;
          tmpItem.Value := IntValue('GELightenAmount', 32);

        end;
      end;
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

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForm(PluginHost.Theme, frmSettingsWnd);
end;

procedure TSharpCenterPlugin.Save;
begin
  with PluginHost.Xml, PluginHost, frmSettingsWnd do begin

    XmlRoot.Clear;
    XmlRoot.Name := 'SharpEThemeSkin';

    with XMLRoot.Items do begin

      Add('Skin', XmlGetSkin(PluginId));
      Add('GEBlurRadius', sceGlassOptions.Items.Item[0].Value);
      Add('GEBlurIterations', sceGlassOptions.Items.Item[1].Value);
      Add('GEBlend', sceGlassOptions.Items.Item[2].Value);
      Add('GEBlendColor', sceGlassOptions.Items.Item[3].Value);
      Add('GEBlendAlpha', sceGlassOptions.Items.Item[4].Value);
      Add('GELighten', sceGlassOptions.Items.Item[5].Value);
      Add('GELightenAmount', sceGlassOptions.Items.Item[6].Value);
    end;

    XmlFilename := XmlGetSkinFile(PluginId);
    Xml.Save;

  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Glass';
    Description := 'Glass Skin Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmLive),
      Integer(suScheme)]);
  end;
end;

function InitPluginInterface(APluginHost: TInterfacedSharpCenterHostBase): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

//function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
//begin
//  if frmOptions = nil then
//    frmOptions := TfrmOptions.Create(nil);
//
//  uVistaFuncs.SetVistaFonts(frmOptions);
//  frmOptions.PluginID := APluginID;
//  frmOptions.ParentWindow := aowner;
//  frmOptions.Left := 0;
//  frmOptions.Top := 0;
//  frmOptions.BorderStyle := bsNone;
//  frmOptions.Show;
//
//  result := frmOptions.Handle;
//end;
//
//function Close: boolean;
//begin
//  result := True;
//  try
//    frmOptions.Close;
//    frmOptions.Free;
//    frmOptions := nil;
//  except
//    result := False;
//  end;
//end;
//
//procedure Save;
//begin
//  frmOptions.Save;
//end;
//
//

//
//exports
//  Open,
//  Close,
//  Save,
//  SetText,
//  GetMetaData;
//
//begin
//end.

