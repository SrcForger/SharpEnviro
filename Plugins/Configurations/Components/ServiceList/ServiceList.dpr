{
Source Name: SharpBarList
Description: SharpBar Manager Config Dll
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

library ServiceList;
uses
//  VCLFixPack,
  Controls,
  Classes,
  ComCtrls,
  Windows,
  Forms,
  Dialogs,
  Contnrs,
  graphics,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uComponentMan,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  listWnd in 'listWnd.pas' {frmList};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs)
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    procedure ClickPluginTab(ATab: TStringItem); stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
var
  tmpList: TComponentList;
  iConfigurable, iDisabled, iOthers, i: Integer;
  tmp: TComponentData;
begin
  iConfigurable := 0;
  iDisabled := 0;
  iOthers := 0;

  tmpList := TComponentList.Create;
  try
    tmpList.BuildList('.dll', false, true);

    for i := 0 to Pred(tmpList.Count) do begin

      tmp := TComponentData(tmpList[i]);

      if (tmp.HasConfig) and not (tmp.Disabled) then
        inc(iConfigurable);

      if not(tmp.HasConfig) and not(tmp.Disabled) then
        Inc(iOthers);

      if (tmp.Disabled) then
        Inc(iDisabled);
    end;

    ATabItems.AddObject(Format('Configurable (%d)', [iConfigurable]), TObject(aiEditable));
    ATabItems.AddObject(Format('System (%d)', [iOthers]), TObject(aiAll));
    ATabItems.AddObject(Format('Disabled (%d)', [iDisabled]), TObject(aiDisabled));

  finally
    tmpList.Free;
  end;
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
var
  tmp: TAddItemsType;
begin
  tmp := TAddItemsType(ATab.FObject);
  frmList.AddItems(tmp);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmList);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmList = nil then frmList := TfrmList.Create(nil);
  uVistaFuncs.SetVistaFonts(frmList);

  result := PluginHost.Open(frmList);
  frmList.PluginHost := PluginHost;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmList,AEditing,Theme);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Service Manager';
    Description := 'Manage and configure the SharpE Service providers';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmLive),
      Integer(suService)]);
  end;
end;

function GetPluginData(pluginID : integer): TPluginData;
var
  tmpList: TComponentList;
begin
  with result do
  begin
    Name := 'Services';
    Description := 'Manage and configure the SharpE Service providers';
    Status := '';

    tmpList := TComponentList.Create;
    try
      tmpList.BuildList('.dll', false, false);
      Status := IntToStr(tmpList.Count);
    finally
      tmpList.Free;
    end;
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

