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
  exit: boolean;
  newExtension: string;

begin

  SCI := TSCImplementer.Create;
  with SCI do begin

    newExtension := '';
    CheckParams(ParamCount, exit, newExtension);
    CheckMutex(exit);

    if not exit then begin

      // Initialisation
      CreateClasses;
      AppInitialise;

      // Assign the extension (if custom)
      if newExtension <> '' then
        ServiceManager.ServiceExt := newExtension;

      // Check for default Shell
      ShellMgr.Check;

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
      SharpCoreMainWnd.Trayicon.IconVisible := True;



      Application.Title := 'SharpCore';
      Application.Run;
    end
    else begin
      Halt;
    end;
  end;

end.

