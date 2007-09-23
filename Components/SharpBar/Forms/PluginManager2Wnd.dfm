object PluginManager2Form: TPluginManager2Form
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Module Manager'
  ClientHeight = 385
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblAvailableModules: TLabel
    Left = 55
    Top = 10
    Width = 85
    Height = 13
    Caption = 'Available Modules'
  end
  object lblActiveLeft: TLabel
    Left = 270
    Top = 10
    Width = 139
    Height = 13
    Caption = 'Active Modules - Left Aligned'
  end
  object lblActiveRight: TLabel
    Left = 270
    Top = 178
    Width = 145
    Height = 13
    Caption = 'Active Modules - Right Aligned'
  end
  object lstAvailable: TListBox
    Left = 8
    Top = 27
    Width = 193
    Height = 314
    ItemHeight = 13
    TabOrder = 0
  end
  object lstActiveLeft: TListBox
    Left = 238
    Top = 27
    Width = 193
    Height = 118
    ItemHeight = 13
    TabOrder = 1
  end
  object btnAddLeft: TButton
    Left = 207
    Top = 69
    Width = 25
    Height = 25
    Caption = '->'
    TabOrder = 2
    OnClick = btnAddLeftClick
  end
  object btnRemoveLeft: TButton
    Left = 207
    Top = 100
    Width = 25
    Height = 25
    Caption = '<-'
    TabOrder = 3
    OnClick = btnRemoveLeftClick
  end
  object lstActiveRight: TListBox
    Left = 238
    Top = 193
    Width = 193
    Height = 120
    ItemHeight = 13
    TabOrder = 4
  end
  object btnAddRight: TButton
    Left = 207
    Top = 237
    Width = 25
    Height = 25
    Caption = '->'
    TabOrder = 5
    OnClick = btnAddRightClick
  end
  object btnRemoveRight: TButton
    Left = 207
    Top = 268
    Width = 25
    Height = 25
    Caption = '<-'
    TabOrder = 6
    OnClick = btnRemoveRightClick
  end
  object btnActiveRightMoveLeft: TButton
    Left = 238
    Top = 319
    Width = 75
    Height = 21
    Caption = 'Move Left'
    TabOrder = 7
    OnClick = btnActiveRightMoveLeftClick
  end
  object btnActiveRightMoveRight: TButton
    Left = 356
    Top = 319
    Width = 75
    Height = 21
    Caption = 'Move Right'
    TabOrder = 8
    OnClick = btnActiveRightMoveRightClick
  end
  object btnActiveLeftMoveLeft: TButton
    Left = 238
    Top = 151
    Width = 75
    Height = 21
    Caption = 'Move Left'
    TabOrder = 9
    OnClick = btnActiveLeftMoveLeftClick
  end
  object btnActiveLeftMoveRight: TButton
    Left = 356
    Top = 151
    Width = 75
    Height = 21
    Caption = 'Move Right'
    TabOrder = 10
    OnClick = btnActiveLeftMoveRightClick
  end
  object Button1: TButton
    Left = 360
    Top = 355
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 11
    OnClick = Button1Click
  end
end
