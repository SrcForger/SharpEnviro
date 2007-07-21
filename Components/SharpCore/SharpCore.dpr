program SharpCore;

uses
  Forms,
  SysUtils,
  Dialogs,
  shellapi,
  Classes,
  Messages,
  Controls,
  SharpApi,
  JclShell,
  Windows,
  uSharpCoreMainWnd in 'uSharpCoreMainWnd.pas' {SharpCoreMainWnd},
  uSharpCoreServiceMan in 'uSharpCoreServiceMan.pas',
  uSharpCorePluginMethods in 'uSharpCorePluginMethods.pas',
  uSharpCoreImplementer in 'uSharpCoreImplementer.pas',
  uSharpCoreHelperMethods in 'uSharpCoreHelperMethods.pas',
  uSharpCoreShutdown in 'uSharpCoreShutdown.pas',
  uSharpCoreSettings in 'uSharpCoreSettings.pas',
  uSharpCoreServiceList in 'uSharpCoreServiceList.pas',
  uSharpCoreItemPnl in 'uSharpCoreItemPnl.pas',
  uSharpCoreStrings in 'uSharpCoreStrings.pas';

{$R *.res}
var
  bExit: boolean;
  sExtension: string;
  bDebug: Boolean;

begin

  SCI := TSCImplementer.Create;
  with SCI do begin

    sExtension := '';
    bDebug := False;
    CheckParams(ParamCount, bExit, sExtension, bDebug);
    CheckMutex(bExit);

    if not bExit then begin

      // Load Debug
      if bDebug then
        ShellExec(hInstance,'open',GetSharpeDirectory+'SharpConsole.exe',
        '',GetSharpeDirectory,0);

      // Initialisation
      CreateClasses;
      AppInitialise;

      // Assign the extension (if custom)
      if sExtension <> '' then
        ServiceManager.ServiceExt := sExtension;

      // Check for default Shell
      ShellMgr.Check;

      // Load Components
      ShellExec(hInstance,'open',GetSharpeDirectory+'SharpDesk.exe',
        '',GetSharpeDirectory,0);

      // If enabled show the splash logo
      if CompSettings.ShowSplash then
        ShowSplash;

      // Initialise services by adding them to the service list
      with ServiceManager do begin
        InitialiseServices;
        LoadServices;
        UpdateServicesView(SharpCoreMainWnd.sbList);
      end;

      // Register Actions
      RegisterActionEx('!ToggleServiceManager', 'SharpCore', SharpCoreMainWnd.Handle, 0);
      RegisterActionEx('!Restart', 'Shutdown', SharpCoreMainWnd.Handle, 1);
      RegisterActionEx('!Shutdown', 'Shutdown', SharpCoreMainWnd.Handle, 2);
      RegisterActionEx('!Logout', 'Shutdown', SharpCoreMainWnd.Handle, 3);
      RegisterActionEx('!Hibernate', 'Shutdown', SharpCoreMainWnd.Handle, 4);
      RegisterActionEx('!MinimizeAll', 'Tasks', SharpCoreMainWnd.Handle, 5);
      RegisterActionEx('!RestoreAll', 'Tasks', SharpCoreMainWnd.Handle, 6);
      RegisterActionEx('!ToggleAllBars', 'SharpBar', SharpCoreMainWnd.Handle, 7);
      SharpCoreMainWnd.Trayicon.IconVisible := True;

      Application.Title := 'SharpCore';
      Application.Run;
    end
    else begin
      Halt;
    end;
  end;

end.

