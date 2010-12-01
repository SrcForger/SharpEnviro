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
  Windows, SysUtils, Classes, Controls, Forms, Types,
  Dialogs, StdCtrls, SharpEBaseControls, GR32_Resamplers,
  ExtCtrls, SharpEProgressBar, GR32, uISharpBarModule,
  JclSimpleXML, SharpApi, Menus, Math, SharpESkinLabel, SharpNotify;


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
    FLastStatus : Integer;
    FShowNotifications : Boolean;
    FInitialized : Boolean;
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure RenderIcon(pRepaint : boolean = True);
    procedure LoadIcons;
    property LastIcon : TBitmap32 read FLastIcon write FLastIcon;
    property Initialized : Boolean read FInitialized write FInitialized;
  end;


implementation

uses
  GR32_PNG,
  uSharpXMLUtils;

{$R *.dfm}

function GetPowerStatus(var HasBattery: Boolean; var LoadstatusPercent: Integer; var Charging : Boolean): DWORD;
var
  SystemPowerStatus: TSystemPowerStatus;
begin
  SetLastError(0);
  if GetSystemPowerStatus(SystemPowerStatus) then
    with SystemPowerStatus do
    begin
      HasBattery := ACLineStatus = 0;
      Charging := (BatteryFlag and 8 = 8);

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
      FShowNotifications := BoolValue('ShowNotifications', FShowNotifications);
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
  iconWidth,o2,topWidth,bottomWidth : integer;
begin
  self.Caption := 'Battery Monitor';

  iconWidth := 0;
  o2 := (Height - 2 - 4) div 2;
  topWidth := 0;
  bottomWidth := 0;

  if sShowIcon then
  begin
    FLastIcon := nil;
    RenderIcon;
    iconWidth := iconWidth + Height;
    topWidth := iconWidth;
    bottomWidth := iconWidth;
  end;

  if sShowInfo then
  begin
    lb_info.Visible := True;
    lb_info.Left := topWidth - 2;
    lb_info.LabelStyle := lsSmall;
    lb_info.UpdateSkin;
    lb_info.Top := 2 + (o2 div 2) - (lb_info.Height div 2);
    topWidth := topWidth + lb_info.Width - 2;
    lb_info.Visible := True;
  end else lb_Info.Visible := False;

  if sShowPC then
  begin
    lb_pc.Visible := True;
    lb_pc.LabelStyle := lsSmall;
    lb_pc.Left := topWidth;
    lb_pc.UpdateSkin;
    lb_pc.Top := 2 + (o2 div 2) - (lb_pc.Height div 2);
    topWidth := topWidth + lb_pc.Width;
    lb_pc.Visible := True;
  end else lb_pc.Visible := False;

  if sShowPBar then
  begin
    pbar.AutoSize := False;
    pbar.Height := o2;
    pbar.Width := max(topWidth - iconWidth, 50);
    pbar.Left := bottomWidth + 2;
    pbar.Top := Height - 2 - pbar.Height;
    bottomWidth := bottomWidth + pbar.Width + 2;
    pbar.Visible := True;
  end else pbar.Visible := False;

  NewWidth := max(topWidth, bottomWidth);
  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if (newWidth <> Width) and (Broadcast) then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
var
  dwResult: DWORD;
  HasBattery, Charging : Boolean;
  LoadStatusPercent: Integer;
  s : String;
  x, y : Integer;
  edge : TSharpNotifyEdge;
  p : TPoint;
begin
  dwResult := GetPowerStatus(HasBattery, LoadStatusPercent, Charging);
  if dwResult = 0 then
  begin
    if HasBattery then
      s := 'Battery'
    else
      s := 'AC Power';

    // Reset the last status to something higher then 100 when
    // the battery is charging so that we send notifications again
    // when the battery is no longer charging.
    if Charging then
      FLastStatus := 255;

    // Only send a notification when we are not charging and the
    // percentage dips below 10, 20 or 50.  Only send the notification
    // once at each level.
    if (not Charging) and (LoadStatusPercent >= 0) and (FInitialized) and (FShowNotifications) then
    begin
      // Get the cordinates on the screen where the notification window should appear.
      p := Self.ClientToScreen(Point(0, Self.Height));
      x := Left + (Width div 2);
      if p.Y > Monitor.Top + Monitor.Height div 2 then
      begin
        edge := neBottomCenter;
        y := p.Y - Self.Height;
      end
      else
      begin
        edge := neTopCenter;
        y := p.Y;
      end;

      if (LoadStatusPercent <= 10) and (FLastStatus > 10) then
        CreateNotifyWindow(0, nil, x, y, 'Battery is getting critically low, less than 10%.', niError, edge, mInterface.SkinInterface.SkinManager, 10000, Monitor.WorkareaRect)
      else if (LoadStatusPercent <= 20) and (FLastStatus > 20) then
        CreateNotifyWindow(0, nil, x, y, 'Battery is getting low, less than 20%.', niWarning, edge, mInterface.SkinInterface.SkinManager, 10000, Monitor.WorkareaRect)
      else if (LoadStatusPercent <= 50) and (FLastStatus > 50) then
        CreateNotifyWindow(0, nil, x, y, 'Battery is below 50% charged.', niInfo, edge, mInterface.SkinInterface.SkinManager, 5000, Monitor.WorkareaRect);
    end;

    FLastStatus := LoadStatusPercent;
    
    if lb_info.Visible then
      if CompareText(lb_info.Caption,s) <> 0 then
        lb_info.Caption := s;

    if lb_pc.Visible then
    begin
      if LoadStatusPercent >= 0 then
      begin
        if CompareText(lb_pc.Caption,s+'%') <> 0 then
          lb_pc.Caption := IntToStr(LoadStatusPercent)+'%';
      end
      else if CompareText(lb_pc.Caption,'') <> 0 then
        lb_pc.Caption := '';
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
  FLastStatus := -1;

  FShowNotifications := True;
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
