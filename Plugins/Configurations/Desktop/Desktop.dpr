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
  SharpEFontSelectorFontList in '..\..\..\Common\Delphi Components\SharpEFontSelector\SharpEFontSelectorFontList.pas';

{$E .dll}

{$R *.res}


function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  Dir : String;
  i : integer;
begin
  if frmDesktopSettings = nil then frmDesktopSettings := TfrmDesktopSettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmDesktopSettings);
  frmDesktopSettings.sTheme := APluginID;
  frmDesktopSettings.ParentWindow := aowner;
  frmDesktopSettings.Left := 2;
  frmDesktopSettings.Top := 2;
  frmDesktopSettings.BorderStyle := bsNone;
  frmDesktopSettings.sFontName := 'Verdana';

  Dir := SharpApi.GetSharpeUserSettingsPath + '\Themes\'+APluginID+'\';
  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(Dir + 'DesktopIcon.xml');
    with XML.Root.Items do
    begin
      // Icon Tab
      i := IntValue('IconSize',32);
      case i of
        32: frmDesktopSettings.rb_icon32.Checked := True;
        48: frmDesktopSettings.rb_icon48.Checked := True;
        64: frmDesktopSettings.rb_icon64.Checked := True;
        else frmDesktopSettings.rb_iconcustom.Checked := True;
      end;
      frmDesktopSettings.tb_iconsize.Position    := i;
      frmDesktopSettings.cb_alphablend.Checked   := BoolValue('IconAlphaBlend',False);
      frmDesktopSettings.tb_iconalpha.Position   := IntValue('IconAlpha',255);
      frmDesktopSettings.cb_colorblend.Checked   := BoolValue('IconBlending',False);
      frmDesktopSettings.tb_cblendalpha.Position := IntValue(' IconBlendAlpha',255);
      frmDesktopSettings.cb_iconshadow.Checked   := BoolValue('IconShadow',True);
      frmDesktopSettings.tb_iconshadow.Position  := IntValue('IconShadowAlpha',196);
      frmDesktopSettings.IconColors.Items.Item[0].ColorCode := IntValue('IconBlendColor',0);
      frmDesktopSettings.IconColors.Items.Item[1].ColorCode := IntValue('IconShadowColor',0);

      // Text Tab
      frmDesktopSettings.sFontName               := Value('FontName','Verdana');
      frmDesktopSettings.se_fontsize.Value       := IntValue('TextSize',12);
      frmDesktopSettings.cb_bold.Checked         := BoolValue('TextBold',False);
      frmDesktopSettings.cb_italic.Checked       := BoolValue('TextItalic',False);
      frmDesktopSettings.cb_underline.Checked    := BoolValue('TextUnderline',False);
      frmDesktopSettings.cb_fontalphablend.Checked := BoolValue('TextAlpha',False);
      frmDesktopSettings.tb_fontalpha.Position   := IntValue('TextAlphaValue',255);
      frmDesktopSettings.cb_textshadow.Checked   := BoolValue('TextShadow',True);
      frmDesktopSettings.tb_textshadow.Position  := IntValue('TextShadowAlpha',196);
      frmDesktopSettings.TextColors.Items.Item[0].ColorCode := IntValue('TextColor',clWhite);
      frmDesktopSettings.TextColors.Items.Item[1].ColorCode := IntValue('TextShadowColor',0);
    end;
  except
  end;
  XML.Free;

  frmDesktopSettings.Show;
  result := frmDesktopSettings.Handle;
end;

function Close(ASave: Boolean): boolean;
var
  XML : TJvSimpleXML;
  i : integer;
  Dir,FileName : String;
begin
  result := True;
  try
    if ASave then
    begin
      Dir := SharpApi.GetSharpeUserSettingsPath + '\Themes\'+frmDesktopSettings.sTheme+'\';
      FileName := Dir + 'DesktopIcon.xml';

      XML := TJvSimpleXML.Create(nil);
      XML.Root.Name := 'SharpEThemeDesktopIcon';
      XML.Root.Items.Clear;

      with XML.Root.Items do
      begin
        if frmDesktopSettings.rb_icon32.Checked then i := 32
           else if frmDesktopSettings.rb_icon48.Checked then i := 48
           else if frmDesktopSettings.rb_icon64.Checked then i := 64
           else i := frmDesktopSettings.tb_iconsize.Position;
        Add('IconSize',i);
        Add('IconAlphaBlend',frmDesktopSettings.cb_alphablend.Checked);
        Add('IconAlpha',frmDesktopSettings.tb_iconalpha.Position);
        Add('IconBlending',frmDesktopSettings.cb_colorblend.Checked);
        Add('IconBlendAlpha',frmDesktopSettings.tb_cblendalpha.Position);
        Add('IconShadow',frmDesktopSettings.cb_iconshadow.Checked);
        Add('IconShadowAlpha',frmDesktopSettings.tb_iconshadow.Position);
        Add('IconBlendColor',frmDesktopSettings.IconColors.Items.Item[0].ColorCode);
        Add('IconShadowColor',frmDesktopSettings.IconColors.Items.Item[1].ColorCode);
        Add('FontName',frmDesktopSettings.cbxFontName.Text);
        Add('TextSize',round(frmDesktopSettings.se_fontsize.Value));
        Add('TextBold',frmDesktopSettings.cb_bold.Checked);
        Add('TextItalic',frmDesktopSettings.cb_italic.Checked);
        Add('TextUnderline',frmDesktopSettings.cb_underline.Checked);
        Add('TextAlpha',frmDesktopSettings.cb_fontalphablend.Checked);
        Add('TextAlphaValue',frmDesktopSettings.tb_fontalpha.Position);
        Add('TextShadow',frmDesktopSettings.cb_textshadow.Checked);
        Add('TextShadowAlpha',frmDesktopSettings.tb_textshadow.Position);
        Add('TextColor',frmDesktopSettings.TextColors.Items.Item[0].ColorCode);
        Add('TextShadowColor',frmDesktopSettings.TextColors.Items.Item[1].ColorCode);
      end;

      XML.SaveToFile(FileName+'~');
      if FileExists(FileName) then
         DeleteFile(FileName);
      RenameFile(FileName+'~',FileName);
      XML.Free;
    end;

    frmDesktopSettings.Close;
    frmDesktopSettings.Free;
    frmDesktopSettings := nil;
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

procedure ClickBtn(AButtonID: Integer; AButton:TPngSpeedButton; AText:String);
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

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  if frmDesktopSettings <> nil then
  begin
    ATabs.Add('Icon',frmDesktopSettings.JvIconPage,'','');
    ATabs.Add('Text',frmDesktopSettings.JvTextPage,'','');
    ATabs.Add('Animations',frmDesktopSettings.JvAnimationPage,'','');
  end;
end;

function SetSettingType : integer;
begin
  result := SU_DESKTOPICON;
end;


exports
  Open,
  Close,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  SetSettingType,
  GetCenterScheme,
  AddTabs,
  ClickTab,
  ClickBtn;

end.

