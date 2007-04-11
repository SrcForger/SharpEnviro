object MainWnd: TMainWnd
  Left = 0
  Top = 0
  Width = 496
  Height = 342
  BorderWidth = 8
  Caption = 'MainWnd'
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
  object SharpEColorPanel1: TSharpEColorPanel
    Left = 0
    Top = 0
    Width = 464
    Height = 24
    Align = alTop
    Expanded = False
    GroupIndex = 0
    Caption = 'Shadow Colour'
    ColorCode = 0
    ColorAsTColor = clBlack
    DesignSize = (
      464
      24)
  end
  object XPManifest1: TXPManifest
    Left = 8
    Top = 248
  end
end
