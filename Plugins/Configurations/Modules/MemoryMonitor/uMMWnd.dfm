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
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 405
      Height = 505
      object pnlSize: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 314
        Width = 395
        Height = 77
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        object sgbBarSize: TSharpeGaugeBox
          Left = 5
          Top = 57
          Width = 250
          Height = 20
          Margins.Left = 5
          Margins.Right = 5
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
          Left = 5
          Top = 10
          Width = 385
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Status Bar Size'
          Description = 'Set the width of the bar when displayed.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitLeft = 3
          ExplicitTop = 3
          ExplicitWidth = 393
        end
      end
      object pnlFormat: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 401
        Width = 395
        Height = 67
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        object schFormat: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 385
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Value Text Format'
          Description = 'Change the format of how the text value is displayed.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitLeft = 3
          ExplicitTop = 3
          ExplicitWidth = 393
        end
        object cboTextFormat: TComboBox
          Left = 5
          Top = 46
          Width = 250
          Height = 21
          Margins.Left = 5
          Margins.Right = 5
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 1
          Text = 'Free MB (example: 210MB Free)'
          OnChange = cboChange
          Items.Strings = (
            'Percent Taken (example: 61%)'
            'Free MB (example: 210MB Free)')
        end
      end
      object pnlAlignment: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 399
        Height = 66
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object schAlignment: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 389
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Alignment'
          Description = 
            'Change how you want the memory and swap file information to be a' +
            'ligned.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitLeft = 3
          ExplicitTop = 3
          ExplicitWidth = 393
        end
        object cboAlignment: TComboBox
          Left = 5
          Top = 45
          Width = 250
          Height = 21
          Margins.Left = 5
          Margins.Right = 5
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          Text = 'Horizontal'
          OnChange = cboChange
          Items.Strings = (
            'Horizontal'
            'Horizontal (Compact)'
            'Vertical (2 rows)')
        end
      end
      object pnlRam: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 82
        Width = 395
        Height = 108
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 1
        object schRam: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 385
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Physical Memory'
          Description = 'Select how to display information about the physical memory.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitLeft = 3
          ExplicitTop = 3
          ExplicitWidth = 393
        end
        object cbRamBar: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 47
          Width = 385
          Height = 17
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Status Bar'
          TabOrder = 0
          Checked = True
          ParentColor = False
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitTop = 46
          ExplicitWidth = 384
        end
        object cbRamInfo: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 91
          Width = 385
          Height = 17
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Information Label'
          TabOrder = 2
          Checked = True
          ParentColor = False
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitTop = 92
          ExplicitWidth = 384
        end
        object cbRamPC: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 69
          Width = 385
          Height = 17
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Value as Text'
          TabOrder = 1
          Checked = True
          ParentColor = False
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitWidth = 384
        end
      end
      object pnlSwap: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 200
        Width = 395
        Height = 114
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 2
        ExplicitLeft = 3
        ExplicitTop = 199
        ExplicitWidth = 399
        object schSwap: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 385
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Swap File'
          Description = 'Select how to display information about the swap file.'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
          Color = clWindow
          ExplicitLeft = 3
          ExplicitTop = 3
          ExplicitWidth = 393
        end
        object cbSwpBar: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 47
          Width = 385
          Height = 17
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Status Bar'
          TabOrder = 0
          Checked = True
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitTop = 46
          ExplicitWidth = 384
        end
        object cbSwpPC: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 69
          Width = 385
          Height = 17
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Value as Text'
          TabOrder = 1
          Checked = True
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitWidth = 384
        end
        object cbSwpInfo: TJvXPCheckbox
          AlignWithMargins = True
          Left = 5
          Top = 91
          Width = 385
          Height = 17
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Information Label'
          TabOrder = 2
          Checked = True
          State = cbChecked
          Align = alTop
          OnClick = CheckboxClick
          ExplicitTop = 92
          ExplicitWidth = 384
        end
      end
    end
  end
end
