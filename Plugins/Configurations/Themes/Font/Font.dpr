{
Source Name: Font
Description: Font Config Dll
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

library Font;
uses
//  VCLFixPack,
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  SharpEUIC,
  uVistaFuncs,
  SharpThemeApiEx,
  uSharpETheme,
  uISharpETheme,
  uThemeConsts,
  SharpApi,
  SysUtils,
  Graphics,
  SharpEFontSelectorFontList,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}

{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs)
  private
    FTheme : ISharpETheme;
    procedure Load;
  public
    constructor Create(APluginHost: ISharpCenterHost);
    destructor Destroy; override; 

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
    procedure Save; override; stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('Font Face', frmSettingsWnd.pagFont);
  ATabItems.AddObject('Font Shadow', frmSettingsWnd.pagFontShadow);
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.FObject <> nil then begin
    tmpPag := TJvStandardPage(ATab.FObject);
    tmpPag.Show;

    if tmpPag = frmSettingsWnd.pagFont then
      frmSettingsWnd.Height := 500 else
      frmSettingsWnd.Height := 220;
  end;
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettingsWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;

  if (length(trim(PluginHost.pluginID)) = 0) then
    PluginHost.pluginID := SharpThemeApiEx.GetCurrentTheme.Info.Name;  

  FTheme := TSharpETheme.Create(PluginHost.PluginID);
  FTheme.LoadTheme([tpSkinFont]);  
end;

destructor TSharpCenterPlugin.Destroy;
begin
  FTheme := nil;

  inherited Destroy;
end;

procedure TSharpCenterPlugin.Load;
var
  n: integer;
  s: string;
begin
  FTheme.LoadTheme([tpSkinFont]);
  with frmSettingsWnd, FTheme.Skin.SkinFont do
  begin
    IsUpdating := true;

    // Font size
    if ModSize then begin
      sgbFontSize.Value := ValueSize;
      uicFontSize.UpdateStatus;
    end;

    // Font face
    if ModName then begin
      uicFontType.HasChanged := True;
      s := ValueName;
      for n := 0 to cboFontName.Items.Count - 1 do
        if CompareText(TFontInfo(cboFontName.Items.Objects[n]).FullName, s) = 0 then begin
          cboFontName.ItemIndex := n;
          break;
        end;
    end;
    if cboFontName.ItemIndex = -1 then
      cboFontName.ItemIndex := cboFontName.Items.IndexOf('arial');

    // Font visibility
    if ModAlpha then begin
      sgbFontVisibility.value := ValueAlpha;
      uicAlpha.UpdateStatus;
    end;

    // font shadow
    if ModUseShadow then begin
      uicShadow.HasChanged := True;
      chkShadow.Checked := ValueUseShadow;
    end;

    // font shadow type
    if ModShadowType then begin
      uicShadowType.HasChanged := True;
      cboShadowtype.ItemIndex := Max(0, Min(3, ValueShadowType));
    end;

    // font shadow visibility
    if ModShadowAlpha then begin
      sgbShadowAlpha.Value := ValueShadowAlpha;
      uicShadowAlpha.UpdateStatus;
    end;

    // font bold
    if ModBold then begin
      uicBold.HasChanged := True;
      chkBold.checked := ValueBold;
    end;

    // font italic
    if ModItalic then begin
      uicItalic.HasChanged := True;
      chkItalic.checked := ValueItalic;
    end;

    // font underline
    if ModUnderline then begin
      uicUnderline.HasChanged := True;
      chkUnderline.checked := ValueUnderline;
    end;

    // font cleartype
    if ModClearType then begin
      uicClearType.HasChanged := True;
      chkCleartype.checked := ValueClearType;
    end;
    IsUpdating := false;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettingsWnd = nil then frmSettingsWnd := TfrmSettingsWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmSettingsWnd);

  frmSettingsWnd.PluginHost := PluginHost;
  Load;
  result := PluginHost.Open(frmSettingsWnd);
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettingsWnd,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  FontData : TThemeSkinFont;
begin
  FontData := FTheme.Skin.SkinFont;
  with frmSettingsWnd, FontData do
  begin
    ModSize          := uicFontSize.HasChanged;
    ModName          := uicFontType.HasChanged;
    ModAlpha         := uicAlpha.HasChanged;
    ModUseShadow     := uicShadow.HasChanged;
    ModShadowType    := uicShadowType.HasChanged;
    ModShadowAlpha   := uicShadowAlpha.HasChanged;
    ModBold          := uicBold.HasChanged;
    ModItalic        := uicItalic.HasChanged;
    ModUnderline     := uicUnderline.HasChanged;
    ModClearType     := uicClearType.HasChanged;
    ValueSize        := sgbFontSize.Value;
    ValueName        := cboFontName.Text;
    ValueAlpha       := sgbFontVisibility.value;
    ValueUseShadow   := chkShadow.checked;
    ValueShadowType  := cboShadowType.ItemIndex;
    ValueShadowAlpha := sgbShadowAlpha.Value;
    ValueBold        := chkBold.checked;
    ValueItalic      := chkItalic.checked;
    ValueUnderline   := chkUnderline.checked;
    ValueClearType   := chkCleartype.Checked;
  end;
  FTheme.Skin.SkinFont := FontData;
  FTheme.Skin.SaveToFileFont;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Skin Font';
    Description := 'Skin Font Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suSkinFont)]);
  end;
end;

function GetPluginData(pluginID: String): TPluginData;
begin
  if (length(trim(pluginID)) = 0) then
    pluginID := SharpThemeApiEx.GetCurrentTheme.Info.Name;

  with Result do
  begin
    Name := 'Skin Font';
    Description := Format('Skin Font Configuration for Theme "%s"', [pluginID]);
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

