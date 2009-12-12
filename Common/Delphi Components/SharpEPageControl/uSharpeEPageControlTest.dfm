object Form4: TForm4
  Left = 0
  Top = 0
  BorderWidth = 8
  Caption = 'Form4'
  ClientHeight = 268
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 402
    Height = 268
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object SharpEPageControl1: TSharpEPageControl
      Left = 1
      Top = 1
      Width = 400
      Height = 209
      Align = alTop
      DoubleBuffered = True
      ExpandedHeight = 200
      TabItems = <
        item
          Caption = 'New'
          ImageIndex = -1
          Visible = True
        end
        item
          Caption = 'Newer'
          ImageIndex = -1
          Visible = True
        end>
      Buttons = <>
      RoundValue = 10
      Border = True
      TextSpacingX = 12
      TextSpacingY = 6
      IconSpacingX = 4
      IconSpacingY = 4
      BtnWidth = 24
      TabIndex = 0
      TabAlignment = taLeftJustify
      AutoSizeTabs = False
      TabImageList = PngImageList1
      TabBackgroundColor = clBtnFace
      BackgroundColor = clBtnFace
      BorderColor = clBlack
      TabColor = 15724527
      TabSelColor = clWhite
      TabCaptionSelColor = clBlack
      TabStatusSelColor = clGreen
      TabCaptionColor = clBlack
      TabStatusColor = clGreen
      PageBackgroundColor = clBtnFace
      DesignSize = (
        400
        209)
    end
    object Button1: TButton
      Left = 16
      Top = 224
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 116
      Top = 224
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002ED4944415478DAA5935B4854511486FF73C6B1CC1BA699
          8EE3254733B4D44AAC1886340A458B2E9365512609D143767B0A03658AAE0429
          FA902994628A0F03251A996017137432BC558A3AE6E89C519850D3463D9E5BDB
          23F990F9520BD6CB5E7B7FFC6BFD6B539224E17F82FA1370D694A0E139EEA420
          88192C37E7278A3C208A631051CE0B4265CDFE5EF38A80CC169D9E9D670B03A0
          F18FF1D5C155E9299F4FCF4FA275B801BD53EDA30494DD78DC625C06C868D6EA
          6739B64CEB99EA1AE11D0BDBEC086C338C5C53AD09809F8B1A5F474DA8FAFCCC
          E1049C31658D189700A7DEEF0A6579AE49EB95AA0AF78E41B3FD0D7851202982
          5EB844D2895240EB9B882F56132ABA2A6D4489AEFB827550069C688CCB5D4F69
          0C499A7434D91B31C773102501A22002A4AE208803217ABCB5D663879F0ED5AD
          A568B17DCEEBBB62BD21038E366CE93F10783E6C1E3CFAA77A41D440220AA885
          EE481E26E08480248C3AACA83157C149006ED6170C0C5DB386CB80D4DA8D33E7
          220D2EED131F31CDFDC45E550A42DC3528EECAC7414D1A12D5C910881BA5DDF9
          6026CD885DBF1397AB7266870DCC1A19B0C7183C931D7BC7A563DC44C42A7035
          26171ECE9E189FFB8EB5AB7DE4C7C51D0FD06FEF869BD20DDB54BB70A9FCFAEC
          F0EDDF80EAE0FED39157C3389A47DF780FBC57ADC3C5AD39C44677320B118F3E
          DD458FBD134ADA09E13E915070346E3D2F1AB0DC65165BD05504E546B8451B0E
          4567A079E435E6040E3EAB7C91B629136F2C75E81E6B032DD170268084B0143C
          7E5B82CE81BE3CCB3D667188F12581A12C2735A56F3EA68A52C5A379E815B190
          27D2051033E4492A6905766B52D036F8014FEA5FD828503ACB4366706991A20A
          D47A072B9565C51D71DD16A4C5C88F6F6026BE113744A8D78642ED118C56F33B
          3CADAB75D04AEA0C796C5CB6CA1BEEABF5222B156E0F8CF04F8EDA072F171FD9
          46BB630C2FDB5FA3ABC73C4AD154B6259F31FEF52F2C44B041AD81209D242B91
          21B1921F480B14458D91523938545A8A98953FD3BFC42F13D076F095DD7DCB00
          00000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end>
    Left = 332
    Top = 236
    Bitmap = {}
  end
end
