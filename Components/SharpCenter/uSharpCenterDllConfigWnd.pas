unit uSharpCenterDllConfigWnd;

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
  Tabs,
  Types,
  pngimage,
  ExtCtrls,
  Buttons,
  PngSpeedButton,
  JvExControls,
  JvComponent,
  JvGradient,
  uSharpCenterDllMethods,
  JvSimpleXml,
  JclGraphics,
  JclGraphUtils,
  SharpApi,
  StdCtrls,
  SharpEListBox,
  PngImageList,
  uSEListboxPainter,
  uSharpCenterSectionList,
  uSharpCenterManager;

type
  TfrmDllConfig = class(TForm)
    pnlPluginPanel: TPanel;
    PnlButtons: TPanel;
    graPnlbuttons: TJvGradient;
    btnHelp: TPngSpeedButton;
    btnSave: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    pnlPage: TPanel;
    picMain: TPngImageCollection;
    splMain: TSplitter;
    pnlConfigurationTree: TPanel;
    pnlDlls: TPanel;
    pnlSections: TPanel;
    SharpEListBox1: TSharpEListBox;
    pnlSectionsCaption: TPanel;
    JvGradient2: TJvGradient;
    Panel1: TPanel;
    JvGradient1: TJvGradient;
    lblDllsCaption: TLabel;
    Panel5: TPanel;
    lbDlls: TSharpEListBox;
    Panel2: TPanel;
    pnlPlugin: TPanel;
    Panel3: TPanel;
    JvGradient3: TJvGradient;
    btnImport: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    btnClear: TPngSpeedButton;
    btnAdd: TPngSpeedButton;
    btnEdit: TPngSpeedButton;
    btnDelete: TPngSpeedButton;
    btnMoveDown: TPngSpeedButton;
    btnMoveUp: TPngSpeedButton;
    btnBack: TPngSpeedButton;
    btnHome: TPngSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lbSections: TSharpEListBox;
    procedure lbDllsClick(Sender: TObject);
    procedure lbSectionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnHomeClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbSectionsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbDllsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button1Click(Sender: TObject);
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
  private
    { Private declarations }
    FMoveUp, FMoveDown: Boolean;
    FConfigDll: TConfigDll;
    FPluginID: Integer;
    FCancelClicked: Boolean;
    FDllFilename: string;
    FName: string;
    FOwnerWinControl: TWinControl;
    FPluginHandle: THandle;
    FSections: TSectionObjectList;

    procedure SettingsChanged(var Msg: TMessage); message WM_SETTINGSCHANGED;
    procedure ButtonStateEvent(var Msg: TMessage); message WM_SCGLOBALBTNMSG;

    procedure ResizeToFitWindow(AHandle: THandle; AControl: TWinControl);
    function GetControlByHandle(AHandle: THandle): TWinControl;
    function GetConfigChanged: Boolean;
    procedure SetControlParentWindows(Ctl: TWinControl);
    procedure EnabledWM(var Msg: TMessage); message CM_ENABLEDCHANGED;

    function AssignIconIndex(ASectionObject: TSectionObject): Integer; overload;
    procedure AssignIconIndex(AFileName: string; ABTData: TBTData); overload;
    function GetDisplayName(ADllFilename: string; APluginID: Integer): string;

  public
    { Public declarations }
    constructor Create(AOwner: TWinControl; AConfigurationFile: string; AName:
      string);
    destructor Destroy; override;
    property ConfigDll: TConfigDll read FConfigDll write FConfigDll;
    property PluginID: Integer read FPluginID write FPluginID;
    property DllFilename: string read FDllFilename write FDllFilename;
    property Name: string read FName write FName;
    property OwnerWinControl: TWinControl read FOwnerWinControl write
      FOwnerWinControl;
    property PluginHandle: THandle read FPluginHandle write FPluginHandle;

    procedure UnloadDll;
    procedure ReloadDll;
    procedure LoadDll(AFileName: string);
    procedure LoadConfiguration(AConfigurationFile: string);
    procedure SaveChanges;
    procedure LoadSelectedDll(AItemIndex: Integer);

    procedure InitialiseWindow(AOwner: TWinControl; AName: string);
    property ConfigChanged: Boolean read GetConfigChanged;
    procedure UpdateSize;
    procedure UpdateSections;

    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
  end;

