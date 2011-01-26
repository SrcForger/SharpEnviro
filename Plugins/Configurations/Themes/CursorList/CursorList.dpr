{
Source Name: Cursors
Description: Cursors Service Config Dll
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
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  GR32_Image,
  GR32,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpThemeApiEx,
  SharpApi,
  SharpCenterApi,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd},
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

{$E .dll}

{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginPreview )
  private
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdCall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure UpdatePreview(ABitmap: TBitmap32); stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettingsWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

procedure TSharpCenterPlugin.Load;
var
  cursor: string;
  i: integer;
begin
  with PluginHost, PluginHost.Xml do
  begin
    if length(trim(PluginId)) = 0 then
      PluginId := SharpThemeApiEx.GetCurrentTheme.Info.Name;
    

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

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettingsWnd,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  i : integer;
begin
  if (frmSettingsWnd.lbCursorList.SelectedItem = nil ) then exit;

  with PluginHost.Xml do
  begin
    if length(trim(PluginHost.PluginId)) = 0 then
      PluginHost.PluginId := SharpThemeApiEx.GetCurrentTheme.Info.Name;


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
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suCursor)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
var
  files: TStringList;
begin
  if (length(trim(pluginID)) = 0) then
    pluginID := SharpThemeApiEx.GetCurrentTheme.Info.Name;

  with Result do
  begin
  	Name := 'Cursors';
    Description := Format('Cursor Configuration for Theme "%s"',[pluginID]);
	  Status := '';

    files := TStringList.Create;
    try
      FindFiles( files, SharpApi.GetSharpeDirectory + 'Cursors\', '*Skin.xml' );
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

