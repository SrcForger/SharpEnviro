object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Notes'
  ClientHeight = 166
  ClientWidth = 285
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Button: TSharpEButton
    Left = 2
    Top = 0
    Width = 105
    Height = 20
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = ButtonClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.OuterColor = -16777216
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Layout = blGlyphLeft
    Margin = 0
    DisabledAlpha = 100
    Caption = 'Notes'
    AutoPosition = True
    GlyphResize = True
    GlyphSpacing = 0
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
    ComponentSkins = [scButton]
    HandleUpdates = False
    Left = 192
    Top = 72
  end
end
