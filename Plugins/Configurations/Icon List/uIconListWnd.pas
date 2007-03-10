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
  ExtCtrls, Menus, JclStrings;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmIconList = class(TForm)
    IconImages: TPngImageList;
    lb_iconlist: TSharpEListBoxEx;
    IconSelImages: TPngImageList;
    procedure lb_iconlistClickItem(AText: string; AItem, ACol: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    sCurrentIconSet : String;
    sTheme : String;
    procedure BuildIconList;
  end;

var
  frmIconList: TfrmIconList;

implementation

uses SharpThemeApi,
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
  Self.DoubleBuffered := true;
end;

procedure TfrmIconList.BuildIconList;
var
  Bmp : TBitmap;
  Bmp32,BmpSel32,Icon : TBitmap32;
  newItem:TSharpEListItem;
  sr : TSearchRec;
  Dir : String;
  y : integer;
  x : integer;
  n : integer;
  XML : TJvSimpleXML;
begin
  lb_iconlist.Clear;
  IconImages.Clear;
  IconSelImages.Clear;

  bmp := TBitmap.Create;
  bmp32 := TBitmap32.Create;
  BmpSel32 := TBitmap32.Create;
  Icon := TBitmap32.Create;
  Icon.DrawMode := dmBlend;
  Icon.CombineMode := cmMerge;
  bmp.Width := IconImages.Width + 2;
  bmp.Height := IconImages.Height + 2;
  SetBkMode(Bmp.Handle,TRANSPARENT);

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
          if XML.Root.Items.ItemNamed['Icons'] <> nil then
          begin
            bmp32.SetSize(Bmp.Width,Bmp.Height);
            bmp32.Clear(color32(lb_iconlist.Colors.ItemColor));
            bmpSel32.SetSize(Bmp.Width,Bmp.Height);
            bmpSel32.Clear(color32(lb_iconlist.Colors.ItemColorSelected));
            x := 0;
            y := 0;
            for n := 0 to XML.Root.Items.ItemNamed['Icons'].Items.Count - 1 do
                with XML.Root.Items.ItemNamed['Icons'].Items.Item[n].Items do
                begin
                  SharpIconUtils.LoadIco(Icon,Dir + sr.Name + '\' + Value('file'),32);
                  Icon.DrawTo(bmp32,x*Icon.Width,y*Icon.Height);
                  Icon.DrawTo(bmpSel32,x*Icon.Width,y*Icon.Height);
                  x := x + 1;
                  if x >= 14 then
                  begin
                    x := 0;
                    y := y + 1;
                  end;
                end;
            bmp32.DrawTo(bmp.canvas.handle,0,0);
            IconImages.AddMasked(bmp,clFuchsia);
            bmpSel32.DrawTo(bmp.canvas.handle,0,0);
            IconSelImages.AddMasked(bmp,clFuchsia);
            newItem := lb_iconlist.AddItem(XML.Root.Items.Value('name','...'),0);
            newItem.AddSubItem('',IconImages.Count - 1,IconSelImages.Count - 1);
            newItem.AddSubItem(sr.Name,0);

            if sr.Name = sCurrentIconSet then
               lb_iconlist.ItemIndex := lb_iconlist.Items.Count - 1;
          end;
        except
        end;
      end;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
  XML.Free;
  Icon.Free;
  Bmp.Free;
  Bmp32.Free;
  BmpSel32.Free;
end;

procedure TfrmIconList.lb_iconlistClickItem(AText: string; AItem,
  ACol: Integer);
begin
  SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_SETTINGS_CHANGED,0);
end;

end.

