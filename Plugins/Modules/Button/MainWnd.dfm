object MainForm: TMainForm
  Left = 0
  Top = 0
  Width = 293
  Height = 195
  Caption = 'Sharp Menu'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Background: TImage32
    Left = 0
    Top = 0
    Width = 285
    Height = 166
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    PopupMenu = MenuPopup
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    object Button: TSharpEButton
      Left = 8
      Top = 1
      Width = 105
      Height = 32
      SkinManager = SharpESkinManager1
      AutoSize = False
      OnMouseUp = ButtonMouseUp
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.OuterColor = -16777216
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = 0
      DisabledAlpha = 100
      Caption = 'Button'
      AutoPosition = True
    end
  end
  object MenuPopup: TPopupMenu
    Left = 168
    Top = 120
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
    end
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    Left = 192
    Top = 72
  end
end
