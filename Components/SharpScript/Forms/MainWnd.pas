unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, XPMan, SharpApi,
  JvComponentBase, JvInterpreter;

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
    procedure FormPaint(Sender: TObject);
    procedure Generic1Click(Sender: TObject);
    procedure Execute1Click(Sender: TObject);
    procedure Install1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    procedure WMSharpTerminate(var msg : TMessage); message WM_SHARPTERMINATE;
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

uses DateUtils,
     InstallWnd,
     CreateInstallScriptWnd,
     CreateGenericScriptWnd,
     ScriptControls;

{$R *.dfm}


procedure TMainForm.WMSharpTerminate(var msg : TMessage);
begin
  Application.Terminate;
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
  Ext,Dir : String;
  //installscript : TSharpEInstallerScript;
  genericscript : TSharpEGenericScript;
begin
  if OpenScript.InitialDir = '' then
  begin
    Dir :=  SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
    ForceDirectories(Dir);
    OpenScript.InitialDir := Dir;
  end;
  if OpenScript.Execute then
  begin
    Ext := ExtractFileExt(OpenScript.FileName);
    {if Ext = '.sip' then
    begin
      installscript := TSharpEInstallerScript.Create;
      try
        installscript.DoInstall(OpenScript.Filename);
      finally
        installscript.Free;
      end;
    end else }
    if Ext = '.sescript' then
    begin
      genericscript := TSharpEGenericScript.Create;
      try
        genericscript.ExecuteScript(OpenScript.FileName);
      finally
        genericscript.Free;
      end;
    end else Showmessage('Unknown file extension');
  end;
end;

procedure TMainForm.Generic1Click(Sender: TObject);
begin
  CreateGenericScriptForm.show;
  self.hide;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
    if CreateGenericScriptForm.Visible then Hide;
end;

end.
