object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Memory Monitor Settings'
  ClientHeight = 197
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 135
    Height = 13
    Caption = 'Physical Memory (RAM)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 52
    Height = 13
    Caption = 'Swap File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 168
    Top = 8
    Width = 58
    Height = 13
    Caption = 'Alignment'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 160
    Top = 88
    Width = 42
    Height = 13
    Caption = 'Bar Size:'
  end
  object lb_barsize: TLabel
    Left = 208
    Top = 88
    Width = 18
    Height = 14
    AutoSize = False
    Caption = '100'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 152
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 232
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cb_rambar: TCheckBox
    Left = 16
    Top = 24
    Width = 97
    Height = 17
    Caption = 'Status Bar'
    TabOrder = 2
  end
  object cb_raminfo: TCheckBox
    Left = 16
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Information Text'
    TabOrder = 3
  end
  object cb_swpbar: TCheckBox
    Left = 16
    Top = 104
    Width = 97
    Height = 17
    Caption = 'Status Bar'
    TabOrder = 4
  end
  object cb_swpinfo: TCheckBox
    Left = 16
    Top = 136
    Width = 97
    Height = 17
    Caption = 'Information Text'
    TabOrder = 5
  end
  object cb_swppc: TCheckBox
    Left = 16
    Top = 120
    Width = 97
    Height = 17
    Caption = 'Percent Value'
    TabOrder = 6
  end
  object cb_rampc: TCheckBox
    Left = 16
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Percent Value'
    TabOrder = 7
  end
  object rb_halign: TRadioButton
    Left = 176
    Top = 24
    Width = 113
    Height = 17
    Caption = 'Horizontal'
    TabOrder = 8
  end
  object rb_valign: TRadioButton
    Left = 176
    Top = 40
    Width = 105
    Height = 17
    Caption = 'Vertical (2 rows)'
    TabOrder = 9
  end
  object tb_size: TGaugeBar
    Left = 160
    Top = 104
    Width = 145
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
    Position = 25
    OnChange = tb_sizeChange
  end
end
