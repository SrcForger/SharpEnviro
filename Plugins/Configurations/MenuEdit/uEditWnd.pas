unit uEditWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  JvExControls,
  JvPageList,
  StdCtrls,
  JvLabel,
  uSharpEMenuItem,
  uSharpEMenu,
  ExtCtrls,
  SharpDialogs,
  pngimage,
  SharpCenterApi,
  SharpApi,
  SharpEGaugeBoxEdit;

type
  TPageData = class
  private
    FPage: TJvCustomPage;
    FMenuItemType: TSharpEMenuItemType;
    FHeight: Integer;
    FDescription: string;
  public
    property Page: TJvCustomPage read FPage write FPage;
    property MenuItemType: TSharpEMenuItemType read FMenuItemType write FMenuItemType;
    property Height: Integer read FHeight write FHeight;
    property Description: string read FDescription write FDescription;
    constructor Create(APage: TJvCustomPage; AMenuItemType: TSharpEMenuItemType;
      AHeight: Integer; ADescription: string);
  end;

  TfrmEdit = class(TForm)
    plMenuItems: TJvPageList;
    pagLink: TJvStandardPage;
    edLinkName: TLabeledEdit;
    pagDriveList: TJvStandardPage;
    edLinkIcon: TLabeledEdit;
    btnLinkIconBrowse: TButton;
    edLinkTarget: TLabeledEdit;
    btnLinkTargetBrowse: TButton;
    pnlHeader: TPanel;
    Label3: TJvLabel;
    JvLabel1: TJvLabel;
    cbMenuItems: TComboBox;
    cbItemPosition: TComboBox;
    chkDriveNames: TCheckBox;
    pagLabel: TJvStandardPage;
    edLabelCaption: TLabeledEdit;
    pagSubMenu: TJvStandardPage;
    edSubmenuCaption: TLabeledEdit;
    edSubmenuIcon: TLabeledEdit;
    btnSubmenuIconBrowse: TButton;
    edSubmenuTarget: TLabeledEdit;
    btnSubmenuTargetBrowse: TButton;
    pagDynamicDir: TJvStandardPage;
    tmr: TTimer;
    edDynamicDirTarget: TLabeledEdit;
    btnDynamicDirBrowse: TButton;
    sgbDynamicDirMaxItems: TSharpeGaugeBox;
    Label1: TLabel;
    Label2: TLabel;
    cbDynamicDirSort: TComboBox;
    edDynamicDirFilter: TLabeledEdit;
    lblDescription: TLabel;
    pagBlank: TJvStandardPage;
    Label4: TLabel;
    chkRecursive: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cbMenuItemsSelect(Sender: TObject);
    procedure btnLinkIconBrowseClick(Sender: TObject);
    procedure btnLinkTargetBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSubmenuIconBrowseClick(Sender: TObject);
    procedure btnSubmenuTargetBrowseClick(Sender: TObject);
    procedure tmrTimer(Sender: TObject);
    procedure btnDynamicDirBrowseClick(Sender: TObject);
    procedure GenericUpdateEditState(Sender: TObject);
    procedure sgbDynamicDirMaxItemsChangeValue(Sender: TObject; Value: Integer);
    procedure cbItemPositionChange(Sender: TObject);
  private
    { Private declarations }
    FEditMode: TSCE_EDITMODE_ENUM;
    FUpdating: Boolean;
    procedure InitWnd;
    procedure SelectMenuItemType(AItemType: TSharpEMenuItemType);
    procedure SetEditMode(const Value: TSCE_EDITMODE_ENUM);
    procedure UpdateEditState;
  public
    { Public declarations }
    procedure InitUI(AEditMode: TSCE_EditMode_Enum);
    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write SetEditMode;
    function ValidateEdit(AEditMode: TSCE_EditMode_Enum): Boolean;
    function Save(AEditMode: TSCE_EditMode_Enum; AApply: Boolean): Boolean;
  end;

var
  frmEdit: TfrmEdit;
  nMenuItemIndex, nInsertIndex: Integer;

