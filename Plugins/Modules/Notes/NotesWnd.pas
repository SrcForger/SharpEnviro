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
  Dialogs, ToolWin, ComCtrls, ImgList,
  SharpThemeApi, Menus, JvComponentBase, JvFindReplace, PngImageList, StdCtrls,
  JvExStdCtrls, JvMemo, ExtCtrls, SharpEPageControl, SharpETabList, JclStrings,
  uVistaFuncs;

type
  TNotesForm = class(TForm)
    PngImageList1: TPngImageList;
    ImportDialog: TOpenDialog;
    ExportDialog: TSaveDialog;
    FindDialog: TJvFindReplace;
    pcNotes: TSharpEPageControl;
    Notes: TJvMemo;
    tbNotes: TToolBar;
    tb_import: TToolButton;
    tb_export: TToolButton;
    ToolButton7: TToolButton;
    tb_copy: TToolButton;
    tb_paste: TToolButton;
    ToolButton1: TToolButton;
    btn_selectall: TToolButton;
    btn_find: TToolButton;
    ToolButton2: TToolButton;
    btn_linewrap: TToolButton;
    btn_monofont: TToolButton;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tb_closeClick(Sender: TObject);
    procedure pcNotesBtnClick(ASender: TObject;
      const ABtnIndex: Integer);
    procedure pcNotesTabClick(ASender: TObject; const ATabIndex: Integer);
    procedure NotesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAlwaysOnTop: boolean;
    function CustomInputQuery(const ACaption, APrompt: string;
      var Value: string): Boolean;
    procedure ShowTabDialog(new: Boolean = true; tabName: string = '');
    function SelectedTab: TTabItem;
    procedure DeleteNote;
    procedure NewNote;
    procedure EditNote;
  public
    function GetNotesDir: string;
    procedure UpdateTabList(FocusTab: string = '');
    procedure SaveCurrentTab;
    procedure LoadCurrentTab;

    property AlwaysOnTop: boolean read FAlwaysOnTop write FAlwaysOnTop;
  end;

const
  NOTES_EXTENSION = '.txt';

implementation

uses SharpApi,
  NotesNewTabWnd,
  MainWnd;

{$R *.dfm}

function TNotesForm.CustomInputQuery(const ACaption, APrompt: string;
  var Value: string): Boolean;
const
  SMsgDlgOK = 'OK';
  SMsgDlgCancel = 'Cancel';
var
  x, y, w, h: Integer;
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;

  function GetAveCharSize(Canvas: TCanvas): TPoint;
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do
      Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do
      Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;

begin
  Result := False;
  Form := TForm.Create(Self);
  with Form do
  try
    Canvas.Font := Font;
    PopupParent := self;
    DialogUnits := GetAveCharSize(Canvas);
    FormStyle := fsStayOnTop;
    BorderStyle := bsToolWindow;
    Caption := ACaption;
    ClientWidth := MulDiv(180, DialogUnits.X, 4);
    ClientHeight := MulDiv(63, DialogUnits.Y, 8);

    // center Horzontally
    w := (Self.Width - Form.Width) div 2;
    X := Self.Left + W;
    if x < 0 then
      x := 0
    else if x + w > Screen.Width then
      x := Screen.Width - Form.Width;
    Form.Left := X;

    // center vertically
    h := (Self.Height - Form.Height) div 2;
    y := Self.Top + h;
    if y < 0 then
      y := 0
    else if y + h > Screen.Height then
      y := Screen.Height - Form.Height;
    Form.Left := X;
    Form.Top := Y;

    Prompt := TLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      AutoSize := True;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Caption := APrompt;
    end;
    Edit := TEdit.Create(Form);
    with Edit do
    begin
      Parent := Form;
      Left := Prompt.Left;
      Top := MulDiv(19, DialogUnits.Y, 8);
      Width := MulDiv(164, DialogUnits.X, 4);
      MaxLength := 255;
      Text := Value;
      SelectAll;
    end;
    ButtonTop := MulDiv(41, DialogUnits.Y, 8);
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := SMsgDlgOK;
      ModalResult := mrOk;
      default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
        ButtonHeight);
    end;
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := SMsgDlgCancel;
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth,
        ButtonHeight);
    end;

    if ShowModal = mrOk then
    begin
      Value := Edit.Text;
      Result := True;
    end;
  finally
    Form.Free;
  end;
end;

procedure TNotesForm.DeleteNote;
var
  Dir: string;
  fname: string;
  b: boolean;
