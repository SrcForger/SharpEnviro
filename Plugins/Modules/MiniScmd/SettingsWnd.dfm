object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'MiniScmd Module Settings'
  ClientHeight = 103
  ClientWidth = 192
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
    Top = 32
    Width = 94
    Height = 13
    Caption = 'Command Box Size:'
  end
  object lb_barsize: TLabel
    Left = 104
    Top = 32
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
  object Button1: TButton
    Left = 32
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object tb_size: TGaugeBar
    Left = 8
    Top = 48
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
  object cb_selectbutton: TCheckBox
    Left = 8
    Top = 8
    Width = 153
    Height = 17
    Caption = 'Show Quick Select Button'
    TabOrder = 3
  end
end
