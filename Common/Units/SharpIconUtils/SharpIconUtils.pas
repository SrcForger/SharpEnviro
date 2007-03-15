unit SharpIconUtils;

interface

uses Windows,
     Graphics,
     SysUtils,
     ShellApi,
     SharpThemeApi,
     CommCtrl,
     Math,
     GR32,
     GR32_PNG,
     GR32_System,
     GR32_Image,
     GR32_Layers,
     GR32_BLEND,
     GR32_Transforms,
     GR32_Filters,
     GR32_Resamplers;

procedure IconToImage(Bmp : TBitmap32; const icon : hicon);
function extrShellIcon(Bmp : TBitmap32; FileName : String) : THandle;
function GetShellIconHandle(FileName : String) : THandle;
function LoadIco(Bmp : TBitmap32; IconFile : string; Size : integer) : boolean;
function LoadPng(Bmp : TBitmap32; PngFile:string) : boolean;
function IconStringToIcon(Icon,Target : String; Bmp : TBitmap32) : boolean; overload;
function IconStringToIcon(Icon,Target : String; Bmp : TBitmap32; Size : integer) : boolean; overload;

implementation

type
  TColorRec = packed record
                b,g,r,a: Byte;
              end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

procedure IconToImage(Bmp : TBitmap32; const icon : hicon);
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
//     dc := createcompatibledc(0);
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
        AlphaUsed := false;
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
//            DeleteDC(dc);
            AlphaBmp.free;
            DeleteObject(info.hbmMask);
            DeleteObject(info.hbmColor);             
            tempbmp.free;
     end;
end;

function GetShellIconHandle(FileName : String) : THandle;
var
  FileInfo : SHFILEINFO;
  ImageListHandle : THandle;
begin
  ImageListHandle := SHGetFileInfo( pChar(FileName), 0, FileInfo, sizeof( SHFILEINFO ),
                                    SHGFI_ICON or SHGFI_SHELLICONSIZE);
  if FileInfo.hicon <> 0 then
     result := FileInfo.hicon
  else result := 0;
  DestroyIcon(FileInfo.hIcon);
  ImageList_Destroy(ImageListHandle);
end;

function extrShellIcon(Bmp : TBitmap32; FileName : String) : THandle;
var
  FileInfo : SHFILEINFO;
  ImageListHandle : THandle;
begin
  ImageListHandle := SHGetFileInfo( pChar(FileName), 0, FileInfo, sizeof( SHFILEINFO ),
                                    SHGFI_ICON or SHGFI_SHELLICONSIZE);
  if FileInfo.hicon <> 0 then
  begin
    IconToImage(Bmp,FileInfo.hicon);
    DestroyIcon(FileInfo.hIcon);
    ImageList_Destroy(ImageListHandle);
    result := FileInfo.hicon;
  end else
  begin
    result := 0;
    Bmp.SetSize(16,16);
    Bmp.Clear(color32(64,64,64,64));
  end;
  DestroyIcon(FileInfo.hIcon);
  ImageList_Destroy(ImageListHandle);
end;

function LoadIco(Bmp : TBitmap32; IconFile : string; Size : integer) : boolean;
var
  icon : Hicon;
begin
  icon := loadimage(0,pchar(IconFile),IMAGE_ICON,Size,Size,LR_DEFAULTSIZE or LR_LOADFROMFILE);
  if icon <> 0 then
  begin
    IconToImage(Bmp, icon);
    destroyicon(icon);
    result := True;
  end else
  begin
    result := False;
    Bmp.SetSize(Max(Size,1),Max(1,Size));
    Bmp.Clear(color32(64,64,64,64));
  end;
end;

function LoadPng(Bmp : TBitmap32; PngFile:string) : boolean;
var
  b : boolean;
begin
  if not FileExists(PngFile) then
  begin
    result := False;
    Bmp.SetSize(100,100);
    Bmp.Clear(color32(64,64,64,64));
    exit;
  end;

  GR32_PNG.LoadBitmap32FromPNG(Bmp,PngFile,b);
  result := true;
end;


function IconStringToIcon(Icon,Target : String; Bmp : TBitmap32) : boolean;
begin
  result := IconStringToIcon(Icon,Target,Bmp,0);
end;

function IconStringToIcon(Icon,Target : String; Bmp : TBitmap32; Size : integer) : boolean;
var
  SEIcon : TSharpEIcon;
  Ext : String;
begin
  if CompareText(Icon,'shell:icon') = 0 then
     result := (extrShellIcon(Bmp,Target) <> 0)
  else if SharpThemeApi.IsIconInIconSet(PChar(Icon)) then
  begin
    SEIcon := SharpThemeApi.GetIconSetIcon(PChar(Icon));
    result := LoadIco(Bmp,SharpThemeApi.GetIconSetDirectory + SEIcon.FileName,Size);
  end else
  begin
    if FileExists(Icon) then
    begin
      Ext := ExtractFileExt(Icon);
      if CompareText(Ext,'.png') = 0 then
         result := LoadPng(Bmp,Icon)
      else if CompareText(Ext,'.ico') = 0 then
         result := LoadIco(Bmp,Icon,0)
      else result := False;
    end else result := False;
  end;
end;

end.
