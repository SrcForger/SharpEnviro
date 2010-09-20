object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 422
  ClientWidth = 508
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
    Width = 508
    Height = 422
    ActivePage = pagDisplay
    PropagateEnable = False
    Align = alClient
    object pagImage: TJvStandardPage
      Left = 0
      Top = 0
      Width = 508
      Height = 422
      object pnlImage: TPanel
        Left = 1
        Top = 1
        Width = 506
        Height = 332
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object schImageSource: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 496
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Image Source'
          Description = 
            'Select the source for the image. Supported image types: .bmp, .g' +
            'if, .jpg, .jpeg, .png, .ico'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object spc: TSharpEPageControl
          AlignWithMargins = True
          Left = 5
          Top = 47
          Width = 496
          Height = 285
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          Color = clWindow
          DoubleBuffered = False
          ExpandedHeight = 200
          TabItems = <
            item
              Caption = 'Load File'
              ImageIndex = 0
              Visible = True
            end
            item
              Caption = 'Load URL'
              ImageIndex = 0
              Visible = True
            end
            item
              Caption = 'Load Directory'
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
          OnTabChange = spcTabChange
          DesignSize = (
            496
            285)
          object pl: TJvPageList
            AlignWithMargins = True
            Left = 8
            Top = 34
            Width = 480
            Height = 240
            Margins.Left = 8
            Margins.Top = 34
            Margins.Right = 8
            Margins.Bottom = 8
            ActivePage = pageurl
            PropagateEnable = False
            Align = alTop
            ParentBackground = True
            object pagefile: TJvStandardPage
              Left = 0
              Top = 0
              Width = 480
              Height = 240
              Caption = 'pagefile'
              object schFile: TSharpECenterHeader
                AlignWithMargins = True
                Left = 6
                Top = 11
                Width = 468
                Height = 37
                Margins.Left = 5
                Margins.Top = 10
                Margins.Right = 5
                Margins.Bottom = 10
                Title = 'Local Location'
                Description = 'Please select the file you would like to use for this object'
                TitleColor = clWindowText
                DescriptionColor = clRed
                Align = alTop
              end
              object pnlFile: TPanel
                AlignWithMargins = True
                Left = 6
                Top = 58
                Width = 468
                Height = 22
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 5
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                object PngSpeedButton1: TPngSpeedButton
                  AlignWithMargins = True
                  Left = 439
                  Top = 0
                  Width = 29
                  Height = 22
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alRight
                  Flat = True
                  OnClick = PngSpeedButton1Click
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
                object imagefile: TEdit
                  Left = 0
                  Top = 0
                  Width = 436
                  Height = 22
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 10
                  Align = alClient
                  AutoSize = False
                  OEMConvert = True
                  TabOrder = 0
                  OnChange = imagefileChange
                end
              end
              object pnlFileScaling: TPanel
                AlignWithMargins = True
                Left = 6
                Top = 137
                Width = 468
                Height = 22
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 5
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 2
                object sgbFileScaling: TSharpeGaugeBox
                  Left = 0
                  Top = 0
                  Width = 150
                  Height = 22
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 0
                  Align = alLeft
                  Color = clWindow
                  ParentBackground = False
                  TabOrder = 0
                  Min = 5
                  Max = 500
                  Value = 100
                  Suffix = '% scaled'
                  Description = 'Scale image by'
                  PopPosition = ppBottom
                  PercentDisplay = False
                  MaxPercent = 100
                  Formatting = '%d'
                  OnChangeValue = sgbFileScalingChangeValue
                  BackgroundColor = clWindow
                end
              end
              object schFileScaling: TSharpECenterHeader
                AlignWithMargins = True
                Left = 6
                Top = 90
                Width = 468
                Height = 37
                Margins.Left = 5
                Margins.Top = 10
                Margins.Right = 5
                Margins.Bottom = 10
                Title = 'Image Scaling'
                Description = 'Changing this option will enlarge or shrink the image'
                TitleColor = clWindowText
                DescriptionColor = clRed
                Align = alTop
              end
            end
            object pageurl: TJvStandardPage
              Left = 0
              Top = 0
              Width = 480
              Height = 240
              Caption = 'pageurl'
              ParentBackground = True
              object pnlURL: TPanel
                AlignWithMargins = True
                Left = 6
                Top = 58
                Width = 468
                Height = 21
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 5
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 0
                object imageurl: TEdit
                  Left = 0
                  Top = 0
                  Width = 468
                  Height = 21
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 0
                  Align = alClient
                  TabOrder = 0
                  Text = 'http://'
                  OnChange = imageurlChange
                end
              end
              object schURLInterval: TSharpECenterHeader
                AlignWithMargins = True
                Left = 6
                Top = 89
                Width = 468
                Height = 37
                Margins.Left = 5
                Margins.Top = 10
                Margins.Right = 5
                Margins.Bottom = 10
                Title = 'Refresh Interval'
                Description = 'Change the update interval at which the image is downloaded'
                TitleColor = clWindowText
                DescriptionColor = clRed
                Align = alTop
              end
              object schURL: TSharpECenterHeader
                AlignWithMargins = True
                Left = 6
                Top = 11
                Width = 468
                Height = 37
                Margins.Left = 5
                Margins.Top = 10
                Margins.Right = 5
                Margins.Bottom = 10
                Title = 'Remote location'
                Description = 'Define the URL where you want to download the image from'
                TitleColor = clWindowText
                DescriptionColor = clRed
                Align = alTop
              end
              object pnlURLInterval: TPanel
                AlignWithMargins = True
                Left = 6
                Top = 136
                Width = 468
                Height = 22
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 5
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 1
                object sgbURLInterval: TSharpeGaugeBox
                  Left = 0
                  Top = 0
                  Width = 150
                  Height = 22
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 0
                  Align = alLeft
                  Color = clWindow
                  ParentBackground = False
                  TabOrder = 0
                  Min = 5
                  Max = 60
                  Value = 30
                  Prefix = 'Every '
                  Suffix = ' minutes'
                  Description = 'Scale image by'
                  PopPosition = ppBottom
                  PercentDisplay = False
                  MaxPercent = 100
                  Formatting = '%d'
                  OnChangeValue = sgbFileScalingChangeValue
                  BackgroundColor = clWindow
                end
              end
              object schURLScaling: TSharpECenterHeader
                AlignWithMargins = True
                Left = 6
                Top = 168
                Width = 468
                Height = 37
                Margins.Left = 5
                Margins.Top = 10
                Margins.Right = 5
                Margins.Bottom = 10
                Title = 'Image Scaling'
                Description = 'Changing this option will enlarge or shrink the image'
                TitleColor = clWindowText
                DescriptionColor = clRed
                Align = alTop
              end
              object pnlURLScaling: TPanel
                AlignWithMargins = True
                Left = 6
                Top = 215
                Width = 468
                Height = 22
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 5
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 5
                object sgbURLScaling: TSharpeGaugeBox
                  Left = 0
                  Top = 0
                  Width = 150
                  Height = 22
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 0
                  Align = alLeft
                  Color = clWindow
                  ParentBackground = False
                  TabOrder = 0
                  Min = 5
                  Max = 500
                  Value = 100
                  Suffix = '% scaled'
                  Description = 'Scale image by'
                  PopPosition = ppBottom
                  PercentDisplay = False
                  MaxPercent = 100
                  Formatting = '%d'
                  OnChangeValue = sgbFileScalingChangeValue
                  BackgroundColor = clWindow
                end
              end
            end
            object pageDirectory: TJvStandardPage
              Left = 0
              Top = 0
              Width = 480
              Height = 240
              object pnlDirectory: TPanel
                AlignWithMargins = True
                Left = 6
                Top = 58
                Width = 468
                Height = 21
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 5
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 0
                object psbDirectory: TPngSpeedButton
                  AlignWithMargins = True
                  Left = 439
                  Top = 0
                  Width = 29
                  Height = 21
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alRight
                  Flat = True
                  OnClick = psbDirectoryClick
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
                object imageDirectory: TEdit
                  Left = 0
                  Top = 0
                  Width = 436
                  Height = 21
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 0
                  Align = alClient
                  TabOrder = 0
                  OnChange = imageDirectoryChange
                end
              end
              object pnlDirectoryInterval: TPanel
                AlignWithMargins = True
                Left = 6
                Top = 136
                Width = 468
                Height = 22
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 5
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 1
                object sgbDirectoryInterval: TSharpeGaugeBox
                  Left = 0
                  Top = 0
                  Width = 150
                  Height = 22
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 0
                  Align = alLeft
                  Color = clWindow
                  ParentBackground = False
                  TabOrder = 0
                  Min = 5
                  Max = 60
                  Value = 30
                  Prefix = 'Every '
                  Suffix = ' minutes'
                  Description = 'Scale image by'
                  PopPosition = ppBottom
                  PercentDisplay = False
                  MaxPercent = 100
                  Formatting = '%d'
                  OnChangeValue = sgbDirectoryIntervalChangeValue
                  BackgroundColor = clWindow
                end
              end
              object schDirectoryInterval: TSharpECenterHeader
                AlignWithMargins = True
                Left = 6
                Top = 89
                Width = 468
                Height = 37
                Margins.Left = 5
                Margins.Top = 10
                Margins.Right = 5
                Margins.Bottom = 10
                Title = 'Refresh Interval'
                Description = 'Change the update interval at which a new image is loaded.'
                TitleColor = clWindowText
                DescriptionColor = clRed
                Align = alTop
              end
              object schDirectory: TSharpECenterHeader
                AlignWithMargins = True
                Left = 6
                Top = 11
                Width = 468
                Height = 37
                Margins.Left = 5
                Margins.Top = 10
                Margins.Right = 5
                Margins.Bottom = 10
                Title = 'Directory location'
                Description = 'Define the directory where you want to load the images from.'
                TitleColor = clWindowText
                DescriptionColor = clRed
                Align = alTop
              end
              object schDirectoryDimensions: TSharpECenterHeader
                AlignWithMargins = True
                Left = 6
                Top = 168
                Width = 468
                Height = 37
                Margins.Left = 5
                Margins.Top = 10
                Margins.Right = 5
                Margins.Bottom = 10
                Title = 'Image Dimensions'
                Description = 'Set the height and width to scale the images to.'
                TitleColor = clWindowText
                DescriptionColor = clRed
                Align = alTop
              end
              object pnlDirectoryDimensions: TPanel
                AlignWithMargins = True
                Left = 6
                Top = 215
                Width = 468
                Height = 21
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 5
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 5
                object sgbDirectoryHeight: TSharpeGaugeBox
                  Left = 0
                  Top = 0
                  Width = 150
                  Height = 21
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 0
                  Align = alLeft
                  Color = clWindow
                  ParentBackground = False
                  TabOrder = 0
                  Min = 0
                  Max = 500
                  Value = 100
                  Prefix = 'Height: '
                  Suffix = ' px'
                  Description = 'Set the height for the images.'
                  PopPosition = ppBottom
                  PercentDisplay = False
                  MaxPercent = 100
                  Formatting = '%d'
                  OnChangeValue = sgbDirectoryHeightChangeValue
                  BackgroundColor = clWindow
                end
                object sgbDirectoryWidth: TSharpeGaugeBox
                  AlignWithMargins = True
                  Left = 155
                  Top = 0
                  Width = 150
                  Height = 21
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 5
                  Margins.Bottom = 0
                  Align = alLeft
                  Color = clWindow
                  ParentBackground = False
                  TabOrder = 1
                  Min = 0
                  Max = 500
                  Value = 100
                  Prefix = 'Width: '
                  Suffix = ' px'
                  Description = 'Set the width for the images.'
                  PopPosition = ppBottom
                  PercentDisplay = False
                  MaxPercent = 100
                  Formatting = '%d'
                  OnChangeValue = sgbDirectoryWidthChangeValue
                  BackgroundColor = clWindow
                end
              end
            end
          end
        end
      end
    end
    object pagDisplay: TJvStandardPage
      Left = 0
      Top = 0
      Width = 508
      Height = 422
      Caption = 'pagDisplay'
      object pnlDisplay: TPanel
        Left = 1
        Top = 1
        Width = 506
        Height = 301
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object Panel3: TPanel
          Left = 0
          Top = 194
          Width = 506
          Height = 65
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 2
          object UIC_colorblend: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 496
            Height = 25
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 5
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'UIC_colorblend'
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            HasChanged = True
            AutoReset = False
            DefaultValue = 'True'
            MonitorControl = cbcolorblend
            OnReset = UIC_Reset
            object cbcolorblend: TCheckBox
              Left = 0
              Top = 0
              Width = 177
              Height = 25
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Enable image colour blending'
              TabOrder = 0
              OnClick = cbcolorblendClick
            end
          end
          object UIC_ColorAlpha: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 30
            Width = 496
            Height = 25
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 10
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'UIC_ColorAlpha'
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            HasChanged = True
            AutoReset = False
            DefaultValue = '100'
            MonitorControl = sbgimagencblendalpha
            OnReset = UIC_Reset
            object sbgimagencblendalpha: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 300
              Height = 25
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alLeft
              ParentBackground = False
              TabOrder = 0
              Min = 16
              Max = 255
              Value = 192
              Suffix = '% colour blended'
              Description = 'Adjust to set the blend strength'
              PopPosition = ppBottom
              PercentDisplay = True
              MaxPercent = 100
              Formatting = '%d'
              OnChangeValue = sbgimagencblendalphaChangeValue
              BackgroundColor = clWindow
            end
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 77
          Width = 506
          Height = 60
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 1
          object UIC_alphablend: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 496
            Height = 25
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 5
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'UIC_colorblend'
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            HasChanged = True
            AutoReset = False
            DefaultValue = 'True'
            MonitorControl = cbalphablend
            OnReset = UIC_Reset
            object cbalphablend: TCheckBox
              Left = 0
              Top = 0
              Width = 177
              Height = 25
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Enable image alpha blending'
              TabOrder = 0
              OnClick = cbalphablendClick
            end
          end
          object UIC_blendalpha: TSharpEUIC
            AlignWithMargins = True
            Left = 5
            Top = 30
            Width = 496
            Height = 25
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 5
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            Caption = 'UIC_blendalpha'
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            HasChanged = True
            AutoReset = False
            DefaultValue = '100'
            MonitorControl = sgbiconalpha
            OnReset = UIC_Reset
            object sgbiconalpha: TSharpeGaugeBox
              Left = 0
              Top = 0
              Width = 300
              Height = 25
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
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
              OnChangeValue = sgbiconalphaChangeValue
              BackgroundColor = clWindow
            end
          end
        end
        object Panel7: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 501
          Height = 25
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 0
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
          object Label1: TLabel
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
        object SharpECenterHeader6: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 30
          Width = 496
          Height = 37
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Image Alpha Blend'
          Description = 'Define how visible you would like the image to be'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object SharpECenterHeader7: TSharpECenterHeader
          AlignWithMargins = True
          Left = 5
          Top = 147
          Width = 496
          Height = 37
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Title = 'Image Colour Blend'
          Description = 'Define the strength of colour blending you want to apply'
          TitleColor = clWindowText
          DescriptionColor = clRed
          Align = alTop
        end
        object UIC_Colors: TSharpEUIC
          AlignWithMargins = True
          Left = 2
          Top = 259
          Width = 499
          Height = 32
          Margins.Left = 2
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 10
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 3
          HasChanged = False
          AutoReset = False
          DefaultValue = '0'
          MonitorControl = IconColors
          object IconColors: TSharpEColorEditorEx
            Left = 0
            Top = 0
            Width = 465
            Height = 32
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 34
            Margins.Bottom = 4
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            AutoSize = True
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clBlack
            ParentBackground = True
            ParentColor = False
            TabOrder = 0
            OnResize = IconColorsResize
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
                ColorEditor = IconColors.Item0
                Tag = 0
              end>
            SwatchManager = SharpESwatchManager1
            OnChangeColor = IconColorsChangeColor
            BorderColor = clBlack
            BackgroundColor = clBlack
            BackgroundTextColor = clBlack
            ContainerColor = clBlack
            ContainerTextColor = clBlack
          end
        end
      end
    end
  end
  object SharpESwatchManager1: TSharpESwatchManager
    Swatches = <>
    PopulateThemeColors = True
    Width = 432
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
    Left = 304
    Top = 32
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'All Images (*.bmp,*.jpg,*.jpeg,*.png,*.ico)|*.bmp;*.jpg;*.jpeg;*' +
      '.png;*.ico'
    Left = 424
    Top = 8
  end
end
