object frmEditWnd: TfrmEditWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Create/Edit Color Scheme'
  ClientHeight = 58
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlEdit: TPanel
    AlignWithMargins = True
    Left = 2
    Top = 5
    Width = 494
    Height = 24
    Margins.Left = 2
    Margins.Top = 5
    Margins.Right = 2
    Margins.Bottom = 5
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      494
      24)
    object pnlName: TPanel
      Left = 0
      Top = 0
      Width = 211
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 3
        Width = 40
        Height = 16
        Caption = 'Name:'
      end
      object edName: TEdit
        Left = 62
        Top = 0
        Width = 149
        Height = 24
        TabOrder = 0
      end
    end
    object pnlAuthor: TPanel
      Left = 248
      Top = 0
      Width = 207
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      object Label2: TLabel
        Left = 0
        Top = 3
        Width = 20
        Height = 16
        Caption = 'By:'
      end
      object edAuthor: TEdit
        Left = 42
        Top = 0
        Width = 165
        Height = 24
        TabOrder = 0
      end
    end
  end
end
