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
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    object lb_clock: TSharpELabel
      Left = 0
      Top = 0
      Width = 285
      Height = 166
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = '.'
      PopupMenu = MenuPopup
      Transparent = True
      Layout = tlCenter
      SkinManager = SharpESkinManager1
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
  end
  object SharpESkinManager1: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    Left = 192
    Top = 72
  end
  object ClockTimer: TTimer
    OnTimer = ClockTimerTimer
    Left = 224
    Top = 16
  end
end
