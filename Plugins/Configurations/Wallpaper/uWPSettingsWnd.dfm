object frmWPSettings: TfrmWPSettings
  Left = 0
  Top = 0
  Width = 461
  Height = 592
  Caption = 'frmWPSettings'
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
    Width = 453
    Height = 563
    ActivePage = JvWPPage
    PropagateEnable = False
    Align = alClient
    object JvWPPage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 453
      Height = 563
      Caption = 'JvWPPage'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 453
        Height = 169
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        DesignSize = (
          453
          169)
        object Label1: TLabel
          Left = 216
          Top = 16
          Width = 54
          Height = 13
          Caption = 'Alignment: '
        end
        object pimage: TImage32
          Left = 16
          Top = 16
          Width = 187
          Height = 144
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baCenter
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 0
        end
        object cb_mhoriz: TCheckBox
          Left = 216
          Top = 72
          Width = 121
          Height = 17
          Caption = 'Mirror Horizontal'
          TabOrder = 1
          OnClick = cb_mhorizClick
        end
        object cb_mvert: TCheckBox
          Left = 336
          Top = 72
          Width = 129
          Height = 17
          Caption = 'Mirror Vertical'
          TabOrder = 2
          OnClick = cb_mhorizClick
        end
        object sgb_wpalpha: TSharpeGaugeBox
          Left = 216
          Top = 136
          Width = 225
          Height = 21
          Min = 0
          Max = 255
          Value = 255
          Prefix = 'Wallpaper Visibility: '
          Suffix = '%'
          Description = 'Adjust to set the Wallpaper Visibility'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgb_cchueChangeValue
        end
        object cb_alignment: TComboBox
          Left = 216
          Top = 32
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 4
          Text = 'Scale'
          OnChange = cb_alignmentChange
          Items.Strings = (
            'Center'
            'Scale'
            'Stretch'
            'Tile')
        end
        object fedit_image: TJvFilenameEdit
          Left = 216
          Top = 104
          Width = 223
          Height = 21
          AddQuotes = False
          Flat = False
          ParentCtl3D = False
          Filter = 
            'All Image Files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.' +
            'bmp'
          DialogTitle = 'Select Wallpaper'
          DirectInput = False
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 5
          OnChange = fedit_imageChange
        end
      end
      object pn_cchange: TPanel
        Left = 0
        Top = 169
        Width = 453
        Height = 128
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object cb_colorchange: TCheckBox
          Left = 8
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Change Color'
          TabOrder = 0
          OnClick = cb_colorchangeClick
        end
        object sgb_cchue: TSharpeGaugeBox
          Left = 24
          Top = 32
          Width = 193
          Height = 21
          Min = -128
          Max = 128
          Value = 0
          Prefix = 'Hue: '
          Description = 'Adjust to set the Hue modification amount'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_cchueChangeValue
        end
        object sgb_ccsat: TSharpeGaugeBox
          Left = 24
          Top = 64
          Width = 193
          Height = 21
          Min = -255
          Max = 255
          Value = 0
          Prefix = 'Saturation: '
          Description = 'Adjust to set the Saturation modification amount'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_cchueChangeValue
        end
        object sgb_cclight: TSharpeGaugeBox
          Left = 24
          Top = 96
          Width = 193
          Height = 21
          Min = -255
          Max = 255
          Value = 0
          Prefix = 'Lightness: '
          Description = 'Adjust to set the lightness modification amount '
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgb_cchueChangeValue
        end
      end
      object pn_gradient: TPanel
        Left = 0
        Top = 297
        Width = 453
        Height = 136
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        DesignSize = (
          453
          136)
        object Label2: TLabel
          Left = 24
          Top = 32
          Width = 28
          Height = 13
          Caption = 'Type:'
        end
        object cb_gradient: TCheckBox
          Left = 8
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Gradient Effect'
          TabOrder = 0
          OnClick = cb_gradientClick
        end
        object sgb_gstartalpha: TSharpeGaugeBox
          Left = 24
          Top = 64
          Width = 193
          Height = 21
          Min = 0
          Max = 255
          Value = 0
          Prefix = 'Start Transparency: '
          Suffix = '%'
          Description = 'Adjust to set the Hue modification amount'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgb_gstartalphaChangeValue
        end
        object sgb_gendalpha: TSharpeGaugeBox
          Left = 24
          Top = 96
          Width = 193
          Height = 21
          Min = 0
          Max = 255
          Value = 255
          Prefix = 'End Transparency: '
          Suffix = '%'
          Description = 'Adjust to set the Saturation modification amount'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgb_gstartalphaChangeValue
        end
        object cb_gtype: TComboBox
          Left = 72
          Top = 32
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          OnChange = cb_gtypeChange
          Items.Strings = (
            'Horizontal'
            'Vertical'
            'Left/Right Horizontal'
            'Top/Bottom Vertical')
        end
        object pgradient: TImage32
          Left = 232
          Top = 32
          Width = 209
          Height = 88
          Anchors = [akLeft, akTop, akRight]
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baCenter
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 4
        end
      end
      object colors: TSharpEColorEditorEx
        Left = 8
        Top = 433
        Width = 437
        Height = 130
        Align = alClient
        AutoSize = True
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        Items = <
          item
            Title = 'Background'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            Visible = True
            ColorEditor = colors.Item0
            Tag = 0
          end
          item
            Title = 'Gradient Start'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            Visible = True
            ColorEditor = colors.Item1
            Tag = 0
          end
          item
            Title = 'Gradient End'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            Visible = True
            ColorEditor = colors.Item2
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
        OnUiChange = colorsUiChange
      end
      object Panel2: TPanel
        Left = 0
        Top = 433
        Width = 8
        Height = 130
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
      end
      object Panel3: TPanel
        Left = 445
        Top = 433
        Width = 8
        Height = 130
        Align = alRight
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 5
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 405
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
    Left = 416
    Top = 192
  end
end
