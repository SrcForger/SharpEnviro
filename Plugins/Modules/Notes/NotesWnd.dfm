object NotesForm: TNotesForm
  Left = 0
  Top = 0
  Width = 485
  Height = 301
  BorderIcons = [biSystemMenu]
  Caption = 'Notes'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000000000000000000000000000000000000000000000
    0000858A88A3858A88FF858A88FF858A88FF858A88FF858A88FF858A88FF858A
    88FF858A88FF858A88FF858A88FF858A88FF858A88A300000000000000000000
    0000858A88FFEEEEEEFFB2B2B2FFB2B2B2FFB2B2B2FFB2B2B2FFB2B2B2FFB2B2
    B2FFB2B2B2FFB1B1B1FFB2B2B2FFB2B2B2FF858A88FF00000000000000000000
    0000858A88FFFFFFFFFFECECECFFEBEBEBFFEAEAEAFFEAEAEAFFE9E9E9FFEBEB
    EBFFEAEAEAFFEBEBEBFFECECECFFB2B2B2FF858A88FF00000000000000000000
    0000858A88FFFFFFFFFFDBDBDBFFCBCBCBFFC4C4C4FF000000FF02598FFF6363
    63FF8C8C8CFFCACACAFFDADADAFFB2B2B2FF858A88FF00000002000000000000
    0000858A88FFFFFFFFFFECECECFFECECECFFE9E9E9FF02598FFF26424CFF3657
    6BFF02598FFF9D9D9DFFD6D6D6FFAEAEAEFF858A88FF00000000000000000000
    0000858A88FFFFFFFFFFDBDBDBFFCCCCCCFFCBCBCBFF757575FF395B70FF8AAB
    C2FF5585A3FF02598FFF8F8F8FFF868686FF858A88FF00000001000000000000
    0000858A88FFFFFFFFFFECECECFFECECECFFECECECFFEBEBEBFF02598FFFC4E5
    EDFF649FC8FF5787A4FF02598FFF717171FF858A88FF00000000000000010000
    0000858A88FFFFFFFFFFDBDBDBFFCCCCCCFFCCCCCCFFCCCCCCFFB7B7B7FF0259
    8FFFC5E6EDFF68A6CEFF5784A0FF02598FFF858A88FF00000000000000010000
    0000858A88FFFFFFFFFFECECECFFECECECFFECECECFFECECECFFECECECFFD3D3
    D3FF02598FFFC6EAEEFF69AACFFF5683A0FF02598FFF02598F33000000000000
    0000858A88FFFFFFFFFFDBDBDBFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
    CCFFB7B7B7FF02598FFFC7EBEFFF6AACD2FF5787A4FF02598FFF02598F330000
    0000858A88FFFFFFFFFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
    ECFFECECECFFD3D3D3FF02598FFFC7EBEFFF6AACD2FF5583A1FC02598FFF0000
    0000858A88FFEBEBEBFF00A0C4FFBCBCBCFF00A0C4FFB8B8B8FF00A0C4FFB8B8
    B8FF00A0C4FFB8B8B8FF00A0C4FF02598FFFC6EAEEFF71ADCFFF02598FFF0000
    0000858A88FF00A0C4FF3DB1EBFF00A0C4FF3DB1EBFF00A0C4FF3DB1EBFF00A0
    C4FF3DB1EBFF00A0C4FF3DB1EBFF00A0C4FF02598FFF02598FFF02598F5C0000
    0000858A886600A0C4FFC6E8F9FF00A0C4FFC6E8F9FF00A0C4FFC6E8F9FF00A0
    C4FFC6E8F9FF00A0C4FFC6E8F9FF00A0C4FF0000000000000000000000000000
    00000000000000A0C44400A0C4FF00A0C44400A0C4FF00A0C44400A0C4FF00A0
    C44400A0C4FF00A0C44400A0C4FF00A0C4440000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000C007
    0000800300008003000080030000800300008003000080030000800300008003
    000080010000800200008000000080010000C0070000EAAF0000FFFF0000}
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 477
    Height = 22
    AutoSize = True
    ButtonWidth = 27
    Caption = 'ToolBar1'
    EdgeBorders = []
    EdgeInner = esNone
    EdgeOuter = esNone
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Images = PngImageList1
    List = True
    ParentFont = False
    TabOrder = 0
    Transparent = False
    Wrapable = False
    object tb_new: TToolButton
      Left = 0
      Top = 0
      Hint = 'Create New Tab'
      AutoSize = True
      Caption = 'New'
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
      OnClick = tb_newClick
    end
    object ToolButton8: TToolButton
      Left = 27
      Top = 0
      Width = 8
      Caption = 'ToolButton8'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object tb_import: TToolButton
      Left = 35
      Top = 0
      Hint = 'Import File'
      AutoSize = True
      Caption = 'Import'
      ImageIndex = 10
      ParentShowHint = False
      ShowHint = True
      OnClick = tb_importClick
    end
    object tb_export: TToolButton
      Left = 62
      Top = 0
      Hint = 'Export Notes'
      AutoSize = True
      Caption = 'Export'
      ImageIndex = 11
      ParentShowHint = False
      ShowHint = True
      OnClick = tb_exportClick
    end
    object ToolButton7: TToolButton
      Left = 89
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object tb_copy: TToolButton
      Left = 97
      Top = 0
      Hint = 'Copy Selected Text'
      AutoSize = True
      Caption = 'Copy'
      ImageIndex = 4
      ParentShowHint = False
      ShowHint = True
      OnClick = tb_copyClick
    end
    object tb_paste: TToolButton
      Left = 124
      Top = 0
      Hint = 'Paste Selected Text'
      AutoSize = True
      Caption = 'Paste'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = tb_pasteClick
    end
    object ToolButton1: TToolButton
      Left = 151
      Top = 0
      Hint = 'Cut Selected Text'
      AutoSize = True
      Caption = 'ToolButton1'
      ImageIndex = 5
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton1Click
    end
    object tb_selectall: TToolButton
      Left = 178
      Top = 0
      Hint = 'Select All'
      AutoSize = True
      Caption = 'Select All'
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = tb_selectallClick
    end
    object ToolButton6: TToolButton
      Left = 205
      Top = 0
      Width = 8
      Caption = 'ToolButton6'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object tb_close: TToolButton
      Left = 213
      Top = 0
      Hint = 'Close'
      AutoSize = True
      Caption = 'Close'
      ImageIndex = 7
      ParentShowHint = False
      ShowHint = True
      OnClick = tb_closeClick
    end
  end
  object tabs: TJvTabBar
    Left = 0
    Top = 22
    Width = 477
    SelectBeforeClose = True
    Tabs = <>
    Painter = JvModernTabBarPainter1
    OnTabClosing = tabsTabClosing
    OnTabSelecting = tabsTabSelecting
    OnTabSelected = tabsTabSelected
  end
  object Notes: TMemo
    Left = 0
    Top = 45
    Width = 477
    Height = 227
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Lines.Strings = (
      'Notes')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000001B349
          44415478DA6364A0103092A2F8FF670E7B06460E13209399E1FFAFCB8CBCDFB6
          136DC0FFCFECE60C8CFC590C8C02CE0C0C6C8C0CFFDF9C64F8FFA9830403F8D2
          1998446A1958F3781918B899187ECFF8CCF0FF5E2FDC808EAED67E6666E65C10
          FBDFBF7F70EFFDFFFF1F2C6FAC7B86D1DCF829233B4F110323A300C3EFAF7DFF
          B838CE14304235CF525050480D0D8EC0ED84BFDB1918FFCC071ACB09E4B032BC
          7C71814154E89E1ECC80FFA5C5150C8F1EDD63F8F6ED1BCC05184048F03BD059
          1F19C4853633ACD9F89B818DED0B0B8A01376E5CC1A91919686AA833F44E9800
          F4DD7F56B8015919D90C8F1F3F04FA0F335C61E100034A4A6A0C93A6F4FF038A
          B3C30DC848CB6278F1E2295131222121CD306BCE0CA063FF71320235BB00C576
          A726A731BC79F38A2803C4C5A54006FC051A600932600927276770544434C7E7
          CF1FB17A011DF0F109322C5FB9F4FB972F5F96800CF8E7E4E8C2A8ACA4CCF0E9
          D37BA25C0032E0E9B3A70CDBB66F610019F03735399DE9C387B7386DC7262E28
          28C23063D634B0017F8001C8FCEBD72F06604AC450F8F7EF5F9C2E99B7600E03
          63776FC75360608813E57634C0C4C4F40E00CD76B228C562FC5F000000004945
          4E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1300000B1301009A9C180000000774494D450000
          00000000000973942E000001F84944415478DA8D934F68134114C6BFD95DED25
          74378BC55068A19A14BC783028AE34A5FF8855C18B60058327456D3D88575BD0
          1E0B1E554A2F4A5328F4D88B68DB4BAAF5D09320289136D2A66E9226EBAC5821
          B03BCEAC649BD814F6C1EE0CDFF0FDE6CD9B7904FF452A9522B22CBD751C77A8
          5EE7DA12D792E9749AD5EB44FC1E0C91DB7C32C557C20C1268E4060CE33424C9
          5B86EB32ACAD7D826ACE73832BA40A63ECE1F365CC92D10128B244AC6B7D2743
          DBD576AC5BDDA8D02ABABA3A41480DE02297DB82D67A1471ED1B22F216165737
          A8CB982E00DA1145324706622D0B3F127832F90C9665219BCD361C2D168B41D7
          758C3F7E8491F60CE6DE7D75B81C6A00BCCA2530FD720694FE44B350550DF746
          EFE066C72AE697BE3402AEF7475B5E7FEFF50199F71F1ACC3D170C685A3838A0
          3E1873BD3AE8FAB1E600451CE1900C78B5C1B8D9387F0E6D6DC783038451EC2A
          3E9101A514D16877308065557CA31885D9FE65237EE66C3040B95CF277CFEFE4
          B1BB5BF232BA98BC7C084016D7B80F28164DCF6CDB943FA01C92C94B7E410301
          4C33EFA55D2816B0F77B0FC3C3577CF3ADCE0C1C469A0316761298783A8530BF
          EF5A8882AAAA8AFB63773D732DEA5FA22211625DED39112ABB11ACDBA7F0C751
          0EBC4243FBECCF3596C79B8F9B94895E10C2D8E0BF6EE4AD164680E0F5F4BAF1
          C50A66FF02F7B94B38EC0ABCFB0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000016E4944415478DA
          63FCFFFF3F434F5FD794BF7FFF64339000585858A6161796E530820CE8EC6EFB
          575A5CC1080460499018217AD294FEFF2545E54C3003FE030D60587DF02603CC
          10741A19F89ACB334C9E3A8101680023DC80B2924AB001376EDC4051ACADADCD
          70F5EA5514BE8F991CA6012017AC3D7C9BE1FAF5EB2806E8E8E860B8C0DB5496
          340390BD61ABCECFC0CBCB8B690090C3B0FEE85D866BD7AEA118A0ABABCB70F9
          F265305B4F4F0F6C000F0F0F7603361CBB070F3818460F483B0D01062E2E2EDC
          06E0D20CA3ED350519383838300D00260A868DC7EFA384383A3034346470D012
          626065656598326D22A6019B4E3CC0704180951258DCCF428161F3C9870C8EDA
          C20CCCCCCC98061415948215201B00C320CD5FBF7E45F10E860185F9250C5B4E
          3DC2F082818101D880EFDFBF8335C292334E0370B9006400131313D800104637
          E05F415E3123B6800385F88F1F3FE0340C00630191997AFBBBA6FCF9435A7606
          C6C45460B8E5000093BD0CF08C3EFD7D0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002984944415478DA
          95D35F4853711407F0EFBDDBD4BB2DF6478B34746866338358E5A2C44C8AC802
          85A2C0227CA89E7A88A087FE82115190201208459641428115E5430809999850
          68BA5CA97369EA485D4EE7B6EBDDEEBFCE7C10FC83E081DFCB3DE77C7E7F2F73
          F5080AB41A3C535570B282F3F73EA8CD584330378EC29767D3A7E9B40CBABD11
          9E9032423EAE0598DA63375A4D062DC60331B886788FC906BB350B9594AF3977
          459D5A15B856824BEB38CD5DA7DD68D06918B4B983A10DBBD44136010ECA6F23
          E0D7AA009D01AB61F190B650B1D3AE374C5B79A4E738D4D0AC3FECF78F1E23A0
          6D5540A5D38BC7FD0BCCEDF5D9B8E5C82F6632329D687F502FCC744E4CA19C09
          C8B2DA40654F09F3AF08D45531A7599679B2AFA0944B4949C560CD378CBE19C0
          F6DA9348CE3363E44F8FF0F3C7175556845784DD24C8B714A8605954A56FCC35
          A041E5E44004FBEB0F21D1CA520507682C102503DCBD2DA2ABE7930C556C9465
          D451FFE7852D1092A87B846E6346F296D29797352CFB971A53017982860F8A34
          0B41C98410B3626CCCA50E795D91E9806F6E0198472A998A6CC78EDAC2A2337A
          886E9A9D56A0040998041F09204C23C20B4832EE85C266A0A5F9F1E462A08A49
          E3388BF754F9F524467807551521C60408D130E6F820787E06F17A63CA090C0F
          7BA5FEBECED78B80783CAF667B0B8BCFE6990DE388F12E486214D1280F4591E6
          F37A4B096DC388B6D6C6882C4BF66500ADE2A0C99CD65458749C0BFB5F409143
          F3DF59AD1506CB614C0745F56BC7DB902489A5741BADCB8078D45733ED395B9D
          F9599B7375C26C0712F476B03A1B7E7BDAA5FEFE2EBFA2E000350F2C7A484B56
          914CD7FA7DB7B36C93C96C647D236ED1E3E993145968A29FED2235FF5BF61257
          406C0C832E1AF182F734EB1D6A1C5A5AF71F27384C69BE17878F000000004945
          4E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000017C49
          44415478DA63ECEDEFF2FFFDFBB7010311808D9DE54A517EF95A6431C6CEEEB6
          DAB2924A26620C00AA65A828AB6EC46AC0C78F1F18FEFFFF8FA1899191114CF3
          F30B1036E0C68D1B0C972E5F087CF7FE9D3E312E6265655D83620008CC9A33A3
          AEB4B882682F61B8E0E0E1FD75C806E202302F6184C1ECB933C12E00F1AF5FBF
          8E55B3A6A626A6011F3EBC076B387CF420792E78FFFE1DD80573E7CFC6EB0290
          ED18068034BC7BF70E1806D7198E1E3F4CD0055C5CDC0C3F7FFE64983A7D12C4
          8082BC62A64F9F3E815DB060D15CBC2E5057D760E0E4E4603873F62CC3D16387
          20066465E4308112CCBF7FFF1966CC9A0A37001DCC99370B85FFE7CF1F06C6FE
          09DD01BF7EFF464E384003CAC12E4277F6BC05B3199212528116FD6578FDE635
          C3D2658B1918B1248EDF85F9C52CDFBE7D43D10C0230035EBE7CC1B074F96290
          D059AC066467E6B130333381C3848D8D8D0194456EDEBCC97004E8676F2F1FB0
          CD40D000CA171806F4F4752EFEFBF76F0CB68C050507401896A900D6FF041AE8
          4CF84E0000000049454E44AE426082}
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000002E149
          44415478DA63644002DDBD1D1E406A090707C7CBDCEC026D34B9E92C2C2CE185
          F92542C8E28CC89CBE09DDDF32D373D8A74C9BB88B8B8BEB5876665E334C6EC2
          C4DE674E4ECE127BF7ED390834C411AB01405BFEB9BB7B30CACAC8FF5BBC64C1
          FABC9CC2109078574FBBBD8282C20119191986E3C78FFF282E2CE3C46A406F7F
          D7673535351E1727B7FF53A64DBA0974C532902B802EFB656767C7FAE8E1A37F
          77EFDDBD5E5A5CA183D500A04D968C8C8CC702FC03194444C4FE2F5A3C7FFFEF
          DFBFEF686969A5898B4930ECDBBFF71F505903D08066AC06405DF150435D43CE
          C9D1950118169F45844578C4C4C419995998FE5DBE7C792B50B31FCE40848683
          31903A1D1612CE28222AF66FE9B2454C7CBC7C0C8F9F3CFE0114B7011A7016AF
          0150572CD4D5D18DD1D5D5673A7CE420C393274FFEFFF9F3676659496526BA5A
          AC06005D11F3EFCF9FC536B6F60CEFDEBC6178595BFBED7D5C8C1DBAED580D58
          2721D1FBF7DFBFB4DF1F3EF0FC75B1FFCFBC632FA3A28438C3B3BFFF3E020378
          66D08B17E5580D58272959FBFBDDBB064D4949863FFFFE31BEFCF8E1FFDB6F5F
          96B3FC678C50141367E66063FBF7EBFF7F867BAF5F33B0F2F327043D7FBE186E
          C07A29A9989F6FDE2CD29094FC7BE3C993BD1242820ECFDEBC658FFAFF9F7101
          17039FAEB0CCFBCF3FBEFF79F1EEC33E552929E75B2F5FB2708888D4073E7BD6
          0C3660B588C8332D7E7EF1CB0F1ED446FCFDDB764E56F6EBEDB76FD9C3BF7D63
          01C9AF6066FEAB2421FED5ECE933BEE54C4CE55A72726DB7BE7C7919FAE68D14
          C4005EDE9F2A02028C868F1FB36DE5E69E202726967BFDF5EB1B615FBE8033D4
          2A4ECED33A5252468F5EBD9AE1F1F973F64579F9DFB73E7DFA1FFAFE3D1BC400
          61E1FB062222725F7FFC007AFF1FCBAD57AF5EB20B0BFB029D7816EA456360F8
          6CD392921201A6CC3FFF191858EE7EFBF626F4ED5B717818FCFEF2A59B918989
          97818D8D19986D6D609A6100ACE6F3E774867FFFB481067C61E3E70F04A90100
          237645204A039A960000000049454E44AE426082}
        Name = 'PngImage5'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000002C94944415478DA
          6D93ED4B145114C6EF9D999DDD715D59A89022F025A27C89D8483F24D67EED63
          916D2ABD5844E0070992A00822ACAD24A82F2A444948BA1951FF8144982561B1
          84A682EB2BE85286AECDCECEEBEDB9DBBA0DD1C061EFCE9CF33BCFB9F7B99431
          46DC4F3FA5214AC8598190C30E2115FC1DD61358BF43665F33635FDCF9741380
          42098537454569DF1D0E7BFDC120F58A22319349B29E4890F5951527A9AA0652
          1FA0E21640561EC08BD1E543712854551989283F4747C9523CAEAE2D2F8BCCB6
          89228A46916515160982B0609ABF34C71987A243803859C000A51D3B6A6BAF54
          37362A733D3D646A7ADA04BC05318C1011356870C34BE9AE325956E60C43D518
          BBDBC4D81DFA9C9090C7EF1F0947A3BE85AE2E22CCCF938461A40DC6DE40EAE9
          E6DC8C502960C44E1FA5ADA5804CE97A1A2A6A693F218FAA1B1ADA6449A263B1
          98892E66B92C17E420AF517DC60D8192F8768FA712DFD877CBBA4F63847CAE69
          6D0DCD0E0DA9C9C9C94BE87254A6F4980BF20AD5E75C90885F101E6F93A4A245
          C318E10AB423EDEDBEF7DDDD19339DDE8B9C0540FA00398E790B66FF405EA2FA
          3C8700500E15E37BBC5EDFA4AE6F6401752D2DBE8FB158C6CA64AA9094401205
          E41920275C9041402EA0410900DFF2008C3056595F7F60716262636D75F52200
          8339A91CD20BC84917E405204318A167AB2806964C333BC2C39DA5A56D82A691
          C564923B6E3F3F5F17E4292091B2BF7B22617FE4946D5B3F6CBB337B8CD8DB91
          8A40C0379B4A6919C6BAD1E5EA3F90271E4A4FF18D85894801CE02F233C83B98
          37125E5E2EF1780A2155D3199B41F56DD47F4270501DA217DFE520EC3DADEB2A
          1A4561A4A8DBCAC3304975892CFB538EE3ACD936B7ACCC55288260164B52001E
          21DC85681007B53E6F6597D3AE21AE6F91242F364A54B8783C69C8561DC75AC5
          DCF8DB818A7B9B23D2FF5CE72AFC34E1028491B12F779DBFDA84BCC5720085E3
          EEFCDF1DE68FFEAAFF46670000000049454E44AE426082}
        Name = 'PngImage6'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000020749
          44415478DA9D934D6B13511486DFA186F463E45E68034EDC8A5F0B5745060437
          AE5BBA73E5C23F21FD07164B1B48218A5592DA3636BA89584B6923165108E22E
          A2620521264463639DD1C9243319C6736FCD3421AD8B1EB8CCCCE1BECF39733E
          14905D18BDE8E388A6B401D7AF5D45B1F815AEE3A2542EC1733DFCB12C98A649
          3E07F5BA8D72A5029B7C6D23DD3E209DBA8F8DEC1358BE4F97EB68369BF21886
          01D775D168D878F9EA35766BB5830137DEBE91CECAF4345D6E0447881DCA2014
          3A8674E6116AD5EAE1802B5353783E3989EF3333B06D3BC842405AAD160132BD
          80252028A0000813901FB1183CCFC3E933A7A04535DC49DCC5D3B53554A90E3D
          80B6509895CF6348D725A43A3B2BA35FBAAC2379EFC1FF01C6EA2A947018942B
          7C12B1F17109896EE5B0B8B00CCE199657320703F48909E9F895CDCA27A7EF3C
          BDFF8CC7512814A0691ACCDF26D28701DA8E737D7D606363526C2612B27042E8
          341D9A07437681B3E3D22F4CE523DD5DD0FF45B6E7E7650145FB3A018BE98718
          1EE64106FD43BC770EDC645246F069A004C0A2C913BFF0EEC37BA4520B38193D
          11003C25D40DA8CFCD21A4AA085331058431868FDB9FA8788F719E7F83B35BEC
          DA83CF4AC720C56EDD44B954462412C1E0E000D6377378B6BE2185ACB52754FB
          BB176973A703703B1E4383A62FF7626B4FA87EC159BE135C66034ACF2626B747
          F701475DE7BF6FD14290744ACE160000000049454E44AE426082}
        Name = 'PngImage7'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E0000021149
          44415478DA6364200254B431FC07D17CEC0C2E55C50C7B91E5188931A0AE8FE9
          BFB3BD14C3DE83CF187E7EFDEFD459FB7F3F4E03CAABD8B839057E4D63656230
          FBFC8B410326EEE92605A6B7EF7AC6F0FF2F23DC101403CA9B183DD9D8FEAFE0
          E36078A4A6CAC1A4A42CA8C5C6C6CAF0FFFF5F863F7FDE31DC7EF89F41484808
          C510B801E50D4CD1EC9CFF66EB6B30B36BEB88307DF8FC09C32B6FDFFE67F803
          0C0D01012186BD875E30FCFCF6CF066C40790B8335072BC34A0D3556691D4D16
          0646A0E897EFA89ABF7CFCCFF0F92703C35FA001ACCC0C0CD212620C6B363D82
          78A1B38FE114370793B0ABA7AAD2BFBF2F183E7EF985622B0CFCF8C7C0F01F88
          15A4219A1980DE001BD0DCCDF0C5D4DC825B49EE0750F37386771F3E30F0F330
          A1B840904F8AE1F2EDA770CD2861008AE7402F270616B6470CC74E3FFFFFEECD
          57C6EF3F51BD10E22707A69135C3630164406A4C20C39E235B185E3DFBFD4988
          93A949499869AF67C49F0B307990019B763DC19E0EC00AFCADFE6DDD718C8983
          89C1B3BC906107B6940804261D550C6731522248416CA8FDB71DBB0E731667FF
          43F53C01003660F20CE6B76A1A326C37EE3EE362FCFE27262FE7FF72920C983A
          8569EE2FC67FB1F6F65A8C678EDEB829C7CFE4EA11F1E739D10680C0F6152C06
          D7DFFC5F2B2DC4F2E0D78FDF1F45B8989A80922F091984921740865C79F1A7F3
          D71F0695DFFF18AE0A71312E27E41D00420AE781D889E76F0000000049454E44
          AE426082}
        Name = 'PngImage8'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E000001F349
          44415478DA95924D6B13511486DF3BC924696CD20F9B268A8A591441291444BB
          293542B43B972E8295EE04FF41170A7EA0BF4211DCF91334A0053735208234D4
          D61A2BC9644A6A46C7CC8CF375C7338319B409243D70B81FDCF7E1DC735E8603
          F1FA09A6C4085AFE7E61050C03E2BF077756C589A533767BFECA39ACBFDA381C
          2014176782F37A793B582D765476B92043886DAC7D6ADD7AF8C8D27A00FF8A6D
          77145141A15B079EABC3323D70DE512AEFC62451002B577F2E3D786CD7430089
          9324D6E68BB3B01D7A21444864202AC6E0D81654F53B01DB184930ECC9694FAE
          432A57D56B04791F00DE3E83D7150B24F6FE92397703806174C2723DB7891FED
          34A47AB4F266532910446777A9FCAB41F9B370B908C7B5F06D7733144D4E1E0B
          F786EE576263673B631A9AF5B1B8D2BAD0D3835AAD867C3E0FC7FCDAD371B925
          C2B45CD8BF53D8DF8B6B97971BA303A710C60843EEE4B81789701617756C5533
          66E18694E8EF0382F880AE0FA84F739A89D347E2583D7B7EECE2BE0A34BF2471
          69B9C9FA1AC56F6C3F27AE3DC5F1785A68644E4C7B8D2D932DDE54D840A71D8C
          CA8B344FE5388D33AB164A3B138702F85F498E4F57FC89EB9DD47D02DC1B1A40
          627F9ECFB333A70ACDDD5FCE62494984561E4298A5BCEDC5720B8C09802995A8
          3F1F8605CCD13245799DF233E5CBAED88F3F5CC3E91113A27E5E000000004945
          4E44AE426082}
        Name = 'PngImage9'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000DD700
          000DD70142289B780000000774494D45000000000000000973942E000001B249
          44415478DA630C0D0FAE97909068604003BF7EFD82D03F7F65CC9FB77026030E
          C0989B9FFD3F313E19ABE48F1FDF19E6CE9FC3F0E9D3A7A8D52BD72EC76A4056
          4EC6FFB09070866BD7AF810558589919787979180881F71FDEB564A5E7D532A6
          67A6FE4F4A4861B87BF72EC444E67F0C1161D1040D58B16A294364780C236362
          72FCFFF8D804B80B0485F8C1067CFBF615A7662E2E6E8401B1F1D1FF73B2F230
          5C0032E03AD45064A0A9A985694072620AF92E888C0EFF5F905744D0053C3CBC
          0CB2B2B2980600D3C1FFECCC1C8685BB6E335C7ECD4530F090013FDB4F06B001
          2545650CD9736E334C2A7667F8F1EB2F519A39D89819F27A7732C05D50B2F429
          4355923DC3BD575F096AFEFBF71F83AC081743DFE223A82EA80419F0F20B0323
          2323C3FFFFFF819881E11F90F8FBEF3FC39FBFFF197E0335FEFAF30FCCD692E1
          6398B1EA38C20533B6DD6170767562B8FAF82303C37F46867F0C40DD100436E8
          3F08FE871A0C14D391E56358B0FE24C48090903086072C7A0C8FDE7C43D50472
          01582B2398031333571562D8B97D07C3A7378F1730DA25741EF8C62A6D4F52F0
          0301F7EF47270F2EA8B2602455233A0000D249ED056AC96CFB0000000049454E
          44AE426082}
        Name = 'PngImage10'
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
        Name = 'PngImage11'
        Background = clWindow
      end>
    Left = 312
    Top = 120
    Bitmap = {}
  end
  object JvModernTabBarPainter1: TJvModernTabBarPainter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    DisabledFont.Charset = DEFAULT_CHARSET
    DisabledFont.Color = clGrayText
    DisabledFont.Height = -11
    DisabledFont.Name = 'Tahoma'
    DisabledFont.Style = []
    SelectedFont.Charset = DEFAULT_CHARSET
    SelectedFont.Color = clWindowText
    SelectedFont.Height = -11
    SelectedFont.Name = 'Tahoma'
    SelectedFont.Style = []
    Left = 312
    Top = 88
  end
  object ImportDialog: TOpenDialog
    Filter = 'Text File (*.txt)|*.txt|All Files (*.*)|*.*'
    Options = [ofEnableSizing, ofForceShowHidden]
    Left = 344
    Top = 88
  end
  object ExportDialog: TSaveDialog
    Filter = 'Text File (*.txt)|*.txt|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoReadOnlyReturn, ofEnableSizing, ofForceShowHidden]
    Left = 344
    Top = 120
  end
end
