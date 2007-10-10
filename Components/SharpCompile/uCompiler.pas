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

implementation


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
  i : integer;
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
              FOutputDir := Item[n].Items.Value('DCC_ExeOutput', '');
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
  FSearchPath := StringReplace(FSearchPath,'$(ProgramFiles)',JclSysInfo.GetProgramFilesFolder,[rfReplaceAll,rfIgnoreCase]);
end;


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
  DCC32.Add('-U"' + FBrowsePath + '"');
  DCC32.Add('-I"' + FBrowsePath + '"');
  DCC32.Add('-R"' + FBrowsePath + '"');

  DCC32.Add('');
  DCC32.Add('-U"' + FSearchPath + '"');
  DCC32.Add('-I"' + FSearchPath + '"');
  DCC32.Add('-R"' + FSearchPath + '"');

  DCC32.Add('');
  DCC32.Add('-U"' + Project.SearchPath + '"');
  DCC32.Add('-R"' + Project.SearchPath + '"');

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
  if FileExists(s + '.orig') then
    DeleteFile(PChar(s + '.orig'));
  MoveFile(PChar(s + '.dpr'), PChar(s + '.orig'));
  AssignFile(origDpr, s + '.orig');
  AssignFile(tempDpr, s + '.dpr');
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
      else
        WriteLn(tempDpr, 'DebugDialog in ''..\..\..\Common\Units\DebugDialog\DebugDialog.pas'',');
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
  bMSBuild: Boolean;
  sPath: String;
  iReturn: Integer;
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

  cmd := 'dcc32 "' + ExtractFilePath(Project.Path) + ChangeFileExt(ExtractFileName(Project.Path), '') + '.dpr"';

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
    if FileExists(s + '.dpr') and FileExists(s + '.orig') then
    begin
      DeleteFile(PChar(s + '.dpr'));
      MoveFile(PChar(s + '.orig'), PChar(s + '.dpr'));
    end;
    s := ChangeFileExt(ExtractFileName(Project.Path), '');
    result := InsertDebugDataIntoExecutableFile(PChar(Project.OutputDir + s + sExt), PChar(Project.OutputDir + s + '.map'), iMapSize, iDataSize);
    Project.DataSize := iDataSize;
  end;

  if FileExists(Project.OutputDir + s + '.ser') then
    if FileExists(Project.OutputDir + s + '.service') then
      DeleteFile(PChar(Project.OutputDir + s + '.service'));
    MoveFile(PChar(Project.OutputDir + s + '.ser'), PChar(Project.OutputDir + s + '.service'));

  if FileExists(Project.OutputDir + s + '.map') then
    DeleteFile(PChar(Project.OutputDir + s + '.map'));

end;

end.
