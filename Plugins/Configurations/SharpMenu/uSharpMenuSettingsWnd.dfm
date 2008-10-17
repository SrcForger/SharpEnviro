object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 254
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
  object Panel1: TPanel
    Left = 0
    Top = 212
    Width = 600
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 172
      Top = 11
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
      PopPosition = ppRight
      PercentDisplay = False
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
      TabOrder = 1
      Text = 'Bottom'
      OnChange = cboWrapPosChange
      Items.Strings = (
        'Bottom'
        'Top')
    end
  end
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
    Title = 'Cache Icons'
    Description = 
      'Define whether to cache icons. Enabling will improve menu perfor' +
      'mance.'
    TitleColor = clWindowText
    DescriptionColor = clGrayText
    Visible = False
    Align = alTop
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
  object chkCacheIcons: TJvXPCheckbox
    AlignWithMargins = True
    Left = 5
    Top = 300
    Width = 590
    Height = 17
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Caption = 'Enable caching of icons'
    TabOrder = 2
    Align = alTop
    Visible = False
    OnClick = chkUseIconsClick
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
    TabOrder = 6
    Checked = True
    State = cbChecked
    Align = alTop
    OnClick = chkMenuWrappingClick
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
    TabOrder = 7
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
      ExplicitTop = -6
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
      ExplicitTop = 14
    end
  end
end
