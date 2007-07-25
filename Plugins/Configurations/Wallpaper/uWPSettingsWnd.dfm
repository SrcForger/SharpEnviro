object frmWPSettings: TfrmWPSettings
  Left = 0
  Top = 0
  Caption = 'frmWPSettings'
  ClientHeight = 556
  ClientWidth = 445
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
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 445
    Height = 556
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object srr_bg: TSharpERoundPanel
      Left = 5
      Top = 30
      Width = 435
      Height = 521
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 2
      Ctl3D = True
      ParentBackground = False
      ParentColor = True
      ParentCtl3D = False
      TabOrder = 0
      VerticalAlignment = taAlignTop
      DrawMode = srpNoTopLeft
      NoTopBorder = False
      RoundValue = 10
      BorderColor = clBtnFace
      Border = True
      BackgroundColor = clBtnFace
      object JvPageList1: TJvPageList
        Left = 2
        Top = 2
        Width = 431
        Height = 517
        ActivePage = JvWPPage
        PropagateEnable = False
        Align = alClient
        object JvWPPage: TJvStandardPage
          Left = 0
          Top = 0
          Width = 431
          Height = 517
          Caption = 'JvWPPage'
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 431
            Height = 217
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            DesignSize = (
              431
              217)
            object Label1: TLabel
              Left = 216
              Top = 16
              Width = 54
              Height = 13
              Caption = 'Alignment: '
            end
            object wpimage: TImage32
              Left = 16
              Top = 16
              Width = 187
              Height = 144
              Bitmap.ResamplerClassName = 'TNearestResampler'
              BitmapAlign = baTopLeft
              Scale = 1.000000000000000000
              ScaleMode = smNormal
              TabOrder = 0
            end
            object cb_mhoriz: TCheckBox
              Left = 216
              Top = 64
              Width = 121
              Height = 17
              Caption = 'Mirror Horizontal'
              TabOrder = 1
              OnClick = cb_mhorizClick
            end
            object cb_mvert: TCheckBox
              Left = 216
              Top = 88
              Width = 129
              Height = 17
              Caption = 'Mirror Vertical'
              TabOrder = 2
              OnClick = cb_mhorizClick
            end
            object sgb_wpalpha: TSharpeGaugeBox
              Left = 216
              Top = 136
              Width = 193
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
              Left = 16
              Top = 176
              Width = 417
              Height = 21
              AddQuotes = False
              Flat = False
              ParentFlat = False
              Filter = 
                'All Image Files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.' +
                'bmp'
              DialogTitle = 'Select Wallpaper'
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 5
              OnChange = fedit_imageChange
              OnKeyUp = fedit_imageKeyUp
            end
          end
          object wpcolors: TSharpEColorEditorEx
            Left = 8
            Top = 217
            Width = 415
            Height = 300
            Align = alClient
            AutoSize = True
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clWindow
            ParentColor = False
            TabOrder = 1
            Items = <
              item
                Title = 'Background'
                ColorCode = 0
                ColorAsTColor = clBlack
                Expanded = False
                ValueEditorType = vetColor
                Value = 0
                Visible = True
                ColorEditor = wpcolors.Item0
                Tag = 0
              end>
            SwatchManager = SharpESwatchManager1
            OnUiChange = wpcolorsUiChange
          end
          object Panel2: TPanel
            Left = 0
            Top = 217
            Width = 8
            Height = 300
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 2
          end
          object Panel3: TPanel
            Left = 423
            Top = 217
            Width = 8
            Height = 300
            Align = alRight
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 3
          end
        end
        object JvCCPage: TJvStandardPage
          Left = 0
          Top = 0
          Width = 431
          Height = 517
          Caption = 'JvCCPage'
          ExplicitWidth = 439
          ExplicitHeight = 524
          object pn_cchange: TPanel
            Left = 0
            Top = 0
            Width = 439
            Height = 193
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
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
              Left = 216
              Top = 40
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
              Left = 216
              Top = 72
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
              Left = 216
              Top = 104
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
            object ccimage: TImage32
              Left = 16
              Top = 36
              Width = 187
              Height = 144
              Bitmap.ResamplerClassName = 'TNearestResampler'
              BitmapAlign = baTopLeft
              Scale = 1.000000000000000000
              ScaleMode = smNormal
              TabOrder = 4
            end
          end
        end
        object JvGDPage: TJvStandardPage
          Left = 0
          Top = 0
          Width = 431
          Height = 517
          Caption = 'JvGDPage'
          object pn_gradient: TPanel
            Left = 0
            Top = 0
            Width = 431
            Height = 145
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            ExplicitWidth = 439
            object Label2: TLabel
              Left = 233
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
              Left = 232
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
              Left = 232
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
              Left = 281
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
              Left = 16
              Top = 36
              Width = 193
              Height = 88
              Bitmap.ResamplerClassName = 'TNearestResampler'
              BitmapAlign = baCenter
              Scale = 1.000000000000000000
              ScaleMode = smNormal
              TabOrder = 4
            end
          end
          object gdcolors: TSharpEColorEditorEx
            Left = 8
            Top = 145
            Width = 415
            Height = 372
            Align = alClient
            AutoSize = True
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clWindow
            ParentColor = False
            TabOrder = 1
            Items = <
              item
                Title = 'Gradient Start'
                ColorCode = 0
                ColorAsTColor = clBlack
                Expanded = False
                ValueEditorType = vetColor
                Value = 0
                Visible = True
                ColorEditor = gdcolors.Item0
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
                ColorEditor = gdcolors.Item1
                Tag = 0
              end>
            SwatchManager = SharpESwatchManager1
            OnUiChange = wpcolorsUiChange
          end
          object Panel4: TPanel
            Left = 423
            Top = 145
            Width = 8
            Height = 372
            Align = alRight
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 2
            ExplicitLeft = 431
            ExplicitHeight = 379
          end
          object Panel5: TPanel
            Left = 0
            Top = 145
            Width = 8
            Height = 372
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 3
            ExplicitHeight = 379
          end
        end
      end
    end
    object tabs: TSharpETabList
      Left = 5
      Top = 5
      Width = 435
      Height = 25
      Align = alTop
      OnTabChange = tabsTabChange
      TabWidth = 62
      TabIndex = 0
      TabColor = 16250871
      TabSelectedColor = 12644838
      BkgColor = clWindow
      CaptionSelectedColor = clBlack
      StatusSelectedColor = 12644838
      CaptionUnSelectedColor = clBlack
      StatusUnSelectedColor = 12644838
      TabAlign = taLeftJustify
      AutoSizeTabs = True
      BottomBorder = False
      Border = True
      BorderColor = 16510947
      BorderSelectedColor = 16510947
      TabList = <
        item
          Caption = 'Wallpaper'
          ImageIndex = 0
          Visible = True
        end
        item
          Caption = 'Color Modification'
          ImageIndex = 0
          Visible = True
        end
        item
          Caption = 'Gradient'
          ImageIndex = 0
          Visible = True
        end>
      Minimized = False
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 383
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
    Left = 408
    Top = 248
  end
end
