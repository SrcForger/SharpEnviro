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
  GR32,
  GR32_Image,
  Graphics,
  sharpapi,
  SharpGraphicsUtils,
  SharpThemeApiEx,
  jvSimpleXml,
  jclStrings,
  uISharpETheme,
  ExtCtrls, StdCtrls,

  uCursesServiceSettings;

type
  TCursor = class(TObject)
  private
    FPath: string;

    FType: integer;
    FPoint: string;

    FWidth: integer;
    FHeight: integer;

    FNumFrames: integer;
    FCurFrame: integer;

    FBitmap: TBitmap32;
    FCurBitmap: TBitmap32;

  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure Load(path: string; Settings: TCursesSettings);

    function GetBitmap(): TBitmap32;

    // Properties
    property CType: integer read FType write FType; 
    property Point: string read FPoint write FPoint;

    property Width: integer read FWidth write FWidth;
    property Height: integer read FHeight write FHeight;

    property NumFrames: integer read FNumFrames write FNumFrames;
    property CurFrame: integer read FCurFrame;
  end;

  TCursorInfo = class(TObject)
  private
    FName: string;
    FAuthor: string;
    FOtherInfo: string;
    FPath: string;

    FAnimInterval: integer;

    Cursors: Array of TCursor;

  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property OtherInfo: string read FOtherInfo write FOtherInfo;
    property Path: string read FPath write FPath;

    property AnimInterval: integer read FAnimInterval write FAnimInterval;
  end;

  TCursesManager = class
  private
    function GetCursesFolder: string;
    function GetPoint(s: string): TPoint;
    function Bitmap2Cursor(Bitmap: TBitmap; HotSpot: TPoint): HCursor;

    procedure CursorOnTimer(Sender: TObject);
  public
    UpdTimer: TTimer;
    CurrentCursor: integer;

    FCursorInfo: TCursorInfo;
    FCursesSettings: TCursesSettings;

    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure ApplySkin;
    procedure UpdateCursorInfo;

    procedure MessageHandler(var msg: TMessage);

    property CursesFolder: string read GetCursesFolder;
  end;

var
  CursesManager: TCursesManager;

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


procedure ReplaceColor(Bitmap: TBitmap; Col1, Col2: TColor);
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

function GetCursorID(name: string): integer;
begin
  Result := OCR_NORMAL;

  if name = 'AppStarting' then
  begin
    Result := OCR_APPSTARTING;
  end else if name = 'Wait' then
  begin
    Result := OCR_WAIT;
  end else if name = 'Hand' then
  begin
    Result := OCR_HAND;
  end else if name = 'No' then
  begin
    Result := OCR_NO;
  end else if name = 'IBeam' then
  begin
    Result := OCR_IBEAM;
  end else if name = 'SizeAll' then
  begin
    Result := OCR_SIZEALL;
  end else if name = 'SizeNESW' then
  begin
    Result := OCR_SIZENESW;
  end else if name = 'SizeNS' then
  begin
    Result := OCR_SIZENS;
  end else if name = 'SizeNWSE' then
  begin
    Result := OCR_SIZENWSE;
  end else if name = 'SizeWE' then
  begin
    Result := OCR_SIZEWE;
  end;
end;


{ TCursor }
constructor TCursor.Create;
begin
  inherited;

  FBitmap := TBitmap32.Create();
  FCurBitmap := TBitmap32.Create();

  FCurFrame := 0;
  FNumFrames := 0;
  FWidth := 0;
  FHeight := 0;
end;

destructor TCursor.Destroy;
begin
  FBitmap.free;
  FCurBitmap.free;

  inherited;
end;

procedure TCursor.Load(path: string; Settings: TCursesSettings);
var
  n: integer;
  clist : array of integer;
  Theme : ISharpETheme;
  TmpBitmap : TBitmap32;
