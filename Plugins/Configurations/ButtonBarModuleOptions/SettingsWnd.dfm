object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 233
  ClientWidth = 668
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
    Width = 668
    Height = 233
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 668
      Height = 233
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 658
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
        Top = 152
        Width = 658
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Button Icons'
        Description = 'Define whether icons should be displayed on buttons'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object SharpECenterHeader4: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 658
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
        Top = 78
        Width = 658
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Button Captions'
        Description = 'Define whether captions should be displayed on buttons'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object chkButtonCaption: TJvXPCheckbox
        AlignWithMargins = True
        Left = 2
        Top = 125
        Width = 661
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
      end
      object chkButtonIcon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 2
        Top = 199
        Width = 661
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
      end
    end
  end
end
