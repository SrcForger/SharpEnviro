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
    Width = 510
    Height = 570
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 510
      Height = 570
      ParentBackground = True
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 510
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
        Width = 510
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
        object sgb_gridx: TSharpeGaugeBox
          Left = 128
          Top = 8
          Width = 121
          Height = 21
          Min = 2
          Max = 256
          Value = 32
          Description = 'Adjust to the width of the grid'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_gridyChangeValue
        end
        object sgb_gridy: TSharpeGaugeBox
          Left = 128
          Top = 40
          Width = 121
          Height = 21
          Min = 2
          Max = 256
          Value = 32
          Description = 'Adjust to set the height of the grid'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_gridyChangeValue
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 113
        Width = 510
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
      Width = 510
      Height = 570
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 510
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object Label2: TLabel
          Left = 40
          Top = 36
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
          Top = 16
          Width = 257
          Height = 17
          Caption = 'Advanced Memory Management'
          TabOrder = 0
          OnClick = cb_ammClick
        end
      end
    end
    object JvStandardPage1: TJvStandardPage
      Left = 0
      Top = 0
      Width = 510
      Height = 570
      Caption = 'JvStandardPage1'
    end
  end
end
