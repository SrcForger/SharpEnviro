object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmDeskAreaSettings'
  ClientHeight = 175
  ClientWidth = 506
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
    AlignWithMargins = True
    Left = 5
    Top = 47
    Width = 496
    Height = 17
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object cb_automode: TCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 429
      Height = 17
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Automated Mode'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cb_automodeClick
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 121
    Width = 496
    Height = 48
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    object sgb_left: TSharpeGaugeBox
      Left = 0
      Top = 0
      Width = 130
      Height = 21
      ParentBackground = False
      Min = -32
      Max = 512
      Value = 0
      Prefix = 'Left: '
      Suffix = ' px'
      Description = 'Left Offset'
      PopPosition = ppBottom
      PercentDisplay = False
      OnChangeValue = sgb_leftChangeValue
      BackgroundColor = clWindow
    end
    object sgb_top: TSharpeGaugeBox
      Left = 136
      Top = 0
      Width = 130
      Height = 21
      ParentBackground = False
      Min = -32
      Max = 512
      Value = 0
      Prefix = 'Top: '
      Suffix = ' px'
      Description = 'Top Offset'
      PopPosition = ppBottom
      PercentDisplay = False
      OnChangeValue = sgb_leftChangeValue
      BackgroundColor = clWindow
    end
    object sgb_bottom: TSharpeGaugeBox
      Left = 136
      Top = 27
      Width = 130
      Height = 21
      ParentBackground = False
      Min = -32
      Max = 512
      Value = 0
      Prefix = 'Bottom: '
      Suffix = ' px'
      Description = 'Bottom Offset'
      PopPosition = ppBottom
      PercentDisplay = False
      OnChangeValue = sgb_leftChangeValue
      BackgroundColor = clWindow
    end
    object sgb_right: TSharpeGaugeBox
      Left = 0
      Top = 27
      Width = 130
      Height = 21
      ParentBackground = False
      Min = -32
      Max = 512
      Value = 0
      Prefix = 'Right: '
      Suffix = ' px'
      Description = 'Right Offset'
      PopPosition = ppBottom
      PercentDisplay = False
      OnChangeValue = sgb_leftChangeValue
      BackgroundColor = clWindow
    end
  end
  object SharpECenterHeader4: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 74
    Width = 496
    Height = 37
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'DeskArea Offsets'
    Description = 
      'Define the constraints of the desktop area. You may also tweak t' +
      'he automated mode'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 496
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Automated Mode'
    Description = 
      'Define whether the constraints of the desktop area is determined' +
      ' by the position of the bars'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
end
