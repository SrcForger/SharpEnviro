object frmCursesList: TfrmCursesList
  Left = 0
  Top = 0
  Caption = 'frmCursesList'
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 418
    Height = 65
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    ParentColor = True
    TabOrder = 0
    object lb_CursorList: TSharpEListBoxEx
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
          StretchColumn = False
          ColumnType = ctDefault
        end
        item
          Width = 256
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calLeft
          StretchColumn = False
          ColumnType = ctDefault
        end>
      Colors.BorderColor = clBtnFace
      Colors.BorderColorSelected = clBtnShadow
      Colors.ItemColor = clWindow
      Colors.ItemColorSelected = clBtnFace
      Colors.CheckColorSelected = clBtnFace
      Colors.CheckColor = 15528425
      ItemHeight = 30
      OnClickItem = lb_CursorListClickItem
      AutosizeGrid = False
      Borderstyle = bsNone
      Ctl3d = False
      Align = alClient
    end
  end
  object ccolors: TSharpEColorEditorEx
    Left = 0
    Top = 65
    Width = 418
    Height = 219
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alBottom
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    TabOrder = 1
    Items = <
      item
        Title = 'Primary Color'
        ColorCode = 0
        ColorAsTColor = clBlack
        Expanded = False
        ValueEditorType = vetColor
        Value = 0
        Visible = True
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
        Visible = True
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
        Visible = True
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
        Visible = True
        ColorEditor = ccolors.Item3
        Tag = 0
      end>
    SwatchManager = SharpESwatchManager1
    OnChangeColor = ccolorsChangeColor
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 386
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
