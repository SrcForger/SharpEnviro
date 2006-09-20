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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Background: TImage32
    Left = 0
    Top = 0
    Width = 285
    Height = 164
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    object pbar: TSharpEProgressBar
      Left = 32
      Top = 4
      Width = 75
      Height = 9
      Min = 0
      Max = 65535
      Value = 0
      SkinManager = SharpESkinManager1
      AutoSize = False
    end
    object mute: TSharpEButton
      Left = 2
      Top = 1
      Width = 25
      Height = 20
      SkinManager = SharpESkinManager1
      AutoSize = True
      OnClick = muteClick
      Glyph32.DrawMode = dmBlend
      Glyph32.CombineMode = cmMerge
      Glyph32.ResamplerClassName = 'TLinearResampler'
      Layout = blGlyphLeft
      Margin = -1
      DisabledAlpha = 100
      AutoPosition = True
      GlyphResize = True
    end
    object cshape: TShape
      Left = 0
      Top = 16
      Width = 65
      Height = 65
      Brush.Style = bsClear
      Pen.Style = psClear
      OnMouseDown = cshapeMouseDown
      OnMouseMove = cshapeMouseMove
      OnMouseUp = cshapeMouseUp
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
  object ClockTimer: TTimer
    Interval = 250
    OnTimer = ClockTimerTimer
    Left = 224
    Top = 16
  end
end
