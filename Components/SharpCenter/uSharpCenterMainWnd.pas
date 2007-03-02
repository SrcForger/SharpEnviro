{
Source Name: uSharpCenterMainWnd
Description: Main window for SharpCenter
Copyright (C) Pixol - pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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
  CategoryButtons,
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
  JvAnimatedImage,
  JvGradient,
  JclGraphUtils,
  JclGraphics,
  JclFileUtils,
  jvSimpleXml,
  Tabs,
  JvOutlookBar,
  SharpEListBox, SharpESkinManager, uSharpCenterPluginTabList, SharpThemeApi,
  uSharpCenterDllMethods, uSharpCenterManager, JvExStdCtrls, JvHtControls,
  ToolWin, SharpERoundPanel, JvExComCtrls, JvToolBar, XPMan, uSharpETabList,
  GR32_Image, uVistaFuncs, JvLabel, JvgWizardHeader, JvPageList, SharpEListBoxEx,
  PngBitBtn;

const
  cEditTabHide=0;
  cEditTabShow=25;

type
  TSharpCenterWnd = class(TForm)
    pnlSettingTree: TPanel;
    splMain: TSplitter;
    pnlTree: TPanel;
    pnlMain: TPanel;
    Panel2: TPanel;
    PnlButtons: TPanel;
    btnHelp: TPngSpeedButton;
    btnSave: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    PopupMenu1: TPopupMenu;
    pnlContent: TPanel;
    MiAdd: TMenuItem;
    pnlPluginContainer_: TPanel;
    Panel4: TPanel;
    XPManifest1: TXPManifest;
    pnlLivePreview: TPanel;
    imgLivePreview: TImage32;
    ImageList1: TImageList;
    tlToolbar: TSharpETabList;
    pnlToolbar: TSharpERoundPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    plToolbar: TJvPageList;
    pnlPluginContainer: TPanel;
    tlPluginTabs: TSharpETabList;
    rpnlContent: TSharpERoundPanel;
    pnlPlugin: TPanel;
    lbTree: TSharpEListBoxEx;
    picMain: TPngImageList;
    pnlEditContainer: TSharpERoundPanel;
    tlEditItem: TSharpETabList;
    pilIcons: TPngImageList;
    pnlEditPlugin: TPanel;
    pnlEditToolbar: TPanel;
    btnEditCancel: TPngSpeedButton;
    btnEditApply: TPngSpeedButton;
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
    MiEdit: TMenuItem;
    miDelete: TMenuItem;
    miSep: TMenuItem;
    miConfigure: TMenuItem;
    lbHistory: TListBox;
    Timer1: TTimer;
    lbFavs: TSharpEListBoxEx;
    Button1: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure MiClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure tlEditItemTabClick(ASender: TObject; const ATabIndex: Integer);
    procedure btnEditApplyClick(Sender: TObject);
    procedure tlEditItemTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure tlToolbarTabClick(ASender: TObject; const ATabIndex:Integer);
    procedure tlToolbarTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure btnEditCancelClick(Sender: TObject);
    procedure lbTreeGetCellColor(const AItem: Integer; var AColor: TColor);
    procedure lbTreeClickItem(AText: string; AItem, ACol: Integer);
    procedure btnFavouriteClick(Sender: TObject);

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);

    procedure btnBackClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbTree_MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnHomeClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
  private
    FCancelClicked: Boolean;
    FSelectedTabID: Integer;
    FSelectedPluginTabID: Integer;

    procedure UpdateLivePreview;
    procedure CenterMessage(var Msg: TMessage); message WM_SHARPCENTERMESSAGE;
    Procedure ClickItem;
    
    procedure EditTabVisible(AVisible:Boolean);

    procedure ShowHistory;
  public

    procedure GetCopyData(var Msg: TMessage); message wm_CopyData;

    procedure InitWindow;
    procedure InitToolbar;
    procedure UpdateSize;

    procedure EnabledWM(var Msg: TMessage); message CM_ENABLEDCHANGED;

    property SelectedTabID: Integer read FSelectedTabID write FSelectedTabID;

    procedure SetToolbarTabVisible(ATabID:TTabID; AVisible:Boolean);
    procedure LoadPluginEvent(Sender:TObject);
    procedure UnloadPluginEvent(Sender:TObject);
    procedure AddItemEvent(AItem: TSharpCenterManagerItem);
    procedure AddPluginTabsEvent(Sender: TObject);
    procedure UpdateThemeEvent(Sender: TObject);
    procedure InitNavEvent(Sender:TObject);
    procedure LoadEditEvent(Sender:TObject);
    procedure ApplyEditEvent(Sender:TObject);
    procedure CancelEditEvent(Sender:Tobject);
    procedure SavePluginEvent(Sender:TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSyscommand(var Message: TWmSysCommand); message WM_SYSCOMMAND;
  end;

var
  SharpCenterWnd: TSharpCenterWnd;

const
  GlobalItemHeight = 22;

implementation

uses
  SharpEScheme,
  uSEListboxPainter,
  uSharpCenterHelperMethods,
  uSharpCenterHistoryManager;

{$R *.dfm}

procedure TSharpCenterWnd.FormShow(Sender: TObject);
begin
  SCM.OnAddNavItem := AddItemEvent;
  SCM.OnUpdateTheme := UpdateThemeEvent;

  SCM.OnInitNavigation := InitNavEvent;
  SCM.OnLoadPlugin := LoadPluginEvent;
  SCM.OnUnloadPlugin := UnloadPluginEvent;
  SCM.OnLoadEdit := LoadEditEvent;
  SCM.OnApplyEdit :=  ApplyEditEvent;
  SCM.OnCancelEdit := CancelEditEvent;
  SCM.OnAddPluginTabs := AddPluginTabsEvent;
  SCM.PngImageList := pilIcons;
  SCM.PluginContainer := pnlPlugin;
  SCM.EditWndContainer := pnlEditPlugin;

  InitWindow;
  InitToolbar;

  SCM.BuildNavRoot;
end;

procedure TSharpCenterWnd.btnHomeClick(Sender: TObject);
begin
  SCM.Unload;
  InitToolbar;
  
  SetToolbarTabVisible(tidHistory,False);
  SCM.BuildNavRoot;
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
  UpdateSize;
end;

procedure TSharpCenterWnd.GetCopyData(var Msg: TMessage);
var
  tmpMsg: TSettingMsg;
  tmpHist: TSharpCenterHistoryItem;
begin
  tmpMsg := pSettingMsg(PCopyDataStruct(msg.lParam)^.lpData)^;
  tmpHist := SCM.ActiveCommand;

  SCM.History.Add(tmpHist.Command, tmpHist.Param, tmpMsg.PluginID);
  SCM.ExecuteCommand(tmpMsg.Command, tmpMsg.Parameter, tmpMsg.PluginID);
end;

procedure TSharpCenterWnd.WMSyscommand(var Message: TWmSysCommand);
begin
  case (Message.CmdType and $FFF0) of
    SC_MINIMIZE:
    begin
      ShowWindow(Handle, SW_MINIMIZE);
      Message.Result := 0;
    end;
    SC_RESTORE:
    begin
      ShowWindow(Handle, SW_RESTORE);
      Message.Result := 0;
    end;
  else
    inherited;
  end;
end;

procedure TSharpCenterWnd.btnBackClick(Sender: TObject);
var
  tmpItem: TSharpCenterHistoryItem;
begin

  tmpItem := nil;
  if SCM.History.List.Count <> 0 then
    tmpItem := SCM.History.List.Last;

  if tmpItem <> nil then
  begin
    SCM.ExecuteCommand(tmpItem.Command, tmpItem.Param, tmpItem.PluginID);
    SCM.History.Delete(tmpItem);

    SetToolbarTabVisible(tidHistory,Not(SCM.History.List.Count = 0));
  end;
end;

procedure TSharpCenterWnd.btnHelpClick(Sender: TObject);
begin
  if (@SCM.ActivePlugin.SetBtnState) <> nil then
    if SCM.ActivePlugin.SetBtnState(SCB_HELP) = True then
      SCM.ActivePlugin.ClickBtn(SCB_HELP,'');
end;

procedure TSharpCenterWnd.btnSaveClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  Try
    if SCM.Save then begin
      SCM.Unload;
      SCM.Reload;
      pnlEditContainer.Hide;
    end;
  Finally
    LockWindowUpdate(0);
  End;
end;

procedure TSharpCenterWnd.btnCancelClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try
    FCancelClicked := True;

    if @SCM.ActivePlugin.Open <> nil then begin
      SCM.StateEditItem := False;
      SCM.StateEditItem := False;

      SCM.Unload;
    end;

    SCM.Reload;
  finally
    LockWindowUpdate(0);
    FCancelClicked := False;
  end;
end;

procedure TSharpCenterWnd.EnabledWM(var Msg: TMessage);
begin
  SendMessage(self.Handle, msg.Msg, msg.WParam, msg.LParam);
end;

procedure TSharpCenterWnd.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;

  if @SCM.ActivePlugin <> nil then
    SCM.Unload;
end;

procedure TSharpCenterWnd.UpdateLivePreview;
begin
  imgLivePreview.Bitmap.SetSize(pnlLivePreview.Width,pnlLivePreview.Height);
  imgLivePreview.Bitmap.Clear(clwhite32);

  if (@SCM.ActivePlugin.UpdatePreview <> nil) then
    SCM.ActivePlugin.UpdatePreview(imgLivePreview);

  pnlLivePreview.Visible := (@SCM.ActivePlugin.UpdatePreview <> nil);
end;

procedure TSharpCenterWnd.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or
    WS_EX_APPWINDOW;
end;

procedure TSharpCenterWnd.btnFavouriteClick(Sender: TObject);
begin
  //pnlToolbar.Visible := False;
end;

procedure TSharpCenterWnd.lbTreeClickItem(AText: string; AItem, ACol: Integer);
begin
  try

    if lbTree.ItemIndex = -1 then
      exit;

    // If in edit state do not continue
    if SCM.CheckEditState then
      exit;

    SCM.Unload;

    ClickItem;
  finally
  end;
end;

procedure TSharpCenterWnd.lbTreeGetCellColor(const AItem: Integer;
  var AColor: TColor);
begin
  if AItem = lbTree.ItemIndex then
    AColor := $00C1F4FE;
end;

procedure TSharpCenterWnd.CenterMessage(var Msg: TMessage);
var
  bEnabled:Boolean;
  iBtnID: Integer;
begin
  Case msg.WParam of
    SCM_SET_BUTTON_ENABLED, SCM_SET_BUTTON_DISABLED: begin

      bEnabled := (msg.WParam = SCM_SET_BUTTON_ENABLED);
      iBtnID := msg.LParam;
      case iBtnID of
        SCB_IMPORT: SetToolbarTabVisible(tidImport,bEnabled);
        SCB_EXPORT: SetToolbarTabVisible(tidExport,bEnabled);
        SCB_DELETE : btnEditApply.Enabled := bEnabled;
        SCB_HELP : btnHelp.Enabled := bEnabled;
      end;
    end;

    SCM_SET_SETTINGS_CHANGED: begin
      btnSave.Enabled := True;
      btnCancel.Enabled := True;

      //UpdatePluginTabs;
    end;
    SCM_EVT_UPDATE_PREVIEW : begin
      UpdateLivePreview;
    end;
    SCM_SET_EDIT_STATE: begin
      SCM.StateEditItem := True;
    end;
    SCM_SET_EDIT_CANCEL_STATE: begin
      SCM.StateEditItem := False;
    end;
  end;
end;

procedure TSharpCenterWnd.btnEditCancelClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  Try
    SCM.CancelEdit(FSelectedTabID);
  Finally
    LockWindowUpdate(0);
  End;
end;

procedure TSharpCenterWnd.SetToolbarTabVisible(ATabID: TTabID; AVisible: Boolean);
begin
  with tlToolbar.TabList do begin
    Case ATabID of
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
  if SCM.CheckEditState then
      AChange := False;

  Case ATabIndex of
    Integer(tidHome): Begin
      pnlToolbar.Hide;
    End;
    Integer(tidFavourite): Begin
      pnlToolbar.Show;
      pagFav.show;
    End;
    Integer(tidHistory): Begin
      pnlToolbar.Hide;
    End;
    Integer(tidImport): Begin
      pnlToolbar.Show;
      pagImport.Show;
    End;
    Integer(tidExport): Begin
      pnlToolbar.Show;
      pagExport.Show;
    End;
  end;

end;

procedure TSharpCenterWnd.tlToolbarTabClick(ASender: TObject; const ATabIndex:Integer);
begin

  Case ATabIndex of
    0: btnHomeClick(nil);
  //0: btnHome.Click;
  //1: btnFavourite.Click;
  2: btnBackClick(nil);
  //3: btnImport.Click;
 // 4: btnExport.Click  }
//  end;
  end;
end;

procedure TSharpCenterWnd.tlEditItemTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
begin
  if SCM.CheckEditState then begin
      AChange := False;
    exit;
  end;

  case ATabIndex of
    Integer(tidAdd): begin
      pilIcons.PngImages.Items[10].Background := pnlEditToolbar.Color;
      btnEditApply.PngImage := pilIcons.PngImages.Items[10].PngImage;
    end;
    Integer(tidEdit): begin
      pilIcons.PngImages.Items[0].Background := pnlEditToolbar.Color;
      btnEditApply.PngImage := pilIcons.PngImages.Items[0].PngImage;
    end;
    Integer(tidDelete): begin
      pilIcons.PngImages.Items[2].Background := pnlEditToolbar.Color;
      btnEditApply.PngImage := pilIcons.PngImages.Items[2].PngImage;
    end;
  end;
end;

procedure TSharpCenterWnd.btnEditApplyClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  Try
    SCM.ApplyEdit(FSelectedTabID);
  Finally
    LockWindowUpdate(0);
  End;
end;

procedure TSharpCenterWnd.tlEditItemTabClick(ASender: TObject;
  const ATabIndex: Integer);
begin
  FSelectedTabID := ATabIndex;
  SCM.LoadEdit(FSelectedTabID)
end;

procedure TSharpCenterWnd.EditTabVisible(AVisible: Boolean);
begin
  if AVisible then
    tlEditItem.Height := 25 else
    tlEditItem.Height := 0;
end;

procedure TSharpCenterWnd.InitWindow;
begin
  // Vista
  SetVistaFonts(Self);
  HideAllTaskbarButton;

  // Hide Edit Tab
  EditTabVisible(False);

  // Set Listbox defaults
  lbTree.Colors.BorderColorSelected := $00C1F4FE;
  lbTree.ItemOffset := Point(0,0);
  lbTree.ColumnMargin := Rect(0,0,0,0);
  lbFavs.Colors.BorderColorSelected := $00C1F4FE;
  lbFavs.ItemOffset := Point(0,0);
  lbFavs.ColumnMargin := Rect(0,0,0,0);
  lbFavs.Margin := Rect(0,0,0,0);
  lbFavs.Color := $00C1F4FE;
  lbFavs.Colors.ItemColor := $00C1F4FE;
  lbFavs.Colors.ItemColorSelected := $0080E7FD;

  // Set tab defaults
  tlPluginTabs.TextBounds := Rect(8,8,8,4);
  pnlEditContainer.DoubleBuffered := true;

   // Reinit values
  FSelectedTabID := -1;

  // Update UI
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  btnHelp.Enabled := False;
  pnlEditContainer.Visible := False;
  tlEditItem.TabIndex := -1;
  pnlToolbar.Hide;

end;

procedure TSharpCenterWnd.ClickItem;
var
  tmpItem: TSharpCenterManagerItem;
  tmpHistItem: TSharpCenterHistoryItem;
  tmpHist:  TSharpCenterHistoryManager;
  tmpManager: TSharpCenterManager;
  sName: string;
begin
  SCM.Unload;

  // Get the Button Data
  tmpItem := TSharpCenterManagerItem(lbTree.Item[lbTree.ItemIndex].Data);
  if tmpItem = nil then exit;

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

        tmpHistItem.Command := cChangeFolder;
        tmpHistItem.Param := PathAddSeparator(tmpItem.Path);
        tmpHistItem.PluginID := '';

        tmpManager.BuildNavFromPath(tmpHistItem.Param);
        SetToolbarTabVisible(tidHistory,True);
      end;
    itmSetting:
      begin
        tmpHist.Add(tmpHistItem.Command, tmpHistItem.Param, tmpHistItem.PluginID);

        tmpHistItem.Command := cLoadSetting;
        tmpHistItem.Param := tmpItem.Filename;
        tmpHistItem.PluginID := '';

        SetToolbarTabVisible(tidHistory,True);

        if fileexists(tmpHistItem.Param) then
        begin

          //InitialiseWindow(pnlMain, tmpItem.Caption);
          SCM.BuildNavFromFile(tmpItem.Filename);

        end;

      end;
    itmDll:
      begin
        SCM.Load(tmpItem.Filename,tmpItem.PluginID);
        //SCM.LoadSelectedDll(lbTree.ItemIndex);
      end;
  end;
end;

procedure TSharpCenterWnd.InitToolbar;
begin
  // Hide Import Export + History
  SetToolbarTabVisible(tidImport,False);
  SetToolbarTabVisible(tidExport,False);
  SetToolbarTabVisible(tidHistory,False);

  // Hide Toolbar panel, and set tabindex to home
  pnlToolbar.Visible := False;
  tlToolbar.TabIndex := 0;
end;

procedure TSharpCenterWnd.UpdateSize;
begin
  UpdateLivePreview;

  if @SCM.ActivePlugin.Open <> nil then
  begin
    If SCM.PluginWndHandle <> 0 then
      ResizeToFitWindow(SCm.PluginWndHandle, pnlPlugin);

    if @SCM.ActivePlugin.OpenEdit <> nil then
      if SCM.EditWndHandle <> 0 then begin
        pnlEditContainer.Height := GetControlByHandle(SCM.EditWndHandle).Height;
        GetControlByHandle(SCM.EditWndHandle).Width := pnlEditPlugin.Width;
      end;

  end;
end;

procedure TSharpCenterWnd.btnImportClick(Sender: TObject);
begin
  if (@SCM.ActivePlugin.ClickBtn <> nil) then
    SCM.ActivePlugin.ClickBtn(SCB_IMPORT,PChar(edImportFileName.Text));
end;

procedure TSharpCenterWnd.PopupMenu1Popup(Sender: TObject);
begin
  miConfigure.Visible := False;
  miSep.Visible := False;

  if (@SCM.ActivePlugin.SetBtnState <> nil) then
    if SCM.ActivePlugin.SetBtnState(SCB_CONFIGURE) then begin
      miConfigure.Visible := True;
      miSep.Visible := True;
    end;

  MiAdd.Visible := (@SCM.ActivePlugin.OpenEdit <> nil);
  MiEdit.Visible := (@SCM.ActivePlugin.OpenEdit <> nil);
  miDelete.Visible := (@SCM.ActivePlugin.OpenEdit <> nil);
end;

procedure TSharpCenterWnd.MiClick(Sender: TObject);
var
  h:Thandle;
begin
  if Sender = MiAdd then
    tlEditItem.ClickTab(integer(tidAdd)) else
  if Sender = MiEdit then
    tlEditItem.ClickTab(integer(tidEdit)) else
  if Sender = MiDelete then begin
    tlEditItem.ClickTab(integer(tidDelete));
    btnEditApply.Click;
  end else
  if Sender = miConfigure then begin
    if (@SCM.ActivePlugin.ClickBtn <> nil) then
      SCM.ActivePlugin.ClickBtn(SCB_CONFIGURE,miConfigure.Caption);
  end;

  h:=getnextWindow(handle,GW_HWNDNEXT);
  Setforegroundwindow(h);
end;

procedure TSharpCenterWnd.ShowHistory;
var
  i:Integer;
begin
  lbHistory.Clear;
  for i := 0 to SCM.History.Count-1 do
    lbHistory.Items.Add(TSharpCenterHistoryItem(SCM.History.List[i]).Command +
      ' ' + TSharpCenterHistoryItem(SCM.History.List[i]).Param + ' (' +
          TSharpCenterHistoryItem(SCM.History.List[i]).PluginID + ')');
end;
procedure TSharpCenterWnd.Timer1Timer(Sender: TObject);
begin
  ShowHistory;
end;

procedure TSharpCenterWnd.LoadPluginEvent(Sender: TObject);
begin
  // Resize Plugin window
  ResizeToFitWindow(SCM.PluginWndHandle, pnlPlugin);

  // Edit bar
  tlEditItem.Height := 0;
  if (@SCM.ActivePlugin.OpenEdit <> nil) then
    tlEditItem.Height := 25;

  // Toolbar
  if (@SCM.ActivePlugin.SetBtnState <> nil) then
    SetToolbarTabVisible(tidImport,SCM.ActivePlugin.SetBtnState(SCB_IMPORT));

  if (@SCM.ActivePlugin.SetBtnState <> nil) then
    SetToolbarTabVisible(tidExport,SCM.ActivePlugin.SetBtnState(SCB_EXPORT));

  pnlToolbar.Hide;
  FSelectedTabID := 0;
  FSelectedPluginTabID := 0;

  UpdateSize;


end;

procedure TSharpCenterWnd.AddItemEvent(AItem: TSharpCenterManagerItem);
var
  tmp:TSharpEListItem;
begin
  tmp := lbTree.AddItem(AItem.Caption,AItem.IconIndex);
  tmp.AddSubItem(AItem.Status);
  tmp.Data := AItem;
end;

procedure TSharpCenterWnd.InitNavEvent(Sender: TObject);
begin
  lbTree.Clear;
end;

procedure TSharpCenterWnd.AddPluginTabsEvent(Sender: TObject);
var
  i {idx}: Integer;
  s: string;

begin
  tlPluginTabs.Clear;

    s := '';
    if SCM.PluginTabs.Count = 0 then
    begin
      tlPluginTabs.Height := 0;
      rpnlContent.Top := 2;
      rpnlContent.Height := pnlPluginContainer.Height-2;
    end
    else begin
      tlPluginTabs.Height := 25;
      rpnlContent.Top := 24;
      rpnlContent.Height := pnlPluginContainer.Height-26;

      for i := 0 to Pred(SCM.PluginTabs.Count) do
      begin
        tlPluginTabs.Add(SCM.PluginTabs[i].Caption,-1,SCM.PluginTabs[i].Status);

        tlPluginTabs.TabIndex := FSelectedPluginTabID;
      end;
    end;
end;


procedure TSharpCenterWnd.UnloadPluginEvent(Sender: TObject);
begin

  // Check if Save first
  if ((btnSave.Enabled) and not (FCancelClicked)) then
  begin
    SCM.Save;
  end;

  // Handle proper closing of the edit window
  tlPluginTabs.Height := 0;
  if @SCM.ActivePlugin.OpenEdit <> nil then begin
    pnlEditContainer.Visible := False;

    if ((@SCM.ActivePlugin.CloseEdit <> nil) and (SCM.EditWndHandle <> 0)) then
      SCM.ActivePlugin.CloseEdit(SCM.EditWndHandle,sceEdit,False);
  end;
  
  tlEditItem.Height := 0;
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TSharpCenterWnd.UpdateThemeEvent(Sender: TObject);
var
  colBackground, colItem, colSelectedItem: TColor;
begin
  if @SCM.ActivePlugin.GetCenterScheme <> nil then begin

    if Not(SCM.StateEditWarning) then begin
      colBackground := $00FBEFE3;
      colItem := clWindow;
      colSelectedItem := $00FBEFE3;
    end else begin
      colBackground := $00d9d6f9;
      colItem := clWindow;
      colSelectedItem := $00FBEFE3;
    end;

    SCM.ActivePlugin.GetCenterScheme(colBackground,
      colItem, colSelectedItem);

    pnlEditContainer.Color := colBackground;
    pnlEditPlugin.Color := colBackground;
    pnlEditContainer.Color := colBackground;
    pnlEditToolbar.Color := colBackground;
    tlEditItem.TabSelectedColor := colBackground;

    if Not(pnlEditContainer.Visible) then
    tlEditItem.TabIndex := -1;

    btnEditCancel.Enabled := True;

    if (SCM.StateEditItem) then begin
      btnEditApply.Enabled := True;

      Case FSelectedTabID of
      integer(tidAdd): btnEditApply.Caption := 'Add';
      integer(tidEdit): btnEditApply.Caption := 'Apply';
      integer(tidDelete): begin
        btnEditApply.Caption := 'Delete';
        btnEditApply.Visible := True;
      end;
      end;

      btnEditCancel.Caption := 'Cancel';

    end else begin
      btnEditApply.Enabled := False;

      Case FSelectedTabID of
      integer(tidAdd): btnEditApply.Caption := 'Add';
      integer(tidEdit): btnEditApply.Caption := 'Edit';
      integer(tidDelete): begin
        btnEditApply.Caption := 'Delete';
        btnEditApply.Visible := True;
      end;
      end;

      btnEditCancel.Caption := 'Close';
    end;

    Self.Invalidate;


  end;
end;

procedure TSharpCenterWnd.LoadEditEvent(Sender: TObject);
begin
  pnlEditContainer.Show;
  UpdateSize;
end;

procedure TSharpCenterWnd.SavePluginEvent(Sender: TObject);
begin
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TSharpCenterWnd.ApplyEditEvent(Sender: TObject);
begin
  tlEditItemTabClick(tlEditItem,tlEditItem.TabIndex);
end;

procedure TSharpCenterWnd.CancelEditEvent(Sender: Tobject);
begin
  if Sender = nil then begin
    tlEditItem.TabIndex := -1;
    pnlEditContainer.Hide;
  end else
    tlEditItemTabClick(tlEditItem,tlEditItem.TabIndex);
end;

end.











