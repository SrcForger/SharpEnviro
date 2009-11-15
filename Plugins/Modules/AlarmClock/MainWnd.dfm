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
  OnDestroy = FormDestroy
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
    object mnuSnoozeBtn: TMenuItem
      Caption = 'Snooze'
      OnClick = mnuRightSnoozeClick
    end
    object mnuTurnOffBtn: TMenuItem
      Caption = 'Turn Off'
      OnClick = mnuRightTurnOffClick
    end
    object mnuDisableBtn: TMenuItem
      Caption = 'Disable'
      OnClick = mnuRightDisableClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuConfigBtn: TMenuItem
      Caption = 'Configure'
      OnClick = mnuRightConfigClick
    end
  end
end