var
  frmDllConfig: TfrmDllConfig;

implementation

uses
  uSharpCenterMainWnd;

{$R *.dfm}

{ TfrmDllConfig }

function TfrmDllConfig.GetControlByHandle(AHandle: THandle): TWinControl;
begin
  Result := Pointer(GetProp(AHandle,
    PChar(Format('Delphi%8.8x', [GetCurrentProcessID]))));
end;

procedure TfrmDllConfig.ButtonStateEvent(var Msg: TMessage);
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

procedure TfrmDllConfig.ResizeToFitWindow(AHandle: THandle; AControl:
  TWinControl);
begin
  GetControlByHandle(AHandle).Height := AControl.Height;
  GetControlByHandle(AHandle).Width := AControl.Width;
  GetControlByHandle(AHandle).Invalidate;
end;

destructor TfrmDllConfig.Destroy;
begin

  if @FConfigDll <> nil then
    UnloadDll;

  FSections.Clear;
  FSections.Free;

  inherited;
end;

procedure TfrmDllConfig.SettingsChanged(var Msg: TMessage);
begin
  btnSave.Enabled := True;
  btnCancel.Enabled := True;

  UpdateSections;
end;

procedure TfrmDllConfig.btnHelpClick(Sender: TObject);
begin
  if @FConfigDll.Help <> nil then
    FConfigDll.Help;
end;

procedure TfrmDllConfig.btnSaveClick(Sender: TObject);
begin
  SaveChanges;

  ReloadDll;
end;

procedure TfrmDllConfig.UnloadDll;
begin
  if btnSave = nil then
    exit;
  if ((btnSave.Enabled) and not (FCancelClicked)) then begin
    if (MessageDlg('Do you want to save changes?', mtConfirmation, [mbYes,
      mbNo], 0) = mrYes) then
      SaveChanges;
  end;

  if @FConfigDll.Close <> nil then
    FConfigDll.Close(Hinstance, false);

  UnloadConfigDll(@FConfigDll);

  btnSave.Enabled := False;
  btnCancel.Enabled := False;
  btnHelp.Enabled := False;
end;

procedure TfrmDllConfig.ReloadDll;
begin
  LoadDll(FDllFilename);
end;

procedure TfrmDllConfig.LoadDll(AFileName: string);
var
  Xml: TJvSimpleXML;
  iConfigDllType: Integer;
  s: string;
  i: Integer;
  num, ItemHeight: Integer;
begin
  Xml := TJvSimpleXML.Create(nil);
  //LockWindowUpdate(Self.Handle);
  FDllFilename := AFileName;

  try

    // Check Dll is already loaded
    if @FConfigDll.Open <> nil then
      UnloadDll;

    if FileExists(AFileName) then begin
      FConfigDll := LoadConfigDll(PChar(AFileName));

      if @FConfigDll.Open <> nil then begin

        //Self.ParentWindow := OwnerWinControl.Handle;

        FPluginHandle := FConfigDll.Open(FPluginID, pnlPlugin.Handle);
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

        UpdateSections;

        case iConfigDllType of
          SCU_SHARPTHEME: ; // already assigned
          SCU_SERVICE: begin

              s := GetSharpeUserSettingsPath +
                'SharpCore\ServiceList.xml';

              if FileExists(s) then begin
                Xml.LoadFromFile(s);
                with Xml.Root.Items do

                  if ItemNamed[FName] <> nil then
                    FPluginID :=
                      ItemNamed[FName].Properties.IntValue('ID',
                      -1);
              end;
            end;
        end;
      end;
    end;

  finally
    Xml.Free;

    //LockWindowUpdate(0);
  end;
end;

procedure TfrmDllConfig.btnCancelClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try
    FCancelClicked := True;
    ReloadDll;
  finally
    LockWindowUpdate(0);
    FCancelClicked := False;
  end;
end;

procedure TfrmDllConfig.btnImportClick(Sender: TObject);
begin
  if @FConfigDll.BtnImport <> nil then try
    FConfigDll.BtnImport(BtnImport);
  except
    MessageDlg('Unable to Import Configuration' + #13 +
      'Check SharpConsole for details', mtError, [mbOK], 0);
  end;
