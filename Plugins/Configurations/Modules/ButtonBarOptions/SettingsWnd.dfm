object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 159
  ClientWidth = 443
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 443
    Height = 159
    ActivePage = pagOptions
    PropagateEnable = False
    Align = alClient
    ParentBackground = True
    object pagOptions: TJvStandardPage
      Left = 0
      Top = 0
      Width = 443
      Height = 159
      object schIconAndCaption: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 10
        Width = 433
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Button Icon and Caption'
        Description = 'Define whether to display an icon or button caption'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object pnlShowIconsAndCaptions: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 57
        Width = 433
        Height = 21
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 0
        object chkButtonIcon: TJvXPCheckbox
          Left = 0
          Top = 0
          Width = 149
          Height = 21
          Margins.Left = 2
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Caption = 'Enable button icons'
          TabOrder = 0
          Checked = True
          State = cbChecked
          Align = alLeft
          OnClick = CheckClick
        end
        object chkButtonCaption: TJvXPCheckbox
          Left = 149
          Top = 0
          Width = 149
          Height = 21
          Margins.Left = 2
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Caption = 'Enable button captions'
          TabOrder = 1
          Align = alLeft
          OnClick = CheckClick
        end
      end
    end
  end
end
