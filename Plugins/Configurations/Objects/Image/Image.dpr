{
Source Name: Image
Description: Image Object Config Dll
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

library Image;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  SysUtils,
  GR32,
  GR32_Image,
  JvPageList,
  SharpEUIC,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SharpThemeApiEx,
  uISharpETheme,
  uSharpDeskObjectSettings,
  uVistaFuncs,
  uSharpCenterPluginScheme,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings},
  ImageObjectXMLSettings in '..\..\..\Objects\Image\ImageObjectXMLSettings.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs )
  private
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdCall;

    function GetPluginDescriptionText: String; override; stdCall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('Image',frmSettings.pagImage);
  ATabItems.AddObject('Display',frmSettings.pagDisplay);
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.FObject <> nil then begin
    tmpPag := TJvStandardPage(ATab.FObject);
    tmpPag.Show;
  end;

  frmSettings.UpdatePageUI;
  PluginHost.Refresh(rtSize);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpCore\Services\VWM\VWM.xml';
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'The Image object allows you to locally and remotely display images';
end;

procedure TSharpCenterPlugin.Load;
var
  Settings : TImageXMLSettings;
  ITheme : ISharpETheme;
begin
  Settings := TImageXMLSettings.Create(strtoint(PluginHost.PluginId),nil,'Image');
  Settings.LoadSettings;

  with frmSettings, Settings do
  begin
    sgb_size.Value := Size;
    if ftURL then
    begin
      spc.TabIndex := 1;
      sgb_refresh.Value := UrlRefresh;
      imageurl.Text := IconFile;
    end else
    begin
      spc.TabIndex := 0;
      imagefile.Text := IconFile;
    end;

    ITheme := GetCurrentTheme;

    // assign the theme default values
    if ITheme.Desktop.Icon.IconAlphaBlend then
      UIC_AlphaBlend.DefaultValue := 'True'
      else UIC_AlphaBlend.DefaultValue := 'False';
    if ITheme.Desktop.Icon.IconBlending then
      UIC_ColorBlend.DefaultValue := 'True'
      else UIC_ColorBlend.DefaultValue := 'False';
    UIC_BlendAlpha.DefaultValue := inttostr(ITheme.Desktop.Icon.IconAlpha);
    UIC_ColorAlpha.DefaultValue := inttostr(ITheme.Desktop.Icon.IconBlendAlpha);
    UIC_Colors.DefaultValue := inttostr(ITheme.Desktop.Icon.IconBlendColor);

    // load the actual values
    cbalphablend.Checked               := Theme[DS_ICONALPHABLEND].BoolValue;
    cbcolorblend.Checked               := Theme[DS_ICONBLENDING].BoolValue;
    sgbiconalpha.Value                 := Theme[DS_ICONALPHA].IntValue;
    sbgimagencblendalpha.Value         := Theme[DS_ICONBLENDALPHA].IntValue;
    IconColors.Items.Item[0].ColorCode := Theme[DS_ICONBLENDCOLOR].IntValue;

    // load if settings are changed
    UIC_AlphaBlend.HasChanged := Theme[DS_ICONALPHABLEND].isCustom;
    UIC_ColorBlend.HasChanged := Theme[DS_ICONBLENDING].isCustom;
    UIC_BlendAlpha.Haschanged := Theme[DS_ICONALPHA].isCustom;
    UIC_ColorAlpha.HasChanged := Theme[DS_ICONBLENDALPHA].isCustom;
    UIC_Colors.HasChanged     := Theme[DS_ICONBLENDCOLOR].isCustom;
  end;

  Settings.Free;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettings = nil then frmSettings := TfrmSettings.Create(nil);
  frmSettings.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmSettings);

  Load;
  result := PluginHost.Open(frmSettings);
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettings,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  Settings : TImageXMLSettings;
begin

  with frmSettings, Settings do
  begin
    Settings := TImageXMLSettings.Create(strtoint(PluginHost.PluginId),nil,'Image');
    Settings.LoadSettings;

    // save the normal settings
    Size := sgb_size.Value;
    ftUrl := (spc.TabIndex = 1);
    if ftUrl then
    begin
      UrlRefresh := sgb_refresh.Value;
      Iconfile := imageurl.Text;
    end else IconFile := imagefile.Text;

    // save which UIC items have changed and should be saved to xml
    Theme[DS_ICONALPHABLEND].isCustom := UIC_AlphaBlend.HasChanged;
    Theme[DS_ICONBLENDING].isCustom   := UIC_ColorBlend.HasChanged;
    Theme[DS_ICONALPHA].isCustom      := UIC_BlendAlpha.Haschanged;
    Theme[DS_ICONBLENDALPHA].isCustom := UIC_ColorAlpha.HasChanged;
    Theme[DS_ICONBLENDCOLOR].isCustom := UIC_Colors.HasChanged;

    // save the actual values (will only be saved to XMl if isCustom = True)
    Theme[DS_ICONALPHABLEND].BoolValue := cbalphablend.Checked;
    Theme[DS_ICONBLENDING].BoolValue   := cbcolorblend.Checked;
    Theme[DS_ICONALPHA].IntValue       := sgbiconalpha.Value;
    Theme[DS_ICONBLENDALPHA].IntValue  := sbgimagencblendalpha.Value;
    Theme[DS_ICONBLENDCOLOR].IntValue  := IconColors.Items.Item[0].ColorCode;
  end;
  Settings.SaveSettings(True);
  Settings.Free;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Image';
    Description := 'Image Object Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suDesktopObject)]);
  end;
