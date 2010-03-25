unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Contnrs, SharpERoundPanel, StdCtrls, JvExComCtrls,
  SharpETabList, ImgList, uVistaFuncs,
  JclSimpleXML, JvComCtrls, JvCheckTreeView, CheckLst, JvExCheckLst,
  JvCheckListBox, JvStatusBar, JvExStdCtrls, JvMemo, uCompiler, SharpEListBoxEx,
  SharpEPageControl, PngImageList, StrUtils, JvExControls, ToolWin;

type
  TCompileThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
  end;

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
    ilToolbar: TImageList;
    dlgOpen: TOpenDialog;
    ctvProjects: TJvCheckTreeView;
    clbOptions: TJvCheckListBox;
    sepLog: TSharpEPageControl;
    mDetailed: TJvMemo;
    splMain: TSplitter;
    lbSummary: TSharpEListBoxEx;
    pilStatus: TPngImageList;
    pilStates: TPngImageList;
    dlgSave: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure stlMainTabClick(ASender: TObject; const ATabIndex: Integer);
    procedure tbClearClick(Sender: TObject);
    procedure tbCompileClick(Sender: TObject);
    procedure mDetailedChange(Sender: TObject);
    procedure mSummary_Change(Sender: TObject);
    procedure ctvProjectsSelectionChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbSummaryDblClickItem(Sender: Tobject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbSummaryGetCellColor(Sender: TObject;
      const AItem: TSharpEListItem; var AColor: TColor);
    procedure lbSummaryGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbSummaryClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbSummaryGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure clbOptionsClick(Sender: TObject);
  private
    FCompileThread : TCompileThread;

    procedure CompilerNewLine(Sender: TObject; CmdOutput: string);
    procedure CompileProject(Project: TCSharpSolution; bDebug : Boolean; iPercent : Integer); overload;
    procedure CompileProject(Project: TDelphiProject; bDebug: Boolean; iPercent: Integer); overload;
    procedure CompileProject(Project: TResourceBat; bDebug: Boolean; iPercent: Integer); overload;
    procedure OpenFile(sXML: String);
    procedure SaveSettings();
    procedure LoadSettings();
    procedure ShowErrorDetail(AItem: TSharpEListItem);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  sPath: String;
  sSettingsFile: String;
  bDebug: Boolean;
  sXMLPath : string;
  
implementation

{$R *.dfm}

function IsClassName(pData : Pointer; name : string) : Boolean;
var
  ClassRef : TClass;
begin
  ClassRef := TObject(pData).ClassType;
  Result := ClassRef.ClassNameIs(name);
end;

function GetDetailIndex(pData : Pointer) : Integer;
begin
  if IsClassName(pData, 'TCSharpSolution') then
    Result := TCSharpSolution(pData).DetailIndex
  else if IsClassName(pData, 'TResourceBat') then
    Result := TResourceBat(pData).DetailIndex
  else
    Result := TDelphiProject(pData).DIndex;
end;

procedure Log(msg : string);
begin
  frmMain.mDetailed.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + msg);
end;

procedure InsertSplitter();
var
  i, c : Integer;
  sSplitter : string;
begin
  c := Trunc(frmMain.mDetailed.ClientWidth / Abs(frmMain.Canvas.TextWidth('-')));
  sSplitter := '';
  for i := 0 to c - 3 do
    sSplitter := sSplitter + '-';

  frmMain.mDetailed.Lines.Add(sSplitter);
end;

constructor TCompileThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
end;

procedure TCompileThread.Execute;
var
  i,iProjCount,iStatus: integer;
  iPercent: integer;
  sPackage: String;
  buildStart, buildEnd : TDateTime;
