object frmMenuSettings: TfrmMenuSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmMenuSettings'
  ClientHeight = 228
  ClientWidth = 518
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
  object Label2: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 29
    Width = 484
    Height = 32
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'Enable to display icons. On slow computers disabling this option' +
      ' can increase the menu performance.'
    Color = clBtnFace
    EllipsisPosition = epEndEllipsis
    ParentColor = False
    Transparent = True
    WordWrap = True
    ExplicitLeft = 31
  end
  object Label3: TLabel
    AlignWithMargins = True
    Left = 26
    Top = 90
    Width = 484
    Height = 32
    Margins.Left = 26
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 
      'When enabled, icons are cached to disk, resulting in a noticeabl' +
      'e performance improvement, at a cost of a few MB of hard disk sp' +
      'ace.'
    Color = clBtnFace
    EllipsisPosition = epEndEllipsis
    ParentColor = False
    Transparent = True
    Visible = False
    WordWrap = True
    ExplicitLeft = 34
    ExplicitTop = 37
  end
  object cb_useicons: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 502
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Use Icons'
    TabOrder = 0
    OnClick = cb_useiconsClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 122
    Width = 518
    Height = 117
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 176
      Top = 75
      Width = 106
      Height = 13
      AutoSize = False
      Caption = 'Sub Menu Position:'
      Color = clWindow
      ParentColor = False
      WordWrap = True
    end
    object Label4: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 29
      Width = 484
      Height = 32
      Margins.Left = 26
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 
        'Enable this option to wrap the menu into multiple sub menus if t' +
        'here are too many items in a menu.'
      Color = clWindow
      EllipsisPosition = epEndEllipsis
      ParentColor = False
      Transparent = False
      WordWrap = True
      ExplicitLeft = 34
      ExplicitTop = 128
    end
    object cb_wrap: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 502
      Height = 17
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Wrap Menu'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cb_wrapClick
    end
    object sgb_wrapcount: TSharpeGaugeBox
      Left = 26
      Top = 72
      Width = 121
      Height = 21
      ParentBackground = False
      Min = 5
      Max = 100
      Value = 25
      Prefix = 'Item Count: '
      Description = 'Item wrap count'
      PopPosition = ppRight
      PercentDisplay = False
      OnChangeValue = sgb_wrapcountChangeValue
    end
    object cobo_wrappos: TComboBox
      Left = 288
      Top = 72
      Width = 121
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 2
      Text = 'Bottom'
      OnChange = cobo_wrapposChange
      Items.Strings = (
        'Bottom'
        'Top')
    end
  end
  object cb_cacheicons: TCheckBox
    AlignWithMargins = True
    Left = 8
    Top = 69
    Width = 502
    Height = 17
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Cache Icons (Advanced)'
    TabOrder = 2
    Visible = False
    OnClick = cb_useiconsClick
  end
end
