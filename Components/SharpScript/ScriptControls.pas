unit ScriptControls;

interface

uses Forms,
     Controls,
     Dialogs,
     SysUtils,
     Classes,
     Types,
     JvComponentBase,
     JvInterpreter;

type
  {TSharpEInstallerScript = class
                           private
                             FUnzipList : TStringList;
                           public
                             procedure UnzipProcess(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
                             procedure DoInstall(FileName : String);
                           end;      }

  TSharpEGenericScript = class
                         private
                           procedure OnInterpreterStatement(Sender : TObject);
                         public
                           procedure ExecuteScript(FileName : String);
                         end;


implementation

uses  DateUtils,
      SharpApi,
      InstallWnd,
      LogWnd,
      SharpApi_Adapter,
      SharpBase_Adapter,
      SharpFileUtils_Adapter;

{procedure TSharpEInstallerScript.UnzipProcess(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
begin
  if FUnzipList.IndexOf(Item.FileName) < 0 then
     FUnzipList.Add(Item.FileName);
  Abort := False;
end;

procedure TSharpEInstallerScript.DoInstall(FileName : String);
var
  UnZipper : TAbUnZipper;
  s : String;
  n : integer;
  MemoryStream : TMemoryStream;
  InstallForm: TInstallForm;
  BeforeInstall, Install, AfterInstall : Boolean;
  JvInterpreter : TJvInterpreterProgram;
begin
  if not FileExists(FileName) then exit;

  UnZipper := TAbUnZipper.Create(nil);
  FUnzipList := TStringList.Create; 
  FUnzipList.Clear;
  UnZipper.OnArchiveItemProgress := UnzipProcess;
  MemoryStream := TMemoryStream.Create;
  JvInterpreter := TJvInterpreterProgram.Create(nil);
  InstallForm := TInstallForm.Create(Application.MainForm);

  s := ExtractFileDir(FileName) +'\' + inttostr(DateTimeToUnix(now)) + '.zip';
  RenameFile(FileName,s);
  try
    ForceDirectories(SharpApi.GetSharpeDirectory + 'Temp\');
    try
      UnZipper.OpenArchive(s);
      UnZipper.ExtractOptions := [eoCreateDirs];
      UnZipper.BaseDirectory := SharpApi.GetSharpeDirectory + 'Temp\';

      MemoryStream.Clear;
      UnZipper.ExtractToStream('Changelog.txt',MemoryStream);
      MemoryStream.Position := 0;
      InstallForm.m_changelog.Lines.LoadFromStream(MemoryStream);

      MemoryStream.Clear;
      UnZipper.ExtractToStream('ReleaseNotes.txt',MemoryStream);
      MemoryStream.Position := 0;
      InstallForm.m_rnotes.Lines.LoadFromStream(MemoryStream);

      MemoryStream.Clear;
      UnZipper.ExtractToStream('Script.siscript',MemoryStream);
      MemoryStream.Position := 0;
      JvInterpreter.Pas.LoadFromStream(MemoryStream);
    except
      Showmessage('Install file is not valid!');
      exit;
    end;
    if Application.MainForm <> nil then Application.MainForm.Hide;
    if InstallForm.ShowModal = mrOk then
    begin
      UnZipper.ExtractFiles('*.*');
      BeforeInstall := False;
      Install := False;
      AfterInstall := False;

      try
        JvInterpreter.Compile;
      except
        ShowMessage('Errors in Install Script Detected!');
        exit;
      end;

      try
        BeforeInstall := JvInterpreter.CallFunction('BeforeInstall',nil,[]);
      except
        ShowMessage('Initializing failed!');
        exit;
      end;

      try
        Install := JvInterpreter.CallFunction('Install',nil,[]);
      except
        ShowMessage('Install process failed!');
        exit;
      end;

      try
        AfterInstall := JvInterpreter.CallFunction('AfterInstall',nil,[]);
      except
        ShowMessage('Completing failed!');
        exit;
      end;
      ShowMessage('Install Complete');
    end;
  finally
    if Application.MainForm <> nil then Application.MainForm.Show;

    try
      for n := 0 to FUnzipList.Count - 1 do
          if FileExists(SharpApi.GetSharpeDirectory + 'Temp\' + FUnzipList[n]) then
             DeleteFile(SharpApi.GetSharpeDirectory + 'Temp\' + FUnzipList[n]);
    except
    end;

    JvInterpreter.Free;
    FUnzipList.Free;
    InstallForm.Free;
    MemoryStream.Free;
    UnZipper.CloseArchive;
    UnZipper.Free;
    RenameFile(s,FileName);
  end;
end;                               }

procedure TSharpEGenericScript.OnInterpreterStatement(Sender : TObject);
begin
  Application.ProcessMessages;
end;

procedure TSharpEGenericScript.ExecuteScript(FileName :String);
var
  JvInterpreter : TJvInterpreterProgram;
  logform : TLogForm;
  n : integer;
  LogWindow : boolean;
  LogAutoClose : boolean;
begin
  if not FileExists(FileName) then exit;

  LogWindow := True;
  LogAutoClose := False;
  LogForm := TLogForm.Create(nil);
  JvInterpreter := TJvInterpreterProgram.Create(nil);
  try
    SharpApi_Adapter.RegisterAPILog(LogForm.lb_log.Items);
    SharpBase_Adapter.RegisterBaseLog(LogForm.lb_log.Items);
    SharpFileUtils_Adapter.RegisterFileUtilsLog(LogForm.lb_log.Items);

    JvInterpreter.Pas.LoadFromFile(FileName);

    for n := 0 to JvInterpreter.Pas.Count - 1 do
    begin
      if CompareText('{$LOGWINDOW OFF}',JvInterpreter.Pas[n]) = 0 then LogWindow := False;
      if CompareText('{$LOGWINDOW AUTOCLOSE ON}',JvInterpreter.Pas[n]) = 0 then LogAutoClose := True;
      if (CompareText('var',JvInterpreter.Pas[n]) = 0) or
         (CompareText('begin',JvInterpreter.Pas[n]) = 0) or
         (CompareText('const',JvInterpreter.Pas[n]) = 0) then break;
    end;

    if LogWindow then LogForm.Show;
    JvInterpreter.OnStatement := OnInterpreterStatement;
    try
      JvInterpreter.Run;
    except
      LogForm.lb_log.Items.Add('Error: aborting script');
    end;
  finally
    SharpApi_Adapter.UnRegisterAPILog;
    SharpBase_Adapter.UnRegisterBaseLog;
    SharpFileUtils_Adapter.UnRegisterFileUtilsLog;
    JvInterpreter.Free;
    if LogWindow then
    begin
      LogForm.lb_log.Items.Add('-----------------------------------------------------');
      LogForm.lb_log.Items.Add('Script finished');
      Application.ProcessMessages;
      if LogAutoClose then
      begin
        Sleep(2500);
      end else
      begin
        LogForm.Hide;
        LogForm.ShowModal;
      end;
    end;
    LogForm.Free;
  end;
end;



end.
