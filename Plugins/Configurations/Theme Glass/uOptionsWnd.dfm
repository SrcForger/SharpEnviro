object frmOptions: TfrmOptions
  Left = 0
  Top = 0
  Caption = 'frmOptions'
  ClientHeight = 327
  ClientWidth = 525
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sceGlassOptions: TSharpEColorEditorEx
    AlignWithMargins = True
    Left = 8
    Top = 0
    Width = 509
    Height = 319
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 8
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWindow
    ParentBackground = True
    ParentColor = False
    TabOrder = 0
    Items = <>
    SwatchManager = SharpESwatchManager1
    OnUiChange = sceGlassOptionsUiChange
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 100
    ShowCaptions = True
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
    Left = 356
    Top = 132
  end
end
