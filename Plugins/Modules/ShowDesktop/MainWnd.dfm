object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Show Desktop'
  ClientHeight = 159
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object btn: TSharpEButton
    Left = 8
    Top = 0
    Width = 105
    Height = 25
    AutoSize = True
    OnMouseUp = btnMouseUp
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.OuterColor = -16777216
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Layout = blGlyphLeft
    Caption = 'Button'
    AutoPosition = True
  end
end
