object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Sharp Menu'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lb_bottomclock: TSharpESkinLabel
    Left = 18
    Top = 0
    Width = 12
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnDblClick = lb_clockDblClick
    Caption = '.'
    AutoPosition = False
    LabelStyle = lsSmall
  end
  object lb_clock: TSharpESkinLabel
    Left = 2
    Top = 0
    Width = 12
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnDblClick = lb_clockDblClick
    Caption = '.'
    AutoPosition = False
    LabelStyle = lsMedium
  end
  object MenuPopup: TPopupMenu
    Left = 168
    Top = 120
    object OpenWindowsDateTimesettings1: TMenuItem
      Caption = 'Open Windows Date/Time Settings'
      OnClick = lb_clockDblClick
    end
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = []
    HandleUpdates = False
    Left = 192
    Top = 72
  end
  object ClockTimer: TTimer
    OnTimer = ClockTimerTimer
    Left = 160
    Top = 88
  end
end
