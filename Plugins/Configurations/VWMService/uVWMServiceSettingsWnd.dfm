object frmVWMSettings: TfrmVWMSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmVWMSettings'
  ClientHeight = 305
  ClientWidth = 428
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 4
    Width = 412
    Height = 13
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 'Desktop Count'
    Transparent = False
    WordWrap = True
    ExplicitLeft = 18
    ExplicitWidth = 56
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 18
    Top = 125
    Width = 402
    Height = 36
    Margins.Left = 18
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Enable this option to make the VWM focus and enable the top most' +
      ' window after switching to another desktop.'
    EllipsisPosition = epEndEllipsis
    Transparent = False
    WordWrap = True
  end
  object Label3: TLabel
    AlignWithMargins = True
    Left = 18
    Top = 188
    Width = 402
    Height = 37
    Margins.Left = 18
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Enable this option to always switch to the virtual monitor on wh' +
      'ich an application or window is activated (for example by Alt + ' +
      'Tab) '
    EllipsisPosition = epEndEllipsis
    Transparent = False
    WordWrap = True
    ExplicitLeft = 23
    ExplicitTop = 179
  end
  object Label5: TLabel
    AlignWithMargins = True
    Left = 18
    Top = 252
    Width = 402
    Height = 37
    Margins.Left = 18
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Show a notification on the screen with the current desktop numbe' +
      'r when the VWM is changed.'
    EllipsisPosition = epEndEllipsis
    Transparent = False
    WordWrap = True
    ExplicitLeft = 23
  end
  object cb_focustopmost: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 101
    Width = 417
    Height = 17
    Margins.Left = 8
    Align = alTop
    Caption = 'Focus Top Most Window'
    TabOrder = 0
    OnClick = cb_focustopmostClick
  end
  object cb_followfocus: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 164
    Width = 417
    Height = 17
    Margins.Left = 8
    Align = alTop
    Caption = 'Follow Window Focus'
    TabOrder = 1
    OnClick = cb_focustopmostClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 17
    Width = 428
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 2
    object Label4: TLabel
      AlignWithMargins = True
      Left = 18
      Top = 4
      Width = 402
      Height = 45
      Margins.Left = 18
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 
        'Select how many virtual monitors you want to use. The Maximum am' +
        'ount of virtual monitors is limited to 12 (while the minimum is ' +
        '2). Disable the VWM.service if you don'#39't want to use virtual mon' +
        'itors.'
      EllipsisPosition = epEndEllipsis
      Transparent = False
      WordWrap = True
    end
    object sgb_vwmcount: TSharpeGaugeBox
      Left = 18
      Top = 52
      Width = 120
      Height = 21
      ParentBackground = False
      Min = 2
      Max = 12
      Value = 4
      Prefix = 'VWMs: '
      Description = 'VWM Count'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgb_vwmcountChangeValue
    end
  end
  object cb_ocd: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 228
    Width = 417
    Height = 17
    Margins.Left = 8
    Align = alTop
    Caption = 'Display VWM Changes'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = cb_focustopmostClick
    ExplicitLeft = 3
  end
end
