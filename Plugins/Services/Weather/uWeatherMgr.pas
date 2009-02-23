{
Source Name: uWeatherMgr
Description: Weather Management Class
Copyright (C) Pixol (pixol@sharpe-shell.org)

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

unit uWeatherMgr;

interface
uses
  Classes,
  ContNrs,
  SysUtils,
  Graphics,
  Dialogs,
  Forms,

  JvSimpleXml,
  JclStrings,
  jclIniFiles,
  jclFileUtils,

  Windows,
  ExtCtrls,
  Wininet,

  uWeatherOptions,
  uWeatherList,
  SharpApi;

type
  TConnectionKind = (ckModem, ckLan, ckProxy, ckRAS, ckModemBusy,
    ckOtherConnected, ckNotConnected);

type
  TWeatherMgr = class
  private
    FTimer: TTimer;
    FForce: Boolean;
    FErrorCount: Integer;
    FNextUpdate: Double;
    FWeatherOptions: TWeatherOptions;
    FWeatherList: TWeatherList;
    procedure Download(UrlTarget: string; Target: string);
    procedure WeatherUpdateCheck(Sender: TObject);
    function ConnectionKind: TConnectionKind;
    procedure Debug(msg: string; errorType: Integer=DMT_INFO);
  public
    constructor Create;
    destructor Destroy; override;

    procedure ForceUpdate;
    property WeatherOptions: TWeatherOptions read FWeatherOptions write FWeatherOptions;
    property WeatherList: TWeatherList read FWeatherList write FWeatherList;

  end;

const
  sPOST_FileExt = '.sop';
  sPOST_Filter = 'SOAP POST Files (*.sop)|*.SOP';
  sPOST_Request = 'Request';
  sPOST_URL = 'URL';
  sPOST_Action = 'SOAPAction';
  sPOST_Untitled = 'Untitled' + sPOST_FileExt;
  STRRequest = '  Request: ';
  STRResponse = '  Response: ';
  STRDateTime = '  AT: ';
  STRSeparator = '-----------------------------------------------------------';

var
  WeatherMgr: TWeatherMgr;

implementation

uses
  SOAPHTTPTrans;

{ TWeatherMgr }

function TWeatherMgr.ConnectionKind: TConnectionKind;
var
  flags: dword;
  bState: Boolean;
begin
  Result := ckOtherConnected;
  bState := InternetGetConnectedState(@flags, 0);
  if bState then
  begin
    if (flags and INTERNET_CONNECTION_MODEM) = INTERNET_CONNECTION_MODEM then
      Result := ckModem
    else if (flags and INTERNET_CONNECTION_LAN) = INTERNET_CONNECTION_LAN then
      Result := ckLan
    else if (flags and INTERNET_CONNECTION_PROXY) = INTERNET_CONNECTION_PROXY
      then
      Result := ckProxy
    else if (flags and INTERNET_CONNECTION_MODEM_BUSY) =
      INTERNET_CONNECTION_MODEM_BUSY then
      Result := ckModemBusy;
  end
  else
    Result := ckNotConnected;
end;

constructor TWeatherMgr.Create;
var
  interval: Integer;
  iMin: Integer;
begin
  FWeatherList := TWeatherList.Create();
  FWeatherList.FileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\WeatherList.xml';
  FWeatherList.LoadSettings;

  FWeatherOptions := TWeatherOptions.Create();
  FWeatherOptions.FileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\WeatherOptions.xml';
  FWeatherOptions.LoadSettings;

  FErrorCount := 0;
  FNextUpdate := -1;
  iMin := 600000;
  FForce := False;
  Ftimer := TTimer.Create(nil);

  // Check for less than 60 seconds, would be too much cpu
  try
    interval := FWeatherOptions.CheckInterval * 1000;
    if (interval < iMin) then
      interval := iMin;
  except
    interval := iMin;
  end;

  FTimer.Interval := interval;
  FTimer.OnTimer := WeatherUpdateCheck;

  // Check Now
  WeatherUpdateCheck(Self);
end;

procedure TWeatherMgr.Debug(msg: string; errorType: Integer);
begin
  SendDebugMessageEx('Weather Service',pchar(msg),clBlack, errorType);
end;

destructor TWeatherMgr.Destroy;
begin
  FTimer.Free;
  FWeatherOptions.Free;
  FWeatherList.Free;
  inherited;
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

      Debug(STRSeparator, DMT_INFO);
      Debug(STRRequest + Target, DMT_INFO);
      Debug(STRDateTime + DateTimeToStr(now), DMT_INFO);
      Debug(STRSeparator, DMT_INFO);

    except
      Inc(FErrorCount);
      Debug(Format('Error downloading %s (Connection Issue)', [Target]),
        DMT_ERROR);
      exit;
    end;
  finally
    Stream.SaveToFile(Target);

    Stream.Destroy;
    HTTPReqResp1.Free;

    FNextUpdate := Now + (30 / SecsPerDay);
  end;
end;

procedure TWeatherMgr.ForceUpdate;
begin
  FForce := true;

  // Reload
  WeatherList.Clear;
  WeatherList.LoadSettings;
  
  WeatherUpdateCheck(Self);
  FForce := false;
end;

procedure TWeatherMgr.WeatherUpdateCheck(Sender: TObject);
var
  currentdt, compareddt, tmpd: TDateTime;
  path, locpath, url: string;
  tmps: string;
  i: Integer;
  tmpInfo: TWeatherItem;
  xml: TJvSimpleXML;
  interval: Integer;
const
  MaxErrors = 5;

{$REGION 'Private'}
  fsCCUrl =
    'http://xoap.weather.com/weather/local/%s?&unit=%s&cc=*&link=xoap&par=1003043975&key=d387802826c0d318';
  fsForecastUrl =
    'http://xoap.weather.com/weather/local/%s?&unit=%s&dayf=10&link=xoap&par=1003043975&key=d387802826c0d318';
{$ENDREGION}

begin
  if now < FNextUpdate then
    exit;

  // Check so that we do not hammer the server
  {$REGION 'Max Error Check'}
  if FErrorCount > MaxErrors then
  begin
    Debug('Updating has been disabled due to too many errors, to re-enable' +
      'stop/start the service', DMT_ERROR);
    Exit;
  end;
{$ENDREGION}

  {$REGION 'Check Connection Type'}
  case ConnectionKind of
    ckModem: Debug('Connected via modem: Check Weather Sources', DMT_STATUS);
    ckModemBusy:
      begin
        Debug('Modem busy: Delayed Updating', DMT_STATUS);
        exit;
      end;
    ckNotConnected:
      begin
        Debug('No Internet connection: Delayed Updating', DMT_STATUS);
        Exit;
      end;
    ckLan: Debug('Connected via LAN: Check Weather Sources', DMT_STATUS);
    ckProxy: Debug('Connected behind a proxy: Check Weather Sources',
      DMT_STATUS);
    ckOtherConnected:
      Debug('Unknown connection to internet: Check Weather Sources', DMT_STATUS);
  end;
{$ENDREGION}

  currentdt := now;
  path := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\Data\';
  forcedirectories(path);

  for i := 0 to WeatherList.Count - 1 do
  begin
    Application.ProcessMessages;
    tmpInfo := WeatherList[i];

    // Check for imperial or metric
    if tmpInfo.Metric then
      tmps := 'm'
    else
      tmps := 's';

    // Check for locationID, Create directory
    if tmpInfo.LocationID = '' then
    begin
      Debug(Format('%s: LocationID Error, does not exist',
        [tmpInfo.LocationID]), DMT_WARN);
      break;
    end
    else
    begin
      locpath := path + tmpInfo.LocationID + '\';
      forcedirectories(locpath);
    end;

    {$REGION 'Check for CCLastUpdate'}
    try

      // Check for less than 30 minutes, must not be less
      try
        interval := FWeatherOptions.CCondInterval;
        if (interval < 30) then
          interval := 30;
      except
        Interval := 30;
      end;

      tmpd := tmpInfo.CCLastUpdated;

      compareddt := tmpd + (interval / MinsPerDay);
      if (currentdt > compareddt) or not (FileExists(locpath + 'cc.xml')) or
        FForce then
      begin

        if ((now > FNextUpdate) or FForce) then
        begin

          Debug(Format('%s: CCUpdate', [tmpInfo.LocationID]), DMT_INFO);
          url := Format(fsCCUrl, [tmpInfo.LocationID, tmps]);
          Download(url, locpath + 'cc.xml');

          // Get Last Icon + Last Temp
          xml := TJvSimpleXML.Create(nil);
          try
            xml.LoadFromFile(locpath + 'cc.xml');
            tmpInfo.LastIconID :=
              xml.Root.Items.ItemNamed['cc'].Items.ItemNamed['icon'].IntValue;
            tmpInfo.LastTemp :=
              xml.Root.Items.ItemNamed['cc'].Items.ItemNamed['tmp'].IntValue;
          finally
            xml.Free;
          end;

          tmpInfo.CCLastUpdated := now;
          FErrorCount := 0;

          WeatherList.SaveSettings;
          SharpApi.BroadcastGlobalUpdateMessage(suCenter);

          SharpEBroadCast(WM_WEATHERUPDATE, 0, 0);
        end;
      end;
    except
      Debug(Format('%s: CC.xml update error, error downloading',
        [tmpInfo.LocationID]), DMT_WARN);
    end;
{$ENDREGION}

    {$REGION 'Check for FCLastUpdate'}
    try

      // Check for less than 2 hours, must not be less
      try
        interval := FWeatherOptions.FCastInterval;
        if (interval < 120) then
          interval := 120;
      except
        interval := 120;
      end;

      tmpd := tmpInfo.FCLastUpdated;

      compareddt := tmpd + (interval / MinsPerDay);
      if (currentdt > compareddt) or not (FileExists(locpath + 'forecast.xml'))
        or FForce then
      begin
        if ((now > FNextUpdate) or (FForce)) then
        begin

          Debug(Format('%s: FCUpdate', [tmpInfo.LocationID]), DMT_INFO);
          url := Format(fsForecastUrl, [tmpInfo.LocationID, tmps]);
          Download(url, locpath + 'forecast.xml');
          tmpInfo.FCLastUpdated := now;
          FErrorCount := 0;

          WeatherList.SaveSettings;

          SharpEBroadCast(WM_WEATHERUPDATE, 0, 0);
          SharpApi.BroadcastGlobalUpdateMessage(suCenter);
        end;
      end;
    except
      Debug(Format('%s: Forecast.xml update error, error downloading',
        [tmpInfo.LocationID]), DMT_WARN);
    end;
{$ENDREGION}

  end;
end;

end.

