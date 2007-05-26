{
Source Name: uIconeListWnd.pas
Description: Icon List Window
Copyright (C) Martin KrÃ¤mer (MartinKraemer@gmx.net)

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

unit uCursesListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
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
    lb_CursorList: TSharpEListBoxEx;
    Panel1: TPanel;
    SharpESwatchManager1: TSharpESwatchManager;
    ccolors: TSharpEColorEditorEx;
    procedure FormDestroy(Sender: TObject);
    procedure ccolorsChangeColor(ASender: TObject; AColorCode: Integer);
    procedure FormResize(Sender: TObject);
    procedure lb_CursorListClickItem(AText: string; AItem, ACol: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure BuildCursorPreview;
  public
    Preview : TBitmap32;
    sCurrentCursor : String;
    sTheme : String;
    procedure BuildCursorList;
  end;

var
  frmCursesList: TfrmCursesList;

  CursorItemArray: array[0..10] of string = ('normal.bmp','appstarting.bmp', 'wait.bmp',
    'hand.bmp', 'no.bmp', 'ibeam.bmp', 'sizeall.bmp',
    'sizenesw.bmp', 'sizens.bmp', 'sizenwse.bmp', 'sizewe.bmp');

implementation

uses SharpThemeApi,
     SharpIconUtils;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmCursesList.FormShow(Sender: TObject);
begin
  lb_CursorList.Margin := Rect(0,0,0,0);
  lb_CursorList.ColumnMargin := Rect(6,0,6,0);
end;


procedure TfrmCursesList.FormCreate(Sender: TObject);
begin
  Preview := TBitmap32.Create;
  DoubleBuffered := true;
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
begin
  if (lb_CursorList.ItemIndex < 0) or (lb_CursorList.Count = 0) then
  begin
    SharpCenterBroadCast( SCM_EVT_UPDATE_PREVIEW, 0);
    exit;
  end;

  Dir := SharpApi.GetSharpeDirectory + 'Cursors\' + lb_CursorList.Item[lb_CursorList.ItemIndex].SubItemText[2] + '\';

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

  ReplaceColor32(bmp32,color32(0,0,0,255),color32(clWindow));
  ReplaceColor32(bmp32,color32(255,0,0,255),color32(ccolors.Items.Item[0].ColorAsTColor));
  ReplaceColor32(bmp32,color32(0,0,255,255),color32(ccolors.Items.Item[1].ColorAsTColor));
  ReplaceColor32(bmp32,color32(0,255,0,255),color32(ccolors.Items.Item[2].ColorAsTColor));
  ReplaceColor32(bmp32,color32(255,255,0,255),color32(ccolors.Items.Item[3].ColorAsTColor));

  Preview.Assign(bmp32);

  Bmp.Free;
  Bmp32.Free;

  SharpCenterBroadCast( SCM_EVT_UPDATE_PREVIEW, 0);
end;

procedure TfrmCursesList.BuildCursorList;
var
  newItem:TSharpEListItem;
  sr : TSearchRec;
  Dir : String;
  XML : TJvSimpleXML;
begin
  lb_CursorList.Clear;

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
            newItem := lb_CursorList.AddItem(XML.Root.Items.ItemNamed['SknDef'].Items.Value('Title','...'));
            newItem.AddSubItem('(Author: ' + XML.Root.Items.ItemNamed['SknDef'].Items.Value('Author','Unknown') + ')');
            newItem.AddSubItem(sr.Name);

            if sr.Name = sCurrentCursor then
            begin
              lb_CursorList.ItemIndex := lb_CursorList.Items.Count - 1;
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
end;

procedure TfrmCursesList.lb_CursorListClickItem(AText: string; AItem,
  ACol: Integer);
begin
  BuildCursorPreview;
  SharpCenterBroadCast(SCM_SET_SETTINGS_CHANGED,0);
end;

procedure TfrmCursesList.FormResize(Sender: TObject);
begin
  BuildCursorPreview;
end;

procedure TfrmCursesList.ccolorsChangeColor(ASender: TObject;
  AColorCode: Integer);
begin
  BuildCursorPreview;
  if Visible then
     SharpCenterBroadCast(SCM_SET_SETTINGS_CHANGED,0);
end;

procedure TfrmCursesList.FormDestroy(Sender: TObject);
begin
  Preview.Free;
end;

end.


