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
    Description = 'Define how long the alarm should sound'
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
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 153
    Width = 406
    Height = 79
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
    object Label6: TLabel
      Left = 2
      Top = 23
      Width = 24
      Height = 13
      Caption = 'YYYY'
    end
    object Label7: TLabel
      Left = 58
      Top = 23
      Width = 16
      Height = 13
      Caption = 'MM'
    end
    object Label8: TLabel
      Left = 110
      Top = 23
      Width = 14
      Height = 13
      Caption = 'DD'
    end
    object Label9: TLabel
      Left = 168
      Top = 23
      Width = 14
      Height = 13
      Caption = 'HH'
    end
    object Label10: TLabel
      Left = 216
      Top = 23
      Width = 16
      Height = 13
      Caption = 'MM'
    end
    object Label11: TLabel
      Left = 264
      Top = 23
      Width = 12
      Height = 13
      Caption = 'SS'
    end
    object Label12: TLabel
      Left = 2
      Top = 66
      Width = 301
      Height = 13
      Caption = 'Note: Setting Year, Month or Date to 0 ignores that parameter'
      Enabled = False
    end
    object sgbTimeDay: TSharpeGaugeBox
      AlignWithMargins = True
      Left = 110
      Top = 39
      Width = 46
      Height = 21
      ParentBackground = False
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
      Left = 168
      Top = 39
      Width = 42
      Height = 21
      ParentBackground = False
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
      Left = 216
      Top = 39
      Width = 42
      Height = 21
      ParentBackground = False
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
      Left = 58
      Top = 39
      Width = 46
      Height = 21
      ParentBackground = False
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
      Left = 264
      Top = 39
      Width = 42
      Height = 21
      ParentBackground = False
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
      Width = 50
      Height = 21
      ParentBackground = False
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
      Left = 1
      Top = 0
      Width = 161
      Height = 17
      Caption = 'Auto Enabled'
      TabOrder = 0
      OnClick = cbOnChange
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
      Top = 4
      Width = 61
      Height = 13
      Caption = 'Silence After'
    end
    object Label3: TLabel
      Left = 171
      Top = 4
      Width = 39
      Height = 13
      Caption = 'seconds'
    end
    object edtTimeout: TEdit
      Left = 75
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
      Left = 2
      Top = 6
      Width = 35
      Height = 13
      Caption = 'Snooze'
    end
    object Label4: TLabel
      Left = 171
      Top = 6
      Width = 39
      Height = 13
      Caption = 'seconds'
    end
    object edtSnooze: TEdit
      Left = 75
      Top = 1
      Width = 90
      Height = 21
      TabOrder = 0
      Text = '540'
      OnKeyPress = edtNumOnChange
    end
  end
  object SharpECenterHeader3: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 237
    Width = 411
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Alarm Sound'
    Description = 'Select an alarm sound'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    ExplicitLeft = 0
    ExplicitTop = 244
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 284
    Width = 406
    Height = 44
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 6
    ExplicitLeft = 10
    ExplicitTop = 301
    object Label5: TLabel
      Left = 2
      Top = 26
      Width = 16
      Height = 13
      Caption = 'File'
    end
    object edtSound: TEdit
      Left = 48
      Top = 23
      Width = 201
      Height = 21
      TabOrder = 0
      Text = 'Default'
      OnKeyPress = edtOnChange
    end
    object btnSoundBrowse: TButton
      Left = 255
      Top = 22
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = btnSoundBrowseClick
    end
    object cbDefaultSound: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 161
      Height = 17
      Caption = 'Use Default Sound'
      TabOrder = 2
      OnClick = cbOnChange
    end
  end
end
