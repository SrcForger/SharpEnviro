object SharpBarMainForm: TSharpBarMainForm
  Left = 20
  Top = 20
  Width = 434
  Height = 210
  Caption = 'SharpBarMainForm'
  Color = 13290186
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
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
      Caption = 'Bar Managment'
      ImageIndex = 11
      object CreateemptySharpBar1: TMenuItem
        Caption = 'Create empty SharpBar'
        ImageIndex = 4
        OnClick = CreateemptySharpBar1Click
      end
    end
    object PluginManager1: TMenuItem
      Caption = 'Plugin Manager'
      ImageIndex = 12
      OnClick = PluginManager1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Position1: TMenuItem
      Caption = 'Position'
      ImageIndex = 10
      object AutoPos1: TMenuItem
        Caption = 'Top'
        ImageIndex = 4
        OnClick = AutoPos1Click
      end
      object Bottom1: TMenuItem
        Caption = 'Bottom'
        ImageIndex = 4
        OnClick = Bottom1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Left1: TMenuItem
        Caption = 'Left'
        ImageIndex = 1
        OnClick = Left1Click
      end
      object Middle1: TMenuItem
        Caption = 'Middle'
        ImageIndex = 3
        OnClick = Middle1Click
      end
      object Right2: TMenuItem
        Caption = 'Right'
        ImageIndex = 2
        OnClick = Right2Click
      end
      object FullScreen1: TMenuItem
        Caption = 'Full Screen'
        ImageIndex = 4
        OnClick = FullScreen1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Monitor1: TMenuItem
        Caption = 'Monitor'
        ImageIndex = 14
      end
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
      ImageIndex = 15
      object AutoStart1: TMenuItem
        Caption = 'Auto Start'
        OnClick = AutoStart1Click
      end
      object DisableBarHiding1: TMenuItem
        Caption = 'Disable Bar Hiding'
        OnClick = DisableBarHiding1Click
      end
    end
    object N3: TMenuItem
      Caption = '-'
      Hint = '-'
    end
    object ExitMn: TMenuItem
      Caption = 'Exit'
      ImageIndex = 13
      OnClick = ExitMnClick
    end
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000005074
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          20666F7220746865205368617270452050726F6A6563740A687474703A2F2F77
          77772E7368617270652D7368656C6C2E6F726736B087FC0000015E4944415478
          DAAD93314BC35014854F53E89C9FD0203875F34714AA93088243A09851D12A48
          B3B876D44109622A88E23F50084EA2CD2244842C894826856AD490414A631BDF
          0D26566962A11E384320F77BE7DEFB5E0E632AF71F80706C40756927FAB8BDB9
          86D13A84E7792315F33CFF0DB86BF3787F3C4F00AEEB6616EBBA0E5114B30186
          61409665388E837EBF0F8EE32008021A8D063A9D4E36800A1545C1957E8952A9
          04D334615916F4968EA67A8072B90C4DD3860354558524497872DB28140A9859
          DEC573FB014A7D2E4AE3FB3E6A2B6B3F87380828168B383E394A4EAEEF5D4480
          E6E602C230846DDB499204401B2011807A7DF55EA2C84110442012C148DD6E37
          4AB25895D2EF81E7BF25A793E204B1081E0386E98301F27182C1167E25E8A501
          2C36FDC9116660A7012ACCA7B485D9F5FDA405D2C6FCD4E016A6B31ED316F36A
          DA3D60DA66AEFDF51A2B5FA009E63C738FF99E0A99CFE8874F813B0836ECA4EA
          B80000000049454E44AE426082}
        Name = 'PngImage4'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000001D74
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          EF64256E0000005F4944415478DA6364A010300E0F03FE536C4062CE1430E7E2
          F9D30CE78E2E64F8F0E103519A0504041006DC7E29C0F0EDD96EB8016FDEBCC1
          ABF9D8B1630C717171A306201B008A01100019B068D122A262016E0091518E15
          0C8EA44C1100009D17700855D591430000000049454E44AE426082}
        Name = 'PngImage5'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100403000000EDDDE2
          5200000018504C54456170003C55A4616C94A2A2A2DCDCDCF0F0F0000000323B
          5F8FE597A00000000174524E530040E6D86600000001624B47440088051D4800
          0000097048597300000B1300000B1301009A9C180000000774494D4500000000
          0000000973942E0000005174455874436F6D6D656E7400437265617465642077
          697468205468652047494D5020666F7220746865205368617270452050726F6A
          656374090A687474703A2F2F7777772E7368617270652D7368656C6C2E6F7267
          BAB0D29E0000002D4944415478DA63648002463C8C341823F503883C13C2987A
          1FC8F8F43A942846F2052083F9A33FC21CDC760100147F1717E86516B2000000
          0049454E44AE426082}
        Name = 'PngImage6'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000005174
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          20666F7220746865205368617270452050726F6A656374090A687474703A2F2F
          7777772E7368617270652D7368656C6C2E6F7267BAB0D29E0000007149444154
          78DA6364A010300E0F03FE536CC0870F1F3024040404181273A680D917CF9F66
          3877742103BA3A901AB8016FDEBC4191545151011B70FBA500C3B767BBC106DC
          B973072E7FECD83186B8B8B8510360062C5AB408231640922003403100022003
          D0D5C10DA0341D500406DE0000EECB85085FEE3EC10000000049454E44AE4260
          82}
        Name = 'PngImage7'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000005174
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          20666F7220746865205368617270452050726F6A656374090A687474703A2F2F
          7777772E7368617270652D7368656C6C2E6F7267BAB0D29E0000004249444154
          78DA6364A010300E0F03FE536CC0870F1FC8D22C20208030E0CD9B3724693E76
          EC18435C5CDCA8013003162D5A44926618801B40966E28181C49992200009608
          3C08E199F8B60000000049454E44AE426082}
        Name = 'PngImage8'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000001D74
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          EF64256E000000E74944415478DA6364A010300E0F03FE536C4062CE1430E7E2
          F9D30CE78E2E64F8F0E1035C81808000C3E7AF560CEC1C67813C6686EFDFAC19
          F8797733DCB973874145450561C0ED97020CDF9EED861BF0E6CD1BB0825F7F94
          199898EF32B0403DFB07E8DE3F7F6C1838588FA0BA009B012000320404603682
          0CF8FF9F938195E93B710620039001BFFF3133FCFC3E8181873B97340360B6FF
          FCDEC2C0CD55C3B068D12286B8B838E20C80D9CCC8F8171C1620EF1C3B760CD5
          00500C8000C80090E9E800A4180490E5E0061013DF7FA0AA58D0921EB129F13F
          9A018CA41AC080E452143D14E7050081D699088316966A0000000049454E44AE
          426082}
        Name = 'PngImage9'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F
          5300000033504C54450700071020431A2650222A5C273667354375464D7C4957
          855C658F6878A28F97B79EA09DA5B0CAB5BDD2C4C6C3F0F2EF131731FB5EF882
          0000000174524E530040E6D86600000001624B47440088051D48000000097048
          597300000B1300000B1301009A9C180000000774494D45000000000000000973
          942E0000002074455874436F6D6D656E740043726561746564206279204D6172
          74696E204B72E46D657221A6840B0000008C4944415478DA5DCFDB0A83301004
          D0D9A4D6C420F5FFBFD2A2A4B998DD8A895ABA6F7360609670DF8419A09F9C8A
          9D77985A5EC62015A402452ECC071018C87D280EB592D83054106A15442438F5
          6197BB03FC10258B56D6771584BC2EF9C98E4B0351111B44990BD68766769BBA
          407444BF5ABA00C9F8C11B9CB001615CCCBEB6BB7F5946E0FD3A96FEDD173FD6
          5511ED9412180000000049454E44AE426082}
        Name = 'PngImage6'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F
          5300000033504C544507000702204012335523477033465A444643465F7B6B6D
          6A5978957794ADA3A5A2A2AEBCBCC4CCC4C6C3DBDDDAF1F3F00001005A9467D4
          0000000174524E530040E6D86600000001624B47440088051D48000000097048
          597300000B1300000B1301009A9C180000000774494D45000000000000000973
          942E0000002074455874436F6D6D656E740043726561746564206279204D6172
          74696E204B72E46D657221A6840B0000008D4944415478DA458FD10AC3200C45
          6FB04BB73DB4FEFF57CACA365B9B64D1618D10BC8743E01222FA24C4772144FB
          C7C2295A7E542064FE84617672059A5D9895A127A76EC0947D273423481004A3
          E46603805138B8E60664F2CF39E102B4DDF4896160BB0B8E65801C76E57DED20
          7EE6AFCC4507D8439E3CB72E0DBC98A4ACA937F41B2F60B9B283DA7F64FC002A
          885031474656ED0000000049454E44AE426082}
        Name = 'PngImage7'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100403000000EDDDE2
          5200000018504C54450000002748693C5F846986A49EA09DC4C6C3F0F2EF0000
          000F4AF5F50000000174524E530040E6D86600000001624B47440088051D4800
          0000097048597300000B1300000B1301009A9C180000000774494D4500000000
          0000000973942E0000002074455874436F6D6D656E7400437265617465642062
          79204D617274696E204B72E46D657221A6840B0000002F4944415478DA636480
          0246D218E560BA9391A1789F29903F13C858E7F281E1D34E20635EF00306E69D
          486A48301900DDE80B113423071A0000000049454E44AE426082}
        Name = 'PngImage8'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100403000000EDDDE2
          520000000F504C54450000009F9F9FC5C5C5F1F1F1101731A802762100000001
          74524E530040E6D86600000001624B47440088051D4800000009704859730000
          0B1300000B1301009A9C180000000774494D45000000000000000973942E0000
          002074455874436F6D6D656E740043726561746564206279204D617274696E20
          4B72E46D657221A6840B0000002D4944415478DA63648002463883C5014CEF61
          64D107D10FDF30B2E87D00323E5191A1FB00C8607E83B00B663B008E0E2111AE
          01AD930000000049454E44AE426082}
        Name = 'PngImage9'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000001D349
          44415478DA6364A0103022733ABA5A7D80D46620F6AD28ABDE82438F0F501D5C
          0DBA01FF53125318E6CC9FC380C310B0E6F4D4CCBF33674F6706CA3332A21B0F
          3224232D9361C6ACE90C20059872D940B9A920395FA0D0164698B3418A61ECA2
          825286BE09DD2806C0E498989818CA4A2AC19AC1610032352FA7E0FFD66D5B18
          EFDEBBC3909F5BC4F0EECD6B8613A74E30383A3A35090989D4E30B1BB8ADD999
          79FFFFFEFDC3F8EFDFBFFFFFFEFD653877F60CE3B98BE7C161812F6019D1421F
          0EBCDCBD192E5DBECCF0E4D92310B709A8B99E603422831DDBB7FEBF70F90283
          A19E11C3F94BE760B1B20D48FFC36A808257BB24907A06E3C75AFE6330D05265
          90959163F8FAF52BC3C93327B0462D23B2E6DE4257B0E0F91BCF19966CBFC290
          E1F0AF09C8ADF3F1F46378FDFA15B22170973002351B80F4CCADF365D87DF402
          D80029092986BEA527191E6CAB8407724C642CC3A3870F180E1D3B8C12262003
          FE836C3E7DE906C39FBFFF18D8B8851898FEFD07BB0064007220FB78FA327CF8
          F081E1C8F1C3F0340237E0C2B5DB0C7F59F8187E7CFBC9B06EFF4D909C2BD080
          3DE80949425C92E1C5CBE7A80614459B337CF9FE0BAC70D6BAF3189A910C6904
          524140BC0ED90B61407A25923AAC9A710100A73EF711857162E2000000004945
          4E44AE426082}
        Name = 'PngImage10'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000001D74
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          EF64256E000001344944415478DA6364A01030E29270ADDAF71FC6DEDDE6C448
          D000CBD08A081E55B7E520F697DBBB2241ECF2605586CEB5B7E17C6C863122DB
          08D270EAD67B86FD97DF30C88B7132586A08331CBFF196E1E1ABEF0C8EBA220C
          666A826003910D413100A4485C9003A77F5FBEFF01361CAB01302F44D8C930DC
          7FF995E1D4CDD75F057838B93F7CF9FED5465B9C5B5A989361C5A12760EF1C5F
          DDB102C5005880C19CBDF2D083AF7F3E3EDAF5FDD59DD56C7CE2765C92DAE121
          360A8230EF20870523B2FF1FBE8648EE3CF792E1F1F9AD51409B96035D16296B
          E8BDCCDD481C2C272FCA89120E585DB0FEF8E39F5CCCBFAE3EBE7CB0874B4A37
          9D995BD424DC4E811BA70B90C300E4920357DE305CB8F7EE27173B1B3B280C3C
          4DA4B9F9B858718701556281E274801C1664A5448AF302B9806203000299CB11
          7C4EC6680000000049454E44AE426082}
        Name = 'PngImage11'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000001D74
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          EF64256E000001354944415478DA6364A01030E292E8E86AFD0F635794553312
          3420343CD8C7D8D86833887DF6EC395F103B2D259D61D69C99703E36C318916D
          0469B874E912C38953C719A424A5190C4DF419CE9FB9C8F0ECF953060B334B06
          3D3D3DB081C886A0180052242C2E88D3BF6F5FBE071B8ED5009817BC7DBD189E
          3E7ECA70E1C2854FFCFCFC7C1F3F7EFC646A6ACA272621C6B075F336B07756AF
          5CBB05C5005880C19CBD75F3D64F2F5FBEDEF0E4C99335424242364A4A4A895E
          3E1EA230EF20870523B2FF9FBE7C0C963C72E808C3BE7D07FC80366D06BACCD7
          C9C961938D9D0D584E5A5C16251CB0BA60D78EDDDF999898CE1E3B76BC0B687B
          BAA020BFADB7AF371F4E17208701C825A7CE9C60B87AF5DA772E2E4E4E5018D8
          3BD8F3F1F0F2E00E03AAC402C5E900392CC84A8914E7057201C50600006627CA
          1182385C210000000049454E44AE426082}
        Name = 'PngImage12'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E000001E649
          44415478DAA593CBAADA501486FF78BF2B3A702438117D0B27E2CC79DB549B78
          A2A7A7141C3813DB4141281DB71E3DB1369ED6F60514D4A12F214E7C045110C5
          7BBB76C896524AC1FE10C84EF6FAD6BFD6DA5B78FFA1F606C03B5CA7B7C22FC0
          597C9ABB2ABAFBE3110CF0EC49168220C0E3F1C06EB7B3F7BFE97C3E63B158E0
          783C5E00E4C008A60DFFD2E974C272B9C4B7EF1D1D901525F8FD7E1E3C9D4E31
          180C7E73E2743A91CFE761369BD97AB55AA1F3B5AD0372CF65F87C3E668B2449
          D21F5927930946A3114B44DA6C36D01E3FEB00297703B7DB8DC3E1C07E168B45
          2412099E8D821A8D0686C32177BADFEFF1A5D3D201F20B85D56F382897CB48A7
          D3D8ED76088542CC7EA95442BFDF87D7EB657B686F5B5375405E2AC06AB57207
          954A05A9540A8140002E970B369B0D8AA2A0D7EBB1353930994C68B59B3AA070
          F392112923A95EAF2393C920168BF17AABD52A6AB51A1F2595FCD0BAD70145E5
          8E051B00555521CB32C2E1306F22B9A2322C160B0350D39B6A5D07DC165EB12C
          06A0DBED221289201A8DB2F576BBC5783C86288A70381CEC1C048341341E3E5D
          00D4559A2D693E9F43D334760EE81BD94D269388C7E3ECC0D17702DC373F5E00
          D41472B05EAF799767B3196B2ED9A6874034051A254138E0EEF6F55597C900FC
          CF75CEFE045D4DF64CA1F962990000000049454E44AE426082}
        Name = 'PngImage13'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003574
          455874436F6D6D656E74002863292032303034204A616B756220537465696E65
          720A0A437265617465642077697468205468652047494D5090D98B6F000001CB
          4944415478DA63ECE86A9DCEC0C090C1401E98C10834E0BF87A70759BA776CDF
          C1003760DA946D0CC78E5E2742DB7F062B6B2D86AC1C2F540362227B197C7D1D
          18FEFE052AF9FF9FE1DFBFFF0CCCCC4C588DD8B6ED00C392E5C5980678793960
          D5F0F9F30F869F3FFF020DFFC7F0E6CD7786870FAFE137E0CB979F0CDFBFFF65
          F8FAF50FC3AF5F7F1918191981A28C0C4C4C10FAE6CDB3B80DF8F8F117C3BB77
          BF913431C0D930FAD2A5A3D80D3033B361F8FD1BA6019586D90E629F3CB90FD3
          00E2638181C1CD5D8F212EC115D5002E4E4E6004FD07C7000803990C3F7FFD04
          510CAC2CAC10710688384C0DCC00CA522294C109C47C651525C7ED6CEDB9EF3F
          B82BF2F3E74FA65FBF7E41920ED056212141062D4D9D9F1B366E78D1DF3BC117
          28FC11846106F001B1407C625CAB87BB7BA48EAE0EF3BB77EF183E7DFE048CC6
          9F0CFC7CFC0C22C2A20C5FBE7E65983265CAF115CB56E6430D780F33801B88F9
          C323C3FC3F7FF9ACA9A9A91124232D2BA4A4A4C8C1C7C7C778FBF6ED5FB76EDF
          FEFEE5F3972FCF9FBF58B071FDC6355003DE3022F9870B640810F3A6A6A714FF
          FDFB97FDFFBFFF12CCCCCC7C7FFEFE79C1C8C8F4E9C3FBF717D7AFDBB00B9438
          81F835107F6764A0100000FC59FFE4206AE8DF0000000049454E44AE426082}
        Name = 'PngImage14'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003574
          455874436F6D6D656E74002863292032303034204A616B756220537465696E65
          720A0A437265617465642077697468205468652047494D5090D98B6F000002DE
          4944415478DA7D935B48936118C7FFDFF7EDC0E614726B273C2C0D1C45B839B5
          2E82EAC241184D671E0A15A3030C22BA34081212AABBC8EEA228C5E5CCC3BCE8
          445D08821174B1696413D4A5356A9B6D959B3B7CFBBEDE6F8A96650F3C3CBCBC
          EFFB7BDEFFF33C2F85757BD8773F537BF418CD732C595100CF83871078307C18
          2C94F0783DF04C79B3E72F5EB884DB776E09273700DCF15A1B158FFF049BC920
          C3B2A06906C82C43C6CCE0CDBB5CBC9FF900BD4E87C3878EC039E0C4FECAAA4D
          40FFA35E7E8F712F92C955E249B06C067ABD0EC12F5F21123398989C44614101
          AAAB0E607874081673054A4B766D025C2E276FADB1E2D98BA730979BC0302241
          80A004914814E313E3A8B7D9313A3602D3BE72A8544AE4E7EFF80DF0D8C94B44
          324C4F4F41ABD5C05C6122F7398181C5A525984D160C0EBBB2CF96C96588467F
          40A19083EABED67595A6E92E3014D2490E25A5062C2C7C242F20C5A318141515
          62F1F3A76C12B95C8E3C850239248AA552C865325037AE77F3E7CE3B788661A8
          9E9E1E949595C1E7F3C1E170E0DB721823234368B0D723994A22100820168B65
          613C4F419EB30E68EF388370388C31B71B0683017EBF1FB6BA3AA25385DE07F7
          D0D2D2048EE3904AA548815360D3292C4722C8CD51FC09F81E8DC2EBF5C26834
          42ADD16C00ACD61A6CB5C4EA2A543B956B00BBBD891444F1D7A1959515226110
          CDCD27F02F63C89CACBDA0FD3442A130288A2243C48223D54FA7D3D06AB4700D
          F4A3B1B121DB528616098D85582C01231281A6E82CE06D6B5B8725180A82222D
          CB10AD825E964D43A7D3E3D5CBE7B0D96C1B595344BFB09F4824108FC5B380BE
          93A7DA5AA3447F9A1449C89EE1481632484A322C6EF71014B90AD28594709F25
          E58F93FF11904AA53E12E704C0D90A4BD5DDD2D2DD102042A5850C6AB51AB3B3
          3E4C4F793A3B2F5FB9896D4C00E44924922796CAEA83C5C586ECEF13CCEF9FC7
          FCFC1C42C1A0860082FF03C848D4127F4D5CB365BF8078980092DB017E01A10E
          4D81E4DC3EC00000000049454E44AE426082}
        Name = 'PngImage15'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000008C74
          455874436F6D6D656E74004D656E752D73697A65642069636F6E0A3D3D3D3D3D
          3D3D3D3D3D0A0A2863292032303033204A616B756220276A696D6D6163272053
          7465696E65722C200A687474703A2F2F6A696D6D61632E6D7573696368616C6C
          2E637A0A0A637265617465642077697468207468652047494D502C0A68747470
          3A2F2F7777772E67696D702E6F7267678AC7470000027C4944415478DA95935D
          48935118C7FFEF3BDD14B7D80457496B3357B1BCA9C89004BF2ED2A22E0C4211
          0A136F62B2B94C2C379D8BAC99A62922BB088CA2E8C2BA29CA6EC25558992D90
          2C74929AD644D7E63BB7C28FB7B7F7634D061AF98773385FFFDFF3F09C73888A
          C61ACB6430999CF32D5100546C2B605B5A2CC92CCAE27EFED82459BA75DF7EC5
          8C7544E455769CD6ECD269D49B95E37B53922AD58AF8FDA1151A9F3C0B78FFD6
          F9DB3D3583DD8AA1ED5DB67BDFD604E8ADF6AEE5C0DCD91586C40C2DC72F4912
          4431B128C93F84D4E444DC78F00AF4B40B1AB16F2DBF8DD09B0C4C4DB511AAAD
          3BF0E5EB67784312DC7D398201D730AACA8BE0F15278D1FF06B6B2A3D8A3498E
          3843A1106A2D3520CE55EB99667B07288A02C330088428389E0CC1F9C18DDC9C
          6C28A53178D8DB0763613A72F7A5B13973760662B11866CB0510864A3DD3DADC
          0E3F358FE3E6EEA8FC38C0F8DC0226865D51EB8F1BCF402291C05C1706B45C6B
          83DF3F8FC9EFA330385EA3B4B8102313531103C9864DDDB605B77B1EE1549E16
          27733211171F074BFD4501D0DCD40A8220303B3B8B498F1B55370779887B629A
          0764E8D4B8DEDD8392EC149CC8CA805C2E074DD3A8B3D6AE02B8A248A5D228C8
          F9F26278838BB8C3462ECA54F166A552896030089148B40A68BADA02AFD78B84
          84041EC2E9E3A80B26473F16976994E5EB507AEC304892442010E083C96432D4
          37980540FA81836C5DC305DE80DE0D0E0800438589BD19264C2020D0D88E21C2
          5301BF53ABC5D8989B9D11FCD18ECE360160B35E469FF3796483E147D1CAC9CA
          832251019FDFC783B97DEB258B00686FEB44EFB3A7FF4CB720FF087F53DC63FB
          2BA3A96215F03F5A0FD0C065B3C1FA453ED31F836D12127A8242580000000049
          454E44AE426082}
        Name = 'PngImage16'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000007049
          44415478DA6364A010308E1A4045034C52979C0152C644EA3B7B66768C09BA01
          FF7BF25C187EFFFB0F16FCFDF73F8A8EFFFF2118245737731F03D000460C031A
          D21D191EBEFE0656F80F681010317CFBF59FE12FD0B03F20FE3F060625094E86
          A9CB8F603580322F0C7C2C8C6003004EB23711482851F60000000049454E44AE
          426082}
        Name = 'PngImage17'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003574
          455874436F6D6D656E74002863292032303034204A616B756220537465696E65
          720A0A437265617465642077697468205468652047494D5090D98B6F000002DC
          4944415478DA6364C002ACBDCBDBFEFF6788FEF79F519A8191919189F1DF3366
          C6FFAB0E6FE92A4657CB88CCB1F02C576466663C9899E82DEBE964C8C0CFCBC9
          F0FBEF3F86D7EFBE30ECD8779E61C9CADDAFFEFFFF6B7B7873D72DAC06D8F856
          3C9BD29121A9AA2C75EDF3F75F577FFDFEFFEBFBCFDF2CBFFEFCE5626566527F
          F8E8A55A47EFD28FFBD7B70A601860EB5BD6979EE05B18E86D7EFDD7EFBFA758
          5998FF7FFFF987F9CB8F3F2C5F7FFC6679F7F9FB5F6626469D13C72FEB6CDBBA
          7FF1DEF59D712806380454BD5D3BBF4AE83703E35A6E0ED6CFECACCCFF3E7DFD
          C5F2F9DB6FE68FDF7E327CFCFA9371FBE9074F7D4D654B1B9BE77DDFB5BA910B
          C5004BAFCABF0737B6303D7BF775191F171BAF200FBB2FB2F70E9DBD7168C69E
          47BB4A830D5AB20B26FED790FCCE327F4EFF3FB80156DE55FF76AD69607CF4EA
          F30A0E3616064509BE88371FBF9DFAFAED3BF3A72FDFFEECBFF2FAE4A12B2FDF
          9485183615944E0619C00B34E02BDC00D790BA2FB327E673BFFEF27B1D30E03F
          9A6B88271EBCF864C6D75F7FFFBF78FFEDD7FE0B4F5EB3B03209865ACA174F9E
          B8E2D78E15B5EC285EF00AAFDAE5E7EBEC6A63A37FE3D2BD377B221DD57396ED
          BF39F5D1AB2F9FAF3C7CFBF9C3D79F6CF1CEEA61572EDCD0BC76FED28D350B6A
          35510C484C29E47AF699FF6D417628078F20FF952DA71E6EEF48B22A0D6EDA56
          CFC3C3CAEF6D2CEFF9E9DD7BCD75ABF7FE96E07EA30874FE538C74E01F51ECFB
          E33FEF1A57170B3633530D062E4E0E6042FACBF0EEC3578693A76E309C3975E5
          0F3FC7B7FCE5F35AA6614D485097087FFF2F74EAF30F06F9E840516646A00A16
          160686CDDB5F7C61FEF3510768F3439C49190622239D785859FF7CEEED6F66E0
          E2E66478F1FC214363FD6486458B0E61A8C765003BD0801F4A4A720C1A5A1A0C
          8F1E3E62B872F906F10680405C9CDDFFD68E9AFF0202FC8C0FEE3FFFDFDDD9C7
          48AA013EB76FFF88E4E515707FF5EAD55E3D3DBEC54003B6A0AB0300031D5420
          FEB387BB0000000049454E44AE426082}
        Name = 'PngImage18'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000018F49
          44415478DA636440020A5EED2E406A37946BF8605BE505060280115D7355A6C7
          57117E6EEEA28EB54419C288ACB932DDEBCDB6334F44A48438187C2D1519B29A
          5612348411A6393BC6E5E5BE4B2FC49125337CB518F25B57E1350464C0FFB264
          97D7CF3FFF1305099CB9F10A2C61A22106A65D0CA418E2AB9630000D60C46900
          88C1CAC2CC1011640F36E01FC31F06330D29861DBB4F32BC7EFF15ACF0DB8BFB
          704DAFCECD821B066728FB75FD8F021970FD05C35FC6FF0C565AE20C8B571D64
          30D2D540B1F1E0CE6DA4196061A6CD70E9D24306A6FF4C0C9ABAF20CFB366DC4
          6D40988F358A6DABB61C65B030D124DE006C81646AA4CD70F5CA3D0626065606
          4D1D5986FD4003FEFEFD0B967B73712E23D69015D14FFE3F7D4219C3DA8377C0
          FCEB571E83699001202023C0FC7AC1FCD5A2F80C300052E79B1AF318662E398E
          226761ACF072ED8AD5A0F4E20A34600F5603900DE968CD6758BDE332C39B37DF
          185CEC54DFCC9DB95804A619250CF01952579BC5F0FCCDC7AFB3A72FE546D64C
          D0006443A05C14CD44194008000089C3BD1140AA64380000000049454E44AE42
          6082}
        Name = 'PngImage19'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000023D4944415478DA
          9D935F4853511CC7BFF79E73B6F647254645AD97C08751F4D64B942F3DF560A0
          0F3DF620480641F590935EA27A58B48208EC0F4BB1BF209422CC94C1EC9F390A
          D2FEB828A720688D1ACEDA72DE8DBB7B4FBF3B6A312BD17E97730E5CCEF7F3FB
          7B142925FE66756DA2D734D03572410F631953FE05D8755CE86E67B591CB674F
          3E0BEAC1FF029C3BD6C5AFF604B499E4A4154D1345A3AF1CD02AF46B27FAB901
          1D772397F2CFDF3C1E378BD84B90F93F00BBFD629C8EDAF24F6B31A857FC61DB
          A77C1C1BED3E0C8DF5157BA33753D2C01E824C5400AC70CF3477726113608CD1
          52C138C31AE140223B0C063BBC8EED98987D2D433DC19C512C3612245A01387B
          E80E8FA71E810B1516880B06CE055D31014931991C5EE73664B25F71F9DE29ED
          BB96F18F9CD7DBCB8040CB6DFE2A19F909E0A50818E3505595BC28908602D390
          D8E0AC854DBA100A07B4E4DCF4F532E07473078F266E2067A64BCB500AA87178
          5065F7A0C6B61E55621D160B393069C326B70F03B16E6D6AE6DD70197070BF9F
          F78D5F84840166B36AA040654AA950D61DCBBBCF5307AF6B2B069FDE5F4C67BE
          744B132D1500DD2C5007E85348AC5A27D0FFA1BD94C28ECDFBC08B2E0C90582B
          E4DAACFC7F17B155A41C7697FB9737DAA98DD23C507FC41579DF819D5B1A909E
          9F9343B1070BA6693450071E2E6DA325762F99A5D95254461E6F275FEA63F1D8
          67BA6ACDC0D48A47B9A9F1287F323AA84D7F4C8C52BEF524CEACEA2DACADF6E8
          DF16D2B7487C98C4C6AA1E138DF70B127692308465EC075F403F60A310CA2F00
          00000049454E44AE426082}
        Name = 'PngImage20'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002424944415478DA
          95935D48537118C69FF3B1CD734EAE1C3A3494B4143469925D086D99612C5399
          B01A52561782095A50D47215941715342B08FA0421E84E89BC8CA26E52C1CB2E
          0ABA120ACACAD4C1DAF4ECFCCF39BD678AAC5A32FFF05EBDE7F93DEFD7E14CD3
          C45ACF7BDED6C10B383B7E536BCA96E7D602F82ED82E17380B2FCDC77ECA93B7
          342E6700B9DA79114FB7965607FA4257A4F0EDE3781B5DCA0D40E2222AF995AF
          7E7F4D6773BFC36197D07BAD2D3700896B391E6F42FEEEC2464F4098513FA03C
          BF1EA7EE0496D4A496F7A712DF2787B4E25500895B45D136D27BE8A2B26D732D
          F725F91E3AAFA2BA602F0C53876118D0990E5DB7C2C0C0BDA3181F52B934C01B
          B685372AAEC1BEE055595614CC243F82130C0A82731C4C02688C81690C5A8AC1
          E3F663E0FE916580372C3EDA525C75A2BB352225B4187E2C4E4310391253F016
          C0A40A58DAD502304DC7CE9283883CE85A058C96B92BDADA1BBBE4D9C42724D8
          0236C84EFC627388B359C45314EA1C444850041724DE850395273138DCB30CD8
          7DCEB243345FDED4DFDE149216D4AF78F7ED25688D1494A216A8079A01680626
          F49481C375113C1CB901EB36328778CC263A1EFBF774C8926CC7D4E7E7D04C15
          414F380DB03E338DE505F09CF02F6005D240962F7CBB9A9D15A555C2C4F433B4
          D4F460782CBA6830D39EB945DDD4E7698DEE6C87544A2DBDDE5E5957DEB0A3C9
          916753D26EF4A4BF6E885105EC7FA72C1364B4A4A86C5F8B37283F19BB8B75FD
          0B2B106BB8D769B867E28998B46E4006A89316717A6248F365CBFF0638740CF0
          29CA03AE0000000049454E44AE426082}
        Name = 'PngImage21'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000001D74
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          EF64256E000001ED4944415478DA9591CB4B1B5114C6BF3B9947421A15457191
          8D528A48DD5895181FD168A4B5BA2B74D3BA10A114BAF1CFF01F70D14D915668
          372E5C482908E28331C6D75205A52DDD150A46AA196732C73B999B492646D003
          67EE9999FBFDEE77CE65B867D085FA14D09E01523D60FF038C348B5C1F31E7E7
          8FD595377CF97C97381CFA85E686341A6A4FA1295918660DF2767EB93EB2FBA1
          08A054F2C5DDC79B8B80F515602DDC401B377084F3F343D4860F5F7B80D1E1E7
          689D98ABAA9F1EDFC1CCE4311ED5CC2052370B32E7615C7C4450FDF9CE032413
          29C4DE7FAB0A78D9A5E355FF3EA24D1D90D57684D553645D07090F3034380AB2
          A9343450B100A31348F61224CA80B1BFFC5323CE7E47F138FA49F100837D49D8
          B65D90B1C243A88B0BFD41007BBCC882A427D8D0FF233532C93CC0407C1879CB
          0255D82FBE3B1B89DC352007B0A9AF616C64BC04E88B2560991CC01C07A20156
          461034E2F65445C1D6F6BA1FD0DB3300D334DDDE859AF1CD5485A4AA2AF49D0D
          3F20D6DD0FC3307CC68998EF7867B703D4821AD2992D3FA0BB338E6B23776B06
          AE21472CD4DC8D03C8ECEB7E4057670C579739716F15BD57442814C4EE41BA62
          06BC05CBCE17AED06D9B89BA442AE7FA1CAC7C5F9E921579010F8BB71CF0A57C
          4A124F99A7E60C5AA45C76B0C9F392E795A80B71031144DE1BC072759E000000
          0049454E44AE426082}
        Name = 'PngImage22'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000DD700000DD70142289B78000001A84944415478DA
          636440020A5EED2E406A3788FD605B25230301F0FFFF7F064674CD65C92EAFBB
          E6EE1125C90098E6EC1897979F7EFD135FB1EE20C33F34C577379531623500A6
          B932DDEBCD86E38F444C34C45014FDF9F58761D596A3780DF85F95E9F175EBA9
          67DCBF7E23D9FB1FC2365016216C405F4530C3EEB38F191EBCFC0696F8C7F087
          01163CC64AA260033E3EBC09E21ABEB938F702BA010640F6F96975E10C93375C
          658079819909E2829F3FFE810DE828F467C82CE84231043910C1864CAC0E6338
          73FB0DC38EDD2719DE7D84B8868189094C991A6933D819C830D4D54F821B821E
          8D604316B6C530C4572D6130D5D76460E36406CBFDFD0731E4FA95C70CB90956
          0C15D513C186BCBE30E7024AC0C00C01DB0834E0C6ED2730DF323031B0825912
          12BC0CDE0E1A0C4DCDD318800630624D2C624669FFEDDDBD186EDD7A06116064
          82CBB1B03033B839287F9D3D7D2937410398D95951C4415EF070D2783377E662
          1120D71568C01E9C0620F3418A1CFDFC19F8D9995FAE5DB15A1CA41918887B50
          02111F10D14FFE9F9018FA7AC1FCD5A230CD28D1488C0150265C33DC00104109
          000085A9D9E1135466440000000049454E44AE426082}
        Name = 'PngImage23'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000001D74
          455874436F6D6D656E7400437265617465642077697468205468652047494D50
          EF64256E0000014D4944415478DA9590CB4AC3401486FF6913B1AFE123140BB1
          6AB5B11595EEDD18F7BE80EFE00BB817DDB855A897D20BBD187AC10BA214C1B5
          E803A8689A717282756C86909C4DC2E4FC5FFEF9D865B5BC05E010D1C65A5DD9
          38920F9800F0A2B91E295DA99D4100580050C8AF61A6B4171A7E3EDD45B571A1
          06984B45183BC7A1007B7F13F566450D58CE15C05D4E07AF6F2F183E3D465402
          8B00B97913AEEBC24374EC06E23821C062368F91E310C0EEB510C709018CCC02
          1C01608CA17F6D238E130264D25938DF5FD4E0F67E00D98937DCFBC227084265
          B35DF301B369031FEF9FB4FA30BC83EC84717F199CE3F795F289045A57751F30
          E75DC11DD1724F5C4176F2D762CCA167524BA22D84B3F2F9C9B6A66B07723BD9
          896AB8A078806EBF83C0C6A413394440EE77D1A77412AE04C84EFCDEC116A9D4
          3406375D35407642D9F19FFFF3940D544E42C6FA015EADCDDB125F0E15000000
          0049454E44AE426082}
        Name = 'PngImage24'
        Background = clMenu
      end>
    Left = 320
    Top = 40
    Bitmap = {}
  end
  object ThrobberPopUp: TPopupMenu
    Images = PngImageList1
    Left = 352
    Top = 40
    object Information1: TMenuItem
      Caption = 'Information'
      ImageIndex = 18
      OnClick = Information1Click
    end
    object Settings: TMenuItem
      Tag = -1
      Caption = 'Settings'
      ImageIndex = 10
      OnClick = SettingsClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      ImageIndex = 17
      OnClick = Delete1Click
    end
    object Clone1: TMenuItem
      Caption = 'Clone'
      ImageIndex = 24
      OnClick = Clone1Click
    end
    object Move1: TMenuItem
      Caption = 'Move'
      ImageIndex = 23
      object Left2: TMenuItem
        Caption = 'Left'
        ImageIndex = 21
        OnClick = Left2Click
      end
      object Right1: TMenuItem
        Caption = 'Right'
        ImageIndex = 20
        OnClick = Right1Click
      end
    end
    object CreateNewBar1: TMenuItem
      Caption = 'Create New Bar'
      Enabled = False
      ImageIndex = 22
      object AllModulestotheLeft1: TMenuItem
        Caption = 'All Modules to the Left'
        Enabled = False
        ImageIndex = 21
      end
      object OutofallRightModules1: TMenuItem
        Caption = 'All Modules to the Right'
        Enabled = False
        ImageIndex = 20
      end
    end
  end
  object SharpEBar1: TSharpEBar
    SkinManager = SkinManager
    AutoPosition = True
    HorizPos = hpMiddle
    VertPos = vpTop
    PrimaryMonitor = True
    MonitorIndex = 0
    AutoStart = True
    ShowThrobber = True
    DisableHideBar = False
    onThrobberMouseDown = SharpEBar1ThrobberMouseDown
    onThrobberMouseUp = SharpEBar1ThrobberMouseUp
    onThrobberMouseMove = SharpEBar1ThrobberMouseMove
    onResetSize = SharpEBar1ResetSize
    Left = 384
    Top = 8
  end
  object SkinManager: TSharpESkinManager
    SkinSource = ssSystem
    SchemeSource = ssSystem
    onSkinChanged = SkinManagerSkinChanged
    Left = 352
    Top = 8
  end
  object ApplicationEvents1: TApplicationEvents
    OnActivate = ApplicationEvents1Activate
    Left = 320
    Top = 8
  end
  object BlendInTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = BlendInTimerTimer
    Left = 384
    Top = 144
  end
  object BlendOutTimer: TTimer
    Tag = 255
    Enabled = False
    Interval = 10
    OnTimer = BlendOutTimerTimer
    Left = 344
    Top = 144
  end
  object DelayTimer1: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = DelayTimer1Timer
    Left = 304
    Top = 144
  end
  object DelayTimer2: TTimer
    Enabled = False
    Interval = 7500
    OnTimer = DelayTimer2Timer
    Left = 264
    Top = 144
  end
  object DelayTimer3: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = DelayTimer3Timer
    Left = 224
    Top = 144
  end
end
