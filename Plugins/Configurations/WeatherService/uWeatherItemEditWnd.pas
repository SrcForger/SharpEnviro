unit uWeatherItemEditWnd;

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
  Buttons,
  pngimage,
  uWeatherList,
  jvSimpleXml,
  PngSpeedButton,
  JvPageList,
  JvExControls,
  SharpEListBoxEx,
  Menus,
  SharpApi, JvLabel, ImgList, PngImageList, JvValidators,
  JvComponentBase, JvErrorIndicator, SharpCenterApi;

type
  TWeatherLocation = class
    Location: string;
    LocationID: string;
  end;

type
  TfrmItemEdit = class(TForm)
    plMain: TJvPageList;
    pagEdit: TJvStandardPage;
    pagDelete: TJvStandardPage;
    edName: TLabeledEdit;
    btnSearch: TPngSpeedButton;
    edWeatherID: TLabeledEdit;
    mnuSearch: TPopupMenu;
    chkMetric: TCheckBox;
    Label1: TJvLabel;
    Label2: TLabel;
    errorinc: TJvErrorIndicator;
    vals: TJvValidators;
    valID: TJvRequiredFieldValidator;
    valName: TJvRequiredFieldValidator;
    pilError: TPngImageList;

    procedure UpdateEditState(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    { Private declarations }
    FItemEdit: TWeatherItem;
    procedure DownloadLocationData(Location: string);
    procedure UpdateSearchList(AResults: string);
    procedure Debug(Str: string; ErrorType: Integer);
    procedure ClickItem(Sender: TObject);
  public
    { Public declarations }
    procedure InitUi(AEditMode: TSCE_EDITMODE_ENUM; AChangePage: Boolean =
      False);
    function ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;
    function Save(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM): Boolean;
  end;

var
  frmItemEdit: TfrmItemEdit;

implementation

uses
  uWeatherItemsListWnd,
  uWeatherOptions,
  uWeatherMgr,
  SOAPHTTPTrans,
  JclSimpleXml;

{$R *.dfm}

{ TForm1 }

procedure TfrmItemEdit.DownloadLocationData(Location: string);
var
  Stream: TMemoryStream;
  StrStream: TStringStream;
  HTTPReqResp1: THTTPReqResp;
  UrlTarget: string;
begin
  Stream := TMemoryStream.Create;
  HTTPReqResp1 := THTTPReqResp.Create(Self);
  try
    try
      HTTPReqResp1.UseUTF8InHeader := False;

      UrlTarget := Format('http://xoap.weather.com/search/search?where=%s',
        [Location]);
      HTTPReqResp1.URL := UrlTarget;
      HTTPReqResp1.Execute(UrlTarget, Stream);

      Debug(STRSeparator, DMT_INFO);
      Debug(STRRequest + UrlTarget, DMT_INFO);
      Debug(STRDateTime + DateTimeToStr(now), DMT_INFO);
      Debug(STRSeparator, DMT_INFO);

      StrStream := TStringStream.Create('');
      StrStream.CopyFrom(Stream, 0);
      try

        UpdateSearchList(StrStream.DataString);
      finally
        StrStream.Free;
      end;
    except
      Debug(Format('Error Searching for %s (Connection Issue)', [Location]),
        DMT_ERROR);
      exit;
    end;
  finally
    Stream.Free;
    HTTPReqResp1.Free;
  end;
end;

procedure TfrmItemEdit.UpdateSearchList(AResults: string);
var
  xml: TJvSimpleXML;
  n: integer;
  tmpWl: TWeatherLocation;
  newMi: TMenuItem;
  sErrType: string;
  cp: TPoint;
begin
  mnuSearch.Items.Clear;

  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromString(AResults);

    // check for errors
    if Xml.Root.Items.Count = 0 then
    begin
      newMi := TMenuItem.Create(nil);
      newMi.Caption := 'No Items Found';
      newMi.Tag := -1;
      mnuSearch.Items.Add(newMi);
    end
    else if Xml.Root.Name = 'error' then
    begin

      if Xml.Root.Items.ItemNamed['err'] <> nil then
        sErrType := Xml.Root.Items.ItemNamed['err'].Value;

      newMi := TMenuItem.Create(nil);
      newMi.Caption := sErrType;
      newMi.Tag := -1;
      mnuSearch.Items.Add(newMi);
    end
    else
    begin
      for n := 0 to XML.Root.Items.Count - 1 do
      begin
        tmpWl := TWeatherLocation.Create;
        tmpWl.Location := XML.Root.Items.Item[n].Value;
        tmpWl.LocationID :=
          Xml.Root.Items.Item[n].Properties.ItemNamed['id'].Value;

        newMi := TMenuItem.Create(nil);
        newMi.Caption := tmpWl.Location;
        newMi.Tag := Integer(tmpWl);
        newMi.OnClick := ClickItem;
        mnuSearch.Items.Add(newMi);
      end;
    end;

  finally
    xml.Free;
    cp := btnSearch.Parent.ClientToScreen(Point(btnSearch.Left +
      btnSearch.Width, btnSearch.Top));
    mnuSearch.Popup(cp.x, cp.y);
  end;
end;

procedure TfrmItemEdit.Debug(Str: string; ErrorType: Integer);
begin
  SendDebugMessageEx('Weather Service', PChar(Str), 0, ErrorType);
end;

procedure TfrmItemEdit.btnSearchClick(Sender: TObject);
begin
  DownloadLocationData(edWeatherID.Text);
end;

procedure TfrmItemEdit.ClickItem(Sender: TObject);
var
  tmpWeather: TWeatherLocation;
begin
  tmpWeather := TWeatherLocation(TMenuItem(Sender).Tag);
  if tmpWeather = nil then
    exit;

  edName.Text := tmpWeather.Location;
  edWeatherID.Text := tmpWeather.LocationID;
end;

procedure TfrmItemEdit.InitUi(AEditMode: TSCE_EDITMODE_ENUM;
  AChangePage: Boolean);
var
  tmpItem: TSharpEListItem;
  tmpWeather: TWeatherItem;
begin
  edName.OnChange := nil;
  edWeatherID.OnChange := nil;
  chkMetric.OnClick := nil;
  try

    case AEditMode of
      sceAdd:
        begin
          edName.Text := '';
          edWeatherID.Text := '';
          chkMetric.Checked := WeatherOptions.Metric;

          if AChangePage then
            pagEdit.Show;

          if pagEdit.Visible then
            edName.SetFocus;

          FItemEdit := nil;
        end;
      sceEdit:
        begin

          if frmItemsList.lbWeatherList.ItemIndex = -1 then
            exit;

          tmpItem := frmItemsList.lbWeatherList.Item[frmItemsList.lbWeatherList.ItemIndex];
          tmpWeather := TWeatherItem(tmpItem.Data);
          FItemEdit := tmpWeather;

          edName.Text := tmpWeather.Location;
          edWeatherID.Text := tmpWeather.LocationID;
          chkMetric.Checked := WeatherOptions.Metric;

          if AChangePage then
            pagEdit.Show;

          if pagEdit.Visible then
            edName.SetFocus;
        end;
    end;

  finally
    edName.OnChange := UpdateEditState;
    edWeatherID.OnChange := UpdateEditState;
    chkMetric.OnClick := UpdateEditState;

    if frmItemsList.lbWeatherList.SelectedItem <> nil then begin
      CenterDefineButtonState(scbEditTab, True);
    end
    else begin
      CenterDefineButtonState(scbEditTab, False);
      CenterSelectEditTab(scbAddTab);

      edName.Text := '';
      edWeatherID.Text := '';
    end;

  end;
end;

procedure TfrmItemEdit.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

function TfrmItemEdit.ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := False;

  case AEditMode of
    sceAdd, sceEdit:
      begin

        errorinc.BeginUpdate;
        try
          errorinc.ClearErrors;
          vals.ValidationSummary := nil;

          Result := vals.Validate;
        finally
          errorinc.EndUpdate;
        end;
      end;
    sceDelete: Result := True;
  end;
end;

function TfrmItemEdit.Save(AApply: Boolean;
  AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  tmpItem:TSharpEListItem;
  tmpWeather: TWeatherItem;
begin
  Result := false;
  if Not(AApply) then Exit;

  case AEditMode of
  sceAdd: begin

    WeatherList.Add(edName.Text,edWeatherID.Text,'-1','-1',-1,-1,True);
    WeatherOptions.Metric := chkMetric.Checked;

    CenterDefineSettingsChanged;
    frmItemsList.UpdateDisplay(WeatherList);
    WeatherList.Save;
    WeatherOptions.Save;

    // Force the service to update
    SharpApi.ServiceMsg('weather','_forceupdate');

    Result := True;
  end;
  sceEdit: begin
    tmpItem := frmItemsList.lbWeatherList.Item[frmItemsList.lbWeatherList.ItemIndex];
    tmpWeather := TWeatherItem(tmpItem.Data);
    tmpWeather.Location := edName.Text;
    tmpWeather.LocationID := edWeatherID.Text;
    WeatherOptions.Metric := chkMetric.Checked;

    CenterDefineSettingsChanged;
    frmItemsList.UpdateDisplay(WeatherList);
    WeatherList.Save;
    WeatherOptions.Save;

    Result := True;
  end;
  end;
end;

procedure TfrmItemEdit.UpdateEditState(Sender: TObject);
begin
  CenterDefineEditState(True);
end;

end.

