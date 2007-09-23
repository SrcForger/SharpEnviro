unit SharpESrvWizard;

interface

uses
  SysUtils, Windows, Controls, ToolsApi;

const
  CRLF = #10#13;
  FileExt = 'ser';

  ServiceLibraryHeader =
    '{                                                                    ' + CRLF +
    'Source Name: %ProjectName.%FileExt                                   ' + CRLF +
    'Description: %Description                                            ' + CRLF +
    'Copyright (C) %Author                                                ' + CRLF +
    '                                                                     ' + CRLF +
    'Source Forge Site                                                    ' + CRLF +
    'https://sourceforge.net/projects/sharpe/                             ' + CRLF +
    '                                                                     ' + CRLF +
    'SharpE Site                                                          ' + CRLF +
    'http://www.sharpenviro.com                                           ' + CRLF +
    '                                                                     ' + CRLF +
    'This program is free software: you can redistribute it and/or modify ' + CRLF +
    'it under the terms of the GNU General Public License as published by ' + CRLF +
    'the Free Software Foundation, either version 3 of the License, or    ' + CRLF +
    '(at your option) any later version.                                  ' + CRLF +
    '                                                                     ' + CRLF +
    'This program is distributed in the hope that it will be useful,      ' + CRLF +
    'but WITHOUT ANY WARRANTY; without even the implied warranty of       ' + CRLF +
    'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        ' + CRLF +
    'GNU General Public License for more details.                         ' + CRLF +
    '                                                                     ' + CRLF +
    'You should have received a copy of the GNU General Public License    ' + CRLF +
    'along with this program.  If not, see <http://www.gnu.org/licenses/>.' + CRLF +
    '}                                                                    ' + CRLF +
    '                                                                     ' + CRLF +
    'library %ProjectName;                                                ' + CRLF +
    '                                                                     ' + CRLF +
    'uses                                                                 ' + CRLF +
    '  Windows%ReqUnits;                                                  ' + CRLF +
    '                                                                     ' + CRLF +
    '{$E %FileExt}                                                        ' + CRLF +
    '                                                                     ' + CRLF +
    '{$R *.res}                                                           ' + CRLF +
    '                                                                     ' + CRLF;

  ServiceLibraryFooter =
    '// Service receives a message                                        ' + CRLF +
    'function SCMsg(msg: string): Integer;                                ' + CRLF +
    'begin                                                                ' + CRLF +
    '  Result := HInstance;                                               ' + CRLF +
    'end;                                                                 ' + CRLF +
    '                                                                     ' + CRLF +
    '//Ordinary Dll code, tells delphi what functions to export.          ' + CRLF +
    'exports                                                              ' + CRLF +
    '  Start,                                                             ' + CRLF +
    '  Stop,                                                              ' + CRLF +
    '  SCMsg;                                                             ' + CRLF +
    '                                                                     ' + CRLF +
    'begin                                                                ' + CRLF +
    'end.                                                                 ' + CRLF;

  ActionEventInterface =
    'type                                                                 ' + CRLF +
    '  TActionEvent = Class(TObject)                                      ' + CRLF +
    '    procedure MessageHandler(var Message: TMessage);                 ' + CRLF +
    '  end;                                                               ' + CRLF +
    '                                                                     ' + CRLF +
    'var                                                                  ' + CRLF +
    '  ActionEvent: TActionEvent;                                         ' + CRLF +
    '  Handle: THandle;                                                   ' + CRLF +
    '                                                                     ' + CRLF;

  StartProcHeader =
    '// Service is started                                                ' + CRLF +
    'function Start(Owner: HWND): HWND;                                   ' + CRLF +
    'begin                                                                ' + CRLF +
    '  Result := Owner;                                                   ' + CRLF;

  StartProcActionEventCreate =
    '  ActionEvent := TActionEvent.Create;                                ' + CRLF +
    '  Handle := AllocateHWnd(ActionEvent.MessageHandler);                ' + CRLF;

  CommonFooter =
    'end;                                                                 ' + CRLF +
    '                                                                     ' + CRLF;

  StopProcHeader =
    '// Service is stopped                                                ' + CRLF +
    'procedure Stop;                                                      ' + CRLF +
    'begin                                                                ' + CRLF;

  StopProcActionEventFree =
    '  DeallocateHWnd(Handle);                                            ' + CRLF +
    '  ActionEvent.Free;                                                  ' + CRLF;

  MsgHandlerHeader =
    'procedure TActionEvent.MessageHandler(var Message: TMessage);        ' + CRLF +
    'begin                                                                ' + CRLF +
    '  // Message Handlers                                                ' + CRLF;

  ActMsgHandler =
    '  case Message.Msg of                                                ' + CRLF +
    '    WM_SHARPEACTIONMESSAGE:                                          ' + CRLF +
    '      begin                                                          ' + CRLF +
    '        // Action Messages                                           ' + CRLF +
    '      end;                                                           ' + CRLF +
    '    WM_SHARPEUPDATEACTIONS:                                          ' + CRLF +
    '      begin                                                          ' + CRLF +
    '        %RegActions                                                  ' + CRLF +
    '      end;                                                           ' + CRLF +
    '  end;                                                               ' + CRLF;

  RegActionsProc =
    'procedure %RegActions                                                ' + CRLF +
    'begin                                                                ' + CRLF;

  UnregActionsProc =
    'procedure %UnregActions                                              ' + CRLF +
    'begin                                                                ' + CRLF;

  RegActionsComment =
    '  // Register Actions                                                ' + CRLF;

  UnregActionsComment =
    '  // Unregister Actions                                              ' + CRLF;

  RegActions =
    '  %RegActions                                                      ' + CRLF;

  UnregActions =
    '  %UnregActions                                                      ' + CRLF;

