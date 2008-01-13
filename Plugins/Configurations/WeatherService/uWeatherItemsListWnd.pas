unit uWeatherItemsListWnd;

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
  pngimage,

  ExtCtrls,
  Buttons,
  ImgList,
  ComCtrls,
  ToolWin,
  JvExControls,
  JvComponent,
  JvGradientHeaderPanel,
  GR32,
  sharpfx,
  JclGraphics,
  JvHtControls,
  JvExStdCtrls,
  Grids,
  PngSpeedButton,
  PngImageList,
  uWeatherList,
  SharpEListBoxEx, SharpApi, SharpCenterApi;

type
  TfrmItemsList = class(TForm)
    imlWeatherGlyphs: TPngImageList;
    lbWeatherList: TSharpEListBoxEx;

    procedure img1Click(Sender: TObject);
    procedure lbWeatherListResize(Sender: TObject);
    procedure lbWeatherListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbWeatherListGetCellImageIndex(Sender: TObject;
      const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbWeatherListGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbWeatherListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    FWinHandle: THandle;
    { Private declarations }
    function GetWeatherIndex(AWeatherItem: TWeatherItem): Integer;
    procedure CustomWndProc(var msg: TMessage);
  public
    { Public declarations }
    procedure UpdateDisplay(AData: TWeatherList);

    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmItemsList: TfrmItemsList;

const
  colName = 0;
  colStatus = 1;
  colDelete = 2;
  iidxStatus = 13;
  iidxDelete = 14;

implementation

uses
  uWeatherOptionsWnd,
  uWeatherOptions,
  uWeatherItemEditWnd,
  Types,
  JclFileUtils;

{$R *.dfm}

procedure TfrmItemsList.UpdateDisplay(AData: TWeatherList);
var
  i: Integer;
  n: Integer;
  newItem: TSharpEListItem;
  tmpWeather: TWeatherItem;
  s: string;
begin
  LockWindowUpdate(Self.Handle);
  try
    n := lbWeatherList.ItemIndex;
    lbWeatherList.Clear;

    for i := 0 to Pred(AData.Count) do begin
      tmpWeather := AData.Info[i];

      newItem := lbWeatherList.AddItem(s, GetWeatherIndex(tmpWeather));
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.Data := tmpWeather;

    end;
    if (n = -1) or (n > lbWeatherList.Items.Count - 1) then
      n := 0;

    if lbWeatherList.Count <> 0 then
      lbWeatherList.ItemIndex := n;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmItemsList.img1Click(Sender: TObject);
begin
  SharpExecute('http://www.weather.com/?prod=xoap&par=1003043975')
end;

procedure TfrmItemsList.CustomWndProc(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suCenter))) then begin
    UpdateDisplay(WeatherList);
    CenterUpdateSize;
  end;
end;

procedure TfrmItemsList.FormCreate(Sender: TObject);
begin
  FWinHandle := AllocateHWND(CustomWndProc);
  lbWeatherList.DoubleBuffered := True;
end;

procedure TfrmItemsList.FormDestroy(Sender: TObject);
begin
  DeallocateHWnd(FWinHandle);
end;

function TfrmItemsList.GetWeatherIndex(
  AWeatherItem: TWeatherItem): Integer;
begin
  Result := 10;
  if AWeatherItem.LastIconID = -1 then
    exit;

  case AWeatherItem.LastIconID of
    0, 3, 4, 17, 35, 37, 38, 47: Result := 6;
    1, 2, 5, 7, 10, 12, 39, 40: Result := 9;
    8, 9, 11, 6, 18: Result := 7;
    13, 14, 15, 16, 41, 42, 43, 46: Result := 8;
    31, 33: Result := 1;
    27, 29: Result := 3;
    26: Result := 4;
    28, 30, 44: Result := 2;
    32, 36, 34: Result := 0;
  else
    Result := 10;
  end;
end;

procedure TfrmItemsList.lbWeatherListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TWeatherItem;
  bDelete: Boolean;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;
begin
  tmp := TWeatherItem(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colDelete: begin
        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmp.Location]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin
          WeatherList.Delete(tmp);
          UpdateDisplay(WeatherList);
          WeatherList.Save;
          WeatherOptions.Save;

          CenterDefineSettingsChanged;
        end;

      end;
  end;

  if lbWeatherList.SelectedItem <> nil then begin
    CenterDefineButtonState(scbEditTab, True);
  end
  else begin
    CenterDefineButtonState(scbEditTab, False);
  end;

  if frmItemEdit <> nil then
    frmItemEdit.InitUi(FEditMode);

  CenterUpdateConfigFull;
end;

procedure TfrmItemsList.lbWeatherListGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol = colDelete then
    ACursor := crHandPoint;
end;

procedure TfrmItemsList.lbWeatherListGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmp: TWeatherItem;
begin
  tmp := TWeatherItem(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colName: AImageIndex := GetWeatherIndex(tmp);
    colStatus: if ((tmp.FCLastUpdated = '0') or (tmp.FCLastUpdated = '-1')) then
        AImageIndex := iidxStatus;
    colDelete: AImageIndex := iidxDelete;
  end;
end;

procedure TfrmItemsList.lbWeatherListGetCellText(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColText: string);
var
  tmp: TWeatherItem;
  sM: string;
  sTemp: string;
  s: string;
begin
  tmp := TWeatherItem(AItem.Data);
  if tmp = nil then
    exit;

  if tmp.Metric then
    sM := 'C'
  else
    sM := 'F';

  case ACol of
    colName: begin
        if tmp.LastTemp = -1 then
          sTemp := ''
        else
          sTemp := Format(' (%d%s)', [tmp.LastTemp, sM]);

        s := Format('%s%s', [tmp.Location, sTemp]);
        AColText := s;
      end;
    colStatus: begin
        if ((tmp.FCLastUpdated = '0') or (tmp.FCLastUpdated = '-1')) then
          AColText := 'Queued'
        else begin
          s := FormatDateTime('dd mmm hh:nn', StrToDateTime(tmp.FCLastUpdated));
          AColText := 'Updated: ' + s;
        end;
      end;
  end;

end;

procedure TfrmItemsList.lbWeatherListResize(Sender: TObject);
begin
  Self.Height := lbWeatherList.Height;
end;

end.

