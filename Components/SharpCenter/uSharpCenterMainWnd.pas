{
Source Name: uSharpCenterMainWnd
Description: Main window for SharpCenter
Copyright (C) Pixol - pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}
unit uSharpCenterMainWnd;

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
  ComCtrls,
  ExtCtrls,
  Menus,
  StdCtrls,
  SharpApi,
  Buttons,
  PngSpeedButton,
  ImgList,
  pngimage,
  PngImageList,
  JvExControls,
  JvComponent,
  JclFileUtils,
  JclStrings,
  jvSimpleXml,
  Tabs,
  SharpEListBox,
  SharpESkinManager,
  uSharpCenterDllMethods,
  uSharpCenterManager,
  ToolWin,
  SharpERoundPanel,
  SharpETabList,
  GR32_Image,
  GR32,
  uVistaFuncs,
  JvLabel,
  JvPageList,
  SharpEListBoxEx,
  PngBitBtn,
  SharpThemeApi,
  Types, SharpEPageControl, SharpCenterApi;

const
  cEditTabHide = 0;
  cEditTabShow = 25;
  cEdit_Add = 0;
  cEdit_Edit = 1;
  //cEdit_Delete = 2;

type
  TSharpCenterWnd = class(TForm)
    pnlSettingTree: TPanel;
    pnlTree: TPanel;
    pnlMain: TPanel;
    PnlButtons: TPanel;
    btnSave: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    pnlContent: TPanel;
    tlToolbar: TSharpETabList;
    pnlToolbar: TSharpERoundPanel;
    plToolbar: TJvPageList;
    lbTree: TSharpEListBoxEx;
    picMain: TPngImageList;
    pilIcons: TPngImageList;
    pagFav: TJvStandardPage;
    pagHistory: TJvStandardPage;
    pagImport: TJvStandardPage;
    pagExport: TJvStandardPage;
    Label1: TLabel;
    edImportFilename: TEdit;
    btnImport: TPngSpeedButton;
    Label2: TLabel;
    Edit2: TEdit;
    PngSpeedButton2: TPngSpeedButton;
    lbHistory: TSharpEListBoxEx;
    pnlLivePreview: TPanel;
    imgLivePreview: TImage32;
    pnlPluginContainer: TSharpEPageControl;
    sbPlugin: TScrollBox;
    pnlPlugin: TPanel;
    pnlEditContainer: TSharpEPageControl;
    pnlEditPluginContainer: TSharpERoundPanel;
    pnlEditPlugin: TPanel;
    pnlEditToolbar: TPanel;
    btnEditCancel: TPngSpeedButton;
    btnEditApply: TPngSpeedButton;
    Timer1: TTimer;
    pnlTitle: TPanel;
    lblDescription: TJvLabel;
    lblTitle: TJvLabel;
    tmrClick: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tlPluginTabsTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure Timer1Timer(Sender: TObject);

    procedure tlEditItemTabClick(ASender: TObject; const ATabIndex: Integer);
    procedure btnEditApplyClick(Sender: TObject);
    procedure tlEditItemTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure tlToolbarTabClick(ASender: TObject; const ATabIndex: Integer);
    procedure tlToolbarTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure btnEditCancelClick(Sender: TObject);

    procedure btnFavouriteClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);

    procedure btnBackClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbTree_MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnHomeClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure sbPluginResize(Sender: TObject);
    procedure lbTreeClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure lbTreeGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure tmrClickTimer(Sender: TObject);
    procedure lbTreeGetCellColor(Sender: TObject; const AItem: TSharpEListItem;
      var AColor: TColor);
    procedure lbTreeGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
  private
    FCancelClicked: Boolean;
    FSelectedTabID: Integer;
    FSelectedPluginTabID: Integer;

    procedure UpdateLivePreview;
    procedure CenterMessage(var Msg: TMessage); message WM_SHARPCENTERMESSAGE;
    procedure WMTerminateMessage(var Msg: TMessage); message WM_SHARPTERMINATE;
    procedure ClickItem;

    procedure ShowHistory;
    procedure InitCommandLine;
    procedure DoDoubleBufferAll(AComponent: TComponent);
    procedure UpdateConfigHeader;
  public

    procedure GetCopyData(var Msg: TMessage); message wm_CopyData;

    procedure InitWindow;
    procedure InitToolbar;
    procedure UpdateSize;

    procedure EnabledWM(var Msg: TMessage); message CM_ENABLEDCHANGED;

    property SelectedTabID: Integer read FSelectedTabID write FSelectedTabID;

    procedure SetToolbarTabVisible(ATabID: TTabID; AVisible: Boolean);
    procedure LoadPluginEvent(Sender: TObject);
    procedure UnloadPluginEvent(Sender: TObject);
    procedure AddItemEvent(AItem: TSharpCenterManagerItem;
      const AIndex: Integer);
    procedure AddPluginTabsEvent(Sender: TObject);
    procedure UpdateThemeEvent(Sender: TObject);
    procedure InitNavEvent(Sender: TObject);
    procedure LoadEditEvent(Sender: TObject);
    procedure ApplyEditEvent(Sender: TObject);
    procedure CancelEditEvent(Sender: Tobject);
    procedure SavePluginEvent(Sender: TObject);
    procedure SetHomeTitleEvent(ATitle: String; ADescription: String);
  protected
  end;

