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
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 233
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 443
      Height = 159
      ExplicitHeight = 233
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 433
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object sgbWidth: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 250
          Height = 23
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          Color = clWindow
          Constraints.MaxWidth = 300
          ParentBackground = False
          Min = 16
          Max = 200
          Value = 100
          Prefix = 'Width: '
          Suffix = ' px'
          Description = 'Adjust button size'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = GaugeBoxChange
          BackgroundColor = clWindow
          ExplicitHeight = 21
        end
      end
      object SharpECenterHeader4: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 433
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Button Size'
        Description = 'Define the width for all buttons globally'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object SharpECenterHeader6: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 80
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
        ExplicitTop = 78
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 127
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
        TabOrder = 3
        ExplicitTop = 172
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
          Width = 436
          Height = 21
          Margins.Left = 2
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Caption = 'Enable button captions'
          TabOrder = 1
          TabStop = False
          Align = alLeft
          OnClick = CheckClick
          ExplicitLeft = 158
          ExplicitTop = 12
          ExplicitHeight = 17
        end
      end
    end
  end
end
