object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Memory Monitor'
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
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lb_servicenotrunning: TSharpESkinLabel
    Left = 0
    Top = 0
    Width = 141
    Height = 21
    SkinManager = SkinManager
    AutoSize = True
    Caption = 'SharpE Tray Service not running'
    AutoPosition = True
    LabelStyle = lsMedium
  end
  object MenuPopup: TPopupMenu
    AutoPopup = False
    Left = 168
    Top = 120
    object Settings1: TMenuItem
      Caption = 'Settings'
      OnClick = Settings1Click
    end
  end
  object SkinManager: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = [scBar]
    HandleUpdates = False
    Left = 112
    Top = 80
  end
end
