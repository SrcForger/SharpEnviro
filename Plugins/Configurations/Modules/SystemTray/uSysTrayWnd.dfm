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
      object pnlIcon: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 130
        Width = 425
        Height = 22
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitTop = 47
        object sgbIconAlpha: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 159
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 32
          Max = 255
          Value = 255
          Prefix = 'Visibility: '
          Suffix = '%'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbIconAlphaChangeValue
          BackgroundColor = clWindow
        end
      end
      object pnlBackground: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 204
        Width = 425
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        ExplicitTop = 121
        object sgbBackground: TSharpeGaugeBox
          Left = 146
          Top = 5
          Width = 159
          Height = 23
          Color = clWindow
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 128
          Prefix = 'Visibility: '
          Suffix = '%'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbIconAlphaChangeValue
          BackgroundColor = clWindow
        end
        object chkBackground: TJvXPCheckbox
          Left = 0
          Top = 7
          Width = 135
          Height = 17
          Caption = 'Display Background'
          TabOrder = 1
          OnClick = cbBackgroundClick
        end
      end
      object Colors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 5
        Top = 448
        Width = 425
        Height = 80
        Margins.Left = 5
        Margins.Top = 0
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
        TabOrder = 2
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
        BorderColor = clBlack
        BackgroundColor = clWindow
        BackgroundTextColor = clBlack
        ContainerColor = clBlack
        ContainerTextColor = clBlack
        ExplicitTop = 365
      end
      object pnlBorder: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 277
        Width = 425
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        ExplicitTop = 194
        object sgbBorder: TSharpeGaugeBox
          Left = 146
          Top = 5
          Width = 159
          Height = 23
          Color = clWindow
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 128
          Prefix = 'Visibility: '
          Suffix = '%'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbIconAlphaChangeValue
          BackgroundColor = clWindow
        end
        object chkBorder: TJvXPCheckbox
          Left = 0
          Top = 7
          Width = 135
          Height = 17
          Caption = 'Display Border'
          TabOrder = 1
          OnClick = cbBorderClick
        end
      end
      object pnlBlend: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 360
        Width = 425
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        ExplicitTop = 277
        object sgbBlend: TSharpeGaugeBox
          Left = 146
          Top = 5
          Width = 159
          Height = 23
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 255
          Prefix = 'Strength: '
          Suffix = '%'
          Description = 'Adjust Blend Strength'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbIconAlphaChangeValue
          BackgroundColor = clWindow
        end
        object chkBlend: TJvXPCheckbox
          Left = 0
          Top = 7
          Width = 135
          Height = 17
          Caption = 'Color Blend Icon'
          TabOrder = 1
          OnClick = cbBlendClick
        end
      end
      object schIconVisibility: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 83
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Icon Visibility'
        Description = 'Adjust the visibility of the system tray icons.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 0
      end
      object schBackgroundVisibility: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 162
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 5
        Title = 'Background Visibility'
        Description = 
          'Adjust the visibility of the background behind the system tray i' +
          'cons.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 79
      end
      object schBorderVisibility: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 235
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 5
        Title = 'Border Visibility'
        Description = 'Adjust the visibilty of the border around the system tray.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 152
      end
      object schColorBlendOptions: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 318
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 5
        Title = 'Color Blend Icon Options'
        Description = 'Adjust the color blending options for the system tray icons.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 235
      end
      object schColor: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 401
        Width = 425
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Color Options'
        Description = 'Select the color for the Background, Border and Blending.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitTop = 318
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 52
        Width = 425
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 10
        object chkIconHiding: TJvXPCheckbox
          Left = 0
          Top = 3
          Width = 135
          Height = 17
          Caption = 'Enable Icon Hiding'
          TabOrder = 0
          OnClick = cbBackgroundClick
        end
      end
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 10
        Width = 425
        Height = 37
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
        ExplicitWidth = 415
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 392
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
