object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmConfig'
  ClientHeight = 442
  ClientWidth = 551
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object SharpECenterHeader1: TSharpECenterHeader
    AlignWithMargins = True
    Left = 5
    Top = 0
    Width = 541
    Height = 55
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Title = 'Settings'
    Description = 'Input text here'
    TitleColor = clWindowText
    DescriptionColor = clRed
    Align = alTop
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 65
    Width = 536
    Height = 17
    Margins.Left = 5
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 56
      Height = 17
      Caption = 'Template'
    end
  end
end
