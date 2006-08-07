object sfilterform: Tsfilterform
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Special Task Filters'
  ClientHeight = 216
  ClientWidth = 212
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object list_filters: TListBox
    Left = 0
    Top = 0
    Width = 121
    Height = 177
    ItemHeight = 13
    TabOrder = 0
    OnClick = list_filtersClick
  end
  object btn_new: TButton
    Left = 128
    Top = 8
    Width = 75
    Height = 25
    Caption = 'New'
    TabOrder = 1
    OnClick = btn_newClick
  end
  object btn_edit: TButton
    Left = 128
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 2
    OnClick = btn_editClick
  end
  object btn_delete: TButton
    Left = 128
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = btn_deleteClick
  end
  object Button1: TButton
    Left = 128
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = Button1Click
  end
end