begin
  try
  // convert to scheme colors
  setlength(clist,length(Settings.Colors));
  Theme := GetCurrentTheme;
  for n := 0 to High(Settings.Colors) do
  begin
    clist[n] := Theme.Scheme.SchemeCodeToColor(Settings.Colors[n]);

    // black will be transparent... but if selected as blend then color it's
    // not supposed to be transparent, so adjust the black and make clFuchsia
    // the new transparent color...
    if clist[n] = 0 then
       clist[n] := 1
       else if clist[n] = clFuchsia then
               clist[n] := 0;
  end;

  // Assign Bitmaps
  FPath := path;
  TmpBitmap := TBitmap32.Create();
  TmpBitmap.LoadFromFile(path);

  FBitmap.SetSize(TmpBitmap.width, TmpBitmap.height);
  FBitmap.Clear(color32(0,0,0,0));
  FBitmap.Assign(TmpBitmap);
  
  FreeAndNil(TmpBitmap);

  ReplaceColor32(FBitmap, color32(0,0,0,255), color32(0,0,0,0));
  ReplaceColor32(FBitmap, color32(255,0,0,255), color32(GetRValue(clist[0]),GetGValue(clist[0]),GetBValue(clist[0]),255));
  ReplaceColor32(FBitmap, color32(0,0,255,255), color32(GetRValue(clist[1]),GetGValue(clist[1]),GetBValue(clist[1]),255));
  ReplaceColor32(FBitmap, color32(0,255,0,255), color32(GetRValue(clist[2]),GetGValue(clist[2]),GetBValue(clist[2]),255));
  ReplaceColor32(FBitmap, color32(255,255,0,255), color32(GetRValue(clist[3]),GetGValue(clist[3]),GetBValue(clist[3]),255));

  {ReplaceColor32(FBitmap, color32(0,0,0,255), color32(0,0,0,0));
  ReplaceColor32(FBitmap, color32(255,0,0,255), clist[0]);
  ReplaceColor32(FBitmap, color32(0,0,255,255), clist[1]);
  ReplaceColor32(FBitmap, color32(0,255,0,255), clist[2]);
  ReplaceColor32(FBitmap, color32(255,255,0,255), clist[3]);  }

  setlength(clist,0);

  except
    on E: Exception do
    begin
      Debug(Format('Error While Loading Cursor: %s', [path]),DMT_ERROR);
      Debug(E.Message, DMT_TRACE);
    end;
  end;
end;

function TCursor.GetBitmap(): TBitmap32;
var
  sRect: Windows.TRect;
begin
  try
  FCurBitmap.SetSize(FWidth, FHeight);
  FCurBitmap.Clear(color32(0,0,0,0));

  sRect := Rect(FWidth * FCurFrame, 0, FWidth + (FCurFrame * FWidth), FHeight);
  FBitmap.DrawTo(FCurBitmap, 0, 0, sRect);

  FCurFrame := FCurFrame + 1;
  if(FCurFrame >= FNumFrames) then
    FCurFrame := 0;

  Result := FCurBitmap;
  except
    on E: Exception do
    begin
      Debug('Error While Getting Bitmap',DMT_ERROR);
      Debug(E.Message, DMT_TRACE);

      Result := nil;
    end;
  end;
end;


{ TCursesManager }

procedure TCursesManager.MessageHandler(var msg: TMessage);
begin
  if msg.Msg = WM_SHARPEUPDATESETTINGS then
  begin
    if (msg.wparam = Integer(suCursor)) or (msg.wparam = Integer(suScheme))
       or (msg.wparam = Integer(suSkin)) or (msg.wparam = Integer(suTheme)) then
    begin
      FCursesSettings.Load;
      if length(trim(FCursesSettings.CurrentSkin)) > 0 then
      begin
        UpdateCursorInfo;
        ApplySkin;
      end;
    end;
  end else msg.Result := DefWindowProc(h,msg.Msg,Msg.WParam,msg.LParam);
end;



procedure TCursesManager.ApplySkin;
var
  i : integer;
  Bitmap : TBitmap;
begin
  // Assign Bitmaps to Cursors
  with FCursorInfo do
  begin
    for i := Low(Cursors) to High(Cursors) do
    begin
      Bitmap := TBitmap.Create();
      Bitmap.Assign(Cursors[i].GetBitmap());
      SetSystemCursor(Bitmap2Cursor(Bitmap, GetPoint(Cursors[i].Point)), Cursors[i].CType);
    end;
  end;

  UpdTimer := TTimer.Create(nil);
  UpdTimer.Interval := FCursorInfo.AnimInterval;
  UpdTimer.OnTimer := CursorOnTimer;
  UpdTimer.Enabled := True;
