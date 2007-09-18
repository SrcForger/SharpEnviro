{
Source Name: MouseGestures.pas
Description: MouseGesture Class
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit MouseGestures;

interface

uses Types,Math,Contnrs,ExtCtrls,Controls;

type
  TVecPoint = class
  public
    X,Y : integer;
    TotalLength : real;
    DX,DY : real;
    constructor Create(pX,pY : integer; pDX,pDY : real); overload;
    constructor Create(pVecPoint : TVecPoint); overload;
    procedure Normalize;
  end;

  TMouseGesture = class
  private
    FMinDistance : integer;
    FRecordInterval : integer;

    FPathLength : real;
    FCValue : real;
    FPoints : TObjectList;
    FRecordTimer : TTimer;
    procedure OnRecordTimer(Sender : TObject);
    procedure UpdatePointData;
  public
    constructor Create;
    destructor Destroy; override;
    procedure StartRecord;
    procedure FinishRecord;
    function CompareTo(MG : TMouseGesture) : boolean;

    property Points : TObjectList read FPoints;
    property PathLength : real read FPathLength;
    property CValue : real read FCValue;
  end;

implementation

uses Unit1;

constructor TVecPoint.Create(pVecPoint : TVecPoint);
begin
  inherited Create;

  TotalLength := pVecPoint.TotalLength;
  X := pVecPoint.X;
  Y := pVecPoint.Y;
  DX := pVecPoint.DX;
  DY := pVecPoint.DY;
end;

constructor TVecPoint.Create(pX,pY : integer; pDX,pDY : real);
begin
  inherited Create;

  TotalLength := 0;
  X := pX;
  Y := pY;
  DX := pDX;
  DY := pDY;
  
  Normalize;
end;

procedure TVecPoint.Normalize;
var
  l : real;
begin
  if (DX = 0) and (DY = 0) then exit;

  l := Sqrt(DX*DX + DY*DY);

  // Make sure no division by zero happens
  if l > 0 then
  begin
    DX := DX / l;
    DY := DY / l;
  end;
end;

constructor TMouseGesture.Create;
begin
  inherited Create;

  // Initial consts
  FMinDistance := 10;{px}
  FRecordInterval := 10;{ms}

  FPathLength := 0;
  FCValue := 0;

  FPoints := TObjectList.Create(True);
end;

destructor TMouseGesture.Destroy;
begin
  FPoints.Free;

  inherited Destroy;
end;

procedure TMouseGesture.StartRecord;
var
  MPos : TPoint;
begin
  MPos := Mouse.CursorPos;
  FPoints.Clear;

  // Add the start point
  FPoints.Add(TVecPoint.Create(MPos.X,MPos.Y,0,0));

  // Intiailize the timer used for recording
  FRecordTimer := TTimer.Create(nil);
  FRecordTimer.Interval := FRecordInterval;
  FRecordTimer.OnTimer := OnRecordTimer;
  FRecordTimer.Enabled := True;
end;

procedure TMouseGesture.FinishRecord;
var
  MPos : TPoint;
begin
  // Add the end point
  MPos := Mouse.CursorPos;
  FPoints.Add(TVecPoint.Create(MPos.X,MPos.Y,0,0));

  // Free the record timer
  FRecordTimer.Enabled := False;
  FRecordTimer.Free;

  // Analyze and Update the recorded points
  UpdatePointData;
end;

procedure TMouseGesture.OnRecordTimer(Sender : TObject);
var
  MPos : TPoint;
begin
  // Add the new point
  MPos := Mouse.CursorPos;
  FPoints.Add(TVecPoint.Create(MPos.X,MPos.Y,0,0));
end;

procedure TMouseGesture.UpdatePointData;
var
  n : integer;
  BfVP,FromVP,ToVP,VP : TVecPoint;
  l : real;
  xmod,ymod : integer;
begin
  if FPoints.Count < 2 then exit;
  n := 0;

  FPathLength := 0;
  FCValue := 0;
  // Update the vectors between each points
  while n < FPoints.Count - 1 do
  begin
    if n > 0 then
       BfVP := TVeCPoint(FPoints.Items[n-1])
       else BfVp := nil;
    FromVP := TVecPoint(FPoints.Items[n]);
    ToVP   := TVecPoint(FPoints.Items[n + 1]);

    // update vector
    FromVP.DX := ToVP.X - FromVP.X;
    FromVP.DY := ToVP.Y - FromVP.Y;

    // check distance between both points
    l := Sqrt(FromVP.DX * FromVP.DX + FromVP.DY * FromVP.DY);
    if l < FMinDistance then
       FPoints.Delete(n+1) // distance not large enough, remove point
       else
       begin
         FromVP.TotalLength := FPathLength;
         FPathLength := FPathLength + l;

         // Normalize vector
         FromVP.DX := FromVP.DX / l;
         FromVP.DY := FromVP.DY / l;

         // calculate how much the direction has changed (how complex is the path...)
         if BfVP <> nil then
            FCValue := FCValue + abs(FromVP.DX - BfVP.DX) + abs(FromVP.DY - BfVP.DY);

         n := n + 1;
       end;
  end;

  // fix for straight lines having only a small c-value
  if FCValue < 2.5 then FCValue := 2.5;

  if FPoints.Count < 2 then exit;

  // transform the points to (0,0) based on the position of the first point
  VP := TVecPoint(FPoints.Items[0]);
  xmod := VP.X;
  ymod := VP.Y;
  for n := 0 to FPoints.Count - 1 do
  begin
    VP := TVecPoint(FPoints.Items[n]);
    VP.X := VP.X - xmod;
    VP.Y := VP.Y - ymod;
  end;
end;

function TMouseGesture.CompareTo(MG : TMouseGesture) : boolean;
var
  l,cdelta,delta : real;
  CPoints : TObjectList;
  n : integer;
  SP,CP : TVecPoint;

  // scale all points by a factor
  procedure ScalePoints(Factor : real);
  var
    VP : TVecPoint;
    n : integer;
  begin
    for n := 0 to CPoints.Count - 1 do
    begin
      VP := TVecPoint(CPoints.Items[n]);
      VP.X := round(VP.X * Factor);
      VP.Y := round(VP.Y * Factor);
      VP.TotalLength := VP.TotalLength * Factor;
    end;
  end;

  function GetPointByLength(l : real; List : TObjectList) : TVecPoint;
  var
    FromVP : TVecPoint;
    ToVP : TVecPoint;
    n : integer;
    d : real;
    RP : TVecPoint;
  begin
    l := abs(l);
    RP := TVecPoint.Create(0,0,0,0);
    result := RP;
    if (List.Count < 2) or (l > FPathLength) or (l = 0) then exit;
    n := 0;

    while n < List.Count - 1 do
    begin
      FromVP := TVecPoint(List.Items[n]);
      ToVP   := TVecPoint(List.Items[n + 1]);

      if ToVP.TotalLength = l then
      begin
        RP.X := ToVP.X;
        RP.Y := ToVP.Y;
        RP.DX := FromVP.DX;
        RP.DY := FromVP.DY;
        exit;
      end else if ToVP.TotalLength > l then
      begin
        d := (ToVP.TotalLength - l);
        RP.X := round(FromVP.X + d * FromVP.DX);
        RP.Y := round(FromVP.Y + d * FromVP.DY);
        RP.DX := FromVP.DX;
        RP.DY := FromVP.DY;
        exit;
      end else n := n + 1;
    end;
  end;

begin
  //how complex are both gestures?
  delta := MG.CValue / FCValue;
  if (delta < 0.6) or (delta > 1.4) then
  begin
    // the complexibility of both gestures differs too much, can't be the same
    result := False;
    exit;
  end;

  // Put all points into a temporary list
  CPoints := TObjectList.Create(True);
  for n := 0 to MG.Points.Count -1 do
      CPoints.Add(TVecPoint.Create(TVecPoint(MG.Points.Items[n])));

  // Scale the points so that the overall lengths of both gestures match
  ScalePoints(FPathLength / MG.PathLength);
  l := 0;
  delta := 0;
  cdelta := 0;
  repeat
    l := l + 20;
    SP := GetPointByLength(l,FPoints);
    CP := GetPointByLength(l,CPoints);
    delta := delta + Sqrt((SP.X - CP.X)*(SP.X - CP.X) + (SP.Y - CP.Y)*(SP.Y - CP.Y));
    cdelta := cdelta + abs(SP.DX - CP.DX) + abs (SP.DY - CP.DY);
    SP.Free;
    CP.Free;
  until l >= FPathLength;

  globaldelta := delta;
  globalcdelta := cdelta;
  if (FPathLength / delta < 0.4) or (FCValue / cdelta < 0.5)   then result := False
     else result := True;

  CPoints.Free;
end;

end.
