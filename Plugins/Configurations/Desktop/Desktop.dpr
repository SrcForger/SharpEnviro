{
Source Name: Desktop Configs
Description: SharpE Desktop Global configs
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

library Desktop;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  JvPageList,
  Graphics,
  uSharpEDesktopSettingsWnd in 'uSharpEDesktopSettingsWnd.pas' {frmDesktopSettings},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  SharpEFontSelectorFontList in '..\..\..\Common\Delphi Components\SharpEFontSelector\SharpEFontSelectorFontList.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML: TJvSimpleXML;
  Dir: string;
  i: integer;
begin
  if frmDesktopSettings = nil then
    frmDesktopSettings := TfrmDesktopSettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmDesktopSettings);
  frmDesktopSettings.sTheme := APluginID;
  frmDesktopSettings.ParentWindow := aowner;
  frmDesktopSettings.Left := 2;
  frmDesktopSettings.Top := 2;
  frmDesktopSettings.BorderStyle := bsNone;
  frmDesktopSettings.sFontName := 'Verdana';

  Dir := SharpApi.GetSharpeUserSettingsPath + '\Themes\' + APluginID + '\';
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(Dir + 'DesktopIcon.xml');
    with XML.Root.Items do
    begin
      // Icon Tab
      i := IntValue('IconSize', 32);
      case i of
        32: frmDesktopSettings.rbicon32.Checked := True;
        48: frmDesktopSettings.rbicon48.Checked := True;
        64: frmDesktopSettings.rbicon64.Checked := True;
      else
        frmDesktopSettings.rbiconcustom.Checked := True;
      end;
      frmDesktopSettings.sgbiconsize.Value := i;
      frmDesktopSettings.cbalphablend.Checked := BoolValue('IconAlphaBlend',
        False);
      frmDesktopSettings.sgbiconalpha.value := IntValue('IconAlpha', 255);
      frmDesktopSettings.cbcolorblend.Checked := BoolValue('IconBlending',
        False);
      frmDesktopSettings.sbgiconcblendalpha.Value := IntValue('IconBlendAlpha',
        255);
      frmDesktopSettings.cbiconshadow.Checked := BoolValue('IconShadow', True);
      frmDesktopSettings.sgbiconshadow.Value := IntValue('IconShadowAlpha',
        196);
      frmDesktopSettings.IconColors.Items.Item[0].ColorCode :=
        IntValue('IconBlendColor', 0);
      frmDesktopSettings.IconColors.Items.Item[1].ColorCode :=
        IntValue('IconShadowColor', 0);

      // Text Tab
      frmDesktopSettings.sFontName := Value('FontName', 'Verdana');
      frmDesktopSettings.sefontsize.Value := IntValue('TextSize', 12);
      frmDesktopSettings.cbbold.Checked := BoolValue('TextBold', False);
      frmDesktopSettings.cbitalic.Checked := BoolValue('TextItalic', False);
      frmDesktopSettings.cbunderline.Checked := BoolValue('TextUnderline',
        False);
      frmDesktopSettings.cbfontalphablend.Checked := BoolValue('TextAlpha',
        False);
      frmDesktopSettings.sgbfontalphablend.Value := IntValue('TextAlphaValue',
        255);
      frmDesktopSettings.cbtextshadow.Checked := BoolValue('TextShadow', True);
      frmDesktopSettings.sgbtextshadow.Value := IntValue('TextShadowAlpha',
        196);
      frmDesktopSettings.TextColors.Items.Item[0].ColorCode :=
        IntValue('TextColor', clWhite);
      frmDesktopSettings.TextColors.Items.Item[1].ColorCode :=
        IntValue('TextShadowColor', 0);
    end;
  except
  end;
  XML.Root.Clear;
  try
    XML.LoadFromFile(Dir + 'DesktopAnimation.xml');
    with XML.Root.Items do
    begin
      frmDesktopSettings.cbanim.Checked := BoolValue('UseAnimations', True);
      frmDesktopSettings.cbanimscale.Checked := BoolValue('Scale', False);
      frmDesktopSettings.sgbanimscale.Value := IntValue('ScaleValue', 0);
      frmDesktopSettings.cbanimalpha.Checked := BoolValue('Alpha', True);
      frmDesktopSettings.sgbanimalpha.Value := IntValue('AlphaValue', 64);
      frmDesktopSettings.cbanimcolorblend.Checked := BoolValue('Blend', False);
      frmDesktopSettings.sgbanimcolorblend.Value := IntValue('BlendValue',
        255);
      frmDesktopSettings.cbanimbrightness.Checked := BoolValue('Brightness',
        True);
      frmDesktopSettings.sgbanimbrightness.Value := IntValue('BrightnessValue',
        64);
      frmDesktopSettings.AnimColors.Items.Item[0].ColorCode :=
        IntValue('BlendColor', clWhite);
    end;
  except
  end;

  XML.Free;

  frmDesktopSettings.Show;
  result := frmDesktopSettings.Handle;
end;

