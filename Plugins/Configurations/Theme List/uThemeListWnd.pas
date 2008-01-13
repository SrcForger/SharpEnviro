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
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JvSimpleXml,
  JclFileUtils,
  uSharpCenterPluginTabList,
  uSharpCenterCommon,
  ImgList,
  PngImageList,
  SharpEListBox,
  uThemeListManager,
  SharpEListBoxEx,
  GR32,
  GR32_PNG,
  SharpApi,
  ExtCtrls,
  Menus,
  JclStrings,
  JclInifiles,
  SharpCenterApi,
  pngimage,
  Jcldatetime,
  DateUtils;

type
  TfrmThemeList = class(TForm)
    ThemeImages: TPngImageList;
    lbThemeList: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    DefThemeImageList: TPngImageList;
    tmrEnableUi: TTimer;
    procedure lbThemeListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure lbThemeListResize(Sender: TObject);

    procedure lbThemeListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure tmrEnableUiTimer(Sender: TObject);
    procedure lbThemeListGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbThemeListGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
  private
    FLoading: Boolean;
    procedure LoadTheme(tmpTheme: TThemeListItem);
  public
    ThemeManager: TThemeManager;
    procedure BuildThemeList;
    procedure ConfigureItem;
  end;

var
  frmThemeList: TfrmThemeList;

const
  cName = 0;
  cReadOnly = 1;
  cWebsite = 2;
  cCopy = 4;
  cEdit = 3;
  cDelete = 5;

implementation

uses uThemeListEditWnd;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmThemeList.FormShow(Sender: TObject);
begin
  BuildThemeList;
end;

procedure TfrmThemeList.FormCreate(Sender: TObject);
begin
  ThemeManager := TThemeManager.Create;
  lbThemeList.DoubleBuffered := True;
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
  LockWindowUpdate(Self.Handle);
  sl := TStringList.Create;
  bmp := TBitmap.Create;
  bmp32 := TBitmap32.Create;

  try
    bmp.Width := ThemeImages.Width;
    bmp.Height := ThemeImages.Height;
    SetBkMode(Bmp.Handle, TRANSPARENT);

    ThemeManager.GetThemeList(sl);

    for i := 0 to Pred(sl.Count) do begin
      tmpTheme := TThemeListItem(sl.Objects[i]);

      newItem := lbThemeList.AddItem('');
      newItem.AddSubItem('');
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
  finally
    LockWindowUpdate(0);
    sl.Free;
    bmp.Free;
    bmp32.Free;
  end;

  CenterUpdateConfigFull;
  CenterUpdateEditTabs(lbThemeList.Count,lbThemeList.ItemIndex);
end;

procedure TfrmThemeList.lbThemeListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpTheme: TThemeListItem;
  s: string;
  tmp: TThemeListItem;
  newID: Integer;
  bDelete: Boolean;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin
  tmpTheme := TThemeListItem(AItem.Data);

  case ACol of
    cName: LoadTheme(tmpTheme);
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
    cDelete: begin

        if lbThemeList.Count = 1 then begin

          MessageDlg('Unable to delete selected theme.' + #13 + #10 + '' + #13 + #10 +
            'There must always be at least one active theme.', mtError,
            [mbOK], 0);
          exit;
        end;

        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmpTheme.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin

            tmp := TThemeListItem(AItem.Data);
            ThemeManager.Delete(tmp.Name);

            if Aitem.id > (frmThemeList.lbThemeList.Count - 2) then begin
              if Aitem.id - 1 >= 0 then
                newID := Aitem.id - 1
              else
                newid := 0;
            end
            else
              newid := Aitem.id;

            BuildThemeList;

            if frmThemeList.lbThemeList.Count <> 0 then
              frmThemeList.lbThemeList.ItemIndex := newId;
          end;
        end;
      end;

  if frmEditItem <> nil then
    frmEditItem.InitUi(frmEditItem.EditMode);

  CenterUpdateEditTabs(lbThemeList.Count,lbThemeList.ItemIndex);
  CenterUpdateConfigFull;

end;

procedure TfrmThemeList.tmrEnableUiTimer(Sender: TObject);
begin
  tmrEnableUi.Enabled := False;
  lbThemeList.Enabled := True;
  FLoading := False;
end;

procedure TfrmThemeList.lbThemeListGetCellCursor(Sender: TObject; const ACol: Integer;
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
      cCopy, cDelete: ACursor := crHandPoint;
    end;
  end;
end;

procedure TfrmThemeList.lbThemeListGetCellImageIndex(Sender: TObject; const ACol: Integer;
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
      cDelete: begin
          AImageIndex := 6;
        end;
    end;
  end;

end;

procedure TfrmThemeList.lbThemeListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpTheme: TThemeListItem;
  s: string;
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
      AColText := Format('%s by %s%s', [tmpTheme.Name, tmpTheme.Author, s]);
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
  begin
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