var
  SharpCenterWnd: TSharpCenterWnd;

const
  GlobalItemHeight = 25;

implementation

uses
  SharpEScheme,
  uSharpCenterHelperMethods,
  uSharpCenterHistoryManager;

{$R *.dfm}

procedure TSharpCenterWnd.FormShow(Sender: TObject);
begin
  SCM.OnInitNavigation := InitNavEvent;
  SCM.OnAddNavItem := AddItemEvent;

  SCM.OnLoadPlugin := LoadPluginEvent;
  SCM.OnUnloadPlugin := UnloadPluginEvent;

  SCM.OnLoadEdit := LoadEditEvent;
  SCM.OnApplyEdit := ApplyEditEvent;
  SCM.OnCancelEdit := CancelEditEvent;

  SCM.OnAddPluginTabs := AddPluginTabsEvent;
  SCM.OnUpdateTheme := UpdateThemeEvent;
  SCM.OnSetHomeTitle := SetHomeTitleEvent;

  SCM.PngImageList := pilIcons;
  SCM.PluginContainer := pnlPlugin;
  SCM.EditWndContainer := pnlEditPlugin;
  SCM.PngImageList := picMain;

  InitWindow;
  InitToolbar;
  InitCommandLine;

end;

procedure TSharpCenterWnd.btnHomeClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try
    SCM.Unload;
    InitToolbar;

    SetToolbarTabVisible(tidHistory, False);
    SCM.BuildNavRoot;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.lbTree_MouseUp(Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if lbTree.ItemIndex = -1 then
    exit;

  ClickItem;
end;

procedure TSharpCenterWnd.FormResize(Sender: TObject);
begin

  if SCM <> nil then
    UpdateSize;
end;

procedure TSharpCenterWnd.GetCopyData(var Msg: TMessage);
var
  tmpMsg: TsharpE_DataStruct;
  tmpHist: TSharpCenterHistoryItem;
begin
  tmpMsg := PSharpE_DataStruct(PCopyDataStruct(msg.lParam)^.lpData)^;
  tmpHist := SCM.ActiveCommand;

  SCM.History.Add(tmpHist.Command, tmpHist.Param, tmpMsg.PluginID);
  SCM.ExecuteCommand(CenterCommandAsEnum(tmpMsg.Command),
    tmpMsg.Parameter, tmpMsg.PluginID);

end;

procedure TSharpCenterWnd.InitCommandLine;
var
  enumCommandType: TSCC_COMMAND_ENUM;
  strlTokens: TStringList;
  sApiParam: string;
  n: Integer;
  sPluginID: string;
  sCmd: string;
begin
  n := Pos('-api', CmdLine);
  if n <> 0 then
  begin
    sApiParam := Copy(CmdLine, n + 4, length(CmdLine));
    strlTokens := TStringlist.Create;
    try
      StrTokenToStrings(sApiParam, '|', strlTokens);
      enumCommandType := TSCC_COMMAND_ENUM(StrToInt(strlTokens[0]));
      sCmd := strlTokens[1];
      if 2 < strlTokens.Count then
        sPluginID := strlTokens[2];
      SCM.ExecuteCommand(enumCommandType, scmd, sPluginID);
    finally
      strlTokens.Free;
    end;
  end
  else
    SCM.BuildNavRoot;
end;

procedure TSharpCenterWnd.btnBackClick(Sender: TObject);
var
  tmpItem: TSharpCenterHistoryItem;
begin
  tmpItem := nil;
  if scm = nil then
    exit;

  if SCM.History.List.Count <> 0 then
    tmpItem := SCM.History.List.Last;

  if tmpItem <> nil then
  begin
    SCM.ExecuteCommand(tmpItem.Command, tmpItem.Param, tmpItem.PluginID);
    SCM.History.Delete(tmpItem);

    SetToolbarTabVisible(tidHistory, not (SCM.History.List.Count = 0));
  end;
end;

procedure TSharpCenterWnd.btnSaveClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try

    if SCM.CheckEditState then
    begin
      exit;
    end;

    SCM.StateEditItem := False;
    SCM.StateEditWarning := False;
    SCM.Save;

  finally
    LockWindowUpdate(0);
    btnSave.Enabled := False;
    btnCancel.Enabled := False;
  end;
end;

procedure TSharpCenterWnd.btnCancelClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try
    FCancelClicked := True;

    if @SCM.ActivePlugin.Open <> nil then
    begin
      SCM.StateEditItem := False;
      SCM.StateEditWarning := False;

      SCM.Unload;
    end;

    SCM.Reload;
  finally
    FCancelClicked := False;
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.EnabledWM(var Msg: TMessage);
begin
  SendMessage(self.Handle, msg.Msg, msg.WParam, msg.LParam);
end;

procedure TSharpCenterWnd.UpdateLivePreview;
var
  Bmp: TBitmap32;
begin
  if SCM = nil then
    exit;

  if (@SCM.ActivePlugin.UpdatePreview <> nil) then
  begin
    Bmp := TBitmap32.Create;
    Bmp.DrawMode := dmBlend;
    Bmp.CombineMode := cmMerge;
    Bmp.SetSize(pnlLivePreview.Width, 50);

    SCM.ActivePlugin.UpdatePreview(Bmp);

    imgLivePreview.Bitmap.SetSize(Bmp.Width, Bmp.Height);
    imgLivePreview.Bitmap.Clear(color32(clWindow));
    Bmp.DrawTo(imgLivePreview.Bitmap, 0, 0);

    //imgLivePreview.Height := Bmp.Height;
    pnlLivePreview.Height := Bmp.Height;

    Bmp.Free;
  end
  else
    pnlLivePreview.Height := 0;
end;

procedure TSharpCenterWnd.DoDoubleBufferAll(AComponent: TComponent);
var i: integer;
begin
  if Assigned(AComponent) then
  begin
    if AComponent is TWinControl then
      TWinControl(AComponent).DoubleBuffered := True;

    for i := 0 to AComponent.ComponentCount - 1 do
      DoDoubleBufferAll(AComponent.Components[i]);
  end;
end;

procedure TSharpCenterWnd.btnFavouriteClick(Sender: TObject);
begin
  //pnlToolbar.Visible := False;
end;

procedure TSharpCenterWnd.lbTreeClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
begin
  if lbTree.ItemIndex = -1 then
    exit;

  tmrClick.Enabled := True;
end;

procedure TSharpCenterWnd.lbTreeGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.ID = lbTree.ItemIndex then
    AColor := $00C1F4FE;
end;

procedure TSharpCenterWnd.lbTreeGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol = 0 then ACursor := crHandPoint;
end;

procedure TSharpCenterWnd.lbTreeGetCellText(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColText: string);
var
  tmp: TSharpCenterManagerItem;
begin
  tmp := TSharpCenterManagerItem(AItem.Data);
  if tmp = nil then exit;

  case ACol of
    0: AColText := tmp.Caption;
    1: AColText := tmp.Status;
  end;
end;

procedure TSharpCenterWnd.CenterMessage(var Msg: TMessage);
var
  bEnabled: Boolean;
  iBtnID: Integer;
  sName, sStatus, sTitle, sDescription: String;
begin
  if SCM = nil then
    exit;

  case msg.WParam of

    SCM_SET_TAB_SELECTED: begin

        SCM.StateEditItem := False;
        SCM.StateEditWarning := False;

        if pnlEditContainer.Minimized then
          FSelectedTabID := -1 else begin

        case Msg.LParam of
          integer(scbAddTab): begin
              pnlEditContainer.TabIndex := cEdit_Add;
              FSelectedTabID := cEdit_Add;
              SCM.LoadEdit(FSelectedTabID);
            end;
          integer(scbEditTab): begin
              pnlEditContainer.TabIndex := cEdit_Edit;
              FSelectedTabID := cEdit_Edit;
              SCM.LoadEdit(FSelectedTabID);
            end;
        end;
          end;
        UpdateThemeEvent(nil);
      end;

    SCM_SET_BUTTON_ENABLED, SCM_SET_BUTTON_DISABLED:
      begin

        bEnabled := (msg.WParam = SCM_SET_BUTTON_ENABLED);
        iBtnID := msg.LParam;
        case iBtnID of
          integer(scbImport): SetToolbarTabVisible(tidImport, bEnabled);
          integer(scbExport): SetToolbarTabVisible(tidExport, bEnabled);
          integer(scbDelete): btnEditApply.Enabled := bEnabled;
          integer(scbAddTab): pnlEditContainer.TabItems.Item[cEdit_Add].Visible := bEnabled;
          integer(scbEditTab): pnlEditContainer.TabItems.Item[cEdit_Edit].Visible := bEnabled;
          integer(scbConfigure): begin
            btnEditApply.Enabled := bEnabled;
            btnEditApply.Caption := 'Add';
            btnEditApply.PngImage := pilIcons.PngImages.Items[10].PngImage;
          end;
        end;
      end;

    SCM_SET_SETTINGS_CHANGED:
      begin
        btnSave.Enabled := True;
        btnCancel.Enabled := True;

        //UpdatePluginTabs;
      end;
    SCM_EVT_UPDATE_PREVIEW:
      begin
        UpdateLivePreview;
      end;
    SCM_SET_EDIT_STATE:
      begin
        if SCM.StateEditItem <> True then
          SCM.StateEditItem := True;
      end;
    SCM_SET_EDIT_CANCEL_STATE:
      begin
        SCM.StateEditItem := False;
      end;
    SCM_EVT_UPDATE_SETTINGS:
      begin
        SCM.UpdateSettingsBroadcast;
      end;
    SCM_EVT_UPDATE_SIZE:
      begin
        UpdateSize;
      end;
    SCM_EVT_UPDATE_TABS:
      begin
        SCM.LoadPluginTabs;
        lbTree.Refresh;
      end;
    SCM_EVT_UPDATE_CONFIG_TEXT:
      begin
        if (@SCM.ActivePlugin <> nil) then
          SCM.ActivePlugin.SetText(SCM.ActivePluginID, sName, sStatus,
            sTitle, sDescription);

        TSharpCenterManagerItem(lbTree.SelectedItem.Data).Caption := sName;
        TSharpCenterManagerItem(lbTree.SelectedItem.Data).Status := sStatus;
        TSharpCenterManagerItem(lbTree.SelectedItem.Data).Title := sTitle;
        TSharpCenterManagerItem(lbTree.SelectedItem.Data).Description := sDescription;
        lbTree.Refresh;

        UpdateConfigHeader;
      end;
  end;
end;

procedure TSharpCenterWnd.btnEditCancelClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try
    SCM.CancelEdit(FSelectedTabID);
  finally
    LockWindowUpdate(0);
    UpdateSize;
  end;
end;

procedure TSharpCenterWnd.SetHomeTitleEvent(ATitle, ADescription: String);
begin
  pnlTitle.Visible := True;
  lblTitle.Caption := ATitle;
  lblDescription.Caption := ADescription;
end;

procedure TSharpCenterWnd.SetToolbarTabVisible(ATabID: TTabID; AVisible:
  Boolean);
begin
  with tlToolbar.TabList do
  begin
    case ATabID of
      tidHome: Item[0].Visible := AVisible;
      tidFavourite: Item[1].Visible := AVisible;
      tidHistory: Item[2].Visible := AVisible;
      tidImport: Item[3].Visible := AVisible;
      tidExport: Item[4].Visible := AVisible;
    end;
  end;
  tlToolbar.TabIndex := 0;
  tlToolbar.Invalidate;
end;

procedure TSharpCenterWnd.tlToolbarTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
begin
  if pnlToolbar = nil then exit;

  if SCM.CheckEditState then
  begin
    AChange := False;
    exit;
  end;

  case ATabIndex of
    Integer(tidHome):
      begin
        pnlToolbar.Hide;
      end;
    Integer(tidFavourite):
      begin
        pnlToolbar.Show;
        pagFav.show;
      end;
    Integer(tidHistory):
      begin
        pnlToolbar.Hide;
      end;
    Integer(tidImport):
      begin
        pnlToolbar.Show;
        pagImport.Show;
      end;
    Integer(tidExport):
      begin
        pnlToolbar.Show;
        pagExport.Show;
      end;
  end;

end;

procedure TSharpCenterWnd.tlToolbarTabClick(ASender: TObject; const ATabIndex:
  Integer);
begin

  case ATabIndex of
    0: btnHomeClick(nil);
    //0: btnHome.Click;
    //1: btnFavourite.Click;
    2: btnBackClick(nil);
    //3: btnImport.Click;
   // 4: btnExport.Click  }
  //  end;
  end;
end;

procedure TSharpCenterWnd.tmrClickTimer(Sender: TObject);
begin
  tmrClick.Enabled := False;

  // If in edit state do not continue
  if SCM.CheckEditState then
    exit;

  ClickItem;
end;

procedure TSharpCenterWnd.tlEditItemTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
begin
  if SCM.CheckEditState then
  begin
    AChange := False;
    exit;
  end;

  case ATabIndex of
    Integer(tidAdd):
      begin
        pilIcons.PngImages.Items[10].Background := pnlEditToolbar.Color;
        btnEditApply.PngImage := pilIcons.PngImages.Items[10].PngImage;
      end;
    Integer(tidEdit):
      begin
        pilIcons.PngImages.Items[0].Background := pnlEditToolbar.Color;
        btnEditApply.PngImage := pilIcons.PngImages.Items[0].PngImage;
      end;
    Integer(tidDelete):
      begin
        pilIcons.PngImages.Items[2].Background := pnlEditToolbar.Color;
        btnEditApply.PngImage := pilIcons.PngImages.Items[2].PngImage;
      end;
  end;
end;

procedure TSharpCenterWnd.btnEditApplyClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try
    SCM.ApplyEdit(FSelectedTabID);
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.tlEditItemTabClick(ASender: TObject;
  const ATabIndex: Integer);
begin
  LockWindowUpdate(Self.Handle);
  try
    FSelectedTabID := ATabIndex;
    SCM.LoadEdit(FSelectedTabID);
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.InitWindow;
begin
  // Vista
  SetVistaFonts(Self);
  DoDoubleBufferAll(pnlTree);
  DoDoubleBufferAll(pnlTitle);
  DoDoubleBufferAll(lbTree);

  // Set Listbox defaults
  lbTree.Colors.BorderColorSelected := $00C1F4FE;

  // Reinit values
  FSelectedTabID := 0;
  FCancelClicked := False;

  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  pnlEditContainer.Height := 0;
  pnlLivePreview.Height := 0;
  pnlPluginContainer.Visible := False;
  pnlEditContainer.TabIndex := -1;
  pnlTitle.Visible := False;
  lblTitle.Font.Size := 10;
  lblDescription.Font.Color := clGrayText;
  //pnlTitle.DoubleBuffered := True;
  //pnlEditContainer.DoubleBuffered := True;
  //lbTree.DoubleBuffered := True;
  pnlToolbar.Hide;

end;

procedure TSharpCenterWnd.ClickItem;
var
  tmpItem: TSharpCenterManagerItem;
  tmpHistItem: TSharpCenterHistoryItem;
  tmpHist: TSharpCenterHistoryManager;
  tmpManager: TSharpCenterManager;
  sName: string;
begin
  LockWindowUpdate(Self.Handle);
  SCM.Unload;

  // Get the Button Data
  tmpItem := TSharpCenterManagerItem(lbTree.Item[lbTree.ItemIndex].Data);
  if tmpItem = nil then
    exit;

  sName := tmpItem.Caption;

  tmpHistItem := SCM.ActiveCommand;
  tmpHist := SCM.History;
  tmpManager := SCM;

  case tmpItem.ItemType of
    itmNone: ;
    itmFolder:
      begin

        tmpHist.Add(tmpHistItem.Command, tmpHistItem.Param,
          tmpHistItem.PluginID);

        tmpHistItem.Command := sccChangeFolder;
        tmpHistItem.Param := PathAddSeparator(tmpItem.Path);
        tmpHistItem.PluginID := '';

        tmpManager.BuildNavFromPath(tmpHistItem.Param);
        SetToolbarTabVisible(tidHistory, True);
      end;
    itmSetting:
      begin
        tmpHist.Add(tmpHistItem.Command, tmpHistItem.Param,
          tmpHistItem.PluginID);

        tmpHistItem.Command := sccLoadSetting;
        tmpHistItem.Param := tmpItem.Filename;
        tmpHistItem.PluginID := '';

        SetToolbarTabVisible(tidHistory, True);

        if fileexists(tmpHistItem.Param) then
        begin
          SCM.BuildNavFromFile(tmpItem.Filename);
        end;

      end;
    itmDll:
      begin
        SCM.Load(tmpItem.Filename, tmpItem.PluginID);
      end;
  end;
  LockWindowUpdate(0);
end;

procedure TSharpCenterWnd.InitToolbar;
begin
  // Hide Import Export + History
  SetToolbarTabVisible(tidImport, False);
  SetToolbarTabVisible(tidExport, False);
  SetToolbarTabVisible(tidHistory, False);

  // Hide Toolbar panel, and set tabindex to home
  pnlToolbar.Visible := False;
  tlToolbar.TabIndex := 0;
end;

procedure TSharpCenterWnd.UpdateSize;
var
  h: Integer;
begin
  UpdateLivePreview;

  lockwindowupdate(Self.Handle);
  try
    if (@SCM.ActivePlugin.Open <> nil) then
    begin
      if SCM.PluginWndHandle <> 0 then begin
        h := GetControlByHandle(SCM.PluginWndHandle).Height;
        pnlPlugin.Height := h;
        GetControlByHandle(SCM.PluginWndHandle).Width := pnlPlugin.Width;
      end;

      if @SCM.ActivePlugin.OpenEdit <> nil then
        if SCM.EditWndHandle <> 0 then
        begin
          pnlEditContainer.Minimized := False;
          pnlEditContainer.Height := 80 + GetControlByHandle(SCM.EditWndHandle).Height;
          GetControlByHandle(SCM.EditWndHandle).Width := pnlEditPlugin.Width;
        end else
          pnlEditContainer.Minimized := True;

    end;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.ShowHistory;
var
  i: Integer;
begin
  lbHistory.Clear;
  for i := 0 to SCM.History.Count-1 do
    lbHistory.AddItem(CenterCommandAsText(TSharpCenterHistoryItem(SCM.History.List[i]).Command) +
      ' ' + TSharpCenterHistoryItem(SCM.History.List[i]).Param + ' (' +
          TSharpCenterHistoryItem(SCM.History.List[i]).PluginID + ')',4);
end;

procedure TSharpCenterWnd.Timer1Timer(Sender: TObject);
begin
  ShowHistory;
end;

procedure TSharpCenterWnd.LoadPluginEvent(Sender: TObject);
var
  i: Integer;
begin
  // Resize Plugin window
  LockWindowUpdate(Self.Handle);
  try

    // Edit bar
    PnlButtons.Show;
    pnlEditContainer.Height := 0;
    if (@SCM.ActivePlugin.OpenEdit <> nil) then
      pnlEditContainer.Minimized := True;

    pnlEditContainer.TabItems.Item[cEdit_Add].Visible := True;
    pnlEditContainer.TabItems.Item[cEdit_Edit].Visible := True;

    if (@SCM.ActivePlugin.UpdatePreview <> nil) then
    begin
      pnlLivePreview.Height := 45;
    end;

    pnlToolbar.Hide;
    FSelectedTabID := 0;
    FSelectedPluginTabID := 0;

    if (SCM.ActivePlugin.ConfigMode = SharpApi.scmLive) then
      PnlButtons.Hide else
      PnlButtons.Show;

    if (@SCM.ActivePlugin.OpenEdit <> nil) then begin
      pnlEditContainer.TabList.TabIndex := -1;
    end;

    // Select in list
    for i := 0 to Pred(lbTree.Count) do begin
      if CompareText(TSharpCenterManagerItem(lbTree.Item[i].Data).Filename,
        SCM.ActivePlugin.Filename) = 0 then begin
        lbTree.ItemIndex := i;
        break;
      end;
    end;

    // Update Title and Description
    UpdateConfigHeader;

    TForm(GetControlByHandle(SCM.PluginWndHandle)).Color := clWindow;
  finally
    pnlPluginContainer.Show;

    // Forces a resize
    pnlPluginContainer.Height := pnlPluginContainer.Height+1;
    pnlPluginContainer.Height := pnlPluginContainer.Height-1;

    LockWindowUpdate(0);
    
    UpdateSize;
    CenterUpdateSize;

    sbPlugin.SetFocus;
  end;

end;

procedure TSharpCenterWnd.AddItemEvent(AItem: TSharpCenterManagerItem;
  const AIndex: Integer);
var
  tmp: TSharpEListItem;
begin
  tmp := lbTree.AddItem(AItem.Caption, AItem.IconIndex);
  tmp.AddSubItem(AItem.Status);
  tmp.Data := AItem;

  //if ((AIndex < lbTree.count) and (AIndex <> -1)) then
  //  lbTree.ItemIndex := AIndex;
end;

procedure TSharpCenterWnd.InitNavEvent(Sender: TObject);
begin
  lbTree.Clear;
  PnlButtons.Show;
end;

procedure TSharpCenterWnd.AddPluginTabsEvent(Sender: TObject);
var
  i {idx}: Integer;
  s: string;

begin
  pnlPluginContainer.TabList.Clear;

  if SCM.PluginTabs.Count <= 1 then begin
    pnlPluginContainer.TabList.Hide;
    sbPlugin.Margins.Top := 6;
    exit;
  end else begin
    pnlPluginContainer.TabList.Show;
    sbPlugin.Margins.Top := 32;
  end;

  LockWindowUpdate(Self.Handle);
  try

    s := '';
    for i := 0 to Pred(SCM.PluginTabs.Count) do
    begin
      pnlPluginContainer.TabList.Add(SCM.PluginTabs[i], -1, '');
    end;
    pnlPluginContainer.TabIndex := FSelectedPluginTabID;
  finally

    LockWindowUpdate(0);
    sbPlugin.Invalidate;
  end;
end;

procedure TSharpCenterWnd.UnloadPluginEvent(Sender: TObject);
begin

  // Check if Save first
  LockWindowUpdate(Self.Handle);
  try
    if ((btnSave.Enabled) and not (FCancelClicked)) then
    begin
      SCM.Save;
    end;

    // Handle proper closing of the edit window
    if @SCM.ActivePlugin.OpenEdit <> nil then
    begin

      if ((@SCM.ActivePlugin.CloseEdit <> nil) and (SCM.EditWndHandle <> 0))
        then
        SCM.ActivePlugin.CloseEdit(sceEdit, False);
    end;

  finally

    //tlPluginTabs.Height := 0;
    pnlEditContainer.TabList.TabIndex := -1;
    btnSave.Enabled := False;
    btnCancel.Enabled := False;
    pnlLivePreview.Height := 0;
    pnlEditContainer.Height := 0;
    pnlPluginContainer.Hide;
    pnlTitle.Hide;

    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.UpdateThemeEvent(Sender: TObject);
var
  colBackground, colItem, colSelectedItem: TColor;
  ctrl: TWinControl;
begin
  //LockWindowUpdate(Self.Handle);
  ctrl := nil;
  if SCM.EditWndHandle <> 0 then
    if GetControlByHandle(SCM.EditWndHandle) <> nil then
      ctrl := TForm(GetControlByHandle(SCM.EditWndHandle)).ActiveControl;
  try

    if @SCM.ActivePlugin.GetCenterScheme <> nil then
    begin

      if not (SCM.StateEditWarning) then
      begin
        colBackground := $00FBEFE3;
        colItem := clWindow;
        colSelectedItem := $00FBEFE3;
      end
      else
      begin
        colBackground := $00D9D6F9;
        colItem := clWindow;
        colSelectedItem := $00FBEFE3;
      end;

      SCM.ActivePlugin.GetCenterScheme(colBackground,
        colItem, colSelectedItem);

      pnlEditContainer.BackgroundColor := colBackground;
      pnlEditContainer.TabBackgroundColor := clWindow;
      pnlEditPluginContainer.Color := colBackground;
      pnlEditPlugin.Color := colBackground;
      pnlEditToolbar.Color := colBackground;
      pnlEditContainer.TabSelColor := colBackground;
      lbTree.Enabled := not (SCM.StateEditItem);

      btnEditCancel.Enabled := True;

      if (SCM.StateEditItem) then
      begin
        btnEditApply.Enabled := True;

        case FSelectedTabID of
          integer(tidAdd): btnEditApply.Caption := 'Add';
          integer(tidEdit): btnEditApply.Caption := 'Apply';
          integer(tidDelete):
            begin
              btnEditApply.Caption := 'Delete';
              btnEditApply.Visible := True;
            end;
        end;

        btnEditCancel.Caption := 'Cancel';

      end
      else
      begin
        btnEditApply.Enabled := False;

        case FSelectedTabID of
          integer(tidAdd): btnEditApply.Caption := 'Add';
          integer(tidEdit): btnEditApply.Caption := 'Edit';
          integer(tidDelete):
            begin
              btnEditApply.Caption := 'Delete';
              btnEditApply.Visible := True;
            end;
        end;

        btnEditCancel.Caption := 'Close';
      end;

    end;
  finally
    //lockWindowUpdate(0);
    if ctrl <> nil then
      ctrl.SetFocus;
  end;
end;

procedure TSharpCenterWnd.LoadEditEvent(Sender: TObject);
begin

  LockWindowUpdate(Self.Handle);
  try
    UpdateSize;
    CenterUpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.SavePluginEvent(Sender: TObject);
begin
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TSharpCenterWnd.UpdateConfigHeader;
var
  tmp: TSharpCenterManagerItem;
begin
  // Get Title and Description
  if lbTree.SelectedItem <> nil then
  begin
    tmp := TSharpCenterManagerItem(lbTree.SelectedItem.Data);
    if tmp <> nil then
    begin
      if (ExtractFileExt(tmp.Filename) = '.dll') then
      begin
        lblTitle.Caption := tmp.Title;
        lblDescription.Caption := tmp.Description;
        pnlTitle.Visible := (tmp.Title <> '');
      end;
    end;
  end;
end;

procedure TSharpCenterWnd.sbPluginResize(Sender: TObject);
begin
  if sbPlugin.VertScrollBar.IsScrollBarVisible then
    sbPlugin.Padding.Right := 6 else
    sbPlugin.Padding.Right := 0;
end;

procedure TSharpCenterWnd.ApplyEditEvent(Sender: TObject);
begin
  tlEditItemTabClick(pnlEditContainer.TabList, pnlEditContainer.TabList.TabIndex);
end;

procedure TSharpCenterWnd.CancelEditEvent(Sender: Tobject);
begin

  LockWindowUpdate(Self.Handle);
  try
    if Sender = nil then
    begin
      pnlEditContainer.TabList.TabIndex := -1;
      pnlEditContainer.Minimized := True;
    end
    else
      tlEditItemTabClick(pnlEditContainer.TabList, pnlEditContainer.TabList.TabIndex);
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.tlPluginTabsTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
var
  tmpStrItem: TStringItem;
begin
  LockWindowUpdate(Self.Handle);
  try

    if (ATabIndex > SCM.PluginTabs.Count - 1) then
      exit;
    if @SCM.ActivePlugin.ClickTab <> nil then begin

      tmpStrItem.FString := SCM.PluginTabs[ATabIndex];
      tmpStrItem.FObject := SCM.PluginTabs.Objects[ATabIndex];
      SCM.ActivePlugin.ClickTab(tmpStrItem);
    end;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.WMTerminateMessage(var Msg: TMessage);
begin
  Close;
end;

procedure TSharpCenterWnd.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  try
    if @SCM.ActivePlugin <> nil then
      SCM.Unload;

    FreeAndNil(SCM);

  finally
    CanClose := True;
  end;
end;

procedure TSharpCenterWnd.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
 Var
  msg: Cardinal;
  code: Cardinal;
  i, n: Integer;
begin
  If WindowFromPoint( mouse.Cursorpos ) = sbPlugin.Handle Then Begin
    Handled := true;
    If ssShift In Shift Then
      msg := WM_HSCROLL
    Else
      msg := WM_VSCROLL;

    If WheelDelta > 0 Then
      code := SB_LINEUP
    Else
      code := SB_LINEDOWN;

    n:= Mouse.WheelScrollLines;
    For i:= 1 to n Do
      sbPlugin.Perform( msg, code, 0 );
    sbPlugin.Perform( msg, SB_ENDSCROLL, 0 );
  End;
end;

end.

