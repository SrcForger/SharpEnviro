object frmItemsList: TfrmItemsList
  Left = 566
  Top = 275
  BorderStyle = bsNone
  Caption = 'frmItemsList'
  ClientHeight = 260
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object lbWeatherList: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 345
    Height = 260
    Columns = <
      item
        Width = 50
        MaxWidth = 0
        MinWidth = 0
        TextColor = clBlack
        SelectedTextColor = clBlack
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        Autosize = False
        Images = imlWeatherGlyphs
      end
      item
        Width = 200
        MaxWidth = 0
        MinWidth = 0
        TextColor = clBlack
        SelectedTextColor = clBlack
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        Autosize = False
        Images = imlWeatherGlyphs
      end>
    ItemHeight = 24
    OnClickItem = lbWeatherListClickItem
    Borderstyle = bsNone
    Align = alClient
  end
  object imlWeatherGlyphs: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          031B4944415478DA7D525B4B5461145D67EEE7CC348ECE8C3A8D172A15CBCC1E
          A297522AA987EA39A2876E9615516045050576219A2C2B7A883030EA37446957
          8A20BA0D15A9A4668E24A2A3A37339736E33E7B4BF5344F4D0071F9CCB5E6BAF
          B5F6E6F0CF89745CA8B6D96C7BE8AED134AD8E7D73381CFDB95CEE05BD779D3C
          7E6AE8EF7AEE2FA0C56AB51EE579E15C536393B3B2720127F03C74C380AAA8F8
          3EFA0DCF9E3F95F3F9FC5922EA2022FD0F0103DBEDF6975555D52BD6376F7052
          11145586246761B739A0693978BD5E08829B489EA87D7D5FA2AAAAAE62242641
          C7958BC71A962D3FB77A75139F4ACD425624B3ABD3E50229422A39078BC58AC2
          223FBCF30AF0E0E17D6570F06BFBB123272E71CCB3CBE58AEEDBBBDF33393509
          45519011D35064857947B0B81886AE23472A78B70081083D6E2F6E75DD944431
          D3C008CE6FDAB8F9642814B2CD2567118FC7A1E775D3BB5B1010080631313161
          5A292B0B9BA679A78091EFDF8CDE473D11AEF35AC7CBD6BD071A138969CCCECE
          4094B2D0733A3C1E0F7C8585A06940551548590905BE0252E544269D4120508C
          EE3BB75F73973B23C9C387DABCC3435F914AA7A0EBACBB8EE1A161CC2412E4DD
          82929212949797C1E5E4E1F6F026B8C817C0F51B9D198E024CEEDAB1DBDBFBB8
          C7945A485D1951E3AA26844261CA44462C16C3C74F51020631453985C36134AF
          DB80BBF7BAD3DC95AB979E959757AC5DB2B80EA5A5A51818E847900A8B287185
          A4B330354D45FF401F6A6A6A893464D6B0AC6263A3AF5888118EE34EB4EC6A35
          C7C7007EBF9F7640862C4B9025C97C4E93AAA575F5F42C617A3A0E0A10866144
          18417B7D7DC399952B56124086DD61071112F01701C7E6EFF3214BE166450AD8
          C8633A3E838F9FA39024E9340B31B673FBEE0AB6506C5958E2B4F7662746189E
          1F469E82CD8A2252A92492745903DA447C88BE1F3109B66ED956417228C02224
          1233D072DA6FF932E5123227236645D30603B2C3D6FDEDBB3723CCC2C1450BAB
          AED6D6D63AEC76E7AFEE241730CC109D3477B6CE2C0B9926C21AB11B1B8B29E3
          E33FDA18818BAA5BAC166B3BFD0AB26EFF3B6C2FC8429C14B4D36BF74FFAD1B1
          CAD909FC7F0000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          02D24944415478DA7D934B6813511486CF9D994C9389CDC28DDD585AAD0B5B27
          4D5DB8283E7067D5282955C48DD63E82520996A2821B172AD552110515057525
          22142B824DABB62B8D7511BBC8A38F442A484B8BC4BC333399C978EE6D8356A8
          671866EECC9CFFFCE73B7708FC13FDB7AE832008EC2C168BEC99288AA0EB3A5B
          5FBE7865CDF7E4EF449EE7C1300C0197C7F0FE2A5E37E0FA1A5E9F1D6C395418
          9FF840DFAF1122E5648BC5027575DB201A8DF438E5C6C126D74E51510A109C0A
          16E3F1D8036FF7599F24D9617CE23D84C321D0348D8994059C58F15EA964BA08
          217A77A77723B59CCBE5209D49C1887F440530359EE3828AA1F7C8DB1B42B3B3
          33D0D77B09C8AAF5C9564FDB2EC92641381206A72C63CF06643269C8E6B2B0BC
          BC0CAEC62688C56330F92510F09DEF6D7EF8E83E16C83201A7D56A9D3A73BA93
          701C0F043D298AC212A94D47A58335AAA91A2493BF60F4DD886914B5FA032DEE
          E9D1313F9081C1FED747DD9E23555555C84104A3B45239994CC2E2E202CCCC4E
          3337B5353550E970B0E773B1B9E1AE0EAFE7C9D3C7406E0EDCC879BBCE493449
          47C2024E4251150A132C1522B8E426A030BF4E05215FC843F5E66AF83C19285C
          F0F54977EE0E3207437B77EFF348763B5958F801F3F3DFD17E065B21D0D1DEC5
          46B602330DFED1B7E5A9FFC471EE477621CAA0166F6EA375374F78BEB5B50D28
          CC48340AF28E06669F26E7F339585A5A5A8539475D0430AF994D8156434597DD
          6E0FB69FEA603069A8EA7A3013E01FF39B9853CF0464B9112291D01B84797813
          C2147153E19E607B209D4EB3AD2CF00263405BA2D348241214F02BCA8056E7D0
          451661DA284CC3D081172CCC01B5AEAA2A586D36C8A058A95462EE4CD3844F81
          8F052670E2F84978F1F2F9D01E84896D90742A091CC781586165158B7AF1CF4F
          8341FF87542A65A28361D6C2D62D7510FF166330B1821BD579F84FA05B030BF8
          51C8C70468F008CEC4A36C71BDA0CE56A1B3F56F87BF9B254C4D30F900000000
          49454E44AE426082}
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          03214944415478DA95935D48536118C7FFEFD970A99966D4CA645317E577A610
          22732A48A94D6F6CE5BC30414769D445980605512054D0451146F845068A8878
          655E98262229E4A6B9392C37BF35E7962D75CEE976D67B4E2824DDF4C081F77D
          CEFFF93DCFF3E71C827DF1E45935B45A9D542010D4B06E772A180684907E9665
          6F262525CEDEABBCFF979EEC2B64E8314428141A1411B280C077CD0CCB102CAA
          2E7B7473331B14124BDF2F5110BB0BE201AAABF932DAF1191564330CB1A7CA15
          E263AFDF30D18A346C3B1CD08F8EE05B6E0E3B69322D7BBDDE603A5127D556B5
          B5B69B794041A1AA33EB6256B6442221BA111D64F675041B27709C16337E7E98
          B42CC3101B85A3C9C9904AA5A01AEFE7CFC3EF5B5BDA948476F7A70C7B7959B9
          D0410B9C8E4D90878F90909B0BC1CA0A3CBF7E615B2CC6486F2FA48D75B0DBED
          58FABE88EEEE0F6E5A17C401CAA223A35E29D2D218C7E6263CBD1F21B65811BC
          B080B0FA7AB85757315F5181396AE6EAF924B8626360A1134D99A7D8D59F3F6F
          9382C22BE69292D2088610881801BE6BAE2351A904B3B686B0BA3ADE28737E3E
          B6FDFDA1EDE9C1E2AD1B8040008FC783B131FD1C0F50AB0B23E0F5C2A7BB07C1
          EB1B08301A11D1DC8C73740D6A1AB42D2D98292EC6D2E12018830EC19992BC0B
          98E556B82E95485E444AA5A2C0973548CCCC04E37422ACA10172B99C170E0E0E
          C2AC52C1E5766374F01366CB34985DB66CD115EE70800374CA6BB1BAD1E73972
          85BFEFF0304E7574402493212F2F0F3B3B3BE8EAEA82D3608089DEADA127D16F
          5D7118CFC6DDA5750D84FB80C495F743822223CD71292907042C8BB0C6467E77
          8D460397CB85A6A626FE3EA556C369B140AFD76F6DD96CE18F2F3D59E60127AA
          1E34259496AA495F9FF034EDC675FF576C4D4CE06B7A3AD6C2C377A687869A1F
          E73E2D26B4D79923F1F15FA2626244429168AF3B179C075C0C0C0CECE5A68B8A
          B0313E0EE3FCBCCB69B52690B740577C41C105A156CBC8DADBE11B17B727E656
          E0A2B6B6762FB73936866F1919580F0961A70D861E0E604B522A8F1C0C0DFDA3
          A04E7BA971FCB37BDE9FA3BE6CD86C309A4C3F3840350B54D0521FFC5F6CD35F
          B7FA37CED57C8840F859210000000049454E44AE426082}
        Name = 'PngImage5'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          03164944415478DA85935F48145114C6BF9971D751335D48DD644DA7403403B1
          B5A428CAA00C4A0842AD884A22B584200209247A8ACC07838220AA87A28CB288
          5ECA307C0A7A285DB335A2DD4D6D5B73DD3FAEEBFC595B67A633231BE4435D18
          3877E63BBFF3DD73EE3058B6BABA2F636868B88865D99BBAAEEFA0570CCB326F
          55553BE3746E1CBFD0D1F9979E5996C85258C8719C7BFBB6EDD9C5C5C5AC9250
          E0F37935976B44D234AD92BE4F12484B814C4043D3C1124AEA26413DC330D1AD
          5BB6D89DCE6A56922488A2084912E1F178B4AF1E4F905CE590A69FB41D7D8F9F
          F94C40D3E186BE3DBB771F140481718D8CA0BCAC1C568B05B2A2602E3E075994
          108E46602FB043104A30EC1AD6DFBFFFF0F2F1A3BEFD0C55B71263BEB5A5CD9A
          20BB8A2C6375612152D5C919727373112140419E1DB1B9594CFD0C6060E08D4A
          793906E0446969E9DDDA9DB5AC4215ADE956B00CFB0720086BB1B090402C1683
          AAAA906409C1E034C627C6B548387A963974A4F173F3F1E6F2344B1A789E3705
          0925B104A0B33B1C45584824109F8F233A1BA56F8AD93C03363AFAC96F00C69A
          1A9BD6D3D84C71602A004591CDC619106A1A5664AD30C122ED53635B02B803C6
          118E398A1CB72ACAD7F37C460692C924599F87AEE990A927BAA681BABE944530
          9D628D9227FD014CC7D42BA9261E07C75F67F55F3C8D07FF5A8653CE92811956
          88D814B783312ED0534F7151BE2DD373E7C2DEF4891909BE69116B5665A2CCB1
          D28C2743326A37E4E35B5034F7BDAF46C55074FE7464EAC70313F0DC27DC3CDB
          58DD525D66E70C813F2CE1408D033129692664F11CECB91966ECF286F062702C
          4C4E57CF4E071699EA530F6C3959D6A9FB17F7F1FE88628AF2B2D3B1719D0D5E
          8A0D473B2BF231115A72D63730A60482B39DE79F9FBBA684426036B73CBC74B2
          BEB27397738D2565B77E135DA4C4A299C0710C4AF2B2CCD83D11C593D71F454D
          D3ED3DEFBAA471B71B4C4D6BEFCCD5F6DA3C9D9A3349D5E405157555767C0FCB
          F8F2238E2AC10625A9E2AB3F86678363722CAEF4DCFB78E3A2180EE3B3D74B80
          B6DE7EFA55EBF09F45A314E94EB4B7DF3E7AFFCF44E8F90D0B34B96D1B1B6076
          0000000049454E44AE426082}
        Name = 'PngImage6'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          036E4944415478DA75936D4C535718C79F73EE85BED022F5835409C51549A8B2
          358A4637A998F801547C991B0AB828891845F1257E302466335934827C52CC66
          F6F2C12DCEA051E20B24B32AA889BA21889525A61622885056D6D6DBDBDEDB96
          7BEE9EDB0D134D3C9F4ECEFD3FBFFFF3FCCFB904DE5B4D278F436F6FDF471C47
          BF634C5DAE9D1142EE31C6F616172F1A6E3C7CE41D3D79AF90E2760ECFF303AE
          1297D966B3514992C0E7F329FD4FFB458414E1F73104B169500A50B9E58B7C8E
          E35A50B09A52127295ACC8763A9D341A8D82288A108D8AE0F57AD90B9FCFAFAA
          AA053BEA406DE3A5B6CB832940554D65477959F96A74247D4FFA60C1FC22E0D3
          D220168B414410208A904070127266E7405E9E0D50A3F6F43CEE6CBB70A982A0
          7B0632C27BEAF7F09AA32CCB60B55A61DA1D3B038BC50281C90058B3AD100E87
          616CFC35B8DDB7A6B02E4B03D4CF2F749C59515A4AA3E8A8D7E9B4D0DE02ECF6
          7C88C7E3100A05813105443C9F98F0C3D0E0100B8642FB4955CDE6C1BA1D7576
          4228180C8654912C4BFF0170F6DCDC5C90A5380891371044888CA16A4B5114F0
          789E8DA400D5D53576505514DB607474142439960A4E836068A0D39B202C88C0
          A6626FAFED7FC0B036C2AE3C9BED54A1C3A133188D9094E3101123C050244931
          48261874FEC5434E1683C5790C541C8F61F1C8F0888C231CD2007AD46EA71C3D
          AA303A3BA91048A7C9944B82F130947000E86782220BB040FF0428A55A177E79
          8A3679A5820EA23D202DB4EFBBC84C7C7DDDF8FAAE3E6B6BF8BAA8F274A9D96C
          B856B57649C6E03F53DCDDAE3F030F7EDE362B114F806BD7F919A8BD83DAAE14
          E06C37B5E375FD6ECECC981B11A2E303171B6C1F6F39E3FD666F4581DE6402BF
          3F08ADBFB83D375AD639CB0EB6E760B1DB9C699A1711C43764EE9A136B2D9986
          8B5515CB74CF2724EE5E77CFDFB75BBFCC5EB5EFF2586DA5CB5A5B5E440EB65C
          8DF70E8C6CC7DE0366A3AEFDAB8D9F1AB12BFE96FB8140E6AD3FE9FBF6C0FAFC
          7483115E8F4D42EBAFB7FBCF1D5EBA70EBB187CB381E6EA05B1666F6DBB9C6A5
          DB6A9BFF787AB461CD27E9461308E10834FFD03944ECEB9A5FD56CF86C4E5D85
          93EE6FBA12F778C7AB77AF64EDD33F59634F01D7B4E485A2ED7FBC9F36F079D9
          6247FDA6627AE47467E291E7E54E6D846274B98EC95A54203FED7425F7C10716
          665588DA9BA89D85C99FAF2B49EEF8171BE5A6E8B64FC22C0000000049454E44
          AE426082}
        Name = 'PngImage7'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          03314944415478DA6D936B48145114C7FF7776665D6DCDB6556BB30C7B6920F4
          F2F1217A43991A046145598165499215D203AA8F811515151414BD7389ECF145
          7B424144650FB32895DCB5D61E14BBEBEAEE3A8FDD9DD9CE8C1914DDE17267E6
          9EF33BFF73EEB90CFF8CBA83FBF525CB64329D8CC7E333F50FC6D8635555ABE9
          D5B37BE79EBFECD93F8E1CCDB1022FB4CE9E3527D9312A83298A0C8FC7A3BE6E
          791926482EED7FA7A90D82D86FE70914F180A669451CC7F5CD993D77E4A489D9
          4C9265C8B2045992D0D5E5D6DA3ADA7E928D8D6C9A08B68B206E0370E8705D63
          D1C2C5C5231D0ED6DEDE867159E3C10B3C144581248AD041BD811ED853D3E070
          384036F1E617CF6FEFA8DD5DCA28BA9518810D159B785991A0C80AEC763B06A3
          EB2293AD560443410C4BB14194FAE1F37971F7DE9D186D0ED301D5B9B9534E14
          E61730999C04B3A0178D640F00D2D34780E4221C0E1BAB1C91E0F7FAD0FAAE55
          1545712B23F99E756B2B32F55C38CE844844412C162305943B0153EDA988C6A2
          206384824144A28AA12A1A89E055CBAB6E03B072F9AA4C3A32D86CC3D1D3E337
          1C068A27234E4F626212FA7A7BE17277221008909D0D1919A3F1A6B5A5DB4881
          8A763C2767326736270C4497448A1287426A683186DBED425A5A3A0AF20BF1E2
          65333E7DEED242A1508D0EB0308EF5255992CCBA6C3A26FC6F083C0F4A950A9C
          0ABFDF877317CF4634554DD101B024586E6667E72CCDCF2B60CF9A9FAA2E57E7
          D5E90BD694E78C1E0AF78F303C5E113F5E3738C9663929309102B5E363FB8D13
          F7D5150620668A8FB1F289C7A26A7411CFF34D1149DD9690C8D7502DB69805E1
          E8D4F9E57B9F375E182558B8A36A4C2B31F15C5354D6B69F7E82EF2CAFF20A52
          869871695F09BEF82523625A7202DE3EBAD85FB4B03889CEBB7F4D458DF5B3B7
          DFD86B78F001DF7E06507B6B3B24AF17AC60633DD62F9982F93332D174FD4C03
          F580B76C75D5E66B574ED50D2A285E56B95777EE7872F53CB58872F95D7AD591
          6775F8F4FE3D58E126270E54CF439CE3F0F6617D3D19F84ACB2AB776FB44747C
          0D625A960D5254C5C72FBD903A1B9D544F7991B3A122ECF3A1CDE5224095933A
          ECFF95FFEBDA1259EF95EA33E57FFEE957F7173FBAAAD6FC41BD780000000049
          454E44AE426082}
        Name = 'PngImage8'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          021A4944415478DAA5534B6B1361143D7732118B560B8D627D148D284A1691E2
          0304E34ABB10D2D7CE07B8B02242BBD1AD2BF117880B1504F1B110A4353B71D5
          292E94B6286817C1986AB0B635D8444CD33AF3CDF58C26D2EAA0A203C3FDE6BB
          E73B73CF3DF713FCE723BF4B7A83A98B4434D91D4EDF1F09BC81D43E860F7697
          F3BAF62DB0F09ECB65F011E3BE5FDB5FCFB089DF4F7E2608123944E4A1AEDEE9
          582B379C56D5ED98FF08540AE35A295E125B8FC0A087B844FD474B247899D46D
          C492476573B748F30E20D200985968790CFEB37B908529852263A7873A437BE0
          0EF59FB5B6F55C9175FB01FF3319F350EF2DCF18885781797C8B24F367A2DDC3
          57C37A6049EBA1579238B505D186DA2609DC1C630EAA6CC10CD7D9EC083CECA5
          04FD41E03D485D6638868D879BAC649F0407838C1AEA37055631C1C87EBADC7B
          3AAE4CCDB0ACEB76A7734116D9D58B58DB5A6BCF3951772C38CD97320CB1E61D
          4153DF09462749A0251EBB13D8BB5882A0B16544769D68D3E5556A9E60D955F6
          629624D34418E8F427487EEE058C26EBB62E6DE2C0815EAC6ABD66EDEE80FA59
          B2BE21419928C216AAF09F9721AE7F32DA357C33D4052F737090C393D6E80A41
          3C0E69B4BED98852119A9F837030A8FDAE9D768E87B91067788908EEABD14712
          B1CE139EA06A88855175E586D86867F9EDC46DA584C9B0512ED41381ADACA6C8
          E5178E724BDDB6DA8FD6FC32CAA19729B057510AECFAA7DBF837CF570D11FC11
          6BEF755D0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          03694944415478DA5D935D6C145514C7FF776676BBB4D506D9554A6BF7232A61
          2BB4BA68250B856E624C50A206DA821AA031604B9F88D1681A135F44F0C1077D
          00E141225025B5609436A64D244A0D44DBD26EBAA6DB2E81D08FDDD25DB6DDCE
          EC6CE7D33393D0887772732733FFF3BBFF73CEBD0CFF1BC7BFF80C4343C3953C
          CF9F320CA3DEFAC618FB9DDEDB42A1E7A73FFAB0E3213DFB6FA03528D84BC1D1
          70385CEAF7F93959CE233E39A14747A3A2699AD50499B1740F4036A0B179B797
          E3B86324788D31E4B66DAD5F575B5BCB499204511261AD13F1B83E9948CC92A6
          8C1CFD4C8E3ABA2E76DFB501CDFB1ABB2391C89B3EAF9F0D0F0F62534D0D1C82
          13D6EE393187BC94C7FCFC3C3C6E377CBE00866F0E19232323972F7EDFB587D1
          EE45C4908EB41DE1A5BC444132CAD796E3C1EE8C9E47CBCA90C9A4B1AEBC028B
          B9052493B3E8EBEBD729AED8021C0AF803A71A2211AE5090E172B9C073020144
          1BE0F706A0A8CB58C866ED844551C42C01E2F109636969A995ED7DAB69BCE560
          CB7A4170906D0185E5659A051B505CB883673C3A144545566688A657234F6959
          4353358CC5627146F9CF1FD87FC0ADAA2AAA9EACC2D4CC340A9486919FC3EB55
          31084FEF048B9E456F72036299D295B65111313A1A4DB3A6BD7B3E0D06831D81
          4040282929A682C9109716F186A71F6BB6B7C114E710BFD683DED4738069F5CD
          84496B32995253A9D431AB068F510B3FE779EEA0E07038798ED79A9EBD8FFA97
          3C3CEFAB63C2D800728A6E4AD994F9ED4D8F99B8EFE0956545A1769E25171F33
          EB00B98A5CB871E3AF275453ABFC60EBE2C6508572DA703FA571ABBC4E6EED16
          DEB8F7A79E19BF7AAEFD17CF0972516228FAECB6EDE1E4D77D3A6C80C69B2815
          5641D5551CF5F75693D1D5B6599E3F898A8620A67FBDCA0CE1E5AFEEEE3274CD
          002F70500B064E0F9068F3A1F3282B71E2BB4F5EC55446C6AD9408CF234588DC
          69AE318BD7FC0D75718AA95A68B0FAD282F5AFAB3F8699B92CDEBF7C14321D2E
          F6E2E10B7877570D22A12AF4FC78C6BA38687CBB15EE814837987307A7217CBB
          EECAB8153C3EF003FD07CE451FC797D78FE3F6D81858DD7B9D38D1DE0093E330
          FADB055BD05EF9D37A93E97F500E2D83C14BBDB2AA63626A01F2E415BB85AF74
          76414CA7F14F224180D64EE8BAF1D015BDBEF39BCD60C60B5B7ADA4EAE5C5B22
          53E5D17EE69D151D47F35F59FCA75BA838F5A70000000049454E44AE426082}
        Name = 'PngImage9'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          03134944415478DA5D536B6BD360147ED2A64DD24BDACEB5E20544BB79419C8A
          FB22EA10A7C274F813FCE42613744C650E44BC216E759B77BC8BF817BC8D5915
          A7E017D926A8A0DD4DF6614ED7B54DDBA449DAC493E8C6DC0BE1246FCE79DEE7
          39E77919CC5BEDB10B952CCB1EA067BBAEEB6BAD3DB7DBFDB5582CBEA5EFBB6D
          AD271373F39939850EA7D3794C103CE76AB6D570CB962D673C8200C334A1A91A
          46C786F1FACDAB42A9543A4B403102326601AC6297CBD557515159BDAB763747
          4950B50294820C17EB86AE17111045081E2F81C4B52F5F3EF76B9AB6C502B101
          629D178FAFAFDA707EEBD61A5E925228A88A7D2AC7F32046C8A4D3703A5984CA
          CA20FA0378F6FCA99A487C3B7DFCE8890EC6D2CCF3FCE0C1C626CFE4E44FA8AA
          8A5C3E0BB5A05ADA118E446018264ABA0EC1EB8187007D5E11B7EEDC2CC872BE
          CA02385F57B7B76DC9E2C56C3A93C6EFDFBFA8C0A007F07A049487C3989898B0
          A52C5DBAC4162D701E0C8F0C9BBD2F7BDA99AECBB1BEC6034DDBA6535348A592
          C82B324C3AD14B7A83A110681AD034158AAC400C04C0711CB25216E1F2081E3E
          BAFF81B9D4D59E3972B8451C4A7C839495ECD32DEDD45438E8B4403048EF6E8C
          8F8F0326B1F2112B2A2E0B2EC0956BDD39861A9869693E268EFE184132998469
          1A28150DB83917229185D444010E8703994C06ACD34912183B46228B70EDFAE5
          2CD3D9DDF1A6B1A1697BA954A4A414B2F91C244AB6BA1E8D466D8F98E4859945
          86B201BD821FF71EDC7E6F37714F5D7DEBCACA95EEE9F414E9D528CD019D747B
          7D3E7B8CBAAED9C53C2F4096651AA588A1A144F145CFF3BF63F4F97C03071B0E
          797379C936104F5DE6389ED83224A7085557ED6245C9D39E037E9F881B37AFE6
          69E41B679CD8B27AD59A33F5F5FB44299B81414E0C51932CAA167D5B1EED3BE9
          DB4F468AC77BE5C14F03A7C889DDB356A6155FB7AE6AD3CEDADDA25560D9D930
          0D7B2AD658796264F5E5D98B27D944E27B3FFDDF316BE519100ACDE4BEB3B53B
          76B12B564405CB890E92A1140A181B1B51FADEBD3572B9DC29CABBFADF659A7F
          9D29EC27469B2956FFDBFE484C3E507C3CFF3AFF01DF2C77DC015C6F30000000
          0049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          03274944415478DA7D535B485451145DE7CE38CE98D4E828CC38E523CBA48CFA
          4949C80FA354A6200A22FC287A60D813442AE8A3A02233EDF111115414F411FD
          044A0F4B0B8220C3220347C426C7995ED038A9C3BD73EFDC3BF7B4CF9D82EAA3
          0387B3CF66ED75F65E7B1F867F5647E719D8ED766BEBBA6EF91C0E070CC3B0EE
          C78E1CFF0BCFFE0CB4D96C70B97250B7A60E25256598F36CE32942B893F50F0E
          4E844378F67C00E974FA2F22F63BB87D715F0D99DF530D8F3E0A90AB7F038384
          AF2201982850D6F698AE9C3960BD6B7DE42BE91A6F7825482C82CEAEB3682B7F
          5444660836F4F1794B5F48B9FE16CE7905D4382047835C8E9D61761E401A5B08
          B7FCD244E0437BDB5130F1BAD3E9C4DE9656643D69BC838295CDAC7433639E25
          80CD05A467C067DE203D7C1792FA8D83A387370D6CBA7AED0A1445CE10343505
          E02F2A823B78FA302BDF7289796B0133011813E0469462D2608602F3E56D40D3
          F7A9EB7AAF863E86F0E4E963B0EE8B9D68D9D34A35072456DC1862CB769622CB
          9951D60883EB213A43E0DC2085C2C0D8D8100C54CBF53DFCE6ADEB447CBF6E15
          89B593E0CD98DF30575A7180CD4C8DA0FF45109FBE4C919B6381D7447DCD27CC
          CD36C1074738632C4EEE5BB46F08828ACFAAFBD0D074F9EEB052E02C2D2DA6C0
          6FA85D5D079FCF0F4D53118984313C3C88F9853226BFB850961BD7ABF3C6EF79
          1DB39759D78573941EEF6D5CDF14F0FA7C6C743488C28242E4E77BA0A53468AA
          467D4F21383A828A8A4A22F581307CF0F5AB0734371B8588B994E78F3DBBF6DA
          552D6905783C1E245515AA9A849A4C5A7622318BAA65CBC94E22168BE171DF43
          12056E41D05A55B5E24ACDAA6AA61230CB9105AA910233044CB221CFED869254
          A0C8D409EAC8D4F718DEBD7F975614E5203BDFDD31B963FBAE62315112815394
          B6987BF19220F417F9619A266459C6CCECB4958918603D95C2D0DBA18845B06D
          6B7331E980BCBC7CC4E353D00DFD57FA2ABC5E5F86808626319B404AD7AC0E0B
          1FE9101125EC5F58B6E8426565257DBAECCCEB94AE689F10319B7CE283092D54
          EA08294E6570442723A9E8E7689B201053B3DB26D94ED09C160AE6FF2D499284
          4631FA7027E97AE327D0039E1EF2ACA0E70000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000032149
          44415478DAA593494C53511486FFD7D779A02D0261105AC0010165505B277024
          B1C401351216262E4C08312E8C31A038C5854374818961E142DDA86163AC1AE6
          A0629568834A44299432B43688166C2DA5E37BAF3E9E95188D2B6FF2E7DEDC73
          F2DD7BEEFD0F81FF1CC49F1BDAF24B6922227A19246908D38C9A6053847CC24D
          509439C010D5E3ADF5CE7F02320D176A081EEF7AF6622D3F2D3D050A858C4B08
          068398704E6278688C42247C69A8E5F4D9BF005AC3C5434AA5ECC68692623257
          9B888CD42424C9A248514BE0F187F1F4AD1D7D3617DEBD1D8094C75CEDB97BB4
          761ED070C7A46B6C7AF9AC6257A9E4D8BE02CC0642104A154855F241B2190E97
          0F8FBA2DE8EA1D83223E1E3DA6DE28685A3BDA76DAC101CA8FDC6CA2F8D2CAD2
          955944C5FA6C2C4850832D058802229241EF8013A68F5FE1F17C075F2040BF75
          028E21DB93A1D6335B39C0B28A2B767DC9EA8CE43801F69415233D5E82E900C0
          6719DF3C33B876AB1D5E7F083C3E8959B69CAC451ABC7A6EF60D3EAC5510B197
          0F55EC2D13E6A7ABB0A96821A6FC8050C0473842A3C3F41E2FCC166E1D8A5010
          8844282CCAC563632733D67C92E40099E517BDFBF76F579CAACC83CBEDC7E084
          0F84480E8AA63162FF828EEE770804230884C288500C4A4A57E3D1834E66BC25
          06607FA06747F97ADD89AA62522D17E1FE9301986DDF909FA3654FA5D9EB0761
          B17EC2A0D5CEBDFB8A821C98BA7AA6465AEA137F95703E2F4773BC6AA75EEA74
          4C60D8318D940405C4EA040458C06C200C920E8308F92196CBF1E6E3A7A8CD62
          BB676B3B73E017208D47C0B2718B5E3EE30B10F65127942A0536AFCB657F8B06
          4347B15CA38441AF45DBEB31DC6E7AEA2245629DB1E1E0F8BC9132CACE1D9629
          558DFAB5859872B9410A85E091245B338D249504BBD76642B7340993935391BE
          FEC1E6A6DB0D75EDEDEDD6DFADAC4A5E537D5CACD6D42D5E9AC559392E4ECE05
          66BE7B4179BE304B1205DE2519F2E1996967474D4D4D2345519FFF6CA6646972
          FEBAD4BC6DD5A464812E44F394739B4C78D6CBF89C1F566988376A19CF6A341A
          9BDD6EB7830D45FFEAC698BDE3582963B3885568EE22AC3CACBCE03CFA73FC00
          3E874620306956960000000049454E44AE426082}
        Name = 'PngImage10'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000019449
          44415478DAA593CB4AC3401486FF7980260DC49D894B0BBA68FB1A16BA70A150
          445C6A5AC4FB465A5A14B78A062928DE0B8A1B4B2B2A49FB002AED421FC0BA89
          909ABE419C1C4B516C84EA59CC993933FF37E7CC85E5F3F94BCBB246D19B8D65
          32990BAFC3B2D9AC9B4EA77B52E772397000FB06300C8326A391288F02B55A8D
          C691F698B5C59224FD06605C1001EB0018A2D130796FB5CB5B490AFA004C8396
          359B361E1EEF61BD59B463683084582C0E455108120CFA010C13EFEF368AA52B
          ACAF6D40555402345E1B486756B138BF4C105F80699AB8BDBB81A62531A00EF0
          32185CD725C84BE30567672798994E7180D81D50E180FDC33D9C1E1748FC15E0
          F9C9A9096C6FEE40F4CBC0711CCCCEA570747042E27ABD4E07EA893B802D1DA2
          E89381D372B0BBAB239198A0123CF320E170F8B384C229B4E9A43FA052ADC2B6
          6D94AF8BC865D77E1CE2D2C20AC50451F00778913E5946B15CC4F3F313018686
          8611E7D7D8AFAA342F083E8056AB4502F6F5D975BAACE30342A03BE0CF7F41D7
          F512AF7DA417802CCBE79AA68DB793FC9F7D00E11CED111534DCB70000000049
          454E44AE426082}
        Name = 'PngImage11'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000032249
          44415478DA65937B4853511CC7BFE7AE6D6EBB77E623B5276224E44A9B666884
          F6A0D482B0C08CB0C23F8AD60B820A2A7A425460415952184614D16A16084594
          51A1BD1F86E956AD286BCDBB3563736E77B9DD7B3B1B39CC0E7CFEB8E7FE7EDF
          F3FDFDCEEF108C583B2AF7D4CA0C3611100324594D144C44668873500A5F3BD9
          7C64E7C878322C3157062ECD2A31E64E2B980A1DAB03A17F65BAE9EF1F40E71B
          2B3A3A6C7C8DE9CEB1DCBCDE0430720F343D66322CB9ADC654A5171412883682
          C4C113F1537499C7D0E7F4C2E37A0843EE45714C5A56BF8279E9A52E77C504B6
          57EE7E59635A31D319F2C1589006EFA783FFD81C3BA3019148044CF80CD46A1E
          2A763F1462DD2F22DD384FA2351796189BC6E5642269A21606430E6C0F57FE23
          303EFF2CC2E13094E40A94B80711C590C50741566BAF8A0ADCAEDDB6AAE2E32F
          07E6CE2B049183484C9A8007CDAB9191128E0B441D88913E24281F83FFDA83D6
          5B6EEF862D775208B5DFB765EFFAE44FDE6F301A73A0542A314AC140A3E5B067
          733654FA22AC5977007A3D176BA846A385CBEA42C39126D9A314D8A880B875DF
          7AC6A7F443CB26203539150A8582DE00814EC7E178DD51A4678C4759D9A2981B
          4E9F0877378F53871AE15187F2E20E5CD45E8E211BBF7F87C0300CFC7E3FCACB
          17C36AB5C26EFF008EE362FB1CA787DBEA46FDE146EA20C4C57B60737FC5C2B2
          391084602CD064DA048BC502B79B872449104511C9C929108202F82E1E4D0DE6
          409DF9101BBF85A4CC344C2B9A0275820AF7EFB7A2AAAA1ABDBD3F68DD724C80
          6539A8546A386C0EBC7DD489B6E71D4FEBCD87670FCDC12B3A070576D777CC5F
          524C035508040210420254B4A9D1EF68F37C1E1F7E7EF0E052A365D0F2CC3CB9
          C76177C4046A4A6B67A78FCEB8BB7A63B5CE13F44193A2465EBE21663B5A0E43
          18F05F5CF03BFDB87CF6BADCE97C77FAEEF3967334D536F416D852C3FC8AE999
          C6BA9205C59346BE85C040005DAF6D78D2F62AFCE47DFB8517B6F6169AF39EF2
          990C1BB8D194ACA585CBD78E4B9DB84CABD28EA5278F92214BC170D0CFFB78EB
          CDF6ABE7694C2FA59BF29D2213FCBFD8BF6243500F1028FD943E8A8F220D05FF
          0180DC535B623C6B230000000049454E44AE426082}
        Name = 'PngImage12'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000029C49
          44415478DA9D53DF4B5361187EBE9DB39DE6D46DA99B3A7463044D2FC2D424AD
          4054B222826E23B32EF2A68B6EBA8A828A7E5C4742D08D04FA075437A5D00FC2
          51D80C05B50405E7D2B9CEF478A6733BE7DBF9FA9AB9696141CFD5C7F7BDEFF3
          3EEFF3BE1FC1363C3C09538BAFF89585190DC646AA9865A84004814214633495
          BE7D68004FF01BC8D6E1DD45E9B2C3223EB27B9C92C3E7825464054F06D33348
          2736109F8DEACA5C748118C699FA7E8CEF2078D325743945D3D3EA23B5A4C051
          0CB6AC033ACB971109489100554D18F3C3E31B84A1658B8470D996D6AA02B5AA
          699F54201581A97433A7FD16C4FD2740279F81BE7DB059CD6A829252D391E0C4
          97C67ED465EF3EF6585F967B4A3BDDB55EB0989E2F9A2378C109EEE57BB60B08
          4F4E27D6C2F255AEA28F8CF55857BCCD350E49B300745336A369884D3D5C7639
          D85A0C99505FBE1D01508C84BA189C1CE604A7C8E76E81064E1F1610A3B91846
          7508013E92B200324B136053CF01B3153089D9F7948D6AB34321B561006564F4
          3C58EDD9636051ED577606861206F11E85505907F6FD2B3263035C3B37D2E602
          297443734A9999C11170052219BD40F440679D486229B075192C19E72406FE86
          A4AF6675FEFD94C6095C64F492B8E03F5851619617F9E8F26D881D776069BB09
          6DF0C60E13F95261D5ED97A31FA647B21E04CFE19ACB5772DFE316CC4634F64F
          02ADD29F5E8A28E1E4B7E507D929FCBCFCD445E6BC8DDE2A5B324E989AD85DBB
          B30471B33D228766233CB939B789DCC8037C80414FA3DF6C27EB1643E63E50BA
          43B6EEAAD6151D4BF1D0ACC4FDECC86DE2564C6F1B5AEB5DE8DDEB2BF5D9DC76
          C166152DA209645D434AA7467A392CCBC98595B53D22BAFFF80BDBF1B81D77FD
          761CB74B087082426A20A1A4313DA360E8CA6B5CDFF537FE2F7E00321B1D20D2
          3147AC0000000049454E44AE426082}
        Name = 'PngImage13'
        Background = clWindow
      end>
    Left = 300
    Top = 220
    Bitmap = {}
  end
end
