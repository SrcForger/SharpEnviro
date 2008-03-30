object Form1: TForm1
  Left = 0
  Top = 0
  BorderWidth = 4
  Caption = 'Form1'
  ClientHeight = 557
  ClientWidth = 440
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
  object Shape1: TShape
    Left = 144
    Top = 8
    Width = 41
    Height = 45
  end
  object mmoDebug: TMemo
    Left = 0
    Top = 462
    Width = 440
    Height = 95
    Align = alBottom
    BorderStyle = bsNone
    Lines.Strings = (
      'mmoDebug')
    TabOrder = 0
    ExplicitWidth = 410
  end
  object SharpEColorEditorEx1: TSharpEColorEditorEx
    Left = 0
    Top = 0
    Width = 440
    Height = 462
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    TabOrder = 1
    Items = <
      item
        Title = 'Alpha.'
        ColorCode = 4344
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetBoolean
        Description = 'This is an alpha value:'
        ValueText = 'Alpha'
        Value = 4344
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = SharpEColorEditorEx1.Item0
        Tag = 0
      end
      item
        Title = 'Enable Shadow'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetBoolean
        Description = 'Enable Bar Shadow?'
        Value = 0
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = SharpEColorEditorEx1.Item1
        Tag = 0
      end
      item
        Title = 'Shadow Opacity'
        ColorCode = 100
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetValue
        ValueText = 'Opacity'
        Value = 100
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = SharpEColorEditorEx1.Item2
        Tag = 0
      end
      item
        ColorCode = 8421376
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 8421376
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = SharpEColorEditorEx1.Item3
        Tag = 0
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = SharpEColorEditorEx1.Item4
        Tag = 0
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = SharpEColorEditorEx1.Item5
        Tag = 0
      end>
    SwatchManager = SharpESwatchManager1
    ExplicitWidth = 410
    object Button2: TButton
      Left = 264
      Top = 380
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 183
      Top = 380
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object XPManifest1: TXPManifest
    Left = 136
    Top = 492
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 4
    Top = 516
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <
      item
        Color = clBlack
        ColorCode = 0
      end
      item
        Color = clBlack
        ColorCode = 0
      end
      item
        Color = clBlack
        ColorCode = 0
      end>
    PopulateThemeColors = True
    Width = 408
    ShowCaptions = False
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = clBlack
    SortMode = sortName
    Left = 284
    Top = 280
  end
end
