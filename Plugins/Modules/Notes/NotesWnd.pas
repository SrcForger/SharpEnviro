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
  Dialogs, JvRichEdit, StdCtrls, JvExStdCtrls, ExtCtrls, SharpEPageControl,
  SharpETabList, ImgList, PngImageList, ToolWin, JvExComCtrls, JclStrings,
  JclAnsiStrings, JvToolBar, SharpThemeApiEx, JvEdit, Menus, JvMenus,
  JvMemo, ComCtrls, StrUtils, uVistaFuncs, SharpFileUtils, uNotesSettings,
  SharpAPI, JclFileUtils;

type
  TSharpENotesForm = class(TForm)
    reNotes: TJvRichEdit;
    pcNotes: TSharpEPageControl;
    tbNotes: TJvToolBar;
    btnImport: TToolButton;
    pilNotes: TPngImageList;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    btnExport: TToolButton;
    btnPrint: TToolButton;
    btnFind: TToolButton;
    btnReplace: TToolButton;
    btnCut: TToolButton;
    btnCopy: TToolButton;
    btnPaste: TToolButton;
    btnFont: TToolButton;
    btnBold: TToolButton;
    btnItalic: TToolButton;
    btnUnderline: TToolButton;
    btnAlignLeft: TToolButton;
    btnAlignCenter: TToolButton;
    btnAlignRight: TToolButton;
    btnAlignJustify: TToolButton;
    btnListBullet: TToolButton;
    btnListNumber: TToolButton;
    btnIndentDecrease: TToolButton;
    btnIndentIncrease: TToolButton;
    btnClearFilter: TToolButton;
    btnSeparator1: TToolButton;
    btnSeparator2: TToolButton;
    btnSeparator3: TToolButton;
    btnSeparator4: TToolButton;
    btnSeparator5: TToolButton;
    editFilter: TJvEdit;
    FontDialog: TFontDialog;
    PrintDialog: TPrintDialog;
    pilTabImages: TPngImageList;
    pmNotes: TPopupMenu;
    miUndo: TMenuItem;
    miRedo: TMenuItem;
    miSeparator1: TMenuItem;
    miCut: TMenuItem;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    miDelete: TMenuItem;
    miSeparator2: TMenuItem;
    miSelectAll: TMenuItem;
    miWordWrap: TMenuItem;
    pmFilter: TPopupMenu;
    miFilterNames: TMenuItem;
    miFilterTags: TMenuItem;
    miFilterText: TMenuItem;
    miFilterNamesAndTags: TMenuItem;
    miFilterNamesAndText: TMenuItem;
    miFilterTagsAndText: TMenuItem;
    hiddenPanel: TPanel;
    miFormat: TMenuItem;
    ColorDialog: TColorDialog;
    miTextBackColor: TMenuItem;
    miTab: TMenuItem;
    miAddTab: TMenuItem;
    miDeleteTab: TMenuItem;
    miEditTab: TMenuItem;
    miAddFromSelectedText: TMenuItem;
    miAddFromCurrentTab: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure pcNotesTabChange(ASender: TObject;
      const ATabIndex: Integer; var AChange: Boolean);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnCutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure btnClearFilterClick(Sender: TObject);
    procedure pcNotesBtnClick(ASender: TObject;
      const ABtnIndex: Integer);
    procedure EditorSelectionChange(Sender: TObject);
    procedure btnListNumberClick(Sender: TObject);
    procedure btnListBulletClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure EditorCloseFindDialog(Sender: TObject; Dialog: TFindDialog);
    procedure FilterChange(Sender: TObject);
    procedure btnIndentDecreaseClick(Sender: TObject);
    procedure btnIndentIncreaseClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditorKeyPress(Sender: TObject; var Key: Char);
    procedure miWordWrapClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miUndoClick(Sender: TObject);
    procedure miRedoClick(Sender: TObject);
    procedure miCutClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miPasteClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure pmNotesPopup(Sender: TObject);
    procedure miFilterNamesClick(Sender: TObject);
    procedure miFilterTagsClick(Sender: TObject);
    procedure miFilterTextClick(Sender: TObject);
    procedure miFilterNamesAndTagsClick(Sender: TObject);
    procedure miFilterNamesAndTextClick(Sender: TObject);
    procedure miFilterTagsAndTextClick(Sender: TObject);
    procedure btnAlignLeftClick(Sender: TObject);
    procedure btnAlignCenterClick(Sender: TObject);
    procedure btnAlignRightClick(Sender: TObject);
    procedure btnAlignJustifyClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditorChange(Sender: TObject);
    procedure miTextBackColorClick(Sender: TObject);
    procedure miAddTabClick(Sender: TObject);
    procedure miDeleteTabClick(Sender: TObject);
    procedure miEditTabClick(Sender: TObject);
    procedure miAddFromSelectedTextClick(Sender: TObject);
    procedure miAddFromCurrentTabClick(Sender: TObject);
    procedure EditorURLClick(Sender: TObject; const URLText: string;
      Button: TMouseButton);
  private
    { Private declarations }
    FIndex: Integer;
    FLoading : Boolean;
    function NotesDir: string;
    function CurrText: TJvTextAttributes;
    procedure FocusEditor;
    function ShowTabOptions(New: Boolean; Name: string) : Boolean;
    procedure AddTabWithText(text : string);
    function AddTab(Name: string) : Integer;
    procedure DeleteTab;
    function TabName(Index: Integer) : string;
    function TabFilePath(Index: Integer) : string; overload;
    function TabNameContainsFilterText(Index: Integer) : Boolean;
    function TabTagsContainsFilterText(Index: Integer) : Boolean;
    function TabTextContainsFilterText(Index: Integer) : Boolean;
    function GetSettings: NotesSettings;
    function GetTabSettings(Name: string) : NotesTabSettings;
    procedure DeleteTabSettings(Name: string);
    procedure ConvertTxtFilesToRtfFiles;
    procedure LoadDefaultTab;
    procedure WMUpdateNotes(var Msg : TMessage); message WM_UPDATENOTES;
    function IsReadOnly(FilePath : string) : Boolean;
  public
    { Public declarations }
    function TabFilePath(Name: string) : string; overload;
    property Settings: NotesSettings read GetSettings;
  end;

