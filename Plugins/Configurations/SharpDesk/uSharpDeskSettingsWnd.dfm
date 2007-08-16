object frmDeskSettings: TfrmDeskSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmDeskSettings'
  ClientHeight = 456
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
    Height = 456
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 201
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 456
      ExplicitHeight = 201
      object Label1: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 223
        Width = 394
        Height = 26
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to enable hyperlink click functionalty for ob' +
          'jects.  Disablied all objects will require a double click to lau' +
          'nch.'
        EllipsisPosition = epEndEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 218
      end
      object JvLabel1: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 126
        Width = 394
        Height = 13
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to enable drag and drop functionality within ' +
          'SharpDesk.'
        EllipsisPosition = epEndEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        ExplicitLeft = 18
        ExplicitTop = 120
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 278
        Width = 394
        Height = 26
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'Enabling this option will allow SharpDesk to monitor when anothe' +
          'r application changes the wallpaper, and then update automatical' +
          'ly.'
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        WordWrap = True
        ExplicitTop = 29
        ExplicitWidth = 370
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 168
        Width = 394
        Height = 26
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'Enabling this option will reduce the memory usage of SharpDesk b' +
          'y moving non constantly used data to the swap file.'
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        WordWrap = True
        ExplicitTop = 159
      end
      object cb_dd: TCheckBox
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
        Caption = 'Enable Drag && Drop'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cb_ddClick
        ExplicitLeft = 0
        ExplicitTop = 101
      end
      object cb_singleclick: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 202
        Width = 412
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Single Click Action'
        TabOrder = 1
        OnClick = cb_singleclickClick
      end
      object cb_wpwatch: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 257
        Width = 412
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Windows Wallpaper Monitoring (Advanced)'
        TabOrder = 2
        OnClick = cb_ammClick
        ExplicitTop = 8
      end
      object cb_amm: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 147
        Width = 412
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Memory Management (Advanced)'
        TabOrder = 3
        OnClick = cb_ammClick
        ExplicitTop = 138
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 428
        Height = 97
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 4
        object Label4: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 394
          Height = 26
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
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = False
          WordWrap = True
          ExplicitTop = 126
          ExplicitWidth = 360
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
          ExplicitTop = 105
        end
        object sgb_gridy: TSharpeGaugeBox
          Left = 26
          Top = 69
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
        object sgb_gridx: TSharpeGaugeBox
          Left = 160
          Top = 69
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
      end
    end
    object JvAdvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 456
      ExplicitHeight = 201
    end
  end
end
