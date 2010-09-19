{
Source Name: SystemTray.dpr
Description: System Tray Module Config Dll
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

library SystemTray;
uses
//  VCLFixPack,
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpThemeApiEx,
  SharpCenterAPI,
  SharpECustomSkinSettings,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSysTrayWnd in 'uSysTrayWnd.pas' {frmSysTray},
  SharpCenterThemeAPI in '..\..\..\..\Common\Libraries\SharpCenterApi\SharpCenterThemeAPI.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdCall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
end;

procedure TSharpCenterPlugin.Save;
var
  skin : String;
begin
  PluginHost.Xml.XmlRoot.Name := 'SysTrayModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmSysTray do
  begin
    skin := GetCurrentTheme.Skin.Name;
    skin := StringReplace(skin,' ','_',[rfReplaceAll]);    
    if ItemNamed['iconhiding'] <> nil then
      ItemNamed['iconhiding'].BoolValue := chkIconHiding.Checked
    else Add('iconhiding',chkIconHiding.Checked);

    if ItemNamed['skin'] <> nil then
    begin
      if ItemNamed['skin'].Items.ItemNamed[skin] = nil then
         ItemNamed['skin'].Items.Add(skin);
    end else Add('skin').Items.Add(skin);

    with ItemNamed['skin'].Items.ItemNamed[skin].Items do
    begin
      // Clear the list so we don't get duplicates.
      Clear;
      Add('ShowBackground', chkBackground.Checked);
      Add('BackgroundColor', Colors.Items.Item[0].ColorCode);
      Add('BackgroundAlpha', sgbBackground.Value);
      Add('ShowBorder', chkBorder.Checked);
      Add('BorderColor', Colors.Items.Item[1].ColorCode);
      Add('BorderAlpha', sgbBorder.Value);
      Add('ColorBlend', chkBlend.Checked);
      Add('BlendColor', Colors.Items.Item[2].ColorCode);
      Add('BlendAlpha', sgbBlend.Value);
      Add('IconAlpha', sgbIconAlpha.Value);
    end;
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
var
  Custom : TSharpECustomSkinSettings;
  Skin : String;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  
  Custom := TSharpECustomSkinSettings.Create;
  Custom.LoadFromXML('');
  with Custom.xml.Items do
  begin
    if ItemNamed['systemtray'] <> nil then
    begin
      with ItemNamed['systemtray'].Items, frmSysTray do
        begin
        chkBackground.Checked           := BoolValue('showbackground',False);
        Colors.Items.Item[0].ColorCode := GetCurrentTheme.Scheme.ParseColor(Value('backgroundcolor','0'));
        sgbBackground.Value            := IntValue('backgroundalpha',255);
        chkBorder.Checked               := BoolValue('showborder',False);
        Colors.Items.Item[1].ColorCode := GetCurrentTheme.Scheme.ParseColor(Value('bordercolor','clwhite'));
        sgbBorder.Value                := IntValue('borderalpha',255);
        chkBlend.Checked                := BoolValue('colorblend',false);
        Colors.Items.Item[2].ColorCode := GetCurrentTheme.Scheme.ParseColor(Value('blendrcolor','clwhite'));
        sgbBlend.Value                 := IntValue('blendalpha',0);
        sgbIconAlpha.Value             := IntValue('iconalpha',255);
      end;
    end;
  end;
  Custom.Free;

  skin := GetCurrentTheme.Skin.Name;
  skin := StringReplace(skin,' ','_',[rfReplaceAll]);

  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmSysTray do
    begin
      chkIconHiding.Checked := BoolValue('iconhiding',true);
      if ItemNamed['skin'] <> nil then
      begin
         if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
         begin
            with ItemNamed['skin'].Items.ItemNamed[skin].Items do
            begin
              chkBackground.Checked           := BoolValue('ShowBackground',chkBackground.Checked);
              Colors.Items.Item[0].ColorCode := IntValue('BackgroundColor',Colors.Items.Item[0].ColorCode);
              sgbBackground.Value            := IntValue('BackgroundAlpha',sgbBackground.Value);
              chkBorder.Checked               := BoolValue('ShowBorder',chkBorder.Checked);
              Colors.Items.Item[1].ColorCode := IntValue('BorderColor',Colors.Items.Item[1].ColorCode);
              sgbBorder.Value                := IntValue('BorderAlpha',sgbBorder.Value);
              chkBlend.Checked                := BoolValue('ColorBlend',chkBlend.Checked);
              Colors.Items.Item[2].ColorCode := IntValue('BlendColor',Colors.Items.Item[2].ColorCode);
              sgbBlend.Value                 := IntValue('BlendAlpha',sgbBlend.Value);
              sgbIconAlpha.Value             := IntValue('IconAlpha',sgbIconAlpha.Value);
           end;
         end;
      end;
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSysTray = nil then frmSysTray := TfrmSysTray.Create(nil);
  frmSysTray.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmSysTray);

  Load;
  result := PluginHost.Open(frmSysTray);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSysTray);
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'System Tray';
    Description := 'System Tray Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
	Name := 'System Tray';
    Description := 'Configure the System Tray module';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSysTray,AEditing,Theme);
end;

function InitPluginInterface( APluginHost: ISharpCenterHost ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData,
  SetBtnState;

begin
end.

