object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 325
  ClientWidth = 532
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SharpECenterHeader2: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 10
    Width = 522
    Height = 37
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'On Screen Notification'
    Description = 
      'Enable this option if you want a text to display on keyboard eve' +
      'nts'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object chkShowOSD: TJvXPCheckbox
    AlignWithMargins = True
    Left = 3
    Top = 57
    Width = 524
    Height = 23
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Caption = 'Enable on screen notification'
    TabOrder = 1
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = SettingsChanged
  end
  object Panel1: TPanel
    Left = 0
    Top = 80
    Width = 532
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 2
    object Label1: TLabel
      Left = 288
      Top = 14
      Width = 139
      Height = 17
      AutoSize = False
      Caption = 'Vertical Position:'
      Color = clWindow
      ParentColor = False
      WordWrap = True
    end
    object Label2: TLabel
      Left = 5
      Top = 14
      Width = 139
      Height = 17
      AutoSize = False
      Caption = 'Horizontal Position:'
      Color = clWindow
      ParentColor = False
      WordWrap = True
    end
    object Label3: TLabel
      Left = 3
      Top = 65
      Width = 139
      Height = 17
      AutoSize = False
      Caption = 'Size Modification:'
      Color = clWindow
      ParentColor = False
      WordWrap = True
    end
    object cboVertPos: TComboBox
      Left = 389
      Top = 11
      Width = 111
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ItemIndex = 2
      ParentCtl3D = False
      TabOrder = 1
      Text = 'Bottom'
      OnChange = cboHorizPosChange
      Items.Strings = (
        'Top'
        'Center'
        'Bottom')
    end
    object cboHorizPos: TComboBox
      Left = 122
      Top = 11
      Width = 111
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ItemIndex = 1
      ParentCtl3D = False
      TabOrder = 0
      Text = 'Center'
      OnChange = cboHorizPosChange
      Items.Strings = (
        'Left '
        'Center'
        'Right')
    end
    object sgbOffsetHor: TSharpeGaugeBox
      Left = 122
      Top = 38
      Width = 111
      Height = 21
      ParentBackground = False
      TabOrder = 2
      Min = -100
      Max = 100
      Value = 0
      Prefix = 'Offset: '
      Suffix = ' px'
      Description = 'Adjust horizontal position offset'
      PopPosition = ppBottom
      PercentDisplay = False
      SignDisplay = True
      MaxPercent = 100
      Formatting = '%d'
      OnChangeValue = sgbOffsetHorChangeValue
      BackgroundColor = clWindow
    end
  end
  object sgbOffsetVert: TSharpeGaugeBox
    Left = 389
    Top = 118
    Width = 111
    Height = 21
    ParentBackground = False
    TabOrder = 3
    Min = -100
    Max = 100
    Value = 0
    Prefix = 'Offset: '
    Suffix = ' px'
    Description = 'Adjust horizontal position offset'
    PopPosition = ppBottom
    PercentDisplay = False
    SignDisplay = True
    MaxPercent = 100
    Formatting = '%d'
    OnChangeValue = sgbOffsetHorChangeValue
    BackgroundColor = clWindow
  end
  object sgbFontSize: TSharpeGaugeBox
    Left = 122
    Top = 145
    Width = 111
    Height = 21
    ParentBackground = False
    TabOrder = 4
    Min = -40
    Max = 40
    Value = 0
    Prefix = 'Font Size: '
    Suffix = ' pt'
    Description = 'Adjust horizontal position offset'
    PopPosition = ppBottom
    PercentDisplay = False
    SignDisplay = True
    MaxPercent = 100
    Formatting = '%d'
    OnChangeValue = sgbOffsetHorChangeValue
    BackgroundColor = clWindow
  end
  object Colors: TSharpEColorEditorEx
    AlignWithMargins = True
    Left = 5
    Top = 200
    Width = 522
    Height = 32
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alTop
    AutoSize = True
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWhite
    ParentColor = False
    TabOrder = 5
    Items = <
      item
        Title = 'Color'
        ColorCode = 16777215
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 16777215
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = Colors.Item0
        Tag = 0
      end>
    SwatchManager = SharpESwatchManager1
    OnChangeColor = ColorsChangeColor
    BorderColor = clBlack
    BackgroundColor = clWhite
    BackgroundTextColor = clBlack
    ContainerColor = clBlack
    ContainerTextColor = clBlack
  end
  object chkColor: TJvXPCheckbox
    AlignWithMargins = True
    Left = 3
    Top = 177
    Width = 524
    Height = 23
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Caption = 'Overwrite Color'
    TabOrder = 6
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = SettingsChanged
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 489
    ShowCaptions = True
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = 16709617
    SortMode = sortName
    BorderColor = clBlack
    BackgroundColor = clBlack
    BackgroundTextColor = clBlack
    Left = 488
    Top = 8
  end
end
