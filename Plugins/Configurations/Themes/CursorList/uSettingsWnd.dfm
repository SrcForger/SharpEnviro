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
    ExplicitTop = 64
    ExplicitHeight = 104
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
        AutoSize = False
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    OnResize = lbCursorListResize
    ItemHeight = 25
    OnClickItem = lbCursorListClickItem
    OnGetCellText = lbCursorListGetCellText
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
end
