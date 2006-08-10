{
Source Name: ThemeList
Description: Theme List Config Window
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

unit uConfigListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, SharpApi, uSEListboxPainter, JclFileUtils,
  uSharpCenterSectionList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox;

type
  TfrmConfigListWnd = class(TForm)
    ThemeImages: TPngImageList;
    themelist: TSharpEListBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure themelistDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  private
    FLoadedThemeID: string;
  private
    function GetLoadedThemeID: string;
    procedure BuildThemeList;
    property LoadedThemeID: string read FLoadedThemeID write FLoadedThemeID;
  public
    procedure EditTheme;
  end;

var
  frmConfigListWnd: TfrmConfigListWnd;
  IDList : TStringList;

implementation

uses GR32, GR32_PNG;

{$R *.dfm}

{ TfrmConfigListWnd }

function TfrmConfigListWnd.GetLoadedThemeID: string;
var
  xml: TJvSimpleXML;
  fn: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    fn := GetSharpeUserSettingsPath + 'SharpDesk\Settings.xml';
    if fileexists(fn) then begin
      xml.LoadFromFile(fn);
      with xml.Root.Items.ItemNamed['Settings'] do begin
        Result := items.ItemNamed['Theme'].Value;
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure TfrmConfigListWnd.FormShow(Sender: TObject);
begin
  FLoadedThemeID := GetLoadedThemeID;
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
begin
  dir := SharpApi.GetSharpeUserSettingsPath + 'Themes\';
  ThemeList.Clear;
  IDList.Clear;
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
          ThemeList.Items.Add(XML.Root.Items.Value('Name','Error loading XML Setting'));
          IDList.Add(XML.Root.Items.Value('ID','-1'));
          if FileExists(dir + sr.Name + '\Preview.png') then
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
begin
  if Index < 0 then  exit;

  if TListBox(Control).Style = lbStandard then  exit;

  if IDList[Index] = FLoadedThemeID then status := 'current theme'
     else status := '';

  PaintListbox(TListBox(Control), Rect, 0, State, themelist.Items[Index], ThemeImages, Index, status, clWindowText);
end;

procedure TfrmConfigListWnd.EditTheme;
begin
  if ThemeList.ItemIndex < 0 then exit;
  SharpApi.CenterMsg('_loadConfig',PChar(SharpApi.GetCenterDirectory + '_Themes\Theme.con'),strtoint(IDList[ThemeList.ItemIndex]));
end;

procedure TfrmConfigListWnd.FormCreate(Sender: TObject);
begin
  IDList := TStringList.Create;
  IDList.Clear;
end;

procedure TfrmConfigListWnd.FormDestroy(Sender: TObject);
begin
  IDList.Free;
end;

end.
