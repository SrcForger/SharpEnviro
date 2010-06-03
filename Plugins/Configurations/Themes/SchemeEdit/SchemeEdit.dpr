{
Source Name: Scheme.dll
Description: Configuration dll for Scheme settings
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
library SchemeEdit;

uses
//  VCLFixPack,
  windows,
  sysutils,
  sharpapi,
  classes,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  JclSimpleXML,
  sharpthemeapiEx,
  graphics,
  uVistaFuncs,
  uThemeConsts,
  uISharpETheme,
  uSharpETheme,
  uSharpCenterPluginScheme,
  BarPreview,
  forms,
  GR32,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uEditWnd in 'uEditWnd.pas' {frmEditWnd};

{$R *.RES}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginPreview )
  private
    FTheme : ISharpETheme;
    procedure Load;
  public
    constructor Create(APluginHost: ISharpCenterHost);
    destructor Destroy; override;

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure Save; override; stdCall;
    procedure UpdatePreview(ABitmap: TBitmap32); stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
var
  themeId : string;
begin
  PluginHost := APluginHost;

  themeId := copy(APluginHost.PluginId, 0, pos(':', APluginHost.PluginId)-1);

  FTheme := TSharpETheme.Create(themeId);
  FTheme.LoadTheme([tpSkinScheme]);
end;

destructor TSharpCenterPlugin.Destroy;
begin
  FTheme := nil;

  inherited Destroy;
end;

procedure TSharpCenterPlugin.Load;
var
  pluginId, themeId, schemeId: String;
begin
  FTheme.LoadTheme([tpSkinScheme]);
  pluginId := PluginHost.PluginId;
  themeId := copy(pluginId, 0, pos(':',pluginId)-1);
  schemeId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));

  frmEditWnd.Scheme := schemeId;
  XmlGetThemeScheme(themeId, schemeId, FTheme.Skin.Name, frmEditWnd.Colors, FTheme);
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmEditWnd = nil then frmEditWnd := TfrmEditWnd.Create(nil);
  frmEditWnd.Theme := FTheme;
  uVistaFuncs.SetVistaFonts(frmEditWnd);

  frmEditWnd.PluginHost := PluginHost;
  Load;
  result := PluginHost.Open(frmEditWnd);
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmEditWnd,AEditing,Theme);
end;

function XmlGetSchemeAuthor(ATheme: string; AScheme: string; ITheme : ISharpETheme): string;
var
  xml: TJclSimpleXML;
  sSchemeDir, sSkin: string;
begin
  Result := '';
  sSkin := ITheme.Skin.Name;
  sSchemeDir := SharpApi.GetSharpeUserSettingsPath + SKINS_SCHEME_DIRECTORY + '\' + sSkin + '\';

  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromFile(sSchemeDir + AScheme + '.xml');
    if xml.Root.Items.ItemNamed['Info'] <> nil then
      result := xml.Root.Items.ItemNamed['Info'].Items.Value('Author');
  finally
    xml.Free;
  end;
end;

procedure XmlSetThemeScheme(ATheme: string; AScheme: string; ASkin: string;
  var AThemeScheme: TSharpEColorSet; ITheme: ISharpETheme; AAuthor:string=''); overload;
var
  xml: TJclSimpleXML;
  i: Integer;
  sFileName, sSchemeDir, sSkin, sAuthor: string;
begin
  xml := TJclSimpleXML.Create;

  try
    xml.Root.Name := 'SharpESkinScheme';
    xml.Root.Items.Add('Info');
    with xml.Root.Items.ItemNamed['Info'] do begin
      Items.Add('Name', AScheme);

      if AAuthor = '' then
        sAuthor := XmlGetSchemeAuthor(ATheme, AScheme, ITheme) else
          sAuthor := AAuthor;

        Items.Add('Author', sAuthor);

    end;
    for i := 0 to High(AThemeScheme) do begin
      with xml.Root.Items.Add('Item') do begin
        Items.Add('Tag', AThemeScheme[i].Tag);
        Items.Add('Color', AThemeScheme[i].Color);
      end;
    end;
    sSkin := ASkin;
    sSchemeDir := SharpApi.GetSharpeUserSettingsPath + SKINS_SCHEME_DIRECTORY + '\' + sSkin + '\';
    sFileName := sSchemeDir + AScheme + '.xml';
    xml.SaveToFile(sFileName);
  finally
    xml.Free;
  end;

end;

procedure TSharpCenterPlugin.Save;
begin
  XmlSetThemeScheme(FTheme.Info.Name,
                    frmEditWnd.Scheme,
                    FTheme.Skin.Name,
                    frmEditWnd.Colors,
                    FTheme);
end;

procedure TSharpCenterPlugin.UpdatePreview(ABitmap: TBitmap32);
begin
  if ( ( High(frmEditWnd.Colors)= 0) or (frmEditWnd = nil) ) then begin
    ABitmap.SetSize(0,0);
    exit;
  end;

  ABitmap.Clear(color32(0,0,0,0));
  frmEditWnd.CreatePreviewBitmap(ABitmap);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Edit Scheme';
    Description := 'Configuration for editing a scheme';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suScheme)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
var
  themeId, schemeId: string;
begin
  themeId := copy(pluginID, 0, pos(':', pluginID)-1);
  schemeId := copy(pluginID, pos(':', pluginID)+1, length(pluginID) - pos(':', pluginID));

  with Result do
  begin
	Name := 'Edit Scheme';
    Description := Format('Editing Scheme "%s"',[schemeId]);
	Status := '';
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
