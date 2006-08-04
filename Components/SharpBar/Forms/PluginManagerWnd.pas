unit PluginManagerWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPluginManagerForm = class(TForm)
    list_plugins: TListBox;
    btn_delete: TButton;
    btn_left: TButton;
    btn_right: TButton;
    btn_addplugin: TButton;
    btn_close: TButton;
    procedure btn_rightClick(Sender: TObject);
    procedure btn_leftClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure list_pluginsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
    procedure btn_addpluginClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure UpdatePluginList;
    procedure UpdateButtonStatus;
  end;

const
 RIGHT_ALIGN_LISTBOX_STRING = '==== Right Aligned Plugins ====';

var
  PluginManagerForm: TPluginManagerForm;

implementation

uses AddPluginWnd,
     SharpBarMainWnd,
     uSharpEModuleManager;

{$R *.dfm}

procedure TPluginManagerForm.UpdatePluginList;
var
 n,ri : integer;
 tempModule : TModule;
 mName, mCaption : String;
begin
  list_plugins.Clear;
  ri := ModuleManager.GetFirstRModuleIndex; // index of the first right aligned module
  for n := 0 to ModuleManager.Modules.Count -1 do
  begin
    if n = ri then list_plugins.Items.Add(RIGHT_ALIGN_LISTBOX_STRING);
    tempModule := TModule(ModuleManager.Modules.Items[n]);
    mName := ExtractFileName(tempModule.ModuleFile.FileName);
    mCaption := TForm(tempModule.Control).Caption;
    list_plugins.Items.Add(mName + ' (' + mCaption + ')');
  end;
  if ri = -1 then list_plugins.Items.Add(RIGHT_ALIGN_LISTBOX_STRING);
  UpdateButtonStatus;
end;

procedure TPluginManagerForm.UpdateButtonStatus;
label ExitCode;
begin
  if (list_plugins.ItemIndex = -1) or (list_plugins.Items.Count = 0) then
  begin
    ExitCode:
    btn_delete.Enabled := False;
    btn_right.Enabled := False;
    btn_left.Enabled := False;
    exit;
  end;
  if list_plugins.Items[list_plugins.ItemIndex] = RIGHT_ALIGN_LISTBOX_STRING then goto ExitCode;
  btn_delete.Enabled := True;
  btn_right.Enabled := True;
  btn_left.Enabled := True;
  if list_plugins.ItemIndex = 0 then btn_left.Enabled := False;
  if list_plugins.ItemIndex = list_plugins.Count - 1 then btn_right.Enabled := False;
end;

procedure TPluginManagerForm.btn_addpluginClick(Sender: TObject);
var
  tempModuleFile : TModuleFile;
  i : integer;
begin
  if AddPluginForm.Showmodal = mrOk then
  begin
    if AddPluginForm.list_plugins.ItemIndex <> -1 then
    begin
      tempModuleFile := TModuleFile(ModuleManager.ModuleFiles.Items[AddPluginForm.list_plugins.ItemIndex]);
      if AddPluginForm.rb_left.Checked then i := -1
         else i := 1;
      ModuleManager.CreateModule(AddPluginForm.list_plugins.ItemIndex,i);
    end;
  end;
  UpdatePluginList;
  SharpBarMainForm.SaveBarSettings;
end;

procedure TPluginManagerForm.btn_closeClick(Sender: TObject);
begin
  Close;
  SharpBarMainForm.SaveBarSettings;
end;

procedure TPluginManagerForm.FormShow(Sender: TObject);
begin
  UpdatePluginList;
end;

procedure TPluginManagerForm.list_pluginsClick(Sender: TObject);
begin
  UpdateButtonStatus;
end;

procedure TPluginManagerForm.btn_deleteClick(Sender: TObject);
var
  ri : integer;
  cp : integer;
begin
  if list_plugins.ItemIndex = -1 then exit;

  ri := ModuleManager.GetFirstRModuleIndex; // index of the first right aligned module
  cp := list_plugins.ItemIndex;
  if (cp > ri) and (ri <> -1) then cp := cp -1;

  if (cp > ModuleManager.Modules.Count - 1) then exit;
  ModuleManager.Delete(TModule(ModuleManager.Modules.Items[cp]).ID);
  UpdatePluginList;
  SharpBarMainForm.SaveBarSettings;
end;

procedure TPluginManagerForm.btn_leftClick(Sender: TObject);
var
  ri : integer;
  cp : integer;
begin
  ri := ModuleManager.GetFirstRModuleIndex; // index of the first right aligned module
  cp := list_plugins.ItemIndex;
  if (cp > ri) and (ri <> -1) then cp := cp -1;
  ModuleManager.MoveModule(cp,-1);
  ModuleManager.SortModulesByPosition;
  ModuleManager.FixModulePositions;
  UpdatePluginList;
  SharpBarMainForm.SaveBarSettings;
  exit;
end;

procedure TPluginManagerForm.btn_rightClick(Sender: TObject);
var
  ri : integer;
  cp : integer;
begin
  ri := ModuleManager.GetFirstRModuleIndex; // index of the first right aligned module
  cp := list_plugins.ItemIndex;
  if (cp > ri) and (ri <> -1) then cp := cp -1;
  ModuleManager.MoveModule(cp,1);
  ModuleManager.SortModulesByPosition;
  ModuleManager.FixModulePositions;
  UpdatePluginList;
  SharpBarMainForm.SaveBarSettings;
  exit;
end;

end.
