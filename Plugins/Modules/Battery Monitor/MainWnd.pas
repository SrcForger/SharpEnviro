{
Source Name: MainWnd
Description: Battery Monitor module main window
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

unit MainWnd;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, SharpEBaseControls, GR32_Resamplers,
  ExtCtrls, SharpEProgressBar, GR32, uISharpBarModule,
  JclSimpleXML, SharpApi, Menus, Math, SharpESkinLabel;


type
  TMainForm = class(TForm)
    UpdateTimer: TTimer;
    lb_pc: TSharpESkinLabel;
    pbar: TSharpEProgressBar;
    lb_info: TSharpESkinLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  protected
  private
    sShowIcon : boolean;
    sShowPBar : boolean;
    sShowInfo : boolean;
    sShowPC   : boolean;
    FBStatus1 : TBitmap32;
    FBStatus2 : TBitmap32;
    FLastIcon : TBitmap32;
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure RenderIcon(pRepaint : boolean = True);
    procedure LoadIcons;
    property LastIcon : TBitmap32 read FLastIcon write FLastIcon;
  end;


implementation

uses
  GR32_PNG,
  uSharpXMLUtils;

{$R *.dfm}

function GetPowerStatus(var HasBattery: Boolean; var LoadStatusString: String;
 var LoadstatusPercent: Integer): DWORD;
var
 SystemPowerStatus: TSystemPowerStatus;
 Text: string;
resourcestring
 rsLoadStatusUnknown = 'UnKnown Status';
 rsLoadStatusNoBattery = 'No Battery';
 rsLoadStatusHigh = 'High Status';
 rsLoadStatusLow = 'Low Status';
 rsLoadStatusCritical = 'Critical Status';
 rsLoadStatusLoading = 'Loading Status';
 rsLoadSatusUnknownLoading = 'UnKnown Status';
begin
 SetLastError(0);
 if GetSystemPowerStatus(SystemPowerStatus) then
   with SystemPowerStatus do
   begin
     HasBattery := ACLineStatus = 0;

     if (BatteryFlag = 255) then
       Text := rsLoadStatusUnknown
     else if (BatteryFlag and 128 = 128) then
       Text := rsLoadStatusNoBattery
     else
     begin
       case (BatteryFlag and (1 or 2 or 4)) of
         1: Text := rsLoadStatusHigh;
         2: Text := rsLoadStatusLow;
         4: Text := rsLoadStatusCritical;
       else
         Text := rsLoadSatusUnknownLoading
       end;
       if (BatteryFlag and 8 = 8) then
         LoadStatusString := Text + rsLoadStatusLoading;
     end;

     if (BatteryLifePercent <> 255) then
       LoadstatusPercent := BatteryLifePercent
     else
       LoadstatusPercent := -1;
 end;
 Result := GetLastError;
end;

procedure TMainForm.LoadIcons;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
  ResIDSuffix : String;
begin
  if mInterface = nil then
    exit;
  if mInterface.SkinInterface = nil then
    exit;

  TempBmp := TBitmap32.Create;
  if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 16 then
  begin
    TempBmp.SetSize(16,16);
    ResIDSuffix := '16';
  end else
  begin
    TempBmp.SetSize(32,32);
    ResIDSuffix := '32';
  end;

  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, 'battery'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FBStatus1.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'batterylow'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FBStatus2.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;

  FBStatus1.DrawMode := dmBlend;
  FBStatus1.CombineMode := cmMerge;
  FBStatus2.DrawMode := dmBlend;
  FBStatus2.CombineMode := cmMerge;  
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
begin
  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with xml.Root.Items do
    begin
      sShowIcon := BoolValue('showicon',sShowIcon);
      sShowPBar := BoolValue('showpbar',sShowPBar);
      sShowInfo := BoolValue('showinfo',sShowInfo);
      sShowPC   := BoolValue('showpc',sShowPC);
    end;
  XML.Free;
  if UpdateTimer.Enabled then
    UpdateTimer.OnTimer(UpdateTimer);
end;

procedure TMainForm.UpdateComponentSkins;
begin
  lb_pc.SkinManager := mInterface.SkinInterface.SkinManager;
  lb_info.SkinManager := mInterface.SkinInterface.SkinManager;
  pbar.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSize;
begin
  FLastIcon := nil;
  LoadIcons;
  RenderIcon;
end;

procedure TMainForm.ReAlignComponents(Broadcast : boolean = True);
var
  newWidth : integer;
  o1,o2,o3,o4 : integer;
  i : integer;
begin
  self.Caption := 'Battery Monitor';

  o1 := 4;
  o2 := (Height - 2 - 4) div 2;
  o3 := 2;
  o4 := 0;
  if sShowIcon then
  begin
    FLastIcon := nil;
    RenderIcon;
    o1 := o1 + Height - 4 + 2;
  end;
  if sShowInfo then
  begin
    lb_info.Visible := True;
    lb_info.Left := o1-5;
    lb_info.LabelStyle := lsSmall;
    lb_info.UpdateSkin;
    lb_info.Top := 2 + (o2 div 2) - (lb_info.Height div 2);
    if CompareText(lb_info.Caption,'Battery') = 0 then
    begin
      lb_info.Caption := 'AC Power';
      i := lb_info.Textwidth;
      lb_info.Caption := 'Battery';
    end else i := lb_info.Textwidth;
    o3 := lb_info.Left + i + 12;
    o4 := o3;
    lb_info.Visible := True;
  end else lb_Info.Visible := False;
  if sShowPC then
  begin
    lb_pc.Visible := True;
    lb_pc.LabelStyle := lsSmall;
    lb_pc.UpdateSkin;
    if sShowInfo then lb_pc.Left := o3 - 8
       else lb_pc.Left := o3 - 5;
    lb_pc.Top := 2 + (o2 div 2) - (lb_pc.Height div 2);
    o4 := max(o4,lb_pc.Left + lb_pc.Width + 2);
    lb_pc.Visible := True;
  end else lb_pc.Visible := False;
  if sShowPBar then
  begin
    pbar.AutoSize := False;
    pbar.Height := o2;
    if sShowIcon then pbar.Width := o3 - 24
       else pbar.Width := o4-10;
    pbar.Left := o1;
    pbar.Top := Height - 2 - pbar.Height;
    pbar.Visible := True;
  end else pbar.Visible := False;

  NewWidth := max(o1,max(o3,o4));
  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if (newWidth <> Width) and (Broadcast) then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
var
  dwResult: DWORD;
  HasBattery: Boolean;
  LoadStatusString: String;
  LoadstatusPercent: Integer;
  s : String;
begin
  dwResult := GetPowerStatus(HasBattery, LoadStatusString, LoadStatusPercent);
  if dwResult = 0 then
  begin
    if HasBattery then
      s := 'Battery'
    else
      s := 'AC Power';

//    if length(LoadStatusString) > 0 then
//       s := s + ' (' + LoadStatusString +')';

    if lb_info.Visible then
       if CompareText(lb_info.Caption,s) <> 0 then lb_info.Caption := s;

    if lb_pc.Visible then
    begin
      if LoadStatusPercent >= 0 then
      begin
        if CompareText(lb_pc.Caption,s+'%') <> 0 then lb_pc.Caption := IntToStr(LoadStatusPercent)+'%';
      end else if CompareText(lb_pc.Caption,'') <> 0 then lb_pc.Caption := '';
    end;

    if pbar.Visible then
       if pbar.Value <> LoadStatusPercent then
       begin
         pbar.Value := LoadStatusPercent;
         RenderIcon(True);
       end;
  end;
end;

procedure TMainForm.RenderIcon(pRepaint : boolean = True);
begin
  if not sShowIcon then exit;

  //FBGBmp.DrawTo(Background.Bitmap);
  if pbar.Value < 25 then
  begin
    //if FLastIcon <> FBStatus2 then
    //   FBStatus2.DrawTo(Background.Bitmap,Rect(2,2,Height-2,Height-2));
    FLastIcon := FBStatus2;
  end else
  begin
    //if FLastIcon <> FBStatus1 then
    //   FBStatus1.DrawTo(Background.Bitmap,Rect(2,2,Height-2,Height-2));
    FLastIcon := FBStatus1;
  end;
  if pRepaint then Repaint;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  sShowIcon := True;
  sShowPBar := True;
  sShowInfo := True;
  sShowPC   := True;

  FLastIcon := nil;
  FBStatus1 := TBitmap32.Create;
  FBStatus2 := TBitmap32.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBStatus1);
  FreeAndNil(FBStatus2);
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  Bmp.Assign(mInterface.Background);
  if (FLastIcon <> nil) and sShowIcon then
  begin
//     FLastIcon.DrawTo(Canvas.Handle,Rect(2,2,Height-2,Height-2),FLastIcon.BoundsRect);
     if FLastIcon.Resampler = nil then
       TLinearResampler.Create(FLastIcon);
     FLastIcon.DrawTo(Bmp,Rect(2,2,Height-2,Height-2));
  end;
  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

end.
