{
Source Name: MediaController.dpr
Description: Media Controller Module Config
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

library MediaController;
uses
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  Jclstrings,
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
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uEditWnd in 'uEditWnd.pas' {frmEdit},
  MediaPlayerList in '..\..\..\Modules\MediaController\MediaPlayerList.pas';

{$E .dll}

{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin)
  private
    barID : string;
    moduleID : string;
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Load;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;

  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmEdit);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);  
end;

procedure TSharpCenterPlugin.Load;
var
  n,i : Integer;
begin
  with frmEdit do
  begin
    IsUpdating := true;
    PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
    if PluginHost.Xml.Load then
    with PluginHost.Xml.XmlRoot.Items, frmEdit do
      if ItemNamed['Players'] <> nil then
        with ItemNamed['Players'].Items do
        begin
          for n := 0 to Count - 1 do
            for i := 0 to lbItems.Count - 1 do
              if CompareText(TMediaPlayerItem(lbItems.Item[i].Data).Name,Item[n].Properties.Value('Name','')) = 0 then
              begin
                lbItems.Item[i].SubItemChecked[1] := Item[n].Properties.BoolValue('Show',True);
                break;
              end;
        end;
    UpdateSize;
    IsUpdating := false;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmEdit = nil then frmEdit := TfrmEdit.Create(nil);
  uVistaFuncs.SetVistaFonts(frmEdit);

  frmEdit.PluginHost := PluginHost;

  result := PluginHost.Open(frmEdit);
  frmEdit.LoadPlayers;
  Load;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmEdit,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  tmp: TMediaPlayerItem;
  n : Integer;
begin
  inherited;

  PluginHost.Xml.XmlRoot.Name := 'MediaControllerModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmEdit do
  begin
    if ItemNamed['Players'] = nil then
      Add('Players');
    with ItemNamed['Players'].Items do
    begin
      Clear;
      for n := 0 to lbItems.Count - 1 do
      begin
        tmp := TMediaPlayerItem(lbItems.Item[n].Data);
        with Add('Player') do
        begin
          Properties.Add('Name',tmp.Name);
          Properties.Add('Show',lbItems.Item[n].SubItemChecked[1]);
        end;
      end;
    end;
  end;
  PluginHost.Xml.Save;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Media Controller';
    Description := 'Media Controller Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply), Integer(suModule)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Media Controller';
    Description := 'Media Controller Module Configuration';
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

