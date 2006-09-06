object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = ' VWM Module Settings'
  ClientHeight = 168
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 47
    Height = 13
    Caption = 'Hot Keys:'
    Transparent = True
  end
  object Label2: TLabel
    Left = 32
    Top = 34
    Width = 83
    Height = 13
    Caption = 'Toggle Desktop 1'
    Transparent = True
  end
  object Label3: TLabel
    Left = 32
    Top = 58
    Width = 83
    Height = 13
    Caption = 'Toggle Desktop 2'
    Transparent = True
  end
  object Label4: TLabel
    Left = 32
    Top = 80
    Width = 82
    Height = 13
    Caption = 'Toggle Desktop 3'
    Transparent = True
  end
  object Label5: TLabel
    Left = 32
    Top = 106
    Width = 83
    Height = 13
    Caption = 'Toggle Desktop 4'
    Transparent = True
  end
  object Button1: TButton
    Left = 96
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 120
    Top = 32
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 2
    Text = 'Win+Left'
  end
  object Edit2: TEdit
    Left = 120
    Top = 56
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 3
    Text = 'Win+Up'
  end
  object Edit3: TEdit
    Left = 120
    Top = 80
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = 'Win+Down'
  end
  object Edit4: TEdit
    Left = 120
    Top = 104
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 5
    Text = 'Win+Right'
  end
  object XPManifest1: TXPManifest
    Left = 48
    Top = 128
  end
end
