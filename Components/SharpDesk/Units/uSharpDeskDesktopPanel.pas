unit uSharpDeskDesktopPanel;

interface

uses
  SysUtils,
  Types,
  GR32,
  Dialogs,
  GR32_PNG,
  SharpApi;


type
  TDesktopPanel = class
                  private
                    FUL : TBitmap32;
                    FUM : TBitmap32;
                    FUR : TBitmap32;
                    FML : TBitmap32;
                    FMM : TBitmap32;
                    FMR : TBitmap32;
                    FBL : TBitmap32;
                    FBM : TBitmap32;
                    FBR : TBitmap32;
                    FBitmap    : TBitmap32;
                    FPanelName : String;
                    FHeight    : integer;
                    FWidth     : integer;
                    FTopHeight    : integer;
                    FBottomHeight : integer;
                    FLeftWidth    : integer;
                    FRightWidth   : integer;
                  public
                    constructor Create;
                    destructor Destroy; override;
                    procedure LoadPanel(pName : String);
                    procedure ReloadPanel;
                    procedure SetSize(pWidth,pHeight : integer);
                    procedure SetCenterSize(pWidth,pHeight : integer);
                    procedure Paint;

                    property Bitmap       : TBitmap32 read FBitmap;   
                    property PanelName    : String    read FPanelName write FPanelName;
                    property Width        : integer   read FWidth;
                    property Height       : integer   read FHeight;
                    property TopHeight    : integer   read FTopHeight;
                    property BottomHeight : integer   read FBottomHeight;
                    property LeftWidth    : integer   read FLeftWidth;
                    property RightWidth   : integer   read FRightWidth;
                  end;

implementation

var
  filearray : array[0..8] of String = ('UL','UM','UR','ML','MM','MR','BL','BM','BR');

constructor TDesktopPanel.Create;
begin
  inherited Create;
  FUL := TBitmap32.Create;
  FUM := TBitmap32.Create;
  FUR := TBitmap32.Create;
  FML := TBitmap32.Create;
  FMM := TBitmap32.Create;
  FMR := TBitmap32.Create;
  FBL := TBitmap32.Create;
  FBM := TBitmap32.Create;
  FBR := TBitmap32.Create;
  FBitmap := TBitmap32.Create;
  with FUL,FUM,FUR,FML,FMM,FMR,FBL,FBM,FBR,FBitmap do
  begin
    setsize(8,8);
    clear(color32(0,0,0,0));
    DrawMode := dmBlend;
  end;
  FTopHeight    := 0;
  FBottomHeight := 0;
  FLeftWidth    := 0;
  FRightWidth   := 0;
end;

destructor TDesktopPanel.Destroy;
begin
  FUL.free;
  FUM.free;
  FUR.free;
  FML.free;
  FMM.free;
  FMR.free;
  FBL.free;
  FBM.free;
  FBR.free;
  FBitmap.free;
  inherited Destroy;
end;

procedure TDesktopPanel.SetCenterSize(pWidth,pHeight : integer);
begin
  FWidth := pWidth + FUL.Width + FUR.Width;
  FHeight := pHeight + FUL.Height + FBL.Height;
  FBitmap.SetSize(FWidth,FHeight);
end;

procedure TDesktopPanel.SetSize(pWidth,pHeight : integer);
begin
  FWidth  := pWidth;
  FHeight := pHeight;
  if FWidth<1  then FWidth  := 8;
  if FHeight<1 then FHeight := 8;
  FBitmap.SetSize(FWidth,FHeight);
end;

procedure TDesktopPanel.LoadPanel(pName : String);
var
  Dir : String;
  n : integer;
  b : boolean;
begin
  FPanelName := pName;
  Dir := GetSharpeDirectory + 'Images\Panels\' + pName + '\';
  for n := 0 to High(filearray) do
      if not FileExists(Dir + filearray[n] + '.png') then exit;

  GR32_PNG.LoadBitmap32FromPNG(FUL,Dir + 'UL.png',b);
  GR32_PNG.LoadBitmap32FromPNG(FUM,Dir + 'UM.png',b);
  GR32_PNG.LoadBitmap32FromPNG(FUR,Dir + 'UR.png',b);
  GR32_PNG.LoadBitmap32FromPNG(FML,Dir + 'ML.png',b);
  GR32_PNG.LoadBitmap32FromPNG(FMM,Dir + 'MM.png',b);
  GR32_PNG.LoadBitmap32FromPNG(FMR,Dir + 'MR.png',b);
  GR32_PNG.LoadBitmap32FromPNG(FBL,Dir + 'BL.png',b);
  GR32_PNG.LoadBitmap32FromPNG(FBM,Dir + 'BM.png',b);
  GR32_PNG.LoadBitmap32FromPNG(FBR,Dir + 'BR.png',b);

  FTopHeight    := FUM.Height;
  FBottomHeight := FBM.Height;
  FLeftWidth    := FML.Width;
  FRightWidth   := FMR.Width;
end;

procedure TDesktopPanel.ReloadPanel;
begin
  LoadPanel(FPanelName);
end;

procedure TileDraw(Src,Dst : TBitmap32; DstRect : TRect);
var
  x,y : integer;
  xn,yn : integer;
  TempBmp : TBitmap32;
begin
  if (Src = nil) or (Dst = nil) then exit;
  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top);
  TempBmp.Clear(color32(0,0,0,0));
  xn := Src.Width;
  yn := Src.Height;
  if xn=0 then xn:=1;
  if yn=0 then yn:=1;
  x := Trunc(TempBmp.Width / xn) + 1;
  y := Trunc(TempBmp.Height / yn) + 1;
  for yn := 0 to y do
      for xn := 0 to x do
          TempBmp.Draw(xn*Src.Width,yn*Src.Height,Src);
  Dst.Draw(DstRect.Left,DstRect.Top,TempBmp);
  TempBmp.Free;
end;

procedure TDesktopPanel.Paint;
begin
  FBitmap.Clear(color32(0,0,0,0));
  FBitmap.Draw(0,0,FUL);
  FBitmap.Draw(0,FBitmap.Height-FBL.Height,FBL);
  FBitmap.Draw(FBitmap.Width-FUR.Width,0,FUR);
  FBitmap.Draw(FBitmap.Width-FBR.Width,FBitmap.Height-FBR.Height,FBR);
  TileDraw(FML,FBitmap,Rect(0,FUL.Height,FUL.Width,FBitmap.Height - FBL.Height));
  TileDraw(FMR,FBitmap,Rect(FBitmap.Width-FUR.Width,FUR.Height,FBitmap.Width,FBitmap.Height - FBR.Height));
  TileDraw(FUM,FBitmap,Rect(FUL.Width,0,FBitmap.Width - FUR.Width,FUL.Height));
  TileDraw(FBM,FBitmap,Rect(FBL.Width,FBitmap.Height - FBL.Height,FBitmap.Width - FBR.Width,FBitmap.Height));
  TileDraw(FMM,FBitmap,Rect(FUL.Width,FUL.Height,FBitmap.Width - FBR.Width,FBitmap.Height-FBR.Height));
end;

end.
