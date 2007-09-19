{
Source Name: Link
Description: Link Object Config Dll
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

library Link;
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
  uLinkWnd in 'uLinkWnd.pas' {frmLink},
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
  uSharpDeskObjectSettings in '..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  LinkObjectXMLSettings in '..\..\Objects\Link\LinkObjectXMLSettings.pas',
  SharpDialogs in '..\..\..\Common\Libraries\SharpDialogs\SharpDialogs.pas';

{$E .dll}

{$R *.res}

procedure Save;
var
  Settings : TLinkXMLSettings;
begin
  if frmLink = nil then
    exit;

  with frmLink, Settings do
  begin
    Settings := TLinkXMLSettings.Create(strtoint(frmLink.sObjectID),nil,'Link');
    Settings.LoadSettings;

    // save the normal settings
    CaptionAlign := cb_calign.ItemIndex;
    if spc.TabIndex = 1 then
    begin
      MLineCaption := True;
      Caption := memo_caption.Lines.CommaText;
    end else
    begin
      MLineCaption := False;
      Caption := edit_caption.Text;
    end;
    ShowCaption := cb_caption.Checked;
    Settings.Icon := frmLink.Icon.Text;
    Settings.Target := frmLink.Target.Text;

    // save which UIC items have changed and should be saved to xml
    // Theme[DS_ICONALPHABLEND].isCustom := UIC_AlphaBlend.HasChanged;
    Theme[DS_ICONBLENDING].isCustom    := UICColorBlend.HasChanged;
    Theme[DS_ICONALPHABLEND].isCustom  := UICIconTrans.HasChanged;
    Theme[DS_ICONSHADOW].isCustom      := UICIconShadow.HasChanged;
    Theme[DS_ICONSIZE].isCustom        := UICSize.HasChanged;
    Theme[DS_ICONBLENDALPHA].isCustom  := UICColorBlendValue.HasChanged;
    Theme[DS_ICONALPHA].isCustom       := UICIconTransValue.HasChanged;
    Theme[DS_ICONSHADOWALPHA].isCustom := UICIconShadowValue.HasChanged;
    Theme[DS_ICONBLENDCOLOR].isCustom  := UICColorBlendColor.HasChanged;
    Theme[DS_ICONSHADOWCOLOR].isCustom := UICIconShadowColor.HasChanged;

    Theme[DS_FONTNAME].isCustom       := UICFontName.HasChanged;
    Theme[DS_TEXTSIZE].isCustom       := UICFontSize.HasChanged;
    Theme[DS_TEXTALPHA].isCustom      := UICFontTrans.HasChanged;
    Theme[DS_TEXTALPHAVALUE].isCustom := UICFontTransValue.HasChanged;
    Theme[DS_TEXTBOLD].isCustom       := UICBold.HasChanged;
    Theme[DS_TEXTITALIC].isCustom     := UICItalic.HasChanged;
    Theme[DS_TEXTUNDERLINE].isCustom  := UICUnderline.HasChanged;
    Theme[DS_TEXTCOLOR].isCustom      := UICFontColor.HasChanged;

    // save the actual values (will only be saved to XMl if isCustom = True)
    Theme[DS_ICONBLENDING].BoolValue   := chkColorBlend.Checked;
    Theme[DS_ICONALPHABLEND].BoolValue := chkIconTrans.Checked;
    Theme[DS_ICONSHADOW].BoolValue     := chkIconShadow.Checked;
    if rdoIcon32.Checked then
      Theme[DS_ICONSIZE].IntValue := 32
    else if rdoIcon48.Checked then
      Theme[DS_ICONSIZE].IntValue := 48
    else if rdoIcon64.Checked then
      Theme[DS_ICONSIZE].IntValue := 64
    else Theme[DS_ICONSIZE].IntValue := sgbIconSize.Value;
    Theme[DS_ICONBLENDALPHA].IntValue  := sgbColorBlend.Value;
    Theme[DS_ICONALPHA].IntValue       := sgbIconTrans.Value;
    Theme[DS_ICONSHADOWALPHA].IntValue := sgbIconShadow.Value;
    Theme[DS_ICONBLENDCOLOR].IntValue  := sceColorBlend.Items.Item[0].ColorCode;
    Theme[DS_ICONSHADOWCOLOR].IntValue := sceIconShadow.Items.Item[0].ColorCode;

    Theme[DS_FONTNAME].Value          := cboFontName.Text;
    Theme[DS_TEXTSIZE].IntValue       := sgbFontSize.Value;
    Theme[DS_TEXTALPHAVALUE].IntValue := sgbFontTrans.Value;
    Theme[DS_TEXTALPHA].BoolValue     := chkFontTrans.Checked;
    Theme[DS_TEXTBOLD].BoolValue      := chkBold.Checked;
    Theme[DS_TEXTITALIC].BoolValue    := chkItalic.Checked;
    Theme[DS_TEXTUNDERLINE].BoolValue := chkUnderline.Checked;
    Theme[DS_TEXTCOLOR].IntValue      := sceFontColor.Items.Item[0].ColorCode;
  end;
  Settings.SaveSettings(True);

  Settings.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  Settings : TLinkXMLSettings;
  s : String;
  n : integer;
begin
  if frmLink = nil then frmLink := TfrmLink.Create(nil);

  uVistaFuncs.SetVistaFonts(frmLink);
  frmLink.sObjectID := APluginID;
  frmLink.ParentWindow := aowner;
  frmLink.Left := 2;
  frmLink.Top := 2;
  frmLink.BorderStyle := bsNone;
  SharpThemeapi.LoadTheme(False,[tpDesktopIcon,tpIconSet]);

  Settings := TLinkXMLSettings.Create(strtoint(APluginID),nil,'Link');
  Settings.LoadSettings;

  with frmLink, Settings do
  begin
    // load normal settings
    cb_calign.ItemIndex := CaptionAlign;
    if MLineCaption then
      spc.TabIndex := 1
      else spc.TabIndex := 0;
    cb_caption.Checked := ShowCaption;
    frmLink.Icon.Text := Settings.Icon;
    frmLink.Target.Text := Settings.Target;
    edit_caption.Text := Caption;
    memo_caption.Lines.CommaText := Caption;

    // assign the theme default values
    if GetDesktopIconBlending then
      UICColorBlend.DefaultValue := 'True'
      else UICColorBlend.DefaultValue := 'False';
    if GetDesktopIconAlphaBlend then
      UICIconTrans.DefaultValue := 'True'
      else UICIconTrans.DefaultValue := 'False';
    if GetDesktopIconShadow then
      UICIconShadow.DefaultValue := 'True'
      else UICIconShadow.DefaultValue := 'False';
    UICSize.DefaultValue := inttostr(GetDesktopIconSize);
    UICColorBlendColor.DefaultValue := inttostr(GetDesktopIconBlendColor);
    UICColorBlendValue.DefaultValue := inttostr(GetDesktopIconBlendAlpha);
    UICIconTransValue.DefaultValue  := inttostr(GetDesktopIconAlpha);
    UICIconShadowColor.DefaultValue := inttostr(GetDesktopIconShadowColor);
    UICIconShadowValue.DefaultValue := inttostr(GetDesktopIconShadowAlpha);

    UICFontName.DefaultValue := GetDesktopFontName;
    UICFontSize.DefaultValue := inttostr(GetDesktopTextSize);
    if GetDesktopTextBold then
      UICBold.DefaultValue := 'True'
    else UICBold.DefaultValue := 'False';
    if GetDesktopTextItalic then
      UICItalic.DefaultValue := 'True'
    else UICItalic.DefaultValue := 'False';
    if GetDesktopTextUnderline then
      UICUnderline.DefaultValue := 'True'
    else UICUnderline.DefaultValue := 'False';
    UICFontColor.DefaultValue := inttostr(GetDesktopTextColor);
    if GetDesktopTextAlpha then
      UICFontTrans.DefaultValue := 'True'
    else UICFontTrans.DefaultValue := 'False';
    UICFontTransValue.DefaultValue := inttostr(GetDesktopTextAlphaValue);

    // load the actual values
    chkColorBlend.Checked := Theme[DS_ICONBLENDING].BoolValue;
    chkIconTrans.Checked  := Theme[DS_ICONALPHABLEND].BoolValue;
    chkIconShadow.Checked := Theme[DS_ICONSHADOW].BoolValue;
    case Theme[DS_ICONSIZE].IntValue of
      32: rdoIcon32.Checked := True;
      48: rdoIcon48.Checked := True;
      64: rdoIcon64.Checked := True;
      else
      begin
        rdoIconCustom.Checked := True;
        sgbIconSize.Value := Theme[DS_ICONSIZE].IntValue;
      end;
    end;
    sgbColorBlend.Value := Theme[DS_ICONBLENDALPHA].IntValue;
    sgbIconTrans.Value  := Theme[DS_ICONALPHA].IntValue;
    sgbIconShadow.Value := Theme[DS_ICONSHADOWALPHA].IntValue;
    sceColorBlend.Items.Item[0].ColorCode := Theme[DS_ICONBLENDCOLOR].IntValue;
    sceIconShadow.Items.Item[0].ColorCode := Theme[DS_ICONSHADOWCOLOR].IntValue;

    s := Theme[DS_FONTNAME].Value;
    for n  := 0 to FontList.List.Count - 1 do
    if CompareText(TFontInfo(FontList.List.Objects[n]).FullName,s) = 0 then
    begin
      cboFontName.ItemIndex := cboFontName.Items.IndexOf(FontList.List[n]);
      break;
     end;
    if cboFontName.ItemIndex = -1 then
      cboFontName.ItemIndex := cboFontName.Items.IndexOf('arial');
    sgbFontSize.Value    := Theme[DS_TEXTSIZE].IntValue;
    sgbFontTrans.Value   := Theme[DS_TEXTALPHAVALUE].IntValue;
    chkFontTrans.Checked := Theme[DS_TEXTALPHA].BoolValue;
    chkBold.Checked      := Theme[DS_TEXTBOLD].BoolValue;
    chkItalic.Checked    := Theme[DS_TEXTITALIC].BoolValue;
    chkUnderline.Checked := Theme[DS_TEXTUNDERLINE].BoolValue;
    sceFontColor.Items.Item[0].ColorCode := Theme[DS_TEXTCOLOR].IntValue;

    // load if settings are changed
    UICColorBlend.HasChanged      := Theme[DS_ICONBLENDING].isCustom;
    UICIconTrans.HasChanged       := Theme[DS_ICONALPHABLEND].isCustom;
    UICIconShadow.HasChanged      := Theme[DS_ICONSHADOW].isCustom;
    UICSize.HasChanged            := Theme[DS_ICONSIZE].isCustom;
    UICColorBlendValue.HasChanged := Theme[DS_ICONBLENDALPHA].isCustom;
    UICIconTransValue.HasChanged  := Theme[DS_ICONALPHA].isCustom;
    UICIconShadowValue.HasChanged := Theme[DS_ICONSHADOWALPHA].isCustom;
    UICColorBlendColor.HasChanged := Theme[DS_ICONBLENDCOLOR].isCustom;
    UICIconShadowColor.HasChanged := Theme[DS_ICONSHADOWCOLOR].isCustom;

    UICFontName.HasChanged       := Theme[DS_FONTNAME].isCustom;
    UICFontSize.HasChanged       := Theme[DS_TEXTSIZE].isCustom;
    UICFontTrans.HasChanged      := Theme[DS_TEXTALPHA].isCustom;
    UICFontTransValue.HasChanged := Theme[DS_TEXTALPHAVALUE].isCustom;
    UICBold.HasChanged           := Theme[DS_TEXTBOLD].isCustom;
    UICItalic.HasChanged         := Theme[DS_TEXTITALIC].isCustom;
    UICUnderline.HasChanged      := Theme[DS_TEXTUNDERLINE].isCustom;
    UICFontColor.HasChanged      := Theme[DS_TEXTCOLOR].isCustom;
  end;

  Settings.Free;

  frmLink.UpdateIconPage;
  frmLink.Show;
  result := frmLink.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmLink.Close;
    frmLink.Free;
    frmLink := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Link');
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
  if frmLink <> nil then
  begin
    AssingUICColors(frmLink);
    frmLink.spc.TabColor := $00F7F7F7;
    frmLink.spc.BorderColor := $00FBEFE3;
  end;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Link',frmLink.pagLink,'','');
  ATabs.Add('Icon',frmLink.pagIcon,'','');
  ATabs.Add('Font',frmLink.pagFont,'','');
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

