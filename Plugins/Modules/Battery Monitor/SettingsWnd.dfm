object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Battery Monitor Settingss'
  ClientHeight = 71
  ClientWidth = 198
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
    Left = 40
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cb_showicon: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Display Icon'
    TabOrder = 2
  end
end
