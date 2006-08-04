object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Button Module Settings'
  ClientHeight = 271
  ClientWidth = 192
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
    Top = 64
    Width = 58
    Height = 13
    Caption = 'Button Size:'
  end
  object lb_barsize: TLabel
    Left = 72
    Top = 64
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
    Top = 104
    Width = 54
    Height = 13
    Caption = 'Click Action'
  end
  object Label2: TLabel
    Left = 24
    Top = 136
    Width = 132
    Height = 11
    Caption = '(Action.service must be started)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
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
    Left = 32
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit_caption: TEdit
    Left = 24
    Top = 32
    Width = 161
    Height = 21
    TabOrder = 3
    Text = 'Edit_caption'
  end
  object tb_size: TGaugeBar
    Left = 8
    Top = 80
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
  object cb_sea: TRadioButton
    Left = 8
    Top = 120
    Width = 113
    Height = 17
    Caption = 'SharpE Action'
    Checked = True
    TabOrder = 5
    TabStop = True
    OnClick = cb_seaClick
  end
  object cb_ea: TRadioButton
    Left = 8
    Top = 184
    Width = 169
    Height = 17
    Caption = 'Execute Application/File'
    TabOrder = 6
    OnClick = cb_seaClick
  end
  object combo_actionlist: TComboBox
    Left = 24
    Top = 152
    Width = 161
    Height = 21
    AutoDropDown = True
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
  end
  object edit_app: TEdit
    Left = 24
    Top = 200
    Width = 137
    Height = 21
    TabOrder = 8
    Text = 'C:\'
  end
  object btn_open: TButton
    Left = 164
    Top = 200
    Width = 22
    Height = 22
    Caption = '...'
    TabOrder = 9
    OnClick = btn_openClick
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
