{
Source Name: SharedBitmapList.pas
Description:
Copyright (C) Malx (malx@sharpenviro.com)

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

unit SharedBitmapList;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, GR32, Forms,
  SharpESkin, SharpTypes, SharpEBitmapList, SharpAPI;

type

  TSharedSkinInfo = record
      Version   : string[4]; //This one should NEVER move
      BlockName : string[255];
      BlockSize : Cardinal;
    end;

  TSharedBitmapList = class(TSkinBitmapList)
  private
    { Private declarations }
    FMapHandle      : THandle;
    FMutexHandle    : THandle;
    FName           : String;
    FMemory         : Pointer;
    FSize           : Longint;
    FBitmap         : TSkinBitmap;
    FLast           : integer;
    FEmptyBmp       : TSkinBitmap; //Returned in dummy functions and outofbounds

  protected
    { Protected declarations }
    Procedure  AllocMemory;
    Procedure  DeAllocMemory;
    function GetCount: Integer;
    function ReturnDummy : TSkinBitmap;

  public
    { Public declarations }
    constructor Create(BlockName : string; Size : integer);
    destructor  Destroy; override;
    procedure SetNewBlock(BlockName : string; Size : integer);
    function GetItems(Index: Integer): TSkinBitmap; override;

    //Following procedures should not work with sharedbitmaplist
    //for the moment so they are overrided to do nothing
    function Add(ASkinBitmap: TSkinBitmap): Integer; override;
    function Extract(Item: TSkinBitmap): TSkinBitmap; override;
    function Remove(ASkinBitmap: TSkinBitmap): Integer; override;
    function IndexOf(ASkinBitmap: TSkinBitmap): Integer; override;
    procedure Insert(Index: Integer; ASkinBitmap: TSkinBitmap); override;
    function Find(filename: string): integer; override;
    function AddFromFile(filename: string): integer; override;
    function AddEmptyBitmap(Width, Height: integer): integer; override;
    procedure Clear; override;
    procedure LoadFromStream(Stream: TStream); override;


    procedure SaveToStream(Stream: TStream); override;
    function First: TSkinBitmap; override;
    function Last: TSkinBitmap; override;

    Property Count : Integer read GetCount;

    Property Items[Index: Integer] : TSkinBitmap read GetItems;
    Property BlockSize             : Longint read FSize;
    Property BlockName             : String read FName;
    Property Buffer : Pointer read FMemory;
  end;

  TSystemSharpESkin = class(TSharpESkin)
  private
    FActivated      : Boolean;
    FUsingMainWnd   : Boolean;
    FMsgWnd         : Hwnd;
    FOnSkinChanged  : TNotifyEvent;

    //Either hook MainWnd or create a wnd by itself
    function MessageHook(var Msg: TMessage) : boolean;
    Procedure MessageHook2(var Msg:TMessage);

    //procedure RegisterForSystemSkin;
    procedure SetActive(b : boolean);
    //procedure NotifyManager;
  protected
  public
    constructor Create(Skins: TSharpESkinItems = ALL_SHARPE_SKINS); reintroduce;
    destructor Destroy; override;

    //Following procedures should not work with systemskin
    //so they are overrided to do nothing
    procedure LoadFromXmlFile(filename: string); override;
    procedure LoadFromSkin(filename: string); override;
    procedure LoadFromStream(Stream : TStream); override;

    procedure LoadSkinFromStream;

    property Activated : Boolean read FActivated write SetActive;
    property OnSkinChanged: TNotifyEvent read FOnSkinChanged write FOnSkinChanged;
   published
  end;

implementation

constructor TSystemSharpESkin.Create(Skins: TSharpESkinItems = ALL_SHARPE_SKINS);
begin
//  FSharedBmpList := TSharedBitmapList.Create('',0);
//  inherited CreateBmp(nil, FSharedBmpList as TSkinBitmapList);
  inherited Create(nil, Skins);
  FActivated := false;

  //Hook MainWindow to recieve system messages
  FUsingMainWnd := Application.Handle <> 0;
  If FUsingMainWnd then begin
    Application.HookMainWindow(MessageHook);
    FMsgWnd := Application.Handle;
  end
  else begin
    FMsgWnd := classes.AllocateHwnd(MessageHook2);
   end;
end;

destructor TSystemSharpESkin.Destroy;
begin
  if FUsingMainWnd then Application.UnHookMainWindow(MessageHook)
  else Classes.DeAllocateHwnd(FMsgWnd) ;
  inherited;
end;

procedure TSystemSharpESkin.SetActive(b : boolean);
begin
  if (csDesigning in ComponentState) then exit;

  if b then
    LoadSkinFromStream
  else
    FActivated := false;
end;

{procedure TSystemSharpESkin.RegisterForSystemSkin;
var
  hTargetWnd: HWND;
begin
  if not(FActivated) then
  begin
    hTargetWnd := FindWindowEx(0, 0, PChar('SharpESkinServer'), nil);
    if hTargetWnd <> 0 then
    begin
      Postmessage(hTargetWnd,WM_ASKFORSYSTEMSKIN,FMsgWnd,0);
    end;
  end;
  FActivated := true;
end;        }

procedure TSystemSharpESkin.LoadSkinFromStream;
var
  loadfile : String;
  stream : TMemoryStream;
begin
  inherited Clear;
  loadfile := SharpApi.GetSharpeUserSettingsPath + 'SharpE.skin';
  if FileExists(loadfile) then
  begin
    stream := TMemoryStream.Create;
    stream.LoadFromFile(loadfile);
    try
      inherited LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
  if Assigned(FOnSkinChanged) then FOnSkinChanged(self);
end;

{procedure TSystemSharpESkin.NotifyManager;
begin
  if Assigned(OnNotify) then
    OnNotify;
end;}

function TSystemSharpESkin.MessageHook(var Msg: TMessage): Boolean;
//var
//  m : TWMCopyData;
//  ssi : TSharedSkinInfo;
begin
  result := false;
  if FActivated then begin
 {   if (Msg.Msg = WM_COPYDATA) then begin
      m := TWMCopyData(Msg);
      if m.CopyDataStruct.dwData = 301 then begin
        ssi := TSharedSkinInfo(m.CopyDataStruct.lpData^);
        LoadFromSharedSkin(ssi);
        NotifyManager;
      end;
    end       }
    //else
  end;
end;

procedure TSystemSharpESkin.MessageHook2(var Msg: TMessage);
begin
  MessageHook(Msg);
end;

procedure TSystemSharpESkin.LoadFromStream(Stream : TStream);
begin
end;

procedure TSystemSharpESkin.LoadFromXmlFile(filename: string);
begin
end;

procedure TSystemSharpESkin.LoadFromSkin(filename: string);
begin
end;



constructor TSharedBitmapList.Create(BlockName : string; Size : integer);
begin
    FMemory      := NIL;
    FBitmap      := TSkinBitmap.Create;
    FMapHandle   := 0;
    FMutexHandle := 0;
    FLast        := -1;
    FSize        := Size;
    FName        := BlockName;
    AllocMemory;
end;

destructor TSharedBitmapList.Destroy;
begin
  DeAllocMemory;
  FBitmap.Free;
  FEmptyBmp.Free;
end;


procedure TSharedBitmapList.SaveToStream(Stream: TStream);
begin
end;

function TSharedBitmapList.First: TSkinBitmap;
begin
  result := GetItems(0);
end;

function TSharedBitmapList.Last: TSkinBitmap;
begin
  result := GetItems(GetCount-1);
end;

procedure TSharedBitmapList.SetNewBlock(BlockName : string; Size : integer);
begin
  DeAllocMemory;
  FLast := -1;
  FName := BlockName;
  FSize := Size;
  AllocMemory;
end;

function TSharedBitmapList.ReturnDummy : TSkinbitmap;
begin
  if FEmptyBmp = nil then FEmptyBmp := TSkinbitmap.Create;
  result := FEmptyBmp;
end;

function TSharedBitmapList.GetCount: Integer;
begin
 if (Fmemory = nil) then result := 0
 else
   result := Integer(Cardinal(FMemory^));
end;


function TSharedBitmapList.GetItems(Index: Integer): TSkinBitmap;
var
   count     : ^Cardinal;
   bplace    : ^Cardinal;
   binfo     : ^tagBITMAPINFO;
   bdata     : Pointer;
begin
  try
    if (Index < 0) or (FMemory = nil) then begin
      result := returnDummy;
      exit;
    end;

    if Index = FLast then begin
      result := FBitmap;
      exit;
    end;

    count := FMemory;
    if count^ < Cardinal(Index) then begin
      result := returnDummy;
      exit;
    end;

    bplace := pointer(Cardinal(FMemory)+cardinal(Index+1)*4);
    binfo  := pointer(Cardinal(FMemory)+bplace^);
    bdata  := pointer(Cardinal(FMemory)+bplace^+sizeof(tagBITMAPINFO));
    FBitmap.FBitmap.SetSize(binfo^.bmiHeader.biWidth,abs(binfo^.bmiHeader.biHeight));
    SetDIBitsToDevice(FBitmap.FBitmap.Handle, 0, 0,FBitmap.FBitmap.Width, FBitmap.FBitmap.Height,
                      0, 0, 0, FBitmap.FBitmap.Height, bdata, binfo^, DIB_RGB_COLORS);
    Result := FBitmap;
    ReleaseMutex(FMutexHandle);
  except
    result := returnDummy;
    ReleaseMutex(FMutexHandle);
  end;
end;

procedure TSharedBitmapList.AllocMemory;
begin
  if (FName='') or (FSize < 4) then exit;

  FMapHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READONLY, 0,
                                  FSize, pchar(FName));
  if (FMapHandle = 0)
    then raise Exception.Create( 'TSharedBitmapList.Alloc Map error' );

  if not (GetLastError = ERROR_ALREADY_EXISTS) then begin
    DeAllocMemory;
    Exit;
  end;

  FMemory := MapViewOfFile(FMapHandle, FILE_MAP_Read, 0, 0, 0 );

  if ( FMemory = Nil )
    then raise Exception.Create('TSharedBitmapList.Alloc View error' );
