unit uSharpCoreStrings;

interface

resourcestring
  // General Resource Strings
  rsApplicationName = 'SharpCore';
  rsRevertShellExplorer =
    'This process will revert the current shell to Windows Explorer, Are you sure?';
  rsExplorerRestored = 'Windows Explorer has now been restored; this will apply on next reboot.';
  rsAdminAccountRequired = 'You must be using an Administrator account to execute this command.';
  rsSeperateExplorer = 'This command will seperate the Windows Explorer Shell from the Explorer File Manager.'
    + #13 + 'This fix is required for SharpE to co-exist correctly with Explorer.' + #13#13 +
      'Click OK to continue.';
  rsFixApplied = 'The fix has now been applied.' + #13 +
    'SharpCore must now reboot; click OK to reboot.';
  rsFixAlreadyApplied = 'The system has already had the Explorer process fix applied.';
  rsNotDefaultShell =
    'SharpE is not currently the default shell, would you like to set it as default?';

  // General Format Strings
  fsApplicationVersion = 'SharpCore V%s';

  // Debug Strings
  dsCheckMutex = 'Checking For SharpCore Mutex...';
  dsMutexFound = 'Mutex found, terminating process.';
  dsMutexNotFound = 'Mutex not found, process intialising.';
  dsCreateForm = 'Create Form %s';
  dsErrorCreateForm = 'Error Creating Form %s';
  dsCreateClass = 'Create Class %s';
  dsErrorCreateClass = 'Error Creating Class %s';
  dsParamPassed = 'Parameter Passed: %s';
  dsShellCheckEnabled = 'ShellCheck property enabled.';
  dsShellCheckDisabled = 'ShellCheck property disabled.';
  dsSplashEnabled = 'Splash Logo property enabled.';
  dsSplashDisabled = 'Splash Logo property disabled.';

  // Parameters
  prmEx = '-explorer';
  prmExs = '-e';
  prmSep = '-setexplorerprocess';
  prmSeps = '-sep';
  prmExt = '-ext';

implementation

end.
