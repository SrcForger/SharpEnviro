object frmVWM: TfrmVWM
  Left = 0
  Top = 0
  Caption = 'frmVWM'
  ClientHeight = 531
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
    Height = 531
    ActivePage = pagVWM
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 587
    object pagVWM: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 531
      ExplicitHeight = 587
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 32
        Width = 393
        Height = 25
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enable this option to display the number of each VWM in the prev' +
          'iew'
        Transparent = False
        WordWrap = True
      end
      object Label1: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 86
        Width = 393
        Height = 33
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Changing the values below will adjust the visibility of all elem' +
          'ents which are shown in the VWM preview windows.'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 34
        ExplicitTop = 143
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 65
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'Color Visibility'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 73
        ExplicitWidth = 65
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 290
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'Colors'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitLeft = 16
        ExplicitTop = 329
      end
      object cb_numbers: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 411
        Height = 16
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Show VWM Numbers'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cb_numbersClick
      end
      object Panel1: TPanel
        Left = 0
        Top = 119
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object sgb_background: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
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
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 150
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object sgb_border: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
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
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 181
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        object sgb_foreground: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
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
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 212
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        object sgb_highlight: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
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
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 243
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 5
        object sgb_text: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
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
        end
      end
      object Colors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 26
        Top = 311
        Width = 393
        Height = 128
        Margins.Left = 26
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
        TabOrder = 6
        Items = <
          item
            Title = 'Background'
            ColorCode = 16777215
            ColorAsTColor = clWhite
            Expanded = False
            ValueEditorType = vetColor
            Value = 16777215
            Visible = True
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
            Visible = True
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
            Visible = True
            ColorEditor = Colors.Item2
            Tag = 0
          end
          item
            Title = 'Highlight'
            ColorCode = 16777215
            ColorAsTColor = clWhite
            Expanded = False
            ValueEditorType = vetColor
            Value = 16777215
            Visible = True
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
            Visible = True
            ColorEditor = Colors.Item4
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
        OnChangeColor = ColorsChangeColor
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 361
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
    Left = 264
    Top = 16
  end
end
