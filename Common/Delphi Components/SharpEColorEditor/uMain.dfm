object MainWnd: TMainWnd
  Left = 0
  Top = 0
  Width = 464
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
  object SharpEColorEditor1: TSharpEColorEditor
    Left = 0
    Top = 0
    Width = 432
    Height = 24
    Align = alTop
    Expanded = False
    GroupIndex = 0
    Caption = 'Scheme Test'
    ColorCode = 0
    ColorAsTColor = clBlack
    SwatchManager = SharpESwatchManager1
    DesignSize = (
      432
      24)
  end
  object XPManifest1: TXPManifest
    Left = 8
    Top = 248
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 432
    ShowCaptions = False
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = 16709617
    SortMode = sortName
    Left = 348
    Top = 180
  end
end