var
  NotesForm: TSharpENotesForm;

  const IndentationSize = 5;

implementation

uses MainWnd, NotesTabOptionsWnd;

{$R *.dfm}

procedure TSharpENotesForm.WMUpdateNotes(var Msg: TMessage);
var
  str : PAnsiChar;
begin
  GetMem(str, 255);
  if GlobalGetAtomName(Msg.WParam, str, 255) > 0 then
    // We only want to reload tab settings that refer to the same directory.
    if str = Settings.Directory then
    begin
      // Call the FormShow event to start fresh with the new settings.
      FormShow(Self);
    end;

  GlobalDeleteAtom(Msg.WParam);
  FreeMem(str);
end;

function TSharpENotesForm.CurrText: TJvTextAttributes;
begin
  with reNotes do
    if SelLength > 0 then
      Result := SelAttributes
    else
      Result := WordAttributes;
end;

procedure TSharpENotesForm.FocusEditor;
begin
  with reNotes do
    if CanFocus then
      SetFocus;
end;

function TSharpENotesForm.ShowTabOptions(New: Boolean; Name: string) : Boolean;
var
  tabSettings : NotesTabSettings;
  frmTabOptions : TTabOptionsForm;
  oldTabName : string;
begin
  Result := False;
  
  if not New and (FIndex = -1) then Exit;

  // Create the tab option form.
  frmTabOptions := TTabOptionsForm.Create(Self);
  try
    frmTabOptions.ilvIcon.Images := pilTabImages;
    
    // Set the default for the fields.
    frmTabOptions.editName.Text := Name;
    frmTabOptions.editTags.Text := '';
    frmTabOptions.ilvIcon.SelectedIndex := DefaultIconIndex;
    frmTabOptions.chkReadOnly.Checked := False; 

    if not New then
    begin
      tabSettings := GetTabSettings(TabName(FIndex));
      frmTabOptions.editTags.Text := tabSettings.Tags;
      frmTabOptions.ilvIcon.SelectedIndex := tabSettings.IconIndex;
      frmTabOptions.chkReadOnly.Checked := IsReadOnly(TabFilePath(FIndex));
    end;

    if frmTabOptions.ShowModal = mrOk then
    begin
      if New then
      begin
        // Create the file.
        with TJvRichEdit.Create(hiddenPanel) do
        try
          Parent := hiddenPanel;
          Visible := False;
          // Create a file for the new tab.
          Lines.SaveToFile(TabFilePath(frmTabOptions.editName.Text));
        finally
          Free;
        end;

        // Set the file to be read only if the checkbox is checked.
        if frmTabOptions.chkReadOnly.Checked then
          FileSetAttr(TabFilePath(frmTabOptions.editName.Text), faReadOnly);

        // Create a tab with the default settings and change to it.
        pcNotes.TabIndex := AddTab(frmTabOptions.editName.Text);

      end
      else
      begin
        oldTabName := TabName(FIndex);

        // If we are changing the name of the tab then
        // delete it from the settings list, rename the file
        // delete the old file and change the tab caption.
        if oldTabName <> frmTabOptions.editName.Text then
        begin
          DeleteTabSettings(oldTabName);

          if RenameFile(TabFilePath(FIndex), TabFilePath(frmTabOptions.editName.Text)) then
          begin
            DeleteFile(TabFilePath(FIndex));
            pcNotes.TabItems.Item[FIndex].Caption := frmTabOptions.editName.Text;
          end;
        end;

        // if read only is checked then set the file to be as such
        // otherwise set the file to have normal access.
        if frmTabOptions.chkReadOnly.Checked then
          FileSetAttr(TabFilePath(FIndex), faReadOnly)
        else
          FileSetAttr(TabFilePath(FIndex), faNormalFile);
      end;
      // Get the tab settings for with the new or old tab name.
      // set the tags and icon index.
      tabSettings := GetTabSettings(TabName(FIndex));
      tabSettings.Tags := frmTabOptions.editTags.Text;
      tabSettings.IconIndex := frmTabOptions.ilvIcon.SelectedIndex;

      // Set the image index for the tab.
      pcNotes.TabItems.Item[FIndex].ImageIndex := tabSettings.IconIndex;

      // Save the tabs settings and send an update to other notes modules.
      TMainForm(Owner).SaveTabsSettings;
      TMainForm(Owner).SendUpdateNotes;

      Result := True;
    end;
  finally
    frmTabOptions.Free;
  end;
end;

procedure TSharpENotesForm.AddTabWithText(text: string);
begin
  if ShowTabOptions(True, '') then
    reNotes.Text := text;
