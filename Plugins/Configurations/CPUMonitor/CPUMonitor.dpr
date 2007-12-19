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
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JclSimpleXML,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  uVistaFuncs,
  SharpESkinManager,
  SharpESkinPart,
  SysUtils,
  Graphics,
  uCPUMonitorWnd in 'uCPUMonitorWnd.pas' {frmCPUMon},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpDialogs in '..\..\..\Common\Libraries\SharpDialogs\SharpDialogs.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas',
  SharpECustomSkinSettings in '..\..\..\Common\Delphi Components\SharpE Skin Components\SharpECustomSkinSettings.pas',
  adCpuUsage in '..\..\..\Common\3rd party\adCpuUsage\adCpuUsage.pas';

{$E .dll}

{$R *.res}

procedure Save;
var
  XML : TJclSimpleXML;
  skin : String;
  fileloaded : boolean;
  fname : string;
begin
  if frmCPUMon = nil then
    exit;

  fname := uSharpBarApi.GetModuleXMLFile(strtoint(frmCPUMon.sBarID),strtoint(frmCPUMon.sModuleID));
  XML := TJclSimpleXML.Create;

  fileloaded := false;
  if FileExists(fname) then
  begin
    try
      XML.LoadFromFile(fname);
      fileloaded := True;
    except
      XML.Root.Clear;
    end;
  end;
  if not fileloaded then
    XML.Root.Name := 'CPUMonitorModuleSettings';
    
  skin := SharpThemeApi.GetSkinName;
  with XML.Root.Items, frmCPUMon do
  begin
    if ItemNamed['global'] = nil then
      Add('global');
    with ItemNamed['global'].Items do
    begin
      Clear;
      Add('Width',sgbWidth.Value);
      Add('Update',sgbUpdate.Value);
      Add('CPU',round(edit_cpu.Value));
      if rbGraphBar.Checked then
        Add('DrawMode',0)
      else if rbCurrentUsage.Checked then
        Add('DrawMode',2)
      else Add('DrawMode',1);
    end;

    if ItemNamed['skin'] <> nil then
    begin
      if ItemNamed['skin'].Items.ItemNamed[skin] = nil then
         ItemNamed['skin'].Items.Add(skin);
    end else Add('skin').Items.Add(skin);
    with ItemNamed['skin'].Items.ItemNamed[skin].Items do
    begin
      Clear;
      Add('BGColor',Colors.Items.Item[0].ColorCode);
      Add('FGColor',Colors.Items.Item[1].ColorCode);
      Add('BorderColor',Colors.Items.Item[2].ColorCode);
      Add('BGAlpha',sgbBackground.Value);
      Add('FGAlpha',sgbForeground.Value);
      Add('BorderAlpha',sgbBorder.Value);
    end;
  end;
  XML.SaveToFile(FName);
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJclSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
  Custom : TSharpECustomSkinSettings;
  SkinManager : TSharpESkinManager;
  Skin : String;
  i : integer;
begin
  if frmCPUMon = nil then frmCPUMon := TfrmCPUMon.Create(nil);

  if not SharpThemeApi.Initialized then
    SharpThemeApi.InitializeTheme;
  SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmCPUMon);
  frmCPUMon.sBarID := left;
  frmCPUMon.sModuleID := right;
  frmCPUMon.ParentWindow := aowner;
  frmCPUMon.Left := 2;
  frmCPUMon.Top := 2;
  frmCPUMon.BorderStyle := bsNone;
  result := frmCPUMon.Handle;

  Custom := TSharpECustomSkinSettings.Create;
  Custom.LoadFromXML('');
  with Custom.xml.Items do
       if ItemNamed['cpumonitor'] <> nil then
          with ItemNamed['cpumonitor'].Items, frmCPUMon do
          begin
            SkinManager := TSharpESkinManager.Create(nil,[]);
            SkinManager.SchemeSource       := ssSystem;
            Colors.Items.Item[0].ColorCode := SharpESkinPart.SchemedStringToColor(Value('bgcolor','0'),SkinManager.Scheme);
            Colors.Items.Item[1].ColorCode := SharpESkinPart.SchemedStringToColor(Value('fgcolor','clwhite'),SkinManager.Scheme);
            Colors.Items.Item[2].ColorCode := SharpESkinPart.SchemedStringToColor(Value('bordercolor','clwhite'),SkinManager.Scheme);
            sgbBackground.Value := IntValue('bgalpha',255);
            sgbForeground.Value := IntValue('fgalpha',255);
            sgbBorder.Value := IntValue('borderalpha',255);
            SkinManager.Free;
          end;
  Custom.Free;

  skin := SharpThemeApi.GetSkinName;

  XML := TJclSimpleXML.Create;
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmCPUMon do
    begin
      if ItemNamed['global'] <> nil then
        with ItemNamed['global'].Items do
        begin             
          sgbWidth.Value := IntValue('Width',sgbWidth.Value);
          sgbUpdate.Value := IntValue('Update',sgbUpdate.Value);
          edit_cpu.Value  := IntValue('CPU',round(edit_cpu.Value));
          i := IntValue('DrawMode',1);
          case i of
            0: rbGraphBar.Checked := True;
            2: rbCurrentUsage.Checked := True;
            else rbGraphLine.Checked := True;
          end;
      end;

      if ItemNamed['skin'] <> nil then
         if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
            with ItemNamed['skin'].Items.ItemNamed[skin].Items do
            begin
              Colors.Items.Item[0].ColorCode := IntValue('BGColor',Colors.Items.Item[0].ColorCode);
              Colors.Items.Item[1].ColorCode := IntValue('FGColor',Colors.Items.Item[1].ColorCode);
              Colors.Items.Item[2].ColorCode := IntValue('BorderColor',Colors.Items.Item[2].ColorCode);
              sgbBackground.Value := IntValue('BGAlpha',sgbBackground.Value);
              sgbForeground.Value := IntValue('FGAlpha',sgbForeground.Value);
              sgbBorder.Value     := IntValue('BorderAlpha',sgbBorder.Value);
           end;
    end;
  XML.Free;

  frmCPUMon.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmCPUMon.Close;
    frmCPUMon.Free;
    frmCPUMon := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: String; var ADisplayText: String);
begin
  ADisplayText := PChar('CPU Monitor');
end;

procedure SetStatusText(const APluginID: String; var AStatusText: string);
begin
  AStatusText := '';
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);

begin
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('General',frmCPUMon.pagMon,'','');
  ATabs.Add('Colors',frmCPUMon.pagColors,'','');  
end;

procedure ClickTab(ATab: TPluginTabItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.Data <> nil then begin
    tmpPag := TJvStandardPage(ATab.Data);
    tmpPag.Show;
  end;
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  result := suModule;
end;


exports
  Open,
  Close,
  Save,
  ClickTab,
  SetDisplayText,
  SetStatusText,
  SetSettingType,
  SetBtnState,
  GetCenterScheme,
  AddTabs;

begin
end.

