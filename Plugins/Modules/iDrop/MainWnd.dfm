object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Sharp Menu'
  ClientHeight = 143
  ClientWidth = 263
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
    Width = 263
    Height = 143
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    PopupMenu = MenuPopup
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    OnDblClick = BackgroundDblClick
  end
  object MenuPopup: TPopupMenu
    Left = 168
    Top = 88
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
    end
  end
  object AnimTimer: TTimer
    Enabled = False
    OnTimer = AnimTimerTimer
    Left = 208
    Top = 72
  end
  object SkinManager: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = [scBar]
    HandleUpdates = False
    Left = 176
    Top = 48
  end
end
