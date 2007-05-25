object VersChangeForm: TVersChangeForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Change Project Versions'
  ClientHeight = 248
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    344
    248)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Major Version'
  end
  object Label2: TLabel
    Left = 96
    Top = 8
    Width = 64
    Height = 13
    Caption = 'Minor Version'
  end
  object Label3: TLabel
    Left = 184
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Release'
  end
  object Label4: TLabel
    Left = 272
    Top = 8
    Width = 22
    Height = 13
    Caption = 'Build'
  end
  object Label5: TLabel
    Left = 8
    Top = 56
    Width = 254
    Height = 13
    Caption = 'The version of the following projects will be updated:'
  end
  object se_v1: TJvSpinEdit
    Left = 8
    Top = 24
    Width = 65
    Height = 21
    ButtonKind = bkStandard
    MaxValue = 10.000000000000000000
    TabOrder = 0
  end
  object se_v2: TJvSpinEdit
    Left = 96
    Top = 24
    Width = 65
    Height = 21
    ButtonKind = bkStandard
    MaxValue = 10.000000000000000000
    TabOrder = 1
  end
  object se_v3: TJvSpinEdit
    Left = 184
    Top = 24
    Width = 65
    Height = 21
    ButtonKind = bkStandard
    MaxValue = 10.000000000000000000
    TabOrder = 2
  end
  object se_v4: TJvSpinEdit
    Left = 272
    Top = 24
    Width = 65
    Height = 21
    ButtonKind = bkStandard
    MaxValue = 10.000000000000000000
    TabOrder = 3
  end
  object lb_plist: TListBox
    Left = 8
    Top = 72
    Width = 329
    Height = 137
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 4
  end
  object Button1: TButton
    Left = 264
    Top = 216
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 216
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    TabOrder = 6
    OnClick = Button2Click
  end
  object XPManifest1: TXPManifest
    Left = 16
    Top = 176
  end
end
