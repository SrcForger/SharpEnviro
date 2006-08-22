{
Source Name: RecycleBinLayer
Description: RecycleBin desktop object layer class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uRecycleBinObjectLayer;

interface
uses
  Windows, StdCtrls, Forms,Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,pngimage,
  GR32_Image,
  GR32_Layers,
  GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, SharpDeskApi, JclFileUtils, JclShell,
  RecycleBinObjectSettingsWnd,
  RecycleBinObjectXMLSettings,
  uSharpDeskDebugging,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskTDeskSettings,
  uSharpDeskFunctions,
  uSharpDeskDesktopPanel,
  GR32_Resamplers;
type
   TColorRec = packed record
                 b,g,r,a: Byte;
               end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

  PSHQueryRBInfo = ^TSHQueryRBInfo;
  TSHQueryRBInfo = packed record
                     cbSize: DWORD;
                     i64Size: Int64;
                     i64NumItems: Int64;
                   end;  

  TRecycleBinLayer = class(TBitmapLayer)
  private
    FFontSettings    : TDeskFont;
    FIconSettings    : TDeskIcon;
    FCaptionSettings : TDeskCaption;
    FSettings        : TXMLSettings;
    FUpdateTimer     : TTimer;
    FHLTimer         : TTimer;
    FHLTimerI        : integer;
    FAnimSteps       : integer;
    FObjectID        : integer;
     FScale           : integer;    
    FHighlight       : boolean;
    FLocked          : boolean;
    FDeskPanel       : TDesktopPanel;
    FPicture         : TBitmap32;
    FIconEmpty       : TBitmap32;
    FIconFull        : TBitmap32;
    Fcs              : TColorScheme;
    FDeskSettings    : TDeskSettings;
    FThemeSettings   : TThemeSettings;
    FObjectSettings  : TObjectSettings;
    FBinSize         : extended;
    FBinItems        : integer;
  protected
     procedure OnTimer(Sender: TObject);
     procedure OnUpdateTimer(Sender: TObject);
  public
     FParentImage : Timage32;
     SHEmptyRecycleBin : function (hwnd: HWND; pszRootPath: PChar; dwFlags: DWord): HResult; stdcall;
     SHQueryRecycleBin : function (pszrtootpath:pchar;QUERYRBINFO:pshqueryrbinfo):integer; stdcall;     
     procedure GetRecycleBinStatus;
     procedure DrawBitmap;
     procedure LoadSettings;
     procedure DoubleClick;
     procedure OnOpenClick(Sender : TObject);
     procedure OnPropertiesClick(Sender : TObject);
     procedure OnEmptyBinClick(Sender : TObject);
     procedure StartHL;
     procedure EndHL;
     constructor Create( ParentImage:Timage32; Id : integer;
                         DeskSettings : TDeskSettings;
                         ThemeSettings : TThemeSettings;
                         ObjectSettings : TObjectSettings); reintroduce;
     destructor Destroy; override;
     property ObjectId: Integer read FObjectId write FObjectId;
     property Highlight : boolean read FHighlight write FHighlight;
     property Settings  : TXMLSettings read FSettings;
     property BinSize   : extended read FBinSize;
     property BinItems  : integer read FBinItems;
     property Locked    : boolean read FLocked write FLocked;
  private
  end;




//  function SHEmptyRecycleBin(hwnd: HWND; pszRootPath: PChar; dwFlags: DWord): HResult; stdcall;
//         external 'shell32' name 'SHEmptyRecycleBinA';

//  function SHQueryRecycleBin(pszrtootpath:pchar;QUERYRBINFO:pshqueryrbinfo):integer;stdcall;
//           external 'shell32' name 'SHQueryRecycleBinA';



var
  SettingsWnd : TSettingsWnd;

implementation


procedure TRecycleBinLayer.OnEmptyBinClick(Sender : TObject);
begin
  try
    if @SHEmptyRecycleBin = nil then exit;
    SHEmptyRecycleBin(Application.Handle, '', 0);
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

procedure TRecycleBinLayer.GetRecycleBinStatus;
var
  rbinfo:TSHQUERYRBINFO;
begin
  try
    if @SHQueryRecycleBin = nil then exit;
    try
      rbinfo.cbSize:=sizeof(rbinfo);
      rbinfo.i64Size:=0;
      rbinfo.i64NumItems:=0;
      SHQueryRecycleBin('',@rbinfo);
      FBinSize:=rbinfo.i64Size / 1024 / 1024;
      FBinItems:=Rbinfo.i64NumItems;
      if FBinItems = 0 then
      begin
        FPicture := FIconEmpty;
      end else
      begin
        FPicture := FIconFull;
      end;
    except
      on E: Exception do
      begin
        SharpApi.SendDebugMessageEx('RecycleBin.Object',PChar('Error in GetRecycleBinStatus'),0,DMT_Error);
        SharpApi.SendDebugMessageEx('RecycleBin.Object',PChar(E.Message),clblue, DMT_TRACE);
      end;
    end;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('RecycleBin.Object',PChar('Error in GetRecycleBinStatus'),0,DMT_Error);
      SharpApi.SendDebugMessageEx('RecycleBin.Object',PChar(E.Message),clblue, DMT_TRACE);
    end;
  end;
end;

procedure TRecycleBinLayer.OnOpenClick(Sender : TObject);
begin
  DoubleClick;
end;

procedure TRecycleBinLayer.OnPropertiesClick(Sender : TObject);
begin
  DisplayPropDialog(Application.Handle,FSettings.Target);
end;


procedure TRecycleBinLayer.OnUpdateTimer(Sender: TObject);
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

procedure TRecycleBinLayer.StartHL;
begin
  if FDeskSettings.Theme.DeskHoverAnimation then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    SharpDeskApi.LightenBitmap(Bitmap,50);
  end;
end;

procedure TRecycleBinLayer.EndHL;
begin
  if FDeskSettings.Theme.DeskHoverAnimation then
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
  BeginUpdate;
  FParentImage.BeginUpdate;
  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 0;
    FScale := 100;
    if (FSettings.UseThemeSettings) and (FDeskSettings.Theme.DeskUseAlphaBlend) then
       i := FDeskSettings.Theme.DeskAlphaBlend
        else if FSettings.AlphaBlend then i := FSettings.AlphaValue
             else i := 255;
    if i > 255 then i := 255
       else if i<32 then i := 32;
    Bitmap.MasterAlpha := i;
    DrawBitmap;
    EndUpdate;
    FParentImage.EndUpdate;
    Changed;
    exit;
  end;

  if FDeskSettings.Theme.AnimScale then
     FScale := round(100 + ((FDeskSettings.Theme.AnimScaleValue)/FAnimSteps)*FHLTimer.Tag);
  if FDeskSettings.Theme.AnimAlpha then
  begin
    if (FSettings.UseThemeSettings) and (FDeskSettings.Theme.DeskUseAlphaBlend) then
       i := FDeskSettings.Theme.DeskAlphaBlend
        else if FSettings.AlphaBlend then i := FSettings.AlphaValue
             else i := 255;
    i := i + round(((FDeskSettings.Theme.AnimAlphaValue/FAnimSteps)*FHLTimer.Tag));
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
  if FDeskSettings.Theme.AnimBB then
     SharpDeskApi.LightenBitmap(Bitmap,round(FHLTimer.Tag*(FDeskSettings.Theme.AnimBBValue/FAnimSteps)));
  if FDeskSettings.Theme.AnimBlend then
     SharpDeskApi.BlendImage(Bitmap,FDeskSettings.Theme.AnimBlendColor,round(FHLTimer.Tag*(FDeskSettings.Theme.AnimBlendValue/FAnimSteps)));
  EndUpdate;
  FParentImage.EndUpdate;
  Changed;
end;


procedure TRecycleBinLayer.DoubleClick;
begin
  SharpExecute(FSettings.Target);
end;

procedure TRecycleBinLayer.DrawBitmap;
var
   R            : TFloatrect;
   w,h          : integer;
   cm           : integer;
   PM           : TPoint;
   FontBitmap  : TBitmap32;
   TempBitmap    : TBitmap32;
   TopHeight    : integer;
   BottomHeight : integer;
   LeftWidth    : integer;
   RightWidth   : integer;
   SList        : TStringList;
   p            : TPoint;
   eh,n         : integer;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

  TempBitmap := TBitmap32.Create;
  TempBitmap.DrawMode := dmBlend;
  TempBitmap.CombineMode := cmMerge;

  if FSettings.ShowData then
  begin
    FCaptionSettings.Caption.Delete(FCaptionSettings.Caption.Count-1);
    FCaptionSettings.Caption.Delete(FCaptionSettings.Caption.Count-1);
    FCaptionSettings.Caption.Add('Size : '+FloatToStrF(FBinSize,ffFixed,6,2)+' MB');
    FCaptionSettings.Caption.Add('Items : '+inttostr(FBinItems));
  end;

  FIconSettings.Icon := FPicture;
  SharpDeskApi.RenderObject(TempBitmap,
                            FIconSettings,
                            FFontSettings,
                            FCaptionSettings,
                            Point(0,0),
                            Point(0,0));
  case FSettings.BGType of
   1: begin
        w := TempBitmap.Width + FSettings.BGThicknessValue + 2;
        h := TempBitmap.Height + FSettings.BGThicknessValue + 2;
        Bitmap.SetSize(w,h);
        Bitmap.Clear(color32(0,0,0,0));
        Bitmap.FillRectS(Bitmap.Canvas.ClipRect,color32(GetRValue(FSettings.BGBorderColor),
                                                        GetGValue(FSettings.BGBorderColor),
                                                        GetBValue(FSettings.BGBorderColor),
                                                        FSettings.BGTransValue));
        Bitmap.FillRectS(Rect(FSettings.BGThicknessValue,
                              FSettings.BGThicknessValue,
                              Bitmap.Width-FSettings.BGThicknessValue,
                              Bitmap.Height-FSettings.BGThicknessValue),
                              color32(GetRValue(FSettings.BGColor),
                                      GetGValue(FSettings.BGColor),
                                      GetBValue(FSettings.BGColor),
                                      FSettings.BGTransValue));
        Bitmap.Draw(FSettings.BGThicknessValue + 1,FSettings.BGThicknessValue + 1,TempBitmap);
      end;
   2: begin
        FDeskPanel.SetCenterSize(TempBitmap.Width,TempBitmap.Height);
        FDeskPanel.Paint;
        if FSettings.BGTHBlend then
           SharpDeskApi.BlendImage(FDeskPanel.Bitmap,FSettings.BGTHBlendColor);
        if FSettings.BGTrans then
           FDeskPanel.Bitmap.MasterAlpha := FSettings.BGTransValue
           else FDeskPanel.Bitmap.MasterAlpha := 255;
        FDeskPanel.Bitmap.DrawMode := dmBlend;
        Bitmap.SetSize(FDeskPanel.Width,FDeskPanel.Height);
        Bitmap.Clear(color32(0,0,0,0));        
        Bitmap.Draw(0,0,FDeskPanel.Bitmap);
        Bitmap.Draw(FDeskPanel.TopHeight,FDeskPanel.LeftWidth,TempBitmap);
      end;
   else
   begin
     Bitmap.SetSize(TempBitmap.Width,TempBitmap.Height);
     Bitmap.Clear(color32(0,0,0,0));
     Bitmap.Draw(0,0,TempBitmap);
   end;
  end;

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

  //FontBitmap.Free;
  //Seems like it must be said sometimes
  Bitmap.DrawMode := dmBlend;

  EndUpdate;
  FParentImage.EndUpdate;
  changed;
end;



procedure TRecycleBinLayer.LoadSettings;
var
   i : integer;
   alphablend : integer;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;

  if (FSettings.CustomFont) and not(Fsettings.UseThemeSettings) then
  begin
    FFontSettings.Name      := FSettings.FontName;
    FFontSettings.Size      := FSettings.FontSize;
    FFontSettings.Color     := CodeToColorEx(FSettings.FontColor,FDeskSettings.Theme.Scheme);
    FFontSettings.Bold      := FSettings.FontBold;
    FFontSettings.Italic    := FSettings.FontItalic;
    FFontSettings.Underline := FSettings.FontUnderline;
    FFontSettings.AALevel   := 0;
    if FSettings.FontAlpha then FFontSettings.Alpha := FSettings.FontAlphaValue
       else FFontSettings.Alpha := 255;
    FFontSettings.ShadowColor := CodeToColorEx(FSettings.FontShadowColor,FDeskSettings.Theme.Scheme);
    FFontSettings.ShadowAlphaValue := FSettings.FontShadowValue;
    FFontSettings.Shadow    := FSettings.FontShadow;
    FFontSettings.ShadowAlpha := True;
  end else
  begin
    FFontSettings.Name      := FDeskSettings.Theme.TextFont.Name;
    FFontSettings.Color     := CodeToColorEx(FDeskSettings.Theme.TextFont.Color,FDeskSettings.Theme.Scheme);
    FFontSettings.Bold      := fsBold in FDeskSettings.Theme.TextFont.Style;
    FFontSettings.Italic    := fsItalic in FDeskSettings.Theme.TextFont.Style;
    FFontSettings.Underline := fsUnderline in FDeskSettings.Theme.TextFont.Style;
    FFontSettings.AALevel   := 0;
    if FDeskSettings.Theme.DeskFontAlpha then FFontSettings.Alpha := FDeskSettings.Theme.DeskFontAlphaValue
       else FFontSettings.Alpha := 255;
    FFontSettings.Size      := FDeskSettings.Theme.TextFont.Size;
    FFontSettings.ShadowColor := CodeToColorEx(FDeskSettings.Theme.ShadowColor,FDeskSettings.Theme.Scheme);
    FFontSettings.ShadowAlphaValue := FDeskSettings.Theme.ShadowAlpha;
    FFontSettings.ShadowAlpha := True;
    if FSettings.UseThemeSettings then FFontSettings.Shadow := FDeskSettings.Theme.DeskTextShadow
       else FFontSettings.Shadow := FSettings.Shadow;
  end;


  FCaptionSettings.Caption.Clear;
  if FSettings.UseThemeSettings then FCaptionSettings.Draw := FDeskSettings.Theme.DeskDisplayCaption
     else FCaptionSettings.Draw := FSettings.ShowCaption;
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
  if FSettings.IconSpacing then
     if (FCaptionSettings.Align = taLeft) or (FCaptionSettings.Align = taRight) then
         FCaptionSettings.Xoffset := FSettings.IconSpacingValue
     else FCaptionSettings.Yoffset := FSettings.IconSpacingValue;

  if FSettings.ShowData then FCaptionSettings.Draw := True;
  FCaptionSettings.LineSpace := 0;

  FIconSettings.Size  := 100;
  FIconSettings.Alpha := 255;
  FIconSettings.ShadowColor := CodeToColorEx(FDeskSettings.Theme.DeskIconShadowColor,FDeskSettings.Theme.Scheme);
  FIconSettings.ShadowAlpha := FDeskSettings.Theme.DeskIconShadow;
  FIconSettings.XOffset     := 0;
  FIconSettings.YOffset     := 0;
  if FSettings.IconOffset then FIconSettings.XOffset := FSettings.IconOffsetValue;;
  if FSettings.UseThemeSettings then
  begin
    FSettings.AlphaBlend      := FDeskSettings.Theme.DeskUseAlphaBlend;
    FSettings.AlphaValue      := FDeskSettings.Theme.DeskAlphaBlend;  
    FIconSettings.Blend       := FDeskSettings.Theme.DeskUseColorBlend;
    FIconSettings.BlendColor  := CodeToColorEx(FDeskSettings.Theme.DeskColorBlendColor,FDeskSettings.Theme.Scheme);
    FIconSettings.BlendValue  := FDeskSettings.Theme.DeskColorBlend;
    FIconSettings.Shadow      := FDeskSettings.Theme.DeskUseIconShadow;
  end else
  begin
    FIconSettings.Blend       := FSettings.ColorBlend; 
    FIconSettings.BlendColor  := CodeToColorEx(FSettings.BlendColor,FDeskSettings.Theme.Scheme);
    FIconSettings.BlendValue  := FSettings.BlendValue;
    FIconSettings.Shadow      := FSettings.UseIconShadow;
  end;

  if FSettings.AlphaBlend then
  begin
    Bitmap.MasterAlpha := FSettings.AlphaValue;
    if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
  end else Bitmap.MasterAlpha := 255;  

  if FSettings.BGType = 2 then
     FDeskPanel.LoadPanel(FSettings.BGSkin);


  SharpDeskApi.LoadIcon(FIconEmpty,FSettings.IconFileE,FSettings.IconFileE,FDeskSettings.Theme.IconSet,strtoint(FSettings.size));
  SharpDeskApi.LoadIcon(FIconFull,FSettings.IconFileF,FSettings.IconFileF,FDeskSettings.Theme.IconSet,strtoint(FSettings.size));

  FCs := LoadColorScheme;

  GetRecycleBinStatus;
  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);   
