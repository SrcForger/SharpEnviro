object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 286
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
    ExplicitWidth = 680
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
    ExplicitWidth = 682
  end
  object Panel1: TPanel
    Left = 0
    Top = 80
    Width = 532
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 690
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
  end
end
