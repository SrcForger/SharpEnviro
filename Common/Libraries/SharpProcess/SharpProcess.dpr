{ A WORD OF WARNING FOR THOSE NEW TO GLOBAL HOOKS!                              }
{   Global hooks are not like your average Delphi app.  This code is injected   }
{   into the address space of *other* programs.  It is a unique copy for each   }
{   process (or thread see notes below on threads loading the DLL), as such     }
{   global variables are IMPOSSIBLE.  Each process that loads the DLL will have }
{   a unique instance of globlal variables.  The only way to do this (at least  }
{   the only way Delphi supports) is to use a Memory Mapped File.  See the      }
{   code below and the API help on how to use these.  It is maniditory in order }
{   to pass information between instances of the DLL.                           }
{ YOU CAN NOT PASS POINTERS!                                                    }
{   Some hooks pass pointers to data stuctures in the callback function.        }
{   *Don't* pass this pointer to your application.  The pointer is a pointer to }
{   memory in the application that is being hooked.  That pointer will point to }
{   random memory in your application if you pass it.  You must copy the        }
{   information the pointer points to to a data structure in a Memory Mapped    }
{   file and then open the File in your application.                            }

library SharpProcess;

uses
  Classes, Windows, ShellHookTypes;

{$R *.RES}

function ShellProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT stdcall;
var
  Msg: Integer;
  MappedMemoryHandle: THandle;
  HookData: PShellHookData;
begin
  { Most will not like the extra overhead of opening the mapped file for every   }
  { hook event.  The problem is I found that in Win98, initial release at least, }
  { that if the user is using dialup networking or connected to their ISP that   }
  { if the hook is unregistered Windows does not remove it from the address      }
  { space of the process handling the dialup (taspi.exe or something like that)  }
  { and it will crash that process because the mapped file is no longer valid.   }
  { Usually you will see the mapped file opened in the Process_Attach call and   }
  { closed in the Process_Detach.  I was trying to make the hook as bullet proof }
  { as possible and this is necessary for maximum robustness.                    }
  Result := 0;

  MappedMemoryHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, str_ShellHookData);
  if MappedMemoryHandle <> 0 then
  begin
    HookData := MapViewOfFile(MappedMemoryHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if Assigned(HookData) then
    begin
      Msg := -1;

      case Code of
      	HSHELL_WINDOWCREATED, HSHELL_WINDOWDESTROYED,
        HSHELL_REDRAW, HSHELL_WINDOWACTIVATED:
         begin
          Msg := WM_HSHELL_NOTIFY;

          if (Code = HSHELL_WINDOWCREATED) then
           begin
            lParam := -1;
           end;

          if (Code = HSHELL_REDRAW) then
           begin
            lParam := lParam - 3;
           end;
         end;
      end;

      if (Msg > -1) then
        { You don't want the hook code to have to wait for the message to be    }
        { processed.  The danger here is that another hook message could come   }
        { along and overwrite the last hook message before your application can }
        { process the first one.  If this matters use SendMessage.              }
        PostMessage(HookData^.AppHandle, Msg, wParam, lParam);

      { The M$ documentation is incorrect.  In Win32 you should always call     }
      { the next hook.                                                          }
      if HookData^.HookHandle <> 0 then
        Result := CallNextHookEx(HookData^.HookHandle, Code, wParam, lParam);
      UnMapViewOfFile(HookData);
    end;
    CloseHandle(MappedMemoryHandle);
  end
end;

procedure HookShell; stdcall;
var
  MappedMemoryHandle: THandle;
  HookData: PShellHookData;
begin
  MappedMemoryHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, str_ShellHookData);
  if MappedMemoryHandle <> 0 then
  begin
    HookData := MapViewOfFile(MappedMemoryHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if Assigned(HookData) then
    begin
      { Store the returned Handle in the Memory Mapped File so all instances    }
      { of the DLL hook can retrieve it to pass it the CallNextHookEx           }
      HookData^.HookHandle := SetWindowsHookEx(WH_SHELL, ShellProc, hInstance, 0);

      UnmapViewOfFile(HookData);
    end;
    CloseHandle(MappedMemoryHandle);
  end
end;

procedure UnHookShell; stdcall;
var
  MappedMemoryHandle: THandle;
  HookData: PShellHookData;
begin
  MappedMemoryHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, str_ShellHookData);
  if MappedMemoryHandle <> 0 then
  begin
    HookData := MapViewOfFile(MappedMemoryHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if Assigned(HookData) then
    begin
      UnHookWindowsHookEx(HookData^.HookHandle);
      HookData^.HookHandle := 0;
      UnmapViewOfFile(HookData);
    end;
    CloseHandle(MappedMemoryHandle);
  end
end;

exports HookShell;
exports UnHookShell;

procedure DLLEntryProc(EntryCode: integer);
var
  Msg: Integer;
  MappedMemoryHandle: THandle;
  HookData: PShellHookData;
begin
  MappedMemoryHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, str_ShellHookData);
  if MappedMemoryHandle <> 0 then
  begin
    HookData := MapViewOfFile(MappedMemoryHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if Assigned(HookData) then
    begin
      Msg := -1;
      case EntryCode of
        DLL_PROCESS_DETACH:
          begin
            Msg := WM_DLL_PROCESS_DETACH;
          end;
        DLL_PROCESS_ATTACH:
          begin
            Msg := WM_DLL_PROCESS_ATTACH;
          end;
        { Since DisableThreadLibraryCalls is used below these will never be    }
        { called but incase you want to see how windows loads the hook in      }
        { threads remove the DisableThreadLibraryCalls and these will be       }
        { updated on the test form.                                            }
        DLL_THREAD_ATTACH:
          begin
            Msg := WM_DLL_THREAD_ATTACH;
          end;
        DLL_THREAD_DETACH:
          begin
            Msg := WM_DLL_THREAD_DETACH;
          end;
      end;
      { Notify the application that some process (or thread) has                }
      { loaded/unloaded the DLL.                                                }
      with HookData^ do
        PostMessage(AppHandle, Msg, ProcessCount, ThreadCount);
      UnmapViewOfFile(HookData);
    end;
    CloseHandle(MappedMemoryHandle);
  end;
end;

begin
  { Very important for hook stability in networking enviroments.  There is an   }
  { not well understood problem with Delphi Global Hooks and Explorer.          }
  DisableThreadLibraryCalls(hInstance);

  { Since the reason we are here is that the DLL has been loaded and is in the  }
  { middle of a DLL_PROCESS_ATTACH.  As such we have not set the DLLProc so we  }
  { have to call our DLLEntry Procedure explicitly.                             }
  DLLProc := @DLLEntryProc;
  DLLEntryProc(DLL_PROCESS_ATTACH);
end.
