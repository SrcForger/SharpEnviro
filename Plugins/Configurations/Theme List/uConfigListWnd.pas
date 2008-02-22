{
Source Name: ThemeList
Description: Theme List Config Window
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

unit uConfigListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, SharpApi, uSEListboxPainter, JclFileUtils,
  uSharpCenterSectionList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpThemeApi;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmConfigListWnd = class(TForm)
    ThemeImages: TPngImageList;
    themelist: TSharpEListBox;
    procedure FormShow(Sender: TObject);
    procedure themelistDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  private
  private
    procedure BuildThemeList;
  public
    procedure EditTheme;
  end;

var
  frmConfigListWnd: TfrmConfigListWnd;

implementation

uses GR32, GR32_PNG;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmConfigListWnd.FormShow(Sender: TObject);
begin
  BuildThemeList;
end;

procedure TfrmConfigListWnd.BuildThemeList;
var
  sr: TSearchRec;
  XML : TJvSimpleXML;
  dir : String;
  Bmp : TBitmap;
  Bmp32 : TBitmap32;
  b : boolean;
  str:TStringObject;
begin
  dir := SharpApi.GetSharpeUserSettingsPath + 'Themes\';
  ThemeList.Clear;

  XML := TJvSimpleXML.Create(nil);
  bmp := TBitmap.Create;
  bmp32 := TBitmap32.Create;
  bmp.Width := ThemeImages.Width + 2;
  bmp.Height := ThemeImages.Height + 2;

  if FindFirst(dir+'*.*', faDirectory, sr) = 0 then
  begin
    repeat
      try
        if FileExists(dir + sr.Name + '\Theme.xml') then
        begin
          XML.LoadFromFile(dir + sr.Name + '\Theme.xml');

          str := TStringObject.Create;
          str.Str := sr.Name;

          ThemeList.Items.AddObject(XML.Root.Items.Value('Name','Error loading XML Setting'),str);

          if FileCheck(dir + sr.Name + '\Preview.png') then
          begin
            GR32_PNG.LoadBitmap32FromPNG(Bmp32,dir + sr.Name + '\Preview.png',b);
            bmp.Canvas.Brush.Color := clBlack;
            bmp.Canvas.Pen.Color := clBlack;
            bmp.canvas.FillRect(bmp.canvas.ClipRect);
            bmp32.DrawTo(bmp.canvas.handle,1,1);
          end else
          begin
            bmp.Canvas.Brush.Color := clFuchsia;
            bmp.Canvas.Pen.Color := clFuchsia;
            bmp.canvas.FillRect(bmp.canvas.ClipRect);
          end;
          themeimages.AddMasked(bmp,clFuchsia);
        end;
      except
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

  XML.Free;
  bmp.free;
  bmp32.free;
end;

procedure TfrmConfigListWnd.themelistDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  status : String;
  str: TStringObject;
begin
  if Index < 0 then  exit;
  str := TStringObject(TSharpEListBox(Control).Items.Objects[Index]);

  if TListBox(Control).Style = lbStandard then  exit;

  //if IDList[Index] = FLoadedThemeID then status := 'current theme'
  //   else status := '';

  SharpThemeApi.GetThemeName;


  PaintListbox(TListBox(Control), Rect, 0, State, themelist.Items[Index], ThemeImages, Index, status, clWindowText);
end;

procedure TfrmConfigListWnd.EditTheme;
var
  str:TStringObject;
begin
  if ThemeList.ItemIndex < 0 then exit;

  str := TStringObject(ThemeList.Items.Objects[ThemeList.ItemIndex]);
  SharpApi.CenterMsg('_loadConfig',PChar(SharpApi.GetCenterDirectory + '_Themes\Theme.con'),pchar(str.Str));
end;

end.
