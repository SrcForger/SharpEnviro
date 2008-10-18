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
  ImgList,
  PngImageList,
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
  SharpThemeApi,
  SharpGraphicsUtils,
  pngimage,
  Jcldatetime,
  DateUtils,

  ISharpCenterHostUnit, AppEvnts;

type
  TfrmList = class(TForm)
    ThemeImages: TPngImageList;
    lbThemeList: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    tmrEnableUi: TTimer;
    SelectedThemeImages: TPngImageList;
    tmrLoadTheme: TTimer;
    ApplicationEvents1: TApplicationEvents;
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
    procedure Button1Click(Sender: TObject);
    procedure LoadThemeOnTimer(Sender: TObject);
  private
    FLoading: Boolean;
    FPluginHost: TInterfacedSharpCenterHostBase;
    FPngMissing: TPNGObject;
    FMask: TBitmap32;
    procedure LoadTheme(tmpTheme: TThemeListItem);
    procedure GenerateMask;

    
  public
    ThemeManager: TThemeManager;
    procedure BuildThemeList;
    procedure ConfigureItem;

    procedure EditTheme( name: String);
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
  end;

var
  frmList: TfrmList;

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
{$R ThemeListGlyphs.res}

{ TfrmConfigListWnd }

procedure TfrmList.FormShow(Sender: TObject);
begin
  
  FPngMissing.LoadFromResourceName(HInstance,'THEMELIST_MISSING_PNG');

  GenerateMask;

  BuildThemeList;
end;

procedure TfrmList.FormCreate(Sender: TObject);
begin
  ThemeManager := TThemeManager.Create;
  lbThemeList.DoubleBuffered := True;
  Self.DoubleBuffered := true;
  FPngMissing := TPNGObject.Create;
  FMask := TBitmap32.Create;
end;

procedure TfrmList.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := pred(lbThemeList.Count) downto 0 do begin
    TThemeListItem(lbThemeList.Item[i].Data).Free;
    lbThemeList.DeleteItem(i);
  end;

  ThemeManager.Free;
  FPngMissing.Free;
  FMask.Free;
end;

procedure TfrmList.BuildThemeList;
var
  Bmp: TBitmap;
  Bmp32: TBitmap32;
  b: boolean;
  i: Integer;
  newItem: TSharpEListItem;
  tmpThemeInfo: TThemeInfo;
  themes: TThemeInfoSet;

begin
  lbThemeList.Clear;
  LockWindowUpdate(Self.Handle);

  bmp := TBitmap.Create;
  bmp32 := TBitmap32.Create;

  try
    bmp.Width := ThemeImages.Width;
    bmp.Height := ThemeImages.Height;
    SetBkMode(Bmp.Handle, TRANSPARENT);

    Setlength(themes,0);
    XmlGetThemeList(themes);

    for i := 0 to high(themes) do begin
      tmpThemeInfo := themes[i];

      newItem := lbThemeList.AddItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');

      newItem.Data := TThemeListItem.Create(tmpThemeInfo);
      //bmp32.Clear(clWhite32);
      bmp32.DrawMode := dmBlend;
      bmp32.CombineMode := cmMerge;

      if ((tmpThemeInfo.Preview <> '') and
        (FileExists(tmpThemeInfo.Preview))) then begin

        GR32_PNG.LoadBitmap32FromPNG(Bmp32, tmpThemeInfo.Preview, b);

        GenerateMask;
        ReplaceColor32(FMask,color32(128,128,128,255),Color32(FPluginHost.Theme.PluginItem));
        FMask.DrawTo(Bmp32, Rect(0, 0, 62, 48));
        bmp32.DrawTo(bmp.canvas.handle, Rect(0, 0, 62, 48), bmp32.ClipRect);

        newItem.SubItemImageIndexes[0] := pointer(themeimages.AddMasked(bmp, clFuchsia));

        GenerateMask;
        ReplaceColor32(FMask,color32(128,128,128,255),Color32(FPluginHost.Theme.PluginSelectedItem));
        FMask.DrawTo(Bmp32, Rect(0, 0, 62, 48));
        bmp32.DrawTo(bmp.canvas.handle, Rect(0, 0, 62, 48), bmp32.ClipRect);

        newItem.SubItemSelectedImageIndexes[0] := pointer(SelectedThemeImages.AddMasked(bmp, clFuchsia));
      end
      else begin

        bmp.Canvas.Brush.Color := FPluginHost.Theme.PluginItem;
        bmp.Canvas.Pen.Color := FPluginHost.Theme.PluginItem;
        bmp.canvas.FillRect(bmp.canvas.ClipRect);

        FpngMissing.Draw(Bmp.Canvas, bmp.Canvas.ClipRect);

        newItem.SubItemImageIndexes[0] :=
          Pointer(themeimages.AddMasked(bmp, FPluginHost.Theme.PluginItem));

        bmp.Canvas.Brush.Color := FPluginHost.Theme.PluginSelectedItem;
        bmp.Canvas.Pen.Color := FPluginHost.Theme.PluginSelectedItem;
        bmp.canvas.FillRect(bmp.canvas.ClipRect);

        FpngMissing.Draw(Bmp.Canvas, bmp.Canvas.ClipRect);

        newItem.SubItemSelectedImageIndexes[0] :=
          Pointer(selectedthemeimages.AddMasked(bmp, FPluginHost.Theme.PluginSelectedItem));

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

    bmp.Free;
    bmp32.Free;
  end;

  FPluginHost.SetEditTabsVisibility(lbThemeList.ItemIndex,lbThemeList.Count);
  FPluginHost.Refresh( rtAll );
