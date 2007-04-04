object MainWnd: TMainWnd
  Left = 0
  Top = 0
  Width = 500
  Height = 342
  BorderWidth = 8
  Caption = 'MainWnd'
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SharpEColorPanel1: TSharpEColorPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 24
    Align = alTop
    BackgroundColor = clBlack
    Expanded = False
    GroupIndex = 1
    CollapseHeight = 24
    ExpandedHeight = 135
    Caption = 'Throbber Back'
    ColorCode = 0
    ColorAsTColor = clBlack
    DesignSize = (
      468
      24)
  end
  object SharpEColorPanel2: TSharpEColorPanel
    Left = 0
    Top = 24
    Width = 468
    Height = 135
    Align = alTop
    BackgroundColor = clBlack
    Expanded = True
    GroupIndex = 1
    CollapseHeight = 24
    ExpandedHeight = 135
    Caption = 'WorkArea Back'
    ColorCode = 65280
    ColorAsTColor = clLime
    DesignSize = (
      468
      135)
  end
  object XPManifest1: TXPManifest
    Left = 8
    Top = 248
  end
end
