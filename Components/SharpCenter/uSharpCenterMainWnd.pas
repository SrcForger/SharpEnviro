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
  ToolWin, SharpERoundPanel, JvExComCtrls, JvToolBar, XPMan;

type
  TSharpCenterWnd = class(TForm)
    pnlConfigurationTree: TPanel;
    splMain: TSplitter;
    pnlTree: TPanel;
    picMain: TPngImageCollection;
    pnlMain: TPanel;
    Panel2: TPanel;
    UnloadTimer: TTimer;
    pnlToolbar: TPanel;
    btnBack: TPngSpeedButton;
    btnHome: TPngSpeedButton;
    PnlButtons: TPanel;
    graPnlbuttons: TJvGradient;
    btnHelp: TPngSpeedButton;
    btnSave: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    btnFavourite: TPngSpeedButton;
    PopupMenu1: TPopupMenu;
    lblTree: TJvHTLabel;
    pnlContent: TPanel;
    N11: TMenuItem;
    btnAdd: TPngSpeedButton;
    btnEdit: TPngSpeedButton;
    btnDelete: TPngSpeedButton;
    btnMoveDown: TPngSpeedButton;
    btnMoveUp: TPngSpeedButton;
    btnImport: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    btnClear: TPngSpeedButton;
    PngImageList1: TPngImageList;
    pnlSectionText: TPanel;
    lblTabs: TJvHTLabel;
    pnlPluginContainer: TPanel;
    pnlPlugin: TPanel;
    JvGradient1: TJvGradient;
    JvGradient4: TJvGradient;
    Shape1: TShape;
    Shape2: TShape;
    Panel4: TPanel;
    Image1: TImage;
    Bevel2: TShape;
    Bevel1: TShape;
    lbTree: TSharpEListBox;
    pnlTreeTitle: TPanel;
    Image2: TImage;
    XPManifest1: TXPManifest;
    procedure lblTabsHyperLinkClick(Sender: TObject; LinkName: string);
    procedure lblTreeHyperLinkClick(Sender: TObject; LinkName: string);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
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
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbTreeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnHomeClick(Sender: TObject);
    procedure lbTreeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);

    procedure FormShow(Sender: TObject);
  private
    FUnloadCommand: string;
    FUnloadParam: string;
    FUnloadID: string;
    FName: string;
    FDllFilename: string;
    FPluginID: string;
    FConfigDll: TConfigDll;
    FSections: TSectionObjectList;
    FCancelClicked: Boolean;
    FPluginHandle: THandle;
    FSelectedTabID: Integer;

    procedure SchemeWindow;
    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
    function GetControlByHandle(AHandle: THandle): TWinControl;
    procedure ResizeToFitWindow(AHandle: THandle; AControl: TWinControl);
    function GetConfigChanged: Boolean;
    procedure SetControlParentWindows(Ctl: TWinControl);
    function AssignIconIndex(ASectionObject: TSectionObject): Integer; overload;
    procedure AssignIconIndex(AFileName: string; ABTData: TBTData); overload;
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

    procedure SettingsChanged(var Msg: TMessage); message WM_SETTINGSCHANGED;
    procedure ButtonStateEvent(var Msg: TMessage); message WM_SCGLOBALBTNMSG;
    procedure EnabledWM(var Msg: TMessage); message CM_ENABLEDCHANGED;

    property ConfigChanged: Boolean read GetConfigChanged;
    property ConfigDll: TConfigDll read FConfigDll write
      FConfigDll;
    property PluginID: string read FPluginID write FPluginID;
    property DllFilename: string read FDllFilename write FDllFilename;
    property Name: string read FName write FName;
    property Sections: TSectionObjectList read FSections write FSections;
    property PluginHandle: THandle read FPluginHandle write FPluginHandle;

    procedure LoadConfiguration(AConfigurationFile, APluginID: string);
    procedure LoadSelectedDll(AItemIndex: Integer);
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

procedure TSharpCenterWnd.ResizeToFitWindow(AHandle: THandle; AControl:
  TWinControl);
begin
  GetControlByHandle(AHandle).Height := AControl.Height;
  GetControlByHandle(AHandle).Width := AControl.Width;
  GetControlByHandle(AHandle).Invalidate;

  Self.Invalidate;
end;

procedure TSharpCenterWnd.ButtonStateEvent(var Msg: TMessage);
var
  iBtnID: Integer;
  bEnabled: Boolean;
