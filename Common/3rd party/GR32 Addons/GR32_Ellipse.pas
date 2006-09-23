// Author unknown
// Modifications by BilliBerserker
// Make sure to be withing a valid Bmp Rect when drawing! X,Y >0!
unit GR32_Ellipse;

Interface

uses GR32, Graphics, Types;

//type
// the boolean value AA is for anti aliasing
// the boolean value Fill is to select whether you want the ellipse to be filled with the clFill color

  procedure Ellipse(aBMP: TBitmap32;Rect: TRect;AA,Fill: boolean; clLine: TColor32; clFill: TColor32 = clBlack32);
  procedure Arc(aBMP:TBitmap32; aRect: TRect; aStart,aEnd:integer; AA: boolean; clLine: TColor32);

implementation
//------------------------------------------------------------------------------
procedure Ellipse(aBMP: TBitmap32;Rect: TRect;AA,Fill: boolean;
                  clLine: TColor32; clFill: TColor32 = clBlack32);
var t1,t2,t3,t4,t5,t6,t7,t8,t9: integer;
    d1,d2,x,y: integer;
    center_x,center_y,rx,ry: integer;
    e: single;
begin
  center_x := (Rect.Right+Rect.Left) shr 1;
  center_y := (Rect.Bottom+Rect.Top) shr 1;
  rx := (Rect.Right-Rect.Left) shr 1;
  ry := (Rect.Bottom-Rect.Top) shr 1;

  t1:=rx*rx;
  t2:=t1 shl 1;
  t3:=t2 shl 1;
  t4:=ry*ry;
  t5:=t4 shl 1;
  t6:=t5 shl 1;
  t7:=rx*t5;
  t8:=t7 shl 1;
  t9:=0;
  d1:=t2 - t7 + (t4 shr 1);
  d2 :=(t1 shr 1) - t8 + t5;

  x:=rx;
  y:=0;
  e:=rx;
  while (d2<0) do
  begin
    if not AA then                                        //no antialias
    begin
      if Fill then
      begin
        aBMP.HorzLine(center_x-x,center_y+y,center_x+x,clFill);
        aBMP.HorzLine(center_x-x,center_y-y,center_x+x,clFill);
      end;
      try
        aBMP.Pixel[center_x+x, center_y+y] := clLine;
        aBMP.Pixel[center_x+x, center_y-y] := clLine;
        aBMP.Pixel[center_x-x, center_y+y] := clLine;
        aBMP.Pixel[center_x-x, center_y-y] := clLine;
      except
      end;
    end else
    begin                                                 //with antialias
      if Fill then
      begin
        aBMP.HorzLine(center_x-x+1,center_y+y,center_x+x-1,clFill);
        aBMP.HorzLine(center_x-x+1,center_y-y,center_x+x-1,clFill);
      end;
      try
        aBMP.PixelF[center_x+e-1, center_y+y] := clLine;
        aBMP.PixelF[center_x+e-1, center_y-y] := clLine;
        aBMP.PixelF[center_x-e+1, center_y+y] := clLine;
        aBMP.PixelF[center_x-e+1, center_y-y] := clLine;
      except
      end;
      e:=sqrt((t1*t4-t1*y*y)/t4);
    end;

    t9:=t9+t3;
    inc(y);
    if d1<0 then
    begin
      d1:=d1+t9+t2;
      d2:=d2+t9;
    end else
    begin
      dec(x);
      t8:=t8-t6;
      d1:=d1+t9+t2-t8;
      d2:=d2+t9+t5-t8;
    end;
  end;

  while (x>=0) do
  begin
    if not AA then
    begin
      try
        aBMP.Pixel[center_x+x, center_y+y] := clLine;
        aBMP.Pixel[center_x+x, center_y-y] := clLine;
        aBMP.Pixel[center_x-x, center_y+y] := clLine;
        aBMP.Pixel[center_x-x, center_y-y] := clLine;
      except
      end;
    end else
    begin
      e:=sqrt((t1*t4-t4*x*x)/t1);
      try
        aBMP.PixelFS[center_x+x, center_y+e] := clLine;
        aBMP.PixelFS[center_x+x, center_y-e] := clLine;
        aBMP.PixelFS[center_x-x, center_y+e] := clLine;
        aBMP.PixelFS[center_x-x, center_y-e] := clLine;
      except
      end;
    end;

    dec(x);

    t8:=t8-t6;
    if (d2<0) then
    begin
      inc(y);
      t9:=t9+t3;
      d2:=d2+t9+t5-t8;
    end else
    begin
      d2:=d2+t5-t8;
    end;
    if Fill then
    begin
      aBMP.VertLine(center_x+x,center_y-y+1,center_y+y-1,clFill);
      aBMP.VertLine(center_x-x,center_y-y+1,center_y+y-1,clFill);
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure Arc(aBMP:TBitmap32; aRect: TRect; aStart,aEnd:integer;AA: boolean;
              clLine: TColor32);
