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
unit uListWnd;

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
  uEditWnd,
  SharpApi,
  SharpCenterApi,
  SharpCenterThemeApi,
  SharpThemeApiEx,
  SharpEListBoxEx,
  PngImageList,
  JvSimpleXML,
  uISharpETheme,
  uThemeConsts,
  uSchemeList,
  BarPreview,
  Gr32,

  ISharpCenterHostUnit, ImgList;

type
  TARGB = packed record b, g, r, a: Byte;
  end;

const
  WM_EVENTS = WM_USER + 123;

type
  TfrmListWnd = class(TForm)
    Label3: TLabel;
    lbSchemeList: TSharpEListBoxEx;
    imlCol2: TPngImageList;
    bmlMain: TBitmap32List;
    tmrSendUpdate: TTimer;
    tmrSetScheme: TTimer;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure lbSchemeListResize(Sender: TObject);
    procedure lbSchemeListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbSchemeListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbSchemeListGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbSchemeListGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure tmrSendUpdateTimer(Sender: TObject);
    procedure tmrSetSchemeTimer(Sender: TObject);

  private
    FPluginHost: ISharpCenterHost;
    procedure SelectSchemeItem(ASchemeName: string);

    { Private declarations }
    procedure EventsMessageHandler(var Msg: TMessage); message WM_EVENTS;
  public
    procedure CreatePreviewBitmap(var ABmp: TBitmap32);

    { Public declarations }
    procedure RebuildSchemeList;
    procedure InitialiseSettings(Theme : ISharpETheme);
    procedure AddItems(ATheme: String);

    procedure EditScheme(tmpSchemeItem: TSchemeItem); overload;
    procedure EditScheme(name: string); overload;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmListWnd: TfrmListWnd;

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

procedure TfrmListWnd.CreatePreviewBitmap(var ABmp: TBitmap32);
var
  bmp: TBitmap32;
  tmpSchemeItem: TSchemeItem;
begin
  bmp := TBitmap32.Create;
  tmpSchemeItem := nil;

  try
    if (frmEditWnd <> nil) then
      tmpSchemeItem := frmEditWnd.SchemeItem
    else if lbSchemeList.Item[lbSchemeList.ItemIndex] <> nil then
      tmpSchemeItem :=
        TSchemeItem(lbSchemeList.Item[lbSchemeList.ItemIndex].Data);

    if tmpSchemeItem = nil then
      exit;

    CreateBarPreview(bmp, FSchemeManager.PluginID, FSchemeManager.Theme.Skin.Name,
      tmpSchemeItem.Name, 150, FSchemeManager.Theme, true );

    ABmp.SetSize(bmp.Width, bmp.height);
    Bmp.DrawTo(ABmp);
  finally
    bmp.Free;
  end;
end;

procedure TfrmListWnd.InitialiseSettings(Theme : ISharpETheme);
begin
  FSchemeManager.PluginID := FPluginHost.PluginId;
  FSchemeManager.Theme := Theme;
  RebuildSchemeList;
end;

procedure TfrmListWnd.AddItems;
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
          FSchemeManager.Theme.Scheme.Name) = 0 then begin
          iSel := i;
          break;
        end;
      end;
    end;

  finally

    if iSel < lbSchemeList.Count then
      lbSchemeList.ItemIndex := iSel
    else begin
      lbSchemeList.ItemIndex := 0;
      SharpApi.BroadcastGlobalUpdateMessage(suScheme, 0, True);
    end;

    //XmlSetScheme(FSchemeManager.PluginID, TSchemeItem(lbSchemeList.Item[lbSchemeList.ItemIndex].Data).Name);

    LockWindowUpdate(0);
    sl.Free;

    PluginHost.SetEditTabsVisibility( lbSchemeList.ItemIndex,lbSchemeList.Count);
    //PluginHost.Refresh;
  end;
end;

