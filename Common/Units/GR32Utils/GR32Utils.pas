unit GR32Utils;

interface

uses
  Classes,
  GR32,
  GR32_PNG,
  JPeg,
  SysUtils,
  SharpSharedFileAccess;

function LoadBitmap32Shared(var Dst : TBitmap32; FileName : String; useFileStream : boolean = False) : boolean;
procedure SaveAssign(Src,Dst : TBitmap32);

implementation

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
  Dst.Draw(0,0,Src);

  Dst.DrawMode := Src.DrawMode;
  Dst.CombineMode := Src.CombineMode;
end;

end.