const
  cLinkDescription = 'This menu item will create links to files, directories, drives, actions and more.';
  cSepDescription = 'This menu item will create a simple divider.';
  cDriveListDescription = 'This dynamic menu item will create a list of all system drives.';
  cCplDescription = 'This dynamic menu item will create a list of all control panel applets.';
  cDesktopObjectListDescription = 'This dynamic menu item will create a list of all available desktop objects.';
  cLabelDescription = 'This menu item will create a simple label.';
  cSubmenuDescription = 'This menu item will create a new submenu. The target specifies what action to perform when the submenu is clicked (if any).';
  cSelectDescription = 'Please select the menu item to insert.';
  cDynamicDirDescription = 'This dynamic menu item will create a menu of files/directories. If multiple dynamic folders are used within the same submenu, all items are combined.';

implementation

uses
  uListWnd;

{$R *.dfm}

procedure TfrmEdit.InitUI(AEditMode: TSCE_EditMode_Enum);
var
  tmpItem: TItemData;
  tmpMenuItemType: TSharpEMenuItemType;
begin

  case AEditMode of
    sceAdd: begin

        FUpdating := True;
        try
          tmpMenuItemType := TPageData(cbMenuItems.Items.Objects[nMenuItemIndex]).MenuItemType;
          cbMenuItems.Enabled := True;
          cbItemPosition.Enabled := True;

          case tmpMenuItemType of
            mtLink: begin
                edLinkName.Text := '';
                edLinkIcon.Text := '';
                edLinkTarget.Text := '';
                SelectMenuItemType(tmpMenuItemType);
              end;
            mtSeparator: begin
                SelectMenuItemType(tmpMenuItemType);
              end;
            mtCPLList: begin
                SelectMenuItemType(tmpMenuItemType);
              end;
            mtDesktopObjectList: begin
                SelectMenuItemType(tmpMenuItemType);
              end;
            mtDriveList: begin
                chkDriveNames.Checked := False;
                SelectMenuItemType(tmpMenuItemType);
              end;
            mtLabel: begin
                edLabelCaption.Text := '';
                SelectMenuItemType(tmpMenuItemType);
              end;
            mtSubMenu: begin
                edSubmenuCaption.Text := '';
                edSubmenuIcon.Text := '';
                edSubmenuTarget.Text := '';
                SelectMenuItemType(tmpMenuItemType);
              end;
            mtDynamicDir: begin
                edDynamicDirTarget.Text := '';
                edDynamicDirFilter.Text := '';
                cbDynamicDirSort.ItemIndex := 0;
                chkRecursive.Checked := false;
                sgbDynamicDirMaxItems.Value := -1;
                SelectMenuItemType(tmpMenuItemType);
              end;

          end;
        finally
          FUpdating := False;
        end;

      end;
    sceEdit: begin

        if frmList.lbItems.SelectedItem = nil then
          exit;

        FUpdating := True;
        try
          tmpItem := TItemData(frmList.lbItems.SelectedItem.Data);
          cbMenuItems.Enabled := False;
          cbItemPosition.Enabled := False;

          case tmpItem.MenuItem.ItemType of
            mtLink: begin
                edLinkName.Text := tmpItem.MenuItem.Caption;
                edLinkIcon.Text := tmpItem.MenuItem.PropList.GetString('IconSource');
                edLinkTarget.Text := tmpItem.MenuItem.PropList.GetString('Action');
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;
            mtSeparator: begin
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;
            mtCPLList: begin
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;
            mtDesktopObjectList: begin
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;
            mtDriveList: begin
                chkDriveNames.Checked := (tmpItem.MenuItem.PropList.GetBool('ShowDriveNames'));
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;
            mtLabel: begin
                edLabelCaption.Text := tmpItem.MenuItem.Caption;
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;
            mtSubMenu: begin
                edSubmenuCaption.Text := tmpItem.MenuItem.Caption;
                edSubmenuIcon.Text := tmpItem.MenuItem.PropList.GetString('IconSource');
                edSubmenuTarget.Text := tmpItem.MenuItem.PropList.GetString('Target');
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;
            mtDynamicDir: begin
                edDynamicDirTarget.Text := tmpItem.MenuItem.PropList.GetString('Action');
                edDynamicDirFilter.Text := tmpItem.MenuItem.PropList.GetString('Filter');

                case tmpItem.MenuItem.PropList.GetInt('Sort') of
                  -1: cbDynamicDirSort.ItemIndex := 2;
                  0: cbDynamicDirSort.ItemIndex := 0;
                  1: cbDynamicDirSort.ItemIndex := 1;
                  2: cbDynamicDirSort.ItemIndex := 3;
                end;

                chkRecursive.Checked := tmpItem.MenuItem.PropList.GetBool('Recursive');
                sgbDynamicDirMaxItems.Value := tmpItem.MenuItem.PropList.GetInt('MaxItems');
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;

          end;

        finally
          FUpdating := False;
        end;
      end;
  end;
