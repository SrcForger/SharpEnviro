{
Source Name: SharpEBitmapList.pas
Description:
Copyright (C) Malx (Malx@techie.com)

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

unit SharpEBitmapList;

interface
uses gr32,
  contnrs,
  SysUtils,
  Classes,
  Types;

type
  TSkinBitmap = class
    FFilename: string;
    FBitmap: TBitmap32;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

    property Bitmap: TBitmap32 read FBitmap write FBitmap;
    property FileName: string read FFileName write FFileName;
  end;

  TClassList = class(TList)
  protected
  public
  end;

  TSkinBitmapList = class(TList)
  protected
    procedure SetItems(Index: Integer; ASkinBitmap: TSkinBitmap);
  public
    //Ordinary List functions
    function GetItems(Index: Integer): TSkinBitmap; virtual;
    function Add(ASkinBitmap: TSkinBitmap): Integer; virtual;
    function Extract(Item: TSkinBitmap): TSkinBitmap; virtual;
    function Remove(ASkinBitmap: TSkinBitmap): Integer; virtual;
    function IndexOf(ASkinBitmap: TSkinBitmap): Integer; virtual;
    function First: TSkinBitmap; virtual;
    function Last: TSkinBitmap; virtual;
    procedure Insert(Index: Integer; ASkinBitmap: TSkinBitmap); virtual;
    property Items[Index: Integer]: TSkinBitmap read GetItems write SetItems;
    default;

    destructor Destroy; override;
    function AddFromFile(filename: string): integer; virtual;
    function AddEmptyBitmap(Width, Height: integer): integer; virtual;
    procedure LoadFromStream(Stream: TStream);virtual;
    procedure SaveToStream(Stream: TStream); virtual;

    function Find(filename: string): integer; virtual;
    procedure Clear; override;
  end;

implementation

uses
 gr32_png,
 SharpEBase;


// function written by Andre Beckedorf (graphics32 dev team)
function HasVisiblePixel(Bitmap: TBitmap32): Boolean;
var
  I: Integer;
  S: PColor32;
begin
  Result := False;
  if (Bitmap.DrawMode = dmBlend) and (Bitmap.MasterAlpha = 0) then
    Exit;

  S := @Bitmap.Bits[0];
//  showmessage(inttostr(I));
  for I := 0 to Bitmap.Width * Bitmap.Height - 1 do
  begin
    if S^ shr 24 > 0 then
    begin
      Result := True;
      Exit;
    end;
    Inc(S);
  end;
end;

constructor TSkinBitmap.Create;
begin
  inherited;
  FBitmap := TBitmap32.Create;
end;

destructor TSkinBitmap.Destroy;
begin
  if FBitmap <> nil then
     FBitmap.Free;
  inherited;
end;

procedure TSkinBitmap.LoadFromStream(Stream: TStream);
begin
  FFileName := StringLoadFromStream(Stream);
  FBitmap.LoadFromStream(Stream);
end;

procedure TSkinBitmap.SaveToStream(Stream: TStream);
begin
  StringSaveToStream(FFileName,Stream);
  FBitmap.SaveToStream(Stream);
end;

destructor TSkinBitmapList.Destroy;
begin
  Clear;
  inherited;
end;

function TSkinBitmapList.Find(filename: string): integer;
var i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if filename = TSkinBitmap(Items[i]).filename then
    begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;

function TSkinBitmapList.AddFromFile(filename: string): integer;
var
  item: TSkinBitmap;
  alpha: boolean;
begin
  if FileExists(filename) then
  begin
    item := TSkinBitmap.Create;
    try
      item.FileName := filename;
      loadbitmap32frompng(item.Bitmap, filename, alpha);
      if alpha then
      begin
        item.Bitmap.CombineMode := cmMerge;
        item.Bitmap.DrawMode := dmBlend;
      end;
      result := Add(item);
    except
      item.Free;
      result := -1;
    end;
  end
  else
    result := -1;
end;

procedure TSkinBitmapList.Clear;
var i: integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Free;
  inherited;
end;

procedure TSkinBitmapList.LoadFromStream(Stream: TStream);
var i: integer;
  d: DWord;
  item: TSkinBitmap;
begin
  Clear;
  Stream.ReadBuffer(d, sizeof(d));
  for i := 1 to d do
  begin
    item := TSkinBitmap.Create;
    item.LoadFromStream(Stream);
    if (item.Bitmap.Height = 16) and (item.Bitmap.Height = 16) and
      (not HasVisiblePixel(item.Bitmap)) then
    begin
      AddEmptyBitmap(16, 16);
      item.Free;
    end
    else
      Add(item);
  end;
end;

procedure TSkinBitmapList.SaveToStream(Stream: TStream);
var i: integer;
  c: DWORD;
begin
  c := Count;
  Stream.WriteBuffer(c, sizeof(c));
  for i := 0 to Count - 1 do
  begin
    Items[i].SaveToStream(Stream);
  end;
end;

function TSkinBitmapList.AddEmptyBitmap(Width, Height: integer): integer;
var
  item: TSkinBitmap;
begin
  item := TSkinBitmap.Create;
  try
    item.FileName := 'empty';
    if (Width > 0) and (Height > 0) then
      item.Bitmap.SetSize(Width, Height)
    else
      item.Bitmap.SetSize(16, 16);
    item.Bitmap.Clear(color32(128, 128, 128, 255));
    item.Bitmap.CombineMode := cmMerge;
    item.Bitmap.DrawMode := dmBlend;
    result := Add(item);
  except
    item.Free;
    result := -1;
  end;
end;

//Ordinary list functions

function TSkinBitmapList.Add(ASkinBitmap: TSkinBitmap): Integer;
begin
  Result := inherited Add(ASkinBitmap);
end;

function TSkinBitmapList.Extract(Item: TSkinBitmap): TSkinBitmap;
begin
  Result := TSkinBitmap(inherited Extract(Item));
end;

function TSkinBitmapList.First: TSkinBitmap;
begin
  Result := TSkinBitmap(inherited First);
end;

function TSkinBitmapList.GetItems(Index: Integer): TSkinBitmap;
begin
  Result := TSkinBitmap(inherited Items[Index]);
end;

function TSkinBitmapList.IndexOf(ASkinBitmap: TSkinBitmap): Integer;
begin
  Result := inherited IndexOf(ASkinBitmap);
end;

procedure TSkinBitmapList.Insert(Index: Integer; ASkinBitmap: TSkinBitmap);
begin
  inherited Insert(Index, ASkinBitmap);
end;

function TSkinBitmapList.Last: TSkinBitmap;
begin
  Result := TSkinBitmap(inherited Last);
end;

function TSkinBitmapList.Remove(ASkinBitmap: TSkinBitmap): Integer;
begin
  Result := inherited Remove(ASkinBitmap);
end;

procedure TSkinBitmapList.SetItems(Index: Integer; ASkinBitmap: TSkinBitmap);
begin
  inherited Items[Index] := ASkinBitmap;
end;

end.
