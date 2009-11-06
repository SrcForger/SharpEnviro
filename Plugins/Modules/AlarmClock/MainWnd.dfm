object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Alarm Clock'
  ClientHeight = 159
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object btnAlarm: TSharpEButton
    Left = 0
    Top = 0
    Width = 42
    Height = 25
    AutoSize = True
    OnMouseUp = btnAlarmOnClick
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Layout = blGlyphLeft
    AutoPosition = True
  end
  object alarmUpdTimer: TTimer
    Enabled = False
    OnTimer = alarmOnTimer
    Left = 72
    Top = 32
  end
  object alarmSnoozeTimer: TTimer
    Enabled = False
    Interval = 0
    OnTimer = alarmOnSnoozeTimer
    Left = 104
    Top = 32
  end
  object alarmTimeoutTimer: TTimer
    Enabled = False
    Interval = 0
    OnTimer = alarmOnTimeoutTimer
    Left = 136
    Top = 32
  end
  object mnuRight: TPopupMenu
    Alignment = paCenter
    Left = 168
    Top = 32
    object urnOff1: TMenuItem
      Caption = 'Snooze'
      OnClick = mnuRightSnoozeClick
    end
    object urnOff2: TMenuItem
      Caption = 'Turn Off'
      OnClick = mnuRightTurnOffClick
    end
    object Disable1: TMenuItem
      Caption = 'Disable'
      OnClick = mnuRightDisableClick
    end
  end
end
