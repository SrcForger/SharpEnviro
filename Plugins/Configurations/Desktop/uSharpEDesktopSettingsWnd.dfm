object frmDesktopSettings: TfrmDesktopSettings
  Left = 0
  Top = 0
  Width = 384
  Height = 599
  Caption = 'frmDesktopSettings'
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
  object JvPageList1: TJvPageList
    Left = 0
    Top = 0
    Width = 376
    Height = 570
    ActivePage = JvIconPage
    PropagateEnable = False
    Align = alClient
    object JvIconPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 376
      Height = 570
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 376
        Height = 129
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 16
          Width = 57
          Height = 13
          AutoSize = False
          Caption = 'Icon Size'
          Color = clWindow
          ParentColor = False
          WordWrap = True
        end
        object icon32: TImage32
          Left = 48
          Top = 32
          Width = 64
          Height = 64
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baCenter
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 0
        end
        object icon48: TImage32
          Left = 120
          Top = 32
          Width = 64
          Height = 64
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baCenter
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 1
        end
        object icon64: TImage32
          Left = 192
          Top = 32
          Width = 64
          Height = 64
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baCenter
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 2
        end
        object iconcustom: TImage32
          Left = 264
          Top = 32
          Width = 64
          Height = 64
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baCenter
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 3
        end
        object rb_icon32: TRadioButton
          Left = 54
          Top = 96
          Width = 65
          Height = 17
          Caption = '32x32'
          Checked = True
          TabOrder = 4
          TabStop = True
          OnClick = rb_iconcustomClick
        end
        object rb_icon48: TRadioButton
          Left = 128
          Top = 96
          Width = 65
          Height = 17
          Caption = '48x48'
          TabOrder = 5
          OnClick = rb_iconcustomClick
        end
        object rb_icon64: TRadioButton
          Left = 200
          Top = 96
          Width = 65
          Height = 17
          Caption = '64x64'
          TabOrder = 6
          OnClick = rb_iconcustomClick
        end
        object rb_iconcustom: TRadioButton
          Left = 266
          Top = 96
          Width = 65
          Height = 17
          Caption = 'Custom'
          TabOrder = 7
          OnClick = rb_iconcustomClick
        end
      end
      object pn_iconsize: TPanel
        Left = 0
        Top = 129
        Width = 376
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object Panel2: TPanel
          Left = 353
          Top = 0
          Width = 23
          Height = 40
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
        end
        object Panel12: TPanel
          Left = 0
          Top = 0
          Width = 17
          Height = 40
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
        end
        object Panel17: TPanel
          Left = 17
          Top = 0
          Width = 336
          Height = 40
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object sgb_iconsize: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 336
            Height = 21
            Align = alTop
            Min = 12
            Max = 256
            Value = 96
            Prefix = 'Custom Size: '
            Suffix = 'px'
            Description = 'Adjust to set the icon size'
            PopPosition = ppBottom
            PercentDisplay = False
            OnChangeValue = sgb_iconalphaChangeValue
          end
        end
      end
      object pn_alphablendbg: TPanel
        Left = 0
        Top = 169
        Width = 376
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object pn_alphablend: TPanel
          Left = 137
          Top = 0
          Width = 216
          Height = 32
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object sgb_iconalpha: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 216
            Height = 21
            Align = alTop
            Min = 16
            Max = 255
            Value = 192
            Prefix = 'Alpha: '
            Suffix = '%'
            Description = 'Adjust to set the transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sgb_iconalphaChangeValue
          end
        end
        object Panel10: TPanel
          Left = 353
          Top = 0
          Width = 23
          Height = 32
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
        end
        object Panel11: TPanel
          Left = 0
          Top = 0
          Width = 137
          Height = 32
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object cb_alphablend: TCheckBox
            Left = 16
            Top = 2
            Width = 113
            Height = 17
            Caption = 'Alpha Blend Icon'
            TabOrder = 0
            OnClick = cb_alphablendClick
          end
        end
      end
      object IconColors: TSharpEColorEditorEx
        Left = 13
        Top = 265
        Width = 343
        Height = 305
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
        ParentBackground = True
        ParentColor = False
        TabOrder = 3
        Items = <
          item
            Title = 'Color Blending'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ColorEditor = IconColors.Item0
            Tag = 0
          end
          item
            Title = 'Icon Shadow'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ColorEditor = IconColors.Item1
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
      end
      object Panel4: TPanel
        Left = 0
        Top = 265
        Width = 13
        Height = 305
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
      end
      object pn_colorblendbg: TPanel
        Left = 0
        Top = 201
        Width = 376
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 5
        object pn_colorblend: TPanel
          Left = 137
          Top = 0
          Width = 216
          Height = 32
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object sbg_iconcblendalpha: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 216
            Height = 21
            Align = alTop
            Min = 0
            Max = 256
            Value = 255
            Prefix = 'Strength: '
            Suffix = '%'
            Description = 'Adjust to set the color blend strength'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sgb_iconalphaChangeValue
          end
        end
        object Panel13: TPanel
          Left = 353
          Top = 0
          Width = 23
          Height = 32
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
        end
        object Panel14: TPanel
          Left = 0
          Top = 0
          Width = 137
          Height = 32
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object cb_colorblend: TCheckBox
            Left = 16
            Top = 2
            Width = 113
            Height = 17
            Caption = 'Color Blend Icon'
            TabOrder = 0
            OnClick = cb_colorblendClick
          end
        end
      end
      object pn_iconshadowbg: TPanel
        Left = 0
        Top = 233
        Width = 376
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 6
        object pn_iconshadow: TPanel
          Left = 137
          Top = 0
          Width = 216
          Height = 32
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object sgb_iconshadow: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 216
            Height = 21
            Align = alTop
            Min = 0
            Max = 256
            Value = 255
            Prefix = 'Alpha: '
            Suffix = '%'
            Description = 'Adjust to set the shadow alpha'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sgb_iconalphaChangeValue
          end
        end
        object Panel15: TPanel
          Left = 353
          Top = 0
          Width = 23
          Height = 32
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
        end
        object Panel16: TPanel
          Left = 0
          Top = 0
          Width = 137
          Height = 32
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object cb_iconshadow: TCheckBox
            Left = 16
            Top = 2
            Width = 113
            Height = 17
            Caption = 'Icon Shadow'
            TabOrder = 0
            OnClick = cb_iconshadowClick
          end
        end
      end
      object Panel3: TPanel
        Left = 356
        Top = 265
        Width = 20
        Height = 305
        Align = alRight
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 7
      end
    end
    object JvTextPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 376
      Height = 570
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 376
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel5'
        ParentColor = True
        TabOrder = 0
        object Label5: TLabel
          Left = 16
          Top = 16
          Width = 52
          Height = 13
          Caption = 'Font Name'
        end
        object cbxFontName: TComboBox
          Left = 88
          Top = 14
          Width = 247
          Height = 23
          Style = csOwnerDrawVariable
          DropDownCount = 12
          ItemHeight = 17
          TabOrder = 0
          OnChange = cb_boldClick
          OnDrawItem = cbxFontNameDrawItem
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 41
        Width = 376
        Height = 120
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object Label9: TLabel
          Left = 16
          Top = 8
          Width = 19
          Height = 13
          Caption = 'Size'
        end
        object se_fontsize: TJvSpinEdit
          Left = 88
          Top = 6
          Width = 57
          Height = 21
          Alignment = taRightJustify
          ButtonKind = bkClassic
          MaxValue = 128.000000000000000000
          MinValue = 4.000000000000000000
          Value = 12.000000000000000000
          TabOrder = 0
          OnChange = cb_boldClick
        end
        object cb_bold: TCheckBox
          Left = 16
          Top = 40
          Width = 153
          Height = 17
          Caption = 'Bold'
          TabOrder = 1
          OnClick = cb_boldClick
        end
        object cb_italic: TCheckBox
          Left = 16
          Top = 64
          Width = 153
          Height = 17
          Caption = 'Italic'
          TabOrder = 2
          OnClick = cb_boldClick
        end
        object cb_underline: TCheckBox
          Left = 16
          Top = 88
          Width = 153
          Height = 17
          Caption = 'Underline'
          TabOrder = 3
          OnClick = cb_boldClick
        end
      end
      object textcolors: TSharpEColorEditorEx
        Left = 25
        Top = 225
        Width = 331
        Height = 345
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
        ParentBackground = True
        ParentColor = False
        TabOrder = 2
        Items = <
          item
            Title = 'Text'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ColorEditor = textcolors.Item0
            Tag = 0
          end
          item
            Title = 'Shadow'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ColorEditor = textcolors.Item1
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
      end
      object Panel6: TPanel
        Left = 0
        Top = 225
        Width = 25
        Height = 345
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
      end
      object pn_textshadowbg: TPanel
        Left = 0
        Top = 193
        Width = 376
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        object pn_textshadow: TPanel
          Left = 137
          Top = 0
          Width = 216
          Height = 32
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object sgb_textshadow: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 216
            Height = 21
            Align = alTop
            Min = 16
            Max = 255
            Value = 255
            Prefix = 'Alpha: '
            Suffix = '%'
            Description = 'Adjust to set the shadow alpha'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sgb_iconalphaChangeValue
          end
        end
        object Panel20: TPanel
          Left = 353
          Top = 0
          Width = 23
          Height = 32
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
        end
        object Panel21: TPanel
          Left = 0
          Top = 0
          Width = 137
          Height = 32
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object cb_textshadow: TCheckBox
            Left = 16
            Top = 2
            Width = 113
            Height = 17
            Caption = 'Text Shadow'
            TabOrder = 0
            OnClick = cb_textshadowClick
          end
        end
      end
      object pn_fontalphablendbg: TPanel
        Left = 0
        Top = 161
        Width = 376
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 5
        object pn_fontalphablend: TPanel
          Left = 137
          Top = 0
          Width = 216
          Height = 32
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object sgb_fontalphablend: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 216
            Height = 21
            Align = alTop
            Min = 16
            Max = 255
            Value = 192
            Prefix = 'Alpha: '
            Suffix = '%'
            Description = 'Adjust to set the text transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sgb_iconalphaChangeValue
          end
        end
        object Panel24: TPanel
          Left = 353
          Top = 0
          Width = 23
          Height = 32
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
        end
        object Panel25: TPanel
          Left = 0
          Top = 0
          Width = 137
          Height = 32
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object cb_fontalphablend: TCheckBox
            Left = 16
            Top = 2
            Width = 113
            Height = 17
            Caption = 'Alpha Blend Text'
            TabOrder = 0
            OnClick = cb_fontalphablendClick
          end
        end
      end
      object Panel18: TPanel
        Left = 356
        Top = 225
        Width = 20
        Height = 345
        Align = alRight
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 6
      end
    end
    object JvAnimationPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 376
      Height = 570
      object pn_anim: TPanel
        Left = 0
        Top = 49
        Width = 376
        Height = 521
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object pn_animscalebg: TPanel
          Left = 0
          Top = 0
          Width = 376
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object pn_animscale: TPanel
            Left = 137
            Top = 0
            Width = 216
            Height = 32
            Align = alClient
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            object sgb_animscale: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 216
              Height = 21
              Align = alTop
              Min = -64
              Max = 64
              Value = 32
              Prefix = 'Scale by: '
              Suffix = 'px'
              Description = 'Adjust to set the scale size'
              PopPosition = ppBottom
              PercentDisplay = False
              OnChangeValue = sgb_iconalphaChangeValue
            end
          end
          object Panel22: TPanel
            Left = 353
            Top = 0
            Width = 23
            Height = 32
            Align = alRight
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
          end
          object Panel23: TPanel
            Left = 0
            Top = 0
            Width = 137
            Height = 32
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 2
            object cb_animscale: TCheckBox
              Left = 16
              Top = 2
              Width = 113
              Height = 17
              Caption = 'Size'
              TabOrder = 0
              OnClick = cb_animscaleClick
            end
          end
        end
        object pn_animalphabg: TPanel
          Left = 0
          Top = 32
          Width = 376
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object pn_animalpha: TPanel
            Left = 137
            Top = 0
            Width = 216
            Height = 32
            Align = alClient
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            object sgb_animalpha: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 216
              Height = 21
              Align = alTop
              Min = -255
              Max = 255
              Value = 64
              Prefix = 'Change by: '
              Suffix = '%'
              Description = 'Adjust to set the alpha modification value'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = sgb_iconalphaChangeValue
            end
          end
          object Panel26: TPanel
            Left = 353
            Top = 0
            Width = 23
            Height = 32
            Align = alRight
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
          end
          object Panel27: TPanel
            Left = 0
            Top = 0
            Width = 137
            Height = 32
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 2
            object cb_animalpha: TCheckBox
              Left = 16
              Top = 2
              Width = 113
              Height = 17
              Caption = 'Alpha'
              TabOrder = 0
              OnClick = cb_animscaleClick
            end
          end
        end
        object pn_animbrightnessbg: TPanel
          Left = 0
          Top = 64
          Width = 376
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object pn_animbrightness: TPanel
            Left = 137
            Top = 0
            Width = 216
            Height = 32
            Align = alClient
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            object sgb_animbrightness: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 216
              Height = 21
              Align = alTop
              Min = -255
              Max = 255
              Value = 64
              Prefix = 'Change by: '
              Suffix = '%'
              Description = 'Adjust to set the brightness modification value'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = sgb_iconalphaChangeValue
            end
          end
          object Panel28: TPanel
            Left = 353
            Top = 0
            Width = 23
            Height = 32
            Align = alRight
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
          end
          object Panel29: TPanel
            Left = 0
            Top = 0
            Width = 137
            Height = 32
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 2
            object cb_animbrightness: TCheckBox
              Left = 16
              Top = 2
              Width = 113
              Height = 17
              Caption = 'Brightness'
              TabOrder = 0
              OnClick = cb_animscaleClick
            end
          end
        end
        object pn_animcolorblendbg: TPanel
          Left = 0
          Top = 96
          Width = 376
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 3
          object pn_animcolorblend: TPanel
            Left = 137
            Top = 0
            Width = 216
            Height = 32
            Align = alClient
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            object sgb_animcolorblend: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 216
              Height = 21
              Align = alTop
              Min = 0
              Max = 255
              Value = 255
              Prefix = 'Strength: '
              Suffix = '%'
              Description = 'Adjust to set the color blend strength'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = sgb_iconalphaChangeValue
            end
          end
          object Panel30: TPanel
            Left = 353
            Top = 0
            Width = 23
            Height = 32
            Align = alRight
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
          end
          object Panel31: TPanel
            Left = 0
            Top = 0
            Width = 137
            Height = 32
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 2
            object cb_animcolorblend: TCheckBox
              Left = 16
              Top = 2
              Width = 113
              Height = 17
              Caption = 'Color Blend'
              TabOrder = 0
              OnClick = cb_animscaleClick
            end
          end
        end
        object Panel19: TPanel
          Left = 356
          Top = 128
          Width = 20
          Height = 393
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 4
        end
        object animcolors: TSharpEColorEditorEx
          Left = 25
          Top = 128
          Width = 331
          Height = 393
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clWindow
          ParentBackground = True
          ParentColor = False
          TabOrder = 5
          Items = <
            item
              Title = 'Color Blending'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ColorEditor = animcolors.Item0
              Tag = 0
            end>
          SwatchManager = SharpESwatchManager1
        end
        object Panel8: TPanel
          Left = 0
          Top = 128
          Width = 25
          Height = 393
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 6
        end
      end
      object Panel9: TPanel
        Left = 0
        Top = 0
        Width = 376
        Height = 49
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object cb_anim: TCheckBox
          Left = 16
          Top = 16
          Width = 153
          Height = 17
          Caption = 'Enable Hover Animation'
          TabOrder = 0
          OnClick = cb_animClick
        end
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 299
    ShowCaptions = True
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = 16709617
    SortMode = sortName
    Left = 344
    Top = 8
  end
  object imlFontIcons: TImageList
    Left = 376
    Top = 8
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
