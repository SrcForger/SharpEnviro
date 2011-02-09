object frmSettingsWnd: TfrmSettingsWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettingsWnd'
  ClientHeight = 740
  ClientWidth = 642
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
    Top = 92
    Width = 642
    Height = 648
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ActivePage = pagWallpaper
    PropagateEnable = False
    Align = alClient
    ExplicitTop = 105
    ExplicitHeight = 635
    object pagWallpaper: TJvStandardPage
      Left = 0
      Top = 0
      Width = 642
      Height = 648
      Caption = 'pagWallpaper'
      ExplicitHeight = 635
      object pnlWallpaper: TPanel
        Left = 1
        Top = 1
        Width = 640
        Height = 559
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object imgWallpaper: TImage32
          Left = 340
          Top = 157
          Width = 279
          Height = 174
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baTopLeft
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 10
          Visible = False
        end
        object SharpECenterHeader6: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 630
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
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
        object chkAutoWallpaper: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 52
          Width = 630
          Height = 23
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
          Top = 88
          Width = 630
          Height = 109
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 1
          object pnlWallpaperDirectoryPath: TPanel
            Left = 0
            Top = 0
            Width = 630
            Height = 87
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            object chkWpRecursive: TJvXPCheckbox
              Left = 0
              Top = 36
              Width = 180
              Height = 22
              Caption = 'Include Subdirectories'
              TabOrder = 1
              OnClick = chkWpRecursiveClick
            end
            object sgbWpChangeInterval: TSharpeGaugeBox
              Left = 186
              Top = 64
              Width = 137
              Height = 22
              ParentBackground = False
              TabOrder = 3
              Min = 1
              Max = 720
              Value = 30
              Prefix = 'Interval: '
              Suffix = ' minutes'
              Description = 'Set how often the wallpaper should change.'
              PopPosition = ppBottom
              PercentDisplay = False
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = sgbWpChangeIntervalChangeValue
              BackgroundColor = clWindow
            end
            object chkWpRandomize: TJvXPCheckbox
              Left = 0
              Top = 64
              Width = 112
              Height = 22
              Caption = 'Randomize'
              TabOrder = 2
              OnClick = chkWpRandomizeClick
            end
            object Panel1: TPanel
              Left = 0
              Top = 0
              Width = 630
              Height = 22
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              object edtWpDirectory: TEdit
                AlignWithMargins = True
                Left = 0
                Top = 0
                Width = 326
                Height = 22
                Margins.Left = 0
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                Align = alLeft
                AutoSize = False
                TabOrder = 0
                OnChange = edtWpDirectoryChange
              end
              object btnWpDirectoryBrowse: TButton
                AlignWithMargins = True
                Left = 329
                Top = 0
                Width = 66
                Height = 22
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                Align = alLeft
                Caption = 'Browse'
                TabOrder = 1
                OnClick = btnWpDirectoryBrowseClick
              end
            end
          end
          object pnlWallpaperFilePath: TPanel
            Left = 0
            Top = 87
            Width = 630
            Height = 22
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            ExplicitTop = 97
            object edtWpFile: TEdit
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 326
              Height = 22
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              AutoSize = False
              TabOrder = 0
              OnChange = edtWallpaperChange
            end
            object btnWpBrowse: TButton
              AlignWithMargins = True
              Left = 329
              Top = 0
              Width = 67
              Height = 22
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Browse'
              TabOrder = 1
              OnClick = btnWpBrowseClick
            end
          end
        end
        object SharpECenterHeader7: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 207
          Width = 630
          Height = 42
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Wallpaper allignment'
          Description = 'Define the alignment for the wallpaper'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          ExplicitTop = 217
        end
        object Panel7: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 259
          Width = 630
          Height = 30
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 2
          ExplicitTop = 269
          object rdoWpAlignStretch: TJvXPCheckbox
            Left = 180
            Top = 0
            Width = 91
            Height = 30
            Caption = 'Stretch'
            TabOrder = 2
            Align = alLeft
            OnClick = AlignmentChangeEvent
          end
          object rdoWpAlignScale: TJvXPCheckbox
            Left = 90
            Top = 0
            Width = 90
            Height = 30
            Caption = 'Scale'
            TabOrder = 1
            Align = alLeft
            OnClick = AlignmentChangeEvent
          end
          object rdoWpAlignCenter: TJvXPCheckbox
            Left = 0
            Top = 0
            Width = 90
            Height = 30
            Caption = 'Center'
            TabOrder = 0
            Checked = True
            State = cbChecked
            Align = alLeft
            OnClick = AlignmentChangeEvent
          end
          object rdoWpAlignTile: TJvXPCheckbox
            Left = 271
            Top = 0
            Width = 90
            Height = 30
            Caption = 'Tile'
            TabOrder = 3
            Align = alLeft
            OnClick = AlignmentChangeEvent
          end
        end
        object SharpECenterHeader8: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 299
          Width = 630
          Height = 42
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Wallpaper mirroring'
          Description = 'Define the mirroring options for the wallpaper'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          ExplicitTop = 309
        end
        object Panel8: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 351
          Width = 630
          Height = 30
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 3
          ExplicitTop = 361
          object chkWpMirrorVert: TJvXPCheckbox
            Left = 106
            Top = 0
            Width = 127
            Height = 30
            Caption = 'Vertical'
            TabOrder = 1
            Align = alLeft
            OnClick = MirrorChangeEvent
          end
          object chkWpMirrorHoriz: TJvXPCheckbox
            Left = 0
            Top = 0
            Width = 106
            Height = 30
            Caption = 'Horizontal'
            TabOrder = 0
            Align = alLeft
            OnClick = MirrorChangeEvent
          end
        end
        object SharpECenterHeader9: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 391
          Width = 630
          Height = 42
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
          ExplicitTop = 401
        end
        object Panel9: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 443
          Width = 630
          Height = 22
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 4
          ExplicitTop = 453
          object sgbWpTrans: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 327
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
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = WallpaperTransChangeEvent
            BackgroundColor = clWindow
          end
        end
        object SharpECenterHeader10: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 475
          Width = 630
          Height = 42
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Background colour'
          Description = 'Define the wallpaper background colour'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          ExplicitTop = 485
        end
        object secWpColor: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 1
          Top = 527
          Width = 634
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
          TabOrder = 11
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
          OnExpandCollapse = secColorExpandCollapse
          BorderColor = clBlack
          BackgroundColor = clBlack
          BackgroundTextColor = clBlack
          ContainerColor = clBlack
          ContainerTextColor = clBlack
          ExplicitTop = 537
        end
      end
    end
    object pagColor: TJvStandardPage
      Left = 0
      Top = 0
      Width = 642
      Height = 648
      Caption = 'pagColor'
      object pnlColor: TPanel
        Left = 1
        Top = 1
        Width = 640
        Height = 163
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object chkApplyColor: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 52
          Width = 630
          Height = 23
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Apply colour blending effects'
          TabOrder = 0
          Align = alTop
          OnClick = ApplyColorClickEvent
        end
        object pnlColorHSL: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 79
          Width = 640
          Height = 84
          Margins.Left = 0
          Margins.Top = 4
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 1
          object Panel10: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 62
            Width = 630
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
              Left = 282
              Top = 0
              Width = 137
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
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = HSLColorChangeEvent
              BackgroundColor = clWindow
            end
            object sgbSat: TSharpeGaugeBox
              AlignWithMargins = True
              Left = 141
              Top = 0
              Width = 137
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
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = HSLColorChangeEvent
              BackgroundColor = clWindow
            end
            object sgbHue: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 137
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
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = HSLColorChangeEvent
              BackgroundColor = clWindow
            end
          end
          object SharpECenterHeader2: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 10
            Width = 630
            Height = 42
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
        object imgColor: TImage32
          Left = 558
          Top = 93
          Width = 74
          Height = 59
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baTopLeft
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 2
          Visible = False
        end
        object SharpECenterHeader12: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 630
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Colour blend'
          Description = 'Define whether to apply a colour blending effect'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
      end
    end
    object pagGradient: TJvStandardPage
      Left = 0
      Top = 0
      Width = 642
      Height = 648
      Caption = 'pagGradient'
      object pnlGradient: TPanel
        Left = 1
        Top = 1
        Width = 640
        Height = 365
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object chkApplyGrad: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 52
          Width = 630
          Height = 23
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Apply gradient effects'
          TabOrder = 0
          Align = alTop
          OnClick = ApplyGradientClickEvent
        end
        object pnlGrad: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 79
          Width = 640
          Height = 286
          Margins.Left = 0
          Margins.Top = 4
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 1
          object Panel5: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 62
            Width = 630
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
            object cboGradType: TComboBox
              Left = 0
              Top = 0
              Width = 327
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
            Top = 146
            Width = 630
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
              Width = 163
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
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = WallpaperTransChangeEvent
              BackgroundColor = clWindow
            end
            object sgbGradEndTrans: TSharpeGaugeBox
              AlignWithMargins = True
              Left = 167
              Top = 0
              Width = 163
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
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = WallpaperTransChangeEvent
              BackgroundColor = clWindow
            end
          end
          object secGradColor: TSharpEColorEditorEx
            AlignWithMargins = True
            Left = 1
            Top = 230
            Width = 634
            Height = 56
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
            OnExpandCollapse = secColorExpandCollapse
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
            Width = 630
            Height = 42
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
          object SharpECenterHeader5: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 178
            Width = 630
            Height = 42
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
          object SharpECenterHeader4: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 94
            Width = 630
            Height = 42
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
        end
        object imgGradient: TImage32
          Left = 560
          Top = 211
          Width = 51
          Height = 51
          Bitmap.ResamplerClassName = 'TNearestResampler'
          BitmapAlign = baCenter
          Scale = 1.000000000000000000
          ScaleMode = smNormal
          TabOrder = 2
          Visible = False
        end
        object SharpECenterHeader11: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 630
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Gradient effect'
          Description = 'Define whether to apply a gradient effect'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
      end
    end
  end
  object pnlMonitor: TSharpERoundPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 642
    Height = 82
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    DrawMode = srpNormal
    NoTopBorder = False
    NoBottomBorder = False
    RoundValue = 10
    BorderColor = clBtnFace
    Border = False
    BackgroundColor = clWindow
    BottomSideBorder = False
    object pnlMonitorList: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 47
      Width = 632
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 10
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 0
      object cboMonitor: TComboBox
        Left = 0
        Top = 0
        Width = 327
        Height = 21
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alLeft
        Style = csDropDownList
        Constraints.MaxWidth = 327
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
      Width = 632
      Height = 42
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
    Width = 601
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
