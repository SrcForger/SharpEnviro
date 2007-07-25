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
    procedure lbWeatherListClickItem(AText: string; AItem, ACol: Integer);
    procedure FormResize(Sender: TObject);
    procedure img1Click(Sender: TObject);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    { Private declarations }
    function GetWeatherIndex(AWeatherItem: TWeatherItem): Integer;
  public
    { Public declarations }
    procedure UpdateDisplay(AData: TWeatherList);
    procedure UpdateEditTabs;

    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmItemsList: TfrmItemsList;

implementation

uses
  uWeatherOptionsWnd,
  uWeatherOptions,
  uWeatherItemEditWnd,
  Types,
  JclFileUtils,
  uSEListboxPainter;

{$R *.dfm}

procedure TfrmItemsList.UpdateDisplay(AData: TWeatherList);
var
  i: Integer;
  n: Integer;
  newItem: TSharpEListItem;
  tmpWeather: TWeatherItem;
  s, sTemp, sM: String;
begin
  n := lbWeatherList.ItemIndex;
  lbWeatherList.Clear;

  for i := 0 to Pred(AData.Count) do begin
    tmpWeather := AData.Info[i];

    if WeatherOptions.Metric then
      sM := 'C' else
      sM := 'F';

    if tmpWeather.LastTemp = -1 then
      sTemp := '' else
      sTemp := Format(' (%d%s)',[tmpWeather.LastTemp,sM]);

    s := Format('%s%s',[tmpWeather.Location,sTemp]);
    newItem := lbWeatherList.AddItem(s,GetWeatherIndex(tmpWeather));

    if ((tmpWeather.FCLastUpdated = '0') or (tmpWeather.FCLastUpdated = '-1')) then
    newItem.AddSubItem('Queued',13) else
    newItem.AddSubItem(tmpWeather.FCLastUpdated);
    newItem.Data := tmpWeather;

  end;
  if (n = -1) or (n > lbWeatherList.Items.Count - 1) then
    n := 0;

  if lbWeatherList.Count <> 0 then
    lbWeatherList.ItemIndex := n;
end;

procedure TfrmItemsList.img1Click(Sender: TObject);
begin
  SharpExecute('http://www.weather.com/?prod=xoap&par=1003043975')
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

procedure TfrmItemsList.FormResize(Sender: TObject);
var
  w: Integer;
begin
  if lbWeatherList.ColumnCount = 0 then exit;

  w := lbWeatherList.Width;
  lbWeatherList.Column[0].Width := w-180;
  lbWeatherList.Column[1].Width := 170;
end;

procedure TfrmItemsList.UpdateEditTabs;

  procedure BC(AEnabled:Boolean; AButton:TSCB_BUTTON_ENUM);
  begin
    if AEnabled then
    CenterDefineButtonState(Abutton,True) else
    CenterDefineButtonState(Abutton,False)
  end;

begin
  if ((lbWeatherList.Count = 0) or (lbWeatherList.ItemIndex = -1)) then
  begin
    BC(False, scbEditTab);

    if (lbWeatherList.Count = 0) then begin
      BC(False, scbDeleteTab);

      if frmItemEdit <> nil then
        frmItemEdit.pagEdit.Show;

      CenterSelectEditTab(scbAddTab);
    end;

    BC(True, scbAddTab);

  end
  else
  begin
    BC(True, scbAddTab);
    BC(True, scbEditTab);
    BC(True, scbDeleteTab);
  end;
end;

procedure TfrmItemsList.lbWeatherListClickItem(AText: string; AItem,
  ACol: Integer);
begin
  if frmItemEdit <> nil then
    frmItemEdit.InitUi(FEditMode);
end;

end.