begin
  frmMain.tbCompile.Caption := 'Cancel';
  frmMain.tbCompile.ImageIndex := 4;

  iProjCount := 0;
  iStatus := 0;
  sPackage := '';
  buildStart := Now;

  for i := 0 to frmMain.ctvProjects.Items.Count - 1 do
  begin
    if frmMain.ctvProjects.Checked[frmMain.ctvProjects.Items[i]] then
      if not frmMain.ctvProjects.Items[i].HasChildren then
        iProjCount := iProjCount + 1;
  end;

  Log('Building ' + IntToStr(iProjCount) + ' projects/solutions.');
  InsertSplitter;
  
  for i := 0 to frmMain.ctvProjects.Items.Count - 1 do
  begin
    if Terminated then
      break;

    if frmMain.ctvProjects.Checked[frmMain.ctvProjects.Items[i]] then
    begin
      if frmMain.ctvProjects.Items[i].Data <> nil then
      begin
        iStatus := iStatus + 1;
        iPercent := Round(iStatus * 100 / iProjCount);

        if IsClassName(frmMain.ctvProjects.Items[i].Data, 'TCSharpSolution') then
        begin
          if sPackage <> TCSharpSolution(frmMain.ctvProjects.Items[i].Data).Package then
          begin
            sPackage := TCSharpSolution(frmMain.ctvProjects.Items[i].Data).Package;
            frmMain.lbSummary.AddItem(sPackage);
          end;
          frmMain.CompileProject(TCSharpSolution(frmMain.ctvProjects.Items[i].Data), frmMain.clbOptions.Checked[0], iPercent);
        end
        else if IsClassName(frmMain.ctvProjects.Items[i].Data, 'TDelphiProject') then
        begin
          if sPackage <> TDelphiProject(frmMain.ctvProjects.Items[i].Data).Package then
          begin
            sPackage := TDelphiProject(frmMain.ctvProjects.Items[i].Data).Package;
            frmMain.lbSummary.AddItem(sPackage);
          end;
          frmMain.CompileProject(TDelphiProject(frmMain.ctvProjects.Items[i].Data), frmMain.clbOptions.Checked[0], iPercent);
        end
        else if IsClassName(frmMain.ctvProjects.Items[i].Data, 'TResourceBat') then
        begin
          if sPackage <> TResourceBat(frmMain.ctvProjects.Items[i].Data).Package then
          begin
            sPackage := TResourceBat(frmMain.ctvProjects.Items[i].Data).Package;
            frmMain.lbSummary.AddItem(sPackage);
          end;
          frmMain.CompileProject(TResourceBat(frmMain.ctvProjects.Items[i].Data), frmMain.clbOptions.Checked[0], iPercent);
        end;
      end;
    end;
  end;
  
  buildEnd := Now;
  if Terminated then
    Log('Build canceled.')
  else
    Log('Build finished.');
  Log('Total build time was ' + FormatDateTime('hh:nn:ss', Frac(buildEnd) - Frac(buildStart)));

  frmMain.tbCompile.Caption := 'Compile';
  frmMain.tbCompile.ImageIndex := 3;

  Self.Terminate;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  uVistaFuncs.SetVistaFonts(frmMain);
  lbSummary.DoubleBuffered := True;
  sepLog.DoubleBuffered := True;
  panMain.DoubleBuffered := True;
  ForceDirectories('.\Settings\Global\SharpCompile');
  sSettingsFile := 'Settings\Global\SharpCompile\Settings.xml';
  LoadSettings;
  
  if ParamStr(1) <> '' then
    sXMLPath := ParamStr(1);

  OpenFile(sXMLPath);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if FCompileThread <> nil then
  begin
    FCompileThread.Terminate;
    FCompileThread.WaitFor;
    FreeAndNil(FCompileThread);
  end;

  SaveSettings;
end;

procedure TfrmMain.lbSummaryClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  if ACol = 1 then
    if Pos('Failed!', AItem.Caption) <> 0 then
      ShowErrorDetail(AItem);
end;

