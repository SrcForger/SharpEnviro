object frmIconList: TfrmIconList
  Left = 0
  Top = 0
  Caption = 'frmIconList'
  ClientHeight = 284
  ClientWidth = 418
  Color = clWindow
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
  object lb_iconlist: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 418
    Height = 148
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
      end>
    OnResize = lb_iconlistResize
    ItemHeight = 22
    OnClickItem = lb_iconlistClickItem
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alTop
    ExplicitLeft = 64
    ExplicitTop = 40
    ExplicitWidth = 185
  end
end
