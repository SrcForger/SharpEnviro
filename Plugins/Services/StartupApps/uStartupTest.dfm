object Form1: TForm1
  Left = 338
  Top = 197
  Caption = 'Test Wnd'
  ClientHeight = 310
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 268
    Top = 188
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Memo1: TMemo
    Left = 0
    Top = 45
    Width = 528
    Height = 265
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 10
    ExplicitTop = 84
    ExplicitWidth = 503
    ExplicitHeight = 205
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 528
    Height = 45
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 56
    ExplicitTop = 16
    ExplicitWidth = 389
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
      Left = 181
      Top = 11
      Width = 161
      Height = 25
      Caption = 'Start Startup Apps'
      TabOrder = 1
      OnClick = btn2Click
    end
  end
end