begin
  b := False;
  if (Notes.Lines.Count = 0) or
    ((Notes.Lines.Count = 1) and (length(Trim(Notes.Lines[0])) = 0)) then
    b := True;

  if not b then
    if MessageBox(self.Handle,
      PChar('The tab you are about to close is not empty!' + #10#13 +
      'All information will be lost. Close it anyway?'),
      'Closing Tab...', MB_YESNO) = IDYES then
      b := True;

  if b then
  begin
    Dir := GetNotesDir;
    fname := SelectedTab.Caption;
    if FileExists(Dir + fname + NOTES_EXTENSION) then
      DeleteFile(Dir + fname + NOTES_EXTENSION);

    pcNotes.TabItems.Delete(SelectedTab.Index);
    pcNotes.TabIndex := pcNotes.TabIndex - 1;
    UpdateTabList;
  end;
end;

procedure TNotesForm.EditNote;
begin
  ShowTabDialog(false, SelectedTab.Caption);
end;

function TNotesForm.GetNotesDir: string;
begin
  result := SharpApi.GetSharpeUserSettingsPath + 'Notes\';
end;

procedure TNotesForm.UpdateTabList(focusTab: string = '');
var
  sDir: string;
  currentTab: string;
  filename: string;
  tab: TTabItem;
  files: TStringList;
  iTabIndex, i: integer;
begin
  sDir := GetNotesDir;
  ForceDirectories(sDir);

  iTabIndex := pcNotes.TabIndex;

  if ((iTabIndex <> -1) and (iTabIndex < pcNotes.TabItems.Count) and
    (length(focustab) = 0)) then
    currentTab := pcNotes.TabItems.Item[iTabIndex].Caption
  else
    currentTab := focusTab;

  pcNotes.TabItems.Clear;
  files := TStringList.Create;
  try
    SharpThemeApi.FindFiles(files, sDir, '*' + NOTES_EXTENSION);
    for i := 0 to Pred(files.Count) do
    begin

      filename := ExtractFileName(files[i]);
      setlength(filename, length(filename) - 4);

      if CompareText(filename, CurrentTab) = 0 then
      begin
        tab := pcNotes.TabItems.Add;
        tab.Caption := filename;
        tab.ImageIndex := 12;
        iTabIndex := i;
      end
      else
      begin
        tab := pcNotes.TabItems.Add;
        tab.ImageIndex := 12;
        tab.Caption := filename;
      end;
    end;

  finally
    files.Free;
  end;

  if iTabIndex = -1 then begin
    if iTabIndex < 0 then iTabIndex := 0;

    if pcNotes.TabItems.Count = 0 then
      iTabIndex := -1;
  end;

  pcNotes.TabIndex := iTabIndex;

  if iTabIndex <> -1 then
    LoadCurrentTab;

  Notes.Visible := pcNotes.TabItems.Count > 0;
  tbNotes.Visible := Notes.Visible;
  pcNotes.Buttons.Item[1].Visible := Notes.Visible;
  pcNotes.Buttons.Item[2].Visible := Notes.Visible;

end;

procedure TNotesForm.SaveCurrentTab;
var
  sDir: string;
  s: string;
begin
  if ( (SelectedTab = nil) or (pcNotes.TabIndex = -1) ) then
    exit;

  sDir := GetNotesDir;
  ForceDirectories(sDir);
  s := SelectedTab.Caption;
  Notes.Lines.SaveToFile(sDir + s + NOTES_EXTENSION);
end;

function TNotesForm.SelectedTab: TTabItem;
begin
  Result := nil;
  if ( (pcNotes.TabIndex <> -1) and (pcNotes.TabIndex < pcNotes.TabItems.Count)) then
    Result := pcNotes.TabItems.Item[pcNotes.TabIndex];
end;

procedure TNotesForm.pcNotesBtnClick(ASender: TObject;
  const ABtnIndex: Integer);
begin
  case ABtnIndex of
    0: NewNote;
    1: DeleteNote;
    2: EditNote;
  end;
end;

procedure TNotesForm.pcNotesTabClick(ASender: TObject;
  const ATabIndex: Integer);
begin
  LoadCurrentTab;
end;

procedure TNotesForm.LoadCurrentTab;
var
  Dir: string;
  fname: string;
begin
  if SelectedTab = nil then
    exit;

  Dir := GetNotesDir;
  ForceDirectories(Dir);
  fname := SelectedTab.Caption;
  Notes.Lines.LoadFromFile(Dir + fname + NOTES_EXTENSION);
  if Notes.Lines.Count > 0 then
  begin
    Notes.CaretPos := Point(length(Notes.Lines[Notes.Lines.Count - 1]), Notes.Lines.Count - 1);
    SendMessage(Notes.Handle, EM_SCROLLCARET, 0, 0);
  end;
end;

procedure TNotesForm.ShowTabDialog(new: Boolean = true; tabName: string = '');
var
  s: string;
  sDir: string;
  bValid: Boolean;
  fhandle: Integer;
