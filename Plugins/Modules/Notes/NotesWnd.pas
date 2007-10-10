{
Source Name: NotesWnd.pas
Description: Notes Module - Notes Edit Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit NotesWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, ImgList, PngImageList, JvTabBar, StdCtrls,
  JvComponentBase, JvFindReplace, JvExStdCtrls, JvMemo, JvExControls,
  JvComponent, Menus;

type
  TNotesForm = class(TForm)
    PngImageList1: TPngImageList;
    ToolBar1: TToolBar;
    tb_new: TToolButton;
    tabs: TJvTabBar;
    JvModernTabBarPainter1: TJvModernTabBarPainter;
    tb_paste: TToolButton;
    btn_selectall: TToolButton;
    tb_copy: TToolButton;
    ToolButton7: TToolButton;
    tb_close: TToolButton;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    tb_import: TToolButton;
    tb_export: TToolButton;
    ImportDialog: TOpenDialog;
    ExportDialog: TSaveDialog;
    ToolButton1: TToolButton;
    btn_find: TToolButton;
    FindDialog: TJvFindReplace;
    btn_linewrap: TToolButton;
    btn_monofont: TToolButton;
    ToolButton2: TToolButton;
    Notes: TJvMemo;
    TabPopup: TPopupMenu;
    tb_rename: TToolButton;
    procedure NotesKeyPress(Sender: TObject; var Key: Char);
    procedure NotesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btn_monofontClick(Sender: TObject);
    procedure btn_linewrapClick(Sender: TObject);
    procedure btn_findClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure tb_importClick(Sender: TObject);
    procedure tb_exportClick(Sender: TObject);
    procedure btn_selectallClick(Sender: TObject);
    procedure tb_pasteClick(Sender: TObject);
    procedure tb_copyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tabsTabSelected(Sender: TObject; Item: TJvTabBarItem);
    procedure tb_newClick(Sender: TObject);
    procedure tabsTabSelecting(Sender: TObject; Item: TJvTabBarItem;
      var AllowSelect: Boolean);
    procedure tabsTabClosing(Sender: TObject; Item: TJvTabBarItem;
      var AllowClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tb_closeClick(Sender: TObject);
    procedure tb_renameClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    function GetNotesDir : String;
    procedure UpdateTabList(FocusTab : String);
    procedure SaveCurrentTab;
    procedure LoadCurrentTab;
  end;

const
  NOTES_EXTENSION = '.txt';


implementation

uses SharpApi,
     NotesNewTabWnd,
     MainWnd;

{$R *.dfm}

function TNotesForm.GetNotesDir : String;
begin
  result := SharpApi.GetSharpeUserSettingsPath + 'Notes\';
end;

procedure TNotesForm.UpdateTabList(FocusTab : String);
var
  Dir        : String;
  sr         : TSearchRec;
  CurrentTab : String;
  fname      : String;
begin
  Dir := GetNotesDir;
  ForceDirectories(Dir);
  if ((Tabs.SelectedTab <> nil) and (length(Focustab)=0)) then CurrentTab := Tabs.SelectedTab.Caption
     else CurrentTab := FocusTab;
  Tabs.Tabs.Clear;
  if FindFirst(Dir + '*'+NOTES_EXTENSION,FAAnyFile,sr) = 0 then
  repeat
    fname := ExtractFileName(sr.Name);
    setlength(fname, length(fname)-4);
    if fname = CurrentTab then Tabs.AddTab(fname).Selected := True
       else Tabs.AddTab(fname);
  until FindNext(sr) <> 0;
  FindClose(sr);

  // Hide the edit memo and tab bar if no tabs are loaded
  Notes.Visible := (Tabs.Tabs.Count <> 0);
  tb_rename.Enabled := Notes.Visible;
  Tabs.Visible := Notes.Visible;
end;

procedure TNotesForm.SaveCurrentTab;
var
  Dir : String;
  fname : String;
begin
  if Tabs.SelectedTab = nil then exit; // something is seriously wrong ;)

  Dir := GetNotesDir;
  ForceDirectories(Dir);
  fname := Tabs.SelectedTab.Caption;
  Notes.Lines.SaveToFile(Dir + fname + NOTES_EXTENSION);
end;

procedure TNotesForm.LoadCurrentTab;
var
  Dir : String;
  fname : String;
begin
  if Tabs.SelectedTab = nil then exit; // something is seriously wrong ;)

  Dir := GetNotesDir;
  ForceDirectories(Dir);
  fname := Tabs.SelectedTab.Caption;
  Notes.Lines.LoadFromFile(Dir + fname + NOTES_EXTENSION);
  if Notes.Lines.Count > 0 then
  begin
    Notes.CaretPos := Point(length(Notes.Lines[Notes.Lines.Count - 1]),Notes.Lines.Count-1);
    SendMessage (Notes.Handle, EM_SCROLLCARET, 0, 0);
  end;
end;

procedure TNotesForm.tb_closeClick(Sender: TObject);
begin
  Close;
end;

procedure TNotesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveCurrentTab;
  TMainForm(Owner).sLineWrap := btn_LineWrap.Down;
  TMainForm(Owner).sMonoFont := btn_monofont.Down;
  if Tabs.SelectedTab <> nil then TMainForm(Owner).sLastTab := Tabs.SelectedTab.Caption
     else TMainForm(Owner).sLastTab := '';
  TMainForm(Owner).sLastTextPos.Y := Notes.CurrentLine;
  TMainForm(Owner).SaveSettings;
end;

procedure TNotesForm.tabsTabClosing(Sender: TObject; Item: TJvTabBarItem;
  var AllowClose: Boolean);
var
  Dir : String;
  fname : String;
  b : boolean;
begin
  b := False;
  if (Notes.Lines.Count = 0) or
     ((Notes.Lines.Count = 1) and (length(Trim(Notes.Lines[0]))=0)) then
     b := True;

  if not b then
     if MessageBox(self.Handle,
                   PChar('The tab you are about to close is not empty!' + #10#13 +
                         'All information will be lost. Close it anyway?'),
                   'Closing Tab...', MB_YESNO) = IDYES then b := True;

  if b then
  begin
    Dir := GetNotesDir;
    fname := Tabs.SelectedTab.Caption;
    if FileExists(Dir + fname + NOTES_EXTENSION) then
       DeleteFile(Dir + fname + NOTES_EXTENSION);
    AllowClose := False;
    Tabs.SelectedTab.Caption := '""';
    UpdateTabList('');
  end else AllowClose := FalsE;
end;

procedure TNotesForm.tabsTabSelecting(Sender: TObject; Item: TJvTabBarItem;
  var AllowSelect: Boolean);
begin
  if Item <> nil then
     if Tabs.SelectedTab <> nil then
        if Tabs.SelectedTab.Caption <> '""' then SaveCurrentTab;
  AllowSelect := True;
end;

procedure TNotesForm.tb_newClick(Sender: TObject);
var
  NotesNewTabForm : TNotesNewtabForm;
  Dir : String;
  fhandle : integer;
begin
  NotesNewTabForm := TNotesNewTabForm.Create(self);
  NotesNewTabForm.PopupParent := self;
  NotesNewTabForm.Caption := 'Enter the name for the new Notes tab';
  try
    if NotesNewTabForm.ShowModal = mrOk then
    begin
      Dir := GetNotesDir;
      ForceDirectories(Dir);
      fhandle := FileCreate(Dir + NotesNewTabForm.edit_name.Text + NOTES_EXTENSION);
      FileClose(fhandle);
      SaveCurrentTab;
      UpdateTabList(NotesNewTabForm.edit_name.Text);
    end;
  finally
    NotesNewTabForm.Free;
  end;
end;

procedure TNotesForm.tabsTabSelected(Sender: TObject; Item: TJvTabBarItem);
begin
  LoadCurrentTab;
end;

procedure TNotesForm.FormShow(Sender: TObject);
begin
  UpdateTabList(TMainForm(Owner).sLastTab);
  //Notes.CurrentLine := TMainForm(Owner).sLastTextPos.Y;
 // SetWindowPos(handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
end;

procedure TNotesForm.tb_copyClick(Sender: TObject);
begin
  Notes.CopyToClipboard;
end;

procedure TNotesForm.tb_pasteClick(Sender: TObject);
begin
  Notes.PasteFromClipboard;
end;

procedure TNotesForm.tb_renameClick(Sender: TObject);
var
  NotesNewTabForm : TNotesNewtabForm;
  Dir : String;
begin
  NotesNewTabForm := TNotesNewTabForm.Create(self);
  NotesNewTabForm.PopupParent := self;
  NotesNewTabForm.Caption := 'Enter the new name for the selected Notes tab';
  try
    if NotesNewTabForm.ShowModal = mrOk then
    begin
      Dir := GetNotesDir;
      ForceDirectories(Dir);
      RenameFile(Dir + Tabs.SelectedTab.Caption + NOTES_EXTENSION,Dir + NotesNEwTabForm.edit_name.Text + NOTES_EXTENSION);
      DeleteFile(Dir + Tabs.SelectedTab.Caption + NOTES_EXTENSION);
      Tabs.SelectedTab.Caption := NotesNewTabForm.edit_name.Text;
      UpdateTabList(NotesNewTabForm.edit_name.Text);
    end;
  finally
    NotesNewTabForm.Free;
  end;
end;

procedure TNotesForm.btn_selectallClick(Sender: TObject);
begin
  Notes.SelectAll;
end;

procedure TNotesForm.ToolButton1Click(Sender: TObject);
begin
  Notes.CutToClipboard;
end;

procedure TNotesForm.tb_exportClick(Sender: TObject);
var
  Ext : String;
begin
  if ExportDialog.Execute then
  begin
    case ExportDialog.FilterIndex of
      1 : Ext := '.txt';
      else Ext := '';
    end;
    Notes.Lines.SaveToFile(ExportDialog.FileName + Ext);
  end;
end;

procedure TNotesForm.tb_importClick(Sender: TObject);
var
  SList : TStringList;
begin
  if ImportDialog.Execute then
  begin
    SList := TStringList.Create;
    try
      SList.LoadFromFile(ImportDialog.FileName);
      Notes.Lines.AddStrings(SList);
    finally
      SList.Free;
    end;
  end;
end;

procedure TNotesForm.btn_findClick(Sender: TObject);
begin
  FindDialog.Find;
end;

procedure TNotesForm.btn_linewrapClick(Sender: TObject);
begin
  Notes.WordWrap := btn_linewrap.Down;
  if not Notes.WordWrap then Notes.ScrollBars := ssBoth
     else Notes.ScrollBars := ssVertical;
end;

procedure TNotesForm.btn_monofontClick(Sender: TObject);
begin
  if btn_monofont.Down then Notes.Font.Name := 'Courier New'
     else Notes.Font.Name := 'Tahoma';
end;

procedure TNotesForm.NotesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = ord('F')) and (Shift = [ssCtrl]) then
      btn_find.OnClick(btn_find)
  else
  if (Key = ord('A')) and (Shift = [ssCtrl]) then
      btn_selectall.OnClick(btn_selectall);
end;

procedure TNotesForm.NotesKeyPress(Sender: TObject; var Key: Char);
var
  KS: TKeyboardState;
  Shift : TShiftState;
begin
  if (Key = 'F') or (Key = 'A')
     or (ord(Key) = 1) or (ord(Key) = 6) then
  begin
    GetKeyboardState(KS);
    Shift := KeyboardStateToShiftState(KS);
    if (Shift = [ssCtrl]) then
       Key := #0;
  end;
end;

end.
