unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Contnrs, SharpERoundPanel, StdCtrls, JvExComCtrls,
  SharpETabList, ImgList, uVistaFuncs,
  JclSimpleXML, JvComCtrls, JvCheckTreeView, CheckLst, JvExCheckLst,
  JvCheckListBox, JvStatusBar, JvExStdCtrls, JvMemo, uCompiler, SharpEListBoxEx,
  SharpEPageControl, PngImageList, StrUtils, JvExControls, ToolWin,
  JclFileUtils, JclCompression, Buttons;

type
  TCompileThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
  end;

  TSharpCompileMainWnd = class(TForm)
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
    panSelection: TPanel;
    btnToggleChecks: TButton;
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
    procedure btnToggleChecksClick(Sender: TObject);
  private
    FCompileThread : TCompileThread;

    procedure CompilerNewLine(Sender: TObject; CmdOutput: string);
    procedure CompileProject(Project: TCSharpSolution; bDebug : Boolean; iPercent : Integer); overload;
    procedure CompileProject(Project: TDelphiProject; bDebug: Boolean; iPercent: Integer); overload;
    procedure CompileProject(Project: TResourceBat; bDebug: Boolean; iPercent: Integer); overload;
    procedure ExecuteCommand(cmd: TCommand; iPercent: Integer);
    procedure OpenFile(sXML: String);
    procedure SaveSettings();
    procedure LoadSettings();
    procedure ShowErrorDetail(AItem: TSharpEListItem);
    procedure UpdateCaption;
    procedure SetCheckedState(checked : Boolean);
  public
    { Public declarations }
  end;

var
  SharpCompileMainWnd: TSharpCompileMainWnd;
  sPath: String;
  sSettingsFile: String;
  bDebug: Boolean;
  bClean : Boolean;
  bZip : Boolean;
  bDev : Boolean;
  sOutputPath : string;
  sVersion : string;
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
  SharpCompileMainWnd.mDetailed.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + msg);
end;

procedure InsertSplitter();
var
  i, c : Integer;
  w : integer;
  sSplitter : string;
begin
  try
    w := Abs(SharpCompileMainWnd.Canvas.TextWidth('-'));
    if w <= 0 then
      w := 200;
    c := Trunc(SharpCompileMainWnd.mDetailed.ClientWidth / w);
    if c < 3 then
      c := 3;

    sSplitter := '';
    for i := 0 to c - 3 do
      sSplitter := sSplitter + '-';

    SharpCompileMainWnd.mDetailed.Lines.Add(sSplitter);
  except
  end;
end;

procedure ZipDirectory(directory : string; filePath : string);
var
  archive: TJcl7zCompressArchive;
  sr : TSearchRec;