end;

function InitPluginInterface( APluginHost: ISharpCenterHost ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin;
end.

//procedure Save;
//var
//  Settings : TImageXMLSettings;
//begin
//  if frmImage = nil then frmImage := TfrmImage.Create(nil);
//
//  uVistaFuncs.SetVistaFonts(frmImage);
//  frmImage.sObjectID := APluginID;
//  frmImage.ParentWindow := aowner;
//  frmImage.Left := 2;
//  frmImage.Top := 2;
//  frmImage.BorderStyle := bsNone;
//  SharpThemeapi.LoadTheme(False,[tpDesktopIcon]);
//
//  Settings := TImageXMLSettings.Create(strtoint(APluginID),nil,'Image');
//  Settings.LoadSettings;
//
//  with frmImage, Settings do
//  begin
//    sgb_size.Value := Size;
//    if ftURL then
//    begin
//      spc.TabIndex := 1;
//      sgb_refresh.Value := UrlRefresh;
//      imageurl.Text := IconFile;
//    end else
//    begin
//      spc.TabIndex := 0;
//      imagefile.Text := IconFile;
//    end;
//
//    // assign the theme default values
//    if GetDesktopIconAlphaBlend then
//      UIC_AlphaBlend.DefaultValue := 'True'
//      else UIC_AlphaBlend.DefaultValue := 'False';
//    if GetDesktopIconBlending then
//      UIC_ColorBlend.DefaultValue := 'True'
//      else UIC_ColorBlend.DefaultValue := 'False';
//    UIC_BlendAlpha.DefaultValue := inttostr(GetDesktopIconAlpha);
//    UIC_ColorAlpha.DefaultValue := inttostr(GetDesktopIconBlendAlpha);
//    UIC_Colors.DefaultValue := inttostr(GetDesktopIconBlendColor);
//
//    // load the actual values
//    cbalphablend.Checked               := Theme[DS_ICONALPHABLEND].BoolValue;
//    cbcolorblend.Checked               := Theme[DS_ICONBLENDING].BoolValue;
//    sgbiconalpha.Value                 := Theme[DS_ICONALPHA].IntValue;
//    sbgimagencblendalpha.Value         := Theme[DS_ICONBLENDALPHA].IntValue;
//    IconColors.Items.Item[0].ColorCode := Theme[DS_ICONBLENDCOLOR].IntValue;
//
//    // load if settings are changed
//    UIC_AlphaBlend.HasChanged := Theme[DS_ICONALPHABLEND].isCustom;
//    UIC_ColorBlend.HasChanged := Theme[DS_ICONBLENDING].isCustom;
//    UIC_BlendAlpha.Haschanged := Theme[DS_ICONALPHA].isCustom;
//    UIC_ColorAlpha.HasChanged := Theme[DS_ICONBLENDALPHA].isCustom;
//    UIC_Colors.HasChanged     := Theme[DS_ICONBLENDCOLOR].isCustom;
//  end;
//
//  Settings.Free;
//
//  frmImage.Show;
//  result := frmImage.Handle;
//end;
//
//function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
//var
//  Settings : TImageXMLSettings;
//begin

//
//  Settings := TImageXMLSettings.Create(strtoint(APluginID),nil,'Image');
//  Settings.LoadSettings;
//
//  with frmImage, Settings do
//  begin
//    sgb_size.Value := Size;
//    if ftURL then
//    begin
//      spc.TabIndex := 1;
//      sgb_refresh.Value := UrlRefresh;
//      imageurl.Text := IconFile;
//    end else
//    begin
//      spc.TabIndex := 0;
//      imagefile.Text := IconFile;
//    end;
//
//    // assign the theme default values
//    if GetDesktopIconAlphaBlend then
//      UIC_AlphaBlend.DefaultValue := 'True'
//      else UIC_AlphaBlend.DefaultValue := 'False';
//    if GetDesktopIconBlending then
//      UIC_ColorBlend.DefaultValue := 'True'
//      else UIC_ColorBlend.DefaultValue := 'False';
//    UIC_BlendAlpha.DefaultValue := inttostr(GetDesktopIconAlpha);
//    UIC_ColorAlpha.DefaultValue := inttostr(GetDesktopIconBlendAlpha);
//    UIC_Colors.DefaultValue := inttostr(GetDesktopIconBlendColor);
//
//    // load the actual values
//    cbalphablend.Checked               := Theme[DS_ICONALPHABLEND].BoolValue;
//    cbcolorblend.Checked               := Theme[DS_ICONBLENDING].BoolValue;
//    sgbiconalpha.Value                 := Theme[DS_ICONALPHA].IntValue;
//    sbgimagencblendalpha.Value         := Theme[DS_ICONBLENDALPHA].IntValue;
//    IconColors.Items.Item[0].ColorCode := Theme[DS_ICONBLENDCOLOR].IntValue;
//
//    // load if settings are changed
//    UIC_AlphaBlend.HasChanged := Theme[DS_ICONALPHABLEND].isCustom;
//    UIC_ColorBlend.HasChanged := Theme[DS_ICONBLENDING].isCustom;
//    UIC_BlendAlpha.Haschanged := Theme[DS_ICONALPHA].isCustom;
//    UIC_ColorAlpha.HasChanged := Theme[DS_ICONBLENDALPHA].isCustom;
//    UIC_Colors.HasChanged     := Theme[DS_ICONBLENDCOLOR].isCustom;
//  end;
//
//  Settings.Free;
//
//  frmImage.Show;
//  result := frmImage.Handle;
//end;
//
//function Close : boolean;
//begin
//  result := True;
//  try
//    frmImage.Close;
//    frmImage.Free;
//    frmImage := nil;
//  except
//    result := False;
//  end;
//end;
//
//
//procedure AddTabs(var ATabs:TStringList);
//begin
//  ATabs.AddObject('Image',frmImage.pagImage);
//  ATabs.AddObject('Display',frmImage.pagDisplay);
//end;
//
//procedure ClickTab(ATab: TStringItem);
//var
//  tmpPag: TJvStandardPage;
//begin
//  if ATab.FObject <> nil then begin
//    tmpPag := TJvStandardPage(ATab.FObject);
//    tmpPag.Show;
//  end;
//
//end;
//

//
//
//exports
//  Open,
//  Close,
//  Save,
//  ClickTab,
//  SetText,
//  GetCenterScheme,
//  GetMetaData,
//  AddTabs;
//
//end.

