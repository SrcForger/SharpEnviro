{
Source Name: DelphiCompiler.pas
Description: Unit for compiling delphi projects by using the command line compiler
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit DelphiCompiler;

interface

uses
  SysUtils,Windows,Registry,Classes,DateUtils,
  JvSimpleXML,JclFileUtils,JclSysInfo,DosCommand;

type
  TCompileEvent = procedure(Sender: TObject; CmdOutput: string) of object;

  TDelphiProject = class
  private
    FSearchPath   : String;
    FUsePackages  : Boolean;
    FPackages     : String;
    FOutputDir    : String;
    FName         : String;
    FPath         : String;
    FDir          : String;
    FType         : String;
    FRequ         : String;
    FVersion      : String;
    FAuthor       : String;
    procedure LoadFromFile(pBDSProjFile : String);
  public
    property SearchPath  : String  read FSearchPath;
    property UsePackages : Boolean read FUsePackages;
    property Packages    : String  read FPackages;
    property OutputDir   : String  read FOutputDir;
    property Name        : String  read FName;
    property Dir         : String  read FDir;
    property Path        : String  read FPath;
    property aType       : String  read FType;
    property Requires    : String  read FRequ;
    property Version     : String  read FVersion write FVersion;
    property Author      : String  read FAuthor; 
  published
    constructor Create(pBDSProjFile,pName,pType,pRequires : String); reintroduce;
    destructor Destroy; override;
  end;

  TDelphiCompiler = class
  private
    FOnCompilerCmdOutput : TCompileEvent;

    FBDSRoot      : String;
    FBDSVersion   : String;
    FBDSEdition   : String;
    FBDSInstalled : boolean;
    FSearchPath   : String;
    FBrowsePath   : String;
    procedure OnCompilerNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    function CompileProject(pBDSProjFile : String) : boolean;
    procedure UpdateBDSData;
  published
    property OnCompilerCmdOutput : TCompileEvent read FOnCompilerCmdOutput write FOnCompilerCmdOutput;
  end;

implementation


constructor TDelphiProject.Create(pBDSProjFile,pName,pType,pRequires : String);
begin
  Inherited Create;

  FName := pName;
  FType := pType;
  FRequ := pRequires;
  FPath := pBDSProjFile;
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
  FVersion := '';

  XML := TJvSimpleXMl.Create(nil);
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
           if ItemNamed['VersionInfoKeys'] <> nil then
              with ItemNamed['VersionInfoKeys'].Items do
                   for n := 0 to Count - 1 do
                   begin
                     s := Item[n].Properties.Value('Name','-1');
                     if CompareText('FileVersion',s) = 0 then
                     begin
                       FVersion := Item[n].Value;
                       break;
                     end;
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
  FSearchPath := '';
  FBrowsePath := '';
  
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Borland\BDS\3.0',False) then
    begin
      FBDSEdition := Reg.ReadString('Edition');
      FBDSVersion := Reg.ReadString('ProductVersion');
      FBDSRoot    := Reg.ReadString('RootDir');
      FBDSInstalled := True;
      Reg.CloseKey;
    end;

    if Reg.OpenKey('\Software\Borland\BDS\3.0\Library',False) then
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

function TDelphiCompiler.CompileProject(pBDSProjFile : String) : boolean;
var
  DP : TDelphiProject;
  DC : TDosCommand;
  Dir : String;
  DCC32 : TStringList;
  n : integer;
  cmd : String;
  s : String;
  tempst : TDateTime;
  dllst  : TDateTime;
  exest  : TDateTime;
  serst  : TDateTime;
  targetfile : String;
begin
  result := False;
  
  if not FileExists(pBDSProjFile) then
     exit;

  Dir := IncludeTrailingBackSlash(ExtractFileDir(pBDSProjFile));

  DP := TDelphiProject.Create(pBDSProjFile,'','','');
  DCC32 := TStringList.Create;

  DCC32.Clear;
  DCC32.Add('-E"' + DP.OutputDir + '"');
  if DP.UsePackages then
     DCC32.Add('-LU"' + DP.Packages + '"');

  DCC32.Add('');
  DCC32.Add('-U"' + FBrowsePath + '"');
  DCC32.Add('-I"' + FBrowsePath + '"');
  DCC32.Add('-R"' + FBrowsePath + '"');

  DCC32.Add('');
  DCC32.Add('-U"' + FSearchPath + '"');
  DCC32.Add('-I"' + FSearchPath + '"');
  DCC32.Add('-R"' + FSearchPath + '"');

  DCC32.Add('');
  DCC32.Add('-U"' + DP.SearchPath + '"');
  DCC32.Add('-R"' + DP.SearchPath + '"');

  DCC32.SaveToFile(Dir + 'Dcc32.cfg');
  DCC32.Free;

  DC := TDosCommand.Create(nil);
  DC.OnNewLine := OnCompilerNewLine;

  s := pBDSProjFile;
  setlength(s,length(s) - length(ExtractFileExt(pBDSProjFile)));
  cmd := 'DCC32 "' + s + '.dpr"';

  SetCurrentDirectory(PChar(Dir));
  ForceDirectories(DP.OutputDir);

  s := ExtractFileName(pBDSProjFile);
  setlength(s,length(s) - length(ExtractFileExt(pBDSProjFile)));
  if FileExists(DP.OutputDir + s + '.dll') then
     GetFileLastWrite(DP.OutputDir + s + '.dll',dllst)
     else dllst := 0;
  if FileExists(DP.OutputDir + s + '.exe') then
     GetFileLastWrite(DP.OutputDir + s + '.exe',exest)
     else exest := 0;
  if FileExists(DP.OutputDir + s + '.ser') then
     GetFileLastWrite(DP.OutputDir + s + '.ser',serst)
     else serst := 0;

  DC.CommandLine := cmd;
  DC.Execute2;

  if (FileExists(DP.OutputDir + s + '.dll')) and (dllst <> 0) then
  begin
    GetFileLastWrite(DP.OutputDir + s + '.dll',tempst);
    result := (CompareDateTime(dllst,tempst) <> 0);
  end
  else
  if (FileExists(DP.OutputDir + s + '.exe')) and (exest <> 0) then
  begin
    GetFileLastWrite(DP.OutputDir + s + '.exe',tempst);
    result := (CompareDateTime(exest,tempst) <> 0);
  end
    else
  if (FileExists(DP.OutputDir + s + '.ser')) and (serst <> 0) then
  begin
    GetFileLastWrite(DP.OutputDir + s + '.ser',tempst);
    result := (CompareDateTime(serst,tempst) <> 0);
  end
  else if    (FileExists(DP.OutputDir + s + '.dll'))
          or (FileExists(DP.OutputDir + s + '.exe'))
          or (FileExists(DP.OutputDir + s + '.ser')) then
       result := True;

  DeleteFile(PChar(Dir + 'Dcc32.cfg'));

  DC.Free;
  DP.Free;
end;

end.