end;

{$REGION 'Editor Events'}

procedure TSharpENotesForm.EditorChange(Sender: TObject);
begin
  if FIndex = -1 then
    Exit;

  // Only save the tab if we are not loading a tab
  // and the file is not read only.
  if not (FLoading or IsReadOnly(TabFilePath(FIndex))) then
    reNotes.Lines.SaveToFile(TabFilePath(FIndex));
end;

procedure TSharpENotesForm.EditorCloseFindDialog(Sender: TObject;
  Dialog: TFindDialog);
begin
  FocusEditor;
end;

procedure TSharpENotesForm.EditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Handled: Boolean;
begin
  // Valid shortcut is Ctrl + Key is pressed, exclude Alt and Shift.
  if (ssCtrl in Shift) and not (ssAlt in Shift) and not (ssShift in Shift) then
  begin
    Handled := True;
    
    case Key of
      Word('B'):
      begin
        // Toggle the button and call its click event.
        btnBold.Down := not btnBold.Down;
        btnBold.Click;
      end;
      Word('F'): btnFind.OnClick(Sender);
      Word('H'): btnReplace.OnClick(Sender);
      Word('I'):
      begin
        // Toggle the button and call its click event.
        btnItalic.Down := not btnItalic.Down;
        btnItalic.Click;
      end;
      Word('O'): btnImport.OnClick(Sender);
      Word('P'): btnPrint.OnClick(Sender);
      Word('S'): btnExport.OnClick(Sender);
      Word('T'):
      begin
        if ssShift in Shift then
          // Ctrl + Shift + T
          miAddFromSelectedText.Click
        else if ssAlt in Shift then
          // Ctrl + Alt + T
          miAddFromCurrentTab.Click
        else
          // Ctrl + T
          ShowTabOptions(True, '');
      end;
      Word('U'):
      begin
        // Toggle the button and call its click event.
        btnUnderline.Down := not btnUnderline.Down;
        btnUnderline.Click;
      end;
      Word('Y'): if reNotes.CanRedo then reNotes.Redo;                 
    else
      // Indicate that we do not have a shortcut for this key combination.
      Handled := False;
    end;

    // We handled the key combination so set the key
    // to 0 to prevent further processing.
    if Handled then
      Key := 0;
  end;
end;

procedure TSharpENotesForm.EditorKeyPress(Sender: TObject; var Key: Char);
var
  KS: TKeyboardState;
  SS: TShiftState;
begin
  if reNotes.Focused and (Key = AnsiEscape) then
    Close;

  GetKeyboardState(KS);
  SS := KeyboardStateToShiftState(KS);

  if (SS = [ssCtrl]) then
    case Key of
      // When using Ctrl+I shortcut to toggle the Italic font style the
      // JvRichEdit tries to insert a tab so don't allow it here.  However
      // we do allow Ctrl+Tab to change tabs but that is handled in the
      // FormKeyDown event.
      AnsiTab: Key := AnsiNull;
    end;
end;

procedure TSharpENotesForm.EditorSelectionChange(Sender: TObject);
var
  tabSettings : NotesTabSettings;
begin
  btnCut.Enabled := (reNotes.SelText <> '');
  btnCopy.Enabled := (reNotes.SelText <> '');
  btnPaste.Enabled := reNotes.CanPaste;

  with reNotes.Paragraph do
  begin
    // Enable the buttons based on the current text style.
    btnBold.Down := fsBold in CurrText.Style;
    btnItalic.Down := fsItalic in CurrText.Style;
    btnUnderline.Down := fsUnderline in CurrText.Style;

    {
    case NumberingStyle of
      nsParenthesis: ;
      nsPeriod: ;
      nsEnclosed: ;
      nsSimple: ;
    end;
    }

    // The List buttons are grouped so only one will be active at a time.
    case Numbering of
      JvRichEdit.nsNone:
      begin
        // There is no List so turn off both buttons.
        btnListNumber.Down := False;
        btnListBullet.Down := False;
      end;
      JvRichEdit.nsBullet: btnListBullet.Down := True;
      JvRichEdit.nsArabicNumbers: btnListNumber.Down := True;
      JvRichEdit.nsLoCaseLetter: ;
      JvRichEdit.nsUpCaseLetter: ;
      JvRichEdit.nsLoCaseRoman: ;
      JvRichEdit.nsUpCaseRoman: ;
    end;

    // The buttons are grouped so only 1 will be active at a time.
    case Alignment of
      JvRichEdit.paLeftJustify: btnAlignLeft.Down := True;
      JvRichEdit.paRightJustify: btnAlignRight.Down := True;
      JvRichEdit.paCenter: btnAlignCenter.Down := True;
      JvRichEdit.paJustify: btnAlignJustify.Down := True;
    end;
  end;

  if (FIndex > -1) and not FLoading then
  begin
    // Update the select start and length when the selection changes.
    tabSettings := GetTabSettings(TabName(FIndex));
    tabSettings.SelStart := reNotes.SelStart;
    tabSettings.SelLength := reNotes.SelLength;

    TMainForm(Owner).SaveTabsSettings;
  end;
end;

procedure TSharpENotesForm.EditorURLClick(Sender: TObject;
  const URLText: string; Button: TMouseButton);
begin
  SharpExecute(URLText);
end;

{$ENDREGION 'Editor Events'}

{$REGION 'Toolbar Events'}

