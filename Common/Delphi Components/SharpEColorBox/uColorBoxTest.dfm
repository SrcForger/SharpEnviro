object Form1: TForm1
  Left = 0
  Top = 0
  Width = 434
  Height = 250
  BorderWidth = 1
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 40
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object SharpEFontSelector1: TSharpEFontSelector
    Left = 232
    Top = 80
    Width = 145
    Height = 21
    FontBackground = sefbChecker
    ShadowEnabled = True
    AlphaEnabled = True
    BoldEnabled = True
    ItalicEnabled = True
    UnderlineEnabled = True
    Color = clWindow
    Enabled = True
  end
  object Edit1: TEdit
    Left = 232
    Top = 112
    Width = 145
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Panel1: TPanel
    Left = 24
    Top = 152
    Width = 185
    Height = 41
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'Panel1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
  end
  object SharpEColorBox1: TSharpEColorBox
    Left = 256
    Top = 56
    Width = 35
    Height = 15
    BackgroundColor = clBtnFace
    Color = clWhite
    ColorCode = 16777215
    OnColorClick = SharpEColorBox1ColorClick
  end
  object SharpEFontSelector2: TSharpEFontSelector
    Left = 232
    Top = 136
    Width = 145
    Height = 21
    FontBackground = sefbChecker
    ShadowEnabled = True
    AlphaEnabled = True
    BoldEnabled = True
    ItalicEnabled = True
    UnderlineEnabled = True
    Color = clBtnHighlight
    Enabled = True
  end
  object XPManifest1: TXPManifest
    Left = 172
    Top = 76
  end
end
