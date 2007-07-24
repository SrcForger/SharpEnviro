unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Contnrs, SharpERoundPanel, StdCtrls, JvExComCtrls,
  JvgTreeView, JvgListBox, SharpETabList, ToolWin, ImgList, uVistaFuncs,
  JvSimpleXML, JvComCtrls, JvCheckTreeView, CheckLst, JvExCheckLst,
  JvCheckListBox, JvStatusBar, JvExStdCtrls, JvMemo, uCompiler, SharpEListBoxEx,
  SharpEPageControl, PngImageList, StrUtils;

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
    tbMain: TToolBar;
    tbOpen: TToolButton;
    tbCompile: TToolButton;
    tbClear: TToolButton;
    tbSettings: TToolButton;
    ilToolbar: TImageList;
    dlgOpen: TOpenDialog;
    ctvProjects: TJvCheckTreeView;
    clbOptions: TJvCheckListBox;
    sepLog: TSharpEPageControl;
    mSummary_: TJvMemo;
    mDetailed: TJvMemo;
    Splitter1: TSplitter;
    lbSummary: TSharpEListBoxEx;
    pilStatus: TPngImageList;
    pilStates: TPngImageList;
    procedure FormCreate(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure stlMainTabClick(ASender: TObject; const ATabIndex: Integer);
    procedure tbClearClick(Sender: TObject);
    procedure tbCompileClick(Sender: TObject);
    procedure mDetailedChange(Sender: TObject);
    procedure mSummary_Change(Sender: TObject);
    procedure ctvProjectsSelectionChange(Sender: TObject);
    procedure lbSummaryGetCellColor(const AItem: Integer; var AColor: TColor);
    procedure lbSummaryDblClickItem(AText: string; AItem, ACol: Integer);
  private
    procedure CompilerNewLine(Sender: TObject; CmdOutput: string);
    procedure CompileProject(Project: TDelphiProject; bDebug: Boolean; iPercent: Integer);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  sPath: String;
  dtTotalStart: TDateTime;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  uVistaFuncs.SetVistaFonts(frmMain);
end;

procedure TfrmMain.lbSummaryDblClickItem(AText: string; AItem, ACol: Integer);
var
  sProjName: String;
  i, iPos: Integer;
begin
  if pos('Compiling', AText) <> 0 then
  begin
    sProjName := RightStr(AText, Length(AText) - 10);
    sProjName := LeftStr(sProjName, Pos('...', sProjName) - 1);
    for i := 0 to ctvProjects.Items.Count - 1 do
    begin
      if ctvProjects.Items[i].Text = sProjName then
      begin
        mDetailed.Perform(EM_LINESCROLL, 0, 0 - mDetailed.Lines.Count);
        iPos := TDelphiProject(ctvProjects.Items[i].Data).DIndex;
        if Pos('Failed!', AText) <> 0 then
          iPos := iPos - Trunc(mDetailed.Height / Abs(Canvas.TextHeight('Wg')) - 1);
        mDetailed.Perform(EM_LINESCROLL, 0, iPos);
        sepLog.TabIndex := 1;
        lbSummary.Visible := False;
        mDetailed.Visible := True;
      end;
    end;
  end;
end;

procedure TfrmMain.lbSummaryGetCellColor(const AItem: Integer;
  var AColor: TColor);
begin
  if lbSummary.Item[AItem].ImageIndex = 0 then
    AColor := $00ECECFF;
end;

procedure TfrmMain.mDetailedChange(Sender: TObject);
begin
  mDetailed.Perform(EM_LINESCROLL, 0, mDetailed.Lines.Count);
end;

procedure TfrmMain.mSummary_Change(Sender: TObject);
begin
  lbSummary.Perform(EM_LINESCROLL, 0, lbSummary.Count);
end;

procedure TfrmMain.stlMainTabClick(ASender: TObject; const ATabIndex: Integer);
begin
  if ATabIndex = 0 then
  begin
    lbSummary.Visible := True;
    mDetailed.Visible := False;
  end;
  if ATabIndex = 1 then
  begin
    lbSummary.Visible := False;
    mDetailed.Visible := True;
  end;
end;

procedure TfrmMain.tbClearClick(Sender: TObject);
begin
  lbSummary.Clear;
  mDetailed.Clear;
end;

procedure TfrmMain.tbCompileClick(Sender: TObject);
var
  i,iProjCount,iStatus: integer;
  iPercent: integer;
begin
  iProjCount := 0;
  iStatus := 0;
  dtTotalStart := Now;
  for i := 0 to ctvProjects.Items.Count - 1 do
  begin
    if ctvProjects.Checked[ctvProjects.Items[i]] then
      if not ctvProjects.Items[i].HasChildren then
        iProjCount := iProjCount + 1;
  end;
  for i := 0 to ctvProjects.Items.Count - 1 do
  begin
    if ctvProjects.Checked[ctvProjects.Items[i]] then
    begin
      if TDelphiProject(ctvProjects.Items[i].Data) <> nil then
      begin
        iStatus := iStatus + 1;
        iPercent := Round(iStatus * 100 / iProjCount);
        CompileProject(TDelphiProject(ctvProjects.Items[i].Data), clbOptions.Checked[0], iPercent);
      end;
    end;
  end;
end;

procedure TfrmMain.CompileProject(Project: TDelphiProject; bDebug: Boolean; iPercent: Integer);
var
  dCompiler: TDelphiCompiler;
  sSummary,sStatus: String;
  newItem: TSharpEListItem;
  dtStart,dtEnd,dtTotalEnd: TDateTime;
  iChars, i: Integer;
  sSplitter: String;
begin
  newItem := lbSummary.AddItem('Compiling ' + Project.Name + '...',2);
  lbSummary.ItemIndex := lbSummary.Count-1;
  Project.SIndex := lbSummary.Count -1;
  sSummary := lbSummary.Item[Project.SIndex].Caption;
  dtStart := Now;
  mDetailed.Lines.Add('Build started at ' + FormatDateTime('hh:nn:ss', dtStart));
  mDetailed.Lines.Add(sSummary);
  Project.DIndex := mDetailed.Lines.Count -1;

  dCompiler := TDelphiCompiler.Create;
  dCompiler.OnCompilerCmdOutput := CompilerNewLine;
  if dCompiler.CompileProject(Project, bDebug) then
  begin
    sStatus := 'Success! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 1;
    if bDebug then
      mDetailed.Lines.Add('Inserted ' + IntToStr(Project.DataSize) + ' bytes of debug data');
  end
  else
  begin
    sStatus := 'Failed! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 0;
  end;

  newItem.Caption := newItem.Caption + sStatus;
  dtEnd := Now;
  if LeftStr(sStatus, 8) = 'Success!' then
  begin
    mDetailed.Lines.Add('Finished at ' + FormatDateTime('hh:nn:ss', dtEnd) + '. Build took ' + FormatDateTime('hh:nn:ss', Frac(dtEnd) - Frac(dtStart)));
  end
  else
  begin
    Project.DIndex := mDetailed.Lines.Count - 1;
    mDetailed.Lines.Add('Build Failed!');
  end;

  iChars := Trunc(mDetailed.ClientWidth / Abs(Canvas.TextWidth('-')));
  sSplitter := '';
  for i := 0 to iChars - 3 do
    sSplitter := sSplitter + '-';
  mDetailed.Lines.Add(sSplitter);

  if iPercent = 100 then
  begin
    dtTotalEnd := Now;
    mDetailed.Lines.Add('Total build time was ' + FormatDateTime('hh:nn:ss', Frac(dtTotalEnd) - Frac(dtTotalStart)));
  end;
end;

procedure TfrmMain.CompilerNewLine(Sender: TObject; CmdOutput: string);
var
  sTemp: String;
begin
  sTemp := mDetailed.Lines[mDetailed.Lines.Count - 1];
  if (RightStr(sTemp, Length(sTemp) - 9) <> CmdOutput) and (CmdOutput <> '') then
    mDetailed.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + CmdOutput);
end;

procedure TfrmMain.ctvProjectsSelectionChange(Sender: TObject);
begin
  if ctvProjects.Selected.Data <> nil then
  begin
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
              mDetailed.Lines.Add('Loaded "' + Properties.Value('Name', 'error')
                + '" of type ' + Properties.Value('Type', 'Application') + ' which requires '
                + Properties.Value('Requ', 'Turbo Delphi Explorer 2006'));
            end;
        end;
      lbSummary.AddItem('Loaded ' + ExtractFileName(dlgOpen.FileName), 2);
	  end;
  end;
end;

end.
