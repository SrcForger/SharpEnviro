object frmEdit: TfrmEdit
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 94
  ClientWidth = 499
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  DesignSize = (
    499
    94)
  PixelsPerInch = 96
  TextHeight = 14
  object JvLabel1: TJvLabel
    Left = 280
    Top = 12
    Width = 48
    Height = 14
    Caption = 'Template:'
    Anchors = [akTop, akRight]
    Transparent = True
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'Tahoma'
    HotTrackFont.Style = []
  end
  object edName: TLabeledEdit
    Left = 48
    Top = 8
    Width = 209
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 30
    EditLabel.Height = 14
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
    OnChange = editStateEvent
  end
  object cbBasedOn: TComboBox
    Left = 341
    Top = 8
    Width = 150
    Height = 22
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 14
    TabOrder = 1
    OnChange = editStateEvent
  end
  object chkOverride: TJvXPCheckbox
    Left = 11
    Top = 45
    Width = 273
    Height = 17
    Caption = 'Override menu options'
    TabOrder = 2
    OnClick = chkOverrideClick
  end
  object chkEnableIcons: TJvXPCheckbox
    Left = 11
    Top = 68
    Width = 101
    Height = 17
    Caption = 'Enable Icons'
    TabOrder = 3
    OnClick = UpdateEditState
  end
  object chkEnableGeneric: TJvXPCheckbox
    Left = 118
    Top = 68
    Width = 139
    Height = 17
    Caption = 'Enable generic Icons'
    TabOrder = 4
    OnClick = UpdateEditState
  end
  object chkDisplayExtensions: TJvXPCheckbox
    Left = 263
    Top = 68
    Width = 161
    Height = 17
    Caption = 'Display file extensions'
    TabOrder = 5
    OnClick = UpdateEditState
  end
end
