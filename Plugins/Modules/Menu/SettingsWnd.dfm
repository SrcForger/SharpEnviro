object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Menu Module Settings'
  ClientHeight = 290
  ClientWidth = 235
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
    Left = 8
    Top = 168
    Width = 58
    Height = 13
    Caption = 'Button Size:'
  end
  object lb_barsize: TLabel
    Left = 72
    Top = 168
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
    Top = 208
    Width = 26
    Height = 13
    Caption = 'Menu'
  end
  object lb_icon: TLabel
    Left = 48
    Top = 88
    Width = 40
    Height = 13
    Caption = 'Location'
  end
  object cb_labels: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Show Caption'
    TabOrder = 0
    OnClick = cb_labelsClick
  end
  object Button1: TButton
    Left = 72
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 152
    Top = 256
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
    Top = 184
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
  object cb_menulist: TComboBox
    Left = 8
    Top = 224
    Width = 217
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
  object cb_icon: TCheckBox
    Left = 8
    Top = 64
    Width = 97
    Height = 17
    Caption = 'Show Icon'
    TabOrder = 6
    OnClick = cb_iconClick
  end
  object img_icon: TImage32
    Left = 8
    Top = 90
    Width = 32
    Height = 32
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 7
  end
  object edit_icon: TEdit
    Left = 48
    Top = 104
    Width = 145
    Height = 21
    ReadOnly = True
    TabOrder = 8
  end
  object btn_selecticon: TButton
    Left = 200
    Top = 102
    Width = 25
    Height = 22
    Caption = '...'
    TabOrder = 9
    OnClick = btn_selecticonClick
  end
  object cb_specialskin: TCheckBox
    Left = 8
    Top = 136
    Width = 185
    Height = 17
    Caption = 'Use Special Skin (if supported)'
    TabOrder = 10
    OnClick = cb_iconClick
  end
end
