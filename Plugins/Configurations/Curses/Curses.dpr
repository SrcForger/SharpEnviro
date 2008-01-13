{
Source Name: Curses
Description: Curses Service Config Dll
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

library Curses;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  GR32_Image,
  GR32,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uCursesListWnd in 'uCursesListWnd.pas' {frmCursesList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}      

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  n : integer;
begin
  if frmCursesList = nil then frmCursesList := TfrmCursesList.Create(nil);

  uVistaFuncs.SetVistaFonts(frmCursesList);
  frmCursesList.sTheme := APluginID;
  frmCursesList.ParentWindow := aowner;
  frmCursesList.Left := 2;
  frmCursesList.Top := 2;
  frmCursesList.BorderStyle := bsNone;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(SharpApi.GetSharpeUserSettingsPath + '\Themes\'+APluginID+'\Cursor.xml');
    frmCursesList.sCurrentCursor := XML.Root.Items.Value('CurrentSkin','');
    for n := 0 to frmCursesList.ccolors.Items.Count - 1 do
        frmCursesList.ccolors.Items.Item[n].ColorCode := XML.Root.Items.IntValue('Color' + inttostr(n),0);
  except
  end;
  XML.Free;

  frmCursesList.Show;
  result := frmCursesList.Handle;
end;

function Close : boolean;

begin
  result := True;
  try
    frmCursesList.Close;
    frmCursesList.Free;
    frmCursesList := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  xml: TJvSimpleXML;
  sDir: String;
  sr: TSearchRec;
  n:Integer;
begin
  AName := 'Cursors';
  ATitle := Format('Cursor Configuration for "%s"',[APluginID]);
  ADescription := 'Select which cursor you want to use for this theme.';

  xml := TJvSimpleXML.Create(nil);
  sDir := SharpApi.GetSharpeDirectory + 'Cursors\';
  n := 0;
  try
  
  if FindFirst(sDir + '*',FADirectory,sr) = 0 then
  repeat
    if (CompareText(sr.Name,'.') <> 0) and (CompareText(sr.Name,'..') <> 0) then
    begin
      if FileExists(sDir + sr.Name + '\Skin.xml') then
        inc(n);
    end;
  until FindNext(sr) <> 0;
  finally
    FindClose(sr);
    xml.Free;

    AStatus := IntToStr(n);
  end;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  if frmCursesList <> nil then
  begin
    frmCursesList.lbcursorlist.Colors.ItemColor := AItemColor;
    frmCursesList.lbcursorlist.Colors.ItemColorSelected := AItemSelectedColor;
    frmCursesList.lbcursorlist.Colors.BorderColor := AItemSelectedColor;
    frmCursesList.lbcursorlist.Colors.BorderColorSelected := AItemSelectedColor;
    if frmCursesList.lbCursorList.Count = 0 then
       frmCursesList.BuildCursorList;
  end;
end;

procedure UpdatePreview(var ABmp: TBitmap32);
begin
  if (frmCursesList.lbCursorList.ItemIndex < 0) or
     (frmCursesList.lbCursorList.Count = 0) then
     exit;

  ABmp.SetSize(frmCursesList.Preview.Width,frmCursesList.Preview.Height);
  ABmp.Clear(color32(0,0,0,0));
  frmCursesList.Preview.DrawTo(ABmp);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Cursors';
    Description := 'Cursor Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suCursor)]);
  end;
end;

exports
  Open,
  Close,
  SetText,
  GetCenterScheme,
  UpdatePreview;

end.

