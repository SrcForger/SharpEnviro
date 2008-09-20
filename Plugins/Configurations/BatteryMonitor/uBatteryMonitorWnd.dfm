object frmBMon: TfrmBMon
  Left = 0
  Top = 0
  Caption = 'frmBMon'
  ClientHeight = 319
  ClientWidth = 652
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
    Width = 652
    Height = 319
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 652
      Height = 319
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 642
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Icon Visibility'
        Description = 'Would you like to display the power status Icon?'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object cb_icon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 642
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
