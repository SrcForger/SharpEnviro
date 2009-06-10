{
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

unit uSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JclSimpleXml, JclFileUtils,
  ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx,GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpGraphicsUtils,
  SharpEColorEditorEx, SharpESwatchManager,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmSettingsWnd = class(TForm)
    lbCursorList: TSharpEListBoxEx;
    SharpESwatchManager1: TSharpESwatchManager;
    ccolors: TSharpEColorEditorEx;
    tmr: TTimer;
    PngImageList1: TPngImageList;
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbCursorListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbCursorListResize(Sender: TObject);
    procedure ccolorsUiChange(Sender: TObject);
    procedure tmrOnTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbCursorListGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbCursorListGetCellImageIndex(Sender: TObject;
      const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
  private
    FPluginHost: ISharpCenterHost;
    FPreview: TBitmap32;
    FCursor: string;
    procedure BuildCursorPreview;
  public
    procedure BuildCursorList;
    procedure SendUpdate;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;

    property Cursor: string read FCursor write FCursor;
    property Preview: TBitmap32 read FPreview write FPreview;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;

  CursorItemArray: array[0..10] of string = ('normal.bmp','appstarting.bmp', 'wait.bmp',
    'hand.bmp', 'no.bmp', 'ibeam.bmp', 'sizeall.bmp',
    'sizenesw.bmp', 'sizens.bmp', 'sizenwse.bmp', 'sizewe.bmp');

implementation

uses SharpThemeApiEx,
     SharpCenterApi;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmSettingsWnd.lbCursorListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  BuildCursorPreview;
  SendUpdate;
end;

procedure TfrmSettingsWnd.lbCursorListGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
begin
  AImageIndex := 0;
end;

procedure TfrmSettingsWnd.lbCursorListGetCellText(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColText: string);
var
  colitemTxt, colDescTxt, colBtnTxt: TColor;
  tmp: TStringObject;
begin
  tmp := TStringObject(AItem.Data);
  if tmp = nil then
    exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  if ACol = 0 then begin
    AColText := format('<font color="%s" />%s',[colorToString(colBtnTxt),tmp.Str]);
  end;
end;

procedure TfrmSettingsWnd.lbCursorListResize(Sender: TObject);
begin
  Self.Height := lbCursorList.Height+ccolors.Height;
end;

procedure TfrmSettingsWnd.SendUpdate;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

procedure TfrmSettingsWnd.tmrOnTimer(Sender: TObject);
begin
  tmr.Enabled := false;
  BuildCursorList;
end;

procedure TfrmSettingsWnd.FormCreate(Sender: TObject);
begin
  FPreview := TBitmap32.Create;
  lbCursorList.DoubleBuffered := true;
end;

procedure TfrmSettingsWnd.BuildCursorPreview;
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
  LockWindowUpdate(self.Handle);
  try
  if (lbCursorList.ItemIndex < 0) or (lbCursorList.Count = 0) then
  begin
    PluginHost.Refresh(rtPreview);
    exit;
  end;

  FCursor := TStringObject(lbCursorList.SelectedItem.Data).Str;
  Dir := SharpApi.GetSharpeDirectory + 'Cursors\' + FCursor + '\';

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

  FPreview.Assign(bmp32);

  Bmp.Free;
  Bmp32.Free;

  
  finally
    LockWindowUpdate(0);
    PluginHost.Refresh(rtPreview);
  end;
end;

procedure TfrmSettingsWnd.BuildCursorList;
var
  newItem:TSharpEListItem;
  sr : TSearchRec;
  Dir : String;
  XML : TJclSimpleXML;
  s, sName, sAuthor:String;
  obj: TStringObject;
begin
  LockWindowUpdate(Application.Handle);
  lbCursorList.Clear;
  Try

  XML := TJclSimpleXML.Create;

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

            if CompareText(sr.Name,FCursor) = 0 then
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

  //PluginHost.Refresh;
end;

procedure TfrmSettingsWnd.FormResize(Sender: TObject);
begin
  BuildCursorPreview;
end;

procedure TfrmSettingsWnd.FormShow(Sender: TObject);
begin
  tmr.Enabled := true;
end;

procedure TfrmSettingsWnd.ccolorsUiChange(Sender: TObject);
begin
  BuildCursorPreview;
  SendUpdate;
end;

procedure TfrmSettingsWnd.FormDestroy(Sender: TObject);
begin
  FPreview.Free;
end;

end.


