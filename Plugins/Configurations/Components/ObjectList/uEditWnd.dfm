object frmEditWnd: TfrmEditWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEditWnd'
  ClientHeight = 92
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbDescription: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 41
    Width = 481
    Height = 16
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = False
    Caption = 'Select the object to add'
    Transparent = True
    WordWrap = True
  end
  object lbAuthor: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 65
    Width = 481
    Height = 13
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 10
    Align = alTop
    Caption = '<no one>'
    Transparent = True
    Layout = tlCenter
    Visible = False
    ExplicitWidth = 49
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 497
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      497
      33)
    object Label3: TLabel
      Left = 8
      Top = 12
      Width = 36
      Height = 13
      Caption = 'Object:'
      Transparent = True
    end
    object cboObjects: TComboBox
      Left = 64
      Top = 9
      Width = 253
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
      OnClick = cboObjectsClick
      OnSelect = cboObjectsSelect
    end
  end
  object Preview: TImage32
    AlignWithMargins = True
    Left = 8
    Top = 88
    Width = 481
    Height = 30
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 1
  end
end
