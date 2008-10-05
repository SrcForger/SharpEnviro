object SharpBarMainForm: TSharpBarMainForm
  Left = 20
  Top = 20
  BorderStyle = bsNone
  Caption = 'SharpBarMainForm'
  ClientHeight = 210
  ClientWidth = 434
  Color = 13290186
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Images = PngImageList1
    OnPopup = PopupMenu1Popup
    Left = 384
    Top = 40
    object BarManagment1: TMenuItem
      Caption = 'Bar Manager'
      ImageIndex = 13
      OnClick = BarManagment1Click
    end
    object PluginManager1: TMenuItem
      Caption = 'Module Manager'
      ImageIndex = 2
      OnClick = PluginManager1Click
    end
    object QuickAddModule1: TMenuItem
      Caption = 'Quick Add Module'
      ImageIndex = 9
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Skin1: TMenuItem
      Caption = 'Skin'
      ImageIndex = 11
    end
    object ColorScheme1: TMenuItem
      Caption = 'Color Scheme'
      ImageIndex = 10
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Position1: TMenuItem
      Caption = 'Position'
      ImageIndex = 0
      object Top1: TMenuItem
        Caption = 'Top'
        GroupIndex = 1
        RadioItem = True
        OnClick = Top1Click
      end
      object Bottom1: TMenuItem
        Caption = 'Bottom'
        GroupIndex = 1
        RadioItem = True
        OnClick = Bottom1Click
      end
      object N1: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object Left1: TMenuItem
        Caption = 'Left'
        GroupIndex = 2
        RadioItem = True
        OnClick = Left1Click
      end
      object Middle1: TMenuItem
        Caption = 'Middle'
        GroupIndex = 2
        RadioItem = True
        OnClick = Middle1Click
      end
      object Right1: TMenuItem
        Caption = 'Right'
        GroupIndex = 2
        RadioItem = True
        OnClick = Right1Click
      end
      object FullScreen1: TMenuItem
        Caption = 'Full Screen'
        GroupIndex = 2
        RadioItem = True
        OnClick = FullScreen1Click
      end
      object N2: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
      object Monitor1: TMenuItem
        Caption = 'Monitor'
        GroupIndex = 3
        ImageIndex = 4
      end
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
      ImageIndex = 5
      object AlwaysOnTop1: TMenuItem
        Caption = 'Always On Top'
        OnClick = AlwaysOnTop1Click
      end
      object AutoStart1: TMenuItem
        Caption = 'Auto Start'
        OnClick = AutoStart1Click
      end
      object DisableBarHiding1: TMenuItem
        Caption = 'Disable Bar Hiding'
        OnClick = DisableBarHiding1Click
      end
      object ShowMiniThrobbers1: TMenuItem
        Caption = 'Show Mini Throbbers'
        OnClick = ShowMiniThrobbers1Click
      end
    end
    object N3: TMenuItem
      Caption = '-'
      Hint = '-'
    end
    object ExitMn: TMenuItem
      Caption = 'Exit'
      ImageIndex = 3
      OnClick = ExitMnClick
    end
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001984944415478DAA592314B425114C7EF157230C13410AA
          C1A9211EAD7E802488263F806B202118F1C02142A4E9C15B5CC2A9492A0AEA41
          B36343E2FAA831D30AA406071DDE7BF79ECEB9F725824E7AE170CEB9F0FFFDCF
          79F7710060CB1C4E807ABD0EE572992F0CB02C0B2A950A7FEC8C27E308C998C4
          4E048C05580742E7A3BD189F0154AB55A8D56A0AB01E8F30F92FC62CC22CF1A2
          F72BD8F17E7C16609A26D8B6CD1F10908A4526420205A198FACF1FC14A077300
          C562111A8D06BF7F19437235A2DC69640288504C751F2738399C0328140AD06C
          36F9CDF318A6F795380AD50A408182D379807C3E0F8EE32CFE0AB95C0E5AAD16
          B79FBE677E0A81F6018EE363F63D609E2F98EF4BCC925D96B6B90264B35968B7
          DB0AB0958A2AA1C47B29A60001AD8311608FE2D78F11BB327734C0300C705D57
          01369351FDE10485169058F898C39EEEDDF711BB3E33342093C940B7DBE596F3
          051B6B2BE804DA895C95BBAE0545087FEB8DD8EDF9AE06A4D369180C06FCE2AE
          0FB49BE709E54AB5EFE9F1697F416BD17B866702482412301C0E177F8565CED2
          803F8CCE5DF0EA7493B50000000049454E44AE426082}
        Name = 'PngImage10'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002B94944415478DA75535D489361147EBE7D73CA309713AD
          25E5C074962C88A645843785E416682089BB2809BB51A8BB306FBCE9EF222F8D
          5D488BE170FEF5E3451045171651CE0C4CF26758986BF3A7A96BD37D737376CE
          578A4E3AF0F0FE9DF739CF39E77D858D8D0D24DBC0C0C0DD603078796969E900
          AF3333337D1A8DC6515656D69CEC2B2413F4F5F5E5C4E3716F4D4D4DCAF6FDAE
          AEAED8FAFABADE6AB5FA7611FC8B584B110FD19E82A2A1B0B0100683017C3E36
          3686A9A929900FDF4990A21FE4D3C98A640262972862EA26EBF4F434DC6EB74C
          C236313181D2D252E4E5E56D5714A53B690249B6D3BAAEA8A8080CB6C1C14104
          02012C2E2ECA6BAD568BACAC2C9494946C29F2783C20C59D424F4F4FCC68342A
          5756562008024451C4E4E424AAABAB77D4A6B7B75756148BC5100E8741F5E0B4
          E2427777F772454585667575553E6092999919E8743AE4E7E7CB9739FFD9D959
          646767CB676C3C27A541817259369BCD9A442221B3864221F87C3E28954AA854
          2AD999A37ABD5EA8D56AA4A4FC6D0E175A2670B95CCB168B45C397A97D60A2B5
          B535B0229E2F2C2C201289C8A931292B64DFF4F4740C0D0D0505A7D319ADAAAA
          52F126D781478EC8643CCECDCD41A150607CFE13611861E937A46804C6DC5350
          87F645858E8E8E5794EF392E504646861C99B1A9C8EFF7E3EBBC1B01711C278E
          9A70505B8037A3CFF061F42D94BF72BD82C3E150516BAE106EEAF5FAC3DC4A96
          CBB5902449CEDD39DC8A8B96F380A840E591EB78F0FA1A4428E07ADA2F6D3D65
          BBDD9E43F31B840622D9CBAF90553041CB937A34581B612EAEDF6A6BFF9736DC
          B1DDDEFD17DADBDB8B69AF99506B3299047A2C68797E159517CE824A8C5BE58F
          71EF651DD2C4D49D0A92CD66B395D3591341F5E2DBA39FA9FBC3974E1F3B8302
          DD7178FC9FF17EE41DBCDF83ADFF2548B6938DBAFB343410F6104284871FDBFC
          4D7F00647D8987E961B0F30000000049454E44AE426082}
        Name = 'PngImage11'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C0000017A4944415478DA
          6D914D48025110C7FFCFCC22A1D508A90E259429D42D3C7A8BA82E1D02C14B75
          B6A05B84F7820E752F90A228C9D24BC76E752BA363501928BA6484EEE247DAEE
          FA9A5DB32F9A81C77B33BFF9CFBCF71847D32ED7E5B9421F6017857D5FA81965
          4D20EE5033FED6C63EAA68CE80F8055065A0D00F930017DCE0B8C31364A06E4F
          0B115F888068D5DFA6B329240801EEE1C54043A9E66F67F15D2CB8E1A1E315F2
          E44017B9D7507A4421C24E955173190C2D78C0ECE73C315252508686A4CA4EA4
          49A182122119F46090D249E4D04D27D07A2DB3A83425D4892D428419160A2BC8
          A203FA853A75E0589A1634A8A8E31D155A5FF146EDCCA4A8C18A1B991DD5662C
          9AD14F214CC10B4CC61C0A2156246AECF0BC77DC456215725DE999EA416A362A
          1291BF6007163ECF579C436E4A1451A5FEA0A44A43E652D8E461E3A9F71C7C99
          073DB661D2C890B4887489EFF0ADA5EC8FBF088FF0100F8C318990528CAF2DDE
          FEF92CDDB627F82AB7F08DE0D977EC17F09F7D006A1A99FC2862604500000000
          49454E44AE426082}
        Name = 'PngImage12'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002394944415478DA95D3DF6B92511807F0EFFBB2DE8D99BB
          A8D936D0045DC348222F3496631821D1FE022FBC18CC0B2F0C242F0441F0B62E
          BB928A6EBAECA29B88A08B201A5430D26ACEADE18FE9D6FC999B9BFAEA7BCEE9
          75B1BDC9DE8B76E0F03D3C703E3C1CCEC331C670D6B5FAECFE434AC90342A426
          771660ED79F0A77C715AD04D22935BC5455EA89C00B1588C514A71BC092127B9
          6465E041218C4FE2BC691A945024DFBFC218E514201A8D32BD5E7F74E6386E20
          67F91F18B73BFB15745B3590AE88F4CA3246BB920244221166341A072E1F9FED
          34019D0C74F77741A4AE5CE1B19EF804A1DD51807038CCCC66B32A7043FC8C09
          C71CC4BD5FA04700878D6F2BE09AFB0A100A8598C5625105AC071F30E59847A7
          B1FDB703C66133950469541520180C32ABD5AA0A5CF9FD0E06FB3CDA8D2298D4
          C184AE8CE58F35742A2505080402CC66B39D7AC07E1A4BAF6174B8D0AEE7A1D5
          D471D9B08BB76FDAA817CA0AE0F7FB99C3E15005A60A2F61BA791BAD5A1EA01D
          8C8D89482677D1286614C0E7F331A7D379AAFD7E5ED87C8199D93B6855B3203D
          F90D381EC5E2162AF90D05585C5C642E974B15D0A69EC072CB8DC36A4E063A72
          6D08C59D6D94B22905F07ABDCCED76AB0242E231AE39EFE2B09201ED8947C076
          B9849DCDEF0AE0F178D8C2C2822A802F8F707DEE1EFA152AF520892DE4B26B28
          6C242A5C3C1E67E9741A854261E0FFFF9B1E530E1AAD16C3231A0823A338270C
          A379D0C0D6FAD7CA7F4DE3D325C3257974CD84F4AECAE88C3C917A7E48F0909E
          B8F707176E4CA84725F0CA0000000049454E44AE426082}
        Name = 'PngImage13'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002754944415478DA9D935F4853511CC7BF777F5CEE4F6ED6
          429D77E6603D143D88B91E0A049FEAA527C1271F6A193130E78B4F7B680369B8
          1A6CA3461B3E546083C47C58827BD88256D90A271943B1DEAD406212B3EEBD3B
          9D736E0B9304E9C7FDF1FBFDEE3DE773BFDCFB3D022104EBEBEBA45EAF83A5A2
          283C6559E6559224DE37B231B33A343424080C50A95448474727BE55AB009DA1
          5EBC27BC903F3DAB369B150B0B590C0F0FAB80D5D55562396CC568AC8883C4ED
          EB1E145F3C87D7EB5501E57299D86C47311A2FA25374C26C3440B49B70C8A0C3
          8E4420C975480AA050094BA53222D7FA90CFE7E0F3F95440A95422767B1B6E24
          5E42747641103468B11870CCDACCFB9D9F0A7EC8043211505E5EC1D4481F1617
          B3F0FBFD2AA0582C927687137E06E8EA864610206834303537C16AD243A7D372
          250CB2525E41F86A2F9E65E7313131A1020A8502119DDD18BFFB1A4E0A609B35
          3459D55298C9D804AD56C3BFEF325570EB4A0FE6E76711080454402E97232E97
          1BE3F796D075DCC53772C86F250D9840E7B50FEF3179B907B34F66100A855440
          369B25274F9DC658E2D581FE4278E40C1E3D9846381C5601737373C4E3398BEA
          F636350F815EAFC7E7CD4D982D2DDC035B5B5FD1DED68E5AADC601168B19E9F4
          7D44A3511590C964EE5067F5EF72592BCDBCC3E1F0B2796363639AD6017A6F6B
          972B9F261289490ED81B943C46175C3A77BE7FC06AB5E1F1CCC31A9D6F52C953
          7BD7FE0588C7E376FA962F6EF709B41EB14391056A220966B3119F3EAE51BFBC
          F91E8BC5CCFB022291C845511417060707B94CF68C25FB0B3A9D0EC96492D9FE
          422A955AFC27804530187C4755F4EE3E818D9349EBDB743AEDD957C1FFC42F3F
          8877F0911979D80000000049454E44AE426082}
        Name = 'PngImage14'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002274944415478DA8D91C18B12511CC7BF63CE3A6D6D6B6B
          0B1591B1D42199F6506097DA830489E02188FA07224118E9561825B18844208B
          A048A2970A895834A296E8A479288BC030B7D196AD69C3C0157777C63674C6E9
          8DD542E5A63FDEEF3DDECC7C3EEFF77B43A9AA8A7E9148242E753A9D8BE4DB43
          6485CBE5A27FBFA3FA09E2F1B806FB1D0EC73009249349B8DD6E6A60412C162B
          D9EDF6C3344DA35028A05C2E83E3B8C105D168B4ED743AF5B55A0DD96CF6B9C7
          E3990A0683AAD60A49B9AF201289C8A4822DD56A15F97C3E4B209DD96C3EC1B2
          2C52A9D4FF05E170D84E8027369B8D922409A2286AA7826118E8743A643299F9
          9E825BB34B21A5B57E72B836C75AAD56BDD67FBBDDEEC28AA2743397CB7D23FB
          ABFF086EDE174226E310272B2A24710DA72D2D08828062B1A8F5ADFCEABD42F2
          B6CFE79BF9431020F0F80E9A3BB0672B3AE4F9DB45098DFA0A46EA8FBF1380F5
          7ABD0B7F57BB21F02785D02E23CD4DEC66B0BCDA86568171BB1E6F2A223E7C11
          F3772E1F39DEEB9EBA82E97B1F43E3A3066E622F831A81579B320CB40E3B47F4
          78C58B78BFB4FE2075CD72AEA7E0FADD4552B6813B48E03A811B1AACA730A6C1
          6509F39F9BB30F7DECD9CDFE147525B1A04E4D1AB1BC42604906434ED6E017BC
          049EC08F6E6C0E77059E48453D75740C5F1B2D28B20AD3E84FB8F4494CCF4D4F
          9E419FA02ECCF0AFF799868E59F66F83D2015EF26B2809CDF4537F7F78E312CF
          074AEF5A322C2D3291917E16180CD6E20770933A74CA760DAD0000000049454E
          44AE426082}
        Name = 'PngImage15'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002954944415478DAA593ED4B536118C6AF33DBD636734C13
          7599914E320B3243C9425351316C516964122E2A08C5FD0581627F4120414484
          1A884403732A4A6AA010256192F992DB7CD964BE8496DACE1967E7799E8E130D
          6B7EA9EBD3CD03D78FFBB9EFEBE61863F81F717F023C566B1223B44202A96462
          20968282316991803653465A4E3C6F75ED0998AFB1964A9434441C37C5E9D2D2
          C019F4805F4060D18BD5DE5E7C5F5D59208C584FBF68B3FD05D83413429A220B
          7275BAB45320AE3160C9038822B87003B8230958B177C133EBF4512259325ABB
          6D3B00774D4DA2DCF660544E96519B910ED2DF0E5EF0832301A8554A70948189
          7E20351DDFBADF607EC9ED254CCA3EFFF2ED74103057555DAB3546D5475EBB0A
          FABE0F84DF802008D82F0ABBE6437C02949979986C7C8A3525EA725E0D3C0C02
          66AAEF3B620A734C4AC90F7E6E0AD2A80BA1A48AD543119300DF9A80F12F03CE
          5CDBBBE420C059758F4FB852A2E1A646C0AFAF41FFE05148C0F24D33940603C2
          CE9CC5C7F64621FFF590360870DCB5F0878BF3359CE313A8DC85A6F6C99E00EE
          801EEACC7318EA782614B40D6F0126EFDC72C4A4269B344A02C93D03DEFB2374
          6A140AA8534E62DD2F6262A4C759D4F979EB0B63B7CB6BD5FC46FDA1EB3720F6
          74802A24043602BB07B8B96E850AFA8B660CDB1EE3A7C8D715778D6F0D71D452
          9648146CF0A036C21899970BC16E87BC6B304240C0C96E2A23F621E2D265B8FB
          BB30B73CEE251CCB2EE99C98DE09D27085B99432A9293A3C4A179D570871D605
          D1E5021529D4C74C50C51F85A7CF8E9995291FE5A84536FF0ED2B63E9417C969
          941AD4448C8B4FC992D7660CBEF35E379C6303E0897F41365BB7CD218F69B0EC
          42129302155218AD6494C4CA0705B95E94EB662A492D25DD5FF73EA67FD12FCA
          BE71F0E82977BB0000000049454E44AE426082}
        Name = 'PngImage17'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000000FD4944415478DA63FCFFFF3F032580718419E03FD37DF7
          AF1FBFBCB7E7EFFF4596019E131DBFFFFCFEEBC9BE8AA3AA2806949CC8009BF2
          F7F75F863FBFFF30FCFEF587E1D7CFDF0CBF7E80F02F869F400CA2258524197E
          FDFACD70F3F6AD4BA73B2EEAA31860256CCBF0F71FD0807F7FE0F8F7DFBF40FC
          9BE1F73F20FE0B14FBFB074C9F3B7F96E1E68DDBA7AE4FBF6D0E36A0F070EA7F
          0B516B84669042B001BF21F41FA80150B973E7CE33DCBA7EE7E89DB9F76DC006
          E4EE4BFC8FCBD9403F83D95C1C5C0C9292520CAF5FBD66B87DE3EE05A0664392
          0251BF40CB0268C17EA0458F809AD5C98A059564C51DC040F67BB0E83179D148
          71421A9C060000DB7FEAE1DBB736010000000049454E44AE426082}
        Name = 'PngImage20'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000000F54944415478DA63FCFFFF3F032580719819507222830D
          486DEDB198E14AAE01B7FFFEFE2BD36F3B9B936403809A2F8AB349E8FDF9F387
          E1E1BB870CBF7EFE66F8F503847F31FC046230FD1DC106C95D9C708D116C0050
          F34931567133451E65863FFFFEC0F1EFBF7F81F837C3EF7F40FC1728F6F70F84
          06F257AF5CCB707DFA6D88018587538F88B28959CBF32A42348314820DF80DA1
          FF400D80CAFDF9FF8761CDB2F50C77E6DE67847B216347EC79613611030E664E
          86872F1F32BC7EFF06ABB3415EFBFD0B68C8EF3F0C0F163D664409C49895C137
          810AE5801A1C37A6EF3C41722C842DF465036ADE04D4EC31300969681A00002A
          EDDDE1EE0C96E70000000049454E44AE426082}
        Name = 'PngImage21'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002BD4944415478DAA5935D4893511CC61FA79B2E5147989B
          1F11393517A2859A14AD297993941012A951E285177D48924965305951525E04
          F346F1A29412224548574E45243315A4462853E647687EA492B8ED7DA77BCF79
          DF5E375C507A53FF73713817CFEFFCCFFF3C8F9F2008F89FF2FB1350D37D5B4D
          795A4828BD422851119E82A364493C37897BB331FFE5D4AE809AEEF23C42F9DA
          FD4A7564A22A05726908DCBC1B3F9CF318B4F562797565911052DA50D4D2FA17
          C02BA68D69F1BAE08488644CDA27B0E49A07C77308938521421E8D810933C626
          AD8CD859D1AB928E561FE0695779ACD876FF11F589A804650AFA16CD6019169C
          4010141408415C9BFC2634A149F834DE838999A9058E106DDB8D9E690FA0BAB3
          4CAF50EC33641DCAC5D0CA0738DD0C1886C19D0C83A7BB479FEFC1C5D8219106
          2043A545536F3D180757D571B3EF8107F0D0546A4BD5E8E236256E4CADDAC477
          737038ECA83E6DF400AEB55C4288420AC2132488B3D97430300DF74C9A6F7D8C
          F700F46FAFB29947CFC9271C635873AEA1F2D8E31DBFACACB300A1720592C2D3
          50F7AEC1D55B31B4C703A86C2B618FA764CBADF651B8E806AA526B760584C842
          91AC4C87B1BDCED57F77C40BA86829B6A90F6AE2F84001DFEDB360B90D30CB76
          345C78E3136E95C44F82F8F0C360D759B40C9A2607EF5BBC4F287B7D59BF2161
          0D67532F6260AE0B1B94838CF7C393EC173E004F05C82401C88CCBC1B30E23D6
          1DCEAA11FDA87788D79B0B62394AFB9511E151E9EA5318F8D6E91998F8B510E8
          16428054E20F9D3A07668B0943E35F1744CF682D06EBB4CF48C5CFCF8B46228D
          D12A65B036311B73EB33985F9B81C0F388D91B8B98D003786F69C7B0759411ED
          5D248A7F1B69BBF2EBCFE4897EAFA5FE2452A739096558E4D6E598FB390BF397
          5ED89DECA2282EDD16EF18A65C63965A841472BE3011314CD41326CA93668B61
          7CF730FD4BFD0276F996F0D72273FA0000000049454E44AE426082}
        Name = 'PngImage25'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000020B4944415478DA63FCFFFF3F032580911C038ECC149262
          60E45EF9F3DBF7BD241B00D22CA1917C5E58C144ECD4CADC0F241900D42C0BD4
          7C4E5CDD43E4EBB3A50C67B76DFD4BB40140CDF2121A49E724D43D85FE7ED9C2
          7064C5B2BF3FBF33FB1065005CB38697102BC301869B870F30DC397FA738A8F5
          591F4103809A55819A4F02350B8234DF3A7A88E1F6D95B0B809A1309C60250B3
          86B87AE209492D6F7ED6FF0718EE9E3AC670E3C4B5E3DF3EB3D8C74C7AF41BAB
          019BD6CE6766F8FF9755F05DBDB2845AC451292D1F7E96FFFB191E5D3ACB70F9
          C0F94740CD0640CDEF61EAE1060035323230FCE3016A4E07D2C97C6FDA64749D
          4B7878F8DE30BCBA7B83E1F4D623DF819AF5819A6F235B0836A077C90A2669B6
          6F225C4C7FE63330B0383330FC6563FAF99081F5D93C4655635386C7371F333C
          BEFEC605A8792FBA37C106742F5926F9E32FE354BEBF4C81F6A6AA0CBA0A6C0C
          DF3EBF6138B073DDFDDF77D648006DCE076A9E8D2D9C187B162D66FBF18721F5
          F737862962AA860CEF9F3D6178F0EA378308C70F869F9F9E6DD37B3D352D61E2
          CDA7B8029AB16EDA92B58C2C5C416C7CE20CCC6C820C1FDE7D6678F49E87E1D3
          D30B1FC4D85E99CFED2CB8852F9A19B35B66FFFBF6FD37E377A0337EFCF8CBF0
          EBD71F065676BEEDBCACDFE72CEECB5F47289181C360D3E2721686FFBFCD18FE
          FF7163F8F77B0690FE060CC8FF7E49F33E1332000079E406F080813ABE000000
          0049454E44AE426082}
        Name = 'PngImage26'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002874944415478DA8D935F4853511CC7BFD7514350AE4E5D
          388811381637C27A18D5436116246241ADC4B79E8A9E6C09862C6621C98AB205
          3A071141E09310852162E10AD339FF204BA6ACAD898EE16CEA9C3AB7DDFFDD7B
          C14049DCF7E5701E3E9FDFEFFCCE3984288AD89BBAE79E471CCBB53234DB4F67
          E886D197B50CF609B15720C18725387DD658AC9A9A8B6339BE7969CA79DD9DB3
          A0E6E93029705CD264D060D21FC3D29F8D3AFFBB86FE9C05D5B62192679864A5
          BE18D38118CE1C15DF7634DFB893B360F0BBD7DEFA61B9E5B88EC4ECEF38EE5D
          398262D55A93D96C761C28181F1F6F2B28246D775DB3D84866C1321C3EB65FC6
          CCDC2CF2D4057486C7CF4D9AFF9661C5170FEB2FACED1278BDDEB6A2A2225B59
          59195EF7FA505D598A818918EEDF3A89FCFC7CF40E0CA3F4180546C84338B234
          B496E11EA419714111783C9E368D46A3C089440213810482D14D507A0DCE9F2A
          872008088542F831332FAACB0D3854A825FCF3D1E61423BC214646461E979494
          3CD1E97458595901CFF350A954204912D96C16344D8365592C2E2E2AA2AF9301
          B180AA22E2AB89F842923D41B8DDEE76A9B255ABD5627B7B1B7247322CAF7237
          322C4BA3D12882C1202291C858C658774E55588AE950B44539425F5F9F43EAC0
          623018942A1CC72930C330CA7E7D7D1D7EBF1FE170784C9255250DD7E82C27F0
          BF56D9D3FF86D8D3D3D3A1D7EB9B64492A95423A9D56608220E4DB412010F048
          DD5CECECEC646EBEFA22C652DCE0686B6DCDAE6BECEEEE76545454588C4623B6
          B6B6A056ABE1F3F9E4212B70575797F227A896CFB7E79E5D7DFFDF8764B7DB1D
          1445594C26930C421AB2023B9D4EE6C087B413ABD5EA908E6291AA2BB0D459EE
          BF71278D8D8DF512FCC9E572ED0BCBF90B1DDE84746DA062E00000000049454E
          44AE426082}
        Name = 'PngImage27'
        Background = clMenu
      end
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
        Name = 'PngImage28'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001EC4944415478DA63FCFFFF3F032580116440FCE4F38540
          B63C10DB00B131030350F03F0323C3BFFF0C4C4C8C0C40C4F0EFDF3F867F7F19
          3EB0B2FCBFA32EC36702922B0DD1608419307B61AE610A293677AEBACE501EA6
          0937E006D000F53947DEC115E0F358AA8D104362CFB19FF34BAC3820064C3CF7
          6161BE113FC80055717688DF18B16BBEF9E227D880889683FF57D4D833810D88
          9B70F6D7A20263D6D9482E6020E082F0C67D0C2BEB9D205E88ED3BF36F719109
          2351BAA120B46E0FC3EA26178801313DA7FF2F29316508A9DFC3F00314DAC000
          D8D6E2C670FFD947AC9A15A5F819426A7632AC6971871810DD75F2FFD2327306
          87B2ED0CCE06D20C5BCF3E6138D1EB053680978B0D45F3E76FBFC00604576C63
          58DBE1053120AAE3C4FF6515160CC6795B18BCCD6519361C7FC870698A1FDC80
          DF7F2171C2CACC083720B06C13C3FA2E3FA80BDA8EFE5F5A65CDA093BE9EC1D3
          529E61DB91FB0C57E704E33520A0680DC386BE10A80BDA8EFC5F56650336C0C3
          429E61FB515403B079C1BF7005C3C6FE088801114D87FEADA8B3630419F0FFEF
          3FB0429801B802D12F7FF9FF4D132321E920B4E1C0BDD50D0E8AA444A36FDEB2
          779B274509430CA8DDD70FA4D580D812986B04FFFDFB034CCBFF80E82F1083D8
          201AC807E75C10F1EF330303D365A001368C9466670041D215F0A4AD78920000
          000049454E44AE426082}
        Name = 'PngImage30'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002604944415478DA85935D48935118C7FF67EF6699A82392
          6A52B458765110E4D64D19E1452054A0AB8BE84229BC88B0D475B1D84DF97193
          D54518F6E117215D4497051911F485B2694E05238746E8C0B51C6BCD6DEFDEB3
          737A36D9456BAB03870387E7FCCE737EFC0F3BEE1C7B5A566AB0E874304AC814
          C0C0A484CAE55A24A60E2643A1871F1E9C4AA0C060F62EB7F799CB56F23D2A14
          461B820E6B2901BD020C8F8731E9F6BF59595EBEFCBEEF442C2FE04CB767FE7E
          6BB5FE734040D14924B94024CE71ACAA18DE00C7D462042F5ECF3D7ED959733D
          2FE074B7C7D7DF56AD2CFC10E9EEA111E0573285DD4681B24D066C3430B4F5CF
          8847970E5A0A0206DAAB956F2101EA1E9A90886B025FFC3FCD2AE7E0044C8F79
          FF6A8C09C92209BEBCB4141F21373DE426CEEC04186AB72A4B619929E40450B5
          143C0B41F3C55A13825181026E9E939BB3ACA1CBE31B7458157F38FD024185EB
          9077732BE673874DF88F9B5E56DFE9F60D5FB5292B1140C7900108EAFAD5ACDF
          DC78C4847FB969BC3925597DC7846FC071400946F57F019A6A4CC87513274894
          E6A19D1BE0E89B91ACE1C6D4E2BDD65D88248C7F00460970BEA612B96E545A13
          04DABFBD08577AA98393AEF1D921A7B5848BF59B748C9248A027630173D3D14A
          E4BAD1A828A64AECDDAA47CBDD4F92D539C746E9484592A31C90F1CC8321515A
          AEEC2337C875439743A5C0575500176E4F488ABDCC9BF186CE498DDCE873DD64
          01962D1CCDB7A60B03EC1D5E99CF4D16B0C31846CB9DAF2808A8BB36BE3AE2B2
          6DCE7593892F4D85BE6F73CF64B220A0D6F1F1ADA2637BA8741B3959CBBA5907
          304A358F96971415FF069DF9921C980053860000000049454E44AE426082}
        Name = 'PngImage14'
        Background = clWindow
      end>
    Left = 320
    Top = 40
    Bitmap = {}
  end
  object ThrobberPopUp: TPopupMenu
    Images = PngImageList1
    Left = 352
    Top = 40
    object Settings: TMenuItem
      Tag = -1
      Caption = 'Settings'
      ImageIndex = 5
      OnClick = SettingsClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = 'Remove'
      ImageIndex = 6
      OnClick = Delete1Click
    end
    object Clone1: TMenuItem
      Caption = 'Clone'
      ImageIndex = 14
      OnClick = Clone1Click
    end
    object Move1: TMenuItem
      Caption = 'Move'
      ImageIndex = 23
      object miLeftModule: TMenuItem
        Caption = 'Left'
        ImageIndex = 8
        OnClick = miLeftModuleClick
      end
      object miRightModule: TMenuItem
        Caption = 'Right'
        ImageIndex = 7
        OnClick = miRightModuleClick
      end
    end
  end
  object DelayTimer1: TTimer
    Enabled = False
    Interval = 750
    OnTimer = DelayTimer1Timer
    Left = 392
    Top = 144
  end
  object DelayTimer3: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = DelayTimer3Timer
    Left = 352
    Top = 144
  end
  object ThemeHideTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = ThemeHideTimerTimer
    Left = 312
    Top = 144
  end
end
