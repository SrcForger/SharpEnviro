{
Source Name: uIconeListWnd.pas
Description: Icon List Window
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

unit uIconListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx,GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmIconList = class(TForm)
    lb_iconlist: TSharpEListBoxEx;
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lb_iconlistClickItem(AText: string; AItem, ACol: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure BuildIconPreview;
  public
    sCurrentIconSet : String;
    sTheme : String;
    Preview : TBitmap32;
    procedure BuildIconList;
  end;

var
  frmIconList: TfrmIconList;

implementation

uses SharpThemeApi, SharpCenterApi,
     SharpIconUtils;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmIconList.FormShow(Sender: TObject);
begin
  lb_iconlist.Margin := Rect(0,0,0,0);
  lb_iconlist.ColumnMargin := Rect(6,0,6,0);
end;


procedure TfrmIconList.FormCreate(Sender: TObject);
begin
  Preview := TBitmap32.Create;
  DoubleBuffered := true;
end;

procedure TfrmIconList.BuildIconPreview;
const
  IconSize = 48;
var
  x,y : integer;
  XML : TJvSimpleXML;
  Dir : String;
  icon : TBitmap32;
  n : integer;
  bmp32 : TBitmap32;
  w,h : integer;
  IconCount : integer;
begin
  if lb_iconlist.ItemIndex < 0 then
  begin
    CenterUpdatePreview;

    exit;
  end;

  Dir := SharpApi.GetSharpeDirectory + 'Icons\' + lb_iconlist.Item[lb_iconlist.ItemIndex].SubItemText[1] + '\';

  XML := TJvSimpleXML.Create(nil);

  Icon := TBitmap32.Create;
  Icon.DrawMode := dmBlend;
  Icon.CombineMode := cmMerge;

  Bmp32 := TBitmap32.Create;
  Bmp32.SetSize(32,32);
  Bmp32.Clear(color32(0,0,0,0));

  try
    if FileExists(Dir + 'IconSet.xml') then
    begin
      XML.LoadFromFile(Dir + 'IconSet.xml');
      if XML.Root.Items.ItemNamed['Icons'] <> nil then
      begin
        IconCount := XML.Root.Items.ItemNamed['Icons'].Items.Count;
        w := ((Width - 64) div IconSize) * IconSize;
        h := (IconCount div (w div IconSize) + 1) * IconSize;

        Bmp32.SetSize(w,h);
        Bmp32.Clear(color32(0,0,0,0));

        x := 0;
        y := 0;
        for n := 0 to XML.Root.Items.ItemNamed['Icons'].Items.Count - 1 do
            with XML.Root.Items.ItemNamed['Icons'].Items.Item[n].Items do
            begin
              Application.ProcessMessages;
              SharpIconUtils.LoadIco(Icon,Dir + Value('file'),IconSize);
              Icon.DrawTo(bmp32,x*Icon.Width,y*Icon.Height);
              x := x + 1;
              if x*Icon.Width >= bmp32.Width then
              begin
                x := 0;
                y := y + 1;
              end;
            end;
      end;
    end;
  except
  end;

  Preview.Assign(bmp32);

  Icon.Free;
  Bmp32.Free;
  XML.Free;

  CenterUpdatePreview;
end;

procedure TfrmIconList.BuildIconList;
var
  newItem:TSharpEListItem;
  sr : TSearchRec;
  Dir : String;
  XML : TJvSimpleXML;
begin
  lb_iconlist.Clear;

  XML := TJvSimpleXML.Create(nil);

  Dir := SharpApi.GetSharpeDirectory + 'Icons\';

  if FindFirst(Dir + '*',FADirectory,sr) = 0 then
  repeat
    if (CompareText(sr.Name,'.') <> 0) and (CompareText(sr.Name,'..') <> 0) then
    begin
      if FileExists(Dir + sr.Name + '\IconSet.xml') then
      begin
        try
          XML.LoadFromFile(Dir + sr.Name + '\IconSet.xml');
          newItem := lb_iconlist.AddItem(XML.Root.Items.Value('name','...'));
          newItem.AddSubItem(sr.Name);

          if sr.Name = sCurrentIconSet then
          begin
            lb_iconlist.ItemIndex := lb_iconlist.Items.Count - 1;
            BuildIconPreview;
          end;
        except
        end;
      end;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
  XML.Free;
end;

procedure TfrmIconList.lb_iconlistClickItem(AText: string; AItem,
  ACol: Integer);
begin
  BuildIconPreview;
  CenterDefineSettingsChanged;
end;

procedure TfrmIconList.FormResize(Sender: TObject);
begin
  BuildIconPreview;
end;

procedure TfrmIconList.FormDestroy(Sender: TObject);
begin
  Preview.Free;
end;

end.

