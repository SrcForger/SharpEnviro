{
Source Name: TextLayer
Description: Text desktop object layer class
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

unit uTextObjectLayer;

interface
uses
  Windows, StdCtrls, Forms,Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, SharpDeskApi, JclFileUtils, JclShell,
  TextObjectSettingsWnd,
  TextObjectXMLSettings,
  uSharpDeskDebugging,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskTDeskSettings,
  uSharpDeskFunctions,
  uSharpDeskDesktopPanel,
  BasicHTMLRenderer;
type
   TColorRec = packed record
                 b,g,r,a: Byte;
               end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

  TTextLayer = class(TBitmapLayer)
  private
    FSettings        : TXMLSettings;
    FHLTimer         : TTimer;
    FHLTimerI        : integer;
    FObjectID        : integer;
    FShadowAlpha     : integer;
    FShadowColor     : integer;
    FHighlight       : boolean;
    FFontBitmap      : TBitmap32;
    FSHTMLRenderer   : TBasicHTMLRenderer;
    FDeskPanel       : TDesktopPanel;
    Fcs              : TColorScheme;
    FDeskSettings    : TDeskSettings;
    FThemeSettings   : TThemeSettings;
    FObjectSettings  : TObjectSettings;
  protected
     procedure OnTimer(Sender: TObject);
  public
     FParentImage : Timage32;
     procedure DrawBitmap;
     procedure LoadSettings;
     procedure DoubleClick;
     procedure OnOpenClick(Sender : TObject);
     procedure OnSearchClick(Sender : TObject);
     procedure OnPropertiesClick(Sender : TObject);
     procedure OnOpenWith(Sender : TObject);
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
  private
  end;


const
     DESK_SETTINGS = 'Settings\SharpDesk\SharpDesk.xml';
     THEME_SETTINGS = 'Settings\SharpDesk\Themes.xml';
     OBJECT_SETTINGS = 'Settings\SharpDesk\Objects.xml';

var
  SettingsWnd : TSettingsWnd;

implementation


procedure TTextLayer.OnOpenClick(Sender : TObject);
begin
  DoubleClick;
end;

procedure TTextLayer.OnSearchClick(Sender : TObject);
//var
//   Shell: Variant;
begin
  //   Shell := CreateOLEObject('Shell.Application');
  //   Shell.FindFiles;
end;

procedure TTextLayer.OnPropertiesClick(Sender : TObject);
begin
end;

procedure TTextLayer.OnOpenWith(Sender : TObject);
begin
end;



procedure TTextLayer.StartHL;
begin
  FHLTimerI := 1;
  FHLTimer.Enabled := True;
end;

procedure TTextLayer.EndHL;
begin
  FHLTimerI := -1;
  FHLTimer.Enabled := True;
end;

procedure TTextLayer.OnTimer(Sender: TObject);
begin
  FParentImage.BeginUpdate;
  BeginUpdate;
  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
//  SharpApi.SendDebugMessage('Link.object',inttostr(FHLTimer.Tag),clred);
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    DrawBitmap;
    FHLTimer.Tag := 0;
    EndUpdate;
    FParentImage.EndUpdate;
    Changed;
    exit;
  end;
  if FHLTimer.Tag >= 5 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 5;
    //DrawBitmap;
    EndUpdate;
    FParentImage.EndUpdate;
    Changed;
    exit;
  end;
  DrawBitmap;
  case FHLTimerI of
   1 : begin
         SharpDeskApi.LightenBitmap(Bitmap,FHLTimer.Tag*15);
       end;
   -1  : begin
           SharpDeskApi.LightenBitmap(Bitmap,FHLTimer.Tag*15);
         end;
  end;
  EndUpdate;
  FParentImage.EndUpdate;
  Changed;
end;


procedure TTextLayer.DoubleClick;
begin
end;

procedure TTextLayer.DrawBitmap;
var
   R : TFloatrect;
   w,h : integer;
   cm : integer;
   PM : TPoint;
   TopHeight    : integer;
   BottomHeight : integer;
   LeftWidth    : integer;
   RightWidth   : integer;
begin
  BeginUpdate;
  FParentImage.BeginUpdate;
  
  PM.X := 0;
  PM.Y := 0;
  case FSettings.BGType of
   1: begin
        w := FFontBitmap.Width;
        h := FFontBitmap.Height;
        TopHeight    := FSettings.BGThicknessValue+4;
        BottomHeight := FSettings.BGThicknessValue+4;
        LeftWidth    := FSettings.BGThicknessValue+4;
        RightWidth   := FSettings.BGThicknessValue+4;
        PM.X := 2;
        PM.Y := 2;
      end;
   2: begin
        w := FFontBitmap.Width+8;
        h := FFontBitmap.Height+8;
        FDeskPanel.SetCenterSize(w,h);
        FDeskPanel.Paint;
        if FSettings.BGTHBlend then
           SharpDeskApi.BlendImage(FDeskPanel.Bitmap,FSettings.BGTHBlendColor);
        if FSettings.BGTrans then
           FDeskPanel.Bitmap.MasterAlpha := FSettings.BGTransValue
           else FDeskPanel.Bitmap.MasterAlpha := 255;
        FDeskPanel.Bitmap.DrawMode := dmBlend;
        TopHeight    := FDeskPanel.TopHeight;
        BottomHeight := FDeskPanel.BottomHeight;
        LeftWidth    := FDeskPanel.LeftWidth;
        RightWidth   := FDeskPanel.RightWidth;
        PM.X := 2;
        PM.Y := 6; 
      end;
   else begin
          w := FFontBitmap.Width;
          h := FFontBitmap.Height;
          TopHeight    := 4;
          BottomHeight := 4;
          LeftWidth    := 4;
          RightWidth   := 4;
        end;
  end;
  w := w + LeftWidth + RightWidth;
  h := h + TopHeight + BottomHeight;

  //Decide size

  Bitmap.SetSize(w,h);
  Bitmap.Clear(color32(0,0,0,0));

  //Draw image centered
  case FSettings.BGType of
   1 : begin
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
       end;
   2 : begin
         Bitmap.Draw(0,0,FDeskPanel.Bitmap);
       end;
   else Bitmap.Clear(color32(0,0,0,0));
  end;
  
  FFontBitmap.DrawMode := dmBlend;
  FFontBitmap.CombineMode := cmMerge;
  Bitmap.Draw(Bitmap.Width div 2 - FFontBitmap.Width div 2,
              Bitmap.Height div 2 - FFontBitmap.Height div 2,
              FFontBitmap);

  //Set the right size of the layer
  R := getadjustedlocation;
  if (w <> (R.Right-R.left)) then   //dont move image if resize
    R.Left := R.left + round(((R.Right-R.left)- w)/2);
  if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
    R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
  R.Right := r.Left + w;
  R.Bottom := r.Top + h;
  location := R;

  //Seems like it must be said sometimes
  Bitmap.DrawMode := dmBlend;

  if not HasVisiblePixel(Bitmap) then
  begin
    Bitmap.SetSize(32,32);
    Bitmap.Clear(color32(128,128,128,128));
  end;  

  EndUpdate;
  FParentImage.EndUpdate;
  changed;
end;




procedure TTextLayer.LoadSettings;
var
   i : integer;
   alphablend : integer;
   IconList : TStringList;
   p : PChar;
   Bmp : TBitmap32;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;

  FShadowAlpha   := FDeskSettings.Theme.ShadowAlpha;
  FShadowColor   := FDeskSettings.Theme.ShadowColor;
  CodeToColorEx(FShadowColor,FDeskSettings.Theme.Scheme);

  if not FSettings.BGThickness then
     FSettings.BGThicknessValue := 0;

  if not FSettings.BGTrans then
     FSettings.BGTransValue := 255;


  if FSettings.UseThemeSettings then
  begin
    FSettings.AlphaValue    := FDeskSettings.Theme.DeskAlphaBlend;
    FSettings.AlphaBlend    := FDeskSettings.Theme.DeskUseAlphaBlend;      
    FSettings.ColorBlend    := FDeskSettings.Theme.DeskUseColorBlend;
    FSettings.BlendColor    := FDeskSettings.Theme.DeskColorBlendColor;
    FSettings.BlendValue    := FDeskSettings.Theme.DeskColorBlend;
    FSettings.Shadow        := FDeskSettings.Theme.DeskTextShadow;
    FSettings.ShowCaption   := FDeskSettings.Theme.DeskDisplayCaption;
  end;

  if length(FSettings.Text)=0 then FSettings.Text:='Text.object';

  if FSettings.AlphaBlend then
  begin
    Bitmap.MasterAlpha := FSettings.AlphaValue;
    if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
  end else Bitmap.MasterAlpha := 255;

  Bitmap.Font := FDeskSettings.Theme.TextFont;
  FShadowColor := FDeskSettings.Theme.ShadowColor;
  FShadowAlpha := FDeskSettings.Theme.ShadowAlpha;

  if FSettings.BGType = 2 then
     FDeskPanel.LoadPanel(FSettings.BGSkin);
     
  FSHTMLRenderer.LoadFromCommaText(FSettings.Text);
  FSHTMLRenderer.DrawPos := Point(2,2);
  FSHTMLRenderer.ParseText;
  FFontBitmap.SetSize(FSHTMLRenderer.DrawWidth+12,FSHTMLRenderer.DrawHeight+12);
  FFontBitmap.Clear(color32(0,0,0,0));
  FSHTMLRenderer.RenderText;


//  showmessage(inttostr(FSHTMLRenderer.DrawPos));

  if FSettings.Shadow then createdropshadow(FFontBitmap,0,1,FShadowAlpha,FShadowColor);
  if FSettings.ColorBlend then BlendImage(FFontBitmap,FSettings.BlendColor,FSettings.BlendValue);  

  FCs := LoadColorScheme;
  DrawBitmap;
end;


constructor TTextLayer.Create( ParentImage:Timage32; Id : integer;
                                 DeskSettings : TDeskSettings;
                                 ThemeSettings : TThemeSettings;
                                 ObjectSettings : TObjectSettings);
begin
  Inherited Create(ParentImage.Layers);
  FDeskSettings   := DeskSettings;
  FThemeSettings  := ThemeSettings;
  FObjectSettings := ObjectSettings;
  FParentImage := ParentImage;
  FDeskPanel := TDesktopPanel.Create;
  Alphahit := False;
  FObjectId := id;
  FHighlight := False;
  scaled := false;
  FSettings := TXMLSettings.Create(FObjectID,nil);
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled := False;  
  FHLTimer.OnTimer := OnTimer;
  FFontBitmap := TBitmap32.Create;
  FSHTMLRenderer := TBasicHTMLRenderer.Create(FFontBitmap);
  FSHTMLRenderer.MaxWidth := Screen.Width;
  fSHTMLRenderer.WordWrap := False;
  LoadSettings;
end;

destructor TTextLayer.Destroy;
begin
  DebugFree(FSettings);
  DebugFree(FDeskPanel);
  FHLTimer.Enabled := False;
  DebugFree(FHLTimer);
  DebugFree(FSHTMLRenderer);
  DebugFree(FFontBitmap);
  inherited Destroy;
end;

end.