procedure TSharpENotesForm.btnImportClick(Sender: TObject);
var
  i: Integer;
  filePath: string;
begin
  if OpenDialog.Execute(Self.Handle) then
  begin
    for filePath in OpenDialog.Files do
    begin
      i := AddTab(PathExtractFileNameNoExt(filePath));

      if i = -1 then Exit;

      with TJvRichEdit.Create(hiddenPanel) do
      try
        Parent := hiddenPanel;
        Visible := False;
        // Open the file being imported.
        Lines.LoadFromFile(filePath);
        // Save the file being imported to the notes directory.
        Lines.SaveToFile(TabFilePath(PathExtractFileNameNoExt(filePath)));
      finally
        Free;
      end;

      // Change to the new tab.
      pcNotes.TabIndex := i;

      // Save the tabs settings and send an update to other notes modules.
      TMainForm(Owner).SaveTabsSettings;
      TMainForm(Owner).SendUpdateNotes;
    end;
  end;
end;

procedure TSharpENotesForm.btnExportClick(Sender: TObject);
var
  ext : string;
begin
  if FIndex = -1 then
    Exit;

  if SaveDialog.Execute(Self.Handle) then
  begin
    ext := '';
    if (SaveDialog.FilterIndex = 1) and (ExtractFileExt(SaveDialog.FileName) <> '.rtf') then
      ext := '.rtf'
    else if (SaveDialog.FilterIndex  = 2) and (ExtractFileExt(SaveDialog.FileName) <> '.txt') then
      ext := '.txt';

    // Save the current text to the new file.
    reNotes.Lines.SaveToFile(SaveDialog.FileName + ext);

    // Delete the exported file from disk.
    DeleteFile(TabFilePath(FIndex));
    // Delete the tab settings from the list.
    DeleteTabSettings(TabName(FIndex));
    // Remove the current tab from the list.
    pcNotes.TabList.Delete(pcNotes.TabItems.Item[FIndex]);
    // Set the index to -1 so we don't try and save it
    // in the tab change event.
    FIndex := -1;
    pcNotes.TabIndex := -1;

    reNotes.Clear;
    reNotes.ReadOnly := True;

    // Save the tabs settings and send an update to other notes modules.
    TMainForm(Owner).SaveTabsSettings;
    TMainForm(Owner).SendUpdateNotes;
  end;
end;

procedure TSharpENotesForm.btnPrintClick(Sender: TObject);
begin
  // From the help: It is not advisable to change FormStyle at runtime.
  try
    if Settings.AlwaysOnTop then
      Self.FormStyle := fsNormal;

    if PrintDialog.Execute(Self.Handle) then
      reNotes.Print(TabFilePath(FIndex));
  finally
    if Settings.AlwaysOnTop then
      Self.FormStyle := fsStayOnTop;
  end;
end;

procedure TSharpENotesForm.btnFindClick(Sender: TObject);
begin
  with reNotes do
    FindDialog(SelText);
end;

procedure TSharpENotesForm.btnReplaceClick(Sender: TObject);
begin
  with reNotes do
    ReplaceDialog(SelText, '');
end;

procedure TSharpENotesForm.btnCutClick(Sender: TObject);
begin
  reNotes.CutToClipboard;
end;

procedure TSharpENotesForm.btnCopyClick(Sender: TObject);
begin
  reNotes.CopyToClipboard;
end;

procedure TSharpENotesForm.btnPasteClick(Sender: TObject);
begin
  reNotes.PasteFromClipboard;
end;

procedure TSharpENotesForm.btnFontClick(Sender: TObject);
begin
  // From the help: It is not advisable to change FormStyle at runtime.
  try
    if Settings.AlwaysOnTop then
      Self.FormStyle := fsNormal;

    // Set the font for the dialog to that of the current text.
    FontDialog.Font.Assign(CurrText);
    if FontDialog.Execute(Self.Handle) then
      // Set the current text font because the user clicked ok.
      CurrText.Assign(FontDialog.Font);
  finally
    if Settings.AlwaysOnTop then
      Self.FormStyle := fsStayOnTop;
  end;
end;

procedure TSharpENotesForm.btnBoldClick(Sender: TObject);
begin
  if btnBold.Down then
    // Add the bold style to the current style.
    CurrText.Style := CurrText.Style + [fsBold]
  else
    // Remove the bold style from the current style.
    CurrText.Style := CurrText.Style - [fsBold];
end;

procedure TSharpENotesForm.btnItalicClick(Sender: TObject);
begin
  if btnItalic.Down then
    // Add the italic style to the current style.
    CurrText.Style := CurrText.Style + [fsItalic]
  else
    // Remove the italic style from the current style.
    CurrText.Style := CurrText.Style - [fsItalic];
end;

procedure TSharpENotesForm.btnUnderlineClick(Sender: TObject);
begin
  if btnUnderline.Down then
    // Add the underline style to the current style.
    CurrText.Style := CurrText.Style + [fsUnderline]
  else
    // Remove the underline style from the current style.
    CurrText.Style := CurrText.Style - [fsUnderline];
end;

procedure TSharpENotesForm.btnAlignLeftClick(Sender: TObject);
begin
  reNotes.Paragraph.Alignment := JvRichEdit.paLeftJustify;
end;

procedure TSharpENotesForm.btnAlignCenterClick(Sender: TObject);
begin
  reNotes.Paragraph.Alignment := JvRichEdit.paCenter;
end;

