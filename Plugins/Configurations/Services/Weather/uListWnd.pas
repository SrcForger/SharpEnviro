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
  uWeatherOptions,
  SharpEListBoxEx, SharpApi, SharpCenterApi, ISharpCenterHostUnit;

type
  TfrmItemswnd = class(TForm)
    imlWeatherGlyphs: TPngImageList;
    lbWeatherList: TSharpEListBoxEx;
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
    procedure FormShow(Sender: TObject);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    FWinHandle: THandle;
    FWeatherList: TWeatherList;
    FWeatherOptions: TWeatherOptions;
    FPluginHost: TInterfacedSharpCenterHostBase;

    { Private declarations }
    function GetWeatherIndex(AWeatherItem: TWeatherItem): Integer;
    procedure CustomWndProc(var msg: TMessage);
  public
    { Public declarations }
    procedure UpdateDisplay;

    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
    property WeatherList: TWeatherList read FWeatherList write FWeatherList;
    property WeatherOptions: TWeatherOptions read FWeatherOptions write FWeatherOptions;
  end;

var
  frmItemswnd: TfrmItemswnd;

const
  colName = 0;
  colStatus = 1;
  colDelete = 2;
  iidxStatus = 13;
  iidxDelete = 14;

implementation

uses
  uEditWnd,
  Types,
  JclFileUtils;

{$R *.dfm}

procedure TfrmItemswnd.UpdateDisplay;
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

    for i := 0 to Pred(FWeatherList.Count) do begin
      tmpWeather := FWeatherList[i];

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

    PluginHost.SetEditTabsVisibility( lbWeatherList.ItemIndex, lbWeatherList.Count );
    PluginHost.Refresh;
  end;
end;

procedure TfrmItemswnd.CustomWndProc(var msg: TMessage);
begin
  if ((msg.Msg = WM_SHARPEUPDATESETTINGS) and (msg.WParam = integer(suCenter))) then begin
    UpdateDisplay;
  end;
end;

procedure TfrmItemswnd.FormCreate(Sender: TObject);
begin
  FWinHandle := Classes.AllocateHWND(CustomWndProc);
  lbWeatherList.DoubleBuffered := True;

  FWeatherList := TWeatherList.Create();
  FWeatherOptions := TWeatherOptions.Create();
end;

procedure TfrmItemswnd.FormDestroy(Sender: TObject);
begin
  Classes.DeallocateHWnd(FWinHandle);

  FWeatherList.Free;
  FWeatherOptions.Free;
end;

procedure TfrmItemswnd.FormShow(Sender: TObject);
begin
  UpdateDisplay;
end;

function TfrmItemswnd.GetWeatherIndex(
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

procedure TfrmItemswnd.lbWeatherListClickItem(Sender: TObject; const ACol: Integer;
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
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmp.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin
          WeatherList.Delete(tmp);
          UpdateDisplay;
          FPluginHost.Save;
        end;

      end;
  end;

  if frmEditWnd <> nil then
    frmEditWnd.Init;

  PluginHost.SetEditTabsVisibility( lbWeatherList.ItemIndex, lbWeatherList.Count );
  PluginHost.Refresh;
end;

procedure TfrmItemswnd.lbWeatherListGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol = colDelete then
    ACursor := crHandPoint;
end;

procedure TfrmItemswnd.lbWeatherListGetCellImageIndex(Sender: TObject;
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

procedure TfrmItemswnd.lbWeatherListGetCellText(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColText: string);
var
  tmp: TWeatherItem;
  sM: string;
  sTemp: string;
  s: string;

  colitemTxt, colDescTxt, colBtnTxt: TColor;
begin
  tmp := TWeatherItem(AItem.Data);
  if tmp = nil then
    exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

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

        s := Format('<font color="%s" />%s<font color="%s" />%s', [colorToString(colItemTxt),
          tmp.Name, colorToString(colDescTxt), sTemp]);
        AColText := s;
      end;
    colStatus: begin
        if ((tmp.FCLastUpdated = '0') or (tmp.FCLastUpdated = '-1')) then
          AColText := format('<font color="%s" />Queued',[colorToString(colBtnTxt)])
        else begin
          s := FormatDateTime('dd mmm hh:nn', StrToDateTime(tmp.FCLastUpdated));
          AColText := format('<font color="%s" />Updated: %s',[colorToString(colBtnTxt),s]);
        end;
      end;
  end;

end;

procedure TfrmItemswnd.lbWeatherListResize(Sender: TObject);
begin
  Self.Height := lbWeatherList.Height;
end;

end.

