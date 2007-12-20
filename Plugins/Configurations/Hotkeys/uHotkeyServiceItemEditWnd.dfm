object FrmHotkeyEdit: TFrmHotkeyEdit
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 73
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 490
    Height = 73
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Panel1: TPanel
      Left = 284
      Top = 140
      Width = 575
      Height = 365
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
    end
    object pMain: TJvPageList
      Left = 0
      Top = 0
      Width = 490
      Height = 73
      ActivePage = spEdit
      PropagateEnable = False
      Align = alClient
      ParentBackground = True
      object spDelete: TJvStandardPage
        Left = 0
        Top = 0
        Width = 490
        Height = 73
        BorderWidth = 8
        ParentBackground = True
        object Label1: TJvLabel
          Left = 0
          Top = 0
          Width = 78
          Height = 13
          Align = alTop
          Caption = 'Confirmation:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
          Images = pilError
        end
        object Label2: TLabel
          Left = 0
          Top = 13
          Width = 307
          Height = 14
          Align = alTop
          Caption = 'Are you sure you want to delete the currently selected Hotkey?'
        end
        object cmdBrowse: TPngBitBtn
          Left = 243
          Top = 147
          Width = 77
          Height = 22
          Caption = 'Browse'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = False
          OnClick = cmdbrowseclick
          PngImage.Data = {
            89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
            6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
            000DD70142289B780000000774494D45000000000000000973942E0000018849
            44415478DAB593DF4A024114C6BF9DD92B83BC3137BC0AAFC257280CB3C45EA4
            EE8308BA2F4C114322905EA3522AFAE3635457A5D8BA7B2989B033DB99D1D556
            BB49E8CC0C7376E0FB9D6FE6B046A178BC0BA086398231B66F10C03F3C389A47
            8FD3D209C68056ABF52771229140A95CF827806118E3059AF0D5A42155AEB3DF
            014AF0FAF6827EFF0BBD5E4FC3E2710BA9D51494B6D97CC4FA5A1A9248169D97
            2BC509A0DD6EE3A3F58EE44A120663787A7E183BB2AC65D8F6A7CE37D2194829
            108B2D85019D4E87DAC2C13953EDA165E0EEFE76E6EE9B992C84F0118D2EE2AC
            5A9E006CDB06E30460238002190CF5C67508B095CD410A89C84204D5F3CA04E0
            74BB43000F5C70DCD4AF661CE4B6F3E440E822B5CB8B1F00D7A1EA264C936B71
            BD312B5691CFED1040EAEE8400AEEBEAEA2637C14D46B9A9BFD55BF8D2879012
            C213B40B78C2D3AD9D72E09238000457192EA9C4420905DD9F76CFD36EC20E1C
            07CC1C0182C7540EE821250DE5220028D80C20389C0E553D88A0B28AC1603006
            CCFD3B53EC7D036587EE50ED5EC05B0000000049454E44AE426082}
        end
      end
      object spEdit: TJvStandardPage
        Left = 0
        Top = 0
        Width = 490
        Height = 73
        Caption = 'spEdit'
        ParentBackground = True
        DesignSize = (
          490
          73)
        object Button1: TPngSpeedButton
          Left = 391
          Top = 40
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Browse'
          OnClick = cmdbrowseclick
        end
        object Label3: TLabel
          Left = 259
          Top = 12
          Width = 36
          Height = 14
          Anchors = [akTop, akRight]
          Caption = 'Hotkey:'
          Transparent = False
        end
        object edName: TLabeledEdit
          Left = 56
          Top = 8
          Width = 182
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 30
          EditLabel.Height = 14
          EditLabel.Caption = 'Name:'
          LabelPosition = lpLeft
          LabelSpacing = 6
          TabOrder = 0
          OnChange = UpdateEditState
        end
        object edCommand: TLabeledEdit
          Left = 80
          Top = 40
          Width = 289
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 50
          EditLabel.Height = 14
          EditLabel.Caption = 'Command:'
          LabelPosition = lpLeft
          LabelSpacing = 6
          TabOrder = 1
          OnChange = UpdateEditState
        end
        object edHotkey: TSharpEHotkeyEdit
          Left = 305
          Top = 8
          Width = 161
          Height = 22
          Modifier = []
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnKeyUp = edHotkeyKeyUp
          Anchors = [akTop, akRight]
        end
      end
    end
  end
  object vals: TJvValidators
    ErrorIndicator = errorinc
    Left = 320
    Top = 32
    object valHotkey: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edHotkey
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Required Field'
    end
    object valName: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Required Field'
    end
    object valCommand: TJvRequiredFieldValidator
      Valid = True
      ControlToValidate = edCommand
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'Required Field'
    end
    object valNameExists: TJvCustomValidator
      Valid = True
      ControlToValidate = edName
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'This name is already in use'
      OnValidate = valNameExistsValidate
    end
    object valHotkeyExists: TJvCustomValidator
      Valid = True
      ControlToValidate = edHotkey
      PropertyToValidate = 'Text'
      Enabled = True
      ErrorMessage = 'This Hotkey is already in use'
      OnValidate = valHotkeyExistsValidate
    end
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
    Left = 352
    Top = 32
    Bitmap = {}
  end
  object errorinc: TJvErrorIndicator
    BlinkRate = 200
    BlinkStyle = ebsNeverBlink
    Images = pilError
    ImageIndex = 0
    Left = 288
    Top = 32
  end
end
