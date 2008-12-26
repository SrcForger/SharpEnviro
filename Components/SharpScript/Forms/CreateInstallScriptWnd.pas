unit CreateInstallScriptWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvEditorCommon, JvEditor, JvHLEditor,
  StdCtrls, ExtCtrls, ToolWin, ComCtrls, ImgList, PngImageList,
  DateUtils, XPMan, JvComponentBase, JvInterpreter;

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
    XPManifest1: TXPManifest;
    JvInterpreter: TJvInterpreterProgram;
    lb_errors: TListBox;
    procedure ed_scriptPaintGutter(Sender: TObject; Canvas: TCanvas);
    procedure ToolButton2Click(Sender: TObject);
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

uses MainWnd;

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
//var
  //n : integer;
  //MemoryStream : TMemoryStream;
  //b : boolean;
  //s : String;
begin
 { if SavePackageDialog.Execute then
  begin
    b := False;
    AbZipper1.ArchiveType := atZip;
    s := ExtractFileDir(SavePackageDialog.FileName) + '\' + inttostr(DateTimeToUnix(now))+'.zip';
    AbZipper1.FileName :=  s;
    MemoryStream := TMemoryStream.Create;
    try
      MemoryStream.Clear;
      ed_script.Lines.SaveToStream(MemoryStream);
      MemoryStream.Position := 0;
      AbZipper1.AddFromStream('Script.siscript',MemoryStream);

      MemoryStream.Clear;
      ed_rnotes.Lines.SaveToStream(MemoryStream);
      MemoryStream.Position := 0;
      AbZipper1.AddFromStream('ReleaseNotes.txt',MemoryStream);

      Memorystream.Clear;
      ed_changelog.Lines.SaveToStream(MemoryStream);
      MemoryStream.Position := 0;
      AbZipper1.AddFromStream('Changelog.txt',MemoryStream);

      for n := 0 to lb_files.Items.Count - 1 do
          if FileExists(lb_files.Items[n]) then
             AbZipper1.AddFiles(lb_files.Items[n],0);

      b := True;
      AbZipper1.Save;
      AbZipper1.CloseArchive;
    finally
      MemoryStream.Free;
    end;
    DeleteFile(SavePackageDialog.FileName + '.sip');
    RenameFile(s,SavePackageDialog.FileName + '.sip');
    
    if not b then showmessage('PANIC: something went wrong!');
  end;    }
end;

procedure TCreateInstallScriptForm.ToolButton2Click(Sender: TObject);
var
  errors : boolean;
begin
  lb_errors.Clear;
  lb_errors.Items.Add('Compiling Script...');
  JvInterpreter.Pas.CommaText := ed_script.Lines.CommaText;
  errors := True;
  try
    JvInterpreter.Compile;
    errors := False;
  except
    on E: Exception do lb_errors.Items.Add('Error: ' + E.Message);
  end;
  if not errors then lb_errors.Items.Add('No Errors Found!');
end;

procedure TCreateInstallScriptForm.ed_scriptPaintGutter(Sender: TObject;
  Canvas: TCanvas);
var
  i: Integer;
  R: TRect;
  oldFont: TFont;
begin
  oldFont := TFont.Create;
  try
    oldFont.Assign(Canvas.Font);
    Canvas.Font := ed_script.Font;
    with ed_script do
      for i := TopRow to TopRow + VisibleRowCount do
      begin
        R := Bounds(2, (i - TopRow) * CellRect.Height, GutterWidth - 2 - 5, CellRect.Height);
        Windows.DrawText(Canvas.Handle, PChar(IntToStr(i + 1)), -1, R, DT_RIGHT or DT_VCENTER or DT_SINGLELINE);
      end;
  finally
    Canvas.Font := oldFont;
    oldFont.Free;
  end;
end;

end.
