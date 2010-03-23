unit ScriptControls;

interface

uses Forms,
     Controls,
     Dialogs,
     SysUtils,
     Classes,
     Types,
     JvComponentBase,
     JvInterpreter;

type
  TSharpEGenericScript = class
                         private
                           procedure OnInterpreterStatement(Sender : TObject);
                         public
                           procedure ExecuteScript(FileName : String);
                         end;

implementation

uses  DateUtils,
      SharpApi,
      InstallWnd,
      LogWnd,
      SharpApi_Adapter,
      SharpBase_Adapter,
      SharpFileUtils_Adapter;

procedure TSharpEGenericScript.OnInterpreterStatement(Sender : TObject);
begin
  Application.ProcessMessages;
end;

procedure TSharpEGenericScript.ExecuteScript(FileName :String);
var
  JvInterpreter : TJvInterpreterProgram;
  logform : TLogForm;
  n : integer;
  LogWindow : boolean;
  LogAutoClose : boolean;
begin
  if not FileExists(FileName) then exit;

  LogWindow := True;
  LogAutoClose := False;
  LogForm := TLogForm.Create(nil);
  JvInterpreter := TJvInterpreterProgram.Create(nil);
  try
    SharpApi_Adapter.RegisterAPILog(LogForm.lb_log.Items);
    SharpBase_Adapter.RegisterBaseLog(LogForm.lb_log.Items);
    SharpFileUtils_Adapter.RegisterFileUtilsLog(LogForm.lb_log.Items);

    JvInterpreter.Pas.LoadFromFile(FileName);

    for n := 0 to JvInterpreter.Pas.Count - 1 do
    begin
      if CompareText('{$LOGWINDOW OFF}',JvInterpreter.Pas[n]) = 0 then LogWindow := False;
      if CompareText('{$LOGWINDOW AUTOCLOSE ON}',JvInterpreter.Pas[n]) = 0 then LogAutoClose := True;
      if (CompareText('var',JvInterpreter.Pas[n]) = 0) or
         (CompareText('begin',JvInterpreter.Pas[n]) = 0) or
         (CompareText('const',JvInterpreter.Pas[n]) = 0) then break;
    end;

    if LogWindow then LogForm.Show;
    JvInterpreter.OnStatement := OnInterpreterStatement;
    try
      JvInterpreter.Run;
    except
      LogForm.lb_log.Items.Add('Error: aborting script');
    end;
  finally
    SharpApi_Adapter.UnRegisterAPILog;
    SharpBase_Adapter.UnRegisterBaseLog;
    SharpFileUtils_Adapter.UnRegisterFileUtilsLog;
    JvInterpreter.Free;
    if LogWindow then
    begin
      LogForm.lb_log.Items.Add('-----------------------------------------------------');
      LogForm.lb_log.Items.Add('Script finished');
      Application.ProcessMessages;
      if LogAutoClose then
      begin
        Sleep(2500);
      end else
      begin
        LogForm.Hide;
        LogForm.ShowModal;
      end;
    end;
    LogForm.Free;
  end;
end;

end.
