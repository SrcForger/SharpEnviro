unit AddPluginWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAddPluginForm = class(TForm)
    list_plugins: TListBox;
    btn_ok: TButton;
    btn_cancel: TButton;
    Label1: TLabel;
    rb_left: TRadioButton;
    lb_right: TRadioButton;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  AddPluginForm: TAddPluginForm;

implementation

uses SharpBarMainWnd,
     uSharpEModuleManager;
{$R *.dfm}

procedure TAddPluginForm.FormShow(Sender: TObject);
var
 n : integer;
 tempModuleFile : TModuleFile;
begin
  ModuleManager.RefreshFromDirectory(ModuleManager.ModuleDirectory);

  list_plugins.Clear;
  for n := 0 to ModuleManager.ModuleFiles.Count -1 do
  begin
    tempModuleFile := TModuleFile(ModuleManager.ModuleFiles.Items[n]);
    list_plugins.Items.Add(ExtractFileName(tempModuleFile.FileName));
  end;
  if list_plugins.Items.Count > 0  then
     list_plugins.ItemIndex := 0;
end;

end.
