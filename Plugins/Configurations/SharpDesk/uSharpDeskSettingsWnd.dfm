object frmDeskSettings: TfrmDeskSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmDeskSettings'
  ClientHeight = 201
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
  object JvPageList1: TJvPageList
    Left = 0
    Top = 0
    Width = 428
    Height = 201
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 221
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 201
      ParentBackground = True
      ExplicitHeight = 221
      object Label1: TJvLabel
        AlignWithMargins = True
        Left = 26
        Top = 71
        Width = 386
        Height = 26
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'Enable this option to enable hyperlink click functionalty for ob' +
          'jects.  Disablied all objects will require a double click to lau' +
          'nch.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        ImageIndex = 0
        Spacing = 3
      end
      object JvLabel1: TJvLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 357
        Height = 13
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'Enable this option to enable drag and drop functionality within ' +
          'SharpDesk.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        ImageIndex = 0
        Spacing = 3
      end
      object JvLabel2: TJvLabel
        AlignWithMargins = True
        Left = 26
        Top = 126
        Width = 362
        Height = 26
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'Enable this option to enable snap to grid functionality for obje' +
          'cts. Disabled objects can be freely positioned.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        ImageIndex = 0
        Spacing = 3
      end
      object cb_grid: TCheckBox
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
        Caption = 'Align Objects to Grid'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cb_gridClick
      end
      object cb_dd: TCheckBox
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
        Caption = 'Enable Drag && Drop'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = cb_ddClick
      end
      object cb_singleclick: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 50
        Width = 412
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Single Click Action'
        TabOrder = 2
        OnClick = cb_singleclickClick
      end
      object sgb_gridx: TSharpeGaugeBox
        Left = 160
        Top = 171
        Width = 120
        Height = 21
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
      object sgb_gridy: TSharpeGaugeBox
        Left = 26
        Top = 171
        Width = 120
        Height = 21
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
    end
    object JvAdvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 201
      ExplicitHeight = 175
      object Label2: TJvLabel
        AlignWithMargins = True
        Left = 26
        Top = 97
        Width = 383
        Height = 26
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'Enabling this option will reduce the memory usage of SharpDesk b' +
          'y moving non constantly used data to the swap file.'
        FrameColor = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Layout = tlCenter
        ParentColor = False
        ParentFont = False
        WordWrap = True
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        Spacing = 3
      end
      object Label3: TJvLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 377
        Height = 39
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'With enabled wallpaper monitoring the SharpDesk wallpaper of the' +
          ' primary monitor will be changed if any other application is usi' +
          'ng the standard windows routines to set a new desktop wallpaper'
        FrameColor = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Layout = tlCenter
        ParentColor = False
        ParentFont = False
        WordWrap = True
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        ImageIndex = 0
        Spacing = 3
      end
      object cb_amm: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 76
        Width = 412
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Advanced Memory Management'
        TabOrder = 0
        OnClick = cb_ammClick
        ExplicitTop = 88
      end
      object cb_wpwatch: TCheckBox
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
        Caption = 'Windows Wallpaper Monitoring'
        TabOrder = 1
        OnClick = cb_ammClick
      end
    end
  end
end
