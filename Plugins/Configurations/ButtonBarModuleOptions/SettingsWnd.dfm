object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 233
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
    Height = 233
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    ExplicitWidth = 668
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 443
      Height = 233
      ExplicitWidth = 668
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 433
        Height = 21
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitWidth = 658
        object sgbWidth: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 250
          Height = 21
          Margins.Left = 8
          Margins.Top = 0
          Margins.Right = 12
          Margins.Bottom = 0
          Color = clWindow
          Constraints.MaxWidth = 300
          ParentBackground = False
          Min = 16
          Max = 200
          Value = 100
          Suffix = ' px'
          Description = 'Adjust button size'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = GaugeBoxChange
          BackgroundColor = clWindow
        end
      end
      object SharpECenterHeader3: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 148
        Width = 433
        Height = 35
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Button Icons'
        Description = 'Define whether icons should be displayed on buttons'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        ExplicitWidth = 658
      end
      object SharpECenterHeader4: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 433
        Height = 35
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Button Size'
        Description = 'Define the width for all buttons globally'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        ExplicitWidth = 658
      end
      object SharpECenterHeader6: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 76
        Width = 433
        Height = 35
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Button Captions'
        Description = 'Define whether captions should be displayed on buttons'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        ExplicitWidth = 658
      end
      object chkButtonCaption: TJvXPCheckbox
        AlignWithMargins = True
        Left = 2
        Top = 121
        Width = 436
        Height = 17
        Margins.Left = 2
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Caption = 'Enable button captions'
        TabOrder = 1
        TabStop = False
        Align = alTop
        OnClick = CheckClick
        ExplicitWidth = 661
      end
      object chkButtonIcon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 2
        Top = 193
        Width = 436
        Height = 17
        Margins.Left = 2
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Caption = 'Enable button icons'
        TabOrder = 5
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = CheckClick
        ExplicitWidth = 661
      end
    end
  end
end
