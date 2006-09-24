{
Source Name: uCompServiceSettingsWnd
Description: Configuration window for Components service
Copyright (C)
              Zack Cerza - zcerza@coe.neu.edu (original dev)
              Pixol (Pixol@sharpe-shell.org)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

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

unit uCompServiceItemsWnd;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  sharpapi,
  ExtCtrls,
  Buttons,
  ImgList,
  ComCtrls,
  ToolWin,
  ShellApi,
  Menus,
  tlhelp32,
  Types,
  PngImageList,
  Tabs,
  SharpFX,
  SharpESkinManager,
  uCompServiceList, SharpEListBox;

type
  TfrmCompItems = class(TForm)
    mnuItem: TPopupMenu;
    miAutoStart: TMenuItem;
    imlMain: TImageList;
    mnuAdd: TPopupMenu;
    AddNew1: TMenuItem;
    AddExisting1: TMenuItem;
    miSharpBar: TMenuItem;
    miSharpConsole: TMenuItem;
    miSharpTray: TMenuItem;
    miSharpTask: TMenuItem;
    miSharpVWM: TMenuItem;
    N2: TMenuItem;
    miSharpDesk: TMenuItem;
    miSharpDocs: TMenuItem;
    picMain: TPngImageCollection;
    pnlWeatherList: TPanel;
    miRename: TMenuItem;
    dlgFile: TOpenDialog;
    miEditCommand: TMenuItem;
    dlgImport: TOpenDialog;
    dlgExport: TSaveDialog;
    Panel1: TPanel;
    lbItems: TSharpEListBox;
    procedure lbItems_Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miEditCommandClick(Sender: TObject);
    procedure miRenameClick(Sender: TObject);

    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);

    procedure AddExistingClick(Sender: TObject);

    procedure lbItems_DrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure btnDeleteClick(Sender: TObject);
    procedure AddNewItem(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuItemPopup(Sender: TObject);

    procedure miAutoStartClick(Sender: TObject);
    procedure UpdateDisplay(AData: TComponentsList);

    procedure UpdateButtonStates;
  private

  public
  end;

var
  frmCompItems: TfrmCompItems;
  ClickedItem: Integer = 0;
implementation

uses Contnrs,
  JclFileUtils,
  uSEListboxPainter;

{$R *.dfm}

procedure TfrmCompItems.btnDeleteClick(Sender: TObject);
var
  tmpInfo: TComponentItem;
  n: Integer;
begin
  n := lbitems.ItemIndex;
  if n <> -1 then
  begin
    tmpInfo := TComponentItem(lbitems.Items.Objects[lbitems.ItemIndex]);

    ItemStorage.Delete(tmpInfo);
    lbitems.DeleteSelected;

    // Select next
    if n < lbItems.Count then
      lbItems.ItemIndex := n
    else
      lbItems.ItemIndex := lbItems.Count - 1;

    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
    UpdateButtonStates;
  end;
end;

procedure TfrmCompItems.AddNewItem(Sender: TObject);
var
  sFilename: string;
begin
  sFilename := '';
  dlgFile.InitialDir := GetSharpeDirectory;
  if dlgFile.Execute then
    sFilename := dlgFile.FileName;

  if sFileName <> '' then
  begin
    ItemStorage.Add(ExtractFileName(sFilename), 'Untitled', sFileName,
      False, False, False, 0);
    UpdateDisplay(ItemStorage);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
    UpdateButtonStates;
  end;
end;

procedure TfrmCompItems.btnEditClick(Sender: TObject);
var
  sFilename: string;
  obj: TComponentItem;
begin
  if lbItems.ItemIndex <> -1 then
  begin
    obj := TComponentItem(lbItems.Items.Objects[lbItems.ItemIndex]);
    if assigned(obj) then
    begin
      dlgFile.InitialDir := ExtractFilePath(obj.Command);
      dlgFile.FileName := ExtractFileName(obj.Command);

      if dlgFile.Execute then
      begin
        sFilename := dlgFile.FileName;
        obj.Command := sFilename;
        obj.Name := ExtractFileName(sFilename);
      end;
    end;
    UpdateDisplay(ItemStorage);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
    UpdateButtonStates;
  end;
end;

procedure TfrmCompItems.FormCreate(Sender: TObject);
begin
  // Create the comp store
  lbitems.DoubleBuffered := True;

end;

procedure TfrmCompItems.mnuItemPopup(Sender: TObject);
var
  tmpInfo: TComponentItem;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    miAutoStart.Checked := False;
    tmpInfo := TComponentItem(lbitems.Items.Objects[lbitems.ItemIndex]);

    // autostart
    if tmpInfo.AutoStart = True then
      miAutoStart.Checked := True;
  end;
end;

procedure TfrmCompItems.miAutoStartClick(Sender: TObject);
var
  tmpInfo: TComponentItem;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    tmpInfo := TComponentItem(lbitems.Items.Objects[lbitems.ItemIndex]);
    tmpInfo.AutoStart := not (miAutoStart.Checked);
    lbitems.Invalidate;
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  end;
end;

procedure TfrmCompItems.UpdateDisplay(AData: TComponentsList);
var
  i: Integer;
  idx: Integer;
begin
  idx := 0;
  if lbItems.ItemIndex <> -1 then
    idx := lbItems.ItemIndex;

  lbItems.Clear;

  for i := 0 to Pred(AData.Count) do
  begin
    lbItems.AddItem(AData.Info[i].Name, AData.info[i]);
  end;

  try
    lbItems.ItemIndex := idx;
  except
  end;
end;

procedure TfrmCompItems.lbItems_DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  iIconIndex: Integer;
  sText, sStatus: string;
  FontColor: TColor;
  obj: TComponentItem;
begin
  // If nothing selected, exit
  if Index = -1 then
    exit;

  // Get Object, and if not assigned then exit
  obj := TComponentItem(TListBox(Control).Items.Objects[Index]);
  if not (assigned(obj)) then
    exit;

  // Also do not continue if list style is standard
  if TListBox(Control).Style = lbStandard then
    exit;

  // Object specific extractions
  sText := Format('%s (%s)', [obj.Name, obj.Command]);

  if obj.AutoStart then
  begin
    iIconIndex := 1;
    sStatus := 'Auto-start';
    FontColor := clWindowText;
  end
  else
  begin
    iIconIndex := 0;
    sStatus := 'Manual';
    FontColor := Darker(clWindow, 50);
  end;

  // Draw Method
  PaintListbox(TListBox(Control), Rect, 0, State, sText, picMain, iIconIndex,
    sStatus, FontColor);
end;

procedure TfrmCompItems.AddExistingClick(Sender: TObject);
begin
  if TMenuItem(Sender) = miSharpBar then
    ItemStorage.Add('SharpBar', 'Core Bar Component', GetSharpeDirectory +
      'SharpBar.exe', True, False, False, 0)
  else if TMenuItem(Sender) = miSharpDesk then
    ItemStorage.Add('SharpDesk', 'Core Desktop Component',
      GetSharpeDirectory + 'SharpDesk.exe', True, False, False, 0)
  else if TMenuItem(Sender) = miSharpConsole then
    ItemStorage.Add('SharpConsole', 'Core Debugging Component',
      GetSharpeDirectory + 'SharpConsole.exe', True, False, False, 0)
  else if TMenuItem(Sender) = miSharpTray then
    ItemStorage.Add('SharpTray', 'Core Tray Component',
      GetSharpeDirectory + 'SharpTray.exe', True, False, False, 0)
  else if TMenuItem(Sender) = miSharpTask then
    ItemStorage.Add('SharpTask', 'Core Task Component',
      GetSharpeDirectory + 'SharpTask.exe', True, False, False, 0)
  else if TMenuItem(Sender) = miSharpVWM then
    ItemStorage.Add('SharpVwm', 'Core VWM Component',
      GetSharpeDirectory + 'SharpVWM.exe', True, False, False, 0)
  else if TMenuItem(Sender) = miSharpDocs then
    ItemStorage.Add('SharpDocs', 'Core Help Component',
      GetSharpeDirectory + 'SharpDocs.exe', True, False, False, 0);

  UpdateDisplay(ItemStorage);
  SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  UpdateButtonStates;
end;

procedure TfrmCompItems.btnDownClick(Sender: TObject);
var
  Index: Integer;
  ObjIndex: Integer;
  tmpObj: TComponentItem;
begin
  // move selected down
  Index := lbitems.ItemIndex;
  tmpObj := TComponentItem(lbItems.Items.Objects[index]);
  ObjIndex := ItemStorage.Items.IndexOf(tmpObj);

  if ObjIndex <> -1 then
  begin

    if not (ObjIndex + 1 >= ItemStorage.Count) then
    begin
      ItemStorage.Items.Move(ObjIndex, ObjIndex + 1);
      lbItems.ItemIndex := ObjIndex + 1;
    end;
  end;
  UpdateDisplay(ItemStorage);
  SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  UpdateButtonStates;
end;

procedure TfrmCompItems.btnUpClick(Sender: TObject);
var
  Index: Integer;
  ObjIndex: Integer;
  tmpObj: TComponentItem;
begin
  // move selected down
  Index := lbitems.ItemIndex;
  tmpObj := TComponentItem(lbItems.Items.Objects[index]);
  ObjIndex := ItemStorage.Items.IndexOf(tmpObj);

  if ObjIndex <> -1 then
  begin
    if not (ObjIndex - 1 < 0) then
    begin
      ItemStorage.Items.Move(ObjIndex, ObjIndex - 1);
      lbItems.ItemIndex := ObjIndex - 1;
    end;
  end;
  UpdateDisplay(ItemStorage);
  SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  UpdateButtonStates;
end;

procedure TfrmCompItems.miRenameClick(Sender: TObject);
var
  tmpInfo: TComponentItem;
  s: string;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    tmpInfo := TComponentItem(lbitems.Items.Objects[lbitems.ItemIndex]);

    // Show input box
    s := tmpInfo.Name;
    if InputQuery('Rename Item', 'Please enter new name', s) then
      tmpInfo.Name := s;

    UpdateDisplay(ItemStorage);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
    UpdateButtonStates;
  end;
end;

procedure TfrmCompItems.miEditCommandClick(Sender: TObject);
var
  tmpInfo: TComponentItem;
  s: string;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    tmpInfo := TComponentItem(lbitems.Items.Objects[lbitems.ItemIndex]);

    // Show input box
    s := tmpInfo.Command;
    if InputQuery('Change Command', 'Please enter new command', s) then
      tmpInfo.Command := s;

    UpdateDisplay(ItemStorage);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
    UpdateButtonStates;
  end;
end;

procedure TfrmCompItems.FormResize(Sender: TObject);
begin
  UpdateDisplay(ItemStorage);
end;

procedure TfrmCompItems.UpdateButtonStates;
begin
  // Update Move Up/Down State
  if lbItems.ItemIndex = -1 then
  begin
    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEUP, 0);
    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEDOWN, 0);
  end
  else if lbItems.ItemIndex = 0 then
  begin

    if lbItems.Count <> 0 then
      SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEDOWN, 1)
    else
      SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEDOWN, 0);

    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEUP, 0);
  end
  else if lbItems.ItemIndex = lbItems.Count - 1 then
  begin

    if lbItems.Count <> 0 then
      SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEUP, 1)
    else
      SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEUP, 0);

    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEDOWN, 0);
  end
  else
  begin
    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEUP, 1);
    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_MOVEDOWN, 1);
  end;

  // Update Edit State
  if lbItems.Count = 0 then
    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_EDIT, 0)
  else
  begin
    if lbItems.ItemIndex <> -1 then
      SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_EDIT, 1)
    else
      SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_EDIT, 0);
  end;

  // Update Delete State
  if lbItems.Count = 0 then
    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_DEL, 0)
  else
  begin
    if lbItems.ItemIndex <> -1 then
      SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_DEL, 1)
    else
      SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_DEL, 0);
  end;

  // Update Export State
  if (lbItems.Count = 0) then
    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_EXPORT, 0)
  else
    SharpEBroadCast(WM_SCGLOBALBTNMSG, SCB_EXPORT, 1);

end;

procedure TfrmCompItems.lbItems_Click(Sender: TObject);
begin
  UpdateButtonStates;
end;

procedure TfrmCompItems.btnExportClick(Sender: TObject);
begin
  dlgExport.FileName := 'Components_backup.xml';
  if dlgExport.Execute then
  begin
    ItemStorage.Save(dlgExport.FileName);

  end;
end;

procedure TfrmCompItems.btnImportClick(Sender: TObject);
begin
  if dlgImport.Execute then
  begin
    ItemStorage.Load(dlgImport.FileName);
    UpdateDisplay(ItemStorage);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  end;
end;

procedure TfrmCompItems.BtnClearClick(Sender: TObject);
begin
  if (MessageDlg('Are you sure you want to clear the Components list?',
    mtConfirmation, [mbOK, mbCancel], 0) = mrOk) then
  begin
    ItemStorage.Clear;
    frmCompItems.UpdateDisplay(ItemStorage);
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  end;
end;

end.


