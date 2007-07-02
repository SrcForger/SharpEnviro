object Form1: TForm1
  Left = 0
  Top = 0
  Width = 434
  Height = 320
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 52
    Top = 80
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'ComboBox1'
  end
  object BitBtn1: TBitBtn
    Left = 148
    Top = 124
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 2
  end
  object XPManifest1: TXPManifest
    Left = 196
    Top = 180
  end
  object XPColorMap1: TXPColorMap
    HighlightColor = clWhite
    BtnSelectedColor = clBtnFace
    UnusedColor = clWhite
    Left = 260
    Top = 176
  end
end
