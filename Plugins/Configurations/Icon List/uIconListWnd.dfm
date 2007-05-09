object frmIconList: TfrmIconList
  Left = 0
  Top = 0
  Width = 434
  Height = 320
  Caption = 'frmIconList'
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
  object lb_iconlist: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 426
    Height = 192
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
    ItemHeight = 22
    OnClickItem = lb_iconlistClickItem
    Borderstyle = bsNone
    Ctl3d = False
    Align = alClient
  end
  object previewpanel: TPanel
    Left = 0
    Top = 192
    Width = 426
    Height = 99
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
    object iconpreview: TImage32
      Left = 0
      Top = 0
      Width = 426
      Height = 99
      Align = alClient
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      Scale = 1.000000000000000000
      ScaleMode = smNormal
      TabOrder = 0
    end
  end
end
