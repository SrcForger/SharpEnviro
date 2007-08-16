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
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmIconList = class(TForm)
    lb_iconlist: TSharpEListBoxEx;
    PngImageList1: TPngImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lb_iconlistResize(Sender: TObject);
    procedure lb_iconlistClickItem(const ACol: Integer; AItem: TSharpEListItem);
  private

  public
    sCurrentIconSet: string;
    sTheme: string;
    procedure BuildIconList;
    procedure SaveSettings;
    procedure BuildIconPreview(var ABmp: TBitmap32);
  end;

var
  frmIconList: TfrmIconList;

implementation

uses SharpThemeApi, SharpCenterApi,
  SharpIconUtils;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmIconList.SaveSettings;
var
  XML: TJvSimpleXML;
  sDir: string;
begin
  if lb_iconlist.ItemIndex >= 0 then
  begin
    sDir := SharpApi.GetSharpeUserSettingsPath + '\Themes\' + sTheme;

    XML := TJvSimpleXML.Create(nil);
    try

      XML.Root.Name := 'SharpEThemeIconSet';
      XML.Root.Items.Add('Name', lb_iconlist.Item[lb_iconlist.ItemIndex].Caption);
      XML.SaveToFile(sDir + '\IconSet.xml~');

      if FileExists(sDir + '\IconSet.xml') then
        DeleteFile(sDir + '\IconSet.xml');

      RenameFile(sDir + '\IconSet.xml~', sDir + '\IconSet.xml');

    finally
      XML.Free;
    end;
  end;
end;

procedure TfrmIconList.FormShow(Sender: TObject);
begin
  //lb_iconlist.Margin := Rect(0,0,0,0);
  //lb_iconlist.ColumnMargin := Rect(6,0,6,0);
end;

procedure TfrmIconList.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmIconList.BuildIconPreview(var ABmp: TBitmap32);
const
  IconSize = 32;
var
  x, y: integer;
  XML: TJvSimpleXML;
  Dir: string;
  icon: TBitmap32;
  n: integer;
  h: integer;
  IconCount: integer;
begin

  Dir := SharpApi.GetSharpeDirectory + 'Icons\' +
    lb_iconlist.Item[lb_iconlist.ItemIndex].Caption + '\';

  XML := TJvSimpleXML.Create(nil);

  Icon := TBitmap32.Create;
  Icon.DrawMode := dmBlend;
  Icon.CombineMode := cmMerge;

  try
    if FileExists(Dir + 'IconSet.xml') then
    begin
      XML.LoadFromFile(Dir + 'IconSet.xml');
      if XML.Root.Items.ItemNamed['Icons'] <> nil then
      begin
        IconCount := XML.Root.Items.ItemNamed['Icons'].Items.Count;
        h := (IconCount div ((ABmp.Width - Icon.Width) div IconSize) + 1) * IconSize;
        ABmp.Height := h;

        x := 0;
        y := 0;
        for n := 0 to XML.Root.Items.ItemNamed['Icons'].Items.Count - 1 do
          with XML.Root.Items.ItemNamed['Icons'].Items.Item[n].Items do
          begin
            Application.ProcessMessages;
            SharpIconUtils.LoadIco(Icon, Dir + Value('file'), IconSize);
            Icon.DrawTo(ABmp, x * Icon.Width, y * Icon.Height);
            x := x + 1;
            if x * Icon.Width >= (ABmp.Width - Icon.Width) then
            begin
              x := 0;
              y := y + 1;
            end;
          end;
      end;
    end;
  except
  end;

  Icon.Free;
  XML.Free;
end;

procedure TfrmIconList.BuildIconList;
var
  newItem: TSharpEListItem;
  sr: TSearchRec;
  Dir: string;
  XML: TJvSimpleXML;
begin
  lb_iconlist.Clear;

  XML := TJvSimpleXML.Create(nil);

  Dir := SharpApi.GetSharpeDirectory + 'Icons\';

  if FindFirst(Dir + '*', FADirectory, sr) = 0 then
    repeat
      if (CompareText(sr.Name, '.') <> 0) and (CompareText(sr.Name, '..') <> 0) then
      begin
        if FileExists(Dir + sr.Name + '\IconSet.xml') then
        begin
          try
            XML.LoadFromFile(Dir + sr.Name + '\IconSet.xml');
            newItem := lb_iconlist.AddItem(XML.Root.Items.Value('name', '...'),0);
            newItem.AddSubItem('By ' + XML.Root.Items.Value('author', '...'));

            if sr.Name = sCurrentIconSet then
            begin
              lb_iconlist.ItemIndex := lb_iconlist.Items.Count - 1;
            //BuildIconPreview;
            end;
          except
          end;
        end;
      end;
    until FindNext(sr) <> 0;
  FindClose(sr);
  XML.Free;

  if (lb_iconlist.ItemIndex < 0) and (lb_iconlist.Count > 0) then
  begin
    lb_iconlist.ItemIndex := 0;
    //BuildIconPreview;
  end;
end;

procedure TfrmIconList.lb_iconlistClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
begin

  SaveSettings;
  BroadcastGlobalUpdateMessage(suIconSet);
  CenterUpdatePreview;

end;

procedure TfrmIconList.lb_iconlistResize(Sender: TObject);
begin
  Self.Height := lb_iconlist.Height;
end;

end.

