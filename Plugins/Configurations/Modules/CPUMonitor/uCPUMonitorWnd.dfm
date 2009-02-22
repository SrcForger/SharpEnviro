object frmCPUMon: TfrmCPUMon
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmCPUMon'
  ClientHeight = 378
  ClientWidth = 432
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
    Width = 432
    Height = 378
    ActivePage = pagMon
    PropagateEnable = False
    Align = alClient
    object pagMon: TJvStandardPage
      Left = 0
      Top = 0
      Width = 432
      Height = 378
      OnShow = pagMonShow
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 246
        Width = 420
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
      end
      object Panel6: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 213
        Width = 420
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object edit_cpu: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 177
          Height = 23
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          ParentBackground = False
          Min = 0
          Max = 16
          Value = 0
          Prefix = 'CPU: '
          Description = 'Adjust Update Interval'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbWidthChangeValue
          BackgroundColor = clWindow
        end
        object sgbUpdate: TSharpeGaugeBox
          Left = 188
          Top = 0
          Width = 193
          Height = 22
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          ParentBackground = False
          Min = 100
          Max = 2000
          Value = 250
          Prefix = 'Update every '
          Suffix = ' ms'
          Description = 'Adjust Update Interval'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbWidthChangeValue
          BackgroundColor = clWindow
        end
      end
      object SharpECenterHeader3: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 1
        Width = 420
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Chart Type'
        Description = 'Define the type of chart used for displaying CPU usage'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader5: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 166
        Width = 420
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'CPU'
        Description = 
          'Define the CPU to monitor. 0 = CPU 1, 1 = CPU 2, CPU Count+1 = O' +
          'VERALL'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 48
        Width = 420
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        object cboGraphType: TComboBox
          Left = 0
          Top = 0
          Width = 177
          Height = 21
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Style = csDropDownList
          Color = clBtnFace
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = 'History Graph (Bar)'
          OnChange = edit_cpuChange
          Items.Strings = (
            'History Graph (Bar)'
            'History Graph (Line)'
            'Current Usage (Progress Bar)')
        end
      end
      object SharpECenterHeader4: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 81
        Width = 420
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Chart Size'
        Description = 'Define the size for the graph'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 128
        Width = 420
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 6
        object sgbWidth: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 177
          Height = 22
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
          Suffix = 'px width'
          Description = 'Adjust graph size'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbWidthChangeValue
          BackgroundColor = clWindow
        end
      end
    end
    object pagColors: TJvStandardPage
      Left = 0
      Top = 0
      Width = 432
      Height = 378
      Caption = 'pagColors'
      Color = clWhite
      OnShow = pagColorsShow
      object Colors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 3
        Top = 161
        Width = 423
        Height = 80
        Margins.Left = 2
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alTop
        AutoSize = True
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        Items = <
          item
            Title = 'Background'
            ColorCode = 16777215
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 16777215
            ValueMin = 0
            ValueMax = 255
            Visible = True
            DisplayPercent = False
            ColorEditor = Colors.Item0
            Tag = 0
          end
          item
            Title = 'Foreground'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            ValueMin = 0
            ValueMax = 255
            Visible = True
            DisplayPercent = False
            ColorEditor = Colors.Item1
            Tag = 0
          end
          item
            Title = 'Border'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            ValueMin = 0
            ValueMax = 255
            Visible = True
            DisplayPercent = False
            ColorEditor = Colors.Item2
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
        OnChangeColor = ColorsChangeColor
        BorderColor = clBlack
        BackgroundColor = clWhite
        BackgroundTextColor = clBlack
        ContainerColor = clBlack
        ContainerTextColor = clBlack
      end
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 48
        Width = 415
        Height = 23
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object sgbBackground: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 200
          Height = 23
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 128
          Prefix = 'Background: '
          Suffix = '% Visible'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbWidthChangeValue
          BackgroundColor = clWindow
        end
        object sgbForeground: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 210
          Top = 0
          Width = 200
          Height = 23
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 128
          Prefix = 'Foreground: '
          Suffix = '% Visible'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbWidthChangeValue
          BackgroundColor = clWindow
        end
      end
      object Panel4: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 81
        Width = 415
        Height = 23
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object sgbBorder: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 200
          Height = 23
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 255
          Prefix = 'Border: '
          Suffix = '% Visible'
          Description = 'Adjust Blend Strength'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbWidthChangeValue
          BackgroundColor = clWindow
        end
      end
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 1
        Width = 420
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Chart Element Visibility'
        Description = 'Define the visibility of the chart elements'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader2: TSharpECenterHeader
        AlignWithMargins = True
        Left = 6
        Top = 114
        Width = 420
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Chart Element Colours'
        Description = 'Define the colour of the chart elements'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
    end
    object pagError: TJvStandardPage
      Left = 0
      Top = 0
      Width = 432
      Height = 378
      Caption = 'pagError'
      object SharpERoundPanel1: TSharpERoundPanel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 422
        Height = 141
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        Caption = 'SharpERoundPanel1'
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        DrawMode = srpNormal
        NoTopBorder = False
        RoundValue = 10
        BorderColor = clBtnFace
        Border = True
        BackgroundColor = clWindow
        object Label10: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 80
          Width = 406
          Height = 15
          Margins.Left = 8
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alTop
          AutoSize = False
          Caption = 
            '(A restart of your SharpBar will be necessary for the change to ' +
            'take effect)'
          WordWrap = True
          ExplicitTop = 62
          ExplicitWidth = 404
        end
        object Label11: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 406
          Height = 57
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'The Windows Performance Monitor is disabled on your system. A fa' +
            'il save flag is set in your registry which disables access to it' +
            '. The CPU Monitor module won'#39't be able to get the current cpu us' +
            'age while the Windows Performance Monitor is disabled.'
          WordWrap = True
          ExplicitWidth = 402
        end
        object Label12: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 65
          Width = 406
          Height = 15
          Margins.Left = 8
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'Click the button below to enable the Windows Performance Monitor' +
            ' again.'
          WordWrap = True
          ExplicitTop = 62
          ExplicitWidth = 404
        end
        object Button1: TButton
          Left = 8
          Top = 106
          Width = 75
          Height = 21
          Caption = 'Enable'
          TabOrder = 0
          OnClick = Button1Click
        end
      end
    end
    object pagError2: TJvStandardPage
      Left = 0
      Top = 0
      Width = 432
      Height = 378
      Caption = 'pagError2'
      object SharpERoundPanel2: TSharpERoundPanel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 422
        Height = 189
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        Caption = 'SharpERoundPanel1'
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        DrawMode = srpNormal
        NoTopBorder = False
        RoundValue = 10
        BorderColor = clBtnFace
        Border = True
        BackgroundColor = clWindow
        object Label13: TLabel
          AlignWithMargins = True
          Left = 22
          Top = 105
          Width = 392
          Height = 24
          Margins.Left = 22
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alTop
          AutoSize = False
          Caption = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\'
          WordWrap = True
          ExplicitWidth = 390
        end
        object Label14: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 406
          Height = 57
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'Access to the Windows Perfomance Object is denied on your system' +
            '. This is a typical problem on Windows Vista. The CPU Monitor mo' +
            'dule won'#39't be able to get the current cpu usage until access to ' +
            'the necessary registry key is granted.'
          WordWrap = True
          ExplicitWidth = 402
        end
        object Label15: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 65
          Width = 406
          Height = 15
          Margins.Left = 8
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'Follow the steps below to allow access (Administrator access req' +
            'uired):'
          WordWrap = True
          ExplicitTop = 62
          ExplicitWidth = 404
        end
        object Label16: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 88
          Width = 406
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = '1. Open Regedit and go to'
          WordWrap = True
          ExplicitWidth = 404
        end
        object Label17: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 137
          Width = 406
          Height = 17
          Margins.Left = 8
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = '2. Right click the '#39'Perflib'#39' Key and select "Security"'
          WordWrap = True
          ExplicitTop = 160
          ExplicitWidth = 404
        end
        object Label18: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 162
          Width = 406
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = '3. Add your user account with '#39'Read'#39' access to the list'
          WordWrap = True
          ExplicitTop = 171
          ExplicitWidth = 404
        end
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 390
    ShowCaptions = True
    SwatchHeight = 16
    SwatchWidth = 16
    SwatchSpacing = 4
    SwatchFont.Charset = DEFAULT_CHARSET
    SwatchFont.Color = clWindowText
    SwatchFont.Height = -11
    SwatchFont.Name = 'Tahoma'
    SwatchFont.Style = []
    SwatchTextBorderColor = 16709617
    SortMode = sortName
    BorderColor = clBlack
    BackgroundColor = clBlack
    BackgroundTextColor = clBlack
    Left = 384
    Top = 56
  end
end
