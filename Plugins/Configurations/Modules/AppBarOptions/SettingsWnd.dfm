object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 150
  ClientWidth = 443
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlStyleAndSort: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 47
    Width = 433
    Height = 31
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lblStyle: TLabel
      Left = 0
      Top = 4
      Width = 31
      Height = 13
      Caption = 'Style: '
    end
    object cbStyle: TComboBox
      AlignWithMargins = True
      Left = 42
      Top = 0
      Width = 150
      Height = 21
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Style = csDropDownList
      Constraints.MaxWidth = 200
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 0
      Text = 'Minimal'
      OnClick = cbStyleClick
      Items.Strings = (
        'Default'
        'Compact'
        'Minimal')
    end
  end
  object schTaskOptions: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 433
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Display Options'
    Description = 'Define the type of button style you want to use'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    Color = clWindow
  end
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 78
    Width = 433
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Overlay Options'
    Description = 
      'Define if you want to show how many windows of an application ar' +
      'e open'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    Color = clWindow
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 125
    Width = 433
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 3
    object chkOverlay: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 289
      Height = 21
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Caption = 'Enable multiple window overlay'
      TabOrder = 0
      Checked = True
      State = cbChecked
      Align = alLeft
      OnClick = CheckClick
    end
  end
end
