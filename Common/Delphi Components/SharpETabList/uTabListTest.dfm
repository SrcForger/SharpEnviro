object Form12: TForm12
  Left = 0
  Top = 0
  BorderWidth = 10
  Caption = 'Form12'
  ClientHeight = 548
  ClientWidth = 548
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SharpERoundPanel3: TSharpERoundPanel
    Left = 0
    Top = 24
    Width = 548
    Height = 300
    BevelOuter = bvNone
    BorderWidth = 2
    Caption = 'SharpERoundPanel1'
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    DrawMode = srpNoTopRight
    NoTopBorder = False
    RoundValue = 10
    BorderColor = clBlack
    Border = True
    BackgroundColor = clWindow
  end
  object SharpETabList1: TSharpETabList
    Left = 0
    Top = 0
    Width = 548
    Height = 25
    Align = alTop
    TabWidth = 62
    TabIndex = -1
    TabColor = 15724527
    TabSelectedColor = clWindow
    BkgColor = clWindow
    CaptionSelectedColor = clBlack
    StatusSelectedColor = clGreen
    CaptionUnSelectedColor = clBlack
    StatusUnSelectedColor = clGreen
    TabAlign = taRightJustify
    AutoSizeTabs = True
    BottomBorder = True
    Border = True
    BorderColor = clBlack
    BorderSelectedColor = clRed
    PngImageList = PngImageList1
    TabList = <
      item
        Caption = 'NewTab-1'
        ImageIndex = 0
        Visible = True
      end
      item
        Caption = 'NewTab-1'
        ImageIndex = 0
        Visible = True
      end
      item
        Caption = 'NewTab-1'
        ImageIndex = 0
        Visible = True
      end
      item
        Caption = 'Hello'
        ImageIndex = -1
        Visible = True
      end
      item
        Caption = 'ABC'
        ImageIndex = -1
        Visible = True
      end>
    Minimized = False
  end
  object Button1: TButton
    Left = 160
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 241
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 322
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 4
    OnClick = Button3Click
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000002474944415478DA8D934B6813511486CFB9F36C6CA94D9556F005E2BB
          A028A2A52A41BB688DAF0651044B25209A10084137EA42C842BBD04C8B44C51A
          37E242D4B43581AE248A8BBA70D38D6DE9C28514A9427749A69399B99E998C22
          B58BB97067E6BEBE73FE7BFE41CE392C6F2713C3D1B68DEB2288CE881EDC829F
          DF179EBF7B98CC2FDF8B2B01C2379EE5F60D9C8F2A2A02E70CA05A85A917AF07
          DFDC8FDDF405E8BD3E92DD7DF16C5C561970CA002B3ACCBC1A4FE71FC4EEF802
          F4A49E66B79C3BED010084AA01DF460BFE01DD8947994D7D67529203A065C930
          60BE50B835AA25EEFD073811CB5C686C0CECA16F5E275AF692D2D41B381CDA2F
          C9E84E32DD007DF2C3274B373E222273A0CC5156D5BF60772A575A1B3A1E42B0
          C0366DE0D42D0BC0E0B617A28E56180341A4532203A4D38A284079B234814713
          2345B6ED60D8AA2C8165D4216EDEEE794F9E534F2724754600B14184A6D60028
          739FF3D875E549B1DCDC1166546B77237A2FFC47A8C3FB735504B7691058A542
          5BED6B1E8F5C7DFCDE5CD3710C1D80D78C1A879AF9377B10040455263F38B21C
          5F11446D90A1B93C3D4197A8450459DA4B736E0C4622162BC2A94565C70144EE
          981056B7C8D06ECE948CAA5E221DA2A70AED9A39B56219BB2E0F0DFD92772529
          30581434D822417B6DFAF69816BFEBCB079D03C3D905B63D4E77E6EA0D5206EB
          71363D9689FB33D2A17E2D3B6F6F250015D7B6A135A8C266692E3DAEF90474F6
          6BB91FB8334AA5274F7002C8B081CD0E12C0DFCFD4734DBBC4A54004EA4604C1
          B180A9BF2C66936F97EFFD0D653DFF941F0EA4F50000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
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
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000035B4944415478DA75937948D36118C79FDFB54DB7A54BCB32D4A9D12C
          D0924AA48364F38A6A4118EBA0143353679E85AB0C4DBB832EDD349D68770992
          4407455A825A8106A65648EABA33CF596BEE77F6FB2D92A2FAFEF3F2BE3CDFCF
          F33EDF971789D29B106FDBA71DFE04B9E4252B6BBC66CEAF81FF282AB5C4CDCF
          F641CF60227BBF64BAF151593A896CD1E5669D5662A7A6CE554167570F1806A5
          71B76BF6D7FD0B707843DAADAC10EF55148A41ED5B6BDB4DC6630FA2DD5AA43E
          E83270377879B808ECDFA1A1BD7BFC08E9BDF241555EEBEFE64DBA5D29253E50
          E6111A0AC0B13064B1409205CB44388E83445DEEFE5381A22299D21FB0AF56A8
          EDB67C28C302A31F56E6BC10CCD109071715B17D0FC3C3426513080A12CA0167
          7B867A6F70B3C29C80883493483BDAD9903DCF6BD9848B0C243CA4BA7FB8E7BC
          6B901A61284E3FD6D1BC3E38C0FFBBC415C47CF7DEE131C819714FBE6536543A
          01823449278276D3AF5BA37C3C1576040391ED2B540C383A09CAC125FA29421C
          523970340D626A020E0C132D8F453E9A4663AA631220685D7CE1E643F8FB4BBE
          536440F27BD43A069CCD0634C500C3AF52868426DF20FB497150644359A633A3
          3F0082B627EC2BCE1BEAD82BFD3280D2DFBE01E720816318205816AC2A151404
          6A8A6ACB0D05BFEAFF02AC4B2848CC6AAB3FA71C1DC2291C0704410078B3582E
          83D3E16B5A4F541D5BFA7BFD2440AD2F9DB1F873D7515D4F4BBC6264C4390208
          66417C0D8E22D011306FF0824A9D595F61B83A0988D19B24EEB6818DABFB5A0B
          C3FBBA7C193B091486FD34F39D71969F1FC34168E3CAD2F0C62F10CCC131F997
          AB8B0F390149DAE433299DF733E4A3A360E7DF9843D19F683E7117B9143E2A3C
          C1F3AD853FC780E5A1129A82F199DE50B320B6AAD7734E36A28BCB49CFBE632A
          91F1D7A4700268BE50304F1113F07C59B4BD72569821E2D9BDADABBB9B17B280
          0285E24038260094BE707CF99642449356EAA17D7ABD2B00A16688FA7B619A75
          04C4521778B53492342B5724DD31665DD464947BCD7FD554B1B6FDBED67D7C0C
          083EDC374B22C0A88A8D7386B82AEDCC2212C7DDA6BF7B1995F8A42ECF1AB298
          36CF560BE6F3BFC28ACC36A38AC1FEF4D88E7BF95EEEF26997E6461EBB56B1CF
          F0D733C66D2B4E250957EBCDF2DC2BFFFA91313B4D01284BFBDC35663409FB1F
          D850791CAD3FC7470000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end>
    Left = 516
    Top = 136
    Bitmap = {}
  end
end
