object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Menu'
  ClientHeight = 166
  ClientWidth = 285
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btn: TSharpEButton
    Left = 0
    Top = 0
    Width = 75
    Height = 25
    AutoSize = True
    OnMouseUp = btnMouseUp
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Layout = blGlyphLeft
    AutoPosition = True
  end
end
