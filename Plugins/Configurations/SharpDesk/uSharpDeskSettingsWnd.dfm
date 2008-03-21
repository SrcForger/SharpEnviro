object frmDeskSettings: TfrmDeskSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmDeskSettings'
  ClientHeight = 531
  ClientWidth = 428
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
  object JvLabel1: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 343
    Width = 394
    Height = 21
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Enable this option to enable drag and drop functionality within ' +
      'SharpDesk.'
    Color = clWindow
    EllipsisPosition = epEndEllipsis
    ParentColor = False
    Transparent = False
    WordWrap = True
    ExplicitTop = 246
  end
  object Label1: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 455
    Width = 394
    Height = 35
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Enable this option to enable hyperlink click functionalty for ob' +
      'jects.  When disabled, all objects will require a double click t' +
      'o launch.'
    EllipsisPosition = epEndEllipsis
    Transparent = False
    WordWrap = True
    ExplicitTop = 358
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 393
    Width = 394
    Height = 33
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Enable this option to reduce the memory usage of SharpDesk by mo' +
      'ving constantly unused data to the swap file.'
    Color = clWindow
    EllipsisPosition = epEndEllipsis
    ParentColor = False
    Transparent = False
    WordWrap = True
    ExplicitLeft = 21
    ExplicitTop = 296
  end
  object Label3: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 519
    Width = 394
    Height = 34
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Enabling this option will allow SharpDesk to monitor when anothe' +
      'r application changes the wallpaper, and then update automatical' +
      'ly.'
    Color = clWindow
    EllipsisPosition = epEndEllipsis
    ParentColor = False
    Transparent = False
    WordWrap = True
    ExplicitTop = 422
  end
  object Label5: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 126
    Width = 394
    Height = 32
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Disable this option if you have problems with games which are of' +
      'ten changing the screen resolution.'
    Color = clWindow
    EllipsisPosition = epEndEllipsis
    ParentColor = False
    Transparent = False
    WordWrap = True
    ExplicitTop = 29
  end
  object Label6: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 284
    Width = 394
    Height = 30
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Enable this option to allow SharpDesk to rotate the desktop wall' +
      'paper, when the screen is rotated by 90'#176' (this will keep proper ' +
      'wallpaper dimensions)'
    Color = clWindow
    EllipsisPosition = epEndEllipsis
    ParentColor = False
    Transparent = False
    WordWrap = True
    ExplicitTop = 187
  end
  object cb_adjustsize: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 105
    Width = 412
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Adjust desktop size to resolution changes'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = cb_ammClick
    ExplicitTop = 8
  end
  object cb_amm: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 372
    Width = 412
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Memory Management (Advanced)'
    TabOrder = 1
    OnClick = cb_ammClick
    ExplicitTop = 275
  end
  object cb_autorotate: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 263
    Width = 412
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Auto Rotate Wallpaper (Advanced)'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = cb_ammClick
    ExplicitTop = 166
  end
  object cb_dd: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 322
    Width = 412
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Enable Drag && Drop'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = cb_ddClick
    ExplicitTop = 225
  end
  object cb_singleclick: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 434
    Width = 412
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Single Click Action'
    TabOrder = 4
    OnClick = cb_singleclickClick
    ExplicitTop = 409
  end
  object cb_wpwatch: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 498
    Width = 412
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Windows Wallpaper Monitoring (Advanced)'
    TabOrder = 5
    OnClick = cb_ammClick
    ExplicitTop = 473
  end
  object Panel1: TPanel
    Left = 0
    Top = 158
    Width = 428
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 6
    ExplicitTop = 61
    object Label4: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 29
      Width = 394
      Height = 37
      Margins.Left = 26
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 
        'Enable this option to enable snap to grid functionality for obje' +
        'cts. Disabled objects can be freely positioned.'
      EllipsisPosition = epEndEllipsis
      Transparent = False
      WordWrap = True
    end
    object cb_grid: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 412
      Height = 17
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Align Objects to Grid'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cb_gridClick
    end
    object sgb_gridy: TSharpeGaugeBox
      Left = 26
      Top = 69
      Width = 120
      Height = 21
      ParentBackground = False
      Min = 2
      Max = 128
      Value = 32
      Prefix = 'Height: '
      Suffix = 'px'
      Description = 'Grid Height'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgb_gridyChangeValue
    end
    object sgb_gridx: TSharpeGaugeBox
      Left = 160
      Top = 69
      Width = 120
      Height = 21
      ParentBackground = False
      Min = 2
      Max = 128
      Value = 32
      Prefix = 'Width: '
      Suffix = 'px'
      Description = 'Grid Width'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgb_gridyChangeValue
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 428
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 7
    object Label7: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 8
      Width = 394
      Height = 13
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Right click Menu'
      Color = clWindow
      ParentColor = False
      Transparent = False
      WordWrap = True
      ExplicitWidth = 76
    end
    object Label8: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 73
      Width = 394
      Height = 16
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'Shift + Right Click'
      Color = clWindow
      EllipsisPosition = epEndEllipsis
      ParentColor = False
      Transparent = False
      WordWrap = True
      ExplicitTop = 70
    end
    object Label9: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 25
      Width = 394
      Height = 16
      Margins.Left = 26
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 
        'Change which menu will be displayed on right click of the deskto' +
        'p.'
      Color = clWindow
      EllipsisPosition = epEndEllipsis
      ParentColor = False
      Transparent = False
      WordWrap = True
      ExplicitLeft = 21
      ExplicitTop = 361
    end
    object Label10: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 49
      Width = 394
      Height = 16
      Margins.Left = 26
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'Right Click'
      Color = clWindow
      EllipsisPosition = epEndEllipsis
      ParentColor = False
      Transparent = False
      WordWrap = True
      ExplicitLeft = 21
      ExplicitTop = 361
    end
    object cbMenuList: TComboBox
      AlignWithMargins = True
      Left = 160
      Top = 44
      Width = 177
      Height = 21
      Margins.Left = 26
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbMenuListChange
    end
    object cbMenuShift: TComboBox
      AlignWithMargins = True
      Left = 160
      Top = 70
      Width = 177
      Height = 21
      Margins.Left = 26
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = cbMenuListChange
    end
  end
end
