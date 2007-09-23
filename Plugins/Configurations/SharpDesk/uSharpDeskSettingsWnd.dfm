object frmDeskSettings: TfrmDeskSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmDeskSettings'
  ClientHeight = 465
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
    Height = 465
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 465
      object Label1: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 358
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
      end
      object JvLabel1: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 246
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
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 422
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
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 296
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
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
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
      end
      object Label6: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 187
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
      end
      object cb_dd: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 225
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
      end
      object cb_singleclick: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 337
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
        Top = 401
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
      end
      object cb_amm: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 275
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
      end
      object Panel1: TPanel
        Left = 0
        Top = 61
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
      object cb_adjustsize: TCheckBox
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
        Caption = 'Adjust desktop size to resolution changes'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = cb_ammClick
      end
      object cb_autorotate: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 166
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
        TabOrder = 6
        OnClick = cb_ammClick
      end
    end
    object JvAdvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 465
    end
  end
end
