object frmRSSReader: TfrmRSSReader
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmRSSReader'
  ClientHeight = 333
  ClientWidth = 421
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
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 411
    Height = 37
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Feed Settings'
    Description = 'Define the url and update interval of the rss feed.'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    ExplicitWidth = 431
  end
  object SharpECenterHeader2: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 153
    Width = 411
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Display Options'
    Description = 'Define what and how to display the feed data'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
    ExplicitTop = 83
    ExplicitWidth = 431
  end
  object pnlTop: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 200
    Width = 406
    Height = 17
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    ExplicitTop = 167
    ExplicitWidth = 426
    object cbNotify: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 161
      Height = 17
      Caption = 'Informations Tooltip'
      TabOrder = 0
      Checked = True
      State = cbChecked
      OnClick = UpdateSettingsEvent
    end
  end
  object pnlBottom: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 227
    Width = 406
    Height = 17
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    ExplicitTop = 194
    ExplicitWidth = 426
    object cbButtons: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 161
      Height = 17
      Caption = 'Scroll Buttons'
      TabOrder = 0
      OnClick = UpdateSettingsEvent
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 47
    Width = 406
    Height = 25
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 4
    ExplicitWidth = 426
    object Label4: TLabel
      Left = 0
      Top = 0
      Width = 23
      Height = 25
      Align = alLeft
      Caption = 'URL:'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object edtURL: TEdit
      Left = 64
      Top = 0
      Width = 286
      Height = 21
      TabOrder = 0
      Text = 'http://rss.cnn.com/rss/cnn_world.rss'
      OnChange = UpdateSettingsEvent
    end
    object Button1: TButton
      Left = 356
      Top = 0
      Width = 37
      Height = 22
      Caption = '...'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 80
    Width = 406
    Height = 25
    Margins.Left = 5
    Margins.Top = 8
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 5
    ExplicitWidth = 426
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 83
      Height = 25
      Align = alLeft
      Caption = 'Update Interval: '
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object sgbUpdateInterval: TSharpeGaugeBox
      Left = 89
      Top = 4
      Width = 72
      Height = 21
      ParentBackground = False
      Min = 1
      Max = 60
      Value = 15
      Suffix = ' min'
      Description = 'Adjust to set the transparency'
      PopPosition = ppBottom
      PercentDisplay = False
      OnChangeValue = sgbUpdateIntervalChangeValue
      BackgroundColor = clWindow
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 254
    Width = 406
    Height = 17
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 6
    ExplicitLeft = 0
    ExplicitTop = 224
    ExplicitWidth = 426
    object cbIcon: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 161
      Height = 17
      Caption = 'Icon'
      TabOrder = 0
      Checked = True
      State = cbChecked
      OnClick = cbIconClick
    end
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 281
    Width = 406
    Height = 17
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 7
    ExplicitLeft = 10
    ExplicitTop = 251
    ExplicitWidth = 426
    object cbCustomIcon: TJvXPCheckbox
      Left = 0
      Top = 0
      Width = 161
      Height = 17
      Caption = 'Custom Feed Icon'
      TabOrder = 0
      OnClick = UpdateSettingsEvent
    end
  end
  object Panel5: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 113
    Width = 406
    Height = 25
    Margins.Left = 5
    Margins.Top = 8
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 8
    ExplicitLeft = 13
    ExplicitTop = 88
    ExplicitWidth = 426
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 74
      Height = 25
      Align = alLeft
      Caption = 'Cycle Interval: '
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object Label2: TLabel
      Left = 300
      Top = 0
      Width = 106
      Height = 25
      Align = alRight
      Caption = '(set to 0 to disable)    '
      Layout = tlCenter
      ExplicitLeft = 303
      ExplicitHeight = 13
    end
    object sgbSwitchInterval: TSharpeGaugeBox
      Left = 89
      Top = 4
      Width = 72
      Height = 21
      ParentBackground = False
      Min = 0
      Max = 120
      Value = 20
      Suffix = ' sec'
      Description = 'Adjust to set the transparency'
      PopPosition = ppBottom
      PercentDisplay = False
      OnChangeValue = sgbUpdateIntervalChangeValue
      BackgroundColor = clWindow
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 408
    Top = 548
    object ffff1: TMenuItem
      Caption = 'English'
      object BBCEurope1: TMenuItem
        Caption = 'BBC - Europe'
        Hint = 
          'http://newsrss.bbc.co.uk/rss/newsonline_world_edition/europe/rss' +
          '.xml'
        OnClick = MenuItemClick
      end
      object BBCTechnology1: TMenuItem
        Caption = 'BBC - Technology'
        Hint = 
          'http://newsrss.bbc.co.uk/rss/newsonline_world_edition/technology' +
          '/rss.xml'
        OnClick = MenuItemClick
      end
      object BBCTopNews1: TMenuItem
        Caption = 'BBC - Top News'
        Hint = 
          'http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page' +
          '/rss.xml'
        OnClick = MenuItemClick
      end
      object BBCUK1: TMenuItem
        Caption = 'BBC - UK'
        Hint = 
          'http://newsrss.bbc.co.uk/rss/newsonline_world_edition/uk_news/rs' +
          's.xml'
        OnClick = MenuItemClick
      end
      object CNNBusiness1: TMenuItem
        Caption = 'CNN - Business'
        Hint = 'http://rss.cnn.com/rss/edition_business.rss'
        OnClick = MenuItemClick
      end
      object CNNEurope1: TMenuItem
        Caption = 'CNN - Europe'
        Hint = 'http://rss.cnn.com/rss/edition_europe.rss'
        OnClick = MenuItemClick
      end
      object CNNUSANews1: TMenuItem
        Caption = 'CNN - USA'
        Hint = 'http://rss.cnn.com/rss/cnn_us.rss'
        OnClick = MenuItemClick
      end
      object CNNTechnology1: TMenuItem
        Caption = 'CNN - Technology'
        Hint = 'http://rss.cnn.com/rss/cnn_tech.rss'
        OnClick = MenuItemClick
      end
      object CNNWorldsNews1: TMenuItem
        Caption = 'CNN - World News'
        Hint = 'http://rss.cnn.com/rss/cnn_world.rss'
        OnClick = MenuItemClick
      end
      object NYTUSA1: TMenuItem
        Caption = 'NYT - USA'
        Hint = 'http://feeds.nytimes.com/nyt/rss/US'
        OnClick = MenuItemClick
      end
      object NYTWorldNews1: TMenuItem
        Caption = 'NYT - World News'
        Hint = 'http://feeds.nytimes.com/nyt/rss/World'
        OnClick = MenuItemClick
      end
    end
    object German1: TMenuItem
      Caption = 'German'
      object ntv1: TMenuItem
        Caption = 'n-tv'
        Hint = 'http://www.n-tv.de/rss'
        OnClick = MenuItemClick
      end
      object SpiegelNachrichten1: TMenuItem
        Caption = 'Spiegel - Nachrichten'
        Hint = 'http://www.spiegel.de/index.rss'
        OnClick = MenuItemClick
      end
      object SpiegelSchlagzeilen1: TMenuItem
        Caption = 'Spiegel - Schlagzeilen'
        Hint = 'http://www.spiegel.de/schlagzeilen/index.rss'
        OnClick = MenuItemClick
      end
      object agesschau1: TMenuItem
        Caption = 'Tagesschau'
        Hint = 'http://www.tagesschau.de/xml/rss2'
        OnClick = MenuItemClick
      end
    end
  end
end
