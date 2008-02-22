object frmConfigListWnd: TfrmConfigListWnd
  Left = 0
  Top = 0
  Caption = 'frmConfigListWnd'
  ClientHeight = 288
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object themelist: TSharpEListBox
    Left = 0
    Top = 0
    Width = 426
    Height = 288
    Style = lbOwnerDrawFixed
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsNone
    ItemHeight = 66
    TabOrder = 0
    OnDrawItem = themelistDrawItem
  end
  object ThemeImages: TPngImageList
    Height = 48
    Width = 62
    PngImages = <>
    Left = 304
    Top = 192
  end
end
