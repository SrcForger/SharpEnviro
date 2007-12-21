{
Source Name: Desktop Configs
Description: SharpE Desktop Global configs
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

library Desktop;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
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
  xml: TJvSimpleXML;
  sDir: string;
  iIconSize: Integer;
begin
  if frmDesktopSettings = nil then
    frmDesktopSettings := TfrmDesktopSettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmDesktopSettings);

  with frmDesktopSettings do begin
    FTheme := APluginID;
    FFontName := 'Arial';

    ParentWindow := AOwner;
    Left := 0;
    Top := 0;

    sDir := SharpApi.GetSharpeUserSettingsPath + '\Themes\' + APluginID + '\';
    xml := TJvSimpleXML.Create(nil);
    try
      try
        xml.LoadFromFile(sDir + 'DesktopIcon.xml');
        with XML.Root.Items do
        begin

          // Icon tab options
          {$REGION 'Load Icon Tab Options'}
          iIconSize := IntValue('IconSize', 32);
          case iIconSize of
            32: rdoIcon32.Checked := True;
            48: rdoIcon48.Checked := True;
            64: rdoIcon64.Checked := True;
          else
            rdoIconcustom.Checked := True;
          end;

          sgbiconsize.Value := iIconSize;
          chkIconTrans.Checked := BoolValue('IconAlphaBlend', False);
          sgbIconTrans.value := IntValue('IconAlpha', 255);
          chkColorBlend.Checked := BoolValue('IconBlending', False);
          sgbColorBlend.Value := IntValue('IconBlendAlpha', 255);
          chkIconShadow.Checked := BoolValue('IconShadow', True);
          sgbIconShadow.Value := IntValue('IconShadowAlpha', 196);
          sceIconColor.Items.Item[0].ColorCode := IntValue('IconBlendColor', 0);
          sceShadowColor.Items.Item[0].ColorCode := IntValue('IconShadowColor', 0);

          {$ENDREGION}

          // Text + shadow tab
          {$REGION 'Load Font Tab Options'}
          FFontName := Value('FontName', 'Verdana');
          sgbFontSize.Value := IntValue('TextSize', 12);
          chkBold.Checked := BoolValue('TextBold', False);
          chkItalic.Checked := BoolValue('TextItalic', False);
          chkUnderline.Checked := BoolValue('TextUnderline', False);
          chkFontTrans.Checked := BoolValue('TextAlpha', False);
          sgbFontTrans.Value := IntValue('TextAlphaValue', 255);
          chkFontShadow.Checked := BoolValue('TextShadow', True);
          sgbFontShadowTrans.Value := IntValue('TextShadowAlpha', 196);
          sceFontColor.Items.Item[0].ColorCode := IntValue('TextColor', clWhite);
          sceShadowColor.Items.Item[0].ColorCode := IntValue('TextShadowColor', 0);
          cboFontShadowType.ItemIndex := Max(0,Min(3,IntValue('TextShadowType',0)));
          {$ENDREGION} end;

      except
      end;

      XML.Root.Clear;
      try
        XML.LoadFromFile(sDir + 'DesktopAnimation.xml');
        with XML.Root.Items, frmDesktopSettings do
        begin

          // Animation tab
          {$REGION 'Load Animation Tab Options'}
          chkAnim.Checked := BoolValue('UseAnimations', True);
          chkAnimSize.Checked := BoolValue('Scale', False);
          sgbAnimSize.Value := IntValue('ScaleValue', 0);
          chkAnimTrans.Checked := BoolValue('Alpha', True);
          sgbAnimTrans.Value := IntValue('AlphaValue', 64);
          chkAnimColorBlend.Checked := BoolValue('Blend', False);
          sgbAnimColorBlend.Value := IntValue('BlendValue', 255);
          chkAnimBrightness.Checked := BoolValue('Brightness', True);
          sgbAnimBrightness.Value := IntValue('BrightnessValue', 64);
          sceAnimColor.Items.Item[0].ColorCode := IntValue('BlendColor', clWhite);

          {$ENDREGION}

        end;

      except
      end;

    finally
      XML.Free;
    end;

  end;
  frmDesktopSettings.Show;
  result := frmDesktopSettings.Handle;
end;

procedure Save;
var
  XML: TJvSimpleXML;
  iIconSize: integer;
  sDir, sFileName: string;
