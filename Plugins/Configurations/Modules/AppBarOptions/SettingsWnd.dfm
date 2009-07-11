object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 385
  ClientWidth = 443
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
    Top = 187
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
    Top = 234
    Width = 433
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
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
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 312
    Width = 433
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 4
    object chkVWM: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 417
      Height = 21
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Caption = 'Enable VWM Filter (show only windows from the current VWM)'
      TabOrder = 0
      Align = alLeft
      OnClick = CheckClick
    end
  end
  object SharpECenterHeader2: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 265
    Width = 433
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'VWM and Monitor Options'
    Description = 'Define if you want to filter any windows'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    Color = clWindow
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 343
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
    TabOrder = 6
    object chkMonitor: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 417
      Height = 21
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Caption = 
        'Enable Monitor Filter (show only windows visible on the current ' +
        'Monitor)'
      TabOrder = 0
      Align = alLeft
      OnClick = CheckClick
    end
  end
  object SharpECenterHeader3: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 78
    Width = 433
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Task Preview Options'
    Description = 'Define if you want to show task previews. '
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    Color = clWindow
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 125
    Width = 433
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 8
    object chkTaskPreviews: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 369
      Height = 21
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Caption = 'Show task previews (Requires Vista/Win7 Home Premium or above)'
      TabOrder = 0
      Checked = True
      State = cbChecked
      Align = alLeft
      OnClick = CheckClick
    end
  end
  object Panel5: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 156
    Width = 433
    Height = 31
    Hint = 
      'Holding down this key while task previews are open will make the' +
      'm to not close until this Key is released. This enables several ' +
      'additional options like clicking several task preview windows at' +
      ' once or closing tasks by middle clicking on their preview windo' +
      'w.'
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    object Label1: TLabel
      Left = 0
      Top = 3
      Width = 46
      Height = 13
      Hint = 
        'Holding down this key while task previews are open will make the' +
        'm to not close until this Key is released. This enables several ' +
        'additional options like clicking several task preview windows at' +
        ' once or closing tasks by middle clicking on their preview windo' +
        'w.'
      Caption = 'Hold Key:'
    end
    object cbLockKey: TComboBox
      AlignWithMargins = True
      Left = 57
      Top = 0
      Width = 135
      Height = 21
      Hint = 
        'Holding down this key while task previews are open will make the' +
        'm to not close until this Key is released. This enables several ' +
        'additional options like clicking several task preview windows at' +
        ' once or closing tasks by middle clicking on their preview windo' +
        'w.'
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Style = csDropDownList
      Constraints.MaxWidth = 200
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 0
      Text = 'Shift'
      OnClick = cbStyleClick
      Items.Strings = (
        'Ctrl'
        'Shift')
    end
  end
end
