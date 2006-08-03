object TerminalWnd: TTerminalWnd
  Left = 0
  Top = 0
  Width = 306
  Height = 451
  Caption = 'SharpDesk Terminal Mode'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 228
    Height = 28
    Caption = 
      'Enabling the terminal mode will make it possible to limit most o' +
      'f SharpDesks functionality'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object cb_tmode: TCheckBox
    Left = 8
    Top = 48
    Width = 161
    Height = 17
    Caption = 'Enable Terminal Mode'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = cb_tmodeClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 72
    Width = 281
    Height = 297
    Caption = 'Enabled Features'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label2: TLabel
      Left = 24
      Top = 32
      Width = 239
      Height = 28
      Caption = 
        'When disabled the menu will only be accessible by using the Shar' +
        'pBar pstart plugin.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label3: TLabel
      Left = 24
      Top = 88
      Width = 227
      Height = 28
      Caption = 
        'When disabled it won'#39't be possible to change any desktop object ' +
        'setting.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 24
      Top = 200
      Width = 246
      Height = 28
      Caption = 
        'When disabled SharpDesk will load the Theme at startup. It won'#39't' +
        ' be possible to load another theme'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label5: TLabel
      Left = 24
      Top = 144
      Width = 233
      Height = 28
      Caption = 
        'Disabling this option will make it impossible to move any deskto' +
        'p object.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label6: TLabel
      Left = 24
      Top = 256
      Width = 224
      Height = 28
      Caption = 
        'Disabling this option will make SharpDesk to ignore any close/ex' +
        'it commands.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object cb_smenu: TCheckBox
      Left = 8
      Top = 16
      Width = 185
      Height = 17
      Caption = 'SharpMenu (right click on deskop)'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cb_omenu: TCheckBox
      Left = 8
      Top = 72
      Width = 185
      Height = 17
      Caption = 'ObjectMenu (right click on object)'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object cb_tload: TCheckBox
      Left = 8
      Top = 184
      Width = 185
      Height = 17
      Caption = 'Theme loading'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cb_omove: TCheckBox
      Left = 8
      Top = 128
      Width = 185
      Height = 17
      Caption = 'Object Movement'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object cb_edesk: TCheckBox
      Left = 8
      Top = 240
      Width = 185
      Height = 17
      Caption = 'Exit Desk'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object bottompanel: TPanel
    Left = 0
    Top = 382
    Width = 298
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      298
      40)
    object btn_Change: TButton
      Left = 125
      Top = 10
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btn_ChangeClick
    end
    object btn_Cancel: TButton
      Left = 213
      Top = 10
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btn_CancelClick
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 25
      Height = 25
      Caption = '?'
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 380
    Width = 298
    Height = 2
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 3
  end
end
