object frmEditScheme: TfrmEditScheme
  Left = 0
  Top = 0
  BorderStyle = bsNone
  BorderWidth = 4
  Caption = 'Create/Edit Color Scheme'
  ClientHeight = 164
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  DesignSize = (
    490
    164)
  PixelsPerInch = 96
  TextHeight = 14
  object edName: TLabeledEdit
    Left = 56
    Top = 8
    Width = 157
    Height = 21
    EditLabel.Width = 30
    EditLabel.Height = 14
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 0
  end
  object edAuthor: TLabeledEdit
    Left = 260
    Top = 8
    Width = 201
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 16
    EditLabel.Height = 14
    EditLabel.Caption = 'By:'
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 1
  end
  object SharpERoundPanel1: TSharpERoundPanel
    Left = 8
    Top = 40
    Width = 473
    Height = 113
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    BorderWidth = 6
    Caption = 'SharpERoundPanel1'
    Color = clWindow
    ParentBackground = False
    TabOrder = 2
    RoundValue = 10
    BorderColor = clWindow
    Border = False
    BackgroundColor = clBtnFace
    object sbAvailableColors: TScrollBox
      Left = 6
      Top = 6
      Width = 461
      Height = 101
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clWindow
      ParentColor = False
      TabOrder = 0
    end
  end
end
