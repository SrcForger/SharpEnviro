{
Source Name: SharpDesk
Description: SharpE Desktop Component
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 6
 - OS : Windows 2000 or higher

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

program SharpDesk;

             

uses
//  VCLFixPack,
  Forms,
  windows,
  Messages,
  SysUtils,
  Dialogs,
  Controls,
  SharpApi,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSharpDeskMainForm in 'Forms\uSharpDeskMainForm.pas' {SharpDeskMainForm},
  uSharpDeskBackgroundUnit in 'Units\uSharpDeskBackgroundUnit.pas',
  uSharpDeskFunctions in 'Units\uSharpDeskFunctions.pas',
  uSharpDeskTDragAndDrop in 'Units\uSharpDeskTDragAndDrop.pas',
  uSharpDeskObjectFile in 'Units\uSharpDeskObjectFile.pas',
  uSharpDeskDesktopObject in 'Units\uSharpDeskDesktopObject.pas',
  uSharpDeskObjectFileList in 'Units\uSharpDeskObjectFileList.pas',
  uSharpDeskObjectSet in 'Units\uSharpDeskObjectSet.pas',
  uSharpDeskObjectSetItem in 'Units\uSharpDeskObjectSetItem.pas',
  uSharpDeskManager in 'Units\uSharpDeskManager.pas',
  uSharpDeskDebugging in 'Units\uSharpDeskDebugging.pas',
  uSharpDeskLayeredWindow in 'Units\uSharpDeskLayeredWindow.pas' {SharpDeskLayeredWindow},
  SharpFX in '..\..\Common\Units\SharpFX\SharpFX.pas',
  SharpGraphicsUtils in '..\..\Common\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  uSharpDeskTDeskSettings in 'Units\uSharpDeskTDeskSettings.pas',
  SharpImageUtils in '..\..\Common\Units\SharpImageUtils\SharpImageUtils.pas',
  SharpIconUtils in '..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpFileUtils in '..\..\Common\Units\SharpFileUtils\SharpFileUtils.pas';

{$R *.res}
{$R metadata.res}

var
   Parameter,FileName : String;
   MutexHandle: THandle;
   OtherWnd  : THandle;

begin
  // Seed random number generator
  Randomize;

  Application.Initialize;
  Application.MainFormOnTaskbar := True; 
  Application.Title := 'SharpDesk - Installing';
  Application.ModalPopupMode := pmAuto;

  Parameter := paramstr(1);
  if length(Parameter) <> 0 then
    if (FileExists(Parameter)) and (ExtractFileExt(Parameter)='.object') then
    begin
      FileName := ExtractFileName(Parameter);
      if ExtractFileDir(Application.ExeName)+'\Objects\'+FileName = Parameter then
        halt;

      MuteXHandle := OpenMutex(MUTEX_ALL_ACCESS,False,'SharpDeskMutex');
      if MuteXHandle <> 0 then
      begin
        OtherWnd := FindWindow(nil,'SharpDesk');
        if OtherWnd <> 0 then
          SendMessage(OtherWnd,WM_Close,0,0);
      end;
      CloseHandle(MuteXHandle);

      if FileExists(ExtractFileDir(Application.ExeName)+'\Objects\'+FileName) then
      begin
        if MessageDlg ('SharpDesk Object Installer '+#13#10+#13#10+'The selected object is already installed.'+#13#10+'Do you want to continue and overwrite the existing object?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          DeleteFile(pChar(ExtractFileDir(Application.ExeName)+'\Objects\'+FileName));
          CopyFile(pChar(Parameter),pChar(ExtractFileDir(Application.ExeName)+'\Objects\'+FileName),True);
        end;
      end else
        CopyFile(pChar(Parameter),pChar(ExtractFileDir(Application.ExeName)+'\Objects\'+FileName),True);

      Application.Processmessages;
    end;

  Application.Title := 'SharpDesk';

  MutexHandle := CreateMutex(nil, TRUE, 'SharpDeskMutex');
  if MutexHandle <> 0 then
  begin
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(MutexHandle);
      Application.Terminate;
      Halt;
    end;
  end;

  Application.CreateForm(TSharpDeskMainForm, SharpDeskMainForm);
  SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));
  ServiceDone('SharpDesk');

  Application.Run;
end.
