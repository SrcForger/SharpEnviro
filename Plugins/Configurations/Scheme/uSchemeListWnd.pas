{
Source Name: uSettingsWnd
Description: Configuration window for Scheme Settings
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
unit uSchemeListWnd;

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
  ExtCtrls,
  Spin,
  ComCtrls,
  pngimage,
  Mask,
  ContNrs,
  GR32_Image,
  uEditSchemeWnd,
  JclGraphUtils,
  SharpApi, SharpCenterApi, SharpThemeApi, ImgList, SharpEListBoxEx, PngImageList,
  JvSimpleXML, uSchemeList, BarPreview, Gr32;

type
  TARGB = packed record b, g, r, a: Byte;
  end;

type
  TfrmSchemeList = class(TForm)
    Label3: TLabel;
    lbSchemeList: TSharpEListBoxEx;
    imlCol1: TPngImageList;
    imlCol2: TPngImageList;
    bmlMain: TBitmap32List;
    Timer1: TTimer;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject); 

    procedure lbSchemeListResize(Sender: TObject);
    procedure lbSchemeListClickItem(const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbSchemeListGetCellFont(const ACol: Integer;
      AItem: TSharpEListItem; var AFont: TFont);
    procedure lbSchemeListGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure Timer1Timer(Sender: TObject);

  private
    { Private declarations }

  public
    procedure CreatePreviewBitmap(var ABmp: TBitmap32);

    { Public declarations }
    procedure InitialiseSettings(APluginID: string);
    procedure UpdateEditTabs;
    procedure BuildSchemeList;
  end;

var
  frmSchemeList: TfrmSchemeList;

implementation

uses
  uSEListboxPainter,
  JclStrings,
  SharpFx;

{$R *.dfm}

procedure TfrmSchemeList.UpdateEditTabs;

  procedure BC(AEnabled: Boolean; AButton: TSCB_BUTTON_ENUM);
  begin
    if AEnabled then
      CenterDefineButtonState(AButton, True) else
      CenterDefineButtonState(AButton, False);
  end;

begin
  if lbSchemeList.Count = 0 then
  begin
    BC(False, scbEditTab);
    BC(False, scbDeleteTab);

    if FSchemeManager.GetSkinValid then
      BC(True, scbAddTab) else
      BC(False, scbAddTab);

    lbSchemeList.AddItem('There is no skin defined, please launch the skin configuration first.', 2);
    lbSchemeList.Enabled := False;
  end
  else
  begin
    BC(True, scbAddTab);
    BC(True, scbEditTab);
    BC(True, scbDeleteTab);
    lbSchemeList.Enabled := True;
  end;
end;

procedure TfrmSchemeList.CreatePreviewBitmap(var ABmp: TBitmap32);
var
  bmp: TBitmap32;
  bmpTint: TBitmap32;
  y, x: Integer;
  c: TColor;
  cx, cy: Integer;
  tmpSchemeItem: TSchemeItem;
begin
  bmp := TBitmap32.Create;
  tmpSchemeItem := nil;

  try
    if (frmEditScheme <> nil) then
      tmpSchemeItem := frmEditScheme.SchemeItem
    else
      if lbSchemeList.Item[lbSchemeList.ItemIndex] <> nil then
        tmpSchemeItem :=
          TSchemeItem(lbSchemeList.Item[lbSchemeList.ItemIndex].Data);

    if tmpSchemeItem = nil then
      exit;

    BarPreview.CreateBarPreview(bmp, FSchemeManager.Theme, FSchemeManager.GetSkinName,
      tmpSchemeItem.GetItemAsColorArray(tmpSchemeItem.Colors), 350);

    ABmp.SetSize(bmp.Width, bmp.height);
    Bmp.DrawTo(ABmp);
  finally
    bmp.Free;
  end;
end;

procedure TfrmSchemeList.InitialiseSettings(APluginID: string);
begin
  FSchemeManager.Theme := APluginID;

  lbSchemeList.Margin := Rect(0, 0, 0, 0);
  lbSchemeList.ColumnMargin := Rect(6, 0, 6, 0);
  BuildSchemeList;
  UpdateEditTabs;
end;

procedure TfrmSchemeList.BuildSchemeList;
var
  b: boolean;
  i,iSel: Integer;
  newItem: TSharpEListItem;
  tmpScheme: TSchemeItem;
  sl: TStringList;
begin
  iSel := lbSchemeList.ItemIndex;
  if iSel = -1 then
    iSel := 0;

  lbSchemeList.Clear;
  LockWindowUpdate(Self.Handle);
  Screen.Cursor := crHourGlass;
  sl := TStringList.Create;
  try
    FSchemeManager.GetSchemeList(sl);

    for i := 0 to Pred(sl.Count) do begin
      tmpScheme := TSchemeItem(sl.Objects[i]);

      newItem := lbSchemeList.AddItem(tmpScheme.Name + ' By ' + tmpScheme.Author, 0);
      newItem.AddSubItem('copy');
      newItem.AddSubItem('delete');

      newItem.Data := tmpScheme;
    end;

    // finally select the default theme

    if lbSchemeList.Count <> 0 then begin

      lbSchemeList.ItemIndex := -1;
      for i := 0 to Pred(lbSchemeList.Count) do begin
        if CompareText(TSchemeItem(lbSchemeList.Item[i].Data).Name,
          FSchemeManager.GetDefaultScheme) = 0 then begin
          iSel := i;
          break;
        end;
      end;

      if lbSchemeList.ItemIndex = -1 then
        lbSchemeList.ItemIndex := 0;
    end;

  finally
    lbSchemeList.ItemIndex := iSel;
    lbSchemeList.Update;
    LockWindowUpdate(0);
    Screen.Cursor := crDefault;
    sl.Free;

  end;
end;

procedure TfrmSchemeList.FormCreate(Sender: TObject);
begin
  FSchemeManager := TSchemeManager.Create;
  Self.DoubleBuffered := True;
  lbSchemeList.DoubleBuffered := True;
end;

procedure TfrmSchemeList.FormDestroy(Sender: TObject);
begin
  FSchemeManager.Free;
end;

procedure TfrmSchemeList.lbSchemeListClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpSchemeItem: TSchemeItem;
begin
  if ACol = 0 then begin
  CenterUpdatePreview;
  CenterDefineSettingsChanged;

  if frmEditScheme <> nil then
  begin
    if frmEditScheme.Edit then
    begin
      frmEditScheme.InitUI(sceEdit);
    end;
  end;

  // Set Scheme
  if lbSchemeList.Item[lbSchemeList.ItemIndex] <> nil then
    FSchemeManager.SetDefaultScheme(TSchemeItem(lbSchemeList.Item[lbSchemeList.ItemIndex].Data).Name);

  end else
  if ACol = 1 then begin
    tmpSchemeItem := TSchemeItem(lbSchemeList.Item[lbSchemeList.ItemIndex].Data);
    FSchemeManager.Copy(tmpSchemeItem);
    Timer1.Enabled := True;
  end;

  lbSchemeList.Update;
end;

procedure TfrmSchemeList.lbSchemeListGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > 0 then
    ACursor := crHandPoint;
end;

procedure TfrmSchemeList.lbSchemeListGetCellFont(const ACol: Integer;
  AItem: TSharpEListItem; var AFont: TFont);
begin
  if ACol > 0 then
    AFont.Style := [fsUnderline];
end;

procedure TfrmSchemeList.lbSchemeListResize(Sender: TObject);
begin
  Self.Height := lbSchemeList.Height;
end;

procedure TfrmSchemeList.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  BuildSchemeList;
end;

end.

