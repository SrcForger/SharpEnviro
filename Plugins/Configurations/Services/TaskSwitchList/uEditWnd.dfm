object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Create/Edit Color Scheme'
  ClientHeight = 40
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  DesignSize = (
    482
    40)
  PixelsPerInch = 96
  TextHeight = 14
  object edName: TLabeledEdit
    Left = 60
    Top = 8
    Width = 153
    Height = 22
    EditLabel.Width = 30
    EditLabel.Height = 14
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
    OnKeyUp = edNameKeyUp
  end
  object edAction: TLabeledEdit
    Left = 280
    Top = 8
    Width = 173
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 34
    EditLabel.Height = 14
    EditLabel.Caption = 'Action:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 1
    OnKeyUp = edNameKeyUp
  end
end
