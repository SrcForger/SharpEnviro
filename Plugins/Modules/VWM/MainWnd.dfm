object MainForm: TMainForm
  Left = 0
  Top = 0
  Width = 178
  Height = 59
  Anchors = [akLeft, akTop, akBottom]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object background: TImage32
    Left = 0
    Top = 0
    Width = 170
    Height = 25
    Align = alClient
    Anchors = [akLeft, akTop, akBottom]
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    DesignSize = (
      170
      25)
    object SharpEButton1: TSharpEButton
      Left = 0
      Top = 0
      Width = 43
      Height = 24
      Anchors = [akLeft, akTop, akBottom]
      SkinManager = SharpESkinManager1
      AutoSize = True
      OnClick = GenericButtonClick
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TLinearResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = '1'
      AutoPosition = True
      GlyphResize = True
    end
    object SharpEButton2: TSharpEButton
      Tag = 1
      Left = 42
      Top = 0
      Width = 43
      Height = 24
      Anchors = [akLeft, akTop, akBottom]
      SkinManager = SharpESkinManager1
      AutoSize = True
      OnClick = GenericButtonClick
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = '2'
      AutoPosition = True
      GlyphResize = False
    end
    object SharpEButton3: TSharpEButton
      Tag = 2
      Left = 84
      Top = 0
      Width = 43
      Height = 24
      Anchors = [akLeft, akTop, akBottom]
      SkinManager = SharpESkinManager1
      AutoSize = True
      OnClick = GenericButtonClick
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = '3'
      AutoPosition = True
      GlyphResize = False
    end
    object SharpEButton4: TSharpEButton
      Tag = 3
      Left = 126
      Top = 0
      Width = 43
      Height = 24
      Anchors = [akLeft, akTop, akBottom]
      SkinManager = SharpESkinManager1
      AutoSize = True
      OnClick = GenericButtonClick
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TNearestResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      Caption = '4'
      AutoPosition = True
      GlyphResize = False
    end
  end
  object MenuPopup: TPopupMenu
    Left = 104
    Top = 16
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
    end
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    Left = 56
    Top = 16
  end
  object HotKeyManager1: THotKeyManager
    OnHotKeyPressed = HotKeyManager1HotKeyPressed
    Left = 144
    Top = 16
  end
end
