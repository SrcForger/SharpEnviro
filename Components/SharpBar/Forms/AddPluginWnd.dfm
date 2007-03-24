object AddPluginForm: TAddPluginForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'AddPluginForm'
  ClientHeight = 244
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 184
    Width = 57
    Height = 13
    Caption = 'Alignment : '
  end
  object list_plugins: TListBox
    Left = 8
    Top = 8
    Width = 201
    Height = 169
    ItemHeight = 13
    TabOrder = 0
  end
  object btn_ok: TButton
    Left = 56
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object btn_cancel: TButton
    Left = 136
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object rb_left: TRadioButton
    Left = 80
    Top = 184
    Width = 49
    Height = 17
    Caption = 'Left'
    Checked = True
    TabOrder = 3
    TabStop = True
  end
  object lb_right: TRadioButton
    Left = 144
    Top = 184
    Width = 49
    Height = 17
    Caption = 'Right'
    TabOrder = 4
  end
end
