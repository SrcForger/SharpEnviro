object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Keyboard Layout Module - Settings'
  ClientHeight = 112
  ClientWidth = 237
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
  object Button1: TButton
    Left = 74
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 154
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cb_dispicon: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Display Icon'
    TabOrder = 2
  end
  object cb_threelettercode: TCheckBox
    Left = 8
    Top = 40
    Width = 177
    Height = 17
    Caption = 'Use Three Letter Keyboard Code '
    TabOrder = 3
  end
end
