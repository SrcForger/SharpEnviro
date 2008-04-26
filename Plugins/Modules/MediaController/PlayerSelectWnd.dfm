object PlayerSelectForm: TPlayerSelectForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Selected Media Player not found'
  ClientHeight = 80
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 264
    Height = 13
    Caption = 'Please chose the location of the selected media player:'
  end
  object edit_player: TJvFilenameEdit
    Left = 8
    Top = 24
    Width = 289
    Height = 21
    AcceptFiles = False
    AddQuotes = False
    Flat = False
    ParentFlat = False
    Filter = 'Applications (*.exe)|*.exe'
    TabOrder = 0
  end
  object btn_ok: TButton
    Left = 141
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btn_okClick
  end
  object btn_cancel: TButton
    Left = 222
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btn_cancelClick
  end
end
