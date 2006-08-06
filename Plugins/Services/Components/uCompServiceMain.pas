{
Source Name: uCompServiceMain
Description: Component services class
Copyright (C)
              Zack Cerza - zcerza@coe.neu.edu (original dev)
              Pixol (Pixol@sharpe-shell.org)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

unit uCompServiceMain;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  sharpapi,
  ExtCtrls,
  Buttons,
  ComCtrls,

  // Project
  uCompServiceAppStore;

type
  TComponentServ = class
  private
    FTimer: TTimer;
    procedure TimerEvent(Sender: TObject);

  public
    constructor Create;
    destructor Destroy; override;
    procedure ProcessList;
    procedure UpdateList(LV: TListView); overload;
    procedure UpdateList; overload;
    procedure LoadComponent(Index: Integer; filename: string);

    procedure MessageHandler(var Message: TMessage);
    procedure DisplayInfoWnd;
  end;

procedure Debug(Text: string; DebugType: Integer);

var
  CompServ: TComponentServ;
  h: THandle;

implementation

uses
  uCompServiceAppStatus;

{ TComponentStart }

procedure Debug(Text: string; DebugType: Integer);
begin
  SendDebugMessageEx('Components Service', Pchar(Text), 0, DebugType);
end;

constructor TComponentServ.Create;
begin
  ItemStorage := TCompStore.Create;
  FTimer := TTimer.Create(Application.MainForm);
  FTimer.Interval := 1000;
  FTimer.OnTimer := TimerEvent;
  FTimer.Enabled := False;
end;

procedure TComponentServ.ProcessList;
var
  I: Integer;
begin
  for i := 0 to ItemStorage.Count - 1 do
  begin
    if ItemStorage.Info[i].AutoStart = True then
    begin
      LoadComponent(i, ItemStorage.Info[i].Command);
    end;
  end;

  ItemStorage.Save;

end;

procedure TComponentServ.LoadComponent(Index: Integer; filename: string);
var
  proc_info: TPROCESSInformation;
  startinfo: TStartupInfo;
  tmp: string;
begin
  // Initialize the structures

  // Current Folder check
  tmp := GetSharpeDirectory + filename;
  if FileExists(tmp) then
    filename := tmp;

  FillChar(proc_info, sizeof(TPROCESSInformation), 0);
  FillChar(startinfo, sizeof(TStartupInfo), 0);
  startinfo.cb := sizeof(TStartupInfo);
  ItemStorage.Info[Index].ProcessHandle := -1;

  if CreatePROCESS(nil, pchar(filename), nil,
    nil, false, CREATE_DEFAULT_ERROR_MODE
    + NORMAL_PRIORITY_CLASS, nil, pchar(ExtractFilePath(filename)), startinfo,
    proc_info) then
  begin
    // Set process handle
    ItemStorage.Info[Index].ProcessHandle := proc_info.hProcess;
    ItemStorage.Save;
  end
  else
  begin
    CloseHandle(proc_info.hPROCESS);
    Debug(Format('Unable to create process for: %s', [filename]), DMT_ERROR);
  end;

  FTimer.Enabled := True;
end;

procedure TComponentServ.UpdateList(LV: TListView);
var
  I: Integer;
  LI: tlistItem;
  ExitCode: Cardinal;
  MH: THandle;
  tmp: string;
begin
  LV.Items.Clear;

  for i := 0 to ItemStorage.Count - 1 do
  begin
    Application.ProcessMessages;
    LI := LV.Items.Add;
    LI.Caption := ItemStorage.Info[i].Name;
    LI.SubItems.Add(ItemStorage.Info[i].Description);
    LI.ImageIndex := 9;

    // Sharpe checks first
    tmp := lowercase(ExtractFileName(ItemStorage.Info[i].Command));

    if tmp = 'sharpbar.exe' then
    begin
      MH := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpBarMutex');
      if MH <> 0 then
        LI.ImageIndex := 5
      else
      begin
        if ItemStorage.Info[i].AutoStart then
          LI.ImageIndex := 8
        else
          Li.ImageIndex := 9;
      end;
      CloseHandle(MH);
    end
    else
      if tmp = 'sharpdesk.exe' then
      begin
        MH := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpDeskMutex');
        if MH <> 0 then
          LI.ImageIndex := 5
        else
        begin
          if ItemStorage.Info[i].AutoStart then
            LI.ImageIndex := 8
          else
            Li.ImageIndex := 9;
        end;
        CloseHandle(MH);
      end
      else
        if tmp = 'sharptray.exe' then
        begin
          MH := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpTrayMutex');
          if MH <> 0 then
            LI.ImageIndex := 5
          else
          begin
            if ItemStorage.Info[i].AutoStart then
              LI.ImageIndex := 8
            else
              Li.ImageIndex := 9;
          end;
          CloseHandle(MH);
        end
        else
          if tmp = 'sharptask.exe' then
          begin
            MH := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpTaskMutex');
            if MH <> 0 then
              LI.ImageIndex := 5
            else
            begin
              if ItemStorage.Info[i].AutoStart then
                LI.ImageIndex := 8
              else
                Li.ImageIndex := 9;
            end;
            CloseHandle(MH);
          end
          else
            if tmp = 'sharpvwm.exe' then
            begin
              MH := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpVWMMutex');
              if MH <> 0 then
                LI.ImageIndex := 5
              else
              begin
                if ItemStorage.Info[i].AutoStart then
                  LI.ImageIndex := 8
                else
                  Li.ImageIndex := 9;
              end;
              CloseHandle(MH);
            end
            else
            begin

              if ItemStorage.Info[i].ProcessHandle <> -1 then
              begin
                if GetExitCodePROCESS(ItemStorage.Info[i].ProcessHandle,
                  ExitCode) then
                  if ExitCode = STILL_ACTIVE then
                    LI.ImageIndex := 5;
              end;
            end;

  end;
end;

procedure TComponentServ.UpdateList;
begin
  //UpdateList(SettingsWnd.lvItems);
end;

procedure TComponentServ.TimerEvent(Sender: TObject);
var
  i: integer;
  ExitCode: Cardinal;
  pHandle: Integer;
begin
  for i := 0 to ItemStorage.Count - 1 do
  begin
    pHandle := ItemStorage.Info[i].ProcessHandle;

    if PHandle <> -1 then
    begin
      if GetExitCodePROCESS(pHandle, ExitCode) then
        if ExitCode = STILL_ACTIVE then
        else
        begin

          Debug(Format('%s: Exit Code (%d)', [ItemStorage.Info[i].Name,
            ExitCode]), DMT_TRACE);

          if ExitCode = 128 {1} then
          begin // crashed exit code maybe?
            ItemStorage.Info[i].ProcessHandle := -1;
            CloseHandle(pHandle);

            if ItemStorage.Info[i].RestartCrash then
              LoadComponent(i, ItemStorage.Info[i].Command);
          end
          else
            CloseHandle(pHandle);

          //if Assigned(SettingsWnd) then
          //  CompServ.UpdateList(SettingsWnd.lvItems);
        end;
    end;
  end;
end;

destructor TComponentServ.Destroy;
begin

  inherited;
  FTimer.Free;
  ItemStorage.Free;
end;

procedure TComponentServ.MessageHandler(var Message: TMessage);
begin
  if message.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    // Load the currently assigned skin
    case Message.LParam of
      0: DisplayInfoWnd;
    end;
  end;

  if message.Msg = WM_SHARPEUPDATESETTINGS then begin
    ItemStorage.Clear;
    ItemStorage.Load;
    Debug('WM_SHARPEUPDATESETTINGS',DMT_INFO);
  end;

  // Continue shutdown
  if message.Msg = WM_QueryEndSession then
  begin
    Message.Result := 1;
  end;

  inherited;
end;

procedure TComponentServ.DisplayInfoWnd;
begin
  with frmComponentStat do
  begin
    //Left := WndLeft;
    //Top := WndTop;
    visible := not (Visible);
    CompServ.UpdateList(frmComponentStat.lvStatusItems);

  end;
end;

end.
