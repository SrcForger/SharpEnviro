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
    tmrRefreshItems: TTimer;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure lbSchemeListResize(Sender: TObject);
    procedure lbSchemeListClickItem(const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbSchemeListGetCellCursor(const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure tmrRefreshItemsTimer(Sender: TObject);
    procedure lbSchemeListGetCellText(const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbSchemeListGetCellImageIndex(const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);

  private
    procedure RebuildSchemeList;
    procedure SelectSchemeItem(ASchemeName:String);
    { Private declarations }

  public
    procedure CreatePreviewBitmap(var ABmp: TBitmap32);

    { Public declarations }
    procedure InitialiseSettings(APluginID: string);
    procedure UpdateEditTabs;
    procedure AddItems;
  end;

var
  frmSchemeList: TfrmSchemeList;

const
  cNameColIdx = 0;
  cCopyColIdx = 1;
  cDeleteColIdx = 2;

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
      CenterDefineButtonState(AButton, True)
    else
      CenterDefineButtonState(AButton, False);
  end;

begin
  if lbSchemeList.Count = 0 then begin
    BC(False, scbEditTab);
    BC(False, scbDeleteTab);

    if FSchemeManager.GetSkinValid then
      BC(True, scbAddTab)
    else
      BC(False, scbAddTab);

    lbSchemeList.AddItem('There is no skin defined, please launch the skin configuration first.', 2);
    lbSchemeList.Enabled := False;
  end
  else begin
    BC(True, scbAddTab);
    BC(True, scbEditTab);
    BC(False, scbDeleteTab);
    lbSchemeList.Enabled := True;
  end;
end;

procedure TfrmSchemeList.CreatePreviewBitmap(var ABmp: TBitmap32);
var
  bmp: TBitmap32;
  tmpSchemeItem: TSchemeItem;
begin
  bmp := TBitmap32.Create;
  tmpSchemeItem := nil;

  try
    if (frmEditScheme <> nil) then
      tmpSchemeItem := frmEditScheme.SchemeItem
    else if lbSchemeList.Item[lbSchemeList.ItemIndex] <> nil then
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
  AddItems;
  UpdateEditTabs;
end;

procedure TfrmSchemeList.AddItems;
var
  i, iSel: Integer;
  newItem: TSharpEListItem;
  tmpScheme: TSchemeItem;
  sl: TStringList;
begin
  iSel := lbSchemeList.ItemIndex;
  if iSel = -1 then
    iSel := 0;

  LockWindowUpdate(Self.Handle);
  lbSchemeList.Clear;
  
  Screen.Cursor := crHourGlass;
  sl := TStringList.Create;
  try
    FSchemeManager.GetSchemeList(sl);

    for i := 0 to Pred(sl.Count) do begin
      tmpScheme := TSchemeItem(sl.Objects[i]);

      newItem := lbSchemeList.AddItem(tmpScheme.Name + ' By ' + tmpScheme.Author, 0);
      newItem.AddSubItem('');
      newItem.AddSubItem('');

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

    CenterUpdateSize;
  end;
end;

procedure TfrmSchemeList.RebuildSchemeList;
begin
  try
    AddItems;
  finally
    CenterUpdatePreview;
  end;
end;

procedure TfrmSchemeList.SelectSchemeItem(ASchemeName: String);
var
  i:Integer;
  tmpScheme: TSchemeItem;
begin
  for i := 0 to Pred(lbSchemeList.Count) do begin
    tmpScheme := TSchemeItem(lbSchemeList.Item[i].Data);
    if CompareText(ASchemeName,tmpScheme.Name) = 0 then begin
      lbSchemeList.ItemIndex := i;
      break;
    end;
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
  sNew: String;
begin

  if ACol = cNameColIdx then begin
    CenterUpdatePreview;
    CenterDefineSettingsChanged;

    if frmEditScheme <> nil then begin
      if frmEditScheme.Edit then begin
        frmEditScheme.InitUI(sceEdit);
      end;
    end;

    // Set Scheme
    if AItem <> nil then begin
      FSchemeManager.SetDefaultScheme(TSchemeItem(AItem.Data).Name);
      SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(suScheme), 0);
    end;

  end
  else if ACol = cCopyColIdx then begin
    tmpSchemeItem := TSchemeItem(AItem.Data);
    FSchemeManager.Copy(tmpSchemeItem,sNew);
    RebuildSchemeList;
    
    SelectSchemeItem(sNew);
  end
  else if ACol = cDeleteColIdx then begin
    tmpSchemeItem := TSchemeItem(AItem.Data);

    FSchemeManager.Delete(tmpSchemeItem);
    RebuildSchemeList;
  end;
end;

procedure TfrmSchemeList.lbSchemeListGetCellCursor(const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > cNameColIdx then
    ACursor := crHandPoint;
end;

procedure TfrmSchemeList.lbSchemeListGetCellImageIndex(const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmp: TSchemeItem;
begin
  tmp := TSchemeItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = cCopyColIdx then begin
    AImageIndex := 1;
  end
  else if ACol = cDeleteColIdx then begin
    AImageIndex := 0;
  end

end;

procedure TfrmSchemeList.lbSchemeListGetCellText(const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TSchemeItem;
begin
  tmp := TSchemeItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = cNameColIdx then begin
    if ((tmp.Author <> '') and (tmp.Author <> '...')) then
      AColText := Format('%s by %s', [StrProper(tmp.Name), tmp.Author])
    else
      AColText := Format('%s', [StrProper(tmp.Name)]);
  end;

end;

procedure TfrmSchemeList.lbSchemeListResize(Sender: TObject);
begin
  Self.Height := lbSchemeList.Height;
end;

procedure TfrmSchemeList.tmrRefreshItemsTimer(Sender: TObject);
begin
  tmrRefreshItems.Enabled := False;
  RebuildSchemeList;
end;

end.

