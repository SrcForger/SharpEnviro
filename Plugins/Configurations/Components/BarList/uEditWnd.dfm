object frmEditwnd: TfrmEditwnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEditwnd'
  ClientHeight = 126
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    475
    126)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBarSpace: TPanel
    Left = 8
    Top = 8
    Width = 0
    Height = 22
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    Visible = False
    ExplicitHeight = 0
    object Label1: TLabel
      Left = 0
      Top = 13
      Width = 0
      Height = 26
      Align = alTop
      AutoSize = False
      Caption = 
        'Reduce the size of already existing bars or disable another Shar' +
        'pBar to free some screen space. There is no space left to create' +
        ' another SharpBar at any possible position.'
      WordWrap = True
      ExplicitWidth = 431
    end
    object JvLabel4: TLabel
      Left = 0
      Top = 0
      Width = 0
      Height = 13
      Align = alTop
      Caption = 'Error:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      ExplicitWidth = 31
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 285
    Height = 116
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alLeft
    AutoSize = True
    BevelOuter = bvNone
    Constraints.MinWidth = 260
    TabOrder = 1
    DesignSize = (
      285
      116)
    object Label3: TLabel
      Left = 0
      Top = 30
      Width = 48
      Height = 13
      Caption = 'Template:'
      Transparent = True
    end
    object Label2: TLabel
      Left = 0
      Top = 3
      Width = 31
      Height = 13
      Caption = 'Name:'
      Transparent = True
    end
    object JvLabel2: TLabel
      Left = 0
      Top = 84
      Width = 27
      Height = 13
      Caption = 'Align:'
      Transparent = True
    end
    object JvLabel1: TLabel
      Left = 0
      Top = 57
      Width = 40
      Height = 13
      Caption = 'Monitor:'
      Transparent = True
    end
    object Panel1: TPanel
      Left = 62
      Top = 81
      Width = 223
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      Constraints.MinWidth = 173
      TabOrder = 3
      object cobo_halign: TComboBox
        AlignWithMargins = True
        Left = 75
        Top = 0
        Width = 98
        Height = 21
        Margins.Left = 2
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 3
        TabOrder = 1
        Text = 'Full Screen'
        OnSelect = cbBasedOnSelect
        Items.Strings = (
          'Left'
          'Middle'
          'Right'
          'Full Screen')
      end
      object cobo_valign: TComboBox
        Left = 0
        Top = 0
        Width = 73
        Height = 21
        Align = alLeft
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = 'Bottom'
        OnSelect = cbBasedOnSelect
        Items.Strings = (
          'Top'
          'Bottom')
      end
    end
    object edName: TEdit
      Left = 62
      Top = 0
      Width = 173
      Height = 21
      TabOrder = 0
      OnKeyPress = edThemeNameKeyPress
    end
    object cobo_monitor: TComboBox
      Left = 62
      Top = 54
      Width = 173
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnSelect = cbBasedOnSelect
    end
    object cbBasedOn: TComboBox
      Left = 62
      Top = 27
      Width = 173
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnSelect = cbBasedOnSelect
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 215
    Top = 10
    Width = 260
    Height = 106
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alRight
    AutoSize = True
    BevelOuter = bvNone
    Constraints.MinWidth = 260
    TabOrder = 2
    ExplicitLeft = 263
    DesignSize = (
      260
      106)
    object chkAlwaysOnTop: TJvXPCheckbox
      AlignWithMargins = True
      Left = 10
      Top = 81
      Width = 244
      Height = 21
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Caption = 'Always On-Top'
      TabOrder = 3
      OnClick = chkShowThrobberClick
    end
    object chkShowThrobber: TJvXPCheckbox
      Left = 10
      Top = 54
      Width = 244
      Height = 21
      Caption = 'Show Throbber'
      TabOrder = 2
      OnClick = chkShowThrobberClick
    end
    object Panel4: TPanel
      Left = 10
      Top = 25
      Width = 244
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 202
      object sgbAutoHide: TSharpeGaugeBox
        Left = 128
        Top = 0
        Width = 116
        Height = 21
        Align = alRight
        ParentBackground = False
        TabOrder = 1
        TabStop = True
        Min = 1
        Max = 60
        Value = 10
        Suffix = ' Second(s)'
        Description = 'Adjust to set the auto-hide timeout'
        PopPosition = ppBottom
        PercentDisplay = False
        MaxPercent = 0
        Formatting = '%d'
        OnChangeValue = sgbFixedWidthChangeValue
        BackgroundColor = clWindow
      end
      object chkAutoHide: TJvXPCheckbox
        Left = 0
        Top = 0
        Width = 90
        Height = 21
        Caption = 'Auto-Hide'
        TabOrder = 0
        Align = alLeft
        OnClick = chkAutoHideClick
        ExplicitLeft = 95
      end
    end
    object Panel5: TPanel
      Left = 10
      Top = 0
      Width = 244
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 202
      object cbFixedWidth: TJvXPCheckbox
        Left = 0
        Top = 0
        Width = 90
        Height = 21
        Caption = 'Fixed Width'
        TabOrder = 0
        Align = alLeft
        OnClick = cbFixedWidthClick
      end
      object sgbFixedWidth: TSharpeGaugeBox
        Left = 128
        Top = 0
        Width = 116
        Height = 21
        Align = alRight
        ParentBackground = False
        TabOrder = 1
        TabStop = True
        Min = 10
        Max = 90
        Value = 50
        Suffix = '%'
        Description = 'Adjust to set the transparency'
        PopPosition = ppBottom
        PercentDisplay = False
        MaxPercent = 100
        Formatting = '%d'
        OnChangeValue = sgbFixedWidthChangeValue
        BackgroundColor = clWindow
      end
    end
  end
  object vals: TJvValidators
    ErrorIndicator = errorinc
    Left = 80
    Top = 152
    object valBarName: TJvCustomValidator
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      OnValidate = valBarNameValidate
    end
  end
  object errorinc: TJvErrorIndicator
    BlinkRate = 200
    BlinkStyle = ebsNeverBlink
    Images = pilError
    ImageIndex = 0
    Left = 40
    Top = 152
  end
  object pilError: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002A744558744372656174696F6E2054696D65004D692035204D727A20
          323030332030313A31363A3336202B303130302D49F2060000000774494D4500
          0000000000000973942E000000097048597300000AF000000AF00142AC349800
          0002564944415478DAA5D35D4893511807F0FFBBBDEF9C4BA732537A474E215C
          D95DC22C8AA5284178679A4111751154170979652F8CCAF0030283A246102548
          D942E8630515097E93294936C7A08D9ACDD636DC74DFDBFBD161441FD0CAF081
          73F1F03CE777CE79E050586750D90AB357A18FD33A0B64794558B69DD8D381E7
          FF05CCDFCA1FD1353E30D254126F9F747C61A30B95156D88AC0970DD410BA36F
          B3149455037C08D1B0070B8F7ABBEA3970FF049C2FA05C59D2D9B7EE33953BA7
          AF811762D8BEB316EF8627E3E2E27C95E11C3EFE15B099C169765FBC94CB8FA1
          A866066A350BDBD30454253B307B77C8D2C089AD5981C5FB6043F26AC7E69AE3
          798AE000D8DAAF28D9580AEB3D2FB46C053E4CBAA465FB27631D87F13F027366
          F46BEBBA8F52F208347933D8DBE4449CD7627AC285B04F0D3A3706EB0DF79B16
          4EA8211BA5DF00C74D1824EDFEA9D22AA34C487BA05205601E18C5E740252E9B
          96108DAF80C98DC0FD3E8EE9C7E2B1233DE8FF15A066AF6F98D8D2D8BB2B9D74
          93CC0F9A0922AD706335560CB6700E922C04794E0A0A1560ED81271D86BEA90B
          D10C30DC89C3BADA53031A6D3999BA071415404E8E0FA30F5F43A662D0702806
          414A8051125B0E043DC02087CED3FD3065805757CA1C86D6EECA54C4411EE627
          4D0114324ED437079060F4981A1B87C0C721A37F5EF9591F561BCFA220938F98
          ABBD8603EDA5A9988B7478C9F291D37CA0150E088A222895767C9FD98F18BA00
          6FF3796CCA0083ED3858ACDBD627A7A97C498C419278B212A492842825040969
          9213428448122912803FE4C59993B7F132EB5F586BAC1BF8061506EE110DE119
          B00000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end>
    Left = 4
    Top = 152
    Bitmap = {}
  end
end
