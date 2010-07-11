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
  Math,
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
  JclFileUtils,
  JclStrings,
  JclSimpleXml,
  Tabs,
  uSharpCenterDllMethods,
  uSharpCenterManager,
  SharpERoundPanel,
  SharpETabList,
  GR32_Image,
  GR32_PNG,
  GR32,
  uVistaFuncs,
  SharpEListBoxEx,
  PngBitBtn,
  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts,
  Types, SharpEPageControl, SharpCenterApi,
  SharpECenterHeader,
  SharpEGaugeBoxEdit,
  SharpEColorEditorEx,
  SharpESwatchManager,
  uSharpXMLUtils,
  JvExControls,
  JvPageList,
  JvXPCheckCtrls,
  JvExMask, JvToolEdit, AppEvnts;

const
  cEditTabHide = 0;
  cEditTabShow = 25;
  cEdit_Add = 0;
  cEdit_Edit = 1;
  //cEdit_Delete = 2;

type
  TSharpCenterWnd = class(TForm)
    pnlSettingTree: TPanel;
    pnlMain: TPanel;
    PnlButtons: TPanel;
    btnSave: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    pnlContent: TPanel;
    tlToolbar: TSharpETabList;
    pnlToolbar: TSharpERoundPanel;
    lbTree: TSharpEListBoxEx;
    picMain: TPngImageList;
    pilIcons: TPngImageList;
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
    pcToolbar: TPageControl;
    tabHistory: TTabSheet;
    tabImport: TTabSheet;
    btnImport: TPngSpeedButton;
    Label1: TLabel;
    edImportFilename: TEdit;
    tabFav: TTabSheet;
    lbHistory: TSharpEListBoxEx;
    tabExport: TTabSheet;
    lblDescription: TLabel;
    ApplicationEvents1: TApplicationEvents;
    pnlHelp: TSharpERoundPanel;
    pnlHelpContent: TPanel;
    MainMenu1: TMainMenu;
    pnlSbHelpContent: TScrollBox;
    pnlHelpToggle: TSharpERoundPanel;
    btnHelp: TPngSpeedButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tlPluginTabsTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);

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
    procedure sbPluginResize(Sender: TObject);
    procedure lbTreeClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure lbTreeGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbTreeGetCellColor(Sender: TObject; const AItem: TSharpEListItem;
      var AColor: TColor);
    procedure tlToolbarBtnClick(ASender: TObject; const ABtnIndex: Integer);

    procedure FormShow(Sender: TObject);
    procedure pnlPluginContainerTabClick(ASender: TObject;
      const ATabIndex: Integer);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    FCancelClicked: Boolean;
    FSelectedTabID: Integer;
    FForceShow: Boolean;

    procedure UpdateLivePreview;
    //procedure CenterMessage(var Msg: TMessage); message WM_SHARPCENTERMESSAGE;
    procedure WMTerminateMessage(var Msg: TMessage); message WM_SHARPTERMINATE;
    procedure WMSettingsUpdate(var Msg: TMessage); message WM_SHARPEUPDATESETTINGS;
    procedure ClickItem;

    procedure InitCommandLine;
    procedure DoDoubleBufferAll(AComponent: TComponent);
    procedure UpdateConfigHeader;
    procedure UpdateEditButtons;
    procedure AssignPluginHostEvents;
    procedure AssignPluginEvents;
  public

    procedure GetCopyData(var Msg: TMessage); message wm_CopyData;

    procedure InitWindow;
    procedure InitToolbar;
    procedure UpdateSize;

    procedure ClearHelp;
    procedure ToggleHelp;

    function GetCommandLineParams(var enumCommandType : TSCC_COMMAND_ENUM; var sCmd, sPluginID : string) : boolean;

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
    procedure RefreshThemeEvent(Sender: TObject);
    procedure SetHomeTitleEvent(ADescription: string);
    procedure RefreshSizeEvent(Sender: TObject);
    procedure RefreshPreviewEvent(Sender: TObject);
    procedure RefreshPluginTabsEvent(Sender: TObject);
    procedure RefreshTitleEvent(Sender: TObject);
    procedure RefreshValidation(sender: TObject);
    procedure RefreshAllEvent(Sender: TObject);
    procedure SaveEvent(Sender: TObject);

    procedure AssignThemeToPluginFormEvent( AForm: TForm; AEditing: Boolean );
    procedure AssignThemeToEditFormEvent( AForm: TForm; AEditing: Boolean );

    procedure SetHostSettingsChangedEvent(Sender: TObject);

    procedure SetEditTabEvent(ATab: TSCB_BUTTON_ENUM);
    procedure SetEditTabVisibilityEvent(ATab: TSCB_BUTTON_ENUM; AVisible: Boolean);
    procedure SetButtonVisibilityEvent(ATab: TSCB_BUTTON_ENUM; AVisible: Boolean);
    procedure SetEditingEvent( AValue: Boolean );
    procedure SetWarningEvent( AValue: Boolean );
  protected
  end;

var
  SharpCenterWnd: TSharpCenterWnd;

const
  GlobalItemHeight = 25;

//procedure AssignThemeToPluginFormEventDll(AForm: TForm; AEditing: Boolean; ATheme : TCenterThemeInfo); external 'Project3.dll' name 'AssignThemeToPluginFormEvent';   

implementation

uses
  uSystemFuncs,
  uSharpCenterHelperMethods,
  uSharpCenterHistoryList,
  ISharpCenterHostUnit;

{$R *.dfm}

procedure TSharpCenterWnd.btnHelpClick(Sender: TObject);
begin
  ToggleHelp;
end;

procedure TSharpCenterWnd.btnHomeClick(Sender: TObject);
begin
  // Initialise the tool bar to a default state
  InitToolbar;

  // Build the navigation root
  SCM.BuildNavRoot;
end;

