object frmPrismWnd: TfrmPrismWnd
  Left = 579
  Top = 235
  AlphaBlend = True
  AlphaBlendValue = 200
  BorderStyle = bsNone
  Caption = 'PRISM'
  ClientHeight = 176
  ClientWidth = 218
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnMouseDown = graBackMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 218
    Height = 176
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    OnMouseDown = graBackMouseDown
    object graBack: TImage
      Left = 0
      Top = 0
      Width = 216
      Height = 174
      Align = alClient
      OnMouseDown = graBackMouseDown
    end
    object lblTitle: TLabel
      Left = 26
      Top = 4
      Width = 34
      Height = 14
      Caption = 'PRISM'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object img1: TImage
      Left = 4
      Top = 3
      Width = 16
      Height = 16
      AutoSize = True
      Picture.Data = {
        0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001000
        00001008060000001FF3FF610000000774494D45000000000000000973942E00
        00001774455874536F66747761726500474C44504E472076657220332E347185
        A4E10000000874704E47474C4433000000004A80291F0000000467414D410000
        B18F0BFC6105000002B94944415478DA6364400333679E31484F37B902A46B80
        DCFA0F1F5ED595977BF502F96A2071A0D81F64F58C481A0580D47E2036B87EFD
        549E8A8A41042B2B9BD58B170F9E3C7A7463A3999947F6EFDF3F6FAC5933D1FF
        C08155B781EAFEA31800624F9F7EEA211313932C030EF0E5CB87CFC5C52E5D40
        E65C207E0132841166F3CF9FDFAF3333B3D8B1B0B04AE332E0E3C7373F9E3FBF
        FF405959FFFF962DB37C76EC58709F71C68C53858C8C4C7DC80A4F9CD8FA18E8
        D41B9F3FBF7B2F23A3CAE9E191A8616AEAA68AACE6F8F12D9B172C6828664C4A
        6A925454D45D202626EB0692D8BF7FD5FD152BBA4E0399FB80F808C8622016CD
        CD9DD8ACA363ED0D5273E9D2A1A78B17B71EFBF4E9ED5290171A7EFCF8EAC5C1
        C16D0AF4C6EFBC3CDB1D4035EB807827CC9F40CC6C6F1FA2121555710364C0E3
        C737DFBD7EFDE4D2CC99E5792003FEC39C059268698906696E07E27B6841C038
        71E2C193208B6002C068CD609C34E9F0F6AF5F3F9A08094988FCFCF9ED4F5E9E
        DD44A05C1B10BF430FC419334E7F606464E47FF5EAD1E70F1FDE7CEBED4D3B02
        8A4681E2E299EBD5D48C1D408AF6EE5D7E62D5AADE2820F33E5A022B0052FD20
        36301DDC5DBEBC0B14468F415E480032E6232BBE78F1E0E269D38A8B81CCD7D0
        680669AE4756B37FFFCA952B5674D732A6A57548181A3ADE7EF7EEE5EF7FFFFE
        B08889C9F1C2140103F5243B3BA7398CFFEBD78F5FEFDFBFFA252020C2515313
        B80E180B7319A1A9510588133B3AB6A6080A8A8BE24A482F5F3EFA525717B417
        C87C044A9840BC10969441B4E8D4A9C7CF815222D08FF7B4B42C458069830F14
        60F7EE5D796F61E12507B4F17B69A9FB6CA0DA6940FC1EE44546344B443D3D93
        266DDF3EEF6765E5422D05056DD39327B73F9837AF76A7B7770AF7D6AD73FE41
        A31764C06BF4CC04033240AC08C44F81380488CD80F810106F01626968EC3C81
        290600A0D131E574C751210000000049454E44AE426082}
    end
    object separator3: TPanel
      Left = 0
      Top = 23
      Width = 216
      Height = 181
      Color = clWhite
      TabOrder = 0
      OnMouseDown = graBackMouseDown
      object lblCpuTitle: TLabel
        Left = 4
        Top = 2
        Width = 101
        Height = 14
        Caption = 'CPU Monitor : High'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object lblMemoryTitle: TLabel
        Left = 4
        Top = 81
        Width = 92
        Height = 14
        Caption = 'Memory Monitor'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object pnl2: TPanel
        Left = 1
        Top = 15
        Width = 214
        Height = 56
        BevelOuter = bvNone
        BorderWidth = 2
        Color = 16053492
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object scpCpu: TJvSimScope
          Left = 2
          Top = 3
          Width = 209
          Height = 33
          Active = True
          BaseColor = 10198015
          BaseLine = 75
          Color = clWhite
          GridColor = 14079702
          GridSize = 4
          Interval = 100
          Lines = <
            item
              Color = 10485760
              Position = 0
            end
            item
              Color = clRed
              Position = 0
            end
            item
              Color = clRed
              Position = 0
            end>
        end
        object lblCpuStatus: TLabel
          Left = 4
          Top = 40
          Width = 15
          Height = 11
          Caption = 'cpu'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Small Fonts'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object pnl4: TPanel
          Left = 83
          Top = 39
          Width = 129
          Height = 15
          BevelOuter = bvNone
          Color = 16053492
          TabOrder = 0
          object lbl5: TLabel
            Left = 16
            Top = 2
            Width = 20
            Height = 11
            Caption = 'CPU'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object lbl7: TLabel
            Left = 56
            Top = 2
            Width = 20
            Height = 11
            Caption = 'AVG'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object lbl8: TLabel
            Left = 96
            Top = 2
            Width = 27
            Height = 11
            Caption = 'AVGP'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object pnl6: TPanel
            Left = 2
            Top = 2
            Width = 11
            Height = 11
            BevelOuter = bvLowered
            Color = clBlue
            TabOrder = 0
            object graCpuCol: TJvGradient
              Left = 1
              Top = 1
              Width = 9
              Height = 9
              Style = grVertical
              EndColor = 16747660
            end
          end
          object pnl7: TPanel
            Left = 42
            Top = 2
            Width = 11
            Height = 11
            BevelOuter = bvLowered
            Color = clGreen
            TabOrder = 1
            object graCpuAvg: TJvGradient
              Left = 1
              Top = 1
              Width = 9
              Height = 9
              Style = grVertical
              StartColor = clGreen
              EndColor = 55552
            end
          end
          object pnl5: TPanel
            Left = 82
            Top = 2
            Width = 11
            Height = 11
            BevelOuter = bvLowered
            Color = clRed
            TabOrder = 2
            object graCpuBl: TJvGradient
              Left = 1
              Top = 1
              Width = 9
              Height = 9
              Style = grVertical
              StartColor = clRed
              EndColor = 8947967
            end
          end
        end
      end
      object pnl3: TPanel
        Left = 1
        Top = 96
        Width = 214
        Height = 56
        BevelOuter = bvNone
        BorderWidth = 2
        Color = 16053492
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        object scpMem: TJvSimScope
          Left = 2
          Top = 3
          Width = 209
          Height = 33
          Active = True
          BaseColor = 10198015
          BaseLine = 15
          Color = clWhite
          GridColor = 14079702
          GridSize = 4
          Interval = 100
          Lines = <
            item
              Color = 33023
              Position = 0
            end
            item
              Color = 16711808
              Position = 0
            end>
        end
        object lblMemoryStatus: TLabel
          Left = 4
          Top = 40
          Width = 21
          Height = 11
          Caption = 'mem'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Small Fonts'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object pnl8: TPanel
          Left = 84
          Top = 39
          Width = 128
          Height = 15
          BevelOuter = bvNone
          Color = 16053492
          TabOrder = 0
          object lbl9: TLabel
            Left = 56
            Top = 2
            Width = 21
            Height = 11
            Caption = 'SWP'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object lbl10: TLabel
            Left = 96
            Top = 2
            Width = 26
            Height = 11
            Caption = 'PHYS'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object pnl10: TPanel
            Left = 42
            Top = 2
            Width = 11
            Height = 11
            BevelOuter = bvLowered
            Color = clGreen
            TabOrder = 0
            object graSwapCol: TJvGradient
              Left = 1
              Top = 1
              Width = 9
              Height = 9
              Style = grVertical
              StartColor = 25025
              EndColor = 33023
            end
          end
          object pnl11: TPanel
            Left = 82
            Top = 2
            Width = 11
            Height = 11
            BevelOuter = bvLowered
            Color = clYellow
            TabOrder = 1
            object graPhysCol: TJvGradient
              Left = 1
              Top = 1
              Width = 9
              Height = 9
              Style = grVertical
              StartColor = 7077942
              EndColor = 16711808
            end
          end
        end
      end
    end
    object btnClose: TPanel
      Left = 197
      Top = 3
      Width = 15
      Height = 14
      Caption = ' X'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
end
