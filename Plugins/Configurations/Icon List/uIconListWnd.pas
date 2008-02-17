{
Source Name: uIconeListWnd.pas
Description: Icon List Window
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

unit uIconListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JclSimpleXML, JclFileUtils,
  ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, Types;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

  TIconItem = class
  private
    FAuthor: string;
    FName: string;
    FWebsite: string;
  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Website: string read FWebsite write FWebsite;
  end;

type
  TfrmIconList = class(TForm)
    lb_iconlist: TSharpEListBoxEx;
    Images: TPngImageList;
    procedure FormCreate(Sender: TObject);
    procedure lb_iconlistResize(Sender: TObject);
    procedure lb_iconlistClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure lb_iconlistGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lb_iconlistGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lb_iconlistGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
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
  XML: TJclSimpleXML;
  sDir: string;
begin
  if lb_iconlist.ItemIndex >= 0 then begin
    sDir := SharpApi.GetSharpeUserSettingsPath + '\Themes\' + sTheme;

    XML := TJclSimpleXML.Create;
    try
      XML.Root.Name := 'SharpEThemeIconSet';
      XML.Root.Items.Add('Name', TIconItem(lb_iconlist.Item[lb_iconlist.ItemIndex].Data).Name);
      XML.SaveToFile(sDir + '\IconSet.xml~');

      if FileExists(sDir + '\IconSet.xml') then
        DeleteFile(sDir + '\IconSet.xml');

      RenameFile(sDir + '\IconSet.xml~', sDir + '\IconSet.xml');
    finally
      XML.Free;
    end;
  end;
end;

procedure TfrmIconList.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  lb_iconlist.DoubleBuffered := True;
end;

procedure TfrmIconList.BuildIconPreview(var ABmp: TBitmap32);
const
  IconSize = 32;
var
  x, y: integer;
  XML: TJclSimpleXML;
  Dir: string;
  icon: TBitmap32;
  n: integer;
  h: integer;
  IconCount: integer;
  tmp: TIconItem;
begin
  tmp := TIconItem(lb_iconlist.Item[lb_iconlist.ItemIndex].Data);
  Dir := SharpApi.GetSharpeDirectory + 'Icons\' + tmp.Name + '\';

  XML := TJclSimpleXML.Create;

  Icon := TBitmap32.Create;
  Icon.DrawMode := dmBlend;
  Icon.CombineMode := cmMerge;

  try
    if FileExists(Dir + 'IconSet.xml') then begin
      XML.LoadFromFile(Dir + 'IconSet.xml');
      if XML.Root.Items.ItemNamed['Icons'] <> nil then begin
        IconCount := XML.Root.Items.ItemNamed['Icons'].Items.Count;
        h := (IconCount div ((ABmp.Width - Icon.Width) div IconSize) + 1) * IconSize;
        ABmp.Height := h;

        x := 0;
        y := 0;
        for n := 0 to XML.Root.Items.ItemNamed['Icons'].Items.Count - 1 do
          with XML.Root.Items.ItemNamed['Icons'].Items.Item[n].Items do begin
            Application.ProcessMessages;
            SharpIconUtils.LoadIco(Icon, Dir + Value('file'), IconSize);
            Icon.DrawTo(ABmp, x * Icon.Width, y * Icon.Height);
            x := x + 1;
            if x * Icon.Width >= (ABmp.Width - Icon.Width) then begin
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
  XML: TJclSimpleXML;
  tmp: TIconItem;
begin
  lb_iconlist.Clear;

  XML := TJclSimpleXML.Create;

  Dir := SharpApi.GetSharpeDirectory + 'Icons\';

  if FindFirst(Dir + '*', FADirectory, sr) = 0 then
    repeat
      if (CompareText(sr.Name, '.') <> 0) and (CompareText(sr.Name, '..') <> 0) then begin
        if FileExists(Dir + sr.Name + '\IconSet.xml') then begin
          try
            XML.LoadFromFile(Dir + sr.Name + '\IconSet.xml');

            tmp := TIconItem.Create;
            tmp.Name := XML.Root.Items.Value('name', '...');
            tmp.Author := XML.Root.Items.Value('author', '...');
            tmp.Website := XML.Root.Items.Value('website', '');

            newItem := lb_iconlist.AddItem('', 0);
            newItem.Data := tmp;
            if length(trim(tmp.Website)) > 0 then
              newItem.AddSubItem('', 1)
            else
              newItem.AddSubItem('', -1);

            if CompareText(sr.Name,sCurrentIconSet) = 0 then begin
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

  if (lb_iconlist.ItemIndex < 0) and (lb_iconlist.Count > 0) then begin
    lb_iconlist.ItemIndex := 0;
    //BuildIconPreview;
  end;
end;

procedure TfrmIconList.lb_iconlistClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TIconItem;
begin
  tmp := TIconItem(AItem.Data);
  if tmp = nil then
    exit;

  if (ACol = 0) then begin
    SaveSettings;
    BroadcastGlobalUpdateMessage(suIconSet);
    CenterUpdatePreview;
  end
  else if (ACol = 1) then begin
    if (Pos('http', tmp.Website) <> 0) then
      SharpExecute(TIconItem(AItem.Data).Website) else begin
        SaveSettings;
      BroadcastGlobalUpdateMessage(suIconSet);
      CenterUpdatePreview;
      end;
  end;
end;

procedure TfrmIconList.lb_iconlistGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmp: TIconItem;
begin
  tmp := TIconItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = 1 then begin

    if (Pos('http', tmp.Website) = 0) then
      ACursor := crDefault
    else
      ACursor := crHandPoint;

  end;

end;

procedure TfrmIconList.lb_iconlistGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmp: TIconItem;
begin
  tmp := TIconItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = 1 then begin

    if (Pos('http', tmp.Website) = 0) then
      AImageIndex := -1
    else
      AImageIndex := 1;

  end;

end;

procedure TfrmIconList.lb_iconlistGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TIconItem;
  s: string;
begin
  tmp := TIconItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = 0 then begin

    if tmp.Author <> '' then
      s := ' by ' + tmp.Author
    else
      s := '';

    AColText := Format('%s%s', [tmp.Name, s]);
  end;
end;

procedure TfrmIconList.lb_iconlistResize(Sender: TObject);
begin
  Self.Height := lb_iconlist.Height;
end;

end.