begin
  s := '';
  if tabName <> '' then
    s := tabName;

  bValid := True;

  if new then
    CustomInputQuery('Enter the name for the new note', 'Name:', s)
  else
    CustomInputQuery('Enter a new name for the note', 'New Name:', s);

  if ((s <> '') and (s <> tabName)) then
  begin
    // Remove invalid chars
    s := trim(StrRemoveChars(s, ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));

    // Check if already exists
    sDir := GetNotesDir;
    if FileExists(sDir + s + NOTES_EXTENSION) then
    begin
      MessageBox(Self.Handle, 'Another note with the same name already exists',
        'Name Invalid', MB_OK);
      bValid := False;
    end;

    // All ok?
    if bValid then
    begin
      ForceDirectories(sDir);

      if new then
      begin
        fhandle := FileCreate(sDir + s + NOTES_EXTENSION);
        FileClose(fhandle);
        SaveCurrentTab;
        UpdateTabList(s);
      end
      else
      begin
        RenameFile(sDir + SelectedTab.Caption + NOTES_EXTENSION, sDir + s + NOTES_EXTENSION);
        DeleteFile(sDir + SelectedTab.Caption + NOTES_EXTENSION);
        pcNotes.TabItems.Item[pcNotes.TabIndex].Caption := s;
        UpdateTabList(s);
      end;
    end;
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
  if SelectedTab <> nil then
    TMainForm(Owner).sLastTab := SelectedTab.Caption
  else
    TMainForm(Owner).sLastTab := '';
  TMainForm(Owner).sLastTextPos.Y := Notes.CurrentLine;
  TMainForm(Owner).SaveSettings;
end;

procedure TNotesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(Self);
end;

procedure TNotesForm.FormShow(Sender: TObject);
begin
  UpdateTabList(TMainForm(Owner).sLastTab);
end;

procedure TNotesForm.tb_copyClick(Sender: TObject);
begin
  Notes.CopyToClipboard;
end;

procedure TNotesForm.tb_pasteClick(Sender: TObject);
begin
  Notes.PasteFromClipboard;
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
  Ext: string;
begin
  Try
  if FAlwaysOnTop then
    Self.FormStyle := fsNormal;

  if ExportDialog.Execute then
  begin
    case ExportDialog.FilterIndex of
      1: Ext := '.txt';
    else
      Ext := '';
    end;
    Notes.Lines.SaveToFile(ExportDialog.FileName + Ext);
  end;
  Finally
    if FAlwaysOnTop then
      Self.FormStyle := fsStayOnTop;
  End;
end;

procedure TNotesForm.tb_importClick(Sender: TObject);
begin
  try
  if FAlwaysOnTop then
    Self.FormStyle := fsNormal;

  if ImportDialog.Execute then
  begin
    Notes.Lines.LoadFromFile(ImportDialog.FileName);
  end;
  finally
    if FAlwaysOnTop then
    Self.FormStyle := fsStayOnTop;

    SaveCurrentTab;
  end;
end;

procedure TNotesForm.btn_findClick(Sender: TObject);
begin
  FindDialog.Find;
end;

procedure TNotesForm.btn_linewrapClick(Sender: TObject);
begin
  Notes.WordWrap := btn_linewrap.Down;
  if not Notes.WordWrap then
    Notes.ScrollBars := ssBoth
  else
    Notes.ScrollBars := ssVertical;
end;

procedure TNotesForm.btn_monofontClick(Sender: TObject);
begin
  if btn_monofont.Down then
    Notes.Font.Name := 'Courier New'
  else
    Notes.Font.Name := 'Tahoma';
end;

procedure TNotesForm.NotesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = ord('F')) and (Shift = [ssCtrl]) then
    btn_find.OnClick(btn_find)
  else if (Key = ord('A')) and (Shift = [ssCtrl]) then
    btn_selectall.OnClick(btn_selectall);

  SaveCurrentTab;
end;

procedure TNotesForm.NewNote;
begin
  ShowTabDialog;
end;

procedure TNotesForm.NotesChange(Sender: TObject);
var
  i : Integer;
  Wider, Higher : Boolean;
begin
  Wider:=False;
  Higher:=False;

  font.Name:=Notes.font.name;
  font.Size:=Notes.font.size;
  font.Style:=Notes.font.style;

  // Check Height
  If Notes.Lines.Count*canvas.TextHeight('Mg')>Notes.Height then Higher:=True;

  // Check width
  for i:=0 to Notes.Lines.Count-1 do
  Begin
    if canvas.TextWidth(Notes.Lines[i])>Notes.Width then Wider:=True;
  end;

  If Wider and Higher then Notes.ScrollBars:=ssBoth else
  if Higher then Notes.ScrollBars:=ssVertical else
  if Wider then Notes.ScrollBars:=ssHorizontal
  else Notes.ScrollBars:=ssNone;
end;

procedure TNotesForm.NotesKeyPress(Sender: TObject; var Key: Char);
var
  KS: TKeyboardState;
  Shift: TShiftState;
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

