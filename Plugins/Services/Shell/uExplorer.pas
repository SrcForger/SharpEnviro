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

  protected
     procedure Execute; override;

  public
    constructor Create(CreateSuspended: Boolean);
    procedure WaitStarted;

  end;

implementation

var
  CritSect: TRtlCriticalSection;

constructor TExplorerThread.Create(CreateSuspended: Boolean);
begin
  inherited;

  Started := False;
end;

procedure TExplorerThread.WaitStarted;
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
end;
                                        
procedure TExplorerThread.Execute;
var
  Dir : string;
  s : boolean;
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

      while FindWindow('TSharpExplorerForm', nil) = 0 do
        Sleep(16);

      while (FindWindow('TSharpExplorerForm', nil) <> 0) and (SendMessage(FindWindow('TSharpExplorerForm', nil), WM_SHARPSHELLLOADED, 0, 0) = 0) do
        Sleep(16);

      EnterCriticalSection(CritSect);
      Started := True;
      LeaveCriticalSection(CritSect);
    end;

    if Terminated then
    begin
      if FindWindow('TSharpExplorerForm', nil) <> 0 then
        SendMessage(FindWindow('TSharpExplorerForm', nil), WM_SHARPTERMINATE, 0, 0);

      if FindWindow('TSharpExplorerForm', nil) <> 0 then
      begin
        while (FindWindow('TSharpExplorerForm', nil) <> 0) do
          Sleep(16);
      end;

      EnterCriticalSection(CritSect);
      Started := False;
      LeaveCriticalSection(CritSect);

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
