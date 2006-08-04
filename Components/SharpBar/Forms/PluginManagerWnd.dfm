object PluginManagerForm: TPluginManagerForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Plugin Manager'
  ClientHeight = 251
  ClientWidth = 372
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
  object list_plugins: TListBox
    Left = 16
    Top = 16
    Width = 265
    Height = 161
    ItemHeight = 13
    TabOrder = 0
    OnClick = list_pluginsClick
  end
  object btn_delete: TButton
    Left = 288
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 1
    OnClick = btn_deleteClick
  end
  object btn_left: TButton
    Left = 288
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Move Left'
    TabOrder = 2
    OnClick = btn_leftClick
  end
  object btn_right: TButton
    Left = 288
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Move Right'
    TabOrder = 3
    OnClick = btn_rightClick
  end
  object btn_addplugin: TButton
    Left = 16
    Top = 184
    Width = 89
    Height = 25
    Caption = 'Add new Plugin'
    TabOrder = 4
    OnClick = btn_addpluginClick
  end
  object btn_close: TButton
    Left = 288
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 5
    OnClick = btn_closeClick
  end
end
