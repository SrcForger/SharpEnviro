object frmSettingsWnd: TfrmSettingsWnd
  Left = 0
  Top = 0
  Caption = 'frmSettingsWnd'
  ClientHeight = 284
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ccolors: TSharpEColorEditorEx
    Left = 0
    Top = 65
    Width = 418
    Height = 219
    Margins.Left = 0
    Margins.Top = 4
    Margins.Right = 0
    Margins.Bottom = 0
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWhite
    ParentColor = False
    TabOrder = 0
    Items = <
      item
        Title = 'Primary Color'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = ccolors.Item0
        Tag = 0
      end
      item
        Title = 'Secondary Color'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = ccolors.Item1
        Tag = 0
      end
      item
        Title = 'Color 3'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = ccolors.Item2
        Tag = 0
      end
      item
        Title = 'Color 4'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        ValueMin = 0
        ValueMax = 255
        Visible = True
        DisplayPercent = False
        ColorEditor = ccolors.Item3
        Tag = 0
      end>
    SwatchManager = SharpESwatchManager1
    OnUiChange = ccolorsUiChange
    BorderColor = clBlack
    BackgroundColor = clWhite
    BackgroundTextColor = clBlack
    ContainerColor = clBlack
    ContainerTextColor = clBlack
  end
  object lbCursorList: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 418
    Height = 65
    Columns = <
      item
        Width = 256
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = PngImageList1
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    OnResize = lbCursorListResize
    ItemHeight = 30
    OnClickItem = lbCursorListClickItem
    OnGetCellText = lbCursorListGetCellText
    OnGetCellImageIndex = lbCursorListGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alTop
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 385
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
    BorderColor = clBlack
    BackgroundColor = clBlack
    BackgroundTextColor = clBlack
    Left = 380
    Top = 12
  end
  object tmr: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmrOnTimer
    Left = 300
    Top = 136
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C0000011B4944415478DA
          63FCCF000167EA4C9A18B00046988293FFFF3659D5E35170F4BF28C3D356C71A
          9C0A0EFD3763B8C7F0B0C3B31287827DFFAD187E303C64B8DF1D508655C1AEFF
          D640058C4053EE7447946151B0EDBF2DC33786FF0CCC0C77186EF425166328D8
          F4DF9EE10BC33F208B95E116C3D5899905680AD6FD7764F80C54C0C8C0CEF097
          E13AC3E52985B9280A56FDF7042AF80B54B0E9EB9F1B7F74FFB0FD9D52998BA4
          60E97F6386633F8DD9E51816FFFF2355F48281A189F32F43E377B88285FFFFBC
          F8E3FF67A5ABC20B86130BCB12301C39F7E49FD0F447130364D7BB324CFAF757
          A8EE239A82199C19DF4174E7F360893B0CC71A9B1AD014C0404BACFA22438679
          9FFF8874FDC2AAA081EDEF833FCFFE6EED82C62C00A6AA800184188152000000
          0049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end>
    Left = 368
    Top = 136
    Bitmap = {}
  end
end
