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

unit uThemeListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, uThemeListManager, SharpEListBoxEx,GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, JclInifiles;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmThemeList = class(TForm)
    ThemeImages: TPngImageList;
    lbThemeList: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    procedure lbThemeListGetCellColor(const AItem: Integer; var AColor: TColor);

    procedure lbThemeListDblClickItem(AText: string; AItem, ACol: Integer);
    procedure lbThemeListClickItem(AText: string; AItem, ACol: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbThemesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
  private
    
  public
    ThemeList: TThemeList;
    //procedure EditTheme;
    procedure BuildThemeList;
    function UpdateEditText:Boolean;
    function UpdateUI:Boolean;
    function SaveUi: Boolean;
    procedure ConfigureItem;
    Property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmThemeList: TfrmThemeList;

implementation

uses uThemeListEditWnd, SharpThemeApi;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmThemeList.FormShow(Sender: TObject);
begin
  lbThemeList.Margin := Rect(0,0,0,0);
  lbThemeList.ColumnMargin := Rect(6,0,6,0);

  ThemeList.Load;
  BuildThemeList;


end;

function TfrmThemeList.UpdateEditText:Boolean;
var
  tmpItem: TSharpEListItem;
  tmpThemeItem: TThemeListItem;
begin

  Result := False;

  Case FEditMode of
    sceAdd: begin

      FrmEditItem.edAuthor.Text := '';
      FrmEditItem.edName.Text := '';
      frmEditItem.edWebsite.Text := '';
      frmEditItem.ItemEdit := nil;

      frmEditItem.cbBasedOn.Items.Clear;
      frmEditItem.cbBasedOn.Items.AddObject('New Theme',nil);
      ThemeList.GetThemeList(frmEditItem.cbBasedOn.Items);

      frmEditItem.cbBasedOn.ItemIndex := 0;
      frmEditItem.cbBasedOn.Enabled := True;

      if FrmEditItem.pagEdit.Visible then begin
        FrmEditItem.edName.SetFocus;

        if FileExists(GetSharpeUserSettingsPath+'author.dat') then begin
          FrmEditItem.edAuthor.Text := IniReadString(GetSharpeUserSettingsPath+'author.dat',
            'main','author');
        end;
      end;
      Result := True;

    end;
    sceEdit: begin

      if frmThemeList.lbThemeList.ItemIndex <> -1 then begin
        tmpItem := frmThemeList.lbThemeList.Item[frmThemeList.lbThemeList.ItemIndex];
        tmpThemeItem := TThemeListItem(tmpItem.Data);

        FrmEditItem.edName.Text := tmpThemeItem.Name;
        FrmEditItem.edAuthor.Text := tmpThemeItem.Author;
        frmEditItem.edWebsite.Text := tmpThemeItem.Website;
        frmEditItem.ItemEdit := tmpThemeItem;

        if FrmEditItem.pagEdit.Visible then
          FrmEditItem.edName.SetFocus;

        frmEditItem.cbBasedOn.Items.Clear;
        frmEditItem.cbBasedOn.Items.AddObject('Not Applicable',nil);
        ThemeList.GetThemeList(frmEditItem.cbBasedOn.Items);

        if tmpThemeItem.Template <> nil then
          frmEditItem.cbBasedOn.ItemIndex := frmEditItem.cbBasedOn.Items.IndexOfObject(Pointer(tmpThemeItem.Template)) else
          frmEditItem.cbBasedOn.ItemIndex := 0;

        frmEditItem.cbBasedOn.Enabled := False;

        Result := True;
      end;
    end;
    sceDelete: begin
      if frmThemeList.lbThemeList.ItemIndex <> -1 then begin
        SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_BUTTON_ENABLED,
          SCB_DELETE);
      end else begin
        SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_BUTTON_DISABLED,
          SCB_DELETE);
      end;
    end;
  end;
end;

procedure TfrmThemeList.lbThemesClick(Sender: TObject);
begin
  if FrmEditItem <> nil then
    UpdateEditText;
end;

procedure TfrmThemeList.FormCreate(Sender: TObject);
begin
  ThemeList := TThemeList.Create;
  Self.DoubleBuffered := true;
end;

procedure TfrmThemeList.FormDestroy(Sender: TObject);
begin
  ThemeList.Free;
end;

procedure TfrmThemeList.BuildThemeList;
var
  Bmp : TBitmap;
  Bmp32 : TBitmap32;
  b : boolean;
  i: Integer;
  newItem:TSharpEListItem;
begin
  lbThemeList.Clear;

  bmp := TBitmap.Create;
  bmp32 := TBitmap32.Create;
  bmp.Width := ThemeImages.Width + 2;
  bmp.Height := ThemeImages.Height + 2;
  SetBkMode(Bmp.Handle,TRANSPARENT);

  For i := 0 to Pred(ThemeList.Count) do begin

    if Not(ThemeList[i].Deleted) then begin

    newItem := lbThemeList.AddItem('',0);
    newItem.AddSubItem(ThemeList[i].Name);
    newItem.AddSubItem(ThemeList[i].Author);
    newItem.Data := ThemeList[i];
    bmp32.Clear(clWhite32);

    if ( (ThemeList[i].PreviewFileName <> '') and
      (FileExists(ThemeList[i].PreviewFileName))) then begin

        GR32_PNG.LoadBitmap32FromPNG(Bmp32,ThemeList[i].PreviewFileName,b);
        bmp.Canvas.Brush.Color := clBlack;
        bmp.Canvas.Pen.Color := clBlack;
        bmp.canvas.FillRect(bmp.canvas.ClipRect);
        bmp32.DrawTo(bmp.canvas.handle,1,1);

        newItem.SubItemImageIndexes[0] :=
          Pointer(themeimages.AddMasked(bmp,clFuchsia));
      end else begin
        bmp.Canvas.Brush.Color := clWindow;
        bmp.Canvas.Pen.Color := clBlack;
        bmp.canvas.Rectangle(bmp.canvas.ClipRect);
        bmp32.DrawTo(bmp.canvas.handle,1,1);
        bmp.Canvas.Font.Size := 30;
        bmp.Canvas.Font.Style := [fsbold];
        bmp.Canvas.TextOut(20,1,'?');

        newItem.SubItemImageIndexes[0] :=
          Pointer(themeimages.AddMasked(bmp,clFuchsia));
      end;
    end;
  end;

  // finally select the default theme

  if lbThemeList.Count <> 0 then begin
    lbThemeList.ItemIndex := ThemeList.GetDefaultThemeIdx;

    if lbThemeList.ItemIndex = -1 then
      lbThemeList.ItemIndex := 0;
  end;


  bmp.free;
  bmp32.free;
