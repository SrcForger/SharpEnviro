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
  SharpEListBox, uThemeListManager, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, JclInifiles, SharpCenterApi, pngimage;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmThemeList = class(TForm)
    ThemeImages: TPngImageList;
    lbThemeList: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    DefThemeImageList: TPngImageList;

    procedure lbThemeListDblClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
    procedure lbThemeListClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbThemesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbThemeListResize(Sender: TObject);
    procedure lbThemeListGetCellTextColor(const ACol: Integer;
      AItem: TSharpEListItem; var AColor: TColor);
    procedure lbThemeListGetCellFont(const ACol: Integer;
      AItem: TSharpEListItem; var AFont: TFont);
    procedure lbThemeListGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
  private

  public
    ThemeManager: TThemeManager;

    procedure UpdateEditTabs;
    procedure BuildThemeList;
    function UpdateUI: Boolean;
    function SaveUi: Boolean;

    procedure ConfigureItem;
    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmThemeList: TfrmThemeList;

implementation

uses uThemeListEditWnd;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmThemeList.UpdateEditTabs;

  procedure BC(AEnabled: Boolean; AButton: TSCB_BUTTON_ENUM);
  begin
    if AEnabled then
      CenterDefineButtonState(AButton, True) else
      CenterDefineButtonState(AButton, False);
  end;

begin
  if ((lbThemeList.Count = 0) or (lbThemeList.ItemIndex = -1)) then
  begin
    BC(False, scbEditTab);

    if (lbThemeList.Count = 0) then begin
      BC(False, scbDeleteTab);
      CenterSelectEditTab(scbAddTab);
    end;

    BC(True, scbAddTab);
  end
  else
  begin
    BC(True, scbAddTab);
    BC(False, scbEditTab);
    BC(True, scbDeleteTab);
  end;
end;

procedure TfrmThemeList.FormShow(Sender: TObject);
begin
  lbThemeList.Margin := Rect(0, 0, 0, 0);
  lbThemeList.ColumnMargin := Rect(6, 0, 6, 0);
  BuildThemeList;


end;

procedure TfrmThemeList.lbThemesClick(Sender: TObject);
begin
  if FrmEditItem <> nil then
    updateui {UpdateEditText};
end;

procedure TfrmThemeList.FormCreate(Sender: TObject);
begin
  ThemeManager := TThemeManager.Create;

  Self.DoubleBuffered := true;
end;

procedure TfrmThemeList.FormDestroy(Sender: TObject);
begin
  ThemeManager.Free;
end;

procedure TfrmThemeList.BuildThemeList;
var
  Bmp: TBitmap;
  Bmp32: TBitmap32;
  b: boolean;
  i: Integer;
  newItem: TSharpEListItem;
  tmpTheme: TThemeListItem;
  sl: TStringList;
begin
  lbThemeList.Clear;

  bmp := TBitmap.Create;
  bmp32 := TBitmap32.Create;
  bmp.Width := ThemeImages.Width + 2;
  bmp.Height := ThemeImages.Height + 2;
  SetBkMode(Bmp.Handle, TRANSPARENT);

  sl := TStringList.Create;
  try
    ThemeManager.GetThemeList(sl);

    for i := 0 to Pred(sl.Count) do begin
      tmpTheme := TThemeListItem(sl.Objects[i]);

      newItem := lbThemeList.AddItem(tmpTheme.Name + ' By ' + tmpTheme.Author, 0);

      if (tmpTheme.IsReadOnly) then
        newItem.AddSubItem('',1) else
        newItem.AddSubItem('',-1);

      if tmpTheme.Website <> '' then
        newItem.AddSubItem('',2) else
        newItem.AddSubItem('',-1);

      

      newItem.AddSubItem('edit');

      newItem.Data := tmpTheme;
      bmp32.Clear(clWhite32);

      if ((tmpTheme.PreviewFileName <> '') and
        (FileExists(tmpTheme.PreviewFileName))) then begin

        GR32_PNG.LoadBitmap32FromPNG(Bmp32, tmpTheme.PreviewFileName, b);
        bmp.Canvas.Brush.Color := clBlack;
        bmp.Canvas.Pen.Color := clBlack;
        bmp.canvas.FillRect(bmp.canvas.ClipRect);
        bmp32.DrawTo(bmp.canvas.handle, 1, 1);

        newItem.SubItemImageIndexes[0] :=
          Pointer(themeimages.AddMasked(bmp, clFuchsia));
      end else begin
        //bmp := imgDef.Picture.Bitmap;
        DefThemeImageList.PngImages.Items[0].PngImage.Draw(Bmp.Canvas,bmp.Canvas.ClipRect);
        //bmp32.DrawTo(bmp.canvas.handle, 1, 1);

        newItem.SubItemImageIndexes[0] :=
          Pointer(themeimages.AddMasked(bmp, clWindow));
      end;
    end;

  // finally select the default theme

    if lbThemeList.Count <> 0 then begin

      lbThemeList.ItemIndex := -1;
      for i := 0 to Pred(lbThemeList.Count) do begin
        if CompareText(TThemeListItem(lbThemeList.Item[i].Data).Name,
          ThemeManager.GetDefaultTheme) = 0 then begin
          lbThemeList.ItemIndex := i;
          break;
        end;
      end;

      if lbThemeList.ItemIndex = -1 then
        lbThemeList.ItemIndex := 0;
    end;

    bmp32.free;
  finally
    lbThemeList.Refresh;
  end;
end;

procedure TfrmThemeList.lbThemeListClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
var
  sUrl: String;
