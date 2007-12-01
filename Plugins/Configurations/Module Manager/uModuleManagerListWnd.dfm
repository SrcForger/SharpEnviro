object frmMMList: TfrmMMList
  Left = 0
  Top = 0
  Caption = 'frmMMList'
  ClientHeight = 284
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlRight: TSharpERoundPanel
    AlignWithMargins = True
    Left = 3
    Top = 69
    Width = 412
    Height = 60
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'pnlRight'
    Color = 16053492
    ParentBackground = False
    TabOrder = 0
    DrawMode = srpNormal
    NoTopBorder = False
    RoundValue = 10
    BorderColor = clBtnFace
    Border = False
    BackgroundColor = clWindow
    object lblRight: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 6
      Width = 399
      Height = 13
      Margins.Left = 10
      Margins.Top = 6
      Align = alTop
      Caption = 'Right Aligned'
      ExplicitWidth = 63
    end
    object lbModulesRight: TSharpEListBoxEx
      AlignWithMargins = True
      Left = 3
      Top = 25
      Width = 406
      Height = 32
      Columns = <
        item
          Width = 200
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calLeft
          StretchColumn = True
          ColumnType = ctDefault
          Images = StatusImages
        end
        item
          Width = 30
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calRight
          StretchColumn = False
          CanSelect = False
          ColumnType = ctDefault
          Images = StatusImages
        end
        item
          Width = 30
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calRight
          StretchColumn = False
          CanSelect = False
          ColumnType = ctDefault
          Images = StatusImages
        end
        item
          Width = 40
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calRight
          StretchColumn = False
          CanSelect = False
          ColumnType = ctDefault
          Images = StatusImages
        end>
      Colors.BorderColor = clBtnFace
      Colors.BorderColorSelected = clBtnShadow
      Colors.ItemColor = 14286304
      Colors.ItemColorSelected = 11205562
      Colors.CheckColorSelected = clBtnFace
      Colors.CheckColor = 15528425
      ItemHeight = 32
      OnClickItem = lbModulesRightClickItem
      OnGetCellCursor = lbModulesRightGetCellCursor
      OnGetCellText = lbModulesRightGetCellText
      OnGetCellImageIndex = lbModulesRightGetCellImageIndex
      AutosizeGrid = True
      Borderstyle = bsNone
      Ctl3d = False
      Align = alTop
    end
  end
  object pnlLeft: TSharpERoundPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 412
    Height = 60
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'SharpERoundPanel1'
    Color = 16053492
    ParentBackground = False
    TabOrder = 1
    DrawMode = srpNormal
    NoTopBorder = False
    RoundValue = 10
    BorderColor = 14803425
    Border = False
    BackgroundColor = clWindow
    object lblLeft: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 6
      Width = 399
      Height = 13
      Margins.Left = 10
      Margins.Top = 6
      Align = alTop
      Caption = 'Left Aligned'
      ExplicitWidth = 57
    end
    object lbModulesLeft: TSharpEListBoxEx
      AlignWithMargins = True
      Left = 3
      Top = 25
      Width = 406
      Height = 32
      Columns = <
        item
          Width = 200
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calLeft
          StretchColumn = True
          ColumnType = ctDefault
          Images = StatusImages
        end
        item
          Width = 30
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calRight
          StretchColumn = False
          CanSelect = False
          ColumnType = ctDefault
          Images = StatusImages
        end
        item
          Width = 30
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calRight
          StretchColumn = False
          CanSelect = False
          ColumnType = ctDefault
          Images = StatusImages
        end
        item
          Width = 40
          HAlign = taLeftJustify
          VAlign = taVerticalCenter
          ColumnAlign = calRight
          StretchColumn = False
          CanSelect = False
          ColumnType = ctDefault
          Images = StatusImages
        end>
      Colors.BorderColor = clBtnFace
      Colors.BorderColorSelected = clBtnShadow
      Colors.ItemColor = 16640983
      Colors.ItemColorSelected = 16571834
      Colors.CheckColorSelected = clBtnFace
      Colors.CheckColor = 15528425
      ItemHeight = 32
      OnClickItem = lbModulesLeftClickItem
      OnGetCellCursor = lbModulesLeftGetCellCursor
      OnGetCellText = lbModulesRightGetCellText
      OnGetCellImageIndex = lbModulesLeftGetCellImageIndex
      AutosizeGrid = True
      Borderstyle = bsNone
      Ctl3d = False
      Align = alTop
    end
  end
  object StatusImages: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000003524944415478DA6D937B4C536718C6DFEF5CBE83A73DA7A54541CAEC
          A45E12954C898C441350875A6C34E28C1289D7A85C3761B0C54BE29688583670
          13A8E836926566646CF3026234D17A8568D498EA020A7159ED0A65A86D29C59E
          B6E7F458FDAB247DFE7DDFFCDE3C4F9E17C9B20CB1CADBDDC89214166824A62F
          F8505D270445FFA04BA80C8B62383A0E5DFDA94A8ADD47B18082F2864F9765EA
          CD032F46EFB946C79CB55545FB3D5E2F1C693D5FBD64E1ACCD98A623BD7DAED2
          EE9395B6B8801D358D1DFB76ACDBE4F58DC3B85F80D9063D485204EC8E21D0A7
          E9408E08507BBAEBD01F27AAEB2601D69536E6A8592810C550CAD6821585BA94
          A9E0F3F9C035FA1A102240373D1992341AB0FF370467CEDF3C93A4E1997F5C7E
          4BA7A5EA365AB9E7383B5F473C599D9B6588FA8544B5129EF40F7A7A6C43165F
          40B602C8849241AB72320DE54BB33E52068341E03905FC75E986ADA7DF9B8D8C
          C54DB486F1757EB234233F2D7AE9E9C0A0BBFBEEC8FAAB6D5FDE890D6BE5AEBA
          BC354BE65C989D3E5321047CD2E59EBE1FDB8E55942153E90F3388F058D1E20C
          DDD139E929A8EBFAB323EDC7AB0F431C6DA96C6836E62CAAF07A3D42AFCD5EFB
          46C21D6863D9377F662F366C64A628400A8C83F5FEEB65175BAB6EC503AC2DF9
          766D5E567A17AF52834A41C3F57B7DBFA30D255FFF366FAE760BA212008505B0
          3D179747C3B9191F505F909B39E39C8AE7800411EEFEEDFC1999CA9A5323827B
          B39613BE4B9ECA93C3AF0873FBF75F1D880728AAACFFE5E38533B7878580607D
          E8FC0261F559642C69A25918ED48E4613D2249C490F4B8FD25B3A1FB54CDB549
          D78B8F156618F85F398EA73145C98EE157B7065CB0E61D80C5E17FFBD3A6B3FA
          604806445080491CF04ED06D0191B222005A8945538A166F55F20A2212168153
          26C0C8CBC083C70E29F77D914CC5F546AD522EF48CF911A7086EC31883924D00
          9AA481881689A0A28EA31FC0B31806EC13AD924C3A850873E5A2E5F34793AA9C
          BFF34093860F7C364D9B081EAF101201B09A638142E4845F08293E485681E37F
          A9BDCD5C5314F717F2F73664ABB0BB99E71347ECC313BDD3543EB33E550B4F1D
          4C0592DF2C484D9A92E970E3839D2DFBAC7101EF642A3F8923B28C902CA9386A
          CCCC3098740B8A43DD2D154E638985BE72AA3C1CBBFF165B486BCCE5950EBF00
          00000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000022D4944415478DA63FCFFFF3F032EE09DD1EBCFC8C8C0BC657AF13A5C
          6A187119E096D861A7E064BF9385F11FC3BDFD47BC77CC2DDF47B401EE891D86
          A2C646BB65ECCD851980D22F8F9C78FBFCEC050FA02167081AE09ED4A9C2A7A1
          B15FCAC146E6FFBFDF0C200318995819DE1E39F2E4CDF59B2E3BE694DDC46980
          4772973887ACFC3E517B7B2D06C6BF0CFFFF41E4189918810A99193E1E3D78FD
          D383C7CEDBE7943CC730C033B5878F59487427BFADA30523F37FB06660000255
          405532313130FD6560F876E2C0C96F2F5E7B6C9B55FC016E80577A3FDB5F4E9E
          4D5C964EEE4C6C4C0C0C7FFF30FCFBFB9FE1DF9F7F70FC1FC8FFF38F9181E5CF
          7F06E6FB27F6FCFDFACD6FDB8CFCEF60033C32FB2672EBDAE4FDE76463F8F6E5
          0FC3F76F40337E020DF9037109C37F906B181978381981CCBF0C7CDC8C0CFF1E
          9D99F3F3FBDF5EB001DE5993AC1999FE6B31FEFDFBF9C31F8EBCEF42FA964025
          70E7837CC9C9C5C120F1FBEA99EF6FDFF63132B370FD67607AC4F09FF122462C
          D8A44C5DF8855F2F8E1168130C80D47070733248FDBDB6665D7B5228DE68B44A
          9EB2F803974E0C13039A015C9C0C724CB7D6AFEF480CC26B8065C2E4C56F39B4
          8006FCC3304091EDF6FA0D9D49F80D308F9BBCF8358B3AA601402FA870DD5BBF
          B18B8001A6311317BFF8AF16C3C488698006FFC3F59BBA091860163361E12B66
          AD387403B879B9802EB8BD7643574A085E033CD2FB3DFFB372A4333031FF414A
          870C2CCC0C6C8CBFBE2FDD32357F05B27A0046821EB95C6F3316000000004945
          4E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000023D4944415478DA63FCFFFF3F0332F0CEEC371510E64D646466F907E4
          3232C00886FFAC1FDF7EDAB0694AFE3664F58CE8067815CD9C6012179ACFCAC2
          C8802CC5C2C2C27063DDA65D8BAAA3DDF11AE0593C7BB25664600E0BF37F5403
          58D9181E6FD9BE6F716584335E033C0A674D560EF6C36AC0ABDDBBF62DA98AC4
          6F805BFECCC9D23E3E39CC2C4071242956A0019F0EEED9B7B4260ABF012EB933
          268BB879E630035D80148260037E1C3FB06F792D01039CB2A74DE4B377CB6302
          5AFFF7CF5F867FBFFF33FC03D22C2C6C0C1CF74FED5ED910E386618077D64475
          36660665C6FF7F3F7E65E028FB2E67EEF7EFE71FA0C67F0CFFFF012D00621676
          760689DFD72EFC7EFBAA90818985FD2F03D3AB7FFF996E810D704BEB6E639634
          AC64606466F8FD8F89E1C30F2606464684F3C1A90088F9D9FE3130FFFFC3202E
          CEC3F0EBF1D92D9F3F7CAF061BE0933591E3FD2FE68D9FF9F4DC407A9818FE31
          6003BFFF3030088AF0324832DCBEF5E5D90BCF6D330AEEC1C3C027B35FE0FD6F
          B6ED1F38B52C18C1F6A186CDDFBFFF19F805791814B81E3FF9F4E891E7B699C5
          573002D127A357F2F52FEEDD1FD8D4B41919FE2269FEC7C0C3C7C3A02AF4FAED
          D747777CB6CE2C39813316BC337A549F7FE7DBF78145498609E8DF7FC000E4E0
          E264D094FEF2EDD7931B219BA7976CC71B8DE0FC90DE6DF4F8ABE0AE0F0C32C2
          6C6C2C0C3A8ABFFFFC7F712D76D3D4E215E86AB11A004ED2A95DF68FBE4B6C97
          5791E0647B732573E394A219D8D4E13400EC9DACFE10262646C5CD530ABA71A9
          010048D30BB1A9DD2D960000000049454E44AE426082}
        Name = 'PngImage4'
        Background = clWindow
      end>
    Left = 344
    Top = 216
    Bitmap = {}
  end
end
