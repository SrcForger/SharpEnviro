object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'VolumeControl'
  ClientHeight = 159
  ClientWidth = 277
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
  object mute: TSharpEButton
    Left = 2
    Top = 0
    Width = 25
    Height = 25
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnClick = muteClick
    OnMouseUp = muteMouseUp
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TLinearResampler'
    Layout = blGlyphLeft
    AutoPosition = True
  end
  object pbar: TSharpEProgressBar
    Left = 33
    Top = 8
    Width = 75
    Height = 9
    Min = 0
    Max = 65535
    Value = 0
    AutoPos = apCenter
    SkinManager = SharpESkinManager1
    AutoSize = False
  end
  object cshape: TShape
    Left = 56
    Top = 32
    Width = 33
    Height = 33
    Brush.Style = bsClear
    Pen.Style = psClear
    OnMouseDown = cshapeMouseDown
    OnMouseMove = cshapeMouseMove
    OnMouseUp = cshapeMouseUp
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = [scButton, scBar, scProgressBar]
    HandleUpdates = False
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
