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
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 17
  object plConfig: TJvPageList
    AlignWithMargins = True
    Left = 0
    Top = 94
    Width = 642
    Height = 646
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ActivePage = pagWallpaper
    PropagateEnable = False
    Align = alClient
    ExplicitTop = 96
    ExplicitHeight = 644
    object pagWallpaper: TJvStandardPage
      Left = 0
      Top = 0
      Width = 642
      Height = 646
      Caption = 'pagWallpaper'
      ExplicitHeight = 644
      object pnlWallpaper: TPanel
        Left = 1
        Top = 1
        Width = 640
        Height = 598
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object SharpECenterHeader6: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 630
          Height = 55
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
          Top = 65
          Width = 630
          Height = 23
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Caption = 'Enable automatic wallpaper changing'
          TabOrder = 1
          Align = alTop
          OnClick = chkAutoWallpaperClick
        end
        object pnlWallpaperOptions: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 101
          Width = 630
          Height = 103
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 2
          object pnlWallpaperDirectoryPath: TPanel
            Left = 0
            Top = 0
            Width = 630
            Height = 75
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
              Width = 527
              Height = 25
              Margins.Left = 28
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              TabOrder = 0
              OnChange = edtWpDirectoryChange
            end
            object btnWpDirectoryBrowse: TButton
              AlignWithMargins = True
              Left = 531
              Top = 0
              Width = 98
              Height = 29
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Caption = 'Browse'
              TabOrder = 1
              OnClick = btnWpDirectoryBrowseClick
            end
            object chkWpRecursive: TJvXPCheckbox
              Left = 4
              Top = 41
              Width = 180
              Height = 22
              Caption = 'Include Subdirectories'
              TabOrder = 2
              OnClick = chkWpRecursiveClick
            end
            object sgbWpChangeInterval: TSharpeGaugeBox
              Left = 337
              Top = 39
              Width = 190
              Height = 28
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
              Left = 203
              Top = 41
              Width = 112
              Height = 22
              Caption = 'Randomize'
              TabOrder = 4
              OnClick = chkWpRandomizeClick
            end
          end
          object pnlWallpaperFilePath: TPanel
            Left = 0
            Top = 75
            Width = 630
            Height = 28
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
              Width = 527
              Height = 25
              Margins.Left = 28
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              TabOrder = 0
              OnChange = edtWallpaperChange
            end
            object btnWpBrowse: TButton
              AlignWithMargins = True
              Left = 531
              Top = 0
              Width = 98
              Height = 29
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Caption = 'Browse'
              TabOrder = 1
              OnClick = btnWpBrowseClick
            end
          end
        end
        object SharpECenterHeader7: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 214
          Width = 630
          Height = 55
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
        object Panel7: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 279
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
          TabOrder = 4
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
          Top = 319
          Width = 630
          Height = 55
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
        object Panel8: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 384
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
          TabOrder = 6
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
          Top = 424
          Width = 630
          Height = 55
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
        object Panel9: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 489
          Width = 630
          Height = 29
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 8
          object sgbWpTrans: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 327
            Height = 29
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
          Top = 528
          Width = 630
          Height = 55
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
        object secWpColor: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 1
          Top = 593
          Width = 634
          Height = 39
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
        end
      end
    end
    object pagColor: TJvStandardPage
      Left = 0
      Top = 0
      Width = 642
      Height = 646
      Caption = 'pagColor'
      object pnlColor: TPanel
        Left = 1
        Top = 1
        Width = 640
        Height = 188
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object chkApplyColor: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 65
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
          ExplicitTop = 58
        end
        object pnlColorHSL: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 92
          Width = 640
          Height = 103
          Margins.Left = 0
          Margins.Top = 4
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 1
          ExplicitTop = 85
          ExplicitHeight = 96
          object Panel10: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 75
            Width = 630
            Height = 28
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 0
            ExplicitTop = 68
            object sgbLum: TSharpeGaugeBox
              AlignWithMargins = True
              Left = 282
              Top = 0
              Width = 137
              Height = 28
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
              Height = 28
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
              Height = 28
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
            Height = 55
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
          Height = 55
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
      Height = 646
      Caption = 'pagGradient'
      object pnlGradient: TPanel
        Left = 1
        Top = 1
        Width = 640
        Height = 419
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object chkApplyGrad: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 65
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
          ExplicitTop = 58
        end
        object pnlGrad: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 92
          Width = 640
          Height = 355
          Margins.Left = 0
          Margins.Top = 4
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 1
          ExplicitTop = 85
          ExplicitHeight = 334
          object Panel5: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 75
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
            TabOrder = 0
            ExplicitTop = 68
            object cboGradType: TComboBox
              Left = 0
              Top = 0
              Width = 327
              Height = 25
              Align = alLeft
              Style = csDropDownList
              ItemHeight = 17
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
            Top = 180
            Width = 630
            Height = 29
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 1
            ExplicitTop = 166
            object sgbGradStartTrans: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 163
              Height = 29
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
              Height = 29
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
            Top = 284
            Width = 634
            Height = 71
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
            ExplicitTop = 263
          end
          object SharpECenterHeader3: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 10
            Width = 630
            Height = 55
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
            Top = 219
            Width = 630
            Height = 55
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 0
            Title = 'Gradient colour'
            Description = 'Define the gradient colours'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
            ExplicitTop = 212
          end
          object SharpECenterHeader4: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 115
            Width = 630
            Height = 55
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
          Height = 55
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
    Height = 84
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
    object pnlMonitorList: TSharpERoundPanel
      AlignWithMargins = True
      Left = 5
      Top = 60
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
      DrawMode = srpNormal
      NoTopBorder = False
      NoBottomBorder = False
      RoundValue = 10
      BorderColor = clBtnFace
      Border = False
      BackgroundColor = clBtnFace
      BottomSideBorder = False
      ExplicitTop = 53
      ExplicitHeight = 21
      object cboMonitor: TComboBox
        Left = 0
        Top = 0
        Width = 327
        Height = 25
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alLeft
        Style = csDropDownList
        Constraints.MaxWidth = 327
        DropDownCount = 12
        ItemHeight = 17
        TabOrder = 0
        OnChange = MonitorChangeEvent
      end
    end
    object SharpECenterHeader1: TSharpECenterHeader
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 632
      Height = 55
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
