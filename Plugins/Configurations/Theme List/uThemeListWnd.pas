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

unit uThemeListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, uThemeListManager, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, JclInifiles, SharpCenterApi, pngimage,
  Jcldatetime, DateUtils;

type
  TfrmThemeList = class(TForm)
    ThemeImages: TPngImageList;
    lbThemeList: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    DefThemeImageList: TPngImageList;
    tmrEnableUi: TTimer;
    procedure lbThemeListClickItem(const ACol: Integer;
      AItem: TSharpEListItem);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbThemesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbThemeListResize(Sender: TObject);

    procedure lbThemeListGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure tmrEnableUiTimer(Sender: TObject);
    procedure lbThemeListGetCellText(const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbThemeListGetCellImageIndex(const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    FLoading:Boolean;
    procedure LoadTheme(tmpTheme: TThemeListItem);
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

const
  cName = 0;
  cReadOnly = 1;
  cWebsite = 2;
  cCopy = 3;
  cEdit = 4;

implementation

uses uThemeListEditWnd;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmThemeList.UpdateEditTabs;

  procedure BC(AEnabled: Boolean; AButton: TSCB_BUTTON_ENUM);
  begin
    if AEnabled then
      CenterDefineButtonState(AButton, True)
    else
      CenterDefineButtonState(AButton, False);
  end;

begin
  if ((lbThemeList.Count = 0) or (lbThemeList.ItemIndex = -1)) then begin
    BC(False, scbEditTab);

    if (lbThemeList.Count = 0) then begin
      BC(False, scbDeleteTab);
      CenterSelectEditTab(scbAddTab);
    end;

    BC(True, scbAddTab);
  end
  else begin
    BC(True, scbAddTab);
    BC(False, scbEditTab);
    BC(True, scbDeleteTab);
  end;
end;

procedure TfrmThemeList.FormShow(Sender: TObject);
begin
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
  bmp.Width := ThemeImages.Width;
  bmp.Height := ThemeImages.Height;
  SetBkMode(Bmp.Handle, TRANSPARENT);

  sl := TStringList.Create;
  try
    ThemeManager.GetThemeList(sl);

    for i := 0 to Pred(sl.Count) do begin
      tmpTheme := TThemeListItem(sl.Objects[i]);

      newItem := lbThemeList.AddItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');

      newItem.Data := tmpTheme;
      bmp32.Clear(clWhite32);

      if ((tmpTheme.PreviewFileName <> '') and
        (FileExists(tmpTheme.PreviewFileName))) then begin

        GR32_PNG.LoadBitmap32FromPNG(Bmp32, tmpTheme.PreviewFileName, b);

        bmp.Canvas.Brush.Color := clBlack;
        bmp.Canvas.Pen.Color := clBlack;
        bmp.canvas.FillRect(bmp.canvas.ClipRect);
        //bmp32.drawto
        bmp32.DrawTo(bmp.canvas.handle, Rect(0, 0, 62, 48), bmp32.ClipRect);

        newItem.SubItemImageIndexes[0] :=
          Pointer(themeimages.AddMasked(bmp, clFuchsia));
      end
      else begin
        //bmp := imgDef.Picture.Bitmap;
        DefThemeImageList.PngImages.Items[0].PngImage.Draw(Bmp.Canvas, bmp.Canvas.ClipRect);
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
  tmpTheme: TThemeListItem;
  s: string;
begin
  if AItem <> nil then begin
    tmpTheme := TThemeListItem(AItem.Data);

    case ACol of
      cReadOnly: ;
      cEdit: begin
          if not (tmpTheme.IsReadOnly) then
            ConfigureItem;
          exit;
        end;
      cWebsite: begin
          if tmpTheme.Website <> '' then
            SharpExecute(tmpTheme.Website);
        end;
      cCopy: begin
          s := InputBox('Copy Theme', 'Please enter a name for the theme:', tmpTheme.Name);

          if CompareText(s, tmpTheme.Name) <> 0 then begin
            ThemeManager.Add(s, tmpTheme.Author, tmpTheme.Website, tmpTheme.Name, False);
            BuildThemeList;
          end;
        end;
    else
      LoadTheme(tmpTheme);
    end;

  end;
end;

function TfrmThemeList.UpdateUI: Boolean;
var
  df: TSC_DEFAULT_FIELDS;
begin
  Result := False;
  case FEditMode of
    sceAdd: begin
        frmEditItem.pagAdd.Show;

        CenterReadDefaults(df);
        FrmEditItem.edAuthor.Text := df.Author;
        FrmEditItem.edName.Text := '';
        frmEditItem.edWebsite.Text := df.Website;

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
    sceDelete: begin

        if frmThemeList.lbThemeList.ItemIndex <> -1 then begin

          frmEditItem.pagDelete.Show;

          CenterDefineButtonState(scbDelete, True);
        end
        else begin
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
  df: TSC_DEFAULT_FIELDS;
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

        df.Author := sAuthor;
        df.Website := sWebsite;
        CenterWriteDefaults(df);
        ThemeManager.Add(sName, sAuthor, sWebsite, sTemplate);
      end;
    sceDelete: begin

        if lbThemeList.Count = 1 then begin
          Result := False;

          MessageDlg('Unable to delete selected theme.' + #13 + #10 + '' + #13 + #10 +
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
              newID := id - 1
            else
              newid := 0;
          end
          else
            newid := id;

          if frmThemeList.lbThemeList.Count <> 0 then
            frmThemeList.lbThemeList.ItemIndex := newId;
        end;
      end;
  end;

end;

procedure TfrmThemeList.tmrEnableUiTimer(Sender: TObject);
begin
  tmrEnableUi.Enabled := False;
  lbThemeList.Enabled := True;
  FLoading := False;
end;

procedure TfrmThemeList.lbThemeListGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmpTheme: TThemeListItem;
begin
  if AItem <> nil then begin

    tmpTheme := TThemeListItem(AItem.Data);
    case ACol of
      cWebsite: begin
          if tmpTheme.Website <> '' then
            ACursor := crHandPoint;
        end;
      cEdit: begin

          if not (tmpTheme.IsReadOnly) then
            ACursor := crHandPoint;
        end;
      cCopy: ACursor := crHandPoint;
    end;
  end;
end;

procedure TfrmThemeList.lbThemeListGetCellImageIndex(const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmpTheme: TThemeListItem;
begin
  tmpTheme := TThemeListItem(AItem.Data);
  if tmpTheme <> nil then begin

    case ACol of
      cReadOnly: begin
          if tmpTheme.IsReadOnly then
            AImageIndex := 1
          else
            AImageIndex := -1;
        end;
      cWebsite: begin
          if tmpTheme.Website <> '' then
            AImageIndex := 3
          else
            AImageIndex := -1;
        end;
      cCopy: begin
          AImageIndex := 5;
        end;
    end;
  end;

end;

procedure TfrmThemeList.lbThemeListGetCellText(const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpTheme: TThemeListItem;
  s: String;
begin
  tmpTheme := TThemeListItem(AItem.Data);
  if tmpTheme <> nil then begin
    if (Acol = cEdit) then begin
      if tmpTheme.IsReadOnly then
        AColText := '<font color="clSilver"><u>Edit</u>'
      else
        AColText := '<font color="clNavy"><u>Edit</u>';
    end
    else if (ACol = cName) then begin

      s := '';
      if ((FLoading) and (AItem.ID = lbThemeList.ItemIndex)) then
        s := ' (Loading)';
      AColText := Format('%s by %s%s', [tmpTheme.Name, tmpTheme.Author,s]);
    end;
  end;

end;

procedure TfrmThemeList.ConfigureItem;
var
  tmpItem: TSharpEListItem;
  sTheme: string;
begin
  tmpItem := lbThemeList.GetItemAtCursorPos(Mouse.CursorPos);
  if tmpItem <> nil then begin
    sTheme := TThemeListItem(tmpItem.Data).Name;
    CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
      + '_Themes\Theme.con'), pchar(sTheme))
  end;
end;

procedure TfrmThemeList.LoadTheme(tmpTheme: TThemeListItem);
begin
  if FrmEditItem <> nil then
    updateui
  else begin
    lbThemeList.Enabled := False;
    tmrEnableUi.Enabled := True;

    FLoading := True;
    ThemeManager.SetTheme(tmpTheme.Name);
    SharpCenterApi.BroadcastGlobalUpdateMessage(suTheme, -1);
  end;
end;

procedure TfrmThemeList.lbThemeListResize(Sender: TObject);
begin
  Self.Height := lbThemeList.Height;
end;

end.

