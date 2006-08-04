object TipForm: TTipForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'SystemTrayTipWnd'
  ClientHeight = 250
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FormShape: TShape
    Left = 0
    Top = 0
    Width = 434
    Height = 250
    Align = alClient
  end
  object InfoLabel: TLabel
    Left = 4
    Top = 2
    Width = 45
    Height = 13
    Caption = 'InfoLabel'
    Transparent = True
  end
end