end;

procedure TfrmDllConfig.btnExportClick(Sender: TObject);
begin
  if @FConfigDll.BtnExport <> nil then try
    FConfigDll.BtnExport(BtnExport);
  except
    MessageDlg('Unable to Export Configuration' + #13 +
      'Check SharpConsole for details', mtError, [mbOK], 0);
  end;

end;

procedure TfrmDllConfig.btnClearClick(Sender: TObject);
begin
  if @FConfigDll.BtnClear <> nil then
    FConfigDll.BtnClear(BtnClear);
end;

procedure TfrmDllConfig.btnMoveDownClick(Sender: TObject);
begin
  if @FConfigDll.BtnMoveDown <> nil then
    FConfigDll.BtnMoveDown(BtnMoveDown);
end;

procedure TfrmDllConfig.btnMoveUpClick(Sender: TObject);
begin
  if @FConfigDll.BtnMoveUp <> nil then
    FConfigDll.BtnMoveUp(BtnMoveUp);
end;

procedure TfrmDllConfig.btnAddClick(Sender: TObject);
begin
  if @FConfigDll.BtnAdd <> nil then
    FConfigDll.BtnAdd(BtnAdd);
end;

procedure TfrmDllConfig.btnDeleteClick(Sender: TObject);
begin
  if @FConfigDll.btnDelete <> nil then
    FConfigDll.BtnDelete(BtnDelete);
end;

procedure TfrmDllConfig.btnEditClick(Sender: TObject);
begin
  if @FConfigDll.btnEdit <> nil then
    FConfigDll.BtnEdit(BtnEdit);
end;

function TfrmDllConfig.GetConfigChanged: Boolean;
begin
  Result := btnSave.Enabled;
end;

procedure TfrmDllConfig.UpdateSize;
begin
  if @FConfigDll.Open <> nil then begin

    if (Self <> nil) and (OwnerWinControl <> nil) then begin
      ResizeToFitWindow(Self.Handle, OwnerWinControl);

      if PluginHandle <> 0 then
        ResizeToFitWindow(PluginHandle, pnlPlugin);
    end;
  end;

  if frmDllConfig <> nil then
    ResizeToFitWindow(frmDllConfig.Handle, OwnerWinControl);
end;

procedure TfrmDllConfig.SetControlParentWindows(Ctl: TWinControl);
var
  i: Integer;
  ChildCtl: TWinControl;
begin
  i := 0;
  while (i < Ctl.ControlCount) do begin
    if (Ctl.Controls[i] is TWinControl) then begin
      ChildCtl := TWinControl(Ctl.Controls[i]);
      ChildCtl.Parent := nil;
      ChildCtl.ParentWindow := Ctl.Handle;
      SetControlParentWindows(ChildCtl);
    end
    else
      Inc(i);
  end;
end;

procedure TfrmDllConfig.EnabledWM(var Msg: TMessage);
begin
  SendMessage(self.Handle, msg.Msg, msg.WParam, msg.LParam);
end;

procedure TfrmDllConfig.Button1Click(Sender: TObject);
begin
  btnCancel.Enabled := true;
end;

procedure TfrmDllConfig.SaveChanges;
var
  iConfigDllType: Integer;
begin
  LockWindowUpdate(Self.Handle);
  try
    if FConfigDll.Close(Self.Handle, True) then begin
      iConfigDllType := FConfigDll.ConfigDllType;
      SharpEBroadCast(WM_SHARPEUPDATESETTINGS, iConfigDllType, FPluginID);

      btnSave.Enabled := False;
      btnCancel.Enabled := False;
    end;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmDllConfig.lbDllsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  colItem: TColor;
  num: string;
  tmpItem: TBTDataDll;
begin
  if lbDlls.Items.Count = 0 then
    exit;

  num := '';
  tmpItem := TBTDataDll(lbDlls.Items.Objects[Index]);
  if tmpItem <> nil then
    PaintListbox(lbDlls, Rect, 0 {5}, State, tmpItem.Caption,
      picMain,
      tmpItem.IconIndex, tmpItem.Status, clBlack);
end;

procedure TfrmDllConfig.lbSectionsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if lbSections.ItemIndex = -1 then
    exit;
  if @FConfigDll.ChangeSection <> nil then
    FConfigDll.ChangeSection(FSections[lbSections.ItemIndex]);
