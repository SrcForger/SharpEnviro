unit GR32Utils;

interface

uses
  Classes,
  Graphics,
  GR32,
  GR32_PNG,
  GR32_LowLevel,
  JPeg,
  SysUtils,
  PngImage,
  SharpSharedFileAccess;

function LoadBitmap32Shared(var Dst : TBitmap32; FileName : String; useFileStream : boolean = False) : boolean;
procedure SaveAssign(Src,Dst : TBitmap32);
function SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
                           bgcolor: TColor; CompressionLevel: Integer = 9;
                           InterlaceMethod: TInterlaceMethod = imNone): TPngObject;


implementation

type
  TARGB = record
    b: Byte;
    g: Byte;
    r: Byte;
    a: Byte;
  end;
  PARGB = ^TARGB;

procedure AssignJpeg(var Dst : TBitmap32; Stream : TStream);
var
  P : TJpegImage;
begin
  P := TJpegImage.Create;
  try
    P.LoadFromStream(Stream);
    Dst.Assign(P);
  finally
    P.Free;
  end;
end;

function LoadBitmap32Shared(var Dst : TBitmap32; FileName : String; useFileStream : boolean = False) : boolean;
var
  FileStream : TSharedFileStream;
  MemoryStream : TMemoryStream;
  Ext : String;
  b : boolean;
begin
  result := False;
  if Dst = nil then exit;

  Ext := ExtractFileExt(FileName);
  if useFileStream then
  begin
    if OpenFileStreamShared(FileStream, sfaRead, FileName, true) = sfeSuccess then
    begin
      if (CompareText(Ext,'.jpeg') = 0) or (CompareText(Ext,'.jpg') = 0) then
        AssignJpeg(Dst,FileStream)
      else if (CompareText(Ext,'.png') = 0) then
        LoadBitmap32FromPNG(Dst,FileStream,b)
      else Dst.LoadFromStream(FileStream);
      FileStream.Free;
      result := True;
    end;
  end else
  begin
    MemoryStream := TMemoryStream.Create;
    if OpenMemoryStreamShared(MemoryStream, FileName, true) = sfeSuccess then
    begin
      if (CompareText(Ext,'.jpeg') = 0) or (CompareText(Ext,'.jpg') = 0) then
        AssignJpeg(Dst,MemoryStream)
      else if (CompareText(Ext,'.png') = 0) then
        LoadBitmap32FromPNG(Dst,FileStream,b)        
      else Dst.LoadFromStream(MemoryStream);
      result := True;
    end;
    MemoryStream.Free;
  end;
end;

procedure SaveAssign(Src,Dst : TBitmap32);
begin
  Dst.SetSize(Src.Width,Src.Height);
  Dst.Clear(color32(0,0,0,0));
  if not Src.Empty then
    GR32_LowLevel.MoveLongword(Src.Bits[0], Dst.Bits[0], Src.Width * Src.Height);

  Dst.DrawMode := Src.DrawMode;
  Dst.CombineMode := Src.CombineMode;
end;

function SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
                           bgcolor: TColor; CompressionLevel: Integer = 9;
                           InterlaceMethod: TInterlaceMethod = imNone): TPngObject;
var
  bm: TBitmap;
  png: TPngObject;
  TRNS: TCHUNKtRNS;
  p: PByteArray;
  x, y: Integer;
begin
  png := TPngObject.Create;
  bm := TBitmap.Create;
  try
    try
      bm.Assign(bm32);
      if paletted then
        bm.PixelFormat := pf8bit; // force paletted on TBitmap, transparent for the web must be 8 bit
      png.InterlaceMethod := InterlaceMethod;
      png.CompressionLevel := CompressionLevel;
      png.Assign(bm); //Convert data into png
    finally
      FreeAndNil(bm);
    end;
    if transparent then begin
      if png.Header.ColorType in [COLOR_PALETTE] then begin
        if (png.Chunks.ItemFromClass(TChunktRNS) = nil) then
          png.CreateAlpha;
        TRNS := png.Chunks.ItemFromClass(TChunktRNS) as TChunktRNS;
        if Assigned(TRNS) then
          TRNS.TransparentColor := bgcolor;
      end;
      if png.Header.ColorType in [COLOR_RGB, COLOR_GRAYSCALE] then
        png.CreateAlpha;
      if png.Header.ColorType in [COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA] then begin
        for y := 0 to png.Header.Height - 1 do begin
          p := png.AlphaScanline[y];
          for x := 0 to png.Header.Width - 1 do
            p[x] :=
              TARGB(bm32.Pixel[x, y]).a;
        end;
      end;
    end;

  finally
    Result := png;
  end;
end;

end.
