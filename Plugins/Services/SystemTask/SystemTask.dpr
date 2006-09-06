library SystemTask;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  Messages,
  SysUtils,
  main in 'main.pas' {fmMain};

{$R *.res}

var
  TaskManager : TfmMain;

procedure Stop;
begin
  if Assigned(TaskManager) then
   begin
    TaskManager.UnHook;

    FreeAndNil(TaskManager);
   end;
end;

function Start(owner: hwnd): hwnd;
begin
  Result := owner;

  if (TaskManager = nil) then
   begin
    TaskManager := TfmMain.Create(nil);
    TaskManager.Hook;

    PostMessage(HWND_BROADCAST, RegisterWindowMessage('TaskbarCreated'), 0, 0);
   end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop;

begin
end.
