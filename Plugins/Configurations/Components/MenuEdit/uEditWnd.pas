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
  SharpEGaugeBoxEdit,

  ISharpCenterHostUnit, JvXPCore, JvXPCheckCtrls;

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
    pagMru: TJvStandardPage;
    Label5: TLabel;
    sgbMruListCount: TSharpeGaugeBox;
    rbMruListRecentItems: TJvXPCheckbox;
    rbMruListMostUsedItems: TJvXPCheckbox;
    chkRecursive: TJvXPCheckbox;
    chkDescending: TJvXPCheckbox;
    chkDriveNames: TJvXPCheckbox;
    procedure FormCreate(Sender: TObject);
    procedure cbMenuItemsSelect(Sender: TObject);
    procedure btnLinkIconBrowseClick(Sender: TObject);
    procedure btnLinkTargetBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSubmenuIconBrowseClick(Sender: TObject);
    procedure btnSubmenuTargetBrowseClick(Sender: TObject);

    procedure btnDynamicDirBrowseClick(Sender: TObject);
    procedure GenericUpdateEditState(Sender: TObject);
    procedure sgbDynamicDirMaxItemsChangeValue(Sender: TObject; Value: Integer);
    procedure cbItemPositionChange(Sender: TObject);
    procedure rbMruListMostUsedItemsClick(Sender: TObject);
  private
    { Private declarations }
    FUpdating: Boolean;
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure InitWnd;
    procedure SelectMenuItemType(AItemType: TSharpEMenuItemType);
    procedure UpdateEditState;
  public
    { Public declarations }
    procedure InitUI;
    function ValidateEdit: Boolean;
    function Save(AApply: Boolean): Boolean;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
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
  cMruListDescription = 'This dynamic menu item will create a list from a defined mru type';

implementation

uses
  uListWnd;

{$R *.dfm}

procedure TfrmEdit.InitUI;
var
  tmpItem: TItemData;
  tmpMenuItemType: TSharpEMenuItemType;
  n: Integer;
begin

  case PluginHost.EditMode of
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
                chkDescending.Checked := false;
                sgbDynamicDirMaxItems.Value := -1;
                SelectMenuItemType(tmpMenuItemType);
              end;
            mtulist: begin
                rbMruListRecentItems.Checked := True;
                rbMruListMostUsedItems.Checked := False;
                sgbDynamicDirMaxItems.Value := 10;
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

                n := tmpItem.MenuItem.PropList.GetInt('Sort');
                case abs(n) of
                  1: cbDynamicDirSort.ItemIndex := 0;
                  3: cbDynamicDirSort.ItemIndex := 1;
                  2: cbDynamicDirSort.ItemIndex := 2;
                else cbDynamicDirSort.ItemIndex := 0;
                end;

                chkDescending.Checked := (n < 0);
                chkRecursive.Checked := tmpItem.MenuItem.PropList.GetBool('Recursive');
                sgbDynamicDirMaxItems.Value := tmpItem.MenuItem.PropList.GetInt('MaxItems');
                SelectMenuItemType(tmpItem.MenuItem.ItemType);
              end;
            mtulist: begin

                rbMruListRecentItems.Checked := False;
                rbMruListMostUsedItems.Checked := False;
                n := tmpItem.MenuItem.PropList.GetInt('ItemType');
                case n of
                  0: rbMruListRecentItems.Checked := True;
                  1: rbMruListMostUsedItems.Checked := True;
                end;

                sgbMruListCount.Value := tmpItem.MenuItem.PropList.GetInt('Count');
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
  s := SharpDialogs.TargetDialog([stiDirectory], Mouse.CursorPos);

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
    mtLink, mtLabel, mtSubMenu, mtDynamicDir: PluginHost.SetEditing(False);
    mtSeparator, mtCPLList, mtDriveList, mtDesktopObjectList, mtulist: if PluginHost.EditMode = sceAdd then
      PluginHost.SetButtonVisibility(scbConfigure,True);
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
  cbMenuItems.AddItem('Mru List', Pointer(TPageData.Create(pagMru, mtulist, 140,
    cMruListDescription)));

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
    PluginHost.Editing := True;
end;

procedure TfrmEdit.InitWnd;
begin
  Self.DoubleBuffered := true;
  pnlHeader.DoubleBuffered := true;
  cbMenuItems.ItemIndex := nMenuItemIndex;
  cbItemPosition.ItemIndex := nInsertIndex;
  cbMenuItemsSelect(nil);
end;

procedure TfrmEdit.rbMruListMostUsedItemsClick(Sender: TObject);
begin
  rbMruListRecentItems.Checked := false;
  rbMruListMostUsedItems.Checked := false;

  TJvXPCheckbox(sender).Checked := true;
  UpdateEditState;
end;

function TfrmEdit.Save(AApply: Boolean): Boolean;
var
  tmpMenuItemType: TSharpEMenuItemType;
  tmpMenuItem: TObject;
  tmpMenu: TSharpEMenu;
  nSort, nInsertPos, n: Integer;
  i: Integer;
  tmpItem: TItemData;
begin
  Result := True;
  tmpMenuItem := nil;

  if not (AApply) then
    exit;

  case PluginHost.EditMode of
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
                0: nSort := 1;
                1: nSort := 3;
                2: nSort := 2;
              else nSort := 1;
              end;

              if chkDescending.Checked then
                nSort := 0 - nSort;

              tmpMenuItem := tmpMenu.AddDynamicDirectoryItem(edDynamicDirTarget.Text,
                sgbDynamicDirMaxItems.Value, nSort, edDynamicDirFilter.Text, chkRecursive.Checked, False,
                nInsertPos);
            end;
          mtulist: begin

              if rbMruListRecentItems.Checked then
                n := 0 else n := 1;
              tmpMenuItem := tmpMenu.AddUListItem(n,sgbMruListCount.Value,
                 False, nInsertPos);
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
                0: nSort := 1;
                1: nSort := 3;
                2: nSort := 2;
              else nSort := 1;
              end;

              if chkDescending.Checked then
                nSort := 0 - nSort;

              tmpItem.MenuItem.PropList.Add('Recursive', chkRecursive.Checked);
              tmpItem.MenuItem.PropList.Add('MaxItems', sgbDynamicDirMaxItems.Value);
              tmpItem.MenuItem.PropList.Add('Sort', nSort);
            end;
          mtulist: begin

            if rbMruListRecentItems.Checked then
              n := 0 else n := 1;

            tmpItem.MenuItem.PropList.Add('ItemType', n);
            tmpItem.MenuItem.PropList.Add('Count', sgbMruListCount.Value);

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

procedure TfrmEdit.sgbDynamicDirMaxItemsChangeValue(Sender: TObject;
  Value: Integer);
begin
  UpdateEditState;
end;

function TfrmEdit.ValidateEdit: Boolean;
begin
  Result := True;
end;

end.
