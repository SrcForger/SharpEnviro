unit uWeatherMgr;

interface
uses
  Classes,

  ContNrs,
  SysUtils,

  dialogs,
  Forms,

  JvSimpleXml,

  JclStrings,
  jclIniFiles,
  uWeatherList,
  Windows,
  ExtCtrls,
  //httpget,
  jclFileUtils,

  Wininet,

  SharpApi;

type
  TConnectionKind = (ckModem, ckLan, ckProxy, ckRAS, ckModemBusy, ckOtherConnected, ckNotConnected);

type
  TWeatherMgr = class
  private
    Ftimer: TTimer;
    FErrorCount: Integer;
    FNextUpdate: Double;
    procedure Download(UrlTarget: string; Target: string);
    procedure WeatherUpdateCheck(Sender: TObject);
    Function ConnectionKind :TConnectionKind;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ForceUpdate;
    procedure DoneFile(Sender: TObject; FileName: String; FileSize: Integer);

  end;

var
  WeatherMgr: TWeatherMgr;
  force: Boolean = False;

const
  sPOST_FileExt = '.sop';
  sPOST_Filter  = 'SOAP POST Files (*.sop)|*.SOP';
  sPOST_Request = 'Request';
  sPOST_URL     = 'URL';
  sPOST_Action  = 'SOAPAction';
  sPOST_Untitled= 'Untitled' + sPOST_FileExt;
  STRRequest    = '  Request: ';
  STRResponse   = '  Response: ';
  STRDateTime   = '  AT: ';
  STRSeparator  = '-----------------------------------------------------------';

implementation

uses
  uWeatherOptions,SOAPHTTPTrans   ;

{ TWeatherMgr }

Function TWeatherMgr.ConnectionKind :TConnectionKind;
var
 flags: dword;
 bState: Boolean;
begin
  Result := ckOtherConnected;
 bState := InternetGetConnectedState(@flags, 0);
 if bState then
 begin
   if (flags and INTERNET_CONNECTION_MODEM) = INTERNET_CONNECTION_MODEM then
    Result := ckModem else
   if (flags and INTERNET_CONNECTION_LAN) = INTERNET_CONNECTION_LAN then
    Result := ckLan else
   if (flags and INTERNET_CONNECTION_PROXY) = INTERNET_CONNECTION_PROXY then
    Result := ckProxy else
   if (flags and INTERNET_CONNECTION_MODEM_BUSY)=INTERNET_CONNECTION_MODEM_BUSY then
    Result := ckModemBusy;
 end
 else
  Result := ckNotConnected;
end;

constructor TWeatherMgr.Create;
var
  interval:Integer;
begin

  FErrorCount := 0;
  FNextUpdate := -1;
  Ftimer := TTimer.Create(nil);

  // Check for less than 30 seconds, would be too much cpu
  try
  interval := WeatherOptions.CheckInterval*1000;
    if (interval < 30000) then interval := 30000;
  except
    interval := 30000;
  end;

  FTimer.Interval := interval;
  FTimer.OnTimer := WeatherUpdateCheck;
  WeatherUpdateCheck(Self);
end;

destructor TWeatherMgr.Destroy;
begin
  Ftimer.Free;

  inherited;
end;

procedure TWeatherMgr.DoneFile(Sender: TObject; FileName: String;
  FileSize: Integer);
begin
  Debug(format('%s completed: size %d',[filename,filesize]),DMT_TRACE);
end;

procedure TWeatherMgr.Download(UrlTarget: string; Target: string);
var
  Stream: TMemoryStream;
  HTTPReqResp1: THTTPReqResp;
begin

  Stream := TMemoryStream.Create;
  HTTPReqResp1 := THTTPReqResp.Create(nil);
  try
  try

    HTTPReqResp1.URL := UrlTarget;
    HTTPReqResp1.UseUTF8InHeader := False;

    HTTPReqResp1.Execute(UrlTarget, Stream);

    Debug(STRSeparator,DMT_INFO);
    Debug(STRRequest + Target,DMT_INFO);
    Debug(STRDateTime + DateTimeToStr(now),DMT_INFO);
    Debug(STRSeparator,DMT_INFO);

    //StrStream := TStringStream.Create('');
    try
      Stream.SaveToFile(Target);
    finally
      //StrStream.Free;
    end;
  except
    Inc(FErrorCount);
    Debug(Format('Error downloading %s (Connection Issue)',[Target]),DMT_ERROR);
    exit;
  end;
  finally
    Stream.Destroy;
    HTTPReqResp1.Free;

    FNextUpdate := Now + (30 / SecsPerDay);
  end;
end;

procedure TWeatherMgr.ForceUpdate;
begin
  force := true;
  WeatherUpdateCheck(Self);
  force := false;
end;

procedure TWeatherMgr.WeatherUpdateCheck(Sender: TObject);
var
  currentdt, compareddt, tmpd: TDateTime;
  path,locpath, url: string;
  tmps: string;
  i: Integer;
  tmpInfo:TWeatherItem;
  xml:TJvSimpleXML;
  interval: Integer;
