{
Source Name: uLinkObjectLayer.pas
Description: Link object layer class
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

unit uLinkObjectLayer;

interface
uses
  Windows, StdCtrls, Forms,Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, SharpDeskApi, JclFileUtils, JclShell,
  LinkObjectSettingsWnd,
  LinkObjectXMLSettings,
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

  TFolderLayer = class(TBitmapLayer)
  private
    FFontSettings    : TDeskFont;
    FIconSettings    : TDeskIcon;
    FCaptionSettings : TDeskCaption;
    FSettings        : TXMLSettings;
    FHLTimer         : TTimer;
    FHLTimerI        : integer;
    FAnimSteps       : integer;
    FObjectID        : integer;
    FScale           : integer;
    FLocked          : Boolean;
    FDeskPanel       : TDesktopPanel;
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
     property ObjectId  : Integer read FObjectId  write FObjectId;
     property Locked    : boolean read FLocked    write FLocked;
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


procedure TFolderLayer.OnOpenClick(Sender : TObject);
begin
  DoubleClick;
end;

procedure TFolderLayer.OnSearchClick(Sender : TObject);
//var
//   Shell: Variant;
begin
  //   Shell := CreateOLEObject('Shell.Application');
  //   Shell.FindFiles;
end;

procedure TFolderLayer.OnPropertiesClick(Sender : TObject);
begin
  DisplayPropDialog(Application.Handle,FSettings.Target);
end;

procedure TFolderLayer.OnOpenWith(Sender : TObject);
begin
  ShellOpenAs(FSettings.Target);
end;

procedure TFolderLayer.StartHL;
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

procedure TFolderLayer.EndHL;
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

procedure TFolderLayer.OnTimer(Sender: TObject);
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
    if (FSettings.UseThemeSettings) and (FDeskSettings.Theme.DeskUseAlphaBlend) then
       i := FDeskSettings.Theme.DeskAlphaBlend
        else if FSettings.AlphaBlend then i := FSettings.AlphaValue
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
  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;


procedure TFolderLayer.DoubleClick;
begin
  SharpExecute(FSettings.Target);
end;

procedure TFolderLayer.DrawBitmap;
var
   R : TFloatrect;
   w,h : integer;
   TempBitmap : TBitmap32;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

  TempBitmap := TBitmap32.Create;
  TempBitmap.DrawMode := dmBlend;
  TempBitmap.CombineMode := cmMerge;
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

  Bitmap.DrawMode := dmBlend;

  FParentImage.EndUpdate;
  EndUpdate;
  changed;
end;




procedure TFolderLayer.LoadSettings;
var
   i : integer;
   alphablend : integer;
   IconList : TStringList;
   p : PChar;
   Bmp : TBitmap32;
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
  if FSettings.MLineCaption then FCaptionSettings.Caption.CommaText := FSettings.Caption
     else FCaptionSettings.Caption.Add(FSettings.Caption);
  FCaptionSettings.Align := IntToTextAlign(FSettings.CaptionAlign);
  FCaptionSettings.Xoffset := 0;
  FCaptionSettings.Yoffset := 0;
  if FSettings.IconSpacing then
     if (FCaptionSettings.Align = taLeft) or (FCaptionSettings.Align = taRight) then
         FCaptionSettings.Xoffset := FSettings.IconSpacingValue
     else FCaptionSettings.Yoffset := FSettings.IconSpacingValue;

  if FSettings.UseThemeSettings then FCaptionSettings.Draw := FDeskSettings.Theme.DeskDisplayCaption
     else FCaptionSettings.Draw := FSettings.ShowCaption;
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

  if length(FSettings.Size)=0 then FSettings.Size:='48';

  SharpDeskApi.LoadIcon(FIconSettings.Icon,FSettings.IconFile,FSettings.Target,FDeskSettings.Theme.IconSet,strtoint(FSettings.size));

  if FSettings.AlphaBlend then
  begin
    Bitmap.MasterAlpha := FSettings.AlphaValue;
    if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
  end else Bitmap.MasterAlpha := 255;

  if FSettings.BGType = 2 then
     FDeskPanel.LoadPanel(FSettings.BGSkin);

  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);   
end;


constructor TFolderLayer.Create( ParentImage:Timage32; Id : integer;
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
  scaled := false;
  FSettings := TXMLSettings.Create(FObjectId,nil);
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled := False;
  FHLTimer.OnTimer := OnTimer;
  FAnimSteps       := 5;
  FScale           := 100;
  FCaptionSettings.Caption := TStringList.Create;
  FCaptionSettings.Caption.Clear;
  FIconSettings.Icon := TBitmap32.Create; 
  LoadSettings;
end;

destructor TFolderLayer.Destroy;
begin
  DebugFree(FCaptionSettings.Caption);
  DebugFree(FIconSettings.Icon);
  DebugFree(FSettings);
  DebugFree(FDeskPanel);
  FHLTimer.Enabled := False;
  DebugFree(FHLTimer);
  inherited Destroy;
end;

end.
