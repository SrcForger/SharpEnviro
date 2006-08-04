object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Task Module Settings'
  ClientHeight = 152
  ClientWidth = 416
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
    Width = 49
    Height = 13
    Caption = 'Task Style'
  end
  object Button1: TButton
    Left = 256
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 336
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cb_tsfull: TRadioButton
    Left = 8
    Top = 24
    Width = 113
    Height = 17
    Caption = 'Full'
    TabOrder = 2
  end
  object cb_tscompact: TRadioButton
    Left = 8
    Top = 40
    Width = 113
    Height = 17
    Caption = 'Compact'
    TabOrder = 3
  end
  object cb_tsminimal: TRadioButton
    Left = 8
    Top = 56
    Width = 113
    Height = 17
    Caption = 'Minimal'
    TabOrder = 4
  end
  object cb_filter: TCheckBox
    Left = 264
    Top = 8
    Width = 145
    Height = 17
    Caption = 'Filter Tasks (Display only)'
    TabOrder = 5
  end
  object cb_maximized: TCheckBox
    Left = 275
    Top = 24
    Width = 97
    Height = 17
    Caption = 'Maximized'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 6
  end
  object cb_minimized: TCheckBox
    Left = 275
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Minimized'
    TabOrder = 7
  end
  object cb_visible: TCheckBox
    Left = 275
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Visible'
    TabOrder = 8
  end
  object Panel1: TPanel
    Left = 96
    Top = 0
    Width = 145
    Height = 89
    BevelOuter = bvNone
    TabOrder = 9
    object cb_sort: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Sort Tasks'
      TabOrder = 0
    end
    object rb_caption: TRadioButton
      Left = 16
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Caption'
      TabOrder = 1
    end
    object rb_wndclassname: TRadioButton
      Left = 16
      Top = 40
      Width = 113
      Height = 17
      Caption = 'Window Class Name'
      TabOrder = 2
    end
    object rb_timeadded: TRadioButton
      Left = 16
      Top = 56
      Width = 113
      Height = 17
      Caption = 'Time added'
      TabOrder = 3
    end
    object rb_icon: TRadioButton
      Left = 16
      Top = 72
      Width = 113
      Height = 17
      Caption = 'Icon'
      Checked = True
      TabOrder = 4
      TabStop = True
    end
  end
  object CheckBox1: TCheckBox
    Left = 275
    Top = 72
    Width = 97
    Height = 17
    Caption = 'Special Filter'
    TabOrder = 10
  end
  object Button3: TButton
    Left = 360
    Top = 72
    Width = 49
    Height = 22
    Caption = 'Setup'
    TabOrder = 11
    OnClick = Button3Click
  end
  object XPManifest1: TXPManifest
    Left = 16
    Top = 88
  end
end
