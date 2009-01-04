object frmVWM: TfrmVWM
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmVWM'
  ClientHeight = 557
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
    Height = 557
    ActivePage = pagVWM
    PropagateEnable = False
    Align = alClient
    ExplicitWidth = 427
    ExplicitHeight = 531
    object pagVWM: TJvStandardPage
      Left = 0
      Top = 0
      Width = 435
      Height = 557
      ExplicitHeight = 551
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 111
        Width = 429
        Height = 31
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitTop = 101
        object sgb_background: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 20
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 20
          Margins.Top = 8
          Margins.Right = 8
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
          ExplicitLeft = 17
        end
      end
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 142
        Width = 429
        Height = 31
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        ExplicitLeft = 0
        ExplicitTop = 150
        ExplicitWidth = 427
        object sgb_border: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 20
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 20
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
        Left = 3
        Top = 173
        Width = 429
        Height = 31
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        ExplicitLeft = 0
        ExplicitTop = 181
        ExplicitWidth = 427
        object sgb_foreground: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 20
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 20
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
          ExplicitLeft = 26
        end
      end
      object Panel4: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 204
        Width = 429
        Height = 31
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        ExplicitLeft = 0
        ExplicitTop = 212
        ExplicitWidth = 427
        object sgb_highlight: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 20
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 20
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
          ExplicitLeft = 26
        end
      end
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 235
        Width = 429
        Height = 31
        Margins.Top = 0
        Margins.Bottom = 8
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        ExplicitLeft = 0
        ExplicitTop = 243
        ExplicitWidth = 427
        object sgb_text: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 20
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 20
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
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
          ExplicitLeft = 26
        end
      end
      object Colors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 20
        Top = 323
        Width = 407
        Height = 128
        Margins.Left = 20
        Margins.Top = 8
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
        ExplicitLeft = 26
        ExplicitTop = 311
        ExplicitWidth = 393
      end
      object schColorVisibility: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 73
        Width = 429
        Height = 35
        Title = 'Color Visibility'
        Description = 
          'Adjust the visibility of all elements shown in the VWM preview w' +
          'indow.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 26
        ExplicitTop = 54
        ExplicitWidth = 185
      end
      object schColorSelection: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 277
        Width = 429
        Height = 35
        Title = 'Color Selections'
        Description = 
          'Select the colors for all elements shown in the VWM preview wind' +
          'ow.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        ExplicitLeft = 144
        ExplicitTop = 272
        ExplicitWidth = 185
      end
      object schNumbers: TSharpECenterHeader
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 429
        Height = 35
        Title = 'VWM Identification'
        Description = 
          'Enable this option to display a number for each VWM in the previ' +
          'ew window.'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
        Color = clWindow
        ExplicitLeft = 112
        ExplicitWidth = 185
      end
      object chkShowNumbers: TJvXPCheckbox
        AlignWithMargins = True
        Left = 20
        Top = 47
        Width = 405
        Height = 17
        Margins.Left = 20
        Margins.Top = 6
        Margins.Right = 10
        Margins.Bottom = 6
        Caption = 'Show VWM Numbers'
        TabOrder = 9
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cb_numbersClick
        ExplicitLeft = 208
        ExplicitTop = 48
        ExplicitWidth = 161
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 374
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
    Left = 264
    Top = 16
  end
end
