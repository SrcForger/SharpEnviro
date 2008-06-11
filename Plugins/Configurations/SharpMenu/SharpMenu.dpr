{
Source Name: SharpDesk Configs
Description: SharpDesk Config Dll
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

library SharpMenu;
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
  Math,
  uSharpMenuSettingsWnd in 'uSharpMenuSettingsWnd.pas' {frmMenuSettings},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpDeskTDeskSettings in '..\..\..\Components\SharpDesk\Units\uSharpDeskTDeskSettings.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}


function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  Dir : String;
  FName : String;
  i : integer;
begin
  if frmMenuSettings = nil then frmMenuSettings := TfrmMenuSettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmMenuSettings);
  frmMenuSettings.ParentWindow := aowner;
  frmMenuSettings.Left := 2;
  frmMenuSettings.Top := 2;
  frmMenuSettings.BorderStyle := bsNone;
  frmMenuSettings.Updating := True;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Settings\';
  FName := Dir + 'SharpMenu.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(FName) then
    begin
      XML.LoadFromFile(FName);
      if XML.Root.Items.ItemNamed['Settings'] <> nil then
         with XML.Root.Items.ItemNamed['Settings'].Items do
         begin
           frmMenuSettings.cb_wrap.Checked := BoolValue('WrapMenu',True);
           frmMenuSettings.sgb_wrapcount.Value := IntValue('WrapCount',25);
           i := Max(0,Min(1,IntValue('WrapPosition',0)));
           frmMenuSettings.cobo_wrappos.ItemIndex := i;
           frmMenuSettings.cb_cacheicons.Checked := BoolValue('CacheIcons',True);
           frmMenuSettings.cb_useicons.Checked := BoolValue('UseIcons',True);
           frmMenuSettings.cb_usegenicons.Checked := BoolValue('UseGenericIcons',False);
         end;
    end;
  finally
    XML.Free;
  end;

  frmMenuSettings.Show;
  frmMenuSettings.Updating := False;
  result := frmMenuSettings.Handle;
end;

procedure Save;
var
  XML : TJvSimpleXML;
  Dir : String;
  FName : String;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Settings\';
  if not DirectoryExists(Dir) then
     ForceDirectories(Dir);
  FName := Dir + 'SharpMenu.xml';

  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'SharpEMenuSettings';
  with XML.Root.Items.Add('Settings').Items do
  begin
   Add('WrapMenu',frmMenuSettings.cb_wrap.Checked);
   AdD('WrapCount',frmMenuSettings.sgb_wrapcount.Value);
   Add('WrapPosition',frmMenuSettings.cobo_wrappos.ItemIndex);
   Add('CacheIcons',frmMenuSettings.cb_cacheicons.Checked);
   Add('UseIcons',frmMenuSettings.cb_useicons.Checked);
   Add('UseGenericIcons',frmMenuSettings.cb_usegenicons.Checked);
  end;
  XML.SaveToFile(FName + '~');
  if FileExists(FName) then
     DeleteFile(FName);
  RenameFile(FName + '~',
             FName);
  XML.Free;
end;

function Close : boolean;
begin
  result := True;
  try
    frmMenuSettings.Close;
    frmMenuSettings.Free;
    frmMenuSettings := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Menu';
  ATitle := 'Menu Configuration';
  ADescription := 'Define advanced menu options, such as caching and wrapping.';

end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Menu';
    Description := 'Menu Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suSharpMenu)]);
  end;
end;


exports
  Open,
  Close,
  Save,
  SetText,
  GetMetaData;

begin
end.

