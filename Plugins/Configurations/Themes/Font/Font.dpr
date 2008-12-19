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
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  SharpEUIC,
  uVistaFuncs,
  SharpThemeApi,
  SharpApi,
  SysUtils,
  Graphics,
  SharpEFontSelectorFontList,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs)
  private
    procedure Load;
  public
    constructor Create(APluginHost: TInterfacedSharpCenterHostBase);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    function GetPluginDescriptionText: string; override; stdcall;
    procedure Refresh; override; stdcall;
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

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: string;
begin
  Result := Format('Skin Font Configuration for "%s"', [PluginHost.PluginId]);
end;

procedure TSharpCenterPlugin.Load;
var
  n: integer;
  s: string;
begin
  PluginHost.Xml.XmlFilename := XmlGetFontFile(PluginHost.PluginId);
  if PluginHost.Xml.Load then begin

    with PluginHost.Xml.XmlRoot, frmSettingsWnd do begin

      frmSettingsWnd.IsUpdating := true;
      try

        with Items do begin

          // Font size
          if BoolValue('ModSize', False) then begin
            sgbFontSize.Value := IntValue('ValueSize', sgbFontSize.Value);
            uicFontSize.UpdateStatus;
          end;

          // Font face
          if BoolValue('ModName', False) then begin
            uicFontType.HasChanged := True;
            s := Value('ValueName', '');
            for n := 0 to cboFontName.Items.Count - 1 do
              if CompareText(TFontInfo(cboFontName.Items.Objects[n]).FullName, s) = 0 then begin
                cboFontName.ItemIndex := n;
                break;
              end;
          end;
          if cboFontName.ItemIndex = -1 then
            cboFontName.ItemIndex := cboFontName.Items.IndexOf('arial');

          // Font visibility
          if BoolValue('ModAlpha', False) then begin
            sgbFontVisibility.value := IntValue('ValueAlpha', sgbFontVisibility.value);
            uicAlpha.UpdateStatus;
          end;

          // font shadow
          if BoolValue('ModUseShadow', False) then begin
            uicShadow.HasChanged := True;
            chkShadow.Checked := BoolValue('ValueUseShadow', chkShadow.Checked);
          end;

          // font shadow type
          if BoolValue('ModShadowType', False) then begin
            uicShadowType.HasChanged := True;
            cboShadowtype.ItemIndex := Max(0, Min(3, IntValue('ValueShadowType', 0)));
          end;

          // font shadow visibility
          if BoolValue('ModShadowAlpha', False) then begin
            sgbShadowAlpha.Value := IntValue('ValueShadowAlpha', sgbShadowAlpha.Value);
            uicShadowAlpha.UpdateStatus;
          end;

          // font bold
          if BoolValue('ModBold', False) then begin
            uicBold.HasChanged := True;
            chkBold.checked := BoolValue('ValueBold', chkBold.checked);
          end;

          // font italic
          if BoolValue('ModItalic', False) then begin
            uicItalic.HasChanged := True;
            chkItalic.checked := BoolValue('ValueItalic', chkItalic.checked);
          end;

          // font underline
          if BoolValue('ModUnderline', False) then begin
            uicUnderline.HasChanged := True;
            chkUnderline.checked := BoolValue('ValueUnderline', chkUnderline.checked);
          end;

          // font cleartype
          if BoolValue('ModClearType', False) then begin
            uicClearType.HasChanged := True;
            chkCleartype.checked := BoolValue('ValueClearType', chkCleartype.checked);
          end;
        end;

      finally
        frmSettingsWnd.IsUpdating := false;
      end;

    end;
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

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForm(PluginHost.Theme, frmSettingsWnd);
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlFilename := XmlGetFontFile(PluginHost.PluginId);
  with PluginHost.Xml.XmlRoot, frmSettingsWnd do begin
    Name := 'ThemeFontSettings';

    with Items do begin
      Add('ModSize', uicFontSize.HasChanged);
      Add('ModName', uicFontType.HasChanged);
      Add('ModAlpha', uicAlpha.HasChanged);
      Add('ModUseShadow', uicShadow.HasChanged);
      Add('ModShadowType', uicShadowType.HasChanged);
      Add('ModShadowAlpha', uicShadowAlpha.HasChanged);
      Add('ModBold', uicBold.HasChanged);
      Add('ModItalic', uicItalic.HasChanged);
      Add('ModUnderline', uicUnderline.HasChanged);
      Add('ModClearType', uicClearType.HasChanged);
      Add('ValueSize', sgbFontSize.Value);
      Add('ValueName', cboFontName.Text);
      Add('ValueAlpha', sgbFontVisibility.value);
      Add('ValueUseShadow', chkShadow.checked);
      Add('ValueShadowType', cboShadowType.ItemIndex);
      Add('ValueShadowAlpha', sgbShadowAlpha.Value);
      Add('ValueBold', chkBold.checked);
      Add('ValueItalic', chkItalic.checked);
      Add('ValueUnderline', chkUnderline.checked);
      Add('ValueClearType', chkCleartype.Checked);
    end;
  end;

  PluginHost.Xml.Save;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Skin Font';
    Description := 'Skin Font Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suTheme)]);
  end;
end;

function InitPluginInterface(APluginHost: TInterfacedSharpCenterHostBase): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

