{
Source Name: SharpSharedFileAccess.pas
Description: Functions for open file with shared read or write access 
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

unit SharpSharedFileAccess;

interface

uses
  Windows, Classes, SysUtils, RTLconsts;

type
  TSharedFileError = (sfeSuccess,sfeInvalidStream,sfeInvalidFilePath, sfeErrorOpeningStream, sfeTimeoutWaitingForAccess);
  TSharedFileAccess = (sfaRead,sfaWrite,sfaCreate);

  // Like TFileStream only that it doesn't throw an exception when it fails to load the file
  // instead it sets the Loaded property to false
  TSharedFileStream = class(THandleStream)
  strict private
    FFileName: string;
    FLoaded: boolean;
  public
    constructor Create(const AFileName: string; Mode: Word);
    destructor Destroy; override;
    property FileName: string read FFileName;
    property Loaded: boolean read FLoaded;
  end;

const
  SHARED_ACCESS_WAIT_TIME = 2500; // (ms)
  SHARED_ACCESS_CHECK_INTERVAL = 50; // (ms)

function OpenFileStreamShared(var Stream : TSharedFileStream; Access : TSharedFileAccess; FileName : String; WaitForAccess : boolean) : TSharedFileError;
function OpenMemoryStreamShared(var Stream : TMemoryStream; FileName : String; WaitForAccess : boolean) : TSharedFileError;

implementation

// Check if Stream is valid
function CheckStreamValid(Stream : TStream) : TSharedFileError;
begin
  // Check if stream is valid
  if (Stream = nil) then
  begin
    result := sfeInvalidStream;
    exit;
  end;

  result := sfeSuccess;  
end;

// Check if input params are valid
function CheckFileValid(FileName : String) : TSharedFileError;
begin
  // Check if file exists
  if (not FileExists(FileName)) then
  begin
    result := sfeInvalidFilePath;
    exit;
  end;

  result := sfeSuccess;
end;

// Setup Access Modes
function CreateAccessMode(Access : TSharedFileAccess) : Word;
begin
  case Access of
    sfaRead: result := fmOpenRead or fmShareDenyWrite;
    sfaWrite: result := fmOpenReadWrite or fmShareExclusive;
    sfaCreate: result := fmCreate or fmShareExclusive;
    else result := fmOpenRead or fmShareDenyWrite;
  end;
end;

function OpenFileStreamShared(var Stream : TSharedFileStream; Access : TSharedFileAccess; FileName : String; WaitForAccess : boolean) : TSharedFileError;
var
  mode : Word;
  StartTime : Cardinal;
  CTime : Cardinal;
  resetSize : boolean;
begin
  // Initial check of valid input data
  if (Access <> sfaCreate) then
  begin
    result := CheckFileValid(FileName);
    if result <> sfeSuccess then exit;
  end;

  if FileExists(filename) and (Access = sfaCreate) then
  begin
    Access := sfaWrite;
    resetSize := True;
  end else resetSize := False;
  mode := CreateAccessMode(Access);

  if WaitForAccess then
  begin
    StartTime := GetTickCount;
    // Create SharedFileStream until access is gained or until timeout is reached
    repeat
      Stream := TSharedFileStream.Create(FileName,mode);
      CTime := GetTickCount;
      if not Stream.Loaded then
      begin
        Sleep(SHARED_ACCESS_CHECK_INTERVAL);
        Stream.Free;
        Stream := nil;
      end;
    until (Stream <> nil) or (CTime - StartTime >= SHARED_ACCESS_WAIT_TIME);
  end;

  if (Stream = nil) then
  begin
    // Create SharedFileStream and return
    Stream := TSharedFileStream.Create(FileName,mode);
    if not Stream.Loaded then
    begin
      if WaitForAccess then
        result := sfeTimeoutWaitingForAccess
      else result := sfeErrorOpeningStream;
      Stream.Free;
      Stream := nil;
    end else result := sfeSuccess;
  end else result := sfeSuccess;

  if (Stream <> nil) and (resetSize) then
    Stream.Size := 0;
end;

function OpenMemoryStreamShared(var Stream : TMemoryStream; FileName : String; WaitForAccess : boolean) : TSharedFileError;
var
  FileStream : TSharedFileStream;
  Access : TSharedFileAccess;
  mode : Word;
  StartTime : Cardinal;
begin
  // Initial check of valid input data
  result := CheckFileValid(FileName);
  if result <> sfeSuccess then exit;
  result := CheckStreamValid(Stream);
  if result <> sfeSuccess then exit;

  Access := sfaRead;
  mode := CreateAccessMode(Access);

  FileStream := nil;
  if WaitForAccess then
  begin
    StartTime := GetTickCount;
    // Create SharedFileStream until access is gained or until timeout is reached
    repeat
      FileStream := TSharedFileStream.Create(FileName,mode);
      if not FileStream.Loaded then
      begin
        Sleep(SHARED_ACCESS_CHECK_INTERVAL);
        FileStream.Free;
        FileStream := nil;
      end;
    until (FileStream <> nil) or (GetTickCount - StartTime >= SHARED_ACCESS_WAIT_TIME);
  end;

  if (FileStream = nil) then
  begin
    // Create FileStream and fully load it into the memory stream
    FileStream := TSharedFileStream.Create(FileName,mode);
  end;

  if FileStream.Loaded then
  begin
    Stream.LoadFromStream(FileStream);
    Stream.Seek(0,soFromBeginning);
    result := sfeSuccess;
  end else
  begin
    if WaitForAccess then
      result := sfeTimeoutWaitingForAccess
    else result := sfeErrorOpeningStream;
  end;
  FileStream.Free;
end;

{ TSharedFileStream }

constructor TSharedFileStream.Create(const AFileName: string; Mode: Word);
begin
  if Mode = fmCreate then
    inherited Create(FileCreate(AFileName))
  else inherited Create(FileOpen(AFileName, Mode));
  FLoaded := (FHandle >= 0);
  FFileName := AFileName;  
end;

destructor TSharedFileStream.Destroy;
begin
  if FHandle >= 0 then FileClose(FHandle);
  inherited Destroy;
end;

end.
