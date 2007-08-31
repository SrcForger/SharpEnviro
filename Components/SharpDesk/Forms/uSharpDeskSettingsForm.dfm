object SettingsForm: TSettingsForm
  Left = 326
  Top = 260
  BorderStyle = bsToolWindow
  Caption = 'Object Settings'
  ClientHeight = 268
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object SettingsPanel: TPanel
    Left = 2
    Top = 2
    Width = 449
    Height = 113
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 229
    Width = 457
    Height = 2
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
  end
  object bottompanel: TPanel
    Left = 0
    Top = 231
    Width = 457
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      457
      37)
    object btn_ok: TButton
      Left = 206
      Top = 9
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btn_okClick
    end
    object btn_cancel: TButton
      Left = 291
      Top = 9
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btn_cancelClick
    end
    object btn_apply: TButton
      Left = 376
      Top = 9
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Apply'
      TabOrder = 2
      OnClick = btn_applyClick
    end
  end
end
