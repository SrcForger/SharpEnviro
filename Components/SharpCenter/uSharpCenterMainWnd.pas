{
Source Name: uSharpCenterMainWnd
Description: Main window for SharpCenter
Copyright (C) lee@sharpe-shell.org

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
  SharpEListBox, SharpESkinManager, uSharpCenterSectionList, SharpThemeApi,
  uSharpCenterDllMethods, uSharpCenterManager, JvExStdCtrls, JvHtControls,
  ToolWin, SharpERoundPanel, JvExComCtrls, JvToolBar, XPMan, uSharpETabList,
  GR32_Image, uVistaFuncs, JvLabel, JvgWizardHeader, JvPageList, SharpEListBoxEx;

type
  TTabID = (tidHome, tidFavourite, tidHistory, tidImport, tidExport);

type
  TSharpCenterWnd = class(TForm)
    pnlConfigurationTree: TPanel;
    splMain: TSplitter;
    pnlTree: TPanel;
    picMain_: TPngImageCollection;
    pnlMain: TPanel;
    Panel2: TPanel;
    UnloadTimer: TTimer;
    PnlButtons: TPanel;
    btnHelp: TPngSpeedButton;
    btnSave: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    PopupMenu1: TPopupMenu;
    lblTree: TJvHTLabel;
    pnlContent: TPanel;
    N11: TMenuItem;
    PngImageList1: TPngImageList;
    pnlPluginContainer_: TPanel;
    JvGradient1: TJvGradient;
    Shape2: TShape;
    Panel4: TPanel;
    pnlTreeTitle: TPanel;
    XPManifest1: TXPManifest;
    pnlLivePreview: TPanel;
    imgLivePreview: TImage32;
    ImageList1: TImageList;
    tlToolbar: TSharpETabList;
    SharpERoundPanel2: TSharpERoundPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    plToolbar: TJvPageList;
    pnlPluginContainer: TPanel;
    tlSections: TSharpETabList;
    rpnlContent: TSharpERoundPanel;
    pnlPlugin: TPanel;
    lbTree: TSharpEListBoxEx;
    picMain: TPngImageList;
    pagHome: TJvStandardPage;
    Image1: TImage;
    pnlEditContainer: TSharpERoundPanel;
    plStandardEdit: TJvPageList;
    pagAddEdit: TJvStandardPage;
    pnlEditButtons: TPanel;
    btnEditCancel: TPngSpeedButton;
    btnEditApply: TPngSpeedButton;
    pnlEditPlugin: TPanel;
    pagDelete: TJvStandardPage;
    Label1: TLabel;
    Panel7: TPanel;
    PngSpeedButton3: TPngSpeedButton;
    PngSpeedButton4: TPngSpeedButton;
    PngSpeedButton5: TPngSpeedButton;
    tlEditItem: TSharpETabList;
    pilIcons: TPngImageList;
    procedure btnEditApplyClick(Sender: TObject);
    procedure tlEditItemTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure tlEditItemTabClick(ASender: TObject; const ATabIndex: Integer);
    procedure tlToolbarTabClick(ASender: TObject; const ATabIndex:Integer);
    procedure tlToolbarTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure btnEditCancelClick(Sender: TObject);
    procedure lbTreeGetCellColor(const AItem: Integer; var AColor: TColor);
    procedure lbTreeClickItem(AText: string; AItem, ACol: Integer);
    procedure btnFavouriteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lblTabsHyperLinkClick(Sender: TObject; LinkName: string);
    procedure lblTreeHyperLinkClick(Sender: TObject; LinkName: string);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure UnloadTimerTimer(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbTree_MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnHomeClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
  private
    FUnloadCommand: string;
    FUnloadParam: string;
    FUnloadID: string;
    FName: string;
    FDllFilename: string;
    FPluginID: string;
    FSetting: TSetting;
    FSections: TSectionItemList;
    FCancelClicked: Boolean;
    FPluginHandle: THandle;
    FSelectedTabID: Integer;
    FEditItemHandle: THandle;

    procedure SchemeWindow;
    function GetControlByHandle(AHandle: THandle): TWinControl;
    procedure ResizeToFitWindow(AHandle: THandle; AControl: TWinControl);
    function GetConfigChanged: Boolean;
    procedure SetControlParentWindows(Ctl: TWinControl);
    function AssignIconIndex(ASectionObject: TSectionItem): Integer; overload;
    procedure AssignIconIndex(AFileName: string; ABTData: TBTData); overload;
    procedure UpdateLivePreview;
    procedure HideAllTaskbarButton;
    function ForceForegroundWindow(hwnd: THandle): Boolean;
  public
    procedure BuildSectionRoot;
    procedure GetCopyData(var Msg: TMessage); message wm_CopyData;
    procedure ExecuteCommand(ACommand, AParameter, APluginID: string);
    procedure UnloadDllWithTimer(ACommand, AParameter, APluginID: string);

    procedure InitialiseWindow(AOwner: TWinControl; AName: string);
    procedure UnloadDll;
    procedure ReloadDll;
    procedure LoadDll(AFileName, APluginID: string);
    procedure UpdateSize;
    function SaveChanges:Boolean;
    procedure UpdateSections;
    procedure DisablePluginButtons;
    function GetDisplayName(ADllFilename, APluginID: string): string;
    function GetStatusText(ADllFilename, APluginID: string): string;
    procedure UpdateSettingTheme;
    procedure CenterMessage(var Msg: TMessage); message WM_SHARPCENTERMESSAGE;

    procedure EnabledWM(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure WMPosChange(var Message: TWMWINDOWPOSCHANGING);
 Message WM_WINDOWPOSCHANGING;

    property ConfigChanged: Boolean read GetConfigChanged;
    property Setting: TSetting read FSetting write
      FSetting;
    property PluginID: string read FPluginID write FPluginID;
    property DllFilename: string read FDllFilename write FDllFilename;
    property Name: string read FName write FName;
    property Sections: TSectionItemList read FSections write FSections;
    property PluginHandle: THandle read FPluginHandle write FPluginHandle;
    property EditItemHandle: THandle read FEditItemHandle write FEditItemHandle;

    procedure LoadConfiguration(AConfigurationFile, APluginID: string);
    procedure LoadSelectedDll(AItemIndex: Integer);

    procedure SetToolbarTabVisible(ATabID:TTabID; AVisible:Boolean);
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
  uSharpCenterDllConfigWnd;

{$R *.dfm}

function TSharpCenterWnd.ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;

begin
  if IsIconic(hwnd) then
    ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then
    Result := True
  else
  begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then
      begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout),
          SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end; { ForceForegroundWindow }

procedure TSharpCenterWnd.ResizeToFitWindow(AHandle: THandle; AControl:
  TWinControl);
begin
  GetControlByHandle(AHandle).Height := AControl.Height;
  GetControlByHandle(AHandle).Width := AControl.Width;
  GetControlByHandle(AHandle).Invalidate;
  //Application.ProcessMessages;

  Self.Invalidate;
end;

function TSharpCenterWnd.GetControlByHandle(AHandle: THandle): TWinControl;
begin
  Result := Pointer(GetProp(AHandle,
    PChar(Format('Delphi%8.8x', [GetCurrentProcessID]))));
end;

procedure TSharpCenterWnd.FormShow(Sender: TObject);
begin
  pnlPlugin.DoubleBuffered := True;
  SharpCenterManager := TSharpCenterManager.Create;

  SchemeWindow;
  BuildSectionRoot;
end;

procedure TSharpCenterWnd.SchemeWindow;
begin
  pnlConfigurationTree.Color := clWindow;
end;

procedure TSharpCenterWnd.BuildSectionRoot;
begin
  tlEditItem.Height := 0;
  SharpCenterManager.ClearHistory;
  SharpCenterWnd.SetToolbarTabVisible(tidHistory,False);

  SharpCenterManager.BuildSectionItemsFromPath(GetCenterDirectory,
    lbTree);

  SharpCenterManager.SetNavRoot(GetCenterDirectory);
end;

procedure TSharpCenterWnd.btnHomeClick(Sender: TObject);
begin
  UnloadDll;
  BuildSectionRoot;
end;

procedure TSharpCenterWnd.lbTree_MouseUp(Sender: TObject; Button:
  TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  try
    if lbTree.ItemIndex = -1 then
      exit;

    if FSetting.Dllhandle <> 0 then
    begin
      UnloadDll;
      //LockWindowUpdate(Self.Handle);
      SharpCenterManager.ClickButton(nil);
    end
    else begin
      //LockWindowUpdate(Self.Handle);
      SharpCenterManager.ClickButton(nil);
    end;

    UpdateSize;
  finally
    //LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.FormResize(Sender: TObject);
begin
  UpdateSize;
end;

procedure TSharpCenterWnd.FormCreate(Sender: TObject);
begin
  SetVistaFonts(Self);
  HideAllTaskbarButton;
  //SetupGlass;


  FSetting.Dllhandle := 0;
  pnlEditContainer.DoubleBuffered := true;
  plStandardEdit.DoubleBuffered := True;
  pagAddEdit.DoubleBuffered := True;
  lbTree.Colors.BorderColorSelected := $00C1F4FE;
  lbTree.ItemOffset := Point(0,0);



  tlSections.TextBounds := Rect(8,8,8,4);

  FSections := TSectionItemList.Create;
  UpdateSections;
  DisablePluginButtons;

  SharpThemeApi.InitializeTheme;
  UpdateSize;
end;

procedure TSharpCenterWnd.GetCopyData(var Msg: TMessage);
var
  tmpMsg: tconfigmsg;
begin
  tmpMsg := pConfigMsg(PCopyDataStruct(msg.lParam)^.lpData)^;
  ExecuteCommand(tmpMsg.Command, tmpMsg.Parameter, tmpMsg.PluginID);
end;

procedure TSharpCenterWnd.PngSpeedButton1Click(Sender: TObject);
begin
  //ConfigMsg('_cLoadDll','D:\SharpE\Center\Plugins\Services\ComponentsService.con',0);
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
  if SharpCenterManager.History.List.Count <> 0 then
    tmpItem := SharpCenterManager.History.List.Last;

  if tmpItem <> nil then
  begin
    UnloadDll;
    ExecuteCommand(tmpItem.Command, tmpItem.Parameter, tmpItem.PluginID);
    SharpCenterManager.SetNavRoot(tmpItem.Parameter);
    SharpCenterManager.History.Delete(tmpItem);

    if SharpCenterManager.History.List.Count = 0 then
      SharpCenterWnd.SetToolbarTabVisible(tidHistory,False)
    else
      SharpCenterWnd.SetToolbarTabVisible(tidHistory,True);
  end;
end;

procedure TSharpCenterWnd.UnloadDllWithTimer(ACommand, AParameter, APluginID: string);
begin
  FUnloadCommand := cUnloadDll;
  FUnloadParam := AParameter;
  FUnloadID := APluginID;
  UnloadTimer.Enabled := True;
end;

procedure TSharpCenterWnd.ExecuteCommand(ACommand, AParameter, APluginID: string);
begin
  // navigate to folder
  if CompareText(ACommand, cChangeFolder) = 0 then
  begin
    if FSetting.Dllhandle <> 0 then
      UnloadDllWithTimer(ACommand, AParameter, APluginID);

    SharpCenterManager.BuildSectionItemsFromPath(AParameter, SharpCenterWnd.lbTree);
  end
  else if CompareText(ACommand, cUnloadDll) = 0 then
  begin
    if FSetting.Dllhandle <> 0 then
      UnloadDllWithTimer(ACommand, AParameter, APluginID);
  end
  else if CompareText(ACommand, cLoadConfig) = 0 then
  begin
    if FSetting.Dllhandle <> 0 then
      UnloadDllWithTimer(ACommand, AParameter, APluginID);

    lbTree.Items.Clear;
  end;
end;

procedure TSharpCenterWnd.UnloadTimerTimer(Sender: TObject);
begin
  UnloadTimer.Enabled := False;

  if CompareText(FUnloadCommand, cUnloadDll) = 0 then
  begin
    UnloadDll;

    if not (IsDirectory(FUnloadParam)) then
      LoadConfiguration(FUnloadParam, FUnloadID);
  end
  else if CompareText(FUnloadCommand, cChangeFolder) = 0 then
  begin
    UnloadDll;
    SharpCenterManager.BuildSectionItemsFromPath(FUnloadParam,
      Self.lbTree)
  end
  else if CompareStr(FUnloadCommand, cLoadConfig) = 0 then
  begin
    UnloadDll;
    if fileexists(FUnloadParam) then
    begin
      InitialiseWindow(SharpCenterWnd.pnlMain,
        ExtractFileName(FUnloadParam));
    end;
    PluginID := FUnloadID;
    LoadConfiguration(FUnloadParam, FPluginID);
  end;
end;

procedure TSharpCenterWnd.btnHelpClick(Sender: TObject);
begin
  if (@FSetting.SetBtnState) <> nil then
    if FSetting.SetBtnState(SCB_HELP) = True then
      FSetting.ClickBtn(SCB_HELP,btnHelp);
end;

procedure TSharpCenterWnd.btnSaveClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  if SaveChanges then
    ReloadDll;
  LockWindowUpdate(0);
end;

procedure TSharpCenterWnd.UnloadDll;
begin
  if btnSave = nil then
    exit;

  // Check if Save first
  if ((btnSave.Enabled) and not (FCancelClicked)) then
  begin
    if (MessageDlg('Do you want to save changes?', mtConfirmation, [mbYes,
      mbNo], 0) = mrYes) then
      SaveChanges;
  end;

  // Handle proper closing of the edit window
  tlSections.Height := 0;
  if @FSetting.OpenEdit <> nil then begin
    pnlEditContainer.Visible := False;

    if ((@FSetting.CloseEdit <> nil) and (EditItemHandle <> 0)) then
      FSetting.CloseEdit(EditItemHandle,False,False);
  end;
  tlEditItem.Height := 0;

  // Handle proper closing of the setting
  if @FSetting.Close <> nil then
    FSetting.Close(Hinstance, false);

  // Unload dll
  UnloadSetting(@FSetting);

  // Reinit values
  FSelectedTabID := -1;
  UpdateSections;
  PluginHandle := 0;
  EditItemHandle := 0;

  // Update UI
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  btnHelp.Enabled := False;
  pnlEditContainer.Visible := False;
  tlEditItem.TabIndex := -1;
  DisablePluginButtons;
end;

procedure TSharpCenterWnd.ReloadDll;
begin
  LoadDll(FDllFilename, FPluginID);
end;

procedure TSharpCenterWnd.LoadDll(AFileName, APluginID: string);
var
  Xml: TJvSimpleXML;
  iSettingType: Integer;
  s: string;

  procedure EnableButton(AButtonID:Integer; AButton:TPngSpeedButton);
  begin
    AButton.Enabled := False;
        if (@FSetting.SetBtnState <> nil) then
          if FSetting.SetBtnState(AButtonID) then
            AButton.Enabled := True;
  end;

begin

  Xml := TJvSimpleXML.Create(nil);
  FDllFilename := AFileName;

  try

    if FileExists(AFileName) then
    begin
      FSetting := LoadSetting(PChar(AFileName));

      if @FSetting.Open <> nil then
      begin
        FPluginHandle := FSetting.Open(Pchar(APluginID), pnlPlugin.Handle);
        pnlPlugin.ParentWindow := FPluginHandle;

        // Resize window to fit plugin panel
        ResizeToFitWindow(PluginHandle, pnlPlugin);

        // Get setting type
        if @FSetting.SetSettingType <> nil then
          iSettingType := FSetting.SetSettingType
        else
          iSettingType := -1;

        // Check if the setting has any item edits
         tlEditItem.Height := 0;
         if (@FSetting.OpenEdit <> nil) then
          tlEditItem.Height := 25;

        splMain.Show;

        // Set Scheme
        UpdateSettingTheme;

        // Set buttons
        {EnableButton(SCB_MOVEUP,btnMoveUp);
        EnableButton(SCB_MOVEDOWN,btnMoveDown);
        EnableButton(SCB_ADD,btnAdd);
        EnableButton(SCB_EDIT,btnEdit);
        EnableButton(SCB_DEL,btnDelete);
        EnableButton(SCB_IMPORT,btnImport);
        EnableButton(SCB_EXPORT,btnExport);  }
        //EnableButton(SCB_CLEAR,btnClear);
        EnableButton(SCB_HELP,btnHelp);
        FSelectedTabID := 0;

        UpdateSections;

        case iSettingType of
          SCU_SHARPTHEME: ; // already assigned
          SCU_SERVICE:
            begin
              FName := GetDisplayName(AFileName, FPluginID);
              s := GetSharpeUserSettingsPath +
                'SharpCore\ServiceList.xml';

              if FileExists(s) then
              begin
                Xml.LoadFromFile(s);
                with Xml.Root.Items do

                  if ItemNamed[FName] <> nil then
                    FPluginID :=
                      ItemNamed[FName].Properties.Value('ID', '');
              end;
            end;
        end;
      end;
    end;

  finally
    Xml.Free;
  end;
end;

procedure TSharpCenterWnd.btnCancelClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try
    FCancelClicked := True;

    if @FSetting.Open <> nil then begin
      SharpCenterManager.EditItemState := False;
      SharpCenterManager.EditItemWarning := False;

      UnloadDll;
    end;

    ReloadDll;
  finally
    LockWindowUpdate(0);
    FCancelClicked := False;
  end;
end;

procedure TSharpCenterWnd.btnImportClick(Sender: TObject);
begin
  if (@Setting.SetBtnState) <> nil then
    if Setting.SetBtnState(SCB_IMPORT) then begin
    try
      //FSetting.ClickBtn(SCB_IMPORT,btnImport);
    except
      MessageDlg('Unable to Import Configuration' + #13 +
        'Check SharpConsole for details', mtError, [mbOK], 0);
    end;
    end;
end;

procedure TSharpCenterWnd.btnExportClick(Sender: TObject);
begin
  if (@Setting.SetBtnState) <> nil then
    if Setting.SetBtnState(SCB_EXPORT) then begin
    try
      //FSetting.ClickBtn(SCB_EXPORT,btnExport);
    except
      MessageDlg('Unable to Export Configuration' + #13 +
        'Check SharpConsole for details', mtError, [mbOK], 0);
    end;
    end;
end;

procedure TSharpCenterWnd.btnClearClick(Sender: TObject);
begin
  if (@Setting.SetBtnState) <> nil then
    if Setting.SetBtnState(SCB_CLEAR) then
      //FSetting.ClickBtn(SCB_CLEAR,btnClear);
end;

procedure TSharpCenterWnd.btnMoveDownClick(Sender: TObject);
begin
  if (@Setting.SetBtnState) <> nil then
    if Setting.SetBtnState(SCB_MOVEDOWN) then
      //FSetting.ClickBtn(SCB_MOVEDOWN,btnMoveDown);
end;

procedure TSharpCenterWnd.btnMoveUpClick(Sender: TObject);
begin
  if (@Setting.SetBtnState) <> nil then
    if Setting.SetBtnState(SCB_MOVEUP) then
      //FSetting.ClickBtn(SCB_MOVEUP,btnMoveUp);
end;

function TSharpCenterWnd.GetConfigChanged: Boolean;
begin
  Result := btnSave.Enabled;
end;

procedure TSharpCenterWnd.UpdateSize;
begin
  UpdateLivePreview;

  if @FSetting.Open <> nil then
  begin
    ResizeToFitWindow(PluginHandle, pnlPlugin);

    if @Setting.OpenEdit <> nil then
      if EditItemHandle <> 0 then begin
        pnlEditContainer.Height := GetControlByHandle(EditItemHandle).Height;
        GetControlByHandle(EditItemHandle).Width := pnlEditPlugin.Width;
      end;

  end;
end;

procedure TSharpCenterWnd.SetControlParentWindows(Ctl: TWinControl);
var
  i: Integer;
  ChildCtl: TWinControl;
begin
  i := 0;
  while (i < Ctl.ControlCount) do
  begin
    if (Ctl.Controls[i] is TWinControl) then
    begin
      ChildCtl := TWinControl(Ctl.Controls[i]);
      ChildCtl.Parent := nil;
      ChildCtl.ParentWindow := Ctl.Handle;
      SetControlParentWindows(ChildCtl);
    end
    else
      Inc(i);
  end;
end;

procedure TSharpCenterWnd.EnabledWM(var Msg: TMessage);
begin
  SendMessage(self.Handle, msg.Msg, msg.WParam, msg.LParam);
end;

Function TSharpCenterWnd.SaveChanges:Boolean;
var
  iSettingType: Integer;
  n: Integer;
  bClose: Boolean;
begin
  bClose := FSetting.Close(Self.Handle, True);

  if bClose then
  begin
    iSettingType := FSetting.SetSettingType;

    if TryStrToInt(FPluginID, n) then
      n := StrToInt(FPluginID)
    else
      n := -1;

    SharpEBroadCast(WM_SHARPEUPDATESETTINGS, iSettingType, n);

    btnSave.Enabled := False;
    btnCancel.Enabled := False;
  end;

  Result := bClose;
end;

function TSharpCenterWnd.AssignIconIndex(
  ASectionObject: TSectionItem): Integer;
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
begin
  if FileExists(ASectionObject.Icon) then
  begin
    tmpPngImage := TPNGObject.Create;
    tmpPngImage.LoadFromFile(ASectionObject.Icon);
    tmpPngImage.CreateAlpha;

    tmpPiC := picMain.PngImages.Add();
    tmpPiC.PngImage.Assign(tmpPngImage);
    tmpPiC.Background := clWindow;

    Result := tmpPic.Index;
  end
  else
    Result := 0;
end;

procedure TSharpCenterWnd.LoadConfiguration(AConfigurationFile, APluginID: string);
var
  xml: TJvSimpleXML;
  i: Integer;
  pngfile: string;
  s, sDll, sIcon: string;
  sStatus: string;
  NewBT: TBTData;
  sPath: string;
  li:TSharpEListItem;
begin
  try
    UpdateSize;
    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(AConfigurationFile);

      with xml.Root.Items.ItemNamed['Sections'] do
      begin
        for i := 0 to Pred(Items.Count) do
        begin

          NewBT := TBTDataDll.Create;

          sPath := ExtractFilePath(AConfigurationFile);
          sDll := '';
          if Items.Item[i].Items.ItemNamed['Dll'] <> nil then
            sDll := Items.Item[i].Items.ItemNamed['Dll'].Value;

          sIcon := '';
          if Items.Item[i].Items.ItemNamed['Icon'] <> nil then
            sIcon := Items.Item[i].Items.ItemNamed['Icon'].Value;

          s := GetDisplayName(sPath + sDll, '');
          sStatus := GetStatusText(sPath + sDll, '');

          if s = '' then
            NewBT.Caption := Items.Item[i].Name
          else
            NewBT.Caption := s;

          TBTDataDll(NewBT).Path := sPath + sDll;
          TBTDataDll(NewBT).PluginID := APluginID;
          NewBT.ID := -1;
          NewBT.BT := btDll;

          pngfile := sPath + sIcon;
          AssignIconIndex(pngfile, NewBT);
          li := lbTree.AddItem(NewBT.Caption,NewBT.IconIndex);
          li.AddSubItem(sStatus);
          li.Data := Pointer(NewBT);
        end;
      end;

    finally
      xml.Free;
    end;

  finally
    LoadSelectedDll(0);

  end;
end;

procedure TSharpCenterWnd.UpdateSections;
var
  i {idx}: Integer;
  s: string;

begin
  FSections.Clear;
  tlSections.Clear;

  if (@FSetting.AddTabs <> nil) then
  begin
    FSetting.AddTabs(FSections);

    s := '';
    if FSections.Count = 0 then
    begin
      tlSections.Height := 0;
      rpnlContent.Top := 2;
      rpnlContent.Height := pnlPluginContainer.Height-2;
    end
    else begin
      tlSections.Height := 25;
      rpnlContent.Top := 24;
      rpnlContent.Height := pnlPluginContainer.Height-26;

      for i := 0 to Pred(FSections.Count) do
      begin
        tlSections.Add(FSections[i].Caption,-1,FSections[i].Status);

        tlSections.TabIndex := FSelectedTabID;
      end;
     end;
  end
  else
  begin
    tlSections.Height := 0;
    rpnlContent.Top := 2;
    rpnlContent.Height := pnlPluginContainer.height-2;
  end;
end;

procedure TSharpCenterWnd.InitialiseWindow(AOwner: TWinControl; AName: string);
begin
  PnlButtons.DoubleBuffered := True;
  pnlEditContainer.Hide;
  tlEditItem.Height := 0;

  if not (Assigned(FSections)) then
    FSections := TSectionItemList.Create;

  //FSections.IconList := picMain;
  FSections.Clear;

  lbTree.Items.Clear;
  UpdateSections;
end;

procedure TSharpCenterWnd.LoadSelectedDll(AItemIndex: Integer);
var
  tmpItem: TBTDataDll;
begin
  tmpItem := TBTDataDll(lbTree[AItemIndex].Data);
  if tmpItem <> nil then
  begin
    FPluginID := tmpItem.PluginID;
    LoadDll(tmpItem.Path, tmpItem.PluginID);

    lbTree.ItemIndex := AItemIndex;
  end;
end;

function TSharpCenterWnd.GetDisplayName(ADllFilename, APluginID: string): string;
var
  tmpSetting: Tsetting;
  s: PChar;
begin
  Result := '';

  if fileexists(ADllFilename) then
  begin
    tmpSetting := LoadSetting(PChar(ADllFilename));

    try
      if @tmpSetting.SetDisplayText <> nil then
      begin
        tmpSetting.SetDisplayText(Pchar(APluginID), s);
        Result := s;
      end;

    finally
      UnloadSetting(@tmpSetting);
    end;
  end;
end;

function TSharpCenterWnd.GetStatusText(ADllFilename, APluginID: string): string;
var
  tmpSetting: Tsetting;
  s: PChar;
begin
  Result := '';

  if fileexists(ADllFilename) then
  begin
    tmpSetting := LoadSetting(PChar(ADllFilename));

    try
      if @tmpSetting.SetStatusText <> nil then
      begin
        tmpSetting.SetStatusText(Pchar(s));
        Result := s;
      end;

    finally
      UnloadSetting(@tmpSetting);
    end;
  end;
end;

procedure TSharpCenterWnd.AssignIconIndex(AFileName: string; ABTData: TBTData);
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
begin
  if FileExists(AFileName) then
  begin
    tmpPngImage := TPNGObject.Create;
    tmpPngImage.LoadFromFile(AFileName);
    tmpPngImage.CreateAlpha;

    tmpPiC := picMain.PngImages.Add();
    tmpPiC.PngImage.Assign(tmpPngImage);
    tmpPiC.Background := clWindow;

    ABTData.IconIndex := tmpPic.Index;
  end
  else if ExtractFilePath(AFileName) = GetCenterDirectory then
    ABTData.IconIndex := 3
  else
    ABTData.IconIndex := 2;

  lbTree.ItemHeight := GlobalItemHeight;
  {if picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6 >
    lbTree.ItemHeight then
    lbTree.ItemHeight :=
      picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6; }

end;

procedure TSharpCenterWnd.DisablePluginButtons;
begin
  // Set buttons
  {btnMoveUp.Enabled := False;
  btnMoveDown.Enabled := False;
  btnAdd.Enabled := False;
  btnEdit.Enabled := False;
  btnDelete.Enabled := False;
  btnImport.Enabled := False;
  btnExport.Enabled := False;
  btnClear.Enabled := False; }
end;

procedure TSharpCenterWnd.lblTreeHyperLinkClick(Sender: TObject;
  LinkName: string);
begin
  if ExtractFileExt(LinkName) = '.con' then
    ExecuteCommand(cLoadConfig, LinkName, '')
  else
    ExecuteCommand(cChangeFolder, LinkName, '');

  SharpCenterManager.SetNavRoot(LinkName);
end;

procedure TSharpCenterWnd.lblTabsHyperLinkClick(Sender: TObject;
  LinkName: string);
begin
  FSelectedTabID := StrToInt(LinkName);
  UpdateSections;

  if @FSetting.ClickTab <> nil then
    FSetting.ClickTab(FSections[FSelectedTabID]);

end;

procedure TSharpCenterWnd.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;

  if @FSetting <> nil then
    UnloadDll;

  FSections.Clear;
  FSections.Free;

  if SharpCenterManager <> nil then
    SharpCenterManager.Free;
end;

procedure TSharpCenterWnd.Button1Click(Sender: TObject);
begin
  UpdateLivePreview;
end;

procedure TSharpCenterWnd.UpdateLivePreview;
begin
  imgLivePreview.Bitmap.SetSize(pnlLivePreview.Width,pnlLivePreview.Height);
  imgLivePreview.Bitmap.Clear(clwhite32);

  if (@FSetting.UpdatePreview <> nil) then
    FSetting.UpdatePreview(imgLivePreview);

  pnlLivePreview.Visible := (@FSetting.UpdatePreview <> nil);
end;

procedure TSharpCenterWnd.WMPosChange(var Message: TWMWINDOWPOSCHANGING);
begin

  //UpdateSize;
end;

procedure TSharpCenterWnd.HideAllTaskbarButton;
begin
  ShowWindow(Application.Handle, SW_HIDE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
    GetWindowLong(Application.Handle, GWL_EXSTYLE) and not WS_EX_APPWINDOW
    or WS_EX_TOOLWINDOW);
  ShowWindow(Application.Handle, SW_SHOW);
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
    if SharpCenterManager.CheckEditState then
      exit;


    if FSetting.Dllhandle <> 0 then
    begin
      UnloadDll;
      SharpCenterManager.ClickButton(nil);
    end
    else begin
      SharpCenterManager.ClickButton(nil);
    end;

    UpdateSize;
  finally
  end;
end;

procedure TSharpCenterWnd.lbTreeGetCellColor(const AItem: Integer;
  var AColor: TColor);
begin
  if AItem = lbTree.ItemIndex then
    AColor := $00C1F4FE;
end;

procedure TSharpCenterWnd.UpdateSettingTheme;
var
  colBackground, colItem, colSelectedItem: TColor;
begin
  if @FSetting.GetCenterScheme <> nil then begin

    if Not(SharpCenterManager.EditItemWarning) then begin
      colBackground := $00FBEFE3;
      colItem := clWindow;
      colSelectedItem := $00FBEFE3;
    end else begin
      colBackground := $00d9d6f9;
      colItem := clWindow;
      colSelectedItem := $00FBEFE3;
    end;

    FSetting.GetCenterScheme(colBackground,
      colItem, colSelectedItem);

    pnlEditContainer.Color := colBackground;
    pnlEditPlugin.Color := colBackground;
    pagAddEdit.Color := colBackground;
    pnlEditButtons.Color := colBackground;
    tlEditItem.TabSelectedColor := colBackground;

    if Not(pnlEditContainer.Visible) then
    tlEditItem.TabIndex := -1;

    btnEditCancel.Enabled := True;

    if SharpCenterManager.EditItemState then begin
      btnEditApply.Enabled := True;
      btnEditCancel.Caption := 'Cancel';
    end else begin
      btnEditApply.Enabled := False;
      btnEditCancel.Caption := 'Close';
    end;
      
    Self.Invalidate;


  end;
end;

procedure TSharpCenterWnd.CenterMessage(var Msg: TMessage);
begin
  Case msg.WParam of
    {SCM_SET_BUTTON_ENABLED, SCM_SET_BUTTON_DISABLED: begin

      bEnabled := (msg.LParam = SCM_SET_BUTTON_ENABLED);
      iBtnID := msg.LParam;
      case iBtnID of
        SCB_MOVEUP: btnMoveUp.Enabled := bEnabled;
        SCB_MOVEDOWN: btnMoveDown.Enabled := bEnabled;
        SCB_ADD: btnAdd.Enabled := bEnabled;
        SCB_DEL: btnDelete.Enabled := bEnabled;
        SCB_EDIT: btnEdit.Enabled := bEnabled;
        SCB_IMPORT: btnImport.Enabled := bEnabled;
        SCB_EXPORT: btnExport.Enabled := bEnabled;
        SCB_CLEAR : btnClear.Enabled := bEnabled;
        SCB_HELP : btnHelp.Enabled := bEnabled;
      end;
    end; }

    SCM_SET_SETTINGS_CHANGED: begin
      btnSave.Enabled := True;
      btnCancel.Enabled := True;

      UpdateSections;
    end;
    SCM_EVT_UPDATE_PREVIEW : begin
      UpdateLivePreview;
    end;
    SCM_SET_EDIT_STATE: begin
      SharpCenterManager.EditItemState := True;
    end;
    SCM_SET_EDIT_CANCEL_STATE: begin
      SharpCenterManager.EditItemState := False;
    end;
  end;
end;

procedure TSharpCenterWnd.btnEditCancelClick(Sender: TObject);
begin

  LockWindowUpdate(Self.Handle);
  Try
  if (@FSetting.CloseEdit <> nil) then
    FSetting.CloseEdit(pnlEditPlugin.Handle,False,False);

  if Not(SharpCenterManager.EditItemState) then begin
    SharpCenterManager.EditItemState := False;
    SharpCenterManager.EditItemWarning := False;
    EditItemHandle := 0;

    pnlEditContainer.Hide;
    UpdateSettingTheme;
    exit;
  end;

  SharpCenterManager.EditItemState := False;
  SharpCenterManager.EditItemWarning := False;
  EditItemHandle := 0;

  tlEditItemTabClick(tlEditItem,tlEditItem.TabIndex);
  UpdateSettingTheme;
  Finally
    LockWindowUpdate(0);
    Self.Update;
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
  if SharpCenterManager.CheckEditState then
      AChange := False;
end;

procedure TSharpCenterWnd.tlToolbarTabClick(ASender: TObject; const ATabIndex:Integer);
begin

  Case ATabIndex of
  //0: btnHome.Click;
  //1: btnFavourite.Click;
  2: btnBackClick(nil);
  //3: btnImport.Click;
 // 4: btnExport.Click  }
//  end;
  end;
end;

procedure TSharpCenterWnd.tlEditItemTabClick(ASender: TObject;
  const ATabIndex: Integer);
var
  handle:THandle;
begin
  // If in edit state do not continue
    if SharpCenterManager.CheckEditState then
      exit;

  Case ATabIndex of
  0,1: begin
    plStandardEdit.ActivePage := pagAddEdit;
    if (@FSetting.OpenEdit <> nil) then begin

      if ATabIndex = 0 then
        handle := FSetting.OpenEdit(pnlEditPlugin.Handle,True) else
        handle := FSetting.OpenEdit(pnlEditPlugin.Handle,False);

      if handle <> HR_NORECIEVERWINDOW then begin
        FEditItemHandle := handle;

        pnlEditContainer.Show;
        pagAddEdit.Show;
        pnlEditPlugin.ParentWindow := handle;

        // Update Scheme
        UpdateSettingTheme;

        UpdateSize;
        ForceForegroundWindow(EditItemHandle);
        //ResizeToWindow(handle, pnlEditContainer);
      end;
    end;
  end;
  2: plStandardEdit.ActivePage := pagDelete;
  End;
end;

procedure TSharpCenterWnd.tlEditItemTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
begin
  if SharpCenterManager.CheckEditState then
      AChange := False;
end;

procedure TSharpCenterWnd.btnEditApplyClick(Sender: TObject);
var
  bValid: Boolean;
begin
  bValid := True;
  LockWindowUpdate(Self.Handle);
  Try
  if (@FSetting.CloseEdit <> nil) then begin
    if tlEditItem.TabIndex = 0 then
    bValid := FSetting.CloseEdit(pnlEditPlugin.Handle,True,True) else
    bValid := FSetting.CloseEdit(pnlEditPlugin.Handle,False,True);
  end;

  if bValid then begin
    SharpCenterManager.EditItemState := False;
    SharpCenterManager.EditItemWarning := False;
    EditItemHandle := 0;

    UpdateSettingTheme;
    UpdateSections;
    tlEditItemTabClick(tlEditItem,tlEditItem.TabIndex);
  end else begin
    SharpCenterManager.CheckEditState;
  end;

  Finally
    LockWindowUpdate(0);
  End;
end;

end.


