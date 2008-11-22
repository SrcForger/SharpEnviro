object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 295
  ClientWidth = 766
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 756
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Virtual desktop count'
    Description = 
      'Define how many virtual desktops should be available. Requires V' +
      'WM service active.'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object pnlGrid: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 47
    Width = 751
    Height = 21
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object sgbVwmCount: TSharpeGaugeBox
      Left = 0
      Top = 0
      Width = 250
      Height = 21
      ParentBackground = False
      Min = 2
      Max = 12
      Value = 4
      Prefix = 'Desktops: '
      Description = 'Desktop count'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgbVwmCountChangeValue
      BackgroundColor = clWindow
    end
  end
  object SharpECenterHeader2: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 78
    Width = 756
    Height = 37
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Focus top-most window'
    Description = 
      'Enable this option to focus and enable the top most window after' +
      ' switching to another desktop.'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object chkFocusTopMost: TJvXPCheckbox
    AlignWithMargins = True
    Left = 3
    Top = 125
    Width = 758
    Height = 17
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Caption = 'Enable focusing of top most windows'
    TabOrder = 3
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = SettingsChanged
  end
  object SharpECenterHeader3: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 152
    Width = 756
    Height = 37
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Follow window focus'
    Description = 
      'Enable this option to always switch to the virtual desktop on wh' +
      'ich an application or window is activated (for example by Alt + ' +
      'Tab). '
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object chkFollowFocus: TJvXPCheckbox
    AlignWithMargins = True
    Left = 3
    Top = 199
    Width = 758
    Height = 17
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Caption = 'Enable follow window focus'
    TabOrder = 5
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = SettingsChanged
  end
  object SharpECenterHeader4: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 226
    Width = 756
    Height = 37
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Virtual desktop notifications'
    Description = 
      'Show a notification on the screen with the current desktop numbe' +
      'r when the virtual desktop is changed.'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    ExplicitLeft = 10
  end
  object chkNotifications: TJvXPCheckbox
    AlignWithMargins = True
    Left = 3
    Top = 273
    Width = 758
    Height = 17
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Enable display of notifications'
    TabOrder = 7
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = SettingsChanged
  end
end