end;

procedure TfrmEdit.btnDynamicDirBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.TargetDialog([stiDirectory, stiShellFolders], Mouse.CursorPos);

  if s <> '' then
    edDynamicDirTarget.Text := s;

end;

procedure TfrmEdit.btnLinkIconBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.IconDialog(edLinkIcon.Text, SMI_ALL_ICONS, Mouse.CursorPos);

  if s <> '' then
    edLinkIcon.Text := s;
end;

procedure TfrmEdit.btnLinkTargetBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);

  if s <> '' then
    edLinkTarget.Text := s;

end;

procedure TfrmEdit.btnSubmenuIconBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.IconDialog(edSubmenuIcon.Text, SMI_ALL_ICONS, Mouse.CursorPos);

  if s <> '' then
    edSubmenuIcon.Text := s;
end;

procedure TfrmEdit.btnSubmenuTargetBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);

  if s <> '' then
    edSubmenuTarget.Text := s;
end;

procedure TfrmEdit.cbItemPositionChange(Sender: TObject);
begin
  nInsertIndex := cbItemPosition.ItemIndex;
end;

procedure TfrmEdit.cbMenuItemsSelect(Sender: TObject);
var
  tmp: TPageData;
begin

  frmList.lbItems.ControlState := frmList.lbItems.ControlState - [csLButtonDown];

  tmp := TPageData(cbMenuItems.Items.Objects[cbMenuItems.ItemIndex]);
  frmEdit.Height := 160; //tmp.Height;
  lblDescription.Caption := tmp.Description;

  nMenuItemIndex := cbMenuItems.ItemIndex;

  if tmp.page <> nil then
    tmp.Page.Show;

  case tmp.MenuItemType of
    mtLink, mtLabel, mtSubMenu, mtDynamicDir: CenterDefineEditState(False);
    mtSeparator, mtCPLList, mtDriveList, mtDesktopObjectList: if FEditMode = sceAdd then
        CenterDefineButtonState(scbConfigure, True);
  end;
end;

procedure TfrmEdit.GenericUpdateEditState(Sender: TObject);
begin
  UpdateEditState;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  cbMenuItems.Clear;
  cbMenuItems.AddItem('Link', Pointer(TPageData.Create(pagLink, mtLink, 130,
    cLinkDescription)));
  cbMenuItems.AddItem('Separator', Pointer(TPageData.Create(pagBlank, mtSeparator, 70,
    cSepDescription)));
  cbMenuItems.AddItem('Drive List', Pointer(TPageData.Create(pagDriveList, mtDriveList, 90,
    cDriveListDescription)));
  cbMenuItems.AddItem('Control Panel List', Pointer(TPageData.Create(pagBlank, mtCPLList, 70,
    cCplDescription)));
  cbMenuItems.AddItem('Desktop Object List', Pointer(TPageData.Create(pagBlank, mtDesktopObjectList, 70,
    cDesktopObjectListDescription)));
  cbMenuItems.AddItem('Label', Pointer(TPageData.Create(pagLabel, mtLabel, 100,
    cLabelDescription)));
  cbMenuItems.AddItem('Submenu', Pointer(TPageData.Create(pagSubMenu, mtSubMenu, 140,
    cSubmenuDescription)));
  cbMenuItems.AddItem('Dynamic Directory', Pointer(TPageData.Create(pagDynamicDir, mtDynamicDir, 140,
    cDynamicDirDescription)));
  cbMenuItems.ItemIndex := 0;
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  InitWnd;
end;

