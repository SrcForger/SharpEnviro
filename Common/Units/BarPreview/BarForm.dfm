object BarWnd: TBarWnd
  Left = 0
  Top = 0
  Caption = 'BarWnd'
  ClientHeight = 32
  ClientWidth = 423
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button: TSharpEButton
    Left = 16
    Top = 8
    Width = 75
    Height = 25
    AutoSize = True
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Layout = blGlyphLeft
    Caption = 'SharpE'
    AutoPosition = False
  end
  object SharpEScheme1: TSharpEScheme
    Left = 280
    Top = 8
  end
end
