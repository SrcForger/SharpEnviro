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
    Width = 277
    Height = 159
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    PopupMenu = MenuPopup
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
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
  end
  object MenuPopup: TPopupMenu
    Left = 168
    Top = 120
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
    end
    object OpenWindowsDateTimesettings1: TMenuItem
      Caption = 'Open Windows Date/Time Settings'
      OnClick = lb_clockDblClick
    end
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    HandleUpdates = False
    Left = 192
    Top = 72
  end
  object ClockTimer: TTimer
    OnTimer = ClockTimerTimer
    Left = 224
    Top = 16
  end
end
