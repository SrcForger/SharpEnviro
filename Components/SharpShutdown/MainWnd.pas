unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngSpeedButton, StdCtrls, ExtCtrls, GR32_Image, SharpApi;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Image321: TImage32;
    Shape1: TShape;
    Label2: TLabel;
    Shape2: TShape;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;


  TShutdownWindowsType = (swtShutdown, swtShutdownPowerOff, swtRestart, swtLogoff);

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


//Source:
// http://www.delphi-library.de/viewtopic.php?sid=41536f47e535c0065f4e85e6ecb7f4d5&t=8272
function ShutdownWindows (aType: TShutdownWindowsType): Boolean;
const
  cSE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
  cFlagValue: Array [TShutdownWindowsType] Of UINT = (
      EWX_SHUTDOWN, EWX_SHUTDOWN or EWX_POWEROFF, EWX_REBOOT, EWX_LOGOFF );
var
  OSVersionInfo: TOSVersionInfo;
  hToken: THandle;
  hProcess: THandle;
  TokenPriv: TTokenPrivileges;
  ReturnLength: DWORD;
begin
  Result := False;

  // Get the windows version
  OSVersionInfo.dwOSVersionInfoSize := SizeOf (OSVersionInfo);
  if not GetVersionEx (OSVersionInfo) then
    Exit;

  // Test if OS is WinNT based
  if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
  begin
    hProcess := GetCurrentProcess;
    if not OpenProcessToken (hProcess, TOKEN_ADJUST_PRIVILEGES, hToken) then
       Exit;

    if not LookupPrivilegeValue (nil, cSE_SHUTDOWN_NAME, TokenPriv.Privileges[0].Luid) then
       Exit;

    TokenPriv.PrivilegeCount := 1;
    TokenPriv.Privileges [0].Attributes := SE_PRIVILEGE_ENABLED;

    if not AdjustTokenPrivileges (hToken, False, TokenPriv, 0,
                                  PTokenPrivileges (nil)^, ReturnLength) then
       Exit;

    CloseHandle (hToken);
  end;
  ShutdownWindows := ExitWindowsEx (cFlagValue [aType], $FFFFFFFF);
end;

procedure TMainForm.Label2Click(Sender: TObject);
begin
  Application.Terminate; 
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  SharpApi.SharpEBroadCast(WM_SHARPTERMINATE,0,0);
  Sleep(2000);
  ShutdownWindows(swtRestart);
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  SharpApi.SharpEBroadCast(WM_SHARPTERMINATE,0,0);
  Sleep(2000);
  ShutdownWindows(swtShutdownPowerOff);
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  SharpApi.SharpEBroadCast(WM_SHARPTERMINATE,0,0);
  Sleep(2000);
  ShutdownWindows(swtLogoff);
end;

end.
