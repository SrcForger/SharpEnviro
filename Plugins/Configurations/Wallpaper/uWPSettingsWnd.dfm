object frmWPSettings: TfrmWPSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmWPSettings'
  ClientHeight = 566
  ClientWidth = 491
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object plConfig: TJvPageList
    AlignWithMargins = True
    Left = 0
    Top = 91
    Width = 491
    Height = 475
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ActivePage = pagWallpaper
    PropagateEnable = False
    Align = alClient
    object pagWallpaper: TJvStandardPage
      Left = 0
      Top = 0
      Width = 491
      Height = 475
      Caption = 'pagWallpaper'
      object lblWpFile: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 475
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Filename'
        ExplicitLeft = 12
        ExplicitTop = 12
        ExplicitWidth = 429
      end
      object lblWpFileDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 457
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Please select the wallpaper filename for this monitor'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitLeft = 30
        ExplicitTop = 33
        ExplicitWidth = 411
      end
      object lblWpAlign: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 82
        Width = 475
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Alignment'
        ExplicitLeft = 36
        ExplicitTop = 124
        ExplicitWidth = 429
      end
      object lblWpAlignDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 103
        Width = 457
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Please select the wallpaper desired alignment '
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitTop = 122
        ExplicitWidth = 411
      end
      object lblWpMirror: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 157
        Width = 475
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Mirror'
        ExplicitLeft = 13
        ExplicitTop = 201
        ExplicitWidth = 429
      end
      object lblWpMirrorDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 178
        Width = 457
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Please select the wallpaper mirror options '
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitLeft = 31
        ExplicitTop = 197
        ExplicitWidth = 411
      end
      object lblWpTrans: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 232
        Width = 475
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Transparency'
        ExplicitLeft = 44
        ExplicitTop = 301
        ExplicitWidth = 429
      end
      object lblWpTransDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 253
        Width = 457
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Changing this value will make the wallpaper more or less transpa' +
          'rent'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitLeft = 62
        ExplicitTop = 297
        ExplicitWidth = 411
      end
      object lblWpColor: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 306
        Width = 475
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Wallpaper Color Options'
        ExplicitLeft = -8
        ExplicitTop = 471
        ExplicitWidth = 562
      end
      object lblWpColorDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 327
        Width = 457
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Define wallpaper color options below.'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitTop = 367
        ExplicitWidth = 494
      end
      object Panel6: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 52
        Width = 455
        Height = 22
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        object edtWpFile: TEdit
          Left = 0
          Top = 0
          Width = 377
          Height = 22
          Margins.Left = 28
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alClient
          TabOrder = 0
          Text = 'edtWpFile'
          OnChange = edtWallpaperChange
          ExplicitHeight = 21
        end
        object btnWpBrowse: TButton
          AlignWithMargins = True
          Left = 380
          Top = 0
          Width = 75
          Height = 22
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alRight
          Caption = 'Browse'
          TabOrder = 1
          OnClick = btnWpBrowseClick
        end
      end
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 126
        Width = 455
        Height = 23
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 1
        object rdoWpAlignStretch: TRadioButton
          Left = 138
          Top = 0
          Width = 69
          Height = 23
          Align = alLeft
          Caption = 'Stretch'
          TabOrder = 0
          OnClick = AlignmentChangeEvent
        end
        object rdoWpAlignScale: TRadioButton
          Left = 69
          Top = 0
          Width = 69
          Height = 23
          Align = alLeft
          Caption = 'Scale'
          TabOrder = 1
          OnClick = AlignmentChangeEvent
        end
        object rdoWpAlignCenter: TRadioButton
          Left = 0
          Top = 0
          Width = 69
          Height = 23
          Align = alLeft
          Caption = 'Center'
          Checked = True
          TabOrder = 2
          TabStop = True
          OnClick = AlignmentChangeEvent
        end
        object rdoWpAlignTile: TRadioButton
          Left = 207
          Top = 0
          Width = 69
          Height = 23
          Align = alLeft
          Caption = 'Tile'
          TabOrder = 3
          OnClick = AlignmentChangeEvent
        end
      end
      object Panel8: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 201
        Width = 455
        Height = 23
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 2
        object chkWpMirrorVert: TCheckBox
          Left = 81
          Top = 0
          Width = 97
          Height = 23
          Align = alLeft
          Caption = 'Vertical'
          TabOrder = 0
          OnClick = MirrorChangeEvent
        end
        object chkWpMirrorHoriz: TCheckBox
          Left = 0
          Top = 0
          Width = 81
          Height = 23
          Align = alLeft
          Caption = 'Horizontal'
          TabOrder = 1
          OnClick = MirrorChangeEvent
        end
      end
      object imgWallpaper: TImage32
        Left = 309
        Top = 99
        Width = 150
        Height = 150
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baTopLeft
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 3
        Visible = False
      end
      object Panel9: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 276
        Width = 455
        Height = 22
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 4
        object sgbWpTrans: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 250
          Height = 22
          Margins.Left = 28
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 0
          Prefix = 'Transparency: '
          Suffix = '%'
          Description = 'Change Wallpaper Transparency'
          PopPosition = ppRight
          PercentDisplay = True
          OnChangeValue = WallpaperTransChangeEvent
        end
      end
      object secWpColor: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 20
        Top = 346
        Width = 463
        Height = 32
        Margins.Left = 20
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alTop
        AutoSize = True
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
        ParentColor = False
        TabOrder = 5
        Items = <
          item
            Title = 'Background'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            Visible = True
            ColorEditor = secWpColor.Item0
            Tag = 0
          end>
        SwatchManager = ssmConfig
        OnUiChange = WallpaperColorUiChangeEvent
      end
    end
    object pagColor: TJvStandardPage
      Left = 0
      Top = 0
      Width = 491
      Height = 475
      Caption = 'pagColor'
      object lblApplyColorDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 457
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Apply wallpaper color blending effects'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitLeft = 30
        ExplicitTop = 33
        ExplicitWidth = 411
      end
      object chkApplyColor: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 475
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Apply Color Effects'
        TabOrder = 0
        OnClick = ApplyColorClickEvent
      end
      object imgColor: TImage32
        Left = 290
        Top = 8
        Width = 150
        Height = 150
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baTopLeft
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 1
        Visible = False
      end
      object pnlColor: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 48
        Width = 491
        Height = 427
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 2
        object lblHSLColor: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 475
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'HSL Color Adjust'
          ExplicitLeft = 36
          ExplicitTop = 124
          ExplicitWidth = 429
        end
        object lblHSLColorDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 457
          Height = 15
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'Change the values below to adjust the Hue, Saturation and Lumino' +
            'sity'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          ExplicitTop = 122
          ExplicitWidth = 411
        end
        object Panel10: TPanel
          AlignWithMargins = True
          Left = 26
          Top = 52
          Width = 457
          Height = 22
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 0
          object sgbLum: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 218
            Top = 0
            Width = 105
            Height = 22
            Margins.Left = 4
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            ParentBackground = False
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Lum: '
            Description = 'Change Luminance'
            PopPosition = ppBottom
            PercentDisplay = False
            OnChangeValue = HSLColorChangeEvent
          end
          object sgbSat: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 109
            Top = 0
            Width = 105
            Height = 22
            Margins.Left = 4
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            ParentBackground = False
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Sat: '
            Description = 'Change Saturation'
            PopPosition = ppBottom
            PercentDisplay = False
            OnChangeValue = HSLColorChangeEvent
          end
          object sgbHue: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 105
            Height = 22
            Margins.Left = 0
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alLeft
            ParentBackground = False
            Min = -128
            Max = 128
            Value = 0
            Prefix = 'Hue: '
            Description = 'Change Hue'
            PopPosition = ppBottom
            PercentDisplay = False
            OnChangeValue = HSLColorChangeEvent
          end
        end
      end
    end
    object pagGradient: TJvStandardPage
      Left = 0
      Top = 0
      Width = 491
      Height = 475
      Caption = 'pagGradient'
      object lblApplyGrad: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 457
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Apply wallpaper gradient effects'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        ExplicitLeft = 30
        ExplicitTop = 33
        ExplicitWidth = 411
      end
      object chkApplyGrad: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 475
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Apply Gradient Effects'
        TabOrder = 0
        OnClick = ApplyGradientClickEvent
      end
      object pnlGrad: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 48
        Width = 491
        Height = 427
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object lblGradType: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 475
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Gradient Type'
          ExplicitLeft = 36
          ExplicitTop = 124
          ExplicitWidth = 429
        end
        object lblGradTypeDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 457
          Height = 15
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Please select the gradient effect you wish to apply'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          ExplicitTop = 122
          ExplicitWidth = 411
        end
        object lblGradTrans: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 83
          Width = 475
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Gradient Transparency'
          ExplicitLeft = -6
          ExplicitTop = 176
          ExplicitWidth = 459
        end
        object lblGradTransDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 104
          Width = 457
          Height = 15
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Please define the gradient transparency'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          ExplicitLeft = 12
          ExplicitTop = 172
          ExplicitWidth = 441
        end
        object lblGradColor: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 157
          Width = 475
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Gradient Color'
          ExplicitLeft = 13
          ExplicitTop = 214
          ExplicitWidth = 459
        end
        object lblGradColorDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 178
          Width = 457
          Height = 15
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Please define the gradient colors below'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          ExplicitLeft = 31
          ExplicitTop = 210
          ExplicitWidth = 441
        end
        object Panel5: TPanel
          AlignWithMargins = True
          Left = 26
          Top = 52
          Width = 457
          Height = 23
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 0
          object cboGradType: TComboBox
            Left = 0
            Top = 0
            Width = 250
            Height = 21
            Align = alLeft
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = cb_gtypeChange
            Items.Strings = (
              'Horizontal'
              'Vertical'
              'Left/Right Horizontal'
              'Top/Bottom Vertical')
          end
        end
        object Panel11: TPanel
          AlignWithMargins = True
          Left = 26
          Top = 127
          Width = 457
          Height = 22
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 1
          object sgbGradStartTrans: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 125
            Height = 22
            Align = alLeft
            ParentBackground = False
            Min = 0
            Max = 255
            Value = 255
            Prefix = 'Start: '
            Suffix = '%'
            Description = 'Set the Start Transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = WallpaperTransChangeEvent
          end
          object sgbGradEndTrans: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 129
            Top = 0
            Width = 125
            Height = 22
            Margins.Left = 4
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            ParentBackground = False
            Min = 0
            Max = 255
            Value = 255
            Prefix = 'End : '
            Suffix = '%'
            Description = 'Set the End Transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = WallpaperTransChangeEvent
          end
        end
        object secGradColor: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 20
          Top = 197
          Width = 463
          Height = 230
          Margins.Left = 20
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          AutoSize = True
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clWindow
          ParentColor = False
          TabOrder = 2
          Items = <
            item
              Title = 'Gradient Start'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              Visible = True
              ColorEditor = secGradColor.Item0
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
              ColorEditor = secGradColor.Item1
              Tag = 0
            end>
          SwatchManager = ssmConfig
          OnUiChange = WallpaperColorUiChangeEvent
        end
      end
      object imgGradient: TImage32
        Left = 274
        Top = 8
        Width = 193
        Height = 88
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baCenter
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 2
        Visible = False
      end
    end
  end
  object pnlMonitor: TSharpERoundPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 485
    Height = 85
    Align = alTop
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 1
    DrawMode = srpNormal
    NoTopBorder = False
    RoundValue = 10
    BorderColor = clBtnFace
    Border = False
    BackgroundColor = clWindow
    object lblMonitorDet: TLabel
      AlignWithMargins = True
      Left = 26
      Top = 29
      Width = 451
      Height = 15
      Margins.Left = 26
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'Please select the monitor from the list below'
      EllipsisPosition = epEndEllipsis
      Transparent = False
      ExplicitWidth = 395
    end
    object lblMonitor: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 469
      Height = 17
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'Monitor'
      Transparent = False
      ExplicitWidth = 413
    end
    object Panel3: TSharpERoundPanel
      AlignWithMargins = True
      Left = 28
      Top = 52
      Width = 449
      Height = 23
      Margins.Left = 28
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 0
      DrawMode = srpNormal
      NoTopBorder = False
      RoundValue = 10
      BorderColor = clBtnFace
      Border = False
      BackgroundColor = clBtnFace
      object cboMonitor: TComboBox
        Left = 0
        Top = 0
        Width = 250
        Height = 23
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alLeft
        Style = csDropDownList
        Constraints.MaxWidth = 250
        DropDownCount = 12
        ItemHeight = 0
        TabOrder = 0
        OnChange = MonitorChangeEvent
      end
    end
  end
  object ssmConfig: TSharpESwatchManager
    Swatches = <>
    Width = 431
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
    Left = 16
    Top = 532
  end
  object dlgOpen: TOpenDialog
    Filter = 
      'All Image Files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.' +
      'bmp'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 56
    Top = 528
  end
end