procedure Save;
var
  XML: TJvSimpleXML;
  i: integer;
  Dir, FileName: string;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + '\Themes\' +
    frmDesktopSettings.sTheme + '\';
  FileName := Dir + 'DesktopIcon.xml';

  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'SharpEThemeDesktopIcon';
  XML.Root.Items.Clear;

  with XML.Root.Items do
  begin
    if frmDesktopSettings.rbicon32.Checked then
      i := 32
    else if frmDesktopSettings.rbicon48.Checked then
      i := 48
    else if frmDesktopSettings.rbicon64.Checked then
      i := 64
    else
      i := frmDesktopSettings.sgbiconsize.Value;
    Add('IconSize', i);
    Add('IconAlphaBlend', frmDesktopSettings.cbalphablend.Checked);
    Add('IconAlpha', frmDesktopSettings.sgbiconalpha.Value);
    Add('IconBlending', frmDesktopSettings.cbcolorblend.Checked);
    Add('IconBlendAlpha', frmDesktopSettings.sbgiconcblendalpha.Value);
    Add('IconShadow', frmDesktopSettings.cbiconshadow.Checked);
    Add('IconShadowAlpha', frmDesktopSettings.sgbiconshadow.Value);
    Add('IconBlendColor',
      frmDesktopSettings.IconColors.Items.Item[0].ColorCode);
    Add('IconShadowColor',
      frmDesktopSettings.IconColors.Items.Item[1].ColorCode);
    Add('FontName', frmDesktopSettings.cbxFontName.Text);
    Add('TextSize', round(frmDesktopSettings.sefontsize.Value));
    Add('TextBold', frmDesktopSettings.cbbold.Checked);
    Add('TextItalic', frmDesktopSettings.cbitalic.Checked);
    Add('TextUnderline', frmDesktopSettings.cbunderline.Checked);
    Add('TextAlpha', frmDesktopSettings.cbfontalphablend.Checked);
    Add('TextAlphaValue', frmDesktopSettings.sgbfontalphablend.Value);
    Add('TextShadow', frmDesktopSettings.cbtextshadow.Checked);
    Add('TextShadowAlpha', frmDesktopSettings.sgbtextshadow.Value);
    Add('TextColor', frmDesktopSettings.TextColors.Items.Item[0].ColorCode);
    Add('TextShadowColor',
      frmDesktopSettings.TextColors.Items.Item[1].ColorCode);
  end;

  XML.SaveToFile(FileName + '~');
  if FileExists(FileName) then
    DeleteFile(FileName);
  RenameFile(FileName + '~', FileName);

  FileName := Dir + 'DesktopAnimation.xml';
  XML.Root.Name := 'SharpEThemeDesktopAnimation';
  XML.Root.Items.Clear;

  with XML.Root.Items do
  begin
    Add('UseAnimations', frmDesktopSettings.cbanim.Checked);
    Add('Scale', frmDesktopSettings.cbanimscale.Checked);
    Add('ScaleValue', frmDesktopSettings.sgbanimscale.Value);
    Add('Alpha', frmDesktopSettings.cbanimalpha.Checked);
    Add('AlphaValue', frmDesktopSettings.sgbanimalpha.Value);
    Add('Blend', frmDesktopSettings.cbanimcolorblend.Checked);
    Add('BlendValue', frmDesktopSettings.sgbanimcolorblend.Value);
    Add('Brightness', frmDesktopSettings.cbanimbrightness.Checked);
    Add('BrightnessValue', frmDesktopSettings.sgbanimbrightness.Value);
    Add('BlendColor', frmDesktopSettings.AnimColors.Items.Item[0].ColorCode);
  end;

  XML.SaveToFile(FileName + '~');
  if FileExists(FileName) then
    DeleteFile(FileName);
  RenameFile(FileName + '~', FileName);

  XML.Free;
end;

function Close : boolean;
begin
  try
    frmDesktopSettings.Close;
    frmDesktopSettings.Free;
    frmDesktopSettings := nil;
    result := True;
  except
    result := False;
  end;
end;

procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Desktop');
end;

procedure SetStatusText(var AStatusText: PChar);
begin
  AStatusText := '';
end;

procedure ClickBtn(AButtonID: Integer; AButton: TPngSpeedButton; AText: string);
begin
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure ClickTab(ATab: TPluginTabItem);
begin
  TJvStandardPage(ATab.Data).Show;
end;

procedure GetCenterScheme(var ABackground: TColor;
  var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
end;

procedure AddTabs(var ATabs: TPluginTabItemList);
begin
  if frmDesktopSettings <> nil then
  begin
    ATabs.Add('Icon', frmDesktopSettings.JvIconPage, '', '');
    ATabs.Add('Text', frmDesktopSettings.JvTextPage, '', '');
    ATabs.Add('Animations', frmDesktopSettings.JvAnimationPage, '', '');
  end;
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  result := suDesktopIcon;
end;

exports
  Open,
  Close,
  Save,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  SetSettingType,
  GetCenterScheme,
  AddTabs,
  ClickTab,
  ClickBtn;

End.
