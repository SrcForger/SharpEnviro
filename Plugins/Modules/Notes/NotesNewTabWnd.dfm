object NotesNewTabForm: TNotesNewTabForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Enter the name for the new Notes tab'
  ClientHeight = 72
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object edit_name: TEdit
    Left = 8
    Top = 8
    Width = 249
    Height = 21
    TabOrder = 0
    Text = 'My Notes'
    OnKeyPress = edit_nameKeyPress
  end
  object btn_ok: TButton
    Left = 96
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btn_okClick
  end
  object btn_cancel: TButton
    Left = 184
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btn_cancelClick
  end
end
