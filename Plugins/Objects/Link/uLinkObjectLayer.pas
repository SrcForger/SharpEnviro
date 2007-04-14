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
  SharpThemeApi,
  SharpIconUtils,
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
     constructor Create( ParentImage:Timage32; Id : integer); reintroduce;
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
  if SharpThemeApi.GetDesktopAnimUseAnimations then
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
  if SharpThemeApi.GetDesktopAnimUseAnimations then
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
{    if (FSettings.UseThemeSettings) and (SharpThemeApi.GetDesktopIconAlphaBlend) then
       i := SharpThemeApi.GetDesktopIconAlpha
        else if FSettings.AlphaBlend then i := FSettings.AlphaValue
             else i := 255;}
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
    {if (FSettings.UseThemeSettings) and (SharpThemeApi.GetDesktopIconAlphaBlend) then
       i := SharpThemeApi.GetDesktopIconAlpha
        else if FSettings.AlphaBlend then i := FSettings.AlphaValue
             else i := 255;     }
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
     SharpDeskApi.LightenBitmap(Bitmap,round(FHLTimer.Tag*(SharpThemeApi.GetDesktopAnimBrightnessValue/FAnimSteps)));
  if SharpThemeApi.GetDesktopAnimBlend then
     SharpDeskApi.BlendImage(Bitmap,
                             SharpThemeApi.GetDesktopAnimBlendColor,
                             round(FHLTimer.Tag*(SharpThemeApi.GetDesktopAnimBlendValue/FAnimSteps)));
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




procedure TFolderLayer.LoadSettings;
var
  bmp : TBitmap32;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;

  FFontSettings.Name      := FSettings.FontName;
  FFontSettings.Size      := FSettings.FontSize;
  FFontSettings.Color     := FSettings.FontColor;
  FFontSettings.Bold      := FSettings.FontBold;
  FFontSettings.Italic    := FSettings.FontItalic;
  FFontSettings.Underline := FSettings.FontUnderline;
  FFontSettings.AALevel   := 0;
  if FSettings.FontAlpha then FFontSettings.Alpha := FSettings.FontAlphaValue
     else FFontSettings.Alpha := 255;
  FFontSettings.ShadowColor := FSettings.FontShadowColor;
  FFontSettings.ShadowAlphaValue := FSettings.FontShadowValue;
  FFontSettings.Shadow    := FSettings.FontShadow;
  FFontSettings.ShadowAlpha := True;

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

  FCaptionSettings.Draw := FSettings.ShowCaption;
  FCaptionSettings.LineSpace := 0;

  FIconSettings.Size  := 100;
  FIconSettings.Alpha := 255;
  FIconSettings.ShadowColor := GetDesktopIconShadowColor;
  FIconSettings.ShadowAlpha := GetDesktopIconShadowAlpha;
  FIconSettings.XOffset     := 0;
  FIconSettings.YOffset     := 0;
  if FSettings.IconOffset then FIconSettings.XOffset := FSettings.IconOffsetValue;;

  FIconSettings.Blend       := FSettings.ColorBlend;
  FIconSettings.BlendColor  := FSettings.BlendColor;
  FIconSettings.BlendValue  := FSettings.BlendValue;
  FIconSettings.Shadow      := FSettings.UseIconShadow;

  if length(FSettings.Size)=0 then FSettings.Size:='48';

  bmp := TBitmap32.Create;
  IconStringToIcon(FSettings.IconFile,FSettings.Target,Bmp,strtoint(FSettings.Size));
  bmp.DrawMode := dmBlend;
  bmp.CombineMode := cmMerge;
  TLinearResampler.Create(bmp);
  FIconSettings.Icon.SetSize(strtoint(FSettings.Size),strtoint(Fsettings.Size));
  FIconSettings.Icon.Clear(color32(0,0,0,0));
  bmp.DrawTo(FIconSettings.Icon,Rect(0,0,FIconSettings.Icon.Width,FIconSettings.Icon.Height));
  bmp.Free;

  if FSettings.AlphaBlend then
  begin
    Bitmap.MasterAlpha := FSettings.AlphaValue;
    if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
  end else Bitmap.MasterAlpha := 255;

  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);   
end;


constructor TFolderLayer.Create( ParentImage:Timage32; Id : integer);
begin
  Inherited Create(ParentImage.Layers);
  FParentImage := ParentImage;
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
  FHLTimer.Enabled := False;
  DebugFree(FHLTimer);
  inherited Destroy;
end;

end.