var
  SrvName, SrvDescription, SrvAuthor: string;
  SrvActions, SrvMsgHandler: Boolean;

type
  TShESvrCreatorFile = class(TInterfacedObject, IOTAFile)
  private
    FAge: TDateTime;
    FProjectName: string;
  public
    constructor Create(const ProjectName: string);
    function GetSource: string;
    function GetAge: TDateTime;
  end;

  TShESvrCreatorModule = class(TInterfacedObject, IOTACreator,
    IOTAProjectCreator, IOTAProjectCreator80)
  public
    // IOTACreator
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
    // IOTAProjectCreator
    function GetFileName: string;
    function GetOptionFileName: string;
    function GetShowSource: Boolean;
    procedure NewDefaultModule;
    function NewOptionSource(const ProjectName: string): IOTAFile;
    procedure NewProjectResource(const Project: IOTAProject);
    function NewProjectSource(const ProjectName: string): IOTAFile;
    // IOTAProjectCreator50
    procedure NewDefaultProjectModule(const Project: IOTAProject);
    // IOTAProjectCreator80
    function GetProjectPersonality: string;
  end;

  TShESvrCreatorWizard = class(TNotifierObject, IOTAWizard, IOTARepositoryWizard,
    IOTAProjectWizard)
  public
    // IOTAWizard
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
    // IOTARepositoryWizard
    function GetAuthor: string;
    function GetComment: string;
    function GetPage: string;
    function GetGlyph: Cardinal;
  end;

implementation

uses
  Dialogs, OTAUtilities, frmSharpESrvWiz;

{ TShESvrCreatorFile }

constructor TShESvrCreatorFile.Create(const ProjectName: string);
begin
  FAge := -1;  // Flag age as New File
  FProjectName := ProjectName;
end;

function TShESvrCreatorFile.GetAge: TDateTime;
begin
  Result := FAge;
end;

function TShESvrCreatorFile.GetSource: string;
var
  ReqUnits, RegActionsValue, UnregActionsValue: string;
begin
  RegActionsValue := 'RegisterSharpEActions;';
  UnregActionsValue := 'UnregisterSharpEActions;';

  Result := ServiceLibraryHeader;
  if SrvMsgHandler then
    Result := Result + ActionEventInterface;
  if SrvActions then
  begin
    Result := Result + RegActionsProc + RegActionsComment + CommonFooter;
    Result := Result + UnregActionsProc + UnregActionsComment + CommonFooter;
  end;
  if SrvMsgHandler then
    Result := Result + MsgHandlerHeader;
  if SrvActions then
    Result := Result + ActMsgHandler;
  if SrvMsgHandler then
    Result := Result + CommonFooter;
  Result := Result + StartProcHeader;
  if SrvMsgHandler then
    Result := Result + StartProcActionEventCreate;
  if SrvActions then
  begin
    Result := Result + RegActionsComment;
    Result := Result + RegActions;
  end;
  Result := Result + CommonFooter;
  Result := Result + StopProcHeader;
  if SrvActions then
  begin
    Result := Result + UnregActionsComment;
    Result := Result + UnregActions;
  end;
  if SrvMsgHandler then
    Result := Result + StopProcActionEventFree;
  Result := Result + CommonFooter;
  Result := Result + ServiceLibraryFooter;

  // Parameterize the code
  if SrvMsgHandler then
    ReqUnits := ', Classes, Messages, SharpAPI';

  Result := StringReplace(Result, '%ProjectName', FProjectName, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%FileExt', FileExt, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%Description', SrvDescription, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%Author', SrvAuthor, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%ReqUnits', ReqUnits, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%RegActions', RegActionsValue, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%UnregActions', UnregActionsValue, [rfReplaceAll, rfIgnoreCase]);
