object frmEdit: TfrmEdit
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 102
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    485
    102)
  PixelsPerInch = 96
  TextHeight = 14
  object btnCommandBrowse: TPngSpeedButton
    Left = 376
    Top = 67
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    OnClick = btnCommandBrowseClick
  end
  object btnIconBrowse: TPngSpeedButton
    Left = 376
    Top = 36
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    OnClick = btnIconBrowseClick
  end
  object edName: TLabeledEdit
    Left = 72
    Top = 8
    Width = 379
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
    Left = 72
    Top = 67
    Width = 283
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
  object edIcon: TLabeledEdit
    Left = 72
    Top = 36
    Width = 283
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 23
    EditLabel.Height = 14
    EditLabel.Caption = 'Icon:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 1
    OnChange = UpdateEditState
  end
end
