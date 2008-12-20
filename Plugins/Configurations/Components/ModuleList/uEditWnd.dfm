object frmEditWnd: TfrmEditWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEditWnd'
  ClientHeight = 120
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
    Caption = 'Select the module to add'
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
      Width = 38
      Height = 13
      Caption = 'Module:'
      Transparent = True
    end
    object JvLabel1: TLabel
      Left = 331
      Top = 12
      Width = 41
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Position:'
      Transparent = True
    end
    object cboModules: TComboBox
      Left = 64
      Top = 9
      Width = 253
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      ItemHeight = 0
      Sorted = True
      TabOrder = 0
      OnClick = cboModulesClick
      OnSelect = cboModulesSelect
    end
    object cboPosition: TComboBox
      Left = 392
      Top = 9
      Width = 97
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'Left'
      OnChange = cboPositionChange
      OnSelect = cboModulesSelect
      Items.Strings = (
        'Left'
        'Right')
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
