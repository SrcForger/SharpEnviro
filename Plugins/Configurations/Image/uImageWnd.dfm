object frmImage: TfrmImage
  Left = 0
  Top = 0
  Caption = 'frmImage'
  ClientHeight = 400
  ClientWidth = 427
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
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 427
    Height = 400
    ActivePage = pagDisplay
    PropagateEnable = False
    Align = alClient
    object pagImage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 400
      object Label4: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 45
        Width = 393
        Height = 20
        Margins.Left = 26
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Supported image types: .bmp, .jpg, .png, .ico'
        EllipsisPosition = epEndEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 49
        ExplicitWidth = 384
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 273
        Width = 393
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Changing this option will to enlarge or shrink the image'
        EllipsisPosition = epEndEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 116
        ExplicitWidth = 384
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Image Source'
        ExplicitWidth = 66
      end
      object Label9: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 252
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Image Scaling'
        ExplicitWidth = 66
      end
      object Label13: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 393
        Height = 16
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select the source the image will be loaded from.'
        EllipsisPosition = epEndEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        ExplicitWidth = 384
      end
      object spc: TSharpEPageControl
        AlignWithMargins = True
        Left = 26
        Top = 68
        Width = 375
        Height = 173
        Margins.Left = 26
        Margins.Right = 26
        Align = alTop
        Color = clWindow
        ExpandedHeight = 200
        TabItems = <
          item
            Caption = 'File'
            ImageIndex = 0
            Visible = True
          end
          item
            Caption = 'URL'
            ImageIndex = 0
            Visible = True
          end>
        RoundValue = 10
        Border = True
        TabWidth = 62
        TabIndex = 0
        TabAlignment = taLeftJustify
        AutoSizeTabs = True
        TabBackgroundColor = clWindow
        BackgroundColor = clBtnFace
        BorderColor = clBlack
        TabColor = 15724527
        TabSelColor = clWhite
        TabCaptionSelColor = clBlack
        TabStatusSelColor = clGreen
        TabCaptionColor = clBlack
        TabStatusColor = clGreen
        OnTabChange = spcTabChange
        DesignSize = (
          375
          173)
        object pl: TJvPageList
          AlignWithMargins = True
          Left = 8
          Top = 34
          Width = 359
          Height = 131
          Margins.Left = 8
          Margins.Top = 34
          Margins.Right = 8
          Margins.Bottom = 8
          ActivePage = pageurl
          PropagateEnable = False
          Align = alClient
          ParentBackground = True
          object pagefile: TJvStandardPage
            Left = 0
            Top = 0
            Width = 359
            Height = 131
            Caption = 'pagefile'
            object Label1: TLabel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 359
              Height = 20
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alTop
              AutoSize = False
              Caption = 'The image will be loaded from a local file.'
              EllipsisPosition = epEndEllipsis
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGrayText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = False
              WordWrap = True
              ExplicitLeft = 18
              ExplicitTop = -3
              ExplicitWidth = 308
            end
            object imagefile: TJvFilenameEdit
              Left = 0
              Top = 20
              Width = 359
              Height = 21
              Align = alTop
              Filter = 
                'All Images (*.bmp,*.jpg,*.jpeg,*.png,*.ico)|*.bmp;*.jpg;*.jpeg;*' +
                '.png;*.ico'
              TabOrder = 0
            end
          end
          object pageurl: TJvStandardPage
            Left = 0
            Top = 0
            Width = 359
            Height = 131
            Caption = 'pageurl'
            ParentBackground = True
            object Label14: TLabel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 359
              Height = 20
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alTop
              AutoSize = False
              Caption = 'The image will be downloaded from a remote internet location'
              EllipsisPosition = epEndEllipsis
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGrayText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = False
              WordWrap = True
              ExplicitLeft = 18
              ExplicitTop = -3
              ExplicitWidth = 308
            end
            object Label6: TLabel
              AlignWithMargins = True
              Left = 0
              Top = 49
              Width = 351
              Height = 13
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alTop
              Caption = 'Refresh Interval'
              ExplicitWidth = 79
            end
            object Label7: TLabel
              AlignWithMargins = True
              Left = 8
              Top = 70
              Width = 351
              Height = 20
              Margins.Left = 8
              Margins.Top = 8
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alTop
              AutoSize = False
              Caption = 'Change the update interval at which the image is downloaded'
              EllipsisPosition = epEndEllipsis
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGrayText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = False
              WordWrap = True
              ExplicitWidth = 342
            end
            object imageurl: TEdit
              Left = 0
              Top = 20
              Width = 359
              Height = 21
              Align = alTop
              TabOrder = 0
              Text = 'http://'
            end
            object Panel1: TPanel
              Left = 0
              Top = 90
              Width = 359
              Height = 31
              Align = alTop
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
              object SharpeGaugeBox1: TSharpeGaugeBox
                AlignWithMargins = True
                Left = 8
                Top = 6
                Width = 174
                Height = 25
                Margins.Left = 8
                Margins.Top = 6
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alLeft
                Color = clWindow
                Min = 5
                Max = 60
                Value = 30
                Prefix = 'Refresh Interval: '
                Suffix = ' minutes'
                Description = 'Scale image by'
                PopPosition = ppRight
                PercentDisplay = False
                OnChangeValue = sgb_sizeChangeValue
              end
            end
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 293
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object sgb_size: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 6
          Width = 190
          Height = 25
          Margins.Left = 26
          Margins.Top = 6
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          Color = clWindow
          Min = 5
          Max = 200
          Value = 100
          Prefix = 'Scale: '
          Suffix = '%'
          Description = 'Scale image by'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = sgb_sizeChangeValue
        end
      end
    end
    object pagDisplay: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 400
      Caption = 'pagDisplay'
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 427
        Height = 85
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        ExplicitLeft = 3
        ExplicitTop = -3
        object Label3: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 33
          Width = 393
          Height = 20
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'This option controls the color blend strength. 100% Image will b' +
            'e fully blended.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
          ExplicitTop = 29
          ExplicitWidth = 528
        end
        object UIC_colorblend: TSharpEUIC
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 415
          Height = 25
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          Caption = 'UIC_colorblend'
          ParentBackground = False
          TabOrder = 0
          RoundValue = 10
          BorderColor = clBtnShadow
          Border = True
          BackgroundColor = clBtnFace
          HasChanged = True
          AutoReset = True
          DefaultValue = 'True'
          MonitorControl = cbcolorblend
          NormalColor = clWhite
          ExplicitLeft = 0
          ExplicitTop = 25
          ExplicitWidth = 427
          object cbcolorblend: TCheckBox
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 407
            Height = 17
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Image Color Blend'
            TabOrder = 0
            OnClick = cbcolorblendClick
            ExplicitLeft = 8
            ExplicitTop = 8
            ExplicitWidth = 411
          end
        end
        object UIC_alpha: TSharpEUIC
          AlignWithMargins = True
          Left = 22
          Top = 53
          Width = 397
          Height = 29
          Margins.Left = 22
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 4
          Align = alTop
          BevelOuter = bvNone
          Caption = 'UIC_alpha'
          ParentBackground = False
          TabOrder = 1
          RoundValue = 10
          BorderColor = clBtnShadow
          Border = True
          BackgroundColor = clBtnFace
          HasChanged = True
          AutoReset = True
          DefaultValue = '100'
          MonitorControl = sbgimagencblendalpha
          NormalColor = clWhite
          ExplicitLeft = 0
          ExplicitWidth = 427
          object sbgimagencblendalpha: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 148
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alLeft
            Min = 16
            Max = 255
            Value = 192
            Prefix = 'Blend Strength: '
            Suffix = '%'
            Description = 'Adjust to set the blend strength'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sbgimagencblendalphaChangeValue
            ExplicitLeft = 25
            ExplicitTop = 8
          end
        end
      end
      object Panel10: TPanel
        Left = 0
        Top = 170
        Width = 427
        Height = 230
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        ExplicitTop = 173
        ExplicitHeight = 227
        object Label10: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 393
          Height = 19
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Define Image color options below.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          ExplicitTop = 25
          ExplicitWidth = 528
        end
        object Label11: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 411
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Image Color Options'
          ExplicitWidth = 546
        end
        object UIC_Colors: TSharpEUIC
          AlignWithMargins = True
          Left = 20
          Top = 50
          Width = 399
          Height = 41
          Margins.Left = 20
          Margins.Top = 2
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
          AutoReset = True
          DefaultValue = '0'
          MonitorControl = IconColors
          NormalColor = clWhite
          ExplicitLeft = 7
          ExplicitTop = 48
          ExplicitWidth = 185
          object IconColors: TSharpEColorEditorEx
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 361
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 34
            Margins.Bottom = 4
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            Align = alTop
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            ParentBackground = True
            TabOrder = 0
            OnResize = IconColorsResize
            Items = <
              item
                Title = 'Color Blending'
                ColorCode = 0
                ColorAsTColor = clBlack
                Expanded = False
                ValueEditorType = vetColor
                Value = 0
                Visible = True
                ColorEditor = IconColors.Item0
                Tag = 0
              end>
            OnChangeColor = IconColorsChangeColor
            ExplicitLeft = 24
            ExplicitTop = 54
            ExplicitWidth = 399
            ExplicitHeight = 169
          end
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 85
        Width = 427
        Height = 85
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 2
        ExplicitTop = -3
        object Label12: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 33
          Width = 393
          Height = 20
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'This option controls the Image transparency. 100% visible.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
          ExplicitTop = 29
          ExplicitWidth = 528
        end
        object UIC_alphablend: TSharpEUIC
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 415
          Height = 25
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          Caption = 'UIC_colorblend'
          ParentBackground = False
          TabOrder = 0
          RoundValue = 10
          BorderColor = clBtnShadow
          Border = True
          BackgroundColor = clBtnFace
          HasChanged = True
          AutoReset = True
          DefaultValue = 'True'
          MonitorControl = cbalphablend
          NormalColor = clWhite
          ExplicitLeft = 0
          ExplicitTop = 25
          ExplicitWidth = 427
          object cbalphablend: TCheckBox
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 407
            Height = 17
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Image Color Blend'
            TabOrder = 0
            OnClick = cbalphablendClick
            ExplicitWidth = 411
          end
        end
        object UIC_blendalpha: TSharpEUIC
          AlignWithMargins = True
          Left = 22
          Top = 53
          Width = 397
          Height = 29
          Margins.Left = 22
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 4
          Align = alTop
          BevelOuter = bvNone
          Caption = 'UIC_blendalpha'
          ParentBackground = False
          TabOrder = 1
          RoundValue = 10
          BorderColor = clBtnShadow
          Border = True
          BackgroundColor = clBtnFace
          HasChanged = True
          AutoReset = True
          DefaultValue = '100'
          MonitorControl = sgbiconalpha
          NormalColor = clWhite
          ExplicitLeft = 0
          ExplicitWidth = 427
          object sgbiconalpha: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 148
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alLeft
            Min = 16
            Max = 255
            Value = 192
            Prefix = 'Transparency: '
            Suffix = '%'
            Description = 'Adjust to set the transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = sgbiconalphaChangeValue
          end
        end
      end
    end
  end
end
