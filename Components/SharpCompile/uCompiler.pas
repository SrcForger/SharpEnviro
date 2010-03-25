{
Source Name: uCompiler.pas
Description: Revised Unit for compiling delphi projects by using the command line compiler
Original Copyright (C) Martin Krämer (MartinKraemer@gmx.net)
Revision Copyright (C) Nathan LaFreniere (quitlahok@gmail.com)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit uCompiler;

interface

uses
  SysUtils,Windows,Registry,Classes,DateUtils,
  JvSimpleXML,JclFileUtils,JclSysInfo,DosCommand,
  JclDebug,StrUtils,XMLDoc;

type
  TCompileEvent = procedure(Sender: TObject; CmdOutput: string) of object;
  {$M+}
  TCSharpSolution = class
  private
    FName : string;
    FPath : string;
    FPackage : string;
    FSummaryIndex : Integer;
    FDetailIndex : Integer;
    FPlatform : string;
  public
    property Name : string read FName;
    property Path : string read FPath;
    property Package : string read FPackage write FPackage;
    property SummaryIndex : Integer read FSummaryIndex write FSummaryIndex;
    property DetailIndex : Integer read FDetailIndex write FDetailIndex;
    property Platform : string read FPlatform;
  published
    constructor Create(csharpSolutionFile : string; name, platform : string); reintroduce;
    destructor Destroy; override;
  end;

  TDelphiProject = class
  private
    FSearchPath   : String;
    FDebugSearchPath : String;
    FUsePackages  : Boolean;
    FPackages     : String;
    FOutputDir    : String;
    FDebugOutputDir : String;
    FPath         : String;
    FDir          : String;
    FName         : String;
    FSIndex       : Integer;
    FDIndex       : Integer;
    FDataSize     : Integer;
    FPackage      : String;
    procedure LoadFromFile(pBDSProjFile : String);

  public
    property SearchPath  : String  read FSearchPath;
    property DebugSearchPath : String read FDebugSearchPath;
    property UsePackages : Boolean read FUsePackages;
    property Packages    : String  read FPackages;
    property OutputDir   : String  read FOutputDir;
    property DebugOutputDir : String read FDebugOutputDir;
    property Dir         : String  read FDir;
    property Path        : String  read FPath;
    property Name        : String  read FName;
    property SIndex      : Integer read FSIndex write FSIndex;
    property DIndex      : Integer read FDIndex write FDIndex;
    property DataSize    : Integer read FDataSize write FDataSize;
    property Package     : String  read FPackage write FPackage;

  published
    constructor Create(pBDSProjFile: String; sName: String); reintroduce;
    destructor Destroy; override;

  end;

  TResourceBat = class
  private
    FName : string;
    FPath : string;
    FPackage : string;
    FSummaryIndex : Integer;
    FDetailIndex : Integer;
  public
    property Name : string read FName;
    property Path : string read FPath;
    property Package : string read FPackage write FPackage;
    property SummaryIndex : Integer read FSummaryIndex write FSummaryIndex;
    property DetailIndex : Integer read FDetailIndex write FDetailIndex;
  published
    constructor Create(path, name : string); reintroduce;
    destructor Destroy; override;
  end;

  TCommand = class
  private
    FName : string;
    FPath : string;
    FCommand : string;
    FPackage : string;
    FSummaryIndex : Integer;
    FDetailIndex : Integer;
  public
    property Name : string read FName;
    property Path : string read FPath;
    property Command : string read FCommand;
    property Package : string read FPackage write FPackage;
    property SummaryIndex : Integer read FSummaryIndex write FSummaryIndex;
    property DetailIndex : Integer read FDetailIndex write FDetailIndex;
  published
    constructor Create(path, name, command : string); reintroduce;
    destructor Destroy; override;
  end;

  TCSharpCompiler = class
  private
    FOnCompilerCmdOutput : TCompileEvent;
    procedure OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function NETFramework35InstallPath() : string;
    function CompileSolution(Project : TCSharpSolution; bDebug : Boolean = False) : Boolean;
  published
    property OnCompilerCmdOutput : TCompileEvent read FOnCompilerCmdOutput write FOnCompilerCmdOutput;
  end;

  TDelphiCompiler = class
  private
    FOnCompilerCmdOutput : TCompileEvent;

    FBDSInstalled : boolean;
    FBDSVersion   : String;
    FBDSPath      : String;
    FSearchPath   : String;
    FBrowsePath   : String;
    procedure OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
    procedure MakeCFG(Project: TDelphiProject; bDebug: Boolean);
    procedure AddDebugUnit(Project: TDelphiProject);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    function CompileProject(Project: TDelphiProject; bDebug : boolean = False) : boolean;
    procedure UpdateBDSData;
  published
    property OnCompilerCmdOutput : TCompileEvent read FOnCompilerCmdOutput write FOnCompilerCmdOutput;
  end;

  TResourceCompiler = class
  private
    FOnCompilerCmdOutput : TCompileEvent;

    procedure OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function CompileBat(Project : TResourceBat) : Boolean;
  published
    property OnCompilerCmdOutput : TCompileEvent read FOnCompilerCmdOutput write FOnCompilerCmdOutput;
  end;

  TCommandRunner = class
  private
    FOnCompilerCmdOutput : TCompileEvent;

    procedure OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function Execute(Project : TCommand) : Boolean;
  published
    property OnCompilerCmdOutput : TCompileEvent read FOnCompilerCmdOutput write FOnCompilerCmdOutput;
  end;

implementation

{$REGION 'TCSharpSolution'}

constructor TCSharpSolution.Create(csharpSolutionFile: string; name, platform: string);
begin
  inherited Create;

  FName := name;
  FPlatform := platform;
  FPath := csharpSolutionFile;
end;

destructor TCSharpSolution.Destroy;
begin
  inherited Destroy;
end;

{$ENDREGION 'TCSharpSolution'}

{$REGION 'TCSharpCompiler'}

constructor TCSharpCompiler.Create;
begin
  inherited Create;
end;

destructor TCSharpCompiler.Destroy;
begin
  inherited Destroy;
end;

procedure TCSharpCompiler.OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
begin
  if Assigned(FOnCompilerCmdOutput) then
     FOnCompilerCmdOutput(Sender,NewLine);
end;

function TCSharpCompiler.CompileSolution(Project: TCSharpSolution; bDebug: Boolean) : Boolean;
var
  dc : TDosCommand;
  cmd : string;
  config : string;
  exitCode : Integer;
begin
  Result := False;

  if not FileExists(Project.Path) then
    Exit;

  config := 'Release';
  if bDebug then
    config := 'Debug';

  // MSBuild.exe "solutionFilePath" /t:Rebuild /p:Configuration=Release
  // MSBuild.exe "solutionFilePath" /t:Rebuild /p:Configuration=Debug
  cmd := NETFramework35InstallPath + 'MSBuild.exe "' + Project.Path + '" /t:Rebuild /p:Configuration=' + config;
  if Project.Platform <> '' then
    cmd := cmd + ' /p:Platform=' + Project.Platform;

  dc := TDosCommand.Create(nil);
  try
    dc.OnNewLine := OnCompilerNewLine;

    dc.CommandLine := cmd;
    dc.Execute2;
    exitCode := dc.ExitCode;
  finally
    dc.Free;
  end;

  Result := (exitCode = 0);
end;

function TCSharpCompiler.NETFramework35InstallPath: string;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5', False) then
      Result := Reg.ReadString('InstallPath');
  finally
    Reg.Free
  end;
end;

{$ENDREGION 'TCSharpCompiler'}

{$REGION 'TDelphiProject'}

constructor TDelphiProject.Create(pBDSProjFile: String; sName: String);
begin
  Inherited Create;

  FPath := pBDSProjFile;
  FName := sName;
  FDir  := IncludeTrailingPathDelimiter(ExtractFileDir(FPath));

  LoadFromFile(pBDSProjFile);
end;

destructor TDelphiProject.Destroy;
begin

  Inherited Destroy;
end;

procedure TDelphiProject.LoadFromFile(pBDSProjFile : String);
var
  XML : TJvSimpleXML;
  n : integer;
  s : String;
begin
  FSearchPath := '';
  FDebugSearchPath := '';
  FUsePackages := False;
  FPackages := '';
  FOutputDir := '';
  FDebugOutputDir := '';

  XML := TJvSimpleXML.Create(nil);

  if LowerCase(ExtractFileExt(pBDSProjFile)) = '.dproj' then
  begin
    try
    if FileExists(pBDSProjFile) then
    begin
      XML.LoadFromFile(pBDSProjFile);
      with XML.Root.Items do
      begin
        for n := 0 to Count - 1 do
          if Item[n].Name = 'PropertyGroup' then
          begin
            s := Item[n].Properties.Value('Condition', 'no');
            if s = 'no' then
            begin
              FUsePackages := Item[n].Items.BoolValue('DCC_EnabledPackages', False);
              FPackages := Item[n].Items.Value('DCC_UsePackage', '');
            end
            else if Pos('Release', s) > 0 then
            begin
              FSearchPath := Item[n].Items.Value('DCC_IncludePath', '');
              FOutputDir := IncludeTrailingPathDelimiter(Item[n].Items.Value('DCC_ExeOutput', ''));
            end
            else if Pos('Debug', s) > 0 then
            begin
              FDebugSearchPath := Item[n].Items.Value('DCC_IncludePath', '');
              FDebugOutputDir := Item[n].Items.Value('DCC_ExeOutput', '');
            end;
          end;
      end;
    end;
    finally
      XML.Free;
    end;
  end
  else
  begin
    try
      if FileExists(pBDSProjFile) then
      begin
        XML.LoadFromFile(pBDSProjFile);
        if XML.Root.Items.ItemNamed['Delphi.Personality'] <> nil then
          with XML.Root.Items.ItemNamed['Delphi.Personality'].Items do
          begin
            if ItemNamed['Directories'] <> nil then
              with ItemNamed['Directories'].Items do
                for n := 0 to Count - 1 do
                begin
                  s := Item[n].Properties.Value('Name','-1');
                  if CompareText('OutputDir',s) = 0 then
                    FOutputDir := IncludeTrailingPathDelimiter(Item[n].Value)
                  else if CompareText('Packages',s) = 0 then
                    FPackages := Item[n].Value
                  else if CompareText('UsePackages',s) = 0 then
                    FUsePackages := StrToBool(Item[n].Value)
                  else if CompareText('SearchPath',s) = 0 then
                    FSearchPath := Item[n].Value;
                end;
          end;
        end;
    finally
      XML.Free;
    end;
  end;
  FSearchPath := FSearchPath + ';' + FDebugSearchPath;
  FSearchPath := StringReplace(FSearchPath,'$(ProgramFiles)',JclSysInfo.GetProgramFilesFolder,[rfReplaceAll,rfIgnoreCase]);
end;

{$ENDREGION 'TDelphiProject'}

{$REGION 'TDelphiCompiler'}

constructor TDelphiCompiler.Create;
begin
  inherited Create;

  UpdateBDSData;
end;

destructor TDelphiCompiler.Destroy;
begin

  inherited Destroy;
end;

procedure TDelphiCompiler.OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
begin
  if Assigned(FOnCompilerCmdOutput) then
     FOnCompilerCmdOutput(Sender,NewLine);
end;

function Clean(const Input:string): String;
var
  sTemp: String;
  iPos: integer;
  sInput: String;
  sResult: String;
  bBDSFound: Boolean;
  bVCLFound: Boolean;
  bRTLFound: Boolean;
begin
  sInput := Input;
  repeat
    iPos := Pos(';', sInput);
    sTemp := LeftStr(sInput, iPos);
    bBDSFound := Pos('$(BDS)', sTemp) > 0;
    bVCLFound := Pos('\vcl', LowerCase(sTemp)) > 0;
    bRTLFound := Pos('\rtl', LowerCase(sTemp)) > 0;
    if not (bBDSFound and (bVCLFound or bRTLFound)) then
      sResult := sResult + sTemp;
    sInput := RightStr(sInput, Length(sInput) - iPos);
  until iPos = 0;
  if sInput <> '' then
    sResult := sResult + sInput;
  result := sResult;
end;

procedure TDelphiCompiler.UpdateBDSData;
var
  Reg : TRegistry;
begin
  FBDSInstalled := False;
  FBDSVersion := '0';
  FBDSPath := '';
  FSearchPath := '';
  FBrowsePath := '';

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Borland\BDS\5.0',False) then
    begin
      FBDSInstalled := True;
      FBDSVersion := '5.0';
      FBDSPath := Reg.ReadString('RootDir');
      Reg.CloseKey;
    end;
    if not FBDSInstalled then
    begin
      if Reg.OpenKey('\Software\Borland\BDS\4.0', False) then
      begin
        FBDSInstalled := True;
        FBDSVersion := '4.0';
        FBDSPath := Reg.ReadString('RootDir');
        Reg.CloseKey;
      end;
    if not FBDSInstalled then
    begin
      if Reg.OpenKey('\Software\Borland\BDS\3.0', False) then
      begin
        FBDSInstalled := True;
        FBDSVersion := '3.0';
        FBDSPath := Reg.ReadString('RootDir');
        Reg.CloseKey;
      end;
    end;
    end;

    if Reg.OpenKey('\Software\Borland\BDS\' + FBDSVersion + '\Library',False) then
    begin
      FSearchPath := Reg.ReadString('Search Path');
      FBrowsePath := Reg.ReadString('Browsing Path');
      Reg.CloseKey;
    end;

  finally
    Reg.Free;
  end;

  // Exclude vcl and rtl from search/browse paths
  FSearchPath := Clean(FSearchPath);
  FBrowsePath := Clean(FBrowsePath);
  if RightStr(FBDSPath, 1) = '\' then
    FBDSPath := LeftStr(FBDSPath, Length(FBDSPath) - 1);
  FSearchPath := StringReplace(FSearchPath, '$(ProgramFiles)', JclSysInfo.GetProgramFilesFolder, [rfReplaceAll,rfIgnoreCase]);
  FBrowsePath := StringReplace(FBrowsePath, '$(ProgramFiles)', JclSysInfo.GetProgramFilesFolder, [rfReplaceAll,rfIgnoreCase]);
  FSearchPath := StringReplace(FSearchPath, '$(BDS)', FBDSPath, [rfReplaceAll,rfIgnoreCase]);
  FBrowsePath := StringReplace(FBrowsePath, '$(BDS)', FBDSPath, [rfReplaceAll,rfIgnoreCase]);
  FSearchPath := StringReplace(FSearchPath, '$(BDSUSERDIR)', JclSysInfo.GetPersonalFolder + '\Rad Studio\5.0', [rfReplaceAll,rfIgnoreCase]);
  FBrowsePath := StringReplace(FBrowsePath, '$(BDSUSERDIR)', JclSysInfo.GetPersonalFolder + '\Rad Studio\5.0', [rfReplaceAll,rfIgnoreCase]);
  FSearchPath := StringReplace(FSearchPath, '$(BDSCOMMONDIR)', JclSysInfo.GetCommonDocumentsFolder + '\Rad Studio\5.0', [rfReplaceAll,rfIgnoreCase]);
  FBrowsePath := StringReplace(FBrowsePath, '$(BDSCOMMONDIR)', JclSysInfo.GetCommonDocumentsFolder + '\Rad Studio\5.0', [rfReplaceAll,rfIgnoreCase]);  
end;

procedure TDelphiCompiler.MakeCFG(Project: TDelphiProject; bDebug: Boolean);
var
  DCC32: TStringList;
begin
  DCC32 := TStringList.Create;

  DCC32.Clear;
  DCC32.Add('-E"' + Project.OutputDir + '"');

  if Project.UsePackages then
    DCC32.Add('-LU"' + Project.Packages + '"');

  DCC32.Add('');
  DCC32.Add('-U"' + Project.SearchPath + '"');
  DCC32.Add('-R"' + Project.SearchPath + '"');
  DCC32.Add('');
  DCC32.Add('-U"' + FBrowsePath + '"');
  DCC32.Add('-I"' + FBrowsePath + '"');
  DCC32.Add('-R"' + FBrowsePath + '"');

  DCC32.Add('');
  DCC32.Add('-U"' + FSearchPath + '"');
  DCC32.Add('-I"' + FSearchPath + '"');
  DCC32.Add('-R"' + FSearchPath + '"');

  if bDebug then
    DCC32.Add('-GD');

  DCC32.SaveToFile(IncludeTrailingPathDelimiter(ExtractFilePath(Project.Path)) + 'Dcc32.cfg');
  DCC32.Free;
end;

procedure TDelphiCompiler.AddDebugUnit(Project: TDelphiProject);
var
  s: String;
  bInserted: Boolean;
  tempDpr : TextFile;
  origDpr : TextFile;
  bufDpr : string;
begin
  bInserted := False;
  s := ChangeFileExt(Project.Path, '');
  if FileExists(s + '.dpr~') then
    DeleteFile(PChar(s + '.dpr~'));
  AssignFile(origDpr, s + '.dpr');
  AssignFile(tempDpr, s + '.dpr~');
  Reset(origDpr);
  Rewrite(tempDpr);
  while not EOF(origDpr) do
  begin
    ReadLn(origDpr, bufDpr);
    WriteLn(tempDpr, bufDpr);
    if (pos('uses', lowercase(bufDpr)) <> 0) and not bInserted then
    begin
      if FileExists('..\..\Common\Units\DebugDialog\DebugDialog.pas') then
        WriteLn(tempDpr, 'DebugDialog in ''..\..\Common\Units\DebugDialog\DebugDialog.pas'',')
      else if FileExists('..\..\..\Common\Units\DebugDialog\DebugDialog.pas') then
        WriteLn(tempDpr, 'DebugDialog in ''..\..\..\Common\Units\DebugDialog\DebugDialog.pas'',')
      else
        WriteLn(tempDpr, 'DebugDialog in ''..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas'',');
      bInserted := True;
    end;
  end;
  CloseFile(tempDpr);
  CloseFile(origDpr);
end;

function TDelphiCompiler.CompileProject(Project: TDelphiProject; bDebug : boolean = False) : boolean;
var
  DC : TDosCommand;
  Dir : String;
  cmd : String;
  s : String;
  sExt : String;
  iMapSize,iDataSize : Integer;
  iReturn: Integer;
  iLinkerBugUnit : string;
begin
  result := False;

  if not FileExists(Project.Path) then
     exit;

  Dir := IncludeTrailingPathDelimiter(ExtractFilePath(Project.Path));
  SetCurrentDirectory(PChar(Dir));
  ForceDirectories(Project.OutputDir);

  if bDebug then
    AddDebugUnit(Project);

  DC := TDosCommand.Create(nil);
  DC.OnNewLine := OnCompilerNewLine;
  MakeCFG(Project, bDebug);

  cmd := 'dcc32 "' + ExtractFilePath(Project.Path) + ChangeFileExt(ExtractFileName(Project.Path), '');
  if bDebug then
    cmd := cmd + '.dpr~'
  else
    cmd := cmd + '.dpr';
  cmd := cmd + '"';

  DC.CommandLine := cmd;
  DC.Execute2;
  iReturn := DC.ExitCode;
  DC.Free;

  SetCurrentDirectory(PChar(Dir));
  DeleteFile(PChar(Dir + 'Dcc32.cfg'));

  s := ChangeFileExt(ExtractFileName(Project.Path), '');
  if (FileExists(Project.OutputDir + s + '.dll')) then
    sExt := '.dll';
  if (FileExists(Project.OutputDir + s + '.exe')) then
    sExt := '.exe';
  if (FileExists(Project.OutputDir + s + '.ser')) then
    sExt := '.ser';

  result := (iReturn = 0);

  if bDebug then
  begin
    s := ChangeFileExt(Project.Path, '');
    if FileExists(s + '.dpr~') then
      DeleteFile(PChar(s + '.dpr~'));
    s := ChangeFileExt(ExtractFileName(Project.Path), '');
    result := InsertDebugDataIntoExecutableFile(PChar(Project.OutputDir + s + sExt), PChar(Project.OutputDir + s + '.map'), iLinkerBugUnit, iMapSize, iDataSize);
    Project.DataSize := iDataSize;
  end;

  if FileExists(Project.OutputDir + s + '.ser') then
    if FileExists(Project.OutputDir + s + '.service') then
      DeleteFile(PChar(Project.OutputDir + s + '.service'));
    MoveFile(PChar(Project.OutputDir + s + '.ser'), PChar(Project.OutputDir + s + '.service'));

  if FileExists(Project.OutputDir + s + '.map') then
    DeleteFile(PChar(Project.OutputDir + s + '.map'));

end;

{$ENDREGION 'TDelphiCompiler'}

{$Region 'TResourceBat'}
constructor TResourceBat.Create(path, name: string);
begin
  inherited Create;

  FName := name;
  FPath := path;
end;

destructor TResourceBat.Destroy;
begin
  inherited Destroy;
end;
{$endregion}

{$Region 'TResourceCompiler'}
constructor TResourceCompiler.Create;
begin
  inherited Create;
end;

destructor TResourceCompiler.Destroy;
begin
  inherited Destroy;
end;

procedure TResourceCompiler.OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
begin
  if Assigned(FOnCompilerCmdOutput) then
     FOnCompilerCmdOutput(Sender,NewLine);
end;

function TResourceCompiler.CompileBat(Project: TResourceBat) : Boolean;
var
  dc : TDosCommand;
  Dir : string;
begin
  Result := False;

  if not FileExists(Project.Path) then
    Exit;

  Dir := IncludeTrailingPathDelimiter(ExtractFilePath(Project.Path));
  SetCurrentDirectory(PChar(Dir));

  dc := TDosCommand.Create(nil);
  try
    dc.OnNewLine := OnCompilerNewLine;

    dc.CommandLine := Project.Path;
    dc.Execute2;
    exitCode := dc.ExitCode;
  finally
    dc.Free;
  end;

  Result := (exitCode = 0);
end;
{$endregion}

{$Region 'TCommand'}

constructor TCommand.Create(path, name, command: string);
begin
  inherited Create;

  FName := name;
  FPath := path;
  FCommand := command;
end;

destructor TCommand.Destroy;
begin
  inherited Destroy;
end;

{$endregion}

{$Region 'TCommandRunner'}

constructor TCommandRunner.Create;
begin
  inherited Create;
end;

destructor TCommandRunner.Destroy;
begin
  inherited Destroy;
end;

procedure TCommandRunner.OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
begin
  if Assigned(FOnCompilerCmdOutput) then
     FOnCompilerCmdOutput(Sender,NewLine);
end;

function TCommandRunner.Execute(Project: TCommand) : Boolean;
var
  dc : TDosCommand;
  Dir : string;
begin
  Dir := IncludeTrailingPathDelimiter(ExtractFilePath(Project.Path));
  SetCurrentDirectory(PChar(Dir));

  dc := TDosCommand.Create(nil);
  try
    dc.OnNewLine := OnCompilerNewLine;

    dc.CommandLine := Project.Command;
    dc.Execute2;
    exitCode := dc.ExitCode;
  finally
    dc.Free;
  end;

  Result := (exitCode = 0);
end;

{$endregion}

end.
