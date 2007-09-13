object frmDesktopSettings: TfrmDesktopSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmDesktopSettings'
  ClientHeight = 431
  ClientWidth = 528
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 528
    Height = 431
    ActivePage = pagFontShadow
    PropagateEnable = False
    Align = alClient
    ExplicitHeight = 606
    object pagIcon: TJvStandardPage
      Left = 0
      Top = 0
      Width = 528
      Height = 431
      ExplicitHeight = 606
      object Panel3: TPanel
        Left = 0
        Top = 279
        Width = 528
        Height = 75
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object lblIconTransDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 33
          Width = 494
          Height = 15
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'This option controls the Icon transparency. 100% fully visible.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
        end
        object sgbIconTrans: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 54
          Width = 250
          Height = 21
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Constraints.MaxWidth = 534
          ParentBackground = False
          Min = 16
          Max = 255
          Value = 192
          Prefix = 'Icon Transparency: '
          Suffix = '%'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = SendUpdateEvent
        end
        object chkIconTrans: TJvCheckBox
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 512
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Icon Transparency'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = UpdateIcontPageEvent
          LinkedControls = <>
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 528
        Height = 129
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object lblIconSizeDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 494
          Height = 15
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Please select the default icon size for desktop icons.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
        end
        object CheckBox1: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 512
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Icon Size'
          ExplicitWidth = 546
        end
        object SharpERoundPanel1: TSharpERoundPanel
          Left = 25
          Top = 47
          Width = 80
          Height = 74
          BevelOuter = bvNone
          Caption = 'SharpERoundPanel1'
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          DrawMode = srpNormal
          NoTopBorder = False
          RoundValue = 10
          BorderColor = clBtnFace
          Border = True
          BackgroundColor = clWindow
          object icon32: TImage32
            AlignWithMargins = True
            Left = 3
            Top = 27
            Width = 74
            Height = 44
            Align = alClient
            Bitmap.ResamplerClassName = 'TKernelResampler'
            Bitmap.Resampler.KernelClassName = 'TBoxKernel'
            Bitmap.Resampler.KernelMode = kmDynamic
            Bitmap.Resampler.TableSize = 32
            BitmapAlign = baCenter
            Scale = 1.000000000000000000
            ScaleMode = smOptimalScaled
            TabOrder = 0
          end
          object rdoIcon32: TRadioButton
            AlignWithMargins = True
            Left = 5
            Top = 4
            Width = 72
            Height = 17
            Margins.Left = 5
            Margins.Top = 4
            Align = alTop
            Caption = '32x32'
            Checked = True
            TabOrder = 1
            TabStop = True
            OnClick = rdoIconCustomClick
          end
        end
        object SharpERoundPanel2: TSharpERoundPanel
          Left = 108
          Top = 48
          Width = 80
          Height = 73
          BevelOuter = bvNone
          Caption = 'SharpERoundPanel1'
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          DrawMode = srpNormal
          NoTopBorder = False
          RoundValue = 10
          BorderColor = clBtnFace
          Border = True
          BackgroundColor = clWindow
          object icon48: TImage32
            AlignWithMargins = True
            Left = 3
            Top = 27
            Width = 74
            Height = 43
            Align = alClient
            Bitmap.ResamplerClassName = 'TKernelResampler'
            Bitmap.Resampler.KernelClassName = 'TBoxKernel'
            Bitmap.Resampler.KernelMode = kmDynamic
            Bitmap.Resampler.TableSize = 32
            BitmapAlign = baCenter
            Scale = 1.000000000000000000
            ScaleMode = smOptimalScaled
            TabOrder = 0
          end
          object rdoIcon48: TRadioButton
            AlignWithMargins = True
            Left = 5
            Top = 4
            Width = 72
            Height = 17
            Margins.Left = 5
            Margins.Top = 4
            Align = alTop
            Caption = '48x48'
            TabOrder = 1
            OnClick = rdoIconCustomClick
          end
        end
        object SharpERoundPanel3: TSharpERoundPanel
          Left = 191
          Top = 48
          Width = 80
          Height = 73
          BevelOuter = bvNone
          Caption = 'SharpERoundPanel1'
          Color = clWhite
          ParentBackground = False
          TabOrder = 2
          DrawMode = srpNormal
          NoTopBorder = False
          RoundValue = 10
          BorderColor = clBtnFace
          Border = True
          BackgroundColor = clWindow
          object Icon64: TImage32
            AlignWithMargins = True
            Left = 3
            Top = 27
            Width = 74
            Height = 43
            Align = alClient
            Bitmap.ResamplerClassName = 'TKernelResampler'
            Bitmap.Resampler.KernelClassName = 'TBoxKernel'
            Bitmap.Resampler.KernelMode = kmDynamic
            Bitmap.Resampler.TableSize = 32
            BitmapAlign = baCenter
            Scale = 1.000000000000000000
            ScaleMode = smOptimalScaled
            TabOrder = 0
          end
          object rdoIcon64: TRadioButton
            AlignWithMargins = True
            Left = 5
            Top = 4
            Width = 72
            Height = 17
            Margins.Left = 5
            Margins.Top = 4
            Align = alTop
            Caption = '64x64'
            TabOrder = 1
            OnClick = rdoIconCustomClick
          end
        end
        object SharpERoundPanel4: TSharpERoundPanel
          Left = 274
          Top = 48
          Width = 119
          Height = 100
          BevelOuter = bvNone
          Caption = 'SharpERoundPanel1'
          Color = clWhite
          ParentBackground = False
          TabOrder = 3
          DrawMode = srpNormal
          NoTopBorder = False
          RoundValue = 10
          BorderColor = clWindow
          Border = False
          BackgroundColor = clWindow
          object rdoIconCustom: TRadioButton
            AlignWithMargins = True
            Left = 5
            Top = 4
            Width = 111
            Height = 17
            Margins.Left = 5
            Margins.Top = 4
            Align = alTop
            Caption = 'Custom'
            TabOrder = 0
            OnClick = rdoIconCustomClick
          end
          object sgbIconSize: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 3
            Top = 27
            Width = 113
            Height = 21
            Align = alTop
            ParentBackground = False
            Min = 12
            Max = 256
            Value = 96
            Prefix = 'Icon Size: '
            Suffix = 'px'
            Description = 'Adjust to set the icon size'
            PopPosition = ppBottom
            PercentDisplay = False
            OnChangeValue = SendUpdateEvent
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 129
        Width = 528
        Height = 75
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 2
        object lblColorBlendDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 33
          Width = 494
          Height = 15
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'This option controls the Icon color blend strength. 100% fully b' +
            'lended.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
          WordWrap = True
        end
        object sgbColorBlend: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 54
          Width = 250
          Height = 21
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Constraints.MaxWidth = 534
          ParentBackground = False
          Min = 16
          Max = 255
          Value = 192
          Prefix = 'Blend Strength: '
          Suffix = '%'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = SendUpdateEvent
        end
        object chkColorBlend: TJvCheckBox
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 512
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Icon Color Blend'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = UpdateIcontPageEvent
          LinkedControls = <>
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 204
        Width = 528
        Height = 75
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 3
        object lblIconShadowDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 33
          Width = 494
          Height = 15
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 
            'This option controls the Icon shadow transparency. 100% fully vi' +
            'sible.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
        end
        object sgbIconShadow: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 26
          Top = 54
          Width = 250
          Height = 21
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Constraints.MaxWidth = 534
          ParentBackground = False
          Min = 16
          Max = 255
          Value = 192
          Prefix = 'Shadow Transparency: '
          Suffix = '%'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = SendUpdateEvent
        end
        object chkIconShadow: TJvCheckBox
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 512
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Icon Shadow'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = UpdateIcontPageEvent
          LinkedControls = <>
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
      end
      object Panel10: TPanel
        Left = 0
        Top = 354
        Width = 528
        Height = 77
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 4
        ExplicitHeight = 252
        object lblIconColorDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 494
          Height = 15
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Define Icon color options below.'
          EllipsisPosition = epEndEllipsis
          Transparent = False
        end
        object lblIconColor: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 512
          Height = 17
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Icon Color Options'
          ExplicitWidth = 546
        end
        object sceIconColor: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 20
          Top = 44
          Width = 500
          Height = 25
          Margins.Left = 20
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clWindow
          Padding.Right = 8
          ParentBackground = True
          ParentColor = False
          TabOrder = 0
          Items = <
            item
              Title = 'Color Blending'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              Visible = True
              ColorEditor = sceIconColor.Item0
              Tag = 0
            end
            item
              Title = 'Icon Shadow'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              Visible = True
              ColorEditor = sceIconColor.Item1
              Tag = 0
            end>
          SwatchManager = SharpESwatchManager1
          OnUiChange = UpdateColorChangeEvent
          ExplicitHeight = 200
        end
      end
    end
    object pagFont: TJvStandardPage
      Left = 0
      Top = 0
      Width = 528
      Height = 431
      ExplicitHeight = 606
      object lblFontNameDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 494
        Height = 15
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select from the list of type faces below'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
      end
      object lblFontSizeDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 104
        Width = 494
        Height = 15
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Changing this value increases/decreases the size of the font'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
      end
      object lblFontTransDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 182
        Width = 494
        Height = 15
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Changing this value will make the font more or less transparent'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
      end
      object Label10: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 512
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Type'
        ExplicitWidth = 49
      end
      object Label11: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 83
        Width = 512
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Size'
        ExplicitWidth = 44
      end
      object lblFontStyleDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 256
        Width = 494
        Height = 15
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Select from the available font styles below'
        EllipsisPosition = epEndEllipsis
        Transparent = False
        WordWrap = True
      end
      object Label14: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 235
        Width = 512
        Height = 13
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Style'
        ExplicitWidth = 49
      end
      object lblFontColor: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 346
        Width = 512
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Font Color Options'
        ExplicitLeft = -8
        ExplicitTop = 471
        ExplicitWidth = 562
      end
      object lblFontColorDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 367
        Width = 494
        Height = 15
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'Define font color options below.'
        EllipsisPosition = epEndEllipsis
        Transparent = False
      end
      object sceFontColor: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 28
        Top = 382
        Width = 492
        Height = 157
        Margins.Left = 28
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 8
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alTop
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
        ParentBackground = True
        ParentColor = False
        TabOrder = 0
        Items = <
          item
            Title = 'Text'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            Visible = True
            ColorEditor = sceFontColor.Item0
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
        OnUiChange = UpdateColorChangeEvent
      end
      object cboFontName: TComboBox
        AlignWithMargins = True
        Left = 28
        Top = 52
        Width = 250
        Height = 23
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Style = csOwnerDrawVariable
        Constraints.MaxWidth = 250
        DropDownCount = 12
        ItemHeight = 17
        TabOrder = 1
        OnChange = cboFontNameChange
        OnDrawItem = cboFontNameDrawItem
      end
      object chkUnderline: TJvCheckBox
        AlignWithMargins = True
        Left = 28
        Top = 321
        Width = 492
        Height = 17
        Margins.Left = 28
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Underline'
        TabOrder = 2
        OnClick = FontStyleCheckEvent
        LinkedControls = <>
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
      end
      object chkItalic: TJvCheckBox
        AlignWithMargins = True
        Left = 28
        Top = 300
        Width = 492
        Height = 17
        Margins.Left = 28
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Italic'
        TabOrder = 3
        OnClick = FontStyleCheckEvent
        LinkedControls = <>
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
      end
      object chkBold: TJvCheckBox
        AlignWithMargins = True
        Left = 28
        Top = 279
        Width = 492
        Height = 17
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Bold'
        TabOrder = 4
        OnClick = FontStyleCheckEvent
        LinkedControls = <>
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
      end
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 127
        Width = 492
        Height = 22
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 5
        object sgbFontSize: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 250
          Height = 22
          Margins.Left = 28
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = 6
          Max = 24
          Value = 0
          Prefix = 'Size: '
          Suffix = 'px'
          Description = 'Change font size'
          PopPosition = ppRight
          PercentDisplay = False
          OnChangeValue = SendUpdateEvent
        end
      end
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 28
        Top = 205
        Width = 492
        Height = 22
        Margins.Left = 28
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 6
        object sgbFontTrans: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 250
          Height = 22
          Margins.Left = 28
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          ParentBackground = False
          Min = -255
          Max = 255
          Value = 0
          Prefix = 'Transparency: '
          Suffix = '%'
          Description = 'Change font opacity'
          PopPosition = ppRight
          PercentDisplay = True
          OnChangeValue = SendUpdateEvent
        end
      end
      object chkFontTrans: TJvCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 157
        Width = 512
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Transparency'
        TabOrder = 7
        OnClick = UpdateFontPageEvent
        LinkedControls = <>
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        Layout = tlTop
      end
    end
    object pagAnimation: TJvStandardPage
      Left = 0
      Top = 0
      Width = 528
      Height = 431
      ExplicitHeight = 606
      object Label5: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 33
        Width = 494
        Height = 13
        Margins.Left = 26
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Enable/Disable mouseover animation'
        Transparent = False
        WordWrap = True
        ExplicitWidth = 175
      end
      object pnlAnim: TPanel
        Left = 0
        Top = 46
        Width = 528
        Height = 385
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitHeight = 560
        object Panel9: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 8
          Width = 528
          Height = 493
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object lblAnimTransDet: TLabel
            AlignWithMargins = True
            Left = 26
            Top = 33
            Width = 494
            Height = 13
            Margins.Left = 26
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            Caption = 'This option controls the animation transparency'
            Transparent = False
            WordWrap = True
            ExplicitWidth = 228
          end
          object lblAnimSizeDet: TLabel
            AlignWithMargins = True
            Left = 26
            Top = 185
            Width = 494
            Height = 13
            Margins.Left = 26
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            Caption = 'This option controls the animation size'
            Transparent = False
            WordWrap = True
            ExplicitWidth = 182
          end
          object lblAnimBrightnessDet: TLabel
            AlignWithMargins = True
            Left = 26
            Top = 109
            Width = 494
            Height = 13
            Margins.Left = 26
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            Caption = 'This option controls the animation brightness'
            Transparent = False
            WordWrap = True
            ExplicitWidth = 214
          end
          object lblAnimColorBlendDet: TLabel
            AlignWithMargins = True
            Left = 26
            Top = 261
            Width = 494
            Height = 13
            Margins.Left = 26
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            Caption = 'This option controls the animation color blend'
            Transparent = False
            WordWrap = True
            ExplicitWidth = 216
          end
          object Panel12: TPanel
            AlignWithMargins = True
            Left = 28
            Top = 206
            Width = 492
            Height = 22
            Margins.Left = 28
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 0
            object sgbAnimSize: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 250
              Height = 22
              Align = alLeft
              ParentBackground = False
              Min = -64
              Max = 64
              Value = 32
              Prefix = 'Change size by: '
              Suffix = 'px'
              Description = 'Adjust to set the scale size'
              PopPosition = ppBottom
              PercentDisplay = False
              OnChangeValue = SendUpdateEvent
            end
          end
          object chkAnimTrans: TJvCheckBox
            AlignWithMargins = True
            Left = 8
            Top = 8
            Width = 512
            Height = 17
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Animation Transparency'
            TabOrder = 1
            LinkedControls = <>
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Layout = tlTop
          end
          object chkAnimSize: TJvCheckBox
            AlignWithMargins = True
            Left = 8
            Top = 160
            Width = 512
            Height = 17
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Animation Size'
            TabOrder = 2
            LinkedControls = <>
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Layout = tlTop
          end
          object Panel13: TPanel
            AlignWithMargins = True
            Left = 28
            Top = 130
            Width = 492
            Height = 22
            Margins.Left = 28
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 3
            object sgbAnimBrightness: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 250
              Height = 22
              Align = alLeft
              ParentBackground = False
              Min = -255
              Max = 255
              Value = 64
              Prefix = 'Change brightness by: '
              Suffix = '%'
              Description = 'Adjust to set the brightness modification value'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = SendUpdateEvent
            end
          end
          object chkAnimBrightness: TJvCheckBox
            AlignWithMargins = True
            Left = 8
            Top = 84
            Width = 512
            Height = 17
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Animation Brightness'
            TabOrder = 4
            LinkedControls = <>
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Layout = tlTop
          end
          object chkAnimColorBlend: TJvCheckBox
            AlignWithMargins = True
            Left = 8
            Top = 236
            Width = 512
            Height = 17
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Animation Color Blend'
            TabOrder = 5
            LinkedControls = <>
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Layout = tlTop
          end
          object Panel14: TPanel
            AlignWithMargins = True
            Left = 28
            Top = 282
            Width = 492
            Height = 22
            Margins.Left = 28
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 6
            object sgbAnimColorBlend: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 250
              Height = 22
              Align = alLeft
              ParentBackground = False
              Min = 0
              Max = 255
              Value = 255
              Prefix = 'Change color blend by: '
              Suffix = '%'
              Description = 'Adjust to set the color blend strength'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = SendUpdateEvent
            end
          end
          object Panel15: TPanel
            AlignWithMargins = True
            Left = 28
            Top = 54
            Width = 492
            Height = 22
            Margins.Left = 28
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 7
            object sgbAnimTrans: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 250
              Height = 22
              Align = alLeft
              ParentBackground = False
              Min = -255
              Max = 255
              Value = 64
              Prefix = 'Change transparency by: '
              Suffix = '%'
              Description = 'Adjust to set the alpha modification value'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = SendUpdateEvent
            end
          end
          object sceAnimColor: TSharpEColorEditorEx
            AlignWithMargins = True
            Left = 26
            Top = 312
            Width = 494
            Height = 181
            Margins.Left = 26
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clWindow
            ParentBackground = True
            ParentColor = False
            TabOrder = 8
            Items = <
              item
                Title = 'Color Blending'
                ColorCode = 0
                ColorAsTColor = clBlack
                Expanded = False
                ValueEditorType = vetColor
                Value = 0
                Visible = True
                ColorEditor = sceAnimColor.Item0
                Tag = 0
              end>
            SwatchManager = SharpESwatchManager1
          end
        end
      end
      object chkAnim: TJvCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 512
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Animation'
        TabOrder = 1
        LinkedControls = <>
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
      end
    end
    object pagFontShadow: TJvStandardPage
      Left = 0
      Top = 0
      Width = 528
      Height = 431
      Caption = 'pagFontShadow'
      ExplicitHeight = 606
      object lblFontShadowDet: TLabel
        AlignWithMargins = True
        Left = 26
        Top = 29
        Width = 494
        Height = 13
        Margins.Left = 26
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Enable/Disable drawing of font shadows'
        Transparent = False
        WordWrap = True
        ExplicitWidth = 192
      end
      object pnlTextShadow: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 42
        Width = 528
        Height = 387
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object lblFontShadowTypeDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 29
          Width = 494
          Height = 13
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Select from different shadow render types below'
          Transparent = False
          WordWrap = True
          ExplicitWidth = 235
        end
        object lblFontShadowTransDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 138
          Width = 494
          Height = 13
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 
            'Changing this value will make the font shadow more or less trans' +
            'parent'
          Transparent = False
          WordWrap = True
          ExplicitWidth = 342
        end
        object Label18: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 512
          Height = 13
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Shadow Type'
          ExplicitWidth = 65
        end
        object Label19: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 117
          Width = 512
          Height = 13
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Shadow Transparency'
          ExplicitWidth = 107
        end
        object Label20: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 189
          Width = 512
          Height = 13
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Font Shadow Color Options'
          ExplicitWidth = 131
        end
        object lblFontShadowColDet: TLabel
          AlignWithMargins = True
          Left = 26
          Top = 210
          Width = 494
          Height = 13
          Margins.Left = 26
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Define font shadow color options below.'
          Transparent = False
          ExplicitWidth = 193
        end
        object Panel11: TPanel
          AlignWithMargins = True
          Left = 28
          Top = 159
          Width = 492
          Height = 22
          Margins.Left = 28
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 0
          object sgbFontShadowTrans: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 250
            Height = 22
            Margins.Left = 28
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alLeft
            Constraints.MaxWidth = 532
            ParentBackground = False
            Min = -255
            Max = 255
            Value = 0
            Prefix = 'Shadow Transparency: '
            Suffix = '%'
            Description = 'Change shadow opacity'
            PopPosition = ppRight
            PercentDisplay = True
            OnChangeValue = SendUpdateEvent
          end
        end
        object rdoShadowTypeOutline: TRadioButton
          AlignWithMargins = True
          Left = 28
          Top = 92
          Width = 492
          Height = 17
          Margins.Left = 28
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Outline'
          TabOrder = 1
        end
        object rdoShadowTypeRight: TRadioButton
          AlignWithMargins = True
          Left = 28
          Top = 71
          Width = 492
          Height = 17
          Margins.Left = 28
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Right'
          TabOrder = 2
        end
        object rdoShadowTypeLeft: TRadioButton
          AlignWithMargins = True
          Left = 28
          Top = 50
          Width = 492
          Height = 17
          Margins.Left = 28
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Left'
          Checked = True
          TabOrder = 3
          TabStop = True
          OnClick = ShadowTypeCheckEvent
        end
        object sceShadowColor: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 28
          Top = 227
          Width = 492
          Height = 157
          Margins.Left = 28
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 8
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alTop
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clWindow
          ParentBackground = True
          ParentColor = False
          TabOrder = 4
          Items = <
            item
              Title = 'Shadow'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              Visible = True
              ColorEditor = sceShadowColor.Item0
              Tag = 0
            end>
          SwatchManager = SharpESwatchManager1
          OnUiChange = UpdateColorChangeEvent
        end
      end
      object chkFontShadow: TJvCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 512
        Height = 17
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Font Shadow'
        TabOrder = 1
        OnClick = UpdateFontshadowPageEvent
        LinkedControls = <>
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    Width = 460
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
    Left = 520
    Top = 56
  end
  object imlFontIcons: TImageList
    Left = 520
    Top = 20
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FAFEFD00C6EEE600C6EEE600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FDFCFC00E9DDDF00E9DDDF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FCFCFC00DFDFDF00DFDFDF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FBFEFD00C7EDE50086D9C80074D4C0007CD7C400EDFAF7000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFCFD00E8DDDF00CFB6BB00C7ABB000CBB1B500F8F4F5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFDFD00DFDFDF00BBBBBB00B0B0B000B5B5B500F5F5F5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FCFE
      FD00E0F5F000A0E1D30064CDB60066CEB80094DDCD00B4E7DC00BFECE2000000
      000000000000000000000000000000000000000000000000000000000000FEFD
      FD00EDE4E600D9C6C800DFD0D300D3BEC100D4BEC200E1D2D500E6D9DB000000
      000000000000000000000000000000000000000000000000000000000000FDFD
      FD00EEEEEE00D9D9D900C1C1C100A9A9A900AAAAAA00ACACAC00DBDBDB000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9FDFC00BDE9E000B7E7
      DC0000000000ABE3D60059C8B0005BC9B200AEE4D90000000000B0E5DA00DDF5
      F0000000000000000000000000000000000000000000FDFCFC00F1EBEC000000
      0000DCCBCE00DCCCCF0000000000DDCDD000DECED00000000000DFCFD200F8F5
      F5000000000000000000000000000000000000000000FCFCFC00ECECEC000000
      00000000000000000000D1D1D100BEBEBE00A5A5A500A5A5A500D3D3D3000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000096DBCC0049C1A700A4E0
      D30000000000A5E0D4004EC3A90050C4AC00A8E2D60000000000A8E2D5008ADA
      C900FEFFFE0000000000000000000000000000000000D3BFC200D9C8CB000000
      0000DAC8CB0000000000DAC9CC00CCB4B800DBCACD0000000000DBCACD00E7DC
      DE000000000000000000000000000000000000000000C4C4C400B8B8B800CDCD
      CD00CDCDCD00CDCDCD0000000000CECECE009F9F9F009F9F9F00CFCFCF000000
      0000FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4DFD20040BDA1009FDE
      D00000000000A1DED00044BEA30045BFA400A2DFD20000000000A4E0D30050C4
      AC00CEF1EA0000000000000000000000000000000000D9C7CB00D7C5C8000000
      00000000000000000000D8C6C900C8AEB200D8C6C90000000000000000000000
      00000000000000000000000000000000000000000000CDCDCD00B4B4B400CACA
      CA000000000000000000CBCBCB00B5B5B50098989800B7B7B700CDCDCD000000
      0000F1F1F1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C5EBE20071CDB9009BDC
      CD00000000009CDCCE0073CEBA0074CEBC009EDDCF0000000000A4E0D30082D4
      C3007DD6C300FBFEFD00000000000000000000000000E7DCDE00D5C2C5000000
      0000D5C2C600D5C2C60000000000D6C3C600D6C3C70000000000D9C8CB00DAC9
      CC0000000000FEFDFD00000000000000000000000000DFDFDF00C8C8C8000000
      0000C8C8C800C8C8C800C9C9C900B2B2B200B2B2B200CACACA0000000000CECE
      CE0000000000FDFDFD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1F4F00097DACC000000
      0000000000000000000098DACC009BDBCD00000000000000000000000000A9E2
      D5005AC8B100CBEFE800000000000000000000000000F2EDEE00D3BFC3000000
      00000000000000000000D3C0C400C3A8AD00C5ABB000D8C6C900000000000000
      0000DDCDCF00F0E9EA00000000000000000000000000EEEEEE00ADADAD00C5C5
      C500000000000000000000000000C8C8C800C9C9C90000000000CDCDCD00BCBC
      BC00D1D1D1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FCFB0075CDBA0092D8
      C90093D8CA0095D9CA006ECCB70073CEB9009FDED000A3DFD300A6E1D40086D7
      C6005CCAB30083D8C600FEFFFF000000000000000000FCFAFB00C4AAAF00D1BC
      C000D1BDC000D2BEC200C2A7AC00AD878E00AF8B9100C8B0B400DAC9CC00DCCB
      CE00D0B9BD00CCB4B800FFFEFE000000000000000000FBFBFB0093939300AAAA
      AA00C3C3C300C5C5C500C7C7C700B2B2B200B4B4B400CCCCCC00B9B9B900A0A0
      A000BFBFBF00DCDCDC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006ECAB60024B0
      91002AB2950030B5990036B89B003CBBA10043BEA3004AC1A80050C4AC0057C7
      AE005ECBB40065CEB700CBEFE700000000000000000000000000C1A6AB00A279
      8100A47D8400A8818800AA848B00AD888E00B18D9300B4919700B7959B00BA99
      9F00BD9EA300C1A2A700EAE0E200000000000000000000000000AFAFAF008686
      8600898989008D8D8D009090900093939300979797009B9B9B009E9E9E00A1A1
      A100A5A5A500A9A9A900E2E2E200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F8FCFB006DCA
      B7002CB3970031B69A0037B99C003EBCA00044BEA5004AC1A90051C5AD0058C8
      AF005FCBB50087D9C700D9F3EE00000000000000000000000000FCFBFB00C1A5
      AA00A57E8500A8818800AB858C00AE899000B18D9300B4919700B8969C00BB9A
      A000BD9EA300CEB7BB00F0E8EA00000000000000000000000000FBFBFB00AEAE
      AE008A8A8A008D8D8D009191910094949400979797009B9B9B009F9F9F00A2A2
      A200A5A5A500BCBCBC00EAEAEA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FDFE
      FE007BD0BE0032B69A0038B99D003EBCA00044BFA4004AC2A80055C5AD008DD9
      C800D7F2EC00FEFFFF000000000000000000000000000000000000000000FEFE
      FE00C7AFB300A8828900AC868D00AE899000B18D9300B4919700B9989E00D1BA
      BE00EFE7E800000000000000000000000000000000000000000000000000FEFE
      FE00B6B6B6008E8E8E009292920094949400979797009B9B9B00A0A0A000C0C0
      C000E9E9E9000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008CD6C70038B99D003EBCA1004FC3A90097DBCD00E4F6F2000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CEB9BD00AC868D00AE899000B6949900D3C0C300F4EFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00092929200949494009D9D9D00C5C5C500F0F0F0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009EDDCF009CDCCF00EDF9F60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6C3C700D6C3C600F8F4F50000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C9C9C900C8C8C800F5F5F50000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FE3FFE3FFE3F0000
      F81FF81FF81F0000E01FE01FE01F0000800F8007800F00008007800780070000
      8007800780070000800380038003000080038003800300008001800180030000
      C001C001C0010000C001C001C0010000E003E007E0070000F81FF81FF81F0000
      FC7FFC7FFC7F0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
end
