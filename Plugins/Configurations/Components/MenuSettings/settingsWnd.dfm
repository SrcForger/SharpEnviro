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
      'Define whether to display menu icons. Disabling icons or enablin' +
      'g caching will improve menu performance.'
    TitleColor = clWindowText
    DescriptionColor = clGrayText
    Align = alTop
  end
  object pnlGenericIcons: TPanel
    Left = 0
    Top = 65
    Width = 600
    Height = 74
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
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
      TabOrder = 0
      Align = alTop
      OnClick = chkUseIconsClick
    end
  end
  object SharpECenterHeader4: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 149
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
  object pnlWrapping: TPanel
    Left = 0
    Top = 196
    Width = 600
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 176
      Top = 30
      Width = 106
      Height = 16
      AutoSize = False
      Caption = 'Sub-Menu Position:'
      Color = clWindow
      ParentColor = False
      WordWrap = True
    end
    object chkMenuWrapping: TJvXPCheckbox
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 590
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Enable menu wrapping'
      TabOrder = 0
      Checked = True
      State = cbChecked
      Align = alTop
      OnClick = chkMenuWrappingClick
    end
    object sgbWrapCount: TSharpeGaugeBox
      Left = 5
      Top = 27
      Width = 149
      Height = 21
      ParentBackground = False
      TabOrder = 1
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
      Top = 27
      Width = 85
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 2
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
    Top = 257
    Width = 590
    Height = 37
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Menu Hide'
    Description = 
      'Define whether the menu should hide when you leave it with your ' +
      'mouse.'
    TitleColor = clWindowText
    DescriptionColor = clGrayText
    Align = alTop
  end
  object pnlAutoHide: TPanel
    Left = 0
    Top = 304
    Width = 600
    Height = 46
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 2
    object Label2: TLabel
      Left = 5
      Top = 29
      Width = 82
      Height = 13
      Caption = 'Hide Menu After:'
    end
    object Label3: TLabel
      Left = 196
      Top = 29
      Width = 39
      Height = 13
      Caption = 'seconds'
    end
    object chkHideTimeout: TJvXPCheckbox
      Left = 5
      Top = 0
      Width = 161
      Height = 17
      Caption = 'Enable Menu Hiding'
      TabOrder = 0
      OnClick = chkHideTimeoutClick
    end
    object edtHideTimeout: TEdit
      Left = 133
      Top = 25
      Width = 57
      Height = 21
      TabOrder = 1
      Text = '0'
      OnKeyPress = edtHideTimeoutKeyPress
      OnKeyUp = edtHideTimeoutKeyUp
    end
  end
  object pnlIcons: TPanel
    Left = 0
    Top = 47
    Width = 600
    Height = 18
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 6
    object chkUseIcons: TJvXPCheckbox
      AlignWithMargins = True
      Left = 1
      Top = 1
      Width = 136
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Enable menu icons'
      TabOrder = 0
      Checked = True
      ParentColor = False
      State = cbChecked
      OnClick = chkUseIconsClick
    end
    object chkCacheIcons: TJvXPCheckbox
      AlignWithMargins = True
      Left = 147
      Top = 0
      Width = 136
      Height = 17
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Caption = 'Enable icon caching'
      TabOrder = 1
      Checked = True
      ParentColor = False
      State = cbChecked
      OnClick = chkCacheIconsClick
    end
  end
end
