object Form1: TForm1
  Left = 0
  Top = 0
  Width = 434
  Height = 601
  BorderWidth = 4
  Caption = 'Form1'
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
    Width = 410
    Height = 95
    Align = alBottom
    BorderStyle = bsNone
    Lines.Strings = (
      'mmoDebug')
    TabOrder = 0
  end
  object SharpEColorEditorEx1: TSharpEColorEditorEx
    Left = 0
    Top = 0
    Width = 410
    Height = 462
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    TabOrder = 1
    Items = <
      item
        Title = 'Alpha'
        ColorCode = -1
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetBoolean
        Description = 'This is an alpha value:'
        ValueText = 'Alpha'
        Value = -1
        Visible = True
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
        Visible = True
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
        Visible = True
        ColorEditor = SharpEColorEditorEx1.Item2
        Tag = 0
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        Visible = True
        ColorEditor = SharpEColorEditorEx1.Item3
        Tag = 0
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        Visible = True
        ColorEditor = SharpEColorEditorEx1.Item4
        Tag = 0
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        Visible = True
        ColorEditor = SharpEColorEditorEx1.Item5
        Tag = 0
      end>
    SwatchManager = SharpESwatchManager1
    object Button2: TButton
      Left = 264
      Top = 380
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 6
      OnClick = Button2Click
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
      end
      item
        Color = clBlack
      end
      item
        Color = clBlack
      end>
    Width = 378
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
