object frmVWM: TfrmVWM
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmVWM'
  ClientHeight = 614
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
    Height = 614
    ActivePage = pagVWM
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 637
    object pagVWM: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 614
      ExplicitHeight = 637
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 122
        Width = 423
        Height = 22
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object sgb_background: TSharpeGaugeBox
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
          Min = 0
          Max = 255
          Value = 128
          Prefix = 'Background: '
          Suffix = '%'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgb_backgroundChangeValue
          BackgroundColor = clWindow
        end
      end
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 144
        Width = 423
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
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
          Align = alLeft
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 128
          Prefix = 'Border: '
          Suffix = '%'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgb_backgroundChangeValue
          BackgroundColor = clWindow
        end
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 175
        Width = 423
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
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
          Align = alLeft
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 64
          Prefix = 'Foreground: '
          Suffix = '%'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgb_backgroundChangeValue
          BackgroundColor = clWindow
        end
      end
      object Panel4: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 206
        Width = 423
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
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
          Align = alLeft
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 192
          Prefix = 'Highlight: '
          Suffix = '%'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgb_backgroundChangeValue
          BackgroundColor = clWindow
        end
      end
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 237
        Width = 423
        Height = 31
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 8
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
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
          Min = 0
          Max = 255
          Value = 255
          Prefix = 'Text: '
          Suffix = '%'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgb_backgroundChangeValue
          BackgroundColor = clWindow
        end
      end
      object Colors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 6
        Top = 333
        Width = 423
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
        TabOrder = 5
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
        BorderColor = clBlack
        BackgroundColor = clWindow
        BackgroundTextColor = clBlack
        ContainerColor = clBlack
        ContainerTextColor = clBlack
      end
      object schColorVisibility: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 75
        Width = 423
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
      object schColorSelection: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 286
        Width = 423
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
      end
      object schNumbers: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 1
        Width = 423
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
      object chkShowNumbers: TJvXPCheckbox
        AlignWithMargins = True
        Left = 6
        Top = 48
        Width = 423
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Show VWM Numbers'
        TabOrder = 9
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cb_numbersClick
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
    Left = 372
    Top = 152
  end
end