procedure TSharpENotesForm.btnAlignRightClick(Sender: TObject);
begin
  reNotes.Paragraph.Alignment := JvRichEdit.paRightJustify;
end;

procedure TSharpENotesForm.btnAlignJustifyClick(Sender: TObject);
begin
  reNotes.Paragraph.Alignment := JvRichEdit.paJustify;
end;

procedure TSharpENotesForm.btnListNumberClick(Sender: TObject);
begin
  with reNotes.Paragraph do
    if btnListNumber.Down then
    begin
      // Set the list style to use a period after the numbers.
      NumberingStyle := JvRichEdit.nsPeriod;
      // Set the number style list to start at 1.
      NumberingStart := 1;
      // Add a numeric style list to the paragraph.
      Numbering := JvRichEdit.nsArabicNumbers;
    end
    else
      // Remove the numeric style list from the paragraph.
      Numbering := JvRichEdit.nsNone;
end;

procedure TSharpENotesForm.btnListBulletClick(Sender: TObject);
begin
  with reNotes.Paragraph do
    if btnListBullet.Down then
      // Add a bullet style list to the paragraph.
      Numbering := JvRichEdit.nsBullet
    else
      // Remove the bullet style list from the paragraph.
      Numbering := JvRichEdit.nsNone;
end;

procedure TSharpENotesForm.btnIndentDecreaseClick(Sender: TObject);
begin
  with reNotes.Paragraph do
    // Only decrement the indentation if it was incremented previously.
    if FirstIndent > 0 then
      // Decrement the indentation by 5 every time the user clicks the button.
      FirstIndent := FirstIndent - IndentationSize;
end;

procedure TSharpENotesForm.btnIndentIncreaseClick(Sender: TObject);
begin
  with reNotes.Paragraph do
    // Increment the indentation by 5 every time the user clicks the button.
    FirstIndent := FirstIndent + IndentationSize;
end;

procedure TSharpENotesForm.btnClearFilterClick(Sender: TObject);
begin
  editFilter.Text := '';
end;

procedure TSharpENotesForm.FilterChange(Sender: TObject);
var
  i: Integer;
begin
  // If the filter is empty then set all tabs to visible.
  if editFilter.Text = '' then
  begin
    btnClearFilter.ImageIndex := 20;
    for i := 0 to Pred(pcNotes.TabCount) do
    begin
      pcNotes.TabItems.Item[i].Visible := True;
    end;
    Exit;
  end;

  btnClearFilter.ImageIndex := 23;
  
  // Loop over the popup menu items to see which on
  // is checked and call the correct click event.
  for i := 0 to Pred(pmFilter.Items.Count) do
    if pmFilter.Items[i].Checked then
    begin
      case i of
        0: miFilterNames.OnClick(Sender);
        1: miFilterTags.OnClick(Sender);
        2: miFilterText.OnClick(Sender);
        3: miFilterNamesAndTags.OnClick(Sender);
        4: miFilterNamesAndText.OnClick(Sender);
        5: miFilterTagsAndText.OnClick(Sender);
      end;
      Break;
    end;

  // Cut out early as there is no selected tab.
  if FIndex = -1 then
    Exit;
    
  if not pcNotes.TabItems.Item[FIndex].Visible then
  begin
    // The tab is no longer visible so set the index to -1.
    pcNotes.TabIndex := -1;
    // Clear the notes and don't allow input.
    reNotes.Clear;
    reNotes.ReadOnly := True;
  end;
end;

{$ENDREGION 'Toolbar Events'}

{$REGION 'Form Events'}

procedure TSharpENotesForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  Settings.Left := Self.Left;
  Settings.Top := Self.Top;
  Settings.Width := Self.Width;
  Settings.Height := Self.Height;
  Settings.WordWrap := reNotes.WordWrap;
  Settings.Filter := editFilter.Text;

  for i := 0 to Pred(pmFilter.Items.Count) do
  begin
    if pmFilter.Items.Items[i].Checked then
    begin
      Settings.FilterIndex := i;
      Break;
    end;
  end;

  if FIndex > -1 then
    Settings.LastTab := pcNotes.TabItems.Item[FIndex].Caption;

  TMainForm(Owner).SaveTabsSettings;
  TMainForm(Owner).SaveSettings;
end;

procedure TSharpENotesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(Self);
end;

procedure TSharpENotesForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Handled: Boolean;
  changed: Boolean;
  i: Integer;
begin
  // Valid shortcut is Ctrl + Tab or Ctrl + Shift + Tab, exclude Alt.
  if (ssCtrl in Shift) and not (ssAlt in Shift) then
  begin
    Handled := False;
    
    case Key of
      VK_TAB:
      begin
        Handled := True;
        changed := False;
        // Only go to the next tab if there is one
        if pcNotes.TabCount > 0 then
        begin
          if ssShift in Shift then
          begin
            // Loop over each item from the before tab index
            // down to 0 looking for a visible tab.
            for i := Pred(FIndex) downto 0 do
              if pcNotes.TabItems.Item[i].Visible then
              begin
                pcNotes.TabIndex := i;
                changed := True;
                Break;
              end;

            // If we weren't able to find a visible tab going
            // from the before tab index down to 0 then start
            // from the tab list count and go to the after tab index.
            if not changed then
              for i := Pred(pcNotes.TabCount) downto Succ(FIndex) do
                if pcNotes.TabItems.Item[i].Visible then
                begin
                  pcNotes.TabIndex := i;
                  Break;
                end;
          end
          else
          begin
            // Loop over each item from the after tab index to
            // the tab list count looking for a visible tab.
            for i := Succ(FIndex) to Pred(pcNotes.TabItems.Count) do
              if pcNotes.TabItems.Item[i].Visible then
              begin
                pcNotes.TabIndex := i;
                changed := True;
                Break;
              end;

            // If we weren't able to find a visible tab going
            // from the after tab index to the tab list count
            // then start from 0 and go to the before tab index.
            if not changed then
              for i := 0 to Pred(FIndex) do
                if pcNotes.TabItems.Item[i].Visible then
                begin
                  pcNotes.TabIndex := i;
                  Break;
                end;
          end;
        end;
      end;
    end;

    // We handled the key combination so set the key
    // to 0 to prevent further processing.
    if Handled then
      Key := 0;
  end;
