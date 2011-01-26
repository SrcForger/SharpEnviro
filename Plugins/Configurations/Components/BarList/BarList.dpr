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

library BarList;
uses
//  VCLFixPack,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  Contnrs,
  graphics,
  JclSimpleXml,
  JvValidators,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  SharpApi,
  SharpCenterApi,
  SharpThemeApiEx,
  SharpFileUtils,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uSharpBar in '..\..\..\..\Components\SharpBar\uSharpBar.pas',
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uListWnd in 'uListWnd.pas' {frmListWnd},
  uEditWnd in 'uEditWnd.pas' {frmEditwnd};

{$E .dll}

{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
    FBars: TBarItems;

    procedure ValidateNameEvent(Sender: TObject; Value: Variant; var Valid: Boolean);

  public
    constructor Create( APluginHost: ISharpCenterHost );
    destructor Destroy; override;

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure SetupValidators; stdcall;

  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmListWnd);
  FreeAndNil(frmEditWnd);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
  begin
    frmEditWnd.Save;

    FBars.Update;
  end;

  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;

  FBars := TBarItems.Create;
end;

destructor TSharpCenterPlugin.Destroy;
begin
  FreeAndNil(FBars);
end;

function XmlGetBarListAsCommaText: string;
var
  sBarDir: string;
  tmpStringList: TStringList;
begin
  sBarDir := GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  tmpStringList := TStringList.Create;
  try
    FindFiles(tmpStringList, sBarDir, '*bar.xml');
    tmpStringList.Sort;
    result := tmpStringList.CommaText;
  finally
    tmpStringList.Free;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmListWnd = nil then
    frmListWnd := TfrmListWnd.Create(nil);
    
  uVistaFuncs.SetVistaFonts(frmListWnd);

  frmListWnd.PluginHost := PluginHost;
  result := PluginHost.Open(frmListWnd);
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if frmEditWnd = nil then
    frmEditWnd := TfrmEditWnd.Create(nil);

  uVistaFuncs.SetVistaFonts(frmEditWnd);

  frmEditWnd.PluginHost := Self.PluginHost;
  result := PluginHost.OpenEdit(frmEditWnd);
  frmEditWnd.Init;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToForms(frmListWnd,frmEditWnd,AEditing,Theme);
end;

procedure TSharpCenterPlugin.ValidateNameEvent(Sender: TObject; Value: Variant; var Valid: Boolean);
var
  name: string;
  i : integer;
begin
  Valid := True;

  // Make sure no other bar exists the same name
  name := Value;

  // Use ErrorMessage as a placeholder for the original name
  if name = TJvCustomValidator(Sender).ErrorMessage then
    Exit;

  if Length(Trim(name)) = 0 then
  begin
    MessageBox(frmEditWnd.Handle, 'Please enter a valid name.', 'Change Name', MB_OK);
    Valid := False;
    Exit;
  end;

  for i := 0 to FBars.Count - 1 do
  begin
    if name = FBars.Bars[i].Name then
      Valid := False;
  end;

  if not Valid then
    MessageBox(frmEditWnd.Handle, PChar('A bar with the name ''' + name + ''' already exists.' + sLineBreak + 'Please choose another name.'), 'Change Name', MB_OK);
end;

procedure TSharpCenterPlugin.SetupValidators;
begin
  if Assigned(frmEditWnd.BarItem) then
    PluginHost.AddCustomValidator(frmEditWnd.edName, frmEditWnd.BarItem.Name, 'Text').OnValidate := ValidateNameEvent
  else
    PluginHost.AddCustomValidator(frmEditWnd.edName, '', 'Text').OnValidate := ValidateNameEvent;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Toolbars';
    Description := 'SharpBar List Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suSharpBar)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
var
  items: TStringList;
begin
  with result do
  begin
    Name := 'Toolbars';
    Description := 'Create and manage toolbar configurations.';
	Status := '';
	
    items := TStringList.Create;
    try
      items.CommaText := XmlGetBarListAsCommaText;
      Status := IntToStr(items.Count);
    finally
      items.Free;
    end;
  end;
end;

function InitPluginInterface(APluginHost: ISharpCenterHost) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.
