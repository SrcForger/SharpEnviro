object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Notes Module Settings'
  ClientHeight = 175
  ClientWidth = 192
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
    Width = 34
    Height = 13
    Caption = 'Display'
  end
  object Button1: TButton
    Left = 32
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object rb_caption: TRadioButton
    Left = 16
    Top = 24
    Width = 113
    Height = 17
    Caption = 'Caption'
    TabOrder = 2
  end
  object rb_icon: TRadioButton
    Left = 16
    Top = 48
    Width = 113
    Height = 17
    Caption = 'Icon'
    TabOrder = 3
  end
  object rb_cai: TRadioButton
    Left = 16
    Top = 72
    Width = 113
    Height = 17
    Caption = 'Caption and Icon'
    TabOrder = 4
  end
  object cb_aot: TCheckBox
    Left = 8
    Top = 112
    Width = 97
    Height = 17
    Caption = 'Always On Top'
    TabOrder = 5
  end
  object OpenFile: TOpenDialog
    FileName = '*.*'
    Filter = 'All Files|*.*|Applications (*.exe)|*.exe'
    Options = [ofHideReadOnly, ofEnableSizing, ofForceShowHidden]
    Title = 'Select Target File'
    Left = 136
    Top = 96
  end
  object XPManifest1: TXPManifest
    Left = 152
    Top = 24
  end
end
