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
    Top = 281
    Width = 410
    Height = 166
    Align = alClient
    BorderStyle = bsNone
    Lines.Strings = (
      'mmoDebug')
    TabOrder = 1
  end
  object SharpEColorPanelEx1: TSharpEColorPanelEx
    Left = 0
    Top = 0
    Width = 410
    Height = 281
    Align = alTop
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    TabOrder = 0
    Items = <
      item
        Title = 'Work Area'
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
        Title = 'Monkey'
        ColorCode = 255
        ColorAsTColor = clRed
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
end