end;

procedure TCursesManager.CursorOnTimer(Sender: TObject);
var
  i: integer;
  Bitmap : TBitmap;
begin
  try
  with FCursorInfo do
  begin
    for i := Low(Cursors) to High(Cursors) do
    begin
      Bitmap := TBitmap.Create();
      Bitmap.Assign(Cursors[i].GetBitmap());
      SetSystemCursor(Bitmap2Cursor(Bitmap, GetPoint(Cursors[i].Point)), Cursors[i].CType);
      Bitmap.free;
    end;
  end;
  except
    on E: Exception do
    begin
      Debug('Error In OnTimer function', DMT_ERROR);
      Debug(E.Message, DMT_TRACE);
    end;
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
  SetLength(FCursorInfo.Cursors, 0);

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
  UpdTimer.Enabled := false;

  for i := Low(FCursorInfo.Cursors) to High(FCursorInfo.Cursors) do
    FCursorInfo.Cursors[i].Free;

  FCursorInfo.Free;
  FCursesSettings.Free;

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

  I, C : integer;
  IName : string;
begin
  XML := TJvSimpleXML.Create(nil);

  if Length(FCursorInfo.Cursors) > 0 then
  begin
    for i := Low(FCursorInfo.Cursors) to High(FCursorInfo.Cursors) do
      FCursorInfo.Cursors[i].Free;
    SetLength(FCursorInfo.Cursors, 0);

    UpdTimer.Enabled := false;
  end;

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
                        FCursorInfo.AnimInterval := IntValue('AnimInterval', 1000);
                      end;

                   C := 0;
                   IName := '';

                   // Old way
                   if ItemNamed['CursPoints'] <> nil then
                   begin
                     with ItemNamed['CursPoints'].Items do
                     begin
                        for I := 0 to Count - 1 do
                        begin
                          if FileExists(FCursorInfo.Path + AnsiLowerCase(Item[I].Name) + '.bmp') then
                          begin
                            SetLength(FCursorInfo.Cursors, C + 1);

                            FCursorInfo.Cursors[C] := TCursor.Create();
                            FCursorInfo.Cursors[C].Width := 32;
                            FCursorInfo.Cursors[C].Height := 32;
                            FCursorInfo.Cursors[C].Point := Value(Item[I].Name, '');
                            FCursorInfo.Cursors[C].NumFrames := 0;
                            FCursorInfo.Cursors[C].CType := GetCursorID(Item[I].Name);
                            FCursorInfo.Cursors[C].Load(FCursorInfo.Path + AnsiLowerCase(Item[I].Name) + '.bmp', FCursesSettings);

                            C := C + 1;
                          end;
                        end;
                     end;
                   // New way (with animations)
                   end else
                   begin  
                      if ItemNamed['Cursors'] <> nil then
                        with ItemNamed['Cursors'].Items do
                        begin
                          for I := 0 to Count - 1 do
                          begin
                            IName := Item[I].Name;

                            if Item[I] <> nil then
                              with Item[I].Items do
                                begin
                                  if FileExists(FCursorInfo.Path + Value('File', '')) then
                                  begin
                                    SetLength(FCursorInfo.Cursors, C + 1);

                                    FCursorInfo.Cursors[C] := TCursor.Create();
                                    FCursorInfo.Cursors[C].Width := IntValue('Width', 32);
                                    FCursorInfo.Cursors[C].Height := IntValue('Height', 32);
                                    FCursorInfo.Cursors[C].Point := Value('Point', '');
                                    FCursorInfo.Cursors[C].NumFrames := IntValue('NumFrames', 0);
                                    FCursorInfo.Cursors[C].CType := GetCursorID(IName);
                                    FCursorInfo.Cursors[C].Load(FCursorInfo.Path + Value('File', ''), FCursesSettings);

                                    C := C + 1;
                                  end;
                                end;
                          end;
                        end;
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

end.

