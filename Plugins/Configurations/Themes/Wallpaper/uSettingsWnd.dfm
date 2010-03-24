object frmSettingsWnd: TfrmSettingsWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettingsWnd'
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
    Top = 76
    Width = 491
    Height = 490
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
      Height = 490
      Caption = 'pagWallpaper'
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 223
        Width = 481
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 1
        object rdoWpAlignStretch: TJvXPCheckbox
          Left = 138
          Top = 0
          Width = 69
          Height = 23
          Caption = 'Stretch'
          TabOrder = 2
          Align = alLeft
          OnClick = AlignmentChangeEvent
        end
        object rdoWpAlignScale: TJvXPCheckbox
          Left = 69
          Top = 0
          Width = 69
          Height = 23
          Caption = 'Scale'
          TabOrder = 1
          Align = alLeft
          OnClick = AlignmentChangeEvent
        end
        object rdoWpAlignCenter: TJvXPCheckbox
          Left = 0
          Top = 0
          Width = 69
          Height = 23
          Caption = 'Center'
          TabOrder = 0
          Checked = True
          State = cbChecked
          Align = alLeft
          OnClick = AlignmentChangeEvent
        end
        object rdoWpAlignTile: TJvXPCheckbox
          Left = 207
          Top = 0
          Width = 69
          Height = 23
          Caption = 'Tile'
          TabOrder = 3
          Align = alLeft
          OnClick = AlignmentChangeEvent
        end
      end
      object Panel8: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 303
        Width = 481
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 2
        object chkWpMirrorVert: TJvXPCheckbox
          Left = 81
          Top = 0
          Width = 97
          Height = 23
          Caption = 'Vertical'
          TabOrder = 1
          Align = alLeft
          OnClick = MirrorChangeEvent
        end
        object chkWpMirrorHoriz: TJvXPCheckbox
          Left = 0
          Top = 0
          Width = 81
          Height = 23
          Caption = 'Horizontal'
          TabOrder = 0
          Align = alLeft
          OnClick = MirrorChangeEvent
        end
      end
      object imgWallpaper: TImage32
        Left = 260
        Top = 120
        Width = 213
        Height = 133
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baTopLeft
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 5
        Visible = False
      end
      object Panel9: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 383
        Width = 481
        Height = 22
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 3
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
          TabOrder = 0
          Min = 0
          Max = 255
          Value = 0
          Prefix = 'Transparency: '
          Suffix = '%'
          Description = 'Change Wallpaper Transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          Formatting = '%d'
          OnChangeValue = WallpaperTransChangeEvent
          BackgroundColor = clWindow
        end
      end
      object secWpColor: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 1
        Top = 462
        Width = 485
        Height = 32
        Margins.Left = 1
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alTop
        AutoSize = True
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBlack
        ParentColor = False
        TabOrder = 4
        Items = <
          item
            Title = 'Background'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            ValueMin = 0
            ValueMax = 255
            Visible = True
            DisplayPercent = False
            ColorEditor = secWpColor.Item0
            Tag = 0
          end>
        SwatchManager = ssmConfig
        OnUiChange = WallpaperColorUiChangeEvent
        BorderColor = clBlack
        BackgroundColor = clBlack
        BackgroundTextColor = clBlack
        ContainerColor = clBlack
        ContainerTextColor = clBlack
      end
      object SharpECenterHeader6: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 10
        Width = 481
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Wallpaper options'
        Description = 
          'Define the wallpaper filename or directory for the selected moni' +
          'tor'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader7: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 176
        Width = 481
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Wallpaper allignment'
        Description = 'Define the allignment for the wallpaper'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader8: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 256
        Width = 481
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Wallpaper mirroring'
        Description = 'Define the mirroring options for the wallpaper'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader9: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 336
        Width = 481
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Wallpaper visibility'
        Description = 
          'Define how visible the wallpaper is against the background colou' +
          'r'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader10: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 415
        Width = 481
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Background colour'
        Description = 'Define the wallpaper background colour'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object chkAutoWallpaper: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 57
        Width = 481
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Caption = 'Enable automatic wallpaper changing'
        TabOrder = 0
        Align = alTop
        OnClick = chkAutoWallpaperClick
      end
      object pnlWallpaperOptions: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 87
        Width = 481
        Height = 79
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 11
        object pnlWallpaperDirectoryPath: TPanel
          Left = 0
          Top = 0
          Width = 481
          Height = 57
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object edtWpDirectory: TEdit
            Left = 0
            Top = 0
            Width = 403
            Height = 21
            Margins.Left = 28
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            TabOrder = 0
            OnChange = edtWpDirectoryChange
          end
          object btnWpDirectoryBrowse: TButton
            AlignWithMargins = True
            Left = 406
            Top = 0
            Width = 75
            Height = 22
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Caption = 'Browse'
            TabOrder = 1
            OnClick = btnWpDirectoryBrowseClick
          end
          object chkWpRecursive: TJvXPCheckbox
            Left = 3
            Top = 31
            Width = 138
            Height = 17
            Caption = 'Include Subdirectories'
            TabOrder = 2
            OnClick = chkWpRecursiveClick
          end
          object sgbWpChangeInterval: TSharpeGaugeBox
            Left = 258
            Top = 30
            Width = 145
            Height = 21
            ParentBackground = False
            TabOrder = 3
            Min = 1
            Max = 60
            Value = 30
            Prefix = 'Interval: '
            Suffix = ' minutes'
            Description = 'Set how often the wallpaper should change.'
            PopPosition = ppBottom
            PercentDisplay = False
            Formatting = '%d'
            OnChangeValue = sgbWpChangeIntervalChangeValue
            BackgroundColor = clWindow
          end
          object chkWpRandomize: TJvXPCheckbox
            Left = 155
            Top = 31
            Width = 86
            Height = 17
            Caption = 'Randomize'
            TabOrder = 4
            OnClick = chkWpRandomizeClick
          end
        end
        object pnlWallpaperFilePath: TPanel
          Left = 0
          Top = 57
          Width = 481
          Height = 22
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object edtWpFile: TEdit
            Left = 0
            Top = 0
            Width = 403
            Height = 21
            Margins.Left = 28
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            TabOrder = 0
            OnChange = edtWallpaperChange
          end
          object btnWpBrowse: TButton
            AlignWithMargins = True
            Left = 406
            Top = 0
            Width = 75
            Height = 22
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Caption = 'Browse'
            TabOrder = 1
            OnClick = btnWpBrowseClick
          end
        end
      end
    end
    object pagColor: TJvStandardPage
      Left = 0
      Top = 0
      Width = 491
      Height = 490
      Caption = 'pagColor'
      object imgColor: TImage32
        Left = 384
        Top = 113
        Width = 56
        Height = 45
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baTopLeft
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 2
        Visible = False
      end
      object pnlColor: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 31
        Width = 491
        Height = 459
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object Panel10: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 57
          Width = 481
          Height = 22
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
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
            TabOrder = 2
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Lum: '
            Description = 'Change Luminance'
            PopPosition = ppBottom
            PercentDisplay = False
            Formatting = '%d'
            OnChangeValue = HSLColorChangeEvent
            BackgroundColor = clWindow
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
            TabOrder = 1
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Sat: '
            Description = 'Change Saturation'
            PopPosition = ppBottom
            PercentDisplay = False
            Formatting = '%d'
            OnChangeValue = HSLColorChangeEvent
            BackgroundColor = clWindow
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
            TabOrder = 0
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Hue: '
            Description = 'Change Hue'
            PopPosition = ppBottom
            PercentDisplay = False
            Formatting = '%d'
            OnChangeValue = HSLColorChangeEvent
            BackgroundColor = clWindow
          end
        end
        object SharpECenterHeader2: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 10
          Width = 481
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'HSL Colour Adjust'
          Description = 
            'Change the values below to adjust the Hue, Saturation and Lumino' +
            'sity'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
      end
      object chkApplyColor: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 10
        Width = 481
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Apply colour blending effects'
        TabOrder = 0
        Align = alTop
        OnClick = ApplyColorClickEvent
      end
    end
    object pagGradient: TJvStandardPage
      Left = 0
      Top = 0
      Width = 491
      Height = 490
      Caption = 'pagGradient'
      object pnlGrad: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 31
        Width = 491
        Height = 459
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object Panel5: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 57
          Width = 481
          Height = 23
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
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
            OnSelect = cboGradTypeSelect
            Items.Strings = (
              'Horizontal'
              'Vertical'
              'Left/Right Horizontal'
              'Top/Bottom Vertical')
          end
        end
        object Panel11: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 137
          Width = 481
          Height = 22
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
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
            TabOrder = 0
            Min = 0
            Max = 255
            Value = 255
            Prefix = 'Start: '
            Suffix = '%'
            Description = 'Set the Start Transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            Formatting = '%d'
            OnChangeValue = WallpaperTransChangeEvent
            BackgroundColor = clWindow
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
            TabOrder = 1
            Min = 0
            Max = 255
            Value = 255
            Prefix = 'End: '
            Suffix = '%'
            Description = 'Set the End Transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            Formatting = '%d'
            OnChangeValue = WallpaperTransChangeEvent
            BackgroundColor = clWindow
          end
        end
        object secGradColor: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 1
          Top = 216
          Width = 485
          Height = 243
          Margins.Left = 1
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          AutoSize = True
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clBlack
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
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
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
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = secGradColor.Item1
              Tag = 0
            end>
          SwatchManager = ssmConfig
          OnUiChange = WallpaperColorUiChangeEvent
          BorderColor = clBlack
          BackgroundColor = clBlack
          BackgroundTextColor = clBlack
          ContainerColor = clBlack
          ContainerTextColor = clBlack
        end
        object SharpECenterHeader3: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 10
          Width = 481
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Gradient type'
          Description = 'Define the gradient effect you wish to apply to the wallpaper'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader4: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 90
          Width = 481
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Gradient visibility'
          Description = 'Define how visible the gradient is when applied'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader5: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 169
          Width = 481
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Gradient colour'
          Description = 'Define the gradient colours'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
      end
      object imgGradient: TImage32
        Left = 428
        Top = 161
        Width = 39
        Height = 39
        Bitmap.ResamplerClassName = 'TNearestResampler'
        BitmapAlign = baCenter
        Scale = 1.000000000000000000
        ScaleMode = smNormal
        TabOrder = 2
        Visible = False
      end
      object chkApplyGrad: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 10
        Width = 481
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Apply gradient effects'
        TabOrder = 0
        Align = alTop
        OnClick = ApplyGradientClickEvent
      end
    end
  end
  object pnlMonitor: TSharpERoundPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 485
    Height = 70
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    DrawMode = srpNormal
    NoTopBorder = False
    RoundValue = 10
    BorderColor = clBtnFace
    Border = False
    BackgroundColor = clWindow
    object Panel3: TSharpERoundPanel
      AlignWithMargins = True
      Left = 5
      Top = 47
      Width = 475
      Height = 23
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
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
        Height = 21
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alLeft
        Style = csDropDownList
        Constraints.MaxWidth = 250
        DropDownCount = 12
        ItemHeight = 13
        TabOrder = 0
        OnChange = MonitorChangeEvent
      end
    end
    object SharpECenterHeader1: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 475
      Height = 37
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Title = 'Monitor'
      Description = 'Please select the monitor from the list below'
      TitleColor = clWindowText
      DescriptionColor = clRed
      Align = alTop
    end
  end
  object ssmConfig: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 452
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
    BorderColor = clBlack
    BackgroundColor = clBlack
    BackgroundTextColor = clBlack
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