end;

procedure TfrmThemeList.lbThemeListClickItem(AText: string; AItem,
  ACol: Integer);
begin

  if FrmEditItem <> nil then
    UpdateEditText;

  SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_SETTINGS_CHANGED,0);
end;

function TfrmThemeList.UpdateUI: Boolean;
var
  tmpItem: TSharpEListItem;
  tmpThemeItem: TThemeListItem;
begin
  Result := False;
  case FEditMode of
  sceAdd : begin
    frmEditItem.pagEdit.Show;
    FrmEditItem.edAuthor.Text := '';
    FrmEditItem.edName.Text := '';
    frmEditItem.edWebsite.Text := '';

    frmEditItem.cbBasedOn.Items.Clear;
    frmEditItem.cbBasedOn.Items.AddObject('New Theme',nil);
    ThemeList.GetThemeList(frmEditItem.cbBasedOn.Items);
    frmEditItem.cbBasedOn.ItemIndex := 0;
    frmEditItem.cbBasedOn.Enabled := True;
    frmEditItem.ItemEdit := nil;

    FrmEditItem.edName.SetFocus;
    Result := True;
  end;
  sceEdit: begin

    if frmThemeList.lbThemeList.ItemIndex <> -1 then begin

      tmpItem := frmThemeList.lbThemeList.Item[frmThemeList.lbThemeList.ItemIndex];
      tmpThemeItem := TThemeListItem(tmpItem.Data);

      frmEditItem.pagEdit.Show;
      FrmEditItem.edName.Text := tmpThemeItem.Name;
      FrmEditItem.edAuthor.Text := tmpThemeItem.Author;
      frmEditItem.edWebsite.Text := tmpThemeItem.Website;
      FrmEditItem.edName.SetFocus;
      frmEditItem.ItemEdit := tmpThemeItem;

      frmEditItem.cbBasedOn.Items.Clear;
      frmEditItem.cbBasedOn.Items.AddObject('Not Applicable',nil);
      ThemeList.GetThemeList(frmEditItem.cbBasedOn.Items);

      if tmpThemeItem.Template <> nil then
        frmEditItem.cbBasedOn.ItemIndex := frmEditItem.cbBasedOn.Items.IndexOfObject(tmpThemeItem.Template) else
        frmEditItem.cbBasedOn.ItemIndex := 0;

      frmEditItem.cbBasedOn.Enabled := False;

      Result := True;
    end;

  end;
  sceDelete: begin

    if frmThemeList.lbThemeList.ItemIndex <> -1 then begin

      frmEditItem.pagDelete.Show;

      SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_BUTTON_ENABLED,
        SCB_DELETE);
      end else begin
        SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_SET_BUTTON_DISABLED,
          SCB_DELETE);
      end;
      
    Result := True;
  end;
  end;
end;

function TfrmThemeList.SaveUi: Boolean;
var
  tmp: TThemeListItem;
begin
  Result := True;

  case FEditMode of
    sceAdd: begin
      tmp := frmThemeList.ThemeList.Add;
      tmp.Name := trim(StrRemoveChars(frmEditItem.edName.Text,
      ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
      tmp.Author := frmEditItem.edAuthor.Text;
      tmp.Website := frmEditItem.edWebsite.Text;
      tmp.FileName := GetSharpeUserSettingsPath + 'Themes\' + tmp.Name + '\' + 'Theme.xml';
      if frmEditItem.cbBasedOn.ItemIndex <> 0 then
        tmp.Template := frmEditItem.cbBasedOn.Items.Objects[frmEditItem.cbBasedOn.ItemIndex];
    end;
    sceEdit: begin
      tmp := TThemeListItem(frmThemeList.lbThemeList.Item[frmThemeList.lbThemeList.ItemIndex].Data);
      tmp.Name := trim(StrRemoveChars(frmEditItem.edName.Text,
      ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
      tmp.Author := FrmEditItem.edAuthor.Text;
      tmp.Website := frmEditItem.edWebsite.Text;
    end;
    sceDelete: begin
    end;
  end;

end;

procedure TfrmThemeList.lbThemeListDblClickItem(AText: string; AItem,
  ACol: Integer);
begin
  ConfigureItem;
end;

procedure TfrmThemeList.ConfigureItem;
var
  sTheme: String;
begin
  if lbThemeList.ItemIndex < 0 then exit;

  sTheme := TThemeListItem(lbThemeList.Item[lbThemeList.ItemIndex].Data).Name;
  SharpApi.CenterMsg(sccLoadSetting,PChar(SharpApi.GetCenterDirectory
    + '_Themes\Theme.con'),pchar(sTheme))
end;

procedure TfrmThemeList.lbThemeListGetCellColor(const AItem: Integer;
  var AColor: TColor);
begin
  if AItem = 2 then AColor := clRed;
end;

end.

