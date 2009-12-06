object frmAlarmClock: TfrmAlarmClock
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmAlarmClock'
  ClientHeight = 333
  ClientWidth = 421
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 411
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Global Settings'
    Description = 'Define the length of timeout and snooze'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object SharpECenterHeader2: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 106
    Width = 411
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Time Settings'
    Description = 'Configure when the alarm should start'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object pnlBottom: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 153
    Width = 406
    Height = 95
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 2
    object Label5: TLabel
      Left = 0
      Top = 82
      Width = 53
      Height = 13
      Caption = 'Sound File:'
    end
    object Label6: TLabel
      Left = 2
      Top = 23
      Width = 24
      Height = 13
      Caption = 'YYYY'
    end
    object Label7: TLabel
      Left = 51
      Top = 23
      Width = 16
      Height = 13
      Caption = 'MM'
    end
    object Label8: TLabel
      Left = 95
      Top = 23
      Width = 14
      Height = 13
      Caption = 'DD'
    end
    object Label9: TLabel
      Left = 167
      Top = 23
      Width = 14
      Height = 13
      Caption = 'HH'
    end
    object Label10: TLabel
      Left = 207
      Top = 23
      Width = 16
      Height = 13
      Caption = 'MM'
    end
    object Label11: TLabel
      Left = 247
      Top = 23
      Width = 12
      Height = 13
      Caption = 'SS'
    end
    object sgbTimeDay: TSharpeGaugeBox
      AlignWithMargins = True
      Left = 95
      Top = 39
      Width = 42
      Height = 21
      ParentBackground = False
      TabOrder = 3
      Min = 0
      Max = 31
      Value = 0
      Description = 'Adjust to set the transparency'
      PopPosition = ppBottom
      PercentDisplay = False
      Formatting = '%.2d'
      OnChangeValue = sgbOnChangeValue
      BackgroundColor = clWindow
    end
    object sgbTimeHour: TSharpeGaugeBox
      Left = 167
      Top = 39
      Width = 34
      Height = 21
      ParentBackground = False
      TabOrder = 4
      Min = 0
      Max = 23
      Value = 0
      Description = 'Adjust to set the transparency'
      PopPosition = ppBottom
      PercentDisplay = False
      Formatting = '%.2d'
      OnChangeValue = sgbOnChangeValue
      BackgroundColor = clWindow
    end
    object sgbTimeMinute: TSharpeGaugeBox
      Left = 207
      Top = 39
      Width = 34
      Height = 21
      ParentBackground = False
      TabOrder = 5
      Min = 0
      Max = 59
      Value = 0
      Description = 'Adjust to set the transparency'
      PopPosition = ppBottom
      PercentDisplay = False
      Formatting = '%.2d'
      OnChangeValue = sgbOnChangeValue
      BackgroundColor = clWindow
    end
    object sgbTimeMonth: TSharpeGaugeBox
      AlignWithMargins = True
      Left = 51
      Top = 39
      Width = 38
      Height = 21
      ParentBackground = False
      TabOrder = 2
      Min = 0
      Max = 12
      Value = 0
      Description = 'Adjust to set the transparency'
      PopPosition = ppBottom
      PercentDisplay = False
      Formatting = '%.2d'
      OnChangeValue = sgbOnChangeValue
      BackgroundColor = clWindow
    end
    object sgbTimeSecond: TSharpeGaugeBox
      Left = 247
      Top = 39
      Width = 34
      Height = 21
      ParentBackground = False
      TabOrder = 6
      Min = 0
      Max = 59
      Value = 0
      Description = 'Adjust to set the transparency'
      PopPosition = ppBottom
      PercentDisplay = False
      Formatting = '%.2d'
      OnChangeValue = sgbOnChangeValue
      BackgroundColor = clWindow
    end
    object sgbTimeYear: TSharpeGaugeBox
      AlignWithMargins = True
      Left = 2
      Top = 39
      Width = 43
      Height = 21
      ParentBackground = False
      TabOrder = 1
      Min = 0
      Max = 3000
      Value = 0
      Description = 'Adjust to set the transparency'
      PopPosition = ppBottom
      PercentDisplay = False
      Formatting = '%.4d'
      OnChangeValue = sgbOnChangeValue
      BackgroundColor = clWindow
    end
    object cbAutostart: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 161
      Height = 17
      Caption = 'Auto Enabled'
      TabOrder = 0
      OnClick = cbOnChange
    end
    object btnSoundBrowse: TButton
      Left = 271
      Top = 74
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 8
      OnClick = btnSoundBrowseClick
    end
    object edtSound: TEdit
      Left = 64
      Top = 74
      Width = 201
      Height = 21
      TabOrder = 7
      Text = 'Default'
      OnKeyPress = edtOnChange
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 47
    Width = 406
    Height = 21
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Top = 8
      Width = 45
      Height = 13
      Caption = 'Timeout: '
    end
    object Label3: TLabel
      Left = 160
      Top = 8
      Width = 39
      Height = 13
      Caption = 'seconds'
    end
    object edtTimeout: TEdit
      Left = 64
      Top = 0
      Width = 90
      Height = 21
      TabOrder = 0
      Text = '60'
      OnKeyPress = edtNumOnChange
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 76
    Width = 406
    Height = 25
    Margins.Left = 5
    Margins.Top = 8
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object Label2: TLabel
      Left = 0
      Top = 9
      Width = 39
      Height = 13
      Caption = 'Snooze:'
    end
    object Label4: TLabel
      Left = 160
      Top = 9
      Width = 39
      Height = 13
      Caption = 'seconds'
    end
    object edtSnooze: TEdit
      Left = 64
      Top = 1
      Width = 90
      Height = 21
      TabOrder = 0
      Text = '540'
      OnKeyPress = edtNumOnChange
    end
  end
end
