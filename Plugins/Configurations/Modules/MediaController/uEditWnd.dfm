object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  Caption = 'frmEdit'
  ClientHeight = 280
  ClientWidth = 503
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbItems: TSharpEListBoxEx
    AlignWithMargins = True
    Left = 0
    Top = 55
    Width = 498
    Height = 148
    Margins.Left = 0
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 0
    Columns = <
      item
        Width = 256
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = pilSelected
        SelectedImages = pilUnselected
      end
      item
        Width = 90
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = False
        ColumnType = ctCheck
        VisibleOnSelectOnly = False
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = clWindow
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    OnResize = lbItemsResize
    ItemHeight = 30
    OnClickCheck = lbItemsClickCheck
    OnGetCellCursor = lbItemsGetCellCursor
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alTop
  end
  object SharpECenterHeader3: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 10
    Width = 493
    Height = 35
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Visible Players'
    Description = 
      'Define which players will be accessible with the player select b' +
      'utton'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object pilSelected: TPngImageList
    PngImages = <>
    Left = 452
    Top = 92
  end
  object pilUnselected: TPngImageList
    PngImages = <>
    Left = 452
    Top = 120
  end
end
