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

  JclSimpleXml,
  JclStrings,
  jclIniFiles,
  jclFileUtils,

  Windows,
  ExtCtrls,
  Wininet,

  uWeatherOptions,
  uWeatherList,
  SharpApi,
  uSharpXMLUtils;

type
  TDownloadComplete = procedure(tmpInfo: TWeatherItem; path: string) of object;

  TDownloadItem = class
    CompleteProc: TDownloadComplete;
    TmpInfo: TWeatherItem;
    UrlTarget, Target: string;
  end;

  TDownloadThread = class(TThread)
  private
    FDownloadItems: TObjectList;

  protected
    procedure Execute; override;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(CompleteProc: TDownloadComplete; tmpInfo: TWeatherItem; UrlTarget, Target: string);

  end;

  TWeatherMgr = class
  private
    FTimer: TTimer;
    FForce: Boolean;
    FErrorCount: Integer;
    FNextUpdate: Double;
    FWeatherOptions: TWeatherOptions;
    FWeatherList: TWeatherList;

    FDownloadThread: TDownloadThread;

    procedure DownloadCompleteCC(tmpInfo: TWeatherItem; path: string);
    procedure DownloadCompleteForecast(tmpInfo: TWeatherItem; path: string);

    procedure WeatherUpdateCheck(Sender: TObject);
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
  sPOST_URL = 'Website';
  sPOST_Action = 'SOAPAction';
  sPOST_Untitled = 'Untitled' + sPOST_FileExt;
  STRRequest = '  Request: ';
  STRResponse = '  Response: ';
  STRDateTime = '  AT: ';
  STRSeparator = '-----------------------------------------------------------';

var
  WeatherMgr: TWeatherMgr;
  DownloadCritical: TRTLCriticalSection;

procedure Debug(msg: string; errorType: Integer = DMT_INFO);

implementation

uses
  SOAPHTTPTrans;

procedure Debug(msg: string; errorType: Integer);
begin
  SendDebugMessageEx('Weather Service',pchar(msg),clBlack, errorType);
end;

{ TDownloadThread }
constructor TDownloadThread.Create;
begin
  inherited Create(false);

  FDownloadItems := TObjectList.Create;
end;

destructor TDownloadThread.Destroy;
begin
  FDownloadItems.Clear;
  FDownloadItems.Free;

  inherited;
end;

procedure TDownloadThread.Add(CompleteProc: TDownloadComplete; tmpInfo: TWeatherItem; UrlTarget, Target: string);
var
  item: TDownloadItem;
begin
  Debug('Adding ' + UrlTarget, DMT_INFO);

  item := TDownloadItem.Create;
  item.CompleteProc := CompleteProc;
  item.TmpInfo := tmpInfo;
  item.UrlTarget := UrlTarget;
  item.Target := Target;

  EnterCriticalSection(DownloadCritical);
  FDownloadItems.Add(item);
  LeaveCriticalSection(DownloadCritical);

  Debug('Finished Adding ' + UrlTarget, DMT_INFO);
end;

procedure TDownloadThread.Execute;
var
  i: integer;
  item: TDownloadItem;
  Stream: TMemoryStream;
  HTTPReqResp1: THTTPReqResp;
  NoConnectionTimeOut : integer;
