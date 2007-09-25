object SharpESrvWizForm: TSharpESrvWizForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SharpE Service Wizard'
  ClientHeight = 315
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblServiceName: TLabel
    Left = 52
    Top = 19
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object lblDescription: TLabel
    Left = 26
    Top = 59
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object lblCopyright: TLabel
    Left = 32
    Top = 99
    Width = 51
    Height = 13
    Caption = 'Copyright:'
  end
  object lblComment: TLabel
    Left = 26
    Top = 216
    Width = 231
    Height = 26
    Caption = 
      '* If you select Actions, Message Handler will be automaticly sel' +
      'ected.'
    WordWrap = True
  end
  object edName: TEdit
    Left = 89
    Top = 16
    Width = 200
    Height = 21
    TabOrder = 0
    Text = 'edName'
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object edDescription: TEdit
    Left = 89
    Top = 56
    Width = 200
    Height = 21
    TabOrder = 1
    Text = 'edDescription'
  end
  object edCopyright: TEdit
    Left = 89
    Top = 96
    Width = 200
    Height = 21
    TabOrder = 2
    Text = 'edCopyright'
  end
  object cbMsgHandler: TCheckBox
    Left = 26
    Top = 176
    Width = 97
    Height = 17
    Caption = 'Message Handler'
    TabOrder = 4
  end
  object cbActions: TCheckBox
    Left = 26
    Top = 144
    Width = 97
    Height = 17
    Caption = 'Actions*'
    TabOrder = 3
    OnClick = cbActionsClick
  end
  object btnOK: TBitBtn
    Left = 52
    Top = 272
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 188
    Top = 272
    Width = 75
    Height = 25
    TabOrder = 6
    Kind = bkCancel
  end
end
