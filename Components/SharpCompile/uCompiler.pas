{
Source Name: uCompiler.pas
Description: Revised Unit for compiling delphi projects by using the command line compiler
Original Copyright (C) Martin Krämer (MartinKraemer@gmx.net)
Revision Copyright (C) Nathan LaFreniere (quitlahok@gmail.com)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uCompiler;

interface

uses
  SysUtils,Windows,Registry,Classes,DateUtils,
  JvSimpleXML,JclFileUtils,JclSysInfo,DosCommand,
  JclDebug;

type
  TCompileEvent = procedure(Sender: TObject; CmdOutput: string) of object;

  TDelphiProject = class
  private
    FSearchPath   : String;
    FUsePackages  : Boolean;
    FPackages     : String;
    FOutputDir    : String;
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
    property UsePackages : Boolean read FUsePackages;
    property Packages    : String  read FPackages;
    property OutputDir   : String  read FOutputDir;
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
    FSearchPath   : String;
    FBrowsePath   : String;
    procedure OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
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
  FDir  := IncludeTrailingBackSlash(ExtractFileDir(FPath));

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
  FUsePackages := False;
  FPackages := '';
  FOutputDir := '';

  XML := TJvSimpleXML.Create(nil);
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
                        FOutputDir := IncludeTrailingBackSlash(Item[n].Value)
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

procedure TDelphiCompiler.UpdateBDSData;
var
  Reg : TRegistry;
begin
  FBDSInstalled := False;
  FBDSVersion := '0';
  FSearchPath := '';
  FBrowsePath := '';

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Borland\BDS\4.0',False) then
    begin
      FBDSInstalled := True;
      FBDSVersion := '4.0';
      Reg.CloseKey;
    end;
    if not FBDSInstalled then
    begin
      if Reg.OpenKey('\Software\Borland\BDS\3.0', False) then
      begin
        FBDSInstalled := True;
        FBDSVersion := '3.0';
        Reg.CloseKey;
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

  FSearchPath := StringReplace(FSearchPath,'$(ProgramFiles)',JclSysInfo.GetProgramFilesFolder,[rfReplaceAll,rfIgnoreCase]);
  FBrowsePath := StringReplace(FBrowsePath,'$(ProgramFiles)',JclSysInfo.GetProgramFilesFolder,[rfReplaceAll,rfIgnoreCase]);
end;

function TDelphiCompiler.CompileProject(Project: TDelphiProject; bDebug : boolean = False) : boolean;
var
  DC : TDosCommand;
  Dir : String;
  DCC32 : TStringList;
  cmd : String;
  s : String;
  sExt : String;
  tempst : TDateTime;
  dllst  : TDateTime;
  exest  : TDateTime;
  serst  : TDateTime;
  iMapSize,iDataSize : Integer;
  tempDpr : TextFile;
  origDpr : TextFile;
  bufDpr : string;
  bInserted : Boolean;
begin
  result := False;
  bInserted := False;

  if not FileExists(Project.Path) then
     exit;

  Dir := IncludeTrailingBackSlash(ExtractFilePath(Project.Path));

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

  DCC32.SaveToFile(Dir + 'Dcc32.cfg');
  DCC32.Free;

  DC := TDosCommand.Create(nil);
  DC.OnNewLine := OnCompilerNewLine;

  SetCurrentDirectory(PChar(Dir));
  ForceDirectories(Project.OutputDir);

  s := ChangeFileExt(Project.Path, '');
  if bDebug then
  begin
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
        else
          WriteLn(tempDpr, 'DebugDialog in ''..\..\..\Common\Units\DebugDialog\DebugDialog.pas'',');
        bInserted := True;
      end;
    end;
    CloseFile(tempDpr);
    CloseFile(origDpr);
    cmd := 'DCC32 "' + s + '.dpr~"';
  end
  else
    cmd := 'DCC32 "' + s + '.dpr"';

  s := ChangeFileExt(ExtractFileName(Project.Path), '');
  if FileExists(Project.OutputDir + s + '.dll') then
     GetFileLastWrite(Project.OutputDir + s + '.dll',dllst)
     else dllst := 0;
  if FileExists(Project.OutputDir + s + '.exe') then
     GetFileLastWrite(Project.OutputDir + s + '.exe',exest)
     else exest := 0;
  if FileExists(Project.OutputDir + s + '.ser') then
     GetFileLastWrite(Project.OutputDir + s + '.ser',serst)
     else serst := 0;

  DC.CommandLine := cmd;
  DC.Execute2;
  DC.Free;

  if (FileExists(Project.OutputDir + s + '.dll')) then
  begin
    GetFileLastWrite(Project.OutputDir + s + '.dll',tempst);
    sExt := '.dll';
    if (dllst <> 0) then
      result := (CompareDateTime(dllst,tempst) <> 0)
    else
      result := True;
  end
  else
  if (FileExists(Project.OutputDir + s + '.exe')) then
  begin
    GetFileLastWrite(Project.OutputDir + s + '.exe',tempst);
    sExt := '.exe';
    if (exest <> 0) then
      result := (CompareDateTime(exest,tempst) <> 0)
    else
      result := True;
  end
  else
  if (FileExists(Project.OutputDir + s + '.ser')) then
  begin
    GetFileLastWrite(Project.OutputDir + s + '.ser',tempst);
    sExt := '.ser';
    if (serst <> 0) then
      result := (CompareDateTime(serst,tempst) <> 0)
    else
      result := True;
  end;

  DeleteFile(PChar(Dir + 'Dcc32.cfg'));

  if bDebug then
  begin
    s := ChangeFileExt(Project.Path, '.dpr~');
    if FileExists(s) then
      DeleteFile(PChar(s));
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
