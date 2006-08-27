object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Media Controler Module Settings'
  ClientHeight = 281
  ClientWidth = 307
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
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 65
    Height = 13
    Caption = 'Media Player:'
  end
  object lb_foobarpath: TLabel
    Left = 32
    Top = 96
    Width = 118
    Height = 13
    Caption = 'Path to Foobar2000.exe'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = 'Visible Buttons:'
  end
  object Button1: TButton
    Left = 144
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cb_winamp: TRadioButton
    Left = 16
    Top = 192
    Width = 113
    Height = 17
    Caption = 'Winamp'
    TabOrder = 2
    OnClick = cb_winampClick
  end
  object cb_foobar: TRadioButton
    Left = 16
    Top = 72
    Width = 169
    Height = 17
    Caption = 'Foobar2000'
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = cb_foobarClick
  end
  object edit_foopath: TEdit
    Left = 32
    Top = 112
    Width = 233
    Height = 21
    TabOrder = 4
    Text = 'C:\Program Files\Foobar2000\Foobar2000.exe'
  end
  object btn_openfoo: TButton
    Left = 276
    Top = 112
    Width = 22
    Height = 22
    Caption = '...'
    TabOrder = 5
    OnClick = btn_openfooClick
  end
  object cb_mpc: TRadioButton
    Left = 16
    Top = 144
    Width = 169
    Height = 17
    Caption = 'Media Player Classic (MPC)'
    TabOrder = 6
    OnClick = cb_foobarClick
  end
  object cb_pselect: TCheckBox
    Left = 16
    Top = 24
    Width = 129
    Height = 17
    Caption = 'Quick Player Selection'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object cb_qcd: TRadioButton
    Left = 16
    Top = 168
    Width = 169
    Height = 17
    Caption = 'Quintessential Player (QCD)'
    TabOrder = 8
    OnClick = cb_foobarClick
  end
  object cb_wmp: TRadioButton
    Left = 16
    Top = 216
    Width = 169
    Height = 17
    Caption = 'Windows Media Player'
    TabOrder = 9
    OnClick = cb_winampClick
  end
  object OpenFile: TOpenDialog
    FileName = '*.*'
    Filter = 'Foobar2000  (Foobar2000.exe)|*.exe'
    Options = [ofHideReadOnly, ofEnableSizing, ofForceShowHidden]
    Title = 'Select location of Foobar2000.exe'
    Left = 200
    Top = 56
  end
  object XPManifest1: TXPManifest
    Left = 240
    Top = 8
  end
end
