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
          Width = 474
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
          ExplicitWidth = 78
        end
        object Label2: TLabel
          Left = 0
          Top = 13
          Width = 474
          Height = 14
          Align = alTop
          Caption = 'Are you sure you want to delete the currently selected Hotkey?'
          ExplicitWidth = 307
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
          Top = 12
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
          Left = 301
          Top = 12
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
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002AD4944415478DAA5935F48536114C08FD3FDBDA2D3C03F
          838CDC9C0327D1242171255692A13D64116925E5831609F522D1C3CC32A8A71E
          7CF0A52C1344AC3D0865A695A5A8889882E6726E13256F7F4CD331EFE69DF7FB
          3AFB0642992F75E070F9CE3DE777CE77BE732228A5F03F12F12740BA73594F28
          2DA5849C278424A102EA57D4274422ADDA7B2DEE6D01C1FA4B2594D086B50845
          B2426F80A89898B0DDBB0A82C3013261F50B215275C2FD76FB168078BB0A8349
          F37A420AA731A681C4CF01410D892C390564BA5DE09D7240C039B14624A97C67
          63877D13B05E57998A25F68B49293ACE680471A09B056A6C0FD9D767BB004028
          28AC05B03AF9117C8E315E22C46A68EAF2308060ABB0F923D575B1B9D67030DA
          428571379B18C07BA31C284133F6437DF0282CF47481B8C4D79A5ADEDC620074
          9891992D0679D00F1BB34E74A42C6374FD630658A9390754A24050E5FA7408CA
          95C0BF7BE1CA6CEB4B6380E59A3281CB2B506F7C18041A58C7AE539631F66E33
          032C5D2D6350A6910A50EDCF05F7D347FEBDF6410D037CBF765A88C92F540747
          07800444566A286374E575901BCDB078E50CCBCE2A932B408380E9F607FE7D1D
          2361005F7D6286B3E41AA2440144E7A74D67C59E6C90C52780AFAB239C1DED8A
          74136CA854E079F5CC95D33916BEC27CD5711BE5E2EB12F30E83AFA793398720
          898D6DEC0AFCC553D89230547BAC086611B8B2E0AE3DD03D116EA2BBA23015DF
          B63FDA64D1C59A32C0FBF23973566666018681303AC2CE7145C5B038390EF343
          AF797C766BFE5B87677390A6CEE69720A4599B91CDC599CC1098F540C0E586D0
          7FE5EE54A63F30786EA87B0D83CB0FF54EDBB78CF2F8C99C121C900655BC2E79
          87D9024A6D1C9B87C0CF65F836360CCB9F5D38CAA4FAC87BA7FDAFBB1092E1E2
          2C3D424A71717099A4DF978990D6823ED7F6CBF42FF20B25BFAEF0015EBF0E00
          00000049454E44AE426082}
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