end;

procedure TfrmDllConfig.FormResize(Sender: TObject);
begin
  lbDlls.Invalidate;
  lbSections.Invalidate;
  UpdateSize;
end;

function TfrmDllConfig.AssignIconIndex(ASectionObject: TSectionObject): Integer;
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
begin
  if FileExists(ASectionObject.Icon) then begin
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

  {if SharpCenterWnd.picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6 >
  SharpCenterWnd.lbSections.ItemHeight then
    SharpCenterWnd.lbSections.ItemHeight :=
    SharpCenterWnd.picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6; }
end;

procedure TfrmDllConfig.btnBackClick(Sender: TObject);
begin
  LockWindowUpdate(SharpCenterWnd.Handle);
  try
    frmDllConfig.UnloadDll;
    frmDllConfig.Hide;
    //FreeAndNil(frmDllConfig);
  finally
    lockwindowupdate(0);
  end;
end;

procedure TfrmDllConfig.btnHomeClick(Sender: TObject);
begin
  LockWindowUpdate(SharpCenterWnd.Handle);
  try
    btnBack.Click;
    SharpCenterWnd.BuildSectionRoot;
  finally
    lockwindowupdate(0);
  end;
end;

constructor TfrmDllConfig.Create(AOwner: TWinControl;
  AConfigurationFile: string; AName: string);
begin
  inherited Create(AOwner);

  InitialiseWindow(AOwner, AName);
  LoadConfiguration(AConfigurationFile);
end;

procedure TfrmDllConfig.LoadConfiguration(AConfigurationFile: string);
var
  xml: TJvSimpleXML;
  i: Integer;
  pngfile: string;
  s, sDll, sIcon, sName: string;
  NewBT: TBTData;
  sPath: string;
begin
  LockWindowUpdate(SharpCenterWnd.Handle);

  try
    Self.ParentWindow := OwnerWinControl.Handle;
    Self.Left := 0;
    Self.Top := 0;
    Self.BorderStyle := bsNone;
    Self.Show;
    ResizeToFitWindow(Self.Handle, OwnerWinControl);

    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(AConfigurationFile);

      with xml.Root.Items.ItemNamed['Sections'] do begin
        for i := 0 to Pred(Items.Count) do begin

          NewBT := TBTDataDll.Create;

          sPath := ExtractFilePath(AConfigurationFile);
          sDll := '';
          if Items.Item[i].Items.ItemNamed['Dll'] <> nil then
            sDll := Items.Item[i].Items.ItemNamed['Dll'].Value;

          sIcon := '';
          if Items.Item[i].Items.ItemNamed['Icon'] <> nil then
            sIcon := Items.Item[i].Items.ItemNamed['Icon'].Value;

          s := GetDisplayName(sPath + sDll, -1);

          if s = '' then
            NewBT.Caption := Items.Item[i].Name
          else
            NewBT.Caption := s;

          lbDlls.Items.AddObject(NewBT.Caption, NewBT);
          TBTDataDll(NewBT).Path := sPath + sDll;
          TBTDataDll(NewBT).PluginID := -1;
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

    {if lbDlls.Count = 1 then
        pnlDlls.Visible := False else
        pnlDlls.Visible := True;

    if lbSections.Count = 1 then
        pnlSections.Visible := False else
        pnlSections.Visible := True; }

      {if ((lbSections.Count <= 1) and (lbDlls.Count <=1)) then
        pnlConfigurationTree.Hide else
        pnlConfigurationTree.Show;}

    LockWindowUpdate(0);
  end;
end;

function TfrmDllConfig.GetDisplayName(ADllFilename: string;
  APluginID: Integer): string;
var
  tmpConfigDll: TConfigDll;
  s: PChar;
begin
  Result := '';

  if fileexists(ADllFilename) then begin
    tmpConfigDll := LoadConfigDll(PChar(ADllFilename));

    try
      if @tmpConfigDll.GetDisplayName <> nil then begin
        tmpConfigDll.GetDisplayName(APluginID, s);
        Result := s;
      end;

    finally
      UnloadConfigDll(@tmpConfigDll);
    end;
  end;
end;

