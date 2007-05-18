{
Source Name: Curses
Description: Curses Service Config Dll
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
  uSEListboxPainter in '..\..\..\Common\Units\SEListboxPainter\uSEListboxPainter.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas';

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

function Close(ASave: Boolean): boolean;
var
  XML : TJvSimpleXML;
  FName : String;
  n : integer;
begin
  result := True;
  try
    if ASave then
    begin
      if frmCursesList.lb_cursorlist.ItemIndex >= 0 then
      begin
        FName := SharpApi.GetSharpeUserSettingsPath + '\Themes\'+frmCursesList.sTheme+'\Cursor.xml';

        XML := TJvSimpleXML.Create(nil);
        XML.Root.Name := 'SharpEThemeCursor';
        XML.Root.Items.Add('CurrentSkin',frmCursesList.lb_cursorlist.Item[frmCursesList.lb_cursorlist.ItemIndex].SubItemText[2]);
        for n := 0 to frmCursesList.ccolors.Items.Count - 1 do
            XML.Root.Items.Add('Color' + inttostr(n),frmCursesList.ccolors.Items.Item[n].ColorCode);
        XML.SaveToFile(FName + '~');
        if FileExists(FName) then
           DeleteFile(FName);
        RenameFile(FName + '~',FName);
        XML.Free;
      end;
    end;

    frmCursesList.Close;
    frmCursesList.Free;
    frmCursesList := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Cursor');
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
begin
  if frmCursesList <> nil then
  begin
    frmCursesList.lb_cursorlist.Colors.ItemColor := AItemColor;
    frmCursesList.lb_cursorlist.Colors.ItemColorSelected := AItemSelectedColor;
    frmCursesList.lb_cursorlist.Colors.BorderColor := AItemSelectedColor;
    frmCursesList.lb_cursorlist.Colors.BorderColorSelected := AItemSelectedColor;
    frmCursesList.BuildCursorList;
  end;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Cursor',nil,'','');
end;

function SetSettingType : integer;
begin
  result := SU_CURSOR;
end;

procedure UpdatePreview(var ABmp: TBitmap32);
begin
  if (frmCursesList.lb_CursorList.ItemIndex < 0) or
     (frmCursesList.lb_CursorList.Count = 0) then
     exit;

  ABmp.SetSize(frmCursesList.Preview.Width,frmCursesList.Preview.Height);
  ABmp.Clear(color32(0,0,0,0));
  frmCursesList.Preview.DrawTo(ABmp);
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
  ClickBtn,
  UpdatePreview;

end.

