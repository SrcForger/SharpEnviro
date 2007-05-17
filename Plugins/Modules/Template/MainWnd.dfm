object MainForm: TMainForm
  Left = 0
  Top = 0
  Width = 293
  Height = 195
  Caption = 'Menu'
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
  object MenuPopup: TPopupMenu
    Left = 224
    Top = 72
    object MenuSettingsItem: TMenuItem
      Caption = 'Settings'
      OnClick = MenuSettingsItemClick
    end
  end
  object SkinManager: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    ComponentSkins = [scPanel, scButton, scProgressBar, scCheckBox, scRadioBox, scMiniThrobber, scEdit, scTaskItem]
    HandleUpdates = False
    Left = 112
    Top = 32
  end
end