end;

procedure TfrmList.lbThemeListClickItem(Sender: TObject; const ACol: Integer;
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

  if FPluginHost.Editing then exit;

  case ACol of
    cName: begin
      tmrLoadTheme.Enabled := True;
      exit;
    end;
    cReadOnly: ;
    cEdit: begin
        if not (tmpTheme.ReadOnly) then
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

            if Aitem.id > (lbThemeList.Count - 2) then begin
              if Aitem.id - 1 >= 0 then
                newID := Aitem.id - 1
              else
                newid := 0;
            end
            else
              newid := Aitem.id;

            BuildThemeList;

            if lbThemeList.Count <> 0 then
              lbThemeList.ItemIndex := newId;
          end;
        end;
      end;

  if frmEdit<> nil then
    frmEdit.InitUi;

  FPluginHost.SetEditTabsVisibility(lbThemeList.ItemIndex,lbThemeList.Count);
  FPluginHost.Refresh( rtAll );
  FPluginHost.Refresh( rtTitle );

end;

procedure TfrmList.tmrEnableUiTimer(Sender: TObject);
begin
  tmrEnableUi.Enabled := False;
  lbThemeList.Enabled := True;
  FLoading := False;
end;

procedure TfrmList.LoadThemeOnTimer(Sender: TObject);
begin
  tmrLoadTheme.Enabled := False;
  LoadTheme(TThemeListItem(lbThemeList.SelectedItem.Data));
end;

procedure TfrmList.lbThemeListGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmpTheme: TThemeListItem;
begin
  tmpTheme := TThemeListItem(AItem.Data);
    if tmpTheme <> nil then begin

    case ACol of
      cWebsite: begin
          if tmpTheme.Website <> '' then
            ACursor := crHandPoint;
        end;
      cEdit: begin

          if not (tmpTheme.ReadOnly) then
            ACursor := crHandPoint;
        end;
      cCopy, cDelete: ACursor := crHandPoint;
    end;
    end;
end;

procedure TfrmList.lbThemeListGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmpTheme: TThemeListItem;
begin

  tmpTheme := TThemeListItem(AItem.Data);
  if tmpTheme <> nil then begin

    case ACol of
      cReadOnly: begin
          if tmpTheme.ReadOnly then
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

procedure TfrmList.lbThemeListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpTheme: TThemeListItem;
  s: string;
  colItemTxt: TColor;
  colDescTxt: TColor;
  colBtnTxt: TColor;
begin
  tmpTheme := TThemeListItem(AItem.Data);
  if tmpTheme <> nil then begin

    AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

    case ACol of
      cEdit: begin
        AColText := format('<font color="%s"><u>Edit</u>',[ColorToString(colBtnTxt)]);
      end;

      cName: begin

        s := '';
        if ((FLoading) and (AItem.ID = lbThemeList.ItemIndex)) then
          AColText := format('<font color="%s">Loading %s...',[ColorToString(colItemTxt),tmpTheme.Name]) else

        AColText := Format('<font color="%s">%s<font color="%s"> by %s%s',
          [ColorToString(colItemTxt), tmpTheme.Name, ColorToString(colDescTxt), tmpTheme.Author, s]);

      end;
    end;
  end;

end;

procedure TfrmList.Button1Click(Sender: TObject);
var
  skinCols: TSharpEColorSet;
begin
  SetLength(skinCols,0);
  XmlGetThemeScheme(skinCols);
end;

procedure TfrmList.ConfigureItem;
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

procedure TfrmList.EditTheme(name: String);
begin
  CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
      + '_Themes\Theme.con'), pchar(name))
end;

procedure TfrmList.GenerateMask;
var
  TempBmp: TBitmap32;
  ResStream: TResourceStream;
  b: Boolean;
begin

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(62, 48);
  TempBmp.Clear(color32(0, 0, 0, 0));
  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  ResStream := TResourceStream.Create(HInstance, 'THEMELIST_MASK_PNG', RT_RCDATA);
  LoadBitmap32FromPng(TempBmp, ResStream, b);
  FMask.Assign(tempBmp);
  ResStream.Free;

  TempBmp.Free;
end;

procedure TfrmList.LoadTheme(tmpTheme: TThemeListItem);
begin
  begin
    lbThemeList.Enabled := False;
    tmrEnableUi.Enabled := True;

    FLoading := True;
    ThemeManager.SetTheme(tmpTheme.Name);
    SharpCenterApi.BroadcastGlobalUpdateMessage(suTheme, -1, True);
  end;
end;

procedure TfrmList.lbThemeListResize(Sender: TObject);
begin
  Self.Height := lbThemeList.Height;
end;

end.