const
  MaxErrors = 5;

  fsCCUrl =
    'http://xoap.weather.com/weather/local/%s?&unit=%s&cc=*&prod=xoap&par=1003043975&key=d387802826c0d318';
  fsForecastUrl =
    'http://xoap.weather.com/weather/local/%s?&unit=%s&dayf=10&prod=xoap&par=1003043975&key=d387802826c0d318';
begin
  if now < FNextUpdate then exit;
  
  // If continous errors do not attempt to download
  If FErrorCount > MaxErrors then begin
    Debug('Updating has been disabled due to too many errors, to re-enable'+
      'stop/start the service',DMT_ERROR);
    Exit;
  end;
  
  // check Connection
  Case ConnectionKind of
    ckModem: Debug('Connected via modem: Check Weather Sources',DMT_STATUS);
    ckModemBusy: begin
      Debug('Modem busy: Delayed Updating',DMT_STATUS);
      exit;
    end;
    ckNotConnected: begin
      Debug('No Internet connection: Delayed Updating',DMT_STATUS);
      Exit;
    end;
    ckLan: Debug('Connected via LAN: Check Weather Sources',DMT_STATUS);
    ckProxy: Debug('Connected behind a proxy: Check Weather Sources',DMT_STATUS);
    ckOtherConnected: Debug('Unknown connection to internet: Check Weather Sources',DMT_STATUS);
  end;

  currentdt := now;
  path := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\Data\';
  forcedirectories(path);

  for i := 0 to WeatherList.Count - 1 do begin
    Application.ProcessMessages;
    tmpInfo := WeatherList.Info[i];

    // Check for imperial or metric
    if WeatherOptions.Metric then tmps := 'm' else
      tmps := 's';

    // Check for locationID, Create directory
    if tmpInfo.LocationID = '' then begin
      Debug(Format('%s: LocationID Error, does not exist',[tmpInfo.LocationID]),DMT_WARN);
      break;
    end else begin
      locpath := path + tmpInfo.LocationID + '\';
      forcedirectories(locpath);
    end;

    // Check for CCLastUpdate
    Try

    // Check for less than 30 minutes, must not be less
    Try
      interval := WeatherOptions.CCondInterval;
      if (interval < 30) then interval := 30;
    Except
      Interval := 30;
    End;

    tmpd := StrToFloat(WeatherList.Info[i].CCLastUpdated);
    compareddt := tmpd + (interval / MinsPerDay);
    if (currentdt > compareddt) or not(FileExists(locpath + 'cc.xml')) or force then begin

      if now > FNextUpdate then begin

      Debug(Format('%s: CCUpdate',[tmpInfo.LocationID]),DMT_INFO);
      url := Format(fsCCUrl, [tmpInfo.LocationID,tmps]);
      Download(url, locpath + 'cc.xml');

      // Get Last Icon + Last Temp
      xml := TJvSimpleXML.Create(nil);
      Try
        xml.LoadFromFile(locpath + 'cc.xml');
        tmpInfo.LastIconID :=  xml.Root.Items.ItemNamed['cc'].Items.ItemNamed['icon'].IntValue;
        tmpInfo.LastTemp := xml.Root.Items.ItemNamed['cc'].Items.ItemNamed['tmp'].IntValue;
      finally
        xml.Free;
      end;

      tmpInfo.CCLastUpdated := FloatToStr(now);
      FErrorCount := 0;

      WeatherList.Save;

      SharpEBroadCast(WM_WEATHERUPDATE,0,0);
    end;
    end;
    except
      Debug(Format('%s: CC.xml update error, error downloading',[tmpInfo.LocationID]),DMT_WARN);
    end;

    // Check for FCLastUpdate
    Try

    // Check for less than 2 hours, must not be less
    Try
      interval := WeatherOptions.FCastInterval;
      if (interval < 120) then interval := 120;
    Except
      interval := 120;
    End;

    tmpd := StrToFloat(WeatherList.Info[i].FCLastUpdated);
    compareddt := tmpd + (interval / MinsPerDay);
    if (currentdt > compareddt) or not(FileExists(locpath + 'forecast.xml')) or force then begin
      if now > FNextUpdate then begin

      Debug(Format('%s: FCUpdate',[tmpInfo.LocationID]),DMT_INFO);
      url := Format(fsForecastUrl, [tmpInfo.LocationID,tmps]);
      Download(url, locpath + 'forecast.xml');
      tmpInfo.FCLastUpdated := FloatToStr(now);
      FErrorCount := 0;

      WeatherList.Save;
        
      SharpEBroadCast(WM_WEATHERUPDATE,0,0);
    end;
    end;
    except
      Debug(Format('%s: Forecast.xml update error, error downloading',[tmpInfo.LocationID]),DMT_WARN);
    end;
  end;
end;

end.

