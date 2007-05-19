object MainWnd: TMainWnd
  Left = 0
  Top = 0
  Width = 464
  Height = 342
  BorderWidth = 8
  Caption = 'v'
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
  object Button1: TButton
    Left = 96
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button2Click
  end
  object SharpEColorEditor2: TSharpEColorEditor
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
    ValueEditorType = vetColor
    ValueText = 'Alpha'
    ValueMax = 0
    ValueMin = 255
    Value = 34
    Visible = True
    SwatchManager = SharpESwatchManager1
    DesignSize = (
      432
      24)
  end
  object Button3: TButton
    Left = 268
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button3Click
  end
  object XPManifest1: TXPManifest
    Left = 8
    Top = 248
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 408
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
