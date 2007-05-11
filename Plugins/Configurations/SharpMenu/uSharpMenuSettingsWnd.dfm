object frmMenuSettings: TfrmMenuSettings
  Left = 0
  Top = 0
  Width = 518
  Height = 599
  Caption = 'frmMenuSettings'
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
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object cb_wrap: TCheckBox
          Left = 16
          Top = 16
          Width = 153
          Height = 17
          Caption = 'Wrap Menu'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cb_wrapClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 97
        Width = 510
        Height = 64
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
      end
      object pn_wrap: TPanel
        Left = 0
        Top = 33
        Width = 510
        Height = 64
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object lb_gridx1: TLabel
          Left = 40
          Top = 10
          Width = 73
          Height = 13
          AutoSize = False
          Caption = 'Item Count'
          Color = clWindow
          ParentColor = False
          WordWrap = True
        end
        object Label1: TLabel
          Left = 40
          Top = 42
          Width = 113
          Height = 13
          AutoSize = False
          Caption = 'Sub Menu Position'
          Color = clWindow
          ParentColor = False
          WordWrap = True
        end
        object sgb_wrapcount: TSharpeGaugeBox
          Left = 152
          Top = 8
          Width = 121
          Height = 21
          Min = 5
          Max = 100
          Value = 25
          Description = 'Adjust to set the icon count at which a menu will be wrapped.'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_wrapcountChangeValue
        end
        object cobo_wrappos: TComboBox
          Left = 152
          Top = 40
          Width = 121
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          OnChange = cobo_wrapposChange
          Items.Strings = (
            'Bottom'
            'Top')
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
        Height = 105
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object Label2: TLabel
          Left = 40
          Top = 36
          Width = 401
          Height = 65
          AutoSize = False
          Caption = 
            'With enabled icon caching all icons are cached as a simple binar' +
            'y stream on the hard drive. The result is a huge performance imp' +
            'rovement for SharpMenu at the cost of very few hard drive space ' +
            '(0,2 to 2MB depending on the menu size).'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsItalic]
          ParentFont = False
          WordWrap = True
        end
        object cb_cacheicons: TCheckBox
          Left = 16
          Top = 16
          Width = 257
          Height = 17
          Caption = 'Cache Icons'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cb_cacheiconsClick
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
