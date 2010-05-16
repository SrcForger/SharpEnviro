object frmEditWnd: TfrmEditWnd
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 110
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 63
    Height = 14
    Caption = 'New Action: '
  end
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 50
    Height = 14
    Caption = 'Command:'
  end
  object Label3: TLabel
    Left = 8
    Top = 67
    Width = 42
    Height = 14
    Caption = 'Execute:'
  end
  object coboAction: TComboBox
    Left = 85
    Top = 36
    Width = 202
    Height = 22
    Style = csDropDownList
    DropDownCount = 16
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 1
    Text = 'Broadcast as Media Message'
    OnChange = coboActionChange
    Items.Strings = (
      'Broadcast as Media Message'
      'Execute Custom Command'
      'Speaker Volume Up'
      'Speaker Volume Down'
      'Mute Speaker'
      'Microphone Volume Up'
      'Microphone Volume Down'
      'Mute Microphone'
      'Execute Default Browser'
      'Execute Default Mail Application')
  end
  object coboCommand: TComboBox
    Left = 85
    Top = 8
    Width = 202
    Height = 22
    Style = csDropDownList
    DropDownCount = 20
    ItemHeight = 14
    TabOrder = 0
    OnChange = coboCommandChange
  end
  object edExecute: TEdit
    Left = 84
    Top = 64
    Width = 203
    Height = 22
    TabOrder = 2
    OnChange = edExecuteChange
  end
  object cbDisableWMC: TCheckBox
    Left = 84
    Top = 91
    Width = 341
    Height = 17
    Caption = 'Disable if Windows Media Center is running'
    TabOrder = 4
    OnClick = cbDisableWMCClick
  end
  object btnBrowse: TButton
    Left = 293
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 3
    OnClick = cmdbrowseclick
  end
end
