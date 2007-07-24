unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Contnrs, SharpERoundPanel, StdCtrls, JvExComCtrls,
  JvgTreeView, JvgListBox, SharpETabList, ToolWin, ImgList, uVistaFuncs,
  JvSimpleXML, JvComCtrls, JvCheckTreeView, CheckLst, JvExCheckLst,
  JvCheckListBox, JvStatusBar, JvExStdCtrls, JvMemo, uCompiler, SharpEListBoxEx;

type
  TfrmMain = class(TForm)
    panMain: TPanel;
    panLeft: TPanel;
    sepProjects: TSharpERoundPanel;
    sepProjLbl: TSharpERoundPanel;
    lblProjects: TLabel;
    sepOptions: TSharpERoundPanel;
    sepOptLbl: TSharpERoundPanel;
    lblOptions: TLabel;
    panRight: TPanel;
    stlMain: TSharpETabList;
    sepLog: TSharpERoundPanel;
    tbMain: TToolBar;
    tbOpen: TToolButton;
    tbCompile: TToolButton;
    tbClear: TToolButton;
    tbSettings: TToolButton;
    ilToolbar: TImageList;
    dlgOpen: TOpenDialog;
    ctvProjects: TJvCheckTreeView;
    clbOptions: TJvCheckListBox;
    mSummary: TJvMemo;
    mDetailed: TJvMemo;
    procedure FormCreate(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure stlMainTabClick(ASender: TObject; const ATabIndex: Integer);
    procedure tbClearClick(Sender: TObject);
    procedure tbCompileClick(Sender: TObject);
    procedure mDetailedChange(Sender: TObject);
    procedure mSummaryChange(Sender: TObject);
    procedure ctvProjectsSelectionChange(Sender: TObject);
  private
    procedure CompilerNewLine(Sender: TObject; CmdOutput: string);
    procedure CompileProject(Project: TDelphiProject; bDebug: Boolean);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  sPath: String;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  uVistaFuncs.SetVistaFonts(frmMain);
end;

procedure TfrmMain.mDetailedChange(Sender: TObject);
begin
  mDetailed.Perform(EM_LINESCROLL, 0, mDetailed.Lines.Count);
end;

procedure TfrmMain.mSummaryChange(Sender: TObject);
begin
  mSummary.Perform(EM_LINESCROLL, 0, mSummary.Lines.Count);
end;

procedure TfrmMain.stlMainTabClick(ASender: TObject; const ATabIndex: Integer);
begin
  if ATabIndex = 0 then
  begin
    mSummary.Visible := True;
    mDetailed.Visible := False;
  end;
  if ATabIndex = 1 then
  begin
    mSummary.Visible := False;
    mDetailed.Visible := True;
  end;
end;

procedure TfrmMain.tbClearClick(Sender: TObject);
begin
  mSummary.Clear;
  mDetailed.Clear;
end;

procedure TfrmMain.tbCompileClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ctvProjects.Items.Count - 1 do
  begin
    if ctvProjects.Checked[ctvProjects.Items[i]] then
    begin
      if TDelphiProject(ctvProjects.Items[i].Data) <> nil then
        CompileProject(TDelphiProject(ctvProjects.Items[i].Data), clbOptions.Checked[0]);
    end;
  end;
end;

procedure TfrmMain.CompileProject(Project: TDelphiProject; bDebug: Boolean);
var
  dCompiler: TDelphiCompiler;
  sSummary: String;
begin
  mSummary.Lines.Add('Compiling ' + Project.Name);
  Project.SIndex := mSummary.Lines.Count -1;
  sSummary := mSummary.Lines[mSummary.Lines.Count - 1];
  mDetailed.Lines.Add(sSummary);
  Project.DIndex := mDetailed.Lines.Count -1;
  dCompiler := TDelphiCompiler.Create;
  dCompiler.OnCompilerCmdOutput := CompilerNewLine;
  if dCompiler.CompileProject(Project, bDebug) then
  begin
    sSummary := sSummary + '...Success!';
    mDetailed.Lines.Add('Inserted ' + IntToStr(Project.DataSize) + ' bytes of debug data');
  end
  else
  begin
    sSummary := sSummary + '...Failed!';
  end;
  mSummary.Lines[Project.SIndex] := sSummary;
  mDetailed.Lines[Project.DIndex] := sSummary;
end;

procedure TfrmMain.CompilerNewLine(Sender: TObject; CmdOutput: string);
begin
  mDetailed.Lines.Add(CmdOutput);
end;

procedure TfrmMain.ctvProjectsSelectionChange(Sender: TObject);
begin
  if ctvProjects.Selected.Data <> nil then
  begin
    mSummary.Perform(EM_LINESCROLL, 0, 0 - mSummary.Lines.Count);
    mSummary.Perform(EM_LINESCROLL, 0, TDelphiProject(ctvProjects.Selected.Data).SIndex);
    mDetailed.Perform(EM_LINESCROLL, 0, 0 - mDetailed.Lines.Count);
    mDetailed.Perform(EM_LINESCROLL, 0, TDelphiProject(ctvProjects.Selected.Data).DIndex);
  end;
end;

procedure TfrmMain.tbOpenClick(Sender: TObject);
var
  n,i: integer;
  xFile: TJvSimpleXML;
  nProject,nComponent: TTreeNode;
begin
  if dlgOpen.Execute then
  begin
    if ctvProjects.Items.Count > 0 then
      for n := 0 to ctvProjects.Items.Count - 1 do
      begin
        ctvProjects.Items[n].Delete;
      end;
    xFile := TJvSimpleXML.Create(nil);
    if FileExists(dlgOpen.FileName) then
    begin
      sPath := IncludeTrailingBackslash(ExtractFileDir(dlgOpen.FileName));
      xFile.LoadFromFile(dlgOpen.FileName);
      for n := 0 to xFile.Root.Items.Count - 1 do
        with xFile.Root.Items.Item[n] do
        begin
          nProject := ctvProjects.Items.Add(nil, Properties.Value('Name', 'error'));
          nProject.Data := nil;
          ctvProjects.SetChecked(nProject, True);
          for i := 0 to Items.Count - 1 do
            with Items.Item[i] do
            begin
              nComponent := ctvProjects.Items.AddChild(nProject, Properties.Value('Name', 'error'));
              nComponent.Data := TDelphiProject.Create(sPath + Value, Properties.Value('Name', 'error'));
              ctvProjects.SetChecked(nComponent, True);
              mDetailed.Lines.Add('Loaded ' + Properties.Value('Name', 'error'));
              mDetailed.Lines.Add('Type: ' + Properties.Value('Type', 'Application'));
              mDetailed.Lines.Add('Requires: ' + Properties.Value('Requ', 'Turbo Delphi Explorer 2006'));
            end;
        end;
      mSummary.Lines.Add('Loaded ' + ExtractFileName(dlgOpen.FileName));
	  end;
  end;
end;

end.
