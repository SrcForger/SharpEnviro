object Form1: TForm1
  Left = 338
  Top = 197
  Width = 544
  Height = 346
  Caption = 'Test Wnd'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 10
    Top = 12
    Width = 161
    Height = 25
    Caption = 'Show Settings'
    TabOrder = 0
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 10
    Top = 46
    Width = 161
    Height = 25
    Caption = 'Start Startup Apps'
    TabOrder = 1
    OnClick = btn2Click
  end
end
