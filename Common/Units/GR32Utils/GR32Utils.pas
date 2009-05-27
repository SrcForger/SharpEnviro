unit GR32Utils;

interface

uses
  GR32;

procedure SaveAssign(Src,Dst : TBitmap32);

implementation

procedure SaveAssign(Src,Dst : TBitmap32);
begin
  Dst.SetSize(Src.Width,Src.Height);
  Dst.Clear(color32(0,0,0,0));
  Dst.Draw(0,0,Src);

  Dst.DrawMode := Src.DrawMode;
  Dst.CombineMode := Src.CombineMode;
end;

end.
