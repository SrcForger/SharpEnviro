{
Source Name: Scheme.dll
Description: Configuration dll for Scheme settings
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
library SchemeEdit;

uses
  windows,
  sysutils,
  sharpapi,
  classes,
  sharpcenterapi,
  sharpthemeapi,
  graphics,
  uVistaFuncs,
  forms,
  GR32,
  uSchemeEditWnd in 'uSchemeEditWnd.pas' {frmSchemeEdit},
  uSchemeList in '..\Scheme\uSchemeList.pas';

{$R *.RES}

function Open(const APluginID: PChar; AOwner: hwnd): HWnd;
var
  pluginId, themeId, schemeId: String;
begin
  {$REGION 'Form Initialisation'}
    frmSchemeEdit := TfrmSchemeEdit.Create(nil);
      SetVistaFonts(frmSchemeEdit);
    
      frmSchemeEdit.ParentWindow := AOwner;
      frmSchemeEdit.Left := 0;
      frmSchemeEdit.Top := 0;
      frmSchemeEdit.BorderStyle := bsNone;
      frmSchemeEdit.Show;
  {$ENDREGION}

  {$REGION 'Get theme and scheme'}
        pluginId := APluginID;
        themeId := copy(pluginId, 0, pos(':',pluginId)-1);
        schemeId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
    {$ENDREGION}

  // Get Scheme Colors
  frmSchemeEdit.Theme := themeId;
  frmSchemeEdit.Scheme := schemeId;
  XmlGetThemeScheme(themeId, schemeId, frmSchemeEdit.Colors);

  result := frmSchemeEdit.Handle;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  pluginId, themeId, schemeId: String;
begin
  {$REGION 'Get theme and scheme'}
        pluginId := APluginID;
        themeId := copy(pluginId, 0, pos(':',pluginId)-1);
        schemeId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
    {$ENDREGION}

  AName := 'Edit Scheme';
  ATitle := Format('Editing Scheme "%s"',[schemeId]);
  ADescription := 'Create a colour scheme for the selected skin.';
end;

procedure Close;
begin
  FreeAndNil(frmSchemeEdit);
end;

procedure UpdatePreview(var ABmp:TBitmap32);
begin
  if ( ( High(frmSchemeEdit.Colors)= 0) or (frmSchemeEdit = nil) ) then begin
    ABmp.SetSize(0,0);
    exit;
  end;

  ABmp.Clear(color32(0,0,0,0));
  frmSchemeEdit.CreatePreviewBitmap(ABmp);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Edit Scheme';
    Description := 'Configuration for editing a scheme';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suScheme)]);
  end;
end;

procedure Save;
begin
  XmlSetThemeScheme(frmSchemeEdit.Theme,frmSchemeEdit.Scheme,frmSchemeEdit.Colors);
end;

exports
  Open,
  Close,
  Save,
  SetText,
  UpdatePreview,
  GetMetaData;
end.

