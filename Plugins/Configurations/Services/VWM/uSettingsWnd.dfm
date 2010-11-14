object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 516
  ClientWidth = 528
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object chkEnable: TJvXPCheckbox
    AlignWithMargins = True
    Left = 3
    Top = 47
    Width = 520
    Height = 17
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 0
    Caption = 'Enable Virtual Desktop'
    TabOrder = 0
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = SettingsChanged
  end
  object pnlEnabled: TPanel
    Left = 0
    Top = 64
    Width = 528
    Height = 449
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 67
    object SharpECenterHeader1: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 10
      Width = 518
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 0
      Title = 'Virtual desktop count'
      Description = 
        'Define how many virtual desktops should be available. Requires V' +
        'WM service active.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      ExplicitLeft = 0
      ExplicitTop = -5
      ExplicitWidth = 516
    end
    object SharpECenterHeader2: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 162
      Width = 518
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
      ExplicitLeft = 6
      ExplicitTop = 4
      ExplicitWidth = 173
    end
    object SharpECenterHeader3: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 236
      Width = 518
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Follow window focus'
      Description = 
        'Switch to the virtual desktop on which an application or window ' +
        'is activated (for example by Alt + Tab). '
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      ExplicitTop = 645
    end
    object SharpECenterHeader4: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 384
      Width = 518
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
      ExplicitLeft = 3
      ExplicitTop = 351
      ExplicitWidth = 516
    end
    object SharpECenterHeader5: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 310
      Width = 518
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Reset on display change'
      Description = 
        'All windows will be moved to the the first virtual desktop when ' +
        'the screen resolution is changed.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      ExplicitTop = 662
    end
    object SharpECenterHeader6: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 88
      Width = 518
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Move Tool Windows'
      Description = 
        'Enable this option if you want tool windows to be also affected ' +
        'by the VWM.'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
      ExplicitLeft = 0
      ExplicitTop = 77
      ExplicitWidth = 516
    end
    object pnlGrid: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 57
      Width = 513
      Height = 21
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 6
      ExplicitTop = 37
      object sgbVwmCount: TSharpeGaugeBox
        Left = 0
        Top = 0
        Width = 250
        Height = 21
        Margins.Top = 0
        ParentBackground = False
        TabOrder = 0
        Min = 2
        Max = 12
        Value = 4
        Prefix = 'Desktops: '
        Description = 'Desktop count'
        PopPosition = ppBottom
        PercentDisplay = False
        MaxPercent = 100
        Formatting = '%d'
        OnChangeValue = sgbVwmCountChangeValue
        BackgroundColor = clWindow
      end
    end
    object chkFocusTopMost: TJvXPCheckbox
      AlignWithMargins = True
      Left = 3
      Top = 209
      Width = 520
      Height = 17
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Enable focusing of top most windows'
      TabOrder = 7
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = SettingsChanged
      ExplicitTop = 176
      ExplicitWidth = 518
    end
    object chkFollowFocus: TJvXPCheckbox
      AlignWithMargins = True
      Left = 3
      Top = 283
      Width = 520
      Height = 17
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Enable follow window focus'
      TabOrder = 8
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = SettingsChanged
      ExplicitLeft = 5
      ExplicitTop = 250
      ExplicitWidth = 518
    end
    object chkNotifications: TJvXPCheckbox
      AlignWithMargins = True
      Left = 3
      Top = 431
      Width = 520
      Height = 17
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Enable display of notifications'
      TabOrder = 9
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = SettingsChanged
      ExplicitTop = 547
    end
    object chkResetOnDisplayChange: TJvXPCheckbox
      AlignWithMargins = True
      Left = 3
      Top = 357
      Width = 520
      Height = 17
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Enable reset on display change'
      TabOrder = 10
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = SettingsChanged
      ExplicitLeft = 6
      ExplicitTop = 324
      ExplicitWidth = 518
    end
    object chkToolWindows: TJvXPCheckbox
      AlignWithMargins = True
      Left = 3
      Top = 135
      Width = 520
      Height = 17
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Move tool windows'
      TabOrder = 11
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = SettingsChanged
      ExplicitLeft = -1
      ExplicitTop = 119
      ExplicitWidth = 518
    end
  end
  object SharpECenterHeader7: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 518
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Virtual desktop'
    Description = 'Configure various virtual desktop options'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    ExplicitLeft = 0
    ExplicitTop = -10
  end
end
