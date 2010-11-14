{
Source Name: Image Layer
Description: ImageLayer class
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

unit uImageObjectLayer;

interface
uses
  Windows, StdCtrls, Classes, ExtCtrls, Math,
  Messages, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,GR32_Image, GR32_Layers,
  JvSimpleXML, Forms, SharpDeskApi, JCLShell,
  ImageObjectXMLSettings,
  uSharpDeskObjectSettings,
  SharpIconUtils,
  SharpImageUtils,
  SharpGraphicsUtils,
  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts,
  uSharpDeskDebugging,
  IdBaseComponent,
  IdHTTP,
  GR32_Resamplers,
  JCLStrings,
  SharpFileUtils;

type

  TImageLayer = class(TBitmapLayer)
  private
    FSettings    : TImageXMLSettings;
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
    FPicture     : TBitmap32;
    FSize        : integer;
    FImageHeight : Integer;
    FImageWidth  : Integer;
    FParentImage : TImage32;
    FUpdateTimer : TTimer;
    FDirectoryImages : TStringList;
    FDirectoryImageIndex : Integer;

  protected
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
     constructor Create(ParentImage : Timage32; Id : integer); reintroduce;
     destructor Destroy; override;
     property ObjectID: Integer read FObjectId write FObjectId;
     property Locked : boolean read FLocked write FLocked;
     property Size : integer read FSize write FSize;
     property ParentImage : TImage32 read FParentImage write FParentImage;
  end;

type
    pTBitmap32 = ^TBitmap32;


implementation


procedure TImageLayer.StartHL;
begin
  if Locked then
    exit;
    
  if GetCurrentTheme.Desktop.Animation.UseAnimations then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    LightenBitmap(Bitmap,50);
  end;
end;

procedure TImageLayer.EndHL;
begin
  if GetCurrentTheme.Desktop.Animation.UseAnimations then
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
  Theme : ISharpETheme;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;
  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 0;

    i := 255;

    Bitmap.MasterAlpha := i;
    DrawBitmap;
    FParentImage.EndUpdate;
    EndUpdate;
    Changed;
    exit;
  end;

  Theme := GetCurrentTheme;
  if Theme.Desktop.Animation.Alpha then
  begin
    i := 255;
    i := i + round(((Theme.Desktop.Animation.AlphaValue/FAnimSteps)*FHLTimer.Tag));

    if i > 255 then
      i := 255
    else if i < 32 then
      i := 32;
      
    Bitmap.MasterAlpha := i;
  end;
  if FHLTimer.Tag >= FAnimSteps then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := FAnimSteps;
  end;
  DrawBitmap;
  if Theme.Desktop.Animation.Brightness then
     LightenBitmap(Bitmap,round(FHLTimer.Tag*(Theme.Desktop.Animation.BrightnessValue/FAnimSteps)));
  if Theme.Desktop.Animation.Blend then
     BlendImageA(Bitmap,
                 Theme.Desktop.Animation.BlendColor,
                 round(FHLTimer.Tag*(Theme.Desktop.Animation.BlendValue/FAnimSteps)));
  FParentImage.EndUpdate;
  EndUpdate;
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

  case FSettings.LocationType of
    ilFile:
      SharpImageUtils.LoadImage(FIconFile,tempBmp);
    ilURL:
    begin
      MimeList := TStringList.Create;
      MimeList.Clear;
      MimeList.Add('image/jpeg');
      MimeList.Add('image/png');
      MimeList.Add('image/bmp');
      MimeList.Add('image/gif');      
      Dir := SharpApi.GetSharpeUserSettingsPath+'SharpDesk\Objects\Image\';
      ForceDirectories(Dir);
      idHTTP := TidHTTP.Create(nil);
      idHTTP.ConnectTimeout := 5000;
      idHTTP.Request.Accept := 'image/jpeg,image/gif,image/png,image/bmp';
      idHTTP.HandleRedirects := True;
      try
        idHTTP.Head(FIconFile);
      except
      end;
      if MimeList.IndexOf(idHttp.Response.ContentType)<>-1 then
      begin
        i := random(1000000);
        try
          try
            if idHttp.Response.ContentType = 'image/jpeg' then Ext := '.jpg'
            else if idHttp.Response.ContentType = 'image/png' then Ext := '.png'
            else if idHttp.Response.ContentType = 'image/gif' then Ext := '.gif'
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
            SharpImageUtils.LoadImage(Dir+'temp'+inttostr(i)+Ext,tempBmp)
          except
            tempBmp.SetSize(128,128);
            tempBmp.Clear(color32(128,128,128,196));
            tempBmp.RenderText(
              tempBmp.Width div 2-tempBmp.TextWidth('Error on image download') div 2,
              tempBmp.Height div 2-tempBmp.TextHeight('E') div 2,
              'Error on image download',
              0,color32(clWhite));
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
        tempBmp.RenderText(
          tempBmp.Width div 2-tempBmp.TextWidth('Error on image download') div 2,
          tempBmp.Height div 2-tempBmp.TextHeight('E') div 2,
          'Error on image download',
          0,color32(clWhite));
      end;
      MimeList.Free;
    end;
    ilDirectory:
    begin
      if FDirectoryImages.Count > 0 then
      begin
        FDirectoryImageIndex := FDirectoryImageIndex + 1;
        if FDirectoryImageIndex = FDirectoryImages.Count then
          FDirectoryImageIndex := 0;
        LoadImage(FDirectoryImages[FDirectoryImageIndex], tempBmp);
      end;
    end;
  end;

  if not SharpGraphicsUtils.HasVisiblePixel(tempBmp) then
  begin
    tempBmp.SetSize(tempBmp.TextWidth('Invalid Image') + 20,tempBmp.TextHeight('Invalid Image') + 20);
    tempBmp.Clear(color32(196,196,196,196));
    tempBmp.RenderText(10,10,'Invalid Image',0,color32(0,0,0,255));
  end;

  if FAlphaBlend then
    tempBmp.MasterAlpha := FAlphaValue
  else tempBmp.MasterAlpha := 255;
  tempBmp.DrawMode := dmBlend;
  tempBmp.CombineMode := cmMerge;

  TLinearResampler.Create(tempBmp);
  if FSettings.LocationType in [ilFile, ilURL] then
  begin
    FPicture.SetSize(round(tempBmp.Width * (FSize / 100)),round(tempBmp.Height * (FSize / 100)));
    FPicture.Clear(color32(0,0,0,0));
    FPicture.Draw(Rect(0,0,FPicture.Width,FPicture.Height),
                Rect(0,0,tempBmp.Width,tempBmp.Height),
                tempBmp);
  end
  else
  begin
    RescaleImage(tempBmp, FPicture, FImageWidth, FImageHeight, True);
  end;

  DrawBitmap;
  tempBmp.Free;
end;

procedure TImageLayer.DrawBitmap;
var
 R : TFloatrect;
 w,h : integer;
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

procedure TImageLayer.LoadSettings;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;
  FSettings.Path := StrRemoveChars(FSettings.Path, ['"']);
  FIconFile := FSettings.Path;
  FSize := FSettings.Size;
  FImageHeight := FSettings.ImageHeight;
  FImageWidth := FSettings.ImageWidth;

  if FSettings.LocationType in [ilUrl, ilDirectory] then
  begin
    FUpdateTimer.Interval := FSettings.RefreshInterval * 60 * 1000;
    FUpdateTimer.Enabled := True;
  end
  else
    FUpdateTimer.Enabled := False;

  if (FSettings.LocationType = ilDirectory) and (DirectoryExists(FIconFile)) then
  begin
    FindFiles(FDirectoryImages, FIconFile, '*.gif', True);
    FindFiles(FDirectoryImages, FIconFile, '*.jpg', True);
    FindFiles(FDirectoryImages, FIconFile, '*.jpeg', True);
    FindFiles(FDirectoryImages, FIconFile, '*.png', True);
    FindFiles(FDirectoryImages, FIconFile, '*.bmp', True);
    FindFiles(FDirectoryImages, FIconFile, '*.ico', True);
  end;

  with FSettings do
  begin
    FBLendValue := Theme[DS_ICONBLENDALPHA].IntValue;
    FBlendColor := GetCurrentTheme.Scheme.SchemeCodeToColor(Theme[DS_ICONBLENDCOLOR].IntValue);
    FBlend      := Theme[DS_ICONBLENDING].BoolValue;
    FAlphaValue := Theme[DS_ICONALPHA].IntValue;
    FAlphaBlend := Theme[DS_ICONALPHABLEND].BoolValue;
  end;

  Bitmap.MasterAlpha := 255;

  UpdateImage;

  if FBlend then
    BlendImageA(FPicture, FBlendColor,FBlendValue);

  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
    FHLTimer.OnTimer(FHLTimer);
end;

constructor TImageLayer.Create(ParentImage:Timage32; Id : integer);
begin
  Inherited Create(ParentImage.Layers);
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
  FDirectoryImages := TStringList.Create;
  FDirectoryImageIndex := -1;
  FSettings := TImageXMLSettings.Create(FObjectId,nil,'Image');
  FAnimSteps       := 5;
  LoadSettings;
 
end;

destructor TImageLayer.Destroy;
begin
  FHLTimer.Enabled := False;
  FUpdateTimer.Enabled := False;
  DebugFree(FHLTimer);
  DebugFree(FUpdateTimer);
  DebugFree(FPicture);
  DebugFree(FDirectoryImages);
  DebugFree(FSettings);
  inherited;
end;

end.
