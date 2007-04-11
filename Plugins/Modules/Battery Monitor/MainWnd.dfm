object MainForm: TMainForm
  Left = 0
  Top = 0
  Width = 293
  Height = 195
  Caption = 'Battery Monitor'
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
    Width = 277
    Height = 159
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    PopupMenu = MenuPopup
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    object lb_info: TSharpESkinLabel
      Left = 2
      Top = -1
      Width = 12
      Height = 21
      SkinManager = SharpESkinManager1
      AutoSize = True
      Caption = '.'
      AutoPosition = False
      LabelStyle = lsMedium
    end
    object pbar: TSharpEProgressBar
      Left = 24
      Top = 16
      Width = 75
      Height = 9
      Min = 0
      Max = 100
      Value = 0
      SkinManager = SharpESkinManager1
      AutoSize = True
    end
    object lb_pc: TSharpESkinLabel
      Left = 106
      Top = -1
      Width = 12
      Height = 21
      SkinManager = SharpESkinManager1
      AutoSize = True
      Caption = '.'
      AutoPosition = False
      LabelStyle = lsMedium
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
    ComponentSkins = [scProgressBar]
    HandleUpdates = False
    Left = 192
    Top = 72
  end
  object UpdateTimer: TTimer
    OnTimer = UpdateTimerTimer
    Left = 224
    Top = 16
  end
end
