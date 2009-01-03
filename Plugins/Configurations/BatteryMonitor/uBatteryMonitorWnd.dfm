object frmBMon: TfrmBMon
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmBMon'
  ClientHeight = 348
  ClientWidth = 660
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 660
    Height = 348
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 660
      Height = 348
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 650
        Height = 35
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Icon Visibility'
        Description = 'Would you like to display the power status Icon?'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        Color = clWindow
      end
      object cb_icon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 650
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Caption = 'Display the icon'
        TabOrder = 1
        Align = alTop
        OnClick = cb_iconClick
      end
    end
  end
end