procedure TSharpCenterWnd.lbTree_MouseUp(Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ClickItem;
end;

procedure TSharpCenterWnd.FormResize(Sender: TObject);
begin
  UpdateSize;
  UpdateLivePreview;
end;

procedure TSharpCenterWnd.FormShow(Sender: TObject);
begin
  // Assign Host ui properties
  with SCM.PluginHost do
  begin
    PluginOwner := pnlPlugin;
    EditOwner := pnlEditPlugin;
    SCM.PngImageList := picMain;
  end;
  
  AssignPluginEvents;
  AssignPluginHostEvents;

  InitWindow;
  InitToolbar;
  InitCommandLine;
end;

procedure TSharpCenterWnd.GetCopyData(var Msg: TMessage);
var
  tmpMsg: TsharpE_DataStruct;
  command: TSCC_COMMAND_ENUM;
begin
  tmpMsg := PSharpE_DataStruct(PCopyDataStruct(msg.lParam)^.lpData)^;

  command := CenterCommandAsEnum(tmpMsg.Command);
  SCM.ExecuteCommand(command, tmpMsg.Parameter, tmpMsg.PluginID, '', 0);

  // Force window to front
  if command = sccLoadSetting then
    ForceForegroundWindow(Handle);
end;

function TSharpCenterWnd.GetCommandLineParams(var enumCommandType : TSCC_COMMAND_ENUM; var sCmd, sPluginID : string) : boolean;
var
  strlTokens: TStringList;
  sApiParam: string;
  n: Integer;
begin
  Result := False;

  n := Pos('-api', ParamStr(1));
  if n <> 0 then
  begin
    sApiParam := ParamStr(2);

    strlTokens := TStringlist.Create;
    try
      StrTokenToStrings(sApiParam, '|', strlTokens);
      enumCommandType := TSCC_COMMAND_ENUM(StrToInt(strlTokens[0]));
      sCmd := strlTokens[1];

      StrReplace(sCmd, '{CenterDirectory}', SharpApi.GetCenterDirectory);

      if 2 < strlTokens.Count then
        sPluginID := strlTokens[2];

      StrReplace(sPluginID, '{CurrentTheme}', GetCurrentTheme.Info.Name);
    finally
      strlTokens.Free;

      Result := True;
    end;
  end
end;

procedure TSharpCenterWnd.InitCommandLine;
var
  enumCommandType: TSCC_COMMAND_ENUM;
  sPluginID: string;
  sCmd: string;
begin
  {$WARN SYMBOL_PLATFORM OFF} SendDebugMessage('SharpCenter',cmdline,0); {$WARN SYMBOL_PLATFORM ON}

  if GetCommandLineParams(enumCommandType, sCmd, sPluginID) then
    SCM.ExecuteCommand(enumCommandType, scmd, sPluginID, '', 0)
  else
    SCM.BuildNavRoot;
end;

procedure TSharpCenterWnd.btnBackClick(Sender: TObject);
var
  tmpItem: TSharpCenterHistoryItem;
begin
  tmpItem := nil;

  if SCM.History.Count <> 0 then
  begin
    SCM.History.DeleteItem(TSharpCenterHistoryItem(SCM.History.Last));
    tmpItem := TSharpCenterHistoryItem(SCM.History.Last);
  end;

  if tmpItem <> nil then
  begin
    SCM.ExecuteCommand(tmpItem.Command, tmpItem.Param, tmpItem.PluginID, tmpItem.HelpFile, tmpItem.TabIndex);
    SCM.History.Delete(SCM.History.IndexOf(tmpItem));

    SetToolbarTabVisible(tidHistory, not (SCM.History.Count = 0));

  end;
end;

procedure TSharpCenterWnd.btnSaveClick(Sender: TObject);
begin
  if SCM.CheckEditState then
      exit;

  LockWindowUpdate(Self.Handle);
  try
    SCM.PluginHost.Editing := False;
    SCM.PluginHost.Warning := False;
    SCM.Save;

  finally
    LockWindowUpdate(0);
    PnlButtons.Hide;
  end;
end;

procedure TSharpCenterWnd.btnCancelClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  try
    FCancelClicked := True;

    SCM.PluginHost.Editing := False;
    SCM.PluginHost.Warning := False;

    SCM.Unload;
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
  bmp: TBitmap32;
begin
  if SCM = nil then
    exit;

  //LockWindowUpdate(Self.Handle);
  try

  if (SCM.PluginHasPreviewSupport) then
  begin
    bmp := TBitmap32.Create;
    try
      bmp.DrawMode := dmBlend;
      bmp.CombineMode := cmMerge;
      bmp.SetSize(pnlLivePreview.Width, 50);

      SCM.Plugin.PreviewInterface.UpdatePreview(bmp);

      imgLivePreview.Color := SCM.Theme.Background;
      pnlLivePreview.Color := SCM.Theme.Background;
      
      imgLivePreview.Bitmap.SetSize(bmp.Width, bmp.Height);
      imgLivePreview.Bitmap.Clear(color32(SCM.Theme.Background));
      bmp.DrawTo(imgLivePreview.Bitmap, 0, 0);

      pnlLivePreview.Height := bmp.Height;
      pnlLivePreview.Margins.Top := 10;
      pnlLivePreview.Margins.Bottom := 15;
    finally
      bmp.Free;
    end;
  end
  else begin
    imgLivePreview.Bitmap.SetSize(0,0);
    pnlLivePreview.Height := 0;
    pnlLivePreview.Margins.Top := 0;
    pnlLivePreview.Margins.Bottom := 0;
  end;

  finally
    //LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.ClearHelp;
var
  n : integer;
begin
  for n := pnlSbHelpContent.ComponentCount - 1 downto 0 do
    pnlSbHelpContent.Components[n].Free;
end;

procedure TSharpCenterWnd.ToggleHelp;
var
  s : string;
  fullsize : boolean;
  b : boolean;
  XML : TJclSimpleXML;
  n : integer;
  lbItem : TLabel;
  imgItem : TImage32;
  Bmp : TBitmap32;
  i : integer;
  lastItem,currentItem : TControl;
  HelpDir : string;
  h : integer;
  nextMargin : integer;
begin
  fullsize := False;
  lastItem := nil;  
  LockWindowUpdate(Handle);
  try
    if not pnlHelp.Visible then
    begin
      pnlHelp.Visible := True;
      pnlHelpToggle.Color := SCM.Theme.EditControlBackground;
      pnlHelpToggle.BorderColor := SCM.Theme.Border;
      
      // Load Help File for Current config
      if length(trim(SCM.ActiveHelpFile)) > 0 then
        if FileExists(SCM.ActiveHelpFile) then
        begin
          {$WARNINGS OFF} HelpDir := IncludeTrailingBackslash(ExtractFileDir(SCM.ActiveHelpFile)); {$WARNINGS ON}
          XML := TJclSimpleXML.Create;
          if LoadXMLFromSharedFile(XML,SCM.ActiveHelpFile,True) then
          begin
            nextMargin := 0;
            fullsize := (CompareText('full',XML.Root.Properties.Value('size','fixed')) = 0);
            for n := 0 to XML.Root.Items.Count - 1 do
              with XML.Root.Items do
              begin
                currentItem := nil;
                if (CompareText(Item[n].Name,'Image') = 0) then
                begin
                  s := HelpDir + Item[n].Value;
                  if FileExists(s) then
                  begin
                    imgItem := TImage32.Create(pnlSbHelpContent);
                    imgItem.AutoSize := True;
                    imgItem.ParentColor := True;
                    Bmp := TBitmap32.Create;                    
                    try
                      if (CompareText('.png',ExtractFileExt(s)) = 0) then
                        GR32_PNG.LoadBitmap32FromPNG(Bmp,s,b)
                      else Bmp.LoadFromFile(s);
                      imgItem.Bitmap.SetSize(Bmp.Width,Bmp.Height);
                      imgItem.Bitmap.Clear(color32(pnlSbHelpContent.Color));
                      Bmp.DrawMode := dmBlend;
                      Bmp.CombineMode := cmMerge;
                      Bmp.DrawTo(imgItem.Bitmap,0,0);
                    finally
                      Bmp.Free;
                    end;
                    imgItem.Parent := pnlSbHelpContent;
                    if (CompareText('none',Item[n].Properties.Value('span','none')) = 0) then
                    begin
                      if (lastItem <> nil) then
                        imgItem.Top := lastItem.Top + lastItem.Height
                      else imgItem.Top := 0;
                      if (CompareText('left',Item[n].Properties.Value('align','left')) = 0) then
                        imgItem.Left := 4 + nextMargin;
                      imgItem.Left := imgItem.Left + Item[n].Properties.IntValue('mleft',0);
                      imgItem.Top := imgItem.Top + Item[n].Properties.IntValue('mtop',0);                      
                      nextMargin := imgItem.Left + imgItem.Width;
                    end else begin // full span
                      imgItem.Align := alTop;
                      if (CompareText('left',Item[n].Properties.Value('align','left')) = 0) then
                        imgItem.BitmapAlign := baTopLeft
                      else imgItem.BitmapAlign := baCenter;
                      imgItem.Margins.Left := 4 + nextMargin;
                      imgItem.Margins.Right := 4;
                      imgItem.Margins.Top := 2;
                      imgItem.MArgins.Bottom := 2;
                      imgItem.AlignWithMargins := True;
                      nextMargin := 0;
                      currentItem := imgItem;
                    end;
                    imgItem.Show;
                  end;
                end;
                if (CompareText(Item[n].Name,'Label') = 0) then
                begin
                  lbItem := TLabel.Create(pnlSbHelpContent);
                  lbItem.Parent := pnlSbHelpContent;
                  lbItem.Align := alTop;
                  lbItem.Margins.Left := 4 + nextMargin;
                  lbItem.Margins.Right := 4;
                  lbItem.Margins.Top := 2;
                  lbItem.Margins.Bottom := 0;
                  lbItem.AlignWithMargins := True;
                  lbItem.AutoSize := True;
                  lbItem.WordWrap := True;

                  i := Item[n].Properties.IntValue('Indent',0);
                  lbItem.Margins.Left := lbItem.Margins.Left + i*8;

                  lbItem.Caption := Item[n].Value;
                  if Item[n].Properties.BoolValue('bold',False) then
                    lbItem.Font.Style := lbItem.Font.Style + [fsBold];
                  if Item[n].Properties.BoolValue('italic',False) then
                    lbItem.Font.Style := lbItem.Font.Style + [fsItalic];
                  if Item[n].Properties.BoolValue('underline',False) then
                    lbItem.Font.Style := lbItem.Font.Style + [fsUnderline];
                  lbItem.Show;

                  currentItem := lbItem;
                  nextMargin := 0;
                end else if (CompareText(Item[n].Name,'Sep') = 0) then
                begin
                  lbItem := TLabel.Create(pnlSbHelpContent);
                  lbItem.Parent := pnlSbHelpContent;
                  lbItem.Align := alTop;
                  lbItem.Margins.Left := 4 + nextMargin;
                  lbItem.Margins.Right := 4;
                  lbItem.Margins.Top := 0;
                  lbItem.Margins.Bottom := 0;
                  lbItem.AlignWithMargins := True;
                  lbItem.Caption := '';
                  if CompareText(Item[n].Properties.Value('Size','Normal'),'Small') = 0 then
                    lbItem.Height := 4
                  else if CompareText(Item[n].Properties.Value('Size','Normal'),'Big') = 0 then
                    lbItem.Height := 16
                  else lbItem.Height := 10;

                  lbItem.Show;

                  currentItem := lbItem;
                  nextMargin := 0;
                end;

                if (currentItem <> nil) and (lastItem <> nil) and (nextMargin = 0) then
                  currentItem.Top := lastItem.Top + lastItem.Height;
                if (currentItem <> nil) then
                  lastItem := currentItem;
              end;

          end;
          XML.Free;
        end;

        if fullsize then
        begin
          h := Height - pnlHelp.Top - pnlButtons.Height;
          if lastItem <> nil then
            pnlHelp.Height := Min(h,lastItem.Top + lastItem.Height + pnlSbHelpContent.Top + pnlHelpContent.Top + 8)
          else pnlHelp.Height := h;
        end else begin
          h := lastItem.Top + lastItem.Height + pnlSbHelpContent.Top + pnlHelpContent.Top + 8;
          if h < 224 then
            pnlHelp.Height := h
          else pnlHelp.Height := 224;
        end;
        
        // This is to force "UpdateScrollBars" to be called internally
        pnlSbHelpContent.Height := pnlSbHelpContent.Height + 1;
        pnlSbHelpContent.Height := pnlSbHelpContent.Height - 1;        
    end else
    begin
      pnlHelp.Visible := False;
      pnlHelpToggle.Color := SCM.Theme.Background;
      pnlHelpToggle.BorderColor := SCM.Theme.Background;
      ClearHelp;
    end;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.DoDoubleBufferAll(AComponent: TComponent);
var
  i: integer;
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
  lbTree.Repaint;

  if lbTree.ItemIndex = -1 then
    exit;

  // If in edit state do not continue
  if SCM.CheckEditState then
    exit;

  ClickItem;
  Application.ProcessMessages;
end;

procedure TSharpCenterWnd.lbTreeGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.ID = lbTree.ItemIndex then
    AColor := SCM.Theme.NavBarSelectedItem;
end;

procedure TSharpCenterWnd.lbTreeGetCellText(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColText: string);
var
  tmp: TSharpCenterManagerItem;
  col: TColor;
begin
  tmp := TSharpCenterManagerItem(AItem.Data);
  if tmp = nil then
    exit;

  if lbTree.SelectedItem = AItem then
    col := SCM.Theme.NavBarSelectedItemText
  else
    col := SCM.Theme.NavBarItemText;

  case ACol of
    0:
      begin
        AColText := format('<font color="%s">%s',
          [colortoString(col), tmp.Caption]);
      end;
    1:
      begin
        AColText := format('<font color="%s">%s',
          [colortoString(col), tmp.Status]);
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

procedure TSharpCenterWnd.SetButtonVisibilityEvent(ATab: TSCB_BUTTON_ENUM;
  AVisible: Boolean);
begin
  case ATab of
    scbImport: SetToolbarTabVisible(tidImport, AVisible);
    scbExport: SetToolbarTabVisible(tidExport, AVisible);
    scbConfigure:
    begin
      btnEditApply.Visible := AVisible;
      btnEditApply.Caption := 'Add';
      btnEditApply.PngImage := pilIcons.PngImages.Items[10].PngImage;
      FForceShow := True;
    end;
  end;
end;

procedure TSharpCenterWnd.SetEditingEvent(AValue: Boolean);
begin
  UpdateEditButtons;
end;

procedure TSharpCenterWnd.SetEditTabEvent(ATab: TSCB_BUTTON_ENUM);
begin

  SCM.PluginHost.Editing := False;
  SCM.PluginHost.Warning := False;

  if pnlEditContainer.Minimized then
    FSelectedTabID := -1
  else
  begin

    case ATab of
      scbAddTab:
        begin
          pnlEditContainer.TabIndex := cEdit_Add;
          FSelectedTabID := cEdit_Add;
          SCM.LoadEdit(FSelectedTabID);
        end;
      scbEditTab:
        begin
          pnlEditContainer.TabIndex := cEdit_Edit;
          FSelectedTabID := cEdit_Edit;
          SCM.LoadEdit(FSelectedTabID);
        end;
    end;
  end;
  UpdateThemeEvent(nil);
end;

procedure TSharpCenterWnd.SetEditTabVisibilityEvent(ATab: TSCB_BUTTON_ENUM;
  AVisible: Boolean);
begin
  case ATab of
    scbAddTab: pnlEditContainer.TabItems.Item[cEdit_Add].Visible := AVisible;
    scbEditTab: pnlEditContainer.TabItems.Item[cEdit_Edit].Visible := AVisible;
  end;
end;

procedure TSharpCenterWnd.SetHomeTitleEvent(ADescription: string);
begin
  pnlTitle.Visible := True;
  lblDescription.Caption := ADescription;
end;

procedure TSharpCenterWnd.SetHostSettingsChangedEvent(Sender: TObject);
begin
  PnlButtons.Show;
end;

procedure TSharpCenterWnd.AssignPluginEvents;
begin
  SCM.OnRefreshTheme := RefreshThemeEvent;
  SCM.OnInitNavigation := InitNavEvent;
  SCM.OnAddNavItem := AddItemEvent;
  SCM.OnSetHomeTitle := SetHomeTitleEvent;
  SCM.OnLoadPlugin := LoadPluginEvent;
  SCM.OnUnloadPlugin := UnloadPluginEvent;
  SCM.OnLoadEdit := LoadEditEvent;
  SCM.OnApplyEdit := ApplyEditEvent;
  SCM.OnCancelEdit := CancelEditEvent;
  SCM.OnAddPluginTabs := AddPluginTabsEvent;
  SCM.OnUpdateTheme := UpdateThemeEvent;
end;

procedure TSharpCenterWnd.AssignPluginHostEvents;
begin
  SCM.PluginHost.OnSettingsChanged := SetHostSettingsChangedEvent;
  SCM.PluginHost.OnSetEditTab := SetEditTabEvent;
  SCM.PluginHost.OnSetEditTabVisibility := SetEditTabVisibilityEvent;
  SCM.PluginHost.OnRefreshSize := RefreshSizeEvent;
  SCM.PluginHost.OnRefreshPreview := RefreshPreviewEvent;
  SCM.PluginHost.OnRefreshTheme := RefreshThemeEvent;
  SCM.PluginHost.OnRefreshPluginTabs := RefreshPluginTabsEvent;
  SCM.PluginHost.OnRefreshAll := RefreshAllEvent;
  SCM.PluginHost.OnRefreshValidation := RefreshValidation;
  SCM.PluginHost.OnSetEditing := SetEditingEvent;
  SCM.PluginHost.OnSetWarning := SetWarningEvent;
  SCM.PluginHost.OnSetButtonVisibility := SetButtonVisibilityEvent;
  SCM.PluginHost.OnRefreshTitle := RefreshTitleEvent;
  SCM.PluginHost.OnSave := SaveEvent;
  SCM.PluginHost.OnThemeEditForm := AssignThemeToEditFormEvent;
  SCM.PluginHost.OnThemePluginForm := AssignThemeToPluginFormEvent;
end;

procedure TSharpCenterWnd.AssignThemeToEditFormEvent(AForm: TForm; AEditing: Boolean);
begin
  exit;
end;

procedure TSharpCenterWnd.AssignThemeToPluginFormEvent(AForm: TForm; AEditing: Boolean);
begin
  exit;
end;

procedure TSharpCenterWnd.UpdateEditButtons;
begin
  if (SCM.PluginHost.Editing) then
  begin
    btnEditApply.Visible := True;
    case FSelectedTabID of
      integer(tidAdd):
        btnEditApply.Caption := 'Add';
      integer(tidEdit):
        btnEditApply.Caption := 'Apply';
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
    btnEditApply.Visible := False;
    case FSelectedTabID of
      integer(tidAdd):
        begin
          btnEditApply.Caption := 'Add';
          if FForceShow then begin
            btnEditApply.Visible := true;
            FForceShow := false;
          end;
        end;
      integer(tidEdit):
        btnEditApply.Caption := 'Edit';
      integer(tidDelete):
        begin
          btnEditApply.Caption := 'Delete';
          btnEditApply.Visible := True;
        end;
    end;
    btnEditCancel.Caption := 'Close';
  end;
end;

procedure TSharpCenterWnd.SetToolbarTabVisible(ATabID: TTabID; AVisible:
  Boolean);
begin
  with tlToolbar.TabList do
  begin
    case ATabID of
      tidHome: Item[0].Visible := AVisible;
      tidFavourite: Item[1].Visible := AVisible;
      tidHistory:
        begin
          //Item[2].Visible := AVisible;
          tlToolbar.Buttons.Item[1].Visible := AVisible;
        end;
      tidImport: Item[3].Visible := AVisible;
      tidExport: Item[4].Visible := AVisible;
    end;
  end;
  tlToolbar.TabIndex := 0;
  tlToolbar.Invalidate;
end;

procedure TSharpCenterWnd.SetWarningEvent(AValue: Boolean);
begin
  SCM.RefreshTheme;
end;

procedure TSharpCenterWnd.tlToolbarBtnClick(ASender: TObject;
  const ABtnIndex: Integer);
begin
  if SCM.PluginHost.Editing then exit;

  case ABtnIndex of
    0: btnHomeClick(nil);
    1: btnBackClick(nil);
  end;
end;

procedure TSharpCenterWnd.tlToolbarTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
begin
  if pnlToolbar = nil then
    exit;

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
        tabFav.show;
      end;
    Integer(tidHistory):
      begin
        pnlToolbar.Hide;
      end;
    Integer(tidImport):
      begin
        pnlToolbar.Show;
        tabImport.Show;
      end;
    Integer(tidExport):
      begin
        pnlToolbar.Show;
        tabExport.Show;
      end;
  end;

end;

procedure TSharpCenterWnd.tlToolbarTabClick(ASender: TObject; const ATabIndex:
  Integer);
begin
  if SCM.PluginHost.Editing then exit;
  
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

  DoDoubleBufferAll(pnlTitle);
  DoDoubleBufferAll(lbTree);
  DoDoubleBufferAll(pnlContent);
  DoDoubleBufferAll(pnlEditToolbar);
  Self.ParentBackground := False;
  Self.DoubleBuffered := True;

  // Reinit values
  FSelectedTabID := 0;
  FCancelClicked := False;

  PnlButtons.Hide;
  pnlEditContainer.Visible := False;
  pnlLivePreview.Height := 0;
  pnlPluginContainer.Visible := False;
  pnlEditContainer.TabIndex := -1;
  pnlTitle.Visible := False;
  pnlToolbar.Hide;

end;

procedure TSharpCenterWnd.ClickItem;
var
  tmpItem: TSharpCenterManagerItem;
  tmpHistory: TSharpCenterHistoryItem;
begin
  if lbTree.ItemIndex = -1 then exit;

  // Set the plugin tab index to 0 so we start with the 1st page of a config
  SCM.PluginTabIndex := 0;

  // Get center manager item, and exit if null
  tmpItem := TSharpCenterManagerItem(lbTree.Item[lbTree.ItemIndex].Data);
  if tmpItem = nil then
    exit;

  case tmpItem.ItemType of
    itmNone: ;
    itmFolder:
      begin
        SCM.BuildNavFromPath(tmpItem.Path);

        // Show the history tab
        SetToolbarTabVisible(tidHistory, True);
      end;
    itmSetting:
      begin
        SCM.BuildNavFromFile(tmpItem.Filename);

        // Show the history tab
        SetToolbarTabVisible(tidHistory, True);

      end;
    itmDll:
      begin

        // Don't add to the history, but change the last item otherwise its nav hell.
        tmpHistory := SCM.History.Item[SCM.History.IndexOf(SCM.History.Last)];
        tmpHistory.Command := sccLoadDll;
        tmpHistory.PluginID := tmpItem.PluginID;
        tmpHistory.Param := tmpItem.Filename;
        tmpHistory.HelpFile := tmpItem.HelpFile;
        SCM.Unload;
        SCM.Load(tmpItem.Filename, tmpItem.PluginID, tmpItem.HelpFile);
      end;
  end;
end;

procedure TSharpCenterWnd.InitToolbar;
begin
  // Hide Import Export + History
  SetToolbarTabVisible(tidImport, False);
  SetToolbarTabVisible(tidExport, False);
  SetToolbarTabVisible(tidHistory, False);

  // Hide tool bar panel, and set tabindex to home
  pnlToolbar.Visible := False;
  tlToolbar.TabIndex := 0;

  // Set plugin tab index to 0
  SCM.PluginTabIndex := 0;
end;

procedure TSharpCenterWnd.UpdateSize;
var
  h: Integer;
begin
  if SCM = nil then exit;

  if SCM.PluginWndHandle <> 0 then
  begin
    h := GetControlByHandle(SCM.PluginWndHandle).Height;
    pnlPlugin.Height := h;
    GetControlByHandle(SCM.PluginWndHandle).Width := pnlPlugin.Width;
  end;

  if SCM.EditWndHandle <> 0 then
  begin
    pnlEditContainer.Minimized := False;
    pnlEditPluginContainer.Visible := True;
    pnlEditContainer.Height := 65 + GetControlByHandle(SCM.EditWndHandle).Height;
    GetControlByHandle(SCM.EditWndHandle).Width := pnlEditPlugin.Width;
  end
  else
  begin
    pnlEditContainer.Minimized := True;
    pnlEditPluginContainer.Visible := False;
  end;
end;

procedure TSharpCenterWnd.LoadPluginEvent(Sender: TObject);
var
  i: Integer;
begin
  LockWindowUpdate(Self.Handle);
  try

    // Set add/edit tabs to visible
    //pnlEditContainer.TabItems.Item[cEdit_Add].Visible := True;
    //pnlEditContainer.TabItems.Item[cEdit_Edit].Visible := True;
    pnlToolbar.Hide;

    // Reset selected tab id
    FSelectedTabID := 0;

    // Hide/show buttons panel
    if (SCM.Plugin.ConfigMode = SharpApi.scmLive) then
      PnlButtons.Hide
    else begin
      if SCM.PluginHost.Editing then
        PnlButtons.Show;
    end;

    // Hide or show edit panel if supported
    if (SCM.PluginHasEditSupport) then
    begin
      pnlEditContainer.Minimized := True;
      pnlEditContainer.Visible := True;
      pnlEditPluginContainer.Visible := False;
      pnlEditContainer.TabList.TabIndex := -1;
    end
    else
      pnlEditContainer.Visible := False;

    // Select the first nav item in list
    for i := 0 to Pred(lbTree.Count) do
    begin
      if CompareText(TSharpCenterManagerItem(lbTree.Item[i].Data).Filename,
        SCM.Plugin.Dll) = 0 then
      begin
        lbTree.ItemIndex := i;
        break;
      end;
    end;

    // Update Title and Description
    UpdateConfigHeader;

    if pnlHelp.Visible then
      ToggleHelp;
     pnlHelpToggle.Visible := False;      

    if length(trim(SCM.ActiveHelpFile)) > 0 then
      if FileExists(SCM.ActiveHelpFile) then
        pnlHelpToggle.Visible := True;

  finally
    pnlPluginContainer.Show;

    // Forces a resize
    pnlPluginContainer.Height := pnlPluginContainer.Height + 1;
    pnlPluginContainer.Height := pnlPluginContainer.Height - 1;
    SCM.PluginHost.Refresh( rtAll );
    UpdateSize;
    sbPlugin.SetFocus;
    LockWindowUpdate(0);
  end;

end;

procedure TSharpCenterWnd.pnlPluginContainerTabClick(ASender: TObject;
  const ATabIndex: Integer);
begin
  LockWindowUpdate(Self.Handle);
  try
    SCM.ClickTab(ATabIndex);
    SCM.PluginTabIndex := ATabIndex;
    TSharpCenterHistoryItem(SCM.History.Last).TabIndex := ATabIndex;
    UpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.RefreshSizeEvent(Sender: TObject);
begin
  UpdateSize;
end;

procedure TSharpCenterWnd.RefreshAllEvent(Sender: TObject);
begin
  RefreshPreviewEvent(nil);
  //RefreshThemeEvent(nil);
  //RefreshPluginTabsEvent(nil);
  RefreshSizeEvent(nil);
  RefreshTitleEvent(nil);
end;

procedure TSharpCenterWnd.RefreshPluginTabsEvent(Sender: TObject);
begin
  SCM.LoadPluginTabs;
  lbTree.Refresh;
end;

procedure TSharpCenterWnd.RefreshPreviewEvent(Sender: TObject);
begin
  UpdateLivePreview;
end;

procedure TSharpCenterWnd.RefreshThemeEvent(Sender: TObject);
var
  colBackground: TColor;
begin

  // Navbar
  lbTree.Color := SCM.Theme.Background;

  if SCM.PluginHost.Warning then
  begin
    lbTree.Colors.ItemColor := SCM.Theme.NavBarItem;
    lbTree.Colors.ItemColorSelected := SCM.Theme.NavBarItem;
  end
  else
  begin
    lbTree.Colors.ItemColor := SCM.Theme.NavBarItem;
    lbTree.Colors.ItemColorSelected := SCM.Theme.NavBarSelectedItem;
  end;

  lbTree.Colors.DisabledColor := SCM.Theme.Background;

  // Title
  lblDescription.Font.Color := SCM.Theme.BackgroundText;

  pnlSettingTree.Color := SCM.Theme.Background;
  pnlMain.Color := SCM.Theme.Background;
  pnlContent.Color := SCM.Theme.Background;
  Self.Color := SCM.Theme.Background;
  tlToolbar.BkgColor := SCM.Theme.Background;
  pnlTitle.Color := SCM.Theme.Background;

  if SCM.PluginHost.Warning then
    colBackground := SCM.Theme.EditBackgroundError
  else
    colBackground := SCM.Theme.EditBackground;

  pnlEditContainer.Color := colBackground;
  pnlEditContainer.PageBackgroundColor := colBackground;
  pnlEditContainer.BackgroundColor := colBackground;
  pnlEditContainer.TabBackgroundColor := SCM.Theme.Background;
  pnlEditContainer.BackgroundColor := colBackground;
  pnlEditContainer.TabColor := SCM.Theme.Background;
  pnlEditContainer.TabSelColor := colBackground;
  pnlEditContainer.TabCaptionColor := SCM.Theme.BackgroundText;
  pnlEditContainer.TabCaptionSelColor := SCM.Theme.EditBackgroundText;
  pnlEditContainer.BorderColor := SCM.Theme.Border;

  pnlEditToolbar.Color := colBackground;
  pnlEditPluginContainer.Color := colBackground;
  pnlEditPluginContainer.BackgroundColor := SCM.Theme.Background;
  pnlEditPlugin.color := colBackground;

  btnEditCancel.Font.Color := SCM.Theme.EditBackgroundText;
  btnEditApply.Font.Color := SCM.Theme.EditBackgroundText;

  sbPlugin.Color := SCM.Theme.PluginBackground;
  pnlPluginContainer.PageBackgroundColor := SCM.Theme.PluginBackground;
  pnlPluginContainer.BackgroundColor := SCM.Theme.Background;
  pnlPluginContainer.TabBackgroundColor := SCM.Theme.Background;
  pnlPluginContainer.TabColor := SCM.Theme.PluginTab;
  pnlPluginContainer.TabSelColor := SCM.Theme.PluginSelectedTab;
  pnlPluginContainer.TabCaptionColor := SCM.Theme.PluginTabText;
  pnlPluginContainer.TabCaptionSelColor := SCM.Theme.PluginTabSelectedText;
  pnlPluginContainer.BorderColor := SCM.Theme.Border;
  pnlPluginContainer.DoubleBuffered := True;

  pnlContent.DoubleBuffered := True;
  pnlMain.DoubleBuffered := True;
  Self.DoubleBuffered := True;

  PnlButtons.Color := SCM.Theme.Background;
  btnSave.Font.Color := SCM.Theme.BackgroundText;
  btnCancel.Font.Color := SCM.Theme.BackgroundText;

  // Help Section
  pnlHelp.Color := SCM.Theme.EditControlBackground;
  pnlHelp.BorderColor := SCM.Theme.Border;
  pnlHelpContent.Color := SCM.Theme.EditControlBackground;

  if pnlHelp.Visible then
  begin
    pnlHelpToggle.Color := SCM.Theme.EditControlBackground;
    pnlHelpToggle.BorderColor := SCM.Theme.Border;
  end else
  begin
    pnlHelpToggle.Color := SCM.Theme.Background;
    pnlHelpToggle.BorderColor := SCM.Theme.Background;
  end;
end;

procedure TSharpCenterWnd.RefreshTitleEvent(Sender: TObject);
var
  pluginData : TPluginData;
  tmpItem: TSharpCenterManagerItem;
begin
  if lbTree.SelectedItem <> nil then
  begin
    GetConfigPluginData(SCM.Plugin.Dllhandle, pluginData, SCM.Plugin.PluginInterface.PluginHost.PluginId);
    tmpItem := TSharpCenterManagerItem(lbTree.SelectedItem.Data);
    tmpItem.Status := pluginData.Status;
    lbTree.Refresh;
  end;
  UpdateConfigHeader;
end;

procedure TSharpCenterWnd.RefreshValidation(sender: TObject);
begin
  if scm.PluginHasValidationSupport then
    SCM.RefreshValidation;
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
var
  i: Integer;
begin
  for i := lbTree.Items.Count - 1 downto 0 do
  begin
    // Free the TSharpCenterManagerItem we added in TSharpCenterWnd.AddItemEvent
    TSharpCenterManagerItem(TSharpEListItem(lbTree.Items.Objects[i]).Data).Free;
    // Free the actual TSharpEListItem here as Clear does not handle it but maybe should.
    TSharpEListItem(lbTree.Items.Objects[i]).Free;
    lbTree.Items.Objects[i] := nil;
  end;

  lbTree.Clear;
  //PnlButtons.Show;
end;

procedure TSharpCenterWnd.AddPluginTabsEvent(Sender: TObject);
var
  i {idx}: Integer;
  s: string;
  tabItem: TTabItem;
begin
  for i := pnlPluginContainer.TabList.Count - 1 downto 0 do
    pnlPluginContainer.TabList.TabItem[i].Free;
  pnlPluginContainer.TabList.Clear;

  if SCM.PluginTabs.Count <= 1 then
  begin
    pnlPluginContainer.TabList.Hide;
    sbPlugin.Margins.Top := 6;
    exit;
  end
  else
  begin
    pnlPluginContainer.TabList.Show;
    sbPlugin.Margins.Top := 32;
  end;

  try
    s := '';
    for i := 0 to Pred(SCM.PluginTabs.Count) do
    begin
      tabItem := pnlPluginContainer.TabItems.Add;
      tabItem.Caption := SCM.PluginTabs[i];

    end;

    pnlPluginContainer.TabIndex := SCM.PluginTabIndex;
  finally
    sbPlugin.Invalidate;
  end;
end;

procedure TSharpCenterWnd.UnloadPluginEvent(Sender: TObject);
begin

  // Check if Save first
  LockWindowUpdate(Self.Handle);
  try
    if ((PnlButtons.Visible) and not (FCancelClicked)) then
    begin
      SCM.Save;
    end;

    // Handle proper closing of the edit window
    if (scm.PluginHasEditSupport) then
    begin
      SCM.Plugin.EditInterface.CloseEdit(False);
    end;

  finally

    pnlEditContainer.TabList.TabIndex := -1;
    pnlLivePreview.Height := 0;
    pnlEditContainer.Visible := False;
    pnlPluginContainer.Hide;
    pnlTitle.Hide;
    PnlButtons.Hide;

    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.UpdateThemeEvent(Sender: TObject);
var
  ctrl: TWinControl;
begin
  LockWindowUpdate(Self.Handle);
  try
    ctrl := nil;
    if SCM.EditWndHandle <> 0 then
      if GetControlByHandle(SCM.EditWndHandle) <> nil then
      begin
        ctrl := TForm(GetControlByHandle(SCM.EditWndHandle)).ActiveControl;
      end;

    SCM.RefreshTheme;
    Scm.Plugin.PluginInterface.Refresh(SCM.Theme,SCM.PluginHost.Editing);

    lbTree.Enabled := not (SCM.PluginHost.Editing);
    UpdateEditButtons;

    if ctrl <> nil then
      ctrl.SetFocus;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.LoadEditEvent(Sender: TObject);
begin

  LockWindowUpdate(Self.Handle);
  try
    UpdateSize;
    SCM.PluginHost.Refresh ( rtAll );
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.SaveEvent(Sender: TObject);
begin
  SCM.Save;
end;

procedure TSharpCenterWnd.SavePluginEvent(Sender: TObject);
begin
  PnlButtons.Hide;
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
        lblDescription.Caption := tmp.Description;
        lblDescription.Hint := tmp.Description;
        pnlTitle.Visible := (tmp.Description <> '');
      end;
    end;
  end;
end;

procedure TSharpCenterWnd.sbPluginResize(Sender: TObject);
begin
  if sbPlugin.VertScrollBar.IsScrollBarVisible then
    sbPlugin.Padding.Right := 6
  else
    sbPlugin.Padding.Right := 0;
end;

procedure TSharpCenterWnd.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  actrl : TWinControl;
begin
  Handled := False;
  if (Msg.Message = WM_KEYDOWN) then
  begin
    if IsWindow(SCM.EditWndHandle) then
    begin
      actrl := TForm(GetControlByHandle(SCM.EditWndHandle)).ActiveControl;
      if actrl <> nil then
      begin
        Handled := True;
        if Msg.wParam = VK_TAB then
          SendMessage(SCM.EditWndHandle,Msg.message,Msg.wParam,Msg.lParam)
        else if (Msg.wParam = VK_LEFT) or (Msg.wParam = VK_RIGHT)
              or (Msg.wParam = VK_UP) or (Msg.wParam = VK_DOWN) then
          SendMessage(actrl.Handle,Msg.message,Msg.wParam,Msg.lParam)
        else Handled := False;
      end;
    end else if IsWindow(SCM.PluginWndHandle) then
    begin
      actrl := TForm(GetControlByHandle(SCM.PluginWndHandle)).ActiveControl;
      if actrl <> nil then
      begin
        Handled := True;
        if Msg.wParam = VK_TAB then
          SendMessage(SCM.PluginWndHandle,Msg.message,Msg.wParam,Msg.lParam)
        else if (Msg.wParam = VK_LEFT) or (Msg.wParam = VK_RIGHT)
              or (Msg.wParam = VK_UP) or (Msg.wParam = VK_DOWN) then
          SendMessage(actrl.Handle,Msg.message,Msg.wParam,Msg.lParam)
        else Handled := False;
      end;    
    end;
  end;
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
      pnlEditPluginContainer.Visible := False;
    end
    else
    begin
      pnlEditPluginContainer.Visible := True;
      tlEditItemTabClick(pnlEditContainer.TabList, pnlEditContainer.TabList.TabIndex);
    end;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.tlPluginTabsTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
begin
  LockWindowUpdate(Self.Handle);
  try



  finally
    LockWindowUpdate(0);
  end;
end;

procedure TSharpCenterWnd.WMSettingsUpdate(var Msg: TMessage);
var
  Theme : ISharpETheme;
begin
  exit; // Disabled because it would cause Problems with theme configs
  // Now the theme configs use a local instance of TSharpETheme, so it's
  // no longer necessary for SharpCenter to update the theme

  if [TSU_UPDATE_ENUM(msg.WParam)] <= [suSkinFont,suSkinFileChanged,suTheme,
                                       suIconSet,suScheme] then
  begin
    Theme := GetCurrentTheme;
    case msg.WParam of
      Integer(suSkinFont): Theme.LoadTheme([tpSkinFont]);
      Integer(suSkinFileChanged): Theme.LoadTheme([tpSkinScheme]);
      Integer(suTheme): Theme.LoadTheme(ALL_THEME_PARTS);
      Integer(suScheme): Theme.LoadTheme([tpSkinScheme]);
      Integer(suIconSet): Theme.LoadTheme([tpIconSet]);
    end;    
  end;
end;

procedure TSharpCenterWnd.WMTerminateMessage(var Msg: TMessage);
begin
  Close;
end;

procedure TSharpCenterWnd.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
end;


procedure TSharpCenterWnd.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  for i := lbTree.Count - 1 downto 0 do
    TObject(lbTree[i].data).Free;

  SCM.Unload;
  FreeAndNil(SCM);
end;

procedure TSharpCenterWnd.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  msg: Cardinal;
  code: Cardinal;
  i, n: Integer;
  CPos : TPoint;
begin
  if not GetCursorPosSecure(CPos) then
    exit;  

  if WindowFromPoint(CPos) = sbPlugin.Handle then
  begin
    Handled := true;
    if ssShift in Shift then
      msg := WM_HSCROLL
    else
      msg := WM_VSCROLL;

    if WheelDelta > 0 then
      code := SB_LINEUP
    else
      code := SB_LINEDOWN;

    n := Mouse.WheelScrollLines;
    for i := 1 to n do
      sbPlugin.Perform(msg, code, 0);
    sbPlugin.Perform(msg, SB_ENDSCROLL, 0);
  end;
end;

end.

