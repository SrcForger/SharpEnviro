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
  PixelsPerInch = 96
  TextHeight = 13
  object Background: TImage32
    Left = 0
    Top = 0
    Width = 285
    Height = 167
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    PopupMenu = MenuPopup
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    object cboxList: TComboBox
      Left = 0
      Top = 0
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'Item 1'
        'Item 2'
        'Item 3'
        'Item 4'
        'Item 5'
        'Item 6'
        'Item 7'
        'Item 8'
        'Item 9'
        'Item 10')
    end
  end
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
    HandleUpdates = True
    Left = 192
    Top = 72
  end
end
