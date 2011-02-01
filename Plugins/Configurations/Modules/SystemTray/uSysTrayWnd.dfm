object frmSysTray: TfrmSysTray
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSysTray'
  ClientHeight = 576
  ClientWidth = 435
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
    Width = 435
    Height = 576
    ActivePage = pagSysTray
    PropagateEnable = False
    Align = alClient
    object pagSysTray: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 576
      object pnlSysTray: TPanel
        Left = 1
        Top = 1
        Width = 433
        Height = 719
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object SharpECenterHeader1: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 10
          Width = 423
          Height = 42
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 5
          Title = 'Icon Hiding'
          Description = 
            'Select if you want to enable the possibility to hide selected tr' +
            'ay icons.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 18
        end
        object schIconVisibility: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 93
          Width = 423
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Icon Visibility'
          Description = 'Adjust the visibility of the system tray icons.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 101
        end
        object chkIconHiding: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 62
          Width = 423
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 10
          Caption = 'Enable Icon Hiding'
          TabOrder = 2
          Align = alTop
          OnClick = cbBackgroundClick
          ExplicitTop = 70
        end
        object schBackgroundVisibility: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 328
          Width = 423
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Background Visibility'
          Description = 
            'Adjust the visibility of the background behind the system tray i' +
            'cons.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 320
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 140
          Width = 433
          Height = 23
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 4
          ExplicitTop = 148
          object sgbIconAlpha: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 159
            Height = 23
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alLeft
            ParentBackground = False
            TabOrder = 0
            Min = 32
            Max = 255
            Value = 255
            Prefix = 'Visibility: '
            Suffix = '%'
            Description = 'Adjust transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgbIconAlphaChangeValue
            BackgroundColor = clWindow
          end
        end
        object pnlBackground: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 375
          Width = 423
          Height = 31
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 10
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 5
          ExplicitTop = 367
          object sgbBackground: TSharpeGaugeBox
            Left = 146
            Top = 5
            Width = 159
            Height = 23
            Color = clWindow
            ParentBackground = False
            TabOrder = 1
            Min = 0
            Max = 255
            Value = 128
            Prefix = 'Visibility: '
            Suffix = '%'
            Description = 'Adjust transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgbIconAlphaChangeValue
            BackgroundColor = clWindow
          end
          object chkBackground: TJvXPCheckbox
            Left = 0
            Top = 7
            Width = 135
            Height = 17
            Caption = 'Display Background'
            TabOrder = 0
            OnClick = cbBackgroundClick
          end
        end
        object schBorderVisibility: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 416
          Width = 423
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Border Visibility'
          Description = 'Adjust the visibilty of the border around the system tray.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 408
        end
        object pnlBorder: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 463
          Width = 423
          Height = 31
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 10
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 7
          ExplicitTop = 455
          object sgbBorder: TSharpeGaugeBox
            Left = 146
            Top = 5
            Width = 159
            Height = 23
            Color = clWindow
            ParentBackground = False
            TabOrder = 1
            Min = 0
            Max = 255
            Value = 128
            Prefix = 'Visibility: '
            Suffix = '%'
            Description = 'Adjust transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgbIconAlphaChangeValue
            BackgroundColor = clWindow
          end
          object chkBorder: TJvXPCheckbox
            Left = 0
            Top = 7
            Width = 135
            Height = 17
            Caption = 'Display Border'
            TabOrder = 0
            OnClick = cbBorderClick
          end
        end
        object schColorBlendOptions: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 504
          Width = 423
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Color Blend Icon Options'
          Description = 'Adjust the color blending options for the system tray icons.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 496
        end
        object pnlBlend: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 551
          Width = 423
          Height = 31
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 10
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 9
          ExplicitTop = 543
          object sgbBlend: TSharpeGaugeBox
            Left = 146
            Top = 5
            Width = 159
            Height = 23
            ParentBackground = False
            TabOrder = 1
            Min = 0
            Max = 255
            Value = 255
            Prefix = 'Strength: '
            Suffix = '%'
            Description = 'Adjust Blend Strength'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgbIconAlphaChangeValue
            BackgroundColor = clWindow
          end
          object chkBlend: TJvXPCheckbox
            Left = 0
            Top = 7
            Width = 135
            Height = 17
            Caption = 'Color Blend Icon'
            TabOrder = 0
            OnClick = cbBlendClick
          end
        end
        object schColor: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 592
          Width = 423
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Color Options'
          Description = 'Select the color for the Background, Border and Blending.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 584
        end
        object Colors: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 5
          Top = 639
          Width = 423
          Height = 80
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
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
          TabOrder = 11
          Items = <
            item
              Title = 'Background'
              ColorCode = 16777215
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 16777215
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = Colors.Item0
              Tag = 0
            end
            item
              Title = 'Border'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = Colors.Item1
              Tag = 0
            end
            item
              Title = 'Blend Color'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = Colors.Item2
              Tag = 0
            end>
          SwatchManager = SharpESwatchManager1
          OnChangeColor = ColorsChangeColor
          OnExpandCollapse = ColorsExpandCollapse
          BorderColor = clBlack
          BackgroundColor = clWindow
          BackgroundTextColor = clBlack
          ContainerColor = clBlack
          ContainerTextColor = clBlack
          ExplicitTop = 631
        end
        object schIconSizing: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 173
          Width = 423
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Icon Sizing'
          Description = 'Automatically size the tray icons to the current theme.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 181
        end
        object chkIconSizing: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 220
          Width = 423
          Height = 17
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 10
          Caption = 'Enable Auto Sizing'
          TabOrder = 13
          Align = alTop
          OnClick = chkIconSizingClick
          ExplicitTop = 228
        end
        object SharpECenterHeader2: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 247
          Width = 423
          Height = 42
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Icon Spacing'
          Description = 'Allows you to specify the space between each tray icon'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 255
        end
        object Panel2: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 294
          Width = 433
          Height = 24
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 15
          object sgbIconSpacing: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 159
            Height = 24
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alLeft
            Color = clWindow
            ParentBackground = False
            TabOrder = 0
            Min = 0
            Max = 25
            Value = 1
            Prefix = 'Spacing: '
            Suffix = 'px'
            Description = 'Adjust transparency'
            PopPosition = ppBottom
            PercentDisplay = False
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgbIconAlphaChangeValue
            BackgroundColor = clWindow
          end
        end
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 390
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
    Left = 384
    Top = 328
  end
end
