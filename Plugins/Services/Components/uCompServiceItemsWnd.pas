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
  JvExControls,
  JvComponent,
  JvGradientHeaderPanel,
  JvExStdCtrls,
  JvHtControls,
  JvExExtCtrls,
  JvPanel,
  JvListBox,
  GR32,
  GR32_Layers,
  GR32_Png,
  SharpFX,
  jclgraphics,
  GR32_Image,
  PngSpeedButton,
  PngImageList,
  uCompServiceAppStore;

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
    ghpTop: TJvGradientHeaderPanel;
    sbAdd: TPngSpeedButton;
    sbDelete: TPngSpeedButton;
    sbEdit: TPngSpeedButton;
    PngSpeedButton4: TPngSpeedButton;
    PngSpeedButton5: TPngSpeedButton;
    picMain: TPngImageCollection;
    pnlWeatherList: TPanel;
    lbItems: TListBox;
    miRename: TMenuItem;
    dlgFile: TOpenDialog;
    miEditCommand: TMenuItem;
    procedure miEditCommandClick(Sender: TObject);
    procedure miRenameClick(Sender: TObject);

    procedure sbUpClick(Sender: TObject);
    procedure sbDownClick(Sender: TObject);
    procedure AddExistingClick(Sender: TObject);
    procedure sbAddClick(Sender: TObject);
    procedure lbItemsChange(Sender: TObject);

    procedure lbItemsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure sbDeleteClick(Sender: TObject);
    procedure AddNewItem(Sender: TObject);
    procedure sbEditClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuItemPopup(Sender: TObject);

    procedure miAutoStartClick(Sender: TObject);
    procedure UpdateDisplay(AData: TCompStore);

  private

  public
  end;

var
  frmCompItems: TfrmCompItems;
  ClickedItem: Integer = 0;
implementation

uses Contnrs,
  JclFileUtils;

{$R *.dfm}

procedure TfrmCompItems.sbDeleteClick(Sender: TObject);
var
  tmpInfo: TInfo;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    tmpInfo := TInfo(lbitems.Items.Objects[lbitems.ItemIndex]);

    TempItemStorage.Delete(tmpInfo);
    lbitems.DeleteSelected;
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
    TempItemStorage.Add(ExtractFileName(sFilename), 'Untitled', sFileName,
      False, False, False, 0);
    UpdateDisplay(TempItemStorage);
  end;
end;

procedure TfrmCompItems.sbEditClick(Sender: TObject);
var
  sFilename: string;
  obj: TInfo;
begin
  if lbItems.ItemIndex <> -1 then
  begin
    obj := TInfo(lbItems.Items.Objects[lbItems.ItemIndex]);
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
    UpdateDisplay(TempItemStorage);
  end;
end;

procedure TfrmCompItems.FormCreate(Sender: TObject);
begin
  // Create the comp store
  lbitems.DoubleBuffered := True;
end;

procedure TfrmCompItems.mnuItemPopup(Sender: TObject);
var
  tmpInfo: TInfo;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    miAutoStart.Checked := False;
    tmpInfo := TInfo(lbitems.Items.Objects[lbitems.ItemIndex]);

    // autostart
    if tmpInfo.AutoStart = True then
      miAutoStart.Checked := True;
  end;
end;

procedure TfrmCompItems.miAutoStartClick(Sender: TObject);
var
  tmpInfo: TInfo;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    tmpInfo := TInfo(lbitems.Items.Objects[lbitems.ItemIndex]);
    tmpInfo.AutoStart := not (miAutoStart.Checked);
    lbitems.Invalidate;
  end;
end;

procedure TfrmCompItems.UpdateDisplay(AData: TCompStore);
var
  i: Integer;
  n: Integer;
begin
  n := lbItems.ItemIndex;
  lbItems.Clear;
  for i := 0 to Pred(AData.Count) do
  begin
    lbItems.AddItem(AData.Info[i].Name, AData.info[i]);
  end;
  if (n = -1) or (n > lbItems.Items.Count - 1) then
    n := 0;

  if lbItems.Count <> 0 then
    lbItems.ItemIndex := n;
end;

procedure TfrmCompItems.lbItemsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  sAutoStart, sName, sDescription, sNameDesc, s, sCommand: string;
  tsAutostart: Integer;
  R, RImg, ARect: Trect;
  lst: TlistBox;
  w, n: Integer;
  obj: TInfo;
  pici: TPngImageCollectionItem;
begin
  if Index = -1 then
    exit;
  lst := TlistBox(Control);
  obj := TInfo(lst.Items.Objects[Index]);
  if not (assigned(obj)) then
    exit;
  if lst.Style = lbStandard then
    exit;

  ARect := Rect;
  R := ARect;
  if R.Top > lst.Height then
    exit;
  sName := obj.Name;
  sCommand := obj.Command;
  sDescription := obj.Description;
  sNameDesc := Format('%s (%s)', [sName, sCommand]);

  if obj.AutoStart then
    sAutoStart := 'Auto Start'
  else
    sAutoStart := 'Manual';

  lst.Canvas.Font := lst.Font;
  if odSelected in state then
  begin
    lst.Canvas.Font.Color := clBlack;
    lst.Canvas.Brush.Color := Darker(clWindow, 10);
  end;

  if (odFocused in state) and (odSelected in state) then
  begin
    lst.Canvas.Font.Color := clBlack;
    lst.Canvas.Brush.Color := Darker(clWindow, 10);
  end;

  if not (odDefault in state) then
    lst.Canvas.FillRect(Arect)
  else
    lst.Canvas.FillRect(R);

  if not (obj.AutoStart) then
    lst.canvas.Font.Color := Darker(clWindow, 50);

  tsAutoStart := lst.Canvas.TextWidth(sAutoStart);

  w := R.Right;
  n := w - (tsAutostart + 40);
  s := PathCompactPath(lst.Canvas.Handle, sNameDesc, n, cpCenter);
  lst.Canvas.TextOut(R.Left + 16 + 8, R.Top + 4, s);
  lst.Canvas.TextOut(R.Right - tsAutostart - 4, R.Top + 4, sAutoStart);

  if not (odDefault in state) then
  begin

    // Draw Glyph
    if obj.AutoStart then
      pici := picMain.Items.Items[1]
    else
      pici := picMain.Items.Items[2];
    RImg := Types.Rect(R.Left + 3, r.Top + 3, r.Left + 3 + 16, r.top + 3 + 16);
    pici.PngImage.Draw(lst.Canvas, RImg);
  end;