begin
  case Msg.LParam of
    0: bEnabled := False;
    1: bEnabled := True;
  else
    bEnabled := False;
  end;

  iBtnID := msg.WParam;
  case iBtnID of
    SCB_MOVEUP: btnMoveUp.Enabled := bEnabled;
    SCB_MOVEDOWN: btnMoveDown.Enabled := bEnabled;
    SCB_ADD: btnAdd.Enabled := bEnabled;
    SCB_DEL: btnDelete.Enabled := bEnabled;
    SCB_EDIT: btnEdit.Enabled := bEnabled;
    SCB_IMPORT: btnImport.Enabled := bEnabled;
    SCB_EXPORT: btnExport.Enabled := bEnabled;
    SCB_CLEAR: btnClear.Enabled := bEnabled;
  end;
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

procedure TSharpCenterWnd.lbTreeDrawItem(Control: TWinControl; Index:
  Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  tmpItem: TBTData;
begin
  if lbTree.Items.Count = 0 then
    exit;

  tmpItem := TBTData(lbTree.Items.Objects[Index]);

  if assigned(tmpItem) then
  begin
    PaintListbox(lbTree, Rect, 0 {5}, State, tmpItem.Caption, picMain,
      tmpItem.IconIndex, tmpItem.Status,
      clBlack);
  end
  else
    PaintListbox(lbTree, Rect, 0 {5}, State, 'No Items', '', clLtGray);
end;

procedure TSharpCenterWnd.BuildSectionRoot;
begin
  btnBack.Enabled := False;

  SharpCenterManager.ClearHistory;

  SharpCenterManager.BuildSectionItemsFromPath(GetCenterDirectory,
    lbTree);

  SharpCenterManager.SetNavRoot(GetCenterDirectory);
end;

procedure TSharpCenterWnd.btnHomeClick(Sender: TObject);
begin
  UnloadDll;
  BuildSectionRoot;
end;

procedure TSharpCenterWnd.lbTreeMouseUp(Sender: TObject; Button:
  TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LockWindowUpdate(Self.Handle);
  try
    if lbTree.ItemIndex = -1 then
      exit;

    if FConfigDll.Dllhandle <> 0 then
    begin
      UnloadDll;
      SharpCenterManager.ClickButton(nil);
    end
    else
      SharpCenterManager.ClickButton(nil);

    UpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.FormResize(Sender: TObject);
begin
  if FConfigDll.Dllhandle <> 0 then
    UpdateSize;
end;

procedure TSharpCenterWnd.FormCreate(Sender: TObject);
begin
  FConfigDll.Dllhandle := 0;
  pnlSectionText.DoubleBuffered := True;
  pnlToolbar.DoubleBuffered := True;
  pnlMain.DoubleBuffered := True;
  PnlButtons.DoubleBuffered := True;
  pnlConfigurationTree.DoubleBuffered := True;
  pnlTreeTitle.DoubleBuffered := True;
  lbTree.DoubleBuffered := True;

  FSections := TSectionObjectList.Create;
  UpdateSections;
  DisablePluginButtons;

  SharpThemeApi.InitializeTheme;

end;

procedure TSharpCenterWnd.FormDestroy(Sender: TObject);
begin
  inherited;

  if @FConfigDll <> nil then
    UnloadDll;

  FSections.Clear;
  FSections.Free;

  if SharpCenterManager <> nil then
    SharpCenterManager.Free;
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

procedure TSharpCenterWnd.WMSysCommand(var Message: TMessage);
begin
  case Message.WParam and $FFF0 of
    SC_MAXIMIZE: FormResize(nil);
    SC_MINIMIZE: FormResize(nil);
  end;
  inherited;
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
      btnBack.Enabled := False
    else
      btnBack.Enabled := True;
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
    if FConfigDll.Dllhandle <> 0 then
      UnloadDllWithTimer(ACommand, AParameter, APluginID);

    SharpCenterManager.BuildSectionItemsFromPath(AParameter, SharpCenterWnd.lbTree);
  end
  else if CompareText(ACommand, cUnloadDll) = 0 then
  begin
    if FConfigDll.Dllhandle <> 0 then
      UnloadDllWithTimer(ACommand, AParameter, APluginID);
  end
  else if CompareText(ACommand, cLoadConfig) = 0 then
  begin
    if FConfigDll.Dllhandle <> 0 then
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
  if @FConfigDll.Help <> nil then
    FConfigDll.Help;
end;

procedure TSharpCenterWnd.btnSaveClick(Sender: TObject);
begin
  if SaveChanges then
    ReloadDll;
end;

procedure TSharpCenterWnd.UnloadDll;
begin
  if btnSave = nil then
    exit;
  if ((btnSave.Enabled) and not (FCancelClicked)) then
  begin
    if (MessageDlg('Do you want to save changes?', mtConfirmation, [mbYes,
      mbNo], 0) = mrYes) then
      SaveChanges;
  end;

  if @FConfigDll.Close <> nil then
    FConfigDll.Close(Hinstance, false);

  UnloadConfigDll(@FConfigDll);
  FSelectedTabID := -1;
  UpdateSections;

  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  btnHelp.Enabled := False;

  DisablePluginButtons;
end;

procedure TSharpCenterWnd.ReloadDll;
begin
  LoadDll(FDllFilename, FPluginID);
end;

procedure TSharpCenterWnd.LoadDll(AFileName, APluginID: string);
var
  Xml: TJvSimpleXML;
  iConfigDllType: Integer;
  s: string;
begin

  Xml := TJvSimpleXML.Create(nil);
  FDllFilename := AFileName;

  try
    
    // Check Dll is already loaded
    //if @FConfigDll.Open <> nil then
    //  UnloadDll;

    if FileExists(AFileName) then
    begin
      FConfigDll := LoadConfigDll(PChar(AFileName));

      if @FConfigDll.Open <> nil then
      begin

        //Self.ParentWindow := OwnerWinControl.Handle;

        FPluginHandle := FConfigDll.Open(Pchar(APluginID), pnlPlugin.Handle);
        pnlPlugin.ParentWindow := FPluginHandle;

        ResizeToFitWindow(PluginHandle, pnlPlugin);

        if @FConfigDll.ConfigDllType <> nil then
          iConfigDllType := FConfigDll.ConfigDllType
        else
          iConfigDllType := -1;

        btnHelp.Enabled := (@FConfigDll.Help <> nil);
        splMain.Show;

        // Set buttons
        btnMoveUp.Enabled := (@FConfigDll.BtnMoveUp <> nil);
        btnMoveDown.Enabled := (@FConfigDll.BtnMoveDown <>
          nil);
        btnAdd.Enabled := (@FConfigDll.BtnAdd <> nil);
        btnEdit.Enabled := (@FConfigDll.BtnEdit <> nil);
        btnDelete.Enabled := (@FConfigDll.BtnDelete <> nil);
        btnImport.Enabled := (@FConfigDll.BtnImport <> nil);
        btnExport.Enabled := (@FConfigDll.BtnExport <> nil);
        btnClear.Enabled := (@FConfigDll.BtnClear <> nil);
        FSelectedTabID := 0;

        UpdateSections;

        case iConfigDllType of
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
  try
    FCancelClicked := True;

    if @FConfigDll.Open <> nil then
      UnloadDll;

    ReloadDll;
  finally
    FCancelClicked := False;
  end;
end;

procedure TSharpCenterWnd.btnImportClick(Sender: TObject);
begin
  if @FConfigDll.BtnImport <> nil then
    try
      FConfigDll.BtnImport(BtnImport);
    except
      MessageDlg('Unable to Import Configuration' + #13 +
        'Check SharpConsole for details', mtError, [mbOK], 0);
    end;
end;

procedure TSharpCenterWnd.btnExportClick(Sender: TObject);
begin
  if @FConfigDll.BtnExport <> nil then
    try
      FConfigDll.BtnExport(BtnExport);
    except
      MessageDlg('Unable to Export Configuration' + #13 +
        'Check SharpConsole for details', mtError, [mbOK], 0);
    end;

end;

procedure TSharpCenterWnd.btnClearClick(Sender: TObject);
begin
  if @FConfigDll.BtnClear <> nil then
    FConfigDll.BtnClear(BtnClear);
end;

procedure TSharpCenterWnd.btnMoveDownClick(Sender: TObject);
begin
  if @FConfigDll.BtnMoveDown <> nil then
    FConfigDll.BtnMoveDown(BtnMoveDown);
end;

procedure TSharpCenterWnd.btnMoveUpClick(Sender: TObject);
begin
  if @FConfigDll.BtnMoveUp <> nil then
    FConfigDll.BtnMoveUp(BtnMoveUp);
end;

procedure TSharpCenterWnd.btnAddClick(Sender: TObject);
begin
  if @FConfigDll.BtnAdd <> nil then
    FConfigDll.BtnAdd(BtnAdd);
end;

procedure TSharpCenterWnd.btnDeleteClick(Sender: TObject);
begin
  if @FConfigDll.btnDelete <> nil then
    FConfigDll.BtnDelete(BtnDelete);
end;

procedure TSharpCenterWnd.btnEditClick(Sender: TObject);
begin
  if @FConfigDll.btnEdit <> nil then
    FConfigDll.BtnEdit(BtnEdit);
end;

function TSharpCenterWnd.GetConfigChanged: Boolean;
begin
  Result := btnSave.Enabled;
end;

procedure TSharpCenterWnd.UpdateSize;
begin
  if @FConfigDll.Open <> nil then
  begin
    ResizeToFitWindow(PluginHandle, pnlPlugin);

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

procedure TSharpCenterWnd.SettingsChanged(var Msg: TMessage);
begin
  btnSave.Enabled := True;
  btnCancel.Enabled := True;

  UpdateSections;
end;

Function TSharpCenterWnd.SaveChanges:Boolean;
var
  iConfigDllType: Integer;
  n: Integer;
  bClose: Boolean;
begin
  bClose := FConfigDll.Close(Self.Handle, True);

  if bClose then
  begin
    iConfigDllType := FConfigDll.ConfigDllType;

    if TryStrToInt(FPluginID, n) then
      n := StrToInt(FPluginID)
    else
      n := -1;

    SharpEBroadCast(WM_SHARPEUPDATESETTINGS, iConfigDllType, n);

    btnSave.Enabled := False;
    btnCancel.Enabled := False;
  end;

  Result := bClose;
end;

function TSharpCenterWnd.AssignIconIndex(
  ASectionObject: TSectionObject): Integer;
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
begin
  if FileExists(ASectionObject.Icon) then
  begin
    tmpPngImage := TPNGObject.Create;
    tmpPngImage.LoadFromFile(ASectionObject.Icon);
    tmpPngImage.CreateAlpha;

    tmpPiC := picMain.Items.Add();
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
  NewBT: TBTData;
  sPath: string;
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

          if s = '' then
            NewBT.Caption := Items.Item[i].Name
          else
            NewBT.Caption := s;

          lbTree.Items.AddObject(NewBT.Caption, NewBT);
          TBTDataDll(NewBT).Path := sPath + sDll;
          TBTDataDll(NewBT).PluginID := APluginID;
          NewBT.ID := -1;
          NewBT.BT := btDll;

          pngfile := sPath + sIcon;
          AssignIconIndex(pngfile, NewBT);
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
  Itemheight: Integer;
  num, i, idx: Integer;
  s: string;
begin
  FSections.Clear;

  if @FConfigDll.AddSections <> nil then
  begin
    ItemHeight := GlobalItemHeight;
    FConfigDll.AddSections(FSections, num);

    s := '';
    if FSections.Count = 0 then
    begin
      lblTabs.Font.Color := clGrayText;
      lblTabs.Caption := ' No Sections Defined';
    end
    else
      for i := 0 to Pred(FSections.Count) do
      begin

        if i = FSelectedTabID then
          s := s + Format('<A HREF="%d"><b> %s</b></A>', [i, FSections[i].Caption])
        else
          s := s + Format('<A HREF="%d"> %s</A>', [i, FSections[i].Caption]);
        if i <> FSections.Count - 1 then
          s := s + ' - ';
      end;

    lblTabs.Font.Color := clBtnText;
    lblTabs.Caption := s;
  end
  else
  begin
    lblTabs.Font.Color := clGrayText;
    lblTabs.Caption := ' No Sections Defined';
  end;
end;

procedure TSharpCenterWnd.InitialiseWindow(AOwner: TWinControl; AName: string);
begin
  PnlButtons.DoubleBuffered := True;
  pnlSectionText.DoubleBuffered := True;
  graPnlbuttons.StartColor := clBtnFace;
  graPnlbuttons.EndColor := clWindow;

  if not (Assigned(FSections)) then
    FSections := TSectionObjectList.Create;

  FSections.IconList := picMain;
  FSections.Clear;

  lbTree.Items.Clear;
  UpdateSections;
end;

procedure TSharpCenterWnd.LoadSelectedDll(AItemIndex: Integer);
var
  tmpItem: TBTDataDll;
begin
  tmpItem := TBTDataDll(lbTree.Items.Objects[AItemIndex]);
  if tmpItem <> nil then
  begin
    FPluginID := tmpItem.PluginID;
    LoadDll(tmpItem.Path, tmpItem.PluginID);

    lbTree.ItemIndex := AItemIndex;
  end;
end;

function TSharpCenterWnd.GetDisplayName(ADllFilename, APluginID: string): string;
var
  tmpConfigDll: TConfigDll;
  s: PChar;
begin
  Result := '';

  if fileexists(ADllFilename) then
  begin
    tmpConfigDll := LoadConfigDll(PChar(ADllFilename));

    try
      if @tmpConfigDll.GetDisplayName <> nil then
      begin
        tmpConfigDll.GetDisplayName(Pchar(APluginID), s);
        Result := s;
      end;

    finally
      UnloadConfigDll(@tmpConfigDll);
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

    tmpPiC := picMain.Items.Add();
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
  btnMoveUp.Enabled := False;
  btnMoveDown.Enabled := False;
  btnAdd.Enabled := False;
  btnEdit.Enabled := False;
  btnDelete.Enabled := False;
  btnImport.Enabled := False;
  btnExport.Enabled := False;
  btnClear.Enabled := False;
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

  if @FConfigDll.ChangeSection <> nil then
    FConfigDll.ChangeSection(FSections[FSelectedTabID]);

end;

end.

