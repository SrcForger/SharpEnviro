object frmVWM: TfrmVWM
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmVWM'
  ClientHeight = 465
  ClientWidth = 435
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 435
    Height = 465
    ActivePage = pagVWM
    PropagateEnable = False
    Align = alClient
    ParentBackground = True
    object pagVWM: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 465
      object pnlVWM: TPanel
        Left = 0
        Top = 0
        Width = 435
        Height = 461
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object chkShowNumbers: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 47
          Width = 425
          Height = 17
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Show VWM Numbers'
          TabOrder = 0
          Checked = True
          State = cbChecked
          Align = alTop
          OnClick = cb_numbersClick
        end
        object Colors: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 5
          Top = 333
          Width = 425
          Height = 128
          Margins.Left = 5
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
          Color = clWindow
          ParentColor = False
          TabOrder = 1
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
              Title = 'Foreground'
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
            end
            item
              Title = 'Highlight'
              ColorCode = 16777215
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 16777215
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = Colors.Item3
              Tag = 0
            end
            item
              Title = 'Text'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = Colors.Item4
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
          ExplicitTop = 332
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 245
          Width = 425
          Height = 31
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          object sgb_background: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 0
            Top = 8
            Width = 159
            Height = 23
            Margins.Left = 0
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            ParentBackground = False
            TabOrder = 0
            Min = 0
            Max = 255
            Value = 128
            Prefix = 'Background: '
            Suffix = '%'
            Description = 'Adjust to set the transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgb_backgroundChangeValue
            BackgroundColor = clWindow
          end
        end
        object Panel2: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 214
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
          ExplicitTop = 222
          object sgb_border: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 0
            Top = 8
            Width = 159
            Height = 23
            Margins.Left = 0
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            ParentBackground = False
            TabOrder = 0
            Min = 0
            Max = 255
            Value = 128
            Prefix = 'Border: '
            Suffix = '%'
            Description = 'Adjust to set the transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgb_backgroundChangeValue
            BackgroundColor = clWindow
          end
        end
        object Panel3: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 183
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
          ExplicitTop = 191
          object sgb_foreground: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 0
            Top = 8
            Width = 159
            Height = 23
            Margins.Left = 0
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            ParentBackground = False
            TabOrder = 0
            Min = 0
            Max = 255
            Value = 64
            Prefix = 'Foreground: '
            Suffix = '%'
            Description = 'Adjust to set the transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgb_backgroundChangeValue
            BackgroundColor = clWindow
          end
        end
        object Panel4: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 152
          Width = 425
          Height = 31
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 5
          ExplicitTop = 160
          object sgb_highlight: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 0
            Top = 8
            Width = 159
            Height = 23
            Margins.Left = 0
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            ParentBackground = False
            TabOrder = 0
            Min = 0
            Max = 255
            Value = 192
            Prefix = 'Highlight: '
            Suffix = '%'
            Description = 'Adjust to set the transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgb_backgroundChangeValue
            BackgroundColor = clWindow
          end
        end
        object Panel5: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 121
          Width = 425
          Height = 31
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 6
          object sgb_text: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 0
            Top = 8
            Width = 159
            Height = 23
            Margins.Left = 0
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            ParentBackground = False
            TabOrder = 0
            Min = 0
            Max = 255
            Value = 255
            Prefix = 'Text: '
            Suffix = '%'
            Description = 'Adjust to set the transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgb_backgroundChangeValue
            BackgroundColor = clWindow
          end
        end
        object schColorSelection: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 286
          Width = 425
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Color Selections'
          Description = 
            'Select the colors for all elements shown in the VWM preview wind' +
            'ow.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          ExplicitTop = 285
        end
        object schColorVisibility: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 74
          Width = 425
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Color Visibility'
          Description = 
            'Adjust the visibility of all elements shown in the VWM preview w' +
            'indow.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
        end
        object schNumbers: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 425
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'VWM Identification'
          Description = 
            'Enable this option to display a number for each VWM in the previ' +
            'ew window.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
        end
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
    Left = 372
    Top = 152
  end
end
