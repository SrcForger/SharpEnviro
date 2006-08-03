object DeskSettingsForm: TDeskSettingsForm
  Left = 384
  Top = 191
  BorderStyle = bsToolWindow
  Caption = 'SharpDesk Settings'
  ClientHeight = 347
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bottompanel: TPanel
    Left = 0
    Top = 307
    Width = 329
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      329
      40)
    object btn_Change: TButton
      Left = 156
      Top = 10
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btn_ChangeClick
    end
    object btn_Cancel: TButton
      Left = 244
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
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 305
    Width = 329
    Height = 2
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 176
    Width = 313
    Height = 121
    Caption = 'Advanced Options'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label10: TLabel
      Left = 32
      Top = 43
      Width = 257
      Height = 14
      AutoSize = False
      Caption = 'Object development debugging'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label2: TLabel
      Left = 32
      Top = 91
      Width = 265
      Height = 22
      AutoSize = False
      Caption = 
        'Check if all objects are displayed in the desktop area.         ' +
        '      '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object cb_acommand: TCheckBox
      Left = 8
      Top = 24
      Width = 169
      Height = 17
      Caption = 'Advanced Commands'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object cb_oposcheck: TCheckBox
      Left = 8
      Top = 72
      Width = 169
      Height = 17
      Caption = 'Object Positions Check'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 161
    Caption = ' Options'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label8: TLabel
      Left = 32
      Top = 48
      Width = 36
      Height = 14
      Caption = 'Grid X :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 104
      Top = 48
      Width = 37
      Height = 14
      Caption = 'Grid Y :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 32
      Top = 91
      Width = 185
      Height = 14
      AutoSize = False
      Caption = 'Enable object tooltips'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label3: TLabel
      Left = 32
      Top = 136
      Width = 249
      Height = 17
      AutoSize = False
      Caption = 'Enable single click action'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object cb_usegrid: TCheckBox
      Left = 8
      Top = 24
      Width = 169
      Height = 17
      Caption = 'Align objects to grid'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object edit_gridx: TEdit
      Left = 64
      Top = 46
      Width = 25
      Height = 19
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      Text = '20'
      OnChange = edit_gridxChange
    end
    object edit_gridy: TEdit
      Left = 136
      Top = 46
      Width = 25
      Height = 19
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      Text = '20'
      OnChange = edit_gridyChange
    end
    object cb_tooltips: TCheckBox
      Left = 8
      Top = 72
      Width = 169
      Height = 17
      Caption = 'Tooltips'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object cb_singleclick: TCheckBox
      Left = 8
      Top = 120
      Width = 169
      Height = 17
      Caption = ' Single Click'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
  end
end
