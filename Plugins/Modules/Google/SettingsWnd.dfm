object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = ' Google Module Settings'
  ClientHeight = 87
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
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Edit Box Size:'
    Transparent = True
  end
  object lb_barsize: TLabel
    Left = 77
    Top = 8
    Width = 33
    Height = 14
    AutoSize = False
    Caption = '150px'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 32
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object tb_size: TGaugeBar
    Left = 8
    Top = 24
    Width = 177
    Height = 13
    Color = clWindow
    Backgnd = bgSolid
    BorderStyle = bsNone
    HandleColor = clBtnFace
    BorderColor = clBtnShadow
    Max = 250
    Min = 25
    ShowArrows = False
    ShowHandleGrip = True
    Style = rbsMac
    Position = 150
    OnChange = tb_sizeChange
  end
  object OpenFile: TOpenDialog
    FileName = '*.*'
    Filter = 'All Files|*.*|Applications (*.exe)|*.exe'
    Options = [ofHideReadOnly, ofEnableSizing, ofForceShowHidden]
    Title = 'Select Target File'
    Left = 136
    Top = 96
  end
  object XPManifest1: TXPManifest
    Left = 144
    Top = 8
  end
end
