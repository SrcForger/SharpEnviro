object frmSkinListWnd: TfrmSkinListWnd
  Left = 0
  Top = 0
  Width = 434
  Height = 320
  Caption = 'Skin List'
  Color = clBtnFace
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
  object lbSkinList: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 418
    Height = 284
    Columns = <>
    ItemHeight = 66
    OnClickItem = lbSkinListDblClickItem
    OnGetCellTextColor = lbSkinListGetCellTextColor
    OnGetCellColor = lbSkinListGetCellColor
    BevelOuter = bvNone
    Borderstyle = bsNone
    Align = alClient
  end
  object ThemeImages: TPngImageList
    Height = 48
    Width = 62
    PngImages = <>
    Left = 304
    Top = 192
  end
end
