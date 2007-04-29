object Form1: TForm1
  Left = 0
  Top = 0
  Width = 434
  Height = 250
  BorderWidth = 1
  Caption = 'Form1'
  Color = clWindow
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
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
    TabOrder = 0
  end
  object SharpEColorPicker1: TSharpEColorPicker
    Left = 24
    Top = 28
    Width = 35
    Height = 17
    BackgroundColor = clWhite
    Color = clWhite
    ColorCode = 16777215
  end
  object XPManifest1: TXPManifest
    Left = 172
    Top = 76
  end
end
