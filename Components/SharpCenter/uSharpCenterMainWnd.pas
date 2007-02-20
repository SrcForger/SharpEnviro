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
  SharpEListBox, SharpESkinManager, uSharpCenterPluginTabList, SharpThemeApi,
  uSharpCenterDllMethods, uSharpCenterManager, JvExStdCtrls, JvHtControls,
  ToolWin, SharpERoundPanel, JvExComCtrls, JvToolBar, XPMan, uSharpETabList,
  GR32_Image, uVistaFuncs, JvLabel, JvgWizardHeader, JvPageList, SharpEListBoxEx,
  PngBitBtn;

type
  TTabID = (tidHome, tidFavourite, tidHistory, tidImport, tidExport);
  TEditTabID = (tidAdd, tidEdit, tidDelete);

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
    UnloadTimer: TTimer;
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
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure UnloadTimerTimer(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
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
    FPluginTabs: TPluginTabItemList;
    FCancelClicked: Boolean;
    FPluginHandle: THandle;
    FSelectedTabID: Integer;
    FSelectedPluginTabID: Integer;
    FEditItemHandle: THandle;

    function GetSettingChanged: Boolean;
    procedure SetControlParentWindows(Ctl: TWinControl);
    function AssignIconIndex(APluginTabObject: TPluginTabItem): Integer; overload;
    procedure AssignIconIndex(AFileName: string; ABTData: TBTData); overload;
    procedure UpdateLivePreview;
    procedure CenterMessage(var Msg: TMessage); message WM_SHARPCENTERMESSAGE;
    Procedure ClickItem;
    
    procedure EditTabVisible(AVisible:Boolean);
    procedure InitWindow;
    procedure InitToolbar;
    procedure InitPluginTabs;
    procedure InitSize;

    procedure ShowHistory;
  public

    procedure GetCopyData(var Msg: TMessage); message wm_CopyData;
    procedure ExecuteCommand(ACommand, AParameter, APluginID: string);
    procedure UnloadDllWithTimer(ACommand, AParameter, APluginID: string);

    procedure InitialiseWindow(AOwner: TWinControl; AName: string);
    procedure UnloadDll;
    procedure ReloadDll;
    procedure LoadDll(AFileName, APluginID: string);
    function SaveChanges:Boolean;

    function GetDisplayName(ADllFilename, APluginID: string): string;
    function GetStatusText(ADllFilename, APluginID: string): string;
    procedure UpdateSettingTheme;

    procedure EnabledWM(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure SetTabIndex(ATab:TEditTabID);

    property SettingChanged: Boolean read GetSettingChanged;
    property Setting: TSetting read FSetting write
      FSetting;
    property PluginID: string read FPluginID write FPluginID;
    property DllFilename: string read FDllFilename write FDllFilename;
    property Name: string read FName write FName;
    property PluginTabs: TPluginTabItemList read FPluginTabs write FPluginTabs;
    property PluginHandle: THandle read FPluginHandle write FPluginHandle;
    property EditItemHandle: THandle read FEditItemHandle write FEditItemHandle;
    property SelectedTabID: Integer read FSelectedTabID write FSelectedTabID;

    procedure LoadSettinguration(ASettingurationFile, APluginID: string);
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
  uSharpCenterHelperMethods;

{$R *.dfm}

procedure TSharpCenterWnd.FormShow(Sender: TObject);
begin
  InitWindow;
  InitToolbar;
  SCM.BuildRoot(lbTree);
end;

procedure TSharpCenterWnd.btnHomeClick(Sender: TObject);
begin
  UnloadDll;
  InitToolbar;
  
  SetToolbarTabVisible(tidHistory,False);
  SCM.BuildRoot(lbTree);
end;

procedure TSharpCenterWnd.lbTree_MouseUp(Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if lbTree.ItemIndex = -1 then
    exit;

  ClickItem;
  InitSize;
end;

procedure TSharpCenterWnd.FormResize(Sender: TObject);
begin
  InitSize;
end;

procedure TSharpCenterWnd.GetCopyData(var Msg: TMessage);
var
  tmpMsg: TSettingMsg;
  tmpHist: TSharpCenterHistoryItem;
begin
  tmpMsg := pSettingMsg(PCopyDataStruct(msg.lParam)^.lpData)^;
  tmpHist := SCM.CurrentCommand;

  SCM.History.Add(tmpHist.Command, tmpHist.Parameter, tmpMsg.PluginID);

  //SCM.CurrentCommand.Command := tmpMsg.Command;
  //SCM.CurrentCommand.Parameter := tmpMsg.Parameter;
  //SCM.CurrentCommand.PluginID := '';

  ExecuteCommand(tmpMsg.Command, tmpMsg.Parameter, tmpMsg.PluginID);
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
    ExecuteCommand(tmpItem.Command, tmpItem.Parameter, tmpItem.PluginID);
    SCM.History.Delete(tmpItem);

    SetToolbarTabVisible(tidHistory,Not(SCM.History.List.Count = 0));
  end;
end;

procedure TSharpCenterWnd.UnloadDllWithTimer(ACommand, AParameter, APluginID: string);
begin
  FUnloadCommand := ACommand;
  FUnloadParam := AParameter;
  FUnloadID := APluginID;
  UnloadTimer.Enabled := True;
end;

procedure TSharpCenterWnd.ExecuteCommand(ACommand, AParameter, APluginID: string);
begin

  if CompareText(ACommand, cChangeFolder) = 0 then
  begin
    UnloadDllWithTimer(cChangeFolder, AParameter, APluginID);
  end
  else if CompareText(ACommand, cUnloadDll) = 0 then
  begin
    UnloadDllWithTimer(cUnloadDll, AParameter, APluginID);
  end
  else if CompareText(ACommand, cLoadSetting) = 0 then
  begin
    UnloadDllWithTimer(cLoadSetting, AParameter, APluginID);

  end;
end;

procedure TSharpCenterWnd.UnloadTimerTimer(Sender: TObject);
begin
  UnloadTimer.Enabled := False;

  if CompareText(FUnloadCommand, cUnloadDll) = 0 then
  begin
    if FSetting.Dllhandle <> 0 then
      UnloadDll;

    if not (IsDirectory(FUnloadParam)) then
      LoadSettinguration(FUnloadParam, FUnloadID);
  end
  else if CompareText(FUnloadCommand, cChangeFolder) = 0 then
  begin
    if FSetting.Dllhandle <> 0 then
      UnloadDll;

    SCM.BuildRootFromPath(FUnloadParam, Self.lbTree)
  end
  else if CompareText(FUnloadCommand, cLoadSetting) = 0 then
  begin

    if FSetting.Dllhandle <> 0 then
      UnloadDll;

    SetToolbarTabVisible(tidHistory,True);
    InitialiseWindow(pnlMain, FUnloadParam);
    LoadSettinguration(FUnloadParam,FUnloadID);
  end;
end;

procedure TSharpCenterWnd.btnHelpClick(Sender: TObject);
begin
  if (@FSetting.SetBtnState) <> nil then
    if FSetting.SetBtnState(SCB_HELP) = True then
      FSetting.ClickBtn(SCB_HELP,btnHelp,'');
end;

procedure TSharpCenterWnd.btnSaveClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  Try
    if SaveChanges then begin
      ReloadDll;
      pnlEditContainer.Hide;
    end;
  Finally
    LockWindowUpdate(0);
  End;
end;

procedure TSharpCenterWnd.UnloadDll;
begin
  if FSetting.Dllhandle = 0 then
    exit;

  if btnSave = nil then
    exit;

  // Check if Save first
  if ((btnSave.Enabled) and not (FCancelClicked)) then
  begin
    SaveChanges;
  end;

  // Handle proper closing of the edit window
  tlPluginTabs.Height := 0;
  if @FSetting.OpenEdit <> nil then begin
    pnlEditContainer.Visible := False;

    if ((@FSetting.CloseEdit <> nil) and (EditItemHandle <> 0)) then
      FSetting.CloseEdit(EditItemHandle,sceEdit,False);
  end;
  tlEditItem.Height := 0;

  // Handle proper closing of the setting
  if @FSetting.Close <> nil then
    FSetting.Close(Hinstance, false);

  // Unload dll
  UnloadSetting(@FSetting);

  InitWindow;
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

        if @FSetting.SetBtnState <> nil then
          SetToolbarTabVisible(tidImport,FSetting.SetBtnState(SCB_IMPORT));

        if @FSetting.SetBtnState <> nil then
          SetToolbarTabVisible(tidExport,FSetting.SetBtnState(SCB_EXPORT));

        pnlToolbar.Hide;
        FSelectedTabID := 0;
        FSelectedPluginTabID := 0;

        InitPluginTabs;

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
      SCM.EditItemState := False;
      SCM.EditItemWarning := False;

      UnloadDll;
    end;

    ReloadDll;
  finally
    LockWindowUpdate(0);
    FCancelClicked := False;
  end;
end;

function TSharpCenterWnd.GetSettingChanged: Boolean;
begin
  Result := btnSave.Enabled;
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
    iSettingType := 0;
    if (@FSetting.SetSettingType) <> nil then
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
  APluginTabObject: TPluginTabItem): Integer;
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
begin
  if FileExists(APluginTabObject.Icon) then
  begin
    tmpPngImage := TPNGObject.Create;
    tmpPngImage.LoadFromFile(APluginTabObject.Icon);
    tmpPngImage.CreateAlpha;

    tmpPiC := picMain.PngImages.Add();
    tmpPiC.PngImage.Assign(tmpPngImage);
    tmpPiC.Background := clWindow;

    Result := tmpPic.Index;
  end
  else
    Result := 0;
end;

procedure TSharpCenterWnd.LoadSettinguration(ASettingurationFile, APluginID: string);
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
    InitSize;
    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(ASettingurationFile);

      with xml.Root.Items.ItemNamed['Sections'] do
      begin
        for i := 0 to Pred(Items.Count) do
        begin

          NewBT := TBTDataDll.Create;

          sPath := ExtractFilePath(ASettingurationFile);
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
          lbTree.visible := True;
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

procedure TSharpCenterWnd.InitialiseWindow(AOwner: TWinControl; AName: string);
begin
  PnlButtons.DoubleBuffered := True;
  pnlEditContainer.Hide;
  tlEditItem.Height := 0;

  if not (Assigned(FPluginTabs)) then
    FPluginTabs := TPluginTabItemList.Create;

  //FPluginTabs.IconList := picMain;
  FPluginTabs.Clear;

  lbTree.Items.Clear;
  InitPluginTabs;
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
  else if ExtractFilePath(AFileName) = SCM.CenterDir then
    ABTData.IconIndex := 3
  else
    ABTData.IconIndex := 2;

  lbTree.ItemHeight := GlobalItemHeight;

end;

procedure TSharpCenterWnd.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;

  if @FSetting <> nil then
    UnloadDll;

  FPluginTabs.Clear;
  FPluginTabs.Free;
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

    if FSetting.Dllhandle <> 0 then
      UnloadDll;

    ClickItem;

    InitSize;
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

    if Not(SCM.EditItemWarning) then begin
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
    pnlEditContainer.Color := colBackground;
    pnlEditToolbar.Color := colBackground;
    tlEditItem.TabSelectedColor := colBackground;

    if Not(pnlEditContainer.Visible) then
    tlEditItem.TabIndex := -1;

    btnEditCancel.Enabled := True;

    if (SCM.EditItemState) then begin
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

      InitPluginTabs;
    end;
    SCM_EVT_UPDATE_PREVIEW : begin
      UpdateLivePreview;
    end;
    SCM_SET_EDIT_STATE: begin
      SCM.EditItemState := True;
    end;
    SCM_SET_EDIT_CANCEL_STATE: begin
      SCM.EditItemState := False;
    end;
  end;
end;

procedure TSharpCenterWnd.btnEditCancelClick(Sender: TObject);
begin

  LockWindowUpdate(Self.Handle);
  Try
  if (@FSetting.CloseEdit <> nil) then
    FSetting.CloseEdit(pnlEditPlugin.Handle,sceEdit,False);

  if Not(SCM.EditItemState) then begin
    SCM.EditItemState := False;
    SCM.EditItemWarning := False;
    EditItemHandle := 0;

    pnlEditContainer.Hide;
    UpdateSettingTheme;
    exit;
  end;

  SCM.EditItemState := False;
  SCM.EditItemWarning := False;
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
var
  bValid: Boolean;
begin
  if FSelectedTabID = integer(tidDelete) then begin
    if (@FSetting.ClickBtn <> nil) then
      FSetting.ClickBtn(SCB_DELETE,btnEditApply,'');
      exit;
  end;

  bValid := True;
  LockWindowUpdate(Self.Handle);
  Try
  if (@FSetting.CloseEdit <> nil) then begin

    case FSelectedTabID of
      Integer(tidAdd): bValid := FSetting.CloseEdit(pnlEditPlugin.Handle,sceAdd,True);
      Integer(tidEdit): bValid := FSetting.CloseEdit(pnlEditPlugin.Handle,sceEdit,True);
      Integer(tidDelete): bValid:= FSetting.CloseEdit(pnlEditPlugin.Handle,sceDelete,True);
    end;
  end;

  if bValid then begin
    SCM.EditItemState := False;
    SCM.EditItemWarning := False;
    EditItemHandle := 0;

    UpdateSettingTheme;
    InitPluginTabs;
    tlEditItemTabClick(tlEditItem,tlEditItem.TabIndex);
  end else begin
    SCM.CheckEditState;
  end;

  Finally
    LockWindowUpdate(0);
  End;
end;

procedure TSharpCenterWnd.SetTabIndex(ATab:TEditTabID);
var
  handle:THandle;
begin
  handle := 0;

  // If in edit state do not continue
    if SCM.CheckEditState then
      exit;

    if (@FSetting.OpenEdit <> nil) then begin

      case Integer(ATab) of
        Integer(tidAdd): handle :=
          FSetting.OpenEdit(pnlEditPlugin.Handle,sceAdd);
        Integer(tidEdit): handle :=
          FSetting.OpenEdit(pnlEditPlugin.Handle,sceEdit);
        Integer(tidDelete): handle :=
          FSetting.OpenEdit(pnlEditPlugin.Handle,sceDelete);
      end;

      if handle <> HR_NORECIEVERWINDOW then begin
        FEditItemHandle := handle;

        pnlEditContainer.Show;
        pnlEditPlugin.ParentWindow := handle;

        // Update Scheme
        UpdateSettingTheme;

        InitSize;
      end;
    end;
end;

procedure TSharpCenterWnd.tlEditItemTabClick(ASender: TObject;
  const ATabIndex: Integer);
begin
  FSelectedTabID := ATabIndex;
  SetTabIndex(TEditTabID(ATabIndex));
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

  // Set tab defaults
  tlPluginTabs.TextBounds := Rect(8,8,8,4);

  FSetting.Dllhandle := 0;
  pnlEditContainer.DoubleBuffered := true;

   // Reinit values
  FSelectedTabID := -1;
  PluginHandle := 0;
  EditItemHandle := 0;

  // Update UI
  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  btnHelp.Enabled := False;
  pnlEditContainer.Visible := False;
  tlEditItem.TabIndex := -1;
  pnlToolbar.Hide;

  FPluginTabs := TPluginTabItemList.Create;

  InitPluginTabs;
  InitSize;

end;

procedure TSharpCenterWnd.ClickItem;
var
  tmpBTData: TBTData;
  tmpBTDataFolder: TBTDataFolder;
  tmpBTDataSetting: TBTDataSetting;
  tmpHistItem: TSharpCenterHistoryItem;
  tmpHist:  TSharpCenterHistory;
  tmpManager: TSharpCenterManager;
  sName: string;
begin
  // Unload Dll
  if Setting.DllHandle <> 0 then
    UnloadDll;

  // Get the Button Data
  tmpBTData := TBTData(lbTree[lbTree.ItemIndex].Data);
  sName := tmpBTData.Caption;

  tmpHistItem := SCM.CurrentCommand;
  tmpHist := SCM.History;
  tmpManager := SCM;

  case tmpBTData.BT of
    btUnspecified: ;
    btFolder:
      begin
        tmpBTDataFolder := TBTDataFolder(tmpBTData);

        tmpHist.Add(tmpHistItem.Command, tmpHistItem.Parameter,
          tmpHistItem.PluginID);

        tmpHistItem.Command := cChangeFolder;
        tmpHistItem.Parameter := PathAddSeparator(tmpBTDataFolder.Path);
        tmpHistItem.PluginID := '';

        tmpManager.BuildRootFromPath(tmpHistItem.Parameter, lbTree);

        SetToolbarTabVisible(tidHistory,True);
      end;
    btSetting:
      begin

        tmpBTDataSetting := TBTDataSetting(tmpBTData);
        tmpHist.Add(tmpHistItem.Command, tmpHistItem.Parameter, tmpHistItem.PluginID);

        tmpHistItem.Command := cLoadSetting;
        tmpHistItem.Parameter := tmpBTDataSetting.SettingFile;
        tmpHistItem.PluginID := '';

        SetToolbarTabVisible(tidHistory,True);

        if fileexists(tmpHistItem.Parameter) then
        begin

          InitialiseWindow(pnlMain, tmpBTDataSetting.Caption);
          LoadSettinguration(tmpHistItem.Parameter,tmpHistItem.PluginID);

        end;

      end;
    btDll:
      begin
        LoadSelectedDll(lbTree.ItemIndex);
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

procedure TSharpCenterWnd.InitPluginTabs;
var
  i {idx}: Integer;
  s: string;

begin
  FPluginTabs.Clear;
  tlPluginTabs.Clear;
  LockWindowUpdate(Self.Handle);
  Try

  if (@FSetting.AddTabs <> nil) then
  begin
    FSetting.AddTabs(FPluginTabs);

    s := '';
    if FPluginTabs.Count = 0 then
    begin
      tlPluginTabs.Height := 0;
      rpnlContent.Top := 2;
      rpnlContent.Height := pnlPluginContainer.Height-2;
    end
    else begin
      tlPluginTabs.Height := 25;
      rpnlContent.Top := 24;
      rpnlContent.Height := pnlPluginContainer.Height-26;

      for i := 0 to Pred(FPluginTabs.Count) do
      begin
        tlPluginTabs.Add(FPluginTabs[i].Caption,-1,FPluginTabs[i].Status);

        tlPluginTabs.TabIndex := FSelectedPluginTabID;
      end;
     end;
  end
  else
  begin
    tlPluginTabs.Height := 0;
    rpnlContent.Top := 2;
    rpnlContent.Height := pnlPluginContainer.height-2;
  end;
  Finally
    LockWindowUpdate(0);
  End;
end;

procedure TSharpCenterWnd.InitSize;
begin
  UpdateLivePreview;

  if @FSetting.Open <> nil then
  begin
    If PluginHandle <> 0 then
      ResizeToFitWindow(PluginHandle, pnlPlugin);

    if @Setting.OpenEdit <> nil then
      if EditItemHandle <> 0 then begin
        pnlEditContainer.Height := GetControlByHandle(EditItemHandle).Height;
        GetControlByHandle(EditItemHandle).Width := pnlEditPlugin.Width;
      end;

  end;
end;

procedure TSharpCenterWnd.btnImportClick(Sender: TObject);
begin
  if (@FSetting.ClickBtn <> nil) then
    FSetting.ClickBtn(SCB_IMPORT,btnImport,PChar(edImportFileName.Text));
end;

procedure TSharpCenterWnd.PopupMenu1Popup(Sender: TObject);
begin
  miConfigure.Visible := False;
  miSep.Visible := False;

  if (@FSetting.SetBtnState <> nil) then
    if FSetting.SetBtnState(SCB_CONFIGURE) then begin
      miConfigure.Visible := True;
      miSep.Visible := True;
    end;

  MiAdd.Visible := (@FSetting.OpenEdit <> nil);
  MiEdit.Visible := (@FSetting.OpenEdit <> nil);
  miDelete.Visible := (@FSetting.OpenEdit <> nil);
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
    if (@FSetting.ClickBtn <> nil) then
      FSetting.ClickBtn(SCB_CONFIGURE,nil,miConfigure.Caption);
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
      ' ' + TSharpCenterHistoryItem(SCM.History.List[i]).Parameter + ' (' +
          TSharpCenterHistoryItem(SCM.History.List[i]).PluginID + ')');
end;
procedure TSharpCenterWnd.Timer1Timer(Sender: TObject);
begin
  ShowHistory;
end;

end.






