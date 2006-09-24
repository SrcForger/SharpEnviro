unit SharpLibrary;

interface

uses Classes, Forms, Messages, ShlObj, Windows, Graphics, SysUtils,
     Controls, ExtCtrls, StdCtrls, SharpApi, GR32, GR32_Filters, ActiveX;

const
  SHACF_AUTOSUGGEST_FORCE_ON = $10000000;
  SHACF_AUTOSUGGEST_FORCE_OFF = $20000000;
  SHACF_AUTOAPPEND_FORCE_ON = $40000000;
  SHACF_AUTOAPPEND_FORCE_OFF = $80000000;
  SHACF_DEFAULT = $0;
  SHACF_FILESYSTEM = $1;
  SHACF_URLHISTORY = $2;
  SHACF_URLMRU = $4;

function SHAutoComplete(hwndEdit: HWnd; dwFlags: DWORD): HResult; stdcall; external 'Shlwapi.dll';

type
  TImageEX = class(TImage)
    private
      FOnMouseLeave: TNotifyEvent;
      FOnMouseEnter: TNotifyEvent;
    protected
      procedure CMMouseLeave(var msg : TMessage); message CM_MOUSELEAVE;
      procedure CMMouseEnter(var msg : TMessage); message CM_MOUSEENTER;
    public
      constructor Create(Owner: TComponent); override;
      destructor Destroy; override;
    published
      property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
      property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    end;

type
    TColorRec = packed record
                  b,g,r,a: Byte;
                end;
    TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
    PColorArray = ^TColorArray;

function GetSpecialFolder(wnd: HWND; iFolder: integer): string;
function GetWindowCaption(hCap: HWND): string;
function LockWS: Boolean;
function NeededServiceRunning(szService: PChar): boolean;
function SendMessageEX(szClass: pchar = nil; szWindow: pchar = nil; msgParm: Cardinal = 0; parm1: integer = 0; parm2: integer = 0): boolean;
function WindowsExit(RebootParam: Longword): Boolean;

procedure CromaKey(ABitmap: TBitmap32; TrColor: TColor32);
procedure GetWindowIcon(var Icon: HICON; Handle: HWnd; iSize: integer = 0);
procedure IconToImage(Bmp : TBitmap32; const icon : HIcon);
procedure TurnOnAutoComplete(edOn: TEdit);

implementation

//This one line of code puts a form inside of SharpDesk, in this example
//  Windows.SetParent(Handle, FindWindow('TSharpDeskMainForm', nil));

procedure TurnOnAutoComplete(edOn: TEdit);
var
  Options: dWord;
begin
  Options := SHACF_FILESYSTEM or SHACF_URLHISTORY or SHACF_URLMRU or
               SHACF_AUTOSUGGEST_FORCE_ON or SHACF_AUTOAPPEND_FORCE_ON;

  if Succeeded(CoInitialize(nil)) then begin
   try
    SHAutoComplete(edOn.Handle, Options);
   finally
    CoUninitialize;
   end;
  end;
end;

{$REGION ' TImageEx Procedures '}
constructor TImageEx.Create(Owner: TComponent);
begin
 inherited Create(Owner);

 Width := 16;
 Height := 16;

 Align := AlClient;
 ShowHint := True;
 Transparent := True;
end;
destructor TImageEx.Destroy;
begin
  inherited Destroy;
end;
procedure TImageEx.CMMouseLeave(var msg : TMessage);
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;
procedure TImageEx.CMMouseEnter(var msg : TMessage);
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;
{$ENDREGION}

{$REGION ' File Routines '}
function PathPaths(sPath: string): TStringList;
var
  Tokens: TStringList;
  s: string;
  i: integer;
begin
  Tokens := TStringList.Create;
  try
    Result := TStringList.Create;
    Tokens.Delimiter := '\';
    Tokens.DelimitedText := sPath;
    s := '';
    for i := 0 to Tokens.Count-1 do begin
      s := s + Tokens[i];
      if i < Tokens.Count-1 then s := s + '\';
      Result.Add(s);
    end;
  finally
    Tokens.Free;
  end;
