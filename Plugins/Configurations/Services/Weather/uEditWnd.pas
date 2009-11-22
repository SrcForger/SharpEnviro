unit uEditWnd;

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
  pngimage,
  uWeatherList,
  PngSpeedButton,
  SharpEListBoxEx,
  SharpApi,
  SharpCenterApi, ISharpCenterHostUnit, JvXPCore,
  JvXPCheckCtrls, JvExControls, StdCtrls, ExtCtrls, Buttons, Menus;

type
  TWeatherLocation = class
    Location: string;
    LocationID: string;
  end;

type
  TfrmEditWnd = class(TForm)
    mnuSearch: TPopupMenu;
    btnSearch: TPngSpeedButton;
    edLocation: TLabeledEdit;
    edWeatherID: TLabeledEdit;
    Image1: TImage;
    chkMetric: TJvXPCheckbox;
    JvLabel1: TLabel;

    procedure UpdateEditState(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    FItemEdit: TWeatherItem;
    FUpdating: Boolean;
    FPluginHost: ISharpCenterHost;
    procedure DownloadLocationData(Location: string);
    procedure UpdateSearchList(AResults: string);
    procedure Debug(Str: string; ErrorType: Integer);
    procedure ClickItem(Sender: TObject);
  public
    { Public declarations }
    procedure Init;
    procedure Save;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
    property ItemEdit: TWeatherItem read FItemEdit write FItemEdit;
  end;

var
  frmEditWnd: TfrmEditWnd;

implementation

uses
  uListWnd,
  uWeatherOptions,
  uWeatherMgr,
  SOAPHTTPTrans,
  JclSimpleXml;

{$R *.dfm}

{ TForm1 }

procedure TfrmEditWnd.DownloadLocationData(Location: string);
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

procedure TfrmEditWnd.UpdateSearchList(AResults: string);
var
  xml: TJclSimpleXML;
  n: integer;
  tmpWl: TWeatherLocation;
  newMi: TMenuItem;
  sErrType: string;
  cp: TPoint;
begin
  mnuSearch.Items.Clear;

  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromString(AResults);

    // check for errors
    if Xml.Root.Items.Count = 0 then begin
      newMi := TMenuItem.Create(nil);
      newMi.Caption := 'No Items Found';
      newMi.Tag := -1;
      mnuSearch.Items.Add(newMi);
    end
    else if Xml.Root.Name = 'error' then begin

      if Xml.Root.Items.ItemNamed['err'] <> nil then
        sErrType := Xml.Root.Items.ItemNamed['err'].Value;

      newMi := TMenuItem.Create(nil);
      newMi.Caption := sErrType;
      newMi.Tag := -1;
      mnuSearch.Items.Add(newMi);
    end
    else begin
      for n := 0 to XML.Root.Items.Count - 1 do begin
        tmpWl := TWeatherLocation.Create;
        tmpWl.Location := XML.Root.Items.Item[n].Value;
        tmpWl.LocationID :=
          Xml.Root.Items.Item[n].Properties.ItemNamed['id'].Value;

        newMi := TMenuItem.Create(nil);
        newMi.Caption := tmpWl.Location;
        newMi.Tag := Integer(tmpWl);
        newMi.OnClick := ClickItem;
        mnuSearch.Items.Add(newMi);

        tmpWl.Free;
      end;
    end;

  finally
    xml.Free;
    cp := btnSearch.Parent.ClientToScreen(Point(btnSearch.Left +
      btnSearch.Width, btnSearch.Top));
    mnuSearch.Popup(cp.x, cp.y);
  end;
end;

procedure TfrmEditWnd.Debug(Str: string; ErrorType: Integer);
begin
  SendDebugMessageEx('Weather Service', PChar(Str), 0, ErrorType);
end;

procedure TfrmEditWnd.btnSearchClick(Sender: TObject);
begin
  if edLocation.Text = '' then
    exit;

  DownloadLocationData(edLocation.Text);
end;

procedure TfrmEditWnd.ClickItem(Sender: TObject);
var
  tmpWeather: TWeatherLocation;
begin
  tmpWeather := TWeatherLocation(TMenuItem(Sender).Tag);
  if tmpWeather = nil then
    exit;

  edLocation.Text := tmpWeather.Location;
  edWeatherID.Text := tmpWeather.LocationID;
end;

procedure TfrmEditWnd.Image1Click(Sender: TObject);
begin
  SharpExecute('http://www.weather.com/?prod=xoap&par=1003043975');
end;

procedure TfrmEditWnd.Init;
var
  tmpItem: TSharpEListItem;
  tmpWeather: TWeatherItem;
begin
  FUpdating := True;
  try

    case FPluginHost.EditMode of
      sceAdd: begin
          edLocation.Text := '';
          edWeatherID.Text := '';
          chkMetric.Checked := True;

          FItemEdit := nil;
        end;
      sceEdit: begin

          if frmItemswnd.lbWeatherList.ItemIndex = -1 then
            exit;

          tmpItem := frmItemswnd.lbWeatherList.Item[frmItemswnd.lbWeatherList.ItemIndex];
          tmpWeather := TWeatherItem(tmpItem.Data);
          FItemEdit := tmpWeather;

          edLocation.Text := tmpWeather.Location;
          edWeatherID.Text := tmpWeather.LocationID;
          chkMetric.Checked := tmpWeather.Metric;
        end;
    end;

  finally
    FUpdating := False;
  end;
end;

procedure TfrmEditWnd.Save;
var
  tmpItem: TSharpEListItem;
  tmpWeather: TWeatherItem;
begin
  case FPluginHost.EditMode of
    sceAdd: begin

        frmItemswnd.WeatherList.AddItem(edLocation.Text, edWeatherID.Text, -1, -1, -1, -1, True, chkMetric.Checked);
        FPluginHost.Save;

        // Force the service to update
        frmItemswnd.UpdateDisplay;
        SharpApi.ServiceMsg('weather', '_forceupdate');

      end;
    sceEdit: begin
        tmpItem := frmItemswnd.lbWeatherList.Item[frmItemswnd.lbWeatherList.ItemIndex];
        tmpWeather := TWeatherItem(tmpItem.Data);
        tmpWeather.Location := edLocation.Text;
        tmpWeather.LocationID := edWeatherID.Text;
        tmpWeather.Metric := chkMetric.Checked;

        frmItemswnd.UpdateDisplay;
        FPluginHost.Save;

      end;
  end;

  frmItemswnd.PluginHost.Refresh();
end;

procedure TfrmEditWnd.UpdateEditState(Sender: TObject);
begin
  if Not(FUpdating) then
    frmItemswnd.PluginHost.SetEditing(true);
end;

end.

