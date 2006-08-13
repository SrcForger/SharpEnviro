object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Volume Control  Module Settings'
  ClientHeight = 193
  ClientWidth = 194
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 62
    Height = 13
    Caption = 'Select Mixer:'
  end
  object Label4: TLabel
    Left = 8
    Top = 56
    Width = 78
    Height = 13
    Caption = 'Volume Bar size:'
  end
  object lb_barsize: TLabel
    Left = 96
    Top = 56
    Width = 33
    Height = 14
    AutoSize = False
    Caption = '100px'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 96
    Width = 177
    Height = 57
    AutoSize = False
    Caption = 
      'Note: some mixers won'#39't work and for some there might be doubled' +
      ' entries in the list. Just try and test them to find the one you' +
      ' need.'
    WordWrap = True
  end
  object Button1: TButton
    Left = 32
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cb_mlist: TComboBox
    Left = 8
    Top = 24
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object tb_size: TGaugeBar
    Left = 8
    Top = 72
    Width = 177
    Height = 13
    Color = clWindow
    Backgnd = bgSolid
    BorderStyle = bsNone
    HandleColor = clBtnFace
    BorderColor = clBtnShadow
    Max = 200
    Min = 25
    ShowArrows = False
    ShowHandleGrip = True
    Style = rbsMac
    Position = 100
    OnChange = tb_sizeChange
  end
  object XPManifest1: TXPManifest
    Left = 168
    Top = 88
  end
end
