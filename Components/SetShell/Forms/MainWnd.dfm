object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'SharpE Shell Switcher'
  ClientHeight = 246
  ClientWidth = 252
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
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 252
    Height = 90
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    Caption = 'Panel1'
    TabOrder = 0
    object rg_shell: TRadioGroup
      Left = 8
      Top = 8
      Width = 236
      Height = 74
      Align = alClient
      Caption = 'New Default Shell'
      ItemIndex = 0
      Items.Strings = (
        'SharpE'
        'Explorer')
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 131
    Width = 252
    Height = 115
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 25
      Width = 236
      Height = 39
      Align = alTop
      Caption = 
        '(This is necessary to prevent the explorer shell from starting w' +
        'hen the explorer '#39'file manager'#39' is used.)'
      WordWrap = True
    end
    object btn_cancel: TButton
      Left = 171
      Top = 85
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = btn_cancelClick
    end
    object btn_ok: TButton
      Left = 86
      Top = 85
      Width = 75
      Height = 25
      Caption = 'Ok'
      TabOrder = 1
      OnClick = btn_okClick
    end
    object Panel4: TPanel
      Left = 8
      Top = 8
      Width = 236
      Height = 17
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object cb_seb: TCheckBox
        Left = 0
        Top = 0
        Width = 209
        Height = 17
        Caption = 'Seperate Explorer Process (Admin)'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 252
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 236
      Height = 26
      Align = alTop
      Caption = 
        'To change your default windows shell environment select the new ' +
        'shell and click '#39'Ok'#39'.'
      WordWrap = True
    end
  end
end
