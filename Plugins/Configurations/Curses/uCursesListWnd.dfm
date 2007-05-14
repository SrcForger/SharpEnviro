object frmCursesList: TfrmCursesList
  Left = 0
  Top = 0
  Width = 434
  Height = 320
  Caption = 'frmCursesList'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object previewpanel: TPanel
    Left = 0
    Top = 40
    Width = 426
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 0
    object cursorpreview: TImage32
      Left = 0
      Top = 0
      Width = 426
      Height = 32
      Align = alClient
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      ParentColor = False
      Scale = 1.000000000000000000
      ScaleMode = smNormal
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 426
    Height = 40
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    ParentColor = True
    TabOrder = 1
    object lb_CursorList: TSharpEListBoxEx
      Left = 0
      Top = 0
      Width = 426
      Height = 40
      Columns = <
        item
          Width = 256
          MaxWidth = 0
          MinWidth = 0
          TextColor = clBlack
          SelectedTextColor = clBlack
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calLeft
          Autosize = False
        end
        item
          Width = 256
          MaxWidth = 0
          MinWidth = 0
          TextColor = clBlack
          SelectedTextColor = clBlack
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calLeft
          Autosize = False
        end>
      ItemHeight = 22
      OnClickItem = lb_CursorListClickItem
      Borderstyle = bsNone
      Ctl3d = False
      Align = alClient
    end
  end
  object ccolors: TSharpEColorEditorEx
    Left = 0
    Top = 72
    Width = 426
    Height = 219
    Align = alBottom
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    TabOrder = 2
    Items = <
      item
        Title = 'Primary Color'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ColorEditor = ccolors.Item0
        Tag = 0
      end
      item
        Title = 'Secondary Color'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ColorEditor = ccolors.Item1
        Tag = 0
      end
      item
        Title = 'Color 3'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ColorEditor = ccolors.Item2
        Tag = 0
      end
      item
        Title = 'Color 4'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ColorEditor = ccolors.Item3
        Tag = 0
      end>
    SwatchManager = SharpESwatchManager1
    OnChangeColor = ccolorsChangeColor
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 394
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
    Left = 352
    Top = 48
  end
end