end;


constructor TRecycleBinLayer.Create( ParentImage:Timage32; Id : integer;
                                 DeskSettings : TDeskSettings;
                                 ThemeSettings : TThemeSettings;
                                 ObjectSettings : TObjectSettings);
begin
  Inherited Create(ParentImage.Layers);
  FDeskSettings   := DeskSettings;
  FThemeSettings  := ThemeSettings;
  FObjectSettings := ObjectSettings;
  FParentImage := ParentImage;
  FIconFull := Tbitmap32.Create;
  FIconEmpty := Tbitmap32.Create;
  FPicture := FIconEmpty;
  FDeskPanel := TDesktopPanel.Create;
  Alphahit := False;
  FObjectId := id;
  FHighlight := False;
  scaled := false;
  FSettings := TXMLSettings.Create(FObjectId,nil);
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled  := False;
  FHLTimer.OnTimer  := OnTimer;
  FAnimSteps        := 5;
  FScale            := 100;
  FUpdateTimer := TTimer.Create(nil);
  FUpdateTimer.Interval := 5000;
  FUpdateTimer.Enabled := True;
  FUpdateTimer.OnTimer := OnUpdateTimer;
  FCaptionSettings.Caption := TStringList.Create;
  FCaptionSettings.Caption.Clear;
  LoadSettings;
end;

destructor TRecycleBinLayer.Destroy;
begin
  FUpdateTimer.Enabled := False;
  FHLTimer.Enabled := False;
  DebugFree(FCaptionSettings.Caption);
  DebugFree(FSettings);
  DebugFree(FIconFull);
  DebugFree(FIconEmpty);
  DebugFree(FDeskPanel);
  DebugFree(FUpdateTimer);
  DebugFree(FHLTimer);
  inherited Destroy;
end;

end.