const rad = 0.01745329251;
var x,y: integer;
    rx,ry: integer;

    function ArcArea(sStart,sEnd: integer): TRect;
    begin
      Result := Rect(0,0,0,0);

      if aStart>sEnd then exit;
      if aEnd<sStart then exit;

      if aStart<sStart then
      begin
        Result.Left:=abs(round(rx*cos(sStart*rad)));
        Result.Top:=abs(round(ry*sin(sStart*rad)));
      end else
      begin
        Result.Left:=abs(round(rx*cos(aStart*rad)));
        Result.Top :=abs(round(ry*sin(aStart*rad)));
      end;

      if aEnd>sEnd then
      begin
        Result.Right :=abs(round(rx*cos(sEnd*rad)));
        Result.Bottom:=abs(round(ry*sin(sEnd*rad)));
      end else
      begin
        Result.Right :=abs(round(rx*cos(aEnd*rad)));
        Result.Bottom:=abs(round(ry*sin(aEnd*rad)));
      end;

      if Result.Left>Result.Right then
         Result:=Rect(Result.Right,Result.Top,Result.Left,Result.Bottom);

      if Result.Bottom>Result.Top then
         Result:=Rect(Result.Left,Result.Bottom,Result.Right,Result.Top);
    end;

    function Inside(aRect: TRect): boolean;
    begin
      result:=(x<=aRect.Right) and (x>=aRect.Left) and
              (y<=aRect.Top)   and (y>=aRect.Bottom);
    end;


begin
 { center_x:= (aRect.Right+aRect.Left) shr 1;
  center_y:= (aRect.Top+aRect.Bottom) shr 1;
  rx      := (aRect.Right-aRect.Left) shr 1;
  ry      := (aRect.Bottom-aRect.Top) shr 1;

  aStart:=abs(aStart);
  aEnd := abs(aEnd);

  if aEnd<aStart then
  begin
    d1:=aEnd;
    aEnd:=aStart;
    aStart:=d1;
  end;

  t1:=rx*rx;
  t2:=t1 shl 1;
  t3:=t2 shl 1;
  t4:=ry*ry;
  t5:=t4 shl 1;
  t6:=t5 shl 1;
  t7:=rx*t5;
  t8:=t7 shl 1;
  t9:=0;
  d1:=t2 - t7 + (t4 shr 1);
  d2 :=(t1 shr 1) - t8 + t5;

  R0:= ArcArea(0,90);
  R1:= ArcArea(91,180);
  R2:= ArcArea(181,270);
  R3:= ArcArea(271,360);

  x:=rx;
  y:=0;
  while (d2<0) do
  begin
    if AA then
    begin
      e:=sqrt((t1*t4-t1*y*y)/t4);
      if inside(R0) then aBMP.SetPixelF(center_x+e, center_y-y, clLine);
      if inside(R1) then aBMP.SetPixelF(center_x-e, center_y-y, clLine);
      if inside(R2) then aBMP.SetPixelF(center_x-e, center_y+y, clLine);
      if inside(R3) then aBMP.SetPixelF(center_x+e, center_y+y, clLine);
    end else
    begin
      if inside(R0) then aBMP.SetPixelT(center_x+x,center_y-y,clLine);
      if inside(R1) then aBMP.SetPixelT(center_x-x,center_y-y,clLine);
      if inside(R2) then aBMP.SetPixelT(center_x-x,center_y+y,clLine);
      if inside(R3) then aBMP.SetPixelT(center_x+x,center_y+y,clLine);
    end;

    t9:=t9+t3;
    inc(y);
    if d1<0 then
    begin
      d1:=d1+t9+t2;
      d2:=d2+t9;
    end else
    begin
      dec(x);
      t8:=t8-t6;
      d1:=d1+t9+t2-t8;
      d2:=d2+t9+t5-t8;
    end;
  end;

  while (x>=0) do
  begin
    if AA then  //with anti aliasing
    begin
      e:=sqrt((t1*t4-t4*x*x)/t1);
      if inside(R0) then aBMP.SetPixelFS(center_x+x, center_y-e, clLine);
      if inside(R1) then aBMP.SetPixelFS(center_x-x, center_y-e, clLine);
      if inside(R2) then aBMP.SetPixelFS(center_x-x, center_y+e, clLine);
      if inside(R3) then aBMP.SetPixelFS(center_x+x, center_y+e, clLine);
    end else
    begin      // without anti aliasing 
      if inside(R0) then aBMP.SetPixelT(center_x+x, center_y-y, clLine);
      if inside(R1) then aBMP.SetPixelT(center_x-x, center_y-y, clLine);
      if inside(R2) then aBMP.SetPixelT(center_x-x, center_y+y, clLine);
      if inside(R3) then aBMP.SetPixelT(center_x+x, center_y+y, clLine);
    end;

    dec(x);
    t8:=t8-t6;
    if (d2<0) then
    begin
      inc(y);
      t9:=t9+t3;
      d2:=d2+t9+t5-t8;
    end else
    begin
      d2:=d2+t5-t8;
    end;
  end;     }
end;

end.