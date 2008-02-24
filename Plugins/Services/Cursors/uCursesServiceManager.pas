{
Source Name: uCursesServiceManager
Description: Cursor Management
Copyright (C) (2007) Martin Krämer (MartinKraemer@gmx.net)
              (2004) Pixol (Pixol@SharpE-Shell.org)
              (2004) Zack Cerza - zcerza@coe.neu.edu

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

unit uCursesServiceManager;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  sharpapi,
  SharpCenterApi,
  sharpthemeapi,
  jvSimpleXml,
  jclStrings,

  uCursesServiceSettings;

type
  TCursorInfo = class(TObject)
  private
    FName: string;
    FAuthor: string;
    FOtherInfo: string;
    FPath: string;

    FAppStarting: string;
    FHand: string;
    FHelp: string;
    FIbeam: string;
    FNo: string;
    FNormal: string;
    FSizeall: string;
    FSizenesw: string;
    FSizens: string;
    FSizenwse: string;
    FSizewe: string;
    FWait: string;
  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property OtherInfo: string read FOtherInfo write FOtherInfo;
    property Path: string read FPath write FPath;

    property AppStarting: string read FAppStarting write FAppStarting;
    property Hand: string read FHand write FHand;
    property Help: string read FHelp write FHelp;
    property Ibeam: string read FIBeam write FIBeam;
    property No: string read FNo write FNo;
    property Normal: string read FNormal write FNormal;
    property Sizeall: string read FSizeAll write FSizeAll;
    property Sizenesw: string read FSizeNESW write FSizeNESW;
    property Sizens: string read FSizeNS write FSizeNS;
    property Sizenwse: string read FSizeNWSE write FSizeNWSE;
    property Sizewe: string read FSizeWE write FSizeWE;
    property Wait: string read FWait write FWait;
  end;

  TCursesManager = class
  private
    function GetCursesFolder: string;
    function GetPoint(s: string): TPoint;
    function Bitmap2Cursor(Bitmap: TBitmap; HotSpot: TPoint): HCursor;
    procedure ReplaceColor(Bitmap: TBitmap; Col1, Col2: TColor);
  public
    FCursorInfo: TCursorInfo;
    FCursesSettings: TCursesSettings;

    CursorBmpArray: array[0..10] of TBitmap;

    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure ApplySkin;
    procedure UpdateCursorInfo;

    procedure MessageHandler(var msg: TMessage);

    property CursesFolder: string read GetCursesFolder;
  end;

var
  CursesManager: TCursesManager;

  CursorItemArray: array[0..9] of string = ('appstarting.bmp', 'wait.bmp',
    'hand.bmp', 'no.bmp', 'ibeam.bmp', 'sizeall.bmp',
    'sizenesw.bmp', 'sizens.bmp', 'sizenwse.bmp', 'sizewe.bmp');

  ItemSelectedID: Integer = 0;
  bmp: TBitmap;
  n: longint;
  SchemeChanged: Boolean = True;
  IsStarted, isConfig: Boolean;
  h: Thandle;

procedure Debug(Text: string; DebugType: Integer);

implementation

procedure Debug(Text: string; DebugType: Integer);
begin
  SendDebugMessageEx('Curses Service', Pchar(Text), 0, DebugType);
end;

{ TCursesManager }

procedure TCursesManager.MessageHandler(var msg: TMessage);
begin
  if msg.Msg = WM_SHARPEUPDATESETTINGS then
  begin
    if (msg.wparam = Integer(suCursor)) or (msg.wparam = Integer(suScheme))
       or (msg.wparam = Integer(suSkin)) or (msg.wparam = Integer(suTheme)) then
    begin
      SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);
      FCursesSettings.Load;
      if length(trim(FCursesSettings.CurrentSkin)) > 0 then
      begin
        UpdateCursorInfo;
        ApplySkin;
      end;
    end;
  end;
end;

procedure TCursesManager.ApplySkin;
var
  n: integer;
  clist : array of integer;
