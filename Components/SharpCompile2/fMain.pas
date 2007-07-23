unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Contnrs, SharpERoundPanel, StdCtrls, JvExComCtrls,
  JvgTreeView, JvgListBox, SharpETabList, ToolWin, ImgList, uVistaFuncs,
  JvSimpleXML, JvComCtrls, JvCheckTreeView, CheckLst, JvExCheckLst,
  JvCheckListBox, JvStatusBar, JvExStdCtrls, JvMemo, uCompiler;

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
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  olProjects: TObjectList;
  sPath: String;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  uVistaFuncs.SetVistaFonts(frmMain);
  olProjects := TObjectList.Create(True);
end;


procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  olProjects.Free;
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
begin
  // compile code
end;

procedure TfrmMain.tbOpenClick(Sender: TObject);
var
  n,i: integer;
  xFile: TJvSimpleXML;
  nProject,nComponent: TTreeNode;
  dpProject: TDelphiProject;
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
          ctvProjects.SetChecked(nProject, True);
          for i := 0 to Items.Count - 1 do
            with Items.Item[i] do
            begin
              nComponent := ctvProjects.Items.AddChild(nProject, Properties.Value('Name', 'error'));
              ctvProjects.SetChecked(nComponent, True);
              mDetailed.Lines.Add('Loaded ' + Properties.Value('Name', 'error'));
              mDetailed.Lines.Add('Type: ' + Properties.Value('Type', 'Application'));
              mDetailed.Lines.Add('Requires: ' + Properties.Value('Requ', 'Turbo Delphi Explorer 2006'));
              dpProject := TDelphiProject.Create(sPath + Value);
              olProjects.Add(dpProject);
              nComponent := nil;
            end;
          nProject := nil;
        end;
      mSummary.Lines.Add('Loaded ' + ExtractFileName(dlgOpen.FileName));
	  end;
  end;
end;

end.
