{
Source Name: uFeedDownloadThread.pas
Description: Thread for downloading xml feeds 
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit uFeedDownloadThread;

interface

uses
  Classes,Contnrs,IdHTTP,GR32,SharpApi,SharpImageUtils,MainWnd,JclStrings,
  JclStreams, Windows;

type
  TFeedDownloadThread = class(TThread)
  private
    FOnThreadFinished : TNotifyEvent;
    FMainWnd : TMainForm;
    FUrl : String;
  protected
    procedure Execute; override;
    procedure DoDownload;
  public
    constructor Create(pUrl : String; pMainWnd : TMainForm);
    destructor Destroy; override;
    property OnThreadFinished : TNotifyEvent read FOnThreadFinished write FOnThreadFinished;
  end;

var
  CriticalFeedSection: TRTLCriticalSection;

implementation


{ TImageDownloadThread }

constructor TFeedDownloadThread.Create(pUrl : String; pMainWnd : TMainForm);
begin
  FMainWnd := pMainWnd;
  FUrl := pUrl;

  inherited Create(False);
  FreeOnTerminate := True;
end;

destructor TFeedDownloadThread.Destroy;
begin
  DeleteCriticalSection(CriticalFeedSection);
  if Assigned(FOnThreadFinished) then
    FOnThreadFinished(self);

  inherited Destroy;
end;

procedure TFeedDownloadThread.DoDownload;
var
  idHTTP : TIdHTTP;
  Stream : TMemoryStream;
  MimeList: TStringList;
  validType : boolean;
  success : boolean;
  n: Integer;
begin
  success := False;
  if FMainWnd = nil then
    exit;
  FMainWnd.Feed.Root.Clear();

  MimeList := TStringList.Create;
  MimeList.Clear;
  MimeList.Add('text/plain');
  MimeList.Add('text/xml');
  MimeList.Add('application/xml');
  MimeList.Add('application/rss');
  MimeList.Add('application/rss+xml');
  MimeList.Add('text/xml-external-parsed-entity');
  MimeList.Add('application/xml-external-parsed-entity');
  MimeList.Add('application/xml-dtd');
  idHTTP := TidHTTP.Create(nil);
  idHTTP.ConnectTimeout := 5000;
  idHTTP.Request.Accept := 'text/plain,text/xml,application/xml,text/xml-external-parsed-entity' +
                           'application/xml-external-parsed-entity,application/xml-dtd' +
                           'application/rss,application/rss+xml';
  idHTTP.HandleRedirects := True;
  try
    idHTTP.Head(FURL);
  except
  end;

  validType := False;
  for n := 0 to MimeList.Count - 1 do
    if StrFind(MimeList[n],idHttp.Response.ContentType) > 0 then
    begin
      validType := True;
      break;
    end;
  SharpApi.SendDebugMessage('rssReader.module','Response.ContentType: ' + idHttp.Response.ContentType,0);

  Stream := TMemoryStream.Create;
  if validType then
  begin
    try
      SharpApi.SendDebugMessage('rssReader.module','Starting download: ' + FURL,0);
      idHTTP.Get(FURL,Stream);
      SharpApi.SendDebugMessage('rssReader.module','Download finished',0);
      success := true;
    except
    end;
  end;

  try
    idHttp.Disconnect;
    idHttp.Free;
  except
  end;

  // try to load file
  if FMainWnd <> nil then
  begin
    EnterCriticalSection(CriticalFeedSection);
    
    FMainWnd.FeedValid := False;
    if success then
    begin
      try
        Stream.Position := 0;

        FMainWnd.Feed.LoadFromStream(Stream,seUTF8);
        FMainWnd.FeedValid := True;
        FMainWnd.FeedIndex := 0;
        FMainWnd.UpdateDisplay;
        FMainWnd.UpdateFeedIcon;
        FMainWnd.SyncImagesWithFeed;
      except
        FMainWnd.ErrorMsg := 'Invalid feed file';
      end;
    end else
      FMainWnd.ErrorMsg := 'Error downloading feed';

    LeaveCriticalSection(CriticalFeedSection);
  end;

  Stream.Free;
  MimeList.Free;

  FMainWnd.UpdateTimer.Enabled := True;
end;

procedure TFeedDownloadThread.Execute;
begin
  DoDownload
end;

end.