procedure TfrmListWnd.EditScheme(tmpSchemeItem: TSchemeItem);
begin
  CenterCommand(sccLoadSetting,
				PChar('Themes'),
				PChar('SchemeEdit'),
				PChar(FSchemeManager.PluginID + ':' + tmpSchemeItem.Name));
end;

procedure TfrmListWnd.EditScheme(name: String);
begin
  CenterCommand(sccLoadSetting,
				PChar('Themes'),
				PChar('SchemeEdit'),
				PChar(FSchemeManager.PluginID + ':' + name));
end;

procedure TfrmListWnd.EventsMessageHandler(var Msg: TMessage);
begin
  SharpApi.BroadcastGlobalUpdateMessage(suScheme, 0);
end;

procedure TfrmListWnd.RebuildSchemeList;
begin
  //tmrRefreshItems.Enabled := True;
  AddItems(FSchemeManager.PluginID);
end;

procedure TfrmListWnd.SelectSchemeItem(ASchemeName: string);
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

procedure TfrmListWnd.FormCreate(Sender: TObject);
begin
  FSchemeManager := TSchemeManager.Create;
  Self.DoubleBuffered := True;
  lbSchemeList.DoubleBuffered := True;
end;

procedure TfrmListWnd.FormDestroy(Sender: TObject);
begin
  FSchemeManager.Theme := nil;
  FSchemeManager.Free;
end;

procedure TfrmListWnd.lbSchemeListClickItem(Sender: TObject; const ACol: Integer;
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
      tmrSetScheme.Enabled := true;
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

  if frmEditWnd <> nil then
    frmEditWnd.InitUi;

  PluginHost.SetEditTabsVisibility( lbSchemeList.ItemIndex,lbSchemeList.Count);
  PluginHost.Refresh(rtPreview);
end;

procedure TfrmListWnd.lbSchemeListGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > cNameColIdx then
    ACursor := crHandPoint;
end;

procedure TfrmListWnd.lbSchemeListGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmp: TSchemeItem;
begin
  tmp := TSchemeItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = 0 then
    AImageIndex := 2;
  if ACol = cCopyColIdx then begin
    AImageIndex := 1;
  end
  else if ACol = cDeleteColIdx then begin
    AImageIndex := 0;
  end

end;

procedure TfrmListWnd.lbSchemeListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TSchemeItem;
	colItemTxt, colDescTxt, colBtnTxt: TColor;
begin

  tmp := TSchemeItem(AItem.Data);
  if tmp = nil then
    exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);
  if ACol = cNameColIdx then begin
    if ((tmp.Author <> '') and (tmp.Author <> '...')) then
      AColText := Format('<font color="%s">%s <font color="%s">By %s', [ColorToString(colItemTxt),
        StrProper(tmp.Name),ColorToString(colDescTxt), tmp.Author])
    else
      AColText := Format('<font color="%s">%s', [ColorToString(colItemTxt), StrProper(tmp.Name)]);
  end;
  if ACol = cEditColIdx then
    AColText := format('<font color="%s"><u>Edit</u> </font>',[ColorToString(colBtnTxt)]);

end;

procedure TfrmListWnd.lbSchemeListResize(Sender: TObject);
begin
  Self.Height := lbSchemeList.Height;
  FPluginHost.Refresh(rtSize);
end;

procedure TfrmListWnd.tmrSendUpdateTimer(Sender: TObject);
begin
  tmrSendUpdate.enabled := false;
  //SharpCenterApi.BroadcastGlobalUpdateMessage(suScheme, 0);
end;

procedure TfrmListWnd.tmrSetSchemeTimer(Sender: TObject);
var
  tmp:TSchemeItem;
begin
  tmrSetScheme.Enabled := false;
  tmp := TSchemeItem(lbSchemeList.SelectedItem.Data);
  FSchemeManager.Theme.Scheme.Name := tmp.Name;
  FSchemeManager.Theme.Scheme.SaveToFile;

  PostMessage(self.Handle,WM_EVENTS,0,0);
  PluginHost.Refresh(rtPreview);
end;

end.

