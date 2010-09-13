object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 658
  ClientWidth = 445
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 30
    Width = 445
    Height = 628
    ActivePage = pagDrive
    PropagateEnable = False
    Align = alClient
    object pagDrive: TJvStandardPage
      Left = 0
      Top = 0
      Width = 445
      Height = 628
      object pnlDrive: TPanel
        Left = 1
        Top = 1
        Width = 443
        Height = 153
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object Panel69: TPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 153
          Align = alTop
          BevelOuter = bvNone
          Ctl3D = True
          ParentColor = True
          ParentCtl3D = False
          TabOrder = 0
          object SharpECenterHeader1: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 85
            Width = 433
            Height = 37
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Title = 'Link Caption'
            Description = 'Define the icon caption for this object'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
            ExplicitTop = 83
          end
          object chkCaption: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 132
            Width = 433
            Height = 17
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Caption = 'Display Caption'
            TabOrder = 0
            Align = alTop
            OnClick = chkCaptionClick
            ExplicitTop = 121
          end
          object SharpECenterHeader2: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 433
            Height = 75
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Title = 'Drive'
            Description = 'Specify drive related options'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
            object cbDriveList: TComboBox
              Left = 148
              Top = 50
              Width = 266
              Height = 23
              ItemHeight = 15
              TabOrder = 0
              OnSelect = cbDriveListSelect
            end
            object StaticText1: TStaticText
              Left = 5
              Top = 56
              Width = 68
              Height = 19
              Caption = 'Select Drive:'
              TabOrder = 1
            end
          end
        end
      end
    end
    object pagIcon: TJvStandardPage
      Left = 0
      Top = 0
      Width = 445
      Height = 628
      object pnlIcon: TPanel
        Left = 1
        Top = 1
        Width = 443
        Height = 557
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object Panel1: TPanel
          Left = 0
          Top = 275
          Width = 443
          Height = 52
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 2
          object uicIconAlpha: TSharpEUIC
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 435
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'uicIconAlpha'
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            HasChanged = True
            AutoReset = False
            MonitorControl = chkIconAlpha
            OnReset = uicIconBlendReset
            object chkIconAlpha: TJvXPCheckbox
              Left = 0
              Top = 0
              Width = 141
              Height = 21
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 50
              Margins.Bottom = 2
              Caption = 'Apply icon visibility'
              TabOrder = 0
              Checked = True
              State = cbChecked
              Align = alLeft
              OnClick = chkIconAlphaClick
            end
          end
          object uicIconAlphaValue: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 30
            Width = 433
            Height = 22
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'uicIconAlphaValue'
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            HasChanged = True
            AutoReset = False
            MonitorControl = sgbIconAlpha
            OnReset = uicIconBlendReset
            object sgbIconAlpha: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 250
              Height = 22
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 4
              Margins.Bottom = 2
              Align = alLeft
              ParentBackground = False
              TabOrder = 0
              Min = 16
              Max = 255
              Value = 192
              Suffix = '% visible'
              Description = 'Adjust to set the transparency'
              PopPosition = ppBottom
              PercentDisplay = True
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = sgbIconAlphaChangeValue
              BackgroundColor = clWindow
            end
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 47
          Width = 443
          Height = 82
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 0
          object uicIconSize: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 433
            Height = 82
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'uicIconSize'
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            HasChanged = True
            AutoReset = False
            OnReset = uicIconSizeReset
            object SharpERoundPanel1: TSharpERoundPanel
              Left = 3
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
              NoBottomBorder = False
              RoundValue = 10
              BorderColor = clBtnFace
              Border = True
              BackgroundColor = clWindow
              BottomSideBorder = False
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
                TabOrder = 1
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
                TabOrder = 0
                Checked = True
                State = cbChecked
                Align = alTop
                OnClick = rdoIcon32Click
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
              NoBottomBorder = False
              RoundValue = 10
              BorderColor = clBtnFace
              Border = True
              BackgroundColor = clWindow
              BottomSideBorder = False
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
                TabOrder = 1
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
                TabOrder = 0
                Align = alTop
                OnClick = rdoIcon48Click
              end
            end
            object SharpERoundPanel3: TSharpERoundPanel
              Left = 172
              Top = 1
              Width = 80
              Height = 73
              BevelOuter = bvNone
              Caption = 'SharpERoundPanel1'
              Color = clWhite
              ParentBackground = False
              TabOrder = 2
              DrawMode = srpNormal
              NoTopBorder = False
              NoBottomBorder = False
              RoundValue = 10
              BorderColor = clBtnFace
              Border = True
              BackgroundColor = clWindow
              BottomSideBorder = False
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
                TabOrder = 1
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
                TabOrder = 0
                Align = alTop
                OnClick = rdoIcon64Click
              end
            end
            object SharpERoundPanel4: TSharpERoundPanel
              Left = 258
              Top = 0
              Width = 130
              Height = 82
              BevelOuter = bvNone
              Caption = 'SharpERoundPanel1'
              Color = clWhite
              ParentBackground = False
              TabOrder = 3
              DrawMode = srpNormal
              NoTopBorder = False
              NoBottomBorder = False
              RoundValue = 10
              BorderColor = clWindow
              Border = False
              BackgroundColor = clWindow
              BottomSideBorder = False
              object sgbIconSize: TSharpeGaugeBox
                AlignWithMargins = True
                Left = 7
                Top = 27
                Width = 113
                Height = 22
                ParentBackground = False
                TabOrder = 1
                Min = 12
                Max = 256
                Value = 96
                Prefix = 'Icon Size: '
                Suffix = 'px'
                Description = 'Adjust to set the icon size'
                PopPosition = ppBottom
                PercentDisplay = False
                MaxPercent = 100
                Formatting = '%d'
                OnChangeValue = sgbIconSizeChangeValue
                BackgroundColor = clWindow
              end
              object rdoIconCustom: TJvXPCheckbox
                AlignWithMargins = True
                Left = 5
                Top = 4
                Width = 122
                Height = 17
                Margins.Left = 5
                Margins.Top = 4
                Caption = 'Custom'
                TabOrder = 0
                Align = alTop
                OnClick = rdoIconCustomClick
              end
            end
          end
        end
        object Panel6: TPanel
          Left = 0
          Top = 176
          Width = 443
          Height = 52
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 1
          object uicIconBlend: TSharpEUIC
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 435
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'uicIconBlend'
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            HasChanged = True
            AutoReset = False
            MonitorControl = chkIconBlendAlpha
            OnReset = uicIconBlendReset
            object chkIconBlendAlpha: TJvXPCheckbox
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 141
              Height = 21
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 50
              Margins.Bottom = 0
              Caption = 'Colour blend the icon'
              TabOrder = 0
              Checked = True
              State = cbChecked
              Align = alLeft
              OnClick = chkIconBlendAlphaClick
            end
          end
          object uicIconBlendAlpha: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 30
            Width = 433
            Height = 22
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'uicIconBlendAlpha'
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            HasChanged = True
            AutoReset = False
            MonitorControl = sgbIconBlendAlpha
            OnReset = uicIconBlendReset
            object sgbIconBlendAlpha: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 250
              Height = 22
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 4
              Margins.Bottom = 2
              Align = alLeft
              ParentBackground = False
              TabOrder = 0
              Min = 16
              Max = 255
              Value = 192
              Suffix = '% blended'
              Description = 'Adjust to set the transparency'
              PopPosition = ppBottom
              PercentDisplay = True
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = sgbIconBlendAlphaChangeValue
              BackgroundColor = clWindow
            end
          end
        end
        object Panel7: TPanel
          Left = 0
          Top = 379
          Width = 443
          Height = 52
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 3
          object uicIconShadow: TSharpEUIC
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 435
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            HasChanged = True
            AutoReset = False
            MonitorControl = chkIconShadowAlpha
            OnReset = uicIconBlendReset
            object chkIconShadowAlpha: TJvXPCheckbox
              Left = 0
              Top = 0
              Width = 141
              Height = 21
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 50
              Margins.Bottom = 2
              Caption = 'Apply an icon shadow'
              TabOrder = 0
              Checked = True
              State = cbChecked
              Align = alLeft
              OnClick = chkIconShadowAlphaClick
            end
          end
          object uicIconShadowAlpha: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 30
            Width = 433
            Height = 22
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'uicIconShadowAlpha'
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            HasChanged = True
            AutoReset = False
            MonitorControl = sgbIconShadowAlpha
            OnReset = uicIconBlendReset
            object sgbIconShadowAlpha: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 250
              Height = 22
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 4
              Margins.Bottom = 2
              Align = alLeft
              ParentBackground = False
              TabOrder = 0
              Min = 16
              Max = 255
              Value = 192
              Suffix = '% visible'
              Description = 'Adjust to set the transparency'
              PopPosition = ppBottom
              PercentDisplay = True
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = sgbIconShadowAlphaChangeValue
              BackgroundColor = clWindow
            end
          end
        end
        object SharpECenterHeader3: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 238
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Icon Visibility'
          Description = 'Define the visibility of the icon'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader5: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Icon Size'
          Description = 'Define the default icon size for desktop icons'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader7: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 134
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Title = 'Icon Blend'
          Description = 'Define the amount of colour blend applied to the icon'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader8: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 337
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 5
          Title = 'Icon Shadow'
          Description = 'Define the visiblity of the icon shadow'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader9: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 441
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Title = 'Icon Colour'
          Description = 'Define various icon specific colours'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object uicIconBlendColor: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 488
          Width = 433
          Height = 32
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicIconBlendColor'
          Color = clWhite
          ParentBackground = False
          TabOrder = 4
          HasChanged = True
          AutoReset = False
          MonitorControl = sceIconBlendColor
          OnReset = uicIconBlendReset
          object sceIconBlendColor: TSharpEColorEditorEx
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 401
            Height = 32
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 32
            Margins.Bottom = 0
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            Align = alTop
            AutoSize = True
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clBlack
            Ctl3D = True
            ParentBackground = True
            ParentColor = False
            ParentCtl3D = False
            TabOrder = 0
            OnResize = sceIconBlendColorResize
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
                ColorEditor = sceIconBlendColor.Item0
                Tag = 0
              end>
            SwatchManager = SharpESwatchManager1
            OnChangeColor = sceIconBlendColorChangeColor
            BorderColor = clBlack
            BackgroundColor = clBlack
            BackgroundTextColor = clBlack
            ContainerColor = clBlack
            ContainerTextColor = clBlack
          end
        end
        object uicIconShadowColor: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 520
          Width = 433
          Height = 32
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'SharpEUIC1'
          Color = clWhite
          ParentBackground = False
          TabOrder = 5
          HasChanged = True
          AutoReset = False
          MonitorControl = sceIconShadowColor
          OnReset = uicIconBlendReset
          object sceIconShadowColor: TSharpEColorEditorEx
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 401
            Height = 32
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 32
            Margins.Bottom = 0
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            Align = alTop
            AutoSize = True
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clBlack
            ParentBackground = True
            ParentColor = False
            TabOrder = 0
            OnResize = sceIconShadowColorResize
            Items = <
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
                ColorEditor = sceIconShadowColor.Item0
                Tag = 0
              end>
            SwatchManager = SharpESwatchManager1
            OnChangeColor = sceIconShadowColorChangeColor
            BorderColor = clBlack
            BackgroundColor = clBlack
            BackgroundTextColor = clBlack
            ContainerColor = clBlack
            ContainerTextColor = clBlack
          end
        end
      end
    end
    object pagFont: TJvStandardPage
      Left = 0
      Top = 0
      Width = 445
      Height = 628
      object pnlFont: TPanel
        Left = 1
        Top = 1
        Width = 443
        Height = 477
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object uicFontName: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 47
          Width = 433
          Height = 27
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicDesktopFontName'
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          HasChanged = True
          AutoReset = False
          MonitorControl = cboFontName
          OnReset = uicFontNameReset
          object cboFontName: TComboBox
            Left = 0
            Top = 0
            Width = 250
            Height = 23
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alLeft
            Style = csOwnerDrawVariable
            Constraints.MaxWidth = 250
            DropDownCount = 12
            ItemHeight = 17
            TabOrder = 0
            OnChange = cboFontNameChange
            OnDrawItem = cboFontNameDrawItem
          end
        end
        object uicTextAlpha: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 210
          Width = 433
          Height = 21
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicTextAlpha'
          Color = clWhite
          ParentBackground = False
          TabOrder = 2
          HasChanged = True
          AutoReset = False
          MonitorControl = chkTextAlpha
          OnReset = uicTextAlphaReset
          object chkTextAlpha: TJvXPCheckbox
            Left = 0
            Top = 0
            Width = 149
            Height = 21
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 48
            Margins.Bottom = 2
            Caption = 'Apply font opacity'
            TabOrder = 0
            Align = alLeft
            OnClick = chkTextAlphaClick
          end
        end
        object uicTextAlphaValue: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 236
          Width = 433
          Height = 22
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicTextAlpha'
          Color = clWhite
          ParentBackground = False
          TabOrder = 3
          HasChanged = True
          AutoReset = False
          MonitorControl = sgbTextAlphaValue
          OnReset = uicFontNameReset
          object sgbTextAlphaValue: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 250
            Height = 22
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 4
            Margins.Bottom = 2
            Align = alLeft
            ParentBackground = False
            TabOrder = 0
            Min = 0
            Max = 255
            Value = 0
            Suffix = '% Visible'
            Description = 'Change font opacity'
            PopPosition = ppBottom
            PercentDisplay = True
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgbTextAlphaValueChangeValue
            BackgroundColor = clWindow
          end
        end
        object uicTextBold: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 367
          Width = 433
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicTextBold'
          Color = clWhite
          ParentBackground = False
          TabOrder = 6
          HasChanged = True
          AutoReset = False
          MonitorControl = chkTextBold
          OnReset = uicFontNameReset
          object chkTextBold: TJvXPCheckbox
            Left = 0
            Top = 0
            Width = 364
            Height = 21
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 48
            Margins.Bottom = 2
            Caption = 'Bold'
            TabOrder = 0
            Align = alLeft
            OnClick = chkTextBoldClick
          end
        end
        object uicTextColor: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 445
          Width = 433
          Height = 32
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicTextColor'
          Color = clWhite
          ParentBackground = False
          TabOrder = 7
          HasChanged = True
          AutoReset = False
          MonitorControl = sceTextColor
          OnReset = uicFontNameReset
          object sceTextColor: TSharpEColorEditorEx
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 401
            Height = 32
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 32
            Margins.Bottom = 0
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            Align = alTop
            AutoSize = True
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clBlack
            ParentBackground = True
            ParentColor = False
            TabOrder = 0
            OnResize = sceTextColorResize
            Items = <
              item
                Title = 'Text'
                ColorCode = 0
                ColorAsTColor = clBlack
                Expanded = False
                ValueEditorType = vetColor
                Value = 0
                ValueMin = 0
                ValueMax = 255
                Visible = True
                DisplayPercent = False
                ColorEditor = sceTextColor.Item0
                Tag = 0
              end>
            SwatchManager = SharpESwatchManager1
            OnChangeColor = sceTextColorChangeColor
            BorderColor = clBlack
            BackgroundColor = clBlack
            BackgroundTextColor = clBlack
            ContainerColor = clBlack
            ContainerTextColor = clBlack
          end
        end
        object uicTextItalic: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 341
          Width = 433
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'UICBold'
          Color = clWhite
          ParentBackground = False
          TabOrder = 5
          HasChanged = True
          AutoReset = False
          MonitorControl = chkTextItalic
          OnReset = uicFontNameReset
          object chkTextItalic: TJvXPCheckbox
            Left = 0
            Top = 0
            Width = 364
            Height = 21
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 48
            Margins.Bottom = 2
            Caption = 'Italic'
            TabOrder = 0
            Align = alLeft
            OnClick = chkTextItalicClick
          end
        end
        object uicTextSize: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 131
          Width = 433
          Height = 22
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicTextSize'
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          HasChanged = True
          AutoReset = False
          MonitorControl = sgbTextSize
          OnReset = uicFontNameReset
          object sgbTextSize: TSharpeGaugeBox
            Left = 0
            Top = 0
            Width = 250
            Height = 22
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 4
            Margins.Bottom = 2
            Align = alLeft
            ParentBackground = False
            TabOrder = 0
            Min = 6
            Max = 24
            Value = 0
            Suffix = ' px'
            Description = 'Change font size'
            PopPosition = ppBottom
            PercentDisplay = False
            MaxPercent = 100
            Formatting = '%d'
            OnChangeValue = sgbTextSizeChangeValue
            BackgroundColor = clWindow
          end
        end
        object uicTextUnderline: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 315
          Width = 433
          Height = 21
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicTextUnderline'
          Color = clWhite
          ParentBackground = False
          TabOrder = 4
          HasChanged = True
          AutoReset = False
          MonitorControl = chkTextUnderline
          OnReset = uicFontNameReset
          object chkTextUnderline: TJvXPCheckbox
            Left = 0
            Top = 0
            Width = 364
            Height = 21
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 48
            Margins.Bottom = 2
            Caption = 'Underline'
            TabOrder = 0
            Align = alLeft
            OnClick = chkTextUnderlineClick
          end
        end
        object SharpECenterHeader13: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Font Type'
          Description = 'Define the font face for the desktop'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader14: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 84
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Font Size'
          Description = 'Define the type face size'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader15: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 163
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Font Visibility'
          Description = 'Define how visible the font is on the desktop'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader16: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 268
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Font Style'
          Description = 'Define styles applied to the font'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader17: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 398
          Width = 433
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Font Colour'
          Description = 'Define the font face colour'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
      end
    end
    object pagFontShadow: TJvStandardPage
      Left = 0
      Top = 0
      Width = 445
      Height = 628
      Caption = 'pagFontShadow'
      object pnlFontShadow: TPanel
        Left = 1
        Top = 1
        Width = 443
        Height = 314
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object pnlTextShadow: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 68
          Width = 443
          Height = 246
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object SharpECenterHeader10: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 10
            Width = 433
            Height = 37
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 10
            Title = 'Font Shadow Type'
            Description = 'Define the type of shadow effect to apply to the font'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
          end
          object uicTextShadowType: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 57
            Width = 433
            Height = 21
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            HasChanged = True
            AutoReset = False
            MonitorControl = cboTextShadowType
            OnReset = uicTextShadowTypeReset
            object cboTextShadowType: TComboBox
              Left = 0
              Top = 0
              Width = 250
              Height = 21
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 4
              Margins.Bottom = 2
              Align = alLeft
              Style = csDropDownList
              ItemHeight = 13
              ItemIndex = 0
              TabOrder = 0
              Text = 'Left Shadow'
              OnChange = cboTextShadowTypeChange
              Items.Strings = (
                'Left Shadow'
                'Right Shadow'
                'Outline Glow')
            end
          end
          object SharpECenterHeader11: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 88
            Width = 433
            Height = 37
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 10
            Title = 'Font Shadow Visiblity'
            Description = 'Define how visible the font shadow is'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
          end
          object uicTextShadowAlpha: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 135
            Width = 433
            Height = 22
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 3
            HasChanged = True
            AutoReset = False
            MonitorControl = sgbTextShadowAlpha
            OnReset = uicTextShadowTypeReset
            object sgbTextShadowAlpha: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 250
              Height = 22
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 4
              Margins.Bottom = 2
              Align = alLeft
              Constraints.MaxWidth = 532
              ParentBackground = False
              TabOrder = 0
              Min = 0
              Max = 255
              Value = 0
              Suffix = '% visible'
              Description = 'Change shadow opacity'
              PopPosition = ppBottom
              PercentDisplay = True
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = sgbTextShadowAlphaChangeValue
              BackgroundColor = clWindow
            end
          end
          object SharpECenterHeader12: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 167
            Width = 433
            Height = 37
            Margins.Left = 5
            Margins.Top = 10
            Margins.Right = 5
            Margins.Bottom = 10
            Title = 'Font Shadow Colour'
            Description = 'Define the font shadow colour'
            TitleColor = clWindowText
            DescriptionColor = clRed
            Align = alTop
          end
          object uicTextShadowColor: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 214
            Width = 433
            Height = 32
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'uicTextShadowColor'
            Color = clWhite
            ParentBackground = False
            TabOrder = 5
            HasChanged = True
            AutoReset = False
            MonitorControl = sceTextShadowColor
            OnReset = uicTextShadowReset
            object sceTextShadowColor: TSharpEColorEditorEx
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 401
              Height = 32
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 32
              Margins.Bottom = 0
              VertScrollBar.Smooth = True
              VertScrollBar.Tracking = True
              Align = alTop
              AutoSize = True
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Color = clBlack
              ParentBackground = True
              ParentColor = False
              TabOrder = 0
              OnResize = sceTextShadowColorResize
              Items = <
                item
                  Title = 'Shadow'
                  ColorCode = 0
                  ColorAsTColor = clBlack
                  Expanded = False
                  ValueEditorType = vetColor
                  Value = 0
                  ValueMin = 0
                  ValueMax = 255
                  Visible = True
                  DisplayPercent = False
                  ColorEditor = sceTextShadowColor.Item0
                  Tag = 0
                end>
              SwatchManager = SharpESwatchManager1
              OnChangeColor = sceTextShadowColorChangeColor
              BorderColor = clBlack
              BackgroundColor = clBlack
              BackgroundTextColor = clBlack
              ContainerColor = clBlack
              ContainerTextColor = clBlack
            end
          end
        end
        object uicTextShadow: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 47
          Width = 433
          Height = 21
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'uicTextShadow'
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          HasChanged = True
          AutoReset = False
          MonitorControl = chkTextShadow
          OnReset = uicTextShadowReset
          object chkTextShadow: TJvXPCheckbox
            Left = 0
            Top = 0
            Width = 113
            Height = 21
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 48
            Margins.Bottom = 2
            Caption = 'Font Shadow'
            TabOrder = 0
            Align = alLeft
            OnClick = chkTextShadowClick
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
          Margins.Bottom = 10
          Title = 'Font Shadow'
          Description = 'Define whether the desktop font has a shadow applied'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
      end
    end
  end
  object pnlOverride: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 440
    Height = 25
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 20
      Height = 25
      Align = alLeft
      Center = True
      Picture.Data = {
        0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001000
        00001008060000001FF3FF610000000467414D410000AFC837058AE900000019
        74455874536F6674776172650041646F626520496D616765526561647971C965
        3C000002DE4944415478DAA5936D48935114C7FF8FAFB939B569E566A66E0E09
        5F52D1FAB01484243045D028B050F04B5129FA21B21714853E242488A4465128
        BD510D47504465465343372A34CB395F524B4D5D6A5337F7BCDCEE1ECB0F995F
        EAC0E5C2BDF7FCCE39FF7B0E4308C1FF18F32720A7D1AC66052E8F7042FE8A93
        0DE6880002610A109A798EBF6338AB1DDA1090DDF029D7E964EB22FC89627758
        00FCBCDCC5F3053B0783E51B7A271627A94791B16A9F6E1D20ABBE2FD769679B
        D2351269CC7619BECE3A31B560072F10F84BDCA1F4DF04CBAC0D2DAD834BF040
        81B1365BB706C8ACEB55B12C67488F942AA31432740FCF83E358EC0ADB0CD0FB
        B7237360DC18442B7C313E6783FED9C004889062BC76785804ECAF7D571E2125
        9599F14A749AADE0594E8C5C752446CCEEFCEDF714047879B8212E4C8E27DD66
        987B662A4CB78E568980B41A93253F6E4BE4A29DC59875913A53E1E84A54CB5D
        7EE81A985C2D98BE5506FA41EEEF8D1BD73B068DF70B3522407BB163F9747AB8
        4FB7791676270796672980C795E35A1170A2DE200269C5F0F460901A1B8A4B35
        8FED26DD498908482E6F5B3E97A1F1793360C5927D913E26AE603875201AE1DB
        64286DA4007AE08279D28F494B52A1BAFA91DDA42FFE0D786139961A1E695D70
        627CE607789A8140231665C522225886E2BA57347D573F106C0D942124C40FCD
        575B078D2D25AB2524973D2DDFA9F0AECC4850A1FDC3172A228F6C6D38D21343
        E146D5EF199AC1E57B5D2E11A08D57A1B5D38C918FA315C696D25511934B5A54
        58E10C99691A65845C8AF6BE7170AE9FE07910BA935FD113A276609675E0F903
        C30403A418F56786D71A29A9F06E2EB1399A327262A5AA2019FA47A731F3DD06
        8113200F9040131A84CFF336BC7CD8B604C6B3803AEBD6B572D2A19BB920CE3A
        75B442B1774F24027DBDC4B4A7171C78DDD98FB13ECB24C3B81519F565BABFCE
        82CB920F36A809E1F3A868F9101CC12EF11886A1C3846606EC9D6EFD858D87E9
        5FEC27BCCF85F03B2A06720000000049454E44AE426082}
      ExplicitHeight = 41
    end
    object Label6: TLabel
      AlignWithMargins = True
      Left = 22
      Top = 5
      Width = 277
      Height = 15
      Margins.Left = 2
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'The options below will override the default theme settings'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnRevert: TPngSpeedButton
      Left = 339
      Top = 2
      Width = 81
      Height = 22
      Caption = 'Revert All'
      Flat = True
      OnClick = btnRevertClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000002544944415478DA95924D68D36018C79F7C746D92A6B5DD
        86B2B5540FE2A111BC7A109908823741D4F939F5205E4451F4EC511041143C09
        DE446FE2555BBFE7C9EDD04EBC48B77569BA43ED47DABC5992373E6F628BA5DB
        612F24E125EFEFF73CF93FE17CDF87ED2C7BEEAA1C7DF1BCD7DF7343823BF772
        788FC3C307E54DE14B57F2BEEB1CA58EBB20BF7EF96958C06041A8B0BD6FDB1A
        FFF8D190C4BE78398FEF4B5C740C36EAEBAF50745F7DFBE66728F80743340A4C
        E7773A4009D1C4674F0309B93097E778BE242454109349B057AB400CE326759C
        27A1E0F6DD984F69172489E7541568BB0DB4D94489A561BBC0601EE148220964
        AD0A76CDF0109652C577CEE013E88D5B31DFF34C4E92041E0F7AAD26B87F1AE0
        A3404069249900525D63953D6C3F9E2ABE272321BAD7AEC7A8EB99BC2C0B626A
        078047D1CC2E0F2B33B81EC21F0A64F3298461A1C4ED4AB9DD3CAC2CA3C403C8
        4C4373619152D751D21F8BE4FFF323026BF63C06C69562D319804A25EC0005AD
        A525703AA63631FFA5BCA5C03A732E0F088BB28281A908FB41FB4C42EA75B00C
        03363A1D6DE7E28FF288A077FA6C5039841360D57406B1B4B9582ACD2B53BBA0
        5733A0A7EB2831B5A95F4BE581A0776A3698B328CB08C7C1D20D20EB0C76E318
        1AE0D394C6D3829ACD4057AF411703659D642ABFCB81C03C7172868F888588A2
        806B76C14218C7171FFFF63908CCD87F0047EC9ACAE4A4C0CE986C228DC691EC
        EA7271F009AD63C751122938ED16C58A0A863594B6BE775FF09F8CA9AAD08747
        426C1C3A3C83F0FCC4F7AF43707F55737B98E460B6BA52DC728CDB5D7F01E142
        7068B693C6920000000049454E44AE426082}
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 368
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
    Left = 328
    Top = 360
  end
  object imlFontIcons: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C08648800000009704859730000004E000000
          4E01B1CD1F3300000016744558744372656174696F6E2054696D650030362F31
          342F3035BF6598320000002574455874536F667477617265004D6163726F6D65
          6469612046697265776F726B73204D5820323030348776ACCF0000029C494441
          5478DA7D935F48DA5114C78F9665344A9F5271814D5CCD977A4A906DD51808A2
          7BD804C5C564142C1187C4F2C13D07424452411B096385431C7B188D207C187B
          8814862F7BA851FE69E9A4745961B3B4DC399729256B170EBFDFEF72BE9FFBBD
          E79C1FA75C2E43EDE27038C2EEEEEE9742A1F0EED6D6D6CCF6F6F647CCFB05FF
          589C5A008A5B6432D9ACD96C7E64B55AF993939385D5D5D5EFD168D49B4EA7DF
          614AA67C4174098062B1542A9D1D1919D1389DCEA6BABA3AB6BFBFBF0F1E8FA7
          B0B4B4943D383898DFDCDCF4A2EEC725008A5B2512C95BAFD73BA0D168AED55A
          A5BC939313989898809595955832997C83AEFC0C8062A948247A3D353575C760
          3034E377555489F3F373383B3B63418EF020F0F97CDF2A8099F1F1F1A776BBBD
          89C495A885944A2528168B707C7C0CB1580CF47A7D9C01D0FAFB858585870281
          80D9ECE8E880868606E072B95548C501418E8E8E000FA3ABCC33406767673010
          08DC3B3C3C84C6C64626CA66B3A0502880CFE75F72924824A0BEBE1E1C0E470A
          BB739B7CB6A8D5EACFCBCBCB3D94707A7A0AD87726A2D3B075A0542A9988563C
          1E874C26032E976B6D636383016E188DC62F8B8B8B121254EE49A0542AC5ACE7
          7239C0AAB3677F7F3FCCCDCD81DFEF7FB6B7B7F78A0003369BEDC3F4F4742B25
          9398EE4A007AA7C0DEB3686F6F678E70C8E2EBEBEBE4384700B15C2EFF6AB158
          C4A3A3A3C0E3F1AA102A6805120C0641A55291F54C2412B1E00C7CAA0E12B6AC
          B9ABABCBDED6D636ACD56A65434343AC0BE482229FCFC3EEEE2E84C36170BBDD
          FE9D9D1DE355A37C1D2BFF041D3DC6BBDE1C1C1C64FB54F942A1006363639150
          28A445CDCF2B7FA6BFA05BBDBDBDCFD191AEAFAF4F8C534A7BBF4D26D30BCC9F
          FDEFDF5803EA41474E9D4EF7002BBF8657B98FF9A58B397F00E7B79F35C6BE52
          360000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000036A4944415478DA55536D6C5355187ECE6DBBDEDDF58BA6
          DD474A270B66E2E68C56443EC6CC102910019D0A621CA086458D683421FE31D1
          4463E20F7F49D098E0468220444C068E211F73A164421CC32222B1E8A0D2B5DD
          E8CAEED6BBDB7BCFB9C753E2C83CC9937372F2BCCF79DFF7BC0FE19C63F67AEB
          ECCBCBC5B643E05181A0805D6042E03CB7F8EECF5BBA8ECFE693190111582276
          093CB7AE76A5D35F1EC4845601CD0028D34191C5E9915ECA283B4929DBF8F5DA
          8353770544B0439C7F5A186C5C160DAF80AA3B518481844A50C69DC869163835
          508E02D2C51806538397A8495B0E6CEC9E9811F82612A87FF1F1D012E890C199
          078661E28AEA80C3E6442ACF619A14365D455D701249F534CE247EED3DDC7E6C
          2DD911DBD62C5EEFDBF9D056479C16A013A082B9002D8054C181A24970F5C624
          6019A8AAC9A132308C8572081F1CFD82892C9E2D091C8E861E6BAB7687F1A79D
          42E235A8A33262293B2C6A47223305228F4309FD0D49CEC0B27444A6AA40F469
          740EF49C280924B7DFDF16BEA86530264B68B02DC61C46B17F8843D719BC351C
          AAFF1046ACDB220B0E1F75A22EEDC4CABA08DEFF6E57BA245078BBA95DD99F89
          61D4A6A149590DB7E1C1B17316BCC169DC53ABE1776B1CC3C5389C7C12CA581E
          73F30A5E5DBA016FECF9689ABC7966ABF64ED396F2CE640FF20823E27D00FD03
          A207E52E14B22A42F30157651693A2A16ACA144D1E84CF18C66BAD9BD0F1D587
          3A79BDAFFD6647635BA87FEC37187233F4BC1D97AF2828737BC021E1F6580EFA
          AD82485F87B75282AFE22F04C845441F598E9D7B3FCB92ED3F6E3EB2A676F13A
          87D38353E99B82702FAE5D0EC3945CE0361F4CF1FF4535073635019F97C163FF
          058DF374B8B88CDDA7BEEF27DB8E3EBF8A9AACE7BDE657EC5DF11FC08803B4F8
          34C673A20CB9128C59D046FF8152750D1E3901924A6273F429BCBBE7D3D208BF
          746790367DBBBE7B51F582F5F5D5F37121731D96F4046EA51570D90F4A398AE3
          29B8FCFB608D16F170C302243323E88D9FEB1FFA24DE7A47A06DEF1AB769B0B3
          4BE6363CB822D282ABA37EDCB82E3221656202258826205CFF33EEF3CC43DF85
          011CBF743E215E6F110299BB668AEE6A758BC93A28CA7972CB32612C560DCE15
          108920E05391CD0DE1CB13DD4C5063022F88E0ECFFDC38B3967EBCE819E1B80E
          517B93C5AC39FF5D97ECFC8740A708DC379BFF2FA0E2A2600875B4EC00000000
          49454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002784944415478DAA5534B68135114BD2F4D6263328DA999
          993409585283D44541ECA25D28683FF8C1AA95BA0908A228512A64E9AACDC2B5
          A220410A52228528A8A1B468136B51C145C16E4A211A28A2533BF9D0E6D76932
          9319EF0C243428BAE883CBB9EFBE7BCE3BEFCD1BA2280AEC66909D02C27B87CB
          74629D53F3D23BF6B9B98FBFACE6F9186B6E19E04BFF1528CD3B2E80A24C61A9
          03638D1AE0496E8E55AC833CF9A703DCED10CA7CB4F4F14C21C6AA2545DFD64F
          2A6BF16F38F1DA4EA548769689617DD07E36A5FCD501DACC60BADFD0D60F46E6
          3828620E40B707724BF7D258A731A69973A9A13F1CE4E6986BB83881F1B8F9E0
          D55B3A430BC85B3F01E46D207A0BE84C4ED8E21741E03E5CC79E658CAFCE8BE9
          8D06071B6F18160CD6754BE71DA8E65700AA028052C5EB908018CC00A60390FD
          F2B08ABD57DCC399A906079919FA3C6A3C35B55FB2192817C8852492258D5C10
          1D90D9F6424A708350DC94245198C997A9073E9F6FA12E909AA65B51A00BD55F
          B51EBDBB4F4607B2588482C4C26ABE07D8F65EA0280A54A7D96C163E7F9A5F11
          2A70DBEFF72FD48FF02B4A8F218C1BDC43506A3E09E94D0B14CB4DD0E1EDD2C8
          922469027ABD1E388E83783CFE241008DCAC0B702FE947AEE1F4E8F2DB5165AF
          370056AB1508211AA946D69AB166341A21140AC9954A258C11AA7FC6EF2FECA7
          7FD8EECF761E39A3116459D6A2366A7D3A9D4E1349269310894426EB02AB117B
          6FC2FA6CA2BBBBFBB03A57C9EA8EB57CA7905A578F130C06730D4F391A8D8E7B
          3C9E31866134927A692AD234ADADF33CAF39703A9D904824201C0E4F3608A025
          279EEB46B95C1E4104C445C426C463EA5C14C5254413620FC66BBC9F10D9EDEF
          FC1BA00A7508772B68BB0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 384
    Top = 420
    Bitmap = {}
  end
end
