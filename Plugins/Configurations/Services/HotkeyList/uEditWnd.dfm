object frmEditWnd: TfrmEditWnd
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 73
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  DesignSize = (
    490
    73)
  PixelsPerInch = 96
  TextHeight = 14
  object Button1: TPngSpeedButton
    Left = 391
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    OnClick = cmdbrowseclick
  end
  object Label1: TLabel
    Left = 255
    Top = 15
    Width = 36
    Height = 14
    Anchors = [akTop, akRight]
    Caption = 'Hotkey:'
  end
  object edName: TLabeledEdit
    Left = 56
    Top = 12
    Width = 182
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 30
    EditLabel.Height = 14
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
    OnChange = UpdateEditState
  end
  object edCommand: TLabeledEdit
    Left = 80
    Top = 40
    Width = 289
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 50
    EditLabel.Height = 14
    EditLabel.Caption = 'Command:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 2
    OnChange = UpdateEditState
  end
  object edHotkey: TSharpEHotkeyEdit
    Left = 301
    Top = 12
    Width = 161
    Height = 21
    Modifier = []
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Color = clBtnFace
    OnKeyUp = edHotkeyKeyUp
    Anchors = [akTop, akRight]
    TabOrder = 1
  end
end
