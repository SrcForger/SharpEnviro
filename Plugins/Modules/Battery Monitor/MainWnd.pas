{
Source Name: MainWnd
Description: Battery Monitor module main window
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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

unit MainWnd;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, SharpEBaseControls, SharpESkinManager,
  ExtCtrls, SharpEProgressBar, GR32,
  JvSimpleXML, SharpApi, Menus, Math, SharpESkinLabel;


type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    UpdateTimer: TTimer;
    lb_pc: TSharpESkinLabel;
    pbar: TSharpEProgressBar;
    lb_info: TSharpESkinLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sShowIcon : boolean;
    sShowPBar : boolean;
    sShowInfo : boolean;
    sShowPC   : boolean;
    FBStatus1 : TBitmap32;
    FBStatus2 : TBitmap32;
    FLastIcon : TBitmap32;
    Background : TBitmap32;
  public
    ModuleID : integer;
    BarID    : integer;
    BarWnd   : hWnd;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure RenderIcon(pRepaint : boolean = True);
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateBackground(new : integer = -1);
    property LastIcon : TBitmap32 read FLastIcon write FLastIcon;
  end;


implementation

uses SettingsWnd,
     GR32_PNG,
     uSharpBarAPI;

{$R *.dfm}
{$R glyphs.res}

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

procedure TMainForm.LoadSettings;
var
  XML : TJvSimpleXML;
  fileloaded : boolean;
begin
  sShowIcon := True;
  sShowPBar := True;
  sShowInfo := True;
  sShowPC   := True;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sShowIcon := BoolValue('showicon',True);
      sShowPBar := BoolValue('showpbar',True);
      sShowInfo := BoolValue('showinfo',True);
      sShowPC   := BoolValue('showpc',True);
    end;
  XML.Free;
  UpdateTimer.OnTimer(UpdateTimer);
end;

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  NewWidth := Max(NewWidth,1);

  UpdateBackground(NewWidth);

  Width := NewWidth;

  FLastIcon := nil;
  RenderIcon;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
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
  end else lb_pc.Visible := False;
  if sShowPBar then
  begin
    pbar.AutoSize := False;
    pbar.Height := o2;
    if sShowIcon then pbar.Width := o3 - 12
       else pbar.Width := o4-10;
    pbar.Left := o1;
    pbar.Top := Height - 2 - pbar.Height;
  end else pbar.Visible := False;

  NewWidth := max(o1,max(o3,o4));
  Tag := newWidth;
  Hint := inttostr(NewWidth);
  if newWidth <> width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  XML : TJvSimpleXML;
begin
  try
    SettingsForm := TSettingsForm.Create(Application.MainForm);
    SettingsForm.cb_showicon.Checked := sShowIcon;

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowIcon := SettingsForm.cb_showicon.Checked;
      XML := TJvSimpleXML.Create(nil);
      XML.Root.Name := 'BatteryMonitorModuleSettings';
      with XML.Root.Items do
      begin
        Add('showicon',sShowIcon);
      end;
      XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
      XML.Free;
      UpdateTimer.OnTimer(UpdateTimer);
    end;
    ReAlignComponents(True);
    Repaint;
  finally
    FreeAndNil(SettingsForm);
  end;
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
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
  Background := TBitmap32.Create;
  DoubleBuffered := True;

  FLastIcon := nil;
  FBStatus1 := TBitmap32.Create;
  FBStatus1.DrawMode := dmBlend;
  FBStatus1.CombineMode := cmMerge;
  FBStatus2 := TBitmap32.Create;
  FBStatus2.DrawMode := dmBlend;
  FBStatus2.CombineMode := cmMerge;

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(22,22);
  TempBmp.Clear(color32(0,0,0,0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, 'battery', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FBStatus1.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'batterylow', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FBStatus2.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBStatus1);
  FreeAndNil(FBStatus2);
  FreeAndNil(Background);
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  Bmp.Assign(Background);
  if (FLastIcon <> nil) and sShowIcon then
//     FLastIcon.DrawTo(Canvas.Handle,Rect(2,2,Height-2,Height-2),FLastIcon.BoundsRect);
     FLastIcon.DrawTo(Bmp,Rect(2,2,Height-2,Height-2));
  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

end.
