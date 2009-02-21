{
Source Name: Notes
Description: Notes Module Config Dll
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

library Notes;
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
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uNotesWnd in 'uNotesWnd.pas' {frmNotes};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh; override; stdCall;

    function GetPluginDescriptionText: String; override; stdCall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlRoot.Name := 'NotesModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmNotes do
  begin
    // Don't clear the list because the Notes Module also
    // saves tab information to this file.

    if ItemNamed['Directory'] <> nil then
      ItemNamed['Directory'].Value := editDirectory.Text
    else
      Add('Directory', editDirectory.Text);

    if ItemNamed['CaptionText'] <> nil then
      ItemNamed['CaptionText'].Value := editCaptionText.Text
    else
      Add('CaptionText', editCaptionText.Text);

    if ItemNamed['AlwaysOnTop'] <> nil then
      ItemNamed['AlwaysOnTop'].BoolValue := cbAlwaysOnTop.Checked
    else
      Add('AlwaysOnTop', cbAlwaysOnTop.Checked);

    if ItemNamed['Caption'] <> nil then
      ItemNamed['Caption'].BoolValue := (rb_text.Checked or rb_icontext.Checked)
    else
      Add('Caption', (rb_text.Checked or rb_icontext.Checked));

    if ItemNamed['Icon'] <> nil then
      ItemNamed['Icon'].BoolValue := (rb_icon.Checked or rb_icontext.Checked)
    else
      Add('Icon', (rb_icon.Checked or rb_icontext.Checked));
  end;

  PluginHost.Xml.Save;

  BroadcastGlobalUpdateMessage(suModule, 0, True);
end;

procedure TSharpCenterPlugin.Load;
var
  ShowIcon, ShowCaption : boolean;
begin
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmNotes do
    begin
      editDirectory.Text := Value('Directory', SharpApi.GetSharpeUserSettingsPath + 'Notes');

      if editDirectory.Text = '' then
        editDirectory.Text := SharpApi.GetSharpeUserSettingsPath + 'Notes';

      editCaptionText.Text := Value('CaptionText', 'Notes');
      
      if editCaptionText.Text = '' then
        editCaptionText.Text := 'Notes';

      cbAlwaysOnTop.Checked := BoolValue('AlwaysOnTop', True);
      ShowIcon := BoolValue('Icon', True);
      ShowCaption := BoolValue('Caption', True);
      if ShowIcon and ShowCaption then
        rb_icontext.Checked := True
      else if ShowCaption then
        rb_text.Checked := True
      else rb_icon.Checked := True;
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmNotes = nil then frmNotes := TfrmNotes.Create(nil);
  frmNotes.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmNotes);

  Load;
  result := PluginHost.Open(frmNotes);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmNotes);
end;

function TSharpCenterPlugin.GetPluginDescriptionText : String;
begin
  result := 'Configure Notes module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Notes';
    Description := 'Notes Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;


procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmNotes);
end;

function InitPluginInterface( APluginHost: TInterfacedSharpCenterHostBase ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

