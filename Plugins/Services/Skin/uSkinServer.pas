{
Source Name: uSkinServer
Description: SharpESkin service to provide all app with skin graphics
Copyright (C) Malx (Malx@sharpe-shell.org)

Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uSkinServer;

interface

uses Windows, Dialogs, SysUtils, Classes,
     Forms, Controls, Messages, Types, Graphics, Contnrs, ExtCtrls,
     GR32,
     SharpApi,
     SharpESkin,
     GR32_Filters;

Type

    TSkinServer = class(TForm)
      procedure FormDestroy(Sender: TObject);
      procedure CreateParams(var Params: TCreateParams); override;
      procedure FormCreate(Sender: TObject);
    private
      FSkin      : TSharpESkin;
      FSize      : Cardinal;
      FBlockName : String;

      FFileName  : string;
      FNrLoaded  : Integer;
      FLastHwnd  : Cardinal;
      FNrReq     : Integer;

      FMapHandle : THandle;
      FMem       : Pointer;
      FStream    : TMemoryStream;


      procedure UpdateTheme(var Msg: TMessage); message WM_SHARPETHEMEUPDATE;
      procedure UpdateScheme(var Msg: TMessage); message WM_SHARPEUPDATESETTINGS;
      procedure IncomingRequest(var Msg: TMessage); message WM_ASKFORSYSTEMSKIN;
      procedure ReloadSharedMemory;
      procedure AllocMemory;
      procedure DeAllocMemory;
      procedure PutListinMemory;
    { Private declarations }
    public
      FTrayManager : TObject;
      isClosing : boolean;
      procedure UpdateInfoDlg;
    { Public declarations }
    end;

    TSharedSkinInfo = record
      Version   : string[4]; //This one should NEVER move
      BlockName : string[255];
      BlockSize : Cardinal;
    end;

{$R *.dfm}

implementation
uses uInfodlg;

function CalculateSize(skin : TSharpESkin): Cardinal;
var i : integer;
   totsize : cardinal;
begin
  totsize := 0;
  //Add pixeldata
  for i := 0 to skin.BitmapList.Count-1 do Begin
    with skin.BitmapList.Items[i] do
      inc(totsize,Bitmap.Height*Bitmap.Width*4);
  end;
  //Add bitmap headers
  inc(totsize,skin.BitmapList.Count*(SizeOf(tagBITMAPINFO)+4));
  //Add a bitmap count in the beginning
  inc(totsize, 4);
  result := totsize;
end;

procedure TSkinServer.FormCreate(Sender: TObject);
begin
  FSkin := TSharpESkin.Create(self);
  FStream := TMemoryStream.Create;
  FNrLoaded := 0;
  FFileName := '';
  FLastHwnd := 0;
  FNrReq := 0;
  FSize := 0;
  ReloadSharedMemory;
  SharpEBroadCast(WM_SYSTEMSKINUPDATE,0,0);
end;

procedure TSkinServer.FormDestroy(Sender: TObject);
begin
  DeAllocMemory;
  FSkin.Free;
  FStream.Free;
end;

procedure TSkinServer.UpdateInfoDlg;
begin
  if InfoDlg <> nil then begin
    InfoDlg.lSkinFile.caption := FFileName;
    InfoDlg.lnr.caption       := inttostr(FNrLoaded);
    InfoDlg.lNrReq.caption    := inttostr(FNrReq);
    InfoDlg.lLastHwnd.caption := inttostr(application.handle);
  end;
end;

procedure TSkinServer.ReloadSharedMemory;
begin
  //dealloc handles to old shared memory
  DeAllocMemory;
  //Load new skin
  FFileName := SharpAPI.GetCurrentSkinFile;
  FSkin.LoadFromXmlFile(FFileName);
  inc(FNrLoaded);
  //Calculate size of bitmaplist
  FSize := CalculateSize(FSkin);
  //Save skin structure as stream (without bitmap data)
  FSkin.SaveToStream(FStream,false);
  //Add structure size to memory size
  inc(FSize,FStream.Size+8);
  //allocate enough memory
  AllocMemory;
  //Put all data to memory
  PutListinMemory;
  //Clear the temporary stream
  FStream.Clear;
  //Update info Dlg
  UpdateInfoDlg;
end;

procedure TSkinServer.PutListinMemory;
var
  i : integer;
  pos : cardinal;
  source : pointer;
  dest  : pointer;
  co    : ^Cardinal;
begin
  if FMem <> nil then begin
    with FSkin.BitmapList do begin
      co  := FMem;
      co^ := cardinal(Count);
      pos := 12 + Count*4;
      for i := 0 to Count - 1 do begin
         co  := Pointer(Cardinal(FMem) + cardinal(i)*4 + 4);
         co^ := pos;
         with Items[i].Bitmap do begin
           source := pointer(@BitmapInfo);
           dest := pointer(cardinal(FMem) + pos);
           System.Move(source^, dest^, sizeof(tagBITMAPINFO));
           inc(pos, sizeof(tagBITMAPINFO));

           source := pointer(Bits);
           dest := pointer(cardinal(FMem) + pos);
           System.Move(source^, dest^, width*Height*4);
           inc(pos, Width*Height*4);
         end;
      end;
      co  := Pointer(Cardinal(FMem) + cardinal(count)*4 + 4);
      co^ := pos;
      co  := Pointer(Cardinal(FMem) + cardinal(count)*4 + 8);
      co^ := Cardinal(FStream.Size);
      dest := pointer(cardinal(FMem) + pos);
      FStream.Position := 0;
      FStream.ReadBuffer(dest^, FStream.Size);
    end;
  end;
end;

procedure TSkinServer.AllocMemory;
var
  res : hResult;
begin
  res := ERROR_ALREADY_EXISTS;
  while res = ERROR_ALREADY_EXISTS do begin
    FBlockName := 'SharpESkin' + inttostr(random(20000));
    FMapHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE,
                               0, FSize, pchar(FBlockName));
    if (FMapHandle = 0)
      then raise Exception.Create('TSkinServer.AllocMemory filemap error');
    res := GetLastError;
  end;

  FMem := MapViewOfFile(FMapHandle, FILE_MAP_WRITE, 0, 0, 0 );
  if (FMem = nil )
    then raise Exception.Create('TSkinServer.AllocMemory mapview error');

