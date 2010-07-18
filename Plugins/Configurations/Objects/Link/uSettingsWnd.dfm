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
    ActivePage = pagIcon
    PropagateEnable = False
    Align = alClient
    object pagLink: TJvStandardPage
      Left = 0
      Top = 0
      Width = 445
      Height = 628
      object pnlLink: TPanel
        Left = 0
        Top = 0
        Width = 445
        Height = 374
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object Panel69: TPanel
          Left = 0
          Top = 0
          Width = 445
          Height = 74
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Ctl3D = True
          ParentColor = True
          ParentCtl3D = False
          TabOrder = 0
          object SharpECenterHeader1: TSharpECenterHeader
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 435
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
          end
          object chkCaption: TJvXPCheckbox
            AlignWithMargins = True
            Left = 5
            Top = 47
            Width = 435
            Height = 17
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Caption = 'Display Caption'
            TabOrder = 0
            Align = alTop
            OnClick = chkCaptionClick
          end
        end
        object SharpECenterHeader2: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 305
          Width = 435
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Link Icon'
          Description = 'Define the icon for this link'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader6: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 226
          Width = 435
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Link Target'
          Description = 'Define the target to be launched when clicked'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object pnlCaption: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 74
          Width = 435
          Height = 137
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Label1: TLabel
            Left = 5
            Top = 116
            Width = 27
            Height = 13
            Caption = 'Align:'
            Layout = tlCenter
          end
          object cboCaptionAlign: TComboBox
            Left = 46
            Top = 112
            Width = 183
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            ItemIndex = 2
            TabOrder = 1
            Text = 'Bottom'
            OnChange = cboCaptionAlignChange
            Items.Strings = (
              'Top'
              'Right'
              'Bottom'
              'Left'
              'Center')
          end
          object spcCaption: TSharpEPageControl
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 430
            Height = 105
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alTop
            Color = clWindow
            DoubleBuffered = False
            ExpandedHeight = 200
            TabItems = <
              item
                Caption = 'Single Line'
                ImageIndex = 0
                Visible = True
              end
              item
                Caption = 'Multi Line'
                ImageIndex = 0
                Visible = True
              end>
            Buttons = <>
            RoundValue = 10
            Border = True
            TextSpacingX = 8
            TextSpacingY = 4
            IconSpacingX = 4
            IconSpacingY = 4
            BtnWidth = 24
            TabIndex = 0
            TabAlignment = taLeftJustify
            AutoSizeTabs = True
            TabBackgroundColor = clWindow
            BackgroundColor = clWindow
            BorderColor = clBlack
            TabColor = 15724527
            TabSelColor = clWhite
            TabCaptionSelColor = clBlack
            TabStatusSelColor = clGreen
            TabCaptionColor = clBlack
            TabStatusColor = clGreen
            PageBackgroundColor = clWindow
            OnTabChange = spcCaptionTabChange
            DesignSize = (
              430
              105)
            object pl: TJvPageList
              AlignWithMargins = True
              Left = 8
              Top = 34
              Width = 414
              Height = 63
              Margins.Left = 8
              Margins.Top = 34
              Margins.Right = 8
              Margins.Bottom = 8
              ActivePage = pagemulti
              PropagateEnable = False
              Align = alClient
              ParentBackground = True
              object pagesingle: TJvStandardPage
                Left = 0
                Top = 0
                Width = 414
                Height = 63
                Caption = 'pagesingle'
                object edtSingle: TEdit
                  AlignWithMargins = True
                  Left = 3
                  Top = 0
                  Width = 408
                  Height = 21
                  Margins.Top = 0
                  Align = alTop
                  BorderStyle = bsNone
                  TabOrder = 0
                  Text = 'Link'
                  OnChange = edtSingleChange
                end
              end
              object pagemulti: TJvStandardPage
                Left = 0
                Top = 0
                Width = 414
                Height = 63
                Caption = 'pagemulti'
                ParentBackground = True
                object mmoMulti: TMemo
                  Left = 0
                  Top = 0
                  Width = 414
                  Height = 63
                  Align = alClient
                  BorderStyle = bsNone
                  Ctl3D = True
                  Lines.Strings = (
                    'Link')
                  ParentCtl3D = False
                  ScrollBars = ssVertical
                  TabOrder = 0
                  OnChange = mmoMultiChange
                end
              end
            end
          end
        end
        object Panel2: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 273
          Width = 435
          Height = 22
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Button1: TPngSpeedButton
            AlignWithMargins = True
            Left = 406
            Top = 0
            Width = 29
            Height = 22
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            Flat = True
            OnClick = edtTargetButtonClick
            PngImage.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000001974455874536F6674776172650041646F626520496D616765526561
              647971C9653C0000020B4944415478DACD933D68144114C7DF6CBCDC26BA67C0
              CA8FC290DD5C12D2C5DB20B6A9242A114494580405831830822092C2CA2EA9C4
              42B0482416774508069BA82836E1FC20481A737887A8C1F875EBDE9E999DFD78
              BE9DDD8BDAD858E8C0DB7933F3FEBFF7E6631922C2DF34F67F005617F62DAB99
              9E1EC6945F9610DCDAEBB7816FEDA781FBBB4A7EEBD9432BBE0494EE9A5C1F5C
              4A33C6229D1403F93EFF0CEBCB570526B3516B6ACE2006DE4767EDE1A5CE232F
              F231602E67E9879F6C171F6E40209A00940CE93550770D909F2279A40FA90F25
              9C29DB4469FE40C9182AF6C680BC69770CDDD7F8BB198A4108DDAFE0D5D721A0
              2DA5D49DA4F1482F88E313C007ADEB3254EE1D748CA3CFB41850C889F6C18594
              532E000A073CFB1368DDC741DDD19D6CB85101C6156C69234D3F378E155B62C0
              9D7E619C5C4A45591A8154070DDF836F2D0206DF00FDC86CF21D50F74C4079EE
              1437869F268069D3D5871F3787DF5F52804556A3600B42AF2AC54489214104A8
              43CBDE492817CE7063A401B869F28E9107E9A0F628CE24335A895F4D32DB9B80
              56FD16546647B931DA005CCF6DE8671755AF3A9F08AD9F65CBBEB629C690C3D6
              EC2C54A6CF71E37C02589DEA5B6B3F9D6F155F8A1A841B0A22A7A320A31E037A
              4318DD802B6F822620BDFB04BEB93D6E775E7CDE2601AFAEF55E008599747203
              74E8DA1FDF2ECA8B1110E24CF6CACAD8BFFF997E000DC65AF0F0FE412D000000
              0049454E44AE426082}
            ExplicitLeft = 332
            ExplicitTop = 1
            ExplicitHeight = 20
          end
          object edtTarget: TEdit
            Left = 0
            Top = 0
            Width = 403
            Height = 22
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Align = alClient
            AutoSize = False
            OEMConvert = True
            TabOrder = 0
            OnChange = edtTargetChange
          end
        end
        object Panel3: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 352
          Width = 435
          Height = 22
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object PngSpeedButton1: TPngSpeedButton
            AlignWithMargins = True
            Left = 406
            Top = 0
            Width = 29
            Height = 22
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            Flat = True
            OnClick = edtIconButtonClick
            PngImage.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000001974455874536F6674776172650041646F626520496D616765526561
              647971C9653C0000020B4944415478DACD933D68144114C7DF6CBCDC26BA67C0
              CA8FC290DD5C12D2C5DB20B6A9242A114494580405831830822092C2CA2EA9C4
              42B0482416774508069BA82836E1FC20481A737887A8C1F875EBDE9E999DFD78
              BE9DDD8BDAD858E8C0DB7933F3FEBFF7E6631922C2DF34F67F005617F62DAB99
              9E1EC6945F9610DCDAEBB7816FEDA781FBBB4A7EEBD9432BBE0494EE9A5C1F5C
              4A33C6229D1403F93EFF0CEBCB570526B3516B6ACE2006DE4767EDE1A5CE232F
              F231602E67E9879F6C171F6E40209A00940CE93550770D909F2279A40FA90F25
              9C29DB4469FE40C9182AF6C680BC69770CDDD7F8BB198A4108DDAFE0D5D721A0
              2DA5D49DA4F1482F88E313C007ADEB3254EE1D748CA3CFB41850C889F6C18594
              532E000A073CFB1368DDC741DDD19D6CB85101C6156C69234D3F378E155B62C0
              9D7E619C5C4A45591A8154070DDF836F2D0206DF00FDC86CF21D50F74C4079EE
              1437869F268069D3D5871F3787DF5F52804556A3600B42AF2AC54489214104A8
              43CBDE492817CE7063A401B869F28E9107E9A0F628CE24335A895F4D32DB9B80
              56FD16546647B931DA005CCF6DE8671755AF3A9F08AD9F65CBBEB629C690C3D6
              EC2C54A6CF71E37C02589DEA5B6B3F9D6F155F8A1A841B0A22A7A320A31E037A
              4318DD802B6F822620BDFB04BEB93D6E775E7CDE2601AFAEF55E008599747203
              74E8DA1FDF2ECA8B1110E24CF6CACAD8BFFF997E000DC65AF0F0FE412D000000
              0049454E44AE426082}
            ExplicitLeft = 332
            ExplicitTop = 1
            ExplicitHeight = 20
          end
          object edtIcon: TEdit
            Left = 0
            Top = 0
            Width = 403
            Height = 22
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Align = alClient
            AutoSize = False
            OEMConvert = True
            TabOrder = 0
            OnChange = edtIconChange
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
        Left = 0
        Top = 0
        Width = 445
        Height = 557
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object Panel1: TPanel
          Left = 0
          Top = 275
          Width = 445
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
            Width = 437
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
            Width = 435
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
          Width = 445
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
            Width = 435
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
              RoundValue = 10
              BorderColor = clWindow
              Border = False
              BackgroundColor = clWindow
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
          Width = 445
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
            Width = 437
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
            Width = 435
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
          Width = 445
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
            Width = 437
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
            Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
            Width = 403
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
          Width = 435
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
            Width = 403
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
        Left = 0
        Top = 0
        Width = 445
        Height = 477
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object uicFontName: TSharpEUIC
          AlignWithMargins = True
          Left = 5
          Top = 47
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
            Width = 403
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
          Width = 435
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
        Left = 0
        Top = 0
        Width = 445
        Height = 315
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object pnlTextShadow: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 68
          Width = 445
          Height = 247
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
            Width = 435
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
            Width = 435
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
              ItemHeight = 0
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
            Top = 89
            Width = 435
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
            Top = 136
            Width = 435
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
            Top = 168
            Width = 435
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
            Top = 215
            Width = 435
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
              Width = 403
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
          Width = 435
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
          Width = 435
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
    Width = 370
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
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002074944415478DA63FCFFFF3F03258091660638B4DF7460
          666170656366E2FFF5FBFFEFBFBFFF3332323070FD7CFFFBC38FF73F9BFFFCFC
          FBE5D252B3FF380DB06BBE11ACA7C2DDAD2ACAAEF8EFDF3F863F7F19189EBDFD
          FDE7E2AD2FBBDFDEFB1A727189C937BC2EB0AEBD2E232DC93E4F5698CD82E1FF
          3FE67F7F1898CE5EFEB4F0D38B1F0517169AFC20E8059BCAABE526BA7C0DD71F
          FDD8F6E7DB9FCFF6067CF13BF6BF9E756CB2413AC130B028BCA4A4ADC57BE0F7
          EF7F7FAF5FFE5C0A14D2717710AEDF77F8FDB26353F4A2F11A609A759199578C
          7DB9863C87EFA9E3EFF27F7FFFB3848585B9CECD55B4FCF4952F971F5F786372
          739BDD2F9C0698655D8831321698F5EADDEFDBF7AF7CACFDFBEBCF1D4E3EB632
          677B91F89B0FBE7FBE74E099F4ED5D8E9FB11A60947C5654C780FFAAB408BBE8
          C53BDFAE7C78FEFDFEFF7FFF997984D8956DF4F8D4AFDEFBF6EBECEE274A77F7
          3B3DC530C020F60C23BF38C72C5B53FE94DD7B5FCD3A39CB181E58E6C967373A
          D80AFB3D7EF99BE1C4D607CAF70EB9DE4331403FE634172333A395ABABD8EEC7
          2F7EBEBD72EC75E095755687410A545CF70B3333B3E4B8F849357CFDF99FE1E0
          8687A17F7FFE5CF7E884D73FB8011619E7D7A9AAF304303332327EF8FCE7DDED
          B36F16FCF8F4B3F9FFDFFF529C7CEC15E22A7C1EFCBC6CA27FFEFD677872F3C3
          BE374F3E943C3EEE759EB679816E0600004C431AF0FB9EBF8C0000000049454E
          44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000774494D45000000000000000973942E000000097048597300001EC1
          00001EC101C3695453000001E14944415478DA6364A010300E0D0322A63E4EFB
          F78F61263B2B23C3C76F7F953715C9DF23D9057E7D0FFFFFFBFFFFDE96620565
          AC2E00DA12FAE7EFFF8E7FFF1994B8399818DE7FF903B4ED5FE7E15AA50A9FDE
          07C65C6CCC67DE7FFDB3E7D79FFFEF81EA047FFFFD3FEB5493CA6AB00161931F
          2BB1B230DC053AEFDE9FBF0C26DF7FFD2B5797622F3F73F7FB9E73AD2AAEAE1D
          F7CBA584583BEE3CFFB907A8F1ACAC085BF99337BFC0DE61843A4F0968EACC1F
          BFFF831430FCFCFD2F544D8ADDF8CC9D6F9D377AD42BAC1BEFEE068ABBB03233
          3282E43F7DFB7B46949FD5F8F9EBAFAE60033CBA1E84026DEDE06667527AF1E1
          CF596B0D6EE373F7BE31BC78F3C5F5EE64FD3D667577FE7FFBF96FF5954EB530
          93DA3B099A321CF38181FAEBE4F5F7EC6003807EFCFFEAE39FF73F7FFD77FDF9
          E79F92830EEF2AA02DBF44F858B8F65FF91C2BC6CF3AFFF1EB9F9DB7FA342A34
          4A6E9E3155E136BEF7F2E79EA3F5CAAE8CB6CDF73AA48558CBAF3CFAFEFED7CF
          3F9D169A7CD5775FFCE405FA33ECCFBFFFAB2FDDFF365356943D0D6640ECCC27
          FF19FE3330DC7CF6230C1E884053EFFEFDF357E9EF9F5F67CD3485FF31333198
          1EBFFAF66C8C93A4C9B203AFEE82D4FCFFFF8FE1FFDF3F4ADACA221F5F7EFC9D
          0AD23C849232CD0C5048D92F0800DFD0061977BB0EC50000000049454E44AE42
          6082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000020B4944415478DACD933D68144114C7DF6CBCDC26BA67C0
          CA8FC290DD5C12D2C5DB20B6A9242A114494580405831830822092C2CA2EA9C4
          42B0482416774508069BA82836E1FC20481A737887A8C1F875EBDE9E999DFD78
          BE9DDD8BDAD858E8C0DB7933F3FEBFF7E6631922C2DF34F67F005617F62DAB99
          9E1EC6945F9610DCDAEBB7816FEDA781FBBB4A7EEBD9432BBE0494EE9A5C1F5C
          4A33C6229D1403F93EFF0CEBCB570526B3516B6ACE2006DE4767EDE1A5CE232F
          F231602E67E9879F6C171F6E40209A00940CE93550770D909F2279A40FA90F25
          9C29DB4469FE40C9182AF6C680BC69770CDDD7F8BB198A4108DDAFE0D5D721A0
          2DA5D49DA4F1482F88E313C007ADEB3254EE1D748CA3CFB41850C889F6C18594
          532E000A073CFB1368DDC741DDD19D6CB85101C6156C69234D3F378E155B62C0
          9D7E619C5C4A45591A8154070DDF836F2D0206DF00FDC86CF21D50F74C4079EE
          1437869F268069D3D5871F3787DF5F52804556A3600B42AF2AC54489214104A8
          43CBDE492817CE7063A401B869F28E9107E9A0F628CE24335A895F4D32DB9B80
          56FD16546647B931DA005CCF6DE8671755AF3A9F08AD9F65CBBEB629C690C3D6
          EC2C54A6CF71E37C02589DEA5B6B3F9D6F155F8A1A841B0A22A7A320A31E037A
          4318DD802B6F822620BDFB04BEB93D6E775E7CDE2601AFAEF55E008599747203
          74E8DA1FDF2ECA8B1110E24CF6CACAD8BFFF997E000DC65AF0F0FE412D000000
          0049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 384
    Top = 420
    Bitmap = {}
  end
end
