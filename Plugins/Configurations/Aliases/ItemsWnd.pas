unit ItemsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpEListBoxEx, ImgList, PngImageList, uExecServiceAliasList,
  SharpAPI, SharpCenterApi, EditWnd;

type
  TfrmItemsWnd = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilIcons: TPngImageList;
    procedure lbItemsResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbItemsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbItemsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbItemsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
  private
    { Private declarations }
    FAliasItems: TAliasList;
    FWinHandle: THandle;
    procedure WndProc(var msg: TMessage);
  public
    { Public declarations }
    procedure AddItems;
    procedure UpdateEditTabs;
    property AliasItems: TAliasList read FAliasItems write FAliasItems;

  end;

var
  frmItemsWnd: TfrmItemsWnd;

const
  colName = 0;
  colLocked = 1;
  colCopy = 2;
  colDelete = 3;
  iidxCopy = 0;
  iidxDelete = 1;
  iidxLocked = 2;

implementation

{$R *.dfm}

procedure TfrmItemsWnd.AddItems;
var
  i: Integer;
  tmpItem: TSharpEListItem;
  sName: string;
begin
  LockWindowUpdate(Self.Handle);
  try

    sName := '';
    if lbItems.ItemIndex <> -1 then begin
      sName := TAliasListItem(lbItems.SelectedItem.Data).AliasName;
    end;

    lbItems.Clear;
    FAliasItems.Sort;

    for i := 0 to Pred(FAliasItems.Count) do begin
      tmpItem := lbItems.AddItem('');
      tmpItem.AddSubItem('');
      tmpItem.AddSubItem('');
      tmpItem.AddSubItem('');
      tmpItem.Data := FAliasItems[i];
    end;

    if sName <> '' then begin
      for i := 0 to Pred(lbItems.Count) do begin
        if sName = TAliasListItem(lbItems.Item[i].Data).AliasName then begin
          lbItems.ItemIndex := i;
          break;
        end;
      end;
    end
    else if lbItems.Count <> 0 then
      lbItems.ItemIndex := 0;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmItemsWnd.FormCreate(Sender: TObject);
var
  srvSettingsPath, sAliasPath: string;
begin
  FWinHandle := AllocateHWND(WndProc);

  srvSettingsPath := GetSharpeUserSettingsPath + 'SharpCore\Services\Exec\';
  sAliasPath := SrvSettingsPath + 'AliasList.xml';
  FAliasItems := TAliasList.Create(sAliasPath);
end;

procedure TfrmItemsWnd.WndProc(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suCenter))) then begin
    AddItems;
    CenterUpdateSize;
  end;
end;

procedure TfrmItemsWnd.FormDestroy(Sender: TObject);
begin
  FAliasItems.Free;
  DeallocateHWnd(FWinHandle);
end;

procedure TfrmItemsWnd.FormShow(Sender: TObject);
begin
  AddItems;
end;

procedure TfrmItemsWnd.lbItemsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp, tmp2: TAliasListItem;
  bDelete: Boolean;
  sCopy: string;
  i: Integer;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin
  tmp := TAliasListItem(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colDelete: begin
        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmp.AliasName]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin
          FAliasItems.Delete(tmp);

          AddItems;
          FAliasItems.Save;

          CenterDefineSettingsChanged;
        end;

      end;
    colCopy: begin
        sCopy := 'Copy of ' + tmp.AliasName;
        tmp2 := FAliasItems.Add(sCopy, tmp.AliasValue, tmp.Elevate);

        AddItems;
        FAliasItems.Save;

        for i := 0 to Pred(lbItems.Count) do begin
          if tmp2.AliasName = TAliasListItem(lbItems.Item[i].Data).AliasName then begin
            lbItems.ItemIndex := i;
            break;
          end;
        end;

        CenterDefineSettingsChanged;
      end;
  end;

  if lbItems.SelectedItem <> nil then begin
    CenterDefineButtonState(scbEditTab, True);
  end
  else begin
    CenterDefineButtonState(scbEditTab, False);
  end;

  if frmEditWnd <> nil then
    frmEditWnd.InitUi(frmEditWnd.EditMode);

  CenterUpdateTabs;
  CenterUpdateSize;
end;

procedure TfrmItemsWnd.lbItemsGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol >= colCopy then
    ACursor := crHandPoint;
end;

procedure TfrmItemsWnd.lbItemsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmp: TAliasListItem;
begin
  tmp := TAliasListItem(Aitem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colCopy: AImageIndex := iidxCopy;
    colDelete: AImageIndex := iidxDelete;
    colLocked: if tmp.Elevate then
        AImageIndex := iidxLocked;
  end;
end;

procedure TfrmItemsWnd.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TAliasListItem;
begin
  tmp := TAliasListItem(Aitem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colName: AColText := Format('%s (%s)', [tmp.AliasName, tmp.AliasValue]);
  end;

end;

procedure TfrmItemsWnd.lbItemsResize(Sender: TObject);
begin
  Self.Height := lbItems.Height;
end;

procedure TfrmItemsWnd.UpdateEditTabs;

  procedure BC(AEnabled: Boolean; AButton: TSCB_BUTTON_ENUM);
  begin
    if AEnabled then
      CenterDefineButtonState(AButton, True)
    else
      CenterDefineButtonState(AButton, False);
  end;

begin
  if ((lbItems.Count = 0) or (lbItems.ItemIndex = -1)) then begin
    BC(False, scbEditTab);

    if (lbItems.Count = 0) then begin
      BC(False, scbDeleteTab);
      CenterSelectEditTab(scbAddTab);
    end;

    BC(True, scbAddTab);

  end
  else begin
    BC(True, scbAddTab);
    BC(True, scbEditTab);
  end;
end;
end.