begin

  if ACol = 3 then
    ConfigureItem else
  if ACol = 2 then begin
    sUrl := TThemeListItem(lbThemeList.Item[lbThemeList.ItemIndex].Data).Website;
    SharpExecute(sUrl);
  end else begin
    if FrmEditItem <> nil then
    updateui;

    SharpCenterApi.BroadcastGlobalUpdateMessage(suTheme, -1);
    ThemeManager.SetTheme(TThemeListItem(lbThemeList.Item[lbThemeList.ItemIndex].Data).Name);
  end;


  
end;

function TfrmThemeList.UpdateUI: Boolean;
var
  tmpItem: TSharpEListItem;
  tmpThemeItem: TThemeListItem;
  i: Integer;
begin
  Result := False;
  case FEditMode of
    sceAdd: begin
        frmEditItem.pagAdd.Show;
        FrmEditItem.edAuthor.Text := '';
        FrmEditItem.edName.Text := '';
        frmEditItem.edWebsite.Text := '';

        frmEditItem.cbBasedOn.Items.Clear;
        frmEditItem.cbBasedOn.Items.AddObject('New Theme', nil);
        ThemeManager.GetThemeList(frmEditItem.cbBasedOn.Items);
        frmEditItem.cbBasedOn.ItemIndex := 0;
        frmEditItem.cbBasedOn.Enabled := True;

        frmEditItem.edName.Enabled := True;

        if ((frmEditItem.Visible) and (frmEditItem.edName.Enabled)) then
          FrmEditItem.edName.SetFocus;

        Result := True;
      end;
    sceEdit: begin

        if frmThemeList.lbThemeList.ItemIndex <> -1 then begin

          tmpItem := frmThemeList.lbThemeList.Item[frmThemeList.lbThemeList.ItemIndex];
          tmpThemeItem := TThemeListItem(tmpItem.Data);

          frmEditItem.pagEdit.Show;

          i := lbThemeList.Item[lbThemeList.ItemIndex].ImageIndex;
          frmEditItem.img.picture.Assign(lbThemeList.Column[0].Images.PngImages.Items[i].PngImage);

          FrmEditItem.lblName.Caption := Format('%s by %s',
            [tmpThemeItem.Name, tmpThemeItem.Author]);

          frmEditItem.lblSite.Visible := True;
          if tmpThemeItem.Website <> '' then
            frmEditItem.lblSite.Caption := tmpThemeItem.Website else begin
            frmEditItem.lblSite.Visible := False;
            frmEditItem.lblSite.Caption := '';
          end;

          Result := True;
        end;

      end;
    sceDelete: begin

        if frmThemeList.lbThemeList.ItemIndex <> -1 then begin

          frmEditItem.pagDelete.Show;

          CenterDefineButtonState(scbDelete, True);
        end else begin
          CenterDefineButtonState(scbDelete, False);
        end;

        Result := True;
      end;
  end;
end;

function TfrmThemeList.SaveUi: Boolean;
var
  tmp: TThemeListItem;
  id, newid: Integer;
  sAuthor: string;
  sWebsite: string;
  sTemplate: string;
  sName: string;
begin
  Result := True;

  case FEditMode of
    sceAdd: begin
        sName := frmEditItem.edName.Text;
        sAuthor := frmEditItem.edAuthor.Text;
        sWebsite := frmEditItem.edWebsite.Text;

        sTemplate := '';
        if frmEditItem.cbBasedOn.ItemIndex <> 0 then
          sTemplate := frmEditItem.cbBasedOn.text;

        ThemeManager.Add(sName, sAuthor, sWebsite, sTemplate);
      end;
    sceDelete: begin

      if lbThemeList.Count = 1 then begin
        Result := False;

        MessageDlg('Unable to delete selected theme.'+#13+#10+''+#13+#10+
          'There must always be at least one active theme.', mtError,
            [mbOK], 0);
        exit;
      end;

        id := frmThemeList.lbThemeList.ItemIndex;

        if id <> -1 then begin
          tmp := TThemeListItem(frmThemeList.lbThemeList.Item[id].Data);

          frmThemeList.lbThemeList.DeleteSelected;
          ThemeManager.Delete(tmp.Name);

          if id > (frmThemeList.lbThemeList.Count - 2) then begin
            if id - 1 >= 0 then
              newID := id - 1 else
              newid := 0;
          end else
            newid := id;

          if frmThemeList.lbThemeList.Count <> 0 then
            frmThemeList.lbThemeList.ItemIndex := newId;
        end;
      end;
  end;

end;

procedure TfrmThemeList.lbThemeListDblClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
begin
  ConfigureItem;
end;

procedure TfrmThemeList.lbThemeListGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if (ACol = 2) or (ACol = 3) then
    ACursor := crHandPoint;
end;

procedure TfrmThemeList.lbThemeListGetCellFont(const ACol: Integer;
  AItem: TSharpEListItem; var AFont: TFont);
begin
  if (ACol = 3) then
    AFont.Style := [fsUnderline];
end;

procedure TfrmThemeList.lbThemeListGetCellTextColor(const ACol: Integer;
  AItem: TSharpEListItem; var AColor: TColor);
begin
  if (ACol = 3) then
    AColor := clBlue;
end;

procedure TfrmThemeList.ConfigureItem;
var
  sTheme: string;
begin
  if lbThemeList.ItemIndex < 0 then exit;

  sTheme := TThemeListItem(lbThemeList.Item[lbThemeList.ItemIndex].Data).Name;
  CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
    + '_Themes\Theme.con'), pchar(sTheme))
end;

procedure TfrmThemeList.lbThemeListResize(Sender: TObject);
begin
  Self.Height := lbThemeList.Height;
end;

end.