begin
  NoConnectionTimeOut := 16;
  while true do
  begin
    if self.Terminated then
      break;

    Sleep(16);

    EnterCriticalSection(DownloadCritical);
    i := FDownloadItems.Count - 1;
    LeaveCriticalSection(DownloadCritical);
  
    while i > 0 do
    begin
      if self.Terminated then
        break;

      Sleep(NoConnectionTimeOut);

      EnterCriticalSection(DownloadCritical);
      item := TDownloadItem(FDownloadItems.Items[i]);
      LeaveCriticalSection(DownloadCritical);

      if not InternetCheckConnection(PAnsiChar(item.UrlTarget), 1, 0) then
      begin
        Debug('No internet connection could be established');
        NoConnectionTimeOut := 60000; // wait one minute before trying again
        continue;
      end else NoConnectionTimeOut := 16;

      Stream := TMemoryStream.Create;
      HTTPReqResp1 := THTTPReqResp.Create(nil);
      try
        try
          HTTPReqResp1.URL := item.UrlTarget;
          HTTPReqResp1.UseUTF8InHeader := False;
          HTTPReqResp1.Execute(item.UrlTarget, Stream);

          Debug(STRSeparator, DMT_INFO);
          Debug(STRRequest + item.Target, DMT_INFO);
          Debug(STRDateTime + DateTimeToStr(now), DMT_INFO);
          Debug(STRSeparator, DMT_INFO);
        except
          Debug(Format('Error downloading %s (Connection Issue)', [item.Target]),
            DMT_ERROR);

          // Remove the last downloaded item
          EnterCriticalSection(DownloadCritical);
          FDownloadItems.Remove(item);
          i := FDownloadItems.Count - 1;
          LeaveCriticalSection(DownloadCritical);
          
          continue;
        end;
      finally
        Stream.SaveToFile(item.Target);

        Stream.Destroy;
        HTTPReqResp1.Free;
      end;

      item.CompleteProc(item.TmpInfo, item.Target);

      // Remove the last downloaded item
      EnterCriticalSection(DownloadCritical);
      FDownloadItems.Remove(item);
      i := FDownloadItems.Count - 1;
      LeaveCriticalSection(DownloadCritical);
    end;
  end;
end;

{ TWeatherMgr }

constructor TWeatherMgr.Create;
var
  interval: Integer;
  iMin: Integer;
begin
  FDownloadThread := TDownloadThread.Create;

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

destructor TWeatherMgr.Destroy;
begin
  FDownloadThread.Terminate;
  FDownloadThread.WaitFor;
  FDownloadThread.Free;

  FTimer.Free;
  FWeatherOptions.Free;
  FWeatherList.Free;
  inherited;
end;

procedure TWeatherMgr.DownloadCompleteCC(tmpInfo: TWeatherItem; path: string);
var
  xml: TJclSimpleXML;
begin
  FNextUpdate := Now + (30 / SecsPerDay);

  // Get Last Icon + Last Temp
  xml := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(xml, path) then
  begin
    tmpInfo.LastIconID :=
      xml.Root.Items.ItemNamed['cc'].Items.ItemNamed['icon'].IntValue;
    tmpInfo.LastTemp :=
      xml.Root.Items.ItemNamed['cc'].Items.ItemNamed['tmp'].IntValue;
  end;
  xml.Free;

  tmpInfo.CCLastUpdated := now;
  FErrorCount := 0;

  WeatherList.SaveSettings;
  SharpApi.BroadcastGlobalUpdateMessage(suCenter);

  SharpEBroadCast(WM_WEATHERUPDATE, 0, 0);
end;

procedure TWeatherMgr.DownloadCompleteForecast(tmpInfo: TWeatherItem; path: string);
begin
  FNextUpdate := Now + (30 / SecsPerDay);

  tmpInfo.FCLastUpdated := now;
  FErrorCount := 0;

  WeatherList.SaveSettings;

  SharpEBroadCast(WM_WEATHERUPDATE, 0, 0);
  SharpApi.BroadcastGlobalUpdateMessage(suCenter);
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
  interval: Integer;
  tmpInfo: TWeatherItem;
const
  MaxErrors = 5;

{$REGION 'Private'}
  fsCCUrl =
    'http://xoap.weather.com/weather/local/%s?&unit=%s&cc=*&link=xoap&prod=xoap&par=1003043975&key=d387802826c0d318';
  fsForecastUrl =
    'http://xoap.weather.com/weather/local/%s?&unit=%s&dayf=10&link=xoap&prod=xoap&par=1003043975&key=d387802826c0d318';
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
          FDownloadThread.Add(DownloadCompleteCC, tmpInfo, url, locpath + 'cc.xml');
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
          FDownloadThread.Add(DownloadCompleteForecast, tmpInfo, url, locpath + 'forecast.xml');
        end;
      end;
    except
      Debug(Format('%s: Forecast.xml update error, error downloading',
        [tmpInfo.LocationID]), DMT_WARN);
    end;
{$ENDREGION}

  end;
end;

initialization
  InitializeCriticalSection(DownloadCritical);

finalization
  DeleteCriticalSection(DownloadCritical);

end.

