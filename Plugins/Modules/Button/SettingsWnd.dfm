object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Button Module Settings'
  ClientHeight = 218
  ClientWidth = 242
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
  object Label4: TLabel
    Left = 8
    Top = 88
    Width = 58
    Height = 13
    Caption = 'Button Size:'
  end
  object lb_barsize: TLabel
    Left = 72
    Top = 88
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
  object Label1: TLabel
    Left = 8
    Top = 128
    Width = 54
    Height = 13
    Caption = 'Click Action'
  end
  object cb_labels: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Show Caption'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 80
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 160
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit_caption: TEdit
    Left = 24
    Top = 32
    Width = 201
    Height = 21
    TabOrder = 3
    Text = 'Edit_caption'
  end
  object tb_size: TGaugeBar
    Left = 8
    Top = 104
    Width = 217
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
  object edit_action: TEdit
    Left = 8
    Top = 144
    Width = 185
    Height = 21
    TabOrder = 5
    Text = 'C:\'
  end
  object btn_open: TButton
    Left = 204
    Top = 144
    Width = 22
    Height = 22
    Caption = '...'
    TabOrder = 6
    OnClick = btn_openClick
  end
  object cb_specialskin: TCheckBox
    Left = 8
    Top = 62
    Width = 185
    Height = 17
    Caption = 'Use Special Skins (if supported)'
    TabOrder = 7
  end
  object XPManifest1: TXPManifest
    Left = 144
    Top = 8
  end
end
