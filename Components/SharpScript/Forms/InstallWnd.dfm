object InstallForm: TInstallForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  BorderWidth = 5
  Caption = 'Install SharpE Package'
  ClientHeight = 259
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    377
    259)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 105
    Width = 377
    Height = 13
    Align = alTop
    Caption = 'Changelog:'
  end
  object m_rnotes: TMemo
    Left = 0
    Top = 0
    Width = 377
    Height = 89
    Align = alTop
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 89
    Width = 377
    Height = 16
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object m_changelog: TMemo
    Left = 0
    Top = 126
    Width = 377
    Height = 89
    Align = alTop
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Panel2: TPanel
    Left = 0
    Top = 118
    Width = 377
    Height = 8
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Button1: TButton
    Left = 298
    Top = 230
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 214
    Top = 230
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Install'
    TabOrder = 5
    OnClick = Button2Click
  end
  object XPManifest1: TXPManifest
    Left = 64
    Top = 16
  end
end
