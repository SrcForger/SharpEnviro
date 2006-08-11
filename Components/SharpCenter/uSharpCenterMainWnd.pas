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
  Tabs,
  JvOutlookBar,
  SharpEListBox, SharpESkinManager;

type
  TSharpCenterWnd = class(TForm)
    pnlPluginPanel: TPanel;
    pnlPage: TPanel;
    pnlConfigurationTree: TPanel;
    graBackdrop: TJvGradient;
    imgBackdrop: TImage;
    pnlSectionToolbar: TPanel;
    graSectionToolbar: TJvGradient;
    btnHome: TPngSpeedButton;
    btnBack: TPngSpeedButton;
    splMain: TSplitter;
    pnlSections: TPanel;
    picMain: TPngImageCollection;
    pnlMain: TPanel;
    Panel1: TPanel;
    JvGradient1: TJvGradient;
    Label1: TLabel;
    Panel2: TPanel;
    lbSections: TSharpEListBox;
    procedure btnBackClick(Sender: TObject);
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnBackMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbSectionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnHomeClick(Sender: TObject);
    procedure lbSectionDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);

    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SchemeWindow;

    procedure WndProc(var Message: TMessage); override;
    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;

  public
    { Public declarations }
    procedure BuildSectionRoot;
    procedure GetCopyData(var Msg: TMessage); message wm_CopyData;
    procedure ExecuteCommand(ACommand, AParameter: string; APluginID: Integer);
  end;

var
  SharpCenterWnd: TSharpCenterWnd;

implementation

uses
  uSharpCenterManager,
  uSharpCenterDllMethods,
  SharpEScheme,
  uSEListboxPainter,
  uSharpCenterDllConfigWnd;

{$R *.dfm}

procedure TSharpCenterWnd.FormShow(Sender: TObject);
begin
  pnlSectionToolbar.DoubleBuffered := True;
  pnlPage.DoubleBuffered := True;
  pnlConfigurationTree.DoubleBuffered := True;
  SharpCenterManager := TSharpCenterManager.Create;

  SchemeWindow;
  BuildSectionRoot;
end;

procedure TSharpCenterWnd.SchemeWindow;
begin
  pnlConfigurationTree.Color := clWindow;
  graBackdrop.StartColor := clWindow;
  graBackdrop.EndColor := clBtnFace;
end;

procedure TSharpCenterWnd.lbSectionDrawItem(Control: TWinControl; Index:
  Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  tmpItem: TBTData;
begin
  if lbSections.Items.Count = 0 then
    exit;

  tmpItem := TBTData(lbSections.Items.Objects[Index]);

  if assigned(tmpItem) then begin
    PaintListbox(lbSections, Rect, 0 {5}, State, tmpItem.Caption, picMain,
      tmpItem.IconIndex, tmpItem.Status,
      clBlack);
  end
  else
    PaintListbox(lbSections, Rect, 0 {5}, State, 'No Items', '', clLtGray);
end;

procedure TSharpCenterWnd.BuildSectionRoot;
begin
  btnBack.Enabled := False;

  SharpCenterManager.ClearHistory;
  SharpCenterManager.History.AddFolder(GetCenterDirectory);
  SharpCenterManager.BuildSectionItemsFromPath(GetCenterDirectory,
    lbSections);
end;

procedure TSharpCenterWnd.btnHomeClick(Sender: TObject);
begin
  BuildSectionRoot;
end;

procedure TSharpCenterWnd.lbSectionMouseUp(Sender: TObject; Button:
  TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if lbSections.ItemIndex = -1 then
    exit;

  {if btnSave.Enabled then
  begin
    if MessageDlg('Would you like to save your current changes?',
      mtConfirmation,
      [mbOK, mbCancel], 0) = mrOk then

      SharpCenterManager.DllProc.Close(Self.handle, True);
    SharpCenterManager.ClickButton(nil);
  end
  else }
  SharpCenterManager.ClickButton(nil);

  if assigned(frmDllConfig) then
    frmDllConfig.UpdateSize;
end;

procedure TSharpCenterWnd.btnBackMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Path: string;
begin
  {SharpCenterManager.UnloadDll;

  Path := SharpCenterManager.GetNextHistory;
  if Path <> '' then
  begin
    if CompareStr(Path, GetSharpeDirectory + 'Center\') = 0 then
    begin
      SharpCenterManager.BuildSectionItemsFromPath(Path, True, SharpCenterWnd.lbSections);
      btnBack.Enabled := False;
    end
    else
      SharpCenterManager.BuildSectionItemsFromPath(Path, False, lbSections);

    SharpCenterManager.CurrentPath := Path;
  end;   }

end;

procedure TSharpCenterWnd.FormResize(Sender: TObject);
begin
  if frmDllConfig = nil then
    exit;

  frmDllConfig.UpdateSize;
end;

procedure TSharpCenterWnd.FormCreate(Sender: TObject);
begin
  //ouseTimer := TMouseTimer.Create;
  //ouseTimer.AddWinControl(SharpCenterWnd.pnlPluginPanel);
end;

procedure TSharpCenterWnd.FormDestroy(Sender: TObject);
begin
  //fMousetimer.Free;

  if frmDllConfig <> nil then
    FreeAndNil(frmDllConfig);

  if SharpCenterManager <> nil then
    SharpCenterManager.Free;
end;

procedure TSharpCenterWnd.WndProc(var Message: TMessage);
begin
  if frmDllConfig <> nil then begin

    if Message.Msg = WM_SCGLOBALBTNMSG then
      PostMessage(frmDllConfig.Handle, message.msg, message.WParam,
        message.LParam);
    if Message.msg = WM_SETTINGSCHANGED then
      PostMessage(frmDllConfig.Handle, message.msg, message.WParam,
        message.LParam);
  end;

  inherited;
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
  tmpItem := SharpCenterManager.History.GetLastEntry;
  ExecuteCommand(tmpItem.Command, tmpItem.Parameter, tmpItem.PluginID);
end;

procedure TSharpCenterWnd.ExecuteCommand(ACommand, AParameter: string;
  APluginID: Integer);
begin
  // navigate to folder
  if CompareStr(ACommand, '_navfolder') = 0 then begin
    if Assigned(frmDllConfig) then
      frmDllConfig.unloaddll;

    SharpCenterManager.BuildSectionItemsFromPath(AParameter, Self.lbSections);
  end;

  // Unload current dll
  if CompareStr(ACommand, '_unloaddll') = 0 then begin
    if Assigned(frmDllConfig) then
      frmDllConfig.unloaddll;
  end;

  // Load config
  if CompareStr(ACommand, '_loadConfig') = 0 then begin
    if Assigned(frmDllConfig) then
      frmDllConfig.unloaddll;

    if fileexists(AParameter) then begin

      if not (assigned(frmDllConfig)) then
        frmDllConfig := TfrmDllConfig.Create(SharpCenterWnd.pnlMain,
          AParameter,
          ExtractFileName(AParameter))
      else
        frmDllConfig.InitialiseWindow(SharpCenterWnd.pnlMain,
          ExtractFileName(AParameter));
    end;
    frmDllConfig.PluginID := APluginID;
    frmDllConfig.LoadConfiguration(AParameter);

  end;
end;

end.

