﻿{
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
  ComCtrls,
  pngimage,
  Mask,
  ContNrs,
  GR32_Image,
  uEditSchemeWnd,
  SharpApi,
  SharpCenterApi,
  SharpThemeApi,
  SharpEListBoxEx,
  PngImageList,
  JvSimpleXML,
  uSchemeList,
  BarPreview,
  Gr32,
  ImgList;

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
    procedure lbSchemeListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbSchemeListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure tmrRefreshItemsTimer(Sender: TObject);
    procedure lbSchemeListGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbSchemeListGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);

  private
    procedure SelectSchemeItem(ASchemeName: string);

    { Private declarations }

  public
    procedure CreatePreviewBitmap(var ABmp: TBitmap32);

    { Public declarations }
    procedure RebuildSchemeList;
    procedure InitialiseSettings(APluginID: string);
    procedure AddItems(ATheme: String);

    procedure EditScheme(tmpSchemeItem: TSchemeItem); overload;
    procedure EditScheme(name: string); overload;
  end;

var
  frmSchemeList: TfrmSchemeList;

const
  cNameColIdx = 0;
  cEditColIdx = 1;
  cCopyColIdx = 2;
  cDeleteColIdx = 3;

implementation

uses
  JclStrings,
  SharpFx;

{$R *.dfm}

procedure TfrmSchemeList.CreatePreviewBitmap(var ABmp: TBitmap32);
var
  bmp: TBitmap32;
  tmpSchemeItem: TSchemeItem;
  colors: TSharpEColorSet;
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

    if ( (frmEditScheme <> nil) and (frmEditScheme.EditMode = sceAdd)) then
      XmlGetThemeScheme(XmlGetSkin(FSchemeManager.PluginID), colors) else
      XmlGetThemeScheme(FSchemeManager.PluginID,tmpSchemeItem.Name,colors);

    BarPreview.CreateBarPreview(bmp, FSchemeManager.PluginID, XmlGetSkin(FSchemeManager.PluginID),
      colors, ABmp.Width, true);

    ABmp.SetSize(bmp.Width, bmp.height);
    Bmp.DrawTo(ABmp);
  finally
    bmp.Free;
  end;
end;

procedure TfrmSchemeList.InitialiseSettings(APluginID: string);
begin
  FSchemeManager.PluginID := APluginID;
  RebuildSchemeList;
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

  sl := TStringList.Create;
  try

    FSchemeManager.GetSchemeList(FSchemeManager.PluginID, sl);

    for i := 0 to Pred(sl.Count) do begin
      tmpScheme := TSchemeItem(sl.Objects[i]);

      newItem := lbSchemeList.AddItem(tmpScheme.Name + ' By ' + tmpScheme.Author, 0);
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');

      newItem.Data := tmpScheme;
    end;

    // finally select the default theme
    if lbSchemeList.Count <> 0 then begin

      lbSchemeList.ItemIndex := -1;
      for i := 0 to Pred(lbSchemeList.Count) do begin
        if CompareText(TSchemeItem(lbSchemeList.Item[i].Data).Name,
          XmlGetScheme(FSchemeManager.PluginID)) = 0 then begin
          iSel := i;
          break;
        end;
      end;

      if lbSchemeList.ItemIndex = -1 then
        lbSchemeList.ItemIndex := 0;
    end;

  finally

    if iSel < lbSchemeList.Count then
      lbSchemeList.ItemIndex := iSel else
      lbSchemeList.ItemIndex := 0;

    XmlSetScheme(FSchemeManager.PluginID, TSchemeItem(lbSchemeList.Item[lbSchemeList.ItemIndex].Data).Name);
    SharpCenterApi.BroadcastGlobalUpdateMessage(suScheme, 0);

    LockWindowUpdate(0);
    sl.Free;

    CenterUpdateEditTabs(lbSchemeList.Count,lbSchemeList.ItemIndex);
    CenterUpdateConfigFull;
  end;
end;

procedure TfrmSchemeList.EditScheme(tmpSchemeItem: TSchemeItem);
begin
  CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory + '\_Themes\SchemeEdit.con'), pchar(FSchemeManager.PluginID + ':' + tmpSchemeItem.Name));
end;

procedure TfrmSchemeList.EditScheme(name: String);
begin
  CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory + '\_Themes\SchemeEdit.con'), pchar(FSchemeManager.PluginID + ':' + name));
end;

procedure TfrmSchemeList.RebuildSchemeList;
begin
  tmrRefreshItems.Enabled := True;
end;

procedure TfrmSchemeList.SelectSchemeItem(ASchemeName: string);
var
  i: Integer;
  tmpScheme: TSchemeItem;
begin
  for i := 0 to Pred(lbSchemeList.Count) do begin
    tmpScheme := TSchemeItem(lbSchemeList.Item[i].Data);
    if CompareText(ASchemeName, tmpScheme.Name) = 0 then begin
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

procedure TfrmSchemeList.lbSchemeListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpSchemeItem: TSchemeItem;
  sNew: string;
  bDelete: Boolean;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin
  if ACol = cNameColIdx then begin

    // Set Scheme
    if AItem <> nil then begin
      XmlSetScheme(FSchemeManager.PluginID, TSchemeItem(AItem.Data).Name);
      SharpCenterApi.BroadcastGlobalUpdateMessage(suScheme, 0);
    end;

  end
  else if ACol = cCopyColIdx then begin
    tmpSchemeItem := TSchemeItem(AItem.Data);
    FSchemeManager.Copy(tmpSchemeItem, sNew);
    RebuildSchemeList;

    SelectSchemeItem(sNew);
  end
  else if ACol = cDeleteColIdx then begin

    if lbSchemeList.Count = 1 then begin
      MessageDlg('Unable to delete selected scheme.' + #13 + #13 + 'There must always be one active scheme.', mtError, [mbOK], 0);
      Exit;
    end;

    tmpSchemeItem := TSchemeItem(AItem.Data);

    bDelete := True;
    if not (CtrlDown) then
      if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmpSchemeItem.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
        bDelete := False;

    if bDelete then begin
      FSchemeManager.Delete(tmpSchemeItem);
      RebuildSchemeList;
    end;
  end
  else if ACol = cEditColIdx then begin
    tmpSchemeItem := TSchemeItem(AItem.Data);
    EditScheme(tmpSchemeItem);
  end;


  if frmEditScheme <> nil then
    frmEditScheme.InitUi(frmEditScheme.EditMode);

  CenterUpdateEditTabs(lbSchemeList.Count,lbSchemeList.ItemIndex);
  CenterUpdateConfigFull;
end;

procedure TfrmSchemeList.lbSchemeListGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > cNameColIdx then
    ACursor := crHandPoint;
end;

procedure TfrmSchemeList.lbSchemeListGetCellImageIndex(Sender: TObject; const ACol: Integer;
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

procedure TfrmSchemeList.lbSchemeListGetCellText(Sender: TObject; const ACol: Integer;
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
  if ACol = cEditColIdx then
    AColText := '<font color="clNavy"><u>Edit</u> </font>';

end;

procedure TfrmSchemeList.lbSchemeListResize(Sender: TObject);
begin
  Self.Height := lbSchemeList.Height;
end;

procedure TfrmSchemeList.tmrRefreshItemsTimer(Sender: TObject);
begin
  tmrRefreshItems.Enabled := False;
  AddItems(FSchemeManager.PluginID);
end;

end.

