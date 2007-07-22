object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Memory Monitor'
  ClientHeight = 164
  ClientWidth = 305
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
  object lb_swpbar: TSharpESkinLabel
    Left = 80
    Top = 72
    Width = 51
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    Caption = 'lb_swpbar'
    AutoPosition = False
    LabelStyle = lsSmall
  end
  object lb_rambar: TSharpESkinLabel
    Left = 80
    Top = 40
    Width = 51
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    Caption = 'lb_rambar'
    AutoPosition = False
    LabelStyle = lsSmall
  end
  object lb_swp: TSharpESkinLabel
    Left = 32
    Top = 48
    Width = 26
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    Caption = 'swp'
    AutoPosition = False
    LabelStyle = lsSmall
  end
  object lb_ram: TSharpESkinLabel
    Left = 8
    Top = 0
    Width = 26
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    Caption = 'ram'
    AutoPosition = False
    LabelStyle = lsSmall
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
  object UpdateTimer: TTimer
    Enabled = False
    OnTimer = UpdateTimerTimer
    Left = 216
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
    ComponentSkins = [scProgressBar]
    HandleUpdates = False
    Left = 224
    Top = 80
  end
end
