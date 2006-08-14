object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'CPU Monitor Module Settings'
  ClientHeight = 374
  ClientWidth = 191
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Width:'
  end
  object lb_barsize: TLabel
    Left = 48
    Top = 8
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
    Top = 144
    Width = 65
    Height = 13
    Caption = 'Display Type:'
  end
  object Label2: TLabel
    Left = 8
    Top = 240
    Width = 34
    Height = 13
    Caption = 'Colors:'
  end
  object Label3: TLabel
    Left = 56
    Top = 264
    Width = 56
    Height = 13
    Caption = 'Background'
  end
  object Label5: TLabel
    Left = 56
    Top = 288
    Width = 56
    Height = 13
    Caption = 'Foreground'
  end
  object Label6: TLabel
    Left = 56
    Top = 312
    Width = 32
    Height = 13
    Caption = 'Border'
  end
  object Label7: TLabel
    Left = 8
    Top = 48
    Width = 80
    Height = 13
    Caption = 'Update Interval:'
  end
  object lb_update: TLabel
    Left = 96
    Top = 48
    Width = 41
    Height = 14
    AutoSize = False
    Caption = '250ms'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 8
    Top = 88
    Width = 64
    Height = 13
    AutoSize = False
    Caption = 'CPU Number:'
  end
  object Button1: TButton
    Left = 32
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 344
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
    Max = 200
    Min = 25
    ShowArrows = False
    ShowHandleGrip = True
    Style = rbsMac
    Position = 100
    OnChange = tb_sizeChange
  end
  object rb_bar: TRadioButton
    Left = 16
    Top = 160
    Width = 169
    Height = 17
    Caption = 'History Graph (Bar)'
    Checked = True
    TabOrder = 3
    TabStop = True
  end
  object rb_line: TRadioButton
    Left = 16
    Top = 184
    Width = 161
    Height = 17
    Caption = 'History Graph (Line)'
    TabOrder = 4
  end
  object rb_cu: TRadioButton
    Left = 16
    Top = 208
    Width = 161
    Height = 17
    Caption = 'Current Usage (Progress Bar)'
    TabOrder = 5
  end
  object scb_bg: TSharpEColorBox
    Left = 16
    Top = 264
    Width = 35
    Height = 15
    BackgroundColor = clBtnFace
    Color = clWhite
    ColorCode = 16777215
    CustomScheme = False
    ClickedColorID = ccCustom
  end
  object scb_fg: TSharpEColorBox
    Left = 16
    Top = 288
    Width = 35
    Height = 15
    BackgroundColor = clBtnFace
    Color = clWhite
    ColorCode = 16777215
    CustomScheme = False
    ClickedColorID = ccCustom
  end
  object scb_border: TSharpEColorBox
    Left = 16
    Top = 312
    Width = 35
    Height = 15
    BackgroundColor = clBtnFace
    Color = clWhite
    ColorCode = 16777215
    CustomScheme = False
    ClickedColorID = ccCustom
  end
  object tb_update: TGaugeBar
    Left = 8
    Top = 64
    Width = 177
    Height = 13
    Color = clWindow
    Backgnd = bgSolid
    BorderStyle = bsNone
    HandleColor = clBtnFace
    BorderColor = clBtnShadow
    Max = 1000
    Min = 100
    ShowArrows = False
    ShowHandleGrip = True
    Style = rbsMac
    SmallChange = 5
    Position = 500
    OnChange = tb_updateChange
  end
  object edit_cpu: TJvSpinEdit
    Left = 8
    Top = 104
    Width = 57
    Height = 21
    CheckMinValue = True
    CheckMaxValue = True
    EditorEnabled = False
    TabOrder = 10
  end
  object XPManifest1: TXPManifest
    Left = 152
    Top = 40
  end
end
