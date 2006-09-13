unit CreateGenericScriptWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvInterpreter, XPMan, ImgList, PngImageList,
  StdCtrls, ComCtrls, ToolWin, JvExControls, JvComponent, JvEditorCommon,
  JvEditor, JvHLEditor;

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

uses SharpApi;

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
  lb_errors.Items.Add('Compiling Script...');
  JvInterpreter.Pas.CommaText := ed_script.Lines.CommaText;
  errors := True;
  try
    JvInterpreter.Compile;
    errors := False;
  except
    on E: Exception do lb_errors.Items.Add('Error: ' + E.Message);
  end;
  if not errors then lb_errors.Items.Add('No Errors Found!');
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
    ed_script.Lines.SaveToFile(SaveScript.FileName);
  end;
end;

end.
