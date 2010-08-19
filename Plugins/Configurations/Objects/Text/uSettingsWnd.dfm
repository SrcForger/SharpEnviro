object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 415
  ClientWidth = 445
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 437
    Height = 407
    ActivePage = pagText
    PropagateEnable = False
    object pagText: TJvStandardPage
      Left = 0
      Top = 0
      Width = 437
      Height = 407
      ExplicitWidth = 445
      ExplicitHeight = 628
      object pnlText: TPanel
        Left = 0
        Top = 0
        Width = 437
        Height = 47
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object SharpECenterHeader13: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 427
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Text'
          Description = 'Define the text to display on the desktop'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
      end
      object edText: TMemo
        Left = 5
        Top = 50
        Width = 427
        Height = 151
        Lines.Strings = (
          'edText')
        ScrollBars = ssBoth
        TabOrder = 1
        OnChange = edTextChange
      end
    end
  end
end
