object frmMenuSettings: TfrmMenuSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmMenuSettings'
  ClientHeight = 105
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
  object JvPageList1: TJvPageList
    Left = 0
    Top = 0
    Width = 518
    Height = 105
    ActivePage = JvSettingsPage
    PropagateEnable = False
    Align = alClient
    object JvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 518
      Height = 105
      Caption = '``````'
      ParentBackground = True
      object Label3: TJvLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 484
        Height = 13
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 
          'Enable this option to wrap the menu into multiple sub menus if t' +
          'here are too many items in a menu.'
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
        ExplicitWidth = 475
      end
      object pn_wrap: TPanel
        Left = 0
        Top = 42
        Width = 518
        Height = 47
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitTop = 50
        object Label1: TLabel
          Left = 184
          Top = 10
          Width = 113
          Height = 13
          AutoSize = False
          Caption = 'Sub Menu Position'
          Color = clWindow
          ParentColor = False
          WordWrap = True
        end
        object sgb_wrapcount: TSharpeGaugeBox
          Left = 26
          Top = 8
          Width = 121
          Height = 21
          Min = 5
          Max = 100
          Value = 25
          Prefix = 'Item Count: '
          Description = 'Count at which a menu will be wrapped.'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_wrapcountChangeValue
        end
        object cobo_wrappos: TComboBox
          Left = 288
          Top = 8
          Width = 121
          Height = 21
          Style = csDropDownList
          Ctl3D = True
          ItemHeight = 13
          ParentCtl3D = False
          TabOrder = 1
          OnChange = cobo_wrapposChange
          Items.Strings = (
            'Bottom'
            'Top')
        end
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
        TabOrder = 1
        OnClick = cb_wrapClick
      end
    end
    object JvAdvSettingsPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 518
      Height = 105
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 518
        Height = 105
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object JvLabel1: TJvLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 484
          Height = 39
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 
            'With enabled icon caching all icons are cached as a simple binar' +
            'y stream on the hard drive. The result is a huge performance imp' +
            'rovement for SharpMenu at the cost of very few hard drive space ' +
            '(0,2 to 2MB depending on the menu size)'
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
          ExplicitWidth = 478
        end
        object cb_cacheicons: TCheckBox
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
          Caption = 'Cache Icons'
          TabOrder = 0
          OnClick = cb_cacheiconsClick
        end
      end
    end
  end
end
