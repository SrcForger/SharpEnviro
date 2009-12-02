object frmEditwnd: TfrmEditwnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEditwnd'
  ClientHeight = 107
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
    107)
  PixelsPerInch = 96
  TextHeight = 13
  object JvLabel1: TLabel
    Left = 242
    Top = 12
    Width = 40
    Height = 13
    Caption = 'Monitor:'
    Transparent = True
  end
  object JvLabel3: TLabel
    Left = 242
    Top = 76
    Width = 78
    Height = 13
    Caption = 'Horizontal Align:'
    Transparent = True
  end
  object JvLabel2: TLabel
    Left = 242
    Top = 44
    Width = 65
    Height = 13
    Caption = 'Vertical Align:'
    Transparent = True
  end
  object Label3: TLabel
    Left = 18
    Top = 44
    Width = 48
    Height = 13
    Caption = 'Template:'
    Transparent = True
  end
  object edName: TLabeledEdit
    Left = 56
    Top = 8
    Width = 157
    Height = 21
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
    OnKeyPress = edThemeNameKeyPress
  end
  object cobo_monitor: TComboBox
    Left = 296
    Top = 8
    Width = 171
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 1
    OnSelect = cbBasedOnSelect
  end
  object cbBasedOn: TComboBox
    Left = 76
    Top = 40
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 2
    OnSelect = cbBasedOnSelect
  end
  object cobo_valign: TComboBox
    Left = 320
    Top = 40
    Width = 147
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 3
    Text = 'Top'
    OnSelect = cbBasedOnSelect
    Items.Strings = (
      'Top'
      'Bottom')
  end
  object cobo_halign: TComboBox
    Left = 336
    Top = 72
    Width = 131
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 4
    Text = 'Left'
    OnSelect = cbBasedOnSelect
    Items.Strings = (
      'Left'
      'Middle'
      'Right'
      'Full Screen')
  end
  object pnlBarSpace: TPanel
    Left = 8
    Top = 8
    Width = 459
    Height = 91
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 5
    object Label1: TLabel
      Left = 0
      Top = 13
      Width = 431
      Height = 26
      Align = alTop
      Caption = 
        'Reduce the size of already existing bars or disable another Shar' +
        'pBar to free some screen space. There is no space left to create' +
        ' another SharpBar at any possible position.'
      WordWrap = True
    end
    object JvLabel4: TLabel
      Left = 0
      Top = 0
      Width = 31
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
    end
  end
  object vals: TJvValidators
    ErrorIndicator = errorinc
    Left = 192
    Top = 72
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
    Left = 152
    Top = 72
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
    Left = 108
    Top = 64
    Bitmap = {}
  end
end