end;

procedure TSharpENotesForm.FormResize(Sender: TObject);
begin
  reNotes.Refresh;
end;

procedure TSharpENotesForm.FormShow(Sender: TObject);
var
  filePaths: TStringList;
  filePath: string;
  i: Integer;
  tabSettings: NotesTabSettings;
begin
  if Self.WindowState = wsMinimized then
    Self.WindowState := wsNormal;

  FLoading := True;

  FIndex := -1;
  pcNotes.TabIndex := -1;

  // Clear the tab settings if there are any before loading.
  for i := 0 to Pred(Settings.Tabs.Count) do
    DeleteTabSettings(TabName(i));

  // Load the tabs settings if there are any before loading the tabs.
  TMainForm(Owner).LoadTabsSettings;

  // Convert the txt files in the old notes dir
  // to rtf files in the notes dir for this instance.
  ConvertTxtFilesToRtfFiles;

  pcNotes.TabList.Clear;

  // Make the richedit readonly and clear it in case there is no tabs.
  reNotes.ReadOnly := True;
  reNotes.Clear;

  filePaths := TStringList.Create;
  try
    // Get a list of rtf files from the Notes directory.
    FindFiles(filePaths, NotesDir, '*.rtf', False);
    
    for filePath in filePaths do
    begin
      // Add a tab with the base file name.
      i := AddTab(PathExtractFileNameNoExt(filePath));

      // If we come across the last tab then change to it.
      if TabName(i) = Settings.LastTab then
      begin
        tabSettings := GetTabSettings(TabName(i));
        reNotes.SelStart := tabSettings.SelStart;
        reNotes.SelLength := tabSettings.SelLength;
        pcNotes.TabIndex := i;
      end;
    end;
  finally
    filePaths.Free;
  end;

  // If there are not tabs then add a default tab and change to it.
  if pcNotes.TabCount = 0 then
    LoadDefaultTab;
    
  // If there is a filter then reapply it.
  if editFilter.Text <> '' then
    FilterChange(Sender);

  FLoading := False;
end;

{$ENDREGION 'Form Events'}

{$REGION 'Context Menu Events'}

procedure TSharpENotesForm.pmNotesPopup(Sender: TObject);
begin
  // Enable / Disable the context menu items before it is displayed.
  miUndo.Enabled := reNotes.CanUndo;
  miRedo.Enabled := reNotes.CanRedo;
  miCut.Enabled := reNotes.SelText <> '';
  miCopy.Enabled := reNotes.SelText <> '';
  miPaste.Enabled := reNotes.CanPaste;
  miDelete.Enabled := reNotes.SelText <> '';
  miWordWrap.Checked := reNotes.WordWrap;
  miAddTab.Enabled := True;
  miDeleteTab.Enabled := FIndex > -1;
  miEditTab.Enabled := FIndex > -1;
  miAddFromSelectedText.Enabled := reNotes.SelText <> '';
  miAddFromCurrentTab.Enabled := FIndex > -1;
end;

procedure TSharpENotesForm.miUndoClick(Sender: TObject);
begin
  reNotes.Undo;
end;

procedure TSharpENotesForm.miRedoClick(Sender: TObject);
begin
  reNotes.Redo;
end;

procedure TSharpENotesForm.miCutClick(Sender: TObject);
begin
  reNotes.CutToClipboard;
end;

procedure TSharpENotesForm.miAddTabClick(Sender: TObject);
begin
  ShowTabOptions(True, '');
end;

procedure TSharpENotesForm.miDeleteTabClick(Sender: TObject);
begin
  DeleteTab;
end;

procedure TSharpENotesForm.miEditTabClick(Sender: TObject);
begin
  ShowTabOptions(False, TabName(FIndex));
end;

procedure TSharpENotesForm.miAddFromSelectedTextClick(Sender: TObject);
begin
  AddTabWithText(reNotes.SelText);
end;

procedure TSharpENotesForm.miAddFromCurrentTabClick(Sender: TObject);
begin
  AddTabWithText(reNotes.Text);
end;

procedure TSharpENotesForm.miCopyClick(Sender: TObject);
begin
  reNotes.CopyToClipboard;
end;

procedure TSharpENotesForm.miPasteClick(Sender: TObject);
begin
  reNotes.PasteFromClipboard;
end;

procedure TSharpENotesForm.miDeleteClick(Sender: TObject);
begin
  reNotes.SelText := '';
end;

procedure TSharpENotesForm.miSelectAllClick(Sender: TObject);
begin
  reNotes.SelectAll;
end;

