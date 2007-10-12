object frmSysTray: TfrmSysTray
  Left = 0
  Top = 0
  Caption = 'frmSysTray'
  ClientHeight = 587
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
    Height = 587
    ActivePage = pagSysTray
    PropagateEnable = False
    Align = alClient
    object pagSysTray: TJvStandardPage
      Left = 0
      Top = 0
      Width = 427
      Height = 587
      object lbBackground: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 121
        Width = 393
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enabled this option to display a simple background behind the ic' +
          'ons'
        Transparent = False
        WordWrap = True
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 372
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
        ExplicitTop = 401
      end
      object Label4: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 411
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'Icon Visibility'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 73
        ExplicitWidth = 65
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 393
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Changing this value will adjust the visibility of all tray icons' +
          '.'
        Transparent = False
        WordWrap = True
      end
      object lbBorder: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 213
        Width = 393
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Enabled this option to display a simple a border around the whol' +
          'e tray'
        Transparent = False
        WordWrap = True
        ExplicitTop = 330
      end
      object lbBlend: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 305
        Width = 393
        Height = 20
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Enable this option to blend all icons to a custom color.'
        Transparent = False
        WordWrap = True
        ExplicitLeft = 18
        ExplicitTop = 367
      end
      object Panel1: TPanel
        Left = 0
        Top = 49
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object sgbIconAlpha: TSharpeGaugeBox
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
          Min = 32
          Max = 255
          Value = 255
          Prefix = 'Visibility: '
          Suffix = '%'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbIconAlphaChangeValue
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 141
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object sgbBackground: TSharpeGaugeBox
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
          Prefix = 'Visibility: '
          Suffix = '%'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbIconAlphaChangeValue
        end
      end
      object Colors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 26
        Top = 393
        Width = 393
        Height = 80
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
        TabOrder = 2
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
            Title = 'Blend Color'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            Visible = True
            ColorEditor = Colors.Item2
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
        OnChangeColor = ColorsChangeColor
      end
      object cbBackground: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 96
        Width = 411
        Height = 17
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Display Background'
        TabOrder = 3
        OnClick = cbBackgroundClick
      end
      object Panel3: TPanel
        Left = 0
        Top = 233
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        object sgbBorder: TSharpeGaugeBox
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
          Prefix = 'Visibility: '
          Suffix = '%'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbIconAlphaChangeValue
        end
      end
      object cbBorder: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 188
        Width = 411
        Height = 17
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Display Border'
        TabOrder = 5
        OnClick = cbBorderClick
      end
      object cbBlend: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 280
        Width = 411
        Height = 17
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Color Blend Icon'
        TabOrder = 6
        OnClick = cbBlendClick
      end
      object Panel4: TPanel
        Left = 0
        Top = 325
        Width = 427
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 7
        object sgbBlend: TSharpeGaugeBox
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
          Prefix = 'Strength: '
          Suffix = '%'
          Description = 'Adjust Blend Strength'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbIconAlphaChangeValue
        end
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
    Left = 288
    Top = 64
  end
end
