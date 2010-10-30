unit uExplorer;

interface

uses Windows, Classes, SysUtils,
  ShellAPI,
  SharpAPI,
  uSystemFuncs;

type
  TExplorerThread = class(TThread)
  private
    Started : boolean;
    Failed : boolean;

    procedure SetStarted(s: boolean; f: boolean = false);

  protected
     procedure Execute; override;

  public
    constructor Create(CreateSuspended: Boolean);
    function WaitStarted: boolean;

  end;

implementation

var
  CritSect: TRtlCriticalSection;

constructor TExplorerThread.Create(CreateSuspended: Boolean);
begin
  inherited;

  Started := False;
  Failed := False;
end;

procedure TExplorerThread.SetStarted(s: boolean; f: boolean = false);
begin
  EnterCriticalSection(CritSect);
  Started := s;
  if f then
    Failed := True;
  LeaveCriticalSection(CritSect);
end;

function TExplorerThread.WaitStarted: boolean;
var
  s : boolean;
begin
  while true do
  begin
    EnterCriticalSection(CritSect);
    s := Started;
    LeaveCriticalSection(CritSect);
    if s then
      break;

    Sleep(16);
  end;
  
  Result := not Failed;
end;

procedure TExplorerThread.Execute;
var
  Dir : string;
  s : boolean;
  iTimeout : integer;
  MsgResult : DWORD;
begin
  while True do
  begin
    EnterCriticalSection(CritSect);
    if (FindWindow('TSharpExplorerForm', nil) <> 0) then
      Started := True;

    s := Started;
    LeaveCriticalSection(CritSect);

    if not s then
    begin
      Dir := IncludeTrailingBackslash(SharpAPI.GetSharpeDirectory);
      if (NETFramework35) and (FileExists(Dir + 'Addons\Explorer.exe')) then
        ShellExecute(0, nil, PChar(Dir + 'Addons\Explorer.exe'), nil, nil, SW_SHOWNORMAL);

      iTimeout := 10000;
      while iTimeout > 0 do
      begin
        if FindWindow('TSharpExplorerForm', nil) <> 0 then
          break;

        Sleep(100);
        iTimeout := iTimeout - 100;
      end;

      if iTimeout <= 0 then
      begin
        SendDebugMessageEx(PChar('Shell'), PChar('Timed out waiting for Explorer to start'), 0, DMT_ERROR);
        SetStarted(True, True);
        exit;
      end;

      iTimeout := 10000;
      while iTimeout > 0 do
      begin
        if (FindWindow('TSharpExplorerForm', nil) = 0) then
          break;

        if SendMessageTimeout(FindWindow('TSharpExplorerForm', nil), WM_SHARPSHELLLOADED, 0, 0, SMTO_ABORTIFHUNG, 100, MsgResult) <> 0 then
        begin
          if MsgResult <> 0 then
            break;

          Sleep(100);
          iTimeout := iTimeout - 100;
        end else
        begin
          iTimeout := iTimeout - 100;
        end;
      end;

      if iTimeout <= 0 then
      begin
        SendDebugMessageEx(PChar('Shell'), PChar('Timed out waiting for Explorer to start'), 0, DMT_ERROR);
        SetStarted(True, True);
        exit;
      end;

      SetStarted(True);
    end;

    if Terminated then
    begin
      if FindWindow('TSharpExplorerForm', nil) <> 0 then
        PostMessage(FindWindow('TSharpExplorerForm', nil), WM_SHARPTERMINATE, 0, 0);

      iTimeout := 10000;
      while iTimeout > 0 do
      begin
        if FindWindow('TSharpExplorerForm', nil) = 0 then
          break;

        Sleep(100);
        iTimeout := iTimeout - 100;
      end;

      if iTimeout <= 0 then
      begin
        SendDebugMessageEx(PChar('Shell'), PChar('Timed out waiting for Explorer to exit'), 0, DMT_ERROR);
        SetStarted(True, True);
        exit;
      end;

      SetStarted(False);

      break;
    end;

    Sleep(1000);
  end;
end;

initialization
  InitializeCriticalSection(CritSect);

finalization
  DeleteCriticalSection(CritSect);

end.
