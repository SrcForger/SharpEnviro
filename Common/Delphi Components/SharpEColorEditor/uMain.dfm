object MainWnd: TMainWnd
  Left = 0
  Top = 0
  BorderWidth = 8
  Caption = 'v'
  ClientHeight = 290
  ClientWidth = 432
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
    Left = 44
    Top = 252
    Width = 75
    Height = 25
    Caption = 'Color'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 124
    Top = 252
    Width = 75
    Height = 25
    Caption = 'Value'
    TabOrder = 1
    OnClick = Button2Click
  end
  object SharpEColorEditor2: TSharpEColorEditor
    Left = 0
    Top = 0
    Width = 432
    Height = 24
    Align = alTop
    ParentColor = False
    DisplayPercent = False
    Expanded = False
    GroupIndex = 0
    Caption = 'Scheme Test'
    ValueAsTColor = clBlack
    ValueEditorType = vetColor
    ValueText = 'Alpha'
    Value = 0
    ValueMin = 0
    ValueMax = 255
    Visible = True
    SwatchManager = SharpESwatchManager1
    DesignSize = (
      432
      24)
  end
  object Button3: TButton
    Left = 284
    Top = 252
    Width = 75
    Height = 25
    Caption = 'ToggleVis'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 204
    Top = 252
    Width = 75
    Height = 25
    Caption = 'Bool'
    TabOrder = 4
    OnClick = Button4Click
  end
  object XPManifest1: TXPManifest
    Left = 8
    Top = 248
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
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
