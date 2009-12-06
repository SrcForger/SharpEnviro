object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 354
  ClientWidth = 600
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
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 590
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Menu Icons'
    Description = 
      'Define whether to display menu icons. Disabling will improve men' +
      'u performance.'
    TitleColor = clWindowText
    DescriptionColor = clGrayText
    Align = alTop
  end
  object chkUseIcons: TJvXPCheckbox
    AlignWithMargins = True
    Left = 5
    Top = 47
    Width = 590
    Height = 17
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Caption = 'Enable menu icons'
    TabOrder = 0
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = chkUseIconsClick
    ExplicitLeft = 0
  end
  object pnlGenericIcons: TPanel
    Left = 0
    Top = 64
    Width = 600
    Height = 74
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    object schGenericIcons: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 10
      Width = 590
      Height = 37
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 10
      Title = 'Generic Icons'
      Description = 
        'Define whether to use generic icons for common types. Enabling w' +
        'ill improve menu performance.'
      TitleColor = clWindowText
      DescriptionColor = clGrayText
      Align = alTop
    end
    object chkUseGenericIcons: TJvXPCheckbox
      AlignWithMargins = True
      Left = 5
      Top = 57
      Width = 590
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Enable generic icons'
      TabOrder = 1
      Align = alTop
      OnClick = chkUseIconsClick
    end
  end
  object SharpECenterHeader4: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 148
    Width = 590
    Height = 37
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Menu Wrapping'
    Description = 
      'Define whether to wrap a large menu into smaller sub-menus, if t' +
      'here are too many menu items.'
    TitleColor = clWindowText
    DescriptionColor = clGrayText
    Align = alTop
  end
  object chkMenuWrapping: TJvXPCheckbox
    AlignWithMargins = True
    Left = 5
    Top = 195
    Width = 590
    Height = 17
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Caption = 'Enable menu wrapping'
    TabOrder = 2
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = chkMenuWrappingClick
    ExplicitLeft = 10
    ExplicitTop = 192
  end
  object Panel1: TPanel
    Left = 0
    Top = 212
    Width = 600
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 3
    object Label1: TLabel
      Left = 176
      Top = 12
      Width = 106
      Height = 13
      AutoSize = False
      Caption = 'Sub-Menu Position:'
      Color = clWindow
      ParentColor = False
      WordWrap = True
    end
    object sgbWrapCount: TSharpeGaugeBox
      Left = 5
      Top = 8
      Width = 149
      Height = 21
      ParentBackground = False
      Min = 5
      Max = 100
      Value = 25
      Prefix = 'Items to wrap: '
      Description = 'Item wrap count'
      PopPosition = ppBottom
      PercentDisplay = False
      Formatting = '%d'
      OnChangeValue = sgbWrapCountChangeValue
      BackgroundColor = clWindow
    end
    object cboWrapPos: TComboBox
      Left = 288
      Top = 8
      Width = 85
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 3
      Text = 'Bottom'
      OnChange = cboWrapPosChange
      Items.Strings = (
        'Bottom'
        'Top')
    end
  end
  object SharpECenterHeader3: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 253
    Width = 590
    Height = 37
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Auto-Hide'
    Description = 
      'Define whether the menu should auto-hide when you leave the wind' +
      'ow with your mouse.'
    TitleColor = clWindowText
    DescriptionColor = clGrayText
    Align = alTop
    ExplicitLeft = 10
    ExplicitTop = 254
  end
  object chkHideTimeout: TJvXPCheckbox
    Left = 8
    Top = 301
    Width = 161
    Height = 17
    Caption = 'Enable Auto-Hide'
    TabOrder = 4
    OnClick = chkHideTimeoutClick
  end
  object Label2: TLabel
    Left = 8
    Top = 327
    Width = 80
    Height = 13
    Caption = 'Auto-Hide After:'
  end
  object edtHideTimeout: TEdit
    Left = 112
    Top = 324
    Width = 57
    Height = 22
    TabOrder = 5
    Text = '0'
    OnKeyPress = edtHideTimeoutKeyPress
    OnKeyUp = edtHideTimeoutKeyUp
  end
  object Label3: TLabel
    Left = 175
    Top = 327
    Width = 13
    Height = 13
    Caption = 'ms'
  end
end
