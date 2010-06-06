{
Source Name: uImageDownloadThread.pas
Description: Thread for download images 
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

unit uImageDownloadThread;

interface

uses
  Classes,Contnrs,IdHTTP,GR32,SharpApi,SharpImageUtils;

type
  TImageListItem = class
    Bmp : TBitmap32;
    Url : String;
    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

  TImageDownloadThread = class(TThread)
  private
    FOnFinishedDownload : TNotifyEvent;
    FOnThreadFinished : TNotifyEvent;
    FList : TObjectList;
    FUrl : String;
    FBmp : TBitmap32;
  protected
    procedure Execute; override;
    procedure DoDownload;
    procedure DoCallThreadFinishEvent;
    procedure DoCallFinishedEvent;
  public
    constructor Create(pUrl : String; pList : TObjectList); overload;
    constructor Create(pUrl : String; pBmp : TBitmap32); overload;
    destructor Destroy; override;
    property OnFinishedDownload : TNotifyEvent read FOnFinishedDownload write FOnFinishedDownload;
    property OnThreadFinished : TNotifyEvent read FOnThreadFinished write FOnThreadFinished;
  end;

implementation


{ TImageDownloadThread }

constructor TImageDownloadThread.Create(pUrl : String; pBmp : TBitmap32);
begin
  FOnFinishedDownload := nil;
  FList := nil;
  FUrl := pUrl;
  FBmp := pBmp;

  inherited Create(False);
  FreeOnTerminate := True;
end;

constructor TImageDownloadThread.Create(pUrl: String; pList: TObjectList);
begin
  FOnFinishedDownload := nil;
  FOnThreadFinished := nil;
  FList := pList;
  FUrl := pUrl;
  FBmp := nil;

  inherited Create(False);
  FreeOnTerminate := True;
end;

destructor TImageDownloadThread.Destroy;
begin
  inherited Destroy;
end;

procedure TImageDownloadThread.DoCallFinishedEvent;
begin
  if Assigned(FOnFinishedDownload) then
    FOnFinishedDownload(nil);
end;

procedure TImageDownloadThread.DoCallThreadFinishEvent;
begin
  if Assigned(FOnThreadFinished) then
    FOnThreadFinished(self);
end;

procedure TImageDownloadThread.DoDownload;
var
  idHTTP : TIdHTTP;
  Stream : TMemoryStream;
  Ext : string;
  MimeList: TStringList;
  success : boolean;
  item : TImageListItem;
begin
  success := False;
  
  MimeList := TStringList.Create;
  MimeList.Clear;
  MimeList.Add('image/jpeg');
  MimeList.Add('image/png');
  MimeList.Add('image/bmp');
  MimeList.Add('image/gif');

  idHTTP := TidHTTP.Create(nil);
  idHTTP.ConnectTimeout := 5000;
  idHTTP.Request.Accept := 'image/jpeg,image/png,image/bmp,image/gif';
  idHTTP.HandleRedirects := True;
  try
    idHTTP.Head(FUrl);
  except
  end;

  Stream := TMemoryStream.Create;
  if MimeList.IndexOf(idHttp.Response.ContentType)<>-1 then
  begin
    try
      if idHttp.Response.ContentType = 'image/jpeg' then Ext := '.jpg'
        else if idHttp.Response.ContentType = 'image/png' then Ext := '.png'
        else if idHttp.Response.ContentType = 'image/gif' then Ext := '.gif'
        else Ext := '.bmp';
      SharpApi.SendDebugMessage('ImageDownloadThread','Starting download: ' + FURL,0);
      idHTTP.Get(FURL,Stream);
      SharpApi.SendDebugMessage('ImageDownloadThread.module','Download finished',0);
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
  if success then
  begin
    Stream.Position := 0;  
    if FList <> nil then
    begin
      item := TImageListItem.Create;
      item.Url := FURL;
      if SharpImageUtils.LoadImage(Stream,Ext,item.Bmp) then
      begin
        FList.Add(item);
        Synchronize(DoCallFinishedEvent);
      end else item.Free;
    end else if FBmp <> nil then
    begin
      SharpImageUtils.LoadImage(Stream,Ext,FBmp);
      Synchronize(DoCallFinishedEvent);
    end;
  end;

  Stream.Free;
  MimeList.Free;
end;

procedure TImageDownloadThread.Execute;
begin
  DoDownload;
  Synchronize(DoCallThreadFinishEvent);
end;

{ TImageListItem }

constructor TImageListItem.Create;
begin
  Bmp := TBitmap32.Create;
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
end;

destructor TImageListItem.Destroy;
begin
  Bmp.Free;

  inherited;
end;


end.
