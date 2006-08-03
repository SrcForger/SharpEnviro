object ObjectListForm: TObjectListForm
  Left = 214
  Top = 237
  BorderStyle = bsToolWindow
  Caption = 'Loaded Desktop Objects'
  ClientHeight = 318
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tv_list: TTreeView
    Left = 0
    Top = 0
    Width = 169
    Height = 318
    Align = alLeft
    Indent = 19
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    OnChange = tv_listChange
  end
  object lv_info: TListView
    Left = 169
    Top = 0
    Width = 456
    Height = 318
    Align = alClient
    Columns = <
      item
        Caption = 'Property'
        Width = 150
      end
      item
        Caption = 'Value'
        Width = 300
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
end
