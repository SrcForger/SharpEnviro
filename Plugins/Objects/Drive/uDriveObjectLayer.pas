{
Source Name: DriveLayer
Description: Drive desktop object layer class
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

unit uDriveObjectLayer;

interface
uses
  Windows, Types, StdCtrls, Forms,Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters, GR32_Backends,
  JclSimpleXML, SharpDeskApi, JclFileUtils, JclShell,
  SharpThemeApiEx,
  SharpGraphicsUtils,
  SharpIconUtils,
  DriveObjectXMLSettings,
  uSharpDeskDebugging,
  uSharpDeskTDeskSettings,
  uSharpDeskFunctions,
  uSharpDeskDesktopPanel,
  uSharpDeskObjectSettings,
  GR32_Resamplers;
type
   TColorRec = packed record
                 b,g,r,a: Byte;
               end;
   TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
   PColorArray = ^TColorArray;
   TDriveType = (dtUnknown, dtNoDrive, dtFloppy, dtFixed, dtNetwork, dtCDROM,dtRAM);   

  TDriveLayer = class(TBitmapLayer)
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
    FIconType        : integer;
    FScale           : integer;
    FLocked          : Boolean;
    FDeskPanel       : TDesktopPanel;
    FPicture         : TBitmap32;
    FMeterBmp        : TBitmap32;
    FOldSpaceFree    : integer;
    FOldDriveType    : integer;
    FOldDriveName    : String;
    
  protected
     procedure OnTimer(Sender: TObject);
     procedure OnUpdateTimer(Sender : TObject);

     function UpdateDriveSize: boolean;
     function UpdateDriveType: boolean;

  public
     FParentImage : Timage32;
     procedure DrawBitmap;
     procedure LoadSettings;
     procedure DoubleClick;
     procedure LoadDefaultImage;
     procedure OnOpenClick(Sender : TObject);
     procedure OnSearchClick(Sender : TObject);
     procedure OnPropertiesClick(Sender : TObject);
     procedure OnOpenWith(Sender : TObject);
     procedure StartHL;
     procedure EndHL;
     constructor Create( ParentImage:Timage32; Id : integer); reintroduce;
     destructor Destroy; override;
     property ObjectId: Integer read FObjectId write FObjectId;
     property Settings  : TXMLSettings read FSettings;
     property Locked    : boolean read FLocked    write FLocked;     
  private
  end;


const
     DESK_SETTINGS = 'Settings\SharpDesk\SharpDesk.xml';
     THEME_SETTINGS = 'Settings\SharpDesk\Themes.xml';
     OBJECT_SETTINGS = 'Settings\SharpDesk\Objects.xml';

function GetDiskFree(drive: char): integer;
function GetDiskCapacity(drive: char): integer;

implementation

function GetDiskCapacity(drive: char): integer;
var
  a: real;
  b: string;
  driveno: integer;
begin
  try
    driveno := Ord(UpCase(Drive)) - Ord('A') + 1;
    a := Disksize(driveno) / 1048576;
    if a = -1 then
    begin
      result := 0;
      exit;
    end;

    b := floattostrf(a, ffFixed, 10, 0);
    Result := StrToInt(b);
  except
    result:=0;
  end;
end;

function GetDiskFree(drive: char): integer;
var
  a: real;
  b: string;
  driveno: integer;
begin
  try
    driveno := Ord(UpCase(Drive)) - Ord('A') + 1;
    a := DiskFree(driveno) / 1048576;
    if a = -1 then
    begin
      result := 0;
      exit;
    end;

    b := floattostrf(a, ffFixed, 10, 0);
    Result := StrToInt(b);
  except
    result := 0;
  end;
end;


function DriveConnected(DriveLetter : char) : Boolean;
var  hr : hresult;
   remotename : array[0..255] of char;
   cbRemoteName : cardinal;
begin
  cbRemoteName := Length(RemoteName);
  hr := WNetGetConnection(pChar(DriveLetter), RemoteName, cbRemoteName);
  
  if hr = NO_ERROR then
    result := true
  else
    result := false;
end;

function GetDiskIn(Drive: Char): Boolean;
var
  ErrorMode: word;
  DriveNumber: Integer;
begin
  {Meldung eines kritischen Systemfehlers vehindern}
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    DriveNumber := Ord(Drive) - 64;
    if DiskSize(DriveNumber) = -1 then
      Result := False
    else
      Result := True;
  finally
    {ErrorMode auf den alten Wert setzen}
    SetErrorMode(ErrorMode);
  end;
end;

procedure TDriveLayer.OnOpenClick(Sender : TObject);
begin
  DoubleClick;
end;


procedure TDriveLayer.OnSearchClick(Sender : TObject);
//var
//   Shell: Variant;
begin
  //   Shell := CreateOLEObject('Shell.Application');
  //   Shell.FindFiles;
end;

procedure TDriveLayer.OnPropertiesClick(Sender : TObject);
begin
  DisplayPropDialog(Application.Handle,FSettings.Target+':\');
end;

procedure TDriveLayer.OnOpenWith(Sender : TObject);
begin
  ShellOpenAs(FSettings.Target+':\');
end;

procedure TDriveLayer.StartHL;
begin
 // if FHLTimer.Enabled then exit;
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

procedure TDriveLayer.EndHL;
begin
//if FHLTimer.Enabled then exit;
  if GetCurrentTheme.Desktop.Animation.UseAnimations then
  begin
    FHLTimerI := -1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
  end;
end;

function GetDriveName(Drive : string) : string;
var
  Ret : string;
  driveType : integer;
  Info: TSHFileInfo;
begin
  try
    SHGetFileInfo(PChar(Drive + ':\'), 0, Info, SizeOf(TSHFileInfo), SHGFI_DISPLAYNAME or SHGFI_TYPENAME);
    Ret := Trim(Info.szDisplayName);

    // Return drive type if name is not specified
    if Length(Ret) <= 0 then
    begin
      driveType := GetDriveType(PChar(Drive + ':\'));

      case driveType of
      DRIVE_UNKNOWN, DRIVE_NO_ROOT_DIR:
        Ret := 'Unknown Disk';
      DRIVE_FIXED:
        Ret := 'Local Disk';
      DRIVE_REMOTE:
        Ret := 'Network Disk';
      DRIVE_REMOVABLE:
        Ret := 'Removable Disk';
      DRIVE_RAMDISK:
        Ret := 'Floppy Disk';
      DRIVE_CDROM:
        Ret := 'CD Drive';
      end;
    end;

    Result := Ret;
  except
  end;
end;

function TDriveLayer.UpdateDriveSize: boolean;
var
  SpaceFree : single;
  SpacePrefix : string;
  DriveName : string;
begin
  Result := False;

  DriveName := GetDriveName(FSettings.Target[1]);

  if (GetDiskIn(FSettings.Target[1])) then
  begin
    // Check if read-only
    if GetDiskFree(FSettings.Target[1]) = 0 then
      SpaceFree := 0.00
    else
      SpaceFree := (GetDiskCapacity(FSettings.Target[1])) - (GetDiskFree(FSettings.Target[1]));

    // If the free space and the drive name have not changed then exit.
    if (floor(SpaceFree) = FOldSpaceFree) and (DriveName = FOldDriveName) then
      exit;

    FOldSpaceFree := floor(SpaceFree);
    FOldDriveName := DriveName;

    if (FSettings.ShowCaption) then
    begin
      if SpaceFree >= (1024 * 1024) then
      begin
        SpaceFree := SpaceFree / (1024 * 1024);
        SpacePrefix := 'TB';
      end else if SpaceFree > (1024) then
      begin
        SpaceFree := SpaceFree / (1024);
        SpacePrefix := 'GB';
      end else
      begin
        SpacePrefix := 'MB';
      end;

      // Add the Drive letter
      FCaptionSettings.Caption.Clear;
      FCaptionSettings.Caption.Delimiter := ' ';

      if Length(DriveName) <= 0 then
        FCaptionSettings.Caption.Add(FSettings.Caption)
      else
        FCaptionSettings.Caption.Add(DriveName);

      FCaptionSettings.Caption.Add(FloatToStrF(SpaceFree,ffFixed,6,2) + ' ' + SpacePrefix + ' Free');

      Result := True;
      exit;
    end;
  end;

  if (DriveName = FOldDriveName) then
    Exit;

  FOldDriveName := DriveName;
      
  // Add the Drive letter
  FCaptionSettings.Caption.Clear;
  FCaptionSettings.Caption.Delimiter := ' ';

  if Length(DriveName) <= 0 then
    FCaptionSettings.Caption.Add(FSettings.Caption)
  else
    FCaptionSettings.Caption.Add(DriveName);

  Result := True;
end;

function TDriveLayer.UpdateDriveType: boolean;
var
  driveType : integer;
  iconStr : string;
  iconSize : integer;
  TempBitmap : TBitmap32;
begin
  Result := False;

  driveType := GetDriveType(PChar(FSettings.Target + ':\'));
  if driveType = FOldDriveType then
    exit;

  FOldDriveType := driveType;

  case driveType of
  DRIVE_UNKNOWN, DRIVE_NO_ROOT_DIR:
    iconStr := 'icon.drive.unknown';
  DRIVE_FIXED, DRIVE_REMOTE:
    iconStr := 'icon.drive.hdd';
  DRIVE_REMOVABLE, DRIVE_RAMDISK:
    iconStr := 'icon.drive.other';
  DRIVE_CDROM:
    iconStr := 'icon.drive.cdrom';
  end;

  {SharpE Icon}
  TempBitmap := TBitmap32.Create;
  try
    iconSize := FSettings.Theme[DS_ICONSIZE].IntValue;
    IconStringToIcon(iconStr, FSettings.Target, TempBitmap, GetNearestIconSize(iconSize));

    FPicture.SetSize(iconSize, iconSize);
    FPicture.Clear(color32(0,0,0,0));
    TempBitmap.DrawTo(FPicture, Rect(0, 0, iconSize, iconSize));
  except
  end;

  TempBitmap.Free;

  Result := True;
end;

procedure TDriveLayer.OnUpdateTimer(Sender : TObject);
begin
  if (UpdateDriveSize) or (UpdateDriveType) then
    DrawBitmap;
end;

procedure TDriveLayer.OnTimer(Sender: TObject);
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

    i := 255;
    Bitmap.MasterAlpha := i;
    
    DrawBitmap;
    FParentImage.EndUpdate;
    EndUpdate;
    Changed;
    exit;
  end;

  if GetCurrentTheme.Desktop.Animation.Scale then
    FScale := round(100 + ((GetCurrentTheme.Desktop.Animation.ScaleValue)/FAnimSteps)*FHLTimer.Tag);
  if GetCurrentTheme.Desktop.Animation.Alpha then
  begin
    FScale := 100;

    i := 255;
    i := i + round(((GetCurrentTheme.Desktop.Animation.AlphaValue/FAnimSteps)*FHLTimer.Tag));
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
  if GetCurrentTheme.Desktop.Animation.Brightness then
     LightenBitmap(Bitmap,round(FHLTimer.Tag*(GetCurrentTheme.Desktop.Animation.BrightnessValue/FAnimSteps)));
  if GetCurrentTheme.Desktop.Animation.Blend then
     BlendImageA(Bitmap,
                 GetCurrentTheme.Desktop.Animation.BlendColor,
                 round(FHLTimer.Tag*(GetCurrentTheme.Desktop.Animation.BlendValue/FAnimSteps)));
  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;


procedure TDriveLayer.DoubleClick;
begin
  SharpExecute(FSettings.Target + ':\');
end;

procedure TDriveLayer.DrawBitmap;
var
   R : TFloatrect;
   w,h : integer;
   TempBitmap : TBitmap32;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

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

procedure TDriveLayer.LoadDefaultImage;
begin
  FIconType := 0;
  FPicture.SetSize(100,100);
  FPicture.Clear(color32(0,0,0,0));
end;

procedure TDriveLayer.LoadSettings;
var
  TempBitmap : TBitmap32;
  iconSize : integer;
begin
  if ObjectID = 0 then
    exit;

  FOldDriveType := -1;
  FOldSpaceFree := -1;
  FOldDrivename := '';
  
  FSettings.LoadSettings;
  if length(FSettings.Target) > 1 then
    FSettings.Target := FSettings.Target[1];

  with FSettings do
  begin
    FFontSettings.Name      := Theme[DS_FONTNAME].Value;
    FFontSettings.Size      := Theme[DS_TEXTSIZE].IntValue;
    FFontSettings.Color     := GetCurrentTheme.Scheme.SchemeCodeToColor(Theme[DS_TEXTCOLOR].IntValue);
    FFontSettings.Bold      := Theme[DS_TEXTBOLD].BoolValue;
    FFontSettings.Italic    := Theme[DS_TEXTITALIC].BoolValue;
    FFontSettings.Underline := Theme[DS_TEXTUNDERLINE].BoolValue;
    FFontSettings.ClearType   := Theme[DS_TEXTCLEARTYPE].BoolValue;
    FFontSettings.ShadowColor      := GetCurrentTheme.Scheme.SchemeCodeToColor(Theme[DS_TEXTSHADOWCOLOR].IntValue);
    FFontSettings.ShadowAlphaValue := Theme[DS_TEXTSHADOWALPHA].IntValue;
    FFontSettings.Shadow           := Theme[DS_TEXTSHADOW].BoolValue;
    FFontSettings.TextAlpha        := Theme[DS_TEXTALPHA].BoolValue;
    FFontSettings.Alpha            := Theme[DS_TEXTALPHAVALUE].IntValue;
    FFontSettings.ShadowType       := Theme[DS_TEXTSHADOWTYPE].IntValue;
    FFontSettings.ShadowSize       := Theme[DS_TEXTSHADOWSIZE].IntValue;

    FCaptionSettings.Align := IntToTextAlign(FSettings.CaptionAlign);
    FCaptionSettings.Xoffset := 0;
    FCaptionSettings.Yoffset := 0;
    FCaptionSettings.Draw := ShowCaption;
    FCaptionSettings.LineSpace := 0;

    UpdateDriveSize;

    FIconSettings.Size  := 100;
    FIconSettings.Alpha := 255;
    if Theme[DS_ICONALPHABLEND].BoolValue then
      FIconSettings.Alpha := Theme[DS_ICONALPHA].IntValue;
    FIconSettings.XOffset     := 0;
    FIconSettings.YOffset     := 0;

    FIconSettings.Blend       := Theme[DS_ICONBLENDING].BoolValue;
    FIconSettings.BlendColor  := GetCurrentTheme.Scheme.SchemeCodeToColor(Theme[DS_ICONBLENDCOLOR].IntValue);
    FIconSettings.BlendValue  := Theme[DS_ICONBLENDALPHA].IntValue;
    FIconSettings.Shadow      := Theme[DS_ICONSHADOW].BoolValue;
    FIconSettings.ShadowColor := GetCurrentTheme.Scheme.SchemeCodeToColor(Theme[DS_ICONSHADOWCOLOR].IntValue);
    FIconSettings.ShadowAlpha := 255-Theme[DS_ICONSHADOWALPHA].IntValue;

    if Theme[DS_ICONSIZE].IntValue <= 8 then
       Theme[DS_ICONSIZE].IntValue:= 48;
  end;

  {SharpE Icon}
  if FSettings.CustomIcon then
  begin
    TempBitmap := TBitmap32.Create;
    try
      iconSize := FSettings.Theme[DS_ICONSIZE].IntValue;
      IconStringToIcon(FSettings.IconFile, FSettings.Target, TempBitmap, GetNearestIconSize(iconSize));

      FPicture.SetSize(iconSize, iconSize);
      FPicture.Clear(color32(0,0,0,0));
      TempBitmap.DrawTo(FPicture, Rect(0, 0, iconSize, iconSize));
    except
    end;

    TempBitmap.Free;
  end else
    UpdateDriveType;

  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);   

  DrawBitmap;
end;


constructor TDriveLayer.Create( ParentImage:Timage32; Id : integer);
begin
  Inherited Create(ParentImage.Layers);
  FParentImage := ParentImage;
  FPicture := TBitmap32.Create;
  FMeterBmp := TBitmap32.Create;
  FDeskPanel := TDesktopPanel.Create;
  Alphahit := False;
  FObjectId := id;
  FScale     := 100;
  scaled := false;

  FOldSpaceFree := -1;
  FOldDriveType := -1;
  FOldDriveName := '';

  FSettings := TXMLSettings.Create(FObjectId,nil,'Drive');

  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled  := False;  
  FHLTimer.OnTimer  := OnTimer;
  FAnimSteps        := 5;

  FUpdateTimer := TTImer.Create(nil);
  FUpdateTimer.Interval := 1000*10;
  FUpdateTimer.Enabled  := True;
  FUpdateTimer.OnTimer  := OnUpdateTimer;
  
  FCaptionSettings.Caption := TStringList.Create;
  FCaptionSettings.Caption.Clear;
  
  FIconSettings.Icon := TBitmap32.Create;   
  LoadSettings;
end;

destructor TDriveLayer.Destroy;
begin
  DebugFree(FSettings);
  DebugFree(FPicture);
  DebugFree(FDeskPanel);
  DebugFree(FCaptionSettings.Caption);
  DebugFree(FIconSettings.Icon);  
  FHLTimer.Enabled := False;
  DebugFree(FHLTimer);
  DebugFree(FMeterBmp);
  FUpdateTimer.Enabled := False;
  DebugFree(FUpdateTimer);
  inherited Destroy;
end;

end.
