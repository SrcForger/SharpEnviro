object frmDASettings: TfrmDASettings
  Left = 0
  Top = 0
  Caption = 'frmDeskAreaSettings'
  ClientHeight = 177
  ClientWidth = 445
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 445
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 0
    object Label4: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 29
      Width = 411
      Height = 26
      Margins.Left = 26
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 
        'Enable this option to make the deskarea service automatically ad' +
        'just the size of the desktop area based on the position of your ' +
        'SharpBars.'
      EllipsisPosition = epEndEllipsis
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = False
      WordWrap = True
      ExplicitTop = 126
      ExplicitWidth = 360
    end
    object cb_automode: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 429
      Height = 17
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Automated Mode'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cb_automodeClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 65
    Width = 445
    Height = 96
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
    object Label2: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 4
      Width = 433
      Height = 13
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'Desk Area Offsets'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = False
      WordWrap = True
      ExplicitWidth = 88
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 21
      Width = 411
      Height = 26
      Margins.Left = 26
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 
        'Use the sliders to adjust the size of the desktop area. If the a' +
        'uomated mode is enabled then the values will be added to the aut' +
        'omatically generated desk area.'
      EllipsisPosition = epEndEllipsis
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = False
      WordWrap = True
      ExplicitTop = 126
      ExplicitWidth = 360
    end
    object sgb_left: TSharpeGaugeBox
      Left = 26
      Top = 58
      Width = 90
      Height = 21
      Min = 0
      Max = 512
      Value = 0
      Prefix = 'Left: '
      Suffix = 'px'
      Description = 'Grid Height'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgb_leftChangeValue
    end
    object sgb_top: TSharpeGaugeBox
      Left = 122
      Top = 58
      Width = 90
      Height = 21
      Min = 0
      Max = 512
      Value = 0
      Prefix = 'Top: '
      Suffix = 'px'
      Description = 'Grid Width'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgb_leftChangeValue
    end
    object sgb_bottom: TSharpeGaugeBox
      Left = 314
      Top = 58
      Width = 90
      Height = 21
      Min = 0
      Max = 512
      Value = 0
      Prefix = 'Bottom: '
      Suffix = 'px'
      Description = 'Grid Width'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgb_leftChangeValue
    end
    object sgb_right: TSharpeGaugeBox
      Left = 218
      Top = 58
      Width = 90
      Height = 21
      Min = 0
      Max = 512
      Value = 0
      Prefix = 'Right: '
      Suffix = 'px'
      Description = 'Grid Width'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgb_leftChangeValue
    end
  end
end