procedure TfrmDllConfig.AssignIconIndex(AFileName: string; ABTData: TBTData);
var
  tmpPngImage: TPNGObject;
  tmpPiC: TPngImageCollectionItem;
begin
  if FileExists(AFileName) then begin
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

  if picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6 >
    lbDlls.ItemHeight then
    lbDlls.ItemHeight :=
      picMain.Items.Items[ABTData.IconIndex].PngImage.Height + 6;

end;

procedure TfrmDllConfig.lbSectionsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  colItem: TColor;
  tmpItem: TSectionObject;
begin
  if lbSections.Items.Count = 0 then
    exit;

  try
    tmpItem := TSectionObject(lbSections.Items.Objects[Index]);
    if tmpItem <> nil then
      PaintListbox(lbSections, Rect, 0 {5}, State, tmpItem.Caption,
        picMain,
        tmpItem.IconID, tmpItem.Status, clBlack);
  except
  end;
end;

procedure TfrmDllConfig.LoadSelectedDll(AItemIndex: Integer);
var
  tmpItem: TBTDataDll;
begin
  tmpItem := TBTDataDll(lbDlls.Items.Objects[AItemIndex]);
  if tmpItem <> nil then begin
    LoadDll(tmpItem.Path);

    lbDlls.ItemIndex := AItemIndex;
  end;
end;

procedure TfrmDllConfig.lbDllsClick(Sender: TObject);
begin
  if lbDlls.ItemIndex = -1 then
    exit;

  LoadSelectedDll(lbDlls.ItemIndex);
end;

procedure TfrmDllConfig.InitialiseWindow(AOwner: TWinControl; AName: string);
begin
  LockWindowUpdate(SharpCenterWnd.Handle);
  try
    PnlButtons.DoubleBuffered := True;
    pnlPluginPanel.DoubleBuffered := True;
    graPnlbuttons.StartColor := clBtnFace;
    graPnlbuttons.EndColor := clWindow;

    if not (Assigned(FSections)) then
      FSections := TSectionObjectList.Create;

    FSections.IconList := picMain;
    FSections.Clear;

    lblDllsCaption.Caption := AName;

    lbDlls.Clear;
    lbSections.Clear;

    if AOwner <> nil then begin
      OwnerWinControl := AOwner;
    end
    else
      OwnerWinControl := Self;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmDllConfig.WMSysCommand(var Message: TMessage);
begin
  case Message.WParam and $FFF0 of
    SC_MAXIMIZE: FormResize(nil);
    SC_MINIMIZE: FormResize(nil);
  end;
  inherited;
end;

procedure TfrmDllConfig.UpdateSections;
var
  Itemheight: Integer;
  num, i, idx: Integer;
begin
  LockWindowUpdate(SharpCenterWnd.Handle);
  try
    FSections.Clear;

    if @FConfigDll.AddSections <> nil then begin
      ItemHeight := SharpCenterWnd.lbSections.ItemHeight;
      FConfigDll.AddSections(FSections, num);

      // Add to Section List
      idx := lbSections.ItemIndex;
      lbSections.Clear;
      for i := 0 to Pred(FSections.Count) do begin
        num := -1;

        if FSections[i] <> nil then begin
          FSections[i].IconID := AssignIconIndex(FSections[i]);
          lbSections.Items.AddObject(FSections[i].Caption, FSections[i]);
        end;
      end;

      if @FConfigDll.ChangeSection <> nil then begin
        if lbSections.Count <> 0 then begin
          lbSections.ItemIndex := 0;

          if Not((idx <> -1) and (idx < lbSections.Count)) then
            idx := 0;

          FConfigDll.ChangeSection(FSections[idx]);
          lbSections.ItemIndex := idx;
        end;
      end;

      lbSections.ItemHeight := ItemHeight;

      if (lbSections.Count <= 1) then begin
        pnlSections.Height := 0;
      end
      else begin
        pnlSections.Height := pnlSectionsCaption.Height +
          (lbSections.ItemHeight * (lbSections.Count)) + 12;

        pnlSectionsCaption.Visible := True;
      end;
    end
    else begin
      lbSections.Clear;
      pnlSectionsCaption.Visible := False;
    end;
  finally
    lockwindowupdate(0);
  end;
end;

end.

