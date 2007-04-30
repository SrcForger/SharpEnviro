object frmDeskSettings: TfrmDeskSettings
  Left = 0
  Top = 0
  Width = 518
  Height = 599
  Caption = 'frmDeskSettings'
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
    Width = 502
    Height = 563
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 502
      Height = 563
      ParentBackground = True
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 502
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object cb_grid: TCheckBox
          Left = 16
          Top = 16
          Width = 153
          Height = 17
          Caption = 'Align Objects to Grid'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cb_gridClick
        end
      end
      object pn_grid: TPanel
        Left = 0
        Top = 41
        Width = 502
        Height = 72
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object lb_gridx1: TLabel
          Left = 40
          Top = 10
          Width = 73
          Height = 13
          AutoSize = False
          Caption = 'Grid Width'
          Color = clWindow
          ParentColor = False
          WordWrap = True
        end
        object lb_gridx: TLabel
          Left = 276
          Top = 10
          Width = 24
          Height = 13
          BiDiMode = bdLeftToRight
          Caption = '32px'
          Color = clWindow
          ParentBiDiMode = False
          ParentColor = False
          WordWrap = True
        end
        object Label1: TLabel
          Left = 40
          Top = 42
          Width = 73
          Height = 13
          AutoSize = False
          Caption = 'Grid Height'
          Color = clWindow
          ParentColor = False
          WordWrap = True
        end
        object lb_gridy: TLabel
          Left = 276
          Top = 42
          Width = 24
          Height = 13
          BiDiMode = bdLeftToRight
          Caption = '32px'
          Color = clWindow
          ParentBiDiMode = False
          ParentColor = False
          WordWrap = True
        end
        object tb_gridx: TJvTrackBar
          Left = 112
          Top = 8
          Width = 161
          Height = 25
          Max = 256
          Min = 2
          PageSize = 1
          Frequency = 8
          Position = 32
          TabOrder = 0
          TickStyle = tsNone
          OnChange = tb_gridxChange
          ShowRange = False
        end
        object tb_gridy: TJvTrackBar
          Left = 112
          Top = 40
          Width = 161
          Height = 25
          Max = 256
          Min = 2
          PageSize = 1
          Frequency = 8
          Position = 32
          TabOrder = 1
          TickStyle = tsNone
          OnChange = tb_gridyChange
          ShowRange = False
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 113
        Width = 502
        Height = 64
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object cb_singleclick: TCheckBox
          Left = 16
          Top = 8
          Width = 153
          Height = 17
          Caption = 'Single Click Action'
          TabOrder = 0
          OnClick = cb_singleclickClick
        end
        object cb_dd: TCheckBox
          Left = 16
          Top = 40
          Width = 153
          Height = 17
          Caption = 'Enable Drag && Drop'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = cb_ddClick
        end
      end
    end
    object JvAdvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 502
      Height = 563
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 502
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object Label2: TLabel
          Left = 40
          Top = 28
          Width = 361
          Height = 29
          AutoSize = False
          Caption = 
            'Enabling this option will reduce the memory usage of SharpDesk b' +
            'y moving non constantly used data to the swap file.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsItalic]
          ParentFont = False
          WordWrap = True
        end
        object cb_amm: TCheckBox
          Left = 16
          Top = 8
          Width = 257
          Height = 17
          Caption = 'Advanced Memory Management'
          TabOrder = 0
          OnClick = cb_ammClick
        end
      end
    end
  end
end
