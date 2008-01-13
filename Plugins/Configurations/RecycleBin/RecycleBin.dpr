{
Source Name: RecycleBin
Description: RecycleBin Object Config Dll
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

library RecycleBin;
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
  uRecycleBinWnd in 'uRecycleBinWnd.pas' {frmRecycleBin},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
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
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpDialogs in '..\..\..\Common\Libraries\SharpDialogs\SharpDialogs.pas',
  RecycleBinObjectXMLSettings in '..\..\Objects\RecycleBin\RecycleBinObjectXMLSettings.pas',
  uSharpDeskObjectSettings in '..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas';

{$E .dll}

{$R *.res}

procedure Save;
var
  Settings : TRecycleXMLSettings;
begin
  if frmRecycleBin = nil then
    exit;

  with frmRecycleBin, Settings do
  begin
    Settings := TRecycleXMLSettings.Create(strtoint(sObjectID),nil,'RecycleBin');
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
    Settings.Icon := IconEmpty.Text;
    Settings.Icon2 := IconFull.Text;
    Settings.ShowData := cbBinStatus.Checked;

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

    Theme[DS_TEXTSHADOW].isCustom      := UICFontShadow.HasChanged;
    Theme[DS_TEXTSHADOWALPHA].isCustom := UICFontShadowTrans.HasChanged;
    Theme[DS_TEXTSHADOWTYPE].isCustom  := UICFontShadowType.HasChanged;
    Theme[DS_TEXTSHADOWCOLOR].isCustom := UICFontShadowColor.HasChanged;

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

    Theme[DS_TEXTSHADOW].BoolValue     := chkFontShadow.Checked;
    Theme[DS_TEXTSHADOWALPHA].IntValue := sgbFontShadowTrans.Value;
    Theme[DS_TEXTSHADOWTYPE].IntValue  := cboFontShadowType.ItemIndex;
    Theme[DS_TEXTSHADOWCOLOR].IntValue := sceShadowColor.Items.Item[0].ColorCode;
  end;
  Settings.SaveSettings(True);

  Settings.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  Settings : TRecycleXMLSettings;
  s : String;
  n : integer;
begin
  if frmRecycleBin = nil then frmRecycleBin := TfrmRecycleBin.Create(nil);

  uVistaFuncs.SetVistaFonts(frmRecycleBin);
  frmRecycleBin.sObjectID := APluginID;
  frmRecycleBin.ParentWindow := aowner;
  frmRecycleBin.Left := 2;
  frmRecycleBin.Top := 2;
  frmRecycleBin.BorderStyle := bsNone;
  SharpThemeapi.LoadTheme(False,[tpDesktopIcon,tpIconSet]);

  Settings := TRecycleXMLSettings.Create(strtoint(APluginID),nil,'RecycleBin');
  Settings.LoadSettings;

  with frmRecycleBin, Settings do
  begin
    // load normal settings
    cb_calign.ItemIndex := CaptionAlign;
    if MLineCaption then
      spc.TabIndex := 1
      else spc.TabIndex := 0;
    cb_caption.Checked := ShowCaption;
    IconEmpty.Text := Icon;
    IconFull.Text := Icon2;
    cbBinStatus.Checked := ShowData;
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

    UICFontName.DefaultValue := inttostr(cboFontName.Items.IndexOf(GetDesktopFontName));
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

    if GetDesktopTextShadow then
      UICFontShadow.DefaultValue := 'True'
    else UICFontShadow.DefaultValue := 'False';
    UICFontShadowTrans.DefaultValue := inttostr(GetDesktopTextShadowAlpha);
    UICFontShadowColor.DefaultValue := inttostr(GetDesktopTextShadowColor);
    UICFontShadowType.DefaultValue := inttostr(GetDesktopTextShadowType);

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
    for n  := 0 to cboFontName.Items.Count - 1 do
    if CompareText(cboFontName.Items[n],s) = 0 then
    begin
      cboFontName.ItemIndex := n;
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

    chkFontShadow.Checked := Theme[DS_TEXTSHADOW].BoolValue;
    sgbFontShadowTrans.Value := Theme[DS_TEXTSHADOWALPHA].IntValue;
    cboFontShadowType.ItemIndex := Theme[DS_TEXTSHADOWTYPE].IntValue;
    sceShadowColor.Items.Item[0].ColorCode := Theme[DS_TEXTSHADOWCOLOR].IntValue;

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

    UICFontShadow.HasChanged      := Theme[DS_TEXTSHADOW].isCustom;
    UICFontShadowTrans.HasChanged := Theme[DS_TEXTSHADOWALPHA].isCustom;
    UICFontShadowType.HasChanged  := Theme[DS_TEXTSHADOWTYPE].isCustom;
    UICFontShadowColor.HasChanged := Theme[DS_TEXTSHADOWCOLOR].isCustom;
  end;

  Settings.Free;

  frmRecycleBin.UpdateIconPage;
  frmRecycleBin.Show;
  result := frmRecycleBin.Handle;
end;

function Close : boolean;
begin
  result := True;
  try
    frmRecycleBin.Close;
    frmRecycleBin.Free;
    frmRecycleBin := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Recycle Bin';
  ATitle := 'Recycle Bin Object';
  ADescription := 'Configure recycle bin object';
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
  if frmRecycleBin <> nil then
  begin
    AssingUICColors(frmRecycleBin);
    frmRecycleBin.spc.TabColor := $00F7F7F7;
    frmRecycleBin.spc.BorderColor := $00FBEFE3;
  end;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('RecycleBin',frmRecycleBin.pagRecycleBin,'','');
  ATabs.Add('Icon',frmRecycleBin.pagIcon,'','');
  ATabs.Add('Font',frmRecycleBin.pagFont,'','');
  ATabs.Add('Font Shadow',frmRecycleBin.pagFontShadow,'','');
end;

procedure ClickTab(ATab: TPluginTabItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.Data <> nil then begin
    tmpPag := TJvStandardPage(ATab.Data);
    tmpPag.Show;
  end;
  frmRecycleBin.UpdatePageUI;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Recycle Bin';
    Description := 'Recycle Bin Object Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suDesktopObject)]);
  end;
end;



exports
  Open,
  Close,
  Save,
  ClickTab,
  SetText,
  SetBtnState,
  GetCenterScheme,
  AddTabs;

end.

