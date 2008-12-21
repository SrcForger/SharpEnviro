{
Source Name: Curses
Description: Curses Service Config Dll
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

library CursorList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  GR32_Image,
  GR32,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpThemeApi,
  SharpApi,
  SharpCenterApi,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd},
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

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
  FreeAndNil(frmSettingsWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  result := Format('Cursor Configuration for "%s"',[PluginHost.PluginId])
end;

function TSharpCenterPlugin.GetPluginStatusText: String;
var
  files: TStringList;
begin
  result := '';

  files := TStringList.Create;
  try
    FindFiles( files, SharpApi.GetSharpeDirectory + 'Cursors\', '*Skin.xml' );
    if files.Count <> 0 then result := IntToStr(files.Count);
  finally
    files.Free;
  end;
end;

procedure TSharpCenterPlugin.Load;
var
  cursor: string;
  i: integer;
begin
  with PluginHost, PluginHost.Xml do begin
    XmlFilename := GetSharpeUserSettingsPath + 'Themes\' + PluginId + '\Cursor.xml';

    if Xml.Load then begin

      // Cursor
      cursor := XMLRoot.Items.Value('CurrentSkin', '');
      frmSettingsWnd.Cursor := cursor;

      // Colours
      for i := 0 to frmSettingsWnd.ccolors.Items.Count - 1 do
        frmSettingsWnd.ccolors.Items.Item[i].ColorCode := XMLRoot.Items.IntValue('Color' + inttostr(i),0);

    end else begin

      // Default
      frmSettingsWnd.Cursor := 'Nabla';
    end;
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
  PluginHost.AssignThemeToPluginForm(frmSettingsWnd);
end;

procedure TSharpCenterPlugin.Save;
var
  i : integer;
begin
  if (frmSettingsWnd.lbCursorList.SelectedItem = nil ) then exit;

  with PluginHost.Xml do begin

    XmlRoot.Clear;
    XmlRoot.Name := 'SharpEThemeCursor';
    XMLRoot.Items.Add('CurrentSkin',frmSettingsWnd.Cursor);

    for i := 0 to frmSettingsWnd.ccolors.Items.Count - 1 do
        XMLRoot.Items.Add('Color' + inttostr(i),frmSettingsWnd.ccolors.Items.Item[i].ColorCode);

    XmlFilename := SharpApi.GetSharpeUserSettingsPath + '\Themes\'+PluginHost.PluginId+'\Cursor.xml';
    PluginHost.Xml.Save;
  end;
end;

procedure TSharpCenterPlugin.UpdatePreview(ABitmap: TBitmap32);
begin
  if (frmSettingsWnd.lbCursorList.ItemIndex < 0) or (frmSettingsWnd.lbCursorList.Count = 0) then
     exit;

  ABitmap.SetSize(ABitmap.Width,frmSettingsWnd.Preview.Height);
  ABitmap.Clear(color32(0,0,0,0));
  frmSettingsWnd.Preview.DrawTo(ABitmap);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Cursors';
    Description := 'Cursor Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suCursor)]);
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

