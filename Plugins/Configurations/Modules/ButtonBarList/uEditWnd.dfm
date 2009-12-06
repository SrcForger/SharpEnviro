object frmEdit: TfrmEdit
  Left = 683
  Top = 363
  BorderStyle = bsNone
  Caption = 'Hotkey Configuration'
  ClientHeight = 113
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
    113)
  PixelsPerInch = 96
  TextHeight = 14
  object btnCommandBrowse: TPngSpeedButton
    Left = 376
    Top = 76
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    OnClick = btnCommandBrowseClick
    ExplicitLeft = 390
  end
  object btnIconBrowse: TPngSpeedButton
    Left = 376
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    OnClick = btnIconBrowseClick
    ExplicitLeft = 390
  end
  object edName: TLabeledEdit
    Left = 56
    Top = 8
    Width = 395
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
    Top = 76
    Width = 275
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
    Left = 56
    Top = 36
    Width = 299
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
