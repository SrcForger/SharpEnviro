unit CreateGenericScriptWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvInterpreter, XPMan, ImgList, PngImageList,
  StdCtrls, ComCtrls, ToolWin, JvExControls, JvComponent, JvEditorCommon,
  JvEditor, JvHLEditor, Menus, JcLSysUtils;

type
  TCreateGenericScriptForm = class(TForm)
    ed_script: TJvHLEditor;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton2: TToolButton;
    lb_errors: TListBox;
    PngImageList1: TPngImageList;
    XPManifest1: TXPManifest;
    JvInterpreter: TJvInterpreterProgram;
    ToolButton4: TToolButton;
    OpenScript: TOpenDialog;
    SaveScript: TSaveDialog;
    ToolButton5: TToolButton;
    btn_insert: TToolButton;
    FunctionDropDown: TPopupMenu;
    N11: TMenuItem;
    SharpApi1: TMenuItem;
    Constants1: TMenuItem;
    SETTINGSGLOBALDIR1: TMenuItem;
    SHARPEDIR2: TMenuItem;
    SETTINGSUSERDIR2: TMenuItem;
    functionGetSharpEDirectoryString1: TMenuItem;
    functionGetSharpEUserSettingsPathString1: TMenuItem;
    functionGetSharpEGlobalSettingsPathString1: TMenuItem;
    functionIsComponentRunningNameStringboolean1: TMenuItem;
    functionFindComponentNameStringinteger1: TMenuItem;
    functionCloseComponentNameStringboolean1: TMenuItem;
    procedureTerminateComponentNameString1: TMenuItem;
    procedureStartComponentNameString1: TMenuItem;
    functionExecuteFilePathStringinteger1: TMenuItem;
    ComponentControl1: TMenuItem;
    Directory1: TMenuItem;
    Applications1: TMenuItem;
    Script1: TMenuItem;
    Valueconvertion1: TMenuItem;
    functionIntToStrValueintegerString1: TMenuItem;
    functionStrToIntValueStringinteger1: TMenuItem;
    imer1: TMenuItem;
    procedureSleepTimeInMs1: TMenuItem;
    FileUtils1: TMenuItem;
    functionCopyFileFromToStringOverwritebooleanboolean1: TMenuItem;
    functionDeleteFileFilePathStringboolean1: TMenuItem;
    functionFileExistsFilePathStringboolean1: TMenuItem;
    functionCreateDirectoryPathStringboolean1: TMenuItem;
    functionGetFileVersionFilePathStrhingString1: TMenuItem;
    functionCompareVersionsFilePathStringinteger1: TMenuItem;
    Version1: TMenuItem;
    Directory2: TMenuItem;
    Files1: TMenuItem;
    SharpApi2: TMenuItem;
    Directories1: TMenuItem;
    ServiceResults1: TMenuItem;
    MRSTARTED1: TMenuItem;
    MRSTOPPED1: TMenuItem;
    MRERRORSTARTING1: TMenuItem;
    MROK1: TMenuItem;
    MRINCOMPATIBLE1: TMenuItem;
    MBERRORSTOPPING1: TMenuItem;
    MRSTARTED2: TMenuItem;
    MRFORCECONFIGDISABLE1: TMenuItem;
    Services1: TMenuItem;
    functionServiceStartServiceStringhresult1: TMenuItem;
    functionServiceStopServicePCharhresult1: TMenuItem;
    functionServiceMsgServiceMessageStringhresult1: TMenuItem;
    functionIsServicesStartedServicePCharhresult1: TMenuItem;
    ScriptEngine1: TMenuItem;
    LOGWINDOWOFF1: TMenuItem;
    LOGWINDOWAUTOCLOSEON1: TMenuItem;
    Windows1: TMenuItem;
    Directrories1: TMenuItem;
    SystemInformations1: TMenuItem;
    WINDOWSDIR1: TMenuItem;
    WINDOWSSYSTEMDIR1: TMenuItem;
    WINDOWSTEMPDIR1: TMenuItem;
    DESKTOPDIR1: TMenuItem;
    STARTUPDIR1: TMenuItem;
    COMMONSTARTUPDIR1: TMenuItem;
    USERNAME1: TMenuItem;
    COMPUTERNAME1: TMenuItem;
    DOMAINNAME1: TMenuItem;
    SHARPEDIR1: TMenuItem;
    procedure LOGWINDOWOFF1Click(Sender: TObject);
    procedure JvInterpreterStatement(Sender: TObject);
    procedure btn_insertClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GenericPopupClick(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ed_scriptPaintGutter(Sender: TObject; Canvas: TCanvas);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  CreateGenericScriptForm: TCreateGenericScriptForm;

implementation

uses SharpApi,
     MainWnd,
     SharpApi_Adapter,
     SharpBase_Adapter, SharpFileUtils_Adapter;

{$R *.dfm}

procedure TCreateGenericScriptForm.ed_scriptPaintGutter(Sender: TObject;
  Canvas: TCanvas);
var
  i: Integer;
  R: TRect;
  oldFont: TFont;
begin
  oldFont := TFont.Create;
  try
    oldFont.Assign(Canvas.Font);
    Canvas.Font := ed_script.Font;
    with ed_script do
      for i := TopRow to TopRow + VisibleRowCount do
      begin
        R := Bounds(2, (i - TopRow) * CellRect.Height, GutterWidth - 2 - 5, CellRect.Height);
        Windows.DrawText(Canvas.Handle, PChar(IntToStr(i + 1)), -1, R, DT_RIGHT or DT_VCENTER or DT_SINGLELINE);
      end;
  finally
    Canvas.Font := oldFont;
    oldFont.Free;
  end;
end;

procedure TCreateGenericScriptForm.ToolButton2Click(Sender: TObject);
var
  errors : boolean;
begin
  lb_errors.Clear;
  lb_errors.Items.Add('Running Script...');
  lb_errors.Items.Add('');
  JvInterpreter.Pas.CommaText := ed_script.Lines.CommaText;
  errors := True;

  SharpApi_Adapter.RegisterAPILog(lb_errors.Items);
  SharpBase_Adapter.RegisterBaseLog(lb_errors.Items);
  SharpFileUtils_Adapter.RegisterFileUtilsLog(lb_errors.Items);

  try
    JvInterpreter.Run;
    errors := False;
  except
    on E: Exception do lb_errors.Items.Add('Error: ' + E.Message);
  end;
  lb_errors.Items.Add('');
  if not errors then lb_errors.Items.Add('No Errors Found!');

  SharpApi_Adapter.UnRegisterAPILog;
  SharpBase_Adapter.UnRegisterBaseLog;
  SharpFileUtils_Adapter.UnRegisterFileUtilsLog;
end;

procedure TCreateGenericScriptForm.ToolButton1Click(Sender: TObject);
var
  Dir : String;
begin
  if OpenScript.InitialDir = '' then
  begin
    Dir :=  SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
    ForceDirectories(Dir);
    OpenScript.InitialDir := Dir;
  end;

  if OpenScript.Execute then
  begin
    ed_script.Lines.LoadFromFile(OpenScript.FileName);
  end;
end;

procedure TCreateGenericScriptForm.ToolButton4Click(Sender: TObject);
var
  Dir : String;
begin
  if SaveScript.InitialDir = '' then
  begin
    Dir :=  SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
    ForceDirectories(Dir);
    SaveScript.InitialDir := Dir;
  end;

  if SaveScript.Execute then
  begin
    if CompareText(ExtractFileExt(SaveScript.FileName),'.sescript') = 0 then
       ed_script.Lines.SaveToFile(SaveScript.FileName)
       else ed_script.Lines.SaveToFile(SaveScript.FileName + '.sescript');
  end;
end;

procedure TCreateGenericScriptForm.GenericPopupClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then exit;

  ed_script.InsertText(TMenuItem(Sender).Hint);
  ed_script.Refresh;
end;

procedure TCreateGenericScriptForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.Show;
end;

procedure TCreateGenericScriptForm.btn_insertClick(Sender: TObject);
var
  p : TPoint;
begin
  p := ToolBar2.ClientToScreen(Point(btn_insert.Left,btn_insert.Top));
  btn_insert.DropdownMenu.Popup(p.X,p.y+btn_insert.Height);
end;

procedure TCreateGenericScriptForm.JvInterpreterStatement(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure TCreateGenericScriptForm.LOGWINDOWOFF1Click(Sender: TObject);
begin
  if not (Sender is TMenuItem) then exit;

  ed_script.Lines.Insert(0,TMenuItem(Sender).Hint);
  ed_script.Refresh;
end;

end.
