object EditSchemeForm: TEditSchemeForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Edit Color Scheme'
  ClientHeight = 304
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ColorPanel: TPanel
    Left = 0
    Top = 49
    Width = 274
    Height = 214
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 263
    Width = 274
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      274
      41)
    object btn_ok: TButton
      Left = 108
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 0
      OnClick = btn_okClick
    end
    object btn_cancel: TButton
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btn_cancelClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 274
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 70
      Height = 13
      Caption = 'Scheme Name '
    end
    object edit_name: TEdit
      Left = 8
      Top = 24
      Width = 249
      Height = 21
      TabOrder = 0
      Text = 'My Scheme'
    end
  end
end
