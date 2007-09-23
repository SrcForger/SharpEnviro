unit PluginManager2Wnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPluginManager2Form = class(TForm)
    lstAvailable: TListBox;
    lstActiveLeft: TListBox;
    btnAddLeft: TButton;
    btnRemoveLeft: TButton;
    lblAvailableModules: TLabel;
    lblActiveLeft: TLabel;
    lstActiveRight: TListBox;
    btnAddRight: TButton;
    btnRemoveRight: TButton;
    lblActiveRight: TLabel;
    btnActiveRightMoveLeft: TButton;
    btnActiveRightMoveRight: TButton;
    btnActiveLeftMoveLeft: TButton;
    btnActiveLeftMoveRight: TButton;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormShow(Sender: TObject);
    procedure btnAddLeftClick(Sender: TObject);
    procedure btnAddRightClick(Sender: TObject);
    procedure btnRemoveLeftClick(Sender: TObject);
    procedure btnRemoveRightClick(Sender: TObject);
    procedure btnActiveLeftMoveLeftClick(Sender: TObject);
    procedure btnActiveLeftMoveRightClick(Sender: TObject);
    procedure btnActiveRightMoveLeftClick(Sender: TObject);
    procedure btnActiveRightMoveRightClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdatePluginList;
  end;

var
  PluginManager2Form: TPluginManager2Form;

implementation

uses SharpBarMainWnd,
     uSharpEModuleManager;
{$R *.dfm}

procedure TPluginManager2Form.btnActiveLeftMoveLeftClick(Sender: TObject);
var
  cp : integer;
begin
  cp := lstActiveLeft.ItemIndex;
  if (cp <> -1) then
  begin
    ModuleManager.MoveModule(cp,-1);
    ModuleManager.SortModulesByPosition;
    ModuleManager.FixModulePositions;
    UpdatePluginList;
    SharpBarMainForm.SaveBarSettings;
    lstActiveLeft.ItemIndex := cp-1;
  end;
  exit;
end;

procedure TPluginManager2Form.btnActiveLeftMoveRightClick(Sender: TObject);
var
  cp : integer;
begin
  cp := lstActiveLeft.ItemIndex;
  if (cp <> -1) then
  begin
    ModuleManager.MoveModule(cp,1);
    ModuleManager.SortModulesByPosition;
    ModuleManager.FixModulePositions;
    UpdatePluginList;
    SharpBarMainForm.SaveBarSettings;
    lstActiveLeft.ItemIndex := cp+1;
  end;
  exit;
end;

procedure TPluginManager2Form.btnActiveRightMoveLeftClick(Sender: TObject);
var
  ri : integer;
  cp : integer;
begin
  ri := ModuleManager.GetFirstRModuleIndex; // index of the first right aligned module
  cp := lstActiveRight.ItemIndex;
  if (cp <> -1) then
  begin
    ModuleManager.MoveModule(ri+cp,-1);
    ModuleManager.SortModulesByPosition;
    ModuleManager.FixModulePositions;
    UpdatePluginList;
    SharpBarMainForm.SaveBarSettings;
    lstActiveRight.ItemIndex := cp-1;
  end;
  exit;
end;

procedure TPluginManager2Form.btnActiveRightMoveRightClick(Sender: TObject);
var
  ri : integer;
  cp : integer;
begin
  ri := ModuleManager.GetFirstRModuleIndex; // index of the first right aligned module
  cp := lstActiveRight.ItemIndex;
  if (cp <> -1) then
  begin
    ModuleManager.MoveModule(ri+cp,1);
    ModuleManager.SortModulesByPosition;
    ModuleManager.FixModulePositions;
    UpdatePluginList;
    SharpBarMainForm.SaveBarSettings;
    lstActiveRight.ItemIndex := cp+1;
  end;
  exit;
end;

procedure TPluginManager2Form.btnAddLeftClick(Sender: TObject);
// -1 = left-aligned
// +1 = right-aligned
begin
    if lstAvailable.ItemIndex <> -1 then
    ModuleManager.CreateModule(lstAvailable.ItemIndex,-1);
    UpdatePluginList;
    SharpBarMainForm.SaveBarSettings;
end;

procedure TPluginManager2Form.btnAddRightClick(Sender: TObject);
begin
    if lstAvailable.ItemIndex <> -1 then
    ModuleManager.CreateModule(lstAvailable.ItemIndex,1);
    UpdatePluginList;
    SharpBarMainForm.SaveBarSettings;
end;

procedure TPluginManager2Form.btnRemoveLeftClick(Sender: TObject);

begin
  if lstActiveLeft.ItemIndex = -1 then exit; // nothing selected
  if (lstActiveLeft.ItemIndex > ModuleManager.Modules.Count - 1) then exit;
  ModuleManager.Delete(TModule(ModuleManager.Modules.Items[lstActiveLeft.ItemIndex]).ID);
  UpdatePluginList;
  SharpBarMainForm.SaveBarSettings;
end;

procedure TPluginManager2Form.btnRemoveRightClick(Sender: TObject);
var
  ri : integer; // right-aligned index
begin
  if lstActiveRight.ItemIndex = -1 then exit; // nothing selected
  if (lstActiveRight.ItemIndex > ModuleManager.Modules.Count - 1) then exit;
  ri := ModuleManager.GetFirstRModuleIndex;
  ModuleManager.Delete(TModule(ModuleManager.Modules.Items[lstActiveRight.ItemIndex+ri]).ID);
  UpdatePluginList;
  SharpBarMainForm.SaveBarSettings;
end;

procedure TPluginManager2Form.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := WS_EX_APPWINDOW;
end;

procedure TPluginManager2Form.UpdatePluginList;
var
 n : integer;
 tempModule : TModule;
 mName, mCaption : String;
begin
  lstActiveLeft.Clear;
  lstActiveRight.Clear;
  for n := 0 to ModuleManager.Modules.Count -1 do
  begin
    tempModule := TModule(ModuleManager.Modules.Items[n]);
    mName := ExtractFileName(tempModule.ModuleFile.FileName);
    mCaption := TForm(tempModule.Control).Caption;
    if (tempModule.Position <> -1)
    then lstActiveRight.Items.Add(mName + ' (' + mCaption + ')')
    else lstActiveLeft.items.Add(mName + ' (' + mCaption + ')');
  end;
end;

procedure TPluginManager2Form.FormShow(Sender: TObject);
var
 n : integer;
 tempModuleFile : TModuleFile;
begin
  ModuleManager.RefreshFromDirectory(ModuleManager.ModuleDirectory);

  lstAvailable.Clear;
  for n := 0 to ModuleManager.ModuleFiles.Count -1 do
  begin
    tempModuleFile := TModuleFile(ModuleManager.ModuleFiles.Items[n]);
    lstAvailable.Items.Add(ExtractFileName(tempModuleFile.FileName));
  end;
  if lstAvailable.Items.Count > 0  then
     lstAvailable.ItemIndex := 0;
  UpdatePluginList;
end;

end.
