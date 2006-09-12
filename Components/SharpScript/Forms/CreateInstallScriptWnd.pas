unit CreateInstallScriptWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvEditorCommon, JvEditor, JvHLEditor,
  StdCtrls, ExtCtrls, ToolWin, ComCtrls, ImgList, PngImageList;

type
  TCreateInstallScriptForm = class(TForm)
    ed_script: TJvHLEditor;
    PngImageList1: TPngImageList;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    AddFileDialog: TOpenDialog;
    SavePackageDialog: TSaveDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    lb_files: TListBox;
    ToolBar1: TToolBar;
    btn_addfile: TToolButton;
    btn_deletefile: TToolButton;
    Panel3: TPanel;
    Label2: TLabel;
    ed_changelog: TMemo;
    Panel4: TPanel;
    Label3: TLabel;
    ed_rnotes: TMemo;
    procedure ToolButton1Click(Sender: TObject);
    procedure btn_deletefileClick(Sender: TObject);
    procedure btn_addfileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  CreateInstallScriptForm: TCreateInstallScriptForm;

implementation

uses MainWnd,
     LibTar;

{$R *.dfm}

procedure TCreateInstallScriptForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.Show;
end;

procedure TCreateInstallScriptForm.btn_addfileClick(Sender: TObject);
var
  n : integer;
begin
  if AddFileDialog.Execute then
  begin
    for n := 0 to AddFileDialog.Files.Count - 1 do
        if lb_files.Items.IndexOf(AddFileDialog.Files[n])<0 then
           lb_files.Items.Add(AddFileDialog.Files[n]);
  end;
end;

procedure TCreateInstallScriptForm.btn_deletefileClick(Sender: TObject);
begin
  if lb_files.ItemIndex >= 0 then lb_files.Items.Delete(lb_files.ItemIndex);
end;

procedure TCreateInstallScriptForm.ToolButton1Click(Sender: TObject);
var
  n : integer;
  MemoryStream : TMemoryStream;
  TW : TTarWriter;
  b : boolean;
begin
  if SavePackageDialog.Execute then
  begin
    b := False;
    MemoryStream := TMemoryStream.Create;
    TW := TTarWriter.Create(SavePackageDialog.FileName + '.sip');
    try
      MemoryStream.Clear;
      ed_script.Lines.SaveToStream(MemoryStream);
      MemoryStream.Position := 0;
      TW.AddStream(MemoryStream,'Script.siscript',now);

      MemoryStream.Clear;
      ed_rnotes.Lines.SaveToStream(MemoryStream);
      MemoryStream.Position := 0;
      TW.AddStream(MemoryStream,'ReleaseNotes.txt',now);

      Memorystream.Clear;
      ed_changelog.Lines.SaveToStream(MemoryStream);
      MemoryStream.Position := 0;
      TW.AddStream(MemoryStream,'Changelog.txt',now);
      
      for n := 0 to lb_files.Items.Count - 1 do
          if FileExists(lb_files.Items[n]) then
             TW.AddFile(lb_files.Items[n],'Files\'+ExtractfileName(lb_files.Items[n]));
      b := True;
    finally
      TW.Free;
      MemoryStream.Free;
    end;
    if not b then showmessage('PANIC: something went wrong!');
  end;
end;

end.
