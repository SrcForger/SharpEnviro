object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 451
  ClientWidth = 579
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
    Top = 45
    Width = 569
    Height = 31
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitTop = 47
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
    Width = 569
    Height = 35
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
    Top = 183
    Width = 569
    Height = 35
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
    ExplicitTop = 185
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 228
    Width = 569
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
    ExplicitTop = 230
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
    Top = 304
    Width = 569
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
    ExplicitTop = 308
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
    Top = 259
    Width = 569
    Height = 35
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
    ExplicitTop = 261
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 335
    Width = 569
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 5
    ExplicitTop = 337
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
    Top = 76
    Width = 569
    Height = 35
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
    Top = 121
    Width = 569
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    object chkTaskPreviews: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 417
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
    Top = 152
    Width = 569
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
    TabOrder = 2
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
      Constraints.MaxWidth = 262
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
  object SharpECenterHeader4: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 366
    Width = 569
    Height = 35
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Title = 'Drag and Drop Options'
    Description = 
      'If disabled icons can still be rearranged when holding the shift' +
      ' key'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    Color = clWindow
  end
  object Panel6: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 411
    Width = 569
    Height = 21
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 11
    object chkDragDrop: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 300
      Height = 21
      Margins.Left = 2
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 10
      Caption = 'Enable rearrangement of buttons by drag and drop'
      TabOrder = 0
      Checked = True
      State = cbChecked
      Align = alLeft
      OnClick = CheckClick
    end
  end
end
