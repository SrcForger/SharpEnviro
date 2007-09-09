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
  Types,
  GR32,
  MainWnd in 'MainWnd.pas' {MainForm},
  SettingsWnd in 'SettingsWnd.pas' {SettingsForm},
  BalloonWindow in 'BalloonWindow.pas',
  TrayIconsManager in 'TrayIconsManager.pas',
  winver in 'winver.pas',
  DateUtils,
  SharpCenterApi,
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  MouseTimer in '..\..\..\Common\Units\MouseTimer\MouseTimer.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  declaration in '..\..\Services\SystemTray\declaration.pas',
  ToolTipApi in '..\..\..\Common\Units\ToolTipApi\ToolTipApi.pas';

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
              constructor Create(pID,pBarID : integer; pParent : hwnd); reintroduce;
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
           tempForm.lb_servicenotrunning.Visible := False
           else tempForm.lb_servicenotrunning.Visible := True;
        tempForm.ReAlignComponents(true);
        if ServiceRunning then tempForm.RepaintIcons;
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

constructor TModule.Create(pID,pBarID : integer; pParent : hwnd);
begin
  FID   := pID;
  FBarWnd := pParent;
  FForm := TMainForm.CreateParented(pParent);
  TMainForm(FForm).FTrayClient := TrayClient;
  TrayClient.ScreenPos := TMainForm(FForm).ClientToScreen(
                               Point(TMainForm(FForm).Left,
                               TMainForm(FForm).Top));
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
    BarID    := pBarID;

    LoadSettings;
    ReAlignComponents(False);
    TrayClient.ScreenPos := TMainForm(FForm).ClientToScreen(
                                 Point(TMainForm(FForm).Left,
                                 TMainForm(FForm).Top));
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
                      BarID : integer;
                      parent : hwnd) : hwnd;
var
  temp : TModule;
  i : integer;
  wfs : boolean;
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
    wfs := True;
  end else wfs := False;

  try
    if ModuleList = nil then
       ModuleList := TObjectList.Create;

    if MouseTimer = nil then
       MouseTimer := TMouseTimer.Create;

    temp := TModule.Create(ID,BarID,parent);
    TrayClient.AddWindow(temp.Form);
    ModuleList.Add(temp);

    if wfs then
    begin
      i := GetBarPluginHeight(temp.BarWnd);
      if i < 20 then
         TrayClient.IconSize := i - 4
      else TrayClient.IconSize := 16;
      {if TrayClient.IconSize < 16 then
      begin
        TrayClient.IconSize := TrayClient.IconSize;
        TrayClient.topspacing := 2;
      end else TrayClient.TopSpacing := 2;}
    end;
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
  if ModuleList = nil then
  begin
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
          TrayClient.RemoveWindow(TModule(ModuleList.Items[n]).Form);
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
        TMainForm(temp.Form).UpdateBackground;

        TrayClient.ScreenPos :=
             TMainForm(temp.FForm).ClientToScreen(
                                    Point(TMainForm(temp.FForm).Left,
                                    TMainForm(temp.FForm).Top));
        TMainForm(temp.Form).RepaintIcons;
        
        lastrepaint := -1;
        FUpdateTimer.OnTimer(FUpdateTimer);

        if n = 0 then
          TrayClient.PositionTrayWindow(0,0,temp.Form);
      end;
end;

procedure UpdateMessage(part : TSU_UPDATE_ENUM; param : integer);
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme];
var
  temp : TModule;
  n,i : integer;
begin
  if not (part in processed) then 
    exit;

  if ModuleList = nil then exit;

  for n := 0  to ModuleList.Count - 1 do
  begin
    temp := TModule(ModuleList.Items[n]);

    // Step1: check if height changed
    if [part] <= [suSkinFileChanged,suBackground,suTheme] then
    begin
      i := GetBarPluginHeight(temp.BarWnd);
      if temp.Form.Height <> i then
      begin
        temp.Form.Height := i;
        if TrayClient <> nil then
        begin
          if temp.Form.Height < 20 then
             TrayClient.IconSize := temp.Form.Height - 4
          else TrayClient.IconSize := 16;
          TrayClient.RenderIcons;
        end;
      end;
    end;

     // Step2: check if skin or scheme changed
    if [part] <= [suScheme,suTheme] then
        TMainForm(temp.Form).SkinManager.UpdateScheme;
    if (part = suSkinFileChanged) then
       TMainForm(temp.Form).SkinManager.UpdateSkin;
    if [part] <= [suScheme,suTheme,suSkinFileChanged] then
       TMainForm(temp.Form).LoadSettings;

    // Step3: update
    if [part] <= [suScheme,suBackground,suSkinFileChanged,suTheme] then
    begin
      TMainForm(temp.Form).UpdateBackground;
      TMainForm(temp.Form).RepaintIcons((param <> -2));
      if [part] <= [suTheme,suSkinFileChanged] then
         TMainForm(temp.Form).ReAlignComponents((part = suSkinFileChanged));

      if n = 0 then
         TrayClient.PositionTrayWindow(0,0,temp.Form);
    end;
  end;
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
                FreeAndNil(FUpdateTimer);
              end;
              if TrayClient <> nil then
                 FreeAndNil(TrayClient);
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

procedure SetSize(ID : integer; NewWidth : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).SetSize(NewWidth);
      end;
end;

Exports
  CreateModule,
  CloseModule,
  Poschanged,
  Refresh,
  UpdateMessage,
  ShowSettingsWnd,
  SetSize;

begin
//  SaveDllProc := @dllProc;  // Speichern der Kette von Exit-Prozeduren
  DllProc := @LibExit;  // Installieren der LibExit-Exit-Prozedur
  LibExit(DLL_PROCESS_ATTACH);

end.
