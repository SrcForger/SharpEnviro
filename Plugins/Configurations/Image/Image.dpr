{
Source Name: Image
Description: Image Object Config Dll
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

library Image;
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
  SysUtils,
  Graphics,
  SharpEFontSelectorFontList,
  uImageWnd in 'uImageWnd.pas' {frmImage},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpEPageControl in '..\..\..\Common\Delphi Components\SharpEPageControl\SharpEPageControl.pas',
  SharpETabList in '..\..\..\Common\Delphi Components\SharpETabList\SharpETabList.pas',
  SharpERoundPanel in '..\..\..\Common\Delphi Components\SharpERoundPanel\SharpERoundPanel.pas',
  ImageObjectXMLSettings in '..\..\Objects\Image\ImageObjectXMLSettings.pas',
  uSharpDeskObjectSettings in '..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas';

{$E .dll}

{$R *.res}

procedure Save;
var
  Settings : TImageXMLSettings;
begin
  if frmImage = nil then
    exit;

  with frmImage, Settings do
  begin
    Settings := TImageXMLSettings.Create(strtoint(frmImage.sObjectID),nil,'Image');
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

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  Settings : TImageXMLSettings;
begin
  if frmImage = nil then frmImage := TfrmImage.Create(nil);

  uVistaFuncs.SetVistaFonts(frmImage);
  frmImage.sObjectID := APluginID;
  frmImage.ParentWindow := aowner;
  frmImage.Left := 2;
  frmImage.Top := 2;
  frmImage.BorderStyle := bsNone;
  SharpThemeapi.LoadTheme(False,[tpDesktopIcon]);

  Settings := TImageXMLSettings.Create(strtoint(APluginID),nil,'Image');
  Settings.LoadSettings;

  with frmImage, Settings do
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

    // assign the theme default values
    if GetDesktopIconAlphaBlend then
      UIC_AlphaBlend.DefaultValue := 'True'
      else UIC_AlphaBlend.DefaultValue := 'False';
    if GetDesktopIconBlending then
      UIC_ColorBlend.DefaultValue := 'True'
      else UIC_ColorBlend.DefaultValue := 'False';
    UIC_BlendAlpha.DefaultValue := inttostr(GetDesktopIconAlpha);
    UIC_ColorAlpha.DefaultValue := inttostr(GetDesktopIconBlendAlpha);
    UIC_Colors.DefaultValue := inttostr(GetDesktopIconBlendColor);

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

  frmImage.Show;
  result := frmImage.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmImage.Close;
    frmImage.Free;
    frmImage := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Image');
end;

procedure SetStatusText(var AStatusText: PChar);
begin
  AStatusText := '';
end;

procedure ClickBtn(AButtonID: Integer; AButton:TPngSpeedButton; AText:String);
begin
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);

  procedure AssingUICColors(Container : TComponent);
  var
    n : integer;
  begin
    for n := 0 to Container.ComponentCount - 1 do
        if Container.Components[n] is TSharpEUIC then
        begin
          TSharpEUIC(Container.Components[n]).NormalColor := clWindow;
          TSharpEUIC(Container.Components[n]).BorderColor := AItemSelectedColor;
          TSharpEUIC(Container.Components[n]).BackgroundColor := $00F7F7F7;
        end else
        if Container.Components[n] is TSharpEUIC then
          AssingUICColors(Container.Components[n]);        
  end;

begin
  if frmImage <> nil then
  begin
    AssingUICColors(frmImage);
    frmImage.spc.TabColor := $00F7F7F7;
    frmImage.spc.BorderColor := $00FBEFE3;
  end;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Image',frmImage.pagImage,'','');
  ATabs.Add('Display',frmImage.pagDisplay,'','');
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
  result := suDesktopObject;
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

end.

