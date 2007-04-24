object Form1: TForm1
  Left = 0
  Top = 0
  Width = 434
  Height = 491
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
    Top = 352
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
    Height = 352
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    TabOrder = 1
    Items = <
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
      end
      item
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
      end>
    SwatchManager = SharpESwatchManager1
  end
  object XPManifest1: TXPManifest
    Left = 336
    Top = 232
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 368
    Top = 232
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
    Width = 394
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
