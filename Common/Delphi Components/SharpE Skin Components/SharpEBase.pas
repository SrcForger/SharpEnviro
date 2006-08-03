unit SharpEBase;

interface
uses Windows,
  Graphics,
  Messages,
  Classes,
  Controls;

const WM_UPDATESKIN = WM_APP + 1500;
  WM_REMOVEMANAGER = WM_APP + 1501;
  WM_ADDMANAGER = WM_APP + 1502;

type
  { TColorScheme = record
    Throbberback  : Tcolor;
    Throbberdark  : Tcolor;
    Throbberlight : Tcolor;
    Throbbertext  : Tcolor;
    WorkAreaback  : Tcolor;
    WorkAreadark  : Tcolor;
    WorkArealight : Tcolor;
    WorkAreatext : Tcolor;
  end;           }

  TSkinTextRecord = record
    FName: string;
    FColor: string;
    FSize: integer;
  end;

  FontRec = packed record
    Color: TColor;
    LogF: LogFont;
  end;

function StringLoadFromStream(stream: TStream): string;
procedure StringSaveToStream(str: string; stream: TStream);
function FontLoadFromStream(stream: TStream): TFont;
procedure FontSaveToStream(font: TFont; stream: TStream);

implementation

procedure StringSaveToStream(str: string; stream: TStream);
var Size: integer;
begin
  Size := length(str);
  stream.WriteBuffer(Size, sizeof(Size));
  stream.WriteBuffer(Pointer(str)^, Size);
end;

function StringLoadFromStream(stream: TStream): string;
var Size: integer;
  str: string;
begin
  Stream.ReadBuffer(Size, sizeof(Size));
  SetString(str, nil, Size);
  Stream.ReadBuffer(Pointer(str)^, Size);
  result := str;
end;

procedure FontSaveToStream(font: TFont; stream: TStream);
var
  fRec: FontRec;
  sz: integer;
begin
  sz := SizeOf(fRec.LogF);
  if Windows.GetObject(Font.Handle, sz, @fRec.LogF) > 0 then
  begin
    stream.Write(sz, SizeOf(Integer));
    fRec.Color := Font.Color;
    stream.Write(fRec, SizeOf(fRec));
  end
  else
  begin
    sz := 0;
    stream.Write(sz, SizeOf(Integer));
  end;
end;

function FontLoadFromStream(stream: TStream): TFont;
var
  fRec: FontRec;
  sz: integer;
begin
  stream.read(sz, SizeOf(Integer));
  result := TFont.create;
  if sz = SizeOf(fRec.LogF) then
  begin
    stream.read(fRec, SizeOf(fRec));
    result.Free;
    result.Handle := CreateFontIndirect(fRec.LogF);
    result.Color := fRec.Color;
  end
end;

end.