{ TItemData }

constructor TPageData.Create(APage: TJvCustomPage;
  AMenuItemType: TSharpEMenuItemType; AHeight: Integer; ADescription: string);
begin
  FPage := APage;
  FMenuItemType := AMenuItemType;
  FHeight := AHeight;
  FDescription := ADescription;
end;

procedure TfrmEdit.UpdateEditState;
begin
  if not (FUpdating) then
    CenterDefineEditState(True);
end;

procedure TfrmEdit.InitWnd;
begin
  cbMenuItems.ItemIndex := nMenuItemIndex;
  cbItemPosition.ItemIndex := nInsertIndex;
  cbMenuItemsSelect(nil);
end;

function TfrmEdit.Save(AEditMode: TSCE_EditMode_Enum; AApply: Boolean): Boolean;
var
  tmpMenuItemType: TSharpEMenuItemType;
  tmpMenuItem: TObject;
  tmpMenu: TSharpEMenu;
  nSort, nInsertPos, n: Integer;
  i: Integer;
  tmpItem: TItemData;
begin
  Result := True;
  if not (AApply) then
    exit;

  case AEditMode of
    sceAdd: begin

        tmpMenuItemType := TPageData(cbMenuItems.Items.Objects[cbMenuItems.ItemIndex]).MenuItemType;

        nInsertPos := -1;
        if frmList.lbItems.ItemIndex <> -1 then begin
          tmpMenuItem := TSharpEMenuItem(TItemData(frmList.lbItems.SelectedItem.Data).MenuItem);
          tmpMenu := TSharpEMenu(TSharpEMenuItem(tmpMenuItem).OwnerMenu);
          n := tmpMenu.Items.IndexOf(tmpMenuItem);
          nInsertPos := n;

          case cbItemPosition.ItemIndex of
            0: if n <> 0 then
                nInsertPos := n - 1;
            1: if n <> tmpMenu.Items.Count - 1 then
                nInsertPos := n + 1;
            2: nInsertPos := 0;
            3: nInsertPos := tmpMenu.Items.Count;
          end;
        end
        else begin
          if frmList.lbItems.Count = 0 then
            tmpMenu := frmList.Menu
          else begin
            tmpMenuItem := TSharpEMenuItem(TItemData(frmList.lbItems.item[0].Data).MenuItem);
            tmpMenu := TSharpEMenu(TSharpEMenuItem(tmpMenuItem).SubMenu);
          end;
        end;

        case tmpMenuItemType of
          mtLink: begin
              tmpMenuItem := tmpMenu.AddLinkItem(edLinkName.Text, edLinkTarget.Text,
                edLinkIcon.Text, False, nInsertPos);
            end;
          mtCPLList: begin
              tmpMenuItem := tmpMenu.AddControlPanelItem(False, nInsertPos);
            end;
          mtDesktopObjectList: begin
              tmpMenuItem := tmpMenu.AddObjectListItem(False, nInsertPos);
            end;
          mtSeparator: begin
              tmpMenuItem := tmpMenu.AddSeparatorItem(False, nInsertPos);
            end;
          mtDriveList: begin
              tmpMenuItem := tmpMenu.AddDriveListItem(chkDriveNames.Checked,
                False, nInsertPos);
            end;
          mtLabel: begin
              tmpMenuItem := tmpMenu.AddLabelItem(edLabelCaption.Text,
                False, nInsertPos);
            end;
          mtSubMenu: begin
              tmpMenuItem := tmpMenu.AddSubMenuItem(edSubmenuCaption.Text,
                edSubmenuIcon.Text, edSubmenuTarget.Text, False, nInsertPos);
              TSharpEMenuItem(tmpMenuItem).SubMenu :=
                TSharpEMenu.Create(TSharpEMenuItem(tmpMenuItem), frmList.smMain,
                frmList.Menu.Settings);
            end;
          mtDynamicDir: begin

              case cbDynamicDirSort.ItemIndex of
                0: nSort := 0;
                1: nSort := 1;
                2: nSort := -1;
                3: nSort := 2;
              else
                nSort := 0;
              end;

              tmpMenuItem := tmpMenu.AddDynamicDirectoryItem(edDynamicDirTarget.Text,
                sgbDynamicDirMaxItems.Value, nSort, edDynamicDirFilter.Text, chkRecursive.Checked, False,
                nInsertPos);
            end;

        end;

        nMenuItemIndex := cbMenuItems.ItemIndex;

        if frmList.IsParentMenu then
          frmList.RenderItems(tmpMenu, True, True)
        else
          frmList.RenderItems(tmpMenu);

        frmList.Save;

        for i := 0 to Pred(frmList.lbItems.Count) do begin
          if TItemData(frmList.lbItems.Item[i].Data).MenuItem = TSharpEMenuItem(tmpMenuItem) then begin
            frmList.lbItems.ItemIndex := i;
            Break;
          end;
        end;
      end;
    sceEdit: begin

        tmpItem := TItemData(frmList.lbItems.SelectedItem.Data);

        case tmpItem.MenuItem.ItemType of
          mtLink: begin
              tmpItem.MenuItem.Caption := edLinkName.Text;
              tmpItem.MenuItem.PropList.Add('IconSource', edLinkIcon.Text);
              tmpItem.MenuItem.PropList.Add('Action', edLinkTarget.Text);
            end;
          mtDriveList: begin
              tmpItem.MenuItem.PropList.Add('ShowDriveNames', chkDriveNames.Checked);
            end;
          mtLabel: begin
              tmpItem.MenuItem.Caption := edLabelCaption.Text;
            end;
          mtSubMenu: begin
              tmpItem.MenuItem.Caption := edSubmenuCaption.Text;
              tmpItem.MenuItem.PropList.Add('IconSource', edSubmenuIcon.Text);
              tmpItem.MenuItem.PropList.Add('Target', edSubmenuTarget.Text);
            end;
          mtDynamicDir: begin
              tmpItem.MenuItem.PropList.Add('Action', edDynamicDirTarget.Text);
              tmpItem.MenuItem.PropList.Add('Filter', edDynamicDirFilter.Text);

              case cbDynamicDirSort.ItemIndex of
                0: nSort := 0;
                1: nSort := 1;
                2: nSort := -1;
                3: nSort := 2;
              else
                nSort := 0;
              end;

              tmpItem.MenuItem.PropList.Add('Recursive', chkRecursive.Checked);
              tmpItem.MenuItem.PropList.Add('MaxItems', sgbDynamicDirMaxItems.Value);
              tmpItem.MenuItem.PropList.Add('Sort', nSort);
            end;
        end;

        frmList.Save;
        nMenuItemIndex := cbMenuItems.ItemIndex;
        frmList.lbItems.Invalidate;

      end;
  end;
end;

procedure TfrmEdit.SelectMenuItemType(AItemType: TSharpEMenuItemType);
var
  i: Integer;
begin
  for i := 0 to Pred(cbMenuItems.Items.Count) do begin
    if TPageData(cbMenuItems.Items.Objects[i]).MenuItemType = AItemType then begin
      cbMenuItems.ItemIndex := i;
      cbMenuItemsSelect(nil);
      exit;
    end;
  end;
end;

procedure TfrmEdit.SetEditMode(const Value: TSCE_EDITMODE_ENUM);
begin
  FEditMode := Value;
end;

procedure TfrmEdit.sgbDynamicDirMaxItemsChangeValue(Sender: TObject;
  Value: Integer);
begin
  UpdateEditState;
end;

procedure TfrmEdit.tmrTimer(Sender: TObject);
begin
  tmr.Enabled := False;
  CenterUpdateSize;
end;

function TfrmEdit.ValidateEdit(AEditMode: TSCE_EditMode_Enum): Boolean;
begin
  Result := True;
end;

end.