end;

Procedure TSkinServer.DeAllocMemory;
begin
  //This function deallocs skinserver handles to the shared memory
  //BUT, as long as ANY client still has a valid handle to the memory
  //it will still exist, and not be freed.
  if (FMem <> nil) then begin
    if not UnmapViewOfFile(FMem)
       then raise Exception.Create( 'TSkinServer.DeAlloc unmapview error');
       FMem := nil;
  end;
  if (FMapHandle <> 0) then
    if not CloseHandle(FMapHandle)
       then raise Exception.Create('TSkinServer.DeAlloc close handle error' );
end;




procedure TSkinServer.CreateParams(var Params: TCreateParams);
begin
  try
    inherited CreateParams(Params);
    with Params do
    begin
      Params.WinClassName := 'SharpESkinServer';
      ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
      Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
    end;
  except
  end;
end;

procedure TSkinServer.UpdateScheme(var Msg: TMessage);
begin
  ReloadSharedMemory;
  SharpEBroadCast(WM_SYSTEMSKINUPDATE,0,0);
end;

procedure TSkinServer.UpdateTheme(var Msg: TMessage);
begin
  ReloadSharedMemory;
  SharpEBroadCast(WM_SYSTEMSKINUPDATE,0,0);
end;

procedure TSkinServer.IncomingRequest(var Msg: TMessage);
var ds : TCopyDataStruct;
    ski : TSharedSkinInfo;
begin
  ds.dwData := 301;
  ds.cbData := SizeOf(TSharedSkinInfo);
  ski.Version := '1.0';
  ski.BlockName := FBlockName;
  ski.BlockSize := FSize;
  ds.lpData := @ski;
  SendMessage(msg.WParam,WM_COPYDATA ,0,Cardinal(@ds));

  inc(FNrReq);
  FLastHwnd := msg.WParam;
  //Update info dlg
  UpdateInfoDlg;
end;

end.
