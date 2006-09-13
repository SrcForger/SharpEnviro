unit ScriptControls;

interface

uses Forms,
     Controls,
     Dialogs,
     SysUtils,
     Classes,
     Types,
     JvComponentBase,
     JvInterpreter,
     AbArcTyp;

type
  TSharpEInstallerScript = class
                           private
                             FUnzipList : TStringList;
                           public
                             procedure UnzipProcess(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
                             procedure DoInstall(FileName : String);
                           end;


implementation

uses  DateUtils,
      SharpApi,
      AbUtils,
      AbBase,
      AbBrowse,
      AbZBrows,
      AbUnzper,
      InstallWnd;

procedure TSharpEInstallerScript.UnzipProcess(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
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
end;



end.