procedure TSharpENotesForm.miWordWrapClick(Sender: TObject);
begin
  reNotes.WordWrap := miWordWrap.Checked;
end;

procedure TSharpENotesForm.miTextBackColorClick(Sender: TObject);
begin
  ColorDialog.Color := CurrText.BackColor;
  if ColorDialog.Execute(Self.Handle) then
    CurrText.BackColor := ColorDialog.Color;
end;

{$ENDREGION 'Context Menu Events'}

{$REGION 'Filter Dropdown Menu Events'}

procedure TSharpENotesForm.miFilterNamesClick(Sender: TObject);
var
  i: Integer;
begin
  if editFilter.Text = '' then Exit;

  // Loop over the tabs and see if it's Name contains the filter.
  for i := 0 to Pred(pcNotes.TabCount) do
    pcNotes.TabItems.Item[i].Visible := TabNameContainsFilterText(i);
end;

procedure TSharpENotesForm.miFilterTagsClick(Sender: TObject);
var
  i: Integer;
begin
  if editFilter.Text = '' then Exit;

  // Loop over the tabs and see if it's Tags contains the filter.
  for i := 0 to Pred(pcNotes.TabCount) do
    pcNotes.TabItems.Item[i].Visible := TabTagsContainsFilterText(i);
end;

procedure TSharpENotesForm.miFilterTextClick(Sender: TObject);
var
  i: Integer;
begin
  if editFilter.Text = '' then Exit;
  
  // Loop over the tabs and see if it's Text contains the filter.
  for i := 0 to Pred(pcNotes.TabCount) do
    pcNotes.TabItems.Item[i].Visible := TabTextContainsFilterText(i);
end;

procedure TSharpENotesForm.miFilterNamesAndTagsClick(Sender: TObject);
var
  i: Integer;
begin
  if editFilter.Text = '' then Exit;

  // Loop over the tabs and see if it's Name or Tags contains the filter.
  for i := 0 to Pred(pcNotes.TabCount) do
    pcNotes.TabItems.Item[i].Visible := (TabNameContainsFilterText(i) or TabTagsContainsFilterText(i));
end;

procedure TSharpENotesForm.miFilterNamesAndTextClick(Sender: TObject);
var
  i: Integer;
begin
  if editFilter.Text = '' then Exit;

  // Loop over the tabs and see if it's Name or Text contains the filter.
  for i := 0 to Pred(pcNotes.TabCount) do
    pcNotes.TabItems.Item[i].Visible := (TabNameContainsFilterText(i) or TabTextContainsFilterText(i));
end;

procedure TSharpENotesForm.miFilterTagsAndTextClick(Sender: TObject);
var
  i: Integer;
begin
  if editFilter.Text = '' then Exit;

  // Loop over the tabs and see if it's Tags or Text contains the filter.
  for i := 0 to Pred(pcNotes.TabCount) do
  begin
    pcNotes.TabItems.Item[i].Visible := (TabTagsContainsFilterText(i) or TabTextContainsFilterText(i));    
  end;
end;

{$ENDREGION 'Filter Dropdown Menu Events'}

{$REGION 'Page Control Events'}

procedure TSharpENotesForm.pcNotesBtnClick(ASender: TObject;
  const ABtnIndex: Integer);
begin
  case ABtnIndex of
    0: { Add Tab } ShowTabOptions(True, '');
    1: { Delete Tab } if FIndex > -1 then DeleteTab;
    2: { Edit Tab } if FIndex > -1 then ShowTabOptions(False, TabName(FIndex));
  end;
end;

procedure TSharpENotesForm.pcNotesTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
var
  tabSettings : NotesTabSettings;
begin
  if ATabIndex > -1 then
    // Allow input seeing how we have a tab.
    reNotes.ReadOnly := False;
  
  if FIndex <> ATabIndex then
  begin
    // Indicate that we are loading a new file.
    FLoading := True;

    if FIndex > -1 then
    begin
      tabSettings := GetTabSettings(TabName(FIndex));
      tabSettings.SelStart := reNotes.SelStart;
      tabSettings.SelLength := reNotes.SelLength;
    end;

    if ATabIndex > -1 then
    begin
      // Load the new tab.
      reNotes.Lines.LoadFromFile(TabFilePath(ATabIndex));

      tabSettings := GetTabSettings(TabName(ATabIndex));
      reNotes.SelStart := tabSettings.SelStart;
      reNotes.SelLength := tabSettings.SelLength;
    end;

    // Store the new tab index.
    FIndex := ATabIndex;
    
    // Indicate that we are no longer loading a new file.
    FLoading := False;
  end;
end;

{$ENDREGION 'Page Control Events'}

{$REGION 'Helper Methods'}

function TSharpENotesForm.NotesDir;
begin
  Result := Settings.Directory + '\';  
end;

function TSharpENotesForm.GetSettings;
begin
  Result := TMainForm(Owner).Settings;
end;

procedure TSharpENotesForm.ConvertTxtFilesToRtfFiles;
var
  filePaths: TStringList;
  filePath: string;
begin
  filePaths := TStringList.Create;
  try
    // Get a list of txt files from the Notes directory.
    FindFiles(filePaths, NotesDir, '*.txt', False);

    for filepath in filePaths do
    begin
      // Convert any *.txt files to *.rtf
      with TJvRichEdit.Create(hiddenPanel) do
      try
        Parent := hiddenPanel;
        Visible := False;
        // Load the text file to be converted.
        Lines.LoadFromFile(filePath);
        // Save the text file as an rtf.
        Lines.SaveToFile(TabFilePath(PathExtractFileNameNoExt(filePath)));
        // Delete the text file now that it is converted.
        DeleteFile(filePath);
      finally
        Free;
      end;
    end;
  finally
    filePaths.Free;
  end;
