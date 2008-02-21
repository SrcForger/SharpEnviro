object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Weather'
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
  PixelsPerInch = 96
  TextHeight = 13
  object lb_bottom: TSharpESkinLabel
    Left = 50
    Top = 0
    Width = 12
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnDblClick = BackgroundDblClick
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsSmall
  end
  object lb_top: TSharpESkinLabel
    Left = 2
    Top = 0
    Width = 12
    Height = 21
    SkinManager = SharpESkinManager1
    AutoSize = True
    OnDblClick = BackgroundDblClick
    Caption = '.'
    AutoPos = apTop
    LabelStyle = lsSmall
  end
  object MenuPopup: TPopupMenu
    Left = 160
    Top = 72
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
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
end
