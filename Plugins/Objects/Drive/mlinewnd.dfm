object mlineform: Tmlineform
  Left = 519
  Top = 264
  Width = 220
  Height = 157
  Caption = 'Multi Line Caption'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 212
    Height = 96
    Align = alClient
    Lines.Strings = (
      'Caption')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 96
    Width = 212
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      212
      32)
    object btn_ok: TButton
      Left = 38
      Top = 5
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btn_okClick
    end
    object btn_cancel: TButton
      Left = 126
      Top = 5
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btn_cancelClick
    end
  end
end
