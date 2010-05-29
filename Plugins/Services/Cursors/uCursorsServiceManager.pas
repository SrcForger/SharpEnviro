{
Source Name: uCursorsServiceManager
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

unit uCursorsServiceManager;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Types,
  Windows,
  Messages,
  SysUtils, StrUtils,
  Classes,
  GR32, GR32_Image, GR32_PNG,
  Graphics,
  sharpapi,
  SharpGraphicsUtils,
  SharpThemeApiEx,
  jvSimpleXml,
  jclStrings,
  uISharpETheme,
  ExtCtrls, StdCtrls,

  uCursorsServiceSettings;

type
  TCursor = class(TObject)
  private
    FType: integer;
    FPoint: string;

    FIsValid, FHasAlpha, FReplaceColor : boolean;
    FWidth, FHeight: integer;
    FCurFrame, FNumFrames: integer;
    FBitmap, FCurBitmap: TBitmap32;
    FhCursor: HICON;

  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure ReplaceColors(clist : Array of integer);
    function Load(path: string; Settings: TCursorsSettings): boolean;

    function GetBitmap(): TBitmap32;

    // Properties
    property IsValid: boolean read FIsValid;
    property HasAlpha: boolean read FHasAlpha;
    property ReplaceColor: boolean write FReplaceColor;
    property CType: integer read FType write FType; 
    property Point: string read FPoint write FPoint;
    property Width: integer read FWidth write FWidth;
    property Height: integer read FHeight write FHeight;
    property NumFrames: integer read FNumFrames write FNumFrames;
    property CurFrame: integer read FCurFrame;
    property Bitmap: TBitmap32 read GetBitmap;
    property Cursor: HICON read FhCursor;
  end;

  TCursorInfo = class(TObject)
  private
    FName: string;
    FAuthor: string;
    FOtherInfo: string;
    FPath: string;

    Cursors: Array of TCursor;

  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property OtherInfo: string read FOtherInfo write FOtherInfo;
    property Path: string read FPath write FPath;
  end;

  TCursorsManager = class
  private
    function GetCursorsFolder: string;
    function GetPoint(s: string): TPoint;
    function BitmapToCursor(Bitmap: TBitmap; HotSpot: TPoint): HCursor;
    function Bitmap32ToCursor(Bitmap: TBitmap32;HotSpot: TPoint): HCursor;

    procedure CursorOnTimer(Sender: TObject);
  public
    UpdTimer: TTimer;
    CurrentCursor: integer;

    FCursorInfo: TCursorInfo;
    FCursorsSettings: TCursorsSettings;

    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure ApplySkin;
    procedure UpdateCursorInfo;

    procedure MessageHandler(var msg: TMessage);

    property CursorsFolder: string read GetCursorsFolder;
  end;

var
  CursorsManager: TCursorsManager;

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
  SendDebugMessageEx('Cursors Service', Pchar(Text), 0, DebugType);
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

  FIsValid := false;
  FHasAlpha := false;

  FBitmap := TBitmap32.Create();
  FCurBitmap := TBitmap32.Create();
  FhCursor := 0;

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

procedure TCursor.ReplaceColors(clist : Array of integer);
begin
  if FReplaceColor then
  begin
    // Replace colors & alpha
    if FHasAlpha <> true then
      ReplaceColor32(FBitmap, color32(0,0,0,255), color32(0,0,0,0));

    ReplaceColor32(FBitmap, color32(255,0,0,255), color32(GetRValue(clist[0]),GetGValue(clist[0]),GetBValue(clist[0]),255));
    ReplaceColor32(FBitmap, color32(0,0,255,255), color32(GetRValue(clist[1]),GetGValue(clist[1]),GetBValue(clist[1]),255));
    ReplaceColor32(FBitmap, color32(0,255,0,255), color32(GetRValue(clist[2]),GetGValue(clist[2]),GetBValue(clist[2]),255));
    ReplaceColor32(FBitmap, color32(255,255,0,255), color32(GetRValue(clist[3]),GetGValue(clist[3]),GetBValue(clist[3]),255));
  end;
end;

function TCursor.Load(path: string; Settings: TCursorsSettings): boolean;
var
  n: integer;
  clist : array of integer;
  Theme : ISharpETheme;
begin
  Result := False;

  try
    // Check if the file is in cursor format (.ani or .cur)
    FhCursor := LoadCursorFromFile(PAnsiChar(path));
    if FhCursor <> 0 then
    begin
      FIsValid := true;
    end else
    begin
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
      FIsValid := true;
      FHasAlpha := false;
      try
        if CompareText(ExtractFileExt(path),'.bmp') = 0 then
          FBitmap.LoadFromFile(path)
        else LoadBitmap32FromPng(FBitmap, path, FHasAlpha);
        ReplaceColors(clist);
      except
        FIsValid := false;
      end;

      setlength(clist,0);

      Result := True;
    end;

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
    if FIsValid = true then
    begin
      FCurBitmap.SetSize(FWidth, FHeight);
      FCurBitmap.Clear(color32(0,0,0,0));

      sRect := Rect(FWidth * FCurFrame, 0, FWidth + (FCurFrame * FWidth), FHeight);
      FBitmap.DrawTo(FCurBitmap, 0, 0, sRect);

      FCurFrame := FCurFrame + 1;
      if(FCurFrame >= FNumFrames) then
        FCurFrame := 0;

        Result := FCurBitmap;
    end else
      Result := nil;
  except
    on E: Exception do
    begin
      Debug('Error While Getting Bitmap',DMT_ERROR);
      Debug(E.Message, DMT_TRACE);

      Result := nil;
    end;
  end;
end;


{ TCursorsManager }

procedure TCursorsManager.MessageHandler(var msg: TMessage);
begin
  if msg.Msg = WM_SHARPEUPDATESETTINGS then
  begin
    if (msg.wparam = Integer(suCursor)) or (msg.wparam = Integer(suScheme))
       or (msg.wparam = Integer(suSkin)) or (msg.wparam = Integer(suTheme)) then
    begin
      FCursorsSettings.Load;
      if length(trim(FCursorsSettings.CurrentSkin)) > 0 then
      begin
        UpdateCursorInfo;
        ApplySkin;
      end;
    end;
  end else msg.Result := DefWindowProc(h,msg.Msg,Msg.WParam,msg.LParam);
end;



procedure TCursorsManager.ApplySkin;
var
  i : integer;
begin
  // Assign Bitmaps to Cursors
  with FCursorInfo do
  begin
    for i := Low(Cursors) to High(Cursors) do
    begin
      if (Cursors[i].IsValid) and (Cursors[i].Cursor <> 0) then
      begin
        SetSystemCursor(Cursors[i].Cursor, Cursors[i].CType);
      end else if (Cursors[i].IsValid) then
      begin
        SetSystemCursor(Bitmap32ToCursor(Cursors[i].Bitmap, GetPoint(Cursors[i].Point)), Cursors[i].CType);
      end;
    end;
  end;
end;

procedure TCursorsManager.CursorOnTimer(Sender: TObject);
var
  i: integer;
begin
  try
  with FCursorInfo do
  begin
    for i := Low(Cursors) to High(Cursors) do
    begin
      if (Cursors[i].IsValid) and (Cursors[i].Cursor <> 0) then
        SetSystemCursor(Cursors[i].Cursor, Cursors[i].CType)
      else if (Cursors[i].IsValid) and (Cursors[i].NumFrames > 1) then
        SetSystemCursor(Bitmap32ToCursor(Cursors[i].Bitmap, GetPoint(Cursors[i].Point)), Cursors[i].CType);
    end;
  end;
  except
    on E: Exception do
    begin
      Debug('Error In OnTimer function, stopping the timer. Please restart the Cursor service.', DMT_ERROR);
      Debug(E.Message, DMT_TRACE);

      UpdTimer.Enabled := false;
    end;
  end;
end;

function TCursorsManager.BitmapToCursor(Bitmap: TBitmap;
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
  except
    Result := 0;
  end;
end;

function TCursorsManager.Bitmap32ToCursor(Bitmap: TBitmap32;
  HotSpot: TPoint): HCursor;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  try
    bmp.Assign(Bitmap);
    Result := BitmapToCursor(bmp, HotSpot);
  finally
    bmp.Free;
  end;
end;

constructor TCursorsManager.Create;
begin
  inherited Create;

  UpdTimer := TTimer.Create(nil);
  UpdTimer.OnTimer := CursorOnTimer;
  UpdTimer.Enabled := False;

  FCursorInfo := TCursorInfo.Create;
  SetLength(FCursorInfo.Cursors, 0);

  FCursorsSettings := TCursorsSettings.Create;
  if length(trim(FCursorsSettings.CurrentSkin)) > 0 then
  begin
    UpdateCursorInfo;
    ApplySkin;
  end;
end;

destructor TCursorsManager.Destroy;
var
  i: integer;
begin
  UpdTimer.Enabled := false;

  for i := Low(FCursorInfo.Cursors) to High(FCursorInfo.Cursors) do
    FCursorInfo.Cursors[i].Free;

  FCursorInfo.Free;
  FCursorsSettings.Free;

  inherited Destroy;
end;

function TCursorsManager.GetCursorsFolder: string;
begin
  Result := SharpApi.GetSharpeDirectory + 'Cursors\';
  ForceDirectories(Result);
end;

function TCursorsManager.GetPoint(s: string): TPoint;
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

procedure TCursorsManager.UpdateCursorInfo;
var
  sr: TSearchRec;
  XML: TJvSimpleXML;
  xmlfile : String;

  I, C : integer;
  IName : string;
begin
  UpdTimer.Enabled := false;

  XML := TJvSimpleXML.Create(nil);

  if Length(FCursorInfo.Cursors) > 0 then
  begin
    for i := Low(FCursorInfo.Cursors) to High(FCursorInfo.Cursors) do
      FCursorInfo.Cursors[i].Free;
    SetLength(FCursorInfo.Cursors, 0);
  end;

  if FindFirst(GetCursorsFolder + '*.*', faDirectory, sr) = 0 then
  begin
    repeat
      if (CompareText(sr.Name,'.') <> 0) and
         (CompareText(sr.Name,'..') <> 0) then
         begin
           if CompareText(sr.Name,FCursorsSettings.CurrentSkin) = 0 then
           begin
             xmlfile := GetCursorsFolder + sr.Name + '\skin.xml';
             if fileexists(xmlfile) then
             begin
               try
                 xml.LoadFromFile(xmlfile);
                 Debug(Format('Load Cursor: %s', [sr.Name]), DMT_STATUS);

                 with xml.Root.Items do
                 begin
                   FCursorInfo.Path := GetCursorsFolder + sr.Name + '\';
                   if ItemNamed['SknDef'] <> nil then
                      with ItemNamed['SknDef'].Items do
                      begin
                        FCursorInfo.Name := Value('Title','');
                        FCursorInfo.Author := Value('Author','');
                        FCursorInfo.OtherInfo := Value('OtherInfo','');
                        UpdTimer.Interval := IntValue('AnimInterval', 1000);
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
                            FCursorInfo.Cursors[C].ReplaceColor := true;
                            FCursorInfo.Cursors[C].Width := 32;
                            FCursorInfo.Cursors[C].Height := 32;
                            FCursorInfo.Cursors[C].Point := Value(Item[I].Name, '');
                            FCursorInfo.Cursors[C].NumFrames := 0;
                            FCursorInfo.Cursors[C].CType := GetCursorID(Item[I].Name);
                            FCursorInfo.Cursors[C].Load(FCursorInfo.Path + AnsiLowerCase(Item[I].Name) + '.bmp', FCursorsSettings);

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
                                    FCursorInfo.Cursors[C].ReplaceColor := BoolValue('ReplaceColor', True);
                                    FCursorInfo.Cursors[C].Width := IntValue('Width', 32);
                                    FCursorInfo.Cursors[C].Height := IntValue('Height', 32);
                                    FCursorInfo.Cursors[C].Point := Value('Point', '');
                                    FCursorInfo.Cursors[C].NumFrames := IntValue('NumFrames', 1);
                                    FCursorInfo.Cursors[C].CType := GetCursorID(IName);
                                    UpdTimer.Enabled := FCursorInfo.Cursors[C].Load(FCursorInfo.Path + Value('File', ''), FCursorsSettings);

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
                   Debug(Format('Error While Loading Cursors Skin: %s', [xmlfile]),DMT_ERROR);
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

