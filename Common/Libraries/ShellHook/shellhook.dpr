{
I dont know where I got the original source, but I have modified this 
somewhat
}

library shellhook;

uses
  SysUtils,
  Messages,
  Windows;

type
    TCallBackProcedure = procedure(handle: hwnd);

    procedure SHSetHook; export; forward;
    procedure SHUnSetHook; export; forward;
    procedure SHSetMainHandle(Handle: HWND); export; forward;
    procedure SHSetCallBack(callproc: TProcedure); export; forward;
    procedure SHResetMsgFlag; export; forward;


exports
    SHSetHook index 1,
    SHUnSetHook index 2,
    SHSetMainHandle index 3,
    SHResetMsgFlag index 4,
    SHSetCallBack index 5;

type
// define a record that will store the handle of our EXE's main window AND
// the hook ID in mapped memory so that it is available in all instances of the DLL
    PHookRec = ^THookRec;
    THookRec = record
//        MainWindow: array [0..9] of HWND;
        MainWindow1: HWND;
        MainWindow2: HWND;
        MainWindow3: HWND;
        MainWindow4: HWND;
        MainWindow5: HWND;
        HookID: HHOOK;
        msgWindow: HWND;
        callback: TProcedure; // not used currently
    end;

const
    AppCount = 10;

    rHookRec: PHookRec = nil;
    msgFlag: boolean = false;
    acallback: TProcedure = NIL;

    WM_SHELLHOOK     = WM_APP + 750; // used for shellhook.dll

    M_NEWTASK            = 0;
    M_DELTASK            = 1;
    M_ACTIVATETASK       = 3;
    M_CAPTIONUPDATE      = 4;
    M_TASKFLASHING       = 5;
    M_GETMINRECT         = 6;



// Our EXE calls this to tell the DLL the handle of our main window. In turn, the DLL
// will send messages to this handle in response to specific messages trapped by our
// hook DLL
procedure SHSetMainHandle(Handle: HWND);
begin
  if not IsWindow(rHookRec^.MainWindow1) then rHookRec^.MainWindow1 := 0;
  if not IsWindow(rHookRec^.MainWindow2) then rHookRec^.MainWindow2 := 0;
  if not IsWindow(rHookRec^.MainWindow3) then rHookRec^.MainWindow3 := 0;
  if not IsWindow(rHookRec^.MainWindow4) then rHookRec^.MainWindow4 := 0;
  if not IsWindow(rHookRec^.MainWindow5) then rHookRec^.MainWindow5 := 0;

 { i := -1;
  for n := 0 to AppCount-1 do
     if not IsWindow(rHookRec^.MainWindow[n]) then
        rHookRec^.MainWindow[n] := 0;
  for n := 0 to AppCount -1 do
  begin
    if rHookRec^.MainWindow[n] = 0 then i := n;
    break;
  end;   }

 // if i = -1 then exit;
  if rHookRec^.MainWindow1 = 0 then rHookRec^.MainWindow1 := Handle
     else if rHookRec^.MainWindow2 = 0 then rHookRec^.MainWindow2 := Handle
     else if rHookRec^.MainWindow3 = 0 then rHookRec^.MainWindow3 := Handle
     else if rHookRec^.MainWindow4 = 0 then rHookRec^.MainWindow4 := Handle
     else if rHookRec^.MainWindow5 = 0 then rHookRec^.MainWindow5 := Handle;
//  rHookRec^.MainWindow[i] := Handle;
//  rHookRec^.MainWindow := Handle;
end;

procedure SHSetCallBack(callproc: TProcedure);
begin
  acallback := callproc;
end;

function GetClosingHandle : HWND;
begin
  result := rHookRec^.msgWindow;
end;

procedure SHResetMsgFlag;
begin
  if msgFlag then msgFlag := false;
end;

// hook proc
function ShellHookProc(nCode: Integer; WPARAM: wParam; LPARAM: lParam): LResult; stdcall;
var
  n : integer;
  MWnd : hwnd;
begin
//  showmessage('HOOK!');
  if nCode >= 0 then
  begin
    for n := 1 to 5 do
//    for n := 0 to High(rHookRec^.MainWindow) do
    begin
      case n of
        1: MWnd := rHookRec^.MainWindow1;
        2: MWnd := rHookRec^.MainWindow2;
        3: MWnd := rHookRec^.MainWindow3;
        4: MWnd := rHookRec^.MainWindow4;
        5: MWnd := rHookRec^.MainWindow5;
      end;

      if IsWindow(MWnd) then
//      if rHookRec^.MainWindow <> 0 then
      begin
        // send a message to our main window for the message just intercepted
        case nCode of
          HSHELL_GETMINRECT     : PostMessage(MWnd, WM_SHELLHOOK, M_GETMINRECT, WPARAM);
          HSHELL_WINDOWACTIVATED: PostMessage(MWnd, WM_SHELLHOOK, M_ACTIVATETASK, WPARAM);
          HSHELL_WINDOWCREATED:   PostMessage(MWnd, WM_SHELLHOOK, M_NEWTASK, WPARAM);
          HSHELL_WINDOWDESTROYED: PostMessage(MWnd, WM_SHELLHOOK, M_DELTASK, WPARAM);
          HSHELL_REDRAW:
            begin
              if boolean(lparam) then
                 PostMessage(MWnd, WM_SHELLHOOK, M_TASKFLASHING, WPARAM)
              else
                 PostMessage(MWnd, WM_SHELLHOOK, M_CAPTIONUPDATE, WPARAM);
            end;
        end;                 
      end;
    end;
  end;
    result := CallNextHookEx(rHookRec^.HookID, nCode, wParam, lParam);
end;

// our EXE calls this method to setup the hook
procedure SHSetHook;
var
  mm: MINIMIZEDMETRICS;
begin
  FillChar(mm, SizeOf(MINIMIZEDMETRICS), 0);

  mm.cbSize := SizeOf(MINIMIZEDMETRICS);
  SystemParametersInfo(SPI_GETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

  mm.iArrange := mm.iArrange or ARW_HIDE;
  SystemParametersInfo(SPI_SETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

  rHookRec^.HookID := SetWindowsHookEx(WH_SHELL, @ShellHookProc, hInstance, 0);
end;

// our EXE calls this method to unset the hook
procedure SHUnSetHook;
begin
    UnHookWindowsHookEx(rHookRec^.HookID);
end;

// In the entry point proc we create or destroy the file mapping in which we store the
// hook ID and the handle of our main window according to whether we're attaching or
// detaching
procedure EntryPointProc(Reason: Integer);
const
    hMapObject: THandle = 0; // this project was declared with Assignable Typed Constants
begin
    case reason of
        DLL_PROCESS_ATTACH:
            begin
//              for n := 0 to AppCount-1 do
//                  rHookRec^.MainWindow[n] := 0;
              hMapObject := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(THookRec), '_CBT');
              rHookRec := MapViewOfFile(hMapObject, FILE_MAP_WRITE, 0, 0, 0);
            end;

        DLL_PROCESS_DETACH:
            begin
                try
                    UnMapViewOfFile(rHookRec);
                    CloseHandle(hMapObject);
                except
                end;
            end;
    end;
end;

// we have to tell the DLL where our entry point proc is and call it as an attach
begin 
    DllProc := @EntryPointProc; 
    EntryPointProc(DLL_PROCESS_ATTACH); 
end.


