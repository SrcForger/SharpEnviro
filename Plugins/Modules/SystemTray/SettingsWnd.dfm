object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'SystemTray Module Settings'
  ClientHeight = 259
  ClientWidth = 216
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
  object Label4: TLabel
    Left = 28
    Top = 32
    Width = 41
    Height = 13
    Caption = 'Visibility:'
  end
  object lb_dbg: TLabel
    Left = 72
    Top = 32
    Width = 33
    Height = 14
    AutoSize = False
    Caption = '100%'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 28
    Top = 104
    Width = 41
    Height = 13
    Caption = 'Visibility:'
  end
  object lb_dbd: TLabel
    Left = 72
    Top = 104
    Width = 33
    Height = 14
    AutoSize = False
    Caption = '100%'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 28
    Top = 176
    Width = 30
    Height = 13
    Caption = 'Value:'
  end
  object lb_blend: TLabel
    Left = 72
    Top = 176
    Width = 33
    Height = 14
    AutoSize = False
    Caption = '100%'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cb_dbg: TCheckBox
    Left = 8
    Top = 8
    Width = 113
    Height = 17
    Hint = 'cb_dbg'
    Caption = 'Display Background'
    TabOrder = 0
    OnClick = cb_dbgClick
  end
  object cb_dbd: TCheckBox
    Left = 8
    Top = 80
    Width = 89
    Height = 17
    Hint = 'cb_db'
    Caption = 'Display Border'
    TabOrder = 1
    OnClick = cb_dbdClick
  end
  object Button1: TButton
    Left = 56
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
  object scb_dbg: TSharpEColorBox
    Left = 128
    Top = 8
    Width = 35
    Height = 15
    BackgroundColor = clBtnFace
    Color = clWhite
    ColorCode = 16777215
    CustomScheme = False
    ClickedColorID = ccCustom
  end
  object scb_dbd: TSharpEColorBox
    Left = 128
    Top = 80
    Width = 35
    Height = 15
    BackgroundColor = clBtnFace
    Color = clWhite
    ColorCode = 16777215
    CustomScheme = False
    ClickedColorID = ccCustom
  end
  object tb_dbg: TGaugeBar
    Left = 28
    Top = 48
    Width = 177
    Height = 13
    Color = clWindow
    Backgnd = bgSolid
    BorderStyle = bsNone
    HandleColor = clBtnFace
    BorderColor = clBtnShadow
    Max = 255
    ShowArrows = False
    ShowHandleGrip = True
    Style = rbsMac
    Position = 255
    OnChange = tb_dbgChange
  end
  object tb_dbd: TGaugeBar
    Left = 28
    Top = 120
    Width = 177
    Height = 13
    Color = clWindow
    Backgnd = bgSolid
    BorderStyle = bsNone
    HandleColor = clBtnFace
    BorderColor = clBtnShadow
    Max = 255
    ShowArrows = False
    ShowHandleGrip = True
    Style = rbsMac
    Position = 255
    OnChange = tb_dbdChange
  end
  object cb_blend: TCheckBox
    Left = 8
    Top = 152
    Width = 105
    Height = 17
    Hint = 'cb_db'
    Caption = 'Color Blend Icons'
    TabOrder = 8
    OnClick = cb_blendClick
  end
  object scb_blend: TSharpEColorBox
    Left = 128
    Top = 152
    Width = 35
    Height = 15
    BackgroundColor = clBtnFace
    Color = clWhite
    ColorCode = 16777215
    CustomScheme = False
    ClickedColorID = ccCustom
  end
  object tb_blend: TGaugeBar
    Left = 28
    Top = 192
    Width = 177
    Height = 13
    Color = clWindow
    Backgnd = bgSolid
    BorderStyle = bsNone
    HandleColor = clBtnFace
    BorderColor = clBtnShadow
    Max = 255
    ShowArrows = False
    ShowHandleGrip = True
    Style = rbsMac
    Position = 255
    OnChange = tb_blendChange
  end
end
