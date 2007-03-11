{
Source Name: uHotkeyServiceEditWnd
Description: Hotkey Item Edit Window
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

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

unit uHotkeyServiceItemEditWnd;

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
  ExtCtrls,
  StdCtrls,
  Buttons,
  ComCtrls,
  jpeg,
  ImgList,

  // JVCL
  JvTabBar,
  JvPageList,
  JvExControls,
  JvComponent,

  // Project
  uScHotkeyEdit,

  // JCL
  jclStrings,
  SharpDialogs,
  SharpApi,

  // PNG Image
  pngimage, JvExExtCtrls, JvShape, JvComponentBase,
  SharpEBaseControls, SharpEEdit, TranComp, JvLabel, PngImageList, PngBitBtn,
  JvExStdCtrls, JvMemo;

type
  TFrmHotkeyEdit = class(TForm)
    pnl1: TPanel;
    Panel1: TPanel;
    pMain: TJvPageList;
    spEdit: TJvStandardPage;
    spDelete: TJvStandardPage;
    cmdBrowse: TPngBitBtn;
    Label3: TJvLabel;
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    edHotkey: TScHotkeyEdit;
    Button1: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);

    procedure cmdbrowseclick(Sender: TObject);


  private
    { Private declarations }

  public
    { Public declarations }
    SelectedText: string;
    procedure InitUi(AEditMode: TSCE_EDITMODE);
    function ValidateEdit(AEditMode: TSCE_EDITMODE):Boolean;
    procedure ShowValidationErrors(AEditMode: TSCE_EDITMODE);
    function Save(AApply: Boolean;AEditMode: TSCE_EDITMODE):Boolean;
  end;

var
  FrmHotkeyEdit: TFrmHotkeyEdit;
  DelimitedList: WideString;
  SelectedItem, SelectedGroup: Integer;

const
  piFile = 0;
  piAction = 1;

implementation

uses
  uHotkeyServiceItemListWnd;

{$R *.dfm}

procedure TFrmHotkeyEdit.cmdbrowseclick(Sender: TObject);
begin
  edCommand.Text := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);
end;

procedure TFrmHotkeyEdit.FormShow(Sender: TObject);
begin
  edCommand.SetFocus;
end;

procedure TFrmHotkeyEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if Key = VK_RETURN then
  //  cmdAddEdit.Click;
end;

procedure TFrmHotkeyEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {if Self.ModalResult <> mrCancel then
  begin
    if mmoCommand.Lines.Text = '' then
    begin
      MessageDlg('Please enter a command to execute, or click Browse for some command options', mtWarning, [mbOK], 0);
      Canclose := False;
      exit;
    end;
    if hkeCommand.Text = '' then
    begin
      MessageDlg('Please assign a hotkey, by pressing the sequence within the hotkey control', mtInformation, [mbOK], 0);
      CanClose := False;
      exit;
    end;
  end;   }
end;

procedure TFrmHotkeyEdit.InitUi(AEditMode: TSCE_EDITMODE);
begin
  Case AEditMode of
    sceAdd: ;
    sceEdit: ;
    sceDelete: ;
  end;
end;

function TFrmHotkeyEdit.ValidateEdit(AEditMode: TSCE_EDITMODE): Boolean;
begin
  Result := True;
end;

function TFrmHotkeyEdit.Save(AApply: Boolean;
  AEditMode: TSCE_EDITMODE): Boolean;
begin
  Result := True;
end;

procedure TFrmHotkeyEdit.ShowValidationErrors(AEditMode: TSCE_EDITMODE);
begin

end;

end.

