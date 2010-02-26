unit ItemsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpEListBoxEx, ImgList, PngImageList, uAliasList,
  SharpAPI, SharpCenterApi, EditWnd, ISharpCenterHostUnit;

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
    FPluginHost: ISharpCenterHost;
    procedure CustomWndProc(var msg: TMessage);
  public
    { Public declarations }
    procedure AddItems;
    property AliasItems: TAliasList read FAliasItems write FAliasItems;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
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

    PluginHost.SetEditTabsVisibility(lbItems.ItemIndex,lbItems.Count);
    PluginHost.Refresh;
  end;
end;

procedure TfrmItemsWnd.FormCreate(Sender: TObject);
var
  srvSettingsPath, sAliasPath: string;
begin
  FWinHandle := Classes.AllocateHWND(CustomWndProc);
  lbItems.DoubleBuffered := True;

  srvSettingsPath := GetSharpeUserSettingsPath + 'SharpCore\Services\Exec\';
  sAliasPath := SrvSettingsPath + 'AliasList.xml';
  FAliasItems := TAliasList.Create;
  FAliasItems.FileName := sAliasPath;
  FAliasItems.Load;
end;

procedure TfrmItemsWnd.CustomWndProc(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suCenter))) then begin
    AddItems;

    PluginHost.Refresh(rtSize);
  end;
end;

procedure TfrmItemsWnd.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := FAliasItems.Count - 1 downto 0 do
    TAliasListItem(FAliasItems[I]).Free;
    
  FAliasItems.Free;
  Classes.DeallocateHWnd(FWinHandle);
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
  FPluginHost.Editing := false;

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
          SharpApi.ServiceMsg('exec','_refresh');
        end;

      end;
    colCopy: begin
        sCopy := 'Copy of ' + tmp.AliasName;
        tmp2 := FAliasItems.AddItem(sCopy, tmp.AliasValue, tmp.Elevate);

        AddItems;
        FAliasItems.Save;
        SharpApi.ServiceMsg('exec','_refresh');

        for i := 0 to Pred(lbItems.Count) do begin
          if tmp2.AliasName = TAliasListItem(lbItems.Item[i].Data).AliasName then begin
            lbItems.ItemIndex := i;
            break;
          end;
        end;
      end;
  end;

  if frmEditWnd <> nil then
    frmEditWnd.Init;

  PluginHost.SetEditTabsVisibility(lbItems.ItemIndex,lbItems.Count);
  PluginHost.Refresh;
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
    0: begin
      if tmp.Elevate then
      AImageIndex := 4 else
      AImageIndex := 3;
    end;
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
  colItemTxt: TColor;
  colDescTxt: TColor;
  colBtnTxt: TColor;
begin
  tmp := TAliasListItem(Aitem.Data);
  if tmp = nil then exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  case ACol of
    colName: begin

      AColText := format('<font color="%s">%s<font color="%s"> - %s',[ColorToString(colItemTxt),
        tmp.AliasName,ColorToString(colDescTxt),tmp.AliasValue]);
    end;
  end;

end;

procedure TfrmItemsWnd.lbItemsResize(Sender: TObject);
begin
  Self.Height := lbItems.Height;
end;

end.

