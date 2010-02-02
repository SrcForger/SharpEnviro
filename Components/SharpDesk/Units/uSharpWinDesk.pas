unit uSharpWinDesk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ActiveX,
  ComObj, ShlObj, SharpApi;

type
  IShellDesktopTray = interface(IUnknown)
      ['{213E2DF9-9A14-4328-99B1-6961F9143CE9}']
      function GetState: Integer; stdcall;
      function GetTrayWindow(var o : HWND): Integer; stdcall;
      function RegisterDesktopWindow(d : HWND): Integer; stdcall;
      function Unknown(p1, p2 : DWORD): Integer; stdcall;
  end;

  TShellDesktopTray = class(TInterfacedObject, IShellDesktopTray)
    protected
      function GetState: Integer; stdcall;
      function GetTrayWindow(var o : HWND): Integer; stdcall;
      function RegisterDesktopWindow(d : HWND): Integer; stdcall;
      function Unknown(p1, p2 : DWORD): Integer; stdcall;
  end;

  TSHDesktopMessageLoop = function(hDesktop : THandle): boolean; stdcall;
  TSHCreateDesktop = function(a : Pointer) : THandle; stdcall;

  TMsgThread = class(TThread)
  private
    ShellTray : IShellDesktopTray;

    ShellDLL : THandle;
    SHCreateDesktop : TSHCreateDesktop;
    SHDesktopMessageLoop : TSHDesktopMessageLoop;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended : Boolean);
    destructor Destroy; override;
  end;

  TSharpWinDesk = class(TObject)
  private
    FMsgThread : TThread;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

implementation

{ TShellDesktopTray }

function TShellDesktopTray.GetState: Integer;
begin
  Result := 2;
end;

function TShellDesktopTray.GetTrayWindow(var o : HWND): Integer;
begin
  o := FindWindow('Shell_TrayWnd', 'Shell_TrayWnd');
  Result := 0;
end;

function TShellDesktopTray.RegisterDesktopWindow(d : HWND): Integer;
begin
  Result := 0;
end;

function TShellDesktopTray.Unknown(p1, p2 : DWORD): Integer;
begin
  Result := 0;
end;


{ TMsgThread }
constructor TMsgThread.Create(CreateSuspended : Boolean);
begin
  inherited;
  ShellTray := TShellDesktopTray.Create;

  ShellDLL := LoadLibrary('shell32.dll');
  @SHCreateDesktop := GetProcAddress(ShellDLL, PAnsiChar(MAKELPARAM(200, 0)));
  @SHDesktopMessageLoop := GetProcAddress(ShellDLL, PAnsiChar(MAKELPARAM(201,0)));
end;

destructor TMsgThread.Destroy;
begin
  FreeLibrary(ShellDLL);
  ShellTray := nil;
end;

procedure TMsgThread.Execute;
var
  hDesktop : THandle;
begin
  hDesktop := SHCreateDesktop(Pointer(ShellTray));
  SHDesktopMessageLoop(hDesktop);
end;

{ TWinDesk }

constructor TSharpWinDesk.Create;
begin
  Inherited Create;

  FMsgThread := TMsgThread.Create(True);
end;

destructor TSharpWinDesk.Destroy;
begin
  FMsgThread.Free;
end;

procedure TSharpWinDesk.Start;
begin
  FMsgThread.Resume;
end;

procedure TSharpWinDesk.Stop;
var
  h : HWND;
begin
  h := FindWindow('Progman', nil);

  SendMessage(h, WM_DESTROY, 0, 0);
  SendMessage(h, WM_NCDESTROY, 0, 0);
  FMsgThread.WaitFor;
end;

end.

