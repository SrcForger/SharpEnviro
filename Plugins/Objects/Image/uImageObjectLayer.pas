{
Source Name: Image Layer
Description: ImageLayer class
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

unit uImageObjectLayer;

interface
uses
  Windows, StdCtrls, Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, Forms, SharpDeskApi, JCLShell,
  ImageObjectSettingsWnd,
  ImageObjectXMLSettings,
  uSharpDeskTDeskSettings,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskDebugging,
  IdBaseComponent,
  IdHTTP,
  GR32_Resamplers;

type

  TImageLayer = class(TBitmapLayer)
  private
    FSettings    : TXMLSettings;
    FObjectID    : integer;
    FIconFile    : string;
    FHLTimer     : TTimer;
    FHLTimerI    : integer;
    FAnimSteps   : integer;    
    FAlphaBlend  : boolean;
    FAlphaValue  : integer;
    FBlendColor  : integer;
    FBlendValue  : integer;
    FLocked      : boolean;
    FBlend       : boolean;
    FUseThemeSettings : boolean;
    FPicture     : TBitmap32;
    FDeskSettings   : TDeskSettings;
    FThemeSettings  : TThemeSettings;
    FObjectSettings : TObjectSettings;
    FSize        : integer;
    FParentImage : TImage32;
    FftURL       : boolean;
    FURLRefresh  : integer;
    FUpdateTimer : TTimer;

  protected
     procedure doLoadImage(var Bmp : TBitmap32; IconFile: string);
     procedure LoadDefaultImage(var bmp : TBitmap32);

  public

     procedure DrawBitmap;
     procedure LoadSettings;
     procedure StartHL;
     procedure EndHL;
     procedure OnTimer(Sender : TObject);
     procedure OnUpdateTimer(Sender : TObject);
     procedure OnOpenClick(Sender : TObject);
     procedure OnPropertiesClick(Sender : TObject);
     procedure SizeOnClick(Sender : TObject);
     procedure UpdateImage;
     constructor Create(ParentImage : Timage32; Id : integer;
                        DeskSettings : TDeskSettings;
                        ThemeSettings : TThemeSettings;
                        ObjectSettings : TObjectSettings); reintroduce;
     destructor Destroy; override;
     property ObjectID: Integer read FObjectId write FObjectId;
     property Locked : boolean read FLocked write FLocked;
     property Size : integer read FSize write FSize;
     property ParentImage : TImage32 read FParentImage write FParentImage;
  end;

type
    pTBitmap32 = ^TBitmap32;


implementation

uses  uSharpDeskManager,
      uSharpDeskDesktopObject,
      uSharpDeskObjectSet,
      uSharpDeskObjectSetItem;

procedure TImageLayer.StartHL;
begin
  if (FDeskSettings.Theme.DeskHoverAnimation) and (not FLocked) then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    if (not FLocked) then SharpDeskApi.LightenBitmap(Bitmap,50);
  end;
end;

procedure TImageLayer.EndHL;
begin
  if (FDeskSettings.Theme.DeskHoverAnimation) and (not FLocked) then
  begin
    FHLTimerI := -1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
  end;
end;

procedure TImageLayer.OnTimer(Sender: TObject);
var
  i : integer;
begin
  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 0;
    if (FUseThemeSettings) and (FDeskSettings.Theme.DeskUseAlphaBlend) then
       i := FDeskSettings.Theme.DeskAlphaBlend
        else if FAlphaBlend then i := FAlphaValue
             else i := 255;
    if i > 255 then i := 255
       else if i<32 then i := 32;
    Bitmap.MasterAlpha := i;
    DrawBitmap;
    Changed;
    exit;
  end;
  FParentImage.BeginUpdate;
  if FDeskSettings.Theme.AnimAlpha then
  begin
    if (FUseThemeSettings) and (FDeskSettings.Theme.DeskUseAlphaBlend) then
       i := FDeskSettings.Theme.DeskAlphaBlend
        else if FAlphaBlend then i := FAlphaValue
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
  Changed;
end;

procedure TImageLayer.OnOpenClick(Sender : TObject);
begin
     SharpExecute(FIconFile);
end;

procedure TImageLayer.OnPropertiesClick(Sender : TObject);
begin
     DisplayPropDialog(Application.Handle,FIconFile);
end;


procedure TImageLayer.SizeOnClick(Sender : TObject);
begin
  if Sender = nil then exit;
  FSettings.Size := TComponent(Sender).Tag;
  FSettings.SaveSettings(True);
  LoadSettings;
end;

procedure TImageLayer.OnUpdateTimer(Sender : TObject);
begin
  UpdateImage;
end;

procedure TImageLayer.UpdateImage;
var
  tempBmp : TBitmap32;
  idHTTP : TIdHTTP;
  FileStream : TFileStream;
  Dir : string;
  Ext : string;
  MimeList: TStringList;
  i : integer;
begin
  tempBmp := TBitmap32.Create;
  if not FftURL then doLoadImage(tempBmp,FIconFile)
  else
  begin
    MimeList := TStringList.Create;
    MimeList.Clear;
    MimeList.Add('image/jpeg');
    MimeList.Add('image/png');
    MimeList.Add('image/bmp');
    Dir := SharpApi.GetSharpeUserSettingsPath+'SharpDesk\Objects\Image\';
    ForceDirectories(Dir);
    idHTTP := TidHTTP.Create(nil);
    idHTTP.ConnectTimeout := 5000;
    idHTTP.Request.Accept := 'image/jpeg,image/png,image/bmp';
    idHTTP.HandleRedirects := True;
    try
      idHTTP.Head(FIconFile);
    except
    end;
    if MimeList.IndexOf(idHttp.Response.ContentType)<>-1 then
    begin
      try
        try
          i := random(1000000);
          if idHttp.Response.ContentType = 'image/jpeg' then Ext := '.jpg'
             else if idHttp.Response.ContentType = 'image/png' then Ext := '.png'
                  else Ext := '.bmp';
          FileStream := TFileStream.Create(Dir+'temp'+inttostr(i)+Ext,fmCreate);
          try
            SharpApi.SendDebugMessage('Image.object','Starting download: '+FIconFile,clblack);
            idHTTP.Get(FIconFile,FileStream);
            SharpApi.SendDebugMessage('Image.object','Download finished',clblack);
          finally
            FileStream.Free;
          end;
          SharpApi.SendDebugMessage('Image.object','Loading downloaded image: '+Dir+'temp'+inttostr(i)+Ext,clblack);
          doLoadImage(tempBmp,Dir+'temp'+inttostr(i)+Ext);
        except
          tempBmp.SetSize(128,128);
          tempBmp.Clear(color32(128,128,128,196));
          tempBmp.RenderText(tempBmp.Width div 2-tempBmp.TextWidth('Error on image download') div 2,
                            tempBmp.Height div 2-TempBmp.TextHeight('E') div 2,'Error on image download',0,color32(clWhite));
        end;
      finally
        try
          idHttp.Disconnect;
          idHttp.Free;
        except
        end;
        try
          DeleteFile(Dir+'temp'+inttostr(i)+Ext);
        except
        end;
      end;
    end else
    begin
      try
        idHttp.Disconnect;
        idHttp.Free;
      except
      end;
      tempBmp.SetSize(128,128);
      tempBmp.Clear(color32(128,128,128,196));
      tempBmp.RenderText(tempBmp.Width div 2-tempBmp.TextWidth('Error on image download') div 2,
                         tempBmp.Height div 2-TempBmp.TextHeight('E') div 2,'Error on image download',0,color32(clWhite));
    end;
    MimeList.Free;    
  end;

  TLinearResampler.Create(TempBmp);
  FPicture.SetSize(round(tempBmp.Width * (FSize / 100)),round(tempBmp.Height * (FSize / 100)));
  FPicture.Clear(color32(0,0,0,0));
  FPicture.Draw(Rect(0,0,FPicture.Width,FPicture.Height),
                Rect(0,0,tempBmp.Width,tempBmp.Height),
                tempBmp);
  DrawBitmap;
  tempBmp.Free;
end;

procedure TImageLayer.DrawBitmap;
var
 R : TFloatrect;
 w,h : integer;
 tempDeskManager : TSharpDeskManager;
 tempDesktopObject : TDesktopObject;
begin
  //Say to Image that we will update
  FParentImage.BeginUpdate;

  //Seems like it must be said sometimes
  FPicture.DrawMode := dmOpaque;

  //Decide size
  w := FPicture.Width;
  h := FPicture.Height;
  Bitmap.SetSize(w,h);

  //Draw image centered
  Bitmap.Clear(color32(0,0,0,0));
  Bitmap.Draw(round((w-FPicture.Width)/2),0,FPicture);
  //if (FHighlight) and not (FLocked) then SharpDeskApi.LightenBitmap(Bitmap,50);

  //Set the right size of the layer
  R := getadjustedlocation;
  if (w <> (R.Right-R.left)) then   //dont move image if resize
    R.Left := R.left + round(((R.Right-R.left)- w)/2);
  if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
    R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
  if R.Left > Screen.DesktopWidth then
     R.Left := Screen.DesktopWidth-w;
  if R.Top > Screen.DesktopHeight then
     R.Top := Screen.DesktopHeight-h;
  if R.Left < 0 then R.Left := 0;
  if R.Top <0 then R.Top := 0;
  R.Right := r.Left + w;
  R.Bottom := r.Top + h;
  location := R;

  //Seems like it must be said sometimes
  Bitmap.DrawMode := dmBlend;

   //
  FParentImage.EndUpdate;
  Changed;
end;



procedure TImageLayer.LoadDefaultImage(var bmp : TBitmap32);
begin
  try
    bmp.SetSize(128,128);
    bmp.Clear(color32(128,128,128,128));
  finally
  end;

end;


procedure TImageLayer.doLoadImage(var Bmp : TBitmap32; IconFile: string);
var
   FileExt : String;
begin
  if FileExists(IconFile) = True then
  begin
       FileExt := ExtractFileExt(IconFile);
       if (lowercase(FileExt) = '.jpeg') or (lowercase(FileExt) = '.jpg') then loadjpg(bmp,IconFile)
          else if (lowercase(FileExt) = '.ico') then loadIco(bmp,IconFile,32)
               else if (lowercase(FileExt) = '.png') then loadPng(bmp,IconFile)
                    else if (lowercase(FileExt) = '.bmp') then LoadBmp(bmp,IconFile)
                        else Bitmap.Clear(color32(130,130,130,0));
  end
  else LoadDefaultImage(bmp);
end;



procedure TImageLayer.LoadSettings;
var
   tempBmp : TBitmap32;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;

  FftURL := FSettings.ftURL;
  FURLRefresh := FSettings.URLRefresh;
  if FftURL then
  begin
    FUpdateTimer.Enabled := True;
    FUpdateTimer.Interval := FURLRefresh*60*1000;
  end else FUpdateTimer.Enabled := False;
  FUseThemeSettings := FSettings.UseThemeSettings;
  FSize := FSettings.Size;
  
  if FUseThemeSettings then
  begin
    FBLendValue := FDeskSettings.Theme.DeskColorBlend;
    FBlend      := FDeskSettings.Theme.DeskUseColorBlend;
    FAlphaValue := FDeskSettings.Theme.DeskAlphaBlend;
    FAlphaBlend := FDeskSettings.Theme.DeskUseAlphaBlend;
  end
  else
  begin
    FBlendValue := FSettings.BlendValue;
    FBlend      := FSettings.ColorBlend;
    FAlphaValue := FSettings.AlphaValue;
    FAlphaBlend := FSettings.AlphaBlend;
  end;

  if FBlend then
  begin
    if FUseThemeSettings then FBlendColor := FDeskSettings.Theme.DeskColorBlendColor
       else FBlendColor := FSettings.BlendColor;
  end;

  FIconFile := FSettings.IconFile;
  if FAlphaBlend then
  begin
    Bitmap.MasterAlpha := FAlphaValue;
    if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
  end else Bitmap.MasterAlpha := 255;

  UpdateImage;

  if FBlend then BlendImage(FPicture, FBlendColor,FBlendValue);

  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);
end;


constructor TImageLayer.Create( ParentImage:Timage32; Id : integer;
                                DeskSettings : TDeskSettings;
                                ThemeSettings : TThemeSettings;
                                ObjectSettings : TObjectSettings);
begin
  Inherited Create(ParentImage.Layers);
  FDeskSettings   := DeskSettings;
  FThemeSettings  := ThemeSettings;
  FObjectSettings := ObjectSettings;
  FParentImage := ParentImage;
  FPicture := Tbitmap32.Create;
  Alphahit := False;
  FObjectId := id;
  scaled := False;
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled := False;
  FHLTimer.OnTimer := OnTimer;
  FUpdateTimer := TTimer.Create(nil);
  FUpdateTimer.Interval := 10000000;
  FUpdateTimer.Enabled := False;
  FUpdateTimer.OnTimer := OnUpdateTimer;
  FSettings := TXMLSettings.Create(FObjectId,nil);
  FAnimSteps       := 5;  
  LoadSettings;
end;

destructor TImageLayer.Destroy;
begin
  FHLTimer.Enabled := False;
  DebugFree(FHLTimer);
  DebugFree(FUpdateTimer);
  DebugFree(FPicture);
  DebugFree(FSettings);
  inherited;
end;

end.
