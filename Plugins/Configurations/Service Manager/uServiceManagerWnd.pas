{
Source Name: SharpBarBarList
Description: SharpBar Manager Config Window
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

unit uServiceManagerWnd;

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
  Math,
  ImgList,
  PngImageList,
  SharpEListBox,
  SharpEListBoxEx,
  GR32,
  GR32_PNG,
  SharpApi,
  SharpCenterApi,
  ExtCtrls,
  Menus,
  Contnrs,
  Types,
  JclStrings,
  uComponentMan;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

  TAddItemsType = (aiAll, aiEditable, aiDisabled);

  TfrmBarList = class(TForm)
    StatusImages: TPngImageList;
    lbItems: TSharpEListBoxEx;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);

    procedure lbItemsClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure lbItemsResize(Sender: TObject);
    procedure lbItemsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbItemsGetCellText(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem;
      var AColText: string);
  private
    FWinHandle: THandle;
    FAddItemsType: TAddItemsType;
    procedure WndProcHandler(var msg: TMessage);
  private
  public
    FComponentList: TComponentList;
    procedure AddItems( AAddItemsType: TAddItemsType=aiAll);
  end;

var
  frmBarList: TfrmBarList;
const
  colName = 0;
  colStartStop = 1;
  colEnableDisable = 2;
  colEdit = 3;

  iidxStop = 2;
  iidxPause = 1;
  iidxPlay = 0;
  iidxDelete = 6;

implementation

uses SharpThemeApi;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmBarList.lbItemsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  sName: string;

  tmpMetaData: TComponentData;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin

  tmpMetaData := TComponentData(AItem.Data);
  if tmpMetaData = nil then
    exit;

  sName := tmpMetaData.MetaData.Name;
  case ACol of
    colEdit: begin
          CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
            + '\_Services\' + sName + '.con'), '');
      end;
    colStartStop: begin

      if not(tmpMetaData.IsRunning) then begin
        ServiceStart(pchar(sName));
        lbItems.Refresh;
      end else begin
        ServiceStop(pchar(sName));
        lbItems.Refresh;
      end;

      end;
    colEnableDisable: begin

      if tmpMetaData.Disabled then begin
        tmpMetaData.Disabled := False;
        lbItems.Refresh;
      end else begin
        tmpMetaData.Disabled := True;
        ServiceStop(pchar(sName));
        lbItems.Refresh;
      end;
    end;
  end;

  AddItems(FAddItemsType);
end;

procedure TfrmBarList.lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmp: TComponentData;
begin

  tmp := TComponentData(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colStartStop, colEnableDisable: ACursor := crHandPoint;
    colEdit: if tmp.HasConfig then
      ACursor := crHandPoint;
  end;
end;

procedure TfrmBarList.lbItemsGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmp: TComponentData;
  sName: string;
begin

  tmp := TComponentData(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colName: begin
        sName := tmp.MetaData.Name;
        if tmp.IsRunning then
          AImageIndex := iidxPlay
        else if not (tmp.Disabled) then
          AImageIndex := iidxPause
        else if tmp.Disabled then
          AImageIndex := iidxStop;

      end;
  end;
end;

procedure TfrmBarList.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TComponentData;
  sName: String;
begin

  tmp := TComponentData(AItem.Data);
  if tmp = nil then
    exit;

  sName := tmp.MetaData.Name;
  case ACol of
    colName: AColText := sName + '<br><font color="clGray">' + tmp.MetaData.Description;
    colStartStop: begin

        if tmp.Disabled then
          AColText := ''
        else if tmp.IsRunning then
          AColText := '<font color="clNavy"><u>Stop</u>'
        else
          AColText := '<font color="clNavy"><u>Start</u>';
      end;
    colEnableDisable: begin
        if Not(tmp.Disabled) then
          AColText := '<font color="clNavy"><u>Disable</u>'
        else
          AColText := '<font color="clNavy"><u>Enable</u>';
      end;
    colEdit: begin

        if (tmp.HasConfig) then
          AColText := '<font color="clNavy"><u>Edit</u>'
        else
          AColText := ''
      end;
  end;

end;

procedure TfrmBarList.lbItemsResize(Sender: TObject);
begin
  Self.Height := lbItems.Height;
end;

procedure TfrmBarList.FormCreate(Sender: TObject);
begin
  FWinHandle := AllocateHWND(WndProcHandler);
  FComponentList := TComponentList.Create;

  Self.DoubleBuffered := true;
  lbItems.DoubleBuffered := true;
end;

procedure TfrmBarList.FormDestroy(Sender: TObject);
begin
  DeallocateHWnd(FWinHandle);
  FComponentList.Free;
end;

procedure TfrmBarList.WndProcHandler(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suCenter))) then begin
    AddItems(FAddItemsType);
  end;
end;

procedure TfrmBarList.AddItems( AAddItemsType: TAddItemsType=aiAll);
var
  newItem: TSharpEListItem;
  tmp: TComponentData;
  selectedIndex, i: Integer;
  bAdd: Boolean;
begin

  // Get selected item
  LockWindowUpdate(Self.Handle);
  if lbItems.ItemIndex <> -1 then
    selectedIndex := TComponentData(lbItems.Item[lbItems.ItemIndex].Data).ID
  else
    selectedIndex := -1;

  FAddItemsType := AAddItemsType;

  lbItems.Clear;
  FComponentList.BuildList('.service', false);
  FComponentList.Sort(CustomSort);

  for i := 0 to FComponentList.Count - 1 do begin
    tmp := TComponentData(FComponentList[i]);
    bAdd := True;
    case AAddItemsType of
      aiEditable: begin
        if Not(tmp.HasConfig) then
        bAdd := False;
      end;
      aiDisabled: begin
        if Not(tmp.Disabled) then
          bAdd := false;
      end;
    end;

    if bAdd then begin
    newItem := lbItems.AddItem(tmp.MetaData.Name);
    newItem.Data := tmp;
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');

    if tmp.ID = selectedIndex then
      lbItems.ItemIndex := i;
    end;

  end;
  LockWindowUpdate(0);

  CenterUpdateEditTabs(lbItems.Count,lbItems.ItemIndex);
  CenterUpdateSize;
end;

end.