end;

function TSharpENotesForm.GetTabSettings(Name: string) : NotesTabSettings;
begin
  // If the tab does not exist in the settings then add a new one.
  if Settings.Tabs.IndexOf(Name) = -1 then
    Settings.Tabs.AddObject(Name, NotesTabSettings.Create(Name));

  Result := NotesTabSettings(Settings.Tabs.Objects[Settings.Tabs.IndexOf(Name)]);
end;

procedure TSharpENotesForm.DeleteTabSettings(Name: string);
begin
  // Free the tab settings object before we delete the tab from the list.
  Settings.Tabs.Objects[Settings.Tabs.IndexOf(Name)].Free;
  Settings.Tabs.Delete(Settings.Tabs.IndexOf(Name));
end;

procedure TSharpENotesForm.LoadDefaultTab;
begin
  // Create the default tab file.
  with TJvRichEdit.Create(hiddenPanel) do
  try
    Parent := hiddenPanel;
    Visible := False;
    Lines.SaveToFile(TabFilePath('My Notes'));
  finally
    Free;
  end;

  // Create a tab with the default settings and change to it.
  pcNotes.TabIndex := AddTab('My Notes');
end;

function TSharpENotesForm.AddTab(Name: string) : Integer;
var
  i: Integer;
  tab: TTabItem;
  tabSettings : NotesTabSettings;
begin
  Result := -1;

  if Name = '' then Exit;

  // TODO: Add TabExists method to the page control.
  for i := 0 to Pred(pcNotes.TabCount) do
  begin
    if TabName(i) = Name then Exit;
  end;

  tab := pcNotes.TabList.Add;
  tabSettings := GetTabSettings(Name);
  tab.Caption := tabSettings.Name;
  tab.ImageIndex := tabSettings.IconIndex;

  Result := tab.Index;
end;

procedure TSharpENotesForm.DeleteTab;
var
  empty : Boolean;
begin
  // If there are no tabs then there is nothing to delete.
  if pcNotes.TabCount = 0 then Exit;

  empty := False;
  if (reNotes.Lines.Count = 0) or
    ((reNotes.Lines.Count = 1) and (length(Trim(reNotes.Lines[0])) = 0)) then
    empty := True;

  if not empty then
    if MessageBox(self.Handle,
      PChar('The tab you are about to close is not empty!' + #10#13 +
      '(It will be recoverable from the recycle bin.)' + #10#13 +
      'Close it anyway?'),
      'Closing Tab...', MB_YESNO) = IDYES then
      empty := True;

  if empty then
  begin
    if FileExists(TabFilePath(FIndex)) then
      FileDelete(TabFilePath(FIndex), True);

    // Delete the tab from the settings list.
    DeleteTabSettings(TabName(FIndex));
    
    // Remove the current tab from the list.
    pcNotes.TabList.Delete(pcNotes.TabItems.Item[FIndex]);

    // Set the saved index to -1 so that when we change tabs
    // we won't try and save the tab that was deleted.
    FIndex := -1;
    pcNotes.TabIndex := -1;

    // Clear the notes as well.
    reNotes.Lines.Clear;
    // Only allow input when there is a tab.
    reNotes.ReadOnly := True;

    // Save the tabs settings and send an update to other notes modules.
    TMainForm(Owner).SaveTabsSettings;
    TMainForm(Owner).SendUpdateNotes;
  end;
end;

function TSharpENotesForm.TabName(Index: Integer) : string;
begin
  Result := pcNotes.TabItems.Item[Index].Caption;
end;

function TSharpENotesForm.TabFilePath(Index: Integer) : string;
begin
  Result := NotesDir + TabName(Index) + '.rtf';
end;

function TSharpENotesForm.TabFilePath(Name: string) : string;
begin
  Result := NotesDir + Name + '.rtf';
end;

function TSharpENotesForm.TabNameContainsFilterText(Index: Integer) : Boolean;
begin
  // Check if the tab index contains the text in the filter.
  Result := AnsiContainsText(pcNotes.TabItems.Item[Index].Caption, editFilter.Text);
end;

function TSharpENotesForm.TabTagsContainsFilterText(Index: Integer) : Boolean;
var
  tabSettings: NotesTabSettings;
begin
  tabSettings := GetTabSettings(TabName(Index));
  // Check if the tab tags contains the text in the filter.
  Result := AnsiContainsText(tabSettings.Tags, editFilter.Text);
end;

function TSharpENotesForm.TabTextContainsFilterText(Index: Integer) : Boolean;
begin
  // Check if the tab text contains the text in the filter.
  with TJvRichEdit.Create(hiddenPanel) do
  try
    Parent := hiddenPanel;
    Visible := False;
    Lines.LoadFromFile(TabFilePath(Index));
    Result := AnsiContainsText(Lines.Text, editFilter.Text);
  finally
    Free;
  end;
end;

function TSharpENotesForm.IsReadOnly(FilePath: string) : Boolean;
var
  Attributes : Integer;
begin
  Attributes := FileGetAttr(FilePath);
  Result := (Attributes and faReadOnly > 0);
end;

{$ENDREGION 'Helper Methods'}

end.