end;
function GetSpecialFolder(wnd: HWND; iFolder: integer): string;
var
  idl: PItemIDList;
  Buffer: array[0..MAX_PATH-1] of Char;
begin
	Result := '';

  SHGetSpecialFolderLocation(wnd, iFolder, idl);
  SHGetPathFromIDList(idl, Buffer);
  Result := Buffer;
end;
{$ENDREGION}

{$REGION ' Graphic Routines '}
procedure IconToImage(Bmp : TBitmap32; const icon : HIcon);
var
   w,h,i    : Integer;
   p        : PColorArray;
   p2       : pColor32;
   bmi      : BITMAPINFO;
   AlphaBmp : Tbitmap32;
   tempbmp  : Tbitmap;
   info     : Ticoninfo;
   alphaUsed : boolean;
begin
     Alphabmp := nil;
     tempbmp := Tbitmap.Create;
     try
        //get info about icon
        GetIconInfo(icon,info);
        tempbmp.handle := info.hbmColor;
        ///////////////////////////////////////////////////////
        // Here comes a ugly step were it tries to paint it as
        // a 32 bit icon and check if it is successful.
        // If failed it will paint it as an icon with fewer colors.
        // No way of deciding bitcount in the beginning has been
        // found reliable , try if you want too.   /Malx
        ///////////////////////////////////////////////////////
        AlphaUsed := False;
        if true then
        begin //32-bit icon with alpha
              w := tempbmp.Width;
              h := tempbmp.Height;
              Bmp.setsize(w,h);
              with bmi.bmiHeader do
              begin
                   biSize := SizeOf(bmi.bmiHeader);
                   biWidth := w;
                   biHeight := -h;
                   biPlanes := 1;
                   biBitCount := 32;
                   biCompression := BI_RGB;
                   biSizeImage := 0;
                   biXPelsPerMeter := 1; //dont care
                   biYPelsPerMeter := 1; //dont care
                   biClrUsed := 0;
                   biClrImportant := 0;
              end;
              GetMem(p,w*h*SizeOf(TColorRec));
              GetDIBits(tempbmp.Canvas.Handle,tempbmp.Handle,0,h,p,bmi,DIB_RGB_COLORS);
              P2 := Bmp.PixelPtr[0, 0];
              for i := 0 to w*h-1 do
              begin
                   if (p[i].a > 0) then alphaused := true;
                   P2^ := color32(p[i].r,p[i].g,p[i].b,p[i].a);
                   Inc(P2);// proceed to the next pixel
              end;
              FreeMem(p);
        end;
        if not(alphaused) then
        begin // 24,16,8,4,2 bit icons
              Bmp.Assign(tempbmp);
              AlphaBmp := Tbitmap32.Create;
              tempbmp.handle := info.hbmMask;
              AlphaBmp.Assign(tempbmp);
              Invert(AlphaBmp,AlphaBmp);
              Intensitytoalpha(Bmp,AlphaBmp);
        end;
     finally
            AlphaBmp.free;
            DeleteObject(info.hbmMask);
            DeleteObject(info.hbmColor);
            tempbmp.free;
     end;
end;
procedure CromaKey(ABitmap: TBitmap32; TrColor: TColor32);
var
  P: PColor32;
  C: TColor32;
  I: Integer;
begin
  TrColor := TrColor and $00FFFFFF; // erase alpha, (just in case it has some)
  with ABitmap do
  begin
    P := PixelPtr[0, 0];
    for I := 0 to Width * Height - 1 do
    begin
      C := P^ and $00FFFFFF; // get RGB without alpha
      if C = TrColor then // is this pixel "transparent"?
        P^ := C; // write RGB with "transparent" alpha back into the SrcBitmap
      Inc(P); // proceed to the next pixel
    end;
  end;
