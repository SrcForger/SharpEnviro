object frmMM: TfrmMM
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmMM'
  ClientHeight = 505
  ClientWidth = 405
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
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
    Width = 405
    Height = 505
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 492
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 405
      Height = 505
      ExplicitHeight = 492
      object pnlSize: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 319
        Width = 399
        Height = 70
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        object sgbBarSize: TSharpeGaugeBox
          Left = 20
          Top = 45
          Width = 137
          Height = 20
          Margins.Left = 20
          Color = clWindow
          ParentBackground = False
          Min = 25
          Max = 200
          Value = 50
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Adjust Bar Width'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbBarSizeChangeValue
          BackgroundColor = clWindow
        end
        object schSize: TSharpECenterHeader
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 393
          Height = 35
          Title = 'Status Bar Size'
          Description = 'Set the width of the bar when displayed.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = -9
        end
      end
      object pnlFormat: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 395
        Width = 399
        Height = 96
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        ExplicitTop = 329
        object rbPTaken: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 49
          Width = 369
          Height = 17
          Margins.Left = 20
          Margins.Top = 8
          Margins.Right = 10
          Margins.Bottom = 8
          Align = alTop
          Caption = 'Percent Taken (example: 61%)'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = RadioButtonClick
          ExplicitTop = 45
        end
        object rbFreeMB: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 74
          Width = 369
          Height = 17
          Margins.Left = 20
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 8
          Align = alTop
          Caption = 'Free MB (example: 210 MB Free)'
          TabOrder = 1
          OnClick = RadioButtonClick
          ExplicitLeft = 24
          ExplicitTop = 33
          ExplicitWidth = 373
        end
        object schFormat: TSharpECenterHeader
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 393
          Height = 35
          Title = 'Value Text Format'
          Description = 'Change the format of how the text value is displayed.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 9
        end
      end
      object pnlAlignment: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 399
        Height = 70
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object rbHoriz: TRadioButton
          Left = 17
          Top = 48
          Width = 77
          Height = 17
          Margins.Left = 24
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Caption = 'Horizontal'
          TabOrder = 0
          OnClick = RadioButtonClick
        end
        object rbVert: TRadioButton
          Left = 279
          Top = 48
          Width = 105
          Height = 17
          Margins.Left = 24
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Caption = 'Vertical (2 rows)'
          TabOrder = 2
          OnClick = RadioButtonClick
        end
        object rbHoriz2: TRadioButton
          Left = 126
          Top = 48
          Width = 121
          Height = 17
          Margins.Left = 24
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Caption = 'Horizontal (Compact)'
          Checked = True
          TabOrder = 1
          TabStop = True
          OnClick = RadioButtonClick
        end
        object schAlignment: TSharpECenterHeader
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 393
          Height = 35
          Title = 'Alignment'
          Description = 
            'Change how you want the memory and swap file information to be a' +
            'ligned.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 27
        end
      end
      object pnlRam: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 79
        Width = 399
        Height = 114
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 1
        object schRam: TSharpECenterHeader
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 393
          Height = 35
          Title = 'Physical Memory'
          Description = 'Select how to display information about the physical memory.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitLeft = -60
          ExplicitTop = -10
          ExplicitWidth = 177
        end
        object cbRamBar: TJvXPCheckbox
          AlignWithMargins = True
          Left = 20
          Top = 44
          Width = 369
          Height = 17
          Margins.Left = 20
          Margins.Right = 10
          Caption = 'Status Bar'
          TabOrder = 0
          Checked = True
          ParentColor = False
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitLeft = 21
          ExplicitTop = 45
          ExplicitWidth = 367
        end
        object cbRamInfo: TJvXPCheckbox
          AlignWithMargins = True
          Left = 20
          Top = 90
          Width = 369
          Height = 17
          Margins.Left = 20
          Margins.Right = 10
          Caption = 'Information Label'
          TabOrder = 2
          Checked = True
          ParentColor = False
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitLeft = 21
          ExplicitTop = 24
          ExplicitWidth = 367
        end
        object cbRamPC: TJvXPCheckbox
          AlignWithMargins = True
          Left = 20
          Top = 67
          Width = 369
          Height = 17
          Margins.Left = 20
          Margins.Right = 10
          Caption = 'Value as Text'
          TabOrder = 1
          Checked = True
          ParentColor = False
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitLeft = 21
          ExplicitTop = 24
          ExplicitWidth = 367
        end
      end
      object pnlSwap: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 199
        Width = 399
        Height = 114
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 2
        object schSwap: TSharpECenterHeader
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 393
          Height = 35
          Title = 'Swap File'
          Description = 'Select how to display information about the swap file.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitTop = 246
          ExplicitWidth = 399
        end
        object cbSwpBar: TJvXPCheckbox
          AlignWithMargins = True
          Left = 20
          Top = 44
          Width = 369
          Height = 17
          Margins.Left = 20
          Margins.Right = 10
          Caption = 'Status Bar'
          TabOrder = 0
          Checked = True
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitTop = 45
          ExplicitWidth = 367
        end
        object cbSwpPC: TJvXPCheckbox
          AlignWithMargins = True
          Left = 20
          Top = 67
          Width = 369
          Height = 17
          Margins.Left = 20
          Margins.Right = 10
          Caption = 'Value as Text'
          TabOrder = 1
          Checked = True
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitLeft = 21
          ExplicitTop = 68
          ExplicitWidth = 367
        end
        object cbSwpInfo: TJvXPCheckbox
          AlignWithMargins = True
          Left = 20
          Top = 90
          Width = 369
          Height = 17
          Margins.Left = 20
          Margins.Right = 10
          Caption = 'Information Label'
          TabOrder = 2
          Checked = True
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitLeft = 21
          ExplicitTop = 24
          ExplicitWidth = 367
        end
      end
    end
  end
end
