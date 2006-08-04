{
Source Name: SystemTray.dpr
Description: SharpBar Module Main Project File
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

library SystemTray;




uses
  Windows,
  Controls,
  Dialogs,
  SysUtils,
  ExtCtrls,
  Forms,
  Classes,
  Contnrs,
  SharpESkinManager,
  SharpEBar,
  StdCtrls,
  JvSimpleXML,
  Types,
  GR32,
  MainWnd in 'MainWnd.pas' {MainForm},
  SettingsWnd in 'SettingsWnd.pas' {SettingsForm},
  BalloonWindow in 'BalloonWindow.pas',
  declaration in 'declaration.pas',
  TipWnd in 'TipWnd.pas',
  TrayIconsManager in 'TrayIconsManager.pas',
  winver in 'winver.pas',
  DateUtils,
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  MouseTimer in '..\..\..\Common\Units\MouseTimer\MouseTimer.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas';

type
  TTimerObject = object
              procedure OnUpdateTimer(Sender : TObject);
            end;
  TModule = class
            private
              FForm    : TForm;
              FID      : integer;
              FPos     : integer;
              FBarWnd  : hWnd;
            public
              constructor Create(pID : integer; pParent : hwnd); reintroduce;
              destructor Destroy; override;
            published
              property ID   : integer read FID;
              property Pos  : integer read FPos write FPos;
              property Form : TForm   read FForm;
              property BarWnd : hWnd  read FBarWnd;
            end;


var
  ModuleList : TObjectList;
  MouseTimer : TMouseTimer;
  FirstStart : boolean = True;
  FUpdateTimer : TTimer;
  TimerObject : TTimerObject;
//  SaveDllProc: Pointer;
  TrayClient : TTrayClient;
  lastrepaint : integer;
  ServiceCheck : integer;
  ServiceRunning : boolean;

{$R *.res}

procedure TTimerObject.OnUpdateTimer(SEnder : TObject);
var
  n : integer;
  tempModule : TModule;
  tempForm : TMainForm;
  hr : hresult;
begin
  if ModuleList = nil then exit;
  if TrayClient = nil then exit;

  ServiceCheck := ServiceCheck + 1;
  if ServiceCheck >= 20 then
  begin
    hr := SharpApi.IsServiceStarted('SystemTray');
    if hr <> MR_STARTED then
    begin
      TrayClient.ClearTrayIcons;
      ServiceRunning := False;
      lastrepaint := -1;
    end else ServiceRunning := True;
    ServiceCheck := 0;
  end;

  if (DateTimeToUnix(now) - TrayClient.LastMessage) >= 5 then
  begin
    TrayClient.RegisterWithTray;
    ServiceCheck := 15;
  end;

  if TrayClient.RepaintHash = lastrepaint then exit;

  for n := 0 to ModuleList.Count - 1 do
  begin
    tempModule := TModule(ModuleList.Items[n]);
    if tempModule.Form <> nil then
    begin
      tempForm := TMainForm(tempModule.Form);
      if TrayClient.RepaintHash <> lastrepaint then
      begin
        if ServiceRunning then
        begin
          tempForm.lb_servicenotrunning.Visible := False;
          tempForm.RepaintIcons;
        end else tempForm.lb_servicenotrunning.Visible := True;
        tempForm.ReAlignComponents(true);
      end;
    end;
  end;
  lastrepaint := TrayClient.RepaintHash;
end;

function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

constructor TModule.Create(pID : integer; pParent : hwnd);
begin
  FID   := pID;
  FBarWnd := pParent;
  FForm := TMainForm.CreateParented(pParent);
  TMainForm(FForm).FTrayClient := TrayClient;
  TrayClient.ScreenPos := TMainForm(FForm).ClientToScreen(
                               Point(TMainForm(FForm).Background.Left,
                               TMainForm(FForm).Background.Top));
  FForm.BorderStyle := bsNone;
  try
    FForm.Height :=  GetBarPluginHeight(FBarWnd);
  except
  end;
 // FForm.ParentWindow := pParent;
 // MouseTimer.AddWinControl(TMainForm(FForm));
  with FForm as TMainForm do
  begin
    ModuleID := pID;
    BarWnd   := FBarWnd;

    LoadSettings;
    ReAlignComponents(true);
    TrayClient.ScreenPos := TMainForm(FForm).ClientToScreen(
                                 Point(TMainForm(FForm).Background.Left,
                                 TMainForm(FForm).Background.Top));
    Show;
  end;
end;

destructor TModule.Destroy;
begin
  FForm.Free;
  FForm := nil;
  inherited Destroy;
end;

function CreateModule(ID : integer;
                      parent : hwnd) : hwnd;
var
  temp : TModule;
begin
  if firststart then
  begin
    TrayClient := TTrayClient.Create;
    TrayClient.BackGroundColor := color32(0,0,0,0);
    FUpdateTimer := TTimer.Create(nil);
    FUpdateTimer.OnTimer := TimerObject.OnUpdateTimer;
    FUpdateTimer.Interval := 100;
    FUpdateTimer.Enabled := True;
    ServiceCheck := 15;
    servicerunning := true;
    firststart := false;
  end;

  try
    if ModuleList = nil then
       ModuleList := TObjectList.Create;

    if MouseTimer = nil then
       MouseTimer := TMouseTimer.Create;

    temp := TModule.Create(ID,parent);
    ModuleList.Add(temp);
  except
    result := 0;
    exit;
  end;
  result := temp.Form.Handle;
end;

function CloseModule(ID : integer) : boolean;
var
  n : integer;
begin
  if ModuleList = nil then begin
    result := false;
    exit;
  end;
  try
    for n := 0 to ModuleList.Count - 1 do
        if TModule(ModuleList.Items[n]).ID = ID then
        begin
          MouseTimer.RemoveWinControl(TModule(ModuleList.Items[n]).Form);
          if MouseTimer.ControlList.Count = 0 then
             FreeAndNil(MouseTimer);
          ModuleList.Delete(n);
          result := True;
          exit;
        end;
  finally
    result := False;
  end;
end;

procedure Refresh(ID : integer);
begin
end;

procedure PosChanged(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).Background.Bitmap.SetSize(temp.Form.Width,
                                                       temp.Form.Height);
         uSharpBarAPI.PaintBarBackGround(temp.BarWnd,
                                         TMainForm(temp.Form).Background.Bitmap,
                                         Temp.Form);

        TrayClient.ScreenPos :=
             TMainForm(temp.FForm).ClientToScreen(
                                    Point(TMainForm(temp.FForm).Background.Left,
                                    TMainForm(temp.FForm).Background.Top));
        lastrepaint := -1;
        FUpdateTimer.OnTimer(FUpdateTimer);
      end;
end;

procedure SkinChanged(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        temp.Form.Height := GetBarPluginHeight(temp.BarWnd);
        if TrayClient <> nil then
        begin
          if temp.Form.Height < 20 then
             TrayClient.IconSize := temp.Form.Height - 4
          else
             TrayClient.IconSize := 16;
          if TrayClient.IconSize < 16 then begin
            TrayClient.IconSize := TrayClient.IconSize + 3;
            TrayClient.topspacing := 2;
          end else
          begin
            TrayClient.TopSpacing := 2;
          end;
          TrayClient.RenderIcons;
        end;
        TMainForm(temp.Form).ReAlignComponents(false);
     //   if FUpdateTimer <> nil then TimerObject.OnUpdateTimer(nil);
      end;
end;

function PluginMessage(ID : integer; msg: string): integer;
begin
  Result := 0;
end;

procedure LibExit(Reason: Integer);
begin
    case reason of
        DLL_PROCESS_ATTACH:
            begin

            end;

        DLL_PROCESS_DETACH:
            begin
              if FUpdateTimer <> nil then
              begin
                FUpdateTimer.Enabled := False;
                FUpdateTimer.Free;
              end;
              if TrayClient <> nil then
                 TrayClient.Free;
            end;
    end;
end;

procedure ShowSettingsWnd(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).Settings1Click(TMainForm(temp.FForm).Settings1);
      end;
end;

Exports
  CreateModule,
  CloseModule,
  Poschanged,
  Refresh,
  SkinChanged,
  ShowSettingsWnd;

begin
//  SaveDllProc := @dllProc;  // Speichern der Kette von Exit-Prozeduren
  DllProc := @LibExit;  // Installieren der LibExit-Exit-Prozedur
  LibExit(DLL_PROCESS_ATTACH);

end.