end;
{$ENDREGION}

{$REGION ' Windows Routines '}
function GetWindowCaption(hCap: HWND): string;
var
  Buf: array[0..255] of Char;
begin
  GetWindowText(hCap, Buf, SizeOf(Buf)-1);

  Result := Buf;
end;
function LockWS: Boolean;
type
  TLockWorkStation = function: Boolean;
var
  hUser32: HMODULE;
  LockWorkStation: TLockWorkStation;
begin
  Result := False;
  
  hUser32 := GetModuleHandle('USER32.DLL');
  if hUser32 <> 0 then
  begin
    @LockWorkStation := GetProcAddress(hUser32, 'LockWorkStation');
    if @LockWorkStation <> nil then
    begin
      LockWorkStation;
      Result := True;
    end;
  end;
end;
function SendMessageEX(szClass: pchar = nil; szWindow: pchar = nil; msgParm: Cardinal = 0; parm1: integer = 0; parm2: integer = 0): boolean;
var
	wnd: HWND;
begin
	Result := False;

	wnd := FindWindow(szClass, szWindow);

  if (wnd > 0) then
   begin
    SendMessage(wnd, msgParm, parm1, parm2);

    Result := True;
   end;
end;
function WindowsExit(RebootParam: Longword): Boolean;
var
   TTokenHd: THandle;
   TTokenPvg: TTokenPrivileges;
   cbtpPrevious: DWORD;
   rTTokenPvg: TTokenPrivileges;
   pcbtpPreviousRequired: DWORD;
   tpResult: Boolean;
const
   SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
   if Win32Platform = VER_PLATFORM_WIN32_NT then
   begin
     tpResult := OpenProcessToken(GetCurrentProcess(),
       TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
       TTokenHd) ;
     if tpResult then
     begin
       tpResult := LookupPrivilegeValue(nil,
                                        SE_SHUTDOWN_NAME,
                                        TTokenPvg.Privileges[0].Luid) ;
       TTokenPvg.PrivilegeCount := 1;
       TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
       cbtpPrevious := SizeOf(rTTokenPvg) ;
       pcbtpPreviousRequired := 0;
       if tpResult then
         Windows.AdjustTokenPrivileges(TTokenHd,
                                       False,
                                       TTokenPvg,
                                       cbtpPrevious,
                                       rTTokenPvg,
                                       pcbtpPreviousRequired) ;
     end;
   end;
   Result := ExitWindowsEx(RebootParam, 0) ;
end;
procedure GetWindowIcon(var Icon: HICON; Handle: HWnd; iSize: integer = 0);
begin
  SendMessageTimeout(Handle, WM_GETICON, 0, 0, SMTO_ABORTIFHUNG, 1000, DWORD(Icon));

  if (iSize = 0) then
   begin
    if (Icon = 0) then Icon := HICON(GetClassLong(Handle, GCL_HICON));
   end;

  if (iSize = 1) then
   begin
    if (Icon = 0) then Icon := HICON(GetClassLong(Handle, GCL_HICONSM));
   end;

  if (Icon = 0) then SendMessageTimeout(Handle, WM_GETICON, 1, 0, SMTO_ABORTIFHUNG, 1000, DWORD(Icon));
  if (Icon = 0) then Icon := HICON(GetClassLong(Handle, GCL_HICON));
  if (Icon = 0) then SendMessageTimeout(Handle, WM_QUERYDRAGICON, 0, 0, SMTO_ABORTIFHUNG, 1000, DWORD(Icon));

  if (Icon = 0) then Icon := LoadIcon(0, IDI_WINLOGO);
end;
{$ENDREGION}

function NeededServiceRunning(szService: PChar): boolean;
var
  hr: HResult;
begin
  Result := False;

  try
   hr := IsServiceStarted(szService);

   Result := (hr = MR_STARTED);
  except
  end;
end;

end.
