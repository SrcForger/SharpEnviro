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

    // save the actual values (will only be saved to XMl if isCustom = True)
    // Theme[DS_ICONALPHABLEND].BoolValue := cbalphablend.Checked;
  end;
  Settings.SaveSettings(True);

  Settings.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  Settings : TLinkXMLSettings;
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
    // UIC_Colors.DefaultValue := inttostr(GetDesktopIconBlendColor);

    // load the actual values
    // cbalphablend.Checked               := Theme[DS_ICONALPHABLEND].BoolValue;

    // load if settings are changed
    // UIC_AlphaBlend.HasChanged := Theme[DS_ICONALPHABLEND].isCustom;
  end;

  Settings.Free;

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

