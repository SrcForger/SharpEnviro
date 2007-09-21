{
Source Name: uLinkObjectLayer.pas
Description: Link object layer class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit uRecycleBinObjectLayer;

interface
uses
  Windows, StdCtrls, Forms,Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, SharpDeskApi, JclShell, Types,
  RecycleBinObjectXMLSettings,
  RecylceBinObjectSettingsWnd,
  uSharpDeskDebugging,
  uSharpDeskFunctions,
  uSharpDeskObjectSettings,
  SharpGraphicsUtils,
  SharpThemeApi,
  SharpIconUtils,
  GR32_Resamplers;
type
   TColorRec = packed record
                 b,g,r,a: Byte;
               end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

  PSHQueryRBInfo = ^TSHQueryRBInfo;
  TSHQUERYRBINFO = packed record
     cbSize : DWord;
     i64Size : Int64;
     i64NumItems : Int64;
  end;

  TRecycleBinLayer = class(TBitmapLayer)
  private
    FIconEmpty       : TBitmap32;
    FIconFull        : TBitmap32;
    FPicture         : TBitmap32;
    FBinSize         : extended;
    FBinItems        : integer;
    FBinTimer        : TTimer;
    FFontSettings    : TDeskFont;
    FIconSettings    : TDeskIcon;
    FCaptionSettings : TDeskCaption;
    FSettings        : TRecycleXMLSettings;
    FHLTimer         : TTimer;
    FHLTimerI        : integer;
    FAnimSteps       : integer;
    FObjectID        : integer;
    FScale           : integer;
    FLocked          : Boolean;
  protected
  public
     FParentImage : Timage32;
     SHEmptyRecycleBin : function (hWnd: HWND; pszRootPath: PChar; dwFlags: DWORD): HResult; stdcall;
     SHQueryRecycleBin : function (pszRootPath: PChar; var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;
     procedure DoubleClick;
     procedure StartHL;
     procedure EndHL;
     procedure DrawBitmap;
     procedure LoadSettings;
     procedure GetRecycleBinStatus;
     procedure OnTimer(Sender: TObject);
     procedure OnBinTimer(Sender: TObject);
     procedure OnPropertiesClick(Sender : TObject);
     procedure OnOpenClick(Sender : TObject);
     procedure OnEmptyBinClick(Sender : TObject);
     constructor Create( ParentImage:Timage32; Id : integer); reintroduce;
     destructor Destroy; override;
     property ObjectId  : Integer read FObjectId  write FObjectId;
     property Locked    : boolean read FLocked    write FLocked;
     property Settings  : TRecycleXMLSettings read FSettings;
     property BinItems  : integer read FBinItems;
  private
  end;


var
  SettingsWnd : TSettingsWnd;

implementation

procedure TRecycleBinLayer.OnEmptyBinClick(Sender : TObject);
begin
  try
    if @SHEmptyRecycleBin = nil then exit;
    SHEmptyRecycleBin(Application.Handle, nil, 0);
    GetRecycleBinStatus;
    DrawBitmap;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('RecycleBin.Object',PChar('Error in OnEmptyBinClick'),0,DMT_Error);
      SharpApi.SendDebugMessageEx('RecycleBin.Object',PChar(E.Message),clblue, DMT_TRACE);
    end;
  end;
end;

procedure TRecycleBinLayer.OnOpenClick(Sender : TObject);
begin
  DoubleClick;
end;

procedure TRecycleBinLayer.DoubleClick;
begin
  SharpExecute(FSettings.Target);
end;

procedure TRecycleBinLayer.OnPropertiesClick(Sender : TObject);
begin
  DisplayPropDialog(Application.Handle,FSettings.Target);
end;

procedure TRecycleBinLayer.OnBinTimer(Sender: TObject);
var
 oldSize  : extended;
 oldItems : integer;
begin
  oldSize := FBinSize;
  oldItems := FBinItems;
  GetRecycleBinStatus;
  if (oldSize<>FBinSize) or ( oldItems<>FBinItems) then
     DrawBitmap;
end;

procedure TRecycleBinLayer.GetRecycleBinStatus;
var
  rbinfo : TSHQUERYRBINFO;
begin
  if @SHQueryRecycleBin = nil then exit;
  rbinfo.cbSize := sizeof(TSHQUERYRBINFO);
  rbinfo.i64Size := 0;
  rbinfo.i64NumItems := 0;
  if SHQueryRecycleBin(nil,rbinfo) = s_OK then
  begin
    FBinSize:=rbinfo.i64Size / 1024 / 1024;
    FBinItems:=Rbinfo.i64NumItems;
    if FBinItems = 0 then
    begin
      FPicture := FIconEmpty;
    end else
    begin
      FPicture := FIconFull;
    end;
  end;
end;

procedure TRecycleBinLayer.StartHL;
begin
  if SharpThemeApi.GetDesktopAnimUseAnimations then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    LightenBitmap(Bitmap,50);
  end;
end;

procedure TRecycleBinLayer.EndHL;
begin
  if SharpThemeApi.GetDesktopAnimUseAnimations then
  begin
    FHLTimerI := -1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
  end;
end;

procedure TRecycleBinLayer.OnTimer(Sender: TObject);
var
  i : integer;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;
  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 0;
    FScale := 100;
    if FSettings.Theme[DS_ICONALPHABLEND].BoolValue then
       i := FSettings.Theme[DS_ICONALPHA].IntValue
       else i := 255;
    if i > 255 then i := 255
       else if i<32 then i := 32;
    Bitmap.MasterAlpha := i;
    DrawBitmap;
    FParentImage.EndUpdate;
    EndUpdate;
    Changed;
    exit;
  end;

  if SharpThemeApi.GetDesktopAnimScale then
     FScale := round(100 + ((SharpThemeApi.GetDesktopAnimScaleValue)/FAnimSteps)*FHLTimer.Tag);
  if SharpThemeApi.GetDesktopAnimAlpha then
  begin
    FScale := 100;
    if FSettings.Theme[DS_ICONALPHABLEND].BoolValue then
       i := FSettings.Theme[DS_ICONALPHA].IntValue
       else i := 255;
    i := i + round(((SharpThemeApi.GetDesktopAnimAlphaValue/FAnimSteps)*FHLTimer.Tag));
    if i > 255 then i := 255
       else if i<32 then i := 32;
    Bitmap.MasterAlpha := i;
  end;
  if FHLTimer.Tag >= FAnimSteps then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := FAnimSteps;
  end;
  DrawBitmap;
  if SharpThemeApi.GetDesktopAnimBrightness then
     LightenBitmap(Bitmap,round(FHLTimer.Tag*(SharpThemeApi.GetDesktopAnimBrightnessValue/FAnimSteps)));
  if SharpThemeApi.GetDesktopAnimBlend then
     BlendImageA(Bitmap,
                 SharpThemeApi.GetDesktopAnimBlendColor,
                 round(FHLTimer.Tag*(SharpThemeApi.GetDesktopAnimBlendValue/FAnimSteps)));
  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;

procedure TRecycleBinLayer.DrawBitmap;
var
   R : TFloatrect;
   w,h : integer;
   TempBitmap : TBitmap32;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

  if FSettings.ShowData then
  begin
    FCaptionSettings.Caption.Delete(FCaptionSettings.Caption.Count-1);
    FCaptionSettings.Caption.Delete(FCaptionSettings.Caption.Count-1);
    FCaptionSettings.Caption.Add('Size : '+FloatToStrF(FBinSize,ffFixed,6,2)+' MB');
    FCaptionSettings.Caption.Add('Items : '+inttostr(FBinItems));
  end;

  FIconSettings.Icon := FPicture;

  TempBitmap := TBitmap32.Create;
  TempBitmap.DrawMode := dmBlend;
  TempBitmap.CombineMode := cmMerge;
  SharpDeskApi.RenderObject(TempBitmap,
                            FIconSettings,
                            FFontSettings,
                            FCaptionSettings,
                            Point(0,0),
                            Point(0,0));

  Bitmap.SetSize(TempBitmap.Width,TempBitmap.Height);
  Bitmap.Clear(color32(0,0,0,0));
  Bitmap.Draw(0,0,TempBitmap);

  TempBitmap.Free;

  if FLocked then
  begin
    w := (Bitmap.Width*FScale) div 100;
    h := (Bitmap.Height*FScale) div 100;
    TDraftResampler.Create(Bitmap);
  end else
  begin
    w := Bitmap.Width;
    h := Bitmap.Height;
  end;
  R := getadjustedlocation;
  if (w <> (R.Right-R.left)) then   //dont move image if resize
    R.Left := R.left + round(((R.Right-R.left)- w)/2);
  if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
    R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
  R.Right := r.Left + w;
  R.Bottom := r.Top + h;
  location := R;

  Bitmap.DrawMode := dmBlend;

  FParentImage.EndUpdate;
  EndUpdate;
  changed;
end;

procedure TRecycleBinLayer.LoadSettings;
var
  bmp : TBitmap32;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;

  with FSettings do
  begin
    FFontSettings.Name      := Theme[DS_FONTNAME].Value;
    FFontSettings.Size      := Theme[DS_TEXTSIZE].IntValue;
    FFontSettings.Color     := SharpThemeApi.SchemeCodeToColor(Theme[DS_TEXTCOLOR].IntValue);
    FFontSettings.Bold      := Theme[DS_TEXTBOLD].BoolValue;
    FFontSettings.Italic    := Theme[DS_TEXTITALIC].BoolValue;
    FFontSettings.Underline := Theme[DS_TEXTUNDERLINE].BoolValue;
    FFontSettings.AALevel   := 0;
    FFontSettings.ShadowColor      := SharpThemeApi.SchemeCodeToColor(Theme[DS_TEXTSHADOWCOLOR].IntValue);
    FFontSettings.ShadowAlphaValue := Theme[DS_TEXTSHADOWALPHA].IntValue;
    FFontSettings.Shadow           := Theme[DS_TEXTSHADOW].BoolValue;
    FFontSettings.TextAlpha        := Theme[DS_TEXTALPHA].BoolValue;
    FFontSettings.Alpha            := Theme[DS_TEXTALPHAVALUE].IntValue;
    FFontSettings.ShadowType       := Theme[DS_TEXTSHADOWTYPE].IntValue;
    FFontSettings.ShadowSize       := Theme[DS_TEXTSHADOWSIZE].IntValue;

    FCaptionSettings.Caption.Clear;
    if FCaptionSettings.Draw then
    begin
      if FSettings.MLineCaption then FCaptionSettings.Caption.CommaText := FSettings.Caption
         else if Length(Trim(FSettings.Caption)) >0 then FCaptionSettings.Caption.Add(FSettings.Caption);
    end;
    if FSettings.ShowData then
    begin
      FCaptionSettings.Caption.Add('-');
      FCaptionSettings.Caption.Add('-');
    end;
    FCaptionSettings.Align := IntToTextAlign(FSettings.CaptionAlign);
    FCaptionSettings.Xoffset := 0;
    FCaptionSettings.Yoffset := 0;
    FCaptionSettings.Draw := ShowCaption;
    FCaptionSettings.LineSpace := 0;

    FIconSettings.Size  := 100;
    FIconSettings.Alpha := 255;
    FIconSettings.XOffset     := 0;
    FIconSettings.YOffset     := 0;

    FIconSettings.Blend       := Theme[DS_ICONBLENDING].BoolValue;
    FIconSettings.BlendColor  := SharpThemeApi.SchemeCodeToColor(Theme[DS_ICONBLENDCOLOR].IntValue);
    FIconSettings.BlendValue  := Theme[DS_ICONBLENDALPHA].IntValue;
    FIconSettings.Shadow      := Theme[DS_ICONSHADOW].BoolValue;
    FIconSettings.ShadowColor := SharpThemeApi.SchemeCodeToColor(Theme[DS_ICONSHADOWCOLOR].IntValue);
    FIconSettings.ShadowAlpha := 255-Theme[DS_ICONSHADOWALPHA].IntValue;

    if Theme[DS_ICONSIZE].IntValue <= 8 then
       Theme[DS_ICONSIZE].IntValue:= 48;

    bmp := TBitmap32.Create;
    bmp.DrawMode := dmBlend;
    bmp.CombineMode := cmMerge;
    TLinearResampler.Create(bmp);

    IconStringToIcon(FSettings.Icon,FSettings.Target,Bmp,FSettings.Theme[DS_ICONSIZE].IntValue);
    FIconEmpty.SetSize(FSettings.Theme[DS_ICONSIZE].IntValue,FSettings.Theme[DS_ICONSIZE].IntValue);
    FIconEmpty.Clear(color32(0,0,0,0));
    bmp.DrawTo(FIconEmpty,Rect(0,0,FIconEmpty.Width,FIconEmpty.Height));

    IconStringToIcon(FSettings.Icon2,FSettings.Target,Bmp,FSettings.Theme[DS_ICONSIZE].IntValue);
    FIconFull.SetSize(FSettings.Theme[DS_ICONSIZE].IntValue,FSettings.Theme[DS_ICONSIZE].IntValue);
    FIconFull.Clear(color32(0,0,0,0));
    bmp.DrawTo(FIconFull,Rect(0,0,FIconFull.Width,FIconFull.Height));

    bmp.Free;

    if Theme[DS_ICONALPHABLEND].BoolValue then
    begin
      Bitmap.MasterAlpha := Theme[DS_ICONALPHA].IntValue;
      if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
    end else Bitmap.MasterAlpha := 255;
  end;

  GetRecycleBinStatus;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);
  DrawBitmap;
end;


constructor TRecycleBinLayer.Create( ParentImage:Timage32; Id : integer);

begin
  Inherited Create(ParentImage.Layers);
  FParentImage := ParentImage;
  Alphahit := False;
  FObjectId := id;
  scaled := false;
  FSettings := TRecycleXMLSettings.Create(FObjectId,nil,'RecycleBin');
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled := False;
  FHLTimer.OnTimer := OnTimer;
  FAnimSteps       := 5;
  FScale           := 100;
  FCaptionSettings.Caption := TStringList.Create;
  FCaptionSettings.Caption.Clear;
  FIconEmpty := TBitmap32.Create;
  FIconFull := TBitmap32.Create;
  FBinTimer := TTimer.Create(nil);
  FBinTimer.Interval := 5000;
  FBinTimer.Enabled := True;
  FBinTimer.OnTimer := OnBinTimer;
  FPicture := FIconEmpty;
  LoadSettings;
end;

destructor TRecycleBinLayer.Destroy;
begin
  DebugFree(FIconEmpty);
  DebugFree(FIconFull);
  DebugFree(FBinTimer);
  DebugFree(FCaptionSettings.Caption);
  DebugFree(FSettings);
  FHLTimer.Enabled := False;
  DebugFree(FHLTimer);

  inherited Destroy;
end;

end.
