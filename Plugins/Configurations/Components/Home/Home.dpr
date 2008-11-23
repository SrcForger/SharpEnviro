{
Source Name: Home
Description: Home Configuration
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

library Home;
uses
  Controls,
  Classes,
  Windows,
  ComCtrls,
  Forms,
  Dialogs,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uHomeWnd in 'uHomeWnd.pas' {frmHome},
  SharpCenterApi,
  SharpApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs )
  private
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    procedure ClickPluginTab(ATab: TStringItem); stdCall;
    procedure AddPluginTabs(ATabItems: TStringList); stdCall;
    procedure Refresh; override; stdcall;

  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('About',frmHome.tabCredits);
  ATabItems.AddObject('Support',frmHome.tabUrls);
  ATabItems.AddObject('Contribution',frmHome.tabUrls);
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
begin
  TTabSheet(ATab.FObject).Show;

  if ATab.FString = 'Support' then begin
    frmHome.AddUrlsToList(True);
    frmHome.lblUrls.Caption := 'If you have a problem or query with this release, ' +
      'you can contact us a number of ways: either by email, using the web forum or in our Irc chat room.'
  end
  else if ATab.FString = 'Contribution' then begin
    frmHome.AddUrlsToList(False);
    frmHome.lblUrls.Caption := 'Thanks to the following sites that contributed to SharpE. ' +
      'Without such opensource groups and products we could never finish what we always set out to acheive.';
  end;

end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmHome); 
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  frmHome := TfrmHome.Create(nil);
  SetVistaFonts(frmHome);

  frmHome.PluginHost := PluginHost;
  result := PluginHost.Open(frmHome);
end;

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForm(PluginHost.Theme,frmHome);
end;

function GetMetaData(): TMetaData;
var
  meta: TMetaData;
  priority, delay: integer;
  tmp: string;
begin
  SharpAPI.GetComponentMetaData( GetSharpeDirectory + 'SharpCore.exe', meta, priority, delay);
  tmp := format('Welcome to SharpEnviro (%s)',[meta.Version]);

  with result do
  begin
    Name := 'Home';
    Description := tmp;
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

