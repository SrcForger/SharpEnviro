object FrmHotkeyEdit: TFrmHotkeyEdit
  Left = 683
  Top = 363
  BorderStyle = bsToolWindow
  Caption = 'Hotkey Configuration'
  ClientHeight = 188
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 316
    Height = 188
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 316
      Height = 188
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object JvLabel2: TJvLabel
        Left = 8
        Top = 16
        Width = 123
        Height = 16
        Caption = 'Command to execute'
        Layout = tlCenter
        HotTrackFont.Charset = ANSI_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
        Images = imlList
        ImageIndex = 0
      end
      object Label1: TJvLabel
        Left = 8
        Top = 101
        Width = 238
        Height = 16
        Caption = 'Assign the command to the following hotkey:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Layout = tlCenter
        ParentFont = False
        Transparent = True
        HotTrackFont.Charset = ANSI_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
        Images = imlList
        ImageIndex = 3
      end
      object cmdAddEdit: TButton
        Left = 184
        Top = 159
        Width = 59
        Height = 22
        Caption = 'Add'
        ModalResult = 1
        TabOrder = 0
        TabStop = False
      end
      object cmdCancel: TButton
        Left = 250
        Top = 159
        Width = 59
        Height = 22
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
        TabStop = False
      end
      object mmoCommand: TMemo
        Left = 8
        Top = 36
        Width = 301
        Height = 53
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object cmdBrowse: TPngBitBtn
        Left = 100
        Top = 159
        Width = 77
        Height = 22
        Caption = 'Browse'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        TabStop = False
        OnClick = cmdbrowseclick
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000018849
          44415478DAB593DF4A024114C6BF9DD92B83BC3137BC0AAFC257280CB3C45EA4
          EE8308BA2F4C114322905EA3522AFAE3635457A5D8BA7B2989B033DB99D1D556
          BB49E8CC0C7376E0FB9D6FE6B046A178BC0BA086398231B66F10C03F3C389A47
          8FD3D209C68056ABF52771229140A95CF827806118E3059AF0D5A42155AEB3DF
          014AF0FAF6827EFF0BBD5E4FC3E2710BA9D51494B6D97CC4FA5A1A9248169D97
          2BC509A0DD6EE3A3F58EE44A120663787A7E183BB2AC65D8F6A7CE37D2194829
          108B2D85019D4E87DAC2C13953EDA165E0EEFE76E6EE9B992C84F0118D2EE2AC
          5A9E006CDB06E30460238002190CF5C67508B095CD410A89C84204D5F3CA04E0
          74BB43000F5C70DCD4AF661CE4B6F3E440E822B5CB8B1F00D7A1EA264C936B71
          BD312B5691CFED1040EAEE8400AEEBEAEA2637C14D46B9A9BFD55BF8D2879012
          C213B40B78C2D3AD9D72E09238000457192EA9C4420905DD9F76CFD36EC20E1C
          07CC1C0182C7540EE821250DE5220028D80C20389C0E553D88A0B28AC1603006
          CCFD3B53EC7D036587EE50ED5EC05B0000000049454E44AE426082}
      end
      object hkeCommand: TScHotkeyEdit
        Left = 8
        Top = 120
        Width = 301
        Height = 21
        Modifier = []
      end
    end
  end
  object imlList: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000028E49
          44415478DA7D935F48537114C7BF37CD0A29D2A6D95B565458B4B94D33EAA117
          E945A3E8A11E6219156D3EE45BA252E41F14877F4AA9C99C510B074110414F2B
          4D9D646A9AD8CAF5105B111BA563FFAC76FFAEDFBD77DB5D50FEB88773EEBDE7
          7C7EE7777EE750F661DB1696E51A388EBB4AD3F4669665A1080796CB7C9785E7
          F8489CA62D0CC374528F1C437D795B55C6DDC57BD6E76CD80820213DFF5A82C0
          23128DC21FF063C235CE7CF9EAEB1501ABBAD28A5CC30503DC8B6EACB5120999
          BCBF641F4C461346C65E46287204AE4C7734ABA2A21CF6A73D1012BCE4286A41
          10882D0B2F2488E6A52C0CD50DB00E5AE01C71220D282F2F437D8B91F045A744
          122407A7400201F3020773D303DC1BE8C7E8D8A802D0EB75E8B2D6CBCE440470
          D26E421240B3BF118E2C231C0B62B0ED15FAEFDEC6B86B5C01E8745AD4D49E42
          9DA9090F1D03580EFA492DC98E3C8760F83BE2F19F7221280ACEC76EDCE9EB86
          EBF5A402D09696A2B6E12CF6161FC089E3A7110C2DC3E630E34730205D25894B
          02806743F3E8EE35636A7A4A0168346A549E3C8C025511AE99AE233B6B1D2ED7
          9D938E838C60D19C7EF119E6AE0ECCBC9DC900A809E08C1E2DF53D187E62C39B
          3917321B824AA540D4E4F34FE8E86CC5DCBBF9BF01BB0E6E970A07F1BE89E3EC
          84270D60181AC72A3592ED99F7A3ADBD190B8B0B0A404D003B4B54C9B352A97A
          65A4AE64B034FB0DCDAD37F0FE833B0370488DFC1DB9FF6F434A2945C017C2CD
          5B8DF8E85982D8CABFF4DA239BAAAAAAE1F57AD3EDBAD6CACFCFC3A52B35F0FA
          7CAB0470DFAADA5678B1B0A0283B168B221C0E1309917B8F4BD747A6145C6A12
          459B7C6358062B2B41261A8B5AC423A8C8D8B693D13C4F9C72885646590A9221
          A95196FE332C4D60766237FE010275B00A65A1185E0000000049454E44AE4260
          82}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000018849
          44415478DAB593DF4A024114C6BF9DD92B83BC3137BC0AAFC257280CB3C45EA4
          EE8308BA2F4C114322905EA3522AFAE3635457A5D8BA7B2989B033DB99D1D556
          BB49E8CC0C7376E0FB9D6FE6B046A178BC0BA086398231B66F10C03F3C389A47
          8FD3D209C68056ABF52771229140A95CF827806118E3059AF0D5A42155AEB3DF
          014AF0FAF6827EFF0BBD5E4FC3E2710BA9D51494B6D97CC4FA5A1A9248169D97
          2BC509A0DD6EE3A3F58EE44A120663787A7E183BB2AC65D8F6A7CE37D2194829
          108B2D85019D4E87DAC2C13953EDA165E0EEFE76E6EE9B992C84F0118D2EE2AC
          5A9E006CDB06E30460238002190CF5C67508B095CD410A89C84204D5F3CA04E0
          74BB43000F5C70DCD4AF661CE4B6F3E440E822B5CB8B1F00D7A1EA264C936B71
          BD312B5691CFED1040EAEE8400AEEBEAEA2637C14D46B9A9BFD55BF8D2879012
          C213B40B78C2D3AD9D72E09238000457192EA9C4420905DD9F76CFD36EC20E1C
          07CC1C0182C7540EE821250DE5220028D80C20389C0E553D88A0B28AC1603006
          CCFD3B53EC7D036587EE50ED5EC05B0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000003324944415478DA
          6D937B504C7114C7BFF7EEEB6EB556F4B045E9B1D918A965462A248F5079CC18
          0CC288FE104D1ED9D5CA8CED61BDA541934735D2187F1924794449E35529234A
          5B61840AA3AD76ADDAFCEE6553C36FE6CC997B7EBFF3B9E7777EDF43F5F7F763
          F0F288D029888B26164A6CE29FF00B62F7895D682E54BF1E7C9EB20248224D9C
          CACE46B8677DD4142640E142FBF9C8B8BDDA868FA8AE6FB5E45E7DF6A3ABC7AC
          25A18304641900FC492E0BF61FABD4C52F1057D4B4E0CEE346D435B57180F19E
          4E981B2847D02477A84F1419CBAB5BAA4878060BB10276CF9AE2959CBE75BE78
          FB91EBF8FABD079A4D61F093CBD06334A3B4AA190545CFE13C5282D4B879483C
          56687A50D5AC2580FDD4D885FB15125B51E5CD9331363B8E5EC7A3DA77889CE1
          8B8CC445A87FDB0E998304C32562943CD54373EA0E26FBBA42B36126C2379F31
          1ABACD4A169096B03A64373948A9328AB89227788F024D51F8D0D18571EE0E28
          485B81DE3E0B22B6E5A38FF89D6B82A17FDF61399C57AA63010F73B5CB832EDE
          A8C6ED476F2012F221140A881710CFC7E299BED8B5763A3E7FE9424CFA550E3C
          CD6F0C4203DC109D74A98205745616C44B166C398F6F062318911022D16F8052
          E18AC309E110F068A4E63C40ADBE1D344DC1C9DE0629B1A150AECC300C0022E2
          73D0D96D8698F90D604105A9CBE03CC20E79376A70EB490BF87C9A0068384AC5
          D0AC0B2680E386812B5CBE558B87A4812C804DB697DA40454A67FF9875A51A14
          4513000F3C1E85006F6704C81DB152955F616DA27A8CF3703A3DB79403881911
          24760CA6FBBB4320E0A3A6B19DEB8780CF27001ACB67F9E095FE9365DFE9629D
          F519AB8A4F6D14A79CBD87572D1D1C44E628C5394D14F72A099925E091642181
          C947DB63499007C262B38CDF0D26A55548EAD953BDF7B2423A90578E86F75F09
          6018B2D5911C2031AB8C94CF87C26D049686782229B3D854545EB74F7F4DA51B
          22E53981F2C96971E14C4D631B586B253A6048353E6E0EF0F37280A74C0A6DF6
          5D5361595DA5F967EF5F290F1EA661B64CF2D655218CFF3817CAC76D24691E85
          E6D66F78D9D46E399453F2A3B3CBA4EDB358860ED3FFC699342B94EC71E3CCE3
          F15EF4F6F6DD27DFFF8CF32F683B4F744CC79CF60000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002194944415478DA
          A593DD4E134114C7FF335349D394DABA6D21A954BD31BE855C192082297E217A
          A53E80496D111EC0886BEB1D2104C58FA8B8A5242A11109F402E30BD315EA0C4
          60EB0542B3AD7C74BBBBCE4C2DA4DA68137777724E76F6FCF67FE69C436CDBC6
          FF5C440086D59B9D8CB147A669FA1B09A294EADC5C8B456F4C4840E2AEFAA1AB
          B3EB584B4BABD804A34C5AB108A132C8B62D585665ADAF7F8736A5E9B1E8C07E
          09B8931C5EEBEFBFA46C160B1019114AF624FE72AB9912FEC2AF04313A368281
          D810D9055CE8BBA8FC28EAA04DFCEF84CA0F898C2648A849E47259A8C9DB30B6
          4A08045A31363E5A0B387FAE4F314A3B208EAA7422E59B6619CBCB9F100A85E0
          72B950DE29C1E3F1E2DEC4782DE0CCE9B38A833198FCA6F20C2A80B9D9796432
          192CBE5BE4793F875DB6E070ECC3C3C70FF6006AE2D65A24D2ABB85D6E1896B1
          7B802295572F67B0F47E09F3B36FF07A6E061EB70746D9C0D3674F6A01DDDD3D
          4A3010C4D6F62628635205E390C8A95E4C6A93E838D181E91769F87D0A36F279
          A4A6B4DF00277B94B68361E40B1BE03D512925B7292D8595CF2B703A9DB872F5
          320E7815E4BE7D457A3AFD2720DC7648E60EF990BA4D649A16B2B9D5FA0041A6
          8CFEB50B2D0E104AEB0256B35FF0AFD910E53D1C3E520BE065FCD87EBCFDA8D7
          E76B68800ABA8E85B70BC5F8F5C1E6EA304538F93EF79B1B9A4042B6F911C5E3
          D1C1115295CC2122F9A606A7D8E0F24DE1FC04095E11F05EC3BD1F0000000049
          454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end>
    Left = 4
    Top = 156
    Bitmap = {}
  end
end
