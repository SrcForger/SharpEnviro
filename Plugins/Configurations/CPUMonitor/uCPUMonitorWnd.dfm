object frmCPUMon: TfrmCPUMon
  Left = 0
  Top = 0
  Caption = 'frmCPUMon'
  ClientHeight = 399
  ClientWidth = 428
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 428
    Height = 399
    ActivePage = pagError2
    PropagateEnable = False
    Align = alClient
    object pagMon: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 399
      OnShow = pagMonShow
      object Label4: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 183
        Width = 412
        Height = 13
        Margins.Left = 8
        Margins.Top = 12
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'Graph Width'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 73
        ExplicitWidth = 65
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 108
        Width = 412
        Height = 13
        Margins.Left = 8
        Margins.Top = 12
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'CPU Number'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 73
        ExplicitWidth = 65
      end
      object Label8: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 129
        Width = 394
        Height = 13
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select which CPU to monitor'
        Transparent = False
        WordWrap = True
        ExplicitTop = 26
        ExplicitWidth = 393
      end
      object Label6: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 239
        Width = 412
        Height = 13
        Margins.Left = 8
        Margins.Top = 12
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'Update Interval'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 96
        ExplicitWidth = 411
      end
      object Label7: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 260
        Width = 394
        Height = 13
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Use this option to change how often the graph is updated'
        Transparent = False
        WordWrap = True
        ExplicitTop = 123
        ExplicitWidth = 393
      end
      object Label9: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 412
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'Display Type'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitLeft = 26
        ExplicitTop = 73
        ExplicitWidth = 65
      end
      object Panel1: TPanel
        Left = 0
        Top = 196
        Width = 428
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object sgbWidth: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 25
          Max = 200
          Value = 100
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Adjust Width'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbWidthChangeValue
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 273
        Width = 428
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object sgbUpdate: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 100
          Max = 1000
          Value = 250
          Prefix = 'Interval: '
          Suffix = 'ms'
          Description = 'Adjust Update Interval'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = sgbWidthChangeValue
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 142
        Width = 428
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object edit_cpu: TJvSpinEdit
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 79
          Height = 21
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          TabOrder = 0
          OnChange = edit_cpuChange
        end
      end
      object rbGraphBar: TRadioButton
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 394
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'History Graph (Bar)'
        TabOrder = 3
        OnClick = rbGraphBarClick
      end
      object rbCurrentUsage: TRadioButton
        AlignWithMargins = True
        Left = 26
        Top = 79
        Width = 394
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Current Usage (Progress Bar)'
        TabOrder = 4
        OnClick = rbGraphBarClick
      end
      object rbGraphLine: TRadioButton
        AlignWithMargins = True
        Left = 26
        Top = 54
        Width = 394
        Height = 17
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'History Graph (Line)'
        Checked = True
        TabOrder = 5
        TabStop = True
        OnClick = rbGraphBarClick
      end
    end
    object pagColors: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 399
      Caption = 'pagColors'
      OnShow = pagColorsShow
      object Label1: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 412
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'Color Visibility'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 109
        ExplicitWidth = 411
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 394
        Height = 28
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'Changing the values below will adjust the visibility of  the col' +
          'ors which are used to render the CPU usage graph.'
        Transparent = False
        WordWrap = True
        ExplicitTop = 109
        ExplicitWidth = 393
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 166
        Width = 412
        Height = 13
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        BiDiMode = bdRightToLeftNoAlign
        Caption = 'Colors'
        ParentBiDiMode = False
        Transparent = False
        WordWrap = True
        ExplicitTop = 313
        ExplicitWidth = 411
      end
      object Colors: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 26
        Top = 187
        Width = 394
        Height = 80
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alTop
        AutoSize = True
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
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
      end
      object Panel2: TPanel
        Left = 0
        Top = 57
        Width = 428
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object sgbBackground: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 128
          Prefix = 'Background: '
          Suffix = '%'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbWidthChangeValue
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 88
        Width = 428
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object sgbForeground: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 128
          Prefix = 'Foreground: '
          Suffix = '%'
          Description = 'Adjust transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbWidthChangeValue
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 119
        Width = 428
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        object sgbBorder: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 8
          Width = 159
          Height = 23
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 0
          Max = 255
          Value = 255
          Prefix = 'Border: '
          Suffix = '%'
          Description = 'Adjust Blend Strength'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = sgbWidthChangeValue
        end
      end
    end
    object pagError: TJvStandardPage
      Left = 0
      Top = 0
      Width = 428
      Height = 399
      Caption = 'pagError'
      object SharpERoundPanel1: TSharpERoundPanel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 420
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
          Width = 404
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
        end
        object Label11: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 404
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
          Width = 404
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
      Width = 428
      Height = 399
      Caption = 'pagError2'
      object SharpERoundPanel2: TSharpERoundPanel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 420
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
          Width = 390
          Height = 24
          Margins.Left = 22
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alTop
          AutoSize = False
          Caption = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\'
          WordWrap = True
        end
        object Label14: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 404
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
          Width = 404
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
        end
        object Label16: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 88
          Width = 404
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = '1. Open Regedit and go to'
          WordWrap = True
        end
        object Label17: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 137
          Width = 404
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
        end
        object Label18: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 162
          Width = 404
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
        end
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 362
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
    Left = 296
    Top = 136
  end
end
