{
Source Name: Menu Editor
Description: SharpMenu Editor Config
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

library MenuEdit;
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
  uSharpEMenuSaver,
  SharpApi,
  SharpCenterApi,
  uSharpEMenuItem,
  uListWnd in 'uListWnd.pas' {frmList},
  uEditWnd in 'uEditWnd.pas' {frmEdit},
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    function GetPluginDescriptionText: String; override; stdCall;
    procedure Refresh; override; stdcall;
    destructor Destroy; override;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;
    procedure SetupValidators; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmList);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  // Save settings?
  if AApply then
    frmEdit.Save;

  // Free the window
  FreeAndNil(frmEdit);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

destructor TSharpCenterPlugin.Destroy;
begin
  inherited;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := format('Menu Configuration for "%s". Drag Items to position them, hold down Ctrl to move an item into a submenu',[PluginHost.PluginId]);
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmList = nil then frmList := TfrmList.Create(nil);
  uVistaFuncs.SetVistaFonts(frmList);
  frmList.PluginHost := PluginHost;

  frmList.MenuFile := GetSharpeUserSettingsPath + 'SharpMenu\' + PluginHost.PluginId + '.xml';
  result := PluginHost.Open(frmList);
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if frmEdit = nil then frmEdit := TfrmEdit.Create(nil);
  uVistaFuncs.SetVistaFonts(frmEdit);

  frmEdit.PluginHost := PluginHost;
  result := PluginHost.OpenEdit(frmEdit);

  frmEdit.InitUI;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToForms(frmList,frmEdit);
end;

procedure TSharpCenterPlugin.SetupValidators;
begin
  if frmEdit.pagLink.Visible then begin
    PluginHost.AddRequiredFieldValidator( frmEdit.edLinkName,'Please enter a name','Text');
    PluginHost.AddRequiredFieldValidator( frmEdit.edLinkTarget,'Please enter a target','Text');
  end
  else if frmEdit.pagSubMenu.Visible then begin
    PluginHost.AddRequiredFieldValidator( frmEdit.edSubmenuCaption,'Please enter a name','Text');
    PluginHost.AddRequiredFieldValidator( frmEdit.edSubmenuTarget,'Please enter a name','Text');
  end
  else if frmEdit.pagLabel.Visible then begin
    PluginHost.AddRequiredFieldValidator( frmEdit.edLabelCaption,'Please enter a name','Text');
  end
  else if frmEdit.pagDynamicDir.Visible then begin
    PluginHost.AddRequiredFieldValidator( frmEdit.edDynamicDirTarget,'Please enter a target','Text');
  end;

  
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Menu Editor';
    Description := 'Menu Editor Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suCenter)]);
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

