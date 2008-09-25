﻿{
Source Name: uIconeListWnd.pas
Description: Icon List Window
Copyright (C) Martin KrÃ¤mer (MartinKraemer@gmx.net)

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

unit uCursesListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx,GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpGraphicsUtils,
  SharpEColorEditorEx, SharpESwatchManager;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmCursesList = class(TForm)
    lbCursorList: TSharpEListBoxEx;
    SharpESwatchManager1: TSharpESwatchManager;
    ccolors: TSharpEColorEditorEx;
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbCursorListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbCursorListResize(Sender: TObject);
    procedure ccolorsUiChange(Sender: TObject);
  private
    procedure BuildCursorPreview;
  public
    Preview : TBitmap32;
    FCurrentCursor : String;
    FTheme : String;
    procedure BuildCursorList;
    procedure Save;
    procedure SendUpdate;
  end;

var
  frmCursesList: TfrmCursesList;

  CursorItemArray: array[0..10] of string = ('normal.bmp','appstarting.bmp', 'wait.bmp',
    'hand.bmp', 'no.bmp', 'ibeam.bmp', 'sizeall.bmp',
    'sizenesw.bmp', 'sizens.bmp', 'sizenwse.bmp', 'sizewe.bmp');

implementation

uses SharpThemeApi,
     SharpCenterApi;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmCursesList.lbCursorListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  BuildCursorPreview;
  SendUpdate;
end;

procedure TfrmCursesList.lbCursorListResize(Sender: TObject);
begin
  Self.Height := lbCursorList.Height+ccolors.Height;
end;

procedure TfrmCursesList.Save;
var
  XML : TJvSimpleXML;
  FName, sTheme : String;
  n : integer;
begin
  if frmCursesList.lbcursorlist.ItemIndex >= 0 then
  begin
    sTheme := TStringObject(lbCursorList.SelectedItem.Data).Str;
    FName := SharpApi.GetSharpeUserSettingsPath + '\Themes\'+FTheme+'\Cursor.xml';

    XML := TJvSimpleXML.Create(nil);
    XML.Root.Name := 'SharpEThemeCursor';
    XML.Root.Items.Add('CurrentSkin',sTheme);
    for n := 0 to frmCursesList.ccolors.Items.Count - 1 do
        XML.Root.Items.Add('Color' + inttostr(n),frmCursesList.ccolors.Items.Item[n].ColorCode);
    XML.SaveToFile(FName + '~');
    if FileExists(FName) then
       DeleteFile(FName);
    RenameFile(FName + '~',FName);
    XML.Free;
  end;
end;

procedure TfrmCursesList.SendUpdate;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

procedure TfrmCursesList.FormCreate(Sender: TObject);
begin
  Preview := TBitmap32.Create;
end;

procedure TfrmCursesList.BuildCursorPreview;
const
  IconSize = 32;
var
  x,y : integer;
  Dir : String;
  n : integer;
  bmp : TBitmap32;
  Bmp32: TBitmap32;
  w,h : integer;
  IconCount : integer;
  sTheme: String;
begin
  LockWindowUpdate(Self.Handle);
  try
  if (lbCursorList.ItemIndex < 0) or (lbCursorList.Count = 0) then
  begin
    CenterUpdatePreview;
    exit;
  end;

  sTheme := TStringObject(lbCursorList.SelectedItem.Data).Str;
  Dir := SharpApi.GetSharpeDirectory + 'Cursors\' + sTheme + '\';

  Bmp32 := TBitmap32.Create;
  Bmp32.DrawMode := dmBlend;
  Bmp32.CombineMode := cmMerge;

  Bmp := TBitmap32.Create;
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;

  IconCount := length(CursorItemArray);
  w := ((Width - 64) div IconSize) * IconSize;
  h := (IconCount div (w div IconSize) + 1) * IconSize;

  Bmp32.SetSize(w,h);
  Bmp32.Clear(color32(0,0,0,0));
  bmp32.DrawMode := dmTransparent;

  x := 0;
  y := 0;
  for n := 0 to High(CursorItemArray) do
  begin
    Application.ProcessMessages;
    if FileExists(Dir + CursorItemArray[n]) then
    begin
      Bmp.LoadFromFile(Dir + CursorItemArray[n]);
      Bmp.DrawTo(Bmp32,x*Bmp.Width,y*Bmp.Height);
      x := x + 1;
      if x*Bmp.Width >= bmp32.Width then
      begin
        x := 0;
        y := y + 1;
      end;
    end;
  end;

  ReplaceColor32(bmp32,color32(0,0,0,255),color32(0,0,0,0));
  ReplaceColor32(bmp32,color32(255,0,0,255),color32(ccolors.Items.Item[0].ColorAsTColor));
  ReplaceColor32(bmp32,color32(0,0,255,255),color32(ccolors.Items.Item[1].ColorAsTColor));
  ReplaceColor32(bmp32,color32(0,255,0,255),color32(ccolors.Items.Item[2].ColorAsTColor));
  ReplaceColor32(bmp32,color32(255,255,0,255),color32(ccolors.Items.Item[3].ColorAsTColor));

  Preview.Assign(bmp32);

  Bmp.Free;
  Bmp32.Free;

  CenterUpdatePreview;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmCursesList.BuildCursorList;
var
  newItem:TSharpEListItem;
  sr : TSearchRec;
  Dir : String;
  XML : TJvSimpleXML;
  s, sName, sAuthor:String;
  obj: TStringObject;
begin
  lbCursorList.Clear;
  LockWindowUpdate(Self.Handle);
  Try

  XML := TJvSimpleXML.Create(nil);

  Dir := SharpApi.GetSharpeDirectory + 'Cursors\';

  if FindFirst(Dir + '*',FADirectory,sr) = 0 then
  repeat
    if (CompareText(sr.Name,'.') <> 0) and (CompareText(sr.Name,'..') <> 0) then
    begin
      if FileExists(Dir + sr.Name + '\Skin.xml') then
      begin
        try
          XML.LoadFromFile(Dir + sr.Name + '\Skin.xml');
          if XML.Root.Items.ItemNamed['SknDef'] <> nil then
          begin

          sName := XML.Root.Items.ItemNamed['SknDef'].Items.Value('Title','Unknown');
          sAuthor := XML.Root.Items.ItemNamed['SknDef'].Items.Value('Author','Unknown');
          s := Format('%s by %s', [sName, sAuthor]);

            newItem := lbCursorList.AddItem(s);
            obj := TStringObject.Create();
            obj.Str := sName;

            newItem.Data := ( obj );

            if CompareText(sr.Name,FCurrentCursor) = 0 then
            begin
              lbCursorList.ItemIndex := lbCursorList.Items.Count - 1;
              BuildCursorPreview;
            end;
          end;
        except
        end;
      end;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
  XML.Free;
  Finally
    LockWindowUpdate(0);
  End;

  CenterUpdateConfigFull;
end;

procedure TfrmCursesList.FormResize(Sender: TObject);
begin
  BuildCursorPreview;
end;

procedure TfrmCursesList.ccolorsUiChange(Sender: TObject);
begin
  BuildCursorPreview;
  SendUpdate;
end;

procedure TfrmCursesList.FormDestroy(Sender: TObject);
begin
  Preview.Free;
end;

end.