end;

Procedure TSharedBitmapList.DeAllocMemory;
begin
  if ( FMutexHandle <> 0 ) then begin
    CloseHandle(FMutexHandle);
    FMutexHandle := 0;
  end;


  if ( FMemory <> Nil ) then begin
    if not UnmapViewOfFile(FMemory) then
       FMemory := Nil;
  end;

  if ( FMapHandle <> 0 ) then
     CloseHandle(FMapHandle);
end;

function TSharedBitmapList.Add(ASkinBitmap: TSkinBitmap): Integer;
begin
  result := 0;
end;
function TSharedBitmapList.Extract(Item: TSkinBitmap): TSkinBitmap;
begin
  result := ReturnDummy;
end;
function TSharedBitmapList.Remove(ASkinBitmap: TSkinBitmap): Integer;
begin
  result := 0;
end;
function TSharedBitmapList.IndexOf(ASkinBitmap: TSkinBitmap): Integer;
begin
  result := 0;
end;
procedure TSharedBitmapList.Insert(Index: Integer; ASkinBitmap: TSkinBitmap);
begin
end;
function TSharedBitmapList.Find(filename: string): integer;
begin
  result := 0;
end;
function TSharedBitmapList.AddFromFile(filename: string): integer;
begin
  result := 0;
end;
function TSharedBitmapList.AddEmptyBitmap(Width, Height: integer): integer;
begin
  result := 0;
end;
procedure TSharedBitmapList.Clear;
begin
end;
procedure TSharedBitmapList.LoadFromStream(Stream: TStream);
begin
end;

end.
