object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Clock'
  ClientHeight = 159
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = MenuPopup
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lb_bottomclock: TSharpESkinLabel
    Left = 18
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    OnDblClick = lb_clockDblClick
    Caption = '.'
    AutoPos = apBottom
    LabelStyle = lsSmall
  end
  object lb_clock: TSharpESkinLabel
    Left = 2
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    OnDblClick = lb_clockDblClick
    Caption = '.'
    AutoPos = apCenter
    LabelStyle = lsMedium
  end
  object MenuPopup: TPopupMenu
    Left = 128
    Top = 72
    object OpenWindowsDateTimesettings1: TMenuItem
      Caption = 'Open Windows Date/Time Settings'
      OnClick = lb_clockDblClick
    end
  end
  object ClockTimer: TTimer
    Enabled = False
    OnTimer = ClockTimerTimer
    Left = 160
    Top = 72
  end
end
