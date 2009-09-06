{
Source Name: MediaPlayerList.pas
Description: List of all supported Media Players
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

unit MediaPlayerList;

interface

uses
  Windows,SysUtils,GR32,Contnrs,Dialogs,JclSimpleXML;

type
  TSendMessageType = (smtAppCommand, smtCommand, smtKey);
  
  TMediaPlayerItem = class
  private
    procedure LoadIcon(pIconFile : String);
  public
    Name : String;
    Icon : TBitmap32;
    WndClassName : String;
    WndCaption : String;
    WndSubClass : String;
    MessageType : TSendMessageType;
    Command  : integer;
    btnPlay  : integer;
    btnPause : integer;
    btnStop  : integer;
    btnNext  : integer;
    btnPrev  : integer;
    PlayerPath : String;
    RegPath : String;
    RegValue : String;

    constructor Create(pXML : TJclSimpleXMLElems);
    destructor Destroy; override;
  end;

  TMediaPlayerList = class
  private
    FItems : TObjectList;
  public
    procedure Load;
    function GetItem(pName : String) : TMediaPlayerItem; overload;
    function GetItem(pWndClass,pWndCaption : String) : TMediaPlayerItem; overload;    
    function GetPlayerHandle(pName : String) : hwnd;

    constructor Create;
    destructor Destroy; override;

    property Items : TObjectList read FItems;
  end;

implementation

uses
  SharpApi,GR32_PNG,Graphics;

{ FMediaPlayerList }

constructor TMediaPlayerList.Create;
begin
  inherited Create;

  FItems := TObjectList.Create(True);
  FItems.Clear;

  Load;
end;

destructor TMediaPlayerList.Destroy;
begin
  FItems.Free;

  inherited Destroy;
end;

function TMediaPlayerList.GetItem(pName: String): TMediaPlayerItem;
var
  n : integer;
  item : TMediaPlayerItem;
begin
  result := nil;
  for n := 0 to FItems.Count - 1 do
  begin
    item := TMediaPlayerItem(FItems[n]);
    if CompareText(item.Name,pName) = 0 then
    begin
      result := item;
      exit;
    end;
  end;
end;

function TMediaPlayerList.GetItem(pWndClass, pWndCaption: String): TMediaPlayerItem;
var
  n : integer;
  item : TMediaPlayerItem;
begin
  result := nil;
  for n := 0 to FItems.Count - 1 do
  begin
    item := TMediaPlayerItem(FItems[n]);
    if CompareText(item.WndClassName,pWndClass) = 0 then
    begin
      result := item;
      exit;
    end;
  end;
end;

function TMediaPlayerList.GetPlayerHandle(pName: String): hwnd;
var
  item : TMediaPlayerItem;
  wnd : hwnd;
begin
  item := GetItem(pName);
  wnd := 0;
  if item <> nil then
  begin
    if length(trim(item.WndClassName)) <> 0 then
    begin
      wnd := FindWindow(PChar(item.WndClassName), nil);
      if length(trim(item.WndSubClass)) <> 0 then
        wnd := FindWindowEx(wnd,0,PChar(item.WndSubClass),PChar(item.WndSubClass));
    end;
    if (wnd = 0) and (length(trim(item.WndCaption)) <> 0) then
      wnd := FindWindow(nil,PChar(item.WndCaption));
  end;

  result := wnd;
end;

procedure TMediaPlayerList.Load;
var
  XML : TJclSimpleXML;
  src : String;
  fileloaded : boolean;
  n : integer;
  newitem : TMediaPlayerItem;
begin
  FItems.Clear;

  src := SharpApi.GetSharpeGlobalSettingsPath + 'SharpCore\Services\MultimediaInput\MediaPlayers.xml';
  if FileExists(src) then
  begin
    XML := TJclSimpleXML.Create;
    fileloaded := False;
    try
      XML.LoadFromFile(src);
      fileloaded := True;
    except
      on E: Exception do
      begin
        SharpApi.SendDebugMessageEx('TMediaPlayerList',PChar('Failed to Load Settings File ' + src),clred,DMT_ERROR);
        SharpApi.SendDebugMessageEx('SharpBar',PChar(E.Message),clblue, DMT_TRACE);
      end;
    end;
    if fileloaded then
    begin
      for n := 0 to XML.Root.Items.Count - 1 do
      with XML.Root.Items.Item[n].Items do
      begin
        newitem := TMediaPlayerItem.Create(XML.Root.Items.Item[n].Items);
        FItems.Add(newitem);
      end;
    end;
    XML.Free;
  end;
end;

{ TMediaPlayer }

constructor TMediaPlayerItem.Create(pXML : TJclSimpleXMLElems);
begin
  PlayerPath := '';

  Name := pXML.Value('Name','');
  WndClassName := pXML.Value('WndClass','');
  WndCaption := pXML.Value('WndCaption','');
  WndSubClass := pXML.Value('WndSubClass','');

  RegPath := pXML.Value('RegPath','');
  RegValue := pXML.Value('RegValue','');

  MessageType := TSendMessageType(pXML.IntValue('MessageType', Integer(smtAppCommand)));
  Command     := pXML.IntValue('Command',-1);
  btnPlay     := pXML.IntValue('btnPlay',APPCOMMAND_MEDIA_PLAY_PAUSE);
  btnPause    := pXML.IntValue('btnPause',APPCOMMAND_MEDIA_PLAY_PAUSE);
  btnStop     := pXML.IntValue('btnStop',APPCOMMAND_MEDIA_STOP);
  btnNext     := pXML.IntValue('btnNext',APPCOMMAND_MEDIA_NEXTTRACK);
  btnPrev     := pXML.IntValue('btnPrev',APPCOMMAND_MEDIA_PREVIOUSTRACK);

  Icon := TBitmap32.Create;
  Icon.SetSize(16,16);
  Icon.Clear(color32(0,0,0,0));

  LoadIcon(pXML.Value('Icon',''));
end;

destructor TMediaPlayerItem.Destroy;
begin
  Icon := TBitmap32.Create;

  inherited;
end;

procedure TMediaPlayerItem.LoadIcon(pIconFile : String);
var
  src : String;
  b : boolean;
  failed : boolean;
begin
  failed := True;
  src := SharpApi.GetSharpeGlobalSettingsPath + 'SharpCore\Services\MultimediaInput\Icons\' + pIconFile;
  if FileExists(src) then
  begin
    try
      GR32_PNG.LoadBitmap32FromPNG(Icon,src,b);
      failed := False;
    except
      on E: Exception do
      begin
        SharpApi.SendDebugMessageEx('TMediaPlayerList',PChar('Failed to Load Icon ' + src),clred,DMT_ERROR);
        SharpApi.SendDebugMessageEx('SharpBar',PChar(E.Message),clblue, DMT_TRACE);
      end;
    end;
  end;

  if failed then  
  begin
    Icon.SetSize(16,16);
    Icon.Clear(color32(0,0,0,0));
  end;
end;

end.