begin
  for n := Low(CursorBmpArray) to High(CursorBmpArray) do
      if CursorBmpArray[n] <> nil then
      begin
        CursorBmpArray[n].Free;
        CursorBmpArray[n] := nil;
      end;

  // convert to scheme colors
  setlength(clist,length(FCursesSettings.Colors));
  for n := 0 to High(FCursesSettings.Colors) do
  begin
    clist[n] := SharpThemeApi.SchemeCodeToColor(FCursesSettings.Colors[n]);

    // black will be transparent... but if selected as blend then color it's
    // not supposed to be transparent, so adjust the black and make clFuchsia
    // the new transparent color...
    if clist[n] = 0 then
       clist[n] := 1
       else if clist[n] = clFuchsia then
               clist[n] := 0;
  end;

  // Assign Bitmaps
  for n := 0 to 10 do
  begin
    if n = 0 then
    begin
      CursorBmpArray[n] := TBitMap.Create;
      CursorBmpArray[n].LoadFromFile(FCursorInfo.Path + 'normal.bmp');
    end
    else begin
      CursorBmpArray[n] := TBitMap.Create;
      CursorBmpArray[n].LoadFromFile(FCursorInfo.Path + CursorItemArray[n - 1]);
    end;

    ReplaceColor(CursorBmpArray[n], clRed,    clist[0]);
    ReplaceColor(CursorBmpArray[n], clBlue,   clist[1]);
    ReplaceColor(CursorBmpArray[n], clLime,  clist[2]);
    ReplaceColor(CursorBmpArray[n], clYellow, clist[3]);
  end;
  setlength(clist,0);

  // Assign Bitmaps to Cursors
  with FCursorInfo do
  begin
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[0], GetPoint(Normal)), OCR_NORMAL);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[1], GetPoint(AppStarting)), OCR_APPSTARTING);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[2], GetPoint(Wait)), OCR_WAIT);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[3], GetPoint(hand)), OCR_HAND);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[4], GetPoint(no)), OCR_NO);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[5], GetPoint(ibeam)), OCR_IBEAM);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[6], GetPoint(sizeall)), OCR_SIZEALL);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[7], GetPoint(sizenesw)), OCR_SIZENESW);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[8], GetPoint(Normal)), OCR_SIZENS);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[9], GetPoint(Normal)), OCR_SIZENWSE);
    SetSystemCursor(Bitmap2Cursor(CursorBmpArray[10], GetPoint(Normal)), OCR_SIZEWE);
  end;
end;

function TCursesManager.Bitmap2Cursor(Bitmap: TBitmap;
  HotSpot: TPoint): HCursor;
var
  IconInfo: TIconInfo;
begin
  try
    IconInfo.fIcon := False;
    IconInfo.hbmColor := bitmap.handle;
    IconInfo.hbmMask := bitmap.maskhandle;
    IconInfo.xHotspot := hotspot.x;
    IconInfo.yHotspot := hotspot.y;

    Result := CreateIconIndirect(IconInfo);
  finally
  end;
end;

constructor TCursesManager.Create;
begin
  inherited Create;

  FCursorInfo := TCursorInfo.Create;
  FCursesSettings := TCursesSettings.Create;
  if length(trim(FCursesSettings.CurrentSkin)) > 0 then
  begin
    UpdateCursorInfo;
    ApplySkin;
  end;
end;

destructor TCursesManager.Destroy;
var
  i: integer;
begin
  FCursorInfo.Free;
  FCursesSettings.Free;

  for i := Low(CursorBmpArray) to High(CursorBmpArray) do
    CursorBmpArray[i].Free;

  inherited Destroy;
end;

function TCursesManager.GetCursesFolder: string;
begin
  Result := SharpApi.GetSharpeDirectory + 'Cursors\';
  ForceDirectories(Result);
end;

function TCursesManager.GetPoint(s: string): TPoint;
var
  strl: Tstringlist;
  x, y: integer;
