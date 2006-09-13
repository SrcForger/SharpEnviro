unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, XPMan, JvComponentBase, JvInterpreter, AbArcTyp;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Script1: TMenuItem;
    Execute1: TMenuItem;
    Edit1: TMenuItem;
    Create1: TMenuItem;
    Generic1: TMenuItem;
    Install1: TMenuItem;
    Skin1: TMenuItem;
    XPManifest1: TXPManifest;
    OpenScript: TOpenDialog;
    JvInterpreter: TJvInterpreterProgram;
    procedure Execute1Click(Sender: TObject);
    procedure Install1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    FUnzipList : TStringList;
    procedure UnzipProcess(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
    procedure DoInstall(FileName : String);
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

uses DateUtils,
     SharpApi,
     InstallWnd,
     CreateInstallScriptWnd,
     AbUtils,
     AbBase,
     AbBrowse,
     AbZBrows,
     AbUnzper;

{$R *.dfm}

procedure TMainForm.UnzipProcess(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
begin
  if FUnzipList.IndexOf(Item.FileName) < 0 then
     FUnzipList.Add(Item.FileName);
  Abort := False;
end;

procedure TMainForm.DoInstall(FileName : String);
var
  UnZipper : TAbUnZipper;
  s : String;
  n : integer;
  MemoryStream : TMemoryStream;
  InstallForm: TInstallForm;
  BeforeInstall, Install, AfterInstall : Boolean;
begin
  if not FileExists(FileName) then exit;

  UnZipper := TAbUnZipper.Create(nil);
  FUnzipList := TStringList.Create; 
  FUnzipList.Clear;
  UnZipper.OnArchiveItemProgress := MainForm.UnzipProcess;
  MemoryStream := TMemoryStream.Create;
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
    Hide;
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
    Show;

    try
      for n := 0 to FUnzipList.Count - 1 do
          if FileExists(SharpApi.GetSharpeDirectory + 'Temp\' + FUnzipList[n]) then
             DeleteFile(SharpApi.GetSharpeDirectory + 'Temp\' + FUnzipList[n]);
    except
    end;

    FUnzipList.Free;
    InstallForm.Free;
    MemoryStream.Free;
    UnZipper.CloseArchive;
    UnZipper.Free;
    RenameFile(s,FileName);
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.Install1Click(Sender: TObject);
begin
  CreateInstallScriptForm.show;
  self.hide;
end;

procedure TMainForm.Execute1Click(Sender: TObject);
var
  Ext : String;
begin
  if OpenScript.Execute then
  begin
    Ext := ExtractFileExt(OpenScript.FileName);
    if Ext = '.sip' then DoInstall(OpenScript.Filename)
       else Showmessage('Unknown file extension');
  end;
end;

end.
