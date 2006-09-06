unit ShellHookTypes;

interface

uses
  Windows, Messages;

{ These Custom messages are made up out of thin air change if needed.           }
const
  WM_DLL_PROCESS_DETACH = WM_USER + 290;
  WM_DLL_PROCESS_ATTACH = WM_USER + 291;
  WM_DLL_THREAD_ATTACH = WM_USER + 292;
  WM_DLL_THREAD_DETACH = WM_USER + 293;

  WM_HSHELL_NOTIFY = WM_USER + 294;
  WM_HSHELL_BROADCAST = WM_USER + 295;

  str_ShellHookData = 'ShellHookData';

{ Memory Mapped File Data structure.  Can be changed as necessary, although     }
{ the AppHandle and HookHandle are necessary for the hook to function.          }
type
  PShellHookData = ^TShellHookData;
  TShellHookData = record
    AppHandle: THandle;
    ProcessCount,
    ThreadCount: integer;
    HookHandle: THandle;
  end;

implementation

end.