begin
  {$WARNINGS OFF} directory := IncludeTrailingBackslash(directory); {$WARNINGS ON}

  archive := TJcl7zCompressArchive.Create(filepath);
  try
    if FindFirst(directory + '*.*', faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          if (sr.Attr and faDirectory) <> 0 then
            archive.AddDirectory(sr.Name, directory + sr.Name, True, True)
          else
            archive.AddFile(sr.Name, directory + sr.Name);
        end;
      until FindNext(sr) <> 0;
      
      FindClose(sr);
    end;

    archive.Compress;
  finally
    archive.Free;
  end;
end;

procedure UpdateVersionInfoFile(path : string);
var
  versionInfoFilePath : string;
  versionInfoBackupFilePath : string;
  versionInfoFile : TextFile;
  versionInfoBackupFile : TextFile;
  line : string;
begin
  if bDev then
    Exit;
    
  versionInfoFilePath := IncludeTrailingBackslash(path) + 'VersionInfo.rc';
  versionInfoBackupFilePath := versionInfoFilePath + '.bak';

  if FileExists(versionInfoFilePath) then
  begin
    FileCopy(versionInfoFilePath, versionInfoBackupFilePath, True);

    AssignFile(versionInfoFile, versionInfoFilePath);
    AssignFile(versionInfoBackupFile, versionInfoBackupFilePath);
    try
      Rewrite(versionInfoFile);
      Reset(versionInfoBackupFile);
      while not Eof(versionInfoBackupFile) do
      begin
        Readln(versionInfoBackupFile, line);
        // The version in the build xml should be using '.' for seprators.
        // We replace 0.0.0.0 with the version from the xml.
        line := ReplaceStr(line, '0.0.0.0', sVersion);
        // We also replace 0,0,0,0 with the version from the xml but adjusted
        // to use ',' as a separator instead of '.'.
        line := ReplaceStr(line, '0,0,0,0', ReplaceStr(sVersion, '.', ','));
        Writeln(versionInfoFile, line);
      end;
    finally
      CloseFile(versionInfoFile);
      CloseFile(versionInfoBackupFile);
    end;
  end;
end;

procedure RestoreVersionInfoFile(path : string);
var
  versionInfoFilePath : string;
  versionInfoBackupFilePath : string;
begin
  if bDev then
    Exit;
    
  versionInfoFilePath := IncludeTrailingBackslash(path) + 'VersionInfo.rc';
  versionInfoBackupFilePath := versionInfoFilePath + '.bak';
  
  if FileExists(versionInfoBackupFilePath) then
  begin
    FileCopy(versionInfoBackupFilePath, versionInfoFilePath, True);
    FileDelete(versionInfoBackupFilePath);
  end;
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
  SharpCompileMainWnd.tbCompile.Caption := 'Cancel';
  SharpCompileMainWnd.tbCompile.ImageIndex := 4;

  iProjCount := 0;
  iStatus := 0;
  sPackage := '';
  buildStart := Now;

  for i := 0 to SharpCompileMainWnd.ctvProjects.Items.Count - 1 do
  begin
    if SharpCompileMainWnd.ctvProjects.Checked[SharpCompileMainWnd.ctvProjects.Items[i]] then
      if not SharpCompileMainWnd.ctvProjects.Items[i].HasChildren then
        iProjCount := iProjCount + 1;
  end;

  Log('Building ' + IntToStr(iProjCount) + ' projects/solutions.');
  InsertSplitter;

  if (bClean) and (not Terminated) then
  begin
    Log('Cleaning output directory "' + sOutputPath + '"');
    DelTree(sOutputPath);
  end;

  for i := 0 to SharpCompileMainWnd.ctvProjects.Items.Count - 1 do
  begin
    if Terminated then
      break;
    sleep(50); // give a little time between projects

    if SharpCompileMainWnd.ctvProjects.Checked[SharpCompileMainWnd.ctvProjects.Items[i]] then
    begin
      if SharpCompileMainWnd.ctvProjects.Items[i].Data <> nil then
      begin
        iStatus := iStatus + 1;
        iPercent := Round(iStatus * 100 / iProjCount);

        if IsClassName(SharpCompileMainWnd.ctvProjects.Items[i].Data, 'TCSharpSolution') then
        begin
          if sPackage <> TCSharpSolution(SharpCompileMainWnd.ctvProjects.Items[i].Data).Package then
          begin
            sPackage := TCSharpSolution(SharpCompileMainWnd.ctvProjects.Items[i].Data).Package;
            SharpCompileMainWnd.lbSummary.AddItem(sPackage);
          end;
          SharpCompileMainWnd.CompileProject(TCSharpSolution(SharpCompileMainWnd.ctvProjects.Items[i].Data), SharpCompileMainWnd.clbOptions.Checked[0], iPercent);
        end
        else if IsClassName(SharpCompileMainWnd.ctvProjects.Items[i].Data, 'TDelphiProject') then
        begin
          if sPackage <> TDelphiProject(SharpCompileMainWnd.ctvProjects.Items[i].Data).Package then
          begin
            sPackage := TDelphiProject(SharpCompileMainWnd.ctvProjects.Items[i].Data).Package;
            SharpCompileMainWnd.lbSummary.AddItem(sPackage);
          end;
          SharpCompileMainWnd.CompileProject(TDelphiProject(SharpCompileMainWnd.ctvProjects.Items[i].Data), SharpCompileMainWnd.clbOptions.Checked[0], iPercent);
        end
        else if IsClassName(SharpCompileMainWnd.ctvProjects.Items[i].Data, 'TResourceBat') then
        begin
          if sPackage <> TResourceBat(SharpCompileMainWnd.ctvProjects.Items[i].Data).Package then
          begin
            sPackage := TResourceBat(SharpCompileMainWnd.ctvProjects.Items[i].Data).Package;
            SharpCompileMainWnd.lbSummary.AddItem(sPackage);
          end;
          SharpCompileMainWnd.CompileProject(TResourceBat(SharpCompileMainWnd.ctvProjects.Items[i].Data), SharpCompileMainWnd.clbOptions.Checked[0], iPercent);
        end
        else if IsClassName(SharpCompileMainWnd.ctvProjects.Items[i].Data, 'TCommand') then
        begin
          if sPackage <> TCommand(SharpCompileMainWnd.ctvProjects.Items[i].Data).Package then
          begin
            sPackage := TCommand(SharpCompileMainWnd.ctvProjects.Items[i].Data).Package;
            SharpCompileMainWnd.lbSummary.AddItem(sPackage);
          end;
          SharpCompileMainWnd.ExecuteCommand(TCommand(SharpCompileMainWnd.ctvProjects.Items[i].Data), iPercent);
        end;
      end;
    end;
  end;

  if (bZip) and (not Terminated) then
  begin
    Log('Zipping contents of output directory.');
    ZipDirectory(sOutputPath, '..\SharpE_Builds\SharpE-' + FormatDateTime('yyyymmddhhnnss', Now) + '.7z');
  end;
  
  buildEnd := Now;
  if Terminated then
    Log('Build canceled.')
  else
    Log('Build finished.');
  Log('Total build time was ' + FormatDateTime('hh:nn:ss', Frac(buildEnd) - Frac(buildStart)));

  SharpCompileMainWnd.tbCompile.Caption := 'Compile';
  SharpCompileMainWnd.tbCompile.ImageIndex := 3;

  Self.Terminate;
end;

procedure TSharpCompileMainWnd.FormCreate(Sender: TObject);
begin
  uVistaFuncs.SetVistaFonts(SharpCompileMainWnd);
  lbSummary.DoubleBuffered := True;
  sepLog.DoubleBuffered := True;
  panMain.DoubleBuffered := True;
  {$WARN SYMBOL_PLATFORM OFF} sSettingsFile := IncludeTrailingBackSlash(ExtractFileDir(Application.ExeName)) + 'SharpCompile-Settings.xml'; {$WARN SYMBOL_PLATFORM ON}
  LoadSettings;
  
  if ParamStr(1) <> '' then
    sXMLPath := ParamStr(1);

  OpenFile(sXMLPath);
end;

procedure TSharpCompileMainWnd.FormDestroy(Sender: TObject);
begin
  if FCompileThread <> nil then
  begin
    FCompileThread.Terminate;
    FCompileThread.WaitFor;
    FreeAndNil(FCompileThread);
  end;

  SaveSettings;
end;

procedure TSharpCompileMainWnd.lbSummaryClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  if ACol = 1 then
    if Pos('Failed!', AItem.Caption) <> 0 then
      ShowErrorDetail(AItem);
end;

procedure TSharpCompileMainWnd.lbSummaryDblClickItem(Sender: Tobject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  ShowErrorDetail(AItem);
end;

procedure TSharpCompileMainWnd.lbSummaryGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.ImageIndex = 0 then
    AColor := $00ECECFF else
  if AItem.ImageIndex = -1 then
    AColor := $00FBEFE3;
end;

procedure TSharpCompileMainWnd.lbSummaryGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol = 1 then
    if Pos('Failed!', AItem.Caption) <> 0 then
      ACursor := crHandPoint;
end;

procedure TSharpCompileMainWnd.lbSummaryGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
begin
  if ACol = 1 then
    if Pos('Failed!', AItem.Caption) <> 0 then
      AImageIndex := 3;
end;

procedure TSharpCompileMainWnd.mDetailedChange(Sender: TObject);
begin
  mDetailed.Perform(EM_LINESCROLL, 0, mDetailed.Lines.Count);
end;

procedure TSharpCompileMainWnd.mSummary_Change(Sender: TObject);
begin
  lbSummary.Perform(EM_LINESCROLL, 0, lbSummary.Count);
end;

procedure TSharpCompileMainWnd.stlMainTabClick(ASender: TObject; const ATabIndex: Integer);
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

procedure TSharpCompileMainWnd.tbClearClick(Sender: TObject);
begin
  lbSummary.Clear;
  mDetailed.Clear;
end;

procedure TSharpCompileMainWnd.tbCompileClick(Sender: TObject);
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

procedure TSharpCompileMainWnd.CompileProject(Project: TCSharpSolution; bDebug: Boolean; iPercent: Integer);
var
  compiler : TCSharpCompiler;
  status : string;
  newItem: TSharpEListItem;
  succeeded : Boolean;
  buildStart, buildEnd : TDateTime;
begin
  LockWindowUpdate(Handle);
  newItem := lbSummary.AddItem('Compiling ' + Project.Name + '...',2);
  newItem.AddSubItem('');
  lbSummary.ItemIndex := lbSummary.Count - 1;
  Project.SummaryIndex := lbSummary.Count - 1;
  LockWindowUpdate(0);
    
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

procedure TSharpCompileMainWnd.CompileProject(Project: TDelphiProject; bDebug: Boolean; iPercent: Integer);
var
  dCompiler: TDelphiCompiler;
  sStatus: String;
  newItem: TSharpEListItem;
  dtStart, dtEnd : TDateTime;
  succeeded : Boolean;
begin
  LockWindowUpdate(Handle);
  newItem := lbSummary.AddItem('Compiling ' + Project.Name + '...',2);
  newItem.AddSubItem('');
  lbSummary.ItemIndex := lbSummary.Count-1;
  Project.SIndex := lbSummary.Count -1;
  LockWindowUpdate(0);
  
  dtStart := Now;
  Log('Build for ' + Project.Name + ' started at ' + FormatDateTime('hh:nn:ss', dtStart));

  Project.DIndex := mDetailed.Lines.Count -1;

  UpdateVersionInfoFile(Project.Dir);
  
  dCompiler := TDelphiCompiler.Create;
  dCompiler.OnCompilerCmdOutput := CompilerNewLine;

  succeeded := dCompiler.CompileProject(Project, bDebug);
  dtEnd := Now;

  RestoreVersionInfoFile(Project.Dir);
  
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

procedure TSharpCompileMainWnd.CompileProject(Project: TResourceBat; bDebug: Boolean; iPercent: Integer);
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

procedure TSharpCompileMainWnd.ExecuteCommand(cmd: TCommand; iPercent: Integer);
var
  compiler : TCommandRunner;
  status : string;
  newItem: TSharpEListItem;
  succeeded : Boolean;
  buildStart, buildEnd : TDateTime;
begin
  newItem := lbSummary.AddItem('Compiling ' + cmd.Name + '...',2);
  newItem.AddSubItem('');

  lbSummary.ItemIndex := lbSummary.Count - 1;
  cmd.SummaryIndex := lbSummary.Count - 1;
  
  compiler := TCommandRunner.Create;
  compiler.OnCompilerCmdOutput := CompilerNewLine;
  
  buildStart := Now;
  Log('Build for ' + cmd.Name + ' started at ' + FormatDateTime('hh:nn:ss', buildStart));

  cmd.DetailIndex := mDetailed.Lines.Count - 1;
  
  succeeded := compiler.Execute(cmd);
  buildEnd := Now;

  if succeeded then
  begin
    status := 'Success! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 1;
    Log('Build for ' + cmd.Name + ' finished at ' + FormatDateTime('hh:nn:ss', buildEnd));
    Log('Build took ' + FormatDateTime('hh:nn:ss', Frac(buildEnd) - Frac(buildStart)));
  end
  else
  begin
    status := 'Failed! (' + IntToStr(iPercent) + '%)';
    newItem.ImageIndex := 0;
    Log('Build for ' + cmd.Name + ' Failed!');
  end;

  cmd.DetailIndex := mDetailed.Lines.Count - 1;
  newItem.Caption := newItem.Caption + status;

  InsertSplitter;
end;

procedure TSharpCompileMainWnd.CompilerNewLine(Sender: TObject; CmdOutput: string);
var
  sTemp: String;
begin
  sTemp := mDetailed.Lines[mDetailed.Lines.Count - 1];
  if (RightStr(sTemp, Length(sTemp) - 9) <> CmdOutput) and (CmdOutput <> '') then
    Log(CmdOutput);
end;

procedure TSharpCompileMainWnd.SetCheckedState(checked : Boolean);
var
  node : TTreeNode;
begin
  for node in ctvProjects.Items do
  begin
    ctvProjects.SetChecked(node, checked);
  end;
end;

procedure TSharpCompileMainWnd.btnToggleChecksClick(Sender: TObject);
var
  checked : Boolean;
begin
  checked := not Bool(btnToggleChecks.Tag);

  SetCheckedState(checked);
  btnToggleChecks.Tag := Integer(checked);
  
  if checked then
    btnToggleChecks.Caption := 'Uncheck All'
  else
    btnToggleChecks.Caption := 'Check All';
end;

procedure TSharpCompileMainWnd.clbOptionsClick(Sender: TObject);
begin
  bDebug := clbOptions.Checked[0];
  bZip := clbOptions.Checked[1];
  bClean := clbOptions.Checked[2];
  bDev := clbOptions.Checked[3];
  UpdateCaption;
end;

procedure TSharpCompileMainWnd.ctvProjectsSelectionChange(Sender: TObject);
begin
  if ctvProjects.Selected.Data <> nil then
  begin
    mDetailed.Perform(EM_LINESCROLL, 0, 0 - mDetailed.Lines.Count);
    mDetailed.Perform(EM_LINESCROLL, 0, GetDetailIndex(ctvProjects.Selected.Data));
  end;
end;

procedure TSharpCompileMainWnd.OpenFile(sXML: String);
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
      SetCurrentDirectory(PChar(sPath));
      xFile.LoadFromFile(sXML);
      for n := 0 to xFile.Root.Items.Count - 1 do
      begin
        sOutputPath := xFile.Root.Properties.Value('OutputPath', '..\SharpE');
        sVersion := xFile.Root.Properties.Value('Version', '0.0.0.0');
        UpdateCaption;
        with xFile.Root.Items.Item[n] do
        begin
          sPackage := Items.Item[0].Name;
          sPackage := Properties.Value('Name', 'error');
          nProject := ctvProjects.Items.Add(nil, sPackage);
          nProject.Data := nil;
          ctvProjects.SetChecked(nProject, True);
          for i := 0 to Items.Count - 1 do
            with Items.Item[i] do
            begin
              // Skip lines that are comments.
              if Name = '' then
                Continue;

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
                TResourceBat(nComponent.Data).Package := sPackage;
              end
              else if sProjectType = 'CommandLine' then
              begin
                nComponent.Data := TCommand.Create(sPath, sProjectName, Value);
                TCommand(nComponent.Data).Package := sPackage;
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
      end;
      lbSummary.AddItem('Loaded ' + ExtractFileName(sXML), 2);
	  end;
    InsertSplitter;
  finally
    xFile.Free;
  end;
end;

procedure TSharpCompileMainWnd.tbOpenClick(Sender: TObject);
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

procedure TSharpCompileMainWnd.LoadSettings();
var
  xFile: TJclSimpleXML;
begin
  if not FileExists(sSettingsFile) then
    Exit;

  xFile := TJclSimpleXML.Create;
  try
    xFile.LoadFromFile(sSettingsFile);
    if xFile.Root.Items.ItemNamed['Options'] <> nil then
      with xFile.Root.Items.ItemNamed['Options'] do
      begin
        bDebug := Properties.BoolValue('Debug', False);
        clbOptions.Checked[0] := bDebug;
        bZip := Properties.BoolValue('Zip', False);
        clbOptions.Checked[1] := bZip;
        bClean := Properties.BoolValue('Clean', False);
        clbOptions.Checked[2] := bClean;
        bDev := Properties.BoolValue('Dev', True);
        clbOptions.Checked[3] := bDev;
        sXMLPath := Properties.Value('XMLPath', '');
      end;
  finally
    xFile.Free;
  end;
end;

procedure TSharpCompileMainWnd.ShowErrorDetail(AItem: TSharpEListItem);
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

procedure TSharpCompileMainWnd.SaveSettings();
var
  xFile: TJclSimpleXML;
begin
  if not ForceDirectories(ExtractFileDir(sSettingsFile)) then
    Exit;
    
  xFile := TJclSimpleXML.Create;
  try
    xFile.Root.Name := 'SharpCompile';
    with xFile.Root.Items.Add('Options') do
    begin
      Properties.Add('Debug', bDebug);
      Properties.Add('Zip', bZip);
      Properties.Add('Clean', bClean);
      Properties.Add('Dev', bDev);
      Properties.Add('XMLPath', sXMLPath);
    end;
    xFile.SaveToFile(sSettingsFile);
  finally
    xFile.Free;
  end
end;

procedure TSharpCompileMainWnd.UpdateCaption;
begin
  if bDev then
    Caption := 'Sharp Compile - Dev Version'
  else
    Caption := 'Sharp Compile - Version ' + sVersion;
end;

end.
