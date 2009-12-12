object Form2: TForm2
  Left = 0
  Top = 0
  BorderWidth = 8
  Caption = 'Form2'
  ClientHeight = 268
  ClientWidth = 402
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SharpERoundPanel1: TSharpERoundPanel
    Left = 0
    Top = 25
    Width = 402
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'SharpERoundPanel1'
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    DrawMode = srpNoTopLeft
    NoTopBorder = True
    RoundValue = 10
    BorderColor = clBlack
    Border = True
    BackgroundColor = clBtnFace
  end
  object SharpETabList1: TSharpETabList
    Left = 0
    Top = 0
    Width = 402
    Height = 25
    Align = alTop
    ButtonWidth = 24
    TabIndex = 0
    TabColor = 15724527
    TabSelectedColor = clWindow
    BkgColor = clWindow
    CaptionSelectedColor = clBlack
    StatusSelectedColor = clGreen
    CaptionUnSelectedColor = clBlack
    StatusUnSelectedColor = clGreen
    TabAlign = taLeftJustify
    TextSpacingX = 8
    TextSpacingY = 6
    IconSpacingX = 4
    IconSpacingY = 4
    AutoSizeTabs = False
    BottomBorder = False
    Border = True
    BorderColor = clBlack
    BorderSelectedColor = clBlack
    TabList = <
      item
        Caption = 'Test'
        ImageIndex = 0
        Visible = True
      end
      item
        Caption = 'Test2'
        ImageIndex = 0
        Visible = True
      end>
    Buttons = <>
    Minimized = False
  end
end