begin
  // Init
  sDir := SharpApi.GetSharpeUserSettingsPath + '\Themes\' +
    frmDesktopSettings.FTheme + '\';
  sFileName := sDir + 'DesktopIcon.xml';

  with frmDesktopSettings do begin

    xml := TJvSimpleXML.Create(nil);
    try
      XML.Root.Name := 'SharpEThemeDesktopIcon';
      XML.Root.Items.Clear;

      with XML.Root.Items do
      begin
        if rdoIcon32.Checked then
          iIconSize := 32
        else if rdoIcon48.Checked then
          iIconSize := 48
        else if rdoIcon64.Checked then
          iIconSize := 64
        else
          iIconSize := sgbIconSize.Value;

        Add('IconSize', iIconSize);
        Add('IconAlphaBlend', chkIconTrans.Checked);
        Add('IconAlpha', sgbIconTrans.Value);
        Add('IconBlending', chkColorBlend.Checked);
        Add('IconBlendAlpha', sgbColorBlend.Value);
        Add('IconShadow', chkIconShadow.Checked);
        Add('IconShadowAlpha', sgbIconShadow.Value);
        Add('IconBlendColor',
          sceIconColor.Items.Item[0].ColorCode);
        Add('IconShadowColor',
          sceShadowColor.Items.Item[0].ColorCode);
        Add('FontName', cboFontName.Text);
        Add('TextSize', sgbFontSize.Value);
        Add('TextBold', chkBold.Checked);
        Add('TextItalic', chkItalic.Checked);
        Add('TextUnderline', chkUnderline.Checked);
        Add('TextAlpha', chkFontTrans.Checked);
        Add('TextAlphaValue', sgbFontTrans.Value);
        Add('TextShadow', chkFontShadow.Checked);
        Add('TextShadowAlpha', sgbFontShadowTrans.Value);
        Add('TextShadowType', cboFontShadowType.ItemIndex);
        Add('TextColor', sceFontColor.Items.Item[0].ColorCode);
        Add('TextShadowColor',
          sceShadowColor.Items.Item[0].ColorCode);
      end;

      XML.SaveToFile(sFileName + '~');
      if FileExists(sFileName) then
        DeleteFile(sFileName);
      RenameFile(sFileName + '~', sFileName);

      sFileName := sDir + 'DesktopAnimation.xml';
      XML.Root.Name := 'SharpEThemeDesktopAnimation';
      XML.Root.Items.Clear;

      with XML.Root.Items do
      begin
        Add('UseAnimations', chkAnim.Checked);
        Add('Scale', chkAnimSize.Checked);
        Add('ScaleValue', sgbAnimSize.Value);
        Add('Alpha', chkAnimTrans.Checked);
        Add('AlphaValue', sgbAnimTrans.Value);
        Add('Blend', chkAnimColorBlend.Checked);
        Add('BlendValue', sgbAnimColorBlend.Value);
        Add('Brightness', chkAnimBrightness.Checked);
        Add('BrightnessValue', sgbAnimBrightness.Value);
        Add('BlendColor', sceAnimColor.Items.Item[0].ColorCode);
      end;

      XML.SaveToFile(sFileName + '~');
      if FileExists(sFileName) then
        DeleteFile(sFileName);
      RenameFile(sFileName + '~', sFileName);


    finally
      xml.Free;
    end;

  end;
end;

function Close: boolean;
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

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Desktop';
  ATitle := Format('Desktop Configuration for "%s"',[APluginID]);
  ADescription := 'Define what desktop options you want to use for this theme.';
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure ClickTab(ATab: TPluginTabItem);
begin
  TJvStandardPage(ATab.Data).Show;
  frmDesktopSettings.UpdatePageUi;
end;

procedure AddTabs(var ATabs: TPluginTabItemList);
begin
  if frmDesktopSettings <> nil then
  begin
    ATabs.Add('Icon', frmDesktopSettings.pagIcon, '', '');
    ATabs.Add('Font', frmDesktopSettings.pagFont, '', '');
    ATabs.Add('Font Shadow', frmDesktopSettings.pagFontShadow, '', '');
    ATabs.Add('Animation', frmDesktopSettings.pagAnimation, '', '');
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
  SetText,
  SetBtnState,
  SetSettingType,
  AddTabs,
  ClickTab;

end.

