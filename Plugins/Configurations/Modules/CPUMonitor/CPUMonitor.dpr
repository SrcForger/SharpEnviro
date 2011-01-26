{
Source Name: CPUMonitor.dpr
Description: CPU Monitor Module Config Dll
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

library CPUMonitor;
uses
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXML,
  JvPageList,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  SharpThemeApiEx,
  uThemeConsts,
  SharpECustomSkinSettings,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uISharpESkin,
  uISharpETheme,
  adCpuUsage,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uCPUMonitorWnd in 'uCPUMonitorWnd.pas' {frmCPUMon};

{$E .dll}
         
{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs )
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

    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
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

  PluginHost.Xml.XmlRoot.Name := 'CPUMonitorModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmCPUMon do
  begin
    // If the global element does not exist then add it.
    if ItemNamed['Global'] = nil  then
      Add('Global');
    
    with ItemNamed['Global'].Items do
    begin
      // Clear the list so we don't get duplicates.
      Clear;
      Add('Width', sgbWidth.Value);
      Add('Update', sgbUpdate.Value);
      Add('CPU', round(edit_cpu.Value));

      if cboGraphType.ItemIndex = 0 then
        Add('DrawMode',0)
      else if cboGraphType.ItemIndex = 2 then
        Add('DrawMode',2)
      else Add('DrawMode',1);
    end;

    // If the skin element does not exist then add it.
    if ItemNamed['skin'] = nil  then
      Add('skin');

    with ItemNamed['skin'].Items do
    begin
      // Get the skin name as we save information per skin.
      skin := GetCurrentTheme.Skin.Name;
      skin := StringReplace(skin,' ','_',[rfReplaceAll]);         

      // If the element with the skin name does not exist then add it.
      if ItemNamed[skin] = nil then
        Add(skin);

      with ItemNamed[skin].Items do
      begin
        // Clear the list so we don't get duplicates.
        Clear;
        Add('BGColor', Colors.Items.Item[0].ColorCode);
        Add('FGColor', Colors.Items.Item[1].ColorCode);
        Add('BorderColor', Colors.Items.Item[2].ColorCode);
        Add('BGAlpha', sgbBackground.Value);
        Add('FGAlpha', sgbForeground.Value);
        Add('BorderAlpha', sgbBorder.Value);
      end;
    end;
  end;
  
  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
var
  Custom: TSharpECustomSkinSettings;
  Skin: string;
  i: Integer;
  Theme : ISharpETheme;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  
  frmCPUMon.Left := 0;
  frmCPUMon.Top := 0;
  frmCPUMon.BorderStyle := bsNone;

  Theme := GetCurrentTheme;

  Custom := TSharpECustomSkinSettings.Create;
  Custom.LoadFromXML(Theme.Skin.Directory);
  with Custom.xml.Items do
  begin
    if ItemNamed['cpumonitor'] <> nil then
      with ItemNamed['cpumonitor'].Items, frmCPUMon do
      begin
        Colors.Items.Item[0].ColorCode := Theme.Scheme.ParseColor(Value('bgcolor', '0'));
        Colors.Items.Item[1].ColorCode := Theme.Scheme.ParseColor(Value('fgcolor', 'clwhite'));
        Colors.Items.Item[2].ColorCode := Theme.Scheme.ParseColor(Value('bordercolor', 'clwhite'));
        sgbBackground.Value := IntValue('bgalpha', 255);
        sgbForeground.Value := IntValue('fgalpha', 255);
        sgbBorder.Value := IntValue('borderalpha', 255);
      end;
  end;
  Custom.Free;

  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmCPUMon do
    begin
      if ItemNamed['Global'] <> nil then
      begin
        with ItemNamed['Global'].Items do
        begin
          sgbWidth.Value := IntValue('Width', sgbWidth.Value);
          sgbUpdate.Value := IntValue('Update', sgbUpdate.Value);
          edit_cpu.Value := IntValue('CPU', round(edit_cpu.Value));
          i := IntValue('DrawMode', 1);
          case i of
            0: cboGraphType.ItemIndex := 0;
            2: cboGraphType.ItemIndex := 2;
          else
            cboGraphType.ItemIndex := 1;
          end;
        end;
      end;

      skin := Theme.Skin.Name;
      skin := StringReplace(skin,' ','_',[rfReplaceAll]);   
      
      if ItemNamed['skin'] <> nil then
      begin
        if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
        begin
          with ItemNamed['skin'].Items.ItemNamed[skin].Items do
          begin
            Colors.Items.Item[0].ColorCode := IntValue('BGColor', Colors.Items.Item[0].ColorCode);
            Colors.Items.Item[1].ColorCode := IntValue('FGColor', Colors.Items.Item[1].ColorCode);
            Colors.Items.Item[2].ColorCode := IntValue('BorderColor', Colors.Items.Item[2].ColorCode);
            sgbBackground.Value := IntValue('BGAlpha', sgbBackground.Value);
            sgbForeground.Value := IntValue('FGAlpha', sgbForeground.Value);
            sgbBorder.Value := IntValue('BorderAlpha', sgbBorder.Value);
          end;
        end;
      end;
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmCPUMon = nil then frmCPUMon := TfrmCPUMon.Create(nil);
  frmCPUMon.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmCPUMon);

  Load;
  result := PluginHost.Open(frmCPUMon);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmCPUMon);
end;

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('General', frmCPUMon.pagMon);
  ATabItems.AddObject('Colors', frmCPUMon.pagColors);
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.FObject <> nil then begin
    tmpPag := TJvStandardPage(ATab.FObject);
    tmpPag.Show;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'CPU Monitor';
    Description := 'CPU Monitor Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
	Name := 'CPU Monitor';
    Description := 'Configure the CPU Monitor module, displays current process activity';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmCPUMon,AEditing,Theme);
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