end;

{ TShESvrCreatorModule }

function TShESvrCreatorModule.GetCreatorType: string;
begin
  Result := '';
end;

function TShESvrCreatorModule.GetExisting: Boolean;
begin
  Result := False; // Create a new module
end;

function TShESvrCreatorModule.GetFileName: string;
begin
  Result := SrvName + '.dpr';
end;

function TShESvrCreatorModule.GetFileSystem: string;
begin
  Result := ''; // Default File System
end;

function TShESvrCreatorModule.GetOptionFileName: string;
begin
  Result := ''; // C++ Only
end;

function TShESvrCreatorModule.GetOwner: IOTAModule;
begin
  Result := GetCurrentProjectGroup;  // Owned by current project group
end;

function TShESvrCreatorModule.GetProjectPersonality: string;
begin
  Result := sDelphiPersonality;
end;

function TShESvrCreatorModule.GetShowSource: Boolean;
begin
  Result := True; // Show the source in the editor
end;

function TShESvrCreatorModule.GetUnnamed: Boolean;
begin
  Result := True; // Project needs to be named/saved
end;

procedure TShESvrCreatorModule.NewDefaultModule;
begin
  // No default modules are created
end;

procedure TShESvrCreatorModule.NewDefaultProjectModule(
  const Project: IOTAProject);
begin
  NewDefaultModule;
end;

function TShESvrCreatorModule.NewOptionSource(
  const ProjectName: string): IOTAFile;
begin
  Result := nil; // C++ Only
end;

procedure TShESvrCreatorModule.NewProjectResource(const Project: IOTAProject);
begin
  // No resources needed
end;

function TShESvrCreatorModule.NewProjectSource(
  const ProjectName: string): IOTAFile;
begin
  Result := TShESvrCreatorFile.Create(ProjectName) as IOTAFile;
end;

{ TShESvrCreatorWizard }

procedure TShESvrCreatorWizard.Execute;
begin
  with TSharpESrvWizForm.Create(nil) do
  begin
    try
      if ShowModal = mrOk then
      begin
        SrvName := edName.Text;
        SrvDescription := edDescription.Text;
        SrvAuthor := edCopyright.Text;
        SrvActions := cbActions.Checked;
        SrvMsgHandler := cbMsgHandler.Checked;
        try
          // First create the Project
          (BorlandIDEServices as IOTAModuleServices).CreateModule(TShESvrCreatorModule.Create as IOTAProjectCreator80);
        except
          MessageDlg('Error generating ' + SrvName + '.' + FileExt, mtError, [mbOK], 0);
        end;
      end;
    finally
      Free;
    end;
  end;
end;

function TShESvrCreatorWizard.GetAuthor: string;
begin
  // When Object Repository is in Detail mode used in the Author column
  Result := 'Aleksandar Milanovic (aleksandar.milanovic@hotmail.com)';
end;

function TShESvrCreatorWizard.GetComment: string;
begin
  // When Object Repository is in Detail mode used in the Comment column
  Result := 'SharpE Service Wizard';
end;

function TShESvrCreatorWizard.GetGlyph: Cardinal;
begin
  // Note here the Image in the resource file MUST contain a 32x32 icon
  // AND a 16x16 icon in the same icon resource.
  Result := LoadIcon(hInstance, 'SHARPESRV');
end;

function TShESvrCreatorWizard.GetIDString: string;
begin
  // Unique name for the Wizard used internally by Delphi
  Result := '{4BF00AE9-19F5-4DB9-9B83-5A6308A5A672}';
end;

function TShESvrCreatorWizard.GetName: string;
begin
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  Result := 'SharpE Service';
end;

function TShESvrCreatorWizard.GetPage: string;
begin
  // Page in the Repository to add the Wizard. This may be a Delphi
  // defined page or a unique name to create a new page.
  // If an empty string is returned the wizard is installed into a page
  // named "Wizards"
  Result := 'SharpE';
end;

function TShESvrCreatorWizard.GetState: TWizardState;
begin
  // For Menu Item Wizards only
  Result := [];
end;

end.