end;

procedure TfrmCompItems.lbItemsChange(Sender: TObject);
begin
  ghpTop.LabelCaption := Format(' (%d) Configured Items',
    [lbitems.Items.Count]);
end;

procedure TfrmCompItems.sbAddClick(Sender: TObject);

begin
  mnuAdd.PopupComponent := sbAdd;
  mnuAdd.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
end;

procedure TfrmCompItems.AddExistingClick(Sender: TObject);
begin
  if TMenuItem(Sender) = miSharpBar then
    TempItemStorage.Add('SharpBar', 'Core Bar Component', GetSharpeDirectory +
      'SharpBar.exe', True, False, False, 0)
  else
    if TMenuItem(Sender) = miSharpDesk then
      TempItemStorage.Add('SharpDesk', 'Core Desktop Component',
        GetSharpeDirectory + 'SharpDesk.exe', True, False, False, 0)
    else
      if TMenuItem(Sender) = miSharpConsole then
        TempItemStorage.Add('SharpConsole', 'Core Debugging Component',
          GetSharpeDirectory + 'SharpConsole.exe', True, False, False, 0)
      else
        if TMenuItem(Sender) = miSharpTray then
          TempItemStorage.Add('SharpTray', 'Core Tray Component',
            GetSharpeDirectory + 'SharpTray.exe', True, False, False, 0)
        else
          if TMenuItem(Sender) = miSharpTask then
            TempItemStorage.Add('SharpTask', 'Core Task Component',
              GetSharpeDirectory + 'SharpTask.exe', True, False, False, 0)
          else
            if TMenuItem(Sender) = miSharpVWM then
              TempItemStorage.Add('SharpVwm', 'Core VWM Component',
                GetSharpeDirectory + 'SharpVWM.exe', True, False, False, 0)
            else
              if TMenuItem(Sender) = miSharpDocs then
                TempItemStorage.Add('SharpDocs', 'Core Help Component',
                  GetSharpeDirectory + 'SharpDocs.exe', True, False, False, 0);

  UpdateDisplay(TempItemStorage);
end;

procedure TfrmCompItems.sbDownClick(Sender: TObject);
var
  Index: Integer;
  ObjIndex: Integer;
  tmpObj: TInfo;
begin
  // move selected down
  Index := lbitems.ItemIndex;
  tmpObj := TInfo(lbItems.Items.Objects[index]);
  ObjIndex := TempItemStorage.Items.IndexOf(tmpObj);

  if ObjIndex <> -1 then
  begin

    if not (ObjIndex + 1 >= TempItemStorage.Count) then
    begin
      TempItemStorage.Items.Move(ObjIndex, ObjIndex + 1);
      lbItems.ItemIndex := ObjIndex + 1;
    end;
  end;
  UpdateDisplay(TempItemStorage);
end;

procedure TfrmCompItems.sbUpClick(Sender: TObject);
var
  Index: Integer;
  ObjIndex: Integer;
  tmpObj: TInfo;
begin
  // move selected down
  Index := lbitems.ItemIndex;
  tmpObj := TInfo(lbItems.Items.Objects[index]);
  ObjIndex := TempItemStorage.Items.IndexOf(tmpObj);

  if ObjIndex <> -1 then
  begin
    if not (ObjIndex - 1 < 0) then
    begin
      TempItemStorage.Items.Move(ObjIndex, ObjIndex - 1);
      lbItems.ItemIndex := ObjIndex - 1;
    end;
  end;
  UpdateDisplay(TempItemStorage);
end;

procedure TfrmCompItems.miRenameClick(Sender: TObject);
var
  tmpInfo: TInfo;
  s: string;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    tmpInfo := TInfo(lbitems.Items.Objects[lbitems.ItemIndex]);

    // Show input box
    s := tmpInfo.Name;
    if InputQuery('Rename Item', 'Please enter new name', s) then
      tmpInfo.Name := s;

    UpdateDisplay(TempItemStorage);
  end;
end;

procedure TfrmCompItems.miEditCommandClick(Sender: TObject);
var
  tmpInfo: TInfo;
  s: string;
begin
  if lbitems.ItemIndex <> -1 then
  begin
    tmpInfo := TInfo(lbitems.Items.Objects[lbitems.ItemIndex]);

    // Show input box
    s := tmpInfo.Command;
    if InputQuery('Change Command', 'Please enter new command', s) then
      tmpInfo.Command := s;

    UpdateDisplay(TempItemStorage);
  end;
end;

end.
