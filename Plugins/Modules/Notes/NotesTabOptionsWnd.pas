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

unit NotesTabOptionsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvExControls, JvXPCore, JvXPButtons, ImgList,
  PngImageList, JvExForms, JvCustomItemViewer, JvImageListViewer, ComCtrls,
  JvOwnerDrawViewer, JvXPCheckCtrls, JclAnsiStrings;

type
  TTabOptionsForm = class(TForm)
    editName: TLabeledEdit;
    editTags: TLabeledEdit;
    btnOk: TJvXPButton;
    btnCancel: TJvXPButton;
    ilvIcon: TJvImageListViewer;
    lblIcon: TLabel;
    chkReadOnly: TJvXPCheckbox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure editNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure ilvIconDrawItem(Sender: TObject; Index: Integer;
      State: TCustomDrawState; Canvas: TCanvas; ItemRect, TextRect: TRect);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FOriginalTabName: string;
    
  public
  end;

var
  TabOptionsForm: TTabOptionsForm;

implementation

uses NotesWnd;

{$R *.dfm}

procedure TTabOptionsForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TTabOptionsForm.btnOkClick(Sender: TObject);
begin
  // Trim the name.
  editName.Text := Trim(editName.Text);

  // If the name is empty then we cannot save the tab.
  if editName.Text = '' then
  begin
    MessageBox(Handle, 'Please enter a valid name for the tab.', 'Name Invalid', MB_OK);
    Exit;
  end;

  if FOriginalTabName <> editName.Text then
    // If the filename we need to create already exists then we cannont save the tab.
    if FileExists(TSharpENotesForm(Owner).TabFilePath(editName.Text)) then
    begin
      MessageBox(Handle, 'Another Notes tab with the same name already exists.', 'Name Invalid', MB_OK);
      Exit;
    end;

  ModalResult := mrOk;
end;

procedure TTabOptionsForm.editNameKeyPress(Sender: TObject; var Key: Char);
var
  Handled : Boolean;
begin
  Handled := True;
  
  case Key of
    // Do not allow these to be entered
    '"','<','>','|','/','\','*','?',':' : ;
    // The user pressed the enter key so raise the ok button click event.
    #13 : btnOk.Click;
  else
    Handled := False;
  end;

  if Handled then
    // Handle the keypress by changing the key.
    Key := #0;
end;

procedure TTabOptionsForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = AnsiEscape then
  begin
    ModalResult := mrCancel;
    Close;
  end;
end;

procedure TTabOptionsForm.FormShow(Sender: TObject);
begin
  // Store the original tab name so we can see if it changed later.
  FOriginalTabName := editName.Text;
end;

procedure TTabOptionsForm.ilvIconDrawItem(Sender: TObject; Index: Integer;
  State: TCustomDrawState; Canvas: TCanvas; ItemRect, TextRect: TRect);
begin
  if ( NotesForm <> nil ) and (Index < NotesForm.pilTabImages.Count) then begin

    if [cdsSelected, cdsHot] * State <> [] then begin
      NotesForm.pilTabImages.Draw(Canvas,ItemRect.Left+1,ItemRect.Top+1,Index);
      Canvas.Rectangle(ItemRect);
    end else begin
      NotesForm.pilTabImages.Draw(Canvas,ItemRect.Left+1,ItemRect.Top+1,Index);
    end;
  end;
end;

end.
