object frmCPUMon: TfrmCPUMon
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmCPUMon'
  ClientHeight = 357
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
    Height = 357
    ActivePage = pagMon
    PropagateEnable = False
    Align = alClient
    object pagMon: TJvStandardPage
      Left = 0
      Top = 0
      Width = 432
      Height = 357
      OnShow = pagMonShow
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 321
        Width = 422
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
        object sgbUpdate: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 200
          Height = 23
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          ParentBackground = False
          Min = 100
          Max = 1000
          Value = 250
          Prefix = 'Interval: '
          Suffix = ' ms'
          Description = 'Adjust Update Interval'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbWidthChangeValue
          BackgroundColor = clWindow
        end
      end
      object Panel6: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 243
        Width = 422
        Height = 21
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object edit_cpu: TJvSpinEdit
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 200
          Height = 21
          Margins.Left = 26
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 0
          ButtonKind = bkClassic
          TabOrder = 0
          OnChange = edit_cpuChange
        end
      end
      object rbGraphBar: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 417
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'History Graph (Bar)'
        TabOrder = 2
        OnClick = rbGraphBarClick
      end
      object rbCurrentUsage: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 91
        Width = 417
        Height = 17
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Current Usage (Progress Bar)'
        TabOrder = 3
        OnClick = rbGraphBarClick
      end
      object rbGraphLine: TRadioButton
        AlignWithMargins = True
        Left = 5
        Top = 69
        Width = 417
        Height = 17
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'History Graph (Line)'
        Checked = True
        TabOrder = 4
        TabStop = True
        OnClick = rbGraphBarClick
      end
      object SharpECenterHeader3: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 422
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Graph Type'
        Description = 'Define the type of graph used for displaying CPU usage'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader4: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 118
        Width = 422
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Graph Size'
        Description = 'Define the width for the graph'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 165
        Width = 422
        Height = 21
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 7
        object sgbWidth: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 200
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
          Suffix = 'px width'
          Description = 'Adjust graph size'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbWidthChangeValue
          BackgroundColor = clWindow
        end
      end
      object SharpECenterHeader5: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 196
        Width = 422
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'CPU'
        Description = 'Define the CPU to monitor. 0 = CPU 1, 1 = CPU 2, 2 = OVERALL'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader6: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 274
        Width = 422
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Update Interval'
        Description = 'Define the graph update interval'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
    end
    object pagColors: TJvStandardPage
      Left = 0
      Top = 0
      Width = 432
      Height = 357
      Caption = 'pagColors'
      Color = clWhite
      OnShow = pagColorsShow
      object Colors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 1
        Top = 171
        Width = 421
        Height = 80
        Margins.Left = 1
        Margins.Top = 0
        Margins.Right = 10
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
        Left = 5
        Top = 47
        Width = 417
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
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
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 75
        Width = 417
        Height = 21
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object sgbForeground: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 200
          Height = 21
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
        Left = 5
        Top = 101
        Width = 417
        Height = 23
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
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
        Left = 5
        Top = 0
        Width = 422
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Visiblity'
        Description = 'Define the visibility of the chart elements'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader2: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 134
        Width = 422
        Height = 37
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Colour'
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
      Height = 357
      Caption = 'pagError'
      object SharpERoundPanel1: TSharpERoundPanel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 424
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
          Width = 408
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
          Width = 408
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
          Width = 408
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
      Height = 357
      Caption = 'pagError2'
      object SharpERoundPanel2: TSharpERoundPanel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 424
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
          Width = 394
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
          Width = 408
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
          Width = 408
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
          Width = 408
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
          Width = 408
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
          Width = 408
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
    Width = 388
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
    Left = 372
    Top = 24
  end
end