begin
  strl := TStringlist.Create;
  try
    StrTokenToStrings(s, ',', strl);
    x := StrToInt(Strl.Strings[0]);
    y := StrToInt(Strl.Strings[1]);
    Result := Point(x, y);
  finally
    Strl.Free;
  end;
end;

procedure TCursesManager.UpdateCursorInfo;
var
  sr: TSearchRec;
  XML: TJvSimpleXML;
  xmlfile : String;
begin
  XML := TJvSimpleXML.Create(nil);

  if FindFirst(GetCursesFolder + '*.*', faDirectory, sr) = 0 then
  begin
    repeat
      if (CompareText(sr.Name,'.') <> 0) and
         (CompareText(sr.Name,'..') <> 0) then
         begin
           if CompareText(sr.Name,FCursesSettings.CurrentSkin) = 0 then
           begin
             xmlfile := GetCursesFolder + sr.Name + '\skin.xml';
             if fileexists(xmlfile) then
             begin
               try
                 xml.LoadFromFile(xmlfile);
                 Debug(Format('Load Cursor: %s', [sr.Name]), DMT_STATUS);

                 with xml.Root.Items do
                 begin
                   FCursorInfo.Path := GetCursesFolder + sr.Name + '\';
                   if ItemNamed['SknDef'] <> nil then
                      with ItemNamed['SknDef'].Items do
                      begin
                        FCursorInfo.Name := Value('Title','');
                        FCursorInfo.Author := Value('Author','');
                        FCursorInfo.OtherInfo := Value('OtherInfo','');
                      end;

                   if ItemNamed['CursPoints'] <> nil then
                      with ItemNamed['CursPoints'].Items do
                      begin
                        FCursorInfo.AppStarting := Value('AppStarting', '');
                        FCursorInfo.Hand        := Value('Hand', '');
                        FCursorInfo.Help        := Value('Help', '');
                        FCursorInfo.IBeam       := Value('IBeam', '');
                        FCursorInfo.No          := Value('No', '');
                        FCursorInfo.Normal      := Value('Normal', '');
                        FCursorInfo.SizeAll     := Value('SizeAll', '');
                        FCursorInfo.SizeNESW    := Value('SizeNESW', '');
                        FCursorInfo.SizeNS      := Value('SizeNS', '');
                        FCursorInfo.SizeNWSE    := Value('SizeNWSE', '');
                        FCursorInfo.SizeWE      := Value('SizeWE', '');
                        FCursorInfo.Wait        := Value('Wait', '');
                      end;
                 end;
               except
                 on E: Exception do
                 begin
                   Debug(Format('Error While Loading Curses Skin: %s', [xmlfile]),DMT_ERROR);
                   Debug(E.Message, DMT_TRACE);
                 end;
             end;
           end;
         end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  XML.Free;
end;

procedure TCursesManager.ReplaceColor(Bitmap: TBitmap; Col1, Col2: TColor);
type
  TrRGB = packed record
    b, g, r: Byte;
  end;
  PRGBAry = ^TRGBAry;
  TRGBAry = array[0..16383] of TrRGB;

var
  PSL: PRGBAry;
  RByte, GByte, BByte: Byte;
  x, y: Integer;
begin
  Bitmap.PixelFormat := pf24bit;
  {you MUST change the PixelFormat to pf24bit
  other Pixel Formats will NOT work in this type of scanline}

  RByte := GetRValue(col1);
  GByte := GetGValue(col1);
  BByte := GetBValue(col1);
  {get the Red green and blue bytes for the color you want to change}
  for y := 0 to Bitmap.Height - 1 do begin
    PSL := Bitmap.ScanLine[y];
    for x := 0 to Bitmap.Width - 1 do
      if (PSL[x].r = RByte) and (PSL[x].g = GByte) and (PSL[x].b = BByte) then begin
        {set the Red Green and Blue for the NEW color here}
        PSL[x].r := GetRValue(col2);
        PSL[x].g := GetGValue(col2);
        PSL[x].b := GetBValue(col2)
      end;
  end;
end;

end.