procedure TfrmMain.lbSummaryDblClickItem(Sender: Tobject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  ShowErrorDetail(AItem);
end;

procedure TfrmMain.lbSummaryGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.ImageIndex = 0 then
    AColor := $00ECECFF else
  if AItem.ImageIndex = -1 then
    AColor := $00FBEFE3;
end;

procedure TfrmMain.lbSummaryGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol = 1 then
    if Pos('Failed!', AItem.Caption) <> 0 then
      ACursor := crHandPoint;
end;

procedure TfrmMain.lbSummaryGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
begin
  if ACol = 1 then
    if Pos('Failed!', AItem.Caption) <> 0 then
      AImageIndex := 3;
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
begin
  if (FCompileThread <> nil) and (not FCompileThread.Terminated) then
  begin
    FCompileThread.Terminate;
    FCompileThread.WaitFor;
    FreeAndNil(FCompileThread);
  end else
  begin
    if FCompileThread <> nil then
    begin
      FreeAndNil(FCompileThread);
    end;

    if FCompileThread = nil then
      FCompileThread := TCompileThread.Create(True);

    FCompileThread.Resume;
  end;
end;

procedure TfrmMain.CompileProject(Project: TCSharpSolution; bDebug: Boolean; iPercent: Integer);
var
  compiler : TCSharpCompiler;
  status : string;
  newItem: TSharpEListItem;
  succeeded : Boolean;
  buildStart, buildEnd : TDateTime;
begin
  newItem := lbSummary.AddItem('Compiling ' + Project.Name + '...',2);
  newItem.AddSubItem('');

  lbSummary.ItemIndex := lbSummary.Count - 1;
  Project.SummaryIndex := lbSummary.Count - 1;
  
  compiler := TCSharpCompiler.Create;
  compiler.OnCompilerCmdOutput := CompilerNewLine;
  
  buildStart := Now;
  Log('Build for ' + Project.Name + ' started at ' + FormatDateTime('hh:nn:ss', buildStart));

  Project.DetailIndex := mDetailed.Lines.Count - 1;
  
  succeeded := compiler.CompileSolution(Project, bDebug);
  buildEnd := Now;

  if succeeded then
  begin
    status := 'Success! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 1;
    Log('Build for ' + Project.Name + ' finished at ' + FormatDateTime('hh:nn:ss', buildEnd));
    Log('Build took ' + FormatDateTime('hh:nn:ss', Frac(buildEnd) - Frac(buildStart)));
  end
  else
  begin
    status := 'Failed! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 0;
    Log('Build for ' + Project.Name + ' Failed!');
  end;

  Project.DetailIndex := mDetailed.Lines.Count - 1;
  newItem.Caption := newItem.Caption + status;

  InsertSplitter;
end;

procedure TfrmMain.CompileProject(Project: TDelphiProject; bDebug: Boolean; iPercent: Integer);
var
  dCompiler: TDelphiCompiler;
  sStatus: String;
  newItem: TSharpEListItem;
  dtStart, dtEnd : TDateTime;
  succeeded : Boolean;
begin
  newItem := lbSummary.AddItem('Compiling ' + Project.Name + '...',2);
  newItem.AddSubItem('');
  lbSummary.ItemIndex := lbSummary.Count-1;
  Project.SIndex := lbSummary.Count -1;

  dtStart := Now;
  Log('Build for ' + Project.Name + ' started at ' + FormatDateTime('hh:nn:ss', dtStart));

  Project.DIndex := mDetailed.Lines.Count -1;

  dCompiler := TDelphiCompiler.Create;
  dCompiler.OnCompilerCmdOutput := CompilerNewLine;

  succeeded := dCompiler.CompileProject(Project, bDebug);
  dtEnd := Now;

  if succeeded then
  begin
    sStatus := 'Success! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 1;
    if bDebug then
      Log('Inserted ' + IntToStr(Project.DataSize) + ' bytes of debug data');

    Log('Build for ' + Project.Name + ' finished.');
    Log('Build took ' + FormatDateTime('hh:nn:ss', Frac(dtEnd) - Frac(dtStart)));
  end
  else
  begin
    sStatus := 'Failed! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 0;
    Log('Build for ' + Project.Name + ' Failed!');
  end;

  Project.DIndex := mDetailed.Lines.Count - 1;
  newItem.Caption := newItem.Caption + sStatus;

  InsertSplitter;
end;

procedure TfrmMain.clbOptionsClick(Sender: TObject);
begin
  bDebug := clbOptions.Checked[0];
end;

procedure TfrmMain.CompileProject(Project: TResourceBat; bDebug: Boolean; iPercent: Integer);
var
  compiler : TResourceCompiler;
  status : string;
  newItem: TSharpEListItem;
  succeeded : Boolean;
  buildStart, buildEnd : TDateTime;
begin
  newItem := lbSummary.AddItem('Compiling ' + Project.Name + '...',2);
  newItem.AddSubItem('');

  lbSummary.ItemIndex := lbSummary.Count - 1;
  Project.SummaryIndex := lbSummary.Count - 1;
  
  compiler := TResourceCompiler.Create;
  compiler.OnCompilerCmdOutput := CompilerNewLine;
  
  buildStart := Now;
  Log('Build for ' + Project.Name + ' started at ' + FormatDateTime('hh:nn:ss', buildStart));

  Project.DetailIndex := mDetailed.Lines.Count - 1;
  
  succeeded := compiler.CompileBat(Project);
  buildEnd := Now;

  if succeeded then
  begin
    status := 'Success! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 1;
    Log('Build for ' + Project.Name + ' finished at ' + FormatDateTime('hh:nn:ss', buildEnd));
    Log('Build took ' + FormatDateTime('hh:nn:ss', Frac(buildEnd) - Frac(buildStart)));
  end
  else
  begin
    status := 'Failed! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 0;
    Log('Build for ' + Project.Name + ' Failed!');
  end;

  Project.DetailIndex := mDetailed.Lines.Count - 1;
  newItem.Caption := newItem.Caption + status;

  InsertSplitter;
end;

procedure TfrmMain.CompilerNewLine(Sender: TObject; CmdOutput: string);
var
  sTemp: String;
begin
  sTemp := mDetailed.Lines[mDetailed.Lines.Count - 1];
  if (RightStr(sTemp, Length(sTemp) - 9) <> CmdOutput) and (CmdOutput <> '') then
    Log(CmdOutput);
end;

procedure TfrmMain.ctvProjectsSelectionChange(Sender: TObject);
begin
  if ctvProjects.Selected.Data <> nil then
  begin
    mDetailed.Perform(EM_LINESCROLL, 0, 0 - mDetailed.Lines.Count);
    mDetailed.Perform(EM_LINESCROLL, 0, GetDetailIndex(ctvProjects.Selected.Data));
  end;
end;

procedure TfrmMain.OpenFile(sXML: String);
var
  n,i: integer;
  xFile: TJclSimpleXML;
  nProject,nComponent: TTreeNode;
  sPackage: String;
  sProjectName, sProjectType, sPlatform : string;
begin
  ctvProjects.Items.Clear;
  xFile := TJclSimpleXML.Create;
  try
    if FileExists(sXML) then
    begin
      sPath := IncludeTrailingPathDelimiter(ExtractFileDir(sXML));
      xFile.LoadFromFile(sXML);
      for n := 0 to xFile.Root.Items.Count - 1 do
        with xFile.Root.Items.Item[n] do
        begin
          sPackage := Properties.Value('Name', 'error');
          nProject := ctvProjects.Items.Add(nil, sPackage);
          nProject.Data := nil;
          ctvProjects.SetChecked(nProject, True);
          for i := 0 to Items.Count - 1 do
            with Items.Item[i] do
            begin
              sProjectName := Properties.Value('Name', 'error');
              sProjectType := Properties.Value('Type', 'Application');
              sPlatform := Properties.Value('Platform', '');
              nComponent := ctvProjects.Items.AddChild(nProject, sProjectName);

              if sProjectType = 'Solution' then
              begin
                nComponent.Data := TCSharpSolution.Create(sPath + Value, sProjectName, sPlatform);
                TCSharpSolution(nComponent.Data).Package := sPackage;
              end
              else if sProjectType = 'Resource' then
              begin
                nComponent.Data := TResourceBat.Create(sPath + Value, sProjectName);
                TCSharpSolution(nComponent.Data).Package := sPackage;
              end
              else
              begin
                nComponent.Data := TDelphiProject.Create(sPath + Value, sProjectName);
                TDelphiProject(nComponent.Data).Package := sPackage;
              end;
              
              ctvProjects.SetChecked(nComponent, True);
              Log('Loaded "' + sProjectName
                + '" of type ' + sProjectType + ' which requires '
                + Properties.Value('Requ', 'Delphi 2007'));
            end;
        end;
      lbSummary.AddItem('Loaded ' + ExtractFileName(sXML), 2);
	  end;
    InsertSplitter;
  finally
    xFile.Free;
  end;
end;

procedure TfrmMain.tbOpenClick(Sender: TObject);
begin
  if FileExists(sXMLPath) then
  begin
    dlgOpen.InitialDir := ExtractFileDir(sXMLPath);
    dlgOpen.FileName := ExtractFileName(sXMLPath);
  end;
  if dlgOpen.Execute then
  begin
    OpenFile(dlgOpen.FileName);
    sXMLPath := dlgOpen.FileName;
  end;
end;

procedure TfrmMain.LoadSettings();
var
  xFile: TJclSimpleXML;
begin
  if FileExists(sSettingsFile) then
  begin
    xFile := TJclSimpleXML.Create;
    try
      xFile.LoadFromFile(sSettingsFile);
      if xFile.Root.Items.ItemNamed['Options'] <> nil then
        with xFile.Root.Items.ItemNamed['Options'] do
        begin
          bDebug := Properties.BoolValue('Debug', False);
          clbOptions.Checked[0] := bDebug;
          sXMLPath := Properties.Value('XMLPath', '');
        end;
    finally
      xFile.Free;
    end;
  end
  else
  begin
    bDebug := False;
    SaveSettings;
  end;
end;

procedure TfrmMain.ShowErrorDetail(AItem: TSharpEListItem);
var
  iPos: Integer;
  i: Integer;
  sProjName: string;
begin
  if pos('Compiling', AItem.Caption) <> 0 then
  begin
    sProjName := RightStr(AItem.Caption, Length(AItem.Caption) - 10);
    sProjName := LeftStr(sProjName, Pos('...', sProjName) - 1);
    for i := 0 to ctvProjects.Items.Count - 1 do
    begin
      if ctvProjects.Items[i].Text = sProjName then
      begin
        mDetailed.Perform(EM_LINESCROLL, 0, 0 - mDetailed.Lines.Count);

        iPos := GetDetailIndex(ctvProjects.Items[i].Data);

        if Pos('Failed!', AItem.Caption) <> 0 then
          iPos := iPos - Trunc(mDetailed.Height / Abs(Canvas.TextHeight('Wg')) - 1);
        mDetailed.Perform(EM_LINESCROLL, 0, iPos);
        sepLog.TabIndex := 1;
        lbSummary.Visible := False;
        mDetailed.Visible := True;
      end;
    end;
  end;
end;

procedure TfrmMain.SaveSettings();
var
  xFile: TJclSimpleXML;
begin
  SetCurrentDirectory(PChar(ExtractFilePath(ParamStr(0))));
  xFile := TJclSimpleXML.Create;
  try
    xFile.Root.Name := 'SharpCompile';
    with xFile.Root.Items.Add('Options') do
    begin
      Properties.Add('Debug', bDebug);
      Properties.Add('XMLPath', sXMLPath);
    end;
    xFile.SaveToFile(sSettingsFile);
  finally
    xFile.Free;
  end
end;

end.
