object frmEditWnd: TfrmEditWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Create/Edit Color Scheme'
  ClientHeight = 36
  ClientWidth = 498
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
    498
    36)
  PixelsPerInch = 96
  TextHeight = 14
  object edAuthor: TLabeledEdit
    Left = 280
    Top = 8
    Width = 189
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 16
    EditLabel.Height = 14
    EditLabel.Caption = 'By:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
    OnChange = EditChange
  end
  object edName: TLabeledEdit
    Left = 50
    Top = 8
    Width = 179
    Height = 22
    EditLabel.Width = 30
    EditLabel.Height = 14
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 1
    OnChange = EditChange
  end
end
