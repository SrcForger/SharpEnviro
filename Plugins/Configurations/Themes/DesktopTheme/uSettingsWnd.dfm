object frmSettingsWnd: TfrmSettingsWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettingsWnd'
  ClientHeight = 591
  ClientWidth = 595
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
    Width = 595
    Height = 591
    ActivePage = pagFont
    PropagateEnable = False
    Align = alClient
    object pagIcon: TJvStandardPage
      Left = 0
      Top = 0
      Width = 595
      Height = 591
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 410
        Width = 585
        Height = 22
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object sgbIconTrans: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 250
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Constraints.MaxWidth = 534
          ParentBackground = False
          Min = 1
          Max = 255
          Value = 192
          Suffix = '% visible'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = SendUpdateEvent
          BackgroundColor = clWindow
        end
      end
      object Panel4: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 585
        Height = 82
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 1
        object SharpERoundPanel1: TSharpERoundPanel
          Left = 0
          Top = 0
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
            AutoSize = True
            Bitmap.OuterColor = -1
            Bitmap.ResamplerClassName = 'TKernelResampler'
            Bitmap.Resampler.KernelClassName = 'TBoxKernel'
            Bitmap.Resampler.KernelMode = kmDynamic
            Bitmap.Resampler.TableSize = 32
            Bitmap.Data = {
              1000000010000000000000FF000000FF211913FF2D251EFF271F19FF231C16FF
              1F1813FF1B140FFF17120DFF15100BFF120D0AFF100C09FF0C0907FF0A0805FF
              080604FF030202FF000000FF000000FF90877EFFDEBAADFFD7B4A5FFD3B2A5FF
              D1B5A9FFCDBFB7FFC6B8AFFFBFAEA5FFB7AAA2FFB0A197FFA8988EFFA1948BFF
              9F9791FF4A3F36FF000000FF0C0906FFBCA99FFFF79673FFF59572FFF79774FF
              FCA17FFFFECFBAFFFFC6B1FFFFC7B2FFFFC8B3FFFDB69CFFF9A483FFFB9E7CFF
              EDBEAEFF5A5752FF000000FF1B1510FFD7BBADFFF7926BFFF6956FFFF9A07EFF
              D19E83FFA69588FFE9B197FFFEB699FFFAB093FFF8A381FFF69772FFF7926BFF
              E5B2A0FF514B44FF000000FF302821FFE7B9A5FFF98D60FFF99871FFEBBAA4FF
              B5A299FF7C7C7CFFC19277FFFC9D76FFFA976FFFFA946AFFF88F64FFF98455FF
              DFA893FF4A433BFF000000FF484038FFF7B597FFFF8F5DFFF7956BFFA48B74FF
              7B8580FF84887EFFD78C68FFFC8452FFFC743CFFFA6A2FFFF96325FFFB5813FF
              D89175FF433B34FF000000FF645E55FFE9A684FFB17858FFE4936AFFD68A64FF
              6F5547FF3C4F44FF7B5C3CFFFE7538FFFD7439FFFD6C2DFFFC6929FFFF601CFF
              D4977EFF3D352DFF000000FF7E7C73FF617367FF6A6154FFFF8F59FF986543FF
              984F31FFAB714BFF836B53FFFF7D3DFFFF7D40FFFE783BFFFF7433FFFF6D29FF
              CDA190FF362E26FF070503FF91928FFF344344FF664A38FFDE6E46FFD07550FF
              E6764AFFFC864CFFD57B52FFFF8449FFFC844CFFFC8147FFFC7B41FFFF773AFF
              C8A496FF30271FFF140E0AFFBBC0C2FF9C9BA3FF999591FFE0955AFFFB9951FF
              FA934FFFF88B49FFFA8547FFFA8248FFFC834CFFFD834DFFFB7E4AFFFF783DFF
              C2A498FF2A2119FF251D16FFD7E0E9FFF6F7FFFFF3F6FFFFD4D2CBFFCCB280FF
              DEB86FFFE5BA69FFDEA656FFD89446FFD4863BFFD67D31FFDE7E31FFE97B2CFF
              B8A699FF241B14FF3C3229FFE1EBF7FFE2E4F3FFE9ECF5FFDAD3DAFFB7A0A0FF
              B99780FFC8A172FFDAB679FFE4BE77FFE1B76EFFD5A75EFFCB9249FFBE7930FF
              A8A59CFF1E1711FF4E443BFFC4D3DFFFCFDBEAFFDCE7F6FFEAF2FDFFE9EEF9FF
              DED7E0FFD0C0C2FFC6B0A4FFC3A37FFFCFA973FFDDB06DFFE1B46AFFE4B768FF
              A9ACA4FF19120DFF100C08FF2F231AFF42362BFF5A5148FF75726DFF939594FF
              B0B9BEFFC4D2DDFFD0DDEBFFC4CCD6FFB2B6B2FFAFA893FFB5A177FFC6AA70FF
              A0A39EFF140E0AFF000000FF000000FF000000FF000000FF000000FF070503FF
              140E0AFF251B14FF392E24FF52473EFF6B655FFF848685FF98A2A3FFADBBB8FF
              8B9496FF0F0B07FF000000FF000000FF000000FF000000FF000000FF000000FF
              000000FF000000FF000000FF000000FF000000FF040302FF100B08FF1F1711FF
              2B2018FF050303FF}
            BitmapAlign = baCenter
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 0
          end
          object rdoIcon32: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 4
            Width = 72
            Height = 17
            Margins.Left = 5
            Margins.Top = 4
            Caption = '32x32'
            TabOrder = 1
            Checked = True
            State = cbChecked
            Align = alTop
            OnClick = rdoIconCustomClick
          end
        end
        object SharpERoundPanel2: TSharpERoundPanel
          Left = 86
          Top = 0
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
            AutoSize = True
            Bitmap.ResamplerClassName = 'TKernelResampler'
            Bitmap.Resampler.KernelClassName = 'TBoxKernel'
            Bitmap.Resampler.KernelMode = kmDynamic
            Bitmap.Resampler.TableSize = 32
            BitmapAlign = baCenter
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 0
          end
          object rdoIcon48: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 4
            Width = 72
            Height = 17
            Margins.Left = 5
            Margins.Top = 4
            Caption = '48x48'
            TabOrder = 1
            TabStop = False
            Align = alTop
            OnClick = rdoIconCustomClick
          end
        end
        object SharpERoundPanel3: TSharpERoundPanel
          Left = 169
          Top = 0
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
            AutoSize = True
            Bitmap.ResamplerClassName = 'TKernelResampler'
            Bitmap.Resampler.KernelClassName = 'TBoxKernel'
            Bitmap.Resampler.KernelMode = kmDynamic
            Bitmap.Resampler.TableSize = 32
            BitmapAlign = baCenter
            Scale = 1.000000000000000000
            ScaleMode = smNormal
            TabOrder = 0
          end
          object rdoIcon64: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 4
            Width = 72
            Height = 17
            Margins.Left = 5
            Margins.Top = 4
            Caption = '64x64'
            TabOrder = 1
            TabStop = False
            Align = alTop
            OnClick = rdoIconCustomClick
          end
        end
        object SharpERoundPanel4: TSharpERoundPanel
          Left = 255
          Top = 0
          Width = 119
          Height = 82
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
          object sgbIconSize: TSharpeGaugeBox
            AlignWithMargins = True
            Left = 3
            Top = 27
            Width = 113
            Height = 22
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
            BackgroundColor = clWindow
          end
          object rdoIconCustom: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 4
            Width = 111
            Height = 17
            Margins.Left = 5
            Margins.Top = 4
            Caption = 'Custom'
            TabOrder = 0
            TabStop = False
            Align = alTop
            OnClick = rdoIconCustomClick
          end
        end
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 208
        Width = 585
        Height = 22
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 2
        object sgbColorBlend: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 250
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Constraints.MaxWidth = 534
          ParentBackground = False
          Min = 1
          Max = 255
          Value = 192
          Suffix = '% blended'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = SendUpdateEvent
          BackgroundColor = clWindow
        end
      end
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 309
        Width = 585
        Height = 22
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 3
        object sgbIconShadow: TSharpeGaugeBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 250
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Constraints.MaxWidth = 534
          ParentBackground = False
          Min = 1
          Max = 255
          Value = 192
          Suffix = '% visible'
          Description = 'Adjust to set the transparency'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = SendUpdateEvent
          BackgroundColor = clWindow
        end
      end
      object Panel10: TPanel
        Left = 0
        Top = 479
        Width = 595
        Height = 112
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 4
        object sceIconColor: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 1
          Top = 0
          Width = 589
          Height = 102
          Margins.Left = 1
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clBlack
          ParentBackground = True
          ParentColor = False
          TabOrder = 0
          Items = <
            item
              Title = 'Blend Colour'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = sceIconColor.Item0
              Tag = 0
            end
            item
              Title = 'Icon Shadow Colour'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = sceIconColor.Item1
              Tag = 0
            end>
          SwatchManager = SharpESwatchManager1
          OnUiChange = UpdateColorChangeEvent
          BorderColor = clBlack
          BackgroundColor = clBlack
          BackgroundTextColor = clBlack
          ContainerColor = clBlack
          ContainerTextColor = clBlack
        end
      end
      object SharpECenterHeader5: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Icon Size'
        Description = 'Define the default icon size for desktop icons'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader6: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 341
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Icon Visibility'
        Description = 'Define the visibility of the icon'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader7: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 139
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Icon Blend'
        Description = 'Define the amount of colour blend applied to the icon'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader8: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 240
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Icon Shadow'
        Description = 'Define the visiblity of the icon shadow'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader9: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 442
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Icon Colour'
        Description = 'Define various icon specific colours'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object chkColorBlend: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 186
        Width = 585
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Colour blend the icon'
        TabOrder = 7
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = UpdateIcontPageEvent
      end
      object chkIconShadow: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 287
        Width = 585
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Apply an icon shadow'
        TabOrder = 9
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = UpdateIcontPageEvent
      end
      object chkIconTrans: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 388
        Width = 585
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Apply icon visibility'
        TabOrder = 11
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = UpdateIcontPageEvent
      end
    end
    object pagFont: TJvStandardPage
      Left = 0
      Top = 0
      Width = 595
      Height = 591
      object sceFontColor: TSharpEColorEditorEx
        AlignWithMargins = True
        Left = 1
        Top = 376
        Width = 589
        Height = 157
        Margins.Left = 1
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alTop
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBlack
        ParentBackground = True
        ParentColor = False
        TabOrder = 0
        Items = <
          item
            Title = 'Font Colour'
            ColorCode = 0
            ColorAsTColor = clBlack
            Expanded = False
            ValueEditorType = vetColor
            Value = 0
            ValueMin = 0
            ValueMax = 255
            Visible = True
            DisplayPercent = False
            ColorEditor = sceFontColor.Item0
            Tag = 0
          end>
        SwatchManager = SharpESwatchManager1
        OnUiChange = UpdateColorChangeEvent
        BorderColor = clBlack
        BackgroundColor = clBlack
        BackgroundTextColor = clBlack
        ContainerColor = clBlack
        ContainerTextColor = clBlack
      end
      object cboFontName: TComboBox
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 580
        Height = 23
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        Style = csOwnerDrawVariable
        Constraints.MaxWidth = 250
        DropDownCount = 12
        ItemHeight = 17
        TabOrder = 1
        OnChange = cboFontNameChange
        OnDrawItem = cboFontNameDrawItem
      end
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 127
        Width = 580
        Height = 22
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 2
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
          Value = 10
          Suffix = ' px'
          Description = 'Change font size'
          PopPosition = ppBottom
          PercentDisplay = False
          OnChangeValue = SendUpdateEvent
          BackgroundColor = clWindow
        end
      end
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 228
        Width = 585
        Height = 22
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 3
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
          Min = 0
          Max = 255
          Value = 0
          Suffix = '% visible'
          Description = 'Change font opacity'
          PopPosition = ppBottom
          PercentDisplay = True
          OnChangeValue = SendUpdateEvent
          BackgroundColor = clWindow
        end
      end
      object SharpECenterHeader10: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Font Type'
        Description = 'Define the font face for the desktop'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader11: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 80
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Font Size'
        Description = 'Define the type face size'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader12: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 159
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Font Visibility'
        Description = 'Define how visible the font is on the desktop'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object SharpECenterHeader13: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 260
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Font Style'
        Description = 'Define styles applied to the font'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object Panel8: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 307
        Width = 585
        Height = 22
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 9
        object chkBold: TJvXPCheckbox
          Left = 0
          Top = 3
          Width = 69
          Height = 17
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 0
          Caption = 'Bold'
          TabOrder = 0
          OnClick = FontStyleCheckEvent
        end
        object chkItalic: TJvXPCheckbox
          AlignWithMargins = True
          Left = 67
          Top = 3
          Width = 68
          Height = 17
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Italic'
          TabOrder = 1
          OnClick = FontStyleCheckEvent
        end
        object chkUnderline: TJvXPCheckbox
          Left = 137
          Top = 3
          Width = 89
          Height = 17
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'Underline'
          TabOrder = 2
          OnClick = FontStyleCheckEvent
        end
      end
      object SharpECenterHeader14: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 339
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Font Colour'
        Description = 'Define the font face colour'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object chkFontTrans: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 206
        Width = 585
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Apply font opacity'
        TabOrder = 4
        Align = alTop
        OnClick = UpdateFontPageEvent
      end
    end
    object pagAnimation: TJvStandardPage
      Left = 0
      Top = 0
      Width = 595
      Height = 591
      object pnlAnim: TPanel
        Left = 0
        Top = 74
        Width = 595
        Height = 517
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object Panel9: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 4
          Width = 595
          Height = 493
          Margins.Left = 0
          Margins.Top = 4
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 0
          object Panel12: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 271
            Width = 585
            Height = 22
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 10
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 0
            Visible = False
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
              Prefix = 'Change scale by '
              Suffix = ' px'
              Description = 'Adjust to set the scale size'
              PopPosition = ppBottom
              PercentDisplay = False
              OnChangeValue = SendUpdateEvent
              BackgroundColor = clWindow
            end
          end
          object Panel13: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 170
            Width = 585
            Height = 22
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 10
            Align = alTop
            AutoSize = True
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
              Prefix = 'Change brightness by '
              Suffix = '%'
              Description = 'Adjust to set the brightness modification value'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = SendUpdateEvent
              BackgroundColor = clWindow
            end
          end
          object Panel14: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 372
            Width = 585
            Height = 22
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
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
              Prefix = 'Change blend by '
              Suffix = '%'
              Description = 'Adjust to set the color blend strength'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = SendUpdateEvent
              BackgroundColor = clWindow
            end
          end
          object Panel15: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 69
            Width = 580
            Height = 22
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alTop
            AutoSize = True
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
              Prefix = 'Change visibility by '
              Suffix = '%'
              Description = 'Adjust to set the alpha modification value'
              PopPosition = ppBottom
              PercentDisplay = True
              OnChangeValue = SendUpdateEvent
              BackgroundColor = clWindow
            end
          end
          object sceAnimColor: TSharpEColorEditorEx
            AlignWithMargins = True
            Left = 1
            Top = 399
            Width = 589
            Height = 94
            Margins.Left = 1
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 0
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clBlack
            ParentBackground = True
            ParentColor = False
            TabOrder = 8
            Items = <
              item
                Title = 'Blend Colour'
                ColorCode = 0
                ColorAsTColor = clBlack
                Expanded = False
                ValueEditorType = vetColor
                Value = 0
                ValueMin = 0
                ValueMax = 255
                Visible = True
                DisplayPercent = False
                ColorEditor = sceAnimColor.Item0
                Tag = 0
              end>
            SwatchManager = SharpESwatchManager1
            OnUiChange = UpdateColorChangeEvent
            BorderColor = clBlack
            BackgroundColor = clBlack
            BackgroundTextColor = clBlack
            ContainerColor = clBlack
            ContainerTextColor = clBlack
          end
          object SharpECenterHeader16: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 585
            Height = 37
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Title = 'Animation Visibility'
            Description = 'Define desktop icon animation transparency'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
          end
          object SharpECenterHeader17: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 101
            Width = 585
            Height = 37
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Title = 'Animation Brightness'
            Description = 'Define desktop icon brightness animation'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
          end
          object SharpECenterHeader18: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 202
            Width = 585
            Height = 37
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Title = 'Animation Scale'
            Description = 'Define desktop icon scale animation'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Visible = False
            Align = alTop
          end
          object SharpECenterHeader19: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 303
            Width = 585
            Height = 37
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Title = 'Animation Colour Blend'
            Description = 'Define desktop icon colour blend animation'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
          end
          object chkAnimTrans: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 47
            Width = 580
            Height = 17
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 5
            Caption = 'Apply animation transparency'
            TabOrder = 1
            Align = alTop
            OnClick = UpdateAnimationPageEvent
          end
          object chkAnimSize: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 249
            Width = 585
            Height = 17
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 0
            Caption = 'Apply animation scale'
            TabOrder = 2
            Align = alTop
            Visible = False
            OnClick = UpdateAnimationPageEvent
          end
          object chkAnimBrightness: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 148
            Width = 585
            Height = 17
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 0
            Caption = 'Apply animation brightness'
            TabOrder = 4
            Align = alTop
            OnClick = UpdateAnimationPageEvent
          end
          object chkAnimColorBlend: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 350
            Width = 585
            Height = 17
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 0
            Caption = 'Apply animation colour blend'
            TabOrder = 5
            Align = alTop
            OnClick = UpdateAnimationPageEvent
          end
        end
      end
      object SharpECenterHeader15: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Animation'
        Description = 'Define desktop icon animated effects'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object chkAnim: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 580
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = 'Apply desktop icon animation'
        TabOrder = 2
        Align = alTop
        OnClick = UpdateAnimationPageEvent
      end
    end
    object pagFontShadow: TJvStandardPage
      Left = 0
      Top = 0
      Width = 595
      Height = 591
      Caption = 'pagFontShadow'
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 585
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Title = 'Font Shadow'
        Description = 'Define whether the desktop font has a shadow applied'
        TitleColor = clWindowText
        DescriptionColor = clRed
        Align = alTop
      end
      object pnlTextShadow: TPanel
        Left = 0
        Top = 74
        Width = 595
        Height = 361
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 2
        object SharpECenterHeader2: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 585
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Font Shadow Type'
          Description = 'Define the type of shadow effect to apply to the font'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader3: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 78
          Width = 585
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Font Shadow Visiblity'
          Description = 'Define how visible the font shadow is'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object Panel11: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 125
          Width = 580
          Height = 22
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
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
            Min = 0
            Max = 255
            Value = 0
            Suffix = '% visible'
            Description = 'Transparency'
            PopPosition = ppBottom
            PercentDisplay = True
            OnChangeValue = SendUpdateEvent
            BackgroundColor = clWindow
          end
        end
        object SharpECenterHeader4: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 157
          Width = 585
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Font Shadow Colour'
          Description = 'Define the font shadow colour'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object sceShadowColor: TSharpEColorEditorEx
          AlignWithMargins = True
          Left = 1
          Top = 194
          Width = 584
          Height = 157
          Margins.Left = 1
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 10
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alTop
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clBlack
          ParentBackground = True
          ParentColor = False
          TabOrder = 4
          Items = <
            item
              Title = 'Shadow Colour'
              ColorCode = 0
              ColorAsTColor = clBlack
              Expanded = False
              ValueEditorType = vetColor
              Value = 0
              ValueMin = 0
              ValueMax = 255
              Visible = True
              DisplayPercent = False
              ColorEditor = sceShadowColor.Item0
              Tag = 0
            end>
          SwatchManager = SharpESwatchManager1
          OnUiChange = UpdateColorChangeEvent
          BorderColor = clBlack
          BackgroundColor = clBlack
          BackgroundTextColor = clBlack
          ContainerColor = clBlack
          ContainerTextColor = clBlack
        end
        object Panel6: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 47
          Width = 580
          Height = 21
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 5
          object cboFontShadowType: TComboBox
            Left = 0
            Top = 0
            Width = 250
            Height = 21
            Margins.Left = 28
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alLeft
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 0
            Text = 'Left Shadow'
            OnChange = cboFontShadowTypeChange
            Items.Strings = (
              'Left Shadow'
              'Right Shadow'
              'Outline Glow')
            ExplicitTop = 2
          end
        end
      end
      object chkFontShadow: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 580
        Height = 17
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = 'Apply font shadow'
        TabOrder = 0
        Align = alTop
        OnClick = UpdateFontshadowPageEvent
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 551
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
