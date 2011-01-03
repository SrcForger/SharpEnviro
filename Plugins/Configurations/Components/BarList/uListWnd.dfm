object frmListWnd: TfrmListWnd
  Left = 0
  Top = 0
  Caption = 'frmListWnd'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbBarList: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 418
    Height = 284
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Columns = <
      item
        Width = 20
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = StatusImages
      end
      item
        Width = 40
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
      end
      item
        Width = 50
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
      end
      item
        Width = 35
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
      end
      item
        Width = 35
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    OnResize = lbBarListResize
    ItemHeight = 40
    OnClickItem = lbBarListClickItem
    OnDblClickItem = lbBarListDblClickItem
    OnGetCellCursor = lbBarListGetCellCursor
    OnGetCellText = lbBarListGetCellText
    OnGetCellImageIndex = lbBarListGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alClient
    ExplicitLeft = -5
    ExplicitTop = -20
  end
  object tmrUpdate: TTimer
    Interval = 1
    OnTimer = tmrUpdateTimer
    Left = 272
    Top = 120
  end
  object StatusImages: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002F34944415478DAA5934B4C135114864F3B7DD0877D615B
          DB8AF2EA8316100DA582B0438C2031AC84A889D115A824E292B832EE9405624D
          74C30603C148084124E8C6980A012A441EB58647414A8542DAD2D2D24E3BDE3B
          85A6C6A5939CDCC99DFB7FF73F67CE61501405E9CFC597A0468B06851C85F870
          DB8F621BC5C65833B8D3CF338E004828448BC17C22602955068C1A41A444C026
          0DF8BBFF80E970EF7167A6B7C40B76AF74029D732050300538149FBD53B8596D
          92871B15F2E33A019F07195C160D0F4762B0170CC1DA2FB773D1CBEB7DB394FB
          116D7FC39023402912D71729226D79D959422C0C47E310892600FBE3B29920E0
          12100C476166CE117478791D7DABDA21049862545B2935B2DDD054E06DD5E69C
          D261B137108504527E75FAE0BC5602188333554BB934C4366E77BE77E774CE07
          940318606E2E5EBF75C1206E51668A52622C68E99A809B357A28D38A219148D6
          EA646606FC58F5C0D8A4CB3AE8B5746340EDE3F29FED85FAEC0A0693896E88D3
          07F1AD779F8FD3EFD76B0C60C917D360099F0507D1180C8F7EB2F5EC5E798201
          4DCFAA16BA8CC602993F440219A7204E61CB14DC7F9104102C1E34D76B2157C1
          0316C100859803FDFDFDBBDDBE6BF768C0D3CAF92E93C928F30563108D27C538
          8556EB38100407C868045EB7554200B9C300099F80776FFB767B42376840ED23
          F3627BB121B7822008F0EF93C91410E0E1AB69243E488931582664C38E3F041F
          46466C83B1263A05F36DFD122AA2A4254B9509EB3B91948307561B1257D150EA
          B0B0D94A1E7C9976C067FB8AF50B554B17515D2CF536D469565A4BCE14E964A2
          0C58FE1DA65D887804F84249312EAA4E258065B70F8687879CB389F2CE352A7F
          20D5485755DFEB4F0B7C6D65A5E7840A8980BE3510266937C7782C3A5C1E241E
          190D7A22E28E29E272B291D25BF99264B25AC9F234EAF4469D4A2907A9884FFF
          15CFCE1EB8D636606E76CAB99D50F4DAD9757FB772FA30E5715C164D62D12820
          B74A38D4BE8124514B535C871F64339B2CD3C20653FFEF30FDCF38FF01581790
          B41CBF26F50000000049454E44AE426082}
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002584944415478DAA5933B4C62511086C747901002E12121
          346041A22484020A3A8DB59414343C96E26A01A1B2152BE4426547E5D251406C
          8C165060670C0909A0100A0A0A48200A5120A03C76E6F048765D9BDD494EEE3D
          F79CFFBB33FF9CB3369BCDE07F62ED4F40B55AB5E0B7231C07388CB43E9D4E8B
          F8CCE2F3C66432E5BE05A098C3B95FA150184422116C6D6DB1EFC3E1107ABD1E
          341A8D67845C9ACDE6D817C042CCEB743A090947A3117C7C7C00AD0B0402100A
          8530180CA0542ABD21E4D46AB5C6568045DA71141B48DCED769970095FBE2B95
          4A06797C7CA44C5C8787873906A8542A415C3CA30D240E8542B8791BBCDE1F4C
          78711166E293936390482450ABD5E0E9E9E9DC66B30519A05C2E67B55AEDFEFA
          FA3AFB0309B6B795E0F1781880E779063C3EE6607373939596C964EEED76FB01
          0320ED657777574E464D2613CCE08201DC6E372B81E7232C0302905826934132
          997C75381C0A0640635EF6F6F6E4EFEFEF301E8F211CE699C0E3712F3288AC4A
          2073C56231A452A957A7D33907140A85ECCECECEFEC6C6066B57243217B85C2E
          068846A3BF95D0E974209D4EDF7BBDDE7909F97C3EA852A9CE341A0DB45A2DB8
          BAFA49DE03FE8195108FC7811A42003211BB00C562F19CE3B8B9890F0F0F164C
          3D6E341A0D52A99475621994111D2A0A12379B4DB8BDBD7DC6A90B01B9D54142
          57393490B7582C12B95C0EFD7E9F0D5A27000D3C89707777F786469EFA7CBED8
          97A37C7D7DCD7D7E7EFAF57ABD41AD560365435D69B7DB50AFD729ED679C5F06
          0281D85FEF02452291B060DA4708629789BA42970947160DBCF1FBFDDF5FA67F
          895FB8188AF0D26B7F0D0000000049454E44AE426082}
        Name = 'PngImage5'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000001654944415478DA
          7D913148425114867F33322494F4291544060DF5281A7C439BB63B36B48450A1
          4BD9E6AA5693A3DB6B736C281A841A129E5BE08320ED150E2D8543A1855994FA
          EEEDBC870A06752E9C7BB9E7BBE7FEE71C0BC7FF66E90115898778902F71B012
          57586E591D002A511E738B76D8E8FC8526AA1ACBF8E53E40E1B4CF61C3375AE0
          18C1283E516EB0F88A6C02943CEB136D78A3A0811B5E20A4A8B1F0AA4AC07D52
          4808036146BB170FD052A1240177CA4C60885E00FB26E04184FC187D972FAC05
          09B8ADCDBB9AD0E9DD8129D8836D02AC18C7497DDD4D40B9B6E07A47872E0FBB
          19B668B7528ED3FA8601DC28B3012B95061C755518191C78C56561D3F8E23AE9
          4D4CE1D994D793C93189224AA98821F24AD2B38BA213D57E90631A4F38D7108E
          A866A3F2513DED77B8F0418BC34EAB8A8B462BBE23F75B7D166DC7E6C40938A9
          9A173CA2A4E9993D796058C75233D4A6617568584C19CEEDAABFA6F997FD00A4
          E2A501151109200000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002524944415478DAA5933F6CE95114C78F3F0F698414119A
          0806093F110383AD4DC757DD9EC1A283C1444C9D9EB4DDFA9048BA19BB1988A5
          61D04137114913EA4F0C86A6319096943614F5CEB9CAF0FABABC779393DFEF77
          EEEFFBB9DF73EEBDBCE57209FF33787F02DAEDB613736E8C3D0C1BCDBFBFBFD7
          F059C4E795DD6EAF7C09407100BF434AA592DBDADA02B158CCF293C904C6E331
          74BBDD06422E1C0E47F213E0431C35180C32124EA753787B7B039A1789442091
          48E0F5F515EEEEEE9E1172EC72B9921BC087ED4B1473241E0E874C883F83D56A
          65EF142A958A41CAE5323939DADFDFAF3040ABD53AC5C913FA612DA6383FFF05
          6EF701701C477D604ED56A35743A1DA8D7EB67878787A70CD06C368B7ABD7E97
          CFE7B31568AC01340E0EBE3308E5A452292BEDFAFAFAC6E3F1EC3100D21ECD66
          B3821AB5582CD86A948F46A30C20147E038FE70768B55A100804B0BDBD0DE974
          FAC9EBF52A791FB53E5A2C16C5683482F97CBE2921168BA14008B3D90C22919F
          CC1D01C845269379F2F97C2B40B55A2D1A8DC65D9A2417EB121289048AE71B31
          E56432190C060328140A377EBF7F55C2EDEDED2936E7646767077ABDDEC6413C
          1E4771045E5E5E36392A0377016AB5DA5920105835B1542A39D1FAA5CD66E3E4
          72391D18E6820E13395A8B753A1D3C3C3C402E976BE0F411022A9B83845D0D60
          03A34EA753A65028D8AAEB95094441E07C3EFF8CBB701C0C06939F8E72369B0D
          60C342269389D36834406E6857FAFD3EDCDFDF93ED067E5F84C3E1E45FEF028D
          542AE544DB6E04B1CB44BB429709A328140AAF42A1D0D797E95FC66FF23DA5F0
          15D7D0730000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002584944415478DAA5933B4C62511086C747901002E12121
          346041A22484020A3A8DB59414343C96E26A01A1B2152BE4426547E5D251406C
          8C165060670C0909A0100A0A0A48200A5120A03C76E6F048765D9BDD494EEE3D
          F79CFFBB33FF9CB3369BCDE07F62ED4F40B55AB5E0B7231C07388CB43E9D4E8B
          F8CCE2F3C66432E5BE05A098C3B95FA150184422116C6D6DB1EFC3E1107ABD1E
          341A8D67845C9ACDE6D817C042CCEB743A090947A3117C7C7C00AD0B0402100A
          8530180CA0542ABD21E4D46AB5C6568045DA71141B48DCED769970095FBE2B95
          4A06797C7CA44C5C8787873906A8542A415C3CA30D240E8542B8791BBCDE1F4C
          78711166E293936390482450ABD5E0E9E9E9DC66B30519A05C2E67B55AEDFEFA
          FA3AFB0309B6B795E0F1781880E779063C3EE6607373939596C964EEED76FB01
          0320ED657777574E464D2613CCE08201DC6E372B81E7232C0302905826934132
          997C75381C0A0640635EF6F6F6E4EFEFEF301E8F211CE699C0E3712F3288AC4A
          2073C56231A452A957A7D33907140A85ECCECECEFEC6C6066B57243217B85C2E
          068846A3BF95D0E974209D4EDF7BBDDE7909F97C3EA852A9CE341A0DB45A2DB8
          BAFA49DE03FE8195108FC7811A42003211BB00C562F19CE3B8B9890F0F0F164C
          3D6E341A0D52A99475621994111D2A0A12379B4DB8BDBD7DC6A90B01B9D54142
          57393490B7582C12B95C0EFD7E9F0D5A27000D3C89707777F786469EFA7CBED8
          97A37C7D7DCD7D7E7EFAF57ABD41AD560365435D69B7DB50AFD729ED679C5F06
          0281D85FEF02452291B060DA4708629789BA42970947160DBCF1FBFDDF5FA67F
          895FB8188AF0D26B7F0D0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000001654944415478DA
          7D913148425114867F33322494F4291544060DF5281A7C439BB63B36B48450A1
          4BD9E6AA5693A3DB6B736C281A841A129E5BE08320ED150E2D8543A1855994FA
          EEEDBC870A06752E9C7BB9E7BBE7FEE71C0BC7FF66E90115898778902F71B012
          57586E591D002A511E738B76D8E8FC8526AA1ACBF8E53E40E1B4CF61C3375AE0
          18C1283E516EB0F88A6C02943CEB136D78A3A0811B5E20A4A8B1F0AA4AC07D52
          4808036146BB170FD052A1240177CA4C60885E00FB26E04184FC187D972FAC05
          09B8ADCDBB9AD0E9DD8129D8836D02AC18C7497DDD4D40B9B6E07A47872E0FBB
          19B668B7528ED3FA8601DC28B3012B95061C755518191C78C56561D3F8E23AE9
          4D4CE1D994D793C93189224AA98821F24AD2B38BA213D57E90631A4F38D7108E
          A866A3F2513DED77B8F0418BC34EAB8A8B462BBE23F75B7D166DC7E6C40938A9
          9A173CA2A4E9993D796058C75233D4A6617568584C19CEEDAABFA6F997FD00A4
          E2A501151109200000000049454E44AE426082}
        Name = 'PngImage2'
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
        Name = 'PngImage6'
        Background = clWindow
      end>
    Left = 360
    Top = 196
    Bitmap = {}
  end
end
