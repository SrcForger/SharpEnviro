object frmFont: TfrmFont
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmFont'
  ClientHeight = 436
  ClientWidth = 434
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 0
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 0
    ExplicitTop = 21
  end
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 434
    Height = 436
    ActivePage = pagFont
    PropagateEnable = False
    Align = alClient
    ExplicitTop = 21
    ExplicitHeight = 415
    object pagFont: TJvStandardPage
      Left = 0
      Top = 0
      Width = 434
      Height = 436
      Caption = 'pagFont'
      ExplicitHeight = 415
      object Label4: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 400
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select from the list of type faces below'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitTop = 49
        ExplicitWidth = 384
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 108
        Width = 400
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Changing this value increases/decreases the size of the font'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitTop = 116
        ExplicitWidth = 384
      end
      object Label6: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 187
        Width = 400
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Changing this value will make the font more or less transparent'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitTop = 179
        ExplicitWidth = 384
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 418
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Type'
        ExplicitWidth = 49
      end
      object Label9: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 87
        Width = 418
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Size'
        ExplicitWidth = 44
      end
      object Label10: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 166
        Width = 418
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Visiblity'
        ExplicitWidth = 60
      end
      object Label7: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 266
        Width = 400
        Height = 16
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select from the available font styles below'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitLeft = 8
        ExplicitTop = 258
        ExplicitWidth = 402
      end
      object Label11: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 245
        Width = 418
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Style'
        ExplicitWidth = 49
      end
      object UIC_Size: TSharpEUIC
        AlignWithMargins = True
        Left = 28
        Top = 132
        Width = 398
        Height = 26
        Margins.Left = 28
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Caption = 'UIC_Size'
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        RoundValue = 10
        BorderColor = clBtnShadow
        Border = True
        BackgroundColor = clBtnFace
        HasChanged = False
        AutoReset = True
        DefaultValue = '0'
        MonitorControl = sgb_size
        NormalColor = clWhite
        OnReset = UIC_Reset
        object sgb_size: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 2
          Top = 2
          Width = 170
          Height = 22
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Align = alLeft
          ParentBackground = False
          Min = -8
          Max = 8
          Value = 0
          Prefix = 'Size: '
          Suffix = 'px'
          Description = 'Change font size by'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_sizeChangeValue
        end
      end
      object UIC_FontType: TSharpEUIC
        AlignWithMargins = True
        Left = 28
        Top = 53
        Width = 398
        Height = 26
        Margins.Left = 28
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        RoundValue = 10
        BorderColor = clBtnShadow
        Border = True
        BackgroundColor = clWindow
        HasChanged = False
        AutoReset = False
        DefaultValue = '-1'
        MonitorControl = cbxFontName
        NormalColor = clWhite
        OnReset = UIC_Reset
        object cbxFontName: TComboBox
          AlignWithMargins = True
          Left = 2
          Top = 2
          Width = 170
          Height = 23
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Align = alLeft
          Style = csOwnerDrawVariable
          DropDownCount = 12
          ItemHeight = 17
          TabOrder = 0
          OnChange = cbxFontNameChange
          OnDrawItem = cbxFontNameDrawItem
        end
      end
      object UIC_Alpha: TSharpEUIC
        AlignWithMargins = True
        Left = 28
        Top = 211
        Width = 398
        Height = 26
        Margins.Left = 28
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Caption = 'UIC_Size'
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        RoundValue = 10
        BorderColor = clBtnShadow
        Border = True
        BackgroundColor = clBtnFace
        HasChanged = False
        AutoReset = True
        DefaultValue = '0'
        MonitorControl = sgb_alpha
        NormalColor = clWhite
        OnReset = UIC_Reset
        object sgb_alpha: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 2
          Top = 2
          Width = 170
          Height = 22
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Align = alLeft
          ParentBackground = False
          Min = -255
          Max = 255
          Value = 0
          Prefix = 'Transparency: '
          Suffix = '%'
          Description = 'Change font opacity'
          PopPosition = ppRight
          PercentDisplay = True
          OnChangeValue = sgb_alphaChangeValue
        end
      end
      object UIC_Bold: TSharpEUIC
        AlignWithMargins = True
        Left = 28
        Top = 346
        Width = 398
        Height = 26
        Margins.Left = 28
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 3
        RoundValue = 10
        BorderColor = clBtnShadow
        Border = True
        BackgroundColor = clBtnFace
        HasChanged = False
        AutoReset = False
        DefaultValue = 'False'
        MonitorControl = cb_bold
        NormalColor = clWhite
        OnReset = UIC_Reset
        object cb_bold: TCheckBox
          Left = 6
          Top = 4
          Width = 97
          Height = 17
          Caption = 'Bold'
          TabOrder = 0
          OnClick = cb_boldClick
        end
      end
      object UIC_Italic: TSharpEUIC
        AlignWithMargins = True
        Left = 28
        Top = 286
        Width = 398
        Height = 26
        Margins.Left = 28
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 4
        RoundValue = 10
        BorderColor = clBtnShadow
        Border = True
        BackgroundColor = clBtnFace
        HasChanged = False
        AutoReset = False
        DefaultValue = 'False'
        MonitorControl = cb_Italic
        NormalColor = clWhite
        OnReset = UIC_Reset
        object cb_Italic: TCheckBox
          Left = 6
          Top = 6
          Width = 103
          Height = 17
          Caption = 'Italic'
          TabOrder = 0
          OnClick = cb_ItalicClick
        end
      end
      object UIC_Underline: TSharpEUIC
        AlignWithMargins = True
        Left = 28
        Top = 316
        Width = 398
        Height = 26
        Margins.Left = 28
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Caption = 'UIC_Size'
        Color = clWhite
        ParentBackground = False
        TabOrder = 5
        RoundValue = 10
        BorderColor = clBtnShadow
        Border = True
        BackgroundColor = clBtnFace
        HasChanged = False
        AutoReset = False
        DefaultValue = 'False'
        MonitorControl = cb_Underline
        NormalColor = clWhite
        OnReset = UIC_Reset
        object cb_Underline: TCheckBox
          Left = 6
          Top = 4
          Width = 97
          Height = 17
          Caption = 'Underline'
          TabOrder = 0
          OnClick = cb_UnderlineClick
        end
      end
    end
    object pagFontShadow: TJvStandardPage
      Left = 0
      Top = 0
      Width = 434
      Height = 436
      Caption = 'pagFontShadow'
      ExplicitHeight = 415
      object Label8: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 38
        Width = 400
        Height = 20
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        AutoSize = False
        Caption = 'Enable/Disable drawing of font shadows'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
        ExplicitLeft = 8
        ExplicitTop = 26
        ExplicitWidth = 402
      end
      object UIC_Shadow: TSharpEUIC
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 418
        Height = 26
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Caption = 'UIC_Size'
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        RoundValue = 10
        BorderColor = clBtnShadow
        Border = True
        BackgroundColor = clBtnFace
        HasChanged = False
        AutoReset = False
        DefaultValue = 'False'
        MonitorControl = cb_shadow
        NormalColor = clWhite
        OnReset = UIC_Reset
        object cb_shadow: TCheckBox
          Left = 0
          Top = 0
          Width = 97
          Height = 26
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Align = alLeft
          Caption = 'Font Shadow'
          TabOrder = 0
          OnClick = cb_shadowClick
        end
      end
      object textpanel: TPanel
        Left = 0
        Top = 66
        Width = 434
        Height = 370
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        ExplicitHeight = 349
        object lb_shadowtype: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 400
          Height = 20
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Select from different shadow render types below'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
          ExplicitLeft = 28
          ExplicitTop = 21
          ExplicitWidth = 385
        end
        object lb_shadowalpha: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 116
          Width = 400
          Height = 20
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'Changing this value will make the font shadow more or less trans' +
            'parent'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
          ExplicitLeft = 33
          ExplicitTop = 95
          ExplicitWidth = 385
        end
        object Label12: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 418
          Height = 13
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Shadow Type'
          ExplicitWidth = 65
        end
        object Label3: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 95
          Width = 418
          Height = 13
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Shadow Transparency'
          ExplicitWidth = 107
        end
        object UIC_ShadowType: TSharpEUIC
          AlignWithMargins = True
          Left = 26
          Top = 53
          Width = 400
          Height = 26
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          RoundValue = 10
          BorderColor = clBtnShadow
          Border = True
          BackgroundColor = clBtnFace
          HasChanged = True
          AutoReset = False
          DefaultValue = '-1'
          MonitorControl = cb_shadowtype
          NormalColor = clWhite
          OnReset = UIC_Reset
          object cb_shadowtype: TComboBox
            AlignWithMargins = True
            Left = 2
            Top = 2
            Width = 170
            Height = 23
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alLeft
            Style = csOwnerDrawFixed
            DropDownCount = 12
            ItemHeight = 17
            ItemIndex = 0
            TabOrder = 0
            Text = 'Left'
            OnChange = cb_shadowtypeChange
            Items.Strings = (
              'Left'
              'Right'
              'Outline')
          end
        end
        object UIC_ShadowAlpha: TSharpEUIC
          AlignWithMargins = True
          Left = 26
          Top = 140
          Width = 400
          Height = 29
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alTop
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          RoundValue = 10
          BorderColor = clBtnShadow
          Border = True
          BackgroundColor = clBtnFace
          HasChanged = False
          AutoReset = True
          DefaultValue = '0'
          MonitorControl = sgb_shadowalpha
          NormalColor = clWhite
          OnReset = UIC_Reset
          object sgb_shadowalpha: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 2
            Top = 2
            Width = 170
            Height = 25
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alLeft
            ParentBackground = False
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Shadow Transparency: '
            Suffix = '%'
            Description = 'Change shadow opacity'
            PopPosition = ppRight
            PercentDisplay = True
            OnChangeValue = sgb_shadowalphaChangeValue
          end
        end
      end
    end
  end
  object imlFontIcons: TImageList
    Left = 372
    Top = 4
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FAFEFD00C6EEE600C6EEE600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FDFCFC00E9DDDF00E9DDDF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FCFCFC00DFDFDF00DFDFDF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FBFEFD00C7EDE50086D9C80074D4C0007CD7C400EDFAF7000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFCFD00E8DDDF00CFB6BB00C7ABB000CBB1B500F8F4F5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFDFD00DFDFDF00BBBBBB00B0B0B000B5B5B500F5F5F5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FCFE
      FD00E0F5F000A0E1D30064CDB60066CEB80094DDCD00B4E7DC00BFECE2000000
      000000000000000000000000000000000000000000000000000000000000FEFD
      FD00EDE4E600D9C6C800DFD0D300D3BEC100D4BEC200E1D2D500E6D9DB000000
      000000000000000000000000000000000000000000000000000000000000FDFD
      FD00EEEEEE00D9D9D900C1C1C100A9A9A900AAAAAA00ACACAC00DBDBDB000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9FDFC00BDE9E000B7E7
      DC0000000000ABE3D60059C8B0005BC9B200AEE4D90000000000B0E5DA00DDF5
      F0000000000000000000000000000000000000000000FDFCFC00F1EBEC000000
      0000DCCBCE00DCCCCF0000000000DDCDD000DECED00000000000DFCFD200F8F5
      F5000000000000000000000000000000000000000000FCFCFC00ECECEC000000
      00000000000000000000D1D1D100BEBEBE00A5A5A500A5A5A500D3D3D3000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000096DBCC0049C1A700A4E0
      D30000000000A5E0D4004EC3A90050C4AC00A8E2D60000000000A8E2D5008ADA
      C900FEFFFE0000000000000000000000000000000000D3BFC200D9C8CB000000
      0000DAC8CB0000000000DAC9CC00CCB4B800DBCACD0000000000DBCACD00E7DC
      DE000000000000000000000000000000000000000000C4C4C400B8B8B800CDCD
      CD00CDCDCD00CDCDCD0000000000CECECE009F9F9F009F9F9F00CFCFCF000000
      0000FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4DFD20040BDA1009FDE
      D00000000000A1DED00044BEA30045BFA400A2DFD20000000000A4E0D30050C4
      AC00CEF1EA0000000000000000000000000000000000D9C7CB00D7C5C8000000
      00000000000000000000D8C6C900C8AEB200D8C6C90000000000000000000000
      00000000000000000000000000000000000000000000CDCDCD00B4B4B400CACA
      CA000000000000000000CBCBCB00B5B5B50098989800B7B7B700CDCDCD000000
      0000F1F1F1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C5EBE20071CDB9009BDC
      CD00000000009CDCCE0073CEBA0074CEBC009EDDCF0000000000A4E0D30082D4
      C3007DD6C300FBFEFD00000000000000000000000000E7DCDE00D5C2C5000000
      0000D5C2C600D5C2C60000000000D6C3C600D6C3C70000000000D9C8CB00DAC9
      CC0000000000FEFDFD00000000000000000000000000DFDFDF00C8C8C8000000
      0000C8C8C800C8C8C800C9C9C900B2B2B200B2B2B200CACACA0000000000CECE
      CE0000000000FDFDFD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1F4F00097DACC000000
      0000000000000000000098DACC009BDBCD00000000000000000000000000A9E2
      D5005AC8B100CBEFE800000000000000000000000000F2EDEE00D3BFC3000000
      00000000000000000000D3C0C400C3A8AD00C5ABB000D8C6C900000000000000
      0000DDCDCF00F0E9EA00000000000000000000000000EEEEEE00ADADAD00C5C5
      C500000000000000000000000000C8C8C800C9C9C90000000000CDCDCD00BCBC
      BC00D1D1D1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FCFB0075CDBA0092D8
      C90093D8CA0095D9CA006ECCB70073CEB9009FDED000A3DFD300A6E1D40086D7
      C6005CCAB30083D8C600FEFFFF000000000000000000FCFAFB00C4AAAF00D1BC
      C000D1BDC000D2BEC200C2A7AC00AD878E00AF8B9100C8B0B400DAC9CC00DCCB
      CE00D0B9BD00CCB4B800FFFEFE000000000000000000FBFBFB0093939300AAAA
      AA00C3C3C300C5C5C500C7C7C700B2B2B200B4B4B400CCCCCC00B9B9B900A0A0
      A000BFBFBF00DCDCDC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006ECAB60024B0
      91002AB2950030B5990036B89B003CBBA10043BEA3004AC1A80050C4AC0057C7
      AE005ECBB40065CEB700CBEFE700000000000000000000000000C1A6AB00A279
      8100A47D8400A8818800AA848B00AD888E00B18D9300B4919700B7959B00BA99
      9F00BD9EA300C1A2A700EAE0E200000000000000000000000000AFAFAF008686
      8600898989008D8D8D009090900093939300979797009B9B9B009E9E9E00A1A1
      A100A5A5A500A9A9A900E2E2E200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F8FCFB006DCA
      B7002CB3970031B69A0037B99C003EBCA00044BEA5004AC1A90051C5AD0058C8
      AF005FCBB50087D9C700D9F3EE00000000000000000000000000FCFBFB00C1A5
      AA00A57E8500A8818800AB858C00AE899000B18D9300B4919700B8969C00BB9A
      A000BD9EA300CEB7BB00F0E8EA00000000000000000000000000FBFBFB00AEAE
      AE008A8A8A008D8D8D009191910094949400979797009B9B9B009F9F9F00A2A2
      A200A5A5A500BCBCBC00EAEAEA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FDFE
      FE007BD0BE0032B69A0038B99D003EBCA00044BFA4004AC2A80055C5AD008DD9
      C800D7F2EC00FEFFFF000000000000000000000000000000000000000000FEFE
      FE00C7AFB300A8828900AC868D00AE899000B18D9300B4919700B9989E00D1BA
      BE00EFE7E800000000000000000000000000000000000000000000000000FEFE
      FE00B6B6B6008E8E8E009292920094949400979797009B9B9B00A0A0A000C0C0
      C000E9E9E9000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008CD6C70038B99D003EBCA1004FC3A90097DBCD00E4F6F2000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CEB9BD00AC868D00AE899000B6949900D3C0C300F4EFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00092929200949494009D9D9D00C5C5C500F0F0F0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009EDDCF009CDCCF00EDF9F60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6C3C700D6C3C600F8F4F50000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C9C9C900C8C8C800F5F5F50000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FE3FFE3FFE3F0000
      F81FF81FF81F0000E01FE01FE01F0000800F8007800F00008007800780070000
      8007800780070000800380038003000080038003800300008001800180030000
      C001C001C0010000C001C001C0010000E003E007E0070000F81FF81FF81F0000
      FC7FFC7FFC7F0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
end
