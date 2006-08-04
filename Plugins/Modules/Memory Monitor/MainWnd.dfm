object MainForm: TMainForm
  Left = 0
  Top = 0
  Width = 197
  Height = 193
  Caption = 'Memory Monitor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Background: TImage32
    Left = 0
    Top = 0
    Width = 189
    Height = 164
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    PopupMenu = MenuPopup
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    object rambar: TSharpEProgressBar
      Left = 40
      Top = 0
      Width = 99
      Height = 10
      Min = 0
      Max = 100
      Value = 0
      ParentShowHint = False
      ShowHint = False
      SkinManager = SharpESkinManager1
      AutoSize = True
    end
    object swpbar: TSharpEProgressBar
      Left = 40
      Top = 16
      Width = 99
      Height = 10
      Min = 0
      Max = 100
      Value = 0
      ParentShowHint = False
      ShowHint = False
      SkinManager = SharpESkinManager1
      AutoSize = True
    end
    object lb_rambar: TSharpELabel
      Left = 144
      Top = 0
      Width = 37
      Height = 10
      Caption = 'lb_rambar'
      Visible = False
      SkinManager = SharpESkinManager1
      LabelStyle = lsSmall
    end
    object lb_swpbar: TSharpELabel
      Left = 144
      Top = 16
      Width = 39
      Height = 10
      Caption = 'lb_swpbar'
      Visible = False
      SkinManager = SharpESkinManager1
      LabelStyle = lsSmall
    end
    object lb_swp: TSharpELabel
      Left = 0
      Top = 16
      Width = 15
      Height = 10
      Caption = 'swp'
      Visible = False
      SkinManager = SharpESkinManager1
      LabelStyle = lsSmall
    end
    object lb_ram: TSharpELabel
      Left = 0
      Top = 0
      Width = 13
      Height = 10
      Caption = 'ram'
      Visible = False
      SkinManager = SharpESkinManager1
      LabelStyle = lsSmall
    end
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = UpdateTimerTimer
    Left = 120
    Top = 40
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
    Left = 224
    Top = 80
  end
end
