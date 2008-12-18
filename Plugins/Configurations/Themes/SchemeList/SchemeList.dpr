{
Source Name: Scheme.dll
Description: Configuration dll for Scheme settings
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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
library SchemeList;

uses
  windows,
  sysutils,
  sharpapi,
  classes,
  graphics,
  uVistaFuncs,
  forms,
  GR32,
  JclStrings,
  JvValidators,
  SharpCenterApi,
  SharpThemeApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uListWnd in 'uListWnd.pas' {frmListWnd},
  uEditWnd in 'uEditWnd.pas' {frmEditWnd},
  uSchemeList in 'uSchemeList.pas';

{$R *.RES}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation, ISharpCenterPluginPreview )
  private
    procedure ValidateSchemeExists(Sender: TObject; ValueToValidate: Variant; var Valid: Boolean);
    procedure ValidateInvalidChars(Sender: TObject; ValueToValidate: Variant; var Valid: Boolean);
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;

    function GetPluginDescriptionText: String; override; stdCall;
    function GetPluginStatusText: String; override; stdCall;
    procedure Refresh; override; stdcall;
    procedure SetupValidators; stdcall;
    procedure UpdatePreview(ABitmap: TBitmap32); stdcall;

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
    frmEditWnd.Save;

  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := Format('Scheme Configuration for "%s"',[PluginHost.PluginId]);
end;

function TSharpCenterPlugin.GetPluginStatusText: String;
var
  sl: TStringList;
begin
  sl := TstringList.Create;
  try
    sl.CommaText := XmlGetSchemeListAsCommaText(PluginHost.PluginId);
  finally
    result := IntToStr(sl.count);
    sl.Free;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmListWnd = nil then frmListWnd := TfrmListWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmListWnd);

  frmListWnd.PluginHost := PluginHost;
  frmListWnd.InitialiseSettings;
  result := PluginHost.Open(frmListWnd);
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if frmEditWnd = nil then frmEditWnd := TfrmEditWnd.Create(nil);
  frmEditWnd.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(frmEditWnd);

  result := PluginHost.OpenEdit(frmEditWnd);
  frmEditWnd.InitUI;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForms(PluginHost.Theme,frmListWnd,frmEditWnd, PluginHost.Editing);
end;

procedure TSharpCenterPlugin.SetupValidators;
var
  tmp: TJvCustomValidator;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edName,'Please enter a scheme name','Text');
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edAuthor,'Please enter the name of the author','Text');

  // Validator for checking duplicates
  tmp := PluginHost.AddCustomValidator( frmEditWnd.edName,'There is already a scheme with this name','Text');
  tmp.OnValidate := ValidateSchemeExists;
  tmp := PluginHost.AddCustomValidator( frmEditWnd.edName,'Scheme name contains invalid characters' ,'Text');
  tmp.OnValidate := ValidateInvalidChars;
end;

procedure TSharpCenterPlugin.UpdatePreview(ABitmap: TBitmap32);
begin
  if (frmListWnd = nil) or (frmListWnd.lbSchemeList.Count = 0) then begin
    ABitmap.SetSize(0,0);
    exit;
  end;

  ABitmap.Clear(color32(0,0,0,0));
  frmListWnd.CreatePreviewBitmap(ABitmap);
end;

procedure TSharpCenterPlugin.ValidateSchemeExists(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  bExistsName: Boolean;
  sName, sSkinDir, sSchemeDir: string;
begin
  sName := trim(StrRemoveChars(frmEditWnd.edName.Text,
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
  sSkinDir := GetSharpeDirectory + 'skins';
  sSchemeDir := Format('%s\%s\schemes\', [sSkinDir, XmlGetSkin(PluginHost.PluginId)]);

  bExistsName := FileExists(sSchemeDir + sName + '.xml');
  if ((CompareText(frmEditWnd.edName.Text, frmEditWnd.SchemeItem.Name) = 0) and (PluginHost.EditMode = sceEdit)) then
    bExistsName := False;

  Valid := not (bExistsName);
end;

procedure TSharpCenterPlugin.ValidateInvalidChars(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  s: string;
begin
  s := string(ValueToValidate);
  Valid := not (StrContainsChars(s, ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':'], False));
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Schemes';
    Description := 'Scheme Theme Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
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
