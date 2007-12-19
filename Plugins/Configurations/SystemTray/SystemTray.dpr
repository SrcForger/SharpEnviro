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
  uVistaFuncs,
  SharpESkinManager,
  SharpESkinPart,
  SysUtils,
  Graphics,
  uSysTrayWnd in 'uSysTrayWnd.pas' {frmSysTray},
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
  SharpECustomSkinSettings in '..\..\..\Common\Delphi Components\SharpE Skin Components\SharpECustomSkinSettings.pas';

{$E .dll}

{$R *.res}

procedure Save;
var
  XML : TJvSimpleXML;
  skin : String;
  fileloaded : boolean;
  fname : string;
begin
  if frmSysTray = nil then
    exit;

  fname := uSharpBarApi.GetModuleXMLFile(strtoint(frmSysTray.sBarID),strtoint(frmSysTray.sModuleID));
  XML := TJvSimpleXML.Create(nil);
  if FileExists(fname) then
  begin
    fileloaded := false;
    try
      XML.LoadFromFile(fname);
      fileloaded := True;
    except
      XML.Root.Clear;
    end;
  end;
  if not fileloaded then
    XML.Root.Name := 'SysTrayModuleSettings';
  skin := SharpThemeApi.GetSkinName;
  with XML.Root.Items, frmSysTray do
  begin
    if ItemNamed['skin'] <> nil then
    begin
      if ItemNamed['skin'].Items.ItemNamed[skin] = nil then
         ItemNamed['skin'].Items.Add(skin);
    end else Add('skin').Items.Add(skin);
    with ItemNamed['skin'].Items.ItemNamed[skin].Items do
    begin
        Clear;
        Add('ShowBackground',cbBackground.Checked);
        Add('BackgroundColor',Colors.Items.Item[0].ColorCode);
        Add('BackgroundAlpha',sgbBackground.Value);
        Add('ShowBorder',cbBorder.Checked);
        Add('BorderColor',Colors.Items.Item[1].ColorCode);
        Add('BorderAlpha',sgbBorder.Value);
        Add('ColorBlend',cbBlend.Checked);
        Add('BlendColor',Colors.Items.Item[2].ColorCode);
        Add('BlendAlpha',sgbBlend.Value);
        Add('IconAlpha',sgbIconAlpha.Value);
    end;
  end;
  XML.SaveToFile(FName);
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
  Custom : TSharpECustomSkinSettings;
  SkinManager : TSharpESkinManager;
  Skin : String;
begin
  if frmSysTray = nil then frmSysTray := TfrmSysTray.Create(nil);

  if not SharpThemeApi.Initialized then
    SharpThemeApi.InitializeTheme;
  SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmSysTray);
  frmSysTray.sBarID := left;
  frmSysTray.sModuleID := right;
  frmSysTray.ParentWindow := aowner;
  frmSysTray.Left := 2;
  frmSysTray.Top := 2;
  frmSysTray.BorderStyle := bsNone;
  result := frmSysTray.Handle;

  Custom := TSharpECustomSkinSettings.Create;
  Custom.LoadFromXML('');
  with Custom.xml.Items do
       if ItemNamed['systemtray'] <> nil then
          with ItemNamed['systemtray'].Items, frmSysTray do
          begin
            SkinManager := TSharpESkinManager.Create(nil,[]);
            SkinManager.SchemeSource       := ssSystem;
            cbBackground.Checked           := BoolValue('showbackground',False);
            Colors.Items.Item[0].ColorCode := SharpESkinPart.SchemedStringToColor(Value('backgroundcolor','0'),SkinManager.Scheme);
            sgbBackground.Value            := IntValue('backgroundalpha',255);
            cbBorder.Checked               := BoolValue('showborder',False);
            Colors.Items.Item[1].ColorCode := SharpESkinPart.SchemedStringToColor(Value('bordercolor','clwhite'),SkinManager.Scheme);
            sgbBorder.Value                := IntValue('borderalpha',255);
            cbBlend.Checked                := BoolValue('colorblend',false);
            Colors.Items.Item[2].ColorCode := SharpESkinPart.SchemedStringToColor(Value('blendrcolor','clwhite'),SkinManager.Scheme);
            sgbBlend.Value                 := IntValue('blendalpha',0);
            sgbIconAlpha.Value             := IntValue('iconalpha',255);
            SkinManager.Free;
          end;
  Custom.Free;

  skin := SharpThemeApi.GetSkinName;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmSysTray do
      if ItemNamed['skin'] <> nil then
         if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
            with ItemNamed['skin'].Items.ItemNamed[skin].Items do
            begin
              cbBackground.Checked           := BoolValue('ShowBackground',cbBackground.Checked);
              Colors.Items.Item[0].ColorCode := IntValue('BackgroundColor',Colors.Items.Item[0].ColorCode);
              sgbBackground.Value            := IntValue('BackgroundAlpha',sgbBackground.Value);
              cbBorder.Checked               := BoolValue('ShowBorder',cbBorder.Checked);
              Colors.Items.Item[1].ColorCode := IntValue('BorderColor',Colors.Items.Item[1].ColorCode);
              sgbBorder.Value                := IntValue('BorderAlpha',sgbBorder.Value);
              cbBlend.Checked                := BoolValue('ColorBlend',cbBlend.Checked);
              Colors.Items.Item[2].ColorCode := IntValue('BlendColor',Colors.Items.Item[2].ColorCode);
              sgbBlend.Value                 := IntValue('BlendAlpha',sgbBlend.Value);
              sgbIconAlpha.Value             := IntValue('IconAlpha',sgbIconAlpha.Value);
           end;
  XML.Free;

  frmSysTray.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmSysTray.Close;
    frmSysTray.Free;
    frmSysTray := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: String; var ADisplayText: String);
begin
  ADisplayText := PChar('SystemTray');
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
  ATabs.Add('SysTray',frmSysTray.pagSysTray,'','');
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

procedure ClickBtn(AButtonID: Integer; AButton:TPngSpeedButton; AText:String);
begin
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
  AddTabs,
  ClickBtn;

begin
end.

