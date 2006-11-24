object frmSettingsWnd: TfrmSettingsWnd
  Left = 501
  Top = 245
  BorderStyle = bsNone
  Caption = 'frmSettingsWnd'
  ClientHeight = 400
  ClientWidth = 380
  Color = clWindow
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Label3: TLabel
    Left = 72
    Top = 528
    Width = 95
    Height = 14
    Caption = 'Memory Settings'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object schemelist: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 380
    Height = 400
    Style = lbOwnerDrawFixed
    Align = alClient
    BorderStyle = bsNone
    ItemHeight = 22
    TabOrder = 0
    OnDrawItem = schemelistDrawItem
  end
  object schemeimages: TPngImageList
    Height = 20
    Masked = False
    Width = 151
    PngImages = <>
    Left = 224
    Top = 128
  end
end
